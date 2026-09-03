import 'package:flutter/material.dart';
import '../../models/imaging_modality.dart';
import '../../data/modalities_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../services/audio_service.dart';

class ModalitySelector extends StatelessWidget {
  final ModalityType selectedModality;
  final ValueChanged<ModalityType> onModalitySelected;

  const ModalitySelector({
    super.key,
    required this.selectedModality,
    required this.onModalitySelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 700;

        return isDesktop
            ? Row(
                children: ModalitiesData.modalities.map((modality) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: _buildModalityCard(modality),
                    ),
                  );
                }).toList(),
              )
            : Column(
                children: ModalitiesData.modalities.map((modality) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildModalityCard(modality),
                  );
                }).toList(),
              );
      },
    );
  }

  Widget _buildModalityCard(ImagingModality modality) {
    final isSelected = modality.type == selectedModality;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          SoundService().playSound(SoundEffect.laserBeep);
          onModalitySelected(modality.type);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? modality.accentColor.withOpacity(0.12) : AppColors.surface.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? modality.accentColor : AppColors.cardGlassBorder,
              width: isSelected ? 2.0 : 1.0,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: modality.accentColor.withOpacity(0.4),
                  blurRadius: 18,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: modality.accentColor.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: modality.accentColor.withOpacity(0.5)),
                    ),
                    child: Text(
                      modality.tag,
                      style: AppTypography.hudLabel.copyWith(
                        color: modality.accentColor,
                        fontSize: 9,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  Icon(
                    isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                    color: isSelected ? modality.accentColor : AppColors.textMuted,
                    size: 18,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                modality.name,
                style: AppTypography.displaySmall.copyWith(
                  fontSize: 22,
                  letterSpacing: 2.0,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                modality.fullName,
                style: AppTypography.bodySmall.copyWith(
                  color: modality.accentColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                modality.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.shield_outlined, size: 12, color: AppColors.amber),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      modality.radiationLevel,
                      style: AppTypography.hudLabel.copyWith(
                        fontSize: 9,
                        color: AppColors.textMuted,
                        letterSpacing: 0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
