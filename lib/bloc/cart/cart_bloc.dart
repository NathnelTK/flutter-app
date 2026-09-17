import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/bloc/cart/cart_event.dart';
import 'package:flutter_app/bloc/cart/cart_state.dart';
import 'package:flutter_app/models/cart_item.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  List<CartItem> _items = [];

  CartBloc() : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateCartQuantity>(_onUpdateCartQuantity);
    on<ClearCart>(_onClearCart);
  }

  void _onLoadCart(LoadCart event, Emitter<CartState> emit) {
    emit(CartLoaded(List.from(_items)));
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    final existingIndex = _items.indexWhere((item) => item.product.id == event.product.id);

    if (existingIndex >= 0) {
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + event.quantity,
      );
    } else {
      _items.add(CartItem(product: event.product, quantity: event.quantity));
    }

    emit(CartLoaded(List.from(_items)));
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    _items.removeWhere((item) => item.product.id == event.productId);
    emit(CartLoaded(List.from(_items)));
  }

  void _onUpdateCartQuantity(UpdateCartQuantity event, Emitter<CartState> emit) {
    if (event.quantity <= 0) {
      _items.removeWhere((item) => item.product.id == event.productId);
    } else {
      final index = _items.indexWhere((item) => item.product.id == event.productId);
      if (index != -1) {
        _items[index] = _items[index].copyWith(quantity: event.quantity);
      }
    }
    emit(CartLoaded(List.from(_items)));
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    _items.clear();
    emit(CartLoaded(List.from(_items)));
  }
}
