import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/extensions/color_filter_extension.dart';
import '../../../core/extensions/context_extension.dart';
import '../../../core/constants/constants.dart';

class BaseTextField extends StatefulWidget {
  const BaseTextField({
    super.key,
    this.hintText,
    this.hintTextColor = AppColors.greyColor,
    this.controller,
    this.initialValue,
    this.isPasswordField = false,
    this.validator,
    this.readOnly = false,
    this.enabled = true,
    this.keyboardType,
    this.textColor,
    this.suffixIconPath,
    this.cursorColor,
    this.suffixIcon,
    this.onSuffixTap,
    this.textAlign = TextAlign.left,
    this.textFieldBorder,
    this.onChanged,
    this.textCapitalization = TextCapitalization.sentences,
    this.fillColor,
    this.borderColor = AppColors.whiteColor,
    this.maxLines = 1,
    this.isExpand,
    this.prefixIcon,
    this.onTap,
    this.isShadow = false,
    this.maxLength,
    this.minLines,
    this.isRemoveFocus = true,
    this.suffixIconBackgroundColor,
    this.borderRadius,
    this.prefixIconPadding,
    this.contentPadding,
    this.focusNode,
    this.suffixWidget,
    this.labelText,
    this.inputFormatters,
  });

  final String? hintText;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final String? initialValue;
  final bool isPasswordField;
  final EdgeInsets? prefixIconPadding;
  final EdgeInsets? contentPadding;
  final FormFieldValidator<String>? validator;
  final bool readOnly;
  final bool enabled;
  final bool isShadow;
  final TextInputType? keyboardType;
  final Color? textColor;
  final Color? hintTextColor;
  final Color? cursorColor;
  final Color? fillColor, borderColor;
  final Color? suffixIconBackgroundColor;
  final Widget? prefixIcon;
  final Widget? suffixWidget;
  final String? suffixIcon;
  final VoidCallback? onSuffixTap, onTap;
  final TextAlign? textAlign;
  final InputBorder? textFieldBorder;
  final Function(String value)? onChanged;
  final TextCapitalization textCapitalization;
  final int maxLines;
  final bool? isExpand;
  final int? maxLength;
  final String? suffixIconPath;
  final int? minLines;
  final bool isRemoveFocus;
  final BorderRadius? borderRadius;
  final String? labelText;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<BaseTextField> createState() => _BaseTextFieldState();
}

class _BaseTextFieldState extends State<BaseTextField> {
  late final ValueNotifier<bool> _hidePasswordNotifier;
  late final ValueNotifier<bool> _focusNotifier;
  late final VoidCallback _focusListener;

  @override
  void initState() {
    super.initState();
    _hidePasswordNotifier = ValueNotifier(true);
    _focusNotifier = ValueNotifier(widget.focusNode?.hasFocus ?? false);
    _focusListener = () {
      _focusNotifier.value = widget.focusNode!.hasFocus;
    };
    widget.focusNode?.addListener(_focusListener);
  }

