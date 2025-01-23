import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/currency_rates_repository.dart';

import '../../../utils.dart/result.dart';
import 'currency_list_state.dart';

part 'currency_list_viewmodel.g.dart';

class CurrencyListViewModel {
  final CurrencyRatesRepository _repository;

  CurrencyListViewModel(this._repository);

  final currencies = ValueNotifier<CurrencyListState>(
    const CurrencyListLoading(),
  );

  Future<void> load() async {
    final result = await _repository.load();

    switch (result) {
      case Success():
        currencies.value = CurrencyListLoaded(result.value);

        return;
      case Error():
        currencies.value = CurrencyListError(
          result.error,
          result.stackTrace,
        );

        return;
    }
  }
}

@riverpod
CurrencyListViewModel currencyListViewModel(Ref ref) {
  return CurrencyListViewModel(
    ref.read(currencyRatesRepositoryProvider),
  );
}
