import 'package:flutter/material.dart';
import '../models/imaging_modality.dart';
import '../models/scan_simulation_state.dart';
import '../data/modalities_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../services/app_state_service.dart';
import '../services/localization_service.dart';
import '../services/audio_service.dart';
import '../widgets/common/hud_header.dart';
import '../widgets/common/glass_panel.dart';
import '../widgets/scan/modality_selector.dart';
import '../widgets/scan/patient_prep_card.dart';
import '../widgets/scan/laser_positioning_hud.dart';
import '../widgets/scan/scan_acquisition_hud.dart';
import '../widgets/scan/kspace_reconstructor.dart';
import '../widgets/scan/slice_viewer.dart';

class ScanSimulationScreen extends StatefulWidget {
  final VoidCallback? onEnterVisualMode;

  const ScanSimulationScreen({super.key, this.onEnterVisualMode});

  @override
  State<ScanSimulationScreen> createState() => _ScanSimulationScreenState();
}

class _ScanSimulationScreenState extends State<ScanSimulationScreen> {
  ModalityType _selectedModality = ModalityType.mri;
  ScanStep _currentStep = ScanStep.patient;
  bool _isReconstructing = false;
  bool _showPhysicsDrawer = false;

  final PatientCaseProfile _demoPatient = const PatientCaseProfile(
    caseId: 'CASE 024',
    patientInitials: 'A.R.',
    age: 17,
    gender: 'Male',
    indication: 'Headache & vertigo post-sports collision',
    examProtocol: 'MRI BRAIN MULTI-PLANE',
    hasFerrousMetal: false,
    hasClaustrophobia: false,
    requiresContrast: false,
    allergies: 'NKDA',
  );

  ImagingModality get _currentModalityInfo {
    return ModalitiesData.modalities.firstWhere(
      (m) => m.type == _selectedModality,
      orElse: () => ModalitiesData.modalities.first,
    );
  }

  void _goToStep(ScanStep step) {
    setState(() => _currentStep = step);
    SoundService().playSound(SoundEffect.uiClick);
  }

