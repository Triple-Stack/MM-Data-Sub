import '/core/routing/route_names.dart';

import '/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../core/utils/app_assets.dart';

class ErrorScreen extends StatefulWidget {
  final FlutterErrorDetails? error;
  const ErrorScreen({required this.error, super.key});

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage(AppAssets.logo),
                    height: 50,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    AppConstants.appName,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Lottie.asset(
                AppAssets.error,
                alignment: Alignment.center,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(40),
                child: Text(
                  "Something went wrong",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge!.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Get.offNamed(AppRouteNames.main);
                },
                child: const Text("Home"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
