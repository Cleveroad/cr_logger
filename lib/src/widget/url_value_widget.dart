import 'dart:math' as math;

import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/colors.dart';
import 'package:cr_logger/src/extensions/extensions.dart';
import 'package:cr_logger/src/styles.dart';
import 'package:cr_logger/src/widget/copy_widget.dart';
import 'package:flutter/material.dart';

class UrlValueWidget extends StatefulWidget {
  const UrlValueWidget({
    required this.url,
    this.title,
    this.child,
    this.requestTime,
    this.responseTime,
    super.key,
  });

  final String? url;
  final String? title;
  final Widget? child;
  final DateTime? requestTime;
  final DateTime? responseTime;

  @override
  _UrlValueWidgetState createState() => _UrlValueWidgetState();
}

class _UrlValueWidgetState extends State<UrlValueWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final child = widget.child;

    return Material(
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
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
                  Text(
                    widget.title ?? 'Link',
                    style: CRStyle.subtitle1BlackSemiBold16,
                  ),
                  CopyWidget(
                    onCopy: () => copyClipboard(context, widget.url ?? ''),
                  ),
                ],
              ),
              if (child != null) child,
              Text(
                widget.url.toString(),
                maxLines: _expanded ? null : 4,
                overflow: TextOverflow.fade,
                style: CRStyle.bodyBlackRegular14,
              ),
              const SizedBox(height: 6),
              IgnorePointer(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF77788A).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Transform.rotate(
                    angle: _expanded ? math.pi : 0,
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (widget.requestTime != null)
                Text(
                  'requestTime: ${widget.requestTime!.formatTime()}',
                  style: CRStyle.bodyGreyRegular14,
                ),
              if (widget.responseTime != null) ...[
                const SizedBox(height: 6),
                Text(
                  'responseTime: ${widget.responseTime!.formatTime()}',
                  style: CRStyle.bodyGreyRegular14,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
