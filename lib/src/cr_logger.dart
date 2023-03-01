import 'dart:async';
import 'dart:io';

import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/constants.dart';
import 'package:cr_logger/src/cr_logger_helper.dart';
import 'package:cr_logger/src/extensions/extensions.dart';
import 'package:cr_logger/src/interceptor/cr_http_adapter.dart';
import 'package:cr_logger/src/interceptor/cr_http_client_adapter.dart';
import 'package:cr_logger/src/managers/log_manager.dart';
import 'package:cr_logger/src/managers/transfer_manager.dart';
import 'package:cr_logger/src/page/actions_and_values/actions_manager.dart';
import 'package:cr_logger/src/page/actions_and_values/notifiers_manager.dart';
import 'package:cr_logger/src/page/log_main/log_main.dart';
import 'package:cr_logger/src/providers/sqflite_provider.dart';
import 'package:cr_logger/src/res/theme.dart';
import 'package:cr_logger/src/utils/console_log_output.dart';
import 'package:cr_logger/src/utils/parsers/isolate_parser.dart';
import 'package:cr_logger/src/utils/pretty_cr_printer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

typedef BuildTypeCallback = String Function();
typedef EndpointCallback = String Function();
typedef LogoutFromAppCallback = Function();

class CRLoggerInitializer {
  CRLoggerInitializer._();

  static const _channel = EventChannel(
    'com.cleveroad.cr_logger/logger',
  );

  static CRLoggerInitializer instance = CRLoggerInitializer._();

  final _consoleLogOutput = ConsoleLogOutput();
  final _loggerNavigationKey = GlobalKey<NavigatorState>();
  final _rootBackButtonDispatcher = RootBackButtonDispatcher();
  late final CRHttpClientAdapter _httpClientAdapter;
  late final CRHttpAdapter _httpAdapter;

  /// Callback for sharing logs file on the app's side.
  ValueChanged<String>? onShareLogsFile;

  /// Has the logger been initialised
  bool inited = false;

  /// Will db init
  bool _useDB = false;

  /// Will logs be printed to console and logger
  bool _printLogs = true;

  /// Will logs be printed to console and logger when [kReleaseMode] is true
  ///
  /// Also depends on [printLogs]
  bool _useCrLoggerInReleaseBuild = false;

  /// Maximum count of logs, which will be showed in the page. Default is 50.
  int _maxCurrentLogsCount = kDefaultMaxLogsCount;

  /// Maximum count of logs, which will be saved to database. Default is 50.
  int _maxDBLogsCount = kDefaultMaxLogsCount;

  /// Name of file when sharing logs
  String logFileName = kLogFileName;

  /// Information to be displayed in the logger on the App info page
  ///
  /// Map of parameter names and values
  Map<String, String> appInfo = {};

  /// Hides all fields in request|response body and query parameters
  /// with keys from list
  List<String> hiddenFields = [];

  /// Hides all headers with keys from list
  List<String> hiddenHeaders = [];

  OverlayEntry? _buttonEntry;
  OverlayEntry? _loggerEntry;

  /// Allows you to listen to local logs and, for example,
  /// send them to a third-party logging service
  Stream<LogBean> get localLogs => LogManager.instance.localLogs.stream;

  bool get isDebugButtonDisplayed => _buttonEntry != null;

  bool get printLogs => _printLogs;

  bool get useCrLoggerInReleaseBuild => _useCrLoggerInReleaseBuild;

  bool get useDB => _useDB;

  int get maxCurrentLogsCount => _maxCurrentLogsCount;

  int get maxDBLogsCount => _maxDBLogsCount;

