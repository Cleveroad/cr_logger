import 'dart:convert';
import 'dart:io';

import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/constants.dart';
import 'package:cr_logger/src/cr_logger_helper.dart';
import 'package:cr_logger/src/log_message_wrapper.dart';
import 'package:cr_logger/src/managers/log_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

/// This class is designed to display logs nicely in the console.
/// If the [printLogsCompactly] is false, then all logs, except HTTP logs, will have borders,
/// with a link to the place where the print is called and the time when the log was created.
/// Otherwise it will write only log message
final class PrettyCRPrinter extends LogPrinter {
  PrettyCRPrinter({
    this.methodCount = 2,
    this.errorMethodCount = 8,
    this.lineLength = 120,
    this.colors = true,
    this.printEmojis = true,
    this.printTime = false,
    this.shortVisible = true,
    Map<Level, Color>? levelColors,
    bool printLogsCompactly = true,
  }) : levelColors = {
          Level.all: AnsiColorExt.fromColorOrNull(levelColors?[Level.all]) ??
              AnsiColor.fg(AnsiColor.grey(0.5)),
          Level.off: AnsiColorExt.fromColorOrNull(levelColors?[Level.off]) ??
              AnsiColor.fg(AnsiColor.grey(0.5)),
          Level.trace:
              AnsiColorExt.fromColorOrNull(levelColors?[Level.trace]) ??
                  const AnsiColor.fg(057),
          Level.debug:
              AnsiColorExt.fromColorOrNull(levelColors?[Level.debug]) ??
                  const AnsiColor.fg(010),
          Level.info: AnsiColorExt.fromColorOrNull(levelColors?[Level.info]) ??
              const AnsiColor.fg(12),
          Level.warning:
              AnsiColorExt.fromColorOrNull(levelColors?[Level.warning]) ??
                  const AnsiColor.fg(208),
          Level.error:
              AnsiColorExt.fromColorOrNull(levelColors?[Level.error]) ??
                  const AnsiColor.fg(160),
          Level.fatal:
              AnsiColorExt.fromColorOrNull(levelColors?[Level.fatal]) ??
                  const AnsiColor.fg(199),
        } {
    _startTime ??= DateTime.now();

    if (!printLogsCompactly) {
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

    _printLogsCompactly = printLogsCompactly;
  }

  static const topLeftCorner = '┌';
  static const bottomLeftCorner = '└';
  static const middleCorner = '├';
  static const verticalLine = '│';
  static const doubleDivider = '─';
  static const singleDivider = '┄';

  static final Map<Level, String> levelEmojis = {
    Level.all: '',
    Level.off: '',
    Level.trace: '',
    Level.debug: '🐛 ',
    Level.info: '💡 ',
    Level.warning: '⚠️ ',
    Level.error: '⛔ ',
    Level.fatal: '👾 ',
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

  bool _printLogsCompactly = true;
  String _topBorder = '';
  String _middleBorder = '';
  String _bottomBorder = '';

  @override
  List<String> log(LogEvent event) {
    final logWrapper = event.message as LogMessageWrapper;
    final messageStr = stringifyMessage(logWrapper.message);

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
      logWrapper,
      stackTraceStr,
    );

    return CRLoggerHelper.instance.printLogs
        ? _formatAndPrint(
            event.level,
            messageStr,
            timeStr,
            errorStr,
            stackTraceStr,
          )
        : [];
  }

  String? formatStackTrace(StackTrace? stackTrace, int methodCount) {
    final lines = stackTrace.toString().split('\n');
    if (lines.isNotEmpty) {
      lines.removeAt(0);
    }

    return kIsWeb
        ? _formatSTWeb(lines, methodCount)
        : _formatSTMobile(lines, methodCount);
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
    final startTime = _startTime;
    String? timeSinceStart;
    if (startTime != null) {
      timeSinceStart = now.difference(startTime).toString();
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
    return colors
        ? levelColors[level] ?? const AnsiColor.none()
        : const AnsiColor.none();
  }

  AnsiColor _getErrorColor(Level level) {
    return colors
        ? level == Level.fatal
            ? levelColors[Level.fatal] ?? const AnsiColor.none()
            : levelColors[Level.error] ?? const AnsiColor.none()
        : const AnsiColor.none();
  }

  // ignore: Long-Parameter-List
  void _addToLogWidget(
    Level level,
    LogMessageWrapper logWrapper,
    String? stacktrace,
  ) {
    final logModel = LogBean(
      message: logWrapper.message ?? '',
      time: DateTime.now(),
      stackTrace: stacktrace ?? '',
      type: LogType.getTypeFromLevel(level),
      showToast: logWrapper.showToast,
    );
    switch (logModel.type) {
      case LogType.http:
        break;
      case LogType.debug:
        LogManager.instance.addDebug(logModel);
        break;
      case LogType.info:
        LogManager.instance.addInfo(logModel);
        break;
      case LogType.error:
        LogManager.instance.addError(logModel);
        break;
      default:
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
    final color = kIsWeb || Platform.isAndroid
        ? _getLevelColor(level)
        : const AnsiColor.none();

    if (!_printLogsCompactly) {
      buffer.add(color(_topBorder));

      if (error != null) {
        final errorColor = kIsWeb || Platform.isAndroid
            ? _getErrorColor(level)
            : const AnsiColor.none();
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
    }
    final emoji = _getEmoji(level);
    if (message != null) {
      for (final line in message.split('\n')) {
        buffer.add(color(_getStringDependsOnCompactMode(emoji, line)));
      }
      if (!_printLogsCompactly) {
        buffer.add(color(_bottomBorder));
      }
    }

    return buffer;
  }

  String _getStringDependsOnCompactMode(String emoji, String line) =>
      _printLogsCompactly ? '$emoji$line' : '$verticalLine $emoji$line';

  /// [linesHasPackageName] is needed, because in stackTrace first there is just a line with the path
  /// where the log was created and then the same line only with the name of the method.
  ///
  /// Then we redo the line, so that the stackTrace on the mobile version and the web were the same.
  String? _formatSTWeb(List<String> lines, int methodCount) {
    final formatted = <String>[];
    var linesHasPackageName = 0;
    var count = 0;
    for (final line in lines) {
      if (line.contains(CRLoggerHelper.instance.packageInfo.packageName)) {
        linesHasPackageName++;
        if (linesHasPackageName > 1) {
          final groupLine = line.split('  ');
          final methodName =
              groupLine.last.replaceAll('[', '').replaceAll(']', '');
          final packageLine = groupLine.first.split('/');
          final newLine =
              '#$count   $methodName (package: ${packageLine[1]}/${packageLine[2]})';
          formatted.add(newLine);

          if (++count == methodCount) {
            break;
          }
        }
      }
    }

    return formatted.isEmpty ? null : formatted.join('\n');
  }

  String? _formatSTMobile(List<String> lines, int methodCount) {
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
}
