import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../utils.dart/result.dart';
import '../model/currency_rates.dart';
import '../services/currency_api_service.dart';

part 'currency_rates_repository.g.dart';

abstract interface class CurrencyRatesRepository{
  Future<Result<CurrencyRates>> load();
}

class RemoteCurrencyRatesRepository implements CurrencyRatesRepository{
  final CurrencyApiService apiService;

  const RemoteCurrencyRatesRepository(this.apiService);

  @override
  Future<Result<CurrencyRates>> load() async {
    try {
      final currencyRates = await apiService.load();

      return Success(currencyRates);
    } catch (error, stackTrace) {
      return Error(error, stackTrace);
    }
  }
}

@riverpod
CurrencyRatesRepository currencyRatesRepository(Ref ref) {
  return RemoteCurrencyRatesRepository(
    ref.read(currencyApiServiceProvider),
  );
}