  /// Logger initialization.
  ///
  /// Custom logger [logger], maximum number of logs of each type (http, debug,
  /// info, error) [maxCurrentLogsCount].
  /// Custom logger theme [theme].
  /// Colors for message types [levelColors] (debug, verbose, info, warning,
  /// error, wtf).
  /// Prints all logs only if [printLogs] is true. Doesn't print logs if
  /// [kReleaseMode] is true and the [useCrLoggerInReleaseBuild] parameter is
  /// false, even if [printLogs] parameter is true
  /// If the [printLogsCompactly] is false, then all logs, except HTTP logs, will have borders,
  /// with a link to the place where the print is called and the time when the log was created.
  /// Otherwise it will write only log message
  // ignore: Long-Parameter-List
  Future<void> init({
    bool printLogs = true,
    bool useCrLoggerInReleaseBuild = false,
    bool useDatabase = false,
    ThemeData? theme,
    Map<Level, Color>? levelColors,
    List<String>? hiddenFields,
    List<String>? hiddenHeaders,
    String? logFileName,
    int maxCurrentLogsCount = kDefaultMaxLogsCount,
    int maxDatabaseLogsCount = kDefaultMaxLogsCount,
    bool printLogsCompactly = true,
    Logger? logger,
  }) async {
    _useDB = useDatabase;
    _maxDBLogsCount = maxDatabaseLogsCount;
    _maxCurrentLogsCount = maxCurrentLogsCount;
    _printLogs = printLogs;
    _useCrLoggerInReleaseBuild = useCrLoggerInReleaseBuild;

    if (inited) {
      return;
    }

    await CRLoggerHelper.instance.init();

    if (!kIsWeb) {
      _channel.receiveBroadcastStream().listen(_receiveNativeLogs);
    }
    _httpClientAdapter = CRHttpClientAdapter();
    _httpAdapter = CRHttpAdapter();

    if (theme != null) {
      CRLoggerHelper.instance.theme =
          theme.copyWithDefaultCardTheme(loggerTheme.cardTheme);
    }
    this.logFileName = logFileName ?? this.logFileName;
    this.hiddenFields = hiddenFields ?? [];
    this.hiddenHeaders = hiddenHeaders ?? [];

    log = logger ??
        Logger(
          printer: PrettyCRPrinter(
            methodCount: 1,
            errorMethodCount: 40,
            lineLength: 80,
            printTime: true,
            printEmojis: false,
            levelColors: levelColors,
            printLogsCompactly: printLogsCompactly,
          ),
          output: _consoleLogOutput,
          filter: useCrLoggerInReleaseBuild
              ? ProductionFilter()
              : DevelopmentFilter(),
          level: Level.verbose,
        );

    _rootBackButtonDispatcher.addCallback(_dispatchBackButton);
    if (!kIsWeb && _useDB && useCrLoggerInReleaseBuild) {
      await _initDB();
    }
    inited = true;
  }

  /// Get current Charles proxy settings as an "ip:port" string
  ///
  /// Proxy settings are saved in the logger with SharedPreferences
  String? getProxySettings() =>
      CRLoggerHelper.instance.getProxyFromSharedPref();

  /// Adds a value notifier to the Actions and values page
  void addValueNotifier({
    ValueNotifier? notifier,
    Widget? widget,
    String? name,
    String? connectedWidgetId,
  }) {
    NotifiersManager.addNotifier(
      name: name,
      notifier: notifier,
      widget: widget,
      connectedWidgetId: connectedWidgetId,
    );
  }

  /// Removes all notifiers with the specified identifier
  void removeNotifiersById(String connectedWidgetId) {
    NotifiersManager.removeNotifiersById(connectedWidgetId);
  }

  /// Clears the value notifiers list on the Actions and values page
  void notifierListClear() {
    NotifiersManager.clear();
  }

  /// Adds an action button to the Actions and values page
  void addActionButton(
    String text,
    VoidCallback action, {
    String? connectedWidgetId,
  }) {
    ActionsManager.addActionButton(
      text,
      action,
      connectedWidgetId: connectedWidgetId,
    );
  }

  /// Removes all action buttons with the specified identifier
  void removeActionsById(String connectedWidgetId) {
    ActionsManager.removeActionButtonsById(connectedWidgetId);
  }

  /// Import logs from json map
  /// Attention, all logs are cleared before import
  Future<void> createLogsFromJson(Map<String, dynamic> json) async {
    await TransferManager().createLogsFromJson(json);
  }

  /// Show global hover debug buttons
  // ignore: Long-Parameter-List
  void showDebugButton(
    BuildContext context, {
    Widget? button,
    bool isDelay = true,
    double left = 100,
    double top = 4,
  }) {
    dismissDebugButton();
    if (!isDelay) {
      _showMenu(
        context,
        button: button,
        left: left,
        top: top,
      );
    } else {
      Timer(const Duration(milliseconds: 500), () {
        _showMenu(
          context,
          button: button,
          left: left,
          top: top,
        );
      });
    }
  }

