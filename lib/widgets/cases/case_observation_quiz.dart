import 'package:flutter/material.dart';
import '../../models/case_file.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../services/localization_service.dart';
import '../common/glass_panel.dart';

class CaseObservationQuiz extends StatefulWidget {
  final CaseFile caseFile;
  final String? answeredChoiceId;
  final Function(String choiceId, bool isCorrect) onChoiceSelected;

  const CaseObservationQuiz({
    super.key,
    required this.caseFile,
    this.answeredChoiceId,
    required this.onChoiceSelected,
  });

  @override
  State<CaseObservationQuiz> createState() => _CaseObservationQuizState();
}

class _CaseObservationQuizState extends State<CaseObservationQuiz> {
  String? _selectedChoiceId;

  @override
  void initState() {
    super.initState();
    _selectedChoiceId = widget.answeredChoiceId;
  }

  @override
  void didUpdateWidget(covariant CaseObservationQuiz oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.caseFile.id != widget.caseFile.id) {
      _selectedChoiceId = widget.answeredChoiceId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTh = LocalizationService().isThai;
    final hasAnswered = _selectedChoiceId != null;
    final chosenChoice = hasAnswered
        ? widget.caseFile.observationChoices.firstWhere(
            (c) => c.id == _selectedChoiceId,
            orElse: () => widget.caseFile.observationChoices.first,
          )
        : null;

    return GlassPanel(
      borderColor: AppColors.cyan.withOpacity(0.4),
      padding: const EdgeInsets.all(20),
      showCornerBrackets: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.cyan.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.cyan),
                ),
                child: const Icon(Icons.remove_red_eye_outlined, color: AppColors.cyan, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('quiz_header'.tr, style: AppTypography.hudLabel.copyWith(fontSize: 10)),
                    const SizedBox(height: 2),
                    Text(
                      widget.caseFile.quizQuestion,
                      style: AppTypography.titleMedium.copyWith(fontSize: 14.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Observation Options
          ...widget.caseFile.observationChoices.map((choice) {
            final isSelected = _selectedChoiceId == choice.id;

            Color borderColor = AppColors.cardGlassBorder;
            Color bgColor = AppColors.surface.withOpacity(0.5);

            if (hasAnswered) {
              if (choice.isCorrect) {
                borderColor = AppColors.emerald;
                bgColor = AppColors.emerald.withOpacity(0.12);
              } else if (isSelected && !choice.isCorrect) {
                borderColor = AppColors.alertRed;
                bgColor = AppColors.alertRed.withOpacity(0.12);
              }
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: MouseRegion(
                cursor: hasAnswered ? SystemMouseCursors.basic : SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    if (!hasAnswered) {
                      setState(() => _selectedChoiceId = choice.id);
                      widget.onChoiceSelected(choice.id, choice.isCorrect);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderColor, width: isSelected ? 2.0 : 1.0),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          hasAnswered
                              ? (choice.isCorrect
                                  ? Icons.check_circle_rounded
                                  : (isSelected ? Icons.cancel_rounded : Icons.radio_button_unchecked_rounded))
                              : (isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded),
                          color: hasAnswered
                              ? (choice.isCorrect ? AppColors.emerald : (isSelected ? AppColors.alertRed : AppColors.textMuted))
                              : (isSelected ? AppColors.cyan : AppColors.textMuted),
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            choice.text,
                            style: AppTypography.bodySmall.copyWith(
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),

          // Educational Explanation & Findings
          if (hasAnswered && chosenChoice != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: (chosenChoice.isCorrect ? AppColors.emerald : AppColors.alertRed).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: (chosenChoice.isCorrect ? AppColors.emerald : AppColors.alertRed).withOpacity(0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chosenChoice.isCorrect
                        ? (isTh ? 'การวิเคราะห์ภาพถูกต้องแม่นยำ (CORRECT)' : 'ACCURATE OBSERVATION')
                        : (isTh ? 'ข้อเสนอแนะและคำอธิบายทางการแพทย์ (FEEDBACK)' : 'EDUCATIONAL FEEDBACK'),
                    style: AppTypography.hudLabel.copyWith(
                      color: chosenChoice.isCorrect ? AppColors.emerald : AppColors.alertRed,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chosenChoice.explanation,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, fontSize: 12, height: 1.4),
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Color(0x1F00F2FE)),
                  const SizedBox(height: 8),
                  Text('findings_header'.tr, style: AppTypography.hudLabel.copyWith(fontSize: 9, color: AppColors.cyan)),
                  const SizedBox(height: 2),
                  Text(
                    widget.caseFile.definitiveFindings,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.caseFile.radiologicExplanation,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
