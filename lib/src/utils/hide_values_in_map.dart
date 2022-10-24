import 'package:cr_logger/cr_logger.dart';
import 'package:cr_logger/src/constants.dart';

Map hideValuesInMap(Map body) {
  return body.map((key, value) {
    if (CRLoggerInitializer.instance.hiddenFields.contains(key)) {
      return MapEntry(key, kHidden);
    } else {
      if (value is Map) {
        return MapEntry(key, hideValuesInMap(value));
      }
      if (value is List) {
        final list = value.map((e) {
          return e is Map ? hideValuesInMap(e) : e;
        }).toList();

        return MapEntry(key, list);
      }

      return MapEntry(key, value);
    }
  });
}
