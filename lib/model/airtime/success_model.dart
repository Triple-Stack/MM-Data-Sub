class AirtimeSuccessModel {
  final String? status;
  final String? msg;
  final num? amountPaid;
  final String? transactionRef;
  final String? planDescription;
  final num? previousBalance;
  final num? newBalance;
  final String? timestamp;

  AirtimeSuccessModel({
    this.status,
    this.msg,
    this.amountPaid,
    this.transactionRef,
    this.planDescription,
    this.previousBalance,
    this.newBalance,
    this.timestamp,
  });

  AirtimeSuccessModel.fromJson(Map<String, dynamic> json)
      : status = json['status'] as String?,
        msg = json['Status'] as String?,
        amountPaid = json['amount_paid'] as num?,
        transactionRef = json['transaction_ref'] as String?,
        planDescription = json['plan_description'] as String?,
        previousBalance = json['previous_balance'] as num?,
        newBalance = json['new_balance'] as num?,
        timestamp = json['timestamp'] as String?;

  Map<String, dynamic> toJson() => {
        'status': status,
        'Status': msg,
        'amount_paid': amountPaid,
        'transaction_ref': transactionRef,
        'plan_description': planDescription,
        'previous_balance': previousBalance,
        'new_balance': newBalance,
        'timestamp': timestamp
      };
}
