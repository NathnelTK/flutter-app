import 'package:flutter/material.dart';

class Product {
  final String id;
  final String title;
  final double price;
  final String category;
  final String description;
  final IconData icon;
  final Color backgroundColor;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.description,
    required this.icon,
    required this.backgroundColor,
  });

  Product copyWith({
    String? id,
    String? title,
    double? price,
    String? category,
    String? description,
    IconData? icon,
    Color? backgroundColor,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      category: category ?? this.category,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}
