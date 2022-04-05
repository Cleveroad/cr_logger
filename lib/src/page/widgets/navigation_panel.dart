import 'package:cr_logger/src/bean/log_type.dart';
import 'package:cr_logger/src/page/widgets/nav_item.dart';
import 'package:flutter/material.dart';

class NavigationPanel extends StatefulWidget {
  const NavigationPanel({
    required this.onLogsTypeChanged,
    Key? key,
  }) : super(key: key);

  final Function(LogType logType) onLogsTypeChanged;

  @override
  State<NavigationPanel> createState() => NavigationPanelState();
}

class NavigationPanelState extends State<NavigationPanel> {
  LogType _selectedLog = LogType.http;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            NavItem(
              title: 'HTTP',
              enabled: _selectedLog == LogType.http,
              onTap: () => _onLogTypeChanged(LogType.http),
            ),
            const SizedBox(width: 28),
            NavItem(
              title: 'Debug',
              enabled: _selectedLog == LogType.debug,
              onTap: () => _onLogTypeChanged(LogType.debug),
            ),
            const SizedBox(width: 28),
            NavItem(
              title: 'Info',
              enabled: _selectedLog == LogType.info,
              onTap: () => _onLogTypeChanged(LogType.info),
            ),
            const SizedBox(width: 28),
            NavItem(
              title: 'Error',
              enabled: _selectedLog == LogType.error,
              onTap: () => _onLogTypeChanged(LogType.error),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }

  void changeLogType(LogType logType) {
    setState(() {
      _selectedLog = logType;
    });
  }

  void _onLogTypeChanged(LogType logType) {
    setState(() {
      _selectedLog = logType;
      widget.onLogsTypeChanged(logType);
    });
  }
}
