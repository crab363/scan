import 'package:flutter/material.dart';
import '../../models/case_file.dart';
import '../../models/imaging_modality.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../common/glass_panel.dart';

class CaseCard extends StatelessWidget {
  final CaseFile caseFile;
  final bool isSelected;
  final bool isAnswered;
  final VoidCallback onTap;

  const CaseCard({
    super.key,
    required this.caseFile,
    required this.isSelected,
    this.isAnswered = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color modalityColor = AppColors.cyan;
    if (caseFile.modality == ModalityType.ct) {
      modalityColor = AppColors.emerald;
    } else if (caseFile.modality == ModalityType.xray) {
      modalityColor = AppColors.violet;
    }

    final isCritical = caseFile.urgencyLevel.contains('STAT') || caseFile.urgencyLevel.contains('Critical');

    return GlassPanel(
      onTap: onTap,
      borderColor: isSelected ? modalityColor : AppColors.cardGlassBorder,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      borderRadius: 14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Badges
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: modalityColor.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: modalityColor.withOpacity(0.6)),
                ),
                child: Text(
                  caseFile.modality.name.toUpperCase(),
                  style: AppTypography.hudLabel.copyWith(
                    color: modalityColor,
                    fontSize: 8.5,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: isCritical ? AppColors.alertRed.withOpacity(0.2) : AppColors.surfaceHighlight,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: isCritical ? AppColors.alertRed : AppColors.cardGlassBorder,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isAnswered) ...[
                        const Icon(Icons.check_circle_rounded, size: 10, color: AppColors.emerald),
                        const SizedBox(width: 3),
                      ],
                      Flexible(
                        child: Text(
                          caseFile.urgencyLevel.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: AppTypography.hudLabel.copyWith(
                            color: isCritical ? AppColors.alertRed : AppColors.textSecondary,
                            fontSize: 7.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Metadata line
          Text(
            '${caseFile.caseNumber} • ${caseFile.age}Y ${caseFile.gender}',
            style: AppTypography.hudLabel.copyWith(color: modalityColor, fontSize: 9.5),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),

          // Title
          Text(
            caseFile.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.titleMedium.copyWith(
              fontSize: 13,
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),

          // Chief Complaint
          Text(
            caseFile.chiefComplaint,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySmall.copyWith(
              fontSize: 10,
              height: 1.25,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
