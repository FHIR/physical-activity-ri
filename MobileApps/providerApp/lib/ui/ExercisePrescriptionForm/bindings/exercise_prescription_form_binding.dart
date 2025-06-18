import 'package:get/get.dart';

import '../controllers/exercise_prescription_form_controller.dart';

class ExercisePrescriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExercisePrescriptionController>(
          () => ExercisePrescriptionController(),
    );
  }
}
