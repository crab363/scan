import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/imaging_modality.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../services/app_state_service.dart';
import '../../services/localization_service.dart';
import '../../services/audio_service.dart';
import '../common/glass_panel.dart';
import '../common/glowing_button.dart';
import 'realistic_scan_painter.dart';

class SliceViewer extends StatefulWidget {
  final ImagingModality modality;
  final String title;
  final VoidCallback? onEnterVisualMode;

  const SliceViewer({
    super.key,
    required this.modality,
    this.title = 'MULTI-SLICE DIAGNOSTIC WORKSTATION',
    this.onEnterVisualMode,
  });

  @override
  State<SliceViewer> createState() => _SliceViewerState();
}

class _SliceViewerState extends State<SliceViewer> {
  int _currentSlice = 14;
  final int _totalSlices = 28;
  ScanPlane _currentPlane = ScanPlane.axial;
  WindowPreset _activeWindowPreset = WindowPreset.brain;
  double _windowWidth = 100.0;
  double _windowLevel = 50.0;
  bool _isInvertedLUT = false;
  bool _showCalipers = false;
  bool _showLandmarks = true;
  bool _isCinePlaying = false;
  Timer? _cineTimer;
  Offset _crosshairPos = const Offset(0.35, 0.38);
  TissueDensityInfo? _sampledDensity;

  @override
  void initState() {
    super.initState();
    _sampleAtCurrentPos();
  }

  @override
  void dispose() {
    _cineTimer?.cancel();
    super.dispose();
  }

  void _sampleAtCurrentPos() {
    _sampledDensity = RealisticScanPainter.sampleTissueDensity(
      pos: _crosshairPos,
      modality: widget.modality.type,
      plane: _currentPlane,
      sliceIndex: _currentSlice,
      totalSlices: _totalSlices,
    );
  }

