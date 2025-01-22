import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_model/currency_list_state.dart';
import '../view_model/currency_list_viewmodel.dart';

class CurrencyListScreen extends ConsumerStatefulWidget {
  const CurrencyListScreen({super.key});

  @override
  ConsumerState<CurrencyListScreen> createState() => _CurrencyListScreenState();
}

class _CurrencyListScreenState extends ConsumerState<CurrencyListScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(currencyListViewModelProvider).load();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(currencyListViewModelProvider);

    return Scaffold(
      body: Center(
        child: ValueListenableBuilder(
          valueListenable: viewModel.currencies,
          builder: (context, state, child) {
            switch (state) {
              case CurrencyListInitial():
              case CurrencyListLoading():
                return const CircularProgressIndicator();
              case CurrencyListLoaded():
                final rates = state.currencyRates.rates;

                return ListView.builder(
                  itemCount: rates.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        rates.keys.elementAt(index),
                      ),
                      trailing: Text(
                        rates.values.elementAt(index).toString(),
                      ),
                    );
                  },
                );
              case CurrencyListError():
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Error: ${state.error} \n ${state.stackTrace}'),
                    ),
                  );
                });
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
