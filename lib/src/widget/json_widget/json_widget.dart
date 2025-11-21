import 'package:cr_json_widget/cr_json_recycler.dart';
import 'package:cr_logger/cr_logger.dart';
import 'package:flutter/material.dart';

class JsonWidget extends StatefulWidget {
  const JsonWidget(this.jsonObj, {
    this.notRoot,
    this.caption,
    this.allExpandedNodes = false,
    this.uncovered = 1,
    super.key,
  });

  final dynamic jsonObj;
  final bool? notRoot;
  final Widget? caption;
  final bool allExpandedNodes;
  final int uncovered;

  @override
  JsonWidgetState createState() => JsonWidgetState();
}

class JsonWidgetState extends State<JsonWidget> {
  late final _jsonCtr = JsonRecyclerController(isExpanded: false);

  Map<String, dynamic>? _jsonWithHiddenParameters;

  @override
  void initState() {
    super.initState();
    _updateNodes();
  }

  @override
  Widget build(BuildContext context) {
    final jsonObj = widget.jsonObj;

    return jsonObj == null || jsonObj.isEmpty
        ? const SizedBox()
        : Padding(
      padding:
      EdgeInsets.only(left: (widget.notRoot ?? false) ? 14.0 : 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.caption != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: widget.caption,
            ),

          /// JsonTreeView
          CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            slivers: [
              CrJsonRecyclerSliver(
                jsonController: _jsonCtr,
                json: _jsonWithHiddenParameters,
                rootExpanded: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(covariant JsonWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateNodes();
    if (oldWidget.allExpandedNodes != widget.allExpandedNodes) {
      _jsonCtr.changeState();
    }
  }

  /// Create Nodes3 = {map entry} "Test3" -> "Hidden"4 = {map entry} "Test4" -3 = {map entry} "Test3" -> "Hidden"> [_InternalLinkedHashMap]
  Map<String, dynamic>? _toTreeJson(Map<String, dynamic> jsonObj) {
    /// Handle error: modifing unmodified map
    final newJsonObj = Map.of(jsonObj);
    for (final obj in newJsonObj.keys) {
      final isHidden = CRLoggerInitializer.instance.hiddenFields.contains(obj);
      if (isHidden) {
        newJsonObj[obj] = 'Hidden';
      }
    }

    return newJsonObj;
  }

  void _updateNodes() {
    final jsonObject = widget.jsonObj;

    if (jsonObject != null) {
      if (jsonObject is Map<String, dynamic>) {
        _jsonWithHiddenParameters = _toTreeJson(jsonObject);
      }

      /// If the input is a list, we need to handle it differently.
      /// This situation can occur when the JSON is an array of objects rather than a single object.
      else if (jsonObject is List) {
        final list = jsonObject;
        if (list.isNotEmpty) {
          final mergedItemsMap = <String, dynamic>{};

          /// Each item in the list is given a unique key like 'item0', 'item1', etc.
          /// This transforms the list into a single map so we can use the same tree conversion logic
          /// as we do for a standard Map. It avoids having to handle lists separately downstream.
          for (var i = 0; i < list.length; i++) {
            if (list[i] is Map<String, dynamic>) {
              mergedItemsMap['item$i'] = list[i];
            }
          }

          _jsonWithHiddenParameters = _toTreeJson(mergedItemsMap);
        }
      }
    }
  }
}
