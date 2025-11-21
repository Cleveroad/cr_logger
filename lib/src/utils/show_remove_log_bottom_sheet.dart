import 'package:cr_logger/src/utils/web_utils.dart';
import 'package:cr_logger/src/widget/delete_log_confirm_widget.dart';
import 'package:flutter/material.dart';

Future<bool> showRemoveLogBottomSheet(BuildContext context, {
  required String message,
  final Color textColor = Colors.black,
}) async {
  final bottomSheetWidth =
  MediaQuery
      .of(context)
      .size
      .width > kWidthTrashHoldForMobileLayout
      ? 400.0
      : double.infinity;

  final result = await showModalBottomSheet<DeleteLogConfirmation?>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(20),
        topLeft: Radius.circular(20),
      ),
    ),
    constraints: BoxConstraints(maxWidth: bottomSheetWidth),
    builder: (context) =>
        DeleteLogConfirmWidget(
          message: message,
          textColor: textColor,
        ),
  );

  return result == DeleteLogConfirmation.ok;
}
