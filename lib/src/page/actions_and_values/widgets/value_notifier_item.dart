import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/res/styles.dart';
import 'package:flutter/material.dart';

class ValueNotifierItem extends StatelessWidget {
  const ValueNotifierItem({
    required this.notifierData,
    super.key,
  });

  final NotifierData notifierData;

  @override
  Widget build(BuildContext context) {
    final notifier = notifierData.valueNotifier;

    return notifier != null
        ? ValueListenableBuilder(
            valueListenable: notifier,
            //ignore: prefer-trailing-comma
            builder: (_, value, __) {
              return Row(
                children: [
                  Expanded(
                    child: Text(
                      notifierData.name ?? '',
                      style: CRStyle.bodyBlackRegular14,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: GestureDetector(
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
          )
        : notifierData.widget ?? const SizedBox();
  }
}
