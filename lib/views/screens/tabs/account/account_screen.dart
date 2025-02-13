import 'package:flutter_animate/flutter_animate.dart';

import '/core/utils/app_helper.dart';

import '/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rate_us_on_store/rate_us_on_store.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/utils/app_assets.dart';

import '../../../../controllers/controllers/auth_controller.dart';
import '../../../../main.dart';
import '../../../widgets/option_tile.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final authController = Get.put(AuthController());
  bool? canAuthenticate = false;
  @override
  void initState() {
    checkDevice();
    super.initState();
  }

  checkDevice() async {
    try {
      final result = await AppConstants().canAuthenticateWithBiometrics();
      debugPrint("canAuthenticate: $result");

      setState(() {
        canAuthenticate = result;
      });
      debugPrint("app_id: ${packageInfo!.packageName}");
    } catch (e) {
      debugPrint("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Profile",
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Divider(
                color: theme.colorScheme.primary.withValues(alpha: .2),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ProfileHead(
                        authController: authController,
                      ),
                      const SizedBox(height: 32),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          OptionTile(
                            name: "Manage Account",
                            onPressed: () => Get.toNamed(
                              AppRouteNames.manageAccount,
                            ),
                          ),
                          OptionTile(
                            name: "Customer Care",
                            onPressed: () =>
                                Get.toNamed(AppRouteNames.custumerCare),
                          ),
                          OptionTile(
                            name: "Refer to Earn",
                            onPressed: () async {
                              await Helper.shareReferral(
                                phone: authController.user!.data!.phone!,
                              );
                            },
                            icon: Icon(
                              Icons.adaptive.share,
                            ),
                          ),
                          canAuthenticate == null || canAuthenticate != true
                              ? const SizedBox.shrink()
                              : OptionTile(
                                  name: "Fingerprint",
                                  icon: Switch.adaptive(
                                    value: sharedPreferences!
                                            .getBool("fingerprint") ??
                                        false,
                                    onChanged: (value) {
                                      setState(() {
                                        sharedPreferences!
                                            .setBool("fingerprint", value);
                                      });
                                    },
                                  ),
                                  onPressed: null,
                                ),
                          const SizedBox(height: 32),
                          OptionTile(
                            name: "Appearances",
                            onPressed: () {
                              AppConstants.switchTheme(context);
                            },
                          ),
                          OptionTile(
                            name: "Rate Us",
                            onPressed: () {
                              RateUsOnStore(
                                androidPackageName: packageInfo!.packageName,
                                appstoreAppId: "284882215",
                              ).launch();
                            },
                          ),
                          OptionTile(
                            name: "Privacy Policy",
                            onPressed: () {
                              Get.toNamed(AppRouteNames.policy);
                            },
                          ),
                          OptionTile(
                            name: "Terms & Condition",
                            onPressed: () {
                              Get.toNamed(AppRouteNames.terms);
                            },
                          ),
                          OptionTile(
                            name: "App Info",
                            onPressed: () {
                              Get.toNamed(AppRouteNames.app);
                            },
                          ),
                          OptionTile(
                            name: "Logout",
                            onPressed: () {
                              logOut(context);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ].animate(interval: 100.ms).fade().slideX(),
          ),
        ),
      ),
    );
  }

  void logOut(BuildContext context) {
    final theme = Theme.of(context);
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: Text(
            "Logout",
            style: theme.textTheme.titleLarge,
          ),
          content: Text(
            "Are you sure?",
            style: theme.textTheme.bodyLarge,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Get.offAllNamed(AppRouteNames.login);
              },
              child: const Text(
                "Yes",
              ),
            ),
            OutlinedButton(
              onPressed: () {
                Get.back();
              },
              child: const Text(
                "No",
              ),
            ),
          ],
        );
      },
    );
  }
}

class ProfileHead extends StatelessWidget {
  const ProfileHead({
    super.key,
    required this.authController,
  });
  final AuthController? authController;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Image(
            image: const AssetImage(AppAssets.account),
            color: theme.colorScheme.onSurface,
            height: 100,
            fit: BoxFit.fill,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "${authController?.user?.data?.fname} ${authController?.user?.data?.lname}",
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium,
        ),
        Text(
          "${authController?.user?.data?.email}",
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
