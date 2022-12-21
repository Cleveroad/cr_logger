import 'package:cr_logger/src/res/colors.dart';
import 'package:cr_logger/src/res/styles.dart';
import 'package:flutter/material.dart';

class WebHeaderWidget extends StatelessWidget {
  const WebHeaderWidget({
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
        Row(
          children: const [
            SizedBox(width: 16),
            Text(
              'Logs',
              style: CRStyle.h2BlackSemibold,
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
              child: const Text(
                'Clear logs',
                style: CRStyle.subtitle1RedMedium16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
