class AccountModel {
  final String? message;
  final Data? data;

  AccountModel({
    this.message,
    this.data,
  });

  AccountModel.fromJson(Map<String, dynamic> json)
      : message = json['message'] as String?,
        data = (json['data'] as Map<String, dynamic>?) != null
            ? Data.fromJson(json['data'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'message': message,
        'data': data?.toJson(),
      };
}

class Data {
  final String? merchantName;
  final String? bankName;
  final String? accountName;
  final String? accountNumber;
  final String? expiresOn;
  final num? totalPayable;
  final num? fee;
  final dynamic ussdPayment;

  Data({
    this.merchantName,
    this.bankName,
    this.accountName,
    this.accountNumber,
    this.expiresOn,
    this.totalPayable,
    this.fee,
    this.ussdPayment,
  });

  Data.fromJson(Map<String, dynamic> json)
      : merchantName = json['merchantName'] as String?,
        bankName = json['bankName'] as String?,
        accountName = json['accountName'] as String?,
        accountNumber = json['accountNumber'] as String?,
        expiresOn = json['expiresOn'] as String?,
        totalPayable = json['totalPayable'] as num?,
        fee = json['fee'] as num?,
        ussdPayment = json['ussdPayment'];

  Map<String, dynamic> toJson() => {
        'merchantName': merchantName,
        'bankName': bankName,
        'accountName': accountName,
        'accountNumber': accountNumber,
        'expiresOn': expiresOn,
        'totalPayable': totalPayable,
        'fee': fee,
        'ussdPayment': ussdPayment
      };
}
