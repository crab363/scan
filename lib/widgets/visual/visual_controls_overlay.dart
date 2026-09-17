import 'package:flutter/material.dart';
import '../../models/visual_mode_preset.dart';
import '../../data/visual_presets_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../services/audio_service.dart';
import '../common/glass_panel.dart';
import '../common/glowing_button.dart';

class VisualControlsOverlay extends StatefulWidget {
  final VisualEffectSettings currentSettings;
  final ValueChanged<VisualEffectSettings> onSettingsChanged;
  final VoidCallback onExit;
  final VoidCallback onTriggerBeat;

  const VisualControlsOverlay({
    super.key,
    required this.currentSettings,
    required this.onSettingsChanged,
    required this.onExit,
    required this.onTriggerBeat,
  });

  @override
  State<VisualControlsOverlay> createState() => _VisualControlsOverlayState();
}

class _VisualControlsOverlayState extends State<VisualControlsOverlay> {
  bool _isPanelExpanded = false;
  bool _isInfoVisible = true;

  @override
  Widget build(BuildContext context) {
    final activePreset = widget.currentSettings;
    final color = activePreset.palette.first;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 650;

    return Stack(
      children: [
        // Top Header Bar
        Positioned(
          top: 14,
          left: 14,
          right: 14,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              // Title HUD
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.background.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: color.withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(color: color.withOpacity(0.25), blurRadius: 10),
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
                      'CONCERT VJ • ${activePreset.title}',
                      style: AppTypography.hudLabel.copyWith(
                        color: Colors.white,
                        fontSize: 9.5,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Action Toolbar
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Beat Trigger Button
                  GlowingButton(
                    text: isMobile ? '⚡ PULSE' : '⚡ BEAT PULSE',
                    primaryColor: color,
                    secondaryColor: activePreset.palette.length > 1 ? activePreset.palette[1] : color,
                    height: 36,
                    onPressed: widget.onTriggerBeat,
                  ),
                  const SizedBox(width: 8),

                  // Sound FX Switcher
                  IconButton.filledTonal(
                    tooltip: 'Soundtrack Switcher',
                    icon: const Icon(Icons.music_note_rounded, color: Colors.white, size: 18),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.surface.withOpacity(0.8),
                      side: BorderSide(color: color.withOpacity(0.4)),
                    ),
                    onPressed: () {
                      SoundService().playSound(SoundEffect.mriGradientPulse);
                    },
                  ),
                  const SizedBox(width: 8),

                  // VJ Settings Drawer
                  IconButton.filledTonal(
                    tooltip: 'VJ Parameters Console',
                    icon: Icon(
                      _isPanelExpanded ? Icons.tune_rounded : Icons.tune_outlined,
                      color: color,
                      size: 18,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.surface.withOpacity(0.8),
                      side: BorderSide(color: color.withOpacity(0.5)),
                    ),
                    onPressed: () {
                      setState(() => _isPanelExpanded = !_isPanelExpanded);
                      SoundService().playSound(SoundEffect.uiClick);
                    },
                  ),
                  const SizedBox(width: 8),

                  // Exit Button
                  IconButton.filledTonal(
                    tooltip: 'Exit Visual Mode',
                    icon: const Icon(Icons.close_fullscreen_rounded, color: Colors.white, size: 18),
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

        // Interactive Touch Guide Hint
        if (_isInfoVisible)
          Positioned(
            top: 70,
            left: 16,
            right: 16,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.background.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.touch_app_rounded, size: 14, color: color),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Tap or drag anywhere to blast quantum laser ripples • Press ⚡ PULSE to beat-sync',
                        style: AppTypography.hudLabel.copyWith(fontSize: 8.5, color: AppColors.textSecondary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => setState(() => _isInfoVisible = false),
                      child: const Icon(Icons.close, size: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Bottom Preset Selector Dock
        Positioned(
          bottom: 16,
          left: 12,
          right: 12,
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
                    child: InkWell(
                      onTap: () {
                        SoundService().playSound(SoundEffect.laserBeep);
                        widget.onSettingsChanged(preset);
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? pColor.withOpacity(0.2) : AppColors.surface.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? pColor : AppColors.cardGlassBorder,
                            width: isSelected ? 1.8 : 1.0,
                          ),
                          boxShadow: [
                            if (isSelected)
                              BoxShadow(color: pColor.withOpacity(0.4), blurRadius: 10),
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
                                color: pColor,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              preset.title,
                              style: AppTypography.hudLabel.copyWith(
                                color: isSelected ? Colors.white : AppColors.textSecondary,
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                                fontSize: 9.5,
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
          ),
        ),

        // Expandable Parameter Tweaker Panel (Right Side Drawer)
        if (_isPanelExpanded)
          Positioned(
            top: 65,
            right: 14,
            width: isMobile ? size.width - 28 : 310,
            child: GlassPanel(
              borderColor: color.withOpacity(0.5),
              padding: const EdgeInsets.all(16),
              showCornerBrackets: true,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('LIVE VJ SYNTHESIZER CONSOLE', style: AppTypography.hudLabel.copyWith(color: color, fontSize: 10)),
                        IconButton(
                          icon: const Icon(Icons.close, size: 16, color: AppColors.textMuted),
                          onPressed: () => setState(() => _isPanelExpanded = false),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

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

                    const SizedBox(height: 6),

                    // Toggles
                    SwitchListTile(
                      title: Text('AUDIO REACTIVE PULSE', style: AppTypography.hudLabel.copyWith(fontSize: 8.5, color: AppColors.textPrimary)),
                      value: activePreset.isAudioPulseActive,
                      activeColor: color,
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      onChanged: (val) => widget.onSettingsChanged(activePreset.copyWith(isAudioPulseActive: val)),
                    ),
                    SwitchListTile(
                      title: Text('CRT GRID LATTICE', style: AppTypography.hudLabel.copyWith(fontSize: 8.5, color: AppColors.textPrimary)),
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
            Text(value.toStringAsFixed(1), style: AppTypography.hudValue.copyWith(fontSize: 9.5, color: color)),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            thumbColor: color,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4),
            trackHeight: 2,
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
