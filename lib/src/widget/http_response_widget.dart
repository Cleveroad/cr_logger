import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/res/styles.dart';
import 'package:cr_logger/src/widget/expand_arrow_button.dart';
import 'package:cr_logger/src/widget/headers_expansion_tile.dart';
import 'package:cr_logger/src/widget/json_widget/json_widget.dart';
import 'package:cr_logger/src/widget/rounded_card.dart';
import 'package:cr_logger/src/widget/url_value_widget.dart';
import 'package:flutter/material.dart';

class HttpResponseWidget extends StatefulWidget {
  const HttpResponseWidget(this.httpBean, {super.key});

  final HttpBean httpBean;

  @override
  HttpResponseWidgetState createState() => HttpResponseWidgetState();
}

class HttpResponseWidgetState extends State<HttpResponseWidget>
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

    final request = widget.httpBean.request;
    final response = widget.httpBean.response;
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
            UrlValueWidget(url: request?.url),
            const SizedBox(height: 12),

            /// Data
            ValueListenableBuilder(
              valueListenable: _allExpandedNodesNotifier,
              builder: (
                BuildContext context,
                bool isAllNodesExpanded,
                Widget? child,
              ) {
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
                              onTap: () => _allExpandedNodesNotifier.value =
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
