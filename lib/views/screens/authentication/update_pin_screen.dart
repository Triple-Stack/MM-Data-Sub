import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../../controllers/controllers/auth_controller.dart';
import '../../../core/theme/colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/extentions.dart';

class UpdatePinScreen extends StatefulWidget {
  const UpdatePinScreen({super.key});

  @override
  State<UpdatePinScreen> createState() => _UpdatePinScreenState();
}

class _UpdatePinScreenState extends State<UpdatePinScreen> {
  @override
  void initState() {
    super.initState();
    emailAddressController = TextEditingController(text: Get.arguments ?? "");
  }

  bool? isLoading = false;
  bool? _isSecure = true;
  final authController = Get.find<AuthController>();
  TextEditingController? emailAddressController;
  final _pinController = TextEditingController();
  final otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailAddressController!.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          "Authentication",
        ),
        leading: BackButton(
          color: theme.colorScheme.onSurface,
        ),
        titleTextStyle: theme.textTheme.titleLarge,
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Enter OTP",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 32),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Enter the code sent to ',
                      style: theme.textTheme.bodyLarge,
                      children: [
                        TextSpan(
                          text: emailAddressController!.text,
                          style: theme.textTheme.titleMedium,
                        ),
                        TextSpan(
                          text:
                              ' to verify your request to change or reset your PIN for ',
                          style: theme.textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text: AppConstants.appName,
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "Enter the OTP",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium!.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                  Pinput(
                    controller: otpController,
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
                      }
                      return null;
                    },
                    onCompleted: (pin) {
                      context.dismissKeyboard();
                    },
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    obscureText: _isSecure!,
                    controller: _pinController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      PinInputFormatter.disallowLeadingZero(),
                    ],
                    maxLength: 4,
                    onChanged: (value) {
                      if (value.trim().length >= 4) {
                        context.dismissKeyboard();
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Password";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "New Transaction PIN",
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            if (_isSecure == true) {
                              _isSecure = false;
                            } else {
                              _isSecure = true;
                            }
                          });
                        },
                        icon: Icon(
                          _isSecure! == false
                              ? Icons.visibility_off_outlined
                              : Icons.visibility,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 64),
                  ElevatedButton(
                    onPressed: isLoading!
                        ? null
                        : () async {
                            context.dismissKeyboard();
                            if (formKey.currentState!.validate()) {
                              try {
                                setState(() {
                                  isLoading = true;
                                });
                                await authController.updatePIN(
                                  email: emailAddressController!.text.trim(),
                                  code: otpController.text.trim(),
                                  pinCode: _pinController.text.trim(),
                                );
                              } finally {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }
                          },
                    child: const Text(
                      "Verify",
                    ),
                  ),
                ].animate(interval: 100.ms).fade().slideX(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
