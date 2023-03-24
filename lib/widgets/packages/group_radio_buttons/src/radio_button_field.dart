import 'package:event_booking_app/widgets/packages/group_radio_buttons/src/radio_button_group.dart';
import 'package:flutter/material.dart';

import '../../../../manager/color_manager.dart';
import '../../../../manager/values_manager.dart';
import 'grouped_buttons_orientation.dart';

class RadioButtonFormField extends StatefulWidget {
  const RadioButtonFormField({
    Key? key,
    this.decoration = const InputDecoration(),
    required this.labels,
    required this.icons,
    this.onChange,
    this.onSelected,
  }) : super(key: key);

  final List<String> labels;
  final List<IconData> icons;

  final void Function(String label, int index)? onChange;
  final void Function(String selected)? onSelected;
  final InputDecoration decoration;

  @override
  State<RadioButtonFormField> createState() => _RadioButtonFormFieldState();
}

class _RadioButtonFormFieldState extends State<RadioButtonFormField> {
  late int currentIndex = 0;

  void onChangedHandler(String value, int index) {
    widget.onChange!(value, index);
    currentIndex = index;
    setState(() {});
  }

  void onSelectedHandler(String value) {
    widget.onSelected!(value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final InputDecoration effectiveDecoration = widget.decoration.applyDefaults(
      Theme.of(context).inputDecorationTheme,
    );
    return InputDecorator(
      decoration: effectiveDecoration.copyWith(
        prefixIcon: Icon(
          widget.icons[currentIndex],
          color: ColorManager.primaryColor,
        ),
      ),
      child: RadioButtonGroup(
        labels: widget.labels,
        picked: widget.labels[currentIndex],
        activeColor: ColorManager.primaryColor,
        alignment: MainAxisAlignment.center,
        orientation: GroupedButtonsOrientation.horizontal,
        direction: GroupedButtonsOrientation.horizontal,
        radioButtonsGap: PaddingManager.paddingL,
        radioButtonTextGap: PaddingManager.paddingS / 2,
        onChange: onChangedHandler,
        onSelected: onSelectedHandler,
      ),
    );
  }
}
