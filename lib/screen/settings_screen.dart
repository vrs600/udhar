import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:udhar/other/styling.dart';
import 'package:udhar/screen/about_app_screen.dart';
import 'package:udhar/screen/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Styling _styling = Styling();

  final TextEditingController _phoneNoTEC = TextEditingController();
  User? _user;
  String _currentUserPhoneNo = "";
  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _currentUserPhoneNo = _user!.email!;
    _phoneNoTEC.text = _currentUserPhoneNo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.settings_rounded),
        automaticallyImplyLeading: false,
        title: const Text(
          "Settings",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 70,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: _searchBox(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2),
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
            Padding(
              padding: const EdgeInsets.all(2),
              child: ListTile(
                onTap: () => _onAppInfoClicked(),
                leading: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutAppScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.info_outline_rounded,
                    color: Colors.black,
                  ),
                ),
                title: const Text(
                  "About App",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("Vision & App Info"),
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

  _onAppInfoClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AboutAppScreen(),
      ),
    );
  }

  _searchBox() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: _phoneNoTEC,
      onChanged: (searchQuery) {
        // here search query is the phone no.
      },
      minLines: 1,
      decoration: _styling.getTFFInputDecoration(
        label: "Email",
        prefixIcon: const Icon(Icons.email_rounded),
      ),
    );
  }
}
