import 'package:cr_logger/src/res/colors.dart';
import 'package:flutter/material.dart';

class ClearLogsContentWidget extends StatefulWidget {
  const ClearLogsContentWidget({
    required this.clearLogsFromDB,
    super.key,
  });

  final ValueChanged<bool> clearLogsFromDB;

  @override
  State<ClearLogsContentWidget> createState() => _ClearLogsContentWidgetState();
}

class _ClearLogsContentWidgetState extends State<ClearLogsContentWidget> {
  bool _clearLogsFromDB = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Do you want to clear all logs?'),
        const SizedBox(height: 4),
        CheckboxListTile(
          contentPadding: const EdgeInsets.only(left: 2),
          activeColor: CRLoggerColors.blue,
          value: _clearLogsFromDB,
          onChanged: _onChanged,
          title: const Text(
            'Clear the database',
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  void _onChanged(bool? value) {
    if (value != null) {
      setState(() {
        _clearLogsFromDB = value;
      });
      widget.clearLogsFromDB(_clearLogsFromDB);
    }
  }
}
