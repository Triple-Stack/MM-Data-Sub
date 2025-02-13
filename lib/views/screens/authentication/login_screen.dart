import 'package:flutter_animate/flutter_animate.dart';
import 'package:in_app_update/in_app_update.dart';

import '/core/utils/extentions.dart';
import '/main.dart';
import 'package:double_tap_exit/double_tap_exit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:upgrader/upgrader.dart';
import '../../../controllers/controllers/auth_controller.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/app_constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    _checkForUpdate();
    showBiometric = sharedPreferences!.getString("token") != null &&
        sharedPreferences!.getBool("fingerprint") == true;
    phoneController = TextEditingController(
        text: sharedPreferences!.getString("phone") ?? "");
    _showPhoneOption =
        sharedPreferences!.getString("name") != null ? false : true;
    super.initState();
  }

  AppUpdateInfo? _updateInfo;

  Future<void> _checkForUpdate() async {
    try {
      _updateInfo = await InAppUpdate.checkForUpdate();
      if (_updateInfo?.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        _showUpdateDialog();
      }
    } catch (e) {
      debugPrint("Error checking for update: $e");
    }
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Update Available',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          content: Text(
            'A new version of the app is available. Please update to continue.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                if (_updateInfo!.immediateUpdateAllowed) {
                  await InAppUpdate.performImmediateUpdate();
                } else if (_updateInfo!.flexibleUpdateAllowed) {
                  _startFlexibleUpdate();
                }
              },
              child: const Text('Update Now'),
            ),
          ],
        );
      },
    );
  }

  void _startFlexibleUpdate() async {
    try {
      await InAppUpdate.startFlexibleUpdate();
      await InAppUpdate.completeFlexibleUpdate();
    } catch (e) {
      debugPrint("Error checking for update: $e");
    }
  }

  bool showBiometric = false;
  final authController = Get.find<AuthController>();
  TextEditingController? phoneController;
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool? isSecure = true;
  bool? _showPhoneOption = false;

  @override
  void dispose() {
    phoneController!.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return UpgradeAlert(
      showReleaseNotes: true,
      child: DoubleTap(
        message: "Press back again to close",
        child: PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: theme.colorScheme.surface,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 20),
                              const Image(
                                image: AssetImage(AppAssets.logo),
                                height: 100,
                              ),
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _showPhoneOption != true
                                      ? Text(
                                          sharedPreferences!.getString("name")!,
                                          textAlign: TextAlign.center,
                                          style: theme.textTheme.titleMedium,
                                        )
                                      : Text(
                                          AppConstants.appName,
                                          textAlign: TextAlign.center,
                                          style: theme.textTheme.titleLarge,
                                        ),
                                  Text(
                                    "We're happy to see you back again!",
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _showPhoneOption != true
                                      ? const SizedBox.shrink()
                                      : TextFormField(
                                          keyboardType: TextInputType.phone,
                                          controller: phoneController,
                                          maxLength: 11,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          onChanged: (value) {
                                            if (value.trim().length >= 11) {
                                              context.dismissKeyboard();
                                            }
                                          },
                                          validator: (value) {
                                            if (value!.trim().isEmpty) {
                                              return "Enter Phone Number";
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                            labelText: "Phone Number",
                                            counterText: "",
                                            prefixIcon: Icon(
                                              Icons.phone_android,
                                            ),
                                          ),
                                        ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    obscureText: isSecure!,
                                    controller: passwordController,
                                    keyboardType: TextInputType.visiblePassword,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Enter Password";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: "Password",
                                      prefixIcon: const Icon(
                                        Icons.lock_outline,
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (isSecure == true) {
                                              isSecure = false;
                                            } else {
                                              isSecure = true;
                                            }
                                          });
                                        },
                                        icon: Icon(
                                          isSecure! == false
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        Get.toNamed(
                                            AppRouteNames.forgotPassword);
                                      },
                                      child: const Text(
                                        "Forgot Password?",
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  showBiometric
                                      ? Center(
                                          child: Column(
                                            children: [
                                              IconButton(
                                                onPressed: () async {
                                                  await authController
                                                      .fingerPrintLogin();
                                                },
                                                icon: const Icon(
                                                  Icons.fingerprint,
                                                  size: 80,
                                                ),
                                              ),
                                              const Text(
                                                "Login with Biometric",
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      _showPhoneOption == true
                          ? const SizedBox.shrink()
                          : TextButton(
                              onPressed: () {
                                setState(() {
                                  _showPhoneOption = true;
                                });
                              },
                              child: const Text(
                                "Login with different Account",
                              ),
                            ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            context.dismissKeyboard();
                            try {
                              await authController.login(
                                password: passwordController.text.trim(),
                                phoneNumber: phoneController!.text.trim(),
                              );
                            } catch (e) {
                              EasyLoading.showError(
                                "Something Went Wrong",
                                dismissOnTap: true,
                              );
                            }
                          }
                        },
                        child: const Text(
                          "Login",
                        ),
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: theme.textTheme.bodyLarge,
                          children: [
                            TextSpan(
                              text: "Sign up",
                              style: theme.textTheme.bodyLarge!.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.toNamed(AppRouteNames.register);
                                  // AppConstants.registerUser();
                                },
                            ),
                          ],
                        ),
                      ),
                    ].animate(interval: 100.ms).fade().slideX(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
