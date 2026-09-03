import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../models/anatomy_model.dart';
import '../../data/anatomy_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../services/audio_service.dart';

class BodySilhouetteScanner extends StatefulWidget {
  final AnatomyZone selectedZone;
  final ValueChanged<AnatomyZone> onZoneSelected;
  final VoidCallback? onZoneDoubleTapped;

  const BodySilhouetteScanner({
    super.key,
    required this.selectedZone,
    required this.onZoneSelected,
    this.onZoneDoubleTapped,
  });

  @override
  State<BodySilhouetteScanner> createState() => _BodySilhouetteScannerState();
}

class _BodySilhouetteScannerState extends State<BodySilhouetteScanner> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final canvasWidth = constraints.maxWidth;
        final canvasHeight = constraints.maxHeight;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Custom Painter for Human Body Mesh, Grid & Nodes
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, _) {
                return CustomPaint(
                  size: Size(canvasWidth, canvasHeight),
                  painter: _BodyMeshPainter(
                    pulseProgress: _pulseController.value,
                    selectedZoneId: widget.selectedZone.id,
                  ),
                );
              },
            ),

            // Interactive Hit-Test Overlay Nodes
            ...AnatomyData.zones.map((zone) {
              final isSelected = zone.id == widget.selectedZone.id;
              final posX = zone.coordinates.dx * canvasWidth;
              final posY = zone.coordinates.dy * canvasHeight;

              return Positioned(
                left: posX - 48,
                top: posY - 24,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      SoundService().playSound(SoundEffect.uiClick);
                      widget.onZoneSelected(zone);
                    },
                    onDoubleTap: () {
                      if (widget.onZoneDoubleTapped != null) {
                        widget.onZoneDoubleTapped!();
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: isSelected ? zone.accentColor.withOpacity(0.25) : AppColors.surface.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? zone.accentColor : zone.accentColor.withOpacity(0.4),
                          width: isSelected ? 2.0 : 1.0,
                        ),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: zone.accentColor.withOpacity(0.6),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: zone.accentColor,
                              boxShadow: [
                                BoxShadow(
                                  color: zone.accentColor.withOpacity(0.9),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            zone.name.split(' ').first.toUpperCase(),
                            style: AppTypography.hudLabel.copyWith(
                              color: isSelected ? Colors.white : zone.accentColor,
                              fontSize: 10,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

class _BodyMeshPainter extends CustomPainter {
  final double pulseProgress;
  final String selectedZoneId;

  _BodyMeshPainter({
    required this.pulseProgress,
    required this.selectedZoneId,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final scale = math.min(size.width / 360, size.height / 600);

    // Scanner beam sweep line
    final scanY = (pulseProgress * size.height);
    final scanBeamPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          AppColors.cyan.withOpacity(0.2),
          AppColors.cyan.withOpacity(0.8),
          AppColors.cyan.withOpacity(0.2),
          Colors.transparent,
        ],
        stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
      ).createShader(Rect.fromLTRB(cx - 140 * scale, scanY - 2, cx + 140 * scale, scanY + 2));

    canvas.drawRect(Rect.fromLTRB(cx - 140 * scale, scanY - 1, cx + 140 * scale, scanY + 1), scanBeamPaint);

    // Stylized Cyberpunk Human Silhouette Path
    final bodyPath = Path();

    // Head / Cranium
    final headCenter = Offset(cx, cy - 210 * scale);
    final headRadius = 32.0 * scale;
    bodyPath.addOval(Rect.fromCircle(center: headCenter, radius: headRadius));

    // Neck
    bodyPath.moveTo(cx - 10 * scale, cy - 180 * scale);
    bodyPath.lineTo(cx - 10 * scale, cy - 160 * scale);
    bodyPath.lineTo(cx + 10 * scale, cy - 160 * scale);
    bodyPath.lineTo(cx + 10 * scale, cy - 180 * scale);

    // Torso & Shoulders
    bodyPath.moveTo(cx - 10 * scale, cy - 160 * scale);
    bodyPath.lineTo(cx - 65 * scale, cy - 145 * scale); // Left shoulder
    bodyPath.lineTo(cx - 85 * scale, cy - 30 * scale); // Left arm
    bodyPath.lineTo(cx - 70 * scale, cy - 30 * scale);
    bodyPath.lineTo(cx - 50 * scale, cy - 110 * scale);
    bodyPath.lineTo(cx - 45 * scale, cy + 30 * scale); // Left waist/hip
    bodyPath.lineTo(cx - 48 * scale, cy + 180 * scale); // Left knee
    bodyPath.lineTo(cx - 38 * scale, cy + 260 * scale); // Left ankle
    bodyPath.lineTo(cx - 18 * scale, cy + 260 * scale);
    bodyPath.lineTo(cx - 18 * scale, cy + 180 * scale);
    bodyPath.lineTo(cx - 8 * scale, cy + 60 * scale); // Inguinal crease
    bodyPath.lineTo(cx + 8 * scale, cy + 60 * scale);
    bodyPath.lineTo(cx + 18 * scale, cy + 180 * scale);
    bodyPath.lineTo(cx + 18 * scale, cy + 260 * scale);
    bodyPath.lineTo(cx + 38 * scale, cy + 260 * scale); // Right ankle
    bodyPath.lineTo(cx + 48 * scale, cy + 180 * scale); // Right knee
    bodyPath.lineTo(cx + 45 * scale, cy + 30 * scale); // Right waist
    bodyPath.lineTo(cx + 50 * scale, cy - 110 * scale);
    bodyPath.lineTo(cx + 70 * scale, cy - 30 * scale);
    bodyPath.lineTo(cx + 85 * scale, cy - 30 * scale); // Right arm
    bodyPath.lineTo(cx + 65 * scale, cy - 145 * scale); // Right shoulder
    bodyPath.lineTo(cx + 10 * scale, cy - 160 * scale);

    // Fill silhouette with subtle holographic gradient
    final fillPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.9,
        colors: [
          AppColors.cyan.withOpacity(0.08),
          AppColors.surface.withOpacity(0.4),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCenter(center: Offset(cx, cy), width: 220 * scale, height: 550 * scale));

    canvas.drawPath(bodyPath, fillPaint);

    // Stroke Outline
    final strokePaint = Paint()
      ..color = AppColors.cyan.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(bodyPath, strokePaint);

    // Internal anatomical ribcage & spine grid lines
    final spinePaint = Paint()
      ..color = AppColors.violet.withOpacity(0.35)
      ..strokeWidth = 2.0;
    canvas.drawLine(Offset(cx, cy - 160 * scale), Offset(cx, cy + 50 * scale), spinePaint);

    for (int i = 0; i < 6; i++) {
      final ry = cy - (130 - i * 18) * scale;
      final rx = (32 - i * 3) * scale;
      final ribPaint = Paint()
        ..color = AppColors.emerald.withOpacity(0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2;
      canvas.drawArc(
        Rect.fromCenter(center: Offset(cx, ry), width: rx * 2, height: 16 * scale),
        math.pi * 0.1,
        math.pi * 0.8,
        false,
        ribPaint,
      );
    }

    // Draw pulsing concentric target rings on selected zone
    final currentZone = AnatomyData.zones.firstWhere(
      (z) => z.id == selectedZoneId,
      orElse: () => AnatomyData.zones.first,
    );
    final targetX = currentZone.coordinates.dx * size.width;
    final targetY = currentZone.coordinates.dy * size.height;

    final pulseRadius = 15.0 + pulseProgress * 25.0;
    final pulseAlpha = (1.0 - pulseProgress) * 0.7;

    final targetPulsePaint = Paint()
      ..color = currentZone.accentColor.withOpacity(pulseAlpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    canvas.drawCircle(Offset(targetX, targetY), pulseRadius, targetPulsePaint);

    final targetCenterPaint = Paint()
      ..color = currentZone.accentColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(targetX, targetY), 4.0, targetCenterPaint);
  }

  @override
  bool shouldRepaint(covariant _BodyMeshPainter oldDelegate) {
    return oldDelegate.pulseProgress != pulseProgress || oldDelegate.selectedZoneId != selectedZoneId;
  }
}
