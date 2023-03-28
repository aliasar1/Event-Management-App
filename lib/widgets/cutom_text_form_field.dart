import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../manager/color_manager.dart';
import '../manager/font_manager.dart';
import '../manager/values_manager.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? initialValue;
  final String? labelText;
  final bool? readOnly;
  final IconData? prefixIconData;
  final IconData? suffixIconData;
  final bool? obscureText;
  final void Function(String?)? onChanged;
  final void Function()? onEditingComplete;
  final void Function()? onSuffixTap;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String?)? onSave;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final void Function(String)? onFieldSubmit;
  final FocusNode? focusNode;
  final int? maxLines;
  final int? maxLength;
  final Color? fillColor;
  final bool? autofocus;
  final TextCapitalization? textCapitalization;
  // bool readOnly;

  const CustomTextFormField({
    Key? key,
    this.initialValue,
    this.hintText,
    this.labelText,
    this.prefixIconData,
    this.suffixIconData,
    this.obscureText,
    this.onChanged,
    this.onSuffixTap,
    this.keyboardType,
    this.validator,
    this.onSave,
    this.inputFormatters,
    this.textInputAction,
    this.onEditingComplete,
    this.controller,
    this.onFieldSubmit,
    this.readOnly,
    this.focusNode,
    this.maxLines,
    this.maxLength,
    this.fillColor,
    this.autofocus,
    this.textCapitalization,

    // this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: ColorManager.blackColor,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(0.0),
        labelText: labelText,
        hintText: hintText,
        labelStyle: const TextStyle(
          color: ColorManager.primaryColor,
          fontSize: FontSize.textFontSize,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: const TextStyle(
          color: ColorManager.primaryColor,
          fontSize: FontSize.textFontSize,
        ),
        prefixIcon: prefixIconData != null
            ? Icon(
                prefixIconData,
                size: 20,
                color: ColorManager.primaryColor,
              )
            : null,
        suffixIcon: suffixIconData != null
            ? InkWell(
                onTap: onSuffixTap,
                child: Icon(
                  suffixIconData,
                  size: 20,
                  color: ColorManager.primaryColor,
                ),
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ColorManager.primaryColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(RadiusManager.fieldRadius),
        ),
        floatingLabelStyle: const TextStyle(
          color: ColorManager.blackColor,
          fontSize: FontSize.textFontSize,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: ColorManager.primaryColor, width: 1.5),
          borderRadius: BorderRadius.circular(RadiusManager.fieldRadius),
        ),

        // fillColor: fillColor ?? kCreamColor,
        // filled: true,
        alignLabelWithHint: true,

        focusColor: ColorManager.blackColor,

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RadiusManager.fieldRadius),
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RadiusManager.fieldRadius),
          borderSide: const BorderSide(color: Colors.red),
        ),
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: FontSize.subTitleFontSize,
        ),

        // contentPadding: maxLines == null
        //     ? const EdgeInsets.all(8)
        //     : const EdgeInsets.symmetric(vertical: 15),
      ),

      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      autofocus: autofocus ?? true,
      focusNode: focusNode,
      readOnly: readOnly ?? false,
      initialValue: initialValue,
      // maxLengthEnforcement: MaxLengthEnforcement.enforced,
      controller: controller,
      onFieldSubmitted: onFieldSubmit,
      // readOnly: readOnly,
      maxLines: maxLines ?? 1,
      maxLength: maxLength,
      scrollPadding: const EdgeInsets.all(8),
      textCapitalization: textCapitalization ?? TextCapitalization.words,
      toolbarOptions: const ToolbarOptions(
        cut: true,
        copy: true,
        selectAll: true,
        paste: true,
      ),
      onEditingComplete: onEditingComplete,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enableSuggestions: true,
      onSaved: onSave,
      validator: validator,
      keyboardType: keyboardType ?? TextInputType.text,
      onChanged: onChanged,
      obscureText: obscureText ?? false,
      style: const TextStyle(
        // fontFamily: 'Ubuntu',
        color: ColorManager.blackColor,
        fontSize: FontSize.textFontSize + 2,
      ),
    );
  }
}
