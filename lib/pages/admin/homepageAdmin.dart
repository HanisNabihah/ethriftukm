import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ethriftukm_fyp/pages/admin/listProducts.dart';
import 'package:ethriftukm_fyp/pages/admin/listUsers.dart';
import 'package:image_picker/image_picker.dart';

import '../onboarding/login.dart';

class homepageAdmin extends StatefulWidget {
  const homepageAdmin({Key? key}) : super(key: key);

  @override
  _homepageAdminState createState() => _homepageAdminState();
}

class _homepageAdminState extends State<homepageAdmin>
    with TickerProviderStateMixin {
  var height, width;
  File? selectedImage;

  Future<DocumentSnapshot?> _fetchAdminData() async {
    try {
      String adminID = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot adminSnapshot = await FirebaseFirestore.instance
          .collection('Admin')
          .doc(adminID)
          .get();
      return adminSnapshot;
    } catch (error) {
      print('Error fetching admin data: $error');
      return null;
    }
  }

  Future<int> _fetchUserCount() async {
    try {
      QuerySnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('Users').get();
      return userSnapshot.docs.length;
    } catch (error) {
      print('Error fetching user count: $error');
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: const Color.fromARGB(174, 113, 95, 182),
        child: Column(
          children: [
            Container(
              height: height * 0.30,
              width: width,
              child: Stack(
                children: [
                  FutureBuilder<DocumentSnapshot?>(
                    future: _fetchAdminData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError ||
                          !snapshot.hasData ||
                          snapshot.data == null) {
                        return const Center(
                            child: Text('Error: Unable to fetch admin data'));
                      } else {
                        var username = snapshot.data!['username'] ?? 'Unknown';
                        var email = snapshot.data!['email'] ?? 'Unknown';
                        return Positioned(
                          bottom: 16,
                          left: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                email,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: ClipOval(
                      child: Image.asset(
                        'lib/images/nana.png',
                        fit: BoxFit.cover,
                        width: 150,
                        height: 150,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 12,
                    child: GestureDetector(
                      onTap: () {
                        _showEditDialog();
                      },
                      child: const Icon(Icons.edit),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showEditDialog(); // Call a function to open the gallery picker
                    },
                    // child: SizedBox(
                    //   width: 150,
                    //   height: 150,
                    //   child: CircleAvatar(
                    //     backgroundImage: AssetImage('lib/images/nana.png'),
                    //   ),
                    // ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              height: height * 0.7,
              width: width,
              child: GestureDetector(
                onTap: () {
                  // Add onTap functionality here
                },
                child: Column(
                  children: [
                    const SizedBox(height: 150),
                    FutureBuilder<int>(
                      future: _fetchUserCount(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return const Text(
                              'Error: Unable to fetch user count');
                        } else {
                          int userCount = snapshot.data ?? 0;
                          return Text(
                            'Total Users: $userCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(
                      width: 250,
                      height: 100,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const listUser()),
                          );
                        },
                        style: ButtonStyle(
                          elevation: WidgetStateProperty.all(5),
                          backgroundColor: WidgetStateProperty.all(
                              const Color.fromARGB(255, 242, 238, 238)),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 10),
                            FutureBuilder<int>(
                              future: _fetchUserCount(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return const Text(
                                      'Error: Unable to fetch user count');
                                } else {
                                  int userCount = snapshot.data ?? 0;
                                  return Text(
                                    '$userCount PENGGUNA',
                                    style: const TextStyle(
                                        fontSize: 24, color: Colors.black),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                    SizedBox(
                      width: 250,
                      height: 100,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const listProducts()),
                          );
                        },
                        style: ButtonStyle(
                          elevation: WidgetStateProperty.all(5),
                          backgroundColor: WidgetStateProperty.all(
                              const Color.fromARGB(255, 242, 238, 238)),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.trolley,
                              size: 40,
                              color: Colors.black,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'PRODUK',
                              style:
                                  TextStyle(fontSize: 24, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _logout();
        },
        tooltip: 'Logout',
        child: const Icon(Icons.exit_to_app),
      ),
    );
  }

  void _showEditDialog() async {
    String adminID = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot adminSnapshot =
        await FirebaseFirestore.instance.collection('Admin').doc(adminID).get();
    String currentUsername = adminSnapshot['username'] ?? 'Unknown';

    TextEditingController usernameController =
        TextEditingController(text: currentUsername);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Kemaskini Admin"),
          content: Container(
            child: TextField(
              controller: usernameController,
              decoration:
                  const InputDecoration(labelText: 'Nama Pengguna Baru'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String newUsername = usernameController.text;
                _updateAdminUsername(newUsername);
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
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

  void _updateAdminUsername(String newUsername) async {
    try {
      String adminID = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('Admin')
          .doc(adminID)
          .update({'username': newUsername});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Username updated successfully.'),
      ));
      setState(() {});
    } catch (error) {
      print('Error updating username: $error');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error: Failed to update username.'),
      ));
    }
  }

  void _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to login page after logout
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
    } catch (error) {
      print('Error logging out: $error');
      // Handle logout error
    }
  }

  // Pick image from gallery
  Future openGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage == null) return;
    setState(() {
      selectedImage = File(pickedImage.path);
    });
  }
}
