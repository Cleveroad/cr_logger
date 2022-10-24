import 'package:cr_logger/src/dio_log.dart';
import 'package:cr_logger/src/page/actions_and_values/models/notifier_data.dart';
import 'package:cr_logger/src/styles.dart';
import 'package:flutter/material.dart';

class ValueNotifierItem extends StatelessWidget {
  const ValueNotifierItem({
    required this.notifierData,
    super.key,
  });

  final NotifierData notifierData;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifierData.valueNotifier,
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
                notifierData.name,
                style: CRStyle.bodyBlackRegular14,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: notifierData.isWidget
                  ? widget
                  : GestureDetector(
                      onLongPress: () => copyClipboard(
                        context,
                        value.toString(),
                      ),
                      child: Text(
                        value.toString(),
                        style: CRStyle.bodyBlackRegular14,
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}
