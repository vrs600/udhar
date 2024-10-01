import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:udhar/model/loan_model.dart';
import 'package:udhar/other/dummy_values_generator.dart';
import 'package:udhar/other/styling.dart';
import 'package:udhar/service/loan_service.dart';

class LoanFormScreen extends StatefulWidget {
  final LoanModel? loanModel;

  const LoanFormScreen(this.loanModel, {super.key});

  @override
  State<LoanFormScreen> createState() => _LoanFormScreenState();
}

class _LoanFormScreenState extends State<LoanFormScreen> {
  final TextEditingController _dueDateTEC = TextEditingController();
  final TextEditingController _loanAmountTEC = TextEditingController();
  final TextEditingController _mobileNoTEC = TextEditingController();
  final TextEditingController _noteTEC = TextEditingController();

  final _loanFormKey = GlobalKey<FormState>();
  final Styling _styling = Styling();
  LoanModel? _loan;
  bool _editLoan = false;
  LoanService? _loanService;

  @override
  void initState() {
    super.initState();
    _loan = widget.loanModel;
    _editLoan = (_loan == null) ? false : true;
    if (kDebugMode) {
      // entering dummy values in the text fields
      if (_loan == null) {
        fillDummyValues();
      } else {
        _loanService = LoanService();
        fillLoanValues();
      }
    }
    if (_loan != null) {
      // user want to edit the loan details
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: null,
        automaticallyImplyLeading: false,
        title: (_editLoan)
            ? const Text(
                "Edit the Loan",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )
            : const Text(
                "Create a Loan",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                    child: (_editLoan)
                        ? Text(
                            _loan!.loanId,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value) => _validateMobileNo(value),
                      controller: _mobileNoTEC,
                      enabled: (_editLoan) ? false : true,
                      keyboardType: TextInputType.phone,
                      decoration: _styling.getTFFInputDecoration(
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
                      decoration: _styling.getTFFInputDecoration(
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
                      decoration: _styling.getTFFInputDecoration(
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
                      decoration: _styling.getTFFInputDecoration(
                        label: 'Note',
                      ),
                    ),
                  )
                ],
              ),
            ),
            (_editLoan)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          onPressed: () => _closeCurrentLoan(),
                          icon: const Icon(Icons.done_rounded),
                          label: const Text("Close"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          onPressed: () => _validateForm(),
                          icon: const Icon(Icons.edit_rounded),
                          label: const Text("Update"),
                        ),
                      )
                    ],
                  )
                : ElevatedButton.icon(
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
      LoanService loanService = LoanService();
      loanService
          .createLoan(
        borrowerMobileNo: _mobileNoTEC.text,
        loanAmount: _loanAmountTEC.text,
        dueDate: _dueDateTEC.text,
        note: _noteTEC.text,
        context: context,
      )
          .then((isLoanCreated) {
        Navigator.pop(context);
        setState(() {
          fillDummyValues();
        });
        if (isLoanCreated) {}
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
      } else {
        // send OTP to the entered mobile number
        // if the OTP gets validated then create the loan
        return null;
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

  void fillLoanValues() {
    _dueDateTEC.text = _loan!.dueDate;
    _loanAmountTEC.text = _loan!.loanAmount.toString();
    _mobileNoTEC.text = _loan!.borrowerMobileNo;
    _noteTEC.text = _loan!.note;
  }

  _closeCurrentLoan() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Close Loan"),
        content:
            const Text("Are you sure that you want to close current loan?"),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close_rounded),
            label: const Text("Cancel"),
          ),
          ElevatedButton.icon(
            onPressed: () {
              _loanService!.closeLoan();
            },
            icon: const Icon(Icons.done_rounded),
            label: const Text("Yes"),
          )
        ],
      ),
    );
  }
}
