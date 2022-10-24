import 'package:flutter/material.dart';

/// Model value notifier
class NotifierData {
  NotifierData({
    required this.name,
    required this.valueNotifier,
    this.isWidget = false,
    this.connectedWidgetId,
  });

  final bool isWidget;
  final String name;
  final ValueNotifier<dynamic> valueNotifier;
  final String? connectedWidgetId;
}
