import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ethriftukm_fyp/pages/admin/homepageAdmin.dart';
import 'package:ethriftukm_fyp/pages/onboarding/forgot_password.dart';
import 'package:ethriftukm_fyp/pages/onboarding/registerFirestore.dart';
import 'mainmenu.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _LoginPageState extends State<LoginPage> {
  // Text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Track whether the password is obscured or not
  bool _isObscured = true;

  Future<void> signIn() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Check if email is verified
      if (userCredential.user != null && userCredential.user!.emailVerified) {
        String uid = userCredential.user!.uid;

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Log Masuk Berjaya'),
        //   ),
        // );

        // Check if the user is in the Users collection
        DocumentSnapshot userData =
            await FirebaseFirestore.instance.collection('Users').doc(uid).get();

        if (userData.exists) {
          // User is in the Users collection

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Log Masuk Berjaya'),
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainMenuPage()),
          );
        } else {
          // Check if the user is in the Admin collection
          DocumentSnapshot adminData = await FirebaseFirestore.instance
              .collection('Admin')
              .doc(uid)
              .get();

          if (adminData.exists) {
            // User is in the Admin collection
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const homepageAdmin()),
            );
          } else {
            // User does not exist in either collection
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Pengguna tidak wujud dalam mana-mana koleksi'),
              ),
            );
          }
        }
      } else {
        // Resend email verification if user's email is not verified
        await userCredential.user!.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Semak emel anda untuk mengesahkan akaun anda'),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Gagal untuk Log masuk'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal untuk Log Masuk'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Image.asset(
                    'lib/images/e-thrift.png',
                  ),
                ),
                const SizedBox(height: 24),
                // Textfield Email
                buildEmail(),
                const SizedBox(height: 10),
                // Textfield Password
                buildPassword(),
                const SizedBox(height: 26),
                // TextButton Forgot Password
                Padding(
                  padding: const EdgeInsets.only(right: 25.0),
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the reset password UI
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPassword(),
                        ),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Lupa kata laluan? ",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Button login
                Container(
                  width: 280,
                  child: RawMaterialButton(
                    fillColor: const Color.fromARGB(255, 101, 13, 6),
                    elevation: 0.0,
                    padding: const EdgeInsets.all(25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onPressed: () {
                      signIn();
                    },
                    child: const Center(
                      child: Text(
                        "LOG MASUK",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterFirestorePage(),
                      ),
                    ),
                    child: const SizedBox(
                      width: 300,
                      child: Text(
                        'Daftar Sekarang!',
                        textAlign:
                            TextAlign.center, // Center the text horizontally
                        style: TextStyle(
                          fontSize: 17,
                          decoration: TextDecoration.underline,
                          color: Colors.purple, // Change color as needed
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

  // Email
  SizedBox buildEmail() {
    return SizedBox(
      width: 350,
      child: TextFormField(
        controller: _emailController,
        validator: (value) {
          if (value == "") {
            return "Sila isi alamat emel";
          }
          return null;
        },
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Emel',
          hintText: 'Masukkan alamat emel anda',
          labelStyle: const TextStyle(color: Colors.black),
          prefixIcon: const Icon(Icons.mail, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // Password
  SizedBox buildPassword() {
    return SizedBox(
      width: 350,
      child: TextFormField(
        controller: _passwordController,
        obscureText: _isObscured,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Kata Laluan',
          hintText: 'Masukkan kata laluan anda.',
          labelStyle: const TextStyle(color: Colors.black),
          prefixIcon: const Icon(Icons.lock, color: Colors.black),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _isObscured = !_isObscured;
              });
            },
            child: Icon(
              _isObscured ? Icons.visibility_off : Icons.visibility,
              color: Colors.black,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}