import 'package:flutter/material.dart';

enum VisualThemePreset {
  cyberHologram,
  quantumParticles,
  matrixNeural,
  kSpaceGlitch,
  bioInfrared,
  solarGold,
}

class VisualEffectSettings {
  final VisualThemePreset preset;
  final String title;
  final String description;
  final List<Color> palette;
  final double particleDensity; // 50 to 300
  final double scanSpeed; // 0.2 to 3.0
  final double waveformFrequency; // 1.0 to 10.0
  final double glowIntensity; // 0.1 to 1.0
  final double glitchAmount; // 0.0 to 1.0
  final bool showGrid;
  final bool showWaveformRings;
  final bool showDataCoordinates;
  final bool isAudioPulseActive;

  const VisualEffectSettings({
    required this.preset,
    required this.title,
    required this.description,
    required this.palette,
    this.particleDensity = 120,
    this.scanSpeed = 1.0,
    this.waveformFrequency = 4.0,
    this.glowIntensity = 0.8,
    this.glitchAmount = 0.15,
    this.showGrid = true,
    this.showWaveformRings = true,
    this.showDataCoordinates = true,
    this.isAudioPulseActive = true,
  });

  VisualEffectSettings copyWith({
    VisualThemePreset? preset,
    String? title,
    String? description,
    List<Color>? palette,
    double? particleDensity,
    double? scanSpeed,
    double? waveformFrequency,
    double? glowIntensity,
    double? glitchAmount,
    bool? showGrid,
    bool? showWaveformRings,
    bool? showDataCoordinates,
    bool? isAudioPulseActive,
  }) {
    return VisualEffectSettings(
      preset: preset ?? this.preset,
      title: title ?? this.title,
      description: description ?? this.description,
      palette: palette ?? this.palette,
      particleDensity: particleDensity ?? this.particleDensity,
      scanSpeed: scanSpeed ?? this.scanSpeed,
      waveformFrequency: waveformFrequency ?? this.waveformFrequency,
      glowIntensity: glowIntensity ?? this.glowIntensity,
      glitchAmount: glitchAmount ?? this.glitchAmount,
      showGrid: showGrid ?? this.showGrid,
      showWaveformRings: showWaveformRings ?? this.showWaveformRings,
      showDataCoordinates: showDataCoordinates ?? this.showDataCoordinates,
      isAudioPulseActive: isAudioPulseActive ?? this.isAudioPulseActive,
    );
  }
}
