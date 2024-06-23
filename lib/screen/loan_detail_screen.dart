import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:udhar/model/loan_model.dart';

class LoanDetailScreen extends StatefulWidget {
  final LoanModel loan;

  const LoanDetailScreen(this.loan, {super.key});

  @override
  State<LoanDetailScreen> createState() => _LoanDetailScreenState();
}

class _LoanDetailScreenState extends State<LoanDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.loan.borrowerMobileNo),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "₹ ${widget.loan.borrowerMobileNo} |  Due: ${widget.loan.dueDate}",
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
          ReadMoreText(
            widget.loan.note,
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
              color: getColor(widget.loan),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.loan.status,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
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
}
