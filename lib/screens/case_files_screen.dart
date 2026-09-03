import 'package:flutter/material.dart';
import '../models/case_file.dart';
import '../models/imaging_modality.dart';
import '../data/case_files_data.dart';
import '../data/modalities_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../services/app_state_service.dart';
import '../services/audio_service.dart';
import '../widgets/common/hud_header.dart';
import '../widgets/common/glass_panel.dart';
import '../widgets/cases/case_card.dart';
import '../widgets/cases/case_observation_quiz.dart';
import '../widgets/scan/slice_viewer.dart';

class CaseFilesScreen extends StatefulWidget {
  const CaseFilesScreen({super.key});

  @override
  State<CaseFilesScreen> createState() => _CaseFilesScreenState();
}

class _CaseFilesScreenState extends State<CaseFilesScreen> {
  CaseFile _selectedCase = CaseFilesData.cases.first;

  ImagingModality _getModalityInfo(ModalityType type) {
    return ModalitiesData.modalities.firstWhere(
      (m) => m.type == type,
      orElse: () => ModalitiesData.modalities.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateService();
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final answeredChoiceId = appState.caseQuizAnswers[_selectedCase.id];

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
                    title: 'DIAGNOSTIC CASE FILES ARCHIVE',
                    subtitle: 'Investigate clinical histories, analyze multi-slice scans, and identify radiologic anomalies',
                    tag: 'PACS REPOSITORY',
                    accentColor: AppColors.violet,
                  ),
                  const SizedBox(height: 14),

                  // Case List Carousel / Horizontal Selector
                  SizedBox(
                    height: 110,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: CaseFilesData.cases.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final c = CaseFilesData.cases[index];
                        final isSelected = c.id == _selectedCase.id;

                        return SizedBox(
                          width: 260,
                          child: CaseCard(
                            caseFile: c,
                            isSelected: isSelected,
                            onTap: () {
                              setState(() => _selectedCase = c);
                              SoundService().playSound(SoundEffect.uiClick);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

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
                                  child: _buildPatientHistoryPanel(),
                                ),
                              ),
                              const SizedBox(width: 20),
                              // Right: Imaging Viewer & Observation Quiz
                              Expanded(
                                flex: 6,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SliceViewer(
                                        modality: _getModalityInfo(_selectedCase.modality),
                                        title: '${_selectedCase.caseNumber} • ${_selectedCase.title}',
                                      ),
                                      const SizedBox(height: 16),
                                      CaseObservationQuiz(
                                        caseFile: _selectedCase,
                                        answeredChoiceId: answeredChoiceId,
                                        onChoiceSelected: (choiceId, isCorrect) {
                                          appState.recordCaseQuizAnswer(_selectedCase.id, choiceId, isCorrect);
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
                                _buildPatientHistoryPanel(),
                                const SizedBox(height: 16),
                                SliceViewer(
                                  modality: _getModalityInfo(_selectedCase.modality),
                                  title: '${_selectedCase.caseNumber} • ${_selectedCase.title}',
                                ),
                                const SizedBox(height: 16),
                                CaseObservationQuiz(
                                  caseFile: _selectedCase,
                                  answeredChoiceId: answeredChoiceId,
                                  onChoiceSelected: (choiceId, isCorrect) {
                                    appState.recordCaseQuizAnswer(_selectedCase.id, choiceId, isCorrect);
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

  Widget _buildPatientHistoryPanel() {
    return GlassPanel(
      borderColor: AppColors.violet.withOpacity(0.4),
      padding: const EdgeInsets.all(20),
      showCornerBrackets: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${_selectedCase.caseNumber} DOSSIER', style: AppTypography.hudLabel.copyWith(color: AppColors.violet, fontSize: 10)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.violet.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.violet),
                ),
                child: Text(
                  _selectedCase.anatomyRegion.toUpperCase(),
                  style: AppTypography.hudLabel.copyWith(color: AppColors.violet, fontSize: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(_selectedCase.title, style: AppTypography.titleMedium.copyWith(fontSize: 18)),
          const SizedBox(height: 4),
          Text(
            'Patient: ${_selectedCase.age} Years Old • ${_selectedCase.gender}',
            style: AppTypography.hudValue.copyWith(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 14),

          // Chief Complaint
          Text('CHIEF COMPLAINT', style: AppTypography.hudLabel.copyWith(fontSize: 9, color: AppColors.textMuted)),
          const SizedBox(height: 4),
          Text(
            _selectedCase.chiefComplaint,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, height: 1.4),
          ),
          const SizedBox(height: 14),

          // Symptoms List
          Text('CLINICAL PRESENTATION & SYMPTOMS', style: AppTypography.hudLabel.copyWith(fontSize: 9, color: AppColors.textMuted)),
          const SizedBox(height: 6),
          ..._selectedCase.symptoms.map((sym) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.arrow_right_rounded, size: 16, color: AppColors.violet),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(sym, style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textSecondary)),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 14),

          // Medical History
          Text('RELEVANT MEDICAL HISTORY', style: AppTypography.hudLabel.copyWith(fontSize: 9, color: AppColors.textMuted)),
          const SizedBox(height: 6),
          ..._selectedCase.medicalHistory.map((hist) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.history_edu_rounded, size: 14, color: AppColors.textMuted),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(hist, style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textSecondary)),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),

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
                    const Icon(Icons.school_outlined, size: 14, color: AppColors.amber),
                    const SizedBox(width: 6),
                    Text('HIGH-YIELD RADIOLOGIC PEARLS', style: AppTypography.hudLabel.copyWith(fontSize: 9, color: AppColors.amber)),
                  ],
                ),
                const SizedBox(height: 6),
                ..._selectedCase.clinicalPearls.map((pearl) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '• $pearl',
                      style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.textPrimary),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Educational Disclaimer
          Text(
            _selectedCase.disclaimer,
            style: AppTypography.bodySmall.copyWith(fontSize: 9, color: AppColors.textMuted, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
