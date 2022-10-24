import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/colors.dart';
import 'package:cr_logger/src/constants.dart';
import 'package:cr_logger/src/models/request_status.dart';
import 'package:cr_logger/src/styles.dart';
import 'package:cr_logger/src/widget/expand_arrow_button.dart';
import 'package:cr_logger/src/widget/headers_expansion_tile.dart';
import 'package:cr_logger/src/widget/json_widget/json_widget.dart';
import 'package:cr_logger/src/widget/rounded_card.dart';
import 'package:cr_logger/src/widget/url_value_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HttpRequestWidget extends StatefulWidget {
  const HttpRequestWidget(
    this.httpBean, {
    super.key,
  });

  final HttpBean httpBean;

  @override
  HttpRequestWidgetState createState() => HttpRequestWidgetState();
}

class HttpRequestWidgetState extends State<HttpRequestWidget>
    with AutomaticKeepAliveClientMixin {
  final _allExpandedNodesNotifier = ValueNotifier<bool>(false);
  final _jsonWidgetBodyValueKey = const ValueKey('RequestPageBody');
  final _jsonWidgetParamsValueKey = const ValueKey('RequestPageParams');
  final _scrollCtrl = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _allExpandedNodesNotifier.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final request = widget.httpBean.request;
    final response = widget.httpBean.response;
    final error = widget.httpBean.error;

    final status = widget.httpBean.status;
    final methodColor = request?.method == kMethodPost
        ? CRLoggerColors.orange
        : CRLoggerColors.green;
    final statusCode = response?.statusCode ?? error?.statusCode;

    return SingleChildScrollView(
      controller: _scrollCtrl,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: CRLoggerColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  /// Request method
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          request?.method ?? '',
                          style: CRStyle.subtitle1BlackSemiBold16
                              .copyWith(color: methodColor),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'method',
                          style: CRStyle.captionGreyMedium12,
                        ),
                      ],
                    ),
                  ),

                  /// Request duration
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${response?.duration ?? error?.duration ?? 0}',
                          style: CRStyle.subtitle1BlackSemiBold16.copyWith(
                            color: _getColorByDuration(
                              response?.duration ?? error?.duration ?? 0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          kMs,
                          style: CRStyle.captionGreyMedium12,
                        ),
                      ],
                    ),
                  ),

                  /// Request status
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (statusCode != null ||
                            status == RequestStatus.sending)
                          Text(
                            statusCode != null
                                ? statusCode.toString()
                                : kSending,
                            style: CRStyle.subtitle1BlackSemiBold16
                                .copyWith(color: status.color),
                          )
                        else
                          Icon(
                            status == RequestStatus.noInternet
                                ? Icons.wifi_off
                                : Icons.error,
                            color: status.color,
                            size: 18,
                          ),
                        const SizedBox(height: 6),
                        const Text(
                          'status',
                          style: CRStyle.captionGreyMedium12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            /// Headers
            HeadersExpansionTile(request: request),
            const SizedBox(height: 12),

            /// URL
            UrlValueWidget(
              url: request?.url,
              requestTime: request?.requestTime,
              responseTime: response?.responseTime,
            ),
            const SizedBox(height: 12),

            /// Body
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Body',
                            style: CRStyle.subtitle1BlackSemiBold16,
                          ),
                          ExpandArrowButton(
                            isExpanded: isAllNodesExpanded,
                            onTap: () => _allExpandedNodesNotifier.value =
                                !isAllNodesExpanded,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      JsonWidget(
                        _getJsonObj(request),
                        allExpandedNodes: isAllNodesExpanded,
                        key: _jsonWidgetBodyValueKey,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Params',
                        style: CRStyle.subtitle1BlackSemiBold16,
                      ),
                      const SizedBox(height: 12),
                      JsonWidget(
                        {'params': request?.params},
                        allExpandedNodes: isAllNodesExpanded,
                        key: _jsonWidgetParamsValueKey,
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

  Color _getColorByDuration(int duration) {
    if (duration < kMinDuration) {
      return CRLoggerColors.green;
    } else if (duration < kAverageDuration) {
      return CRLoggerColors.orange;
    } else {
      return CRLoggerColors.red;
    }
  }

  Map<String, dynamic>? _getJsonObj(request) {
    if (request?.body is FormData) {
      return {'formData': request?.getFormData() ?? ''};
    } else if (request?.body is List) {
      return {'[]': request?.body ?? ''};
    } else if (request?.body is Map<String, dynamic>) {
      return {'body': request?.body ?? ''};
    } else {
      return {'body': request?.body.toString() ?? ''};
    }
  }
}
