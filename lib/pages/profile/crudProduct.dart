import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class crudProductPage extends StatefulWidget {
  final String productId;
  final String imageUrl;
  final String productName;
  final double productPrice;
  final String productDesc;
  final String productCategory;

  const crudProductPage({
    Key? key,
    required this.productId,
    required this.imageUrl,
    required this.productName,
    required this.productPrice,
    required this.productDesc,
    required this.productCategory,
  }) : super(key: key);

  @override
  State<crudProductPage> createState() => _crudProductPageState();
}

class _crudProductPageState extends State<crudProductPage> {
  final List<String> categories = [
    "Women's Fashion",
    "Men's Fashion",
    "Beauty & Personal Care",
    "Computer Tech",
  ];

  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  late String selectedCategory;
  final TextEditingController DescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    productNameController.text = widget.productName;
    productPriceController.text = widget.productPrice.toString();
    DescriptionController.text = widget.productDesc;
    selectedCategory = widget.productCategory;
  }

  Future<List<String>> getProductIds() async {
    List<String> productIds = [];
    try {
      QuerySnapshot productsSnapshot =
          await FirebaseFirestore.instance.collection('AllProducts').get();

      productsSnapshot.docs.forEach((doc) {
        productIds.add(doc.id);
      });

      return productIds;
    } catch (error) {
      print('Error fetching productIds: $error');
      return [];
    }
  }

  Future<void> updateProductDetails() async {
    String updatedName = productNameController.text;
    double updatedPrice = double.parse(productPriceController.text);
    String updatedDescription = DescriptionController.text;
    String updatedCategory = selectedCategory;

    try {
      List<String> productIds = await getProductIds();

      if (productIds.isNotEmpty) {
        String userId = FirebaseAuth.instance.currentUser!.uid;
        await FirebaseFirestore.instance
            .collection('Products')
            .doc(userId)
            .collection('Products')
            .doc(widget.productId)
            .update({
          'name': updatedName,
          'price': updatedPrice,
          'description': updatedDescription,
          'category': updatedCategory,
        });
        await FirebaseFirestore.instance
            .collection('AllProducts')
            .doc(widget.productId)
            .update({
          'name': updatedName,
          'price': updatedPrice,
          'description': updatedDescription,
          'category': updatedCategory,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produk berjaya dikemaskini')),
        );
        Navigator.pop(context, {
          'username': updatedName,
          'price': updatedPrice,
          'description': updatedDescription,
          'category': updatedCategory,
        });
      } else {
        print('Tiada produk dijumpai untuk dikemaskini');
      }
    } catch (error) {
      print('Ralat Kemaskini Produk: $error');
    }
  }

  Future<void> deleteProductDetails() async {
    try {
      List<String> productIds = await getProductIds();

      if (productIds.isNotEmpty) {
        String userId = FirebaseAuth.instance.currentUser!.uid;
        await FirebaseFirestore.instance
            .collection('Products')
            .doc(userId)
            .collection('Products')
            .doc(widget.productId)
            .delete();

        await FirebaseFirestore.instance
            .collection('AllProducts')
            .doc(widget.productId)
            .delete();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product deleted successfully')),
        );
        Navigator.pop(context);
      } else {
        print('No product found to delete');
      }
    } catch (error) {
      print('Error deleting product: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
            ),
          ),
          title: const Text('Kemaskini Produk'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 250,
                width: 250,
                color: Colors.amberAccent,
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              buildProductName(),
              const SizedBox(height: 20),
              buildProductPrice(),
              const SizedBox(height: 20),
              buildProductCategory(),
              const SizedBox(height: 20),
              buildProductDesc(),
              const SizedBox(height: 20),
              SizedBox(
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RawMaterialButton(
                        fillColor: const Color.fromARGB(255, 101, 13, 6),
                        onPressed: () {
                          deleteProductDetails();
                        },
                        padding: const EdgeInsets.all(25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'BUANG',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: RawMaterialButton(
                        fillColor: const Color.fromARGB(255, 101, 13, 6),
                        onPressed: updateProductDetails,
                        padding: const EdgeInsets.all(25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'KEMASKINI',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox buildProductName() {
    return SizedBox(
      width: 380,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextFormField(
            controller: productNameController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Nama Produk',
              hintText: 'Isi semula nama produk.',
              labelStyle: const TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onTap: () {
              FocusScope.of(context).unfocus();
            },
          ),
        ),
      ),
    );
  }

  SizedBox buildProductPrice() {
    return SizedBox(
      width: 380,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextFormField(
            controller: productPriceController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Harga',
              hintText: 'Isi harga produk.',
              labelStyle: const TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onTap: () {
              FocusScope.of(context).unfocus();
            },
          ),
        ),
      ),
    );
  }

  SizedBox buildProductCategory() {
    return SizedBox(
      width: 380,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: DropdownButtonFormField2<String>(
            isExpanded: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            hint: const Text(
              'Select Category',
              style: TextStyle(fontSize: 14),
            ),
            value: selectedCategory,
            items: categories
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ))
                .toList(),
            validator: (value) {
              if (value == null) {
                return 'Sila pilih kategori produk.';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                selectedCategory = value!;
              });
            },
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.only(right: 8),
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.black45,
              ),
              iconSize: 24,
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox buildProductDesc() {
    return SizedBox(
      width: 400,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextFormField(
            controller: DescriptionController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Diskripsi',
              hintText: 'Isi diskripsi produk dibawah.',
              labelStyle: const TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            minLines: 4,
            maxLines: 10,
          ),
        ),
      ),
    );
  }
}
