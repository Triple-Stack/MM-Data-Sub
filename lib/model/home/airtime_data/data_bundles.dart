class DataBundles {
  final String? responseDescription;
  final Content? content;

  DataBundles({
    this.responseDescription,
    this.content,
  });

  DataBundles.fromJson(Map<String, dynamic> json)
      : responseDescription = json['response_description'] as String?,
        content = (json['content'] as Map<String, dynamic>?) != null
            ? Content.fromJson(json['content'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'response_description': responseDescription,
        'content': content?.toJson()
      };
}

class Content {
  final String? serviceName;
  final String? serviceID;
  final String? convinienceFee;
  final List<Varations>? varations;

  Content({
    this.serviceName,
    this.serviceID,
    this.convinienceFee,
    this.varations,
  });

  Content.fromJson(Map<String, dynamic> json)
      : serviceName = json['ServiceName'] as String?,
        serviceID = json['serviceID'] as String?,
        convinienceFee = json['convinience_fee'] as String?,
        varations = (json['varations'] as List?)
            ?.map((dynamic e) => Varations.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'ServiceName': serviceName,
        'serviceID': serviceID,
        'convinience_fee': convinienceFee,
        'varations': varations?.map((e) => e.toJson()).toList()
      };
}

class Varations {
  final String? variationCode;
  final String? name;
  final String? variationAmount;
  final String? fixedPrice;

  Varations({
    this.variationCode,
    this.name,
    this.variationAmount,
    this.fixedPrice,
  });

  Varations.fromJson(Map<String, dynamic> json)
      : variationCode = json['variation_code'] as String?,
        name = json['name'] as String?,
        variationAmount = json['variation_amount'] as String?,
        fixedPrice = json['fixedPrice'] as String?;

  Map<String, dynamic> toJson() => {
        'variation_code': variationCode,
        'name': name,
        'variation_amount': variationAmount,
        'fixedPrice': fixedPrice
      };
}
