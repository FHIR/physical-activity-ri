import 'package:get/get.dart';

import '../controllers/create_Practitioner_controller.dart';


class CreatePractitionerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreatePractitionerController>(
          () => CreatePractitionerController(),
    );
  }
}
