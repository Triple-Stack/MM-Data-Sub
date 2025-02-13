class CableModel {
  final String? status;
  final String? msg;
  final String? customerName;

  CableModel({
    this.status,
    this.msg,
    this.customerName,
  });

  CableModel.fromJson(Map<String, dynamic> json)
      : status = json['status'] as String?,
        msg = json['msg'] as String?,
        customerName = json['Customer_Name'] as String?;

  Map<String, dynamic> toJson() => {
        'status': status,
        'msg': msg,
        'Customer_Name': customerName,
      };
}
