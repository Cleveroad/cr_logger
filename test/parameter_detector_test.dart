import 'package:cr_logger/src/utils/paramas_detector/params_detector.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ParameterDetector tests', () {
    final detector = ParameterDetector();

    test(
      'getParams should return an empty list when given a string without any parameters',
      () {
        const text = 'This is a test string.';
        final result = detector.getParams(text);

        expect(result, isEmpty);
      },
    );

    test(
      'getParams should return a list with one ParameterModel when given a string with one parameter',
      () {
        const text = 'Hello, {{name}}!';
        final result = detector.getParams(text);

        expect(result.length, equals(1));
        expect(result.first.name, equals('name'));
        expect(result.first.locationStart, equals(7));
        expect(result.first.locationEnd, equals(15));
      },
    );

    test(
      'getParams should return a list with multiple ParameterModels when given a string with multiple parameters',
      () {
        const text = 'The {{animal}} jumped over the {{object}}.';
        final result = detector.getParams(text);
        expect(result.length, equals(2));
        expect(result.first.name, equals('animal'));
        expect(result.first.locationStart, equals(4));
        expect(result.first.locationEnd, equals(14));
        expect(result.last.name, equals('object'));
        expect(result.last.locationStart, equals(31));
        expect(result.last.locationEnd, equals(41));
      },
    );

    test(
      'getParams should not include curly braces in the ParameterModel names',
      () {
        const text = '{{curly-braces}} are not allowed as parameter names.';
        final result = detector.getParams(text);
        expect(result.length, equals(1));
        expect(result.first.name, equals('curly-braces'));
        expect(result.first.locationStart, equals(0));
        expect(result.first.locationEnd, equals(16));
      },
    );

    test('getParams should handle overlapping parameters correctly', () {
      const text = 'This {{has {{nested}}}} parameters.';
      final result = detector.getParams(text);

      expect(result.length, equals(1));
      expect(result.first.name, equals('nested'));
      expect(result.first.locationStart, equals(11));
      expect(result.first.locationEnd, equals(21));
    });

    test('getParams should handle adjacent parameters correctly', () {
      const text = '{{param1}}{{param2}}';
      final result = detector.getParams(text);

      expect(result.length, equals(2));
      expect(result.first.name, equals('param1'));
      expect(result.first.locationStart, equals(0));
      expect(result.first.locationEnd, equals(10));
      expect(result.last.name, equals('param2'));
      expect(result.last.locationStart, equals(10));
      expect(result.last.locationEnd, equals(20));
    });

    test('getParams should handle when parameter in curly braces ', () {
      const text = 'This is a {{{parameter}}} in curly braces';
      final result = detector.getParams(text);

      expect(result.length, equals(1));
      expect(result.first.name, equals('parameter'));
      expect(result.first.locationStart, equals(11));
      expect(result.first.locationEnd, equals(24));
    });
  });
}
