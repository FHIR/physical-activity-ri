import 'package:get/get.dart';

import '../controllers/goal_list_controller.dart';

class GoalListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GoalListController>(
          () => GoalListController(),
    );
  }
}
