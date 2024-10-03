import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:udhar/model/user_model.dart';

class AuthService {
  User? user;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    User user = userCredential.user!;
    String secreteKey = generateSecreteKey();
    UserModel userModel = UserModel(
      user.uid,
      user.displayName!,
      user.email!,
      user.photoURL!,
      secreteKey,
    );

    await FirebaseDatabase.instance
        .ref("app/user/${user.uid}/personal_info/")
        .update(userModel.toMap())
        .onError(
      (error, stackTrace) {
        if (error != null) {
          if (kDebugMode) {
            print("AUTH ERROR\n${error.toString()}");
            print("AUTH STACK TRACE\n${stackTrace.toString()}");
          }
        }
      },
    );
  }

  User? getCurrentUserInfo() {
    User? user = _firebaseAuth.currentUser;

    return user;
  }

  String generateSecreteKey() {
    const chars =
        '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final random = Random.secure();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)])
        .join();
  }
}
