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
      padding: const EdgeInsets.all(18),
      showCornerBrackets: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2D INVERSE FAST FOURIER TRANSFORM (2D-IFFT)',
                      style: AppTypography.hudLabel.copyWith(color: color, fontSize: 9.5),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Raw Frequency Domain → Spatial Domain',
                      style: AppTypography.titleMedium.copyWith(fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: color),
                ),
                child: Text(
                  '2D-IFFT RECON',
                  style: AppTypography.hudLabel.copyWith(color: color, fontSize: 8.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 2D IFFT Transition Canvas
          SizedBox(
            height: 220,
            width: double.infinity,
            child: AnimatedBuilder(
              animation: _animController,
              builder: (context, _) {
                return CustomPaint(
                  size: const Size(double.infinity, 220),
                  painter: _KSpacePainter(
                    progress: _animController.value,
                    color: color,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),

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
                Icon(Icons.auto_awesome_rounded, color: color, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'The center of k-space holds anatomical contrast (low spatial frequencies), while the periphery holds fine edge sharpness (high spatial frequencies). 2D-IFFT converts phase & frequency integrals into clinical voxels.',
                    style: AppTypography.bodySmall.copyWith(fontSize: 10.5, color: AppColors.textSecondary),
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
        ..strokeWidth = 1.0;

      // Concentric raw frequency waves
      for (int r = 10; r < 100; r += 15) {
        canvas.drawCircle(Offset(cx, cy), r.toDouble(), kPaint..style = PaintingStyle.stroke);
      }

      // High frequency starburst lines
      for (int i = 0; i < 16; i++) {
        final angle = i * (math.pi / 8);
        canvas.drawLine(
          Offset(cx + math.cos(angle) * 10, cy + math.sin(angle) * 10),
          Offset(cx + math.cos(angle) * 110, cy + math.sin(angle) * 110),
          kPaint,
        );
      }
    }

    // Draw Spatial Domain Brain Reconstruction (Fade in with progress)
    final spatialAlpha = progress.clamp(0.0, 1.0);
    if (spatialAlpha > 0.05) {
      final brainPaint = Paint()
        ..color = Colors.white.withOpacity(spatialAlpha * 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      // Calvarium / Skull contour
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, cy), width: 140 * spatialAlpha, height: 170 * spatialAlpha),
        brainPaint,
      );

      // Ventricles & Sulci contours
      final ventriclePaint = Paint()
        ..color = color.withOpacity(spatialAlpha * 0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      final leftVent = Path()
        ..moveTo(cx - 15, cy - 30)
        ..quadraticBezierTo(cx - 30, cy, cx - 10, cy + 25)
        ..quadraticBezierTo(cx - 5, cy, cx - 15, cy - 30);
      canvas.drawPath(leftVent, ventriclePaint);

      final rightVent = Path()
        ..moveTo(cx + 15, cy - 30)
        ..quadraticBezierTo(cx + 30, cy, cx + 10, cy + 25)
        ..quadraticBezierTo(cx + 5, cy, cx + 15, cy - 30);
      canvas.drawPath(rightVent, ventriclePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _KSpacePainter oldDelegate) => true;
}
