class LoanModel {
  String loanId;
  String borrowerMobileNo;
  String loanCreationDate;
  String loanCreationTime;
  double loanAmount;
  String lenderMobileNo;
  int durationInMonth;
  String note;

  LoanModel(
      this.loanId,
      this.borrowerMobileNo,
      this.loanCreationDate,
      this.loanCreationTime,
      this.loanAmount,
      this.lenderMobileNo,
      this.durationInMonth,
      this.note);
}
