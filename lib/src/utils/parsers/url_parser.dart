import 'package:cr_logger/cr_logger.dart';

String getUrlWithHiddenParams(String url, {bool showFullPath = false}) {
  final absolutePath = url.split('://');

  /// Get all parameters
  final parameters = Uri.tryParse(url)?.queryParameters;

  /// Separate the base url and parameters to avoid replacing parts of the base url
  final resultUrl = url.split('?');

  final path = showFullPath ? resultUrl.first : absolutePath[1];

  /// If there is no paramters then nothing to hide and just return url
  if (resultUrl.length < 2) {
    return path;
  }

  /// Replace
  CRLoggerInitializer.instance.hiddenFields.forEach((element) {
    final value = parameters?[element];
    if (value != null) {
      /// = needed to avoid replacing keys if parameter have the same name as key
      ///
      /// E.g. https://....?test=test
      resultUrl[1] = resultUrl[1].replaceAll('=$value', '=...');
    }
  });

  return '$path?${resultUrl[1]}';
}
