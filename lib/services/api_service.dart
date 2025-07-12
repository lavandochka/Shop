import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/product.dart';

class ApiService {
  static const String _baseUrl = 'https://mobile-shop-api.hiring.dev.devebs.net/';

  static Future<List<Category>> getCategories() async {
    final res = await http.get(
      Uri.parse('https://mobile-shop-api.hiring.dev.devebs.net/categories'),
      headers: {
        'accept': 'application/json',
        'X-CSRFToken': 'vUy4edACb7XvfHuVWesTq65E12AOrru3RyrAfyVIPP8BMUbb5uCAjBvCMUg5XqLt',
      },
    );
    final data = jsonDecode(res.body);
    final List results = data['results'];
    return results.map((json) => Category.fromJson(json)).toList();
  }

  static Future<List<Product>> getBestSoldProducts(int page, int pageSize, {int? categoryId}) async {
    String url = '$_baseUrl/products/best-sold-products?page=$page&page_size=$pageSize';
    if (categoryId != null) {
      url += '&category_id=$categoryId';
    }
    final res = await http.get(Uri.parse(url));
    final data = jsonDecode(res.body);
    final List results = data['results'];
  return results.map((json) => Product.fromJson(json)).toList();
  }
}