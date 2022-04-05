import 'package:cr_logger/src/bean/http_bean.dart';
import 'package:cr_logger/src/bean/request_bean.dart';
import 'package:cr_logger/src/extensions/extensions.dart';
import 'package:cr_logger/src/page/http_log_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HttpLogCard extends StatelessWidget {
  const HttpLogCard(this.data, {Key? key}) : super(key: key);

  final HttpBean data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final resOpt = data.response;
    final reqOpt = data.request;
    final errOpt = data.error;

    final requestTime = reqOpt?.requestTime?.formatTime();

    final textColor =
        (data.error != null || resOpt?.statusCode == null) ? Colors.red : null;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        borderRadius: theme.cardTheme.borderRadius,
        onTap: () => _onTap(context),
        onLongPress: () => _onLongPress(context, reqOpt),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'url:\u00A0${reqOpt?.url}',
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: textColor),
              ),
              const Divider(height: 2),
              Text(
                'method: ${reqOpt?.method}',
                style: TextStyle(color: textColor),
              ),
              const Divider(height: 2),
              Text(
                'status: ${resOpt?.statusCode}',
                style: TextStyle(color: textColor),
              ),
              const Divider(height: 2),
              Text(
                'requestTime: $requestTime'
                ' duration: ${resOpt?.duration ?? errOpt?.duration ?? 0}ms',
                style: TextStyle(color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return HttpLogDetailsPage(data);
      }),
    );
  }

  void _onLongPress(BuildContext context, RequestBean? reqOpt) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Copy \n"${reqOpt?.url}"',
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
    Clipboard.setData(ClipboardData(text: reqOpt?.url ?? ''));
  }
}
