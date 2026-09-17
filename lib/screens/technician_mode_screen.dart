import 'package:flutter/material.dart';
import '../models/imaging_modality.dart';
import '../data/technician_cases_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../services/app_state_service.dart';
import '../services/localization_service.dart';
import '../services/audio_service.dart';
import '../widgets/common/hud_header.dart';
import '../widgets/common/glowing_button.dart';
import '../widgets/technician/workstation_hud.dart';
import '../widgets/technician/technician_decision_card.dart';

class TechnicianModeScreen extends StatefulWidget {
  const TechnicianModeScreen({super.key});

  @override
  State<TechnicianModeScreen> createState() => _TechnicianModeScreenState();
}

class _TechnicianModeScreenState extends State<TechnicianModeScreen> {
  ModalityType? _modalityFilter;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateService();
    final isTh = LocalizationService().isThai;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 650;

    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final activeCase = appState.activeTechnicianCase;
        final score = appState.technicianScore;
        final streak = appState.consecutiveCorrectStreak;
        final decisions = appState.technicianDecisions;
        final selectedChoiceId = decisions[activeCase.id];

        final filteredCases = _modalityFilter == null
            ? TechnicianCasesData.cases
            : TechnicianCasesData.cases.where((c) => c.modality == _modalityFilter).toList();

        final answeredCount = TechnicianCasesData.cases.where((c) => decisions.containsKey(c.id)).length;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 12 : 20,
                vertical: isMobile ? 10 : 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  HUDHeader(
                    title: 'radtech_title'.tr,
                    subtitle: 'radtech_subtitle'.tr,
                    tag: isTh ? 'คอนโซลนักรังสีเทคนิค' : 'RADTECH CONSOLE',
                    accentColor: AppColors.cyan,
                    trailing: Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.cyan.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.cyan),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${'score_label'.tr}: $score PTS',
                                style: AppTypography.hudLabel.copyWith(color: AppColors.cyan, fontSize: 10.5),
                              ),
                              if (streak > 1) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: AppColors.amber.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '🔥 $streak STREAK',
                                    style: AppTypography.hudLabel.copyWith(color: AppColors.amber, fontSize: 8.5),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        GlowingButton(
                          text: isMobile ? (isTh ? 'สุ่ม' : 'RANDOM') : 'random_scenario'.tr,
                          icon: Icons.shuffle_rounded,
                          primaryColor: AppColors.cyan,
                          secondaryColor: AppColors.neonTeal,
                          height: 36,
                          onPressed: () {
                            appState.randomizeTechnicianCase(modalityFilter: _modalityFilter);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Filter Strip & Solved Counter
                  Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildFilterChip('${'all_modalities'.tr} (${TechnicianCasesData.cases.length})', null, AppColors.cyan),
                              _buildFilterChip(isTh ? 'MRI ความปลอดภัยและฟิสิกส์' : 'MRI SAFETY & PHYSICS', ModalityType.mri, AppColors.cyan),
                              _buildFilterChip(isTh ? 'CT โปรโตคอล' : 'CT PROTOCOLS', ModalityType.ct, AppColors.emerald),
                              _buildFilterChip(isTh ? 'เอกซเรย์ดิจิทัล' : 'DIGITAL X-RAY', ModalityType.xray, AppColors.violet),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$answeredCount / ${TechnicianCasesData.cases.length}',
                        style: AppTypography.hudLabel.copyWith(fontSize: 10, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Case Switcher Horizontal Strip
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: filteredCases.map((c) {
                        final isSelected = c.id == activeCase.id;
                        final hasAnswered = decisions.containsKey(c.id);

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            avatar: hasAnswered
                                ? const Icon(Icons.check_circle_rounded, size: 15, color: AppColors.emerald)
                                : null,
                            label: Text(
                              '${c.caseCode} • ${c.title}',
                              style: AppTypography.hudLabel.copyWith(
                                color: isSelected ? AppColors.background : (hasAnswered ? AppColors.emerald : AppColors.textPrimary),
                                fontSize: 9.5,
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: AppColors.cyan,
                            backgroundColor: AppColors.surface,
                            side: BorderSide(
                              color: isSelected ? AppColors.cyan : (hasAnswered ? AppColors.emerald.withOpacity(0.4) : AppColors.cardGlassBorder),
                            ),
                            onSelected: (selected) {
                              if (selected) {
                                appState.setActiveTechnicianCase(c);
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Main Interactive Workstation View
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          WorkstationHUD(
                            techCase: activeCase,
                            isAnswered: selectedChoiceId != null,
                          ),
                          const SizedBox(height: 14),
                          TechnicianDecisionCard(
                            techCase: activeCase,
                            selectedOptionId: selectedChoiceId,
                            onOptionChosen: (optionId, scoreDelta) {
                              appState.recordTechnicianDecision(activeCase.id, optionId, scoreDelta);
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label, ModalityType? modality, Color accentColor) {
    final isSelected = _modalityFilter == modality;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(
          label,
          style: AppTypography.hudLabel.copyWith(
            color: isSelected ? AppColors.background : accentColor,
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        selected: isSelected,
        selectedColor: accentColor,
        backgroundColor: AppColors.surface,
        side: BorderSide(color: isSelected ? accentColor : AppColors.cardGlassBorder),
        onSelected: (selected) {
          if (selected) {
            setState(() => _modalityFilter = modality);
            SoundService().playSound(SoundEffect.uiClick);
          }
        },
      ),
    );
  }
}
