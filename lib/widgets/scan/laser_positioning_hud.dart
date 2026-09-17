import 'package:flutter/material.dart';
import '../../models/imaging_modality.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../services/audio_service.dart';
import '../../services/localization_service.dart';
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
  double _sliceThicknessMm = 3.0;
  double _acpcAngleDeg = 12.0;
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
    final isTh = LocalizationService().isThai;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return GlassPanel(
      borderColor: color.withOpacity(0.4),
      padding: EdgeInsets.all(isMobile ? 12 : 18),
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
                      'laser_hud_title'.tr,
                      style: AppTypography.hudLabel.copyWith(color: color, fontSize: isMobile ? 9 : 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'isocenter_alignment'.tr,
                      style: AppTypography.titleMedium.copyWith(fontSize: isMobile ? 14 : 17),
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
                      _isLaserAligned ? 'ISOCENTER LOCKED' : 'ALIGN TARGET',
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

          // Interactive Scout Topogram / Laser Crosshair Canvas
          SizedBox(
            height: 200,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Gantry Bore & Slice Pack Graphic
                CustomPaint(
                  size: const Size(double.infinity, 200),
                  painter: _ScoutPlanPainter(
                    color: color,
                    pulse: _crosshairPulse.value,
                    isAligned: _isLaserAligned,
                    angleDeg: _acpcAngleDeg,
                    sliceThickness: _sliceThicknessMm,
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
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withOpacity(0.12),
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
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.background.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.cardGlassBorder),
                    ),
                    child: Text(
                      isTh ? 'ลากเป้าเลเซอร์ไปยังจุดกึ่งกลาง (0, 0) เพื่อล็อกแนวศูนย์กลาง' : 'Drag laser crosshair to center optical isocenter (0, 0)',
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

          // Planning Sliders: Slice Thickness, Gap, AC-PC Line Angle
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('slice_thickness'.tr, style: AppTypography.hudLabel.copyWith(fontSize: 8, color: AppColors.textMuted)),
                        Text('${_sliceThicknessMm.toStringAsFixed(1)} mm', style: AppTypography.hudValue.copyWith(fontSize: 10, color: color)),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: color,
                        thumbColor: color,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4.5),
                        trackHeight: 2,
                      ),
                      child: Slider(
                        value: _sliceThicknessMm,
                        min: 1.0,
                        max: 8.0,
                        divisions: 14,
                        onChanged: (val) => setState(() => _sliceThicknessMm = val),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('plane_angle'.tr, style: AppTypography.hudLabel.copyWith(fontSize: 8, color: AppColors.textMuted)),
                        Text('${_acpcAngleDeg.toStringAsFixed(1)}°', style: AppTypography.hudValue.copyWith(fontSize: 10, color: AppColors.amber)),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.amber,
                        thumbColor: AppColors.amber,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4.5),
                        trackHeight: 2,
                      ),
                      child: Slider(
                        value: _acpcAngleDeg,
                        min: 0.0,
                        max: 30.0,
                        divisions: 15,
                        onChanged: (val) => setState(() => _acpcAngleDeg = val),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Coordinates Row: Table Height (Z) & Bore Depth (Y)
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('table_height'.tr, style: AppTypography.hudLabel.copyWith(fontSize: 8, color: AppColors.textMuted)),
                        Text('${_tableHeightMm.toStringAsFixed(1)} mm', style: AppTypography.hudValue.copyWith(fontSize: 10, color: color)),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: color.withOpacity(0.8),
                        thumbColor: color,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4.5),
                        trackHeight: 2,
                      ),
                      child: Slider(
                        value: _tableHeightMm,
                        min: 80.0,
                        max: 200.0,
                        onChanged: (val) => setState(() => _tableHeightMm = val),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('gantry_depth'.tr, style: AppTypography.hudLabel.copyWith(fontSize: 8, color: AppColors.textMuted)),
                        Text('${_boreAdvancementMm.toStringAsFixed(1)} mm', style: AppTypography.hudValue.copyWith(fontSize: 10, color: color)),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: color.withOpacity(0.8),
                        thumbColor: color,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4.5),
                        trackHeight: 2,
                      ),
                      child: Slider(
                        value: _boreAdvancementMm,
                        min: 100.0,
                        max: 600.0,
                        onChanged: (val) => setState(() => _boreAdvancementMm = val),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Lock Position Button
          Align(
            alignment: Alignment.centerRight,
            child: GlowingButton(
              text: 'lock_position_btn'.tr,
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

class _ScoutPlanPainter extends CustomPainter {
  final Color color;
  final double pulse;
  final bool isAligned;
  final double angleDeg;
  final double sliceThickness;

  _ScoutPlanPainter({
    required this.color,
    required this.pulse,
    required this.isAligned,
    required this.angleDeg,
    required this.sliceThickness,
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

    canvas.drawCircle(Offset(cx, cy), 74, ringPaint);
    canvas.drawCircle(Offset(cx, cy), 46, ringPaint);
    canvas.drawCircle(Offset(cx, cy), 18, ringPaint..color = (isAligned ? AppColors.emerald : color).withOpacity(0.5));

    // Scout Slice Pack Stack (Green box tilted by angleDeg)
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(angleDeg * 3.14159265 / 180.0);

    final boxPaint = Paint()
      ..color = AppColors.emerald.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    final boxBorder = Paint()
      ..color = AppColors.emerald.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final boxRect = Rect.fromCenter(center: Offset.zero, width: 140, height: 60 + sliceThickness * 5);
    canvas.drawRect(boxRect, boxPaint);
    canvas.drawRect(boxRect, boxBorder);

    // Multi-slice grid lines
    final sliceLinePaint = Paint()
      ..color = AppColors.emerald.withOpacity(0.4)
      ..strokeWidth = 1.0;
    for (double y = boxRect.top + 10; y < boxRect.bottom; y += 12) {
      canvas.drawLine(Offset(boxRect.left, y), Offset(boxRect.right, y), sliceLinePaint);
    }

    canvas.restore();

    // Laser Crosshairs (Red/Cyan)
    final laserPaint = Paint()
      ..color = (isAligned ? AppColors.emerald : const Color(0xFFFF2A6D)).withOpacity(0.7)
      ..strokeWidth = 1.2;

    canvas.drawLine(Offset(cx - 100, cy), Offset(cx + 100, cy), laserPaint);
    canvas.drawLine(Offset(cx, cy - 80), Offset(cx, cy + 80), laserPaint);

    // Center Pulse Target Ring
    final centerPulsePaint = Paint()
      ..color = (isAligned ? AppColors.emerald : color).withOpacity(0.3 * (1.0 - pulse))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(Offset(cx, cy), 18.0 + pulse * 14.0, centerPulsePaint);
  }

  @override
  bool shouldRepaint(covariant _ScoutPlanPainter oldDelegate) => true;
}
