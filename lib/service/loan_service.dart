import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:udhar/model/loan_model.dart';
import 'package:uuid/uuid.dart';

class LoanService {
  String pending = "pending";
  String _loanId = "";
  String borrowerMobileNo;
  BuildContext context;
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<String> mobileNumbers = [
    "+919876543210",
    "+918765432109",
    "+917654321098",
    "+916543210987",
    "+915432109876",
  ];

  LoanService(this.borrowerMobileNo, this.context);

  Future<bool> createLoan({
    required String borrowerMobileNo,
    required String loanAmount,
    required String dueDate,
    required String note,
  }) async {
    // todo : create loan
    // todo : OTP is remaining
    bool isLoanCreated = false;
    Uuid uuid = const Uuid();
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
      kDebugMode ? getLoanStatus() : pending,
      _auth.currentUser!.uid,
    );

    if (_auth.currentUser != null) {
      DatabaseReference loanLedgerRef =
          _firebaseDatabase.ref("app/ledger/$_loanId/loan_info");
      loanLedgerRef.set({
        "loan_id": loanModel.loanId,
        "borrower_mobile_no": loanModel.borrowerMobileNo,
        "loan_creation_date": loanModel.loanCreationDate,
        "loan_creation_time": loanModel.loanCreationTime,
        "loan_amount": loanModel.loanAmount,
        "lender_email": loanModel.lenderMobileNo,
        "due_date": loanModel.dueDate,
        "note": loanModel.note,
        "status": loanModel.status,
        "lender_id": _auth.currentUser!.uid,
      }).onError((error, stackTrace) {
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
                    label: const Text("Okay"))
              ],
            ),
          );
        }
      });
    }
    return isLoanCreated;
  }

  closeLoan() {
    // todo : close loan
  }

  getLoanStatus() {
    var randomNumber = Random().nextInt(10);
    if (randomNumber % 2 == 0) {
      return "completed";
    } else {
      return "pending";
    }
  }
}
