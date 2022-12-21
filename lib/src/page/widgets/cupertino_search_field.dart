import 'package:cr_logger/src/res/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoSearchField extends StatefulWidget {
  const CupertinoSearchField({
    required this.searchController,
    required this.onSearch,
    required this.onClear,
    required this.placeholderText,
    super.key,
  });

  final TextEditingController searchController;
  final VoidCallback onSearch;
  final VoidCallback onClear;
  final String placeholderText;

  @override
  State<CupertinoSearchField> createState() => _CupertinoSearchFieldState();
}

class _CupertinoSearchFieldState extends State<CupertinoSearchField> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          /// Cupertino search field
          Expanded(
            child: CupertinoTextField(
              focusNode: _focusNode,
              controller: widget.searchController,
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              onChanged: (_) => widget.onSearch(),
              suffixMode: OverlayVisibilityMode.editing,
              suffix: IconButton(
                padding: EdgeInsets.zero,
                onPressed: widget.onClear,
                icon: const Icon(Icons.clear),
              ),
              placeholder: widget.placeholderText,
              cursorWidth: 1,
              cursorColor: CRLoggerColors.primaryColor,
              decoration: BoxDecoration(
                color: CRLoggerColors.white,
                borderRadius: BorderRadius.circular(21),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
