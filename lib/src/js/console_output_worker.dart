@JS()
library console_output;

// ignore: avoid_web_libraries_in_flutter
import 'package:cr_logger/src/utils/html_stub.dart'
if (dart.library.js) 'package:js/js.dart';

@JS('printLogs')
external void printLogs(List<String> lines);

@JS('printRequestLog')
external void printRequestLog(String requestBean);

@JS('printResponseLog')
external void printResponseLog(String responseBean);

@JS('printErrorLog')
external void printErrorLog(String errorBean);

@JS('downloadLogsWeb')
external void downloadLogsWeb(String fileName, String text);
