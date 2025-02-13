class UserModel {
  final String? msg;
  final UserData? data;

  UserModel({
    this.msg,
    this.data,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : msg = json['msg'] as String?,
        data = (json['data'] as Map<String, dynamic>?) != null
            ? UserData.fromJson(json['data'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {'msg': msg, 'data': data?.toJson()};
}

class UserData {
  final num? id;
  final String? image;
  final String? token;
  final String? fname;
  final String? lname;
  final String? email;
  final String? phone;
  final String? state;
  final num? pin;
  final String? usertype;
  final num? balance;
  final num? bonus;
  final List<Accounts>? accounts;
  final String? regstatus;
  final num? otp;
  final String? regdate;
  final String? lastactivity;
  final String? referrer;
  final num? bvn;
  final num? nin;
  final dynamic dob;
  final String? kycstatus;
  final dynamic deviceId;

  UserData({
    this.id,
    this.image,
    this.token,
    this.fname,
    this.lname,
    this.email,
    this.phone,
    this.state,
    this.pin,
    this.usertype,
    this.balance,
    this.bonus,
    this.accounts,
    this.regstatus,
    this.otp,
    this.regdate,
    this.lastactivity,
    this.referrer,
    this.bvn,
    this.nin,
    this.dob,
    this.kycstatus,
    this.deviceId,
  });

  UserData.fromJson(Map<String, dynamic> json)
      : id = json['id'] as num?,
        image = json['image'] as String?,
        token = json['token'] as String?,
        fname = json['fname'] as String?,
        lname = json['lname'] as String?,
        email = json['email'] as String?,
        phone = json['phone'] as String?,
        state = json['state'] as String?,
        pin = json['pin'] as num?,
        usertype = json['usertype'] as String?,
        balance = json['balance'] as num?,
        bonus = json['bonus'] as num?,
        accounts = (json['accounts'] as List?)
            ?.map((dynamic e) => Accounts.fromJson(e as Map<String, dynamic>))
            .toList(),
        regstatus = json['regstatus'] as String?,
        otp = json['otp'] as num?,
        regdate = json['regdate'] as String?,
        lastactivity = json['lastactivity'] as String?,
        referrer = json['referrer'] as String?,
        bvn = json['bvn'] as num?,
        nin = json['nin'] as num?,
        dob = json['dob'],
        kycstatus = json['kycstatus'] as String?,
        deviceId = json['device Id'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
        'token': token,
        'fname': fname,
        'lname': lname,
        'email': email,
        'phone': phone,
        'state': state,
        'pin': pin,
        'usertype': usertype,
        'balance': balance,
        'bonus': bonus,
        'accounts': accounts?.map((e) => e.toJson()).toList(),
        'regstatus': regstatus,
        'otp': otp,
        'regdate': regdate,
        'lastactivity': lastactivity,
        'referrer': referrer,
        'bvn': bvn,
        'nin': nin,
        'dob': dob,
        'kycstatus': kycstatus,
        'device Id': deviceId
      };
}

class Accounts {
  final String? bank;
  final num? account;

  Accounts({
    this.bank,
    this.account,
  });

  Accounts.fromJson(Map<String, dynamic> json)
      : bank = json['Bank'] as String?,
        account = json['Account'] as num?;

  Map<String, dynamic> toJson() => {
        'Bank': bank,
        'Account': account,
      };
}
