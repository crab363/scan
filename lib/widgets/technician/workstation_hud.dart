import 'package:flutter/material.dart';
import '../../models/technician_case.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../services/localization_service.dart';
import '../common/glass_panel.dart';

class WorkstationHUD extends StatelessWidget {
  final TechnicianCase techCase;
  final bool isAnswered;
  final int currentScore;

  const WorkstationHUD({
    super.key,
    required this.techCase,
    this.isAnswered = false,
    this.currentScore = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isTh = LocalizationService().isThai;

    return GlassPanel(
      borderColor: AppColors.cyan.withOpacity(0.4),
      padding: const EdgeInsets.all(16),
      showCornerBrackets: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 9,
                      height: 9,
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
                    Flexible(
                      child: Text(
                        isTh ? 'คอนโซลควบคุมรังสีเทคนิค • สถานี 04' : 'RADTECH CONSOLE • WORKSTATION 04',
                        style: AppTypography.hudLabel.copyWith(fontSize: 10.5),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isAnswered ? AppColors.emerald.withOpacity(0.15) : AppColors.amber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: isAnswered ? AppColors.emerald : AppColors.amber),
                ),
                child: Text(
                  isAnswered ? (isTh ? 'ประเมินแล้ว' : 'EVALUATED') : (isTh ? 'รอดำเนินการ' : 'PENDING DECISION'),
                  style: AppTypography.hudLabel.copyWith(
                    color: isAnswered ? AppColors.emerald : AppColors.amber,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildField(
                        isTh ? 'ผู้ป่วย' : 'PATIENT',
                        '${techCase.caseCode} (${techCase.patientAge}Y, ${techCase.patientGender})',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 4,
                      child: _buildField(
                        isTh ? 'การตรวจ' : 'EXAM',
                        techCase.examName,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 4,
                      child: _buildField(
                        isTh ? 'การจัดท่า' : 'POSITIONING',
                        techCase.positioningStatus.split(';').first,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(color: Color(0x1F00F2FE)),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildFieldWithBadge(
                        isTh ? 'คุณภาพภาพ' : 'IMAGE QUALITY',
                        '${techCase.initialImageQuality.toInt()}%',
                        AppColors.amber,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 5,
                      child: _buildFieldWithBadge(
                        'artifact_detected'.tr,
                        techCase.detectedArtifact,
                        AppColors.alertRed,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: _buildField(
                        isTh ? 'ระบบ' : 'SYSTEM',
                        'PACS OK',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

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
                      fontSize: 11.5,
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
        Text(
          label,
          style: AppTypography.hudLabel.copyWith(fontSize: 8, color: AppColors.textMuted),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.hudValue.copyWith(fontSize: 10.5, color: AppColors.textPrimary),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildFieldWithBadge(String label, String value, Color badgeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.hudLabel.copyWith(fontSize: 8, color: AppColors.textMuted),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
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
            style: AppTypography.hudValue.copyWith(fontSize: 9.5, color: badgeColor, fontWeight: FontWeight.w700),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
