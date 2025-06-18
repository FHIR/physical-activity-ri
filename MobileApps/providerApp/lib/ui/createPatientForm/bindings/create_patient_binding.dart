import 'package:get/get.dart';

import '../controllers/create_patient_controller.dart';


class CreatePatientBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreatePatientController>(
          () => CreatePatientController(),
    );
  }
}
