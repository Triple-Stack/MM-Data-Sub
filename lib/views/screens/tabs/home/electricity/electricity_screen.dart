import 'package:flutter_animate/flutter_animate.dart';

import '/controllers/controllers/electricity_controller.dart';
import '/model/home/electricity/electricity_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/themes.dart';
import '../../../../../core/utils/extentions.dart';
import '../../../../widgets/refresh_widget.dart';

class ElectricityScreen extends StatefulWidget {
  const ElectricityScreen({super.key});

  @override
  State<ElectricityScreen> createState() => _ElectricityScreenState();
}

class _ElectricityScreenState extends State<ElectricityScreen> {
  final _controller = Get.find<ElectrictyController>();
  bool? isLoading = false;
  @override
  void initState() {
    super.initState();
    getProviders();
  }

  getProviders() async {
    if (_controller.electriciticyProvidersModel == null) {
      try {
        setState(() {
          isLoading = true;
        });
        _controller.electriciticyProvidersModel == null
            ? await _controller.getElectrics()
            : null;
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  ElectriciticyData? selected = ElectriciticyData(
    provider: "Choose Provider",
  );
  String? providerId;
  final provider = TextEditingController();
  final amount = TextEditingController();
  final meterNumber = TextEditingController();
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
              : _controller.electriciticyProvidersModel == null ||
                      _controller.electriciticyProvidersModel!
                          .electriciticyData!.isEmpty
                  ? RefreshWidget(
                      service: "Electricity",
                      onPressed: () {
                        getProviders();
                      },
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Form(
                            key: formKey,
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
                                        "Electricity",
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
                                  const SizedBox(height: 32),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        "Select Provider:",
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
                                                  "Choose Provider",
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
                                                    children: _controller
                                                        .electriciticyProvidersModel!
                                                        .electriciticyData!
                                                        .map((value) {
                                                      return PopupMenuItem(
                                                        child: Text(
                                                          value.abbreviation!,
                                                        ),
                                                        onTap: () {
                                                          setState(() {
                                                            selected = value;
                                                            providerId =
                                                                "${value.provider}";
                                                            provider.text =
                                                                value.provider!;
                                                            debugPrint(
                                                              "Type: ${value.toJson()}",
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
                                            controller: TextEditingController(
                                                text: selected?.abbreviation ??
                                                    ""),
                                            decoration: InputDecoration(
                                              hintText: 'Choose Provider',
                                              enabledBorder: enabledInputBorder,
                                              suffixIcon: Icon(
                                                Icons.expand_more,
                                                color:
                                                    theme.colorScheme.primary,
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value!.trim().isEmpty) {
                                                return 'Please select Provider';
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
                                        "Company Name",
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        keyboardType: TextInputType.name,
                                        readOnly: true,
                                        controller: provider,
                                        validator: (value) {
                                          if (value!.trim().isEmpty) {
                                            return "Enter Company Name";
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                          hintText: "Abuja Electric",
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
                                        "Meter Number:",
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: meterNumber,
                                        maxLength: 11,
                                        onChanged: (value) {
                                          if (value.trim().length >= 11) {
                                            context.dismissKeyboard();
                                          }
                                        },
                                        validator: (value) {
                                          if (value!.trim().isEmpty) {
                                            return "Enter Meter Number";
                                          }
                                          return null;
                                        },
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        decoration: const InputDecoration(
                                          hintText: "9876543210",
                                          counterText: "",
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
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: amount,
                                        maxLength: 6,
                                        onChanged: (value) {
                                          if (value.trim().length >= 6) {
                                            context.dismissKeyboard();
                                          }
                                        },
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
                                        decoration: InputDecoration(
                                          hintText: "5000".toCurrency(),
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
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              _controller.verifyMeter(
                                providerId: providerId,
                                provider: provider.text.trim(),
                                meterNumber: meterNumber.text.trim(),
                                amount: amount.text.trim(),
                              );
                            }
                          },
                          child: const Text(
                            "Verify",
                          ),
                        )
                      ].animate(interval: 100.ms).fade().slideX(),
                    ),
        ),
      ),
    );
  }
}
