import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class WaveformVisualizer extends StatefulWidget {
  final double height;
  final double width;
  final Color primaryColor;
  final Color secondaryColor;
  final double frequency;
  final double amplitude;
  final bool isScanningActive;

  const WaveformVisualizer({
    super.key,
    this.height = 80,
    this.width = double.infinity,
    this.primaryColor = AppColors.cyan,
    this.secondaryColor = AppColors.emerald,
    this.frequency = 3.5,
    this.amplitude = 25.0,
    this.isScanningActive = true,
  });

  @override
  State<WaveformVisualizer> createState() => _WaveformVisualizerState();
}

class _WaveformVisualizerState extends State<WaveformVisualizer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.width, widget.height),
          painter: _WaveformPainter(
            time: _controller.value * 2 * math.pi,
            primaryColor: widget.primaryColor,
            secondaryColor: widget.secondaryColor,
            frequency: widget.frequency,
            amplitude: widget.amplitude,
            isActive: widget.isScanningActive,
          ),
        );
      },
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final double time;
  final Color primaryColor;
  final Color secondaryColor;
  final double frequency;
  final double amplitude;
  final bool isActive;

  _WaveformPainter({
    required this.time,
    required this.primaryColor,
    required this.secondaryColor,
    required this.frequency,
    required this.amplitude,
    required this.isActive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final centerY = size.height / 2;

    // Baseline grid center line
    final baseLinePaint = Paint()
      ..color = primaryColor.withOpacity(0.15)
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(0, centerY), Offset(size.width, centerY), baseLinePaint);

    final path1 = Path();
    final path2 = Path();

    final effAmp = isActive ? amplitude : 4.0;

    for (double x = 0; x <= size.width; x += 3) {
      final normalizedX = x / size.width;

      // Primary harmonic wave (RF Pulse modulation)
      final y1 = centerY +
          math.sin(normalizedX * frequency * 2 * math.pi - time * 2) * effAmp * 0.7 +
          math.sin(normalizedX * frequency * 4 * math.pi + time) * (effAmp * 0.3);

      // Secondary phase-shifted harmonic wave
      final y2 = centerY +
          math.cos(normalizedX * frequency * 3 * math.pi + time * 1.5) * (effAmp * 0.5);

      if (x == 0) {
        path1.moveTo(x, y1);
        path2.moveTo(x, y2);
      } else {
        path1.lineTo(x, y1);
        path2.lineTo(x, y2);
      }
    }

    // Draw primary waveform glow
    final glowPaint1 = Paint()
      ..color = primaryColor.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawPath(path1, glowPaint1);

    final linePaint1 = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    canvas.drawPath(path1, linePaint1);

    // Draw secondary harmonic waveform
    final linePaint2 = Paint()
      ..color = secondaryColor.withOpacity(0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawPath(path2, linePaint2);
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) => true;
}
