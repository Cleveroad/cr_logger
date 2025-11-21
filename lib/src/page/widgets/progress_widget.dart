import 'package:cr_logger/src/res/colors.dart';
import 'package:flutter/material.dart';

class ProgressWidget extends StatelessWidget {
  const ProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: CRLoggerColors.backgroundGrey.withValues(alpha: 0.8),
      child: const CircularProgressIndicator(strokeWidth: 2),
    );
  }
}
