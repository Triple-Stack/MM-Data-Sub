import 'package:flutter_animate/flutter_animate.dart';

import '/core/routing/route_names.dart';
import '/core/utils/extentions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../model/home/transactions_model.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  Widget build(BuildContext context) {
    Transactions? trans = Get.arguments;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        backgroundColor: theme.colorScheme.surface,
        leading: BackButton(
          color: theme.colorScheme.onSurface,
        ),
        title: Text(
          "Transaction Detail",
          style: theme.textTheme.titleMedium,
        ),
      ),
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ListTile(
                        title: Text(
                          "Service",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: theme.textTheme.titleMedium!,
                        ),
                        trailing: SelectableText(
                          trans?.servicename ?? "",
                          style: theme.textTheme.bodyLarge!,
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "Amount",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: theme.textTheme.titleMedium!,
                        ),
                        trailing: SelectableText(
                          "${trans?.amount ?? 0}".toCurrency(),
                          style: theme.textTheme.bodyLarge!,
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "New Balance",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: theme.textTheme.titleMedium!,
                        ),
                        trailing: SelectableText(
                          "${trans?.newbal ?? 0}".toCurrency(),
                          style: theme.textTheme.bodyLarge!,
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "Old Balance",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: theme.textTheme.titleMedium!,
                        ),
                        trailing: SelectableText(
                          "${trans?.oldbal ?? 0}".toCurrency(),
                          style: theme.textTheme.bodyLarge!,
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "Reference",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: theme.textTheme.titleMedium!,
                        ),
                        trailing: SelectableText(
                          trans?.transref ?? "",
                          style: theme.textTheme.bodyLarge!,
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "Status",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: theme.textTheme.titleMedium!,
                        ),
                        trailing: SelectableText(
                          trans?.status ?? "",
                          style: theme.textTheme.titleMedium!.copyWith(
                            color: trans?.status?.capitalizeFirst == "success"
                                ? theme.colorScheme.primary
                                : trans?.status?.capitalizeFirst == "processing"
                                    ? theme.colorScheme.secondary
                                    : theme.colorScheme.error,
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "Date",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: theme.textTheme.titleMedium!,
                        ),
                        trailing: SelectableText(
                          trans?.date ?? "",
                          style: theme.textTheme.bodyLarge!,
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "Description",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: theme.textTheme.titleMedium!,
                        ),
                        subtitle: SelectableText(
                          trans?.servicedesc ?? "",
                          style: theme.textTheme.bodyLarge!,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Get.toNamed(
                    AppRouteNames.receipt,
                    arguments: trans,
                  );
                },
                child: const Text("View Receipt"),
              ),
            ].animate(interval: 100.ms).fade().slideX(),
          ),
        ),
      ),
    );
  }
}

class ReceiptWidget extends StatelessWidget {
  const ReceiptWidget({
    super.key,
    required this.screenshotController,
    required this.theme,
    required this.transactions,
  });

  final ScreenshotController screenshotController;
  final ThemeData theme;
  final Transactions? transactions;

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Receipt",
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            ListTile(
              title: Text(
                "Service",
                style: theme.textTheme.titleMedium,
              ),
              subtitle: Text(
                transactions?.servicename ?? "",
                style: theme.textTheme.bodyLarge,
              ),
            ),
            ListTile(
              title: Text(
                "Amount",
                style: theme.textTheme.titleMedium,
              ),
              subtitle: Text(
                "${transactions?.amount ?? 0}".toCurrency(),
                style: theme.textTheme.bodyLarge,
              ),
            ),
            ListTile(
              title: Text(
                "New Balance",
                style: theme.textTheme.titleMedium,
              ),
              subtitle: Text(
                "${transactions?.newbal ?? 0}".toCurrency(),
                style: theme.textTheme.bodyLarge,
              ),
            ),
            ListTile(
              title: Text(
                "Old Balance",
                style: theme.textTheme.titleMedium,
              ),
              subtitle: Text(
                "${transactions?.oldbal ?? 0}".toCurrency(),
                style: theme.textTheme.bodyLarge,
              ),
            ),
            ListTile(
              title: Text(
                "Description",
                style: theme.textTheme.titleMedium,
              ),
              subtitle: Text(
                transactions?.servicedesc ?? "",
                style: theme.textTheme.bodyLarge,
              ),
            ),
            ListTile(
              title: Text(
                "Reference",
                style: theme.textTheme.titleMedium,
              ),
              subtitle: Text(
                transactions?.transref ?? "",
                style: theme.textTheme.bodyLarge,
              ),
            ),
            ListTile(
              title: Text(
                "Status",
                style: theme.textTheme.titleMedium,
              ),
              subtitle: Text(
                transactions?.status ?? "",
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: transactions?.status == "success"
                      ? theme.colorScheme.primary
                      : transactions?.status == "processing"
                          ? theme.colorScheme.secondary
                          : theme.colorScheme.error,
                ),
              ),
            ),
            ListTile(
              title: Text(
                "Date",
                style: theme.textTheme.titleMedium,
              ),
              subtitle: Text(
                transactions?.date ?? "",
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
