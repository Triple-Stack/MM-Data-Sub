import 'package:flutter_animate/flutter_animate.dart';

import '/controllers/controllers/auth_controller.dart';
import '/core/utils/extentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final authController = Get.find<AuthController>();
  bool? isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _reasonController = TextEditingController();

  final _nameNode = FocusNode();
  final _emailNode = FocusNode();
  final _phoneNode = FocusNode();
  final _reasonNode = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _reasonController.dispose();

    _nameNode.dispose();
    _emailNode.dispose();
    _phoneNode.dispose();
    _reasonNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surface,
          centerTitle: true,
          leading: BackButton(
            color: theme.colorScheme.onSurface,
            onPressed: () => Get.back(),
          ),
          title: Text(
            "Request Account Deletion",
            style: theme.textTheme.titleMedium,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "To request the deletion of your account, please fill out the form below. We will process your request and inform you once your account has been successfully deleted",
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          keyboardType: TextInputType.name,
                          focusNode: _nameNode,
                          controller: _nameController,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return "Enter Name";
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            context.nextFocus(_nameNode, _emailNode);
                          },
                          decoration: const InputDecoration(
                            labelText: "Name",
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          focusNode: _emailNode,
                          controller: _emailController,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return "Enter Email";
                            } else if (!value.trim().isEmail) {
                              return "Invalid email";
                            } else if (value.trim() !=
                                authController.user!.data!.email) {
                              return "Wrong email";
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            context.nextFocus(_emailNode, _phoneNode);
                          },
                          decoration: const InputDecoration(
                            labelText: "Email Address",
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          focusNode: _phoneNode,
                          controller: _phoneController,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return "Enter Phone";
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            context.nextFocus(_phoneNode, _reasonNode);
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) {
                            if (value.trim().length >= 11) {
                              _phoneNode.unfocus();
                            }
                          },
                          maxLength: 11,
                          decoration: const InputDecoration(
                            labelText: "Phone",
                            counterText: "",
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          focusNode: _reasonNode,
                          controller: _reasonController,
                          onFieldSubmitted: (value) {
                            _reasonNode.unfocus();
                          },
                          decoration: const InputDecoration(
                            labelText: "Reason",
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                ),
                onPressed: () async {
                  context.dismissKeyboard();
                  if (_formKey.currentState!.validate()) {
                    showAdaptiveDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog.adaptive(
                            title: Text(
                              "Delete Account",
                              style: theme.textTheme.titleMedium,
                            ),
                            content: Text(
                              "You are about to request the deletion of your account. All your data will be permanently deleted. Are you sure you want to proceed?",
                              style: theme.textTheme.bodyLarge,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  Get.back();
                                  await authController.deleteAccount(
                                    name: _emailController.text.trim(),
                                    email: _emailController.text.trim(),
                                    phone: _phoneController.text.trim(),
                                    reason: _reasonController.text.trim(),
                                  );
                                },
                                child: const Text(
                                  "Yes",
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text(
                                  "No",
                                ),
                              ),
                            ],
                          );
                        });
                  }
                },
                child: const Text(
                  "Submit Request",
                ),
              ),
            ].animate(interval: 100.ms).fade().slideX(),
          ),
        ),
      ),
    );
  }
}
