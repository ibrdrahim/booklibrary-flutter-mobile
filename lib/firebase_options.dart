// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyATdFAQQ059rDaYlhZVzCY6RFWJaaK2hlg',
    appId: '1:241715499127:web:e8f78209c09197b349f672',
    messagingSenderId: '241715499127',
    projectId: 'booklibrary-flutterflow-dev',
    authDomain: 'booklibrary-flutterflow-dev.firebaseapp.com',
    databaseURL: 'https://booklibrary-flutterflow-dev-default-rtdb.firebaseio.com',
    storageBucket: 'booklibrary-flutterflow-dev.appspot.com',
    measurementId: 'G-SG0SBXYXBD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyARKL0ub9goKs-5uEm-OOmIo_of4Dlzhh0',
    appId: '1:241715499127:android:49ddb514e52d035349f672',
    messagingSenderId: '241715499127',
    projectId: 'booklibrary-flutterflow-dev',
    databaseURL: 'https://booklibrary-flutterflow-dev-default-rtdb.firebaseio.com',
    storageBucket: 'booklibrary-flutterflow-dev.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBT6gv9DM7j0RGzMu3Sd3NJYEiIj5u1l3Y',
    appId: '1:241715499127:ios:0f15d5e34de80c7c49f672',
    messagingSenderId: '241715499127',
    projectId: 'booklibrary-flutterflow-dev',
    databaseURL: 'https://booklibrary-flutterflow-dev-default-rtdb.firebaseio.com',
    storageBucket: 'booklibrary-flutterflow-dev.appspot.com',
    iosBundleId: 'com.example.flutterBooklibrary',
  );

}