import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ethriftukm_fyp/pages/onboarding/login.dart';
import 'package:ethriftukm_fyp/pages/onboarding/mainmenu.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MainMenuPage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
