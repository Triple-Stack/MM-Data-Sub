import 'package:flutter_animate/flutter_animate.dart';

import '/core/utils/app_constants.dart';
import '/main.dart';
import 'package:flutter/material.dart';

import '../../../widgets/option_tile.dart';

class AboutAppScreen extends StatefulWidget {
  const AboutAppScreen({super.key});

  @override
  State<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
  bool? isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        centerTitle: true,
        leading: BackButton(
          color: theme.colorScheme.onSurface,
        ),
        title: Text(
          "App",
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OptionTile(
                      name: "App Name",
                      icon: Text(
                        packageInfo?.appName ?? '0',
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    OptionTile(
                      name: "Build number",
                      icon: Text(
                        packageInfo?.buildNumber ?? '0',
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    OptionTile(
                      name: "App Version",
                      icon: Text(
                        packageInfo?.version ?? '0',
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await AppConstants.openUrl(
                  link: "https://wa.me/${AppConstants.developerContact}",
                );
              },
              child: const Text(
                "Contact Developer",
              ),
            ),
          ].animate(interval: 100.ms).fade().slideX(),
        ),
      ),
    );
  }
}
