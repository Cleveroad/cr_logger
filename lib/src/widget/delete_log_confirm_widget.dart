import 'package:cr_logger/src/constants.dart';
import 'package:cr_logger/src/res/styles.dart';
import 'package:flutter/material.dart';

class DeleteLogConfirmWidget extends StatelessWidget {
  const DeleteLogConfirmWidget({
    required this.message,
    this.textColor = Colors.black,
    super.key,
  });

  final String message;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    const buttonsTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.2,
      fontFamily: 'Urbanist',
      height: 1.4,
    );

    final buttonStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    );

    return SizedBox(
      height: 210,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  /// Title
                  const Text(
                    'Remove log from list?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.2,
                      fontFamily: 'Urbanist',
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  /// Log data
                  Text(
                    message.toString().replaceAll(patternOfParamsRegex, ''),
                    style: CRStyle.bodyGreyMedium14.copyWith(color: textColor),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.grey),
            Row(
              children: [

                /// Close button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: buttonStyle.copyWith(
                      backgroundColor: WidgetStateProperty.all(Colors.grey),
                    ),
                    child: const Text(
                      'Cancel',
                      style: buttonsTextStyle,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                /// Remove button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).pop(DeleteLogConfirmation.ok),
                    style: buttonStyle.copyWith(
                      backgroundColor: WidgetStateProperty.all(Colors.red),
                    ),
                    child: const Text(
                      'Yes, remove',
                      style: buttonsTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum DeleteLogConfirmation { cancel, ok }
