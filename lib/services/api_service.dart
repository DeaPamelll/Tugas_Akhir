import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String _base = 'https://dummyjson.com';
  static const Duration _timeout = Duration(seconds: 12);

  Future<List<String>> fetchCategories() async {
    final res = await _get(Uri.parse('$_base/products/categories'));
    final data = jsonDecode(res.body);

    if (data is List) {
      return data.map<String>((e) {
        if (e is Map) return (e['slug'] ?? e['name'] ?? '').toString();
        return e.toString();
      }).where((s) => s.isNotEmpty).toList();
    }
    return <String>[];
  }

  Future<List<Product>> fetchProducts({int limit = 100, int skip = 0}) async {
    final uri = Uri.parse('$_base/products').replace(queryParameters: {
      'limit': '$limit',
      if (skip > 0) 'skip': '$skip',
    });

    final res = await _get(uri);
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final list = (json['products'] as List?) ?? const [];
    return list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Product>> fetchByCategory(String catSlug) async {
    final slug = Uri.encodeComponent(catSlug.toLowerCase());
    final uri = Uri.parse('$_base/products/category/$slug');

    final res = await _get(uri);
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final list = (json['products'] as List?) ?? const [];
    return list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Product>> searchProducts(String q) async {
    final uri = Uri.parse('$_base/products/search')
        .replace(queryParameters: {'q': q}); 

    final res = await _get(uri);
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final list = (json['products'] as List?) ?? const [];
    return list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  }


  Future<http.Response> _get(Uri uri) async {
    try {
      final res = await http.get(uri).timeout(_timeout);
      if (res.statusCode >= 200 && res.statusCode < 300) return res;

      throw Exception(
        'HTTP ${res.statusCode} ${res.reasonPhrase ?? ''} — ${uri.path}',
      );
    } on Exception catch (e) {
      throw Exception('Request gagal (${uri.path}): $e');
    }
  }
}
