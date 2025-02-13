import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    super.key,
    required this.network,
    this.radius,
    this.showBorder = false,
  });

  final String? network;
  final double? radius;
  final bool? showBorder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      alignment: Alignment.center,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 20),
        color: showBorder!
            ? theme.colorScheme.secondary
            : theme.colorScheme.secondary.withValues(alpha: .2),
        border: Border.all(
          width: 2,
          color: !showBorder!
              ? theme.colorScheme.onSurface.withValues(alpha: .5)
              : theme.colorScheme.secondary,
        ),
      ),
      child: Text(
        "$network",
        style: theme.textTheme.bodyLarge!.copyWith(
          color: !showBorder!
              ? theme.colorScheme.onSurface
              : theme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
