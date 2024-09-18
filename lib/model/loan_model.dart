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
  );
}
