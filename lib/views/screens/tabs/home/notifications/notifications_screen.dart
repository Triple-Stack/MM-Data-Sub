import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../../../../controllers/controllers/auth_controller.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool? isLoading = false;
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      await authController.getNotifications();
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
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        leading: BackButton(
          color: theme.colorScheme.onSurface,
        ),
        centerTitle: true,
        title: Text(
          "Notification",
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: isLoading!
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : RefreshIndicator.adaptive(
                  onRefresh: () async {
                    getData();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      authController.notificationsModel == null ||
                              authController
                                  .notificationsModel!.notifications!.isEmpty
                          ? Expanded(
                              child: Center(
                                child: Text(
                                  "No Notification",
                                  style: theme.textTheme.titleLarge,
                                ),
                              ),
                            )
                          : Expanded(
                              child: ListView.separated(
                                separatorBuilder: (context, index) => Divider(
                                  color: theme.colorScheme.primary
                                      .withValues(alpha: .2),
                                ),
                                itemCount: authController
                                    .notificationsModel!.notifications!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final notification = authController
                                      .notificationsModel!
                                      .notifications![index];
                                  return ListTile(
                                    title: Text(
                                      "${notification.subject}",
                                      style: theme.textTheme.titleMedium,
                                    ),
                                    subtitle: Text(
                                      "${notification.message}",
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                  );
                                },
                              ),
                            ),
                    ].animate(interval: 100.ms).fade().slideX(),
                  ),
                ),
        ),
      ),
    );
  }
}
