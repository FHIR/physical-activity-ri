import 'package:banny_table/ui/configuration/controllers/configuration_controllers.dart';
import 'package:get/get.dart';

class ConfigurationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConfigurationController>(
      () => ConfigurationController(),
    );
  }
}
