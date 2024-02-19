import 'package:cr_logger/src/res/styles.dart';
import 'package:cr_logger/src/widget/expand_arrow_button.dart';
import 'package:cr_logger/src/widget/json_widget/json_widget.dart';
import 'package:flutter/material.dart';

class JsonDetailsWidget extends StatefulWidget {
  const JsonDetailsWidget({
    required this.logMessage,
    super.key,
  });

  final Map<String, dynamic> logMessage;

  @override
  State<JsonDetailsWidget> createState() => _JsonDetailsWidgetState();
}

class _JsonDetailsWidgetState extends State<JsonDetailsWidget> {
  final _allExpandedNodesNotifier = ValueNotifier<bool>(true);

  @override
  void dispose() {
    _allExpandedNodesNotifier.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _allExpandedNodesNotifier,
      builder: (
        BuildContext context,
        bool isAllNodesExpanded,
        Widget? child,
      ) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Json title
                const Text(
                  'JSON data',
                  style: CRStyle.subtitle1BlackSemiBold16,
                ),

                /// Json expand button
                ExpandArrowButton(
                  isExpanded: isAllNodesExpanded,
                  onTap: _onExpandArrowTap,
                ),
              ],
            ),

            /// Json widget
            JsonWidget(
              widget.logMessage,
              allExpandedNodes: isAllNodesExpanded,
            ),
          ],
        );
      },
    );
  }

  void _onExpandArrowTap() {
    _allExpandedNodesNotifier.value = !_allExpandedNodesNotifier.value;
  }
}
