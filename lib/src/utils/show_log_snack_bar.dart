import 'package:flutter/material.dart';

/// Displays the snack bar when a log is added with the snack bar display option
/// Pressing the "OPEN" button opens the logger, the tab in which the log
/// belongs and the log details page
void showLogSnackBar(
  ScaffoldMessengerState scaffoldMessengerState,
  VoidCallback? onOpen,
  String message,
) {
  final scaffold = scaffoldMessengerState;
  scaffold
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          'Log: $message',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        action: SnackBarAction(
          label: 'OPEN',
          textColor: Colors.green,
          //ignore:prefer-extracting-callbacks
          onPressed: () {
            scaffold.hideCurrentSnackBar();
            onOpen?.call();
          },
        ),
      ),
    );
}
