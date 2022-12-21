import 'package:cr_json_widget/cr_json_recycler.dart';
import 'package:cr_logger/cr_logger.dart';
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
  late final _jsonCtr = JsonRecyclerController(isExpanded: true);

  Map<String, dynamic>? _jsonWithHiddenParameters;

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
      _jsonCtr.changeState();
    }
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
                    ),
                  ],
                ),
              ],
            ),
          );
  }

  /// Create Nodes3 = {map entry} "Test3" -> "Hidden"4 = {map entry} "Test4" -3 = {map entry} "Test3" -> "Hidden"> [_InternalLinkedHashMap]
  Map<String, dynamic>? _toTreeJson(Map<String, dynamic> jsonObj) {
    for (final obj in jsonObj.keys) {
      final isHidden = CRLoggerInitializer.instance.hiddenFields.contains(obj);
      if (isHidden) {
        jsonObj[obj] = 'Hidden';
      }
    }

    return jsonObj;
  }

  void _updateNodes() {
    if (widget.jsonObj != null) {
      _jsonWithHiddenParameters = _toTreeJson(widget.jsonObj!);
    }
  }
}
