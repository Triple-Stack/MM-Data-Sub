import '/core/routing/route_names.dart';
import '/core/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RefreshWidget extends StatelessWidget {
  const RefreshWidget({
    super.key,
    required this.onPressed,
    required this.service,
  });

  final VoidCallback? onPressed;
  final String? service;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage(AppAssets.logo),
            height: 100,
          ),
          const SizedBox(height: 32),
          Text(
            "Oops!",
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineLarge!,
          ),
          const SizedBox(height: 8),
          Text(
            "The $service Service is temporarily unavailable due to maintenance/technical issues. Our team is on it, ensuring everything is resolved smoothly.",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge!,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
            ),
            onPressed: () {
              Get.offNamed(AppRouteNames.main);
            },
            child: const Text("Back to Home screen"),
          ),
        ],
      ),
    );
  }
}
