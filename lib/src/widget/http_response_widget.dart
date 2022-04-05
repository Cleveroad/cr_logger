import 'dart:math' as math;

import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/generated/assets.dart';
import 'package:cr_logger/src/colors.dart';
import 'package:cr_logger/src/extensions/extensions.dart';
import 'package:cr_logger/src/styles.dart';
import 'package:cr_logger/src/widget/json_widget/json_widget.dart';
import 'package:cr_logger/src/widget/url_value_widget.dart';
import 'package:flutter/material.dart';

class HttpResponseWidget extends StatefulWidget {
  const HttpResponseWidget(this.httpBean, {Key? key}) : super(key: key);

  final HttpBean httpBean;

  @override
  HttpResponseWidgetState createState() => HttpResponseWidgetState();
}

class HttpResponseWidgetState extends State<HttpResponseWidget>
    with AutomaticKeepAliveClientMixin {
  double fontSize = 15;

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
    final data = response?.data ?? 'no response';

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          16,
          0,
          16,
          16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            HeadersExpansionTile(request: request),
            const SizedBox(height: 12),
            UrlValueWidget(url: request?.url),
            const SizedBox(height: 12),
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
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Data',
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
                        if (data is Map<String, dynamic> || data is List)
                          JsonWidget(
                            {'': data},
                            allExpandedNodes: value,
                            key: _jsonWidgetValueKey,
                          )
                        else
                          Text(
                            data.toString(),
                            style: CRStyle.bodyBlackMedium14,
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
}