  @override
  void dispose() {
    widget.focusNode?.removeListener(_focusListener);
    _hidePasswordNotifier.dispose();
    _focusNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int? effectiveMaxLines = widget.maxLines;
    int? effectiveMinLines = widget.minLines;

    if (effectiveMinLines != null && effectiveMaxLines < effectiveMinLines) {
      effectiveMaxLines = effectiveMinLines;
    }

    final bool isSingleLine = effectiveMaxLines == 1;
    final double? textFieldHeight = isSingleLine ? 42 : null;

    return ValueListenableBuilder<bool>(
      valueListenable: _hidePasswordNotifier,
      builder: (context, hidePassword, child) {
        Widget textFormFieldBuilder(
          bool hasFocus,
          TextEditingValue? textValue,
        ) {
          final isNotEmpty = textValue?.text.isNotEmpty ?? false;
          return SizedBox(
            height: textFieldHeight,
            child: TextFormField(
              onTap: widget.onTap,
              focusNode: widget.focusNode,
              onTapOutside: widget.isRemoveFocus
                  ? (PointerDownEvent e) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    }
                  : null,
              style: context.bodyLarge!.copyWith(
                color:
                    widget.textColor ??
                    (widget.fillColor != null
                        ? (widget.fillColor!.isDark
                              ? Colors.white
                              : Colors.black)
                        : Theme.of(context).colorScheme.onSurface),
              ),
              cursorColor: widget.cursorColor ?? AppColors.primaryColor,
              inputFormatters: widget.inputFormatters,
              readOnly: widget.readOnly,
              enabled: widget.enabled,
              controller: widget.controller,
              initialValue: widget.initialValue,
              onChanged: widget.onChanged,
              maxLength: widget.maxLength,
              textCapitalization: widget.textCapitalization,
              textAlign: widget.textAlign ?? TextAlign.left,
              keyboardType: widget.keyboardType,
              maxLines: effectiveMaxLines,
              minLines: effectiveMinLines,
              expands: widget.isExpand ?? false,
              validator: widget.validator,
              obscureText: widget.isPasswordField ? hidePassword : false,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                isCollapsed: false,
                errorMaxLines: 2,
                prefixIcon: widget.prefixIcon != null
                    ? Padding(
                        padding:
                            widget.prefixIconPadding ??
                            const EdgeInsets.all(12),
                        child: widget.prefixIcon,
                      )
                    : null,
                suffixIcon: widget.suffixWidget != null
                    ? (widget.onSuffixTap != null
                          ? InkWell(
                              onTap: widget.onSuffixTap,
                              borderRadius: BorderRadius.circular(5),
                              child: widget.suffixWidget,
                            )
                          : widget.suffixWidget)
                    : (widget.isPasswordField
                          ? _hidePasswordIcon(hidePassword)
                          : (widget.suffixIconPath != null
                                ? InkWell(
                                    onTap: widget.onSuffixTap,
                                    borderRadius: BorderRadius.circular(5),
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      padding: const EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                        color: widget.suffixIconBackgroundColor,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: SvgPicture.asset(
                                        widget.suffixIconPath!,
                                        height: 20,
                                        width: 20,
                                        colorFilter: AppColors.primaryColor
                                            .filter(),
                                      ),
                                    ),
                                  )
                                : null)),
                hintText: widget.hintText,
                hintStyle: context.bodyMedium!.copyWith(
                  color: widget.hintTextColor ?? Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
                fillColor: widget.enabled
                    ? widget.fillColor
                    : Colors.grey.shade300,
                filled: true,
                counter: const Offstage(),
                contentPadding:
                    widget.contentPadding ??
                    (isSingleLine
                        ? EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: context.height * 0.01,
                          )
                        : EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: context.height * 0.012,
                          )),
                errorBorder: _inputBorder(),
                focusedErrorBorder:
                    widget.textFieldBorder ??
                    _inputBorder(color: AppColors.primaryColor),
                enabledBorder: widget.textFieldBorder ?? _inputBorder(),
                disabledBorder: widget.textFieldBorder ?? _inputBorder(),
                focusedBorder: widget.textFieldBorder ?? _inputBorder(),
                border: widget.textFieldBorder ?? _inputBorder(),
                labelText: widget.labelText,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                labelStyle: context.bodyMedium!.copyWith(
                  color: isNotEmpty || hasFocus
                      ? AppColors.primaryColor
                      : AppColors.greyColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }

        if (widget.controller != null) {
          return ValueListenableBuilder<TextEditingValue>(
            valueListenable: widget.controller!,
            builder: (context, textValue, child) {
              return ValueListenableBuilder<bool>(
                valueListenable: _focusNotifier,
                builder: (context, hasFocus, child) {
                  return textFormFieldBuilder(hasFocus, textValue);
                },
              );
            },
          );
        } else {
          return ValueListenableBuilder<bool>(
            valueListenable: _focusNotifier,
            builder: (context, hasFocus, child) {
              return textFormFieldBuilder(hasFocus, null);
            },
          );
        }
      },
    );
  }

  InputBorder _inputBorder({Color? color}) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: color ?? widget.borderColor ?? AppColors.transparentColor,
      ),
      borderRadius:
          widget.borderRadius ?? const BorderRadius.all(Radius.circular(12.0)),
    );
  }

  void _toggleHidePassword() {
    _hidePasswordNotifier.value = !_hidePasswordNotifier.value;
  }

  Widget _hidePasswordIcon(bool hidePassword) {
    return IconButton(
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.zero,
      ),
      onPressed: _toggleHidePassword,
      icon: Transform.rotate(
        angle: 180 * 3.1415926535 / 180,
        child: Icon(
          hidePassword
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: AppColors.blackColor.withAlpha(80),
        ),
      ),
    );
  }
}
