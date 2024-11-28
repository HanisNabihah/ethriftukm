import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ethriftukm_fyp/pages/products/productDesc.dart';

class SearchResultsPage extends StatelessWidget {
  final String query;

  const SearchResultsPage({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keputusan Carian'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('AllProducts')
            .where('name', isGreaterThanOrEqualTo: query.toLowerCase())
            .where('name', isLessThanOrEqualTo: query.toLowerCase() + '\uf8ff')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final searchResults = snapshot.data?.docs ?? [];

          if (searchResults.isEmpty) {
            return const Center(child: Text('Tiada produk dijumpai'));
          }

          return ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> productData =
                  searchResults[index].data() as Map<String, dynamic>;
              // Ensure all necessary fields are non-null
              final imageUrl = productData['image'] ?? '';
              final productName = productData['name'] ?? 'No Name';
              final productPrice = productData['price'] ?? 0.0;
              final productDesc =
                  productData['description'] ?? 'No Description';
              final username = productData['username'] ?? 'Unknown';
              final sellerEmail = productData['sellerEmail'] ?? 'No Email';
              final sellerId = productData['sellerId'] ?? 'Unknown';
              final productId = productData['productId'] ?? 'Unknown';

              return ListTile(
                title: Text(productName),
                subtitle: Text('Harga: RM ${productPrice}'),
                leading: Image.network(imageUrl),
                onTap: () {
                  // Handle product tap (e.g., navigate to product detail page)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => productDescPage(
                        imageUrl: imageUrl,
                        productName: productName,
                        productPrice: productPrice,
                        productDesc: productDesc,
                        username: username,
                        sellerEmail: sellerEmail,
                        sellerId: sellerId,
                        productId: productId,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
