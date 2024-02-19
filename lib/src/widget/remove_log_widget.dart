import 'package:flutter/material.dart';

class RemoveLogWidget extends StatelessWidget {
  const RemoveLogWidget({
    this.onRemove,
    super.key,
  });

  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 28,
      child: IconButton(
        onPressed: onRemove,
        icon: const Icon(
          Icons.delete_outline,
          color: Colors.black45,
        ),
        iconSize: 24,
        splashRadius: 20,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
