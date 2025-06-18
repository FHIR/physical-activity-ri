import 'package:banny_table/ui/welcomeScreen/healthProvider/intro/controllers/health_provider_intro_controller.dart';
import 'package:get/get.dart';


class HealthProviderIntroBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HealthProviderIntroController>(
          () => HealthProviderIntroController(),
    );
  }
}
