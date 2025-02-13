import 'package:get/get.dart';

import '../controllers/education_controller.dart';

class ExamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EducationController>(
      () => EducationController(),
    );
  }
}
