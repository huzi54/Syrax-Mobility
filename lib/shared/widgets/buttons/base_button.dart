import 'package:flutter/material.dart';
import '../../../core/extensions/context_extension.dart';

import '../../../core/constants/constants.dart';

class BaseButton extends StatelessWidget {
  const BaseButton({
    required this.child,
    required this.onPressed,
    super.key,
    this.backgroundColor = AppColors.primaryColor,
    this.foregroundColor = AppColors.whiteColor,
    this.size,
    this.disabledBackgroundColor = AppColors.greyColor,
    this.disabledForegroundColor = AppColors.greyColor,
    this.borderColor = AppColors.transparentColor,
    this.borderWidth = 1,
    this.elevation = 0.0,
    this.padding,
    this.borderRadius = 18.0,
    this.isLoading = false,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? disabledBackgroundColor;
  final Color? foregroundColor;
  final Color? disabledForegroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double? borderRadius;
  final double elevation;
  final EdgeInsets? padding;
  final Size? size;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.disabled) || isLoading) {
          return disabledBackgroundColor;
        }
        return backgroundColor;
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.disabled) || isLoading) {
          return disabledForegroundColor;
        }
        return foregroundColor;
      }),
      padding: WidgetStateProperty.all<EdgeInsetsGeometry?>(
        padding ?? const EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.0),
      ),
      shape: WidgetStateProperty.all<OutlinedBorder?>(
        RoundedRectangleBorder(
          side: BorderSide(
            color: borderColor ?? Colors.transparent,
            width: borderColor == Colors.transparent ? 0 : borderWidth,
          ),
          borderRadius: BorderRadius.circular((borderRadius ?? 12.0)),
        ),
      ),
      textStyle: WidgetStateProperty.all<TextStyle?>(
        context.theme.textTheme.bodyLarge,
      ),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minimumSize: size == null ? null : WidgetStateProperty.all<Size?>(size),
      elevation: WidgetStateProperty.all<double>(elevation),
    );

    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: isLoading
          ? const SizedBox(
              width: 24.0,
              height: 24.0,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.whiteColor,
              ),
            )
          : FittedBox(
              fit: BoxFit.scaleDown,
              child: DefaultTextStyle(
                style: context.theme.textTheme.bodyLarge!,
                maxLines: 1,
                child: child,
              ),
            ),
    );
  }
}
