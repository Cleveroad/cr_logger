import 'package:cr_logger/src/page/actions_and_values/models/notifier_data.dart';
import 'package:flutter/cupertino.dart';

/// Manager through which value notifiers are added to the page
class NotifiersManager {
  NotifiersManager._();

  static final List<NotifierData> valueNotifiers = [];

  static void addNotifier({
    ValueNotifier? notifier,
    Widget? widget,
    String? name,
    String? connectedWidgetId,
  }) {
    valueNotifiers.add(
      NotifierData(
        name: name,
        valueNotifier: notifier,
        widget: widget,
        connectedWidgetId: connectedWidgetId,
      ),
    );
  }

  static void removeNotifiersById(String connectedWidgetId) {
    valueNotifiers.removeWhere((notifier) {
      return notifier.connectedWidgetId == connectedWidgetId;
    });
  }

  static void clear() {
    valueNotifiers.clear();
  }
}
