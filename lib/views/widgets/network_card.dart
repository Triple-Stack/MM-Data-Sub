import 'package:flutter/material.dart';

import '../../core/utils/app_assets.dart';

class NetworkCard extends StatelessWidget {
  const NetworkCard({
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

    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(50),
      shadowColor: theme.colorScheme.primary,
      child: Container(
        // Outer container for the border
        padding:
            EdgeInsets.all(showBorder! ? 3 : 1), // Adds padding for the border
        // decoration: BoxDecoration(
        //   shape: BoxShape.circle,
        //   border: Border.all(
        //     width: showBorder! ? 4 : 1, // Thicker border when selected
        //     color: showBorder!
        //         ? theme.colorScheme.secondary
        //         : theme.colorScheme.secondary.withValues(alpha: 0.4),
        //   ),
        // ),
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(radius ?? 20),
          shape: BoxShape.circle,
          color: showBorder! ? theme.colorScheme.primary : Colors.transparent,
          border: Border.all(
            width: 8,
            color:
                !showBorder! ? Colors.transparent : theme.colorScheme.primary,
          ),
        ),
        child: Container(
          // Inner container for the image
          alignment: Alignment.center,

          height: 50,
          width: 50,
          clipBehavior: Clip.antiAlias, // Ensure it clips properly
          decoration: const BoxDecoration(
            shape: BoxShape.circle, // Inner shape is also circular
          ),
          child: Image(
            image: AssetImage(
              network!.toLowerCase() == "9mobile"
                  ? AppAssets.etisalat
                  : "assets/${network!.toLowerCase()}.png",
            ),
            fit: BoxFit.cover, // Ensures the image covers the container
          ),
        ),
      ),
    );
  }
}
