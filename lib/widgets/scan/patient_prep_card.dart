import 'package:flutter/material.dart';
import '../../models/imaging_modality.dart';
import '../../models/scan_simulation_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../services/audio_service.dart';
import '../../services/localization_service.dart';
import '../common/glass_panel.dart';
import '../common/glowing_button.dart';

class PatientPrepCard extends StatefulWidget {
  final PatientCaseProfile patient;
  final ImagingModality modality;
  final VoidCallback onPrepCompleted;

  const PatientPrepCard({
    super.key,
    required this.patient,
    required this.modality,
    required this.onPrepCompleted,
  });

  @override
  State<PatientPrepCard> createState() => _PatientPrepCardState();
}

class _PatientPrepCardState extends State<PatientPrepCard> {
  final Map<int, bool> _checkedItems = {};

  bool get _allChecked => widget.modality.safetyChecklist.asMap().entries.every(
        (entry) => _checkedItems[entry.key] == true,
      );

  @override
  Widget build(BuildContext context) {
    final color = widget.modality.accentColor;
    final isTh = LocalizationService().isThai;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return GlassPanel(
      borderColor: color.withOpacity(0.4),
      padding: EdgeInsets.all(isMobile ? 12 : 18),
      showCornerBrackets: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'patient_intake_title'.tr,
                      style: AppTypography.hudLabel.copyWith(color: color, fontSize: isMobile ? 9 : 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${widget.patient.caseId} • ${widget.patient.patientInitials} (${widget.patient.age}Y, ${widget.patient.gender})',
                      style: AppTypography.titleMedium.copyWith(fontSize: isMobile ? 14 : 17),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: color),
                ),
                child: Text(
                  widget.modality.tag,
                  style: AppTypography.hudLabel.copyWith(color: color, fontSize: 9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Clinical Indication Grid
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceHighlight.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.cardGlassBorder),
            ),
            child: Row(
              children: [
                Icon(Icons.medical_information_outlined, color: color, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isTh ? 'ข้อบ่งชี้ทางคลินิกและโปรโตคอลการตรวจ' : 'CLINICAL INDICATION & EXAM PROTOCOL',
                        style: AppTypography.hudLabel.copyWith(color: AppColors.textMuted, fontSize: 8.5),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${widget.patient.examProtocol} — ${widget.patient.indication}',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 11.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Interactive Safety Checklist
          Text(
            'safety_checklist_header'.tr,
            style: AppTypography.hudLabel.copyWith(color: AppColors.textSecondary, fontSize: 9.5),
          ),
          const SizedBox(height: 8),

          ...widget.modality.safetyChecklist.asMap().entries.map((entry) {
            final index = entry.key;
            final text = entry.value;
            final isChecked = _checkedItems[index] ?? false;

            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _checkedItems[index] = !isChecked;
                  });
                  SoundService().playSound(SoundEffect.uiClick);
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: isChecked ? color.withOpacity(0.12) : AppColors.surface.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isChecked ? color.withOpacity(0.8) : AppColors.cardGlassBorder,
                      width: isChecked ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isChecked ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                        color: isChecked ? color : AppColors.textMuted,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          text,
                          style: AppTypography.bodySmall.copyWith(
                            color: isChecked ? AppColors.textPrimary : AppColors.textSecondary,
                            fontWeight: isChecked ? FontWeight.w600 : FontWeight.w400,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 14),

          // Action Button
          Align(
            alignment: Alignment.centerRight,
            child: GlowingButton(
              text: _allChecked ? 'prep_ready_btn'.tr : (isTh ? 'ยืนยันทุกข้อและเริ่มจัดตำแหน่ง' : 'CHECK ALL & PROCEED'),
              icon: Icons.arrow_forward_rounded,
              primaryColor: color,
              isSecondary: !_allChecked,
              onPressed: () {
                if (_allChecked) {
                  widget.onPrepCompleted();
                } else {
                  setState(() {
                    for (int i = 0; i < widget.modality.safetyChecklist.length; i++) {
                      _checkedItems[i] = true;
                    }
                  });
                  SoundService().playSound(SoundEffect.successPing);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
