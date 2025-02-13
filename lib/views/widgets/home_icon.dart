import 'package:flutter/material.dart';

class HomeIconCard extends StatelessWidget {
  const HomeIconCard({
    required this.icon,
    required this.name,
    required this.onPressed,
    this.iconColor,
    super.key,
  });
  final VoidCallback? onPressed;
  final String? icon;
  final String? name;
  final Color? iconColor;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.colorScheme.onSurface,
                width: 2,
              ),
            ),
            child: Image(
              image: AssetImage(icon!),
              height: 30,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "$name",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        )
      ],
    );
  }
}
