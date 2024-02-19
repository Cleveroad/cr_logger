import 'package:flutter/material.dart';

/// Displays the snack bar after deleting the log
/// Pressing the "UNDO" button restores the deleted log
void showRemoveLogSnackBar(BuildContext context, VoidCallback? onUndo) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: const Text(
          'Log has been deleted',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.green,
          //ignore:prefer-extracting-callbacks
          onPressed: () {
            scaffold.hideCurrentSnackBar();
            onUndo?.call();
          },
        ),
      ),
    );
}
