import 'package:get/get.dart';

import '../controllers/goal_form_controller.dart';

class GoalFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GoalFormController>(
      () => GoalFormController(),
    );
  }
}
