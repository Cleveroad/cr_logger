import 'package:cr_logger/src/colors.dart';
import 'package:flutter/material.dart';

enum LogType {
  http,
  debug,
  info,
  error,
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

  String asString() {
    switch (this) {
      case LogType.http:
        return 'HTTP';
      case LogType.debug:
        return 'Debug';
      case LogType.info:
        return 'Info';
      case LogType.error:
        return 'Error';
    }
  }
}
