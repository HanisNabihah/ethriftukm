import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ethriftukm_fyp/pages/admin/homepageAdmin.dart';

class RegisterAdminPage extends StatefulWidget {
  static const routeName = "/registerAdminPage";
  const RegisterAdminPage({Key? key}) : super(key: key);

  @override
  _RegisterAdminPageState createState() => _RegisterAdminPageState();
}

class _RegisterAdminPageState extends State<RegisterAdminPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();

    super.dispose();
  }

  Future<void> register() async {
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      CollectionReference admin =
          FirebaseFirestore.instance.collection('Admin');
      await admin.doc(userCredential.user!.uid).set({
        'username': username,
        'email': email,
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomepageAdmin()),
      );
    } catch (error) {
      print('Failed to register: $error');
    }
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _passwordConfirmController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Register Admin',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Image.asset(
                  'lib/images/e-thrift.png',
                  height: 300,
                ),
              ),
              buildUsername(),
              const SizedBox(height: 10),
              buildEmail(),
              const SizedBox(height: 10),
              buildPassword(),
              const SizedBox(height: 10),
              buildConfirmPassword(),
              const SizedBox(height: 26),
              SizedBox(
                width: 300,
                child: RawMaterialButton(
                  fillColor: const Color.fromARGB(255, 101, 13, 6),
                  elevation: 0.0,
                  padding: const EdgeInsets.all(25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onPressed: () {
                    register();
                  },
                  child: const Center(
                    child: Text(
                      "REGISTER",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox buildUsername() {
    return SizedBox(
      width: 400,
      child: TextFormField(
        controller: _usernameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Username',
          hintText: 'Name',
          labelStyle: const TextStyle(color: Colors.black),
          prefixIcon: const Icon(Icons.person, color: Colors.black),
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

  SizedBox buildEmail() {
    return SizedBox(
      width: 400,
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'Enter your email address',
          labelStyle: const TextStyle(color: Colors.black),
          prefixIcon: const Icon(Icons.mail, color: Colors.black),
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

  SizedBox buildPassword() {
    return SizedBox(
        width: 400,
        child: TextFormField(
          controller: _passwordController,
          obscureText: true,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Enter your password.',
            labelStyle: const TextStyle(color: Colors.black),
            prefixIcon: const Icon(Icons.lock, color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onTap: () {
            FocusScope.of(context).unfocus();
          },
        ));
  }

  SizedBox buildConfirmPassword() {
    return SizedBox(
        width: 400,
        child: TextFormField(
          controller: _passwordConfirmController,
          obscureText: true,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            hintText: 'Confirm your password.',
            labelStyle: const TextStyle(color: Colors.black),
            prefixIcon: const Icon(Icons.lock, color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onTap: () {
            FocusScope.of(context).unfocus();
          },
        ));
  }
}
