import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/res/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

class CRLoggerHelper {
  CRLoggerHelper._();

  static const _proxySharedPrefKey = 'cr_logger_charles_proxy';
  static CRLoggerHelper instance = CRLoggerHelper._();

  final lock = Lock();
  final inspectorNotifier = ValueNotifier<bool>(false);
  final loggerShowingNotifier = ValueNotifier<bool>(false);

  late final PackageInfo packageInfo;
  late final SharedPreferences _prefs;

  ThemeData theme = loggerTheme;

  bool get isLoggerShowing => loggerShowingNotifier.value;

  /// Condition that determines whether or not to print logs
  bool get doPrintLogs {
    final shouldPrintLogs = CRLoggerInitializer.instance.shouldPrintLogs;
    final shouldPrintInReleaseMode =
        CRLoggerInitializer.instance.shouldPrintInReleaseMode;

    return shouldPrintLogs && (shouldPrintInReleaseMode || !kReleaseMode);
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    packageInfo = await PackageInfo.fromPlatform();
  }

  Future<bool> setProxyToSharedPref(String? proxy) async {
    return proxy != null
        ? _prefs.setString(_proxySharedPrefKey, proxy)
        : _prefs.remove(_proxySharedPrefKey);
  }

  String? getProxyFromSharedPref() => _prefs.getString(_proxySharedPrefKey);

  void showLogger() => loggerShowingNotifier.value = true;

  void hideLogger() => loggerShowingNotifier.value = false;
}
