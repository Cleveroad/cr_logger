import 'package:cr_logger/src/colors.dart';
import 'package:cr_logger/src/cr_logger_helper.dart';
import 'package:cr_logger/src/widget/cr_app_bar.dart';
import 'package:flutter/material.dart';

/// Action data model for [ActionsManager]
class _ActionModel {
  _ActionModel({
    required this.text,
    required this.action,
    this.connectedWidgetId,
  });

  final String text;
  final VoidCallback action;
  final String? connectedWidgetId;
}

/// Manager through which methods are added to the page
class ActionsManager {
  ActionsManager._();

  static final List<_ActionModel> _actions = [];

  static void addActionButton(
    String text,
    VoidCallback action, {
    String? connectedWidgetId,
  }) {
    _actions.add(_ActionModel(
      text: text,
      action: action,
      connectedWidgetId: connectedWidgetId,
    ));
  }

  static void removeActionButtonsById(String connectedWidgetId) {
    _actions.removeWhere((action) {
      return action.connectedWidgetId == connectedWidgetId;
    });
  }
}

/// Page with buttons calling added methods from the logger
class ActionsPage extends StatelessWidget {
  const ActionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: CRLoggerHelper.instance.theme.copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              CRLoggerHelper.instance.theme.colorScheme.secondary,
            ),
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: CRLoggerColors.backgroundGrey,
        appBar: const CRAppBar(title: 'Actions page'),
        body: ActionsManager._actions.isNotEmpty
            ? GridView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: ActionsManager._actions.length,
                itemBuilder: (_, index) {
                  final actionModel = ActionsManager._actions[index];

                  return ElevatedButton(
                    onPressed: actionModel.action,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                      minimumSize: const Size(0, 77),
                    ),
                    child: Text(
                      actionModel.text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(color: CRLoggerColors.primaryColor),
                    ),
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 40,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
              )
            : const Center(
                child: Text(
                  'There are no actions.\nContact developer to add.',
                  textAlign: TextAlign.center,
                ),
              ),
      ),
    );
  }
}
