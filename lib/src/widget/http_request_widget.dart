import 'dart:math' as math;

import 'package:cr_logger/generated/assets.dart';
import 'package:cr_logger/src/bean/http_bean.dart';
import 'package:cr_logger/src/bean/request_bean.dart';
import 'package:cr_logger/src/colors.dart';
import 'package:cr_logger/src/constants.dart';
import 'package:cr_logger/src/extensions/extensions.dart';
import 'package:cr_logger/src/styles.dart';
import 'package:cr_logger/src/widget/json_widget/json_widget.dart';
import 'package:cr_logger/src/widget/url_value_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HttpRequestWidget extends StatefulWidget {
  const HttpRequestWidget(
    this.httpBean, {
    Key? key,
  }) : super(key: key);

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

    final color = (error != null || response?.statusCode == null)
        ? CRLoggerColors.red
        : CRLoggerColors.green;
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
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (statusCode != null)
                          Text(
                            statusCode.toString(),
                            style: CRStyle.subtitle1BlackSemiBold16
                                .copyWith(color: color),
                          )
                        else
                          Icon(
                            Icons.wifi_off,
                            color: color,
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
            UrlValueWidget(
              url: request?.url,
              requestTime: request?.requestTime,
              responseTime: response?.responseTime,
            ),
            const SizedBox(height: 12),
            HeadersExpansionTile(request: request),
            const SizedBox(height: 8),
            ValueListenableBuilder(
              valueListenable: _allExpandedNodesNotifier,
              builder: (
                BuildContext context,
                bool value,
                Widget? child,
              ) {
                return Material(
                  borderRadius: BorderRadius.circular(10),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: CRLoggerColors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      6,
                      16,
                      16,
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
                            Transform.rotate(
                              angle: value ? math.pi : 0,
                              child: IconButton(
                                onPressed: () => setState(() =>
                                    _allExpandedNodesNotifier.value = !value),
                                icon: ImageExt.fromPackage(
                                  Assets.assetsArrowDown,
                                  height: 28,
                                  width: 28,
                                ),
                                iconSize: 32,
                                splashRadius: 20,
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                        JsonWidget(
                          _getJsonObj(request),
                          allExpandedNodes: value,
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
                          allExpandedNodes: value,
                          key: _jsonWidgetParamsValueKey,
                        ),
                      ],
                    ),
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

class HeadersExpansionTile extends StatefulWidget {
  const HeadersExpansionTile({
    required this.request,
    Key? key,
  }) : super(key: key);

  final RequestBean? request;

  @override
  State<HeadersExpansionTile> createState() => _HeadersExpansionTileState();
}

class _HeadersExpansionTileState extends State<HeadersExpansionTile> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    var headersLength = widget.request?.headers?.length ?? 0;
    if (!expanded) {
      headersLength = headersLength > kMinVisibleHeaders
          ? kMinVisibleHeaders + 1
          : headersLength;
    }

    return Material(
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        padding: const EdgeInsets.fromLTRB(
          16,
          6,
          16,
          16,
        ),
        decoration: BoxDecoration(
          color: CRLoggerColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Headers',
                  style: CRStyle.subtitle1BlackSemiBold16,
                ),
                Transform.rotate(
                  angle: expanded ? math.pi : 0,
                  child: IconButton(
                    onPressed: () => setState(() => expanded = !expanded),
                    icon: ImageExt.fromPackage(
                      Assets.assetsArrowDown,
                      height: 28,
                      width: 28,
                    ),
                    iconSize: 32,
                    splashRadius: 20,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            if (widget.request?.headers?.isNotEmpty ?? false)
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: headersLength,
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  if (expanded ||
                      index < 3 ||
                      headersLength == kMinVisibleHeaders) {
                    final header =
                        widget.request?.headers?.keys.elementAt(index);
                    final value =
                        widget.request?.headers?.values.elementAt(index);

                    return Row(children: [
                      Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.purpleAccent.withOpacity(0.4),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '$header:',
                          style: CRStyle.bodyBlackMedium14,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: value == kHidden
                            ? Row(children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: CRLoggerColors.darkMagenta,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  child: Text(
                                    value.toString(),
                                    style: CRStyle.bodyWhiteSemiBold14,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ])
                            : Text(
                                value.toString(),
                                style: CRStyle.bodyBlackRegular14,
                                textAlign: TextAlign.left,
                              ),
                      ),
                    ]);
                  } else {
                    return const Text(
                      kMore,
                      style: CRStyle.bodyBlackMedium14,
                    );
                  }
                },
                separatorBuilder: (_, __) => const SizedBox(height: 4),
              ),
          ],
        ),
      ),
    );
  }
}
