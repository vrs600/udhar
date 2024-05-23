import 'package:flutter/material.dart';
import 'package:udhar/other/styling.dart';

class CreateLoanScreen extends StatefulWidget {
  const CreateLoanScreen({super.key});

  @override
  State<CreateLoanScreen> createState() => _CreateLoanScreenState();
}

class _CreateLoanScreenState extends State<CreateLoanScreen> {
  final TextEditingController _dueDateTEC = TextEditingController();
  final TextEditingController _loanAmountTEC = TextEditingController();
  final TextEditingController _mobileNoTEC = TextEditingController();

  final _loanFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Create a Loan"),
      ),
      body: Column(
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
                    decoration: Styling.getTFFInputDecoration(
                      label: 'Mobile No.',
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
                    decoration: Styling.getTFFInputDecoration(
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
                    decoration: Styling.getTFFInputDecoration(
                      label: 'Due Date',
                      prefixIcon: const Icon(Icons.calendar_month_rounded),
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
}
