import 'package:cr_logger/src/constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('patternOfParamsRegex tests', () {
    test('replace for string without parameters', () {
      const text = 'This is a test string.';

      expect(text.replaceAll(patternOfParamsRegex, ''), equals(text));
    });

    test('replace for string with one parameter', () {
      const text = 'Hello, {{name}}!';

      expect(
        text.replaceAll(patternOfParamsRegex, ''),
        equals('Hello, name!'),
      );
    });

    test('replace for string with several parameter', () {
      const text = 'The {{animal}} jumped over the {{object}}.';

      expect(
        text.replaceAll(patternOfParamsRegex, ''),
        equals('The animal jumped over the object.'),
      );
    });

    test(
      'replace for string with one parameter, when parameter is a start of sentence',
      () {
        const text = '{{curly-braces}} are not allowed as parameter names.';

        expect(
          text.replaceAll(patternOfParamsRegex, ''),
          equals('curly-braces are not allowed as parameter names.'),
        );
      },
    );

    test('replace for string with nested parameters', () {
      const text = 'This {{has {{nested}}}} parameters.';

      expect(
        text.replaceAll(patternOfParamsRegex, ''),
        equals('This has nested parameters.'),
      );
    });

    test('replace for string, where parameters are adjacent to each other', () {
      const text = '{{param1}}{{param2}}';

      expect(text.replaceAll(patternOfParamsRegex, ''), equals('param1param2'));
    });

    test('replace for string when parameter in curly braces ', () {
      const text = 'This is a {{{parameter}}} in curly braces';
      expect(
        text.replaceAll(patternOfParamsRegex, ''),
        equals('This is a {parameter} in curly braces'),
      );
    });
  });
}
