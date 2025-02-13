import '../../controllers/controllers/data_controller.dart';
import '../../model/data/data_bundles.dart';
import '/core/routing/route_names.dart';
import '/core/utils/app_assets.dart';
import '/core/utils/app_constants.dart';
import '/core/utils/extentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../model/authentication/welcome_model.dart';
import '../../model/home_icon_model.dart';

class Helper {
  static DataController dataController = Get.put(DataController());
  static List<String> customOrder = ['MTN', 'AIRTEL', '9MOBILE', 'GLO'];
  static List<Network> sortedNetworks = dataController.dataBundles!.network!
    ..sort((a, b) {
      int aIndex = Helper.customOrder.indexOf(a.name!);
      int bIndex = Helper.customOrder.indexOf(b.name!);
      return aIndex.compareTo(bIndex);
    });

  static Future<void> pickContact(
      {BuildContext? context, TextEditingController? controller}) async {
    // Check if the contacts permission is already granted
    if (await Permission.contacts.isGranted) {
      await _pickContact(controller!);
    } else {
      // Show consent dialog
      bool consent = await showAdaptiveDialog(
        context: Get.context!,
        builder: (context) => AlertDialog.adaptive(
          title: const Text('Permission Request'),
          content: const Text(
            'We need access to your contacts to allow you to pick a contact. Do you grant permission?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Deny'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Allow'),
            ),
          ],
        ),
      );

      if (consent == true) {
        // Request permission
        if (await Permission.contacts.request().isGranted) {
          await _pickContact(controller!);
        } else {
          EasyLoading.showError("Contacts permission denied");
        }
      }
    }
  }

  static Future<void> _pickContact(TextEditingController controller) async {
    if (await FlutterContacts.requestPermission()) {
      final contact = await FlutterContacts.openExternalPick();
      if (contact != null && contact.phones.isNotEmpty) {
        String phoneNumber = contact.phones.first.number;
        controller.text = phoneNumber.formatPhoneNumber();
      }
    }
  }

  static Future shareReferral({
    required String? phone,
  }) async {
    String inviteMessage = """
I'm enjoying amazing deals and seamless top-ups with ${AppConstants.appName}, and I want you to join me!

Click here to start: ${AppConstants.url}/mobile/register?referral=$phone
""";
    await Share.share(inviteMessage);
  }

  static Future<void> captureAndShareReceipt({
    required ScreenshotController? controller,
  }) async {
    await Permission.storage.request();

    final directory = (await getApplicationDocumentsDirectory()).path;
    // final filePath = '$directory/receipt.png';

    controller!.captureAndSave(directory, fileName: 'receipt.png').then((file) {
      Share.shareXFiles(
        [XFile(file!)],
        text: '${AppConstants.appName} Transaction receipt',
        subject: "${AppConstants.appName} Transaction receipt",
      );
      debugPrint("file: $file");
    }).catchError((error) {
      debugPrint('Error capturing screenshot: $error');
    });
  }

  static List<IntroductionMessage> introductionMessges = [
    IntroductionMessage(
      image: AppAssets.logo,
      title: "Welcome to ${AppConstants.appName}",
      subtitle:
          "Manage all your utility payments effortlessly. Whether it's airtime, data, or cable subscriptions, ${AppConstants.appName} has you covered.",
    ),
    IntroductionMessage(
      image: AppAssets.logo,
      title: "Comprehensive Utility Services",
      subtitle:
          "From buying airtime and data to paying for cable and other utilities, we offer a wide range of services designed to make your life easier.",
    ),
    IntroductionMessage(
      image: AppAssets.logo,
      title: "Available Anytime, Anywhere",
      subtitle:
          "Whether it's day or night, enjoy uninterrupted access to all our services whenever you need them. We're here for you, 24/7.",
    ),
    IntroductionMessage(
      image: AppAssets.notification,
      title: "We're Here to Help",
      subtitle:
          "Have a question or need assistance? Our customer support team is always ready to help you with any issues or inquiries, anytime.",
    ),
  ];

  static List<HomeIconModel> homeIconsList = [
    HomeIconModel(
      icon: AppAssets.call,
      name: "Airtime",
      screen: AppRouteNames.airtime,
    ),
    HomeIconModel(
      icon: AppAssets.wifi,
      name: "Data",
      screen: AppRouteNames.data,
    ),
    HomeIconModel(
      icon: AppAssets.education,
      name: "Education",
      screen: AppRouteNames.exam,
    ),
    HomeIconModel(
      icon: AppAssets.electricity,
      name: "Electricity",
      screen: AppRouteNames.electricity,
    ),
    HomeIconModel(
      icon: AppAssets.cable,
      name: "TV Cable",
      screen: AppRouteNames.cable,
    ),
  ];
}
