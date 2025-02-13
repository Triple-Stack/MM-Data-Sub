import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:double_tap_exit/double_tap_exit.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import '../../../core/utils/app_assets.dart';
import '../../../views/screens/tabs/account/account_screen.dart';
import '../../../views/screens/tabs/home/home_screen.dart';
import '../tabs/customer_support/support_screen.dart';
import '../../../views/screens/tabs/transactions/transactions_screen.dart';
import '../../../controllers/controllers/auth_controller.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
    this.index,
  });
  final int? index;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    _checkForUpdate();
    currentPageIndex = Get.arguments ?? 0;
  }

  final authController = Get.find<AuthController>();
  int currentPageIndex = 0;

  AppUpdateInfo? _updateInfo;

  Future<void> _checkForUpdate() async {
    try {
      _updateInfo = await InAppUpdate.checkForUpdate();
      if (_updateInfo?.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        _showUpdateDialog();
      }
    } catch (e) {
      debugPrint("secondary checking for update: $e");
    }
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Update Available',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          content: Text(
            'A new version of the app is available. Please update to continue.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                if (_updateInfo!.immediateUpdateAllowed) {
                  await InAppUpdate.performImmediateUpdate();
                } else if (_updateInfo!.flexibleUpdateAllowed) {
                  _startFlexibleUpdate();
                }
              },
              child: const Text('Update Now'),
            ),
          ],
        );
      },
    );
  }

  void _startFlexibleUpdate() async {
    try {
      await InAppUpdate.startFlexibleUpdate();
      await InAppUpdate.completeFlexibleUpdate();
    } catch (e) {
      debugPrint("secondary checking for update: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DoubleTap(
      message: "Press back again to close",
      child: PopScope(
        canPop: false,
        child: Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: CustomNavigationBar(
              iconSize: 25,
              borderRadius: const Radius.circular(20),
              backgroundColor: theme.colorScheme.primary,
              items: [
                CustomNavigationBarItem(
                  icon: Image(
                    image: const AssetImage(
                      AppAssets.home,
                    ),
                    color: theme.colorScheme.surface,
                  ),
                  title: Text(
                    "Home",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: theme.colorScheme.surface,
                    ),
                  ),
                  selectedIcon: Image(
                    image: const AssetImage(
                      AppAssets.home,
                    ),
                    color: theme.colorScheme.secondary,
                  ),
                  selectedTitle: Text(
                    "Home",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: theme.textTheme.bodyLarge!.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ),
                CustomNavigationBarItem(
                  icon: Image(
                    image: const AssetImage(
                      AppAssets.transaction,
                    ),
                    color: theme.colorScheme.surface,
                  ),
                  title: Text(
                    "Transaction",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: theme.colorScheme.surface,
                    ),
                  ),
                  selectedIcon: Image(
                    image: const AssetImage(
                      AppAssets.transaction,
                    ),
                    color: theme.colorScheme.secondary,
                  ),
                  selectedTitle: Text(
                    "Transaction",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: theme.textTheme.bodyLarge!.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ),
                CustomNavigationBarItem(
                  icon: Image(
                    image: const AssetImage(
                      AppAssets.notification,
                    ),
                    color: theme.colorScheme.surface,
                  ),
                  title: Text(
                    "Customer Care",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: theme.colorScheme.surface,
                    ),
                  ),
                  selectedIcon: Image(
                    image: const AssetImage(
                      AppAssets.notification,
                    ),
                    color: theme.colorScheme.secondary,
                  ),
                  selectedTitle: Text(
                    "Customer Care",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: theme.textTheme.bodyLarge!.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ),
                CustomNavigationBarItem(
                  icon: Image(
                    image: const AssetImage(
                      AppAssets.account,
                    ),
                    color: theme.colorScheme.surface,
                  ),
                  title: Text(
                    "Account",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: theme.colorScheme.surface,
                    ),
                  ),
                  selectedIcon: Image(
                    image: const AssetImage(
                      AppAssets.account,
                    ),
                    color: theme.colorScheme.secondary,
                  ),
                  selectedTitle: Text(
                    "Account",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: theme.textTheme.bodyLarge!.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ),
              ],
              currentIndex: currentPageIndex,
              onTap: (index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
              isFloating: true,
              scaleCurve: Curves.easeInBack,
            ),
          ),
          body: const [
            HomeScreen(),
            TransactionsScreen(),
            SupportScreen(),
            AccountScreen(),
          ][currentPageIndex],
        ),
      ),
    );
  }
}
