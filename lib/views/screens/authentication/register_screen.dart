import 'package:double_tap_exit/double_tap_exit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../controllers/controllers/auth_controller.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/app_helper.dart';
import '../../../core/utils/extentions.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void initState() {
    _referal = TextEditingController(text: Get.arguments ?? "");
    super.initState();
  }

  final _authController = Get.find<AuthController>();
  final _phoneNumber = TextEditingController();
  final _email = TextEditingController();
  final _transactionPin = TextEditingController();
  TextEditingController? _referal;
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool? _isSecure = true;
  bool _policyAccepted = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DoubleTap(
      message: "Press back again to close",
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // const SizedBox(height: 32),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Image(
                        image: AssetImage(AppAssets.logo),
                        height: 100,
                      ),
                      Text(
                        "Create an account",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge,
                      ),
                      Text(
                        "Welcome! Let's get you signed up",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              controller: _firstName,
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return "Enter First Name";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: "First Name",
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              controller: _lastName,
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return "Enter Last Name";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: "Last Name",
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _email,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return "Enter Email Address";
                          } else if (!value.trim().isEmail) {
                            return "Invalid Email Address";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: "Email Address",
                          prefixIcon: Icon(
                            Icons.email_outlined,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: _phoneNumber,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return "Enter Phone Number";
                          }
                          return null;
                        },
                        maxLength: 11,
                        onChanged: (value) {
                          if (value.trim().length >= 11) {
                            context.dismissKeyboard();
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: "Phone Number",
                          counterText: "",
                          prefixIcon: Icon(
                            Icons.phone_android_outlined,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _transactionPin,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return "Enter Transaction PIN";
                          }
                          return null;
                        },
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
                        decoration: const InputDecoration(
                          labelText: "Transaction PIN",
                          prefixIcon: Icon(
                            Icons.lock_outline,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: _referal,
                        maxLength: 11,
                        onChanged: (value) {
                          if (value.trim().length >= 11) {
                            context.dismissKeyboard();
                          }
                        },
                        decoration: InputDecoration(
                          labelText: "Referal Phone",
                          counterText: "",
                          prefixIcon: const Icon(
                            Icons.phone_android_outlined,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.person_add_alt),
                            onPressed: () async {
                              await Helper.pickContact(
                                context: context,
                                controller: _referal,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        obscureText: _isSecure!,
                        controller: _password,
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
                      const SizedBox(height: 16),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox.adaptive(
                            value: _policyAccepted,
                            onChanged: (value) {
                              setState(() {
                                _policyAccepted = value!;
                              });
                            },
                          ),
                          // By registering, you agree to our Privacy Policy, Terms of Service, and Cookies Policy.
                          Expanded(
                            child: RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                text: "By registering, you agree to our ",
                                style: theme.textTheme.bodyLarge,
                                children: [
                                  TextSpan(
                                    text: "Privacy Policy",
                                    style: theme.textTheme.bodyLarge!.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.toNamed(AppRouteNames.policy);
                                      },
                                  ),
                                  TextSpan(
                                    text: " And ",
                                    style: theme.textTheme.bodyLarge!.copyWith(
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Terms & Conditions.",
                                    style: theme.textTheme.bodyLarge!.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.toNamed(AppRouteNames.terms);
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _policyAccepted != true
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  await _authController.signUp(
                                    email: _email.text.trim(),
                                    pin: _transactionPin.text.trim(),
                                    referal: _referal?.text.trim(),
                                    firstName: _firstName.text.trim(),
                                    lastName: _lastName.text.trim(),
                                    phoneNumber: _phoneNumber.text.trim(),
                                    password: _password.text.trim(),
                                  );
                                }
                              },
                        child: const Text(
                          "Register",
                        ),
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "Already have an account? ",
                          style: theme.textTheme.bodyLarge,
                          children: [
                            TextSpan(
                              text: "Login",
                              style: theme.textTheme.bodyLarge!.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.offAndToNamed(AppRouteNames.login);
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
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
