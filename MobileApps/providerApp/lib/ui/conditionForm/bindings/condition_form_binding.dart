import 'package:banny_table/ui/conditionForm/controllers/condition_form_controller.dart';
import 'package:get/get.dart';


class ConditionFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConditionController>(
          () => ConditionController(),
    );
  }
}
