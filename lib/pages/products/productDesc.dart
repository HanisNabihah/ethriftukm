import 'package:flutter/material.dart';
import 'package:ethriftukm_fyp/pages/products/LikesProductProvider.dart';
import 'package:provider/provider.dart';

import 'checkoutProduct.dart';

class productDescPage extends StatefulWidget {
  final String imageUrl;
  final String productName;
  final double productPrice;
  final String productDesc;
  final String username;
  final String sellerEmail;
  final String sellerId;
  final String productId;

  const productDescPage({
    Key? key,
    required this.imageUrl,
    required this.productName,
    required this.productPrice,
    required this.productDesc,
    required this.username,
    required this.sellerEmail,
    required this.sellerId,
    required this.productId,
  }) : super(key: key);

  @override
  State<productDescPage> createState() => _productDescPageState();
}

class _productDescPageState extends State<productDescPage> {
  String selectedPaymentMethod = '';
  bool isLiked = false;

  late String productName;
  late String productDescription;
  late double productPrice;
  late String username;
  late String sellerEmail;
  late String sellerId;
  late String productId;

  @override
  void initState() {
    super.initState();
    isLiked = false;

    productName = widget.productName;
    productDescription = widget.productDesc;
    productPrice = widget.productPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text('Maklumat Produk'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.amberAccent,
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      productName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    productDescription,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'RM $productPrice',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Consumer<LikedProductsProviderPage>(
                    builder: (context, likedProductsProvider, _) {
                      bool isLiked = likedProductsProvider.likedProducts.any(
                          (product) =>
                              product['productName'] == widget.productName);
                      return GestureDetector(
                        onTap: () {
                          likedProductsProvider.toggleLike({
                            'productName': widget.productName,
                            'imageUrl': widget.imageUrl,
                            'productDescription': widget.productDesc,
                            'productPrice': widget.productPrice,
                            'username': widget.username,
                            'sellerEmail': widget.sellerEmail,
                            'sellerId': widget.sellerId,
                          });
                        },
                        child: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.grey,
                          size: 30,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: RawMaterialButton(
                      fillColor: const Color.fromARGB(255, 101, 13, 6),
                      elevation: 0.0,
                      padding: const EdgeInsets.all(25),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => checkoutProductPage(
                              imageUrl: widget.imageUrl,
                              productName: widget.productName,
                              productPrice: widget.productPrice,
                              username: widget.username,
                              sellerEmail: widget.sellerEmail,
                              sellerId: widget.sellerId,
                              productId: widget.productId,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "BELI",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
