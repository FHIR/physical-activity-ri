import 'package:banny_table/ui/welcomeScreen/integration/controllers/integration_controller.dart';
import 'package:get/get.dart';


class IntegrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IntegrationController>(
          () => IntegrationController(),
    );
  }
}
