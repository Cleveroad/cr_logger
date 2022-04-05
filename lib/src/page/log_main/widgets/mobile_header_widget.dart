import 'package:cr_logger/src/colors.dart';
import 'package:cr_logger/src/styles.dart';
import 'package:flutter/material.dart';

class MobileHeaderWidget extends StatelessWidget {
  const MobileHeaderWidget({
    required this.onClear,
    required this.onAllClear,
    Key? key,
  }) : super(key: key);

  final VoidCallback onClear;
  final VoidCallback onAllClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: const [
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
                primary: CRLoggerColors.red,
              ),
              child: const Text(
                'Clear logs',
                style: CRStyle.bodyRedMedium14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
