enum ScanStep {
  patient,
  preparation,
  positioning,
  scan,
  image,
}

class PatientCaseProfile {
  final String caseId;
  final String patientInitials;
  final int age;
  final String gender;
  final String indication;
  final String examProtocol;
  final bool hasFerrousMetal;
  final bool hasClaustrophobia;
  final bool requiresContrast;
  final String allergies;

  const PatientCaseProfile({
    required this.caseId,
    required this.patientInitials,
    required this.age,
    required this.gender,
    required this.indication,
    required this.examProtocol,
    required this.hasFerrousMetal,
    required this.hasClaustrophobia,
    required this.requiresContrast,
    required this.allergies,
  });
}

class ScanMetrics {
  final double imageQuality; // 0 to 100%
  final String signalToNoiseRatio;
  final String artifactStatus;
  final double currentSliceIndex;
  final int totalSlices;
  final double magneticFieldStrength; // e.g. 3.0 Tesla or CT kVp
  final int radioFrequencyPower; // in Watts

  const ScanMetrics({
    required this.imageQuality,
    required this.signalToNoiseRatio,
    required this.artifactStatus,
    required this.currentSliceIndex,
    required this.totalSlices,
    required this.magneticFieldStrength,
    required this.radioFrequencyPower,
  });

  ScanMetrics copyWith({
    double? imageQuality,
    String? signalToNoiseRatio,
    String? artifactStatus,
    double? currentSliceIndex,
    int? totalSlices,
    double? magneticFieldStrength,
    int? radioFrequencyPower,
  }) {
    return ScanMetrics(
      imageQuality: imageQuality ?? this.imageQuality,
      signalToNoiseRatio: signalToNoiseRatio ?? this.signalToNoiseRatio,
      artifactStatus: artifactStatus ?? this.artifactStatus,
      currentSliceIndex: currentSliceIndex ?? this.currentSliceIndex,
      totalSlices: totalSlices ?? this.totalSlices,
      magneticFieldStrength: magneticFieldStrength ?? this.magneticFieldStrength,
      radioFrequencyPower: radioFrequencyPower ?? this.radioFrequencyPower,
    );
  }
}
