import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void copyClipboard(BuildContext context,
    String value, {
      Color selectValueColor = Colors.white,
    }) {
  final snackBar = SnackBar(
    content: RichText(
      overflow: TextOverflow.ellipsis,
      maxLines: 4,
      text: TextSpan(
        children: [
          const TextSpan(text: 'Copy '),
          TextSpan(
            text: '"$value"',
            style: TextStyle(
              color: selectValueColor,
            ),
          ),
          const TextSpan(text: ' to clipboard'),
        ],
      ),
    ),
  );
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
  Clipboard.setData(ClipboardData(text: value));
}
