import 'package:flutter/material.dart';
import 'imaging_modality.dart';

class CaseObservationChoice {
  final String id;
  final String text;
  final bool isCorrect;
  final String explanation;

  const CaseObservationChoice({
    required this.id,
    required this.text,
    required this.isCorrect,
    required this.explanation,
  });
}

class DiagnosticSlice {
  final String label;
  final String plane; // Axial, Sagittal, Coronal
  final String sequenceType; // T1, T2, FLAIR, CT Bone, etc.
  final String annotation;
  final Offset findingHighlight; // Normalized position on slice (0.0 to 1.0)
  final double findingRadius;

  const DiagnosticSlice({
    required this.label,
    required this.plane,
    required this.sequenceType,
    required this.annotation,
    required this.findingHighlight,
    this.findingRadius = 0.12,
  });
}

class CaseFile {
  final String id;
  final String caseNumber;
  final String title;
  final int age;
  final String gender;
  final String chiefComplaint;
  final List<String> symptoms;
  final List<String> medicalHistory;
  final ModalityType modality;
  final String anatomyRegion;
  final String urgencyLevel; // Routine, Urgent, Stat / Code Stroke
  final List<DiagnosticSlice> slices;
  final String quizQuestion;
  final List<CaseObservationChoice> observationChoices;
  final String definitiveFindings;
  final String radiologicExplanation;
  final List<String> clinicalPearls;
  final String disclaimer;

  const CaseFile({
    required this.id,
    required this.caseNumber,
    required this.title,
    required this.age,
    required this.gender,
    required this.chiefComplaint,
    required this.symptoms,
    required this.medicalHistory,
    required this.modality,
    required this.anatomyRegion,
    required this.urgencyLevel,
    required this.slices,
    required this.quizQuestion,
    required this.observationChoices,
    required this.definitiveFindings,
    required this.radiologicExplanation,
    required this.clinicalPearls,
    this.disclaimer = 'Educational simulation only. Not for clinical diagnosis.',
  });
}
