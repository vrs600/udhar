import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:readmore/readmore.dart';
import 'package:udhar/model/loan_model.dart';
import 'package:udhar/other/styling.dart';
import 'package:udhar/service/loan_service.dart';

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
  double _paidLoanPercentage = 0;
  LottieBuilder? _riskAnimation;

  @override
  void initState() {
    super.initState();
    _getLoanList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.loan.borrowerMobileNo,
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _riskAnimation,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(3),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "RISK : ${((100 - _paidLoanPercentage).toString())}%",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 3,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueAccent,
                        Colors.lightBlueAccent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: _animatedRadioGauge(),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: ListView.builder(
              itemCount: _loanModelList.length,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         LoanFormScreen(_loanModelList[index]),
                    //   ),
                    // );
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
          )
        ],
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
    String borrowerMobileNumber = "";
    _loanModelList.clear();
    _firebaseDatabase.ref("app/ledger").get().then((dataSnapshot) {
      setState(() {
        _showProgressIndicator = true;
        for (DataSnapshot snapshot in dataSnapshot.children) {
          if (kDebugMode) {
            snapshot.value.toString();
            print("\n======================\n");
            print("\n${snapshot.value}\n");
            print("\n======================\n");
          }
          borrowerMobileNumber = snapshot
              .child("loan_info")
              .child("borrower_mobile_no")
              .value
              .toString();

          if (borrowerMobileNumber == widget.loan.borrowerMobileNo) {
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
        }
        _loanModelListCopy = _loanModelList;
        // calculating the total loan
        for (LoanModel loanModel in _loanModelList) {
          if (loanModel.status == LoanStatus.pending) {
            _pendingLoanCount += 1;
          }
          if (loanModel.status == LoanStatus.paid ||
              loanModel.status == LoanStatus.completed
          ) {
            _paidLoanCount += 1;
          }
        }

        _paidLoanPercentage =
            (_paidLoanCount / (_paidLoanCount + _pendingLoanCount)) * 100;

        if (_paidLoanPercentage < 33.3) {
          _riskAnimation =
              Lottie.asset("./asset/animation/risk_animation.json");
        } else if (_paidLoanPercentage > 33.3 && _paidLoanPercentage < 66.6) {
          _riskAnimation =
              Lottie.asset("./asset/animation/warning_animation.json");
        } else {
          _riskAnimation =
              Lottie.asset("./asset/animation/done_animation.json");
        }

        _showProgressIndicator = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        _showProgressIndicator = false;
      });

      if (kDebugMode) {
        print("Loan List Error: ${error.toString()}");
        print("Loan List stackTrace: ${stackTrace.toString()}");
      }
    });
  }

  getColor(LoanModel loanModel) {
    if (widget.loan.status == "pending") {
      return Colors.redAccent;
    }
    if (widget.loan.status == "completed") {
      return Colors.green;
    }
    if (widget.loan.status == LoanStatus.partiallyPaid) {
      return Colors.orange;
    } else {
      return Colors.blueAccent;
    }
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

  _animatedRadioGauge() {
    return AnimatedRadialGauge(
      duration: const Duration(seconds: 2),
      curve: Curves.elasticOut,
      radius: 100,
      initialValue: 0,
      value: _paidLoanPercentage,
      axis: const GaugeAxis(
        min: 0,
        max: 100,
        degrees: 180,
        style: GaugeAxisStyle(
          thickness: 20,
          background: Color(0xFFDFE2EC),
          segmentSpacing: 0,
        ),
        progressBar: GaugeProgressBar.rounded(
          color: Colors.transparent,
        ),
        segments: [
          GaugeSegment(
            from: 0,
            to: 33.3,
            color: Colors.redAccent,
            cornerRadius: Radius.circular(0),
          ),
          GaugeSegment(
            from: 33.3,
            to: 66.6,
            color: Colors.deepOrangeAccent,
            cornerRadius: Radius.circular(0),
          ),
          GaugeSegment(
            from: 66.6,
            to: 100,
            color: Colors.green,
            cornerRadius: Radius.circular(0),
          ),
        ],
      ),
    );
  }
}
