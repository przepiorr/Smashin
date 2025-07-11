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
    apiKey: 'AIzaSyAJYAu8pfQpPEg_XB54JPTt6M5e-gVpgD8',
    appId: '1:368488960916:web:cd485be14b947eb37eb581',
    messagingSenderId: '368488960916',
    projectId: 'smashin-b2ee8',
    authDomain: 'smashin-b2ee8.firebaseapp.com',
    storageBucket: 'smashin-b2ee8.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBD8Px1Fhw7T_90Pdl6cDaICWkah1Aw2Tc',
    appId: '1:368488960916:android:0ee10274ae68c7197eb581',
    messagingSenderId: '368488960916',
    projectId: 'smashin-b2ee8',
    storageBucket: 'smashin-b2ee8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDOw45S2Aq9PcdKfY8Uj-8jLgWB9uzqX2I',
    appId: '1:368488960916:ios:9155b030537692cf7eb581',
    messagingSenderId: '368488960916',
    projectId: 'smashin-b2ee8',
    storageBucket: 'smashin-b2ee8.appspot.com',
    iosBundleId: 'com.example.smashinfluter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDOw45S2Aq9PcdKfY8Uj-8jLgWB9uzqX2I',
    appId: '1:368488960916:ios:9155b030537692cf7eb581',
    messagingSenderId: '368488960916',
    projectId: 'smashin-b2ee8',
    storageBucket: 'smashin-b2ee8.appspot.com',
    iosBundleId: 'com.example.smashinfluter',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAJYAu8pfQpPEg_XB54JPTt6M5e-gVpgD8',
    appId: '1:368488960916:web:560ac78fd8e762bd7eb581',
    messagingSenderId: '368488960916',
    projectId: 'smashin-b2ee8',
    authDomain: 'smashin-b2ee8.firebaseapp.com',
    storageBucket: 'smashin-b2ee8.appspot.com',
  );
}
