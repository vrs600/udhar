import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:udhar/other/styling.dart';
import 'package:udhar/screen/btm_nav_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mobileNoTEC = TextEditingController();
  final TextEditingController _otpTEC = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Styling _styling = Styling();
  User? _user;
  String countryCode = "+91";

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
      appBar: AppBar(
        leading: const Icon(Icons.login_rounded),
        automaticallyImplyLeading: false,
        title: const Text(
          "Login",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("./asset/image/ic_launcher.png"),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Udhar",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 38,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _mobileNoTEC,
                  keyboardType: TextInputType.phone,
                  decoration: _styling.getTFFInputDecoration(
                    label: 'Mobile No.',
                    textEditingController: _mobileNoTEC,
                    prefixIcon: const Icon(Icons.phone_rounded),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => onVerifyButtonPressed(),
                icon: const Icon(Icons.done_rounded),
                label: const Text("Send OTP"),
                style: _styling.getElevatedIconButtonStyle(),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            signInWithGoogle();
          },
          child: const Text("Continue with Google"),
        ),
      ),
    );
  }

  verifyMobileNo() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _mobileNoTEC.text,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        onOtpSent(verificationId, resendToken);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  onVerifyButtonPressed() {
    if (_mobileNoTEC.text.isNotEmpty) {
      verifyMobileNo();
    }
  }

  void onOtpSent(String verificationId, int? resendToken) {
    // clearing the test form field
    _otpTEC.text = "";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("OTP Verification"),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _otpTEC,
            keyboardType: TextInputType.phone,
            decoration: _styling.getTFFInputDecoration(label: 'OTP'),
          ),
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: () => verifyEnteredOTP(verificationId, resendToken),
            icon: const Icon(Icons.done_rounded),
            label: const Text("Verify"),
            style: _styling.getElevatedIconButtonStyle(),
          )
        ],
      ),
    );
  }

  verifyEnteredOTP(String verificationId, int? resendToken) async {
    // Update the UI - wait for the user to enter the SMS code
    String smsCode = _otpTEC.text;

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

  Future<UserCredential> signInWithGoogle() async {
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

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
