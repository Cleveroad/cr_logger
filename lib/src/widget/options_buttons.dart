import 'package:cr_logger/src/extensions/do_post_frame.dart';
import 'package:cr_logger/src/res/colors.dart';
import 'package:cr_logger/src/res/styles.dart';
import 'package:flutter/material.dart';

class OptionsButtons extends StatefulWidget with PreferredSizeWidget {
  const OptionsButtons({
    required this.titles,
    required this.onSelected,
    this.selectedIndex,
    this.margin = EdgeInsets.zero,
    this.backgroundColor = CRLoggerColors.white,
    this.activeColor = CRLoggerColors.blue,
    this.isWeb = false,
    this.disableColor,
    super.key,
  });

  final List<String> titles;
  final Function(int index) onSelected;
  final EdgeInsets margin;
  final Color backgroundColor;
  final Color activeColor;
  final bool isWeb;
  final Color? disableColor;
  final int? selectedIndex;

  @override
  Size get preferredSize => const Size.fromHeight(0);

  @override
  OptionsButtonsState createState() => OptionsButtonsState();
}

class OptionsButtonsState extends State<OptionsButtons> {
  final _selected = <int, bool>{};

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.titles.length; i++) {
      _selected[i] = i == (widget.selectedIndex ?? 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(21),
      ),
      margin: widget.margin,
      child: Row(
        children: List.generate(
          _selected.length,
          (index) => widget.isWeb
              ? InkWell(
                  onTap: () => _onTap(index),
                  borderRadius: BorderRadius.circular(21),
                  child: Container(
                    width: 130,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    height: 40,
                    decoration: BoxDecoration(
                      color: _isSelected(index)
                          ? widget.activeColor
                          : widget.disableColor ?? widget.backgroundColor,
                      borderRadius: BorderRadius.circular(21),
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.titles[index],
                          style: _isSelected(index)
                              ? CRStyle.subtitle1WhiteSemiBold16
                              : CRStyle.subtitle1BlackMedium16,
                        ),
                      ),
                    ),
                  ),
                )
              : Flexible(
                  child: InkWell(
                    onTap: () => _onTap(index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      height: 38,
                      decoration: BoxDecoration(
                        color: _isSelected(index)
                            ? widget.activeColor
                            : widget.disableColor ?? widget.backgroundColor,
                        borderRadius: BorderRadius.circular(21),
                      ),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            widget.titles[index],
                            style: _isSelected(index)
                                ? CRStyle.subtitle1WhiteSemiBold16
                                : CRStyle.subtitle1BlackMedium16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  void change(int index) {
    setState(() {
      _selected.updateAll((key, value) => value = key == index);
    });
  }

  void _onTap(int index) {
    change(index);
    doPostFrame(
      () => widget.onSelected(index),
    );
  }

  bool _isSelected(int index) {
    return _selected[index] ?? false;
  }
}
