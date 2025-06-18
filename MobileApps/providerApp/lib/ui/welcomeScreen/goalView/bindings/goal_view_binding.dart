import 'package:banny_table/ui/welcomeScreen/goalView/controllers/goal_view_controller.dart';
import 'package:get/get.dart';


class GoalViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GoalViewController>(
          () => GoalViewController(),
    );
  }
}
