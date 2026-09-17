import 'package:go_router/go_router.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:flutter_app/screens/product_detail_screen.dart';
import 'package:flutter_app/screens/cart_screen.dart';
import 'package:flutter_app/screens/add_product_screen.dart';
import 'package:flutter_app/models/product.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/product/:id',
      name: 'product-detail',
      builder: (context, state) {
        final product = state.extra as Product;
        return ProductDetailScreen(product: product);
      },
    ),
    GoRoute(
      path: '/cart',
      name: 'cart',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/add-product',
      name: 'add-product',
      builder: (context, state) => const AddProductScreen(),
    ),
  ],
);
