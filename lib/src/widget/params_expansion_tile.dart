import 'package:cr_logger/src/data/bean/http/http_request_bean.dart';
import 'package:cr_logger/src/res/colors.dart';
import 'package:cr_logger/src/res/styles.dart';
import 'package:cr_logger/src/widget/expand_arrow_button.dart';
import 'package:cr_logger/src/widget/json_widget/json_widget.dart';
import 'package:cr_logger/src/widget/rounded_card.dart';
import 'package:flutter/material.dart';

class ParamsExpansionTile extends StatefulWidget {
  const ParamsExpansionTile({
    required this.request,
    super.key,
  });

  final HttpRequestBean? request;

  @override
  State<ParamsExpansionTile> createState() => _ParamsExpansionTileState();
}

class _ParamsExpansionTileState extends State<ParamsExpansionTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final paramsLength = widget.request?.params?.length ?? 0;
    final paramsIsNotEmpty = paramsLength != 0;
    const _jsonWidgetParamsValueKey = ValueKey('RequestPageParams');

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
                  'Params',
                  style: CRStyle.subtitle1BlackSemiBold16,
                ),
              ),
              Text(
                '$paramsLength',
                style: CRStyle.subtitle1BlackSemiBold16.copyWith(
                  color: CRLoggerColors.grey,
                ),
              ),
              const SizedBox(width: 6),
              ExpandArrowButton(
                isExpanded: _isExpanded && paramsIsNotEmpty,
                onTap: paramsIsNotEmpty ? _expand : null,
              ),
            ],
          ),
          if (paramsIsNotEmpty)
            JsonWidget(
              // widget.request?.params,
              const {},
              key: _jsonWidgetParamsValueKey,
              allExpandedNodes: _isExpanded,
            ),
        ],
      ),
    );
  }

  void _expand() => setState(() => _isExpanded = !_isExpanded);
}
