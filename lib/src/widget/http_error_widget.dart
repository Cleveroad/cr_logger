import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/colors.dart';
import 'package:cr_logger/src/styles.dart';
import 'package:cr_logger/src/widget/json_widget/json_widget.dart';
import 'package:cr_logger/src/widget/url_value_widget.dart';
import 'package:flutter/material.dart';

class HttpErrorWidget extends StatefulWidget {
  const HttpErrorWidget(this.httpBean, {Key? key}) : super(key: key);

  final HttpBean httpBean;

  @override
  _HttpErrorWidgetState createState() => _HttpErrorWidgetState();
}

class _HttpErrorWidgetState extends State<HttpErrorWidget>
    with AutomaticKeepAliveClientMixin {
  final _jsonWidgetErrorValueKey = const ValueKey('ErrorPageParams');

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final errorBean = widget.httpBean.error;
    final statusCode = errorBean?.statusCode;
    final statusMessage = errorBean?.statusMessage;
    final url = errorBean?.url;

    super.build(context);

    return errorBean == null
        ? const Center(
            child: Text(
              'no error',
              style: CRStyle.bodyGreyMedium14,
            ),
          )
        : SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              16,
              0,
              16,
              16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UrlValueWidget(
                  url: url,
                  title: 'Dio error',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Status code and message
                      if (statusCode != null && statusMessage != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Status',
                              style: CRStyle.bodyBlackMedium14,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: CRLoggerColors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              child: Text(
                                '$statusCode $statusMessage',
                                style: CRStyle.bodyWhiteSemiBold14,
                              ),
                            ),
                          ],
                        ),
                      const Divider(height: 24),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                /// Params
                Material(
                  borderRadius: BorderRadius.circular(10),
                  child: Ink(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: CRLoggerColors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dio response:',
                          style: CRStyle.subtitle1BlackSemiBold16,
                        ),
                        const SizedBox(height: 12),
                        JsonWidget(
                          _getJsonObj(errorBean),
                          allExpandedNodes: true,
                          key: _jsonWidgetErrorValueKey,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Map<String, dynamic>? _getJsonObj(ErrorBean? error) {
    if (error?.errorData is List) {
      return {'[]': error?.errorData};
    } else if (error?.errorData is Map<String, dynamic>) {
      return {'Error': error?.errorData ?? ''};
    } else {
      return {'Error': error?.errorData.toString() ?? ''};
    }
  }
}
