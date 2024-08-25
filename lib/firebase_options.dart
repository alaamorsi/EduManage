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
    apiKey: 'AIzaSyBslRxxPkfKDLhhDji2hjX-mEzHBCpP6pA',
    appId: '1:184729967422:web:7b60ec0a2453c86c522a6f',
    messagingSenderId: '184729967422',
    projectId: 'mr-mm-fae0b',
    authDomain: 'mr-mm-fae0b.firebaseapp.com',
    storageBucket: 'mr-mm-fae0b.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDTKmGoorBaknEer0J2ETV7O14bvM20Efw',
    appId: '1:184729967422:android:c2405c87b4cc8e06522a6f',
    messagingSenderId: '184729967422',
    projectId: 'mr-mm-fae0b',
    storageBucket: 'mr-mm-fae0b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDtnuBC5HJi7NODLQP1a-lp0YM80-OlXoU',
    appId: '1:184729967422:ios:6db9f07469a10323522a6f',
    messagingSenderId: '184729967422',
    projectId: 'mr-mm-fae0b',
    storageBucket: 'mr-mm-fae0b.appspot.com',
    iosBundleId: 'com.example.mrMm',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDtnuBC5HJi7NODLQP1a-lp0YM80-OlXoU',
    appId: '1:184729967422:ios:6db9f07469a10323522a6f',
    messagingSenderId: '184729967422',
    projectId: 'mr-mm-fae0b',
    storageBucket: 'mr-mm-fae0b.appspot.com',
    iosBundleId: 'com.example.mrMm',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBslRxxPkfKDLhhDji2hjX-mEzHBCpP6pA',
    appId: '1:184729967422:web:f416c4713b334862522a6f',
    messagingSenderId: '184729967422',
    projectId: 'mr-mm-fae0b',
    authDomain: 'mr-mm-fae0b.firebaseapp.com',
    storageBucket: 'mr-mm-fae0b.appspot.com',
  );
}