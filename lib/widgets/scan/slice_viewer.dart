import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../models/imaging_modality.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../services/audio_service.dart';
import '../common/glass_panel.dart';
import '../common/glowing_button.dart';

class SliceViewer extends StatefulWidget {
  final ImagingModality modality;
  final String title;
  final VoidCallback? onEnterVisualMode;

  const SliceViewer({
    super.key,
    required this.modality,
    this.title = 'RECONSTRUCTED DIAGNOSTIC SLICES',
    this.onEnterVisualMode,
  });

  @override
  State<SliceViewer> createState() => _SliceViewerState();
}

class _SliceViewerState extends State<SliceViewer> {
  int _currentSlice = 14;
  final int _totalSlices = 28;
  double _windowWidth = 100.0; // Contrast
  double _windowLevel = 50.0; // Brightness
  bool _isInvertedLUT = false;
  bool _showCalipers = false;
  Offset _crosshairPos = const Offset(0.5, 0.5);

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
          // Header Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MULTI-SLICE DIAGNOSTIC WORKSTATION',
                    style: AppTypography.hudLabel.copyWith(color: color),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.title,
                    style: AppTypography.titleMedium.copyWith(fontSize: 18),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    tooltip: 'Invert Grayscale LUT (Negative)',
                    icon: Icon(
                      _isInvertedLUT ? Icons.contrast_rounded : Icons.invert_colors_rounded,
                      color: _isInvertedLUT ? AppColors.amber : AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() => _isInvertedLUT = !_isInvertedLUT);
                      SoundService().playSound(SoundEffect.uiClick);
                    },
                  ),
                  IconButton(
                    tooltip: 'Toggle Measurement Calipers',
                    icon: Icon(
                      Icons.straighten_rounded,
                      color: _showCalipers ? color : AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() => _showCalipers = !_showCalipers);
                      SoundService().playSound(SoundEffect.uiClick);
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Central Medical Slice Visualizer Canvas
          Container(
            height: 280,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _isInvertedLUT ? const Color(0xFFF0F4F8) : const Color(0xFF03060E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.4)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  // Slice Painter
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _MedicalSlicePainter(
                        sliceIndex: _currentSlice,
                        totalSlices: _totalSlices,
                        modalityType: widget.modality.type,
                        windowWidth: _windowWidth,
                        windowLevel: _windowLevel,
                        isInverted: _isInvertedLUT,
                        accentColor: color,
                        crosshairPos: _crosshairPos,
                        showCalipers: _showCalipers,
                      ),
                    ),
                  ),

                  // Interactive Crosshair Touch Target
                  Positioned.fill(
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        final box = context.findRenderObject() as RenderBox?;
                        if (box != null) {
                          setState(() {
                            final local = details.localPosition;
                            _crosshairPos = Offset(
                              (local.dx / 320).clamp(0.1, 0.9),
                              (local.dy / 280).clamp(0.1, 0.9),
                            );
                          });
                        }
                      },
                    ),
                  ),

                  // Overlay Workstation Telemetry Labels
                  Positioned(
                    top: 10,
                    left: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CASE: 024-MRI', style: AppTypography.hudLabel.copyWith(fontSize: 10, color: color)),
                        Text('AXIAL T2-FSE', style: AppTypography.hudLabel.copyWith(fontSize: 9, color: AppColors.textSecondary)),
                        Text('THK: 4.0mm / SP: 1.0mm', style: AppTypography.telemetryCode.copyWith(fontSize: 9)),
                      ],
                    ),
                  ),

                  Positioned(
                    top: 10,
                    right: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('WW: ${_windowWidth.toInt()} | WL: ${_windowLevel.toInt()}', style: AppTypography.hudLabel.copyWith(fontSize: 9, color: color)),
                        Text('SLICE: $_currentSlice / $_totalSlices', style: AppTypography.hudValue.copyWith(fontSize: 11, color: Colors.white)),
                        Text('FOV: 230mm', style: AppTypography.telemetryCode.copyWith(fontSize: 9)),
                      ],
                    ),
                  ),

                  // Anatomical Directional Markers
                  Positioned(
                    top: 8,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text('A (ANTERIOR)', style: AppTypography.hudLabel.copyWith(fontSize: 9, color: color.withOpacity(0.7))),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text('P (POSTERIOR)', style: AppTypography.hudLabel.copyWith(fontSize: 9, color: color.withOpacity(0.7))),
                    ),
                  ),
                  Positioned(
                    left: 8,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Text('R', style: AppTypography.hudLabel.copyWith(fontSize: 11, color: color.withOpacity(0.7))),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Text('L', style: AppTypography.hudLabel.copyWith(fontSize: 11, color: color.withOpacity(0.7))),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Multi-Slice Scrubber Slider
          Row(
            children: [
              Text('SLICE DEPTH', style: AppTypography.hudLabel.copyWith(fontSize: 10, color: AppColors.textMuted)),
              const SizedBox(width: 10),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: color,
                    thumbColor: color,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                    trackHeight: 3,
                  ),
                  child: Slider(
                    value: _currentSlice.toDouble(),
                    min: 1,
                    max: _totalSlices.toDouble(),
                    divisions: _totalSlices - 1,
                    label: 'Slice $_currentSlice',
                    onChanged: (val) {
                      setState(() => _currentSlice = val.toInt());
                    },
                  ),
                ),
              ),
              Text('$_currentSlice / $_totalSlices', style: AppTypography.hudValue.copyWith(fontSize: 12, color: color)),
            ],
          ),
          const SizedBox(height: 8),

          // Window / Level Controls
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('WINDOW WIDTH (CONTRAST)', style: AppTypography.hudLabel.copyWith(fontSize: 8, color: AppColors.textMuted)),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: color.withOpacity(0.8),
                        thumbColor: color,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                        trackHeight: 2,
                      ),
                      child: Slider(
                        value: _windowWidth,
                        min: 20.0,
                        max: 200.0,
                        onChanged: (val) => setState(() => _windowWidth = val),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('WINDOW LEVEL (BRIGHTNESS)', style: AppTypography.hudLabel.copyWith(fontSize: 8, color: AppColors.textMuted)),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: color.withOpacity(0.8),
                        thumbColor: color,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                        trackHeight: 2,
                      ),
                      child: Slider(
                        value: _windowLevel,
                        min: 0.0,
                        max: 100.0,
                        onChanged: (val) => setState(() => _windowLevel = val),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Bottom Action: Enter Visual Mode
          if (widget.onEnterVisualMode != null)
            Align(
              alignment: Alignment.centerRight,
              child: GlowingButton(
                text: 'ENTER CONCERT VISUAL MODE',
                icon: Icons.auto_awesome_motion_rounded,
                primaryColor: AppColors.magenta,
                secondaryColor: AppColors.violet,
                onPressed: widget.onEnterVisualMode!,
              ),
            ),
        ],
      ),
    );
  }
}

