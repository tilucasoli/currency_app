class CurrencyRates {
  final String base;
  final String date;
  final Map<String, num> rates;

  CurrencyRates({
    required this.base,
    required this.date,
    required this.rates,
  });

  factory CurrencyRates.fromJson(Map<String, dynamic> json) {
    return CurrencyRates(
      base: json['base'],
      date: json['date'],
      rates: Map<String, num>.from(json['rates']),
    );
  }
}
