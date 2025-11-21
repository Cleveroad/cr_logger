import 'package:flutter/material.dart';

/// Model value notifier
final class NotifierData {
  NotifierData({
    required this.valueNotifier,
    this.widget,
    this.name,
    this.connectedWidgetId,
  }) : assert(
  valueNotifier == null && name == null && widget != null ||
      valueNotifier != null && name != null && widget == null,
  "if widget is null, then name and valueNotifier can't be null and conversely",
  );

  final String? name;
  final ValueNotifier? valueNotifier;
  final Widget? widget;
  final String? connectedWidgetId;
}