class _MedicalSlicePainter extends CustomPainter {
  final int sliceIndex;
  final int totalSlices;
  final ModalityType modalityType;
  final double windowWidth;
  final double windowLevel;
  final bool isInverted;
  final Color accentColor;
  final Offset crosshairPos;
  final bool showCalipers;

  _MedicalSlicePainter({
    required this.sliceIndex,
    required this.totalSlices,
    required this.modalityType,
    required this.windowWidth,
    required this.windowLevel,
    required this.isInverted,
    required this.accentColor,
    required this.crosshairPos,
    required this.showCalipers,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Slice relative depth (0.0 to 1.0)
    final depth = sliceIndex / totalSlices;
    final baseRadius = math.min(size.width, size.height) * 0.36;

    // Calibrate brightness & contrast
    final contrastMult = windowWidth / 100.0;

    final brainParenchymaPaint = Paint()
      ..color = isInverted ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B).withOpacity((0.9 * contrastMult).clamp(0.1, 1.0))
      ..style = PaintingStyle.fill;

    final skullPaint = Paint()
      ..color = isInverted ? const Color(0xFF0F172A) : Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = modalityType == ModalityType.ct ? 5.0 : 2.5;

    // 1. Calvarium / Skull Oval
    final skullPath = Path();
    final skullW = (baseRadius * 2.0) * (0.85 + math.sin(depth * math.pi) * 0.25);
    final skullH = (baseRadius * 2.4) * (0.85 + math.sin(depth * math.pi) * 0.25);
    skullPath.addOval(Rect.fromCenter(center: Offset(cx, cy), width: skullW, height: skullH));

    canvas.drawPath(skullPath, brainParenchymaPaint);
    canvas.drawPath(skullPath, skullPaint);

    // 2. Gray / White Matter Sulcal Undulations
    final sulciPaint = Paint()
      ..color = isInverted ? const Color(0xFF94A3B8) : const Color(0xFF475569).withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * math.pi;
      final sx = cx + math.cos(angle) * (skullW * 0.42);
      final sy = cy + math.sin(angle) * (skullH * 0.42);
      final ex = cx + math.cos(angle) * (skullW * 0.28);
      final ey = cy + math.sin(angle) * (skullH * 0.28);
      canvas.drawLine(Offset(sx, sy), Offset(ex, ey), sulciPaint);
    }

