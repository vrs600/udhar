class LoanModel {
  String loanId;
  String borrowerMobileNo;
  String loanCreationDate;
  String loanCreationTime;
  double loanAmount;
  String lenderMobileNo;
  String dueDate;
  String note;
  String status;
  String lenderId;
  String timestamp;

  LoanModel(
    this.loanId,
    this.borrowerMobileNo,
    this.loanCreationDate,
    this.loanCreationTime,
    this.loanAmount,
    this.lenderMobileNo,
    this.dueDate,
    this.note,
    this.status,
    this.lenderId,
    this.timestamp,
  );

  Map<String, dynamic> toMap() {
    return {
      "loan_id": loanId,
      "borrower_mobile_no": borrowerMobileNo,
      "loan_creation_date": loanCreationDate,
      "loan_creation_time": loanCreationTime,
      "loan_amount": loanAmount,
      "lender_mobile_no": lenderMobileNo,
      "loan_date": dueDate,
      "note": note,
      "status": status,
      "lender_id": lenderId,
      "timestamp": timestamp,
    };
  }
}
