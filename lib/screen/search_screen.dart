import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:udhar/model/loan_model.dart';
import 'package:udhar/other/styling.dart';
import 'package:udhar/screen/loan_detail_screen.dart';
import 'package:udhar/screen/loan_form_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<LoanModel> _loanModelList = [];
  List<LoanModel> _loanModelListCopy = [];
  Styling styling = Styling();
  bool _showProgressIndicator = true;
  int? chipSelectedIndex = 0;
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  final TextEditingController _searchPeopleTEC = TextEditingController();
  final TextEditingController _otpTEC = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getLoanList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(LucideIcons.search),
        automaticallyImplyLeading: false,
        title: const Text(
          "Search",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 70,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _searchBox(),
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  _listView(),
                  Visibility(
                    visible: _showProgressIndicator,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _getLoanList() {
    _loanModelList.clear();
    _firebaseDatabase.ref("app/ledger").get().then((dataSnapshot) {
      setState(() {
        _showProgressIndicator = true;
        for (DataSnapshot snapshot in dataSnapshot.children) {
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
              snapshot.child("loan_info").child("timestamp").value.toString(),
            ),
          );
        }
        _loanModelListCopy = _loanModelList;

        _showProgressIndicator = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        _showProgressIndicator = false;
      });

      if (kDebugMode) {
        print("Loan List Error: ${error.toString()}");
      }
    });
  }

  _getColor(int index) {
    if (_loanModelList[index].status == "pending") {
      return Colors.redAccent;
    }
    if (_loanModelList[index].status == "completed") {
      return Colors.green;
    } else {
      return Colors.blueAccent;
    }
  }

  _listView() {
    return ListView.builder(
      itemCount: _loanModelList.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(2),
        child: Card(
          child: ListTile(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => LoanFormScreen(_loanModelList[index]),
              //   ),
              // );
            },
            title: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Text(
                "₹ ${_loanModelList[index].loanAmount} |  Due: ${_loanModelList[index].dueDate}",
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(2),
                      child: Icon(Icons.call_rounded),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: Text(_loanModelList[index].borrowerMobileNo),
                    ),
                  ],
                ),
                Text("Dis. Date : ${_loanModelList[index].loanCreationDate}"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: _getColor(index),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _loanModelList[index].status,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () => _onViewReportButtonClicked(index),
                      child: const Text("View Report"),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _searchBox() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: _searchPeopleTEC,
      onChanged: (searchQuery) {
        // here search query is the phone no.
        setState(() {
          _loanModelList = _loanModelListCopy.where((loanItem) {
            return loanItem.borrowerMobileNo.contains(searchQuery);
          }).toList();
        });
      },
      minLines: 1,
      decoration: styling.getTFFInputDecoration(
        label: "Search People by mobile no.",
        textEditingController: _searchPeopleTEC,
        prefixIcon: const Icon(LucideIcons.search),
      ),
    );
  }

  _onViewReportButtonClicked(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("OTP Verification"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                    "Enter the OTP  sent to ${_loanModelList[index].borrowerMobileNo} to get permission to view full report"),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: TextFormField(
                  controller: _otpTEC,
                  keyboardType: TextInputType.number,
                  decoration: styling.getTFFInputDecoration(
                    label: "OTP",
                    prefixIcon: const Icon(Icons.password_rounded),
                    textEditingController: _otpTEC,
                  ),
                ),
              )
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (kDebugMode) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoanDetailScreen(
                      _loanModelList[index],
                    ),
                  ),
                );
              }
            },
            child: const Text("Verify"),
          )
        ],
      ),
    );
  }
}
