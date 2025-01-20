import 'package:currency_app/data/model/currency_rates.dart';
import 'package:currency_app/data/repositories/currency_rates_repository.dart';
import 'package:currency_app/data/services/currency_api_service.dart';
import 'package:currency_app/utils.dart/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCurrencyApiService extends Mock implements CurrencyApiService {}

// class FakeCurrencyRates extends Fake implements CurrencyRates {}

void main() {
  test(
      'load should return a CurrencyRates object when the service returns a valid response',
      () async {
    final apiService = MockCurrencyApiService();
    final sut = RemoteCurrencyRatesRepository(apiService);

    final returnedCurrencyRates = CurrencyRates(
      base: 'EUR',
      date: '2025-01-20',
      rates: {'AUD': 1.6627, 'BGN': 1, 'BRL': 6.2688},
    );

    when(() => apiService.load()).thenAnswer(
      (_) async => returnedCurrencyRates,
    );

    final result = await sut.load();

    expect(result, isA<Success<CurrencyRates>>());
    expect((result as Success).value, returnedCurrencyRates);
  });

  test(
      'load should return an Error when the service returns an invalid response',
      () async {
    final apiService = MockCurrencyApiService();
    final sut = RemoteCurrencyRatesRepository(apiService);

    final error = Exception('Error');
    when(() => apiService.load()).thenThrow(error);

    final result = await sut.load();

    expect(result, isA<Error>());
    expect((result as Error).error, error);
  });
}
