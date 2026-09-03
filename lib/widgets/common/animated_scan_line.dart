import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class AnimatedScanLine extends StatefulWidget {
  final double height;
  final double width;
  final Color color;
  final Duration duration;
  final bool isVertical; // True = sweeps up/down; False = sweeps left/right

  const AnimatedScanLine({
    super.key,
    this.height = double.infinity,
    this.width = double.infinity,
    this.color = AppColors.cyan,
    this.duration = const Duration(milliseconds: 2400),
    this.isVertical = true,
  });

  @override
  State<AnimatedScanLine> createState() => _AnimatedScanLineState();
}

class _AnimatedScanLineState extends State<AnimatedScanLine> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.width, widget.height),
          painter: _ScanLinePainter(
            progress: _animation.value,
            color: widget.color,
            isVertical: widget.isVertical,
          ),
        );
      },
    );
  }
}

class _ScanLinePainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool isVertical;

  _ScanLinePainter({
    required this.progress,
    required this.color,
    required this.isVertical,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (isVertical) {
      final y = size.height * progress;

      // Trailing gradient glow
      final trailHeight = 40.0;
      final trailPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            color.withOpacity(0.15),
            color.withOpacity(0.0),
          ],
        ).createShader(Rect.fromLTRB(0, y - trailHeight, size.width, y + 10));

      canvas.drawRect(Rect.fromLTRB(0, y - trailHeight, size.width, y + 4), trailPaint);

      // Core Laser Line
      final linePaint = Paint()
        ..color = color.withOpacity(0.95)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 2);

      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);

      // High-intensity laser center
      final centerPaint = Paint()
        ..color = Colors.white
        ..strokeWidth = 1.0;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), centerPaint);
    } else {
      final x = size.width * progress;

      final trailWidth = 40.0;
      final trailPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.transparent,
            color.withOpacity(0.15),
            color.withOpacity(0.0),
          ],
        ).createShader(Rect.fromLTRB(x - trailWidth, 0, x + 10, size.height));

      canvas.drawRect(Rect.fromLTRB(x - trailWidth, 0, x + 4, size.height), trailPaint);

      final linePaint = Paint()
        ..color = color.withOpacity(0.95)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 2);

      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ScanLinePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
