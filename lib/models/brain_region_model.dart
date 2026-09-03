import 'package:flutter/material.dart';

class BrainRegion {
  final String id;
  final String name;
  final String latinName;
  final String keyRole;
  final String description;
  final List<String> primaryFunctions;
  final List<String> clinicalRelevance;
  final String imagingTip;
  final Color highlightColor;
  final Offset visualCenter; // Relative coordinate (0.0 - 1.0)
  final double radius;
  final List<String> anatomicalLandmarks;

  const BrainRegion({
    required this.id,
    required this.name,
    required this.latinName,
    required this.keyRole,
    required this.description,
    required this.primaryFunctions,
    required this.clinicalRelevance,
    required this.imagingTip,
    required this.highlightColor,
    required this.visualCenter,
    required this.radius,
    required this.anatomicalLandmarks,
  });
}
