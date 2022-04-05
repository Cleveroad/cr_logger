import 'package:cr_logger/cr_logger.dart';
import 'package:flutter/material.dart';

class KeyValueWidget extends StatelessWidget {
  const KeyValueWidget(
    this.dataKey,
    this.dataValue, {
    Key? key,
  }) : super(key: key);

  final String dataKey, dataValue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: () => _onLongPress(context),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                dataKey.toString(),
                style: const TextStyle(fontSize: 15),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                dataValue.toString(),
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onLongPress(BuildContext context) {
    copyClipboard(context, dataValue);
  }
}
