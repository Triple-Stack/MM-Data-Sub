import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_assets.dart';

import '../../../../../controllers/controllers/auth_controller.dart';

class BonusToWalletScreen extends StatefulWidget {
  const BonusToWalletScreen({super.key});

  @override
  State<BonusToWalletScreen> createState() => _BonusToWalletScreenState();
}

class _BonusToWalletScreenState extends State<BonusToWalletScreen> {
  final _authController = Get.find<AuthController>();

  final _amountController = TextEditingController();
  final _amountNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _amountController.dispose();
    _amountNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        leading: BackButton(
          color: theme.colorScheme.onSurface,
        ),
        title: Text(
          "Convert Bonus to Wallet",
          style: theme.textTheme.titleLarge,
        ),
        centerTitle: true,
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
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Convert your bonus to balance",
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium!,
                        ),
                        Text(
                          "You can use your balance to buy airtime, data, cable, etc.",
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge!,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _amountController,
                          focusNode: _amountNode,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return "Enter Amount";
                            } else if (_authController.user!.data!.bonus! <=
                                0) {
                              return "You have no bonus available to convert.";
                            } else if (int.tryParse(value.trim())! >=
                                _authController.user!.data!.bonus!) {
                              return "The requested amount exceeds your available bonus.";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Amount",
                            hintText: "e.g 500",
                            prefixIcon: Icon(
                              Icons.account_balance_wallet_outlined,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _amountNode.unfocus();
                    await _authController.convertBonus(
                      amount: _amountController.text.trim(),
                    );
                  }
                },
                child: const Text(
                  "Convert",
                ),
              ),
            ].animate(interval: 100.ms).fade().slideX(),
          ),
        ),
      ),
    );
  }
}

class AccountCard extends StatelessWidget {
  const AccountCard({
    super.key,
    required this.bankAccount,
    required this.bankName,
  });

  final String? bankName;
  final String? bankAccount;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text(
        "$bankName",
        style: theme.textTheme.titleMedium,
      ),
      subtitle: bankAccount == ""
          ? null
          : Text(
              "$bankAccount",
              style: theme.textTheme.bodyLarge,
            ),
      trailing: IconButton(
        onPressed: bankAccount == ""
            ? null
            : () async {
                await Clipboard.setData(
                  ClipboardData(text: "$bankAccount"),
                );
              },
        icon: const Icon(
          size: 20,
          Icons.copy,
        ),
      ),
    );
  }
}

class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.name,
    required this.title,
  });

  final String? name;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text(
        title!,
        style: theme.textTheme.titleMedium,
      ),
      subtitle: Text(
        name!,
        style: theme.textTheme.bodyLarge!.copyWith(
          fontFamily: "roboto",
        ),
      ),
      trailing: IconButton(
        onPressed: () async {
          await Clipboard.setData(
            ClipboardData(text: name!),
          );
          EasyLoading.showToast(
            "Copied $name",
            dismissOnTap: true,
            maskType: EasyLoadingMaskType.clear,
          );
        },
        icon: const Icon(
          Icons.copy,
        ),
      ),
    );
  }
}

class ProfileHead extends StatelessWidget {
  const ProfileHead({
    super.key,
    required this.authController,
  });
  final AuthController? authController;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Center(
          child: Image(
            image: AssetImage(AppAssets.account),
            height: 100,
            fit: BoxFit.fill,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "${authController!.user!.data!.email}",
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium,
        ),
        Text(
          "${authController!.user!.data!.fname} ${authController!.user!.data!.lname}",
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
