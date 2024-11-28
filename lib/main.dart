import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'pages/onboarding/intro_pages.dart';

import 'package:ethriftukm_fyp/pages/products/LikesProductProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => LikedProductsProviderPage(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: MainMenuPage(), //ni baru
      home: IntroPage(),
    );
  }
}
