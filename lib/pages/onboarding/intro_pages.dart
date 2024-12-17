import 'package:flutter/material.dart';
import 'package:ethriftukm_fyp/pages/onboarding/registerFirestore.dart';
import 'login.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Image.asset(
                  'lib/images/e-thrift.png',
                ),
              ),
              const Text(
                'PRELOVED IS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              const Text(
                'RELOVED',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Mencari tawaran terbaik untuk barangan terpakai',
                style: TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                'Kami disini untuk membantu anda !',
                style: TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              GestureDetector(
                  onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      ),
                  child: SizedBox(
                    width: 280,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 101, 13, 6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(25),
                      child: const Center(
                        child: Text(
                          'LOG MASUK',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  )),
              const SizedBox(height: 30),
              const Text(
                'Masih Tiada Akaun?',
                style: TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
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
                      'Daftar Disini !',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        decoration: TextDecoration.underline,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
