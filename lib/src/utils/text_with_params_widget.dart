import 'package:cr_logger/src/constants.dart';
import 'package:cr_logger/src/res/styles.dart';
import 'package:cr_logger/src/utils/paramas_detector/parameter_model.dart';
import 'package:cr_logger/src/utils/paramas_detector/params_detector.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// The widget allows you to copy the parameter.
class TextWithParamsWidget extends StatefulWidget {
  /// Highlight mentions in text.
  ///
  /// Displays [text] which contains [params].
  const TextWithParamsWidget(this.text, {
    required this.textColor,
    required this.onParamTap,
    super.key,
  });

  final dynamic text;

  /// Returns the clicked mention model
  final ValueChanged<String> onParamTap;

  /// Style of a plain text
  final Color textColor;

  @override
  State<TextWithParamsWidget> createState() => _TextWithParamsWidgetState();
}

class _TextWithParamsWidgetState extends State<TextWithParamsWidget> {
  final _parameterDetector = ParameterDetector();
  final List<TapGestureRecognizer> _recognizers = [];
  final _params = <ParameterModel>[];

  @override
  void initState() {
    super.initState();
    if (widget.text is String) {
      final params = _parameterDetector.getParams(widget.text);
      _params.addAll(params);
    }
  }

  @override
  void dispose() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _params.isNotEmpty
        ? RichText(
      text: TextSpan(
        text: 'Message:\n',
        children: _generateTextSpans(context),
        style: CRStyle.bodyBlackMedium14.copyWith(
          color: widget.textColor.withValues(alpha: 0.8),
        ),
      ),
    )
        : Text(
      'Message:\n${widget.text}',
      style: CRStyle.bodyBlackMedium14.copyWith(
        color: widget.textColor,
      ),
    );
  }

  List<TextSpan> _generateTextSpans(_) {
    final text = widget.text;
    var currentPos = 0;
    final textSpans = <TextSpan>[];
    final textLength = text.length;
    final params = _params;

    if (params.isNotEmpty) {
      for (final param in params) {
        var paramStart = param.locationStart;
        var paramEnd = param.locationEnd;

        /// Protection against QA
        if (paramStart < currentPos) {
          paramStart = currentPos;
        }
        if (paramEnd > textLength) {
          paramEnd = textLength;
        }

        /// Plain text before the parameter
        if (currentPos != paramStart) {
          final regularText = text.substring(currentPos, paramStart);
          textSpans.add(
            TextSpan(text: regularText),
          );
        }

        /// Parameter text
        if (paramStart != paramEnd) {
          final paramText = text.substring(paramStart, paramEnd);
          final recognizer = TapGestureRecognizer()
            ..onTap = () => _onTap(param.name);
          _recognizers.add(recognizer);

          textSpans.add(
            TextSpan(
              text: paramText.replaceAll(patternOfParamsRegex, ''),
              style: CRStyle.bodyBlackMedium14.copyWith(
                color: widget.textColor,
                decoration: TextDecoration.underline,
                decorationThickness: 3,
              ),
              recognizer: recognizer,
            ),
          );
        }

        currentPos = paramEnd;

        /// Protection against QA
        if (currentPos >= textLength) {
          break;
        }
      }
    }

    /// Rest of the text after last parameter
    textSpans.add(
      TextSpan(
        text: text.substring(currentPos, textLength),
      ),
    );

    return textSpans;
  }

  void _onTap(String param) => widget.onParamTap(param);
}
