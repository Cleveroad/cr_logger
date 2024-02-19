import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/extensions/extensions.dart';
import 'package:cr_logger/src/res/styles.dart';
import 'package:cr_logger/src/utils/parsers/url_parser.dart';
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
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final urlWithHiddenParams = getUrlWithHiddenParams(
      widget.url.toString(),
      showFullPath: _isExpanded,
    );
    final requestTime = widget.requestTime;
    final responseTime = widget.responseTime;

    return RoundedCard(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      onLongTap: () => copyClipboard(context, widget.url ?? ''),
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
                  maxLines: _isExpanded ? null : 1,
                  overflow: _isExpanded ? null : TextOverflow.ellipsis,
                  style: CRStyle.bodyBlackRegular14,
                ),
                const SizedBox(height: 4),

                /// Request time
                if (_isExpanded && requestTime != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'Request time: ${requestTime.formatTime(context)}',
                      style: CRStyle.bodyGreyRegular14,
                    ),
                  ),

                /// Response time
                if (_isExpanded && responseTime != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'Response time: ${responseTime.formatTime(context)}',
                      style: CRStyle.bodyGreyRegular14,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 4),

          /// Arrow button
          ExpandArrowButton(isExpanded: _isExpanded),
        ],
      ),
    );
  }
}
