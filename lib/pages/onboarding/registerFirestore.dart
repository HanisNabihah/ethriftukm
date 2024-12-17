import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ethriftukm_fyp/pages/onboarding/login.dart';

class RegisterFirestorePage extends StatefulWidget {
  static const routeName = "/registerPage";

  const RegisterFirestorePage({Key? key}) : super(key: key);

  @override
  _RegisterFirestorePageState createState() => _RegisterFirestorePageState();
}

class _RegisterFirestorePageState extends State<RegisterFirestorePage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _collegeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _collegeController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();

    super.dispose();
  }

  Future<void> register() async {
    String username = _usernameController.text.trim();
    String phone = _phoneNumberController.text.trim();
    String email = _emailController.text.trim();
    String college = _collegeController.text.trim();
    String password = _passwordController.text.trim();

    if (!passwordConfirmed()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kata Laluan tidak sepadan.'),
          duration: Duration(seconds: 5),
        ),
      );
      return;
    }

    final emailRegex = RegExp(r'^[^\s@]+@(siswa.ukm.edu.my|ukm.edu.my)$');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Sila masukkan alamat emel yang sah dengan @siswa.ukm.edu.my atau @ukm.edu.my .'),
          duration: Duration(seconds: 5),
        ),
      );
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      CollectionReference users =
          FirebaseFirestore.instance.collection('Users');
      await users.doc(userCredential.user!.uid).set({
        'username': username,
        'phone': phone,
        'email': email,
        'college': college,
        'profileImageUrl': "",
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal untuk mendaftar: $error'),
        ),
      );
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

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sila masukkan alamat emel'),
        ),
      );
      return null;
    }

    final emailRegex = RegExp(r'^[^\s@]+@(siswa.ukm.edu.my|ukm.edu.my)$');
    if (!emailRegex.hasMatch(value)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Sila masukkan alamat emel yang sah dengan @siswa.ukm.edu.my atau @ukm.edu.my .'),
        ),
      );
      return null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _registerFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Image.asset(
                    'lib/images/e-thrift.png',
                    height: 300,
                  ),
                ),
                buildUsername(),
                const SizedBox(height: 10),
                buildPhoneNumber(),
                const SizedBox(height: 10),
                buildEmail(),
                const SizedBox(height: 10),
                buildCollege(),
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
                        "DAFTAR AKAUN",
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
      ),
    );
  }

  SizedBox buildUsername() {
    return SizedBox(
      width: 380,
      child: TextFormField(
        controller: _usernameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Nama Pengguna',
          hintText: 'Nama',
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

  SizedBox buildPhoneNumber() {
    return SizedBox(
      width: 380,
      child: TextFormField(
        controller: _phoneNumberController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'No Telefon',
          hintText: 'No Telefon',
          labelStyle: const TextStyle(color: Colors.black),
          prefixIcon: const Icon(Icons.phone, color: Colors.black),
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
      width: 380,
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        validator: validateEmail,
        decoration: InputDecoration(
          labelText: 'Emel',
          hintText: 'Masukkan alamat emel anda',
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

  SizedBox buildCollege() {
    return SizedBox(
        width: 380,
        child: TextFormField(
          controller: _collegeController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: 'Kolej',
            hintText: 'eg: KPZ',
            labelStyle: const TextStyle(color: Colors.black),
            prefixIcon: const Icon(Icons.school, color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onTap: () {
            FocusScope.of(context).unfocus();
          },
        ));
  }

  SizedBox buildPassword() {
    return SizedBox(
        width: 380,
        child: TextFormField(
          controller: _passwordController,
          obscureText: true,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: 'Kata Laluan',
            hintText: 'Masukkan kata laluan.',
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
        width: 380,
        child: TextFormField(
          controller: _passwordConfirmController,
          obscureText: true,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: 'Sahkan Kata Laluan',
            hintText: 'Sahkan kata Laluan anda.',
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
