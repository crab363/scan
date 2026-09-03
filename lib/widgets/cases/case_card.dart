import 'package:flutter/material.dart';
import '../../models/case_file.dart';
import '../../models/imaging_modality.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../common/glass_panel.dart';

class CaseCard extends StatelessWidget {
  final CaseFile caseFile;
  final bool isSelected;
  final VoidCallback onTap;

  const CaseCard({
    super.key,
    required this.caseFile,
    required this.isSelected,
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

    return GlassPanel(
      onTap: onTap,
      borderColor: isSelected ? modalityColor : AppColors.cardGlassBorder,
      padding: const EdgeInsets.all(16),
      borderRadius: 14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: modalityColor.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: modalityColor.withOpacity(0.6)),
                ),
                child: Text(
                  caseFile.modality.name.toUpperCase(),
                  style: AppTypography.hudLabel.copyWith(
                    color: modalityColor,
                    fontSize: 9,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: caseFile.urgencyLevel.contains('STAT') || caseFile.urgencyLevel.contains('Critical')
                      ? AppColors.alertRed.withOpacity(0.2)
                      : AppColors.surfaceHighlight,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: caseFile.urgencyLevel.contains('STAT') || caseFile.urgencyLevel.contains('Critical')
                        ? AppColors.alertRed
                        : AppColors.cardGlassBorder,
                  ),
                ),
                child: Text(
                  caseFile.urgencyLevel.toUpperCase(),
                  style: AppTypography.hudLabel.copyWith(
                    color: caseFile.urgencyLevel.contains('STAT') || caseFile.urgencyLevel.contains('Critical')
                        ? AppColors.alertRed
                        : AppColors.textSecondary,
                    fontSize: 8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${caseFile.caseNumber} • ${caseFile.age}Y ${caseFile.gender}',
            style: AppTypography.hudLabel.copyWith(color: modalityColor, fontSize: 10),
          ),
          const SizedBox(height: 2),
          Text(
            caseFile.title,
            style: AppTypography.titleMedium.copyWith(
              fontSize: 15,
              color: isSelected ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            caseFile.chiefComplaint,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySmall.copyWith(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
