import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '/model/authentication/contacts_model.dart';
import '/model/home/accounts_model.dart';
import '/model/home/notifications_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import '/model/authentication/user_model.dart';
import '/model/authentication/wallet_model.dart';
import '/model/home/transactions_model.dart';
import 'package:local_auth/local_auth.dart';

import '../../core/routing/route_names.dart';
import '../../core/utils/app_constants.dart';
import '../../main.dart';
import '../../model/authentication/account_model.dart';
import '../../model/authentication/verification_model.dart';

class AuthController extends GetxController {
  final LocalAuthentication auth = LocalAuthentication();
  ContactsModel? contactsModel;
  AccountsModel? accountsModel;
  UserModel? user;
  WalletModel? walletModel;
  AccountModel? accountModel;
  VerificationModel? verificationModel;
  TransactionsModel? transactionsModel;
  NotificationsModel? notificationsModel;

  Future<bool> authenticateUser() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await auth.authenticate(
        localizedReason: "Login to your account using fingerprint",
      );
    } on TimeoutException catch (_) {
      // Handle timeout explicitly
      EasyLoading.showError(
        "Request timed out. Please check your internet connection and try again.",
        duration: const Duration(seconds: 1),
      );
    } catch (e) {
      debugPrint("Error: $e");
    }
    return isAuthenticated;
  }

  Future login({
    required String? password,
    required String? phoneNumber,
  }) async {
    try {
      await EasyLoading.show(
        dismissOnTap: false,
        status: 'loading...',
      );
      final header = {
        "Content-Type": "application/json",
      };
      final body = {
        "phone": phoneNumber,
        "password": "$password",
      };
      // 07057651224
      // zxcvbnm0
      const String endPoint = '${AppConstants.mainUrl}/auth/login.php';

      final response = await http
          .post(
            Uri.parse(endPoint),
            headers: header,
            body: jsonEncode(body),
          )
          .timeout(
            const Duration(seconds: 60),
          );
      debugPrint("Body: ${response.body}");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final token = jsonDecode(response.body)['Userdata']['token'];
        await sharedPreferences!.setString("token", token);
        await sharedPreferences!.setBool("skipIntro", true);
        await sharedPreferences!.setBool("fingerprint", true);
        user = await getUser();
        await sharedPreferences!.setString("name", user!.data!.fname!);
        await sharedPreferences!.setString("phone", user!.data!.phone!);
        if (user != null) {
          return Get.toNamed(AppRouteNames.main);
        }
      } else {
        final errorMessage = jsonDecode(response.body)["msg"];
        EasyLoading.showError(
          errorMessage,
          dismissOnTap: true,
        );
      }
    } on SocketException {
      EasyLoading.showError("No internet connection.");
    } on HttpException {
      EasyLoading.showError("Failed to fetch data, try again");
    } on FormatException {
      EasyLoading.showError("Response format error.");
    } on TimeoutException {
      EasyLoading.showError("Request timed out. Try again.");
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      EasyLoading.dismiss();
    }
    return user;
  }

  Future fingerPrintLogin() async {
    try {
      bool canAuthenticate =
          await AppConstants().canAuthenticateWithBiometrics();
      if (canAuthenticate) {
        bool isAuthenticated = await authenticateUser();
        if (isAuthenticated) {
          try {
            EasyLoading.show(
              dismissOnTap: false,
              status: 'loading...',
            );
            if (user == null) {
              final result = await getUser();
              if (result != null) {
                user = result;
                Get.toNamed(AppRouteNames.main);
              }
            } else {
              EasyLoading.showToast("Login with Password");
            }
          } on Exception catch (e) {
            EasyLoading.showError("$e");
          } finally {
            EasyLoading.dismiss();
          }
        } else {
          debugPrint("Authentication failed");
        }
      } else {
        EasyLoading.showError("Fingerprint authentication not available");
      }
    } on SocketException {
      EasyLoading.showError("No internet connection.");
    } on HttpException {
      EasyLoading.showError("Failed to fetch data, try again");
    } on FormatException {
      EasyLoading.showError("Response format error.");
    } on TimeoutException {
      EasyLoading.showError("Request timed out. Try again.");
    } catch (e) {
      debugPrint("Error: $e");
      EasyLoading.showError("$e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future signUp(
      {required String? firstName,
      required String? lastName,
      required String? phoneNumber,
      required String? email,
      required String? password,
      required String? pin,
      String? referal}) async {
    try {
      EasyLoading.show(status: "Loading...");
      final header = {
        "Content-Type": "application/json",
        // "Authorization": "Bearer $token",
      };
      final body = {
        "fname": "$firstName",
        "lname": "$lastName",
        "phone": "$phoneNumber",
        "email": "$email",
        "password": "$password",
        "transpin": "$pin",
        "referal": "$referal"
      };
      const String endPoint = '${AppConstants.mainUrl}/auth/register.php';

      final response = await http
          .post(
            Uri.parse(endPoint),
            headers: header,
            body: jsonEncode(body),
          )
          .timeout(
            const Duration(seconds: 60),
          );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint("Signup: ${response.body}");
        final token = jsonDecode(response.body)['data']['token'];
        await sharedPreferences!.setString("token", token);
        await sharedPreferences!.setBool("skipIntro", true);
        await sharedPreferences!.setBool("fingerprint", true);
        user = await getUser();
        await sharedPreferences!.setString("name", user!.data!.fname!);
        await sharedPreferences!.setString("phone", user!.data!.phone!);
        if (user != null) {
          return Get.toNamed(AppRouteNames.main);
        }
      } else {
        debugPrint("Signup: ${response.body}");
        final errorMessage = jsonDecode(response.body)["msg"];
        EasyLoading.showError(
          "$errorMessage",
          dismissOnTap: true,
        );
      }
    } on SocketException {
      EasyLoading.showError("No internet connection.");
    } on HttpException {
      EasyLoading.showError("Failed to fetch data, try again");
    } on FormatException {
      EasyLoading.showError("Response format error.");
    } on TimeoutException {
      EasyLoading.showError("Request timed out. Try again.");
    } catch (e) {
      EasyLoading.showError("Something went wrong");
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future getUser() async {
    try {
      final token = sharedPreferences!.getString("token");
      debugPrint("Token: $token");
      final header = {
        "Content-Type": "application/json",
        "Token": "$token",
      };

      const String endPoint = '${AppConstants.mainUrl}/auth/userdata.php';

      final response = await http
          .get(
            Uri.parse(endPoint),
            headers: header,
          )
          .timeout(
            const Duration(seconds: 60),
          );
      debugPrint("User: ${response.body}");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        user = UserModel.fromJson(jsonDecode(response.body));
        // await Database.saveUser(user: userData.data);
        // user = await Database.getUser();
        await sharedPreferences!.setString("name", user!.data!.fname!);
        debugPrint("Email: ${user?.data?.email ?? "No Email"}");
        return user!;
      } else {
        final errorMessage = jsonDecode(response.body)["message"];
        debugPrint(errorMessage);
      }
    } on SocketException {
      EasyLoading.showError("No internet connection.");
    } on HttpException {
      EasyLoading.showError("Failed to fetch data, try again");
    } on FormatException {
      EasyLoading.showError("Response format error.");
    } on TimeoutException {
      EasyLoading.showError("Request timed out. Try again.");
    } catch (e) {
      EasyLoading.showError("Something went wrong");
    }
  }

  Future getContacts() async {
    try {
      final token = sharedPreferences!.getString("token");
      debugPrint("Token: $token");
      final header = {
        "Content-Type": "application/json",
        "Token": "$token",
      };

      const String endPoint = '${AppConstants.mainUrl}/other/contact.php';

      final response = await http
          .get(
            Uri.parse(endPoint),
            headers: header,
          )
          .timeout(
            const Duration(seconds: 60),
          );
      debugPrint("Contacts: ${response.body}");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        contactsModel = ContactsModel.fromJson(jsonDecode(response.body));
        debugPrint("Contacts: ${contactsModel?.support?.length ?? "0"}");
      } else {
        final message = jsonDecode(response.body)["message"];
        debugPrint("Contacts: $message");
      }
    } on SocketException {
      EasyLoading.showError("No internet connection.");
    } on HttpException {
      EasyLoading.showError("Failed to fetch data, try again");
    } on FormatException {
      EasyLoading.showError("Response format error.");
    } on TimeoutException {
      EasyLoading.showError("Request timed out. Try again.");
    } catch (e) {
      EasyLoading.showError("Something went wrong");
    }
  }

  Future getAccounts() async {
    try {
      final token = sharedPreferences!.getString("token");
      debugPrint("Token: $token");
      final header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };
      final body = {
        "getBank": true,
      };

      const String endPoint = '${AppConstants.mainUrl}/other/banks.php';
      // const String endPoint =
      // 'https://www.islam24data.com/api/app/other/banks.php';

      final response = await http
          .post(
            Uri.parse(endPoint),
            headers: header,
            body: jsonEncode(body),
          )
          .timeout(
            const Duration(seconds: 60),
          );
      debugPrint("Banks: ${response.body}");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        accountsModel = AccountsModel.fromJson(jsonDecode(response.body));
        debugPrint("Accounts: ${accountsModel?.accounts?.length ?? "0"}");
      } else {
        final errorMessage = jsonDecode(response.body)["message"];
        throw errorMessage;
      }
    } on SocketException {
      EasyLoading.showError("No internet connection.");
    } on HttpException {
      EasyLoading.showError("Failed to fetch data, try again");
    } on FormatException {
      EasyLoading.showError("Response format error.");
    } on TimeoutException {
      EasyLoading.showError("Request timed out. Try again.");
    } catch (e) {
      EasyLoading.showError("Something went wrong");
    }
    return accountsModel!;
  }

  Future getTransactions() async {
    try {
      final token = sharedPreferences!.getString("token");
      debugPrint("Token: $token");
      final header = {
        "Content-Type": "application/json",
        "Token": "$token",
      };

      const String endPoint = '${AppConstants.mainUrl}/other/transactions.php';

      final response = await http
          .get(
            Uri.parse(endPoint),
            headers: header,
          )
          .timeout(
            const Duration(seconds: 60),
          );
      debugPrint("Transactions: ${response.body}");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        transactionsModel =
            TransactionsModel.fromJson(jsonDecode(response.body));
        debugPrint(
            "Transactions: ${transactionsModel?.transactions?.length ?? "0"}");
      } else {
        final errorMessage = jsonDecode(response.body)["message"];
        throw errorMessage;
      }
    } on SocketException {
      EasyLoading.showError("No internet connection.");
    } on HttpException {
      EasyLoading.showError("Failed to fetch data, try again");
    } on FormatException {
      EasyLoading.showError("Response format error.");
    } on TimeoutException {
      EasyLoading.showError("Request timed out. Try again.");
    } catch (e) {
      EasyLoading.showError("Something went wrong");
    }
  }

  Future getNotifications() async {
    try {
      final token = sharedPreferences!.getString("token");
      debugPrint("Token: $token");
      final header = {
        "Content-Type": "application/json",
        "Token": "$token",
      };

      const String endPoint = '${AppConstants.mainUrl}/other/notifications.php';

      final response = await http
          .get(
            Uri.parse(endPoint),
            headers: header,
          )
          .timeout(
            const Duration(seconds: 60),
          );
      debugPrint("User: ${response.body}");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        notificationsModel =
            NotificationsModel.fromJson(jsonDecode(response.body));
        debugPrint(
            "Notifications: ${notificationsModel!.notifications!.length}");
      } else {
        final message = jsonDecode(response.body)["msg"];
        throw message;
      }
    } on SocketException {
      EasyLoading.showError("No internet connection.");
    } on HttpException {
      EasyLoading.showError("Failed to fetch data, try again");
    } on FormatException {
      EasyLoading.showError("Response format error.");
    } on TimeoutException {
      EasyLoading.showError("Request timed out. Try again.");
    } catch (e) {
      EasyLoading.showError("Something went wrong");
    }
  }

  Future requestPasswordCode({
    required String? emailAddress,
  }) async {
    EasyLoading.show(
      status: "Loading...",
    );
    try {
      final header = {
        "Content-Type": "application/json",
      };
      final body = {
        "email": "$emailAddress",
      };
      const String endPoint = '${AppConstants.mainUrl}/auth/otp.php';

      final response = await http
          .post(
            Uri.parse(endPoint),
            headers: header,
            body: jsonEncode(body),
          )
          .timeout(
            const Duration(seconds: 60),
          );
      debugPrint("Response ${response.body}");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Get.toNamed(
          AppRouteNames.updatePassword,
          arguments: "$emailAddress",
        );
      } else {
        final errorMessage = jsonDecode(response.body)["msg"];
        EasyLoading.showError(
          errorMessage,
          dismissOnTap: true,
        );
      }
    } on SocketException {
      EasyLoading.showError("No internet connection.");
    } on HttpException {
      EasyLoading.showError("Failed to fetch data, try again");
    } on FormatException {
      EasyLoading.showError("Response format error.");
    } on TimeoutException {
      EasyLoading.showError("Request timed out. Try again.");
    } catch (e) {
      EasyLoading.showError("Something went wrong");
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future requestPinCode({
    required String? emailAddress,
  }) async {
    EasyLoading.show(
      status: "Loading...",
    );
    try {
      final header = {
        "Content-Type": "application/json",
      };
      final body = {
        "email": "$emailAddress",
      };
      const String endPoint = '${AppConstants.mainUrl}/auth/otp.php';

      final response = await http
          .post(
            Uri.parse(endPoint),
            headers: header,
            body: jsonEncode(body),
          )
          .timeout(
            const Duration(seconds: 60),
          );
      debugPrint("Response ${response.body}");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Get.toNamed(
          AppRouteNames.updatePin,
          arguments: "$emailAddress",
        );
      } else {
        final errorMessage = jsonDecode(response.body)["msg"];
        EasyLoading.showError(
          errorMessage,
          dismissOnTap: true,
        );
      }
    } on SocketException {
      EasyLoading.showError("No internet connection.");
    } on HttpException {
      EasyLoading.showError("Failed to fetch data, try again");
    } on FormatException {
      EasyLoading.showError("Response format error.");
    } on TimeoutException {
      EasyLoading.showError("Request timed out. Try again.");
    } catch (e) {
      EasyLoading.showError("Something went wrong");
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future updatePassword({
    required String? code,
    required String? email,
    required String? password,
  }) async {
    EasyLoading.show(
      status: "Loading...",
    );
    try {
      final header = {
        "Content-Type": "application/json",
      };
      final body = {
        "email": "$email",
        "code": "$code",
        "newPassword": "$password",
      };

      const String endPoint = '${AppConstants.mainUrl}/auth/updatepass.php';

      final response = await http
          .post(
            Uri.parse(endPoint),
            headers: header,
            body: jsonEncode(body),
          )
          .timeout(
            const Duration(seconds: 60),
          );
      debugPrint("Response ${response.body}");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final message = jsonDecode(response.body)["msg"];
        EasyLoading.showSuccess(message);
        Get.offNamed(
          AppRouteNames.login,
        );
      } else {
        final errorMessage = jsonDecode(response.body)["msg"];
        EasyLoading.showError(
          errorMessage,
          dismissOnTap: true,
        );
      }
    } on SocketException {
      EasyLoading.showError("No internet connection.");
    } on HttpException {
      EasyLoading.showError("Failed to fetch data, try again");
    } on FormatException {
      EasyLoading.showError("Response format error.");
    } on TimeoutException {
      EasyLoading.showError("Request timed out. Try again.");
    } catch (e) {
      EasyLoading.showError("Something went wrong");
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future updatePIN({
    required String? code,
    required String? email,
    required String? pinCode,
  }) async {
    EasyLoading.show(
      status: "Loading...",
    );
    try {
      final header = {
        "Content-Type": "application/json",
      };

      final body = {
        "email": "$email",
        "code": "$code",
        "newPin": "$pinCode",
      };
      debugPrint("Body: ${jsonEncode(body)}");
      const String endPoint = '${AppConstants.mainUrl}/auth/updatepin.php';

      final response = await http
          .post(
            Uri.parse(endPoint),
            headers: header,
            body: jsonEncode(body),
          )
          .timeout(
            const Duration(seconds: 60),
          );
      debugPrint("Response ${response.body}");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final message = jsonDecode(response.body)["msg"];
        final token = jsonDecode(response.body)["ApiKey"];
        sharedPreferences!.setString("token", token);
        EasyLoading.showSuccess(message);
        Get.back();
        await getUser();
      } else {
        final errorMessage = jsonDecode(response.body)["msg"];
        EasyLoading.showError(
          errorMessage,
          dismissOnTap: true,
        );
      }
    } on SocketException {
      EasyLoading.showError("No internet connection.");
    } on HttpException {
      EasyLoading.showError("Failed to fetch data, try again");
    } on FormatException {
      EasyLoading.showError("Response format error.");
    } on TimeoutException {
      EasyLoading.showError("Request timed out. Try again.");
    } catch (e) {
      EasyLoading.showError("Something went wrong");
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future convertBonus({
    required String? amount,
  }) async {
    EasyLoading.show(status: "Loading...");
    try {
      final token = sharedPreferences!.getString("token");
      final header = {
        "Content-Type": "application/json",
        "Token": "$token",
      };
      final body = {
        "amount": int.tryParse(amount!),
      };
      const String endPoint =
          '${AppConstants.mainUrl}/other/bonus-to-wallet.php';

      final response = await http
          .post(
            Uri.parse(endPoint),
            headers: header,
            body: jsonEncode(body),
          )
          .timeout(
            const Duration(seconds: 60),
          );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final message = jsonDecode(response.body)["msg"];
        debugPrint(response.body);
        await getUser();
        EasyLoading.showSuccess("$message");
        Get.offNamed(AppRouteNames.main);
      } else {
        final errorMessage = jsonDecode(response.body)["message"];
        EasyLoading.showError(
          errorMessage,
          dismissOnTap: true,
        );
      }
    } on SocketException {
      EasyLoading.showError("No internet connection.");
    } on HttpException {
      EasyLoading.showError("Failed to fetch data, try again");
    } on FormatException {
      EasyLoading.showError("Response format error.");
    } on TimeoutException {
      EasyLoading.showError("Request timed out. Try again.");
    } catch (e) {
      EasyLoading.showError("Something went wrong");
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future deleteAccount({
    required String? name,
    required String? email,
    required String? phone,
    String? reason,
  }) async {
    EasyLoading.show(status: "Loading...");
    try {
      final token = sharedPreferences!.getString("token");
      final header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };
      final body = {
        "fullName": "$name",
        "email": "$email",
        "phone": "$phone",
        "reason": "$reason",
      };
      const String endPoint = '${AppConstants.mainUrl}/auth/delete_account.php';

      final response = await http
          .post(
            Uri.parse(endPoint),
            headers: header,
            body: jsonEncode(body),
          )
          .timeout(
            const Duration(seconds: 60),
          );
      debugPrint("Response: ${response.body}");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final message = jsonDecode(response.body)["msg"];
        EasyLoading.showSuccess("$message");
        Get.back();
      } else {
        final errorMessage = jsonDecode(response.body)["msg"];
        EasyLoading.showError(
          errorMessage,
          dismissOnTap: true,
        );
      }
    } on SocketException {
      EasyLoading.showError("No internet connection.");
    } on HttpException {
      EasyLoading.showError("Failed to fetch data, try again");
    } on FormatException {
      EasyLoading.showError("Response format error.");
    } on TimeoutException {
      EasyLoading.showError("Request timed out. Try again.");
    } catch (e) {
      EasyLoading.showError("Something went wrong");
    } finally {
      EasyLoading.dismiss();
    }
  }
}
