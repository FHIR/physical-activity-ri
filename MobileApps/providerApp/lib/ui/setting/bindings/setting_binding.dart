import 'package:banny_table/ui/setting/controllers/setting_controller.dart';
import 'package:get/get.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingController>(
          () => SettingController(),
    );
  }
}
