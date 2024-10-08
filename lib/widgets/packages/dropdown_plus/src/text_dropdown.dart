import 'package:flutter/material.dart';

import '../../../../manager/color_manager.dart';
import 'dropdown.dart';

/// Simple dropdown with plain text as a dropdown items.
class TextDropdownFormField extends StatelessWidget {
  final List<String> options;
  final InputDecoration? decoration;
  final DropdownEditingController<String>? controller;
  final void Function(String item)? onChanged;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final bool Function(String item, String str)? filterFn;
  final Future<List<String>> Function(String str)? findFn;
  final double? dropdownHeight;
  final Color color;

  const TextDropdownFormField({
    Key? key,
    required this.options,
    this.decoration,
    this.onSaved,
    this.controller,
    this.onChanged,
    this.validator,
    this.findFn,
    this.filterFn,
    this.dropdownHeight,
    this.color = ColorManager.blackColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownFormField<String>(
      dropdownColor: Color.fromARGB(255, 208, 208, 209),
      decoration: decoration,
      onSaved: onSaved,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      dropdownHeight: dropdownHeight,
      displayItemFn: (dynamic str) => Text(
        str ?? '',
        style: const TextStyle(
          fontSize: 16,
          color: ColorManager.primaryColor,
        ),
      ),
      findFn: findFn ?? (dynamic str) async => options,
      filterFn: filterFn ??
          (dynamic item, str) =>
              item.toLowerCase().indexOf(str.toLowerCase()) >= 0,
      dropdownItemFn: (dynamic item, position, focused, selected, onTap) {
        return ListTile(
          title: Text(
            item,
            style: TextStyle(
                color: selected
                    ? Colors.black
                    : const Color.fromARGB(255, 111, 109, 109)),
          ),
          tileColor:
              focused ? const Color.fromARGB(20, 0, 0, 0) : Colors.transparent,
          onTap: onTap,
        );
      },
    );
  }
}
