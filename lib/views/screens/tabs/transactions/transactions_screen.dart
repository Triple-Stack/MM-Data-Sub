import 'package:flutter_animate/flutter_animate.dart';

import '/core/routing/route_names.dart';
import '/core/theme/themes.dart';
import '/model/home/transactions_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:searchable_listview/searchable_listview.dart';
import '../../../../../controllers/controllers/auth_controller.dart';
import '../../../widgets/transaction_tile.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  ScreenshotController screenshotController = ScreenshotController();
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
      await authController.getTransactions();
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
        centerTitle: true,
        leading: const SizedBox.shrink(),
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          "Transactions",
          style: theme.textTheme.titleMedium,
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
                  child: SearchableList<Transactions>(
                    initialList:
                        authController.transactionsModel!.transactions!,
                    itemBuilder: (Transactions? transaction) {
                      return TransactionTile(
                        transaction: transaction,
                        onPressed: () {
                          Get.toNamed(
                            AppRouteNames.transaction,
                            arguments: transaction,
                          );
                        },
                      ).animate().fade().slideX();
                    },
                    filter: (value) =>
                        authController.transactionsModel!.transactions!.where(
                      (element) {
                        // Define your multiple conditions here
                        bool matchesDate = element.date!.contains(value);
                        bool matchesAmount =
                            "${element.amount!}".contains(value);
                        bool service = element.servicename!.contains(value);
                        bool description = element.servicedesc!.contains(value);
                        // Return true if all conditions are met
                        return matchesDate ||
                            matchesAmount ||
                            service ||
                            description;
                      },
                    ).toList(),
                    emptyWidget: Center(
                      child: Text(
                        "No Transaction",
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    inputDecoration: InputDecoration(
                      labelText: "Search Transaction",
                      focusedBorder: enabledInputBorder,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
