import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/bloc/cart/cart_bloc.dart';
import 'package:flutter_app/bloc/cart/cart_event.dart';
import 'package:flutter_app/bloc/cart/cart_state.dart';
import 'package:flutter_app/bloc/product/product_bloc.dart';
import 'package:flutter_app/bloc/product/product_event.dart';
import 'package:flutter_app/bloc/product/product_state.dart';
import 'package:flutter_app/repositories/api_client.dart';
import 'package:flutter_app/repositories/cart_repository.dart';
import 'package:flutter_app/repositories/product_repository.dart';

void main() {
  test('product and cart BLoCs work with the SQLite API', () async {
    const apiUrl = 'http://localhost:5000/api';
    final apiClient = ApiClient(baseUrl: apiUrl);
    final productBloc = ProductBloc(
      repository: ProductRepository(apiClient: apiClient),
    );
    final cartBloc = CartBloc(repository: CartRepository(apiClient: apiClient));
    addTearDown(productBloc.close);
    addTearDown(cartBloc.close);

    final productsLoaded = productBloc.stream
        .where((state) => state is ProductLoaded || state is ProductError)
        .first;
    productBloc.add(LoadProducts());
    final productState = await productsLoaded;
    expect(
      productState,
      isA<ProductLoaded>(),
      reason: productState is ProductError ? productState.message : null,
    );
    final loadedProducts = productState as ProductLoaded;

    expect(loadedProducts.products, isNotEmpty);

    final productToUpdate = loadedProducts.products.first;
    final updatedProduct = productToUpdate.copyWith(
      title: '${productToUpdate.title} Updated',
    );
    final productUpdated = productBloc.stream
        .where((state) => state is ProductLoaded)
        .first;
    productBloc.add(UpdateProduct(productToUpdate.id, updatedProduct));
    final updatedState = await productUpdated as ProductLoaded;
    expect(
      updatedState.products
          .firstWhere((product) => product.id == productToUpdate.id)
          .title,
      updatedProduct.title,
    );

    final cartLoaded = cartBloc.stream
        .where((state) => state is CartLoaded)
        .first;
    cartBloc.add(LoadCart());
    final loadedCart = await cartLoaded as CartLoaded;
    expect(loadedCart.items, isEmpty);

    final cartItemAdded = cartBloc.stream
        .where((state) => state is CartLoaded && state.items.isNotEmpty)
        .first;
    cartBloc.add(AddToCart(loadedProducts.products.first, 2));
    final cartWithItem = await cartItemAdded as CartLoaded;

    expect(cartWithItem.items.single.quantity, 2);

    final cartCleared = cartBloc.stream
        .where((state) => state is CartLoaded && state.items.isEmpty)
        .first;
    cartBloc.add(ClearCart());
    final clearedCart = await cartCleared as CartLoaded;
    expect(clearedCart.items, isEmpty);
  });
}
