import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class HUDHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? tag;
  final Color? accentColor;
  final Widget? trailing;
  final bool showDivider;

  const HUDHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.tag,
    this.accentColor,
    this.trailing,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? AppColors.cyan;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Glowing Indicator Diamond
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(1.5),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.8),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (tag != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: color.withOpacity(0.4), width: 1),
                ),
                child: Text(
                  tag!.toUpperCase(),
                  style: AppTypography.hudLabel.copyWith(
                    color: color,
                    fontSize: 9,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                title.toUpperCase(),
                style: AppTypography.displaySmall.copyWith(
                  fontSize: 16,
                  letterSpacing: 2.0,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            trailing ?? const SizedBox.shrink(),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              subtitle!,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
        if (showDivider) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 36,
                height: 2,
                decoration: BoxDecoration(
                  color: color,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.8),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: color.withOpacity(0.18),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
