import 'package:flutter_animate/flutter_animate.dart';

import '/controllers/controllers/auth_controller.dart';
import '/controllers/controllers/education_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pinput/pinput.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/utils/app_constants.dart';
import '../../../../../core/utils/extentions.dart';
import '../../../../../main.dart';

class ConfirmExamScreen extends StatefulWidget {
  const ConfirmExamScreen({super.key});

  @override
  State<ConfirmExamScreen> createState() => _ConfirmExamScreenState();
}

class _ConfirmExamScreenState extends State<ConfirmExamScreen> {
  bool? isLoading = false;
  final _examController = Get.find<EducationController>();
  final _authController = Get.find<AuthController>();
  @override
  void initState() {
    checkBiometric();
    providerCode = Get.parameters["providerCode"];
    providerName = Get.parameters["providerName"];
    price = Get.parameters["price"] ?? "0";

    debugPrint("Provider code: $providerCode");
    debugPrint("Provider name: $providerName");
    debugPrint("Price: $price");
    super.initState();
  }

  checkBiometric() async {
    biometricSupported = await AppConstants().canAuthenticateWithBiometrics();
    setState(() {});
  }

  bool biometricSupported = false;
  String? providerCode;
  String? providerName;
  String? price;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => Get.back(),
                          child: const Icon(
                            Icons.arrow_back_ios,
                          ),
                        ),
                        Text(
                          "Exam",
                          style: theme.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const Opacity(
                          opacity: 0,
                          child: Icon(
                            Icons.arrow_back_ios,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Divider(
                      color: theme.colorScheme.primary.withValues(alpha: .2),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "REVIEW YOUR ORDER",
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 32),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Exam Type",
                                  style: theme.textTheme.bodyLarge,
                                ),
                                Expanded(
                                  child: Text(
                                    "$providerName",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Amount",
                                  style: theme.textTheme.bodyLarge,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "$price".toCurrency(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Date",
                                  style: theme.textTheme.bodyLarge,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    DateTime.now().toDate(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: isLoading!
                    ? null
                    : () {
                        pinDialog(context, theme);
                      },
                child: const Text("Confirm"),
              ),
            ].animate(interval: 100.ms).fade().slideX(),
          ),
        ),
      ),
    );
  }

  void pinDialog(BuildContext context, ThemeData theme) {
    final formKey = GlobalKey<FormState>();
    final LocalAuthentication auth = LocalAuthentication();

    Future<void> authenticateWithBiometrics() async {
      try {
        final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Please authenticate to proceed',
          options: const AuthenticationOptions(
            biometricOnly: true,
          ),
        );
        if (didAuthenticate) {
          Get.back();
          await confirmExam();
        }
      } catch (e) {
        EasyLoading.showError("$e");
      }
    }

    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: Text(
            "Enter Transaction PIN",
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
          content: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Pinput(
                  focusedPinTheme: PinTheme(
                    textStyle: theme.textTheme.bodyMedium,
                    height: 50,
                    width: 50,
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColor.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  defaultPinTheme: PinTheme(
                    textStyle: theme.textTheme.bodyMedium,
                    height: 50,
                    width: 50,
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: .5),
                        width: 2,
                      ),
                    ),
                  ),
                  length: 4,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Enter OTP";
                    } else if (value.trim().length < 4) {
                      return "Wrong input";
                    } else if (value.trim() !=
                        "${_authController.user?.data?.pin}") {
                      return "Invalid PIN";
                    }
                    return null;
                  },
                  onCompleted: (pin) async {
                    context.dismissKeyboard();
                    if (formKey.currentState!.validate()) {
                      await submit();
                    }
                  },
                ),
                const SizedBox(height: 20),
                biometricSupported && sharedPreferences!.getBool("fingerprint")!
                    ? ElevatedButton.icon(
                        onPressed: () {
                          authenticateWithBiometrics();
                        },
                        icon: const Icon(Icons.fingerprint),
                        label: const Text("Use Fingerprint"),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> submit() async {
    try {
      isLoading = true;
      Get.back();
      EasyLoading.showSuccess("Success");
      await confirmExam();
    } finally {
      isLoading = false;
    }
  }

  Future<void> confirmExam() async {
    try {
      await _examController.buyExam(
        providerCode: providerCode,
        reference: "${DateTime.now().millisecondsSinceEpoch}",
      );
    } catch (e) {
      debugPrint("Error: $e");
      rethrow;
    }
  }
}
