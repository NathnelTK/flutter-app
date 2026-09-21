import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/bloc/cart/cart_event.dart';
import 'package:flutter_app/bloc/cart/cart_state.dart';
import 'package:flutter_app/models/cart_item.dart';
import 'package:flutter_app/repositories/cart_repository.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repository;
  List<CartItem> _items = [];

  CartBloc({CartRepository? repository})
    : repository = repository ?? CartRepository(),
      super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateCartQuantity>(_onUpdateCartQuantity);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    try {
      _items = await repository.getCartItems();
      emit(CartLoaded(List.from(_items)));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    try {
      await repository.addToCart(event.product, event.quantity);
      _items = await repository.getCartItems();
      emit(CartLoaded(List.from(_items)));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      final item = _items.firstWhere(
        (item) => item.product.id == event.productId,
      );
      if (item.id != null) await repository.removeFromCart(item.id!);
      _items = await repository.getCartItems();
      emit(CartLoaded(List.from(_items)));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onUpdateCartQuantity(
    UpdateCartQuantity event,
    Emitter<CartState> emit,
  ) async {
    try {
      final item = _items.firstWhere(
        (item) => item.product.id == event.productId,
      );
      if (event.quantity <= 0) {
        if (item.id != null) await repository.removeFromCart(item.id!);
      } else {
        await repository.updateQuantity(item.id!, event.quantity);
      }
      _items = await repository.getCartItems();
      emit(CartLoaded(List.from(_items)));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    try {
      await repository.clearCart();
      _items = [];
      emit(CartLoaded(List.from(_items)));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
}
