import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/extensions/extensions.dart';
import 'package:cr_logger/src/styles.dart';
import 'package:cr_logger/src/utils/url_parser.dart';
import 'package:cr_logger/src/widget/copy_widget.dart';
import 'package:cr_logger/src/widget/expand_arrow_button.dart';
import 'package:cr_logger/src/widget/rounded_card.dart';
import 'package:flutter/material.dart';

class UrlValueWidget extends StatefulWidget {
  const UrlValueWidget({
    required this.url,
    this.requestTime,
    this.responseTime,
    super.key,
  });

  final String? url;
  final DateTime? requestTime;
  final DateTime? responseTime;

  @override
  _UrlValueWidgetState createState() => _UrlValueWidgetState();
}

class _UrlValueWidgetState extends State<UrlValueWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final urlWithHiddenParams = getUrlWithHiddenParams(widget.url.toString());
    final requestTime = widget.requestTime;
    final responseTime = widget.responseTime;

    return RoundedCard(
      padding: const EdgeInsets.only(
        left: 16,
        top: 10,
        right: 16,
        bottom: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                /// URL
                Text(
                  urlWithHiddenParams,
                  maxLines: _expanded ? null : 1,
                  overflow: _expanded ? null : TextOverflow.ellipsis,
                  style: CRStyle.bodyBlackRegular14,
                ),
                const SizedBox(height: 4),

                /// Request time
                if (_expanded && requestTime != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'Request time: ${requestTime.formatTime()}',
                      style: CRStyle.bodyGreyRegular14,
                    ),
                  ),

                /// Response time
                if (_expanded && responseTime != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'Response time: ${responseTime.formatTime()}',
                      style: CRStyle.bodyGreyRegular14,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 4),

          /// Arrow button and copy widget
          Flex(
            direction: _expanded ? Axis.vertical : Axis.horizontal,
            verticalDirection: VerticalDirection.up,
            children: [
              CopyWidget(
                onCopy: () => copyClipboard(context, widget.url ?? ''),
              ),
              if (_expanded) const SizedBox(height: 4),
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
