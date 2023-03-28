import 'package:event_booking_app/manager/color_manager.dart';
import 'package:flutter/material.dart';

class CustomSearchWidget extends StatefulWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmit;

  const CustomSearchWidget(
      {Key? key, this.controller, this.validator, this.onFieldSubmit})
      : super(key: key);

  @override
  _CustomSearchWidgetState createState() => _CustomSearchWidgetState();
}

class _CustomSearchWidgetState extends State<CustomSearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[200],
      ),
      child: TextFormField(
        controller: widget.controller,
        onFieldSubmitted: widget.onFieldSubmit,
        validator: widget.validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: ColorManager.primaryColor,
          ),
          hintText: 'Search for...',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
