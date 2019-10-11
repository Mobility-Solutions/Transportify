import 'package:flutter/material.dart';

class TransportifyColors {
  static const String primaryValueString = "#3C6997";
  static const String primaryLightValueString = "#6D97C8";
  static const String primaryDarkValueString = "#003F69";

  static const int primaryValue = 0xff3C6997;
  static const int primaryLightValue = 0xff6D97C8;
  static const int primaryDarkValue = 0xff003F69;

  static const MaterialColor primarySwatch = const MaterialColor(
    primaryValue,
    const <int, Color>{
      50: const Color(primaryLightValue),
      100: const Color(primaryLightValue),
      200: const Color(primaryLightValue),
      300: const Color(primaryLightValue),
      400: const Color(primaryLightValue),
      500: const Color(primaryValue),
      600: const Color(primaryDarkValue),
      700: const Color(primaryDarkValue),
      800: const Color(primaryDarkValue),
      900: const Color(primaryDarkValue),
    },
  );

  // Components
  static const appBackground = Color(primaryValue);
  static const scaffoldBackground = Color(primaryValue);

}