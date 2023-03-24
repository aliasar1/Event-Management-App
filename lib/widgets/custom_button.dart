import 'package:flutter/material.dart';

import '../manager/font_manager.dart';
import '../manager/values_manager.dart';

enum ButtonType {
  outline,
  outlineWithImage,
  text,
  textWithImage,
  image,
  loading,
}

class CustomButton extends StatelessWidget {
  final Color color;
  final bool hasInfiniteWidth;
  final Color textColor;
  final String text;
  final Widget? image;
  final VoidCallback onPressed;
  final Widget? loadingWidget;
  final ButtonType buttonType;

  const CustomButton({
    Key? key,
    required this.color,
    required this.textColor,
    required this.text,
    required this.onPressed,
    required this.hasInfiniteWidth,
    this.image,
    this.loadingWidget,
    this.buttonType = ButtonType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: hasInfiniteWidth ? double.infinity : 0,
      ),
      child: getButtonWidget(context),
    );
  }

  getButtonWidget(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.subtitle1!.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.5,
          fontSize: FontSize.textFontSize,
          fontFamily: "Nunito",
        );
    switch (buttonType) {
      case ButtonType.outline:
        return buildOutlinedButton(
          textStyle: textStyle,
          child: Text(text, style: textStyle),
        );
      case ButtonType.outlineWithImage:
        return buildOutlinedButton(
          textStyle: textStyle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: PaddingManager.paddingL),
                child: image,
              ),
              Text(text, style: textStyle),
            ],
          ),
        );
      case ButtonType.text:
        return buildTextButton(
          textStyle: textStyle,
          child: Text(text, style: textStyle),
        );
      case ButtonType.textWithImage:
        return buildTextButton(
          textStyle: textStyle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: PaddingManager.paddingL),
                child: image,
              ),
              Text(text, style: textStyle),
            ],
          ),
        );
      case ButtonType.image:
        return buildTextButton(
          textStyle: textStyle,
          child: image!,
        );
      case ButtonType.loading:
        return buildTextButton(
          textStyle: textStyle,
          child: loadingWidget == null
              ? Text(text, style: textStyle)
              : loadingWidget!,
        );
      default:
        return buildTextButton(
          textStyle: textStyle,
          child: loadingWidget == null
              ? Text(text, style: textStyle)
              : loadingWidget!,
        );
    }
  }

  TextButton buildTextButton({
    required TextStyle textStyle,
    required Widget child,
  }) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.all(PaddingManager.paddingS),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusManager.buttonRadius),
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }

  OutlinedButton buildOutlinedButton({
    required TextStyle textStyle,
    required Widget child,
  }) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        primary: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusManager.buttonRadius),
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
