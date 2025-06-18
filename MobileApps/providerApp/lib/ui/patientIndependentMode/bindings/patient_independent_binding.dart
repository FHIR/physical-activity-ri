import 'package:get/get.dart';
import '../controllers/patient_independent_controller.dart';

class PatientIndependentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientIndependentController>(
          () => PatientIndependentController(),
    );
  }
}
