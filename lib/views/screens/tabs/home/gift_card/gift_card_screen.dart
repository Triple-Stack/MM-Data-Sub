import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/enums.dart';
import '../../../../widgets/network_card.dart';

class GiftCardScreen extends StatefulWidget {
  const GiftCardScreen({super.key});

  @override
  State<GiftCardScreen> createState() => _GiftCardScreenState();
}

class _GiftCardScreenState extends State<GiftCardScreen> {
  List<Networks> networks = Networks.values;
  Networks? selected = Networks.mtn;
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
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
                              "Gift Card",
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
                          color:
                              theme.colorScheme.primary.withValues(alpha: .2),
                        ),
                        const SizedBox(height: 16),
                        const NetworkCard(
                          network: "Coming Soon!",
                          showBorder: false,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Exciting New Feature on The Way!",
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "We are working on something amazing for you. "
                          "Stay tuned for our new Service, coming soon!",
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {},
                            decoration: const InputDecoration(
                              hintText: "email@gmail.com",
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text("Notify Me"),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Follow us for updates:",
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Facebook",
                              ),
                            ),
                            VerticalDivider(
                              color: theme.colorScheme.onSurface,
                              thickness: 1,
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Twitter",
                              ),
                            ),
                            VerticalDivider(
                              color: theme.colorScheme.onSurface,
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Instagram",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox.shrink(),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  "Back to Home",
                ),
              )
            ].animate(interval: 100.ms).fade().slideX(),
          ),
        ),
      ),
    );
  }
}
