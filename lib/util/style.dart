import 'package:flutter/material.dart';

class TransportifyColors {
  static const String primaryValueString = "#3C6997";
  static const String primaryLightValueString = "#6D97C8";
  static const String primaryDarkValueString = "#2A4D70";

  static const int primaryValue = 0xff3C6997;
  static const int primaryLightValue = 0xff6D97C8;
  static const int primaryDarkValue = 0xff2a4d70;

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

class TransportifyContainer extends StatelessWidget {
  TransportifyContainer({
    this.child,
    this.padding = 15.0,
    this.color = TransportifyColors.primarySwatch,
    this.vertical = true
  });

  final double padding;
  final Widget child;
  final Color color;
  final bool vertical;
  
  @override
  Widget build(BuildContext context) {
    return Container(padding: vertical ? EdgeInsets.symmetric(vertical: padding) : EdgeInsets.symmetric(horizontal: padding),
    child: child);
  }}