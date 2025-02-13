class DataSuccessModel {
  final String? status;
  final String? servicename;
  final String? planDescription;
  final num? amountPaid;
  final String? transactionRef;
  final num? previousBalance;
  final num? newBalance;
  final String? timestamp;

  DataSuccessModel({
    this.status,
    this.servicename,
    this.planDescription,
    this.amountPaid,
    this.transactionRef,
    this.previousBalance,
    this.newBalance,
    this.timestamp,
  });

  DataSuccessModel.fromJson(Map<String, dynamic> json)
      : status = json['status'] as String?,
        servicename = json['servicename'] as String?,
        planDescription = json['plan_description'] as String?,
        amountPaid = json['amount_paid'] as num?,
        transactionRef = json['transaction_ref'] as String?,
        previousBalance = json['previous_balance'] as num?,
        newBalance = json['new_balance'] as num?,
        timestamp = json['timestamp'] as String?;

  Map<String, dynamic> toJson() => {
        'status': status,
        'servicename': servicename,
        'plan_description': planDescription,
        'amount_paid': amountPaid,
        'transaction_ref': transactionRef,
        'previous_balance': previousBalance,
        'new_balance': newBalance,
        'timestamp': timestamp
      };
}
