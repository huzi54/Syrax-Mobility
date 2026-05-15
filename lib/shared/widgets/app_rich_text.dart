import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AppRichText extends StatelessWidget {
  final String normalText;
  final String actionText;
  final VoidCallback onTap;
  final TextStyle? normalStyle;
  final TextStyle? actionStyle;
  final TextAlign textAlign;

  const AppRichText({
    super.key,
    required this.normalText,
    required this.actionText,
    required this.onTap,
    this.normalStyle,
    this.actionStyle,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        children: [
          TextSpan(
            text: normalText,
            style: normalStyle ?? Theme.of(context).textTheme.bodySmall,
          ),
          TextSpan(
            text: actionText,
            style:
                actionStyle ??
                Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}
