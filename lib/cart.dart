import 'package:flutter/material.dart';

class CartItem {
  final String name;
  final int price;
  final int quantity;

  CartItem({required this.name,required this.price,required this.quantity});

}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  int get totalAmount {
    int total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, String name, int price) {
    if (_items.containsKey(productId)) 
    {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          name: existingCartItem.name,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    }

    else 
    {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          name: name,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (_items.containsKey(productId)) 
    {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          name: existingCartItem.name,
          price: existingCartItem.price,
          quantity: quantity,
        )
      );
    }
    notifyListeners();
    }

}
