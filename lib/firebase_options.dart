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
    apiKey: 'AIzaSyBQx2RstuydswMLoD00fkTHHCiUHdldAqQ',
    appId: '1:780979866129:web:63bdb92abddf68770e7fb0',
    messagingSenderId: '780979866129',
    projectId: 'asset-management-909aa',
    authDomain: 'asset-management-909aa.firebaseapp.com',
    storageBucket: 'asset-management-909aa.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA8sUELn8Xh5sGCPhT0H4F5g2X9TGluCn8',
    appId: '1:780979866129:android:1e3c9f507de4f3460e7fb0',
    messagingSenderId: '780979866129',
    projectId: 'asset-management-909aa',
    storageBucket: 'asset-management-909aa.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDIXOADYOJYq8EetT88dF8HbP9XGDQQjy0',
    appId: '1:780979866129:ios:c3a562aa7d2834650e7fb0',
    messagingSenderId: '780979866129',
    projectId: 'asset-management-909aa',
    storageBucket: 'asset-management-909aa.appspot.com',
    iosBundleId: 'com.example.assetApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDIXOADYOJYq8EetT88dF8HbP9XGDQQjy0',
    appId: '1:780979866129:ios:07292cb2e226ded70e7fb0',
    messagingSenderId: '780979866129',
    projectId: 'asset-management-909aa',
    storageBucket: 'asset-management-909aa.appspot.com',
    iosBundleId: 'com.example.assetApp.RunnerTests',
  );
}
