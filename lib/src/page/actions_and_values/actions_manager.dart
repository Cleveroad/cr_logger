import 'package:cr_logger/src/page/actions_and_values/models/action_model.dart';
import 'package:flutter/foundation.dart';

/// Manager through which methods are added to the page
final class ActionsManager {
  ActionsManager._();

  static final List<ActionModel> actions = [];

  static void addActionButton(String text,
      VoidCallback action, {
        String? connectedWidgetId,
      }) {
    actions.add(ActionModel(
      text: text,
      action: action,
      connectedWidgetId: connectedWidgetId,
    ));
  }

  static void removeActionButtonsById(String connectedWidgetId) {
    actions.removeWhere((action) {
      return action.connectedWidgetId == connectedWidgetId;
    });
  }
}
