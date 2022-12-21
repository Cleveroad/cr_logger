import 'package:cr_logger/src/res/colors.dart';
import 'package:flutter/material.dart';

enum LogType {
  http('HTTP'),
  debug('Debug'),
  info('Info'),
  error('Error');

  const LogType(this.name);

  final String name;
}

extension LogTypeExt on LogType {
  Color getColor() {
    switch (this) {
      case LogType.http:
        return CRLoggerColors.blueAccent;
      case LogType.debug:
        return CRLoggerColors.orange;
      case LogType.info:
        return CRLoggerColors.blueAccent;
      case LogType.error:
        return CRLoggerColors.red;
    }
  }
}
