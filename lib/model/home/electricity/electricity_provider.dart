class ElectriciticyProvidersModel {
  final String? status;
  final List<ElectriciticyData>? electriciticyData;

  ElectriciticyProvidersModel({
    this.status,
    this.electriciticyData,
  });

  ElectriciticyProvidersModel.fromJson(Map<String, dynamic> json)
      : status = json['status'] as String?,
        electriciticyData = (json['data'] as List?)
            ?.map((dynamic e) =>
                ElectriciticyData.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': electriciticyData?.map((e) => e.toJson()).toList()
      };
}

class ElectriciticyData {
  final int? eId;
  final String? electricityid;
  final String? provider;
  final String? abbreviation;
  final String? icon;

  ElectriciticyData({
    this.eId,
    this.electricityid,
    this.provider,
    this.abbreviation,
    this.icon,
  });

  ElectriciticyData.fromJson(Map<String, dynamic> json)
      : eId = json['eId'] as int?,
        electricityid = json['electricityid'] as String?,
        provider = json['provider'] as String?,
        abbreviation = json['abbreviation'] as String?,
        icon = json['icon'] as String?;

  Map<String, dynamic> toJson() => {
        'eId': eId,
        'electricityid': electricityid,
        'provider': provider,
        'abbreviation': abbreviation,
        'icon': icon
      };
}
