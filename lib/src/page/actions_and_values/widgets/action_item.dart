import 'package:cr_logger/src/colors.dart';
import 'package:cr_logger/src/page/actions_and_values/models/action_model.dart';
import 'package:flutter/material.dart';

class ActionItem extends StatelessWidget {
  const ActionItem({
    required this.actionModel,
    super.key,
  });

  final ActionModel actionModel;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: actionModel.action,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        minimumSize: const Size(0, 77),
      ),
      child: Text(
        actionModel.text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: CRLoggerColors.primaryColor),
      ),
    );
  }
}
