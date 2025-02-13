class CableProvidersModel {
  final String? status;
  final String? msg;
  final List<CableProviders>? cableProviders;

  CableProvidersModel({
    this.status,
    this.msg,
    this.cableProviders,
  });

  CableProvidersModel.fromJson(Map<String, dynamic> json)
      : status = json['status'] as String?,
        msg = json['msg'] as String?,
        cableProviders = (json['cableProviders'] as List?)
            ?.map((dynamic e) =>
                CableProviders.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'status': status,
        'msg': msg,
        'cableProviders': cableProviders?.map((e) => e.toJson()).toList()
      };
}

class CableProviders {
  final int? cId;
  final String? cableid;
  final String? provider;
  final String? icon;
  final List<CablePlans>? plans;

  CableProviders({
    this.cId,
    this.cableid,
    this.provider,
    this.icon,
    this.plans,
  });

  CableProviders.fromJson(Map<String, dynamic> json)
      : cId = json['cId'] as int?,
        cableid = json['cableid'] as String?,
        provider = json['provider'] as String?,
        icon = json['icon'] as String?,
        plans = (json['plans'] as List?)
            ?.map((dynamic e) => CablePlans.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'cId': cId,
        'cableid': cableid,
        'provider': provider,
        'icon': icon,
        'plans': plans?.map((e) => e.toJson()).toList()
      };
}

class CablePlans {
  final int? cpId;
  final String? name;
  final int? price;
  final int? planid;
  final dynamic type;
  final int? day;

  CablePlans({
    this.cpId,
    this.name,
    this.price,
    this.planid,
    this.type,
    this.day,
  });

  CablePlans.fromJson(Map<String, dynamic> json)
      : cpId = json['cpId'] as int?,
        name = json['name'] as String?,
        price = json['price'] as int?,
        planid = json['planid'] as int?,
        type = json['type'],
        day = json['day'] as int?;

  Map<String, dynamic> toJson() => {
        'cpId': cpId,
        'name': name,
        'price': price,
        'planid': planid,
        'type': type,
        'day': day
      };
}
