import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../models/brain_region_model.dart';
import '../../data/brain_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../services/audio_service.dart';

enum BrainSlicePlane { axial, sagittal, coronal, threeD }

class BrainCanvas3D extends StatefulWidget {
  final BrainRegion selectedRegion;
  final ValueChanged<BrainRegion> onRegionSelected;
  final BrainSlicePlane activePlane;
  final double sliceDepth; // 0.0 to 1.0

  const BrainCanvas3D({
    super.key,
    required this.selectedRegion,
    required this.onRegionSelected,
    this.activePlane = BrainSlicePlane.threeD,
    this.sliceDepth = 0.5,
  });

  @override
  State<BrainCanvas3D> createState() => _BrainCanvas3DState();
}

class _BrainCanvas3DState extends State<BrainCanvas3D> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  double _rotationAngleY = 0.0;
  double _rotationAngleX = 0.0;
  double _zoomScale = 1.0;
  Offset? _hoverPos;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleTapUp(TapUpDetails details, Size size) {
    final localPos = details.localPosition;
    final normalizedX = localPos.dx / size.width;
    final normalizedY = localPos.dy / size.height;

    // Find nearest brain region by center distance
    BrainRegion? nearest;
    double minDistance = double.infinity;

    for (final region in BrainData.regions) {
      final dx = normalizedX - region.visualCenter.dx;
      final dy = normalizedY - region.visualCenter.dy;
      final dist = math.sqrt(dx * dx + dy * dy);

      if (dist < region.radius && dist < minDistance) {
        minDistance = dist;
        nearest = region;
      }
    }

    if (nearest != null) {
      SoundService().playSound(SoundEffect.uiClick);
      widget.onRegionSelected(nearest);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);

        return GestureDetector(
          onScaleUpdate: (details) {
            setState(() {
              _rotationAngleY += details.focalPointDelta.dx * 0.01;
              _rotationAngleX = (_rotationAngleX + details.focalPointDelta.dy * 0.01).clamp(-0.5, 0.5);
              _zoomScale = (_zoomScale * details.scale).clamp(0.8, 1.8);
            });
          },
          onTapUp: (details) => _handleTapUp(details, size),
          child: MouseRegion(
            onHover: (event) => setState(() => _hoverPos = event.localPosition),
            onExit: (_) => setState(() => _hoverPos = null),
            cursor: SystemMouseCursors.click,
            child: AnimatedBuilder(
              animation: _animController,
              builder: (context, _) {
                return CustomPaint(
                  size: size,
                  painter: _Brain3DPainter(
                    animTime: _animController.value * 2 * math.pi,
                    selectedRegion: widget.selectedRegion,
                    activePlane: widget.activePlane,
                    sliceDepth: widget.sliceDepth,
                    rotationY: _rotationAngleY,
                    rotationX: _rotationAngleX,
                    zoomScale: _zoomScale,
                    hoverPos: _hoverPos,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _Brain3DPainter extends CustomPainter {
  final double animTime;
  final BrainRegion selectedRegion;
  final BrainSlicePlane activePlane;
  final double sliceDepth;
  final double rotationY;
  final double rotationX;
  final double zoomScale;
  final Offset? hoverPos;

  _Brain3DPainter({
    required this.animTime,
    required this.selectedRegion,
    required this.activePlane,
    required this.sliceDepth,
    required this.rotationY,
    required this.rotationX,
    required this.zoomScale,
    this.hoverPos,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final baseRadius = math.min(size.width, size.height) * 0.38 * zoomScale;

    // Coordinate Grid & Hologram Rings
    _drawHolographicHUD(canvas, size, cx, cy, baseRadius);

    // Render Brain Lobes Geometry
    _drawBrainLobes(canvas, size, cx, cy, baseRadius);

    // Render Selected Lobe Glow and Callouts
    _drawSelectedLobeOverlay(canvas, size, cx, cy, baseRadius);

    // Animated Laser Scan Plane
    _drawScanLaserPlane(canvas, size, cx, cy, baseRadius);
  }

  void _drawHolographicHUD(Canvas canvas, Size size, double cx, double cy, double radius) {
    final ringPaint = Paint()
      ..color = AppColors.cyan.withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Outer Target Rings
    canvas.drawCircle(Offset(cx, cy), radius * 1.25, ringPaint);
    canvas.drawCircle(Offset(cx, cy), radius * 1.35, ringPaint..color = AppColors.cyan.withOpacity(0.06));

    // Rotating telemetry dashes
    final dashPaint = Paint()
      ..color = AppColors.cyan.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    const numDashes = 36;
    for (int i = 0; i < numDashes; i++) {
      final angle = (i * (360 / numDashes) * math.pi / 180) + animTime * 0.2;
      final r1 = radius * 1.25;
      final r2 = (i % 3 == 0) ? r1 + 8 : r1 + 4;
      canvas.drawLine(
        Offset(cx + math.cos(angle) * r1, cy + math.sin(angle) * r1),
        Offset(cx + math.cos(angle) * r2, cy + math.sin(angle) * r2),
        dashPaint,
      );
    }
  }

  void _drawBrainLobes(Canvas canvas, Size size, double cx, double cy, double radius) {
    // We draw the distinct anatomical lobes with organic curvature and sulcal contours
    for (final region in BrainData.regions) {
      final isSelected = region.id == selectedRegion.id;
      final lobePaint = Paint()
        ..color = isSelected ? region.highlightColor.withOpacity(0.45) : region.highlightColor.withOpacity(0.15)
        ..style = PaintingStyle.fill;

      final strokePaint = Paint()
        ..color = isSelected ? region.highlightColor : region.highlightColor.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? 2.5 : 1.2;

      final rx = (region.visualCenter.dx - 0.5) * (radius * 1.8) + cx;
      final ry = (region.visualCenter.dy - 0.5) * (radius * 1.8) + cy;
      final lobeR = region.radius * radius * 1.6;

      // Draw Organic Lobe Contour
      final path = Path();
      const segments = 16;
      for (int i = 0; i <= segments; i++) {
        final theta = (i / segments) * 2 * math.pi;
        // Harmonic organic perturbation
        final ripple = math.sin(theta * 3 + animTime) * (lobeR * 0.08) + math.cos(theta * 5) * (lobeR * 0.04);
        final curR = lobeR + ripple;
        final px = rx + math.cos(theta + rotationY) * curR;
        final py = ry + math.sin(theta + rotationX) * curR;

        if (i == 0) {
          path.moveTo(px, py);
        } else {
          path.lineTo(px, py);
        }
      }
      path.close();

      canvas.drawPath(path, lobePaint);
      canvas.drawPath(path, strokePaint);

      // Sulcal Gyri Internal Curves
      final gyriPaint = Paint()
        ..color = region.highlightColor.withOpacity(isSelected ? 0.8 : 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      for (int g = 0; g < 3; g++) {
        final gyriPath = Path();
        gyriPath.moveTo(rx - lobeR * 0.5, ry - lobeR * 0.3 + g * (lobeR * 0.3));
        gyriPath.cubicTo(
          rx - lobeR * 0.2,
          ry - lobeR * 0.6 + g * (lobeR * 0.3) + math.sin(animTime + g) * 4,
          rx + lobeR * 0.2,
          ry + lobeR * 0.1 + g * (lobeR * 0.3),
          rx + lobeR * 0.5,
          ry - lobeR * 0.2 + g * (lobeR * 0.3),
        );
        canvas.drawPath(gyriPath, gyriPaint);
      }
    }
  }

  void _drawSelectedLobeOverlay(Canvas canvas, Size size, double cx, double cy, double radius) {
    final rx = (selectedRegion.visualCenter.dx - 0.5) * (radius * 1.8) + cx;
    final ry = (selectedRegion.visualCenter.dy - 0.5) * (radius * 1.8) + cy;

    // Glowing Target Marker
    final markerPaint = Paint()
      ..color = selectedRegion.highlightColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(rx, ry), 5.0, markerPaint);

    // Callout Leader Line
    final leaderPaint = Paint()
      ..color = selectedRegion.highlightColor.withOpacity(0.85)
      ..strokeWidth = 1.5;

    final targetOffset = Offset(rx, ry);
    final elbowOffset = Offset(rx + 40, ry - 35);
    final endOffset = Offset(rx + 110, ry - 35);

    canvas.drawLine(targetOffset, elbowOffset, leaderPaint);
    canvas.drawLine(elbowOffset, endOffset, leaderPaint);

    // Callout Text Banner
    final textPainter = TextPainter(
      text: TextSpan(
        text: selectedRegion.name.toUpperCase(),
        style: AppTypography.hudLabel.copyWith(
          color: selectedRegion.highlightColor,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(canvas, Offset(elbowOffset.dx + 4, elbowOffset.dy - 16));
  }

  void _drawScanLaserPlane(Canvas canvas, Size size, double cx, double cy, double radius) {
    final scanY = cy - radius + (math.sin(animTime) * 0.5 + 0.5) * (radius * 2);

    final laserPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          AppColors.cyan.withOpacity(0.1),
          AppColors.cyan.withOpacity(0.8),
          AppColors.cyan.withOpacity(0.1),
          Colors.transparent,
        ],
        stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
      ).createShader(Rect.fromLTRB(cx - radius * 1.2, scanY - 2, cx + radius * 1.2, scanY + 2));

    canvas.drawRect(Rect.fromLTRB(cx - radius * 1.2, scanY - 1.5, cx + radius * 1.2, scanY + 1.5), laserPaint);
  }

  @override
  bool shouldRepaint(covariant _Brain3DPainter oldDelegate) => true;
}
