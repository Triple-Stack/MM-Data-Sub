class ContactsModel {
  final List<Support>? support;

  ContactsModel({
    this.support,
  });

  ContactsModel.fromJson(Map<String, dynamic> json)
      : support = (json['support'] as List?)
            ?.map(
              (dynamic e) => Support.fromJson(e as Map<String, dynamic>),
            )
            .toList();

  Map<String, dynamic> toJson() => {
        'support': support?.map((e) => e.toJson()).toList(),
      };
}

class Support {
  final String? name;
  final String? link;

  Support({
    this.name,
    this.link,
  });

  Support.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        link = json['link'] as String?;

  Map<String, dynamic> toJson() => {
        'name': name,
        'link': link,
      };
}
