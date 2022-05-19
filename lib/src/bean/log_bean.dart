import 'package:cr_logger/src/colors.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class LogBean implements Comparable<LogBean> {
  LogBean({
    required this.message,
    required this.time,
    required this.stackTrace,
    this.data = const {},
    this.color = CRLoggerColors.primaryColor,
  });

  factory LogBean.fromJson(Map<String, dynamic> json) {
    return LogBean(
      message: json['message'] ?? '',
      time: DateTime.tryParse(json['time']) ?? DateTime.now(),
      stackTrace: json['stackTrace'] ?? '',
    );
  }

  final String id = const Uuid().v4();
  final dynamic message;
  final DateTime time;
  final String? stackTrace;
  final Map<String, dynamic> data;
  Color color;

  String getShortStackText() {
    if (stackTrace?.isEmpty ?? true) {
      return '';
    } else {
      final indexLongSize = stackTrace?.indexOf('#1');

      return indexLongSize != -1
          ? stackTrace?.substring(0, indexLongSize) ?? ''
          : stackTrace ?? '';
    }
  }

  Map<String, dynamic> toJson() => {
        'message': message.toString(),
        'time': time.toIso8601String(),
        'stackTrace': stackTrace,
        'data': data,
      };

  @override
  int compareTo(LogBean other) {
    return other.time.isAfter(time) ? 1 : -1;
  }
}
