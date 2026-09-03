import 'dart:async';
import 'package:flutter/foundation.dart';

enum SoundEffect {
  uiClick,
  laserBeep,
  mriGradientPulse,
  mriRfChirp,
  ctGantryHum,
  xrayExposure,
  alertWarning,
  successPing,
  ambientSynth,
}

class SoundService extends ChangeNotifier {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  bool _isMuted = false;
  double _volume = 0.8;
  String _activeAudioTrack = 'AMBIENT SCANNER IDLE';
  double _audioActivityLevel = 0.3;
  Timer? _equalizerTimer;

  bool get isMuted => _isMuted;
  double get volume => _volume;
  String get activeAudioTrack => _activeAudioTrack;
  double get audioActivityLevel => _isMuted ? 0.0 : _audioActivityLevel;

  void initialize() {
    _startEqualizerSimulation();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    notifyListeners();
  }

  void setVolume(double val) {
    _volume = val.clamp(0.0, 1.0);
    if (_volume == 0) {
      _isMuted = true;
    } else {
      _isMuted = false;
    }
    notifyListeners();
  }

  void playSound(SoundEffect effect) {
    if (_isMuted) return;

    switch (effect) {
      case SoundEffect.uiClick:
        _activeAudioTrack = 'UI_TACTILE_TICK';
        _audioActivityLevel = 0.45;
        break;
      case SoundEffect.laserBeep:
        _activeAudioTrack = 'LASER_ALIGN_OPTICAL';
        _audioActivityLevel = 0.75;
        break;
      case SoundEffect.mriGradientPulse:
        _activeAudioTrack = 'MRI_GRADIENT_BIPLANE_110dB';
        _audioActivityLevel = 0.95;
        break;
      case SoundEffect.mriRfChirp:
        _activeAudioTrack = 'RF_LARMOR_CHIRP_127.7MHz';
        _audioActivityLevel = 0.85;
        break;
      case SoundEffect.ctGantryHum:
        _activeAudioTrack = 'CT_SLIPRING_4_ROT_SEC';
        _audioActivityLevel = 0.65;
        break;
      case SoundEffect.xrayExposure:
        _activeAudioTrack = 'XRAY_ANODE_ROTOR_BUZZ';
        _audioActivityLevel = 0.80;
        break;
      case SoundEffect.alertWarning:
        _activeAudioTrack = 'HUD_ARTIFACT_WARNING';
        _audioActivityLevel = 0.90;
        break;
      case SoundEffect.successPing:
        _activeAudioTrack = 'DIAGNOSTIC_CONFIRM_CHIME';
        _audioActivityLevel = 0.70;
        break;
      case SoundEffect.ambientSynth:
        _activeAudioTrack = 'SCANVERSE_SUBLIMINAL_DRONE';
        _audioActivityLevel = 0.35;
        break;
    }

    notifyListeners();

    // Auto-decay peak activity back to baseline ambient level
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!_isMuted) {
        _audioActivityLevel = 0.25;
        notifyListeners();
      }
    });
  }

  void _startEqualizerSimulation() {
    _equalizerTimer?.cancel();
    _equalizerTimer = Timer.periodic(const Duration(milliseconds: 120), (timer) {
      if (!_isMuted) {
        notifyListeners();
      }
    });
  }

  void stop() {
    _equalizerTimer?.cancel();
  }

  @override
  void dispose() {
    _equalizerTimer?.cancel();
    super.dispose();
  }
}
