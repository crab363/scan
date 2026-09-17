import 'package:flutter/material.dart';
import '../models/imaging_modality.dart';
import '../models/scan_simulation_state.dart';
import '../data/modalities_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../services/app_state_service.dart';
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
                title: 'SCAN SIMULATION LAB',
                subtitle: '5-Stage Clinical Radiologic Acquisition & Reconstruction Workflow',
                tag: modality.name,
                accentColor: color,
                trailing: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _currentStep = ScanStep.patient;
                      _isReconstructing = false;
                    });
                    SoundService().playSound(SoundEffect.uiClick);
                  },
                  icon: const Icon(Icons.restart_alt_rounded, size: 16, color: AppColors.cyan),
                  label: Text('RESET LAB', style: AppTypography.hudLabel.copyWith(color: AppColors.cyan, fontSize: 9)),
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

              // 5-Step Visual Stepper Bar (Horizontally scrollable for mobile)
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

  Widget _buildStepperBar(Color color) {
    final steps = [
      {'step': ScanStep.patient, 'label': '1. PATIENT'},
      {'step': ScanStep.preparation, 'label': '2. PREP'},
      {'step': ScanStep.positioning, 'label': '3. POSITION'},
      {'step': ScanStep.scan, 'label': '4. SCAN'},
      {'step': ScanStep.image, 'label': '5. IMAGE'},
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
                          fontSize: 8.5,
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
