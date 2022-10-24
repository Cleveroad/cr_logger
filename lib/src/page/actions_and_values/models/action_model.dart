import 'package:flutter/foundation.dart';

/// Action data model for [ActionsManager]
class ActionModel {
  ActionModel({
    required this.text,
    required this.action,
    this.connectedWidgetId,
  });

  final String text;
  final VoidCallback action;
  final String? connectedWidgetId;
}
