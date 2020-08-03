import 'package:flutter/material.dart';

String capitalize(String string) {
  if (string == null) {
    throw ArgumentError("string: $string");
  }

  if (string.isEmpty) {
    return string;
  }

  return string[0].toUpperCase() + string.substring(1);
}

class AppConfig {
  static const appName = "Mellow Note";
}

class AvailableFonts {
  static const primaryFont = "Raleway";
  static const secondaryFont = "BarlowSemiCondensed";
}

class AvailableImages {
  static const appLogo = {
    'assetImage': AssetImage('assets/images/mellow_note_logo.png'),
    'assetPath': 'assets/images/mellow_note_logo.png',
  };
}

// convert hex color for use in flutter
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
