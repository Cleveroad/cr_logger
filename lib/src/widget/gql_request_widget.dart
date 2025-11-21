import 'package:cr_logger/src/constants.dart';
import 'package:cr_logger/src/data/bean/gql_bean.dart';
import 'package:cr_logger/src/extensions/graphql_ext.dart';
import 'package:cr_logger/src/extensions/string_ext.dart';
import 'package:cr_logger/src/models/request_status.dart';
import 'package:cr_logger/src/res/colors.dart';
import 'package:cr_logger/src/res/styles.dart';
import 'package:cr_logger/src/widget/body_expansion_tile.dart';
import 'package:cr_logger/src/widget/gql_request_info_widget.dart';
import 'package:cr_logger/src/widget/headers_expansion_tile.dart';
import 'package:flutter/material.dart';

class GQLRequestWidget extends StatefulWidget {
  const GQLRequestWidget(this.gqlBean, {
    super.key,
  });

  final GQLBean gqlBean;

  @override
  GQLRequestWidgetState createState() => GQLRequestWidgetState();
}

class GQLRequestWidgetState extends State<GQLRequestWidget>
    with AutomaticKeepAliveClientMixin {
  final _scrollCtrl = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final request = widget.gqlBean.request;
    final response = widget.gqlBean.response;
    final error = widget.gqlBean.error;

    final status = widget.gqlBean.status;
    final methodColor = GraphqlExt
        .fromString(request?.operationType)
        ?.color;
    // ? CRLoggerColors.orange
    // : CRLoggerColors.green;
    final statusCode = response?.statusCode ?? error?.statusCode;
    final operation = request?.operationName ?? ' - ';

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
                          request?.operationType?.capitalize() ?? '',
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
            HeadersExpansionTile(headers: request?.headers),
            const SizedBox(height: 12),

            /// URL
            GQLRequestInfoWidget(
              url: request?.url.toString() ?? '',
              operationName: operation,
              requestTime: request?.requestTime,
              responseTime: response?.responseTime,
            ),
            const SizedBox(height: 12),

            /// Body
            BodyExpansionTile(
              request: request,
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
}
