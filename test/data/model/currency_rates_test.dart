import 'package:currency_app/data/model/currency_rates.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CurrencyRates', () {
    test('fromJson() should correctly parse JSON data', () {
      final json = {
        'base': 'USD',
        'date': '2023-12-01',
        'rates': {
          'EUR': 0.92,
          'GBP': 0.79,
          'JPY': 147.73,
        },
      };

      final currencyRates = CurrencyRates.fromJson(json);

      expect(currencyRates.base, equals('USD'));
      expect(currencyRates.date, equals('2023-12-01'));
      expect(
          currencyRates.rates,
          equals({
            'EUR': 0.92,
            'GBP': 0.79,
            'JPY': 147.73,
          }));
    });

    test('fromJson() should throw an Error if the JSON is invalid', () {
      final json = {
        'base': 'USD',
        'date': '2023-12-01',
      };

      expect(() => CurrencyRates.fromJson(json), throwsA(isA<Error>()));
    });
  });
}
