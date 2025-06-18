import 'package:banny_table/ui/carePlanForm/controllers/care_plan_form_controller.dart';
import 'package:get/get.dart';


class CarePlanFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CarePlanController>(
          () => CarePlanController(),
    );
  }
}
