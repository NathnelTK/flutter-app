import 'dart:convert';

import 'package:flutter_app/models/cart_item.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/repositories/api_client.dart';

class CartRepository {
  final ApiClient _apiClient;

  CartRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<List<CartItem>> getCartItems() async {
    final response = await _apiClient.get('/cart');
    final List<dynamic> data = json.decode(response.body);

    return data.map((item) {
      return CartItem.fromJson({
        '_id': item['_id']?.toString(),
        'product': item['productId'],
        'quantity': item['quantity'],
      });
    }).toList();
  }

  Future<CartItem> addToCart(Product product, int quantity) async {
    final response = await _apiClient.post('/cart', {
      'productId': product.id,
      'quantity': quantity,
    });

    final Map<String, dynamic> data = json.decode(response.body);
    return CartItem.fromJson({
      '_id': data['_id']?.toString(),
      'product': data['productId'],
      'quantity': data['quantity'],
    });
  }

  Future<void> removeFromCart(String cartItemId) async {
    await _apiClient.delete('/cart/$cartItemId');
  }

  Future<CartItem> updateQuantity(String cartItemId, int quantity) async {
    final response = await _apiClient.put('/cart/$cartItemId', {
      'quantity': quantity,
    });

    final Map<String, dynamic> data = json.decode(response.body);
    return CartItem.fromJson({
      '_id': data['_id']?.toString(),
      'product': data['productId'],
      'quantity': data['quantity'],
    });
  }

  Future<void> clearCart() async {
    await _apiClient.delete('/cart');
  }
}
