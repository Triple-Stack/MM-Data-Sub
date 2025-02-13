import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/controllers/theme_controller.dart';

// fluttertoast, url_launcher
/// create a class for app constants  usinhg signleton pattern
///
class AppConstants {
  static final AppConstants instance = AppConstants._internal();

  factory AppConstants() {
    return instance;
  }

  AppConstants._internal();
  static const String url = "https://$domain";
  static const String domain = "mmdatasub.com.ng";
  // https://islam24data.com/api
  // https://islam24data.com/api
  static const String baseUrl = "$url/api";
  static const String mainUrl = "$baseUrl/app";
  static const String appName = "MM Data Sub";
  static const String developerContact = "23408130762880";
  // static const String token =
  //     "35e3wctDqxdcokAGb16Cx8pBAliAB42A6gFCA30z1730718714";
  final LocalAuthentication auth = LocalAuthentication();
  static const String email = "support@$domain";

  Future<bool> canAuthenticateWithBiometrics() async {
    bool canAuthenticate = false;
    try {
      canAuthenticate = await auth.canCheckBiometrics;
      debugPrint("Device Status: $canAuthenticate");
    } catch (e) {
      debugPrint("Error: $e");
    }
    return canAuthenticate;
  }

  static void throwError(String? errorMessage) {
    debugPrint("Error: $errorMessage");
    Fluttertoast.showToast(
      msg: "$errorMessage",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
    );
    throw errorMessage!;
  }

  static Future<dynamic> switchTheme(BuildContext context) {
    final themeController = Get.put(ThemeController());
    return showAdaptiveDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog.adaptive(
          title: Text(
            "Switch Theme",
            style: theme.textTheme.titleMedium,
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  themeController.setThemeMode(ThemeMode.light);
                  Get.back();
                },
                child: Text(
                  "Light Theme",
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              TextButton(
                onPressed: () {
                  themeController.setThemeMode(ThemeMode.dark);
                  Get.back();
                },
                child: Text(
                  "Dark Theme",
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              TextButton(
                onPressed: () {
                  themeController.setThemeMode(ThemeMode.system);
                  Get.back();
                },
                child: Text(
                  "System Default",
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Contact Support Function
  ///
  /// This Flutter function enables users to easily contact our support team via email. It is designed to improve user engagement
  /// and encourage inquiries about our services. By setting a meaningful subject and message body, we aim to provide a better
  /// user experience.
  ///
  /// To use this function, simply call `sendEmail()`. It will open the user's default email client with a pre-filled email
  /// to our support team.
  static Future sendEmail({
    required String? email,
  }) async {
    // Create the phone call URL
    String callUrl = 'mailto:$email';

    // Check if the phone call can be initiated
    try {
      if (await canLaunchUrl(
        Uri.parse(callUrl),
      )) {
        // If possible, initiate the phone call
        await launchUrl(
          Uri.parse(callUrl),
          mode: LaunchMode.externalApplication,
        );
      }
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  /// Make Phone Call Function
  ///
  /// This Flutter function allows users to make a phone call to our support team for immediate assistance. It simplifies
  /// the process of reaching out for help using a predefined phone number. By providing this function, we aim to enhance
  /// user engagement and provide a convenient way for users to access support.
  ///
  /// To use this function, simply call `makeCall()`. It will initiate a phone call to our support team.
  static Future makeCall({
    required String? phone,
  }) async {
    // Create the phone call URL
    String callUrl = 'tel:$phone';

    // Check if the phone call can be initiated
    try {
      if (await canLaunchUrl(
        Uri.parse(
          callUrl,
        ),
      )) {
        // If possible, initiate the phone call
        await launchUrl(
          Uri.parse(
            callUrl,
          ),
        );
      }
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> openUrl({required String? link}) async {
    Uri url = Uri.parse(link!);

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      }
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> openEmail({required String? link}) async {
    Uri url = Uri.parse("mailto:$link");

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      }
    } on Exception catch (e) {
      throw Exception(e);
    }
  }
}
