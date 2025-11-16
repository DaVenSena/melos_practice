import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.foregroundColor,
    this.disabledBackgroundColor,
    this.isLoading = false,
    this.padding,
    this.borderRadius,
    this.elevation,
    this.child,
    this.progressIndicatorSize,
    this.textStyle,
  });

  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? foregroundColor;
  final Color? disabledBackgroundColor;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final double? elevation;
  final Widget? child;
  final double? progressIndicatorSize;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveForegroundColor =
        foregroundColor ?? theme.colorScheme.onPrimary;
    final effectivePadding =
        padding ?? const EdgeInsets.symmetric(vertical: 16);
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(12);
    final effectiveElevation = elevation ?? 0;
    final effectiveIndicatorSize = progressIndicatorSize ?? 24;

    final buttonChild = child ??
        Text(
          text,
          style: textStyle,
        );

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: effectiveForegroundColor,
        disabledBackgroundColor: disabledBackgroundColor,
        padding: effectivePadding,
        shape: RoundedRectangleBorder(
          borderRadius: effectiveBorderRadius,
        ),
        elevation: effectiveElevation,
      ),
      child: isLoading
          ? SizedBox(
              height: effectiveIndicatorSize,
              width: effectiveIndicatorSize,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  effectiveForegroundColor,
                ),
              ),
            )
          : buttonChild,
    );
  }
}
