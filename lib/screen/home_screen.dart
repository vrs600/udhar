import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:udhar/model/loan_model.dart';
import 'package:udhar/other/styling.dart';
import 'package:udhar/screen/create_loan_screen.dart';
import 'package:udhar/service/loan_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<LoanModel> _loanModelList = [];
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _showProgressIndicator = true;
  Styling styling = Styling();
  int? chipSelectedIndex = 0;
  final List<String> _loanStatusList = ["all", "pending", "completed"];
  List<LoanModel> loanListCopy = [];
  bool _showClearSearchInputIcon = false;

  @override
  void initState() {
    super.initState();
    _getLoanList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _getLoanList();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 70,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextFormField(
                        onChanged: (searchQuery) {
                          setState(() {
                            _loanModelList = loanListCopy.where((loanItem) {
                              return loanItem.borrowerMobileNo
                                  .contains(searchQuery);
                            }).toList();
                          });
                        },
                        minLines: 1,
                        decoration:
                            styling.getTFFInputDecoration(label: "Search"),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Wrap(
                    spacing: 5.0,
                    children: List<Widget>.generate(
                      _loanStatusList.length,
                      (int index) {
                        return ChoiceChip(
                          label: Text(_loanStatusList[index]),
                          selected: chipSelectedIndex == index,
                          onSelected: (bool selected) {
                            setState(() {
                              chipSelectedIndex = selected ? index : null;

                              if (chipSelectedIndex == 0) {
                                _loanModelList = loanListCopy;
                              } else if (chipSelectedIndex == 1) {
                                _loanModelList = loanListCopy.where((loanItem) {
                                  return loanItem.status == "pending";
                                }).toList();
                              } else if (chipSelectedIndex == 2) {
                                _loanModelList = loanListCopy.where((loanItem) {
                                  return loanItem.status == "completed";
                                }).toList();
                              }
                            });
                          },
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    ListView.builder(
                      itemCount: _loanModelList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(2),
                          child: Card(
                            child: ListTile(
                              title: Text(
                                _loanModelList[index].borrowerMobileNo,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Amount: ${_loanModelList[index].loanAmount} |  Due: ${_loanModelList[index].dueDate}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ReadMoreText(
                                    _loanModelList[index].note,
                                    trimMode: TrimMode.Line,
                                    trimLines: 2,
                                    colorClickableText: Colors.blueAccent,
                                    trimCollapsedText: 'Show more',
                                    trimExpandedText: 'Show less',
                                    moreStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: getColor(index),
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
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Visibility(
                      visible: _showProgressIndicator,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_rounded),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const CreateLoanScreen(),
          ));
        },
      ),
    );
  }

  void _getLoanList() {
    _loanModelList.clear();
    _firebaseDatabase
        .ref("app/ledger/${_auth.currentUser!.phoneNumber}")
        .get()
        .then((dataSnapshot) {
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
                  .child("loan_mobile_no")
                  .value
                  .toString(),
              snapshot.child("loan_info").child("due_date").value.toString(),
              snapshot.child("loan_info").child("note").value.toString(),
              snapshot.child("loan_info").child("status").value.toString(),
            ),
          );
        }
        loanListCopy = _loanModelList;

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

  onOptionsClicked(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => BottomSheet(
        onClosing: () {},
        builder: (context) => ListView(),
      ),
    );
  }

  getCardStyle(int index) {
    if (_loanModelList[index].status == "pending") {
      return const TextStyle(
        color: Colors.white,
      );
    }
  }

  getColor(int index) {
    if (_loanModelList[index].status == "pending") {
      return Colors.redAccent;
    }
    if (_loanModelList[index].status == "completed") {
      return Colors.green;
    } else {
      return Colors.blueAccent;
    }
  }
}
