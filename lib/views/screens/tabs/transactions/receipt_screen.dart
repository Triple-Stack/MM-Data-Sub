import 'package:flutter_animate/flutter_animate.dart';

import '/core/utils/app_assets.dart';
import '/core/utils/app_constants.dart';
import '/model/home/transactions_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/app_helper.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  ScreenshotController screenshotController = ScreenshotController();
  @override
  void initState() {
    super.initState();
    trans = Get.arguments;
  }

  Transactions? trans;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Screenshot(
                  controller: screenshotController,
                  child: Container(
                    color: AppColor.whiteColor,
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Image(
                              image: AssetImage(
                                AppAssets.logo,
                              ),
                              height: 50,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              AppConstants.appName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleLarge!.copyWith(
                                color: AppColor.blackColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Receipt",
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge!.copyWith(
                            color: AppColor.blackColor,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Reference",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: theme.textTheme.titleMedium!.copyWith(
                              color: AppColor.blackColor,
                            ),
                          ),
                          trailing: SelectableText(
                            trans?.transref ?? "",
                            style: theme.textTheme.bodyLarge!.copyWith(
                              color: AppColor.blackColor,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Date",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: theme.textTheme.titleMedium!.copyWith(
                              color: AppColor.blackColor,
                            ),
                          ),
                          trailing: SelectableText(
                            trans?.date ?? "",
                            style: theme.textTheme.bodyLarge!.copyWith(
                              color: AppColor.blackColor,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Service",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: theme.textTheme.titleMedium!.copyWith(
                              color: AppColor.blackColor,
                            ),
                          ),
                          trailing: SelectableText(
                            trans?.servicename ?? "",
                            style: theme.textTheme.bodyLarge!.copyWith(
                              color: AppColor.blackColor,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Status",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: theme.textTheme.titleMedium!.copyWith(
                              color: AppColor.blackColor,
                            ),
                          ),
                          trailing: SelectableText(
                            trans?.status?.capitalizeFirst ?? "processing",
                            style: theme.textTheme.titleMedium!.copyWith(
                              color: trans!.status?.capitalizeFirst == "success"
                                  ? Colors.green[00]
                                  : trans!.status?.capitalizeFirst ==
                                          "processing"
                                      ? Colors.yellow[800]
                                      : Colors.yellow[800],
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Description",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: theme.textTheme.titleMedium!.copyWith(
                              color: AppColor.blackColor,
                            ),
                          ),
                          subtitle: SelectableText(
                            trans?.servicedesc ?? "",
                            style: theme.textTheme.bodyLarge!.copyWith(
                              color: AppColor.blackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        Get.toNamed(AppRouteNames.main);
                      },
                      child: Text(
                        "Okay",
                        style: theme.textTheme.titleMedium!.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await Helper.captureAndShareReceipt(
                          controller: screenshotController,
                        );
                      },
                      iconAlignment: IconAlignment.end,
                      icon: Icon(
                        Icons.adaptive.share,
                      ),
                      label: const Text(
                        "Share",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ].animate(interval: 100.ms).fade().slideX(),
        ),
      ),
    );
  }
}
