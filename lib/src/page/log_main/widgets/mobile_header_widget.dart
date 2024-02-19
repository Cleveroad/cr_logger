import 'package:cr_logger/src/controllers/logs_mode.dart';
import 'package:cr_logger/src/controllers/logs_mode_controller.dart';
import 'package:cr_logger/src/res/colors.dart';
import 'package:cr_logger/src/res/styles.dart';
import 'package:flutter/material.dart';

class MobileHeaderWidget extends StatelessWidget {
  const MobileHeaderWidget({
    required this.onClear,
    required this.onAllClear,
    super.key,
  });

  final VoidCallback onClear;
  final VoidCallback onAllClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          children: [
            SizedBox(width: 16),
            Text(
              'Logs',
              style: CRStyle.subtitle1BlackSemiBold16,
            ),
          ],
        ),
        Row(
          children: [
            TextButton(
              onPressed: onClear,
              onLongPress: onAllClear,
              style: TextButton.styleFrom(
                minimumSize: const Size(0, 20),
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 16,
                ),
                foregroundColor: CRLoggerColors.red,
              ),
              child: ValueListenableBuilder(
                valueListenable: LogsModeController.instance.logMode,
                //ignore: prefer-trailing-comma
                builder: (_, value, __) => Text(
                  value == LogsMode.fromCurrentSession
                      ? 'Clear logs'
                      : 'Clear logs from DB',
                  style: CRStyle.bodyRedMedium14,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
