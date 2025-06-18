import 'package:banny_table/ui/carePlanList/controllers/care_plan_list_controller.dart';
import 'package:get/get.dart';

class CarePlanListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CarePlanListController>(
      () => CarePlanListController(),
    );
  }
}