    // 3. Ventricles (Shape morphs based on slice depth)
    final ventPaint = Paint()
      ..color = isInverted ? Colors.white : (modalityType == ModalityType.mri ? const Color(0xFF020617) : const Color(0xFF0F172A))
      ..style = PaintingStyle.fill;

    final ventStroke = Paint()
      ..color = accentColor.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final ventSize = math.sin(depth * math.pi) * 35.0;
    if (ventSize > 5.0) {
      // Left Frontal Horn
      final leftHorn = Path()
        ..moveTo(cx - 6, cy - 20)
        ..cubicTo(cx - 24, cy - 10, cx - 18, cy + 20, cx - 4, cy + 10)
        ..close();
      canvas.drawPath(leftHorn, ventPaint);
      canvas.drawPath(leftHorn, ventStroke);

      // Right Frontal Horn
      final rightHorn = Path()
        ..moveTo(cx + 6, cy - 20)
        ..cubicTo(cx + 24, cy - 10, cx + 18, cy + 20, cx + 4, cy + 10)
        ..close();
      canvas.drawPath(rightHorn, ventPaint);
      canvas.drawPath(rightHorn, ventStroke);
    }

    // 4. Interactive Crosshair Marker
    final chX = crosshairPos.dx * size.width;
    final chY = crosshairPos.dy * size.height;

    final crossPaint = Paint()
      ..color = accentColor.withOpacity(0.8)
      ..strokeWidth = 1.0;

    canvas.drawLine(Offset(chX - 12, chY), Offset(chX + 12, chY), crossPaint);
    canvas.drawLine(Offset(chX, chY - 12), Offset(chX, chY + 12), crossPaint);

    // 5. Measurement Caliper Overlay
    if (showCalipers) {
      final calPaint = Paint()
        ..color = AppColors.amber
        ..strokeWidth = 1.5;

      final p1 = Offset(cx - 40, cy - 15);
      final p2 = Offset(cx + 40, cy - 15);

      canvas.drawLine(p1, p2, calPaint);
      canvas.drawLine(Offset(p1.dx, p1.dy - 4), Offset(p1.dx, p1.dy + 4), calPaint);
      canvas.drawLine(Offset(p2.dx, p2.dy - 4), Offset(p2.dx, p2.dy + 4), calPaint);

      final textPainter = TextPainter(
        text: TextSpan(
          text: '28.4 mm',
          style: AppTypography.hudLabel.copyWith(color: AppColors.amber, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(cx - 20, cy - 32));
    }
  }

  @override
  bool shouldRepaint(covariant _MedicalSlicePainter oldDelegate) => true;
}
