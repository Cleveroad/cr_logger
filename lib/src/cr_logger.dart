import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/colors.dart';
import 'package:cr_logger/src/constants.dart';
import 'package:cr_logger/src/cr_logger_helper.dart';
import 'package:cr_logger/src/extensions/extensions.dart';
import 'package:cr_logger/src/interceptor/cr_http_adapter.dart';
import 'package:cr_logger/src/interceptor/cr_http_client_adapter.dart';
import 'package:cr_logger/src/page/actions_and_values/actions_managed.dart';
import 'package:cr_logger/src/page/actions_and_values/notifiers_manager.dart';
import 'package:cr_logger/src/page/log_main/log_main.dart';
import 'package:cr_logger/src/res/theme.dart';
import 'package:cr_logger/src/utils/console_log_output.dart';
import 'package:cr_logger/src/utils/local_log_managed.dart';
import 'package:cr_logger/src/utils/nothing_log_filter.dart';
import 'package:cr_logger/src/utils/pretty_cr_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

/// Typedef for function callback to provide Isolate handle of some function
/// outside of cr_logger.
///
/// When printing large logs to the console UI of the app may lag.
///
/// [fun] - should always be global or static function. Should allow only 1
/// argument.
/// [data] - data which [fun] receives as an argument.
typedef IsolateFunctionHandler<DATA> = Future<dynamic> Function(
  Function(DATA) fun,
  DATA data,
);

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

  /// Has the logger been initialised
  bool inited = false;

  /// Will logs be printed to console and logger
  bool _shouldPrintLogs = true;

  /// Will logs be printed to console and logger when [kReleaseMode] is true
  ///
  /// Also depends on [shouldPrintLogs]
  bool _shouldPrintInReleaseMode = false;

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

  /// Callback for fast logout button in logger popup menu.
  LogoutFromAppCallback? onLogout;

  /// Callback for sharing logs file on the app's side.
  /// Needed for avoiding additional iOS permissions from share plugins if not
  /// needed.
  ValueChanged<String>? onShareLogsFile;

  /// Callback for printing cr_logger logs to console in separate isolate
  /// provided by the app.
  ///
  /// Printing a lot of log may cause UI and performance lags, isolate print
  /// helps to print logs faster.
  ///
  /// If callback not provided all logs are printed in main isolate.
  ///
  /// E.g. with worker_manager package https://pub.dev/packages/worker_manager:
  ///
  /// '''dart
  /// Future<void> main() async {
  ///   // Call this first if main function is async
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///
  ///   await Executor().warmUp();
  ///
  ///   CRLoggerInitializer.instance.handleFunctionInIsolate = (fun, data) {
  ///      return await Executor().execute(
  ///       arg1: data,
  ///       fun1: fun,
  ///     );
  ///   };
  ///   runApp(const MyApp());
  /// }
  /// '''
  IsolateFunctionHandler<dynamic>? handleFunctionInIsolate;

  /// To ensure order of map from native iOS is saved properly it is saved as
  /// json string. Android maps order is saved properly when passed to Flutter.
  ///
  /// On Flutter side it is decoded with [jsonDecode] which may cause UI lags
  /// when string is big.
  ///
  /// This callback allows to move parsing to Isolate provided by the app itself.
  ///
  /// If callback not provided json string is parsed in main isolate
  ///
  /// E.g. with worker_manager package https://pub.dev/packages/worker_manager:
  ///
  /// '''dart
  /// Future<void> main() async {
  ///   // Call this first if main function is async
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///
  ///   await Executor().warmUp();
  ///
  ///   CRLoggerInitializer.instance.parseiOSJsonStringInIsolate = (fun, data) {
  ///     return await Executor().execute(
  ///       arg1: data,
  ///       fun1: fun,
  ///     );
  ///   };
  ///   runApp(const MyApp());
  /// }
  /// '''
  IsolateFunctionHandler<String>? parseiOSJsonStringInIsolate;

  OverlayEntry? _buttonEntry;
  OverlayEntry? _loggerEntry;

  /// Allows you to listen to local logs and, for example,
  /// send them to a third-party logging service
  Stream<LogBean> get localLogs => LocalLogManager.instance.localLogs.stream;

  /// Whether logs will be printed in isolate
  set isIsolateHttpLogsPrinting(bool value) =>
      PrettyCRLogger.isIsolatePrinting = value;

  /// Whether logs will be printed in isolate
  bool get isIsolateHttpLogsPrinting => PrettyCRLogger.isIsolatePrinting;

  bool get isDebugButtonDisplayed => _buttonEntry != null;

  bool get shouldPrintLogs => _shouldPrintLogs;

  bool get shouldPrintInReleaseMode => _shouldPrintInReleaseMode;

  /// Logger initialization.
  ///
  /// Custom logger [logger], maximum number of logs of each type (http, debug,
  /// info, error) [maxLogsCount].
  /// Custom logger theme [theme].
  /// Colors for message types [levelColors] (debug, verbose, info, warning,
  /// error, wtf).
  /// Prints all logs only if [shouldPrintLogs] is true. Doesn't print logs if
  /// [kReleaseMode] is true and the [shouldPrintInReleaseMode] parameter is
  /// false, even if [shouldPrintLogs] parameter is true
  // ignore: Long-Parameter-List
  Future<void> init({
    bool shouldPrintLogs = true,
    bool shouldPrintInReleaseMode = false,
    ThemeData? theme,
    Map<Level, Color>? levelColors,
    List<String>? hiddenFields,
    List<String>? hiddenHeaders,
    String? logFileName,
    int maxLogsCount = kMaxEachTypeOfLogsCountByDefault,
    Logger? logger,
  }) async {
    if (inited) {
      return;
    }

    HttpLogManager.instance.maxLogsCount = maxLogsCount;
    LocalLogManager.instance.maxLogsCount = maxLogsCount;

    await CRLoggerHelper.instance.init();

    if (!kIsWeb) {
      _channel.receiveBroadcastStream().listen(_receiveNativeLogs);
    }
    _httpClientAdapter = CRHttpClientAdapter();
    _httpAdapter = CRHttpAdapter();
    _shouldPrintLogs = shouldPrintLogs;
    _shouldPrintInReleaseMode = shouldPrintInReleaseMode;
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
          ),
          output: _consoleLogOutput,
          filter: CRLoggerInitializer.instance.shouldPrintLogs
              ? shouldPrintInReleaseMode
                  ? ProductionFilter()
                  : DevelopmentFilter()
              : NothingLogFilter(),
          level: CRLoggerInitializer.instance.shouldPrintLogs
              ? Level.verbose
              : Level.nothing,
        );

    _rootBackButtonDispatcher.addCallback(_dispatchBackButton);

    inited = true;
  }

  /// Get current Charles proxy settings as an "ip:port" string
  ///
  /// Proxy settings are saved in the logger with SharedPreferences
  String? getProxySettings() =>
      CRLoggerHelper.instance.getProxyFromSharedPref();

  /// Adds a value notifier to the Actions and values page
  void addValueNotifier(
    String name,
    ValueNotifier<dynamic> notifier, {
    String? connectedWidgetId,
  }) {
    NotifiersManager.addNotifier(
      name,
      notifier,
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
    await LocalLogManager.instance.createLogsFromJson(json);
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
          data = parseiOSJsonStringInIsolate != null
              ? await parseiOSJsonStringInIsolate!.call(jsonDecode, jsonString)
              : jsonDecode(jsonString);
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
      Overlay.of(context)?.insert(newLoggerEntry);

      /// The button should be above logger
      final buttonEntry = _buttonEntry;
      if (buttonEntry != null) {
        buttonEntry.remove();
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
}

/// Run LoggerInitializer.instance.init() before using this
late Logger log;

class PrettyCRPrinter extends LogPrinter {
  PrettyCRPrinter({
    this.methodCount = 2,
    this.errorMethodCount = 8,
    this.lineLength = 120,
    this.colors = true,
    this.printEmojis = true,
    this.printTime = false,
    this.shortVisible = true,
    Map<Level, Color>? levelColors,
  }) : levelColors = {
          Level.nothing:
              AnsiColorExt.fromColorOrNull(levelColors?[Level.verbose]) ??
                  AnsiColor.fg(AnsiColor.grey(0.5)),
          Level.verbose:
              AnsiColorExt.fromColorOrNull(levelColors?[Level.verbose]) ??
                  AnsiColor.fg(AnsiColor.grey(0.5)),
          Level.debug:
              AnsiColorExt.fromColorOrNull(levelColors?[Level.debug]) ??
                  AnsiColor.none(),
          Level.info: AnsiColorExt.fromColorOrNull(levelColors?[Level.info]) ??
              AnsiColor.fg(12),
          Level.warning:
              AnsiColorExt.fromColorOrNull(levelColors?[Level.warning]) ??
                  AnsiColor.fg(208),
          Level.error:
              AnsiColorExt.fromColorOrNull(levelColors?[Level.error]) ??
                  AnsiColor.fg(160),
          Level.wtf: AnsiColorExt.fromColorOrNull(levelColors?[Level.wtf]) ??
              AnsiColor.fg(199),
        } {
    _startTime ??= DateTime.now();

    final doubleDividerLine = StringBuffer();
    final singleDividerLine = StringBuffer();
    for (var i = 0; i < lineLength - 1; i++) {
      doubleDividerLine.write(doubleDivider);
      singleDividerLine.write(singleDivider);
    }

    _topBorder = '$topLeftCorner$doubleDividerLine';
    _middleBorder = '$middleCorner$singleDividerLine';
    _bottomBorder = '$bottomLeftCorner$doubleDividerLine';
  }

  static const topLeftCorner = '┌';
  static const bottomLeftCorner = '└';
  static const middleCorner = '├';
  static const verticalLine = '│';
  static const doubleDivider = '─';
  static const singleDivider = '┄';

  static final Map<Level, String> levelEmojis = {
    Level.nothing: '',
    Level.verbose: '',
    Level.debug: '🐛 ',
    Level.info: '💡 ',
    Level.warning: '⚠️ ',
    Level.error: '⛔ ',
    Level.wtf: '👾 ',
  };

  static final stackTraceRegex = RegExp(r'#[0-9]+[\s]+(.+) \(([^\s]+)\)');

  static DateTime? _startTime;

  final int methodCount;
  final int errorMethodCount;
  final int lineLength;
  final bool colors;
  final bool printEmojis;
  final bool printTime;
  final bool shortVisible;
  final Map<Level, AnsiColor> levelColors;

  String _topBorder = '';
  String _middleBorder = '';
  String _bottomBorder = '';

  @override
  List<String> log(LogEvent event) {
    final messageStr = stringifyMessage(event.message);

    String? stackTraceStr;
    if (event.stackTrace == null) {
      if (methodCount > 0) {
        stackTraceStr = formatStackTrace(StackTrace.current, methodCount);
      }
    } else if (errorMethodCount > 0) {
      stackTraceStr = formatStackTrace(event.stackTrace, errorMethodCount);
    }

    final errorStr = event.error?.toString();

    String? timeStr;
    if (printTime) {
      timeStr = getTime();
    }
    _addToLogWidget(
      event.level,
      event.message,
      timeStr,
    );

    return _formatAndPrint(
      event.level,
      messageStr,
      timeStr,
      errorStr,
      stackTraceStr,
    );
  }

  String? formatStackTrace(StackTrace? stackTrace, int methodCount) {
    final lines = stackTrace.toString().split('\n');
    if (lines.isNotEmpty) {
      lines.removeAt(0);
    }
    final formatted = <String>[];
    var count = 0;
    for (final line in lines) {
      final match = stackTraceRegex.matchAsPrefix(line);
      if (match != null) {
        if (match.group(2)?.startsWith(kLoggerPackage) ?? false) {
          continue;
        }
        final newLine = '#$count   ${match.group(1)} (${match.group(2)})';
        formatted.add(newLine.replaceAll('<anonymous closure>', '()'));
        if (++count == methodCount) {
          break;
        }
      } else {
        formatted.add(line);
      }
    }

    return formatted.isEmpty ? null : formatted.join('\n');
  }

  String getTime() {
    String _threeDigits(int n) {
      if (n >= 100) {
        return '$n';
      }
      if (n >= 10) {
        return '0$n';
      }

      return '00$n';
    }

    String _twoDigits(int n) {
      if (n >= 10) {
        return '$n';
      }

      return '0$n';
    }

    final now = DateTime.now();
    final h = _twoDigits(now.hour);
    final min = _twoDigits(now.minute);
    final sec = _twoDigits(now.second);
    final ms = _threeDigits(now.millisecond);
    String? timeSinceStart;
    if (_startTime != null) {
      timeSinceStart = now.difference(_startTime!).toString();
    }

    return '$h:$min:$sec.$ms (+$timeSinceStart)';
  }

  String stringifyMessage(Object? message) {
    if (message is Map || message is Iterable) {
      const encoder = JsonEncoder.withIndent('  ');

      return encoder.convert(message);
    } else {
      return message.toString();
    }
  }

  AnsiColor _getLevelColor(Level level) {
    return colors ? levelColors[level] ?? AnsiColor.none() : AnsiColor.none();
  }

  AnsiColor _getErrorColor(Level level) {
    return colors
        ? level == Level.wtf
            ? levelColors[Level.wtf] ?? AnsiColor.none()
            : levelColors[Level.error] ?? AnsiColor.none()
        : AnsiColor.none();
  }

  // ignore: Long-Parameter-List
  void _addToLogWidget(
    Level level,
    message,
    String? stacktrace,
  ) {
    final logModel = LogBean(
      message: message ?? '',
      time: DateTime.now(),
      stackTrace: stacktrace ?? '',
    );
    switch (level) {
      case Level.verbose:
      case Level.debug:
        logModel.color = CRLoggerColors.orange;
        LocalLogManager.instance.addDebug(logModel);
        break;
      case Level.info:
      case Level.warning:
        logModel.color = CRLoggerColors.blueAccent;
        LocalLogManager.instance.addInfo(logModel);
        break;
      case Level.error:
      case Level.wtf:
        logModel.color = CRLoggerColors.red;
        LocalLogManager.instance.addError(logModel);
        break;
      case Level.nothing:
        break;
    }
  }

  String _getEmoji(Level level) {
    return printEmojis ? levelEmojis[level] ?? '' : '';
  }

  // ignore: Long-Parameter-List
  List<String> _formatAndPrint(
    Level level,
    String? message,
    String? time,
    String? error,
    String? stacktrace,
  ) {
    final buffer = <String>[];
    final color =
        kIsWeb || Platform.isAndroid ? _getLevelColor(level) : AnsiColor.none();
    buffer.add(color(_topBorder));

    if (error != null) {
      final errorColor = kIsWeb || Platform.isAndroid
          ? _getErrorColor(level)
          : AnsiColor.none();
      for (final line in error.split('\n')) {
        buffer.add(
          color('$verticalLine ') +
              errorColor.resetForeground +
              errorColor(line) +
              errorColor.resetBackground,
        );
      }
      if (!shortVisible) {
        buffer.add(color(_middleBorder));
      }
    }

    if (stacktrace != null) {
      for (final line in stacktrace.split('\n')) {
        buffer.add('$color$verticalLine $line');
      }
      if (!shortVisible) {
        buffer.add(color(_middleBorder));
      }
    }

    if (time != null && !shortVisible) {
      buffer
        ..add(color('$verticalLine $time'))
        ..add(color(_middleBorder));
    }

    final emoji = _getEmoji(level);
    if (message != null) {
      for (final line in message.split('\n')) {
        buffer.add(color('$verticalLine $emoji$line'));
      }
      buffer.add(color(_bottomBorder));
    }

    return buffer;
  }
}
