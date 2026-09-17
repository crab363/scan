import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../services/app_state_service.dart';
import '../services/localization_service.dart';
import '../services/audio_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/common/glass_panel.dart';
import '../widgets/common/glowing_button.dart';
import '../widgets/common/particle_background.dart';
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
    final isTh = LocalizationService().isThai;

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
                                    isTh ? 'ระบบปฏิบัติการรังสีวินิจฉัย • ออนไลน์' : 'SYSTEM VER: 3.4.0 • ONLINE',
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
                      const SizedBox(height: 24),

                      // Main Hero Showcase: Responsive Columns on Desktop, Vertical on Mobile
                      if (isDesktop)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Left Hero Text & CTA
                            Expanded(flex: 5, child: _buildHeroContent(isTh)),
                            const SizedBox(width: 40),
                            // Right Holographic 3D Medical Scan Visualization
                            Expanded(flex: 5, child: _buildHolographicBrainScan()),
                          ],
                        )
                      else
                        Column(
                          children: [
                            _buildHolographicBrainScan(),
                            const SizedBox(height: 24),
                            _buildHeroContent(isTh),
                          ],
                        ),

                      const SizedBox(height: 40),

                      // Feature Highlights Pill Badges
                      _buildFeatureBadges(isTh),

                      const SizedBox(height: 24),
                      Text(
                        isTh ? 'สำรวจ • สแกน • วินิจฉัย • ค้นพบ' : 'EXPLORE • SCAN • DISCOVER',
                        style: AppTypography.hudLabel.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 11,
                          letterSpacing: 3.0,
                        ),
                      ),
                      const SizedBox(height: 16),
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

  Widget _buildHeroContent(bool isTh) {
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
                isTh ? 'ระบบจำลองรังสีวิทยาทางการแพทย์เชิงโต้ตอบ' : 'INTERACTIVE RADIOLOGY EXPERIENCE',
                style: AppTypography.hudLabel.copyWith(fontSize: 9, letterSpacing: 1.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

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
                fontSize: 44,
                letterSpacing: 4.0,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Subtitle Quote
        Text(
          isTh ? '“มองเห็นสิ่งที่สายตามนุษย์ไม่อาจมองเห็นด้วยตาเปล่า”' : '“See what the human eye cannot see.”',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textCyan,
            fontStyle: FontStyle.italic,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 14),

        // Lead Description
        Text(
          isTh
              ? 'ระบบจำลองการทำงานของเครื่องมือรังสีแพทย์ (MRI, CT, Digital X-Ray) และการตรวจวินิจฉัยโรคเสมือนจริง เรียนรู้หลักฟิสิกส์การสร้างภาพ, ส่องดูโครงสร้างกายวิภาคหลายระนาบ (Axial/Sagittal/Coronal), ทดสอบความหนาแน่นเนื้อเยื่อ Hounsfield Units, วิเคราะห์เคสผู้ป่วยฉุกเฉิน และเปลี่ยนภาพสแกนสู่ทัศนศิลป์แห่งอนาคต'
              : 'An immersive interactive medical imaging and radiologic technology simulator. Explore anatomical layers, operate multi-sequence MRI/CT scans, sample Hounsfield units, solve real clinical dilemmas, and transform diagnostic imaging into concert-grade visual art.',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.textSecondary,
            fontSize: 13.5,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),

        // Enter Button
        Wrap(
          spacing: 14,
          runSpacing: 10,
          children: [
            GlowingButton(
              text: isTh ? 'เข้าสู่ห้องสแกน' : 'ENTER SCANVERSE',
              icon: Icons.explore_rounded,
              primaryColor: AppColors.cyan,
              secondaryColor: AppColors.neonTeal,
              height: 48,
              onPressed: () {
                SoundService().playSound(SoundEffect.laserBeep);
                widget.onEnterScanverse();
              },
            ),
            GlowingButton(
              text: isTh ? 'โหมดภาพศิลป์' : 'VISUAL MODE',
              icon: Icons.auto_awesome_motion_rounded,
              primaryColor: AppColors.magenta,
              secondaryColor: AppColors.violet,
              isSecondary: true,
              height: 48,
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
      height: 340,
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
                  size: const Size(double.infinity, 340),
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

            // Telemetry Readouts
            Positioned(
              top: 14,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('3.0T MAGNETOM ISOCENTER', style: AppTypography.hudLabel.copyWith(fontSize: 9.5, color: AppColors.cyan)),
                  Text('AXIAL MULTI-PLANE • REAL-TIME', style: AppTypography.telemetryCode.copyWith(fontSize: 8.5)),
                ],
              ),
            ),

            Positioned(
              bottom: 14,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('DICOM 3.0 / HU ACCURACY', style: AppTypography.hudLabel.copyWith(fontSize: 9.5, color: AppColors.emerald)),
                  Text('512x512 MATRIX RECON', style: AppTypography.telemetryCode.copyWith(fontSize: 8.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureBadges(bool isTh) {
    final features = [
      {'icon': Icons.view_in_ar_rounded, 'title': isTh ? 'สแกน 5 ขั้นตอนเสมือนจริง' : '5-Stage Clinical Simulation', 'color': AppColors.cyan},
      {'icon': Icons.psychology_rounded, 'title': isTh ? 'กายวิภาคหลายระนาบ 3 มิติ' : 'Multiplanar Brain Anatomy', 'color': AppColors.emerald},
      {'icon': Icons.find_in_page_rounded, 'title': isTh ? 'คลังเคสผู้ป่วยและรอยโรค' : 'Clinical PACS Case Files', 'color': AppColors.violet},
      {'icon': Icons.colorize_rounded, 'title': isTh ? 'วัดความหนาแน่นเนื้อเยื่อ HU' : 'Real-time HU Density Probe', 'color': AppColors.amber},
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: features.map((f) {
        final col = f['color'] as Color;
        final icon = f['icon'] as IconData;
        final title = f['title'] as String;

        return GlassPanel(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          borderRadius: 12,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: col, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTypography.hudLabel.copyWith(color: AppColors.textPrimary, fontSize: 10.5),
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
    final cy = size.height / 2;

    // Glowing Holographic Grid Rings
    final gridPaint = Paint()
      ..color = AppColors.cyan.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int r = 30; r < 140; r += 24) {
      canvas.drawCircle(Offset(cx, cy), r.toDouble(), gridPaint);
    }

    // 3D Wireframe Rotating Slices
    for (int i = -6; i <= 6; i++) {
      final yOffset = i * 18.0;
      final radScale = math.cos((i / 7.0) * (math.pi / 2));
      if (radScale <= 0) continue;

      final rotAngle = time + (i * 0.15);
      final rx = (85 * radScale) * math.cos(rotAngle).abs().clamp(0.4, 1.0);
      final ry = (40 * radScale);

      final slicePaint = Paint()
        ..color = Color.lerp(AppColors.cyan, AppColors.violet, (i + 6) / 12.0)!.withOpacity(0.4 + (radScale * 0.3))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2;

      canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, cy + yOffset), width: rx * 2, height: ry * 2),
        slicePaint,
      );
    }

    // Core Glowing Ventricular Nodes
    final corePaint = Paint()
      ..color = AppColors.cyan.withOpacity(0.8)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(cx, cy), 16, corePaint);
  }

  @override
  bool shouldRepaint(covariant _HolographicBrainPainter oldDelegate) => true;
}
