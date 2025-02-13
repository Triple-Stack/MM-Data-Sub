class Telecoms {
  final List<Network>? network;

  Telecoms({
    this.network,
  });

  Telecoms.fromJson(Map<String, dynamic> json)
      : network = (json['network'] as List?)
            ?.map((dynamic e) => Network.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() =>
      {'network': network?.map((e) => e.toJson()).toList()};
}

class Network {
  final String? name;
  final int? id;
  final List<Type>? type;

  Network({
    this.name,
    this.id,
    this.type,
  });

  Network.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        id = json['id'] as int?,
        type = (json['type'] as List?)
            ?.map((dynamic e) => Type.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() =>
      {'name': name, 'id': id, 'type': type?.map((e) => e.toJson()).toList()};
}

class Type {
  final String? name;
  final List<Plans>? plans;

  Type({
    this.name,
    this.plans,
  });

  Type.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        plans = (json['plans'] as List?)
            ?.map((dynamic e) => Plans.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() =>
      {'name': name, 'plans': plans?.map((e) => e.toJson()).toList()};
}

class Plans {
  final String? network;
  final String? icon;
  final String? type;
  final int? discount;
  final int? aId;

  Plans({
    this.network,
    this.icon,
    this.type,
    this.discount,
    this.aId,
  });

  Plans.fromJson(Map<String, dynamic> json)
      : network = json['network'] as String?,
        icon = json['icon'] as String?,
        type = json['type'] as String?,
        discount = json['discount'] as int?,
        aId = json['aId'] as int?;

  Map<String, dynamic> toJson() => {
        'network': network,
        'icon': icon,
        'type': type,
        'discount': discount,
        'aId': aId
      };
}
