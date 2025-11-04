import 'dart:convert';
import 'package:http/http.dart' as http;

class KMataUangService {
  static const String _apiKey = '567adbcd7316c87fe2770bcd';
  static const String _urlV6 = 'https://v6.exchangerate-api.com/v6/$_apiKey/latest/USD';

  final bool useApiKey;
  KMataUangService({this.useApiKey = true}); 

  Future<Map<String, double>> fetchRates() async {
    final url = useApiKey ? _urlV6 : _urlV6; 
    final r = await http.get(Uri.parse(url));
    if (r.statusCode != 200) {
      throw Exception('Gagal ambil kurs: ${r.statusCode}');
    }
    final data = jsonDecode(r.body) as Map<String, dynamic>;
    final Map<String, dynamic> raw =
        (data['rates'] ?? data['conversion_rates']) as Map<String, dynamic>;
    return raw.map((k, v) => MapEntry(k, (v as num).toDouble()));
  }
}
