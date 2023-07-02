import 'package:flutter/material.dart';

import '../manager/color_manager.dart';
import '../manager/font_manager.dart';

class UnderlineTextFormField extends StatefulWidget {
  final String label;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? maxLength;
  final TextCapitalization? textCapitalization;

  const UnderlineTextFormField({
    super.key,
    required this.label,
    this.validator,
    this.controller,
    this.keyboardType,
    this.maxLines,
    this.maxLength,
    this.textCapitalization,
  });

  @override
  _UnderlineTextFormFieldState createState() => _UnderlineTextFormFieldState();
}

class _UnderlineTextFormFieldState extends State<UnderlineTextFormField> {
  // ignore: unused_field
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      maxLines: widget.maxLines ?? 1,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      textCapitalization: widget.textCapitalization ?? TextCapitalization.words,
      maxLength: widget.maxLength,
      cursorColor: ColorManager.blackColor,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(
          fontFamily: FontsManager.fontFamilyPoppins,
          color: ColorManager.blackColor,
          fontSize: FontSize.subTitleFontSize * 1.2,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorManager.blackColor),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: ColorManager.blackColor),
        ),
      ),
      onChanged: (value) => setState(() {}),
      onTap: () => setState(() => _isFocused = true),
      onFieldSubmitted: (value) => setState(() => _isFocused = false),
    );
  }
}
