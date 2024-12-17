import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAQgOh6UOgMTHY8aG6Dkl1CNKx9_chIk0c',
    appId: '1:637440390668:web:ebb1a20a76a341f3f9a029',
    messagingSenderId: '637440390668',
    projectId: 'ethriftukms',
    authDomain: 'ethriftukms.firebaseapp.com',
    storageBucket: 'ethriftukms.appspot.com',
    measurementId: 'G-KY5WQ02LX0',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDIt9bkVHhQm_rhL1Asx31IRiuOzY_SCSU',
    appId: '1:637440390668:ios:c1da47dc3f56ef46f9a029',
    messagingSenderId: '637440390668',
    projectId: 'ethriftukms',
    storageBucket: 'ethriftukms.appspot.com',
    iosBundleId: 'com.example.ethriftukmFyp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDIt9bkVHhQm_rhL1Asx31IRiuOzY_SCSU',
    appId: '1:637440390668:ios:c1da47dc3f56ef46f9a029',
    messagingSenderId: '637440390668',
    projectId: 'ethriftukms',
    storageBucket: 'ethriftukms.appspot.com',
    iosBundleId: 'com.example.ethriftukmFyp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAQgOh6UOgMTHY8aG6Dkl1CNKx9_chIk0c',
    appId: '1:637440390668:web:678050c3afbdc630f9a029',
    messagingSenderId: '637440390668',
    projectId: 'ethriftukms',
    authDomain: 'ethriftukms.firebaseapp.com',
    storageBucket: 'ethriftukms.appspot.com',
    measurementId: 'G-3JZ2KFBXH4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBwR58kKS0zOaduV_GzXPW2jLwzR0KmSeI',
    appId: '1:637440390668:android:0d35e13f1ba77157f9a029',
    messagingSenderId: '637440390668',
    projectId: 'ethriftukms',
    storageBucket: 'ethriftukms.appspot.com',
  );
}
