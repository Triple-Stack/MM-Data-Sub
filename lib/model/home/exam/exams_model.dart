class ExamsModel {
  final String? status;
  final List<ExamCard>? examCards;

  ExamsModel({
    this.status,
    this.examCards,
  });

  ExamsModel.fromJson(Map<String, dynamic> json)
      : status = json['status'] as String?,
        examCards = (json['examCards'] as List?)
            ?.map((dynamic e) => ExamCard.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'status': status,
        'examCards': examCards?.map((e) => e.toJson()).toList()
      };
}

class ExamCard {
  final int? eId;
  final int? examid;
  final String? provider;
  final int? price;
  final String? icon;

  ExamCard({
    this.eId,
    this.examid,
    this.provider,
    this.price,
    this.icon,
  });

  ExamCard.fromJson(Map<String, dynamic> json)
      : eId = json['eId'] as int?,
        examid = json['examid'] as int?,
        provider = json['provider'] as String?,
        price = json['price'] as int?,
        icon = json['icon'] as String?;

  Map<String, dynamic> toJson() => {
        'eId': eId,
        'examid': examid,
        'provider': provider,
        'price': price,
        'icon': icon
      };
}
