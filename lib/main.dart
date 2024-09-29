import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:udhar/firebase_options.dart';
import 'package:udhar/screen/login_screen.dart';
import 'package:udhar/screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: "Poppins",
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
        ),
      ),
    ),
  );
}

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await dotenv.load(fileName: "../.env");
//
//   if (Platform.isAndroid) {
//     await Firebase.initializeApp(
//       name: "udhar",
//       options: FirebaseOptions(
//         databaseURL: dotenv.get("ANDROID_DATABASE_URL", fallback: "NULL"),
//         apiKey: dotenv.get("ANDROID_API_KEY", fallback: "NULL"),
//         appId: dotenv.get("ANDROID_APP_ID", fallback: "NULL"),
//         messagingSenderId:
//             dotenv.get("ANDROID_MESSAGING_SENDER_ID", fallback: "NULL"),
//         projectId: dotenv.get("ANDROID_PROJECT_ID", fallback: "NULL"),
//         storageBucket: dotenv.get("ANDROID_STORAGE_BUCKET", fallback: "NULL"),
//       ),
//     );
//   } else {
//     await Firebase.initializeApp(
//       options: FirebaseOptions(
//         iosClientId: dotenv.get("IOS_CLIENT_ID", fallback: "NULL"),
//         iosBundleId: dotenv.get("IOS_BUNDLE_ID", fallback: "NULL"),
//         apiKey: dotenv.get("IOS_API_KEY", fallback: "NULL"),
//         appId: dotenv.get("IOS_APP_ID", fallback: "NULL"),
//         messagingSenderId:
//             dotenv.get("IOS_MESSAGING_SENDER_ID", fallback: "NULL"),
//         projectId: dotenv.get("IOS_PROJECT_ID", fallback: "NULL"),
//         storageBucket: dotenv.get("IOS_STORAGE_BUCKET", fallback: "NULL"),
//       ),
//     );
//   }
//
//   runApp(
//     MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: const BtmNavScreen(),
//       theme: ThemeData(useMaterial3: true, fontFamily: "Poppins"),
//     ),
//   );
// }
