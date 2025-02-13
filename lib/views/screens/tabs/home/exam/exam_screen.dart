import 'package:flutter_animate/flutter_animate.dart';
import '/views/widgets/service_card.dart';

import '/controllers/controllers/education_controller.dart';
import '/model/home/exam/exams_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/routing/route_names.dart';
import '../../../../../core/utils/extentions.dart';
import '../../../../../model/data/data_bundles.dart';

import '../../../../widgets/refresh_widget.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  final _controller = Get.find<EducationController>();
  final formKey = GlobalKey<FormState>();
  bool? isLoading = false;
  @override
  void initState() {
    getExams();
    super.initState();
  }

  getExams() async {
    if (_controller.examsModel == null) {
      setState(() {
        isLoading = true;
      });
      try {
        await _controller.getExams();
        selected = _controller.examsModel?.examCards?.first;
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      selected = _controller.examsModel?.examCards?.first;
    }
  }

  ExamCard? selected = ExamCard(
    provider: "choose Exam Type",
  );

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
            : _controller.examsModel == null ||
                    _controller.examsModel!.examCards!.isEmpty
                ? RefreshWidget(
                    service: "Exam PIN",
                    onPressed: () {
                      getExams();
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
                                      "Exam PIN",
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
                                Text(
                                  "Exam type:",
                                  style: theme.textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: context.deviceSize.height * .08,
                                  child: ListView.builder(
                                    itemCount: _controller
                                        .examsModel!.examCards!.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final network = _controller
                                          .examsModel!.examCards![index];
                                      return Row(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              setState(() {
                                                selected = network;
                                                context.dismissKeyboard();
                                              });
                                            },
                                            child: ServiceCard(
                                              network: network.provider!,
                                              showBorder: selected == network,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
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
                                                "${selected?.price ?? "0"}"
                                                    .toCurrency(),
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
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                Get.toNamed(
                                  AppRouteNames.confirmExam,
                                  parameters: {
                                    "providerCode": "${selected!.provider}",
                                    "providerName": "${selected!.provider}",
                                    "price": "${selected?.price ?? "0"}",
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
