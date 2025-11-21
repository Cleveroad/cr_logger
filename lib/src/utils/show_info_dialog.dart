import 'package:cr_logger/src/cr_logger_helper.dart';
import 'package:flutter/material.dart';

Future<void> showInfoDialog({
  required BuildContext context,
  Widget? title,
  Widget? content,
}) =>
    showDialog(
      context: context,
      builder: (context) =>
          Theme(
            data: CRLoggerHelper.instance.theme,
            child: AlertDialog(
              title: title,
              content: content,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CLOSE'),
                ),
              ],
            ),
          ),
    );
