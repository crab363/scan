import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../models/imaging_modality.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../common/glass_panel.dart';

class KSpaceReconstructor extends StatefulWidget {
  final ImagingModality modality;
  final VoidCallback onReconstructionDone;

  const KSpaceReconstructor({
    super.key,
    required this.modality,
    required this.onReconstructionDone,
  });

  @override
  State<KSpaceReconstructor> createState() => _KSpaceReconstructorState();
}

class _KSpaceReconstructorState extends State<KSpaceReconstructor> with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..forward().then((_) {
        widget.onReconstructionDone();
      });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.modality.accentColor;

    return GlassPanel(
      borderColor: color.withOpacity(0.4),
      padding: const EdgeInsets.all(20),
      showCornerBrackets: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '2D INVERSE FAST FOURIER TRANSFORM (2D-IFFT)',
                    style: AppTypography.hudLabel.copyWith(color: color),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Raw Frequency Domain → Spatial Domain',
                    style: AppTypography.titleMedium.copyWith(fontSize: 18),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: color),
                ),
                child: Text(
                  'MATHEMATICAL RECONSTRUCTION',
                  style: AppTypography.hudLabel.copyWith(color: color, fontSize: 9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 2D IFFT Transition Canvas
          SizedBox(
            height: 240,
            width: double.infinity,
            child: AnimatedBuilder(
              animation: _animController,
              builder: (context, _) {
                return CustomPaint(
                  size: const Size(double.infinity, 240),
                  painter: _KSpacePainter(
                    progress: _animController.value,
                    color: color,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Educational physics explanation note
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceHighlight.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.cardGlassBorder),
            ),
            child: Row(
              children: [
                Icon(Icons.auto_awesome_rounded, color: color, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'The center of k-space holds anatomical contrast (low spatial frequencies), while the periphery holds fine edge sharpness (high spatial frequencies). 2D-IFFT converts phase & frequency integrals into clinical voxels.',
                    style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KSpacePainter extends CustomPainter {
  final double progress;
  final Color color;

  _KSpacePainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Draw Raw K-Space Frequency Grid (Fade out as progress increases)
    final kspaceAlpha = (1.0 - progress).clamp(0.0, 1.0);
    if (kspaceAlpha > 0.05) {
      final kPaint = Paint()
        ..color = color.withOpacity(kspaceAlpha * 0.7)
        ..style = PaintingStyle.fill;

      // Draw high density frequency speckles
      for (int i = 0; i < 180; i++) {
        final rand = math.Random(i * 1337);
        final dist = rand.nextDouble();
        final angle = rand.nextDouble() * 2 * math.pi;
        final r = math.pow(dist, 2.5) * 80;
        final px = cx + math.cos(angle) * r;
        final py = cy + math.sin(angle) * r;
        final dotSize = (1.0 - dist) * 2.5 + 0.8;
        canvas.drawCircle(Offset(px, py), dotSize, kPaint);
      }

      // Bright center star in k-space (Contrast peak)
      final starPaint = Paint()
        ..color = Colors.white.withOpacity(kspaceAlpha * 0.9)
        ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 4);
      canvas.drawCircle(Offset(cx, cy), 8.0, starPaint);
    }

    // Draw Reconstructed Spatial Anatomical Contours (Fade in as progress increases)
    final spatialAlpha = progress.clamp(0.0, 1.0);
    if (spatialAlpha > 0.05) {
      final brainPath = Path();
      brainPath.addOval(Rect.fromCenter(center: Offset(cx, cy), width: 140, height: 170));

      final fillPaint = Paint()
        ..color = color.withOpacity(spatialAlpha * 0.15)
        ..style = PaintingStyle.fill;
      canvas.drawPath(brainPath, fillPaint);

      final strokePaint = Paint()
        ..color = color.withOpacity(spatialAlpha * 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawPath(brainPath, strokePaint);

      // Ventricles & Sulci
      final ventPaint = Paint()
        ..color = Colors.white.withOpacity(spatialAlpha * 0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      // Left Lateral Ventricle
      canvas.drawArc(Rect.fromCenter(center: Offset(cx - 15, cy - 10), width: 22, height: 45), 0.5, 2.2, false, ventPaint);
      // Right Lateral Ventricle
      canvas.drawArc(Rect.fromCenter(center: Offset(cx + 15, cy - 10), width: 22, height: 45), 0.5, -2.2, false, ventPaint);
    }

    // Scanning Fourier Wave Line
    final fourierY = (progress * size.height);
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(cx - 100, fourierY), Offset(cx + 100, fourierY), linePaint);
  }

  @override
  bool shouldRepaint(covariant _KSpacePainter oldDelegate) => true;
}
