import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ethriftukm_fyp/pages/products/productDesc.dart';

import '../screenSeller/product.dart';

class ProductsWidgetFirestore extends StatefulWidget {
  final List<Product> products;
  //const ProductsWidgetFirestore({Key? key});

  final Function(String, double, String) onProductSelected; // Callback function

  const ProductsWidgetFirestore({
    Key? key,
    required this.products, // Declare the products parameter as required
    required this.onProductSelected,
  }) : super(key: key);

  @override
  State<ProductsWidgetFirestore> createState() =>
      _ProductsWidgetFirestoreState();
}

class _ProductsWidgetFirestoreState extends State<ProductsWidgetFirestore> {
  late Future<List<DocumentSnapshot>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _fetchProducts();
  }

  Future<List<DocumentSnapshot>> _fetchProducts() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('AllProducts')
        .where('availability', isEqualTo: 'available')
        .get();
    return querySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<DocumentSnapshot> products = snapshot.data ?? [];
          if (products.isEmpty) {
            return const Center(child: Text('No products found'));
          } else {
            return GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.68,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                for (int i = 0; i < products.length; i++)
                  Container(
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
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            // Call the callback function when a product is selected
                            widget.onProductSelected(
                              products[i]['name'], // Product name
                              products[i]['price'], // Product price
                              products[i]['image'], // Product image URL
                            );
                            //Extract product details
                            // Product product = Product(
                            //   imgUrl: products[i]['image'],
                            //   name: products[i]['name'],
                            //   desc: products[i]['description'],
                            //   price: products[i]['price'],
                            // );

                            // navigate to product details description
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => productDescPage(
                                  //product: Product.fromSnapshot(products[i]),
                                  imageUrl: products[i]['image'],
                                  productName: products[i]['name'],
                                  productPrice: products[i]['price'],
                                  productDesc: products[i]['description'],
                                  username: products[i]['username'],
                                  sellerId: products[i]['userId'],
                                  sellerEmail: products[i]['userEmail'],
                                  productId: products[i]['productId'],
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.network(
                              products[i][
                                  'image'], // Assuming 'image' is the field name for image URL
                              height: 170,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              products[i][
                                  'name'], // Assuming 'name' is the field name for product name
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "RM ${products[i]['price']}", // Assuming 'price' is the field name for product price
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          }
        }
      },
    );
  }
}
