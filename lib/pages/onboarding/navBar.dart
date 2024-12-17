import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ethriftukm_fyp/pages/onboarding/login.dart';

import 'package:ethriftukm_fyp/pages/products/beautySkincare.dart';
import 'package:ethriftukm_fyp/pages/products/computerTech.dart';

import 'package:ethriftukm_fyp/pages/products/mensFashion.dart';
import 'package:ethriftukm_fyp/pages/products/womensFashion.dart';

class NavBar extends StatelessWidget {
  Future<Map<String, dynamic>> _fetchUserData() async {
    String userID = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance.collection('Users').doc(userID).get();
    return userSnapshot.data() ?? {};
  }

  const NavBar({super.key});

  Future<DocumentSnapshot?> getUserData() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();
      return userData;
    } catch (error) {
      print('Error fetching user data: $error');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<Map<String, dynamic>>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            String accountName = snapshot.data!['username'] ?? 'Unknown';
            String accountEmail = snapshot.data!['email'] ?? 'Unknown';
            String profileImageUrl = snapshot.data!['profileImageUrl'] ?? '';

            return ListView(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(accountName),
                  accountEmail: Text(accountEmail),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                      child: profileImageUrl.isNotEmpty
                          ? Image.network(
                              profileImageUrl,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'lib/images/default-profilephoto.jpeg',
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          : Image.asset(
                              'lib/images/default-profilephoto.jpeg',
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text("Women's Fashion "),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WomensFashionPage()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text("Men's Fashion "),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MensFashionPage()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.account_circle_outlined),
                  title: const Text('Beauty & Personal Care'),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BeautySkincarePage()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.favorite),
                  title: const Text('Computer Tech'),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ComputerTechPage()));
                  },
                ),
                const SizedBox(height: 380),
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text('Log Keluar'),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
