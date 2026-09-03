import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../services/audio_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class AudioEqualizerHUD extends StatelessWidget {
  final bool compact;

  const AudioEqualizerHUD({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final soundService = SoundService();

    return ListenableBuilder(
      listenable: soundService,
      builder: (context, _) {
        final isMuted = soundService.isMuted;
        final activity = soundService.audioActivityLevel;

        if (compact) {
          return IconButton(
            tooltip: isMuted ? 'Unmute Audio Simulation' : 'Mute Audio Simulation',
            icon: Icon(
              isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
              color: isMuted ? AppColors.textMuted : AppColors.cyan,
              size: 20,
            ),
            onPressed: () {
              soundService.toggleMute();
              soundService.playSound(SoundEffect.uiClick);
            },
          );
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(0.85),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isMuted ? AppColors.textMuted.withOpacity(0.3) : AppColors.cyan.withOpacity(0.4),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Equalizer 4 animated bars
              SizedBox(
                width: 24,
                height: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(4, (index) {
                    final random = math.Random(DateTime.now().millisecond + index * 100);
                    final barHeight = isMuted ? 3.0 : (6.0 + random.nextDouble() * 10.0 * (activity + 0.3)).clamp(3.0, 16.0);

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      width: 3.5,
                      height: barHeight,
                      decoration: BoxDecoration(
                        color: isMuted ? AppColors.textMuted : (index == 3 ? AppColors.emerald : AppColors.cyan),
                        borderRadius: BorderRadius.circular(1.5),
                        boxShadow: isMuted
                            ? null
                            : [
                                BoxShadow(
                                  color: AppColors.cyan.withOpacity(0.6),
                                  blurRadius: 4,
                                ),
                              ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(width: 8),
              // Track Label
              Text(
                isMuted ? 'AUDIO MUTED' : soundService.activeAudioTrack,
                style: AppTypography.hudLabel.copyWith(
                  fontSize: 9,
                  color: isMuted ? AppColors.textMuted : AppColors.textSecondary,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(width: 8),
              // Mute Toggle Icon Button
              InkWell(
                onTap: () {
                  soundService.toggleMute();
                  soundService.playSound(SoundEffect.uiClick);
                },
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Icon(
                    isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                    color: isMuted ? AppColors.alertRed : AppColors.cyan,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
