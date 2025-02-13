import 'package:flutter_animate/flutter_animate.dart';

import '/core/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/utils/app_helper.dart';

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: PopScope(
        canPop: false,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: Helper.introductionMessges.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox.shrink(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Image(
                                  image: AssetImage(
                                      Helper.introductionMessges[index].image!),
                                  height: 100,
                                  // color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  Helper.introductionMessges[index].title!,
                                  textAlign: TextAlign.center,
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  Helper.introductionMessges[index].subtitle!,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge!,
                                ),
                              ],
                            ),
                            const SizedBox.shrink(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Center(
                        child: SmoothPageIndicator(
                          controller: pageController,
                          onDotClicked: (value) {
                            pageController.animateToPage(
                              value,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                          effect: WormEffect(
                            activeDotColor:
                                Theme.of(context).colorScheme.primary,
                            dotColor: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withValues(alpha: .5),
                            dotHeight: 10,
                            dotWidth: 10,
                            type: WormType.thin,
                          ),
                          count: Helper.introductionMessges.length,
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () {
                          Get.toNamed(AppRouteNames.login);
                        },
                        child: const Text(
                          "Get Started",
                        ),
                      ),
                      const SizedBox(height: 10),
                    ].animate(interval: 100.ms).fade().slideX(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
