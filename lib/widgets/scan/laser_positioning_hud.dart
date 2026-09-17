import 'package:flutter/material.dart';
import '../../models/imaging_modality.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../services/audio_service.dart';
import '../common/glass_panel.dart';
import '../common/glowing_button.dart';

class LaserPositioningHUD extends StatefulWidget {
  final ImagingModality modality;
  final VoidCallback onPositioningLocked;

  const LaserPositioningHUD({
    super.key,
    required this.modality,
    required this.onPositioningLocked,
  });

  @override
  State<LaserPositioningHUD> createState() => _LaserPositioningHUDState();
}

class _LaserPositioningHUDState extends State<LaserPositioningHUD> with SingleTickerProviderStateMixin {
  late AnimationController _crosshairPulse;
  Offset _crosshairOffset = const Offset(0.0, 0.0);
  double _tableHeightMm = 142.0;
  double _boreAdvancementMm = 380.0;
  bool _isLaserAligned = false;

  @override
  void initState() {
    super.initState();
    _crosshairPulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _crosshairPulse.dispose();
    super.dispose();
  }

  void _checkAlignment() {
    // Within tolerance of isocenter
    if (_crosshairOffset.dx.abs() < 25 && _crosshairOffset.dy.abs() < 25) {
      if (!_isLaserAligned) {
        setState(() => _isLaserAligned = true);
        SoundService().playSound(SoundEffect.laserBeep);
      }
    } else {
      if (_isLaserAligned) {
        setState(() => _isLaserAligned = false);
      }
    }
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
                      'LASER OPTICAL ISOCENTER ALIGNMENT',
                      style: AppTypography.hudLabel.copyWith(color: color, fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Patient Positioning & Table Coordinates',
                      style: AppTypography.titleMedium.copyWith(fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: _isLaserAligned ? AppColors.emerald.withOpacity(0.2) : AppColors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: _isLaserAligned ? AppColors.emerald : AppColors.amber),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isLaserAligned ? Icons.check_circle_rounded : Icons.radar_rounded,
                      size: 13,
                      color: _isLaserAligned ? AppColors.emerald : AppColors.amber,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _isLaserAligned ? 'LOCKED' : 'ALIGN',
                      style: AppTypography.hudLabel.copyWith(
                        color: _isLaserAligned ? AppColors.emerald : AppColors.amber,
                        fontSize: 8.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Interactive Crosshair Alignment Canvas
          SizedBox(
            height: 200,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Gantry Bore & Calibration Grid
                CustomPaint(
                  size: const Size(double.infinity, 200),
                  painter: _GantryTargetPainter(
                    color: color,
                    pulse: _crosshairPulse.value,
                    isAligned: _isLaserAligned,
                  ),
                ),

                // Drag gesture detector for crosshair target
                GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _crosshairOffset += details.delta;
                      _crosshairOffset = Offset(
                        _crosshairOffset.dx.clamp(-120.0, 120.0),
                        _crosshairOffset.dy.clamp(-75.0, 75.0),
                      );
                    });
                    _checkAlignment();
                  },
                  child: Transform.translate(
                    offset: _crosshairOffset,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.move,
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withOpacity(0.1),
                          border: Border.all(
                            color: _isLaserAligned ? AppColors.emerald : color,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (_isLaserAligned ? AppColors.emerald : color).withOpacity(0.6),
                              blurRadius: 14,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.filter_center_focus_rounded,
                          color: _isLaserAligned ? AppColors.emerald : color,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                ),

                // Instruction Overlay Badge
                Positioned(
                  bottom: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.background.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.cardGlassBorder),
                    ),
                    child: Text(
                      'Drag crosshair to center optical isocenter (0, 0)',
                      style: AppTypography.hudLabel.copyWith(
                        fontSize: 8.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Telemetry Sliders: Table Elevation & Bore Advancement
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('TABLE (Z)', style: AppTypography.hudLabel.copyWith(fontSize: 8.5, color: AppColors.textMuted)),
                        Text('${_tableHeightMm.toStringAsFixed(1)}mm', style: AppTypography.hudValue.copyWith(fontSize: 10.5, color: color)),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: color,
                        thumbColor: color,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                        trackHeight: 2,
                      ),
                      child: Slider(
                        value: _tableHeightMm,
                        min: 80.0,
                        max: 200.0,
                        onChanged: (val) {
                          setState(() => _tableHeightMm = val);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('BORE (Y)', style: AppTypography.hudLabel.copyWith(fontSize: 8.5, color: AppColors.textMuted)),
                        Text('${_boreAdvancementMm.toStringAsFixed(1)}mm', style: AppTypography.hudValue.copyWith(fontSize: 10.5, color: color)),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: color,
                        thumbColor: color,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                        trackHeight: 2,
                      ),
                      child: Slider(
                        value: _boreAdvancementMm,
                        min: 100.0,
                        max: 600.0,
                        onChanged: (val) {
                          setState(() => _boreAdvancementMm = val);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Lock Position Button
          Align(
            alignment: Alignment.centerRight,
            child: GlowingButton(
              text: _isLaserAligned ? 'LOCK ISOCENTER & PROCEED' : 'AUTO-LOCK ISOCENTER',
              icon: Icons.lock_outline_rounded,
              primaryColor: _isLaserAligned ? AppColors.emerald : color,
              onPressed: () {
                setState(() {
                  _crosshairOffset = Offset.zero;
                  _isLaserAligned = true;
                });
                SoundService().playSound(SoundEffect.laserBeep);
                widget.onPositioningLocked();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _GantryTargetPainter extends CustomPainter {
  final Color color;
  final double pulse;
  final bool isAligned;

  _GantryTargetPainter({
    required this.color,
    required this.pulse,
    required this.isAligned,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Gantry Outer Bore Rings
    final ringPaint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(Offset(cx, cy), 70, ringPaint);
    canvas.drawCircle(Offset(cx, cy), 45, ringPaint);
    canvas.drawCircle(Offset(cx, cy), 18, ringPaint..color = (isAligned ? AppColors.emerald : color).withOpacity(0.5));

    // Target Crosshair Axis Lines
    final axisPaint = Paint()
      ..color = (isAligned ? AppColors.emerald : color).withOpacity(0.4)
      ..strokeWidth = 1.2;

    canvas.drawLine(Offset(cx - 90, cy), Offset(cx + 90, cy), axisPaint);
    canvas.drawLine(Offset(cx, cy - 70), Offset(cx, cy + 70), axisPaint);

    // Center Pulse Target Ring
    final centerPulsePaint = Paint()
      ..color = (isAligned ? AppColors.emerald : color).withOpacity(0.3 * (1.0 - pulse))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(Offset(cx, cy), 18.0 + pulse * 12.0, centerPulsePaint);
  }

  @override
  bool shouldRepaint(covariant _GantryTargetPainter oldDelegate) => true;
}
