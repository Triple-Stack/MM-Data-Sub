import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../../../controllers/controllers/airtime_controller.dart';
import '../../../../../core/routing/route_names.dart';
import '../../../../../core/theme/themes.dart';
import '../../../../../core/utils/app_helper.dart';
import '../../../../../core/utils/extentions.dart';
import '../../../../../model/airtime/telecoms.dart';
import '../../../../widgets/network_card.dart';
import '../../../../widgets/refresh_widget.dart';

class AirtimeScreen extends StatefulWidget {
  const AirtimeScreen({super.key});

  @override
  State<AirtimeScreen> createState() => _AirtimeScreenState();
}

class _AirtimeScreenState extends State<AirtimeScreen> {
  final airtimeController = Get.find<AirtimeController>();
  bool? isLoading = false;
  @override
  void initState() {
    super.initState();
    getNetworks();
  }

  getNetworks() async {
    if (airtimeController.telecomms == null) {
      try {
        setState(() {
          isLoading = true;
        });
        airtimeController.telecomms == null
            ? await airtimeController.getTelecoms()
            : null;

        selected = airtimeController.telecomms?.network?.first;
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      selected = airtimeController.telecomms?.network?.first;
    }
  }

  Network? selected;
  Type? services = Type(
    name: "Choose Airtime Type",
  );
  final amount = TextEditingController();
  final phone = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: isLoading!
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : airtimeController.telecomms == null ||
                      airtimeController.telecomms!.network!.isEmpty
                  ? RefreshWidget(
                      service: "Airtime",
                      onPressed: () {
                        getNetworks();
                      },
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Form(
                            key: formKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: SingleChildScrollView(
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
                                        "Airtime",
                                        style: theme.textTheme.titleMedium!
                                            .copyWith(
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
                                        airtimeController.telecomms!.network!
                                            .length, (index) {
                                      final network = airtimeController
                                          .telecomms?.network![index];
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            selected = network;
                                            services = Type(
                                              name: "Choose Airtime Type",
                                            );
                                          });
                                        },
                                        child: NetworkCard(
                                          network: network!.name,
                                          showBorder: selected == network,
                                        ),
                                      );
                                    }),
                                  ),
                                  const SizedBox(height: 32),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        "Airtime Type:",
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                      const SizedBox(height: 10),
                                      GestureDetector(
                                        onTap: () {
                                          showAdaptiveDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog.adaptive(
                                                title: Text(
                                                  "Choose Plan type",
                                                  style: theme
                                                      .textTheme.titleLarge,
                                                ),
                                                content: SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: selected!.type!
                                                        .map((value) {
                                                      return PopupMenuItem(
                                                        child:
                                                            Text(value.name!),
                                                        onTap: () {
                                                          setState(() {
                                                            services = value;
                                                            debugPrint(
                                                                "Type: ${value.toJson()}");
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
                                            controller: TextEditingController(
                                                text: services?.name ?? ""),
                                            decoration: InputDecoration(
                                              hintText: 'Choose Airtime Type',
                                              enabledBorder: enabledInputBorder,
                                              suffixIcon: Icon(
                                                Icons.expand_more,
                                                color:
                                                    theme.colorScheme.primary,
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value!.trim().isEmpty) {
                                                return 'Please select airtime type';
                                              } else if (value.trim() ==
                                                  "Choose Airtime Type") {
                                                return 'Please select airtime type';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        "Phone Number:",
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        keyboardType: TextInputType.phone,
                                        controller: phone,
                                        maxLength: 11,
                                        onChanged: (value) {
                                          if (value.trim().length >= 11) {
                                            context.dismissKeyboard();
                                          }
                                        },
                                        validator: (value) {
                                          if (value!.trim().isEmpty) {
                                            return "Enter Phone Number";
                                          }
                                          return null;
                                        },
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        decoration: InputDecoration(
                                          hintText: "e.g 080987654321",
                                          counterText: "",
                                          suffixIcon: IconButton(
                                            icon: const Icon(
                                                Icons.person_add_alt),
                                            onPressed: () async {
                                              await Helper.pickContact(
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
                                        "Enter Amount:",
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: amount,
                                        validator: (value) {
                                          if (value!.trim().isEmpty) {
                                            return "Enter Amount";
                                          }
                                          return null;
                                        },
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        decoration: const InputDecoration(
                                          hintText: "N500",
                                          counterText: "",
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              Get.toNamed(
                                AppRouteNames.confirmAirtime,
                                parameters: {
                                  "network": selected!.name!,
                                  "network-type": "${selected!.id!}",
                                  "airtime_type": services!.name!,
                                  "amount": amount.text.trim(),
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
    );
  }
}
