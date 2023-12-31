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
    apiKey: 'AIzaSyDchqmDLTHEETGZ8Y19ZxUebMG-22H9UqU',
    appId: '1:846889293282:web:e80713bd06a949401715bb',
    messagingSenderId: '846889293282',
    projectId: 'tab-animal',
    authDomain: 'tab-animal.firebaseapp.com',
    storageBucket: 'tab-animal.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB07cUjfta3NMH64kuBGZaDdgYIbdLpjBQ',
    appId: '1:846889293282:android:60e36266fad65d181715bb',
    messagingSenderId: '846889293282',
    projectId: 'tab-animal',
    storageBucket: 'tab-animal.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBfcWcik-W2AhNV2P20yjasWElkFGucfhs',
    appId: '1:846889293282:ios:ea16e69d199f52771715bb',
    messagingSenderId: '846889293282',
    projectId: 'tab-animal',
    storageBucket: 'tab-animal.appspot.com',
    iosBundleId: 'com.addong.tabAnimal',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBfcWcik-W2AhNV2P20yjasWElkFGucfhs',
    appId: '1:846889293282:ios:2c5ea7569034fa311715bb',
    messagingSenderId: '846889293282',
    projectId: 'tab-animal',
    storageBucket: 'tab-animal.appspot.com',
    iosBundleId: 'com.addong.tabAnimal.RunnerTests',
  );
}
