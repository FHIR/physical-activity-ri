import 'package:banny_table/ui/welcomeScreen/healthProvider/patientList/controllers/patient_list_controller.dart';
import 'package:get/get.dart';


class PatientListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientListController>(
          () => PatientListController(),
    );
  }
}
