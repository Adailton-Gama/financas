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
    apiKey: 'AIzaSyD3VBvuiw6gG4AVy4FzgOe3LI9bLkdoFMg',
    appId: '1:41315726657:web:a6e04a92460328b3ef9dc0',
    messagingSenderId: '41315726657',
    projectId: 'supertreino-7595b',
    authDomain: 'supertreino-7595b.firebaseapp.com',
    storageBucket: 'supertreino-7595b.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDqxb1zi2TIAe5Y_MZXalqUVN4m367ep-8',
    appId: '1:41315726657:android:fd93fa27d40dd4f5ef9dc0',
    messagingSenderId: '41315726657',
    projectId: 'supertreino-7595b',
    storageBucket: 'supertreino-7595b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCqrloN4wXwkNcnribQp-dTqG_5eMspq0E',
    appId: '1:41315726657:ios:47388d2c01a2bddcef9dc0',
    messagingSenderId: '41315726657',
    projectId: 'supertreino-7595b',
    storageBucket: 'supertreino-7595b.appspot.com',
    androidClientId: '41315726657-9icmn6h3bkj03ksnb4rbtefssm7blck7.apps.googleusercontent.com',
    iosClientId: '41315726657-jl70q4od0gtsjsi8u6mj44kp9f1mge6v.apps.googleusercontent.com',
    iosBundleId: 'com.example.financas',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCqrloN4wXwkNcnribQp-dTqG_5eMspq0E',
    appId: '1:41315726657:ios:47388d2c01a2bddcef9dc0',
    messagingSenderId: '41315726657',
    projectId: 'supertreino-7595b',
    storageBucket: 'supertreino-7595b.appspot.com',
    androidClientId: '41315726657-9icmn6h3bkj03ksnb4rbtefssm7blck7.apps.googleusercontent.com',
    iosClientId: '41315726657-jl70q4od0gtsjsi8u6mj44kp9f1mge6v.apps.googleusercontent.com',
    iosBundleId: 'com.example.financas',
  );
}
