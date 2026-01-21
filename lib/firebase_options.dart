// File generated manually from Firebase Console
// Replace the values below with your actual Firebase config

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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCxdT16mQbkfb1iJh1OY2IFCB19hmqT1Ek',                                    // Replace with your apiKey
    appId: '1:589461749498:web:d66f62c222578f9595d343',                                      // Replace with your appId
    messagingSenderId: '589461749498',             // Replace with your messagingSenderId
    projectId: 'nsymphony-eats-prod',                              // Replace with your projectId
    authDomain: 'nsymphony-eats-prod.firebaseapp.com',             // Replace YOUR_PROJECT_ID
    storageBucket: 'nsymphony-eats-prod.firebasestorage.app',              // Replace YOUR_PROJECT_ID
    measurementId: 'G-P0B0NP23KL',                      // Optional, replace if you have it
  );
}
