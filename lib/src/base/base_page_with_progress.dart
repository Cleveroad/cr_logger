import 'package:cr_logger/src/controllers/logs_mode_controller.dart';
import 'package:cr_logger/src/res/colors.dart';
import 'package:flutter/material.dart';

abstract class BasePageWithProgress<T extends StatefulWidget> extends State<T> {
  final _logsModeController = LogsModeController.instance;

  LogsMode get currentLogsMode => _logsModeController.logMode.value;

  @override
  void initState() {
    super.initState();
    _logsModeController.addListener(getCurrentLogs);
  }

  @override
  void dispose() {
    _logsModeController.removeListener(getCurrentLogs);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _logsModeController.progressNotifier,
      //ignore: prefer-trailing-comma
      builder: (_, isProgressState, __) => isProgressState
          ? Container(
              color: CRLoggerColors.backgroundGrey.withOpacity(0.8),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Builder(
              builder: (_) => bodyWidget(context),
            ),
    );
  }

  Widget bodyWidget(BuildContext context);

  Future<void> getCurrentLogs();
}
