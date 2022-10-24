import 'package:cr_logger/src/styles.dart';
import 'package:flutter/material.dart';

class AppInfoItem extends StatelessWidget {
  const AppInfoItem({
    required this.name,
    required this.value,
    super.key,
  });

  final String name;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: CRStyle.bodyBlackSemiBold14),
          Padding(
            padding: const EdgeInsets.only(left: 14, top: 6),
            child: Text(value, style: CRStyle.bodyBlackRegular14),
          ),
        ],
      ),
    );
  }
}
