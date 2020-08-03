import 'package:flutter/material.dart';
import 'package:mellow_note/utils/colors.dart';
import 'package:mellow_note/utils/utils.dart';

ThemeData buildThemeData() {
  final baseTheme = ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: AvailableFonts.primaryFont);

  return baseTheme.copyWith(
    primaryColor: primaryColor,
    primaryColorDark: primaryDark,
    primaryColorLight: primaryLight,
  );
}
