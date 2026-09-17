import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/imaging_modality.dart';
import '../../models/scan_simulation_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../services/audio_service.dart';
import '../../services/localization_service.dart';
import '../common/glass_panel.dart';
import '../common/glowing_button.dart';
import '../common/waveform_visualizer.dart';
import '../common/animated_scan_line.dart';

class ScanAcquisitionHUD extends StatefulWidget {
  final ImagingModality modality;
  final PatientCaseProfile patient;
  final ValueChanged<ScanMetrics> onScanComplete;

  const ScanAcquisitionHUD({
    super.key,
    required this.modality,
    required this.patient,
    required this.onScanComplete,
  });

  @override
  State<ScanAcquisitionHUD> createState() => _ScanAcquisitionHUDState();
}

class _ScanAcquisitionHUDState extends State<ScanAcquisitionHUD> with SingleTickerProviderStateMixin {
  late ScanSequenceInfo _activeSequence;
  bool _isScanning = false;
  double _scanProgress = 0.0;
  Timer? _scanTimer;

  // Live Metrics
  double _qualityScore = 96.0;
  String _artifactStatus = 'NONE (NOMINAL)';
  int _currentSlice = 0;
  final int _totalSlices = 28;
  bool _simulateMotion = false;

  @override
  void initState() {
    super.initState();
    _activeSequence = widget.modality.availableSequences.first;
  }

  @override
  void dispose() {
    _scanTimer?.cancel();
    super.dispose();
  }

  void _startScan() {
    setState(() {
      _isScanning = true;
      _scanProgress = 0.0;
      _currentSlice = 0;
    });

    // Play modality sound signature
    if (widget.modality.type == ModalityType.mri) {
      SoundService().playSound(SoundEffect.mriGradientPulse);
    } else if (widget.modality.type == ModalityType.ct) {
      SoundService().playSound(SoundEffect.ctGantryHum);
    } else {
      SoundService().playSound(SoundEffect.xrayExposure);
    }

    _scanTimer?.cancel();
    _scanTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) return;

