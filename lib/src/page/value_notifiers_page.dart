import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/colors.dart';
import 'package:cr_logger/src/cr_logger_helper.dart';
import 'package:cr_logger/src/styles.dart';
import 'package:cr_logger/src/widget/cr_app_bar.dart';
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

/// Manager through which value notifiers are added to the page
class NotifiersManager {
  NotifiersManager._();

  static final List<NotifierData> valueNotifiers = [];

  static void addNotifier(
    String name,
    ValueNotifier<dynamic> notifier, {
    String? connectedWidgetId,
  }) {
    valueNotifiers.add(NotifierData(
      name: name,
      valueNotifier: notifier,
      isWidget: notifier.value is Widget,
      connectedWidgetId: connectedWidgetId,
    ));
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

/// The page for observing the values of the added variables
class ValueNotifiersPage extends StatelessWidget {
  const ValueNotifiersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: CRLoggerHelper.instance.theme,
      child: Scaffold(
        backgroundColor: CRLoggerColors.backgroundGrey,
        appBar: const CRAppBar(title: 'Value notifiers'),
        body: NotifiersManager.valueNotifiers.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    /// Name - Value
                    Row(
                      children: const [
                        Expanded(
                          child: Text(
                            'Name',
                            style: CRStyle.h1Green,
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            'Value',
                            style: CRStyle.h1Green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    /// List notifiers
                    Expanded(
                      child: ListView.separated(
                        physics: const ClampingScrollPhysics(),
                        itemCount: NotifiersManager.valueNotifiers.length,
                        itemBuilder: (_, index) {
                          return ValueListenableBuilder(
                            valueListenable: NotifiersManager
                                .valueNotifiers[index].valueNotifier,
                            //ignore: Prefer-trailing-comma
                            builder: (_, value, __) {
                              final widget = value is Widget
                                  ? value
                                  : const Text(
                                      'Bad widget',
                                      style: CRStyle.subtitle1BlackMedium16,
                                    );

                              return Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      NotifiersManager
                                          .valueNotifiers[index].name,
                                      style: CRStyle.subtitle1BlackMedium16,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: NotifiersManager
                                            .valueNotifiers[index].isWidget
                                        ? widget
                                        : GestureDetector(
                                            onLongPress: () => copyClipboard(
                                              context,
                                              value.toString(),
                                            ),
                                            child: Text(
                                              value.toString(),
                                              style: CRStyle
                                                  .subtitle1BlackMedium16,
                                            ),
                                          ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        separatorBuilder: (_, __) => const Divider(),
                      ),
                    ),
                  ],
                ),
              )
            : const Center(
                child: Text(
                  'There are no values.\nContact developer to add.',
                  textAlign: TextAlign.center,
                ),
              ),
      ),
    );
  }
}
