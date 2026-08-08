import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Product> _products = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _products = await _apiService.getProducts();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
