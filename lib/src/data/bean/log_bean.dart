import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/res/colors.dart';
import 'package:cr_logger/src/utils/enum_ext.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class LogBean implements Comparable<LogBean> {
  LogBean({
    required this.message,
    required this.time,
    required this.stackTrace,
    this.type,
    this.data = const {},
    this.color = CRLoggerColors.primaryColor,
    this.key,
    String? id,
  }) : id = id ?? const Uuid().v4();

  factory LogBean.fromJson(Map<String, dynamic> json) {
    return LogBean(
      key: json['key'],
      id: json['id'],
      message: json['message'],
      time: DateTime.tryParse(json['time']) ?? DateTime.now(),
      stackTrace: json['stackTrace'],
      data: json['data'],
      type: LogType.values.valueOf(json['type']) ?? LogType.info,
    );
  }

  final int? key;
  final String id;
  final dynamic message;
  final DateTime time;
  final String? stackTrace;
  final Map<String, dynamic>? data;
  LogType? type;
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
        'key': key,
        'id': id,
        'type': type?.name,
      };

  @override
  int compareTo(LogBean other) {
    return other.time.isAfter(time) ? 1 : -1;
  }
}
