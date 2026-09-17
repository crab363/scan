import 'package:flutter/material.dart';
import '../models/case_file.dart';
import '../models/imaging_modality.dart';
import '../data/case_files_data.dart';
import '../data/modalities_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../services/app_state_service.dart';
import '../services/localization_service.dart';
import '../services/audio_service.dart';
import '../widgets/common/hud_header.dart';
import '../widgets/common/glass_panel.dart';
import '../widgets/common/glowing_button.dart';
import '../widgets/cases/case_card.dart';
import '../widgets/cases/case_observation_quiz.dart';
import '../widgets/scan/slice_viewer.dart';

class CaseFilesScreen extends StatefulWidget {
  const CaseFilesScreen({super.key});

  @override
  State<CaseFilesScreen> createState() => _CaseFilesScreenState();
}

class _CaseFilesScreenState extends State<CaseFilesScreen> {
  ModalityType? _modalityFilter;

  ImagingModality _getModalityInfo(ModalityType type) {
    return ModalitiesData.modalities.firstWhere(
      (m) => m.type == type,
      orElse: () => ModalitiesData.modalities.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateService();
    final isTh = LocalizationService().isThai;
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;
    final isMobile = size.width < 600;

    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final activeCase = appState.activeCaseFile;
        final answeredChoiceId = appState.caseQuizAnswers[activeCase.id];

        final filteredCases = _modalityFilter == null
            ? CaseFilesData.cases
            : CaseFilesData.cases.where((c) => c.modality == _modalityFilter).toList();

        final answeredCount = CaseFilesData.cases.where((c) => appState.caseQuizAnswers.containsKey(c.id)).length;

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
                    title: 'case_files_title'.tr,
                    subtitle: 'case_files_subtitle'.tr,
                    tag: 'pacs_repository'.tr,
                    accentColor: AppColors.violet,
                    trailing: Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.violet.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.violet.withOpacity(0.5)),
                          ),
                          child: Text(
                            '${'solved_cases'.tr}: $answeredCount / ${CaseFilesData.cases.length}',
                            style: AppTypography.hudLabel.copyWith(color: AppColors.violet, fontSize: 10),
                          ),
                        ),
                        GlowingButton(
                          text: isMobile ? (isTh ? 'สุ่ม' : 'RANDOM') : 'random_case'.tr,
                          icon: Icons.shuffle_rounded,
                          primaryColor: AppColors.violet,
                          secondaryColor: AppColors.magenta,
                          height: 36,
                          onPressed: () {
                            appState.randomizeCaseFile(modalityFilter: _modalityFilter);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Modality Filter Strip
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('${'all_modalities'.tr} (${CaseFilesData.cases.length})', null, AppColors.violet),
                        _buildFilterChip('mri_cases'.tr, ModalityType.mri, AppColors.cyan),
                        _buildFilterChip('ct_cases'.tr, ModalityType.ct, AppColors.emerald),
                        _buildFilterChip('xray_cases'.tr, ModalityType.xray, AppColors.violet),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Case List Carousel
                  SizedBox(
                    height: 124,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredCases.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final c = filteredCases[index];
                        final isSelected = c.id == activeCase.id;
                        final isAnswered = appState.caseQuizAnswers.containsKey(c.id);

                        return SizedBox(
                          width: 270,
                          child: CaseCard(
                            caseFile: c,
                            isSelected: isSelected,
                            isAnswered: isAnswered,
                            onTap: () {
                              appState.setActiveCaseFile(c);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Main Interactive Case Inspector
                  Expanded(
                    child: isDesktop
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left: Clinical Presentation & History
                              Expanded(
                                flex: 4,
                                child: SingleChildScrollView(
                                  child: _buildPatientHistoryPanel(activeCase, isTh),
                                ),
                              ),
                              const SizedBox(width: 18),
                              // Right: Imaging Viewer & Observation Quiz
                              Expanded(
                                flex: 6,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SliceViewer(
                                        modality: _getModalityInfo(activeCase.modality),
                                        title: '${activeCase.caseNumber} • ${activeCase.title}',
                                      ),
                                      const SizedBox(height: 14),
                                      CaseObservationQuiz(
                                        caseFile: activeCase,
                                        answeredChoiceId: answeredChoiceId,
                                        onChoiceSelected: (choiceId, isCorrect) {
                                          appState.recordCaseQuizAnswer(activeCase.id, choiceId, isCorrect);
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                _buildPatientHistoryPanel(activeCase, isTh),
                                const SizedBox(height: 14),
                                SliceViewer(
                                  modality: _getModalityInfo(activeCase.modality),
                                  title: '${activeCase.caseNumber} • ${activeCase.title}',
                                ),
                                const SizedBox(height: 14),
                                CaseObservationQuiz(
                                  caseFile: activeCase,
                                  answeredChoiceId: answeredChoiceId,
                                  onChoiceSelected: (choiceId, isCorrect) {
                                    appState.recordCaseQuizAnswer(activeCase.id, choiceId, isCorrect);
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

  Widget _buildPatientHistoryPanel(CaseFile caseFile, bool isTh) {
    return GlassPanel(
      borderColor: AppColors.violet.withOpacity(0.4),
      padding: const EdgeInsets.all(18),
      showCornerBrackets: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  '${caseFile.caseNumber} DOSSIER',
                  style: AppTypography.hudLabel.copyWith(color: AppColors.violet, fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.violet.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.violet),
                ),
                child: Text(
                  caseFile.anatomyRegion.toUpperCase(),
                  style: AppTypography.hudLabel.copyWith(color: AppColors.violet, fontSize: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(caseFile.title, style: AppTypography.titleMedium.copyWith(fontSize: 16)),
          const SizedBox(height: 4),
          Text(
            '${isTh ? 'ผู้ป่วย' : 'Patient'}: ${caseFile.age} ${isTh ? 'ปี' : 'Years Old'} • ${caseFile.gender}',
            style: AppTypography.hudValue.copyWith(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),

          // Chief Complaint
          Text(
            isTh ? 'อาการสำคัญที่มาโรงพยาบาล (CHIEF COMPLAINT)' : 'CHIEF COMPLAINT',
            style: AppTypography.hudLabel.copyWith(fontSize: 8.5, color: AppColors.textMuted),
          ),
          const SizedBox(height: 3),
          Text(
            caseFile.chiefComplaint,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, height: 1.4, fontSize: 12),
          ),
          const SizedBox(height: 12),

          // Symptoms List
          Text('symptoms_header'.tr, style: AppTypography.hudLabel.copyWith(fontSize: 8.5, color: AppColors.textMuted)),
          const SizedBox(height: 5),
          ...caseFile.symptoms.map((sym) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.arrow_right_rounded, size: 16, color: AppColors.violet),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(sym, style: AppTypography.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textSecondary)),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),

          // Medical History
          Text('medical_history_header'.tr, style: AppTypography.hudLabel.copyWith(fontSize: 8.5, color: AppColors.textMuted)),
          const SizedBox(height: 5),
          ...caseFile.medicalHistory.map((hist) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.history_edu_rounded, size: 14, color: AppColors.textMuted),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(hist, style: AppTypography.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textSecondary)),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 14),

          // Clinical Pearls Card
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
                    const Icon(Icons.school_outlined, size: 16, color: AppColors.amber),
                    const SizedBox(width: 6),
                    Text('pearls_header'.tr, style: AppTypography.hudLabel.copyWith(fontSize: 9, color: AppColors.amber)),
                  ],
                ),
                const SizedBox(height: 6),
                ...caseFile.clinicalPearls.map((pearl) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '• $pearl',
                      style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textPrimary, height: 1.4),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Educational Disclaimer
          Text(
            'disclaimer_note'.tr,
            style: AppTypography.bodySmall.copyWith(fontSize: 8.5, color: AppColors.textMuted, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
