import 'package:flutter/material.dart';

class CartItem {
  final String name;
  final double price;
  int quantity;

  CartItem({required this.name, required this.price, this.quantity = 1});
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addToCart(String name, double price) {
    final index = _cartItems.indexWhere((item) => item.name == name);
    if (index != -1) {
      _cartItems[index].quantity++;
    } else {
      _cartItems.add(CartItem(name: name, price: price));
    }
    notifyListeners();
  }

  void removeFromCart(String name) {
    _cartItems.removeWhere((item) => item.name == name);
    notifyListeners();
  }

  void increaseQuantity(String name) {
    final index = _cartItems.indexWhere((item) => item.name == name);
    if (index != -1) {
      _cartItems[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(String name) {
    final index = _cartItems.indexWhere((item) => item.name == name);
    if (index != -1) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        _cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }
}
