import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:udhar/other/styling.dart';
import 'package:udhar/service/loan_service.dart';

class LoanKeyScreen extends StatefulWidget {
  const LoanKeyScreen({super.key});

  @override
  State<LoanKeyScreen> createState() => _LoanKeyScreenState();
}

class _LoanKeyScreenState extends State<LoanKeyScreen> {
  String _secreteKey = "";
  LoanService loanService = LoanService();
  final _loanFormKey = GlobalKey<FormState>();
  final Styling _styling = Styling();
  bool _showSecretKey = false;
  String _showSecreteKeyButtonText = "Show Secret Key";
  TextEditingController secreteKeyTEC = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _showProgIndicator = true;

  @override
  void initState() {
    super.initState();
    loanService.updateSecreteKey().then(
      (value) {
        loanService.getCurrentUserSecreteKey().then(
          (secreteKey) {
            setState(() {
              _secreteKey = secreteKey;
              secreteKeyTEC.text = "******";
              _showProgIndicator = false;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("User Secret Key"),
          leading: const Icon(LucideIcons.keyRound),
        ),
        body: Stack(
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 250,
                      height: 250,
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PrettyQrView.data(
                            data: _secreteKey,
                            decoration: const PrettyQrDecoration(
                              image: PrettyQrDecorationImage(
                                image:
                                    AssetImage('./asset/image/ic_launcher.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("---------- OR ----------"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: TextStyle(
                        color: Colors.black
                            .withOpacity(0.5), // Adjust opacity as needed
                      ),
                      controller: secreteKeyTEC,
                      keyboardType: TextInputType.visiblePassword,
                      maxLines: null,
                      decoration: _styling.getTFFInputDecoration(
                        label: 'SECRETE KEY',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (_showSecretKey) {
                          _showSecreteKeyButtonText = "Hide Secrete Key";
                          _showSecretKey = false;
                          secreteKeyTEC.text = "******";
                        } else {
                          _showSecreteKeyButtonText = "Show Secrete Key";
                          _showSecretKey = true;
                          secreteKeyTEC.text = _secreteKey;
                        }
                      });
                    },
                    child: Text(_showSecreteKeyButtonText),
                  ),
                ],
              ),
            ),
            Center(
              child: Visibility(
                visible: _showProgIndicator,
                child: const CircularProgressIndicator(),
              ),
            ),
          ],
        ));
  }
}
