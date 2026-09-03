import 'package:flutter/material.dart';
import '../services/app_state_service.dart';
import '../theme/app_colors.dart';
import '../widgets/visual/concert_visual_canvas.dart';
import '../widgets/visual/visual_controls_overlay.dart';

class VisualArtModeScreen extends StatefulWidget {
  final VoidCallback onExit;

  const VisualArtModeScreen({super.key, required this.onExit});

  @override
  State<VisualArtModeScreen> createState() => _VisualArtModeScreenState();
}

class _VisualArtModeScreenState extends State<VisualArtModeScreen> {
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
              ConcertVisualCanvas(
                settings: settings,
                isInteractive: true,
              ),

              // HUD & Parameter Customization Overlay
              VisualControlsOverlay(
                currentSettings: settings,
                onSettingsChanged: (newSettings) {
                  appState.setVisualSettings(newSettings);
                },
                onExit: widget.onExit,
              ),
            ],
          ),
        );
      },
    );
  }
}
