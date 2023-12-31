// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
    apiKey: 'AIzaSyBrkY8k8ta4gg-0vtijyqt0cRhwc5lQPJI',
    appId: '1:987919199528:web:f7ef8af59b31e00cf0b41d',
    messagingSenderId: '987919199528',
    projectId: 'zenn-trends',
    authDomain: 'zenn-trends.firebaseapp.com',
    storageBucket: 'zenn-trends.appspot.com',
    measurementId: 'G-R3JSKTDJC2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCAppC3v3UMQghJfS_sx32zeqZ9CfahNek',
    appId: '1:987919199528:android:caee4a219cd41b2df0b41d',
    messagingSenderId: '987919199528',
    projectId: 'zenn-trends',
    storageBucket: 'zenn-trends.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBozOsjj1aCkvLaAR1YKZuY2AP2PO58b7k',
    appId: '1:987919199528:ios:ce9f806e7b8b3f79f0b41d',
    messagingSenderId: '987919199528',
    projectId: 'zenn-trends',
    storageBucket: 'zenn-trends.appspot.com',
    iosBundleId: 'com.example.zennTrends',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBozOsjj1aCkvLaAR1YKZuY2AP2PO58b7k',
    appId: '1:987919199528:ios:c163cfc706c68f4ff0b41d',
    messagingSenderId: '987919199528',
    projectId: 'zenn-trends',
    storageBucket: 'zenn-trends.appspot.com',
    iosBundleId: 'com.example.zennTrends.RunnerTests',
  );
}
