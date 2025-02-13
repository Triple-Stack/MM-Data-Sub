import 'dart:async';

import '/controllers/controllers/airtime_controller.dart';
import '/controllers/controllers/auth_controller.dart';
import '/controllers/controllers/data_controller.dart';
import '/core/utils/database.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/controllers/education_controller.dart';
import 'controllers/controllers/theme_controller.dart';
import 'controllers/network/error_screen.dart';
import 'controllers/network/network_dependency.dart';
import 'core/routing/route_configuration.dart';
import 'core/routing/route_names.dart';
import 'core/theme/themes.dart';
import 'core/utils/app_constants.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'core/utils/app_link.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final dynamicLinkHandler = AppLinkHandler.instance;
  dynamicLinkHandler.initialize();
  sharedPreferences = await SharedPreferences.getInstance();
  packageInfo = await PackageInfo.fromPlatform();

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ],
  );

  Database.database();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return ErrorScreen(error: details);
  };

  Get.put(ThemeController());

  runApp(
    const MmDataApp(),
  );

  NetWorkDependencyInjection.init();
}

SharedPreferences? sharedPreferences;
PackageInfo? packageInfo;

class MmDataApp extends StatefulWidget {
  const MmDataApp({super.key});

  @override
  State<MmDataApp> createState() => _MmDataAppState();
}

class _MmDataAppState extends State<MmDataApp> {
  final themeController = Get.find<ThemeController>();
  final authController = Get.put(AuthController());
  final dataController = Get.put(DataController());
  final examController = Get.put(EducationController());
  final airtimeController = Get.put(AirtimeController());

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    try {
      // Load additional data in parallel
      await Future.wait([
        authController.getContacts(),
        airtimeController.getTelecoms(),
        dataController.getDataBundles(),
      ]);

      // Remove the splash screen after all data has loaded
      FlutterNativeSplash.remove();
    } catch (error, stackTrace) {
      // Handle errors gracefully and log them for debugging
      debugPrint("Error loading data: $error");
      debugPrint(stackTrace.toString());

      // Optionally, show an error message to the user or retry loading data
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          useInheritedMediaQuery: true,
          locale: DevicePreview.locale(context),
          title: AppConstants.appName,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.themeMode.value,
          defaultTransition: Transition.fade,
          transitionDuration: const Duration(milliseconds: 300),
          navigatorKey: Get.key,
          builder: EasyLoading.init(),
          getPages: AppRoutesConfiguration.myRoutes,
          initialRoute: sharedPreferences!.getBool("skipIntro") != true
              ? AppRouteNames.introduction
              : AppRouteNames.login,
        );
      },
    );
  }
}
