import 'package:currency_app/data/model/currency_rates.dart';
import 'package:currency_app/data/repositories/currency_rates_repository.dart';
import 'package:currency_app/ui/currency_list/view_model/currency_list_state.dart';
import 'package:currency_app/ui/currency_list/view_model/currency_list_viewmodel.dart';
import 'package:currency_app/utils.dart/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCurrencyRatesRepository extends Mock
    implements CurrencyRatesRepository {}

void main() {
  group('CurrencyListViewModel', () {
    late MockCurrencyRatesRepository repository;
    late CurrencyListViewModel sut;

    setUp(() {
      repository = MockCurrencyRatesRepository();
      sut = CurrencyListViewModel(repository);
    });

    tearDown(() {
      reset(repository);
    });

    test('initial state should be loading', () {
      expect(sut.currencies.value, isA<CurrencyListLoading>());
    });

    test('load should update state to loaded when repository returns success',
        () async {
      final currencyRates = CurrencyRates(
        base: 'EUR',
        date: '2025-01-20',
        rates: {'AUD': 1.6627, 'BGN': 1, 'BRL': 6.2688},
      );

      when(() => repository.load()).thenAnswer(
        (_) async => Success(currencyRates),
      );

      await sut.load();

      expect(sut.currencies.value, isA<CurrencyListLoaded>());
      expect((sut.currencies.value as CurrencyListLoaded).currencyRates,
          currencyRates);
    });

    test('load should update state to error when repository returns error',
        () async {
      final error = Exception('Test error');
      final stackTrace = StackTrace.current;

      when(() => repository.load()).thenAnswer(
        (_) async => Error(error, stackTrace),
      );

      await sut.load();

      expect(sut.currencies.value, isA<CurrencyListError>());
      expect((sut.currencies.value as CurrencyListError).error, error);
      expect(
          (sut.currencies.value as CurrencyListError).stackTrace, stackTrace);
    });
  });
}
