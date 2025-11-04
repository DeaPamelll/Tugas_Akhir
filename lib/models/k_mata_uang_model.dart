import 'dart:convert';

class KMataUang {
  final String base;
  final Map<String, double> rates;

  KMataUang({required this.base, required this.rates});

  factory KMataUang.fromMap(Map<String, dynamic> map) {
    // v4: { base: "USD", rates: {...} }
    // v6: { base_code: "USD", conversion_rates: {...} }
    final base = (map['base'] ?? map['base_code'] ?? 'USD').toString();
    final rawRates = (map['rates'] ?? map['conversion_rates']) as Map<String, dynamic>;
    final parsed = rawRates.map((k, v) => MapEntry(k.toString(), (v as num).toDouble()));
    return KMataUang(base: base, rates: parsed);
  }

  factory KMataUang.fromJson(String source) =>
      KMataUang.fromMap(jsonDecode(source) as Map<String, dynamic>);

  double factorFromUsdTo(String code) {
    if (rates.isEmpty) return 1.0;
    if (base.toUpperCase() == 'USD') {
      return rates[code] ?? 1.0;
    }
    final usd = rates['USD'];
    final to = rates[code];
    if (usd == null || to == null || usd == 0) return 1.0;
    return to / usd;
  }
}
