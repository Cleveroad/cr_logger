import 'package:cr_json_widget/cr_json_widget.dart';
import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/widget/json_widget/json_node_content.dart';
import 'package:flutter/material.dart';

class JsonWidget extends StatefulWidget {
  const JsonWidget(
    this.jsonObj, {
    this.notRoot,
    this.caption,
    this.allExpandedNodes = false,
    this.uncovered = 1,
    super.key,
  });

  final Map<String, dynamic>? jsonObj;
  final bool? notRoot;
  final Widget? caption;
  final bool allExpandedNodes;
  final int uncovered;

  @override
  JsonWidgetState createState() => JsonWidgetState();
}

class JsonWidgetState extends State<JsonWidget> {
  final double _iconSize = 14;

  late final _jsonController = JsonController(
    allNodesExpanded: widget.allExpandedNodes,
    uncovered: widget.uncovered,
  );

  List<JsonNode>? _listNodes;

  @override
  void initState() {
    super.initState();
    _updateNodes();
  }

  @override
  void didUpdateWidget(covariant JsonWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateNodes();
    if (oldWidget.allExpandedNodes != widget.allExpandedNodes) {
      if (widget.allExpandedNodes) {
        _jsonController.expandAll();
      } else {
        _jsonController.collapseAll();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.jsonObj == null
        ? const SizedBox()
        : Padding(
            padding:
                EdgeInsets.only(left: (widget.notRoot ?? false) ? 14.0 : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.caption != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: widget.caption,
                  ),

                /// JsonTreeView
                CrJsonWidget(
                  iconOpened: Icon(
                    Icons.arrow_drop_down,
                    size: _iconSize,
                  ),
                  iconClosed: Icon(
                    Icons.arrow_right,
                    size: _iconSize,
                  ),
                  indentHeight: 5,
                  indentLeftEndJsonNode: _iconSize,
                  jsonNodes: _listNodes!,
                  jsonController: _jsonController,
                ),
              ],
            ),
          );
  }

  /// Create Nodes
  List<JsonNode> _toTreeNodes(parsedJson) {
    /// Create Map Nodes
    if (parsedJson is Map) {
      return parsedJson.entries.map((k) {
        final isHidden =
            CRLoggerInitializer.instance.hiddenFields.contains(k.key);
        List<JsonNode>? children;

        /// If the item is a List or a Map then create a node
        /// with nesting otherwise create a node without nesting
        children = parsedJson[k.key] is Map || parsedJson[k.key] is List
            ? _toTreeNodes(parsedJson[k.key])
            : null;

        return JsonNode(
          content: JsonNodeContent(
            keyValue: '${k.key}: ',
            value: k.value,
            isHidden: isHidden,
          ),
          children: isHidden ? null : children,
        );
      }).toList();
    }

    /// Create List Nodes
    if (parsedJson is List) {
      return parsedJson
          .asMap()
          .map((i, element) {
            List<JsonNode>? children;

            /// If the item is a List or a Map then create a node
            /// with nesting otherwise create a node without nesting
            children = element is Map || element is List
                ? _toTreeNodes(element)
                : null;

            return MapEntry(
              i,
              JsonNode(
                content: JsonNodeContent(
                  keyValue: '[$i]:  ',
                  value: element,
                ),
                children: children,
              ),
            );
          })
          .values
          .toList();
    }

    return [JsonNode(content: Text(parsedJson.toString()))];
  }

  void _updateNodes() {
    if (widget.jsonObj != null) {
      _listNodes = _toTreeNodes(widget.jsonObj!);
    }
  }
}
