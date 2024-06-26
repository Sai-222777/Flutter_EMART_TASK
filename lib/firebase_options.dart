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
    apiKey: 'AIzaSyAlxSwaCH2n8tgKTif-T2tKlpnS3oUlFbM',
    appId: '1:344764567081:web:40f1c873404dc3e2bcd638',
    messagingSenderId: '344764567081',
    projectId: 'e-mart-task1',
    authDomain: 'e-mart-task1.firebaseapp.com',
    storageBucket: 'e-mart-task1.appspot.com',
    measurementId: 'G-XB27T10RTX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDjatB9i6tMd5HKrBJmAtRdnkmeTp562X0',
    appId: '1:344764567081:android:82fa40dca30dfde9bcd638',
    messagingSenderId: '344764567081',
    projectId: 'e-mart-task1',
    storageBucket: 'e-mart-task1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCffW9aas_BZ6QOaKAo8XHfs8Qg0iUa_UE',
    appId: '1:344764567081:ios:5c47f0be55b0fc7bbcd638',
    messagingSenderId: '344764567081',
    projectId: 'e-mart-task1',
    storageBucket: 'e-mart-task1.appspot.com',
    iosBundleId: 'com.example.emart',
  );
}
