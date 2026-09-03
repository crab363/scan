import 'package:flutter/material.dart';
import '../models/brain_region_model.dart';
import '../models/case_file.dart';
import '../models/imaging_modality.dart';
import '../models/technician_case.dart';
import '../models/visual_mode_preset.dart';
import '../data/brain_data.dart';
import '../data/modalities_data.dart';
import '../data/technician_cases_data.dart';
import '../data/case_files_data.dart';
import '../data/visual_presets_data.dart';
import 'audio_service.dart';

class AppStateService extends ChangeNotifier {
  static final AppStateService _instance = AppStateService._internal();
  factory AppStateService() => _instance;
  AppStateService._internal();

  int _currentNavigationIndex = 0;
  ModalityType _selectedModality = ModalityType.mri;
  BrainRegion _selectedBrainRegion = BrainData.regions.first;
  TechnicianCase _activeTechnicianCase = TechnicianCasesData.cases.first;
  CaseFile _activeCaseFile = CaseFilesData.cases.first;
  VisualEffectSettings _visualSettings = VisualPresetsData.presets.first;
  int _technicianScore = 0;
  final Map<String, String> _technicianDecisions = {};
  final Map<String, String> _caseQuizAnswers = {};

  int get currentNavigationIndex => _currentNavigationIndex;
  ModalityType get selectedModality => _selectedModality;
  BrainRegion get selectedBrainRegion => _selectedBrainRegion;
  TechnicianCase get activeTechnicianCase => _activeTechnicianCase;
  CaseFile get activeCaseFile => _activeCaseFile;
  VisualEffectSettings get visualSettings => _visualSettings;
  int get technicianScore => _technicianScore;
  Map<String, String> get technicianDecisions => _technicianDecisions;
  Map<String, String> get caseQuizAnswers => _caseQuizAnswers;

  ImagingModality get currentModalityInfo {
    return ModalitiesData.modalities.firstWhere(
      (m) => m.type == _selectedModality,
      orElse: () => ModalitiesData.modalities.first,
    );
  }

  void setNavigationIndex(int index) {
    if (_currentNavigationIndex != index) {
      _currentNavigationIndex = index;
      SoundService().playSound(SoundEffect.uiClick);
      notifyListeners();
    }
  }

  void setSelectedModality(ModalityType modality) {
    _selectedModality = modality;
    SoundService().playSound(SoundEffect.laserBeep);
    notifyListeners();
  }

  void setSelectedBrainRegion(BrainRegion region) {
    _selectedBrainRegion = region;
    SoundService().playSound(SoundEffect.uiClick);
    notifyListeners();
  }

  void setActiveTechnicianCase(TechnicianCase techCase) {
    _activeTechnicianCase = techCase;
    SoundService().playSound(SoundEffect.uiClick);
    notifyListeners();
  }

  void recordTechnicianDecision(String caseId, String optionId, int scoreDelta) {
    _technicianDecisions[caseId] = optionId;
    _technicianScore += scoreDelta;
    if (scoreDelta > 0) {
      SoundService().playSound(SoundEffect.successPing);
    } else {
      SoundService().playSound(SoundEffect.alertWarning);
    }
    notifyListeners();
  }

  void setActiveCaseFile(CaseFile caseFile) {
    _activeCaseFile = caseFile;
    SoundService().playSound(SoundEffect.uiClick);
    notifyListeners();
  }

  void recordCaseQuizAnswer(String caseId, String choiceId, bool isCorrect) {
    _caseQuizAnswers[caseId] = choiceId;
    if (isCorrect) {
      SoundService().playSound(SoundEffect.successPing);
    } else {
      SoundService().playSound(SoundEffect.alertWarning);
    }
    notifyListeners();
  }

  void setVisualSettings(VisualEffectSettings settings) {
    _visualSettings = settings;
    notifyListeners();
  }
}
