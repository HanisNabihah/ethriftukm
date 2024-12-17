import 'package:flutter/material.dart';

class LikedProductsProviderPage extends ChangeNotifier {
  final List<Map<String, dynamic>> _likedProducts = [];

  List<Map<String, dynamic>> get likedProducts => _likedProducts;

  void toggleLike(Map<String, dynamic> productDetails) {
    bool isLiked = _likedProducts.any(
        (product) => product['productName'] == productDetails['productName']);

    if (isLiked) {
      _likedProducts.removeWhere(
          (product) => product['productName'] == productDetails['productName']);
    } else {
      _likedProducts.add(productDetails);
    }

    notifyListeners();
  }
}
