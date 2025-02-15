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
    apiKey: 'AIzaSyC85FHjCh4FF_nh4iCR-jQ5CEHf7ct3oNA',
    appId: '1:294363315729:web:e0167213b3ca00a3197bb0',
    messagingSenderId: '294363315729',
    projectId: 'chatapp-d9f9e',
    authDomain: 'chatapp-d9f9e.firebaseapp.com',
    storageBucket: 'chatapp-d9f9e.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDku5bxswT_q2dyb733r7W7MJ3dZN-ESrU',
    appId: '1:294363315729:android:d8bc269690d254b3197bb0',
    messagingSenderId: '294363315729',
    projectId: 'chatapp-d9f9e',
    storageBucket: 'chatapp-d9f9e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyChM3MTkwEfMksQ2abY_d-dwrnZDYhF85o',
    appId: '1:294363315729:ios:428842a818bb4d6d197bb0',
    messagingSenderId: '294363315729',
    projectId: 'chatapp-d9f9e',
    storageBucket: 'chatapp-d9f9e.appspot.com',
    iosBundleId: 'com.example.chatapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyChM3MTkwEfMksQ2abY_d-dwrnZDYhF85o',
    appId: '1:294363315729:ios:c3e381e8080205fb197bb0',
    messagingSenderId: '294363315729',
    projectId: 'chatapp-d9f9e',
    storageBucket: 'chatapp-d9f9e.appspot.com',
    iosBundleId: 'com.example.chatapp.RunnerTests',
  );
}
