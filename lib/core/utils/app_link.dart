import 'dart:developer';
import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import '/core/routing/route_names.dart';

class AppLinkHandler {
  AppLinkHandler._();

  static final instance = AppLinkHandler._();

  final _appLinks = AppLinks();

  Future<void> initialize() async {
    // Listen to the dynamic links and manage navigation.
    _appLinks.uriLinkStream.listen(_handleLinkData).onError((error) {
      log('$error', name: 'Dynamic Link Handler');
    });
    await _checkInitialLink();
  }

  Future<void> _checkInitialLink() async {
    final initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      _handleLinkData(initialLink);
    }
  }

  void _handleLinkData(Uri data) {
    final queryParams = data.queryParameters;
    log(data.toString(), name: 'Dynamic Link Handler');
    if (queryParams.isNotEmpty) {
      final referralCode = queryParams['referral'];
      if (referralCode != null) {
        // Navigate to the registration screen with the referral code
        Get.toNamed(AppRouteNames.register, arguments: referralCode);
      } else {
        log('Referral code not found in the link.');
      }
    }
  }
}
