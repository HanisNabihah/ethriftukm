import 'package:flutter/material.dart';
import 'package:ethriftukm_fyp/pages/products/LikesProductProvider.dart';
import 'package:ethriftukm_fyp/pages/products/productDesc.dart';
import 'package:provider/provider.dart';

class LikesPage extends StatelessWidget {
  final String productName;
  final double productPrice;
  final String imageUrl;

  LikesPage({
    required this.productName,
    required this.productPrice,
    required this.imageUrl,
  });

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
        title: const Text('Kesukaan'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 0.68,
        shrinkWrap: true,
        children: Provider.of<LikedProductsProviderPage>(context)
            .likedProducts
            .map((product) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => productDescPage(
                          imageUrl: product['imageUrl'],
                          productName: product['productName'],
                          productPrice: product['productPrice'],
                          productDesc: product['productDescription'],
                          username: product['username'],
                          sellerId: product['sellerId'],
                          sellerEmail: product['sellerEmail'],
                          productId: product['productId'].toString(),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 10),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: ListTile(
                      //title: Image.network(product['imageUrl']),
                      title: SizedBox(
                        height: 160,
                        width: 200,
                        child: Image.network(
                          product['imageUrl'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      //leading: Text(product['productName']),

                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          Text(product['productName'],
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Text(
                            'RM ${product['productPrice'].toStringAsFixed(2)}',
                            style:
                                const TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
