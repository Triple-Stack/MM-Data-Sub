import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../controllers/controllers/auth_controller.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/extentions.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool? isLoading = false;
  final authController = Get.find<AuthController>();
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          "Forgot Password",
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
                  const SizedBox(height: 46),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Enter the email address used with ',
                      style: theme.textTheme.bodyLarge,
                      children: [
                        TextSpan(
                          text: AppConstants.appName,
                          style: theme.textTheme.titleMedium,
                        ),
                        const TextSpan(
                          text: ' to reset your password.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return "Enter Email Address";
                      }
                      if (!value.trim().isEmail) {
                        return "Invalid Email";
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
                  const SizedBox(height: 32),
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
                                await authController.requestPasswordCode(
                                  emailAddress: emailController.text.trim(),
                                );
                              } finally {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }
                          },
                    child: const Text(
                      "Continue",
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Get.offNamed(AppRouteNames.login);
                      },
                      child: const Text(
                        "Return to log in",
                      ),
                    ),
                  )
                ].animate(interval: 100.ms).fade().slideX(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
