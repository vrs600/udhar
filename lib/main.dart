import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:udhar/firebase_options.dart';
import 'package:udhar/screen/btm_nav_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const BtmNavScreen(),
      theme: ThemeData(useMaterial3: false, fontFamily: "Poppins"),
    ),
  );
}
