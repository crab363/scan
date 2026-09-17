import 'dart:math' as math;
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
import 'localization_service.dart';

enum ScanPlane {
  axial,
  sagittal,
  coronal,
}

enum WindowPreset {
  brain,
  stroke,
  subdural,
  bone,
  softTissue,
  lung,
  custom,
}

class AppStateService extends ChangeNotifier {
  static final AppStateService _instance = AppStateService._internal();
  factory AppStateService() => _instance;
  AppStateService._internal();

  final math.Random _random = math.Random();

  int _currentNavigationIndex = 0;
  ModalityType _selectedModality = ModalityType.mri;
  BrainRegion _selectedBrainRegion = BrainData.regions.first;
  TechnicianCase _activeTechnicianCase = TechnicianCasesData.cases.first;
  CaseFile _activeCaseFile = CaseFilesData.cases.first;
  VisualEffectSettings _visualSettings = VisualPresetsData.presets.first;
  int _technicianScore = 0;
  int _consecutiveCorrectStreak = 0;
  final Map<String, String> _technicianDecisions = {};
  final Map<String, String> _caseQuizAnswers = {};

  // DICOM & Medical Viewer State
  ScanPlane _activeScanPlane = ScanPlane.axial;
  WindowPreset _activeWindowPreset = WindowPreset.brain;
  bool _isCinePlaying = false;
  bool _showCalipers = false;
  bool _showLandmarks = true;
  bool _isInvertedLUT = false;
  Offset _crosshairPos = const Offset(0.5, 0.5);
  int _currentSlice = 14;
  final int _totalSlices = 28;

  int get currentNavigationIndex => _currentNavigationIndex;
  ModalityType get selectedModality => _selectedModality;
  BrainRegion get selectedBrainRegion => _selectedBrainRegion;
  TechnicianCase get activeTechnicianCase => _activeTechnicianCase;
  CaseFile get activeCaseFile => _activeCaseFile;
  VisualEffectSettings get visualSettings => _visualSettings;
  int get technicianScore => _technicianScore;
  int get consecutiveCorrectStreak => _consecutiveCorrectStreak;
  Map<String, String> get technicianDecisions => _technicianDecisions;
  Map<String, String> get caseQuizAnswers => _caseQuizAnswers;

  // Language
  AppLanguage get currentLanguage => LocalizationService().currentLanguage;
  bool get isThai => LocalizationService().isThai;

  // Viewer Getters
  ScanPlane get activeScanPlane => _activeScanPlane;
  WindowPreset get activeWindowPreset => _activeWindowPreset;
  bool get isCinePlaying => _isCinePlaying;
  bool get showCalipers => _showCalipers;
  bool get showLandmarks => _showLandmarks;
  bool get isInvertedLUT => _isInvertedLUT;
  Offset get crosshairPos => _crosshairPos;
  int get currentSlice => _currentSlice;
  int get totalSlices => _totalSlices;

  ImagingModality get currentModalityInfo {
    return ModalitiesData.modalities.firstWhere(
      (m) => m.type == _selectedModality,
      orElse: () => ModalitiesData.modalities.first,
    );
  }

  void toggleLanguage() {
    LocalizationService().toggleLanguage();
    SoundService().playSound(SoundEffect.uiClick);
    notifyListeners();
  }

