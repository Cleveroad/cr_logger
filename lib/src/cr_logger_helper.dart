import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/res/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

final class CRLoggerHelper {
  CRLoggerHelper._();

  static const _proxySharedPrefKey = 'cr_logger_charles_proxy';
  static CRLoggerHelper instance = CRLoggerHelper._();

  final lock = Lock();
  final inspectorNotifier = ValueNotifier<bool>(false);
  final loggerShowingNotifier = ValueNotifier<bool>(false);

  final maxLogsCount = CRLoggerInitializer.instance.maxCurrentLogsCount;

  final maxDBLogsCount = CRLoggerInitializer.instance.maxDBLogsCount;
  late final PackageInfo packageInfo;
  late final SharedPreferences _prefs;

  ThemeData theme = loggerTheme;

  bool get isLoggerShowing => loggerShowingNotifier.value;

  bool showGQLLogs = false;

  bool get useDB {
    final useCrLoggerInReleaseBuild =
        CRLoggerInitializer.instance.useCrLoggerInReleaseBuild;
    final useDB = CRLoggerInitializer.instance.useDB;

    return useDB && (useCrLoggerInReleaseBuild || !kReleaseMode) && !kIsWeb;
  }

  /// Condition that determines whether or not to print logs
  bool get printLogs {
    final printLogs = CRLoggerInitializer.instance.printLogs;
    final useCrLoggerInReleaseBuild =
        CRLoggerInitializer.instance.useCrLoggerInReleaseBuild;

    return printLogs && (useCrLoggerInReleaseBuild || !kReleaseMode);
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
