import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:udhar/model/loan_model.dart';
import 'package:udhar/other/styling.dart';
import 'package:uuid/uuid.dart';

class LoanStatus {
  static const String paid = "paid";
  static const String pending = "completed";
  static const String partiallyPaid = "partially_paid";
}

class LoanService {
  String pending = "pending";
  String _loanId = "";
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<LoanModel> _loanModelList = [];
  Styling styling = Styling();
  int? chipSelectedIndex = 0;

  final List<String> mobileNumbers = [
    "+919876543210",
    "+918765432109",
    "+917654321098",
    "+916543210987",
    "+915432109876",
  ];

  Future<bool> createLoan({
    required String borrowerMobileNo,
    required String loanAmount,
    required String dueDate,
    required String note,
    required BuildContext context,
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Loan created"),
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
          snapshot.child("loan_info").child("due_date").value.toString(),
          snapshot.child("loan_info").child("note").value.toString(),
          snapshot.child("loan_info").child("status").value.toString(),
          snapshot.child("loan_info").child("lender_id").value.toString(),
        ),
      );
    }
    return _loanModelList;
  }
}
