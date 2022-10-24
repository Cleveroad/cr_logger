import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/colors.dart';
import 'package:cr_logger/src/styles.dart';
import 'package:cr_logger/src/utils/url_parser.dart';
import 'package:cr_logger/src/widget/copy_widget.dart';
import 'package:cr_logger/src/widget/expand_arrow_button.dart';
import 'package:cr_logger/src/widget/rounded_card.dart';
import 'package:flutter/material.dart';

class ErrorValueWidget extends StatefulWidget {
  const ErrorValueWidget({
    required this.errorBean,
    super.key,
  });

  final ErrorBean errorBean;

  @override
  _ErrorValueWidgetState createState() => _ErrorValueWidgetState();
}

class _ErrorValueWidgetState extends State<ErrorValueWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final statusCode = widget.errorBean.statusCode;
    final statusMessage = widget.errorBean.statusMessage;
    final url = widget.errorBean.url;
    final urlWithHiddenParams = getUrlWithHiddenParams(url.toString());

    return RoundedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Error', style: CRStyle.subtitle1BlackSemiBold16),
              CopyWidget(onCopy: () => copyClipboard(context, url ?? '')),
            ],
          ),
          const SizedBox(height: 4),

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
          const Divider(height: 20),

          /// Link
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 4),
                  child: Text(
                    urlWithHiddenParams,
                    maxLines: _expanded ? null : 1,
                    overflow: _expanded ? null : TextOverflow.ellipsis,
                    style: CRStyle.bodyBlackRegular14,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              ExpandArrowButton(
                isExpanded: _expanded,
                onTap: () => setState(() => _expanded = !_expanded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
