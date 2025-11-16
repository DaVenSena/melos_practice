import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.borderSide,
    this.borderRadius,
    this.padding,
    this.child,
    this.style,
  });

  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;
  final BorderSide? borderSide;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveForegroundColor =
        textColor ?? (color != null ? theme.colorScheme.onSurface : null);

    final defaultStyle = TextButton.styleFrom(
      backgroundColor: color,
      foregroundColor: effectiveForegroundColor,
      padding: padding,
      shape: borderSide != null || borderRadius != null
          ? RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(8),
              side: borderSide ?? BorderSide.none,
            )
          : null,
    );

    final effectiveStyle = style ?? defaultStyle;

    final buttonChild = child ??
        Text(
          text,
          style: textColor != null ? TextStyle(color: textColor) : null,
        );

    return TextButton(
      onPressed: onPressed,
      style: effectiveStyle,
      child: buttonChild,
    );
  }
}
