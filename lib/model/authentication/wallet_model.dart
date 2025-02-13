class WalletModel {
  final Data? data;

  WalletModel({
    this.data,
  });

  WalletModel.fromJson(Map<String, dynamic> json)
      : data = (json['data'] as Map<String, dynamic>?) != null
            ? Data.fromJson(json['data'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {'data': data?.toJson()};
}

class Data {
  final Wallet? wallet;
  final List<Transactions>? transactions;

  Data({
    this.wallet,
    this.transactions,
  });

  Data.fromJson(Map<String, dynamic> json)
      : wallet = (json['wallet'] as Map<String, dynamic>?) != null
            ? Wallet.fromJson(json['wallet'] as Map<String, dynamic>)
            : null,
        transactions = (json['transactions'] as List?)
            ?.map(
                (dynamic e) => Transactions.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'wallet': wallet?.toJson(),
        'transactions': transactions?.map((e) => e.toJson()).toList()
      };
}

class Wallet {
  final num? id;
  final num? userId;
  final String? currency;
  final String? accountNumber;
  final String? username;
  final String? accountName;
  final String? balance;
  final String? lockedBalance;
  final String? ledgerBalance;
  final String? prevBalance;
  final String? prevLockedBalance;
  final String? prevLedgerBalance;
  final String? phone;
  final String? email;
  final num? tier;
  final String? createdAt;
  final String? updatedAt;
  final dynamic deletedAt;

  Wallet({
    this.id,
    this.userId,
    this.currency,
    this.accountNumber,
    this.username,
    this.accountName,
    this.balance,
    this.lockedBalance,
    this.ledgerBalance,
    this.prevBalance,
    this.prevLockedBalance,
    this.prevLedgerBalance,
    this.phone,
    this.email,
    this.tier,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Wallet.fromJson(Map<String, dynamic> json)
      : id = json['id'] as num?,
        userId = json['userId'] as num?,
        currency = json['currency'] as String?,
        accountNumber = json['accountNumber'] as String?,
        username = json['username'] as String?,
        accountName = json['accountName'] as String?,
        balance = json['balance'] as String?,
        lockedBalance = json['lockedBalance'] as String?,
        ledgerBalance = json['ledgerBalance'] as String?,
        prevBalance = json['prevBalance'] as String?,
        prevLockedBalance = json['prevLockedBalance'] as String?,
        prevLedgerBalance = json['prevLedgerBalance'] as String?,
        phone = json['phone'] as String?,
        email = json['email'] as String?,
        tier = json['tier'] as num?,
        createdAt = json['createdAt'] as String?,
        updatedAt = json['updatedAt'] as String?,
        deletedAt = json['deletedAt'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'currency': currency,
        'accountNumber': accountNumber,
        'username': username,
        'accountName': accountName,
        'balance': balance,
        'lockedBalance': lockedBalance,
        'ledgerBalance': ledgerBalance,
        'prevBalance': prevBalance,
        'prevLockedBalance': prevLockedBalance,
        'prevLedgerBalance': prevLedgerBalance,
        'phone': phone,
        'email': email,
        'tier': tier,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt
      };
}

class Transactions {
  final num? netAmount;
  final Details? details;
  final num? id;
  final num? userId;
  final String? amount;
  final String? charge;
  final String? description;
  final String? reference;
  final String? transactionType;
  final dynamic sessionId;
  final String? status;
  final String? type;
  final String? createdAt;
  final String? updatedAt;
  final dynamic deletedAt;

  Transactions({
    this.netAmount,
    this.details,
    this.id,
    this.userId,
    this.amount,
    this.charge,
    this.description,
    this.reference,
    this.transactionType,
    this.sessionId,
    this.status,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Transactions.fromJson(Map<String, dynamic> json)
      : netAmount = json['netAmount'] as num?,
        details = (json['details'] as Map<String, dynamic>?) != null
            ? Details.fromJson(json['details'] as Map<String, dynamic>)
            : null,
        id = json['id'] as num?,
        userId = json['userId'] as num?,
        amount = json['amount'] as String?,
        charge = json['charge'] as String?,
        description = json['description'] as String?,
        reference = json['reference'] as String?,
        transactionType = json['transactionType'] as String?,
        sessionId = json['sessionId'],
        status = json['status'] as String?,
        type = json['type'] as String?,
        createdAt = json['createdAt'] as String?,
        updatedAt = json['updatedAt'] as String?,
        deletedAt = json['deletedAt'];

  Map<String, dynamic> toJson() => {
        'netAmount': netAmount,
        'details': details?.toJson(),
        'id': id,
        'userId': userId,
        'amount': amount,
        'charge': charge,
        'description': description,
        'reference': reference,
        'transactionType': transactionType,
        'sessionId': sessionId,
        'status': status,
        'type': type,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt
      };
}

class Details {
  final String? adminName;
  final num? adminId;
  final String? paymentMethod;

  Details({
    this.adminName,
    this.adminId,
    this.paymentMethod,
  });

  Details.fromJson(Map<String, dynamic> json)
      : adminName = json['adminName'] as String?,
        adminId = json['adminId'] as num?,
        paymentMethod = json['paymentMethod'] as String?;

  Map<String, dynamic> toJson() => {
        'adminName': adminName,
        'adminId': adminId,
        'paymentMethod': paymentMethod
      };
}
