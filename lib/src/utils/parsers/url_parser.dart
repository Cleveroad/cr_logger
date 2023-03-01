import 'package:cr_logger/cr_logger.dart';

String getUrlWithHiddenParams(String url, {bool showFullPath = false}) {
  final uri = Uri.tryParse(url);

  /// Get path without scheme.
  /// E.g. httpbin/anything instead of https://httpbin/anything
  final absolutePath = '${uri?.host}${uri?.path}';

  /// Get all parameters
  final parameters = uri?.queryParameters;

  /// Separate the base url and parameters to avoid replacing parts of the base url
  final resultUrl = url.split('?');

  if (!showFullPath) {
    resultUrl.first = absolutePath;
  }

  /// If there is no parameters then nothing to hide and just return url
  if (resultUrl.length < 2) {
    return resultUrl.join();
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

  return resultUrl.join('?');
}
