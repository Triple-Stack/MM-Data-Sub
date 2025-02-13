class MeterModel {
  final String? status;
  final String? msg;
  final String? customerName;

  MeterModel({
    this.status,
    this.msg,
    this.customerName,
  });

  MeterModel.fromJson(Map<String, dynamic> json)
      : status = json['status'] as String?,
        msg = json['msg'] as String?,
        customerName = json['Customer_Name'] as String?;

  Map<String, dynamic> toJson() => {
        'status': status,
        'msg': msg,
        'Customer_Name': customerName,
      };
}
