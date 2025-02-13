import 'package:carousel_slider/carousel_slider.dart';
import '/model/authentication/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AccountCarousel extends StatelessWidget {
  final List<Accounts>? accounts;
  const AccountCarousel({
    required this.accounts,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: accounts!.map((account) {
        return Builder(
          builder: (BuildContext context) {
            final theme = Theme.of(context);
            return ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: theme.colorScheme.primary,
              title: Text(
                account.bank!,
                style: theme.textTheme.titleMedium!.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              subtitle: Text(
                "${account.account ?? 0}",
                style: theme.textTheme.titleMedium!.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              trailing: InkWell(
                onTap: () async {
                  await Clipboard.setData(
                    ClipboardData(text: "${account.account}"),
                  ).then((_) {
                    EasyLoading.showToast("${account.account} Copied");
                  });
                },
                child: Icon(
                  Icons.copy,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            );
          },
        );
      }).toList(),
      options: CarouselOptions(
        height: 80,
        viewportFraction: .9,
        autoPlay: false,
        enlargeCenterPage: true,
        pauseAutoPlayInFiniteScroll: true,
      ),
    );
  }
}
