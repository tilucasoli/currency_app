import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../utils.dart/http_client.dart';
import '../model/currency_rates.dart';
part 'currency_api_service.g.dart';

abstract interface class CurrencyApiService {
  Future<CurrencyRates> load();
}

class CurrencyApiServiceImpl implements CurrencyApiService {
  final HttpClient client;

  const CurrencyApiServiceImpl(this.client);

  final String _baseUrl = 'https://api.frankfurter.dev/v1/latest';

  @override
  Future<CurrencyRates> load() async {
    final currencyRates = await client.get(
      Uri.parse(_baseUrl),
      parser: CurrencyRates.fromJson,
    );

    return currencyRates;
  }
}

@riverpod
CurrencyApiService currencyApiService(Ref ref) {
  return CurrencyApiServiceImpl(
    ref.read(httpClientProvider),
  );
}
