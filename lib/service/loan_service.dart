import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:udhar/model/loan_model.dart';
import 'package:udhar/other/styling.dart';
import 'package:uuid/uuid.dart';

class LoanStatus {
  static const String paid = "paid";
  static const String pending = "pending";
  static const String partiallyPaid = "partially_paid";
  static const String closed = "closed";
  static const String completed = "completed";
}

class LoanService {
  String pending = "pending";
  String _loanId = "";
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<LoanModel> _loanModelList = [];
  Styling styling = Styling();
  int? chipSelectedIndex = 0;
  Uuid uuid = const Uuid();
  DatabaseReference _reference = FirebaseDatabase.instance.ref();
  final List<String> mobileNumbers = [
    "+919876543210",
    "+918765432109",
    "+917654321098",
    "+916543210987",
    "+915432109876",
  ];

  LoanService() {}

  Future<bool> createLoan({
    required String borrowerMobileNo,
    required String loanAmount,
    required String dueDate,
    required String note,
    required BuildContext context,
  }) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    bool isLoanCreated = false;

    _loanId = uuid.v4();
    DateTime dateTime = DateTime.now();
    String? currentUserMobileNumber = _auth.currentUser!.email;

    LoanModel loanModel = LoanModel(
      _loanId,
      borrowerMobileNo,
      "${dateTime.day.toString()}/${dateTime.month.toString()}/${dateTime.year.toString()}",
      "${dateTime.hour.toString()}:${dateTime.minute.toString()}",
      double.parse(loanAmount),
      currentUserMobileNumber!,
      dueDate,
      note,
      LoanStatus.pending,
      _auth.currentUser!.uid,
      timestamp.toString(),
    );

    if (_auth.currentUser != null) {
      DatabaseReference loanLedgerRef =
          _firebaseDatabase.ref("app/ledger/$_loanId/loan_info");
      loanLedgerRef.set(loanModel.toMap()).onError((error, stackTrace) {
        isLoanCreated = false;

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: Text(kDebugMode
                ? error.toString()
                : "Can't create your loan at this moment. Please try again later."),
            actions: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.done_rounded),
                label: const Text("Okay"),
              )
            ],
          ),
        );
      }).then((value) {
        isLoanCreated = true;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Loan Created"),
            content: Text("Your loan is recorded with ID: ${loanModel.loanId}"),
            actions: [
              ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.done_rounded),
                  label: const Text("Okay"))
            ],
          ),
        );
        if (!kDebugMode) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Loan Created"),
              content:
                  Text("Your loan is recorded with ID: ${loanModel.loanId}"),
              actions: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.done_rounded),
                  label: const Text("Okay"),
                )
              ],
            ),
          );
        }
      });
    }
    return isLoanCreated;
  }

  closeLoan({
    required String loanId,
    required BuildContext context,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Close Loan"),
        content: const Text("Are you sure that you want to close the loan?"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _firebaseDatabase.ref("app/ledger/$loanId/loan_info").update({
                "loan_amount": 0,
                "status": LoanStatus.completed,
              }).then(
                (value) {
                  if (kDebugMode) {
                    print("[updateLoan] : LOAN AMOUNT UPDATED");
                  }
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      icon:
                          Lottie.asset("./asset/animation/done_animation.json"),
                      title: const Text("Loan Closed"),
                      content: const Text("Selected loan closed successfully"),
                      actions: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.done_rounded),
                          label: const Text("Okay"),
                        )
                      ],
                    ),
                  );
                },
              );
            },
            child: const Text("Yes"),
          )
        ],
      ),
    );
  }

  getLoanStatus() {
    var randomNumber = Random().nextInt(10);
    if (randomNumber % 2 == 0) {
      return LoanStatus.paid;
    } else {
      return LoanStatus.pending;
    }
  }

  Future<List<LoanModel>> getLoanList() async {
    _loanModelList.clear();
    DataSnapshot loanListSnapshot =
        await _firebaseDatabase.ref("app/ledger").get();

    for (DataSnapshot snapshot in loanListSnapshot.children) {
      if (kDebugMode) {
        snapshot.value.toString();
      }
      _loanModelList.add(
        LoanModel(
          snapshot.child("loan_info").child("loan_id").value.toString(),
          snapshot
              .child("loan_info")
              .child("borrower_mobile_no")
              .value
              .toString(),
          snapshot
              .child("loan_info")
              .child("loan_creation_date")
              .value
              .toString(),
          snapshot
              .child("loan_info")
              .child("loan_creation_time")
              .value
              .toString(),
          double.parse(snapshot
              .child("loan_info")
              .child("loan_amount")
              .value
              .toString()),
          snapshot
              .child("loan_info")
              .child("lender_mobile_no")
              .value
              .toString(),
          snapshot.child("loan_info").child("loan_date").value.toString(),
          snapshot.child("loan_info").child("note").value.toString(),
          snapshot.child("loan_info").child("status").value.toString(),
          snapshot.child("loan_info").child("lender_id").value.toString(),
          snapshot.child("loan_info").child("timestamp").value.toString(),
        ),
      );
    }
    return _loanModelList;
  }

  Future<String> getCurrentUserSecreteKey() async {
    DataSnapshot snapshot = await _firebaseDatabase
        .ref("app/user/${_auth.currentUser!.uid}/personal_info/")
        .get();

    if (kDebugMode) {
      print("getCurrentUserSecreteKey() : ${snapshot.value.toString()}");
    }

    String secreteKey = snapshot.child("secrete_key").value.toString();
    return secreteKey;
  }

  Future<void> updateSecreteKey() async {
    String secreteKey = generateSecreteKey();
    _firebaseDatabase
        .ref("app/user/${_auth.currentUser!.uid}/personal_info/")
        .update({
      "secrete_key": secreteKey,
    });
  }

  String generateSecreteKey() {
    String chars =
        '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    Random random = Random.secure();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  void updateLoan({
    required String loanId,
    required double updatedLoanAmount,
    required String updatedNotes,
    required String updatedLoanDate,
    required BuildContext context,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update Loan"),
        content: const Text("Are you sure that you want to update the loan?"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
              onPressed: () {
                _reference =
                    _firebaseDatabase.ref("app/ledger/$loanId/loan_info");
                _reference.update({
                  "loan_amount": updatedLoanAmount,
                  "loan_date": updatedLoanDate,
                  "note": updatedNotes,
                  "status": (updatedLoanAmount == 0)
                      ? LoanStatus.paid
                      : LoanStatus.pending,
                }).then(
                  (value) {
                    Navigator.pop(context);
                    if (kDebugMode) {
                      print("[updateLoan] : LOAN AMOUNT UPDATED");
                    }
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Loan Updated"),
                        content:
                            const Text("Your loan are updated successfully"),
                        actions: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.done_rounded),
                            label: const Text("Okay"),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
              child: const Text("Yes")),
        ],
      ),
    );
  }
}
