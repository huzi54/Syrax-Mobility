import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import '../../core/extensions/context_extension.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool showBackButton;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? titleColor;
  final double? fontSize;
  final void Function()? onPressed;

  const MyAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.showBackButton = true,
    this.actions,
    this.backgroundColor,
    this.titleColor,
    this.fontSize,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.primaryColor,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      leading: showBackButton
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: titleColor ?? AppColors.white,
                size: 20, // Icon size thoda adjust kiya
              ),
              onPressed: onPressed ?? () => Navigator.pop(context),
            )
          : null,
      title: Column(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Center aligned for AppBar
        mainAxisSize: MainAxisSize.min,
        children: [
          // FittedBox text ko automatic chota karega agar space kam hogi
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: context.titleMedium?.copyWith(
                color: titleColor ?? AppColors.white,
                fontSize: fontSize ?? 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          if (subtitle != null)
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 12,
                  color: (titleColor ?? AppColors.white).withOpacity(0.8),
                ),
              ),
            ),
        ],
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
