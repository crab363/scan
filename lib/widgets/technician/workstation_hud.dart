import 'package:flutter/material.dart';
import '../../models/technician_case.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../common/glass_panel.dart';

class WorkstationHUD extends StatelessWidget {
  final TechnicianCase techCase;
  final int currentScore;

  const WorkstationHUD({
    super.key,
    required this.techCase,
    required this.currentScore,
  });

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      borderColor: AppColors.cyan.withOpacity(0.4),
      padding: const EdgeInsets.all(18),
      showCornerBrackets: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.cyan,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.cyan.withOpacity(0.8),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'RADTECH CONSOLE • WORKSTATION 04',
                    style: AppTypography.hudLabel.copyWith(fontSize: 11),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.emerald.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.emerald),
                ),
                child: Text(
                  'COMPETENCY SCORE: $currentScore PTS',
                  style: AppTypography.hudLabel.copyWith(
                    color: AppColors.emerald,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Workstation Patient Status Grid
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceHighlight.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.cardGlassBorder),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildField('PATIENT', '${techCase.caseCode} (${techCase.patientAge}Y, ${techCase.patientGender})'),
                    _buildField('EXAM', techCase.examName),
                    _buildField('POSITIONING', techCase.positioningStatus.split(';').first),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(color: Color(0x1F00F2FE)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFieldWithBadge('IMAGE QUALITY', '${techCase.initialImageQuality.toInt()}%', AppColors.amber),
                    _buildFieldWithBadge('ARTIFACT', techCase.detectedArtifact, AppColors.alertRed),
                    _buildField('SYSTEM', 'PACS INTEGRATION OK'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Alert Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.alertRed.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.alertRed.withOpacity(0.6)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.alertRed, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    techCase.workstationAlert,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.hudLabel.copyWith(fontSize: 8, color: AppColors.textMuted)),
        const SizedBox(height: 2),
        Text(value, style: AppTypography.hudValue.copyWith(fontSize: 11, color: AppColors.textPrimary)),
      ],
    );
  }

  Widget _buildFieldWithBadge(String label, String value, Color badgeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.hudLabel.copyWith(fontSize: 8, color: AppColors.textMuted)),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: badgeColor.withOpacity(0.18),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: badgeColor.withOpacity(0.5)),
          ),
          child: Text(
            value,
            style: AppTypography.hudValue.copyWith(fontSize: 10, color: badgeColor, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
