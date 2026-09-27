import 'package:e_commerce_app/src/features/cart/data/cart_item_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../products/domain/product_model.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(Product product) {
    final existingIndex = state.indexWhere(
      (item) => item.product.id == product.id,
    );
    if (existingIndex != -1) {
      state = [
        ...state.sublist(0, existingIndex),
        CartItem(product: product, quantity: state[existingIndex].quantity + 1),
        ...state.sublist(existingIndex + 1),
      ];
    } else {
      state = [...state, CartItem(product: product)];
    }
  }

  void removeItem(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(productId);
      return;
    }
    final index = state.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      state = [
        ...state.sublist(0, index),
        CartItem(product: state[index].product, quantity: newQuantity),
        ...state.sublist(index + 1),
      ];
    }
  }

  void clear() => state = [];
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(
    0.0,
    (sum, item) => sum + item.product.price * item.quantity,
  );
});

final cartItemCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (sum, item) => sum + item.quantity);
});
