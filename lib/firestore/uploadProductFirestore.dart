import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class UploadProductFirestorePage extends StatefulWidget {
  static const routeName = "/UploadProduct";
  const UploadProductFirestorePage({superKey}) : super(key: superKey);

  @override
  State<UploadProductFirestorePage> createState() =>
      _UploadProductFirestorePageState();
}

final CollectionReference<Map<String, dynamic>> dbEthriftRef =
    FirebaseFirestore.instance.collection('Products');
final Reference storageRef =
    FirebaseStorage.instance.ref().child('product_images');

class _UploadProductFirestorePageState
    extends State<UploadProductFirestorePage> {
  TextEditingController prodName = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController description = TextEditingController();

  File? _selectedImage;

  final List<String> categories = [
    "Women's Fashion",
    "Men's Fashion",
    "Beauty & Personal Care",
    "Computer Tech",
  ];

  String? selectedValue;

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
        title: const Text('Muatnaik Produk'),
      ),
      body: Form(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _selectedImage != null
                    ? SizedBox(
                        width: 250,
                        height: 200,
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Text("Pilih satu gambar"),
                SizedBox(
                  width: 50,
                  child: MaterialButton(
                    elevation: 0.0,
                    padding: const EdgeInsets.all(0.0),
                    child: Image.asset(
                      'lib/images/add-image.png',
                    ),
                    onPressed: () {
                      _pickImageFromGallery();
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
                SizedBox(
                  width: 280,
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
                        "TAMBAH PRODUK",
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
      width: 350,
      child: TextFormField(
        controller: prodName,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Nama Produk',
          hintText: 'Sila isi nama produk anda.',
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
      width: 350,
      child: TextFormField(
        controller: price,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Harga',
          hintText: 'Sila isi harga produk anda.',
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
      width: 350,
      child: DropdownButtonFormField2<String>(
        isExpanded: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        hint: const Text(
          'Pilih Kategori',
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
            return 'Sila pilih kategori.';
          }
          return null;
        },
        onChanged: (value) {
          setState(() {
            selectedValue = value;
          });
        },
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
      width: 350,
      child: TextFormField(
        controller: description,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Deskripsi',
          hintText: 'Sila isi deskripsi produk anda.',
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
    );
  }

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  Future<void> addProduct() async {
    if (_selectedImage != null) {
      final imageBytes = await _selectedImage!.readAsBytes();

      String userID = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userID)
          .get();
      String username = userSnapshot['username'];
      String userEmail = userSnapshot['email'];

      String productId = dbEthriftRef.doc().id;
      String imageUrl = await uploadImageToStorage(imageBytes, productId);
      if (imageUrl.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error uploading image')),
        );
        return;
      }

      DocumentReference productRef =
          dbEthriftRef.doc(userID).collection('Products').doc(productId);

      DocumentReference categoryRef = FirebaseFirestore.instance
          .collection('Category Products')
          .doc(selectedValue)
          .collection('Products')
          .doc(productId);

      String availability = "available";

      await productRef.set({
        "userEmail": userEmail,
        "userId": userID,
        "username": username,
        "name": prodName.text,
        "price": double.parse(price.text),
        "category": selectedValue,
        "description": description.text,
        "image": imageUrl,
        "availability": availability,
        "productId": productId,
      });

      await productRef.set({
        "userEmail": userEmail,
        "userId": userID,
        "username": username,
        "name": prodName.text,
        "price": double.parse(price.text),
        "category": selectedValue,
        "description": description.text,
        "image": imageUrl,
        "availability": availability,
        "productId": productId,
      });

      await FirebaseFirestore.instance
          .collection('AllProducts')
          .doc(productId)
          .set({
        "userEmail": userEmail,
        "userId": userID,
        "username": username,
        "name": prodName.text,
        "price": double.parse(price.text),
        "category": selectedValue,
        "description": description.text,
        "image": imageUrl,
        "availability": availability,
        "productId": productId,
      });
      await categoryRef.set({
        "userEmail": userEmail,
        "userId": userID,
        "username": username,
        "name": prodName.text,
        "price": double.parse(price.text),
        "description": description.text,
        "image": imageUrl,
        "availability": availability,
        "productId": productId,
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
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sila pilih satu gambar')),
      );
    }
  }

  Future<String> uploadImageToStorage(
      Uint8List imageBytes, String productId) async {
    try {
      print('Uploading image for product: $productId');
      Reference storageReference = storageRef.child('$productId.jpg');
      UploadTask uploadTask = storageReference.putData(imageBytes);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();
      print('Image uploaded successfully: $imageUrl');
      return imageUrl;
    } catch (e) {
      print('Error uploading image to storage: $e');
      return '';
    }
  }

  void testImageUpload() async {
    final ByteData byteData = await rootBundle.load('assets/test_image.jpg');
    final Uint8List imageBytes = byteData.buffer.asUint8List();
    const String productId = 'testProductId';
    final String imageUrl = await uploadImageToStorage(imageBytes, productId);
    print('Test Image URL: $imageUrl');
  }
}
