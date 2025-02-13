import 'package:flutter/material.dart';

class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.name,
    this.onPressed,
    this.icon,
  });

  final String? name;
  final VoidCallback? onPressed;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: onPressed,
      title: Text(
        name!,
        style: theme.textTheme.bodyLarge,
      ),
      trailing: icon ??
          const Icon(
            Icons.arrow_forward_ios,
            size: 15,
          ),
    );
  }
}
