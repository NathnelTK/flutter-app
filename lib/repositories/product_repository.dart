import 'dart:convert';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/repositories/api_client.dart';

class ProductRepository {
  final ApiClient _apiClient;

  ProductRepository({ApiClient? apiClient}) 
      : _apiClient = apiClient ?? ApiClient();

  Future<List<Product>> getProducts() async {
    final response = await _apiClient.get('/products');
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Product.fromJson(json)).toList();
  }

  Future<Product> getProduct(String id) async {
    final response = await _apiClient.get('/products/$id');
    final Map<String, dynamic> data = json.decode(response.body);
    return Product.fromJson(data);
  }

  Future<Product> createProduct(Product product) async {
    final response = await _apiClient.post('/products', product.toJson());
    final Map<String, dynamic> data = json.decode(response.body);
    return Product.fromJson(data);
  }

  Future<Product> updateProduct(String id, Product product) async {
    final response = await _apiClient.put('/products/$id', product.toJson());
    final Map<String, dynamic> data = json.decode(response.body);
    return Product.fromJson(data);
  }

  Future<void> deleteProduct(String id) async {
    await _apiClient.delete('/products/$id');
  }
}
