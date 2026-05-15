import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show TextInputFormatter;
import '../../../core/extensions/app_extensions.dart';
import '../../../core/extensions/context_extension.dart';

import '../../../core/constants/constants.dart';
import 'base_text_field.dart';
import '../../../core/constants/app_strings.dart';

class AppTextField extends StatelessWidget {
  final String title;
  final Widget? titleWidget;
  final double? height;
  final bool? hideTitle;
  final bool isRequired;
  final BaseTextField customTextField;
  final Color? headingColor;

  const AppTextField._({
    required this.title,
    required this.customTextField,
    required this.hideTitle,
    this.titleWidget,
    this.height,
    this.isRequired = false,
    this.headingColor = AppColors.blackColor,
  });

  factory AppTextField.email({
    Key? key,
    String? hintText,
    String? heading,
    TextEditingController? controller,
    FormFieldValidator<String>? validator,
    bool readOnly = false,
    bool enabled = true,
    TextInputType? keyboardType,
    Color? textColor,
    Color? hintTextColor,
    Color? cursorColor,
    Widget? prefixIcon,
    String? suffixIcon,
    VoidCallback? onSuffixTap,
    TextAlign? textAlign,
    InputBorder? textFieldBorder,
    Function(String value)? onChanged,
    TextCapitalization textCapitalization = TextCapitalization.sentences,
    Color fillColor = AppColors.whiteColor,
    Color borderColor = AppColors.greyColor,
    int maxLines = 1,
    bool isRequired = false,
    int? maxLength,
    bool isRemoveFocus = true,
    double? height,
    Color suffixIconBackgroundColor = AppColors.transparentColor,
    EdgeInsets? prefixIconPadding,
    EdgeInsets? contentPadding,
    bool? hideTitle = false,
    FocusNode? focusNode,
    Color? headingColor,
    Widget? titleWidget,
  }) {
    return AppTextField._(
      title: heading ?? AppStrings.email,
      height: height,
      titleWidget: titleWidget,
      hideTitle: hideTitle,
      headingColor: headingColor,
      isRequired: isRequired,
      customTextField: BaseTextField(
        hintText: hintText,
        controller: controller,
        focusNode: focusNode,
        validator: validator,
        readOnly: readOnly,
        enabled: enabled,
        keyboardType: TextInputType.emailAddress,
        textColor: textColor,
        hintTextColor: hintTextColor,
        cursorColor: cursorColor,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        onSuffixTap: onSuffixTap,
        textAlign: textAlign ?? TextAlign.left,
        textFieldBorder: textFieldBorder,
        onChanged: onChanged,
        textCapitalization: textCapitalization,
        fillColor: fillColor,
        borderColor: borderColor,
        maxLines: maxLines,
        maxLength: maxLength,
        isRemoveFocus: isRemoveFocus,
        suffixIconBackgroundColor: suffixIconBackgroundColor,
        prefixIconPadding: prefixIconPadding,
        contentPadding: contentPadding,
      ),
    );
  }

