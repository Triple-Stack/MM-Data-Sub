import 'package:flutter_animate/flutter_animate.dart';
import '/views/widgets/service_card.dart';

import '/controllers/controllers/cable_controller.dart';
import '/core/theme/themes.dart';
import '/core/utils/app_helper.dart';
import '/model/cable_tv/cables_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/extentions.dart';
import '../../../../../model/data/data_bundles.dart';
import '../../../../widgets/refresh_widget.dart';

class CableScreen extends StatefulWidget {
  const CableScreen({super.key});

  @override
  State<CableScreen> createState() => _CableScreenState();
}

class _CableScreenState extends State<CableScreen> {
  final _cableController = Get.find<CableTvController>();
  final cardNumber = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool? isLoading = false;
  @override
  void initState() {
    getCables();
    super.initState();
  }

  getCables() async {
    if (_cableController.cableProvidersModel == null) {
      setState(() {
        isLoading = true;
      });
      try {
        await _cableController.getCables();
        selected = _cableController.cableProvidersModel!.cableProviders!.first;
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      selected = _cableController.cableProvidersModel!.cableProviders!.first;
    }
  }

  String amount = "0.0";
  String? provider;

  CableProviders? selected;
  CablePlans? cablePlans;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: isLoading!
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : _cableController.cableProvidersModel == null ||
                    _cableController
                        .cableProvidersModel!.cableProviders!.isEmpty
                ? RefreshWidget(
                    service: "Cable",
                    onPressed: () {
                      getCables();
                    },
                  )
                : Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () => Get.back(),
                                      child: const Icon(
                                        Icons.arrow_back_ios,
                                      ),
                                    ),
                                    Text(
                                      "Cable",
                                      style:
                                          theme.textTheme.titleMedium!.copyWith(
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    const Opacity(
                                      opacity: 0,
                                      child: Icon(
                                        Icons.arrow_back_ios,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Divider(
                                  color: theme.colorScheme.primary
                                      .withValues(alpha: .2),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  height: context.deviceSize.height * .08,
                                  child: ListView.builder(
                                    itemCount: _cableController
                                        .cableProvidersModel
                                        ?.cableProviders!
                                        .length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final network = _cableController
                                          .cableProvidersModel
                                          ?.cableProviders![index];
                                      return Row(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              setState(() {
                                                selected = network;
                                                amount = "0.0";
                                                provider = "${network?.cId}";
                                                cablePlans = null;
                                                context.dismissKeyboard();
                                              });
                                            },
                                            child: ServiceCard(
                                              network: network?.provider ??
                                                  "No Name",
                                              showBorder: selected == network,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        const SizedBox(height: 32),
                                        selected == null
                                            ? const SizedBox.shrink()
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Text(
                                                    "Cable Type:",
                                                    style: theme
                                                        .textTheme.bodyMedium,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  GestureDetector(
                                                    onTap: () {
                                                      showAdaptiveDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog
                                                              .adaptive(
                                                            title: Text(
                                                              "Choose Cable type",
                                                              style: theme
                                                                  .textTheme
                                                                  .titleLarge,
                                                            ),
                                                            content:
                                                                SingleChildScrollView(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .stretch,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: selected!
                                                                    .plans!
                                                                    .map(
                                                                        (value) {
                                                                  return PopupMenuItem(
                                                                    child: Text(
                                                                        value
                                                                            .name!),
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        cablePlans =
                                                                            value;
                                                                        amount =
                                                                            "${value.price}";
                                                                        debugPrint(
                                                                          "Cable: ${value.toJson()}",
                                                                        );
                                                                      });
                                                                    },
                                                                  );
                                                                }).toList(),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: AbsorbPointer(
                                                      child: TextFormField(
                                                        readOnly: true,
                                                        controller:
                                                            TextEditingController(
                                                                text: cablePlans
                                                                        ?.name ??
                                                                    ""),
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'Select a Cable Plan',
                                                          enabledBorder:
                                                              enabledInputBorder,
                                                          suffixIcon: Icon(
                                                            Icons.expand_more,
                                                            color: theme
                                                                .colorScheme
                                                                .primary,
                                                          ),
                                                        ),
                                                        validator: (value) {
                                                          if (value!
                                                              .trim()
                                                              .isEmpty) {
                                                            return 'Please choose Data Type';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        cablePlans == null
                                            ? const SizedBox.shrink()
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  const SizedBox(height: 16),
                                                  Text(
                                                    "Decoder Number:",
                                                    style: theme
                                                        .textTheme.bodyMedium,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  TextFormField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    controller: cardNumber,
                                                    maxLength: 11,
                                                    onChanged: (value) {
                                                      if (value.trim().length >=
                                                          11) {
                                                        context
                                                            .dismissKeyboard();
                                                      }
                                                    },
                                                    validator: (value) {
                                                      if (value!
                                                          .trim()
                                                          .isEmpty) {
                                                        return "Enter Decoder Number";
                                                      }
                                                      return null;
                                                    },
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                    ],
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          "e.g 789987654321",
                                                      counterText: "",
                                                      suffixIcon: IconButton(
                                                        icon: const Icon(Icons
                                                            .person_add_alt),
                                                        onPressed: () async {
                                                          await Helper
                                                              .pickContact(
                                                            context: context,
                                                            controller:
                                                                cardNumber,
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                        const SizedBox(height: 16),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              "Amount:",
                                              style: theme.textTheme.bodyMedium,
                                            ),
                                            const SizedBox(height: 10),
                                            Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                  color:
                                                      theme.colorScheme.primary,
                                                ),
                                              ),
                                              child: Text(
                                                amount.toCurrency(),
                                                style:
                                                    theme.textTheme.bodyLarge,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                await _cableController.verifyCable(
                                  provider: provider,
                                  planName: cablePlans!.name,
                                  cardNumber: cardNumber.text.trim(),
                                  amount: amount,
                                );
                              }
                            },
                            child: const Text(
                              "Purchase",
                            ),
                          )
                        ].animate(interval: 100.ms).fade().slideX(),
                      ),
                    ),
                  ),
      ),
    );
  }

  Future<void> loadBundles({required String? network}) async {
    try {
      setState(() {
        isLoading = true;
      });
      await _cableController.getCables();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

class DropDownOption extends StatelessWidget {
  const DropDownOption({
    super.key,
    required this.selectedService,
    required this.items,
  });

  final ValueNotifier<Network> selectedService;

  final List<Network> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: theme.colorScheme.primary,
        ),
      ),
      child: PopupMenuButton(
        itemBuilder: (context) => items.map((value) {
          return PopupMenuItem(
            child: Text(value.name!),
            onTap: () {
              selectedService.value = value;
              debugPrint("Data: ${value.toJson()}");
            },
          );
        }).toList(),
        child: ValueListenableBuilder(
          valueListenable: selectedService,
          builder: ((context, value, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    selectedService.value.name!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                Icon(
                  Icons.expand_more,
                  color: theme.colorScheme.primary,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
