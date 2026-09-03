import 'package:flutter/material.dart';

class AnatomyZone {
  final String id;
  final String name;
  final String category;
  final String description;
  final Offset coordinates; // Relative on body silhouette (0.0 to 1.0)
  final Color accentColor;
  final List<String> primaryModalities;
  final List<String> commonExams;
  final String clinicalPearls;
  final String radiationSafetyNote;

  const AnatomyZone({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.coordinates,
    required this.accentColor,
    required this.primaryModalities,
    required this.commonExams,
    required this.clinicalPearls,
    required this.radiationSafetyNote,
  });
}
