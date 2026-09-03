import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/imaging_modality.dart';
import '../../models/scan_simulation_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../services/audio_service.dart';
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
  double _qualityScore = 82.0;
  String _artifactStatus = 'MOTION ARTIFACT DETECTED';
  int _currentSlice = 0;
  final int _totalSlices = 28;

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
    _scanTimer = Timer.periodic(const Duration(milliseconds: 120), (timer) {
      if (!mounted) return;

      setState(() {
        _scanProgress += 0.025;
        _currentSlice = (_scanProgress * _totalSlices).toInt().clamp(0, _totalSlices);

        if (_scanProgress >= 0.5 && _scanProgress <= 0.6) {
          _artifactStatus = 'PHASE MOTION DETECTED (SLICE 14)';
          _qualityScore = 82.0;
        }

        if (_scanProgress >= 1.0) {
          _scanProgress = 1.0;
          _isScanning = false;
          timer.cancel();

          final metrics = ScanMetrics(
            imageQuality: _qualityScore,
            signalToNoiseRatio: 'SNR: 18.4 dB',
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

    return GlassPanel(
      borderColor: color.withOpacity(0.4),
      padding: const EdgeInsets.all(20),
      showCornerBrackets: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Readout
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'REAL-TIME RF PULSE & GRADIENT ACQUISITION',
                    style: AppTypography.hudLabel.copyWith(color: color),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.patient.caseId} • ${_activeSequence.name}',
                    style: AppTypography.titleMedium.copyWith(fontSize: 18),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _isScanning ? AppColors.emerald.withOpacity(0.2) : color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: _isScanning ? AppColors.emerald : color),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isScanning ? AppColors.emerald : color,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _isScanning ? 'ACQUIRING RAW K-SPACE' : 'SCANNER READY',
                      style: AppTypography.hudLabel.copyWith(
                        color: _isScanning ? AppColors.emerald : color,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Sequence Selection Bar
          SizedBox(
            height: 38,
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
                      fontSize: 11,
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
          const SizedBox(height: 16),

          // Live RF Waveform & Scanner Animation Box
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surface.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardGlassBorder),
            ),
            child: Stack(
              children: [
                WaveformVisualizer(
                  height: 150,
                  primaryColor: color,
                  secondaryColor: AppColors.emerald,
                  frequency: _isScanning ? 6.5 : 2.0,
                  amplitude: _isScanning ? 35.0 : 8.0,
                  isScanningActive: _isScanning,
                ),
                if (_isScanning)
                  Positioned.fill(
                    child: AnimatedScanLine(
                      color: color,
                      duration: const Duration(milliseconds: 1400),
                    ),
                  ),
                // Telemetry Overlay
                Positioned(
                  top: 8,
                  left: 12,
                  child: Text(
                    'TR: ${_activeSequence.defaultTR}ms | TE: ${_activeSequence.defaultTE}ms | FA: 90°',
                    style: AppTypography.telemetryCode.copyWith(fontSize: 10, color: color),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 12,
                  child: Text(
                    'SLICE: $_currentSlice / $_totalSlices',
                    style: AppTypography.hudValue.copyWith(fontSize: 11, color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Live Telemetry Grid
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceHighlight.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.cardGlassBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTelemetryItem('IMAGE QUALITY', '${_qualityScore.toInt()}%', AppColors.cyan),
                _buildTelemetryItem('ARTIFACT', 'MOTION DETECTED', AppColors.amber),
                _buildTelemetryItem('FIELD STRENGTH', '3.0 TESLA', AppColors.emerald),
                _buildTelemetryItem('RF POWER', '450 W', AppColors.violet),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('K-SPACE ENCODING PROGRESS', style: AppTypography.hudLabel.copyWith(fontSize: 9, color: AppColors.textMuted)),
                  Text('${(_scanProgress * 100).toInt()}%', style: AppTypography.hudValue.copyWith(fontSize: 12, color: color)),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _scanProgress,
                  minHeight: 6,
                  backgroundColor: AppColors.surface,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Simulated Sequence: Educational Mode',
                style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.textMuted),
              ),
              GlowingButton(
                text: _isScanning ? 'ACQUIRING...' : (_scanProgress >= 1.0 ? 'VIEW RECONSTRUCTED IMAGE' : 'START SCAN'),
                icon: _isScanning ? Icons.sync_rounded : Icons.play_arrow_rounded,
                isLoading: _isScanning,
                primaryColor: color,
                onPressed: () {
                  if (_scanProgress >= 1.0) {
                    final metrics = ScanMetrics(
                      imageQuality: _qualityScore,
                      signalToNoiseRatio: 'SNR: 18.4 dB',
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
        Text(label, style: AppTypography.hudLabel.copyWith(fontSize: 8, color: AppColors.textMuted)),
        const SizedBox(height: 3),
        Text(value, style: AppTypography.hudValue.copyWith(fontSize: 11, color: accent, fontWeight: FontWeight.w700)),
      ],
    );
  }
}
