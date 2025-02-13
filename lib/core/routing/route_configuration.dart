import '/views/screens/authentication/intro_screen.dart';
import '/views/screens/authentication/update_pin_screen.dart';
import '/views/screens/tabs/account/term_condition.dart';
import '/views/screens/tabs/home/electricity/confirm_electricity.dart';
import '/views/screens/tabs/home/electricity/electricity_screen.dart';
import '/views/screens/tabs/home/electricity/electricity_transaction.dart';
import 'package:get/get.dart';
import '../../controllers/bindings/data_binding.dart';
import '../../controllers/bindings/exam_binding.dart';
import '../../controllers/bindings/electricity_binding.dart';
import '../../controllers/network/no_network_screen.dart';
import '../../views/screens/authentication/forget_password_screen.dart';
import '../../views/screens/tabs/customer_support/support_screen.dart';
import '../../views/screens/tabs/home/cable/cable_transaction.dart';
import '../../views/screens/tabs/home/exam/exam_transaction.dart';
import '../../views/screens/tabs/home/funding_screen.dart';
import '../../views/screens/authentication/main_screen.dart';
import '../../views/screens/authentication/login_screen.dart';
import '../../views/screens/authentication/register_screen.dart';
import '../../views/screens/tabs/home/cable/cable_screen.dart';
import '../../views/screens/tabs/home/cable/confirm_cable.dart';
import '../../views/screens/tabs/home/data/confirm_data.dart';
import '../../views/screens/tabs/home/data/data_screen.dart';
import '../../views/screens/tabs/home/exam/confirm_exam.dart';
import '../../views/screens/tabs/home/exam/exam_screen.dart';
import '../../views/screens/tabs/home/home_screen.dart';
import '../../views/screens/tabs/transactions/transactions_screen.dart';

import '../../controllers/bindings/airtime_binding.dart';
import '../../controllers/bindings/auth_binding.dart';
import '../../controllers/bindings/cable_binding.dart';
import '../../views/screens/authentication/update_password_screen.dart';
import '../../views/screens/tabs/account/about_app.dart';
import '../../views/screens/tabs/account/delete_account.dart';
import '../../views/screens/tabs/account/policy_screen.dart';
import '../../views/screens/tabs/account/help_support_screen.dart';
import '../../views/screens/tabs/account/manage_account_screen.dart';
import '../../views/screens/tabs/home/airtime/airtime_transaction.dart';
import '../../views/screens/tabs/home/airtime/confirm_airtime.dart';
import '../../views/screens/tabs/home/airtime/airtime_screen.dart';
import '../../views/screens/tabs/home/bonus_to_wallet_screen.dart';
import '../../views/screens/tabs/home/data/data_transaction.dart';
import '../../views/screens/tabs/home/gift_card/gift_card_screen.dart';
import '../../views/screens/tabs/home/notifications/notifications_screen.dart';
import '../../views/screens/tabs/transactions/receipt_screen.dart';
import '../../views/screens/tabs/transactions/transaction.dart';
import 'route_names.dart';

class AppRoutesConfiguration {
  static List<GetPage> myRoutes = [
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.main}',
      bindings: [
        AuthBinding(),
        AirtimeBinding(),
        CableBinding(),
        ExamBinding(),
      ],
      page: () => const MainScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.login}',
      binding: AuthBinding(),
      page: () => const LoginScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.updatePassword}',
      binding: AuthBinding(),
      page: () => const UpdatePasswordScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.updatePin}',
      binding: AuthBinding(),
      page: () => const UpdatePinScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.policy}',
      binding: AuthBinding(),
      page: () => const PolicyScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.terms}',
      binding: AuthBinding(),
      page: () => const TermsScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.app}',
      binding: AuthBinding(),
      page: () => const AboutAppScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.funding}',
      binding: AuthBinding(),
      page: () => const FundingScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.bonusWallet}',
      binding: AuthBinding(),
      page: () => const BonusToWalletScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      binding: AuthBinding(),
      name: '/${AppRouteNames.forgotPassword}',
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.introduction}',
      binding: AuthBinding(),
      page: () => const IntroductionScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.register}',
      binding: AuthBinding(),
      page: () => const RegisterScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.noNetwork}',
      binding: AuthBinding(),
      page: () => const NoNetworkScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.home}',
      bindings: [
        AuthBinding(),
        AirtimeBinding(),
        CableBinding(),
        ExamBinding(),
      ],
      page: () => const HomeScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.airtime}',
      binding: AuthBinding(),
      page: () => const AirtimeScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.confirmAirtime}',
      binding: AuthBinding(),
      page: () => const ConfirmAirtimeScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.airtimeTransaction}',
      binding: AuthBinding(),
      page: () => const AirtimeTransaction(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.data}',
      bindings: [
        AuthBinding(),
        AirtimeBinding(),
        DataBinding(),
      ],
      page: () => const DataScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.confirmData}',
      binding: AuthBinding(),
      page: () => const ConfirmDataScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.dataTransaction}',
      binding: AuthBinding(),
      page: () => const DataTransaction(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.exam}',
      bindings: [
        AuthBinding(),
        ExamBinding(),
      ],
      page: () => const ExamScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.confirmExam}',
      bindings: [
        AuthBinding(),
        ExamBinding(),
      ],
      page: () => const ConfirmExamScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.examTransaction}',
      bindings: [
        AuthBinding(),
        ExamBinding(),
      ],
      page: () => const ExamTransaction(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.electricity}',
      bindings: [
        AuthBinding(),
        ElectricityBinding(),
      ],
      page: () => const ElectricityScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.confirmElectricity}',
      bindings: [
        AuthBinding(),
        ElectricityBinding(),
      ],
      page: () => const ConfirmelEctricityScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.electricityTransaction}',
      bindings: [
        AuthBinding(),
        ElectricityBinding(),
      ],
      page: () => const ElectricityTransaction(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.transactions}',
      bindings: [
        AuthBinding(),
        AirtimeBinding(),
        DataBinding(),
      ],
      page: () => const TransactionsScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.cable}',
      bindings: [
        AuthBinding(),
        CableBinding(),
      ],
      page: () => const CableScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.confirmCable}',
      bindings: [
        AuthBinding(),
        CableBinding(),
      ],
      page: () => const ConfirmCableScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.cableTransaction}',
      bindings: [
        AuthBinding(),
        CableBinding(),
      ],
      page: () => const CableTransaction(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.giftCard}',
      binding: AuthBinding(),
      page: () => const GiftCardScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.manageAccount}',
      binding: AuthBinding(),
      page: () => const ManageAccountScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.deleteAccount}',
      binding: AuthBinding(),
      page: () => const DeleteAccountScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.helpSupport}',
      binding: AuthBinding(),
      page: () => const HelpSupportScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.transaction}',
      binding: AuthBinding(),
      page: () => const TransactionScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.receipt}',
      binding: AuthBinding(),
      page: () => const ReceiptScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.notifications}',
      binding: AuthBinding(),
      page: () => const NotificationsScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.custumerCare}',
      binding: AuthBinding(),
      page: () => const SupportScreen(),
    ),
  ];
}
