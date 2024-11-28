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

class uploadProductPage extends StatefulWidget {
  static const routeName = "/UploadProduct";
  const uploadProductPage({super.key});

  @override
  State<uploadProductPage> createState() => _uploadProductState();
}

final dbEthriftRef = FirebaseDatabase.instance.ref("Products");
final storageRef = FirebaseStorage.instance.ref().child('product_images');

class _uploadProductState extends State<uploadProductPage> {
  //text controllers
  TextEditingController prodName = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController description = TextEditingController();

  bool isItemSaved = false;

  Future<void> addProduct() async {
    // Get the selected image and convert it to a base64 string
    if (_selectedImage != null) {
      final imageBytes = File(_selectedImage!.path).readAsBytesSync();
      // Generate a new unique ID for the product
      String productId = dbEthriftRef.push().key ?? '';

      // Upload the image to Firebase Storage
      String imageUrl = await uploadImageToStorage(imageBytes, productId);

      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String userId = user.uid;

        try {
          // Save the product data to Firestore under the user's ID
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

          // Save the product data to Firestore under the category
          await FirebaseFirestore.instance
              .collection('Category Products')
              .doc(selectedValue)
              .collection('Product ID') // Store under the current user's ID
              .doc(productId)
              .set({
            "name": prodName.text,
            "price": double.parse(price.text),
            // You can add other fields here if needed
          });

          // Clear the text fields and reset the selected image
          prodName.clear();
          price.clear();
          description.clear();
          setState(() {
            _selectedImage = null;
          });

          // Show a success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Produk berjaya ditambah.')),
          );
        } catch (error) {
          // Handle Firestore error
          print('Gagal untuk menambah produk: $error');
        }
      } else {
        // Show an error message if user is null
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User is not authenticated')),
        );
      }
    } else {
      // Show an error message if no image is selected
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

  //final fbEthrift = FirebaseDatabase.instance;

  final List<String> categories = [
    "Fesyen Wanita",
    "Fesyen Lelaki",
    "Alat Solek",
    "Komputer Teknologi",
  ]; // Example categories

  //String dropdownValue = "Select Category"; // Default category
  String? selectedValue;

  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    //final ref = fbEthrift.ref().child('Products');

    return Scaffold(
      body: Form(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //    _selectedImage != null ? Image.file(_selectedImage!) : const Text("Please select an image"),
                _selectedImage != null
                    ? Container(
                        width: 350, // Adjust width as needed
                        height: 300, // Adjust height as needed
                        child: Image.file(_selectedImage!),
                      )
                    : const Text("Sila pilih satu gambar."),

                //button add image
                Container(
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
                //  const SizedBox(height: 10),

                const SizedBox(height: 40),

                //textfield product Name
                buildProductName(),
                const SizedBox(height: 10),

                //textfield product price
                buildProductPrice(),
                const SizedBox(height: 10),

                //dropdown product category
                buildProductCategory(),
                const SizedBox(height: 10),

                //textfield description
                buildProductDesc(),
                const SizedBox(height: 40),

                //button add product
                const SizedBox(height: 40),
                Container(
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

  //product Name
  SizedBox buildProductName() {
    return SizedBox(
      width: 400, // Adjust the width as needed
      child: TextFormField(
        controller: prodName,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Product Name',
          hintText: 'Fill your product name here.',
          labelStyle: const TextStyle(color: Colors.black),
          //prefixIcon: Icon(Icons.person, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          // You can add more styling here if needed
        ),
        onTap: () {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  //product Price
  SizedBox buildProductPrice() {
    return SizedBox(
      width: 400, // Adjust the width as needed
      child: TextFormField(
        controller: price,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Price',
          hintText: 'Fill your product price here.',
          labelStyle: const TextStyle(color: Colors.black),
          //prefixIcon: Icon(Icons.person, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          // You can add more styling here if needed
        ),
        onTap: () {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  //product Category
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
        onChanged: (value) {
          //Do something when selected item is changed.
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

  //description
  SizedBox buildProductDesc() {
    return SizedBox(
      width: 400, // Adjust the width as needed
      child: TextFormField(
        controller: description,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Description',
          hintText: 'Fill your description here.',
          labelStyle: const TextStyle(color: Colors.black),
          //prefixIcon: Icon(Icons.person, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          // You can add more styling here if needed
        ),
        onTap: () {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  //pick image from gallery
  Future _pickImagefromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  //upload image to firebase storage
  uploadImageToStorage(Uint8List imageBytes, String productId) async {
    try {
      // Create a reference to the location where you want to store the image
      Reference storageRef =
          FirebaseStorage.instance.ref().child('product_images/$productId.jpg');

      // Upload the image to Firebase Storage
      UploadTask uploadTask = storageRef.putData(imageBytes);

      // Await the completion of the upload task and get the download URL
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();

      return imageUrl;
    } catch (e) {
      print('Error uploading image to storage: $e');
      return ''; // Return empty string in case of error
    }
  }
}
