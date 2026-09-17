import 'package:flutter/material.dart';
import '../../models/technician_case.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../services/localization_service.dart';
import '../common/glass_panel.dart';

class TechnicianDecisionCard extends StatefulWidget {
  final TechnicianCase techCase;
  final String? selectedOptionId;
  final Function(String optionId, int scoreDelta) onOptionChosen;

  const TechnicianDecisionCard({
    super.key,
    required this.techCase,
    this.selectedOptionId,
    required this.onOptionChosen,
  });

  @override
  State<TechnicianDecisionCard> createState() => _TechnicianDecisionCardState();
}

class _TechnicianDecisionCardState extends State<TechnicianDecisionCard> {
  String? _chosenOptionId;

  @override
  void initState() {
    super.initState();
    _chosenOptionId = widget.selectedOptionId;
  }

  @override
  void didUpdateWidget(covariant TechnicianDecisionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.techCase.id != widget.techCase.id) {
      _chosenOptionId = widget.selectedOptionId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTh = LocalizationService().isThai;
    final hasChosen = _chosenOptionId != null;
    final chosenOption = hasChosen
        ? widget.techCase.options.firstWhere((o) => o.id == _chosenOptionId, orElse: () => widget.techCase.options.first)
        : null;

    return GlassPanel(
      borderColor: AppColors.cyan.withOpacity(0.4),
      padding: const EdgeInsets.all(20),
      showCornerBrackets: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dilemma Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.cyan.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.cyan),
                ),
                child: const Icon(Icons.help_outline_rounded, color: AppColors.cyan, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('dilemma_prompt'.tr, style: AppTypography.hudLabel.copyWith(fontSize: 10)),
                    const SizedBox(height: 2),
                    Text(
                      widget.techCase.dilemmaQuestion,
                      style: AppTypography.titleMedium.copyWith(fontSize: 15.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Action Choices
          ...widget.techCase.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = _chosenOptionId == option.id;

            Color borderColor = AppColors.cardGlassBorder;
            Color bgColor = AppColors.surface.withOpacity(0.6);

            if (hasChosen) {
              if (option.isOptimal) {
                borderColor = AppColors.emerald;
                bgColor = AppColors.emerald.withOpacity(0.12);
              } else if (isSelected && !option.isOptimal) {
                borderColor = AppColors.alertRed;
                bgColor = AppColors.alertRed.withOpacity(0.12);
              }
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: MouseRegion(
                cursor: hasChosen ? SystemMouseCursors.basic : SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    if (!hasChosen) {
                      setState(() => _chosenOptionId = option.id);
                      widget.onOptionChosen(option.id, option.scoreDelta);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor, width: isSelected ? 2.0 : 1.0),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: borderColor.withOpacity(0.4),
                            blurRadius: 12,
                          ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? (option.isOptimal ? AppColors.emerald : AppColors.alertRed) : AppColors.surfaceHighlight,
                            border: Border.all(color: borderColor),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: AppTypography.hudLabel.copyWith(
                                color: isSelected ? AppColors.background : AppColors.textPrimary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                option.title,
                                style: AppTypography.titleMedium.copyWith(
                                  fontSize: 14,
                                  color: isSelected ? (option.isOptimal ? AppColors.emerald : AppColors.alertRed) : AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                option.actionDescription,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (hasChosen)
                          Icon(
                            option.isOptimal ? Icons.check_circle_rounded : (isSelected ? Icons.cancel_rounded : Icons.circle_outlined),
                            color: option.isOptimal ? AppColors.emerald : (isSelected ? AppColors.alertRed : AppColors.textMuted),
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),

          // Educational Outcome & Takeaway Box
          if (hasChosen && chosenOption != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: (chosenOption.isOptimal ? AppColors.emerald : AppColors.alertRed).withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: (chosenOption.isOptimal ? AppColors.emerald : AppColors.alertRed).withOpacity(0.6)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        chosenOption.isOptimal
                            ? (isTh ? 'การตัดสินใจที่ถูกต้องและปลอดภัยที่สุด (+${chosenOption.scoreDelta} แต้ม)' : 'OPTIMAL CLINICAL ACTION (+${chosenOption.scoreDelta} PTS)')
                            : (isTh ? 'การตัดสินใจที่ไม่ถูกต้องตามมาตรฐาน (${chosenOption.scoreDelta} แต้ม)' : 'SUBOPTIMAL ACTION (${chosenOption.scoreDelta} PTS)'),
                        style: AppTypography.hudLabel.copyWith(
                          color: chosenOption.isOptimal ? AppColors.emerald : AppColors.alertRed,
                          fontSize: 10.5,
                        ),
                      ),
                      Icon(
                        chosenOption.isOptimal ? Icons.verified_rounded : Icons.info_outline_rounded,
                        color: chosenOption.isOptimal ? AppColors.emerald : AppColors.alertRed,
                        size: 18,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    chosenOption.outcomeExplanation,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, fontSize: 12.5, height: 1.4),
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Color(0x1F00F2FE)),
                  const SizedBox(height: 8),
                  Text('takeaways_header'.tr, style: AppTypography.hudLabel.copyWith(fontSize: 9, color: AppColors.cyan)),
                  const SizedBox(height: 2),
                  Text(
                    chosenOption.educationalTakeaway,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11.5, height: 1.4),
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