  factory AppTextField.basic({
    Key? key,
    String? hintText,
    String? labelText,
    String? heading,
    String? initialValue,

    TextEditingController? controller,
    FormFieldValidator<String>? validator,
    bool readOnly = false,
    bool enabled = true,
    TextInputType? keyboardType,
    Color? textColor,
    Color? cursorColor,
    Widget? prefixIcon,
    String? suffixIcon,
    VoidCallback? onSuffixTap,
    TextAlign? textAlign,
    InputBorder? textFieldBorder,
    Function(String value)? onChanged,
    TextCapitalization textCapitalization = TextCapitalization.sentences,
    Color fillColor = AppColors.whiteColor,
    Color? hintTextColor,
    Color borderColor = AppColors.greyColor,
    int maxLines = 1,
    bool isRequired = false,
    String? suffixIconPath,
    int? minLines = 1,
    bool isRemoveFocus = true,
    double? height,
    Color suffixIconBackgroundColor = AppColors.transparentColor,
    EdgeInsets? prefixIconPadding,
    EdgeInsets? contentPadding,
    bool? hideTitle = false,
    FocusNode? focusNode,
    Color? headingColor,
    Widget? titleWidget,
    Widget? suffixWidget,
    Function()? onTap,
    TextStyle? textStyle,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return AppTextField._(
      title: heading ?? AppStrings.basic,
      height: height,
      hideTitle: hideTitle,
      headingColor: headingColor,
      titleWidget: titleWidget,
      isRequired: isRequired,
      customTextField: BaseTextField(
        onTap: onTap,
        hintText: hintText,
        initialValue: initialValue,
        suffixIconPath: suffixIconPath,
        suffixWidget: suffixWidget,
        inputFormatters: inputFormatters,
        controller: controller,
        focusNode: focusNode,
        validator: validator,
        readOnly: readOnly,
        enabled: enabled,
        keyboardType: keyboardType,
        textColor: textColor,
        hintTextColor: hintTextColor,
        cursorColor: cursorColor,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        onSuffixTap: onSuffixTap,
        textAlign: textAlign ?? TextAlign.left,
        textFieldBorder: textFieldBorder,
        onChanged: onChanged,
        textCapitalization: textCapitalization,
        fillColor: fillColor,
        borderColor: borderColor,
        maxLines: maxLines,

        minLines: minLines,
        isRemoveFocus: isRemoveFocus,

        suffixIconBackgroundColor: suffixIconBackgroundColor,
        prefixIconPadding: prefixIconPadding,
        contentPadding: contentPadding,
        labelText: labelText,
      ),
    );
  }

  factory AppTextField.password({
    Key? key,
    String? hintText,
    String? labelText,
    double? height,
    String? heading,
    String? suffixIconPath,
    TextEditingController? controller,
    FormFieldValidator<String>? validator,
    bool readOnly = false,
    bool enabled = true,
    TextInputType? keyboardType,
    Color? textColor,
    Color? cursorColor,
    Widget? prefixIcon,
    String? suffixIcon,
    VoidCallback? onSuffixTap,

    TextAlign? textAlign,
    InputBorder? textFieldBorder,
    Function(String value)? onChanged,
    TextCapitalization textCapitalization = TextCapitalization.sentences,
    Color fillColor = AppColors.whiteColor,
    Color? hintTextColor,
    Color borderColor = AppColors.greyColor,
    int maxLines = 1,
    bool isRequired = false,
    int? maxLength,
    int? minLength,
    bool isRemoveFocus = true,
    Color suffixIconBackgroundColor = AppColors.transparentColor,
    EdgeInsets? prefixIconPadding,
    EdgeInsets? contentPadding,
    bool? hideTitle = false,
    FocusNode? focusNode,
    Color? headingColor,
    Widget? titleWidget,
  }) {
    return AppTextField._(
      title: heading ?? "Password",
      height: height,
      hideTitle: hideTitle,
      headingColor: headingColor,
      titleWidget: titleWidget,
      isRequired: isRequired,
      customTextField: BaseTextField(
        hintText: hintText,
        controller: controller,
        focusNode: focusNode,
        isPasswordField: true,
        validator: validator,
        readOnly: readOnly,
        enabled: enabled,
        keyboardType: keyboardType,
        textColor: textColor,
        hintTextColor: hintTextColor,
        cursorColor: cursorColor,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        onSuffixTap: onSuffixTap,
        textAlign: textAlign ?? TextAlign.left,
        textFieldBorder: textFieldBorder,
        onChanged: onChanged,
        textCapitalization: textCapitalization,
        fillColor: fillColor,
        borderColor: borderColor,
        maxLines: maxLines,
        maxLength: maxLength,
        isRemoveFocus: isRemoveFocus,
        suffixIconBackgroundColor: suffixIconBackgroundColor,
        prefixIconPadding: prefixIconPadding,
        contentPadding: contentPadding,
        labelText: labelText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (titleWidget != null) ...<Widget>[
          titleWidget ?? const SizedBox(),
          4.0.verticalSpace,
        ],
        if (!(hideTitle ?? false)) ...<Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: RichText(
              text: TextSpan(
                children: <InlineSpan>[
                  TextSpan(
                    text: title,
                    style: context.bodyMedium?.copyWith(color: headingColor),
                  ),
                  if (isRequired)
                    TextSpan(
                      text: "*",
                      style: context.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.redColor,
                      ),
                    ),
                ],
              ),
            ),
          ),
          3.0.verticalSpace,
        ],
        SizedBox(height: height, child: customTextField),
        6.0.verticalSpace,
      ],
    );
  }
}
