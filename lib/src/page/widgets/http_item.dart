import 'package:cr_logger/src/bean/http_bean.dart';
import 'package:cr_logger/src/colors.dart';
import 'package:cr_logger/src/constants.dart';
import 'package:cr_logger/src/extensions/extensions.dart';
import 'package:cr_logger/src/styles.dart';
import 'package:cr_logger/src/widget/copy_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HttpItem extends StatelessWidget {
  const HttpItem({
    required this.httpBean,
    required this.onSelected,
    this.useWebLayout = false,
    super.key,
  });

  final HttpBean httpBean;
  final bool useWebLayout;
  final Function(HttpBean httpBean) onSelected;

  @override
  Widget build(BuildContext context) {
    final color =
        (httpBean.error != null || httpBean.response?.statusCode == null)
            ? CRLoggerColors.red
            : CRLoggerColors.green;
    final methodColor = httpBean.request?.method == kMethodPost
        ? CRLoggerColors.orange
        : CRLoggerColors.green;
    final statusCode =
        httpBean.response?.statusCode ?? httpBean.error?.statusCode;

    return Material(
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () => onSelected(httpBean),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        child: Text(
                          httpBean.request?.method ?? '',
                          style: CRStyle.bodyBlackSemiBold14
                              .copyWith(color: methodColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: color.withOpacity(0.06),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 16,
                        ),
                        child: statusCode != null
                            ? FittedBox(
                                child: Text(
                                  statusCode.toString(),
                                  style: CRStyle.bodyBlackSemiBold14
                                      .copyWith(color: color),
                                  maxLines: 1,
                                ),
                              )
                            : Icon(
                                Icons.wifi_off,
                                color: color,
                                size: 14,
                              ),
                      ),
                    ],
                  ),
                  CopyWidget(onCopy: () => _onCopy(context)),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                httpBean.request?.url ?? '',
                style: CRStyle.h3Black,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Text(
                '${httpBean.request?.requestTime?.formatTime()}  duration: ${httpBean.response?.duration ?? httpBean.error?.duration ?? 0}ms',
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
          'Copy \n"${httpBean.request?.url}"',
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
    Clipboard.setData(ClipboardData(text: httpBean.request?.url));
  }
}
