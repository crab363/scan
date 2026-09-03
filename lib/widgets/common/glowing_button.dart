import 'package:flutter/material.dart';
import '../../services/audio_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class GlowingButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color primaryColor;
  final Color? secondaryColor;
  final bool isSecondary;
  final double height;
  final double? width;
  final bool isLoading;

  const GlowingButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.primaryColor = AppColors.cyan,
    this.secondaryColor,
    this.isSecondary = false,
    this.height = 48,
    this.width,
    this.isLoading = false,
  });

  @override
  State<GlowingButton> createState() => _GlowingButtonState();
}

class _GlowingButtonState extends State<GlowingButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.primaryColor;
    final secColor = widget.secondaryColor ?? widget.primaryColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: () {
          SoundService().playSound(SoundEffect.uiClick);
          widget.onPressed();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: widget.width,
          height: widget.height,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          transform: Matrix4.identity()..scale(_isPressed ? 0.97 : (_isHovered ? 1.02 : 1.0)),
          decoration: BoxDecoration(
            gradient: widget.isSecondary
                ? null
                : LinearGradient(
                    colors: [color, secColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            color: widget.isSecondary ? color.withOpacity(_isHovered ? 0.18 : 0.08) : null,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: widget.isSecondary ? color.withOpacity(_isHovered ? 0.9 : 0.45) : Colors.white.withOpacity(0.3),
              width: 1.2,
            ),
            boxShadow: [
              if (!widget.isSecondary || _isHovered)
                BoxShadow(
                  color: color.withOpacity(_isHovered ? 0.55 : 0.35),
                  blurRadius: _isHovered ? 20 : 12,
                  spreadRadius: _isHovered ? 2 : 0,
                  offset: const Offset(0, 3),
                ),
            ],
          ),
          child: Row(
            mainAxisSize: widget.width == null ? MainAxisSize.min : MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.isLoading) ...[
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.isSecondary ? color : AppColors.background,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ] else if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: 18,
                  color: widget.isSecondary ? color : AppColors.background,
                ),
                const SizedBox(width: 10),
              ],
              Text(
                widget.text.toUpperCase(),
                style: AppTypography.button.copyWith(
                  fontSize: 12,
                  letterSpacing: 2.0,
                  color: widget.isSecondary ? color : AppColors.background,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
