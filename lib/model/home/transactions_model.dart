class TransactionsModel {
  final String? msg;
  final List<Transactions>? transactions;

  TransactionsModel({
    this.msg,
    this.transactions,
  });

  TransactionsModel.fromJson(Map<String, dynamic> json)
      : msg = json['msg'] as String?,
        transactions = (json['transactions'] as List?)
            ?.map(
                (dynamic e) => Transactions.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'msg': msg,
        'transactions': transactions?.map((e) => e.toJson()).toList()
      };
}

class Transactions {
  final num? tId;
  final num? sId;
  final String? transref;
  final String? servicename;
  final String? servicedesc;
  final num? amount;
  final String? status;
  final num? oldbal;
  final num? newbal;
  final num? profit;
  final String? date;
  final dynamic apiResponseLog;
  final dynamic pdfLink;

  Transactions({
    this.tId,
    this.sId,
    this.transref,
    this.servicename,
    this.servicedesc,
    this.amount,
    this.status,
    this.oldbal,
    this.newbal,
    this.profit,
    this.date,
    this.apiResponseLog,
    this.pdfLink,
  });

  Transactions.fromJson(Map<String, dynamic> json)
      : tId = json['tId'] as num?,
        sId = json['sId'] as num?,
        transref = json['transref'] as String?,
        servicename = json['servicename'] as String?,
        servicedesc = json['servicedesc'] as String?,
        amount = json['amount'] as num?,
        status = json['status'] as String?,
        oldbal = json['oldbal'] as num?,
        newbal = json['newbal'] as num?,
        profit = json['profit'] as num?,
        date = json['date'] as String?,
        apiResponseLog = json['api_response_log'],
        pdfLink = json['pdfLink'];

  Map<String, dynamic> toJson() => {
        'tId': tId,
        'sId': sId,
        'transref': transref,
        'servicename': servicename,
        'servicedesc': servicedesc,
        'amount': amount,
        'status': status,
        'oldbal': oldbal,
        'newbal': newbal,
        'profit': profit,
        'date': date,
        'api_response_log': apiResponseLog,
        'pdfLink': pdfLink
      };
}
