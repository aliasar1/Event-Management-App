import 'dart:ui';

import '../models/enums.dart';

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = 'FF$hexColorString';
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}

extension CapExtension on String {
  String get inCaps =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
  String get allInCaps => toUpperCase();
  String get capitalizeFirstOfEach => replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.inCaps)
      .join(" ");
}

extension ParseGenderToString on Gender {
  String genderToString() {
    return toString().split('.').last;
  }
}

extension ParseToGender on String {
  Gender stringToGenderEnum() {
    switch (capitalizeFirstOfEach) {
      case 'Male':
        return Gender.male;
      case 'Female':
        return Gender.female;
      default:
        return Gender.male;
    }
  }
}
