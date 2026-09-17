import 'package:flutter/material.dart';
import '../models/anatomy_model.dart';
import '../data/anatomy_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../services/app_state_service.dart';
import '../services/localization_service.dart';
import '../services/audio_service.dart';
import '../widgets/common/glass_panel.dart';
import '../widgets/common/hud_header.dart';
import '../widgets/common/glowing_button.dart';
import '../widgets/explore/body_silhouette_scanner.dart';
import 'brain_explorer_screen.dart';

class ExploreScreen extends StatefulWidget {
  final VoidCallback? onNavigateToScan;

  const ExploreScreen({super.key, this.onNavigateToScan});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  AnatomyZone _selectedZone = AnatomyData.zones.first;

  void _openBrainExplorer() {
    SoundService().playSound(SoundEffect.laserBeep);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const BrainExplorerScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;
    final isTh = LocalizationService().isThai;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              HUDHeader(
                title: isTh ? 'แผนที่กายวิภาคศาสตร์มนุษย์' : 'HUMAN ANATOMICAL MAP',
                subtitle: isTh ? 'เลือกโซนอวัยวะเพื่อตรวจสอบแนวทางการถ่ายภาพรังสีและโปรโตคอลการตรวจ' : 'Select anatomical region to inspect imaging pathways and clinical protocols',
                tag: isTh ? 'ศูนย์สำรวจ' : 'EXPLORE HUB',
                accentColor: _selectedZone.accentColor,
                trailing: _selectedZone.id == 'brain'
                    ? GlowingButton(
                        text: isTh ? 'เปิด 3D สมอง' : 'OPEN 3D BRAIN EXPLORER',
                        icon: Icons.biotech_rounded,
                        primaryColor: AppColors.cyan,
                        onPressed: _openBrainExplorer,
                      )
                    : null,
              ),
              const SizedBox(height: 16),

              // Responsive Body Map & Detail Panel
              Expanded(
                child: isDesktop
                    ? Row(
                        children: [
                          // Left: Interactive Silhouette
                          Expanded(
                            flex: 5,
                            child: GlassPanel(
                              padding: const EdgeInsets.all(12),
                              showCornerBrackets: true,
                              child: BodySilhouetteScanner(
                                selectedZone: _selectedZone,
                                onZoneSelected: (zone) => setState(() => _selectedZone = zone),
                                onZoneDoubleTapped: () {
                                  if (_selectedZone.id == 'brain') _openBrainExplorer();
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          // Right: Detailed Anatomical Zone Inspector
                          Expanded(
                            flex: 5,
                            child: _buildZoneDetailPanel(isTh),
                          ),
                        ],
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 380,
                              child: GlassPanel(
                                padding: const EdgeInsets.all(12),
                                showCornerBrackets: true,
                                child: BodySilhouetteScanner(
                                  selectedZone: _selectedZone,
                                  onZoneSelected: (zone) => setState(() => _selectedZone = zone),
                                  onZoneDoubleTapped: () {
                                    if (_selectedZone.id == 'brain') _openBrainExplorer();
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildZoneDetailPanel(isTh),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildZoneDetailPanel(bool isTh) {
    final color = _selectedZone.accentColor;

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
                    _selectedZone.category.toUpperCase(),
                    style: AppTypography.hudLabel.copyWith(color: color, fontSize: 10),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _selectedZone.name,
                    style: AppTypography.titleLarge.copyWith(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: color),
                ),
                child: Text(
                  isTh ? 'โซนที่เลือก' : 'ACTIVE REGION',
                  style: AppTypography.hudLabel.copyWith(color: color, fontSize: 9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            _selectedZone.description,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary, height: 1.5),
          ),
          const SizedBox(height: 16),

          // Primary Modalities Used
          Text(
            isTh ? 'เครื่องมือรังสีวินิจฉัยหลักที่ใช้' : 'PRIMARY IMAGING MODALITIES',
            style: AppTypography.hudLabel.copyWith(fontSize: 9, color: AppColors.textMuted),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: _selectedZone.primaryModalities.map((m) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: color.withOpacity(0.4)),
                ),
                child: Text(
                  m,
                  style: AppTypography.hudValue.copyWith(fontSize: 11, color: Colors.white),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Common Exams
          Text(
            isTh ? 'การตรวจทางรังสีที่พบบ่อย' : 'COMMON RADIOLOGIC EXAMS',
            style: AppTypography.hudLabel.copyWith(fontSize: 9, color: AppColors.textMuted),
          ),
          const SizedBox(height: 6),
          ..._selectedZone.commonExams.map((exam) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Icon(Icons.chevron_right_rounded, size: 14, color: color),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      exam,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11.5),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),

          // Clinical Pearls Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceHighlight.withOpacity(0.6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.cardGlassBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.lightbulb_outline_rounded, color: AppColors.amber, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      isTh ? 'ข้อคิดทางรังสีคลินิก (Clinical Pearl)' : 'CLINICAL RADIOLOGY PEARL',
                      style: AppTypography.hudLabel.copyWith(fontSize: 9, color: AppColors.amber),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _selectedZone.clinicalPearls,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, fontSize: 11, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Radiation Note
          Row(
            children: [
              Icon(Icons.shield_outlined, size: 14, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _selectedZone.radiationSafetyNote,
                  style: AppTypography.hudLabel.copyWith(fontSize: 9, color: AppColors.textMuted),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Action Buttons
          Wrap(
            spacing: 12,
            runSpacing: 10,
            alignment: WrapAlignment.spaceBetween,
            children: [
              if (_selectedZone.id == 'brain')
                GlowingButton(
                  text: isTh ? 'เปิด 3D สมอง' : 'ENTER 3D BRAIN EXPLORER',
                  icon: Icons.blur_on_rounded,
                  primaryColor: AppColors.cyan,
                  onPressed: _openBrainExplorer,
                ),
              GlowingButton(
                text: isTh ? 'เริ่มจำลองการสแกน' : 'START SCAN SIMULATION',
                icon: Icons.play_arrow_rounded,
                primaryColor: color,
                isSecondary: true,
                onPressed: () {
                  AppStateService().setNavigationIndex(2);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
