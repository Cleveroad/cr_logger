import 'package:cr_logger/src/utils/copy_clipboard.dart';
import 'package:cr_logger/src/utils/json_utils.dart';
import 'package:cr_logger/src/widget/json_widget/json_tree_colors.dart';
import 'package:flutter/material.dart';

class JsonNodeContent extends StatelessWidget {
  const JsonNodeContent({
    required this.keyValue,
    this.value,
    super.key,
  });

  final String keyValue;
  final Object? value;

  @override
  Widget build(BuildContext context) {
    var valueText = '';

    /// If the value is a List, print its type and cardinality
    /// (example: Array<int>[10])
    if (value is List) {
      final listNode = value as List;
      valueText = listNode.isEmpty
          ? 'Array[0]'
          : 'Array<${_getTypeName(listNode.first)}>[${listNode.length}]';

      /// If the type is map, output - Object
    } else if (value is Map) {
      valueText = 'Object';
    } else {
      valueText = value is String ? '"$value"' : value.toString();
    }

    return GestureDetector(
      onLongPress: () => _onLongPress(context),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: keyValue,
              style: const TextStyle(
                color: jsonTreeColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: valueText,
              style: TextStyle(
                color: _getTypeColor(value),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(Object? content) {
    if (content is int) {
      return intColor;
    } else if (content is String) {
      return stringColor;
    } else if (content is bool) {
      return boolColor;
    } else if (content is double) {
      return doubleColor;
    } else {
      return nullColor;
    }
  }

  String _getTypeName(content) {
    if (content is int) {
      return 'int';
    } else if (content is String) {
      return 'String';
    } else if (content is bool) {
      return 'bool';
    } else if (content is double) {
      return 'double';
    } else if (content is List) {
      return 'List';
    }

    return 'Object';
  }

  void _onLongPress(BuildContext context) {
    copyClipboard(
      context,
      value is Map<String, dynamic> ? toJson(value) : value.toString(),
      selectValueColor: _getTypeColor(value),
    );
  }
}
