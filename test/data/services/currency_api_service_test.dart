import 'dart:convert';

import 'package:currency_app/data/model/currency_rates.dart';
import 'package:currency_app/data/services/currency_api_service.dart';
import 'package:currency_app/utils.dart/http_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements HttpClient {}

class MockClient extends Mock implements Client {}

void main() {
  group('CurrencyApiServiceImpl', () {
    setUpAll(() {
      registerFallbackValue(Uri.parse('https://api.frankfurter.dev/v1/latest'));
    });

    test(
        'load should return a CurrencyRates object when the client returns a well-formed JSON',
        () async {
      final client = MockClient();
      final sut = CurrencyApiServiceImpl(HttpClient(client));

      final jsonResponse = {
        "amount": 1.0,
        "base": "EUR",
        "date": "2025-01-20",
        "rates": {
          "AUD": 1.6627,
          "BGN": 1,
          "BRL": 6.2688,
        }
      };

      when(() => client.get(any())).thenAnswer(
        (_) async => Response(
          jsonEncode(jsonResponse),
          200,
        ),
      );

      final result = await sut.load();

      expect(result, isA<CurrencyRates>());
      expect(result.base, 'EUR');
      expect(result.date, '2025-01-20');
      expect(result.rates, isA<Map<String, num>>());
      expect(result.rates['AUD'], 1.6627);
      expect(result.rates['BGN'], 1);
      expect(result.rates['BRL'], 6.2688);
    });

    test('load should throw an exception when the client returns an error',
        () async {
      final client = MockClient();
      final sut = CurrencyApiServiceImpl(HttpClient(client));

      when(() => client.get(any())).thenThrow(Exception('Test error'));

      expect(() => sut.load(), throwsA(isA<Exception>()));
    });
  });
}
