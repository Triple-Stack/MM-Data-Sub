import 'package:flutter_animate/flutter_animate.dart';

import '/core/routing/route_names.dart';
import '/core/utils/extentions.dart';
import '/model/data/success_model.dart';
import '/model/home/transactions_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_constants.dart';

class DataTransaction extends StatefulWidget {
  const DataTransaction({super.key});

  @override
  State<DataTransaction> createState() => _DataTransactionState();
}

class _DataTransactionState extends State<DataTransaction> {
  @override
  Widget build(BuildContext context) {
    DataSuccessModel? transactions = Get.arguments;
    final theme = Theme.of(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 1,
          backgroundColor: theme.colorScheme.surface,
          leading: const SizedBox.shrink(),
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
                              style: theme.textTheme.titleLarge!,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          title: Text(
                            "Service",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: theme.textTheme.titleMedium!,
                          ),
                          trailing: Text(
                            "${transactions!.servicename}",
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
                          trailing: Text(
                            "${transactions.amountPaid ?? 0}".toCurrency(),
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
                          trailing: Text(
                            "${transactions.previousBalance ?? 0}".toCurrency(),
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
                          trailing: Text(
                            "${transactions.newBalance ?? 0}".toCurrency(),
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
                          trailing: Text(
                            transactions.transactionRef ?? "",
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
                          trailing: Text(
                            transactions.status ?? "",
                            style: theme.textTheme.titleMedium!.copyWith(
                              color: transactions.status == "success"
                                  ? theme.colorScheme.primary
                                  : transactions.status == "processing"
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
                          trailing: Text(
                            transactions.timestamp ?? "",
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
                          subtitle: Text(
                            transactions.planDescription ?? "",
                            style: theme.textTheme.bodyLarge!,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          Get.toNamed(AppRouteNames.main);
                        },
                        child: const Text("Okay"),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final transaction = Transactions(
                            amount: transactions.amountPaid?.toInt() ?? 0,
                            date: "${transactions.timestamp}",
                            newbal: transactions.newBalance?.toInt() ?? 0,
                            oldbal: transactions.previousBalance?.toInt() ?? 0,
                            servicedesc: "${transactions.planDescription}",
                            servicename: "${transactions.servicename}",
                            status: "${transactions.status}",
                            transref: "${transactions.transactionRef}",
                          );
                          Get.toNamed(
                            AppRouteNames.receipt,
                            arguments: transaction,
                          );
                        },
                        child: const Text("View Receipt"),
                      ),
                    ),
                  ],
                ),
              ].animate(interval: 100.ms).fade().slideX(),
            ),
          ),
        ),
      ),
    );
  }
}
