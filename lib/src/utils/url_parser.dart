import 'package:cr_logger/cr_logger.dart';

String getUrlWithHiddenParams(String url) {
  ///Get all parameters
  final parameters = Uri.tryParse(url.toString())?.queryParameters;

  ///Separate the base url and parameters to avoid replacing parts of the base url
  final resultUrl = url.toString().split('?');

  ///If there is no paramters then nothing to hide and just return url
  if (resultUrl.length < 2) {
    return url;
  }

  ///Replace
  CRLoggerInitializer.instance.hiddenFields.forEach((element) {
    final value = parameters?[element];
    if (value != null) {
      ///= needed to avoid replacing keys if parameter have the same name as key
      ///
      /// E.g. https://....?test=test
      resultUrl[1] = resultUrl[1].replaceAll('=$value', '=...');
    }
  });

  return '${resultUrl.first}?${resultUrl[1]}';
}
