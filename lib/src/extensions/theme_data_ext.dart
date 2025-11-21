import 'package:flutter/material.dart';

extension ThemeDataExt on ThemeData {
  /// Return ThemeData with default values of [cardTheme] fields
  ThemeData copyWithDefaultCardTheme(CardThemeData defaultCardTheme) {
    return copyWith(
      cardTheme: cardTheme.copyWith(
        clipBehavior: cardTheme.clipBehavior ?? defaultCardTheme.clipBehavior,
        color: cardTheme.color ?? defaultCardTheme.color,
        shadowColor: cardTheme.shadowColor ?? defaultCardTheme.shadowColor,
        elevation: cardTheme.elevation ?? defaultCardTheme.elevation,
        margin: cardTheme.margin ?? defaultCardTheme.margin,
        shape: cardTheme.shape ?? defaultCardTheme.shape,
      ),
    );
  }
}