  void setLanguage(AppLanguage lang) {
    LocalizationService().setLanguage(lang);
    SoundService().playSound(SoundEffect.uiClick);
    notifyListeners();
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

  void setScanPlane(ScanPlane plane) {
    _activeScanPlane = plane;
    SoundService().playSound(SoundEffect.uiClick);
    notifyListeners();
  }

  void setWindowPreset(WindowPreset preset) {
    _activeWindowPreset = preset;
    SoundService().playSound(SoundEffect.uiClick);
    notifyListeners();
  }

  void setSlice(int slice) {
    _currentSlice = slice.clamp(1, _totalSlices);
    notifyListeners();
  }

  void toggleCinePlaying() {
    _isCinePlaying = !_isCinePlaying;
    SoundService().playSound(SoundEffect.uiClick);
    notifyListeners();
  }

  void toggleCalipers() {
    _showCalipers = !_showCalipers;
    SoundService().playSound(SoundEffect.uiClick);
    notifyListeners();
  }

  void toggleLandmarks() {
    _showLandmarks = !_showLandmarks;
    SoundService().playSound(SoundEffect.uiClick);
    notifyListeners();
  }

  void toggleInvertedLUT() {
    _isInvertedLUT = !_isInvertedLUT;
    SoundService().playSound(SoundEffect.uiClick);
    notifyListeners();
  }

  void setCrosshairPos(Offset pos) {
    _crosshairPos = Offset(pos.dx.clamp(0.05, 0.95), pos.dy.clamp(0.05, 0.95));
    notifyListeners();
  }

  void setActiveTechnicianCase(TechnicianCase techCase) {
    _activeTechnicianCase = techCase;
    SoundService().playSound(SoundEffect.uiClick);
    notifyListeners();
  }

  /// Selects a random RadTech technician case, prioritizing unsolved cases
  TechnicianCase randomizeTechnicianCase({ModalityType? modalityFilter}) {
    List<TechnicianCase> pool = TechnicianCasesData.cases;
    if (modalityFilter != null) {
      pool = pool.where((c) => c.modality == modalityFilter).toList();
      if (pool.isEmpty) pool = TechnicianCasesData.cases;
    }

    // Try finding an unanswered case first
    final unanswered = pool.where((c) => !_technicianDecisions.containsKey(c.id)).toList();
    List<TechnicianCase> candidatePool = unanswered.isNotEmpty ? unanswered : pool;

    // Filter out active case if more than 1 option is available
    if (candidatePool.length > 1) {
      candidatePool = candidatePool.where((c) => c.id != _activeTechnicianCase.id).toList();
    }

    final selected = candidatePool[_random.nextInt(candidatePool.length)];
    _activeTechnicianCase = selected;
    SoundService().playSound(SoundEffect.laserBeep);
    notifyListeners();
    return selected;
  }

  void recordTechnicianDecision(String caseId, String optionId, int scoreDelta) {
    _technicianDecisions[caseId] = optionId;
    _technicianScore += scoreDelta;
    if (scoreDelta > 0) {
      _consecutiveCorrectStreak++;
      SoundService().playSound(SoundEffect.successPing);
    } else {
      _consecutiveCorrectStreak = 0;
      SoundService().playSound(SoundEffect.alertWarning);
    }
    notifyListeners();
  }

  void resetTechnicianProgress() {
    _technicianDecisions.clear();
    _technicianScore = 0;
    _consecutiveCorrectStreak = 0;
    SoundService().playSound(SoundEffect.uiClick);
    notifyListeners();
  }

  void setActiveCaseFile(CaseFile caseFile) {
    _activeCaseFile = caseFile;
    SoundService().playSound(SoundEffect.uiClick);
    notifyListeners();
  }

  /// Selects a random PACS Diagnostic Case File
  CaseFile randomizeCaseFile({ModalityType? modalityFilter}) {
    List<CaseFile> pool = CaseFilesData.cases;
    if (modalityFilter != null) {
      pool = pool.where((c) => c.modality == modalityFilter).toList();
      if (pool.isEmpty) pool = CaseFilesData.cases;
    }

    // Try finding an unanswered case first
    final unanswered = pool.where((c) => !_caseQuizAnswers.containsKey(c.id)).toList();
    List<CaseFile> candidatePool = unanswered.isNotEmpty ? unanswered : pool;

    if (candidatePool.length > 1) {
      candidatePool = candidatePool.where((c) => c.id != _activeCaseFile.id).toList();
    }

    final selected = candidatePool[_random.nextInt(candidatePool.length)];
    _activeCaseFile = selected;
    SoundService().playSound(SoundEffect.laserBeep);
    notifyListeners();
    return selected;
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
