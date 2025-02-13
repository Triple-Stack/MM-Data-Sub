import 'package:flutter_animate/flutter_animate.dart';

import '/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/controllers/auth_controller.dart';
import '../../../widgets/network_card.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  bool? isLoading = false;
  @override
  void initState() {
    super.initState();
    getContacts();
  }

  getContacts() async {
    try {
      setState(() {
        isLoading = true;
      });
      await authController.getContacts();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  final authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
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
                    Text(
                      "Customer Support",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "If you need more information or have any complaints, please contact one of our customer care representatives.",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    Divider(
                      color: theme.colorScheme.primary.withValues(alpha: .2),
                    ),
                    const SizedBox(height: 16),
                    authController.contactsModel == null
                        ? Expanded(
                            child: Center(
                              child: Text(
                                "Not Available",
                                style: theme.textTheme.titleLarge,
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount:
                                  authController.contactsModel?.support?.length,
                              itemBuilder: (BuildContext context, int index) {
                                final support = authController
                                    .contactsModel!.support![index];
                                return ListTile(
                                  onTap: () async {
                                    if (support.name == "Phone Number") {
                                      await AppConstants.makeCall(
                                        phone: support.link,
                                      );
                                    } else if (support.name == "Email") {
                                      await AppConstants.sendEmail(
                                        email: support.link,
                                      );
                                    } else {
                                      AppConstants.openUrl(
                                        link: support.link,
                                      );
                                    }
                                  },
                                  title: Text("${support.name}"),
                                  trailing: Icon(
                                    Icons.adaptive.arrow_forward,
                                  ),
                                );
                              },
                            ),
                          )
                  ].animate(interval: 100.ms).fade().slideX(),
                ),
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 30,
      ),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF6C3EFE).withValues(alpha: .2),
            const Color(0xCC368BF0).withValues(alpha: .2),
            const Color(0x55368BF0).withValues(alpha: .2),
          ],
          stops: const [0.0, 0.8, 1.0],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const NetworkCard(
            network: "MTN",
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "100MB Daily Plan Valid for 1 day",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge,
                ),
                Text(
                  "Thank you for using Quickbill",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  "Refer a friend and earn money https://quickbill.com/referall",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
