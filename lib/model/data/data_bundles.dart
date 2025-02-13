class DataBundlesModel {
  final List<Network>? network;

  DataBundlesModel({
    this.network,
  });

  DataBundlesModel.fromJson(Map<String, dynamic> json)
      : network = (json['network'] as List?)
            ?.map((dynamic e) => Network.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() =>
      {'network': network?.map((e) => e.toJson()).toList()};
}

class Network {
  final String? name;
  final num? id;
  final List<Type>? type;

  Network({
    this.name,
    this.id,
    this.type,
  });

  Network.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        id = json['id'] as num?,
        type = (json['type'] as List?)
            ?.map((dynamic e) => Type.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'type': type?.map((e) => e.toJson()).toList(),
      };
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
            ?.map(
              (dynamic e) => Plans.fromJson(e as Map<String, dynamic>),
            )
            .toList();

  Map<String, dynamic> toJson() => {
        'name': name,
        'plans': plans?.map((e) => e.toJson()).toList(),
      };
}

class Plans {
  final String? network;
  final String? type;
  final num? price;
  final num? pId;
  final String? name;

  Plans({
    this.network,
    this.type,
    this.price,
    this.pId,
    this.name,
  });

  Plans.fromJson(Map<String, dynamic> json)
      : network = json['network'] as String?,
        type = json['type'] as String?,
        price = json['price'] as num?,
        pId = json['pId'] as num?,
        name = json['name'] as String?;

  Map<String, dynamic> toJson() => {
        'network': network,
        'type': type,
        'price': price,
        'pId': pId,
        'name': name
      };
}
