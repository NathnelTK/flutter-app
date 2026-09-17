import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/bloc/product/product_event.dart';
import 'package:flutter_app/bloc/product/product_state.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/data/sample_products.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  List<Product> _products = [];

  ProductBloc() : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<AddProduct>(_onAddProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
  }

  void _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      _products = List.from(sampleProducts);
      emit(ProductLoaded(_products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void _onAddProduct(AddProduct event, Emitter<ProductState> emit) async {
    if (state is ProductLoaded) {
      try {
        _products.add(event.product);
        emit(ProductLoaded(List.from(_products)));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    }
  }

  void _onUpdateProduct(UpdateProduct event, Emitter<ProductState> emit) async {
    if (state is ProductLoaded) {
      try {
        final index = _products.indexWhere((p) => p.id == event.id);
        if (index != -1) {
          _products[index] = event.product;
          emit(ProductLoaded(List.from(_products)));
        }
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    }
  }

  void _onDeleteProduct(DeleteProduct event, Emitter<ProductState> emit) async {
    if (state is ProductLoaded) {
      try {
        _products.removeWhere((p) => p.id == event.id);
        emit(ProductLoaded(List.from(_products)));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    }
  }
}