  void _toggleCine() {
    setState(() {
      _isCinePlaying = !_isCinePlaying;
    });
    SoundService().playSound(SoundEffect.uiClick);

    if (_isCinePlaying) {
      _cineTimer?.cancel();
      _cineTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (!mounted) return;
        setState(() {
          _currentSlice++;
          if (_currentSlice > _totalSlices) {
            _currentSlice = 1;
          }
          _sampleAtCurrentPos();
        });
      });
    } else {
      _cineTimer?.cancel();
    }
  }

  void _applyWindowPreset(WindowPreset preset) {
    setState(() {
      _activeWindowPreset = preset;
      switch (preset) {
        case WindowPreset.brain:
          _windowWidth = 80.0;
          _windowLevel = 40.0;
          break;
        case WindowPreset.stroke:
          _windowWidth = 30.0;
          _windowLevel = 35.0;
          break;
        case WindowPreset.subdural:
          _windowWidth = 150.0;
          _windowLevel = 75.0;
          break;
        case WindowPreset.bone:
          _windowWidth = 200.0;
          _windowLevel = 80.0;
          break;
        case WindowPreset.softTissue:
          _windowWidth = 120.0;
          _windowLevel = 45.0;
          break;
        case WindowPreset.lung:
          _windowWidth = 180.0;
          _windowLevel = 20.0;
          break;
        case WindowPreset.custom:
          break;
      }
    });
    SoundService().playSound(SoundEffect.uiClick);
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
          // Header Bar with Quick Action Tools
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'workstation_title'.tr,
                      style: AppTypography.hudLabel.copyWith(color: color, fontSize: isMobile ? 9 : 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.title,
                      style: AppTypography.titleMedium.copyWith(fontSize: isMobile ? 14 : 17),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Wrap(
                spacing: 4,
                children: [
                  // Cine Auto-Play Button
                  IconButton(
                    tooltip: 'cine_loop'.tr,
                    icon: Icon(
                      _isCinePlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                      color: _isCinePlaying ? AppColors.emerald : AppColors.textSecondary,
                      size: isMobile ? 20 : 24,
                    ),
                    onPressed: _toggleCine,
                  ),
                  // Landmarks Toggle
                  IconButton(
                    tooltip: 'landmark_overlay'.tr,
                    icon: Icon(
                      Icons.place_rounded,
                      color: _showLandmarks ? AppColors.amber : AppColors.textSecondary,
                      size: isMobile ? 20 : 24,
                    ),
                    onPressed: () {
                      setState(() => _showLandmarks = !_showLandmarks);
                      SoundService().playSound(SoundEffect.uiClick);
                    },
                  ),
                  // Caliper Measurement
                  IconButton(
                    tooltip: 'caliper_measure'.tr,
                    icon: Icon(
                      Icons.straighten_rounded,
                      color: _showCalipers ? color : AppColors.textSecondary,
                      size: isMobile ? 20 : 24,
                    ),
                    onPressed: () {
                      setState(() => _showCalipers = !_showCalipers);
                      SoundService().playSound(SoundEffect.uiClick);
                    },
                  ),
                  // Invert LUT
                  IconButton(
                    tooltip: 'invert_lut'.tr,
                    icon: Icon(
                      _isInvertedLUT ? Icons.contrast_rounded : Icons.invert_colors_rounded,
                      color: _isInvertedLUT ? AppColors.amber : AppColors.textSecondary,
                      size: isMobile ? 20 : 24,
                    ),
                    onPressed: () {
                      setState(() => _isInvertedLUT = !_isInvertedLUT);
                      SoundService().playSound(SoundEffect.uiClick);
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Multiplanar View Selector (Axial / Sagittal / Coronal)
          Row(
            children: [
              _buildPlaneChip(ScanPlane.axial, 'plane_axial'.tr, color),
              const SizedBox(width: 8),
              _buildPlaneChip(ScanPlane.sagittal, 'plane_sagittal'.tr, color),
              const SizedBox(width: 8),
              _buildPlaneChip(ScanPlane.coronal, 'plane_coronal'.tr, color),
            ],
          ),
          const SizedBox(height: 12),

          // Central Medical Canvas
          Container(
            height: isMobile ? 260 : 310,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _isInvertedLUT ? const Color(0xFFF1F5F9) : const Color(0xFF030509),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.4)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  // Realistic Scan Painter
                  Positioned.fill(
                    child: CustomPaint(
                      painter: RealisticScanPainter(
                        sliceIndex: _currentSlice,
                        totalSlices: _totalSlices,
                        modalityType: widget.modality.type,
                        scanPlane: _currentPlane,
                        windowPreset: _activeWindowPreset,
                        windowWidth: _windowWidth,
                        windowLevel: _windowLevel,
                        isInverted: _isInvertedLUT,
                        accentColor: color,
                        crosshairPos: _crosshairPos,
                        showCalipers: _showCalipers,
                        showLandmarks: _showLandmarks,
                      ),
                    ),
                  ),

                  // Interactive Drag Probe Listener
                  Positioned.fill(
                    child: GestureDetector(
                      onPanDown: (details) => _updateCrosshair(details.localPosition, context),
                      onPanUpdate: (details) => _updateCrosshair(details.localPosition, context),
                    ),
                  ),

                  // DICOM Telemetry Overlays (Top Left)
                  Positioned(
                    top: 10,
                    left: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('PACSCore v4.2 • ${_currentPlane.name.toUpperCase()}', style: AppTypography.hudLabel.copyWith(fontSize: 9.5, color: color)),
                        Text('ZOOM: 100% | MATRIX: 512x512', style: AppTypography.telemetryCode.copyWith(fontSize: 8.5)),
                        Text('THK: 3.0mm | SP: 0.5mm', style: AppTypography.telemetryCode.copyWith(fontSize: 8.5)),
                      ],
                    ),
                  ),

                  // DICOM Telemetry Overlays (Top Right)
                  Positioned(
                    top: 10,
                    right: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('WW: ${_windowWidth.toInt()} | WL: ${_windowLevel.toInt()}', style: AppTypography.hudLabel.copyWith(fontSize: 9.5, color: color)),
                        Text('SLICE: $_currentSlice / $_totalSlices', style: AppTypography.hudValue.copyWith(fontSize: 11, color: Colors.white)),
                        Text(_activeWindowPreset.name.toUpperCase(), style: AppTypography.telemetryCode.copyWith(fontSize: 8.5, color: AppColors.amber)),
                      ],
                    ),
                  ),

                  // Directional Markers
                  Positioned(
                    top: 6,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(_currentPlane == ScanPlane.sagittal ? 'S (SUPERIOR)' : 'A (ANTERIOR)', style: AppTypography.hudLabel.copyWith(fontSize: 8.5, color: color.withOpacity(0.7))),
                    ),
                  ),
                  Positioned(
                    bottom: 6,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(_currentPlane == ScanPlane.sagittal ? 'I (INFERIOR)' : 'P (POSTERIOR)', style: AppTypography.hudLabel.copyWith(fontSize: 8.5, color: color.withOpacity(0.7))),
                    ),
                  ),
                  Positioned(
                    left: 8,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Text(_currentPlane == ScanPlane.sagittal ? 'A' : 'R', style: AppTypography.hudLabel.copyWith(fontSize: 10.5, color: color.withOpacity(0.7))),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Text(_currentPlane == ScanPlane.sagittal ? 'P' : 'L', style: AppTypography.hudLabel.copyWith(fontSize: 10.5, color: color.withOpacity(0.7))),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Interactive Real-Time Hounsfield Unit (HU) Probe HUD Panel
          if (_sampledDensity != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.95),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _sampledDensity!.indicatorColor.withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(color: _sampledDensity!.indicatorColor.withOpacity(0.15), blurRadius: 8),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _sampledDensity!.indicatorColor.withOpacity(0.2),
                      border: Border.all(color: _sampledDensity!.indicatorColor),
                    ),
                    child: Center(
                      child: Icon(Icons.colorize_rounded, color: _sampledDensity!.indicatorColor, size: 18),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isTh ? _sampledDensity!.tissueNameTh : _sampledDensity!.tissueNameEn,
                              style: AppTypography.titleMedium.copyWith(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w700),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: _sampledDensity!.indicatorColor.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${_sampledDensity!.hounsfieldUnits.toInt()} HU',
                                style: AppTypography.hudValue.copyWith(fontSize: 11, color: _sampledDensity!.indicatorColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isTh ? _sampledDensity!.clinicalSignificanceTh : _sampledDensity!.clinicalSignificanceEn,
                          style: AppTypography.bodySmall.copyWith(fontSize: 10.5, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),

          // Multi-Slice Scrubber Slider
          Row(
            children: [
              Text('slice_depth'.tr, style: AppTypography.hudLabel.copyWith(fontSize: 9.5, color: AppColors.textMuted)),
              const SizedBox(width: 10),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: color,
                    thumbColor: color,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    trackHeight: 3,
                  ),
                  child: Slider(
                    value: _currentSlice.toDouble(),
                    min: 1,
                    max: _totalSlices.toDouble(),
                    divisions: _totalSlices - 1,
                    onChanged: (val) {
                      setState(() {
                        _currentSlice = val.toInt();
                        _sampleAtCurrentPos();
                      });
                    },
                  ),
                ),
              ),
              Text('$_currentSlice / $_totalSlices', style: AppTypography.hudValue.copyWith(fontSize: 11.5, color: color)),
            ],
          ),
          const SizedBox(height: 10),

          // Window Preset Chips Row
          Text('window_presets'.tr, style: AppTypography.hudLabel.copyWith(fontSize: 9, color: AppColors.textMuted)),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildWindowPresetChip(WindowPreset.brain, 'win_brain'.tr, color),
                const SizedBox(width: 6),
                _buildWindowPresetChip(WindowPreset.stroke, 'win_stroke'.tr, color),
                const SizedBox(width: 6),
                _buildWindowPresetChip(WindowPreset.subdural, 'win_subdural'.tr, color),
                const SizedBox(width: 6),
                _buildWindowPresetChip(WindowPreset.bone, 'win_bone'.tr, color),
                const SizedBox(width: 6),
                _buildWindowPresetChip(WindowPreset.softTissue, 'win_soft_tissue'.tr, color),
                const SizedBox(width: 6),
                _buildWindowPresetChip(WindowPreset.lung, 'win_lung'.tr, color),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Enter Visual Mode Button
          if (widget.onEnterVisualMode != null)
            Align(
              alignment: Alignment.centerRight,
              child: GlowingButton(
                text: 'enter_visual_mode'.tr,
                icon: Icons.auto_awesome_motion_rounded,
                primaryColor: AppColors.magenta,
                secondaryColor: AppColors.violet,
                height: 38,
                onPressed: widget.onEnterVisualMode!,
              ),
            ),
        ],
      ),
    );
  }

  void _updateCrosshair(Offset localPos, BuildContext context) {
    setState(() {
      _crosshairPos = Offset(
        (localPos.dx / 320).clamp(0.05, 0.95),
        (localPos.dy / 280).clamp(0.05, 0.95),
      );
      _sampleAtCurrentPos();
    });
  }

  Widget _buildPlaneChip(ScanPlane plane, String label, Color accent) {
    final isSelected = _currentPlane == plane;
    return ChoiceChip(
      label: Text(
        label,
        style: AppTypography.hudLabel.copyWith(
          color: isSelected ? AppColors.background : accent,
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
        ),
      ),
      selected: isSelected,
      selectedColor: accent,
      backgroundColor: AppColors.surface,
      side: BorderSide(color: isSelected ? accent : AppColors.cardGlassBorder),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _currentPlane = plane;
            _sampleAtCurrentPos();
          });
          SoundService().playSound(SoundEffect.uiClick);
        }
      },
    );
  }

  Widget _buildWindowPresetChip(WindowPreset preset, String label, Color accent) {
    final isSelected = _activeWindowPreset == preset;
    return ChoiceChip(
      label: Text(
        label,
        style: AppTypography.hudLabel.copyWith(
          color: isSelected ? AppColors.background : AppColors.textSecondary,
          fontSize: 8.5,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      selected: isSelected,
      selectedColor: accent,
      backgroundColor: AppColors.surfaceHighlight.withOpacity(0.4),
      side: BorderSide(color: isSelected ? accent : AppColors.cardGlassBorder),
      onSelected: (selected) {
        if (selected) {
          _applyWindowPreset(preset);
        }
      },
    );
  }
}
