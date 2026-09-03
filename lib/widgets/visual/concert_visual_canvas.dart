import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../models/visual_mode_preset.dart';
import '../../theme/app_colors.dart';


class ConcertVisualCanvas extends StatefulWidget {
  final VisualEffectSettings settings;
  final bool isInteractive;

  const ConcertVisualCanvas({
    super.key,
    required this.settings,
    this.isInteractive = true,
  });

  @override
  State<ConcertVisualCanvas> createState() => _ConcertVisualCanvasState();
}

class _ConcertVisualCanvasState extends State<ConcertVisualCanvas> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  final List<_VisualParticle> _particles = [];
  Offset? _pointerPos;
  double _interactionIntensity = 0.0;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _initParticles();
  }

  void _initParticles() {
    _particles.clear();
    final count = widget.settings.particleDensity.toInt();
    for (int i = 0; i < count; i++) {
      _particles.add(_VisualParticle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        vx: (_random.nextDouble() - 0.5) * 0.0012 * widget.settings.scanSpeed,
        vy: (_random.nextDouble() - 0.5) * 0.0012 * widget.settings.scanSpeed,
        radius: _random.nextDouble() * 3.5 + 1.0,
        alpha: _random.nextDouble() * 0.7 + 0.3,
        colorIndex: i % widget.settings.palette.length,
        orbitRadius: _random.nextDouble() * 160 + 40,
        orbitSpeed: (_random.nextDouble() - 0.5) * 0.02,
        orbitAngle: _random.nextDouble() * 2 * math.pi,
      ));
    }
  }

  @override
  void didUpdateWidget(covariant ConcertVisualCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.settings.preset != widget.settings.preset ||
        oldWidget.settings.particleDensity != widget.settings.particleDensity ||
        oldWidget.settings.scanSpeed != widget.settings.scanSpeed) {
      _initParticles();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget canvas = AnimatedBuilder(
      animation: _animController,
      builder: (context, _) {
        return CustomPaint(
          size: Size.infinite,
          painter: _ConcertVisualPainter(
            time: _animController.value * 2 * math.pi,
            settings: widget.settings,
            particles: _particles,
            pointerPos: _pointerPos,
            interactionIntensity: _interactionIntensity,
          ),
        );
      },
    );

    if (widget.isInteractive) {
      canvas = Listener(
        onPointerHover: (event) {
          setState(() {
            _pointerPos = event.localPosition;
            _interactionIntensity = 0.8;
          });
        },
        onPointerMove: (event) {
          setState(() {
            _pointerPos = event.localPosition;
            _interactionIntensity = 1.0;
          });
        },
        onPointerUp: (_) {
          setState(() {
            _pointerPos = null;
            _interactionIntensity = 0.0;
          });
        },
        child: canvas,
      );
    }

    return canvas;
  }
}

class _VisualParticle {
  double x;
  double y;
  double vx;
  double vy;
  double radius;
  double alpha;
  int colorIndex;
  double orbitRadius;
  double orbitSpeed;
  double orbitAngle;

  _VisualParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
    required this.alpha,
    required this.colorIndex,
    required this.orbitRadius,
    required this.orbitSpeed,
    required this.orbitAngle,
  });

  void update(Size size, Offset? pointer, double scanSpeed) {
    x += vx * scanSpeed;
    y += vy * scanSpeed;

    if (x <= 0 || x >= 1.0) vx = -vx;
    if (y <= 0 || y >= 1.0) vy = -vy;

    orbitAngle += orbitSpeed * scanSpeed;

    if (pointer != null && size.width > 0 && size.height > 0) {
      final px = x * size.width;
      final py = y * size.height;
      final dx = pointer.dx - px;
      final dy = pointer.dy - py;
      final dist = math.sqrt(dx * dx + dy * dy);

      if (dist < 180 && dist > 1) {
        final force = (180 - dist) / 180 * 0.0006;
        vx += (dx / dist) * force;
        vy += (dy / dist) * force;
      }
    }
  }
}

class _ConcertVisualPainter extends CustomPainter {
  final double time;
  final VisualEffectSettings settings;
  final List<_VisualParticle> particles;
  final Offset? pointerPos;
  final double interactionIntensity;

