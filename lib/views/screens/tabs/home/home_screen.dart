import 'package:flutter_svg/svg.dart';
// import '/model/home/accounts_model.dart';
import '../../../widgets/account_slider.dart';
import '/core/utils/app_assets.dart';

import '/controllers/controllers/data_controller.dart';
import '/core/routing/route_names.dart';
import '/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../../../controllers/controllers/auth_controller.dart';
import '../../../../../controllers/controllers/education_controller.dart';

import '../../../../../core/utils/extentions.dart';

import '../../../../controllers/controllers/airtime_controller.dart';
import '../../../../controllers/controllers/cable_controller.dart';
import '../../../../core/utils/app_helper.dart';
import '../../../widgets/home_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final authController = Get.find<AuthController>();
  final airtimeController = Get.find<AirtimeController>();
  final dataController = Get.put(DataController());
  final cableController = Get.find<CableTvController>();
  final educationController = Get.find<EducationController>();
  bool? showBalance = true;
  bool? isLoading = false;
  @override
  void initState() {
    super.initState();
    if (authController.contactsModel != null) {
      for (var value in authController.contactsModel!.support!) {
        if (value.name == "WhatsApp") {
          whatsapp = value.link;
        }
      }
    }
  }

  String? whatsapp;
  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      await authController.getUser();
      await authController.getContacts();
      await dataController.getDataBundles();
      await airtimeController.getTelecoms();
      await authController.getUser();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (whatsapp != null) {
            AppConstants.openUrl(link: whatsapp);
          } else {
            EasyLoading.showError("Service Not Available");
          }
        },
        child: SvgPicture.asset(
          AppAssets.whatsapp,
        ),
      ),
      body: SafeArea(
        child: isLoading!
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : RefreshIndicator.adaptive(
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                onRefresh: () async => await getData(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton.filled(
                            onPressed: () {
                              Get.toNamed(AppRouteNames.notifications);
                            },
                            icon: Icon(
                              Icons.notifications_active,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "${DateTime.now().getGreeting()} "
                            "${authController.user?.data?.fname ?? "Customer"}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: theme.textTheme.titleMedium!,
                          ),
                          subtitle: Text(
                            "Manage all your utility bills conveniently in one place with ${AppConstants.appName}.",
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Card.outlined(
                          elevation: 3,
                          color: theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      showBalance == true
                                          ? "${authController.user?.data?.balance}"
                                              .toCurrency()
                                          : "*" * 6,
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.headlineMedium!
                                          .copyWith(
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    InkWell(
                                      onTap: () {
                                        hideShowBalance();
                                      },
                                      child: Icon(
                                        showBalance!
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Bonus:",
                                      textAlign: TextAlign.center,
                                      style:
                                          theme.textTheme.bodyMedium!.copyWith(
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      showBalance == true
                                          ? "${authController.user?.data?.bonus}"
                                              .toCurrency()
                                          : "*" * 6,
                                      textAlign: TextAlign.center,
                                      style:
                                          theme.textTheme.titleMedium!.copyWith(
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                    const SizedBox(width: 32),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        foregroundColor:
                                            theme.colorScheme.onPrimary,
                                        // side: BorderSide(
                                        //   color:
                                        //       theme.colorScheme.primary,
                                        // ),
                                      ),
                                      onPressed: () {
                                        Get.toNamed(AppRouteNames.bonusWallet);
                                      },
                                      child: const Text("Claim"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        accounts()
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const SizedBox(height: 16),
                                  Text(
                                    "Account Number(s)",
                                    style: theme.textTheme.titleMedium!,
                                  ),
                                  const SizedBox(height: 8),
                                  AccountCarousel(
                                      accounts:
                                          authController.user!.data!.accounts!),
                                ],
                              )
                            : TextButton.icon(
                                onPressed: () async {
                                  try {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await authController.getUser();
                                  } finally {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: theme.colorScheme.error,
                                ),
                                iconAlignment: IconAlignment.end,
                                label: const Text("No Account? Refresh"),
                                icon: const Icon(
                                  Icons.refresh,
                                ),
                              ),
                        const SizedBox(height: 16),
                        Text(
                          "Services",
                          style: theme.textTheme.titleMedium!,
                        ),
                        const SizedBox(height: 8),
                        GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          childAspectRatio: 1,
                          children: List.generate(
                            Helper.homeIconsList.length,
                            (index) {
                              final iconsData = Helper.homeIconsList;
                              return HomeIconCard(
                                icon: iconsData[index].icon,
                                name: iconsData[index].name,
                                iconColor: theme.colorScheme.primary,
                                onPressed: () {
                                  if (index <= 4) {
                                    Get.toNamed(
                                      iconsData[index].screen!,
                                    );
                                  } else {
                                    EasyLoading.showToast("Coming soon!!!");
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  bool accounts() {
    return authController.user!.data?.accounts != null &&
        authController.user!.data!.accounts!.isNotEmpty;
  }

  void hideShowBalance() {
    setState(() {
      if (showBalance == true) {
        showBalance = false;
      } else {
        showBalance = true;
      }
    });
  }
}

class BalanceTile extends StatelessWidget {
  const BalanceTile({
    super.key,
    required this.showBalance,
    required this.onPressed,
    required this.onRefresh,
    required this.controller,
  });

  final bool? showBalance;
  final VoidCallback? onPressed;
  final VoidCallback? onRefresh;
  final AuthController? controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 30,
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: theme.colorScheme.primary,
      ),

      ///
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Your Wallet",
            style: theme.textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.normal,
              color: Colors.white.withValues(alpha: .8),
            ),
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Available Balance",
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: Colors.white.withValues(alpha: .8),
                          ),
                        ),
                        Text(
                          showBalance!
                              ? "*" * 8
                              : "${controller?.user?.data?.balance ?? 0}"
                                  .toCurrency(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.white.withValues(alpha: .8),
                                  ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: theme.colorScheme.onSurface,
                      backgroundColor: theme.colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                    onPressed: onPressed,
                    child: Text(
                      showBalance! ? "Show" : "Hide",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Referal Balance",
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: Colors.white.withValues(alpha: .8),
                          ),
                        ),
                        Text(
                          showBalance!
                              ? "*" * 8
                              : "${controller?.user?.data?.bonus ?? 0}"
                                  .toCurrency(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.white.withValues(alpha: .8),
                                  ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: theme.colorScheme.surface,
                      backgroundColor: theme.colorScheme.onSurface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                    onPressed: () {
                      Get.toNamed(AppRouteNames.bonusWallet);
                    },
                    child: const Text(
                      "Claim",
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: theme.colorScheme.onSurface,
                    backgroundColor: theme.colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                  ),
                  onPressed: () async {
                    Get.toNamed(AppRouteNames.funding);
                  },
                  child: const Text(
                    "Add Money",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: onRefresh,
                icon: Icon(
                  Icons.refresh,
                  color: theme.colorScheme.surface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
