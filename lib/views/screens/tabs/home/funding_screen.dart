import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/utils/app_assets.dart';

import '../../../../../controllers/controllers/auth_controller.dart';

class FundingScreen extends StatefulWidget {
  const FundingScreen({super.key});

  @override
  State<FundingScreen> createState() => _FundingScreenState();
}

class _FundingScreenState extends State<FundingScreen> {
  final authController = Get.find<AuthController>();
  bool? isLoading = false;

  @override
  void initState() {
    getAccounts();
    super.initState();
  }

  getAccounts() async {
    try {
      setState(() {
        isLoading = true;
      });
      await authController.getAccounts();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        leading: BackButton(
          color: theme.colorScheme.onSurface,
        ),
        title: Text(
          "Fund Wallet",
          style: theme.textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: isLoading!
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "The account number(s) displayed below are unique to you. Use them to fund your account directly.",
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleMedium!,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                "Automated bank transfer attracts additional charges of N50 only.",
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyLarge!.copyWith(
                                  color: theme.colorScheme.error,
                                ),
                              ),
                            ),
                            Divider(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: .2),
                            ),
                            authController.accountsModel == null ||
                                    authController
                                        .accountsModel!.accounts!.isEmpty
                                ? Center(
                                    child: Text(
                                      "Accounts not created yet",
                                      style: theme.textTheme.titleMedium,
                                    ),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: List.generate(
                                      authController
                                          .accountsModel!.accounts!.length,
                                      (index) {
                                        final account = authController
                                            .accountsModel!.accounts![index];
                                        return AccountCard(
                                          bankName: "${account.bankName}",
                                          bankAccount:
                                              "${account.accountNumber}",
                                        );
                                      },
                                    ),
                                  ),
                            const SizedBox(height: 16),
                            const Divider(),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () {
                                Get.toNamed(AppRouteNames.custumerCare);
                              },
                              child: const Text(
                                "Customer care",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () async {
                        await authController.getUser().then((value) {
                          Get.offNamed(AppRouteNames.main);
                        });
                      },
                      child: const Text(
                        "Done",
                      ),
                    ),
                  ].animate(interval: 100.ms).fade().slideX(),
                ),
        ),
      ),
    );
  }
}

class AccountCard extends StatelessWidget {
  const AccountCard({
    super.key,
    required this.bankAccount,
    required this.bankName,
  });

  final String? bankName;
  final String? bankAccount;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text(
        "$bankName",
        style: theme.textTheme.titleMedium,
      ),
      subtitle: bankAccount == ""
          ? null
          : Text(
              "$bankAccount",
              style: theme.textTheme.bodyLarge,
            ),
      trailing: IconButton(
        onPressed: bankAccount == ""
            ? null
            : () async {
                await Clipboard.setData(
                  ClipboardData(text: "$bankAccount"),
                ).then((value) {
                  EasyLoading.showToast(
                    "$bankAccount Copied",
                  );
                });
              },
        icon: const Icon(
          size: 20,
          Icons.copy,
        ),
      ),
    );
  }
}

class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.name,
    required this.title,
  });

  final String? name;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text(
        title!,
        style: theme.textTheme.titleMedium,
      ),
      subtitle: Text(
        name!,
        style: theme.textTheme.bodyLarge!.copyWith(
          fontFamily: "roboto",
        ),
      ),
      trailing: IconButton(
        onPressed: () async {
          await Clipboard.setData(
            ClipboardData(text: name!),
          );
          EasyLoading.showToast(
            "Copied $name",
            dismissOnTap: true,
            maskType: EasyLoadingMaskType.clear,
          );
        },
        icon: const Icon(
          Icons.copy,
        ),
      ),
    );
  }
}

class ProfileHead extends StatelessWidget {
  const ProfileHead({
    super.key,
    required this.authController,
  });
  final AuthController? authController;
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
          "${authController!.user!.data!.email}",
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium,
        ),
        Text(
          "${authController!.user!.data!.fname} ${authController!.user!.data!.lname}",
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
