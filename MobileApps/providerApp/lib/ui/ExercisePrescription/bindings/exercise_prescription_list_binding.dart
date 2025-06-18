import 'package:banny_table/ui/ExercisePrescription/controllers/exercise_prescription_list_controller.dart';
import 'package:get/get.dart';


class ExercisePrescriptionListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExercisePrescriptionListController>(
          () => ExercisePrescriptionListController(),
    );
  }
}
