import 'package:flutter/material.dart';
import '../../../core/extensions/context_extension.dart';

import '../../../core/constants/constants.dart';
import 'base_button.dart';

class AppButtons extends StatelessWidget {
  final Widget? child;
  final String? text;

  final VoidCallback? onPressed;

  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;
  final Color? borderColor;

  final double borderWidth;
  final double elevation;
  final double? borderRadius;
  final Size? size;
  final EdgeInsets? padding;
  final bool? isLoading;

  const AppButtons.filled({
    this.child,
    this.text,
    required this.onPressed,
    super.key,
    this.backgroundColor = AppColors.primaryColor,
    this.foregroundColor = AppColors.whiteColor,
    this.disabledBackgroundColor = AppColors.greyColor,
    this.disabledForegroundColor = AppColors.whiteColor,
    this.borderColor = AppColors.transparentColor,
    this.borderWidth = 1,
    this.size,
    this.padding,
    this.borderRadius,
    this.isLoading,
  }) : elevation = 5.0;

  const AppButtons.elevated({
    this.child,
    this.text,
    required this.onPressed,
    super.key,
    this.backgroundColor = AppColors.primaryColor,
    this.foregroundColor = AppColors.whiteColor,
    this.disabledBackgroundColor = AppColors.greyColor,
    this.disabledForegroundColor = AppColors.greyColor,
    this.borderColor = AppColors.transparentColor,
    this.borderWidth = 1,
    this.elevation = 6.0,
    this.size,
    this.padding,
    this.borderRadius = 100,
    this.isLoading,
  });

  const AppButtons.outlined({
    this.child,
    this.text,
    required this.onPressed,
    super.key,
    this.borderColor = AppColors.primaryColor,
    this.borderWidth = 1,
    this.foregroundColor = AppColors.primaryColor,
    this.disabledForegroundColor = AppColors.greyColor,
    this.size,
    this.padding,
    this.borderRadius,
    this.isLoading,
  }) : backgroundColor = Colors.transparent,
       disabledBackgroundColor = Colors.transparent,
       elevation = 0.0;

  const AppButtons.text({
    this.child,
    this.text,
    required this.onPressed,
    super.key,
    this.foregroundColor = AppColors.primaryColor,
    this.disabledForegroundColor = AppColors.greyColor,
    this.size,
    this.padding,
    this.borderRadius,
    this.isLoading,
  }) : backgroundColor = Colors.transparent,
       disabledBackgroundColor = Colors.transparent,
       borderColor = Colors.transparent,
       borderWidth = 0.0,
       elevation = 0.0;

  @override
  Widget build(BuildContext context) {
    final Widget buttonChild =
        child ??
        (text != null
            ? Text(
                text!,

                style: context.bodyLarge?.copyWith(
                  color: foregroundColor,
                  fontWeight: FontWeight.bold,
                ),
              )
            : const Text('')); // fallback to empty text

    return BaseButton(
      onPressed: onPressed,
      isLoading: isLoading ?? false,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledForegroundColor: disabledForegroundColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      elevation: elevation,
      padding: padding,
      borderRadius: borderRadius,
      size: size ?? Size.fromHeight(50),
      // safe default
      child: buttonChild,
    );
  }
}
