import 'package:banny_table/ui/patientUserList/controllers/patient_user_list_controller.dart';
import 'package:get/get.dart';


class PatientListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientUserListController>(
          () => PatientUserListController(),
    );
  }
}
