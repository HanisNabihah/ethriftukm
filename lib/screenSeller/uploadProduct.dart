import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class UploadProductPage extends StatefulWidget {
  static const routeName = "/UploadProduct";
  const UploadProductPage({super.key});

  @override
  State<UploadProductPage> createState() => _UploadProductState();
}

final dbEthriftRef = FirebaseDatabase.instance.ref("Products");
final storageRef = FirebaseStorage.instance.ref().child('product_images');

class _UploadProductState extends State<UploadProductPage> {
  TextEditingController prodName = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController description = TextEditingController();

  bool isItemSaved = false;

  Future<void> addProduct() async {
    if (_selectedImage != null) {
      final imageBytes = File(_selectedImage!.path).readAsBytesSync();
      String productId = dbEthriftRef.push().key ?? '';
      String imageUrl = await uploadImageToStorage(imageBytes, productId);
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String userId = user.uid;

        try {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(userId)
              .collection('Products')
              .doc(productId)
              .set({
            "name": prodName.text,
            "price": double.parse(price.text),
            "category": selectedValue,
            "description": description.text,
            "image": imageUrl,
          });
          await FirebaseFirestore.instance
              .collection('Category Products')
              .doc(selectedValue)
              .collection('Product ID')
              .doc(productId)
              .set({
            "name": prodName.text,
            "price": double.parse(price.text),
          });
          prodName.clear();
          price.clear();
          description.clear();
          setState(() {
            _selectedImage = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Produk berjaya ditambah.')),
          );
        } catch (error) {
          print('Gagal untuk menambah produk: $error');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User is not authenticated')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sila pilih satu gambar')),
      );
    }
  }

  @override
  void dispose() {
    prodName.dispose();
    price.dispose();
    description.dispose();
    super.dispose();
  }

  final List<String> categories = [
    "Fesyen Wanita",
    "Fesyen Lelaki",
    "Alat Solek",
    "Komputer Teknologi",
  ];
  String? selectedValue;

  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _selectedImage != null
                    ? SizedBox(
                        width: 350,
                        height: 300,
                        child: Image.file(_selectedImage!),
                      )
                    : const Text("Sila pilih satu gambar."),
                SizedBox(
                  width: 50,
                  child: MaterialButton(
                    elevation: 0.0,
                    padding: const EdgeInsets.all(0.0),
                    child: Image.asset(
                      'lib/images/add-image.png',
                    ),
                    onPressed: () {
                      _pickImagefromGallery();
                    },
                  ),
                ),
                const SizedBox(height: 40),
                buildProductName(),
                const SizedBox(height: 10),
                buildProductPrice(),
                const SizedBox(height: 10),
                buildProductCategory(),
                const SizedBox(height: 10),
                buildProductDesc(),
                const SizedBox(height: 40),
                const SizedBox(height: 40),
                SizedBox(
                  width: 200,
                  child: RawMaterialButton(
                    fillColor: const Color.fromARGB(255, 101, 13, 6),
                    elevation: 0.0,
                    padding: const EdgeInsets.all(25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onPressed: () {
                      addProduct();
                    },
                    child: const Center(
                      child: Text(
                        "ADD PRODUCT",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox buildProductName() {
    return SizedBox(
      width: 400,
      child: TextFormField(
        controller: prodName,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Product Name',
          hintText: 'Fill your product name here.',
          labelStyle: const TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onTap: () {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  SizedBox buildProductPrice() {
    return SizedBox(
      width: 400,
      child: TextFormField(
        controller: price,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Price',
          hintText: 'Fill your product price here.',
          labelStyle: const TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onTap: () {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  SizedBox buildProductCategory() {
    return SizedBox(
      width: 400,
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
            return 'Please select a category.';
          }
          return null;
        },
        onChanged: (value) {},
        onSaved: (value) {
          selectedValue = value.toString();
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
    );
  }

  SizedBox buildProductDesc() {
    return SizedBox(
      width: 400,
      child: TextFormField(
        controller: description,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Description',
          hintText: 'Fill your description here.',
          labelStyle: const TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onTap: () {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  Future _pickImagefromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  uploadImageToStorage(Uint8List imageBytes, String productId) async {
    try {
      Reference storageRef =
          FirebaseStorage.instance.ref().child('product_images/$productId.jpg');
      UploadTask uploadTask = storageRef.putData(imageBytes);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();

      return imageUrl;
    } catch (e) {
      print('Error uploading image to storage: $e');
      return '';
    }
  }
}
