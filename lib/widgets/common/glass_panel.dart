import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? borderColor;
  final Color? backgroundColor;
  final double blur;
  final bool showCornerBrackets;
  final VoidCallback? onTap;

  const GlassPanel({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 16,
    this.borderColor,
    this.backgroundColor,
    this.blur = 12.0,
    this.showCornerBrackets = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = borderColor ?? AppColors.cardGlassBorder;
    final effectiveBgColor = backgroundColor ?? AppColors.cardGlass;

    Widget content = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: effectiveBorderColor, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: (borderColor ?? AppColors.cyan).withOpacity(0.08),
            blurRadius: 20,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Stack(
            children: [
              // Subtle gradient sheen
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        (borderColor ?? AppColors.cyan).withOpacity(0.05),
                        Colors.transparent,
                        Colors.black.withOpacity(0.2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              // Corner brackets for high-tech HUD aesthetic
              if (showCornerBrackets)
                Positioned.fill(
                  child: CustomPaint(
                    painter: _CornerBracketPainter(
                      color: (borderColor ?? AppColors.cyan).withOpacity(0.6),
                      bracketLength: 12,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              Padding(
                padding: padding ?? const EdgeInsets.all(16),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          splashColor: (borderColor ?? AppColors.cyan).withOpacity(0.2),
          highlightColor: (borderColor ?? AppColors.cyan).withOpacity(0.1),
          child: content,
        ),
      );
    }

    return content;
  }
}

class _CornerBracketPainter extends CustomPainter {
  final Color color;
  final double bracketLength;
  final double strokeWidth;

  _CornerBracketPainter({
    required this.color,
    required this.bracketLength,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Top-Left
    canvas.drawLine(const Offset(4, 4), Offset(4 + bracketLength, 4), paint);
    canvas.drawLine(const Offset(4, 4), Offset(4, 4 + bracketLength), paint);

    // Top-Right
    canvas.drawLine(Offset(size.width - 4, 4), Offset(size.width - 4 - bracketLength, 4), paint);
    canvas.drawLine(Offset(size.width - 4, 4), Offset(size.width - 4, 4 + bracketLength), paint);

    // Bottom-Left
    canvas.drawLine(Offset(4, size.height - 4), Offset(4 + bracketLength, size.height - 4), paint);
    canvas.drawLine(Offset(4, size.height - 4), Offset(4, size.height - 4 - bracketLength), paint);

    // Bottom-Right
    canvas.drawLine(Offset(size.width - 4, size.height - 4), Offset(size.width - 4 - bracketLength, size.height - 4), paint);
    canvas.drawLine(Offset(size.width - 4, size.height - 4), Offset(size.width - 4, size.height - 4 - bracketLength), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
