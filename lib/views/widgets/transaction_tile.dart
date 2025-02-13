import '/model/home/transactions_model.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utils/extentions.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.transaction,
    required this.onPressed,
  });

  final Transactions? transaction;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: onPressed,
      // onTap: () {
      //   Get.toNamed(
      //     AppRouteNames.transaction,
      //     arguments: transaction,
      //   );
      // },
      title: Text(
        "${transaction?.servicename}",
        style: theme.textTheme.titleMedium,
      ),
      subtitle: Text(
        "${transaction?.servicedesc}",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyMedium,
      ),
      trailing: Text(
        "${transaction?.amount}".toCurrency(),
        style: theme.textTheme.titleMedium,
      ),
    );
  }
}
