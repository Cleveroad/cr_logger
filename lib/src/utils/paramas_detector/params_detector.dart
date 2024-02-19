import 'package:cr_logger/src/constants.dart';
import 'package:cr_logger/src/utils/paramas_detector/parameter_model.dart';

final class ParameterDetector {
  static final _parameterRegex = RegExp(r'\{\{[^{}]+\}\}');

  List<ParameterModel> getParams(String text) {
    final params = <ParameterModel>[];

    if (_parameterRegex.hasMatch(text)) {
      final matches = _parameterRegex.allMatches(text);
      if (matches.isNotEmpty) {
        for (final match in matches) {
          final param = match.group(0);
          if (param != null) {
            params.add(
              ParameterModel(
                name: param.replaceAll(patternOfParamsRegex, ''),
                locationStart: match.start,
                locationEnd: match.end,
              ),
            );
          }
        }
      }
    }

    return params;
  }
}
