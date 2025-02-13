import 'package:flutter_animate/flutter_animate.dart';

import '/controllers/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../widgets/option_tile.dart';

class ManageAccountScreen extends StatefulWidget {
  const ManageAccountScreen({super.key});

  @override
  State<ManageAccountScreen> createState() => _ManageAccountScreenState();
}

class _ManageAccountScreenState extends State<ManageAccountScreen> {
  final authController = Get.find<AuthController>();
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
                    "Manage Account",
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OptionTile(
                      name: "Update PIN",
                      onPressed: () async {
                        await authController.requestPinCode(
                          emailAddress: "${authController.user!.data!.email}",
                        );
                      },
                    ),
                    OptionTile(
                      name: "Update Password",
                      onPressed: () async {
                        await authController.requestPasswordCode(
                          emailAddress: "${authController.user!.data!.email}",
                        );
                      },
                    ),
                    // OptionTile(
                    //   name: "Delete Account",
                    //   onPressed: () {
                    //     Get.toNamed(AppRouteNames.deleteAccount);
                    //   },
                    // ),
                  ].animate(interval: 100.ms).fade().slideX(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileHead extends StatelessWidget {
  const ProfileHead({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Center(
          child: Image(
            image: AssetImage(AppAssets.account),
            height: 100,
            fit: BoxFit.fill,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "johndoe@gmail.com",
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium,
        ),
        Text(
          "John Doe",
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
