import 'package:banny_table/ui/bottomNavigation/controllers/bottom_navigation_controller.dart';
import 'package:banny_table/ui/setting/controllers/setting_controller.dart';
import 'package:get/get.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingController>(
          () => SettingController(),
    );

    Get.lazyPut<BottomNavigationController>(
            () => BottomNavigationController(),
        fenix: true
    );
  }
}
