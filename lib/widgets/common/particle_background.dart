import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class ParticleBackground extends StatefulWidget {
  final int particleCount;
  final Color primaryColor;
  final Color secondaryColor;
  final bool enableTouchReaction;
  final bool showGrid;
  final double speedMultiplier;
  final Widget? child;

  const ParticleBackground({
    super.key,
    this.particleCount = 55,
    this.primaryColor = AppColors.cyan,
    this.secondaryColor = AppColors.emerald,
    this.enableTouchReaction = true,
    this.showGrid = true,
    this.speedMultiplier = 1.0,
    this.child,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  Offset? _touchPosition;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _initParticles();
  }

  void _initParticles() {
    _particles.clear();
    for (int i = 0; i < widget.particleCount; i++) {
      _particles.add(_Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        vx: (_random.nextDouble() - 0.5) * 0.0006 * widget.speedMultiplier,
        vy: (_random.nextDouble() - 0.5) * 0.0006 * widget.speedMultiplier,
        radius: _random.nextDouble() * 2.2 + 0.8,
        alpha: _random.nextDouble() * 0.6 + 0.2,
        isSecondary: _random.nextBool(),
      ));
    }
  }

  @override
  void didUpdateWidget(covariant ParticleBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.particleCount != widget.particleCount || oldWidget.speedMultiplier != widget.speedMultiplier) {
      _initParticles();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget canvasWidget = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _ParticlePainter(
            particles: _particles,
            primaryColor: widget.primaryColor,
            secondaryColor: widget.secondaryColor,
            touchPos: _touchPosition,
            showGrid: widget.showGrid,
          ),
        );
      },
    );

    if (widget.enableTouchReaction) {
      canvasWidget = Listener(
        onPointerHover: (event) {
          setState(() {
            _touchPosition = event.localPosition;
          });
        },
        onPointerMove: (event) {
          setState(() {
            _touchPosition = event.localPosition;
          });
        },
        onPointerUp: (_) {
          setState(() {
            _touchPosition = null;
          });
        },
        child: canvasWidget,
      );
    }

    if (widget.child != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          canvasWidget,
          widget.child!,
        ],
      );
    }

    return canvasWidget;
  }
}

class _Particle {
  double x;
  double y;
  double vx;
  double vy;
  double radius;
  double alpha;
  bool isSecondary;

  _Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
    required this.alpha,
    required this.isSecondary,
  });

  void update(Size size, Offset? touchPos) {
    x += vx;
    y += vy;

    // Bounce off walls
    if (x <= 0 || x >= 1.0) vx = -vx;
    if (y <= 0 || y >= 1.0) vy = -vy;

    x = x.clamp(0.0, 1.0);
    y = y.clamp(0.0, 1.0);

    // Gravity attraction / deflection near touch pointer
    if (touchPos != null && size.width > 0 && size.height > 0) {
      final px = x * size.width;
      final py = y * size.height;
      final dx = touchPos.dx - px;
      final dy = touchPos.dy - py;
      final dist = math.sqrt(dx * dx + dy * dy);

      if (dist < 120 && dist > 1) {
        final force = (120 - dist) / 120 * 0.0003;
        vx += (dx / dist) * force;
        vy += (dy / dist) * force;
      }
    }
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final Color primaryColor;
  final Color secondaryColor;
  final Offset? touchPos;
  final bool showGrid;

  _ParticlePainter({
    required this.particles,
    required this.primaryColor,
    required this.secondaryColor,
    required this.touchPos,
    required this.showGrid,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) return;

    // Optional Sci-Fi Grid lines
    if (showGrid) {
      final gridPaint = Paint()
        ..color = primaryColor.withOpacity(0.035)
        ..strokeWidth = 0.8;

      const step = 48.0;
      for (double x = 0; x < size.width; x += step) {
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
      }
      for (double y = 0; y < size.height; y += step) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
      }
    }

    final pPaintPrimary = Paint()..style = PaintingStyle.fill;
    final pPaintSecondary = Paint()..style = PaintingStyle.fill;
    final linePaint = Paint()..strokeWidth = 0.6;

    // Update & draw particles
    for (int i = 0; i < particles.length; i++) {
      final p = particles[i];
      p.update(size, touchPos);

      final px = p.x * size.width;
      final py = p.y * size.height;

      final color = p.isSecondary ? secondaryColor : primaryColor;
      final paint = p.isSecondary ? pPaintSecondary : pPaintPrimary;
      paint.color = color.withOpacity(p.alpha);

      canvas.drawCircle(Offset(px, py), p.radius, paint);

      // Constellation connection lines
      for (int j = i + 1; j < particles.length; j++) {
        final p2 = particles[j];
        final p2x = p2.x * size.width;
        final p2y = p2.y * size.height;
        final dx = px - p2x;
        final dy = py - p2y;
        final dist = math.sqrt(dx * dx + dy * dy);

        if (dist < 85) {
          final lineAlpha = (1.0 - dist / 85) * 0.18;
          linePaint.color = primaryColor.withOpacity(lineAlpha);
          canvas.drawLine(Offset(px, py), Offset(p2x, p2y), linePaint);
        }
      }
    }

    // Touch ring glow
    if (touchPos != null) {
      final touchGlow = Paint()
        ..color = primaryColor.withOpacity(0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawCircle(touchPos!, 35, touchGlow);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