  _ConcertVisualPainter({
    required this.time,
    required this.settings,
    required this.particles,
    required this.pointerPos,
    required this.interactionIntensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final primaryColor = settings.palette.first;
    final secondaryColor = settings.palette.length > 1 ? settings.palette[1] : primaryColor;
    final accentColor = settings.palette.length > 2 ? settings.palette[2] : primaryColor;

    // 1. Futuristic Radial Background Glow & Ambient Waves
    final bgGlowPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.95,
        colors: [
          primaryColor.withOpacity(0.18 * settings.glowIntensity),
          secondaryColor.withOpacity(0.08 * settings.glowIntensity),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgGlowPaint);

    // 2. High-Tech Grid Mesh
    if (settings.showGrid) {
      final gridPaint = Paint()
        ..color = primaryColor.withOpacity(0.06 * settings.glowIntensity)
        ..strokeWidth = 1.0;

      const spacing = 50.0;
      for (double x = 0; x < size.width; x += spacing) {
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
      }
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
      }
    }

    // 3. Central Holographic Medical Wireframe Silhouette (Brain & Orb)
    final brainRadius = math.min(size.width, size.height) * 0.28;
    final brainPath = Path();
    brainPath.addOval(Rect.fromCenter(center: Offset(cx, cy), width: brainRadius * 1.8, height: brainRadius * 2.2));

    final brainGlow = Paint()
      ..color = primaryColor.withOpacity(0.35 * settings.glowIntensity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawPath(brainPath, brainGlow);

    final brainStroke = Paint()
      ..color = primaryColor.withOpacity(0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(brainPath, brainStroke);

    // 4. Concentric Waveform Frequency Rings (Concert Audio Pulse)
    if (settings.showWaveformRings) {
      for (int ring = 1; ring <= 4; ring++) {
        final r = brainRadius * (0.5 + ring * 0.35);
        final ringPath = Path();
        const numPoints = 72;

        for (int i = 0; i <= numPoints; i++) {
          final theta = (i / numPoints) * 2 * math.pi;
          // Harmonic wave distortion
          final waveOffset = math.sin(theta * settings.waveformFrequency + time * (ring % 2 == 0 ? 2 : -2)) * (12.0 * settings.glowIntensity);
          final px = cx + math.cos(theta) * (r + waveOffset);
          final py = cy + math.sin(theta) * (r + waveOffset);

          if (i == 0) {
            ringPath.moveTo(px, py);
          } else {
            ringPath.lineTo(px, py);
          }
        }
        ringPath.close();

        final ringColor = settings.palette[ring % settings.palette.length];
        final ringPaint = Paint()
          ..color = ringColor.withOpacity(0.5 / ring * settings.glowIntensity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6;
        canvas.drawPath(ringPath, ringPaint);
      }
    }

    // 5. Reactive Quantum Particles
    final pPaint = Paint()..style = PaintingStyle.fill;
    final connPaint = Paint()..strokeWidth = 0.8;

    for (int i = 0; i < particles.length; i++) {
      final p = particles[i];
      p.update(size, pointerPos, settings.scanSpeed);

      final px = p.x * size.width;
      final py = p.y * size.height;
      final pColor = settings.palette[p.colorIndex % settings.palette.length];

      pPaint.color = pColor.withOpacity(p.alpha * settings.glowIntensity);
      canvas.drawCircle(Offset(px, py), p.radius, pPaint);

      // Particle Interconnections
      for (int j = i + 1; j < math.min(i + 5, particles.length); j++) {
        final p2 = particles[j];
        final p2x = p2.x * size.width;
        final p2y = p2.y * size.height;
        final dx = px - p2x;
        final dy = py - p2y;
        final dist = math.sqrt(dx * dx + dy * dy);

        if (dist < 100) {
          final alpha = (1.0 - dist / 100) * 0.25 * settings.glowIntensity;
          connPaint.color = pColor.withOpacity(alpha);
          canvas.drawLine(Offset(px, py), Offset(p2x, p2y), connPaint);
        }
      }
    }

    // 6. Laser Scan Sweep Bar with Trail
    final scanY = ((time * 0.5 * settings.scanSpeed) % (2 * math.pi) / (2 * math.pi)) * size.height;
    final laserPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          accentColor.withOpacity(0.15),
          accentColor.withOpacity(0.9 * settings.glowIntensity),
          accentColor.withOpacity(0.15),
          Colors.transparent,
        ],
        stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
      ).createShader(Rect.fromLTRB(0, scanY - 3, size.width, scanY + 3));

    canvas.drawRect(Rect.fromLTRB(0, scanY - 2, size.width, scanY + 2), laserPaint);

    // 7. Chromatic Aberration & Glitch Lines
    if (settings.glitchAmount > 0.05) {
      final glitchRandom = math.Random((time * 60).toInt());
      if (glitchRandom.nextDouble() < settings.glitchAmount) {
        final gy = glitchRandom.nextDouble() * size.height;
        final gh = glitchRandom.nextDouble() * 14 + 4;
        final gOffset = (glitchRandom.nextDouble() - 0.5) * 20;

        final glitchPaint = Paint()
          ..color = (glitchRandom.nextBool() ? AppColors.magenta : AppColors.cyan).withOpacity(0.4)
          ..style = PaintingStyle.fill;

        canvas.drawRect(Rect.fromLTWH(gOffset, gy, size.width, gh), glitchPaint);
      }
    }

    // 8. Dynamic Pointer Ring Ripple
    if (pointerPos != null) {
      final rippleR = 30.0 + (time * 80) % 50;
      final ripplePaint = Paint()
        ..color = primaryColor.withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawCircle(pointerPos!, rippleR, ripplePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConcertVisualPainter oldDelegate) => true;
}
