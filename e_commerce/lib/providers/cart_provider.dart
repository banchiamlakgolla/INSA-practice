import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  List<Product> _cartProducts = [];
  Map<int, int> _quantities = {};

  List<Product> get cartProducts => _cartProducts;

  int get totalItems {
    int total = 0;

    for (final quantity in _quantities.values) {
      total += quantity;
    }

    return total;
  }

  double get totalPrice {
    double total = 0;

    for (final product in _cartProducts) {
      total += product.price * (_quantities[product.id] ?? 1);
    }

    return total;
  }

  int getQuantity(int productId) {
    return _quantities[productId] ?? 1;
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();

    final savedCart = prefs.getString('cart');

    if (savedCart == null) {
      return;
    }

    final List<dynamic> data = jsonDecode(savedCart);

    _cartProducts = data.map((item) {
      return Product.fromJson(item['product']);
    }).toList();

    _quantities = {};

    for (final item in data) {
      _quantities[item['product']['id']] = item['quantity'];
    }

    notifyListeners();
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();

    final data = _cartProducts.map((product) {
      return {
        'product': {
          'id': product.id,
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'category': product.category,
          'image': product.image,
          'rating': {'rate': product.rating, 'count': product.ratingCount},
        },
        'quantity': _quantities[product.id] ?? 1,
      };
    }).toList();

    await prefs.setString('cart', jsonEncode(data));
  }

  Future<void> addToCart(Product product) async {
    final existingIndex = _cartProducts.indexWhere(
      (item) => item.id == product.id,
    );

    if (existingIndex == -1) {
      _cartProducts.add(product);
      _quantities[product.id] = 1;
    } else {
      _quantities[product.id] = (_quantities[product.id] ?? 1) + 1;
    }

    await _saveCart();

    notifyListeners();
  }

  Future<void> increaseQuantity(Product product) async {
    _quantities[product.id] = (_quantities[product.id] ?? 1) + 1;

    await _saveCart();

    notifyListeners();
  }

  Future<void> decreaseQuantity(Product product) async {
    final currentQuantity = _quantities[product.id] ?? 1;

    if (currentQuantity > 1) {
      _quantities[product.id] = currentQuantity - 1;
    } else {
      _cartProducts.removeWhere((item) => item.id == product.id);
      _quantities.remove(product.id);
    }

    await _saveCart();

    notifyListeners();
  }

  Future<void> removeFromCart(Product product) async {
    _cartProducts.removeWhere((item) => item.id == product.id);
    _quantities.remove(product.id);

    await _saveCart();

    notifyListeners();
  }

  Future<void> clearCart() async {
    _cartProducts.clear();
    _quantities.clear();

    await _saveCart();

    notifyListeners();
  }
}
