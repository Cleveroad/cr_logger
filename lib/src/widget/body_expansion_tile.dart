import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/res/colors.dart';
import 'package:cr_logger/src/res/styles.dart';
import 'package:cr_logger/src/widget/expand_arrow_button.dart';
import 'package:cr_logger/src/widget/json_widget/json_widget.dart';
import 'package:cr_logger/src/widget/rounded_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class BodyExpansionTile extends StatefulWidget {
  const BodyExpansionTile({
    required this.request,
    super.key,
  });

  final RequestBean? request;

  @override
  State<BodyExpansionTile> createState() => _BodyExpansionTileState();
}

class _BodyExpansionTileState extends State<BodyExpansionTile> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    const _jsonWidgetBodyValueKey = ValueKey('RequestPageBody');
    final bodyLength = _getBody(widget.request)?.length ?? 0;
    final bodyIsNotEmpty = bodyLength != 0;

    return RoundedCard(
      padding: const EdgeInsets.only(
        left: 16,
        top: 10,
        right: 16,
        bottom: 10,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Body',
                  style: CRStyle.subtitle1BlackSemiBold16,
                ),
              ),
              Text(
                '$bodyLength',
                style: CRStyle.subtitle1BlackSemiBold16.copyWith(
                  color: CRLoggerColors.grey,
                ),
              ),
              const SizedBox(width: 6),
              ExpandArrowButton(
                isExpanded: _expanded && bodyIsNotEmpty,
                onTap: bodyIsNotEmpty
                    ? () => setState(() => _expanded = !_expanded)
                    : null,
              ),
            ],
          ),
          if (bodyIsNotEmpty)
            JsonWidget(
              _getBody(widget.request),
              allExpandedNodes: _expanded,
              key: _jsonWidgetBodyValueKey,
            ),
        ],
      ),
    );
  }

  Map<String, dynamic>? _getBody(request) {
    if (request?.body is FormData) {
      return request?.getFormData() ?? '';
    } else if (request?.body is List) {
      return request?.body ?? '';
    } else if (request?.body is Map<String, dynamic>) {
      return request?.body ?? '';
    } else {
      return null;
    }
  }
}
