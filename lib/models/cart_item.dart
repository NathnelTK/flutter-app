import 'package:flutter_app/models/product.dart';

class CartItem {
  final String? id;
  final Product product;
  final int quantity;

  CartItem({this.id, required this.product, required this.quantity});

  CartItem copyWith({String? id, Product? product, int? quantity}) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalPrice => product.price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );
  }
}
