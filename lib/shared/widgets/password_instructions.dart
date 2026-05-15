import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';
import '../../../core/extensions/app_extensions.dart';
import '../../core/extensions/context_extension.dart';

/// A reusable widget to display password validation rules with colors
/// It reacts to password state and highlights rules green/red based on conditions
class PasswordInstructions extends StatelessWidget {
  final bool hasMinLength;
  final bool hasUppercase;
  final bool hasLowercase;
  final bool hasNumber;
  final bool hasSpecialChar;
  final bool showError; // True when user pressed set password button

  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color borderColor;

  final TextStyle? titleStyle;
  final TextStyle? ruleTextStyle;

  const PasswordInstructions({
    super.key,
    required this.hasMinLength,
    required this.hasUppercase,
    required this.hasLowercase,
    required this.hasNumber,
    required this.hasSpecialChar,
    this.showError = false,
    this.padding,
    this.borderRadius = 8,
    this.borderColor = AppColors.greyColor,
    this.titleStyle,
    this.ruleTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your password must contain:",
            style:
                titleStyle ??
                context.bodyMedium?.copyWith(color: AppColors.greyColor),
          ),
          4.verticalSpace,
          // _buildRuleRow("At least 6 characters", hasMinLength),
          PasswordRulesRow(
            text: "At least 6 characters",
            passInstructionConditionIsValid: hasMinLength,
            showError: showError,
          ),
          // _buildRuleRow("Contains uppercase letter", hasUppercase),
          PasswordRulesRow(
            text: "Contains uppercase letter",
            passInstructionConditionIsValid: hasUppercase,
            showError: showError,
          ),

          // _buildRuleRow("Contains lowercase letter", hasLowercase),
          PasswordRulesRow(
            text: "Contains lowercase letter",
            passInstructionConditionIsValid: hasLowercase,
            showError: showError,
          ),
          // _buildRuleRow("Contains number", hasNumber),
          PasswordRulesRow(
            text: "Contains number",
            passInstructionConditionIsValid: hasNumber,
            showError: showError,
          ),

          PasswordRulesRow(
            text: "Contains special character (!@#\$&*)",
            passInstructionConditionIsValid: hasSpecialChar,
            showError: showError,
          ),
        ],
      ),
    );
  }
}

class PasswordRulesRow extends StatelessWidget {
  final String text;

  final bool? passInstructionConditionIsValid;
  final bool? showError;

  const PasswordRulesRow({
    super.key,
    required this.text,

    required this.passInstructionConditionIsValid,
    this.showError,
  });

  @override
  Widget build(BuildContext context) {
    final color = passInstructionConditionIsValid == true
        ? AppColors.greenColor
        : (showError == true)
        ? AppColors.redColor
        : AppColors.greyColor;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.check, size: 15, color: color),
          6.horizontalSpace,
          Text(text, style: context.bodyMedium?.copyWith(color: color)),
        ],
      ),
    );
  }
}
