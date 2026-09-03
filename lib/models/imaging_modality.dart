import 'package:flutter/material.dart';

enum ModalityType { mri, ct, xray }

class ScanSequenceInfo {
  final String code;
  final String name;
  final String physicsDescription;
  final String contrastType;
  final int defaultTR; // Repetition time (ms)
  final int defaultTE; // Echo time (ms)
  final String primaryApplication;

  const ScanSequenceInfo({
    required this.code,
    required this.name,
    required this.physicsDescription,
    required this.contrastType,
    required this.defaultTR,
    required this.defaultTE,
    required this.primaryApplication,
  });
}

class ImagingModality {
  final ModalityType type;
  final String name;
  final String tag;
  final String fullName;
  final String description;
  final String physicsPrinciple;
  final String soundProfile;
  final Color accentColor;
  final List<Color> gradientColors;
  final String radiationLevel;
  final String acquisitionSpeed;
  final String softTissueResolution;
  final List<String> safetyChecklist;
  final List<ScanSequenceInfo> availableSequences;
  final List<String> hardwareComponents;

  const ImagingModality({
    required this.type,
    required this.name,
    required this.tag,
    required this.fullName,
    required this.description,
    required this.physicsPrinciple,
    required this.soundProfile,
    required this.accentColor,
    required this.gradientColors,
    required this.radiationLevel,
    required this.acquisitionSpeed,
    required this.softTissueResolution,
    required this.safetyChecklist,
    required this.availableSequences,
    required this.hardwareComponents,
  });
}
