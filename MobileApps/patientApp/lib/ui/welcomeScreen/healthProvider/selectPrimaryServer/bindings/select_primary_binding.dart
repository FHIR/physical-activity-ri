import 'package:banny_table/ui/welcomeScreen/healthProvider/selectPrimaryServer/controllers/select_primary_controller.dart';
import 'package:get/get.dart';

class SelectPrimaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectPrimaryController>(
          () => SelectPrimaryController(),
    );
   /* Get.lazyPut<HealthProviderController>(
            () => HealthProviderController(),
        fenix: true
    );*/
  }
}
