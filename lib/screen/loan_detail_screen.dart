import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:readmore/readmore.dart';
import 'package:udhar/model/loan_model.dart';
import 'package:udhar/other/styling.dart';
import 'package:easy_pie_chart/easy_pie_chart.dart';

import 'loan_form_screen.dart';

class LoanDetailScreen extends StatefulWidget {
  final LoanModel loan;

  const LoanDetailScreen(this.loan, {super.key});

  @override
  State<LoanDetailScreen> createState() => _LoanDetailScreenState();
}

class _LoanDetailScreenState extends State<LoanDetailScreen> {
  final Styling _styling = Styling();
  final double _riskValue = 70;
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  TextEditingController searchPeopleTEC = TextEditingController();
  bool _showProgressIndicator = true;
  final List<LoanModel> _loanModelList = [];
  List<LoanModel> _loanModelListCopy = [];
  int? chipSelectedIndex = 0;
  int _pendingLoanCount = 0;
  int _paidLoanCount = 0;
  int _totalLoanCount = 0;
  double _paidLoanPercentage = 0;
  double _pendingLoanPercentage = 0;

  @override
  void initState() {
    super.initState();
    _getLoanList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.loan.borrowerMobileNo,
        ),
      ),
      body: ListView.builder(
        itemCount: _loanModelList.length,
        itemBuilder: (context, index) => Card(
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoanFormScreen(_loanModelList[index]),
                ),
              );
            },
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
                      "₹ ${_loanModelList[index].loanAmount} |  Due: ${_loanModelList[index].dueDate}",
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
              ],
            ),
          ),
        ),
      ),
    );
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

  void _getLoanList() {
    _loanModelList.clear();
    _firebaseDatabase.ref("app/ledger").get().then((dataSnapshot) {
      setState(() {
        _showProgressIndicator = true;
        for (DataSnapshot snapshot in dataSnapshot.children) {
          if (kDebugMode) {
            snapshot.value.toString();
          }
          print("\n======================\n");
          print("\n${snapshot.value}\n");
          print("\n======================\n");

          print(
              "INFORMATION ${snapshot.child("loan_info").child("borrower_mobile_no").value.toString()} : ${widget.loan.lenderId}");
          if (snapshot
                  .child("loan_info")
                  .child("borrower_mobile_no")
                  .value
                  .toString() ==
              widget.loan.borrowerMobileNo) {
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

  detailes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Loan Success Rate",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => openRiskRateInfoBtmSheet(),
                          icon: const Icon(Icons.info_outline_rounded),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: riskRateRadialGauge(),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Loan Repayment",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.info_outline),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: EasyPieChart(
                            pieType: PieType.crust,
                            size: 150,
                            centerText: "$_paidLoanPercentage%",
                            children: [
                              PieData(
                                  value: _pendingLoanPercentage,
                                  color: Colors.red),
                              PieData(
                                  value: _paidLoanPercentage,
                                  color: Colors.blue),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            _styling.borderRadius),
                                        color: Colors.redAccent),
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Pending Loan"),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            _styling.borderRadius),
                                        color: Colors.blueAccent),
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Paid Loan"),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  getColor(LoanModel loanModel) {
    if (widget.loan.status == "pending") {
      return Colors.redAccent;
    }
    if (widget.loan.status == "completed") {
      return Colors.green;
    } else {
      return Colors.blueAccent;
    }
  }

  riskRateRadialGauge() {
    return AnimatedRadialGauge(
      /// The animation duration.
      duration: const Duration(seconds: 3),
      curve: Curves.elasticOut,

      /// Define the radius.
      /// If you omit this value, the parent size will be used, if possible.
      radius: 100,

      /// Gauge value.
      value: 70,

      /// Optionally, you can configure your gauge, providing additional
      /// styles and transformers.
      axis: GaugeAxis(
        /// Provide the [min] and [max] value for the [value] argument.
        min: 0,
        max: 100,

        /// Render the gauge as a 180-degree arc.
        degrees: 180,

        /// Set the background color and axis thickness.
        style: const GaugeAxisStyle(
          thickness: 20,
          background: Colors.transparent,
          segmentSpacing: 4,
        ),

        /// Define the pointer that will indicate the progress (optional).
        pointer: const GaugePointer.needle(
          borderRadius: 16,
          width: 20,
          height: 100,
          color: Colors.black,
        ),

        /// Define the progress bar (optional).
        progressBar: const GaugeProgressBar.rounded(
          color: Colors.blueAccent,
        ),

        /// Define axis segments (optional).
        segments: [
          GaugeSegment(
            from: 0,
            to: 100,
            color: const Color(0xFFD9DEEB),
            cornerRadius: Radius.circular(_styling.borderRadius),
          ),
        ],
      ),
    );
  }

  getGaugeProgressBarColor() {
    if (_riskValue > 0 && _riskValue <= 33.3) {
      return Colors.redAccent;
    } else if (_riskValue > 33.3 && _riskValue <= 66.6) {
      return Colors.orangeAccent;
    } else {
      return Colors.green;
    }
  }

  openRiskRateInfoBtmSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => BottomSheet(
        onClosing: () {},
        builder: (context) => const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.info_outline_rounded),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Understanding Risk Rate",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                  "   The Loan Success Rate is a metric developed specifically for this app to help you assess the risk involved in lending money to someone. It takes into account various factors that influence a borrower's ability to repay a loan."),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                  "\n    A high Loan Success Rate indicates a lower risk, meaning the borrower is statistically more likely to make their loan payments on time and in full. Conversely, a low Loan Success Rate suggests a higher risk, indicating a greater chance of encountering difficulties with repayment."),
            )
          ],
        ),
      ),
    );
  }
}
