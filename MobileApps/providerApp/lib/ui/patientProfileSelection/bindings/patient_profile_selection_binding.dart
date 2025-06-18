import 'package:get/get.dart';

import '../controllers/patient_profile_selection_controller.dart';


class PatientProfileSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientProfileSelectionController>(
          () => PatientProfileSelectionController(),
    );
  }
}
