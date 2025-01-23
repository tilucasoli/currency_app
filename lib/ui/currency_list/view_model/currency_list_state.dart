import '../../../data/model/currency_rates.dart';

sealed class CurrencyListState {
  const CurrencyListState();
}

class CurrencyListLoading extends CurrencyListState {
  const CurrencyListLoading();
}

class CurrencyListLoaded extends CurrencyListState {
  const CurrencyListLoaded(this.currencyRates);

  final CurrencyRates currencyRates;
}

class CurrencyListError extends CurrencyListState {
  const CurrencyListError(this.error, this.stackTrace);

  final Object error;
  final StackTrace? stackTrace;
}
