import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController collegeController = TextEditingController();

  late Stream<DocumentSnapshot> userStream;

  File? _selectedImage;
  String? profileImageUrl;
  bool displayProfilePicture = false;

  @override
  void initState() {
    super.initState();
    userStream = getUserStream();
  }

  Stream<DocumentSnapshot> getUserStream() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .snapshots();
  }

  Future _openGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> updateUserDetails() async {
    String updatedName = usernameController.text.trim();
    String updatedPhone = phoneController.text.trim();
    String updateCollege = collegeController.text.trim();
    String userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      if (_selectedImage != null) {
        String imageName = 'profile_$userId.jpg';
        TaskSnapshot snapshot = await FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(imageName)
            .putFile(_selectedImage!);

        profileImageUrl = await snapshot.ref.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'username': updatedName,
        'phone': updatedPhone,
        'college': updateCollege,
        'profileImageUrl': profileImageUrl ?? '',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kemaskini Profil berjaya')),
      );

      Navigator.pop(context, {
        'username': updatedName,
        'phone': updatedPhone,
        'college': updateCollege,
        'profileImageUrl': profileImageUrl ?? '',
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal untuk Kemaskini Profil: $error')),
      );
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
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text(
          'Kemaskini Profil',
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data?.data() == null) {
            return const Center(child: Text('User data not available'));
          } else {
            Map<String, dynamic>? userData =
                snapshot.data!.data() as Map<String, dynamic>?;
            if (userData != null) {
              profileImageUrl = userData['profileImageUrl'];
              displayProfilePicture =
                  profileImageUrl != null && profileImageUrl!.isNotEmpty;

              usernameController.text = userData['username'] ?? '';
              phoneController.text = userData['phone'] ?? '';
              collegeController.text = userData['college'] ?? '';
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: _openGallery,
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          _selectedImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(75),
                                  child: Image.file(
                                    _selectedImage!,
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : displayProfilePicture
                                  ? CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(profileImageUrl!),
                                      radius: 75,
                                    )
                                  : Image.asset(
                                      'lib/images/default-profilephoto.jpeg',
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                          Positioned(
                            bottom: 0,
                            right: 90,
                            child: GestureDetector(
                              onTap: _openGallery,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  buildTextField(usernameController, 'Nama Pengguna',
                      'Fill your new username here.'),
                  const SizedBox(height: 20),
                  buildTextField(phoneController, 'Nombor Telefon',
                      'Sila isi nombor telefon baru anda'),
                  const SizedBox(height: 20),
                  buildDisabledTextField(userData?['email'] ?? '', 'Emel'),
                  const SizedBox(height: 20),
                  buildTextField(
                      collegeController, 'Kolej', 'Sila isi kolej baru anda.'),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: 300,
                    child: RawMaterialButton(
                      fillColor: const Color.fromARGB(255, 101, 13, 6),
                      onPressed: updateUserDetails,
                      padding: const EdgeInsets.all(25),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: const Text(
                        'KEMASKINI PROFIL',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildTextField(
      TextEditingController controller, String labelText, String hintText) {
    return SizedBox(
      width: 350,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          labelStyle: const TextStyle(color: Colors.black),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget buildDisabledTextField(String text, String labelText) {
    return SizedBox(
      width: 400,
      child: TextFormField(
        initialValue: text,
        enabled: false,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
