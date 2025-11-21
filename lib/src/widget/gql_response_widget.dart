import 'package:cr_logger/src/data/bean/gql_bean.dart';
import 'package:cr_logger/src/res/styles.dart';
import 'package:cr_logger/src/widget/expand_arrow_button.dart';
import 'package:cr_logger/src/widget/gql_request_info_widget.dart';
import 'package:cr_logger/src/widget/headers_expansion_tile.dart';
import 'package:cr_logger/src/widget/json_widget/json_widget.dart';
import 'package:cr_logger/src/widget/rounded_card.dart';
import 'package:flutter/material.dart';

class GQLResponseWidget extends StatefulWidget {
  const GQLResponseWidget(this.gqlBean, {super.key});

  final GQLBean gqlBean;

  @override
  GQLResponseWidgetState createState() => GQLResponseWidgetState();
}

class GQLResponseWidgetState extends State<GQLResponseWidget>
    with AutomaticKeepAliveClientMixin {
  final _allExpandedNodesNotifier = ValueNotifier<bool>(false);
  final _jsonWidgetValueKey = const ValueKey('ResponsePage');

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _allExpandedNodesNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final request = widget.gqlBean.request;
    final response = widget.gqlBean.response;
    final data = response?.data;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Headers
            HeadersExpansionTile(headers: response?.headers),
            const SizedBox(height: 12),

            /// URL
            GQLRequestInfoWidget(
              url: request?.url.toString() ?? '',
              operationName: request?.operationName ?? ' - ',
            ),
            const SizedBox(height: 12),

            /// Data
            ValueListenableBuilder(
              valueListenable: _allExpandedNodesNotifier,
              builder: (BuildContext context,
                  bool isAllNodesExpanded,
                  Widget? child,) {
                return RoundedCard(
                  padding: const EdgeInsets.only(
                    left: 16,
                    top: 10,
                    right: 16,
                    bottom: 12,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Data',
                            style: CRStyle.subtitle1BlackSemiBold16,
                          ),
                          if (data != null)
                            ExpandArrowButton(
                              isExpanded: isAllNodesExpanded,
                              onTap: () =>
                              _allExpandedNodesNotifier.value =
                              !isAllNodesExpanded,
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (data is Map<String, dynamic> || data is List)
                        JsonWidget(
                          data,
                          allExpandedNodes: isAllNodesExpanded,
                          key: _jsonWidgetValueKey,
                        )
                      else
                        Text(
                          data?.toString() ?? 'No response',
                          style: CRStyle.bodyBlackMedium14,
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
