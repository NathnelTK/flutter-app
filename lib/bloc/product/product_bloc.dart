import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/bloc/product/product_event.dart';
import 'package:flutter_app/bloc/product/product_state.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/repositories/product_repository.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;
  List<Product> _products = [];

  ProductBloc({ProductRepository? repository})
    : repository = repository ?? ProductRepository(),
      super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<AddProduct>(_onAddProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      _products = await repository.getProducts();
      emit(ProductLoaded(List.from(_products)));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onAddProduct(
    AddProduct event,
    Emitter<ProductState> emit,
  ) async {
    try {
      final product = await repository.createProduct(event.product);
      _products.add(product);
      emit(ProductLoaded(List.from(_products)));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onUpdateProduct(
    UpdateProduct event,
    Emitter<ProductState> emit,
  ) async {
    try {
      final product = await repository.updateProduct(event.id, event.product);
      final index = _products.indexWhere((item) => item.id == event.id);
      if (index != -1) {
        _products[index] = product;
        emit(ProductLoaded(List.from(_products)));
      }
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProduct event,
    Emitter<ProductState> emit,
  ) async {
    try {
      await repository.deleteProduct(event.id);
      _products.removeWhere((product) => product.id == event.id);
      emit(ProductLoaded(List.from(_products)));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
