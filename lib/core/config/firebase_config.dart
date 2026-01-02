import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseConfig {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return _webOptions;
    }
    throw UnsupportedError('Platform not supported');
  }

  static const FirebaseOptions _webOptions = FirebaseOptions(
    apiKey: 'AIzaSyDemoKey-ReplaceWithYourActualKey',
    appId: '1:123456789:web:abcdef123456',
    messagingSenderId: '123456789',
    projectId: 'sakhipath-demo',
    authDomain: 'sakhipath-demo.firebaseapp.com',
    storageBucket: 'sakhipath-demo.appspot.com',
    measurementId: 'G-ABCDEFGH',
  );
}
