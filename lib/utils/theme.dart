import 'package:flutter/material.dart';

TextTheme customUrbanistTextTheme(TextTheme base) {
  return base.copyWith(
    displayLarge: base.displayLarge?.copyWith(fontFamily: 'Urbanist', fontWeight: FontWeight.normal),
    displayMedium: base.displayMedium?.copyWith(fontFamily: 'Urbanist', fontWeight: FontWeight.normal),
    displaySmall: base.displaySmall?.copyWith(fontFamily: 'Urbanist', fontWeight: FontWeight.normal),
    headlineMedium: base.headlineMedium?.copyWith(fontFamily: 'Urbanist', fontWeight: FontWeight.normal),
    headlineSmall: base.headlineSmall?.copyWith(fontFamily: 'Urbanist', fontWeight: FontWeight.normal),
    titleLarge: base.titleLarge?.copyWith(fontFamily: 'Urbanist', fontWeight: FontWeight.normal),
    titleMedium: base.titleMedium?.copyWith(fontFamily: 'Urbanist', fontWeight: FontWeight.normal),
    titleSmall: base.titleSmall?.copyWith(fontFamily: 'Urbanist', fontWeight: FontWeight.normal),
    bodyLarge: base.bodyLarge?.copyWith(fontFamily: 'Urbanist', fontWeight: FontWeight.normal),
    bodyMedium: base.bodyMedium?.copyWith(fontFamily: 'Urbanist', fontWeight: FontWeight.normal),
    labelLarge: base.labelLarge?.copyWith(fontFamily: 'Urbanist', fontWeight: FontWeight.normal),
    bodySmall: base.bodySmall?.copyWith(fontFamily: 'Urbanist', fontWeight: FontWeight.normal),
    labelSmall: base.labelSmall?.copyWith(fontFamily: 'Urbanist', fontWeight: FontWeight.normal),
  ).apply(
    fontFamily: 'Urbanist',
  );
}