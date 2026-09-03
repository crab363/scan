import 'package:flutter/material.dart';
import '../models/technician_case.dart';
import '../data/technician_cases_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../services/app_state_service.dart';
import '../services/audio_service.dart';
import '../widgets/common/hud_header.dart';
import '../widgets/common/glass_panel.dart';
import '../widgets/technician/workstation_hud.dart';
import '../widgets/technician/technician_decision_card.dart';

class TechnicianModeScreen extends StatefulWidget {
  const TechnicianModeScreen({super.key});

  @override
  State<TechnicianModeScreen> createState() => _TechnicianModeScreenState();
}

class _TechnicianModeScreenState extends State<TechnicianModeScreen> {
  TechnicianCase _activeCase = TechnicianCasesData.cases.first;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateService();

    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final score = appState.technicianScore;
        final decisions = appState.technicianDecisions;
        final selectedChoiceId = decisions[_activeCase.id];

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
                    title: 'TECHNICIAN WORKSTATION SIMULATOR',
                    subtitle: 'Play the role of a Radiologic Technologist: Quality Assurance & Decision Making',
                    tag: 'RADTECH CONSOLE',
                    accentColor: AppColors.cyan,
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.cyan.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.cyan),
                      ),
                      child: Text(
                        'TOTAL SCORE: $score PTS',
                        style: AppTypography.hudLabel.copyWith(color: AppColors.cyan, fontSize: 11),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Case Switcher Strip
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: TechnicianCasesData.cases.map((c) {
                        final isSelected = c.id == _activeCase.id;
                        final hasAnswered = decisions.containsKey(c.id);

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            avatar: hasAnswered
                                ? const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.emerald)
                                : null,
                            label: Text(
                              '${c.caseCode} • ${c.modality.name.toUpperCase()}',
                              style: AppTypography.hudLabel.copyWith(
                                color: isSelected ? AppColors.background : AppColors.cyan,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: AppColors.cyan,
                            backgroundColor: AppColors.surface,
                            side: BorderSide(color: isSelected ? AppColors.cyan : AppColors.cardGlassBorder),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() => _activeCase = c);
                                SoundService().playSound(SoundEffect.uiClick);
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Main Workstation & Decision Views
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          WorkstationHUD(
                            techCase: _activeCase,
                            currentScore: score,
                          ),
                          const SizedBox(height: 16),
                          TechnicianDecisionCard(
                            techCase: _activeCase,
                            selectedOptionId: selectedChoiceId,
                            onOptionChosen: (optionId, scoreDelta) {
                              appState.recordTechnicianDecision(_activeCase.id, optionId, scoreDelta);
                            },
                          ),
                          const SizedBox(height: 16),

                          // Competencies Tested Grid
                          GlassPanel(
                            padding: const EdgeInsets.all(16),
                            borderRadius: 12,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('RADTECH PROFESSIONAL COMPETENCIES TESTED', style: AppTypography.hudLabel.copyWith(fontSize: 9, color: AppColors.textMuted)),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 6,
                                  children: _activeCase.radTechCompetenciesTested.map((comp) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceHighlight,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: AppColors.cardGlassBorder),
                                      ),
                                      child: Text(
                                        comp,
                                        style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.textSecondary),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
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
}