      setState(() {
        _scanProgress += 0.035;
        _currentSlice = (_scanProgress * _totalSlices).toInt().clamp(0, _totalSlices);

        if (_simulateMotion && _scanProgress >= 0.4 && _scanProgress <= 0.7) {
          _artifactStatus = 'PHASE MOTION ARTIFACT DETECTED';
          _qualityScore = 74.0;
        }

        if (_scanProgress >= 1.0) {
          _scanProgress = 1.0;
          _isScanning = false;
          timer.cancel();

          final metrics = ScanMetrics(
            imageQuality: _qualityScore,
            signalToNoiseRatio: 'SNR: 24.8 dB',
            artifactStatus: _artifactStatus,
            currentSliceIndex: _totalSlices.toDouble(),
            totalSlices: _totalSlices,
            magneticFieldStrength: 3.0,
            radioFrequencyPower: 450,
          );

          SoundService().playSound(SoundEffect.successPing);
          widget.onScanComplete(metrics);
        }
      });
    });
  }

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
          // Header Readout
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'acquisition_title'.tr,
                      style: AppTypography.hudLabel.copyWith(color: color, fontSize: isMobile ? 9 : 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${widget.patient.caseId} • ${_activeSequence.name}',
                      style: AppTypography.titleMedium.copyWith(fontSize: isMobile ? 14 : 17),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: _isScanning ? AppColors.emerald.withOpacity(0.2) : color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: _isScanning ? AppColors.emerald : color),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isScanning ? AppColors.emerald : color,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _isScanning ? 'acquiring_kspace'.tr : 'scanner_ready'.tr,
                      style: AppTypography.hudLabel.copyWith(
                        color: _isScanning ? AppColors.emerald : color,
                        fontSize: 8.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Sequence Selection Bar
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.modality.availableSequences.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final seq = widget.modality.availableSequences[index];
                final isSelected = seq.code == _activeSequence.code;

                return ChoiceChip(
                  label: Text(
                    seq.code,
                    style: AppTypography.hudLabel.copyWith(
                      color: isSelected ? AppColors.background : color,
                      fontWeight: FontWeight.w700,
                      fontSize: 10.5,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: color,
                  backgroundColor: AppColors.surface,
                  side: BorderSide(color: isSelected ? color : AppColors.cardGlassBorder),
                  onSelected: _isScanning
                      ? null
                      : (selected) {
                          if (selected) {
                            setState(() => _activeSequence = seq);
                            SoundService().playSound(SoundEffect.uiClick);
                          }
                        },
                );
              },
            ),
          ),
          const SizedBox(height: 14),

          // Live RF Waveform & Scanner Animation Box
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surface.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardGlassBorder),
            ),
            child: Stack(
              children: [
                WaveformVisualizer(
                  height: 140,
                  primaryColor: color,
                  secondaryColor: AppColors.emerald,
                  frequency: _isScanning ? 7.0 : 2.0,
                  amplitude: _isScanning ? 36.0 : 8.0,
                  isScanningActive: _isScanning,
                ),
                if (_isScanning)
                  Positioned.fill(
                    child: AnimatedScanLine(
                      color: color,
                      duration: const Duration(milliseconds: 1200),
                    ),
                  ),
                // Telemetry Overlay
                Positioned(
                  top: 8,
                  left: 12,
                  child: Text(
                    'TR: ${_activeSequence.defaultTR}ms | TE: ${_activeSequence.defaultTE}ms | FA: 90°',
                    style: AppTypography.telemetryCode.copyWith(fontSize: 9.5, color: color),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 12,
                  child: Text(
                    'SLICE: $_currentSlice / $_totalSlices',
                    style: AppTypography.hudValue.copyWith(fontSize: 10.5, color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Live Telemetry Grid
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surfaceHighlight.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.cardGlassBorder),
            ),
            child: Row(
              children: [
                Expanded(child: _buildTelemetryItem(isTh ? 'คุณภาพภาพ' : 'QUALITY', '${_qualityScore.toInt()}%', AppColors.cyan)),
                Expanded(child: _buildTelemetryItem(isTh ? 'สัญญาณรบกวน' : 'ARTIFACT', _simulateMotion ? 'MOTION' : 'CLEAN', _simulateMotion ? AppColors.amber : AppColors.emerald)),
                Expanded(child: _buildTelemetryItem(isTh ? 'สนามแม่เหล็ก' : 'FIELD', '3.0T', AppColors.emerald)),
                Expanded(child: _buildTelemetryItem(isTh ? 'กำลัง RF' : 'RF POWER', '450 W', AppColors.violet)),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(isTh ? 'ความคืบหน้าการบันทึก K-SPACE' : 'K-SPACE ENCODING PROGRESS', style: AppTypography.hudLabel.copyWith(fontSize: 8.5, color: AppColors.textMuted)),
                  Text('${(_scanProgress * 100).toInt()}%', style: AppTypography.hudValue.copyWith(fontSize: 11, color: color)),
                ],
              ),
              const SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _scanProgress,
                  minHeight: 5,
                  backgroundColor: AppColors.surface,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Controls Row
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 10,
            children: [
              InkWell(
                onTap: () {
                  setState(() => _simulateMotion = !_simulateMotion);
                  SoundService().playSound(SoundEffect.uiClick);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _simulateMotion ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                      size: 16,
                      color: _simulateMotion ? AppColors.amber : AppColors.textMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'motion_simulation'.tr,
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 10.5,
                        color: _simulateMotion ? AppColors.amber : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              GlowingButton(
                text: _isScanning ? 'acquiring_kspace'.tr : (_scanProgress >= 1.0 ? 'view_recon_btn'.tr : 'start_scan_btn'.tr),
                icon: _isScanning ? Icons.sync_rounded : Icons.play_arrow_rounded,
                isLoading: _isScanning,
                primaryColor: color,
                onPressed: () {
                  if (_scanProgress >= 1.0) {
                    final metrics = ScanMetrics(
                      imageQuality: _qualityScore,
                      signalToNoiseRatio: 'SNR: 24.8 dB',
                      artifactStatus: _artifactStatus,
                      currentSliceIndex: _totalSlices.toDouble(),
                      totalSlices: _totalSlices,
                      magneticFieldStrength: 3.0,
                      radioFrequencyPower: 450,
                    );
                    widget.onScanComplete(metrics);
                  } else {
                    _startScan();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTelemetryItem(String label, String value, Color accent) {
    return Column(
      children: [
        Text(
          label,
          style: AppTypography.hudLabel.copyWith(fontSize: 7.5, color: AppColors.textMuted),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.hudValue.copyWith(fontSize: 10.5, color: accent, fontWeight: FontWeight.w700),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
