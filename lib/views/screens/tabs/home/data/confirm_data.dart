import 'package:flutter_animate/flutter_animate.dart';

import '/controllers/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pinput/pinput.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/utils/app_constants.dart';
import '../../../../../core/utils/extentions.dart';

import '../../../../../controllers/controllers/data_controller.dart';
import '../../../../../main.dart';

class ConfirmDataScreen extends StatefulWidget {
  const ConfirmDataScreen({super.key});

  @override
  State<ConfirmDataScreen> createState() => _ConfirmDataScreenState();
}

class _ConfirmDataScreenState extends State<ConfirmDataScreen> {
  bool? isLoading = false;
  final _dataController = Get.find<DataController>();
  final _authController = Get.find<AuthController>();
  @override
  void initState() {
    checkBiometric();
    serviceCode = Get.parameters["network-code"];
    dataCode = Get.parameters["data-code"];
    networkName = Get.parameters["network-name"];
    amount = Get.parameters["amount"];
    phone = Get.parameters["phone"];
    data = Get.parameters["data"];
    dataType = Get.parameters["data-type"];
    debugPrint("data: $data");
    debugPrint("data code: $dataCode");
    debugPrint("network code: $serviceCode");
    debugPrint("network name: $networkName");
    debugPrint("Amount: $amount");
    debugPrint("Phone: $phone");
    super.initState();
  }

  checkBiometric() async {
    biometricSupported = await AppConstants().canAuthenticateWithBiometrics();
    setState(() {});
  }

  bool biometricSupported = false;
  String? serviceCode;
  String? networkName;
  String? amount;
  String? phone;
  String? data;
  String? dataType;
  String? dataCode;

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
                          "Data",
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
                                  "Phone Number",
                                  style: theme.textTheme.bodyLarge,
                                ),
                                Expanded(
                                  child: Text(
                                    "$phone",
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
                                  "Network",
                                  style: theme.textTheme.bodyLarge,
                                ),
                                Expanded(
                                  child: Text(
                                    "$networkName",
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
                                  "Type",
                                  style: theme.textTheme.bodyLarge,
                                ),
                                Expanded(
                                  child: Text(
                                    "$dataType",
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
                                  "Description",
                                  style: theme.textTheme.bodyLarge,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "$data",
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
                                    "$amount".toCurrency(),
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
          await confirmData();
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
      await confirmData();
    } finally {
      isLoading = false;
    }
  }

  Future<void> confirmData() async {
    try {
      await _dataController.buyData(
        planId: dataCode,
        networkId: serviceCode,
        reference: "${DateTime.now().millisecondsSinceEpoch}",
        phoneNumber: phone,
      );
    } catch (e) {
      debugPrint("Error: $e");
      rethrow;
    }
  }
}
