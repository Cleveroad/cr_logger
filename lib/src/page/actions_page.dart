import 'package:cr_logger/src/colors.dart';
import 'package:cr_logger/src/cr_logger_helper.dart';
import 'package:cr_logger/src/widget/cr_app_bar.dart';
import 'package:flutter/material.dart';

/// Manager through which methods are added to the page
class ActionsManager {
  ActionsManager._();

  static final List<ElevatedButton> _actionButtons = [];

  static void addActionButton(String text, VoidCallback action) {
    _actionButtons.add(ElevatedButton(
      onPressed: action,
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        minimumSize: const Size(0, 77),
      ),
      child: Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: CRLoggerColors.primaryColor),
      ),
    ));
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
        body: ActionsManager._actionButtons.isNotEmpty
            ? GridView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: ActionsManager._actionButtons.length,
                itemBuilder: (_, index) {
                  return ActionsManager._actionButtons[index];
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
