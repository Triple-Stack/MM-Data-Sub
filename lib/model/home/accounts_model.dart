class AccountsModel {
  final List<Accounts>? accounts;
  // final List<ManualBankDetails>? manualBankDetails;

  AccountsModel({
    this.accounts,
    // this.manualBankDetails,
  });

  AccountsModel.fromJson(Map<String, dynamic> json)
      : accounts = (json['accounts'] as List?)
            ?.map((dynamic e) => Accounts.fromJson(e as Map<String, dynamic>))
            .toList();
  // manualBankDetails = (json['Manual Bank Details'] as List?)
  //     ?.map((dynamic e) => ManualBankDetails.fromJson(e as Map<String, dynamic>))
  //     .toList();

  Map<String, dynamic> toJson() => {
        'accounts': accounts?.map((e) => e.toJson()).toList(),
        // 'Manual Bank Details':manualBankDetails?.map((e) => e.toJson()).toList()
      };
}

class Accounts {
  final String? bankName;
  final String? accountNumber;

  Accounts({
    this.bankName,
    this.accountNumber,
  });

  Accounts.fromJson(Map<String, dynamic> json)
      : bankName = json['Bank'] as String?,
        accountNumber = json['Account'] as String?;

  Map<String, dynamic> toJson() => {
        'Bank': bankName,
        'Account': accountNumber,
      };
}

// class ManualBankDetails {
//   final String? bankName;
//   final String? accountName;
//   final String? accountNumber;

//   ManualBankDetails({
//     this.bankName,
//     this.accountName,
//     this.accountNumber,
//   });

//   ManualBankDetails.fromJson(Map<String, dynamic> json)
//       : bankName = json['Bank Name'] as String?,
//         accountName = json['Account Name'] as String?,
//         accountNumber = json['Account Number'] as String?;

//   Map<String, dynamic> toJson() => {
//         'Bank Name': bankName,
//         'Account Name': accountName,
//         'Account Number': accountNumber
//       };
// }
