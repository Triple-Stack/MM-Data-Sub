/// create a class for app constants  usinhg signleton pattern
///
class AppAssets {
  static final AppAssets instance = AppAssets._internal();

  factory AppAssets() {
    return instance;
  }

  AppAssets._internal();
  static const String noNetworkAnim = "assets/network.json";
  static const String error = "assets/error.json";
  static const String logo = "assets/logo.png";
  static const String apple = "assets/apple.png";
  static const String google = "assets/google.png";

  /// icons
  static const String call = "assets/call.png";
  static const String cable = "assets/cable.png";
  static const String education = "assets/education.png";
  static const String electricity = "assets/electricity.png";
  static const String gift = "assets/gift.png";
  static const String wifi = "assets/wifi.png";
  static const String whatsapp = "assets/whatsapp.svg";

  ///
  static const String home = "assets/home.png";
  static const String transaction = "assets/transaction.png";
  static const String notification = "assets/notification.png";
  static const String account = "assets/account.png";

  /// Networks
  static const String mtn = "assets/mtn.png";
  static const String airtel = "assets/airtel.png";
  static const String glo = "assets/glo.png";
  static const String etisalat = "assets/etisalat.png";
}
