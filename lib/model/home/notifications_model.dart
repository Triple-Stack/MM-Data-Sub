class NotificationsModel {
  final String? msg;
  final List<Notifications>? notifications;

  NotificationsModel({
    this.msg,
    this.notifications,
  });

  NotificationsModel.fromJson(Map<String, dynamic> json)
      : msg = json['msg'] as String?,
        notifications = (json['notifications'] as List?)
            ?.map((dynamic e) =>
                Notifications.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'msg': msg,
        'notifications': notifications?.map((e) => e.toJson()).toList()
      };
}

class Notifications {
  final num? msgId;
  final num? msgfor;
  final String? subject;
  final String? message;
  final num? status;
  final String? dPosted;

  Notifications({
    this.msgId,
    this.msgfor,
    this.subject,
    this.message,
    this.status,
    this.dPosted,
  });

  Notifications.fromJson(Map<String, dynamic> json)
      : msgId = json['msgId'] as num?,
        msgfor = json['msgfor'] as num?,
        subject = json['subject'] as String?,
        message = json['message'] as String?,
        status = json['status'] as num?,
        dPosted = json['dPosted'] as String?;

  Map<String, dynamic> toJson() => {
        'msgId': msgId,
        'msgfor': msgfor,
        'subject': subject,
        'message': message,
        'status': status,
        'dPosted': dPosted
      };
}
