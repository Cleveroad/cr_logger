import 'package:cr_logger/src/log_message_wrapper.dart';
import 'package:logger/logger.dart';

final class CRLoggerWrapper {
  CRLoggerWrapper._();

  static final CRLoggerWrapper instance = CRLoggerWrapper._();

  late Logger log;

  /// It is necessary to be careful with the use of the [showToast] parameter,
  /// because at a high refresh rate the logs with this parameter will be missed
  /// for a detailed view.
  void t(dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    bool showToast = false,
  }) {
    log.t(
      LogMessageWrapper(
        message: message,
        showToast: showToast,
      ),
      error: error,
      stackTrace: stackTrace,
    );
  }

  void d(dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    bool showToast = false,
  }) {
    log.d(
      LogMessageWrapper(
        message: message,
        showToast: showToast,
      ),
      error: error,
      stackTrace: stackTrace,
    );
  }

  void i(dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    bool showToast = false,
  }) {
    log.i(
      LogMessageWrapper(
        message: message,
        showToast: showToast,
      ),
      error: error,
      stackTrace: stackTrace,
    );
  }

  void w(dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    bool showToast = false,
  }) {
    log.w(
      LogMessageWrapper(
        message: message,
        showToast: showToast,
      ),
      error: error,
      stackTrace: stackTrace,
    );
  }

  void e(dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    bool showToast = false,
  }) {
    log.e(
      LogMessageWrapper(
        message: message,
        showToast: showToast,
      ),
      error: error,
      stackTrace: stackTrace,
    );
  }

  void f(dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    bool showToast = false,
  }) {
    log.f(
      LogMessageWrapper(
        message: message,
        showToast: showToast,
      ),
      error: error,
      stackTrace: stackTrace,
    );
  }
}
