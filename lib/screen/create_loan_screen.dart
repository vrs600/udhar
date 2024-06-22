import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:udhar/other/dummy_values_generator.dart';
import 'package:udhar/other/styling.dart';
import 'package:udhar/service/loan_service.dart';

class CreateLoanScreen extends StatefulWidget {
  const CreateLoanScreen({super.key});

  @override
  State<CreateLoanScreen> createState() => _CreateLoanScreenState();
}

class _CreateLoanScreenState extends State<CreateLoanScreen> {
  final TextEditingController _dueDateTEC = TextEditingController();
  final TextEditingController _loanAmountTEC = TextEditingController();
  final TextEditingController _mobileNoTEC = TextEditingController();
  final TextEditingController _noteTEC = TextEditingController();

  final _loanFormKey = GlobalKey<FormState>();
  Styling styling = Styling();

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      // entering dummy values in the text fields
      fillDummyValues();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: null,
        automaticallyImplyLeading: false,
        title: const Text("Create a Loan"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _loanFormKey,
              onPopInvoked: (didPop) {},
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value) => _validateMobileNo(value),
                      controller: _mobileNoTEC,
                      keyboardType: TextInputType.phone,
                      decoration: styling.getTFFInputDecoration(
                        label: 'Borrower Mobile No.',
                        prefixIcon: const Icon(Icons.phone_rounded),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value) => _loanValidator(value),
                      controller: _loanAmountTEC,
                      keyboardType: TextInputType.number,
                      decoration: styling.getTFFInputDecoration(
                        label: 'Loan Amount',
                        prefixIcon: const Icon(Icons.currency_rupee_rounded),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value) => _validateDueDate(value),
                      onTap: () => _showDueDatePicker(),
                      controller: _dueDateTEC,
                      readOnly: true,
                      keyboardType: TextInputType.datetime,
                      decoration: styling.getTFFInputDecoration(
                        label: 'Due Date',
                        prefixIcon: const Icon(Icons.calendar_month_rounded),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _noteTEC,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: styling.getTFFInputDecoration(
                        label: 'Note',
                      ),
                    ),
                  )
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _validateForm(),
              icon: const Icon(Icons.done_rounded),
              label: const Text("Create Loan"),
            )
          ],
        ),
      ),
    );
  }

  _showDueDatePicker() {
    showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    ).then((dateTime) {
      if (dateTime != null) {}
      _dueDateTEC.text =
          "${dateTime!.day.toString()}/${dateTime.month.toString()}/${dateTime.year.toString()}";
    });
  }

  _loanValidator(String? value) {
    if (value != null) {
      if (value.isEmpty) {
        return "Please enter loan amount";
      }
      if (!RegExp(r"^\d+$").hasMatch(value)) {
        return "Invalid loan amount";
      }
    }
  }

  _validateForm() {
    if (_loanFormKey.currentState!.validate()) {
      // todo : create loan
      LoanService loanService = LoanService(_mobileNoTEC.text, context);
      loanService
          .createLoan(
              borrowerMobileNo: _mobileNoTEC.text,
              loanAmount: _loanAmountTEC.text,
              dueDate: _dueDateTEC.text,
              note: _noteTEC.text)
          .then((isLoanCreated) {
        if (isLoanCreated) {
          setState(() {
            fillDummyValues();
          });
        }
      });
    } else {
      // show appropriate message to the user
    }
  }

  _validateDueDate(String? value) {
    if (value != null) {
      if (value.isEmpty) {
        return "Please enter due date";
      }
    } else {
      return "Please enter due date";
    }
  }

  _validateMobileNo(String? value) {
    if (value != null) {
      if (value.isEmpty) {
        return "Please enter mobile no.";
      } else if (!RegExp(r"^\d+$").hasMatch(value)) {
        return "Invalid mobile no.";
      } else {
        // send OTP to the entered mobile number
        // if the OTP gets validated then create the loan
      }
    }
  }

  void fillDummyValues() {
    DummyValueGenerator dummyValueGenerator = DummyValueGenerator();

    _mobileNoTEC.text = dummyValueGenerator.generateRandomMobileNumber();
    _loanAmountTEC.text =
        dummyValueGenerator.generateRandomLoanInThousands().toString();
    _dueDateTEC.text = dummyValueGenerator.generateRandomDate().toString();
    _noteTEC.text =
        dummyValueGenerator.generateRandomNote(minCharCount: 50).toString();
  }
}
