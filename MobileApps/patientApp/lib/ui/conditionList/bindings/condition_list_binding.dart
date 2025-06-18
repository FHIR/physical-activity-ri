import 'package:banny_table/ui/conditionList/controllers/condition_list_controller.dart';
import 'package:get/get.dart';

class ConditionListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConditionListController>(
      () => ConditionListController(),
    );
  }
}
