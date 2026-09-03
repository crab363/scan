import 'package:flutter/material.dart';
import '../../models/visual_mode_preset.dart';
import '../../data/visual_presets_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../services/audio_service.dart';
import '../common/glass_panel.dart';

class VisualControlsOverlay extends StatefulWidget {
  final VisualEffectSettings currentSettings;
  final ValueChanged<VisualEffectSettings> onSettingsChanged;
  final VoidCallback onExit;

  const VisualControlsOverlay({
    super.key,
    required this.currentSettings,
    required this.onSettingsChanged,
    required this.onExit,
  });

  @override
  State<VisualControlsOverlay> createState() => _VisualControlsOverlayState();
}

class _VisualControlsOverlayState extends State<VisualControlsOverlay> {
  bool _isPanelExpanded = false;

  @override
  Widget build(BuildContext context) {
    final activePreset = widget.currentSettings;
    final color = activePreset.palette.first;

    return Stack(
      children: [
        // Top Header Bar
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title HUD
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.background.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(color: color.withOpacity(0.2), blurRadius: 10),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                        boxShadow: [
                          BoxShadow(color: color, blurRadius: 6),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'CONCERT VISUAL MODE • ${activePreset.title}',
                      style: AppTypography.hudLabel.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),

              // Action Buttons (Preset Drawer & Exit)
              Row(
                children: [
                  IconButton.filledTonal(
                    tooltip: 'Toggle Parameters Control Panel',
                    icon: Icon(
                      _isPanelExpanded ? Icons.tune_rounded : Icons.tune_outlined,
                      color: color,
                      size: 20,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.surface.withOpacity(0.8),
                      side: BorderSide(color: color.withOpacity(0.4)),
                    ),
                    onPressed: () {
                      setState(() => _isPanelExpanded = !_isPanelExpanded);
                      SoundService().playSound(SoundEffect.uiClick);
                    },
                  ),
                  const SizedBox(width: 10),
                  IconButton.filledTonal(
                    tooltip: 'Exit Visual Mode',
                    icon: const Icon(Icons.close_fullscreen_rounded, color: Colors.white, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.surface.withOpacity(0.8),
                      side: const BorderSide(color: AppColors.cardGlassBorder),
                    ),
                    onPressed: () {
                      SoundService().playSound(SoundEffect.uiClick);
                      widget.onExit();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        // Bottom Preset Chips Row
        Positioned(
          bottom: 20,
          left: 16,
          right: 16,
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: VisualPresetsData.presets.map((preset) {
                  final isSelected = preset.preset == activePreset.preset;
                  final pColor = preset.palette.first;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(
                        preset.title,
                        style: AppTypography.hudLabel.copyWith(
                          color: isSelected ? AppColors.background : Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: pColor,
                      backgroundColor: AppColors.surface.withOpacity(0.7),
                      side: BorderSide(color: isSelected ? pColor : AppColors.cardGlassBorder),
                      onSelected: (selected) {
                        if (selected) {
                          SoundService().playSound(SoundEffect.laserBeep);
                          widget.onSettingsChanged(preset);
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),

        // Expandable Parameter Tweaker Panel (Right Side)
        if (_isPanelExpanded)
          Positioned(
            top: 70,
            right: 16,
            width: 320,
            child: GlassPanel(
              borderColor: color.withOpacity(0.5),
              padding: const EdgeInsets.all(18),
              showCornerBrackets: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('LIVE VISUAL PARAMETERS', style: AppTypography.hudLabel.copyWith(color: color)),
                      IconButton(
                        icon: const Icon(Icons.close, size: 16, color: AppColors.textMuted),
                        onPressed: () => setState(() => _isPanelExpanded = false),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Particle Density Slider
                  _buildSlider(
                    label: 'PARTICLE SWARM DENSITY',
                    value: activePreset.particleDensity,
                    min: 40,
                    max: 250,
                    color: color,
                    onChanged: (val) => widget.onSettingsChanged(activePreset.copyWith(particleDensity: val)),
                  ),

                  // Scan Speed Slider
                  _buildSlider(
                    label: 'LASER SCAN VELOCITY',
                    value: activePreset.scanSpeed,
                    min: 0.2,
                    max: 3.0,
                    color: color,
                    onChanged: (val) => widget.onSettingsChanged(activePreset.copyWith(scanSpeed: val)),
                  ),

                  // Waveform Frequency Slider
                  _buildSlider(
                    label: 'WAVE HARMONIC FREQUENCY',
                    value: activePreset.waveformFrequency,
                    min: 1.0,
                    max: 10.0,
                    color: color,
                    onChanged: (val) => widget.onSettingsChanged(activePreset.copyWith(waveformFrequency: val)),
                  ),

                  // Glow Intensity Slider
                  _buildSlider(
                    label: 'LUMINESCENT GLOW INTENSITY',
                    value: activePreset.glowIntensity,
                    min: 0.2,
                    max: 1.0,
                    color: color,
                    onChanged: (val) => widget.onSettingsChanged(activePreset.copyWith(glowIntensity: val)),
                  ),

                  // Glitch Amount Slider
                  _buildSlider(
                    label: 'K-SPACE GLITCH / STROBE',
                    value: activePreset.glitchAmount,
                    min: 0.0,
                    max: 0.6,
                    color: color,
                    onChanged: (val) => widget.onSettingsChanged(activePreset.copyWith(glitchAmount: val)),
                  ),

                  const SizedBox(height: 8),

                  // Toggles Row
                  SwitchListTile(
                    title: Text('AUDIO REACTIVE PULSE', style: AppTypography.hudLabel.copyWith(fontSize: 9, color: AppColors.textPrimary)),
                    value: activePreset.isAudioPulseActive,
                    activeColor: color,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    onChanged: (val) => widget.onSettingsChanged(activePreset.copyWith(isAudioPulseActive: val)),
                  ),
                  SwitchListTile(
                    title: Text('COORDINATES GRID', style: AppTypography.hudLabel.copyWith(fontSize: 9, color: AppColors.textPrimary)),
                    value: activePreset.showGrid,
                    activeColor: color,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    onChanged: (val) => widget.onSettingsChanged(activePreset.copyWith(showGrid: val)),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required Color color,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.hudLabel.copyWith(fontSize: 8, color: AppColors.textMuted)),
            Text(value.toStringAsFixed(1), style: AppTypography.hudValue.copyWith(fontSize: 10, color: color)),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            thumbColor: color,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
            trackHeight: 2,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
