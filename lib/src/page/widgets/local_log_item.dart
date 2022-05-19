import 'package:cr_logger/generated/assets.dart';
import 'package:cr_logger/src/bean/log_bean.dart';
import 'package:cr_logger/src/bean/log_type.dart';
import 'package:cr_logger/src/colors.dart';
import 'package:cr_logger/src/extensions/extensions.dart';
import 'package:cr_logger/src/styles.dart';
import 'package:cr_logger/src/widget/copy_widget.dart';
import 'package:cr_logger/src/widget/expanded_arrow_widget.dart';
import 'package:cr_logger/src/widget/json_widget/json_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocalLogItem extends StatelessWidget {
  LocalLogItem({
    required this.logType,
    required this.logBean,
    required this.onSelected,
    this.useWebLayout = false,
    super.key,
  });

  final LogType logType;
  final LogBean logBean;
  final bool useWebLayout;
  final Function(LogBean logBean) onSelected;
  final _allExpandedNodesNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final stackTrace = logBean.stackTrace?.split('\n') ?? [];

    return Material(
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () => onSelected(logBean),
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          padding: const EdgeInsets.fromLTRB(
            16,
            12,
            16,
            16,
          ),
          decoration: BoxDecoration(
            color: CRLoggerColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: (logBean.message is Map<String, dynamic>)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: _allExpandedNodesNotifier,
                      builder: (
                        BuildContext context,
                        bool isAllNodesExpanded,
                        Widget? child,
                      ) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'JSON data',
                                  style: CRStyle.subtitle1BlackSemiBold16,
                                ),
                                Row(
                                  children: [
                                    CopyWidget(onCopy: () => _onCopy(context)),
                                    ExpandedArrowWidget(
                                      allExpandedNotifier:
                                          _allExpandedNodesNotifier,
                                      expanded: isAllNodesExpanded,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            JsonWidget(
                              logBean.message as Map<String, dynamic>,
                              allExpandedNodes: isAllNodesExpanded,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              stackTrace.isNotEmpty ? stackTrace.first : '',
                              style: CRStyle.captionBlackRegular12,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'time: ${logBean.time.formatTime()}',
                              style: CRStyle.bodyGreyRegular14,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            logBean.message.toString(),
                            style: CRStyle.bodyGreyMedium14
                                .copyWith(color: logType.getColor()),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _onCopy(context),
                          icon: ImageExt.fromPackage(
                            Assets.assetsContentCopy,
                            height: 20,
                            width: 20,
                          ),
                          iconSize: 20,
                          splashRadius: 20,
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stackTrace.isNotEmpty ? stackTrace.first : '',
                      style: CRStyle.captionBlackRegular12,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'time: ${logBean.time.formatTime()}',
                      style: CRStyle.bodyGreyRegular14,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _onCopy(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Copy \n"${logBean.message}"',
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
    Clipboard.setData(ClipboardData(text: logBean.message));
  }
}
