import 'package:flutter/material.dart';

class LikedProductsProviderPage extends ChangeNotifier {
  List<Map<String, dynamic>> _likedProducts = [];

  List<Map<String, dynamic>> get likedProducts => _likedProducts;

  void toggleLike(Map<String, dynamic> productDetails) {
    // Check if the product is already liked
    bool isLiked = _likedProducts.any(
        (product) => product['productName'] == productDetails['productName']);

    if (isLiked) {
      // Remove the product from the liked list
      _likedProducts.removeWhere(
          (product) => product['productName'] == productDetails['productName']);
    } else {
      // Add the product to the liked list
      _likedProducts.add(productDetails);
    }

    // Notify listeners that the data has changed
    notifyListeners();
  }
}