  /// Get Dio interceptor which should be applied to Dio instance.
  DioLogInterceptor getDioInterceptor({ParserError? parserError}) {
    return DioLogInterceptor(parserError: parserError);
  }

  /// Get Chopper interceptor which should be applied to Chopper instance.
  ChopperLogInterceptor getChopperInterceptor() {
    return ChopperLogInterceptor();
  }

  /// Handle request of HttpClient from dart:io library
  void onHttpClientRequest(HttpClientRequest request, Object? body) {
    _httpClientAdapter.onRequest(request, body);
  }

  /// Handle response of HttpClient from dart:io library
  void onHttpClientResponse(
    HttpClientResponse response,
    HttpClientRequest request,
    Object? body,
  ) {
    _httpClientAdapter.onResponse(
      response,
      request,
      body,
    );
  }

  /// Handle both request and response from http package
  void onHttpResponse(http.Response response, Object? body) {
    _httpAdapter.onResponse(response, body);
  }

  /// Clearing all logs.
  ///
  /// Clearing debug, error, info and http logs.
  void cleanAllLogs() {
    MainLogPage.cleanLogs();
  }

  /// Clearing http logs.
  void cleanHttpLogs() {
    MainLogPage.cleanHttpLogs();
  }

  /// Clearing debug logs.
  void cleanDebug() {
    MainLogPage.cleanDebug();
  }

  /// Clearing info logs.
  void cleanInfo() {
    MainLogPage.cleanInfo();
  }

  /// Clearing error logs.
  void cleanError() {
    MainLogPage.cleanError();
  }

  /// Close hover button
  void dismissDebugButton() {
    _buttonEntry?.remove();
    _buttonEntry = null;
  }

  void _showMenu(
    BuildContext context, {
    required double left,
    required double top,
    Widget? button,
  }) {
    _buttonEntry = OverlayEntry(
      builder: (BuildContext context) => SafeArea(
        child: button ??
            DraggableButtonWidget(
              leftPos: left,
              topPos: top,
              onLoggerOpen: _onLoggerOpen,
            ),
      ),
    );

    /// Show hover menu
    if (_buttonEntry != null) {
      //ignore:invalid_null_aware_operator
      Overlay.of(context)?.insert(_buttonEntry!);
    }
  }

  Future<void> _receiveNativeLogs(event) async {
    var data = <String, dynamic>{};
    final logData = event[1];
    if (Platform.isIOS) {
      if (logData is Map) {
        final jsonString = logData['jsonString'];
        if (jsonString is String) {
          data = await IsolateParser().decode(jsonString);
        }
      }
    } else if (Platform.isAndroid) {
      if (logData is Map) {
        data = Map.from(logData);
      }
    }

    switch (event[0]) {
      case 'd':
        log.d(data.entries.isEmpty ? logData : data);
        break;
      case 'i':
        log.i(data.entries.isEmpty ? logData : data);
        break;
      case 'e':
        log.e(data.entries.isEmpty ? logData : data);
        break;
    }
  }

  void _onLoggerClose() {
    _loggerEntry?.remove();
    _loggerEntry = null;
    CRLoggerHelper.instance.hideLogger();
  }

  void _onLoggerOpen(BuildContext context) {
    /// Show logger
    if (_loggerEntry == null) {
      final newLoggerEntry = OverlayEntry(
        builder: (context) => MainLogPage(
          navigationKey: _loggerNavigationKey,
          onLoggerClose: _onLoggerClose,
        ),
      );
      _loggerEntry = newLoggerEntry;
      //ignore:invalid_null_aware_operator
      Overlay.of(context)?.insert(newLoggerEntry);

      /// The button should be above logger
      final buttonEntry = _buttonEntry;
      if (buttonEntry != null) {
        buttonEntry.remove();
        //ignore:invalid_null_aware_operator
        Overlay.of(context)?.insert(buttonEntry);
      }
    }
  }

  Future<bool> _dispatchBackButton() async {
    if (CRLoggerHelper.instance.isLoggerShowing) {
      if (_loggerNavigationKey.currentState != null) {
        final isPopped = await _loggerNavigationKey.currentState!.maybePop();
        if (!isPopped) {
          _onLoggerClose();
        }
      }

      return true;
    }

    return false;
  }

  /// Init DB and load logs from it
  Future<void> _initDB() => SqfliteProvider.instance.init();
}

/// Run LoggerInitializer.instance.init() before using this
late Logger log;
