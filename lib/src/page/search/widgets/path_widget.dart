import 'package:cr_logger/src/res/colors.dart';
import 'package:cr_logger/src/res/styles.dart';
import 'package:flutter/material.dart';

class PathWidget extends StatelessWidget {
  const PathWidget({
    required this.onSearchUrl,
    required this.path,
    super.key,
  });

  final VoidCallback onSearchUrl;
  final String path;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSearchUrl,
      child: Container(
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: CRLoggerColors.progressBackground,
          ),
          color: CRLoggerColors.white,
        ),
        child: Text(
          path,
          style: CRStyle.bodyBlackSemiDefault13,
        ),
      ),
    );
  }
}
