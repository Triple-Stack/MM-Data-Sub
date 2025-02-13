import 'package:flutter_animate/flutter_animate.dart';

import '/core/theme/themes.dart';
import '/core/utils/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../controllers/controllers/data_controller.dart';
import '../../../../../core/routing/route_names.dart';
import '../../../../../core/utils/extentions.dart';
import '../../../../../model/data/data_bundles.dart';
import '../../../../widgets/network_card.dart';
import '../../../../widgets/refresh_widget.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final dataController = Get.find<DataController>();
  final phone = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool? isLoading = false;
  @override
  void initState() {
    getDataBundles();
    super.initState();
  }

  getDataBundles() async {
    if (dataController.dataBundles == null) {
      setState(() {
        isLoading = true;
      });
      try {
        await dataController.getDataBundles();
        selected = dataController.dataBundles!.network!.first;
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      selected = dataController.dataBundles!.network!.first;
    }
  }

  String amount = "0.0";

  Network? selected;
  Type? types;
  Plans? plans;
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
            : dataController.dataBundles == null ||
                    dataController.dataBundles!.network!.isEmpty
                ? RefreshWidget(
                    service: "Data",
                    onPressed: () {
                      getDataBundles();
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
                                      "Data",
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: List.generate(
                                      Helper.sortedNetworks.length, (index) {
                                    final network =
                                        Helper.sortedNetworks[index];
                                    return InkWell(
                                      onTap: () async {
                                        setState(() {
                                          selected = network;
                                          plans = null;
                                          types = null;
                                          amount = "0.0";
                                          context.dismissKeyboard();
                                        });
                                      },
                                      child: NetworkCard(
                                        network: network.name!,
                                        showBorder: selected == network,
                                      ),
                                    );
                                  }),
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
                                                    "Data Type:",
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
                                                              "Choose Data type",
                                                              style: theme
                                                                  .textTheme
                                                                  .titleLarge,
                                                            ),
                                                            content: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .stretch,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: selected!
                                                                  .type!
                                                                  .map((value) {
                                                                return PopupMenuItem(
                                                                  child: Text(
                                                                      value
                                                                          .name!),
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      types =
                                                                          value;
                                                                      debugPrint(
                                                                        "Data: ${value.toJson()}",
                                                                      );
                                                                    });
                                                                  },
                                                                );
                                                              }).toList(),
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
                                                                text: types
                                                                        ?.name ??
                                                                    ""),
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'Select a Data Type',
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
                                                          } else if (value
                                                                  .trim() ==
                                                              "Choose Data type") {
                                                            return 'Please choose Data Type';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        types == null
                                            ? const SizedBox.shrink()
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  const SizedBox(height: 16),
                                                  Text(
                                                    "Plan Type:",
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
                                                              "Choose Plan type",
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
                                                                children: types!
                                                                    .plans!
                                                                    .map(
                                                                        (value) {
                                                                  return PopupMenuItem(
                                                                    child: Text(
                                                                        value.name ??
                                                                            ""),
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        plans =
                                                                            value;
                                                                        amount =
                                                                            "${value.price ?? "0"}";
                                                                        debugPrint(
                                                                          "Plans: ${value.toJson()}",
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
                                                                text: plans
                                                                        ?.name ??
                                                                    ""),
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'Select a Plan',
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
                                                            return 'Please select a plan';
                                                          } else if (value
                                                                  .trim() ==
                                                              "Choose plan") {
                                                            return 'Please select a plan';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        plans == null
                                            ? const SizedBox.shrink()
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  const SizedBox(height: 16),
                                                  Text(
                                                    "Phone Number:",
                                                    style: theme
                                                        .textTheme.bodyMedium,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  TextFormField(
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    controller: phone,
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
                                                        return "Enter Phone Number";
                                                      }
                                                      return null;
                                                    },
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                    ],
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          "e.g 080987654321",
                                                      counterText: "",
                                                      suffixIcon: IconButton(
                                                        icon: const Icon(Icons
                                                            .person_add_alt),
                                                        onPressed: () async {
                                                          await Helper
                                                              .pickContact(
                                                            context: context,
                                                            controller: phone,
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
                                                padding:
                                                    const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  border: Border.all(
                                                    color: theme
                                                        .colorScheme.primary,
                                                  ),
                                                ),
                                                child: Text(
                                                  amount.toCurrency(),
                                                  style:
                                                      theme.textTheme.bodyLarge,
                                                )),
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
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                Get.toNamed(
                                  AppRouteNames.confirmData,
                                  parameters: {
                                    "network-code": "${selected?.id}",
                                    "network-name": "${selected?.name}",
                                    "data-code": "${plans?.pId}",
                                    "amount": amount,
                                    "data": "${plans?.name}",
                                    "data-type": "${plans?.type}",
                                    "phone": phone.text.trim(),
                                  },
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
      await dataController.getDataBundles();
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
