import 'dart:ui';

import 'package:logger/logger.dart';

extension AnsiColorExt on AnsiColor {
  /// Return [AnsiColor] from provided [color] or null if [color] is null.
  static AnsiColor? fromColorOrNull(Color? color) =>
      (color != null) ? fromColor(color) : null;

  /// Return [AnsiColor] from provided [color]
  static AnsiColor fromColor(Color color) {
    var xtermColor = ((color.red / 255).clamp(0.0, 1.0) * 5).toInt() * 36 +
        ((color.green / 255).clamp(0.0, 1.0) * 5).toInt() * 6 +
        ((color.blue / 255).clamp(0.0, 1.0) * 5).toInt() +
        16;

    xtermColor = xtermColor < 0
        ? 0
        : xtermColor > 255
            ? 255
            : xtermColor;

    return AnsiColor.fg(xtermColor);
  }
}
