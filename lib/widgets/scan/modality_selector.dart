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
                      child: _buildModalityCard(modality, isCompact: false),
                    ),
                  );
                }).toList(),
              )
            : SizedBox(
                height: 105,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: ModalitiesData.modalities.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final modality = ModalitiesData.modalities[index];
                    return SizedBox(
                      width: 250,
                      child: _buildModalityCard(modality, isCompact: true),
                    );
                  },
                ),
              );
      },
    );
  }

  Widget _buildModalityCard(ImagingModality modality, {required bool isCompact}) {
    final isSelected = modality.type == selectedModality;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          SoundService().playSound(SoundEffect.laserBeep);
          onModalitySelected(modality.type);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.all(isCompact ? 12 : 16),
          decoration: BoxDecoration(
            color: isSelected ? modality.accentColor.withOpacity(0.12) : AppColors.surface.withOpacity(0.7),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? modality.accentColor : AppColors.cardGlassBorder,
              width: isSelected ? 1.8 : 1.0,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: modality.accentColor.withOpacity(0.35),
                  blurRadius: 14,
                  spreadRadius: 1,
                  offset: const Offset(0, 3),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: modality.accentColor.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: modality.accentColor.withOpacity(0.5)),
                    ),
                    child: Text(
                      modality.tag,
                      style: AppTypography.hudLabel.copyWith(
                        color: modality.accentColor,
                        fontSize: 8.5,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  Icon(
                    isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                    color: isSelected ? modality.accentColor : AppColors.textMuted,
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    modality.name,
                    style: AppTypography.displaySmall.copyWith(
                      fontSize: isCompact ? 17 : 20,
                      letterSpacing: 1.5,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      modality.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(
                        color: modality.accentColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              if (!isCompact) ...[
                const SizedBox(height: 6),
                Text(
                  modality.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.shield_outlined, size: 11, color: AppColors.amber),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      modality.radiationLevel,
                      style: AppTypography.hudLabel.copyWith(
                        fontSize: 8.5,
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
