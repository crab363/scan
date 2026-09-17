import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../models/visual_mode_preset.dart';
import '../../services/audio_service.dart';

class ConcertVisualCanvas extends StatefulWidget {
  final VisualEffectSettings settings;
  final bool isInteractive;
  final double beatPulseTrigger; // 0.0 to 1.0 manual or audio pulse

  const ConcertVisualCanvas({
    super.key,
    required this.settings,
    this.isInteractive = true,
    this.beatPulseTrigger = 0.0,
  });

  @override
  State<ConcertVisualCanvas> createState() => _ConcertVisualCanvasState();
}

class _ConcertVisualCanvasState extends State<ConcertVisualCanvas> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  final List<_VisualParticle> _particles = [];
  final List<_TouchRipple> _ripples = [];
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
        vx: (_random.nextDouble() - 0.5) * 0.0016 * widget.settings.scanSpeed,
        vy: (_random.nextDouble() - 0.5) * 0.0016 * widget.settings.scanSpeed,
        radius: _random.nextDouble() * 3.5 + 1.2,
        alpha: _random.nextDouble() * 0.7 + 0.3,
        colorIndex: i % widget.settings.palette.length,
        orbitRadius: _random.nextDouble() * 160 + 40,
        orbitSpeed: (_random.nextDouble() - 0.5) * 0.02,
        orbitAngle: _random.nextDouble() * 2 * math.pi,
      ));
    }
  }

  void _addTouchRipple(Offset pos) {
    if (_ripples.length > 8) _ripples.removeAt(0);
    _ripples.add(_TouchRipple(center: pos, createdAtTime: _animController.value));
    SoundService().playSound(SoundEffect.laserBeep);
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
        // Update ripples
        _ripples.removeWhere((r) => r.progress >= 1.0);
        for (var r in _ripples) {
          r.update();
        }

        return CustomPaint(
          size: Size.infinite,
          painter: _ConcertVisualPainter(
            time: _animController.value * 2 * math.pi,
            settings: widget.settings,
            particles: _particles,
            pointerPos: _pointerPos,
            interactionIntensity: _interactionIntensity,
            ripples: _ripples,
            beatPulse: widget.beatPulseTrigger,
          ),
        );
      },
    );

    if (widget.isInteractive) {
      canvas = GestureDetector(
        onTapDown: (details) {
          _addTouchRipple(details.localPosition);
          setState(() {
            _pointerPos = details.localPosition;
            _interactionIntensity = 1.0;
          });
        },
        onPanUpdate: (details) {
          setState(() {
            _pointerPos = details.localPosition;
            _interactionIntensity = 0.9;
          });
        },
        onPanEnd: (_) {
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

class _TouchRipple {
  final Offset center;
  final double createdAtTime;
  double radius = 10.0;
  double maxRadius = 220.0;
  double opacity = 1.0;

  double get progress => radius / maxRadius;

  _TouchRipple({required this.center, required this.createdAtTime});

  void update() {
    radius += 6.5;
    opacity = (1.0 - progress).clamp(0.0, 1.0);
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

      if (dist < 200 && dist > 1) {
        final force = (200 - dist) / 200 * 0.001;
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
  final List<_TouchRipple> ripples;
  final double beatPulse;

  _ConcertVisualPainter({
    required this.time,
    required this.settings,
    required this.particles,
    required this.pointerPos,
    required this.interactionIntensity,
    required this.ripples,
    required this.beatPulse,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final primaryColor = settings.palette.first;
    final secondaryColor = settings.palette.length > 1 ? settings.palette[1] : primaryColor;
    final accentColor = settings.palette.length > 2 ? settings.palette[2] : primaryColor;

    final pulseScale = 1.0 + (math.sin(time * 2.0).abs() * 0.12 + beatPulse * 0.25) * (settings.isAudioPulseActive ? 1.0 : 0.2);

    // 1. Futuristic Radial Background Glow & Ambient Waves
    final bgGlowPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.95 * pulseScale,
        colors: [
          primaryColor.withOpacity(0.22 * settings.glowIntensity),
          secondaryColor.withOpacity(0.10 * settings.glowIntensity),
          const Color(0xFF03060F),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgGlowPaint);

    // 2. High-Tech Grid Mesh
    if (settings.showGrid) {
      final gridPaint = Paint()
        ..color = primaryColor.withOpacity(0.07 * settings.glowIntensity)
        ..strokeWidth = 1.0;

      const spacing = 45.0;
      for (double x = 0; x < size.width; x += spacing) {
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
      }
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
      }
    }

    // 3. 3D Holographic Brain Wireframe Mesh with Morphing Sulci
    final brainRadius = math.min(size.width, size.height) * 0.24 * pulseScale;
    const brainRings = 10;

    for (int r = 0; r < brainRings; r++) {
      final ringNorm = (r / brainRings);
      final ringR = brainRadius * math.sin(ringNorm * math.pi);
      final ringY = cy - brainRadius * math.cos(ringNorm * math.pi) * 0.85;

      final p = Path();
      const points = 32;
      for (int i = 0; i <= points; i++) {
        final theta = (i / points) * 2 * math.pi;
        final sulci = math.sin(theta * 5 + time * 1.5) * (ringR * 0.1) + math.cos(theta * 7) * (ringR * 0.05);
        final px = cx + math.cos(theta + time * 0.3) * (ringR + sulci);
        final py = ringY + math.sin(theta) * (ringR * 0.3);

        if (i == 0) {
          p.moveTo(px, py);
        } else {
          p.lineTo(px, py);
        }
      }
      p.close();

      final wirePaint = Paint()
        ..color = primaryColor.withOpacity((0.25 + ringNorm * 0.4) * settings.glowIntensity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4;

      canvas.drawPath(p, wirePaint);
    }

    // Central Glowing Synaptic Core
    final coreGlow = Paint()
      ..color = primaryColor.withOpacity(0.4 * settings.glowIntensity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(Offset(cx, cy), 30 * pulseScale, coreGlow);

    // 4. Concentric Waveform Frequency Rings (Concert Audio Pulse)
    if (settings.showWaveformRings) {
      for (int ring = 1; ring <= 3; ring++) {
        final r = brainRadius * (0.8 + ring * 0.45);
        final ringPath = Path();
        const numPoints = 64;

        for (int i = 0; i <= numPoints; i++) {
          final theta = (i / numPoints) * 2 * math.pi;
          final harmonic = math.sin(theta * settings.waveformFrequency + time * 2.0 + ring) * 12.0 * pulseScale;
          final px = cx + math.cos(theta) * (r + harmonic);
          final py = cy + math.sin(theta) * (r + harmonic);

          if (i == 0) {
            ringPath.moveTo(px, py);
          } else {
            ringPath.lineTo(px, py);
          }
        }
        ringPath.close();

        final ringPaint = Paint()
          ..color = (ring % 2 == 0 ? secondaryColor : accentColor).withOpacity(0.35 * settings.glowIntensity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6;

        canvas.drawPath(ringPath, ringPaint);
      }
    }

    // 5. Rotating Sweeping Laser Beams (VJ Scanner)
    final sweepAngle = time * settings.scanSpeed;
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: sweepAngle,
        endAngle: sweepAngle + math.pi * 0.5,
        colors: [
          primaryColor.withOpacity(0.35 * settings.glowIntensity),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: size.width));
    canvas.drawCircle(Offset(cx, cy), math.max(size.width, size.height), sweepPaint);

    // 6. Particle Constellation Network & Swarm
    final particlePaint = Paint()..style = PaintingStyle.fill;
    final linePaint = Paint()..strokeWidth = 0.8;

    for (int i = 0; i < particles.length; i++) {
      final p = particles[i];
      p.update(size, pointerPos, settings.scanSpeed);

      final px = p.x * size.width;
      final py = p.y * size.height;
      final pColor = settings.palette[p.colorIndex % settings.palette.length];

      particlePaint.color = pColor.withOpacity(p.alpha * settings.glowIntensity);
      canvas.drawCircle(Offset(px, py), p.radius * pulseScale, particlePaint);

      // Connect close particles (Constellation mesh)
      for (int j = i + 1; j < math.min(i + 12, particles.length); j++) {
        final p2 = particles[j];
        final p2x = p2.x * size.width;
        final p2y = p2.y * size.height;
        final dx = px - p2x;
        final dy = py - p2y;
        final dist = math.sqrt(dx * dx + dy * dy);

        if (dist < 70) {
          final lineAlpha = (1.0 - (dist / 70)) * 0.3 * settings.glowIntensity;
          linePaint.color = primaryColor.withOpacity(lineAlpha);
          canvas.drawLine(Offset(px, py), Offset(p2x, p2y), linePaint);
        }
      }
    }

    // 7. Interactive Touch Ripple Shockwaves
    for (var ripple in ripples) {
      final ripplePaint = Paint()
        ..color = primaryColor.withOpacity(ripple.opacity * 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;

      canvas.drawCircle(ripple.center, ripple.radius, ripplePaint);

      final outerGlow = Paint()
        ..color = secondaryColor.withOpacity(ripple.opacity * 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6.0
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawCircle(ripple.center, ripple.radius, outerGlow);
    }

    // 8. K-Space Glitch / Chromatic Aberration Burst
    if (settings.glitchAmount > 0.1 && (time % 1.2 < 0.15 || beatPulse > 0.5)) {
      final glitchOffset = settings.glitchAmount * 18.0;
      final glitchPaint = Paint()
        ..color = const Color(0xFFFF0055).withOpacity(0.3)
        ..blendMode = BlendMode.screen;
      canvas.drawRect(Rect.fromLTWH(0, (cy + math.sin(time * 10) * 80) % size.height, size.width, 6), glitchPaint);

      final cyanGlitch = Paint()
        ..color = const Color(0xFF00F2FE).withOpacity(0.3)
        ..blendMode = BlendMode.screen;
      canvas.drawRect(Rect.fromLTWH(0, (cy - math.cos(time * 8) * 80 + glitchOffset) % size.height, size.width, 4), cyanGlitch);
    }
  }

  @override
  bool shouldRepaint(covariant _ConcertVisualPainter oldDelegate) => true;
}
