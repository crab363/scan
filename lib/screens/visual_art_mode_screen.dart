import 'package:flutter/material.dart';
import '../services/app_state_service.dart';
import '../services/audio_service.dart';
import '../theme/app_colors.dart';
import '../widgets/visual/concert_visual_canvas.dart';
import '../widgets/visual/visual_controls_overlay.dart';

class VisualArtModeScreen extends StatefulWidget {
  final VoidCallback onExit;

  const VisualArtModeScreen({super.key, required this.onExit});

  @override
  State<VisualArtModeScreen> createState() => _VisualArtModeScreenState();
}

class _VisualArtModeScreenState extends State<VisualArtModeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _beatController;

  @override
  void initState() {
    super.initState();
    _beatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
  }

  @override
  void dispose() {
    _beatController.dispose();
    super.dispose();
  }

  void _triggerBeat() {
    _beatController.forward(from: 0.0);
    SoundService().playSound(SoundEffect.laserBeep);
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateService();

    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final settings = appState.visualSettings;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            fit: StackFit.expand,
            children: [
              // Concert LED Visual Interactive Canvas
              AnimatedBuilder(
                animation: _beatController,
                builder: (context, _) {
                  return ConcertVisualCanvas(
                    settings: settings,
                    isInteractive: true,
                    beatPulseTrigger: 1.0 - _beatController.value,
                  );
                },
              ),

              // HUD & Parameter Customization Overlay
              VisualControlsOverlay(
                currentSettings: settings,
                onSettingsChanged: (newSettings) {
                  appState.setVisualSettings(newSettings);
                },
                onExit: widget.onExit,
                onTriggerBeat: _triggerBeat,
              ),
            ],
          ),
        );
      },
    );
  }
}
