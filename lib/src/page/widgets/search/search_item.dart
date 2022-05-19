import 'package:cr_logger/src/bean/log_bean.dart';
import 'package:flutter/material.dart';

class SearchItem extends StatelessWidget {
  const SearchItem({
    required this.logBean,
    super.key,
    this.onTap,
    this.onLongTap,
  });

  final LogBean logBean;
  final Function(LogBean)? onTap;
  final Function(LogBean)? onLongTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        logBean.message.toString(),
        style: TextStyle(color: logBean.color),
      ),
      subtitle: Text('${logBean.time}'),
      onTap: () => onTap?.call(logBean),
      onLongPress: () => onLongTap?.call(logBean),
    );
  }
}
