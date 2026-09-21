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

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'price': price,
      'category': category,
      'description': description,
      'icon': _iconNames[icon] ?? 'smartphone',
      'backgroundColor':
          '#${backgroundColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      category: json['category'] ?? 'smartphones',
      description: json['description'] ?? '',
      icon: _icons[json['icon']] ?? Icons.smartphone,
      backgroundColor: _colorFromHex(json['backgroundColor']),
    );
  }

  static const _icons = <String, IconData>{
    'smartphone': Icons.smartphone,
    'laptop': Icons.laptop,
    'headphones': Icons.headphones,
    'camera_alt': Icons.camera_alt,
    'backpack': Icons.backpack,
    'checkroom': Icons.checkroom,
  };

  static final _iconNames = <IconData, String>{
    for (final entry in _icons.entries) entry.value: entry.key,
  };

  static Color _colorFromHex(dynamic value) {
    final hex = value is String ? value.replaceFirst('#', '') : 'D4D9F7';
    final normalized = hex.length == 6 ? 'FF$hex' : hex;
    return Color(int.tryParse(normalized, radix: 16) ?? 0xFFD4D9F7);
  }
}
