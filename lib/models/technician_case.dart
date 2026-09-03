import 'imaging_modality.dart';

class TechnicianDecisionOption {
  final String id;
  final String title;
  final String actionDescription;
  final bool isOptimal;
  final int scoreDelta;
  final String outcomeExplanation;
  final String educationalTakeaway;

  const TechnicianDecisionOption({
    required this.id,
    required this.title,
    required this.actionDescription,
    required this.isOptimal,
    required this.scoreDelta,
    required this.outcomeExplanation,
    required this.educationalTakeaway,
  });
}

class TechnicianCase {
  final String id;
  final String caseCode;
  final String title;
  final ModalityType modality;
  final String examName;
  final int patientAge;
  final String patientGender;
  final String clinicalIndication;
  final String positioningStatus;
  final double initialImageQuality;
  final String detectedArtifact;
  final String artifactDescription;
  final String workstationAlert;
  final String dilemmaQuestion;
  final List<TechnicianDecisionOption> options;
  final List<String> radTechCompetenciesTested;

  const TechnicianCase({
    required this.id,
    required this.caseCode,
    required this.title,
    required this.modality,
    required this.examName,
    required this.patientAge,
    required this.patientGender,
    required this.clinicalIndication,
    required this.positioningStatus,
    required this.initialImageQuality,
    required this.detectedArtifact,
    required this.artifactDescription,
    required this.workstationAlert,
    required this.dilemmaQuestion,
    required this.options,
    required this.radTechCompetenciesTested,
  });
}
