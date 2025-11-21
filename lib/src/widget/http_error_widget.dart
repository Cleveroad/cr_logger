import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/res/styles.dart';
import 'package:cr_logger/src/widget/error_value_widget.dart';
import 'package:cr_logger/src/widget/json_widget/json_widget.dart';
import 'package:cr_logger/src/widget/rounded_card.dart';
import 'package:flutter/material.dart';

class HttpErrorWidget extends StatefulWidget {
  const HttpErrorWidget(this.httpBean, {super.key});

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
    super.build(context);

    final errorBean = widget.httpBean.error;

    return errorBean == null
        ? const Center(
      child: Text(
        'No error',
        style: CRStyle.bodyGreyMedium14,
      ),
    )
        : SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ErrorValueWidget(errorBean: errorBean),
          const SizedBox(height: 12),

          /// Error response
          RoundedCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Response:',
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
        ],
      ),
    );
  }

  Map<String, dynamic>? _getJsonObj(HttpErrorBean? error) {
    final errorData = error?.errorData;

    return errorData is Map<String, dynamic>
        ? errorData
        : {'Error': error?.errorData.toString() ?? ''};
  }
}
