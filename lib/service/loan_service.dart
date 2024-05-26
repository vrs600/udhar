import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:udhar/model/loan_model.dart';
import 'package:uuid/uuid.dart';

class LoanService {
  String? loanId;
  String borrowerMobileNo;
  BuildContext context;
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LoanService(this.borrowerMobileNo, this.context);

  createLoan({
    required String borrowerMobileNo,
    required String loanAmount,
    required String dueDate,
    required String note,
  }) async {
    // todo : create loan
    // todo : OTP is remaining
    Uuid uuid = const Uuid();
    String loanId = uuid.v4();
    DateTime dateTime = DateTime.now();
    String? currentUserMobileNumber = _auth.currentUser!.phoneNumber;

    LoanModel loanModel = LoanModel(
        loanId,
        borrowerMobileNo,
        "${dateTime.day.toString()}/${dateTime.month.toString()}/${dateTime.year.toString()}",
        "${dateTime.hour.toString()}:${dateTime.minute.toString()}",
        double.parse(loanAmount),
        currentUserMobileNumber!,
        3,
        note);

    if (_auth.currentUser != null) {
      String? currentUserMobileNo = _auth.currentUser!.phoneNumber;
      FirebaseDatabase.instance.ref("").set({});
      DatabaseReference loanLedgerRef = _firebaseDatabase
          .ref("app/ledger/$currentUserMobileNo/$loanId/loan_info");
      await loanLedgerRef.set({
        "loan_id": loanModel.loanId,
        "borrower_mobile_no": loanModel.borrowerMobileNo,
        "loan_creation_date": loanModel.loanCreationDate,
        "loan_creation_time": loanModel.loanCreationTime,
        "loan_amount": loanModel.loanAmount,
        "lender_mobile_no": loanModel.lenderMobileNo,
        "duration_in_month": loanModel.durationInMonth,
        "note": loanModel.note,
      }).onError((error, stackTrace) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: Text(kDebugMode
                ? error.toString()
                : "Can't create your at this moment. Please try again later."),
            actions: [
              ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.done_rounded),
                  label: const Text("Okay"))
            ],
          ),
        );
      }).then((value) {
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
      });
    }
  }

  closeLoan() {
    // todo : close loan
  }
}
