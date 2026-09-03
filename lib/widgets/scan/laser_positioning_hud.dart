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
                    'LASER OPTICAL ISOCENTER ALIGNMENT',
                    style: AppTypography.hudLabel.copyWith(color: color),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Patient Positioning & Table Coordinates',
                    style: AppTypography.titleMedium.copyWith(fontSize: 18),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                      size: 14,
                      color: _isLaserAligned ? AppColors.emerald : AppColors.amber,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _isLaserAligned ? 'ISOCENTER LOCKED' : 'ALIGN TARGET',
                      style: AppTypography.hudLabel.copyWith(
                        color: _isLaserAligned ? AppColors.emerald : AppColors.amber,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Interactive Crosshair Alignment Canvas
          SizedBox(
            height: 220,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Gantry Bore & Calibration Grid
                CustomPaint(
                  size: const Size(double.infinity, 220),
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
                        _crosshairOffset.dy.clamp(-80.0, 80.0),
                      );
                    });
                    _checkAlignment();
                  },
                  child: Transform.translate(
                    offset: _crosshairOffset,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.move,
                      child: Container(
                        width: 60,
                        height: 60,
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
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.filter_center_focus_rounded,
                          color: _isLaserAligned ? AppColors.emerald : color,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),

                // Instruction Overlay Badge
                Positioned(
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.background.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.cardGlassBorder),
                    ),
                    child: Text(
                      'Drag crosshair to center optical isocenter (0, 0)',
                      style: AppTypography.hudLabel.copyWith(
                        fontSize: 9,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

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
                        Text('TABLE ELEVATION (Z-AXIS)', style: AppTypography.hudLabel.copyWith(fontSize: 9, color: AppColors.textMuted)),
                        Text('${_tableHeightMm.toStringAsFixed(1)} mm', style: AppTypography.hudValue.copyWith(fontSize: 12, color: color)),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: color,
                        thumbColor: color,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        trackHeight: 3,
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
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('BORE ADVANCEMENT (Y-AXIS)', style: AppTypography.hudLabel.copyWith(fontSize: 9, color: AppColors.textMuted)),
                        Text('${_boreAdvancementMm.toStringAsFixed(1)} mm', style: AppTypography.hudValue.copyWith(fontSize: 12, color: color)),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: color,
                        thumbColor: color,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        trackHeight: 3,
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
          const SizedBox(height: 16),

          // Lock Position Button
          Align(
            alignment: Alignment.centerRight,
            child: GlowingButton(
              text: _isLaserAligned ? 'LOCK ISOCENTER & START ACQUISITION' : 'AUTO-LOCK ISOCENTER',
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

    canvas.drawCircle(Offset(cx, cy), 80, ringPaint);
    canvas.drawCircle(Offset(cx, cy), 50, ringPaint);
    canvas.drawCircle(Offset(cx, cy), 20, ringPaint..color = (isAligned ? AppColors.emerald : color).withOpacity(0.5));

    // Target Crosshair Axis Lines
    final axisPaint = Paint()
      ..color = (isAligned ? AppColors.emerald : color).withOpacity(0.4)
      ..strokeWidth = 1.2;

    canvas.drawLine(Offset(cx - 100, cy), Offset(cx + 100, cy), axisPaint);
    canvas.drawLine(Offset(cx, cy - 80), Offset(cx, cy + 80), axisPaint);

    // Center Pulse Target Ring
    final centerPulsePaint = Paint()
      ..color = (isAligned ? AppColors.emerald : color).withOpacity(0.3 * (1.0 - pulse))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(Offset(cx, cy), 20.0 + pulse * 15.0, centerPulsePaint);
  }

  @override
  bool shouldRepaint(covariant _GantryTargetPainter oldDelegate) => true;
}
