import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListProducts extends StatefulWidget {
  const ListProducts({super.key});

  @override
  State<ListProducts> createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {
  Future<List<Map<String, dynamic>>> _fetchProductsData() async {
    try {
      QuerySnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('AllProducts')
          .where('availability', isEqualTo: 'available')
          .get();

      List<Map<String, dynamic>> productsData = productSnapshot.docs.map((doc) {
        Map<String, dynamic> productData = doc.data() as Map<String, dynamic>;
        productData['productId'] = doc.id;
        return productData;
      }).toList();

      return productsData;
    } catch (error) {
      print('Error fetching products data: $error');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
        title: const Text(
          'Senarai Produk',
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchProductsData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
                child: Text('Error: Unable to fetch products data'));
          } else {
            List<Map<String, dynamic>> productsData = snapshot.data ?? [];
            return Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: ListView.builder(
                itemCount: productsData.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> productData = productsData[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nama : ${productData['name'] ?? 'Unknown'}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              "Harga : ${productData['price'] ?? 'Unknown'}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              "Emel Penjual : ${productData['userEmail'] ?? 'Unknown'}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  flex: 0,
                                  child: Text(
                                    "Kategori : ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    productData['category'] ?? 'Unknown',
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _showDeleteDialog(productData['productId']);
                                  },
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  void _showDeleteDialog(String productId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Pilih Sebab:"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Produk Tidak Relevan"),
                onTap: () {
                  _deleteProduct(productId);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Lain-Lain"),
                onTap: () {
                  _deleteProduct(productId);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection('AllProducts')
          .doc(productId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Produk berjaya dipadam.'),
      ));
      setState(() {});
    } catch (error) {
      print('Error deleting product: $error');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Ralat: Gagal memadam produk.'),
      ));
    }
  }
}
