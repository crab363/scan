import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../services/app_state_service.dart';
import '../services/audio_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/common/glass_panel.dart';
import '../widgets/common/glowing_button.dart';
import '../widgets/common/particle_background.dart';
import '../widgets/common/waveform_visualizer.dart';
import '../widgets/common/animated_scan_line.dart';
import '../widgets/common/audio_equalizer_hud.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onEnterScanverse;

  const HomeScreen({super.key, required this.onEnterScanverse});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _brainMeshController;

  @override
  void initState() {
    super.initState();
    _brainMeshController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _brainMeshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Particle & Grid System
          const ParticleBackground(
            particleCount: 50,
            primaryColor: AppColors.cyan,
            secondaryColor: AppColors.violet,
            showGrid: true,
          ),

          // Main Interactive Layout
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Top Bar HUD
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 9,
                                  height: 9,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.cyan,
                                    boxShadow: [
                                      BoxShadow(color: AppColors.cyan.withOpacity(0.8), blurRadius: 8),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    'SYSTEM VER: 3.4.0 • ONLINE',
                                    style: AppTypography.hudLabel.copyWith(fontSize: 9.5),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const AudioEqualizerHUD(),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Main Hero Showcase: Responsive Columns on Desktop, Vertical on Mobile
                      if (isDesktop)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Left Hero Text & CTA
                            Expanded(flex: 5, child: _buildHeroContent()),
                            const SizedBox(width: 40),
                            // Right Holographic 3D Medical Scan Visualization
                            Expanded(flex: 5, child: _buildHolographicBrainScan()),
                          ],
                        )
                      else
                        Column(
                          children: [
                            _buildHolographicBrainScan(),
                            const SizedBox(height: 30),
                            _buildHeroContent(),
                          ],
                        ),

                      const SizedBox(height: 50),

                      // Feature Highlights Pill Badges
                      _buildFeatureBadges(),

                      const SizedBox(height: 30),
                      Text(
                        'EXPLORE • SCAN • DISCOVER',
                        style: AppTypography.hudLabel.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 11,
                          letterSpacing: 4.0,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.cyan.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.cyan.withOpacity(0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.blur_on_rounded, color: AppColors.cyan, size: 14),
              const SizedBox(width: 6),
              Text(
                'INTERACTIVE RADIOLOGY EXPERIENCE',
                style: AppTypography.hudLabel.copyWith(fontSize: 9, letterSpacing: 2.0),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Hero Main Title
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: ShaderMask(
            shaderCallback: (bounds) => AppColors.cyanTealGradient.createShader(bounds),
            child: Text(
              'SCANVERSE',
              style: AppTypography.heroTitle.copyWith(
                color: Colors.white,
                fontSize: 48,
                letterSpacing: 6.0,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Subtitle Quote
        Text(
          '“See what the human eye cannot see.”',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textCyan,
            fontStyle: FontStyle.italic,
            fontSize: 18,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 16),

        // Lead Description
        Text(
          'An immersive interactive medical imaging and radiologic technology simulator. Explore anatomical layers, operate multi-sequence MRI/CT scans, solve real clinical dilemmas, and transform diagnostic imaging into concert-grade visual art.',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 30),

        // Enter Button
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: [
            GlowingButton(
              text: 'ENTER SCANVERSE',
              icon: Icons.explore_rounded,
              primaryColor: AppColors.cyan,
              secondaryColor: AppColors.neonTeal,
              height: 54,
              onPressed: () {
                SoundService().playSound(SoundEffect.laserBeep);
                widget.onEnterScanverse();
              },
            ),
            GlowingButton(
              text: 'VISUAL MODE',
              icon: Icons.auto_awesome_motion_rounded,
              primaryColor: AppColors.magenta,
              secondaryColor: AppColors.violet,
              isSecondary: true,
              height: 54,
              onPressed: () {
                AppStateService().setNavigationIndex(5);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHolographicBrainScan() {
    return Container(
      height: 360,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardGlassBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withOpacity(0.12),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 3D Animated Brain Mesh Painter
            AnimatedBuilder(
              animation: _brainMeshController,
              builder: (context, _) {
                return CustomPaint(
                  size: const Size(double.infinity, 360),
                  painter: _HolographicBrainPainter(
                    time: _brainMeshController.value * 2 * math.pi,
                  ),
                );
              },
            ),

            // Animated Laser Scanning Line
            const Positioned.fill(
              child: AnimatedScanLine(
                color: AppColors.cyan,
                duration: Duration(milliseconds: 2200),
              ),
            ),

            // Real-time Waveform at Bottom of Card
            Positioned(
              bottom: 12,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('RF FREQUENCY: 127.7 MHz (3.0T LARMOR)', style: AppTypography.hudLabel.copyWith(fontSize: 8)),
                      Text('PHASE COHERENCE: 99.4%', style: AppTypography.hudLabel.copyWith(fontSize: 8, color: AppColors.emerald)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const WaveformVisualizer(
                    height: 36,
                    primaryColor: AppColors.cyan,
                    secondaryColor: AppColors.emerald,
                    frequency: 5.0,
                    amplitude: 14.0,
                  ),
                ],
              ),
            ),

            // Top Telemetry Tag
            Positioned(
              top: 14,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.background.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.cardGlassBorder),
                ),
                child: Text(
                  'BRAIN VOLUMETRIC MRI • ISO-CENTER',
                  style: AppTypography.hudLabel.copyWith(fontSize: 9, color: AppColors.cyan),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureBadges() {
    final features = [
      {'title': 'ANATOMY EXPLORER', 'desc': 'Interactive 3D Lobes & Body Map', 'icon': Icons.accessibility_new_rounded, 'color': AppColors.cyan},
      {'title': '5-STAGE SCANNER', 'desc': 'MRI • CT • Digital X-Ray', 'icon': Icons.view_in_ar_rounded, 'color': AppColors.emerald},
      {'title': 'RADTECH WORKSTATION', 'desc': 'Clinical Decision Dilemmas', 'icon': Icons.psychology_rounded, 'color': AppColors.amber},
      {'title': 'MYSTERY CASES', 'desc': 'Multi-slice Diagnostic Pearls', 'icon': Icons.find_in_page_rounded, 'color': AppColors.violet},
      {'title': 'CONCERT VISUALS', 'desc': 'Stage-Grade LED Media Canvas', 'icon': Icons.auto_awesome_motion_rounded, 'color': AppColors.magenta},
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: features.map((f) {
        final color = f['color'] as Color;

        return GlassPanel(
          borderColor: color.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          borderRadius: 12,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(f['icon'] as IconData, color: color, size: 20),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(f['title'] as String, style: AppTypography.hudLabel.copyWith(color: color, fontSize: 10)),
                  const SizedBox(height: 2),
                  Text(f['desc'] as String, style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _HolographicBrainPainter extends CustomPainter {
  final double time;

  _HolographicBrainPainter({required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2 - 10;
    final radius = math.min(size.width, size.height) * 0.32;

    // Outer Target Rings
    final ringPaint = Paint()
      ..color = AppColors.cyan.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(Offset(cx, cy), radius * 1.25, ringPaint);
    canvas.drawCircle(Offset(cx, cy), radius * 1.45, ringPaint..color = AppColors.cyan.withOpacity(0.08));

    // Rotating Holographic Orbit Dots
    final dotPaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 8; i++) {
      final angle = time * 0.5 + i * (math.pi / 4);
      final dx = cx + math.cos(angle) * (radius * 1.25);
      final dy = cy + math.sin(angle) * (radius * 1.25);
      dotPaint.color = i % 2 == 0 ? AppColors.cyan : AppColors.emerald;
      canvas.drawCircle(Offset(dx, dy), 2.5, dotPaint);
    }

    // 3D Wireframe Brain Mesh
    const rings = 12;


    for (int r = 0; r < rings; r++) {
      final ringNorm = (r / rings);
      final ringR = radius * math.sin(ringNorm * math.pi);
      final ringY = cy - radius * math.cos(ringNorm * math.pi) * 0.8;

      final p = Path();
      const points = 32;
      for (int i = 0; i <= points; i++) {
        final theta = (i / points) * 2 * math.pi;
        // Morphing harmonic waves for biological organic brain shape
        final sulci = math.sin(theta * 4 + time) * (ringR * 0.08) + math.cos(theta * 6) * (ringR * 0.04);
        final px = cx + math.cos(theta + time * 0.2) * (ringR + sulci);
        final py = ringY + math.sin(theta) * (ringR * 0.25);

        if (i == 0) {
          p.moveTo(px, py);
        } else {
          p.lineTo(px, py);
        }
      }
      p.close();

      final wirePaint = Paint()
        ..color = AppColors.cyan.withOpacity(0.25 + ringNorm * 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      canvas.drawPath(p, wirePaint);
    }

    // Central Glowing Neural Core
    final coreGlow = Paint()
      ..color = AppColors.cyan.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
    canvas.drawCircle(Offset(cx, cy), 24, coreGlow);
  }

  @override
  bool shouldRepaint(covariant _HolographicBrainPainter oldDelegate) => true;
}