  @override
  Widget build(BuildContext context) {
    final modality = _currentModalityInfo;
    final color = modality.accentColor;
    final isTh = LocalizationService().isThai;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

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
              // HUD Header
              HUDHeader(
                title: 'scan_lab_title'.tr,
                subtitle: 'scan_lab_subtitle'.tr,
                tag: modality.name,
                accentColor: color,
                trailing: Wrap(
                  spacing: 6,
                  children: [
                    // Physics & Knowledge Button
                    TextButton.icon(
                      onPressed: () {
                        setState(() => _showPhysicsDrawer = !_showPhysicsDrawer);
                        SoundService().playSound(SoundEffect.uiClick);
                      },
                      icon: Icon(Icons.school_rounded, size: 16, color: _showPhysicsDrawer ? AppColors.amber : AppColors.cyan),
                      label: Text(
                        isTh ? 'ความรู้ฟิสิกส์' : 'PHYSICS',
                        style: AppTypography.hudLabel.copyWith(
                          color: _showPhysicsDrawer ? AppColors.amber : AppColors.cyan,
                          fontSize: 9.5,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _currentStep = ScanStep.patient;
                          _isReconstructing = false;
                        });
                        SoundService().playSound(SoundEffect.uiClick);
                      },
                      icon: const Icon(Icons.restart_alt_rounded, size: 16, color: AppColors.cyan),
                      label: Text('reset_lab'.tr, style: AppTypography.hudLabel.copyWith(color: AppColors.cyan, fontSize: 9)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Modality Selector Bar
              ModalitySelector(
                selectedModality: _selectedModality,
                onModalitySelected: (m) {
                  setState(() {
                    _selectedModality = m;
                    _currentStep = ScanStep.patient;
                    _isReconstructing = false;
                  });
                },
              ),
              const SizedBox(height: 10),

              // Optional Educational Physics Drawer
              if (_showPhysicsDrawer) ...[
                _buildPhysicsInfoDrawer(modality, isTh),
                const SizedBox(height: 10),
              ],

              // 5-Step Visual Stepper Bar
              _buildStepperBar(color),
              const SizedBox(height: 12),

              // Active Step Body View
              Expanded(
                child: SingleChildScrollView(
                  child: _buildCurrentStepContent(modality),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhysicsInfoDrawer(ImagingModality modality, bool isTh) {
    return GlassPanel(
      borderColor: AppColors.amber.withOpacity(0.5),
      padding: const EdgeInsets.all(14),
      borderRadius: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology_alt_rounded, color: AppColors.amber, size: 20),
              const SizedBox(width: 8),
              Text(
                '${modality.fullName} — ${'physics_title'.tr}',
                style: AppTypography.titleMedium.copyWith(color: AppColors.amber, fontSize: 13.5),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            modality.physicsPrinciple,
            style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textPrimary, height: 1.45),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    '${'radiation_dose'.tr}: ${modality.radiationLevel}',
                    style: AppTypography.telemetryCode.copyWith(fontSize: 9.5, color: AppColors.cyan),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    '${'acquisition_time'.tr}: ${modality.acquisitionSpeed}',
                    style: AppTypography.telemetryCode.copyWith(fontSize: 9.5, color: AppColors.emerald),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepperBar(Color color) {
    final steps = [
      {'step': ScanStep.patient, 'label': 'step_1_patient'.tr},
      {'step': ScanStep.preparation, 'label': 'step_2_prep'.tr},
      {'step': ScanStep.positioning, 'label': 'step_3_position'.tr},
      {'step': ScanStep.scan, 'label': 'step_4_scan'.tr},
      {'step': ScanStep.image, 'label': 'step_5_image'.tr},
    ];

    return GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      borderRadius: 12,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: steps.map((s) {
            final step = s['step'] as ScanStep;
            final label = s['label'] as String;
            final isCurrent = _currentStep == step;
            final isPast = step.index < _currentStep.index;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                onTap: () => _goToStep(step),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isCurrent ? color.withOpacity(0.2) : (isPast ? AppColors.surfaceHighlight : Colors.transparent),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isCurrent ? color : (isPast ? color.withOpacity(0.4) : Colors.transparent),
                      width: isCurrent ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPast ? Icons.check_circle_rounded : (isCurrent ? Icons.radio_button_checked_rounded : Icons.circle_outlined),
                        size: 13,
                        color: isCurrent ? color : (isPast ? AppColors.emerald : AppColors.textMuted),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        label,
                        style: AppTypography.hudLabel.copyWith(
                          color: isCurrent ? Colors.white : (isPast ? AppColors.textPrimary : AppColors.textMuted),
                          fontSize: 9.0,
                          fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent(ImagingModality modality) {
    switch (_currentStep) {
      case ScanStep.patient:
      case ScanStep.preparation:
        return PatientPrepCard(
          patient: _demoPatient,
          modality: modality,
          onPrepCompleted: () => _goToStep(ScanStep.positioning),
        );

      case ScanStep.positioning:
        return LaserPositioningHUD(
          modality: modality,
          onPositioningLocked: () => _goToStep(ScanStep.scan),
        );

      case ScanStep.scan:
        return ScanAcquisitionHUD(
          modality: modality,
          patient: _demoPatient,
          onScanComplete: (metrics) {
            setState(() {
              _isReconstructing = true;
              _currentStep = ScanStep.image;
            });
          },
        );

      case ScanStep.image:
        if (_isReconstructing) {
          return KSpaceReconstructor(
            modality: modality,
            onReconstructionDone: () {
              setState(() => _isReconstructing = false);
            },
          );
        }

        return SliceViewer(
          modality: modality,
          title: 'CASE 024 • ${_demoPatient.examProtocol}',
          onEnterVisualMode: widget.onEnterVisualMode ??
              () {
                AppStateService().setNavigationIndex(5);
              },
        );
    }
  }
}
