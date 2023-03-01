import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/res/colors.dart';
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

  final int? key;
  final String id;
  final dynamic message;
  final DateTime time;
  final String? stackTrace;
  final Map<String, dynamic>? data;
  LogType? type;
  Color color;

  @override
  int compareTo(LogBean other) {
    return other.time.isAfter(time) ? 1 : -1;
  }
}
