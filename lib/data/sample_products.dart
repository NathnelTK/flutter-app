import 'package:flutter/material.dart';
import 'package:flutter_app/models/product.dart';

final List<Product> sampleProducts = [
  Product(
    id: '1',
    title: 'Phone X',
    price: 549.0,
    category: 'smartphones',
    description: '6.1-inch display, 128 GB storage, dual camera.',
    icon: Icons.smartphone,
    backgroundColor: const Color(0xFFD4D9F7),
  ),
  Product(
    id: '2',
    title: 'Headphones',
    price: 89.0,
    category: 'audio',
    description: 'Wireless noise-cancelling headphones with premium sound.',
    icon: Icons.headphones,
    backgroundColor: const Color(0xFFD4F1E8),
  ),
  Product(
    id: '3',
    title: 'T-shirt',
    price: 15.0,
    category: 'clothing',
    description: 'Comfortable cotton t-shirt, available in multiple colors.',
    icon: Icons.checkroom,
    backgroundColor: const Color(0xFFF5E1D4),
  ),
  Product(
    id: '4',
    title: 'Laptop',
    price: 899.0,
    category: 'computers',
    description: 'Powerful laptop with 16GB RAM and 512GB SSD.',
    icon: Icons.laptop,
    backgroundColor: const Color(0xFFE4D9F7),
  ),
  Product(
    id: '5',
    title: 'Camera',
    price: 320.0,
    category: 'electronics',
    description: 'Digital camera with 24MP sensor and 4K video recording.',
    icon: Icons.camera_alt,
    backgroundColor: const Color(0xFFDCE8D4),
  ),
  Product(
    id: '6',
    title: 'Backpack',
    price: 42.0,
    category: 'accessories',
    description: 'Durable backpack with laptop compartment and water bottle holder.',
    icon: Icons.backpack,
    backgroundColor: const Color(0xFFF5D9E8),
  ),
];
