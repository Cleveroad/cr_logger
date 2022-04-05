import 'package:flutter/material.dart';

extension CardThemeExt on CardTheme {
  BorderRadius get borderRadius =>
      ((shape ?? const RoundedRectangleBorder()) as RoundedRectangleBorder)
          .borderRadius as BorderRadius;
}
