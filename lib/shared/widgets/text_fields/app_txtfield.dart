import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imo_mobility/core/constants/constants.dart';
import 'package:imo_mobility/core/extensions/context_extension.dart';

class AppTextFields extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon; // ✅ NEW
  final bool isPassword;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final double? height;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  const AppTextFields({
    super.key,
    required this.controller,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon, // ✅ NEW
    this.isPassword = false,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.height,
    this.maxLines,
    this.maxLength,
    this.inputFormatters,
  });

  /// 🔵 Email Constructor
  factory AppTextFields.email({
    Key? key,
    required TextEditingController controller,
    ValueChanged<String>? onChanged,
    bool? enabled,
    required String hintText,
  }) {
    return AppTextFields(
      key: key,
      controller: controller,
      enabled: enabled ?? true,
      hintText: hintText,

      keyboardType: TextInputType.emailAddress,
      prefixIcon: const Icon(Icons.email_outlined),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Email is required";
        }

        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

        if (!emailRegex.hasMatch(value)) {
          return "Enter valid email";
        }

        return null;
      },
    );
  }

  /// 🔵 Password Constructor
  factory AppTextFields.password({
    Key? key,
    required TextEditingController controller,
    required String hintText,
    ValueChanged<String>? onChanged,
  }) {
    return AppTextFields(
      key: key,
      controller: controller,
      hintText: hintText,
      obscureText: true,
      isPassword: true,
      prefixIcon: const Icon(Icons.lock_outline),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Password is required";
        }

        if (value.length < 6) {
          return "Password must be at least 6 characters";
        }

        return null;
      },
    );
  }

  @override
  State<AppTextFields> createState() => _AppTextFieldsState();
}

class _AppTextFieldsState extends State<AppTextFields> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 70,
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.isPassword ? _obscure : false,
        enabled: widget.enabled,
        validator: widget.validator,

        maxLines: widget.maxLines ?? 1,
        maxLength: widget.maxLength,
        onChanged: widget.onChanged,

        style: context.bodyLarge,
        inputFormatters: widget.inputFormatters,
        decoration: InputDecoration(
          fillColor: Colors.white.withValues(alpha: .2),
          counterText: "",
          hintText: widget.hintText,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          prefixIcon: widget.prefixIcon,

          /// ✅ Suffix logic
          suffixIcon:
              widget.suffixIcon ??
              (widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscure = !_obscure;
                        });
                      },
                    )
                  : null),

          border: _border(),
          enabledBorder: _border(),
          focusedBorder: _border(color: AppColors.orangePrimary),
          errorBorder: _border(color: Colors.red),
          focusedErrorBorder: _border(color: Colors.red),
        ),
      ),
    );
  }

  OutlineInputBorder _border({Color color = Colors.grey}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: color, width: 1),
    );
  }
}
