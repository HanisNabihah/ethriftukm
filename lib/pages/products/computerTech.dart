import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../onboarding/mainmenu.dart';
import 'productDesc.dart';

class ComputerTechPage extends StatefulWidget {
  const ComputerTechPage({super.key});

  @override
  State<ComputerTechPage> createState() => _ComputerTechPageState();
}

class _ComputerTechPageState extends State<ComputerTechPage> {
  late Future<List<DocumentSnapshot>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _fetchProducts();
  }

  Future<List<DocumentSnapshot>> _fetchProducts() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('AllProducts')
        .where('category', isEqualTo: "Computer Tech")
        .where('availability', isEqualTo: 'available')
        .get();
    return querySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainMenuPage()),
              (Route<dynamic> route) => false,
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
        title: const Text('Kategori: Komputer Teknologi'),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<DocumentSnapshot> products = snapshot.data ?? [];
            if (products.isEmpty) {
              return const Center(child: Text('Tiada Produk Dijumpai'));
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDescPage(
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
                                products[i]['image'],
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
                                products[i]['name'],
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
                              "RM ${products[i]['price']}",
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
      ),
    );
  }
}
