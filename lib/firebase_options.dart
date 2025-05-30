// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return android;
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
    apiKey: 'AIzaSyBvF1GtwUJgWFVNqr9u5Vu0TDz1XbZg8iA',
    appId: '1:5889685606:web:fb04c317bfb41d984195a7',
    messagingSenderId: '5889685606',
    projectId: 'geogssr-9a43c',
    authDomain: 'geogssr-9a43c.firebaseapp.com',
    storageBucket: 'geogssr-9a43c.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD8G6fAKC_F8x-ecaiNT4o7F_M-nyp01vU',
    appId: '1:5889685606:android:ac36d8fa2f8618f34195a7',
    messagingSenderId: '5889685606',
    projectId: 'geogssr-9a43c',
    storageBucket: 'geogssr-9a43c.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBvF1GtwUJgWFVNqr9u5Vu0TDz1XbZg8iA',
    appId: '1:5889685606:web:a07a74d8dc22b7cb4195a7',
    messagingSenderId: '5889685606',
    projectId: 'geogssr-9a43c',
    authDomain: 'geogssr-9a43c.firebaseapp.com',
    storageBucket: 'geogssr-9a43c.appspot.com',
  );
}
