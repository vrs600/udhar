import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
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
  final TextEditingController _secreteKeyTEC = TextEditingController();
  final TextEditingController _loanIdTEC = TextEditingController();

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
    if (widget.loanModel != null) {
      _loanIdTEC.text = _loan!.loanId;
    }
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
                  (!_editLoan)
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                              controller: _loanIdTEC,
                              keyboardType: TextInputType.text,
                              maxLines: null,
                              readOnly: false,
                              decoration: InputDecoration(
                                filled: true,
                                labelText: "Loan ID",
                                prefixIcon: const Icon(LucideIcons.hash),
                                fillColor: Colors.grey[300],
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              )),
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
                        prefixIcon: const Icon(LucideIcons.phoneCall),
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
                        prefixIcon: const Icon(LucideIcons.indianRupee),
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
                        prefixIcon: const Icon(LucideIcons.calendar),
                      ),
                    ),
                  ),
                  (_editLoan)
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                              controller: _secreteKeyTEC,
                              keyboardType: TextInputType.text,
                              maxLines: null,
                              validator: (value) {
                                if (value == null) {
                                  return "Please enter secret key of borrower";
                                }
                              },
                              decoration: InputDecoration(
                                filled: true,
                                labelText: "Secret Key",
                                prefixIcon: const Icon(LucideIcons.keyRound),
                                fillColor: Colors.grey[300],
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return BottomSheet(
                                          onClosing: () {},
                                          builder: (context) {
                                            return AiBarcodeScanner(
                                              onDetect: (BarcodeCapture
                                                  barcodeCapture) {
                                                barcodeCapture
                                                    .barcodes[0].displayValue;
                                              },
                                              onScan: (string) {
                                                setState(() {
                                                  _secreteKeyTEC.text = string;
                                                });
                                              },
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    LucideIcons.qrCode,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              )),
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
                  ),
                ],
              ),
            ),
            (_editLoan)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (_loan!.status != LoanStatus.closed)
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton.icon(
                                onPressed: () => _loanService!.closeLoan(
                                  context: context,
                                  loanId: _loan!.loanId,
                                ),
                                icon: const Icon(Icons.done_rounded),
                                label: const Text("Close the Loan"),
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          onPressed: () => _loanService!.updateLoan(
                            loanId: widget.loanModel!.loanId,
                            updatedLoanAmount:
                                double.parse(_loanAmountTEC.text),
                            context: context,
                            updatedNotes: _noteTEC.text,
                            updatedLoanDate: _dueDateTEC.text,
                          ),
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
              _loanService!.closeLoan(
                loanId: widget.loanModel!.loanId,
                context: context,
              );
            },
            icon: const Icon(Icons.done_rounded),
            label: const Text("Yes"),
          )
        ],
      ),
    );
  }
}
