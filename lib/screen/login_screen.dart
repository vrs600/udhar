import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:udhar/other/styling.dart';
import 'package:udhar/screen/btm_nav_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController mobileNoTEC = TextEditingController();
  TextEditingController otpTEC = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;

    if (_user != null) {
      // user is logged in
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const BtmNavScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: mobileNoTEC,
                  keyboardType: TextInputType.phone,
                  decoration: Styling.getTFFInputDecoration(),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => onVerifyButtonPressed(),
                icon: const Icon(Icons.done_rounded),
                label: const Text("Send OTP"),
                style: Styling.getElevatedIconButtonStyle(),
              )
            ],
          ),
        ),
      ),
    );
  }

  verifyMobileNo() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: mobileNoTEC.text,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        onOtpSent(verificationId, resendToken);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  onVerifyButtonPressed() {
    if (mobileNoTEC.text.isNotEmpty) {
      verifyMobileNo();
    }
  }

  void onOtpSent(String verificationId, int? resendToken) {
    // clearing the test form field
    otpTEC.text = "";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("OTP Verification"),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: otpTEC,
            keyboardType: TextInputType.phone,
            decoration: Styling.getTFFInputDecoration(),
          ),
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: () => verifyEnteredOTP(verificationId, resendToken),
            icon: const Icon(Icons.done_rounded),
            label: const Text("Verify"),
            style: Styling.getElevatedIconButtonStyle(),
          )
        ],
      ),
    );
  }

  verifyEnteredOTP(String verificationId, int? resendToken) async {
    // Update the UI - wait for the user to enter the SMS code
    String smsCode = otpTEC.text;

    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);

    // Sign the user in (or link) with the credential
    await _auth.signInWithCredential(credential).then((value) => {
          // after successful verification user will be navigated to the home screen
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BtmNavScreen(),
              ))
        });
  }
}
