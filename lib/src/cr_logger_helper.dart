import 'package:cr_logger/src/res/theme.dart';
import 'package:flutter/material.dart';
import 'package:synchronized/synchronized.dart';

class CRLoggerHelper {
  CRLoggerHelper._();

  static CRLoggerHelper instance = CRLoggerHelper._();

  final lock = Lock();
  final inspectorNotifier = ValueNotifier<bool>(false);

  ThemeData theme = loggerTheme;
}
