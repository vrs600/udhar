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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBJwOBS-IPWerXZrfFxNpjUejoilbfyChk',
    appId: '1:1007664513257:android:4f6f2803ba6089c2d23078',
    messagingSenderId: '1007664513257',
    projectId: 'udhar-de160',
    databaseURL: 'https://udhar-de160-default-rtdb.firebaseio.com',
    storageBucket: 'udhar-de160.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAkH7gXw_7T4roqRi2VKjnXPdJeLZJT0q4',
    appId: '1:1007664513257:ios:b857a2153852d968d23078',
    messagingSenderId: '1007664513257',
    projectId: 'udhar-de160',
    databaseURL: 'https://udhar-de160-default-rtdb.firebaseio.com',
    storageBucket: 'udhar-de160.appspot.com',
    androidClientId: '1007664513257-a04onte16qsc5slvr6sfoo0j4pr2ur9r.apps.googleusercontent.com',
    iosClientId: '1007664513257-csgko710q8a2je1pt9kjdsfvt32iv9mh.apps.googleusercontent.com',
    iosBundleId: 'com.android.udhar',
  );

}