import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:udhar/other/styling.dart';
import 'package:udhar/screen/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Styling styling = Styling();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Settings"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(2),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(styling.borderRadius),
                ),
                child: ListTile(
                  onTap: () => _onLogOutSelected(),
                  leading: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: Colors.black,
                    ),
                  ),
                  title: const Text(
                    "Log Out",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text("Log out from Udhar App"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(styling.borderRadius),
                ),
                child: ListTile(
                  onTap: () => _onAppInfoClicked(),
                  leading: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.info_outline_rounded,
                      color: Colors.black,
                    ),
                  ),
                  title: const Text(
                    "About App",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text("Vision, Terms & Conditions, App Info"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _onLogOutSelected() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Log Out",
        ),
        content: const Text("Are you sure that you want to log out?"),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              _auth.signOut().then((value) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false);
              });
            },
            icon: const Icon(Icons.done_rounded),
            label: const Text("Yes"),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close_rounded),
            label: const Text("No"),
          )
        ],
      ),
    );
  }

  _onAppInfoClicked() {}
}
