import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Image.asset(
                  'lib/images/e-thrift.png',
                  //height: 240,
                ),
              ),

              // text RESET PASSWORD
              const Text(
                'Lupa Kata Laluan?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 30),

              //textfield Email
              buildEmail(),

              const SizedBox(height: 30),

              //button reset password
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
                    _resetPassword();
                  },
                  child: const Center(
                    child: Text(
                      "HANTAR",
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

  // function Email
  // function Email
  SizedBox buildEmail() {
    return SizedBox(
      width: 350, // Adjust the width as needed
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'Emel',
          hintText: 'Sila Masukkan alamat emel',
          labelStyle: const TextStyle(color: Colors.black),
          prefixIcon: const Icon(Icons.mail, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          // You can add more styling here if needed
        ),
      ),
    );
  }

  // Function to reset password
  Future<void> _resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      // Show a success message or navigate to a success page
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset email sent. Please check your email.'),
          duration: Duration(seconds: 5),
        ),
      );

      // Navigate to the login page after showing the success message
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (error) {
      // Show an error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send password reset email. $error'),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }
}
