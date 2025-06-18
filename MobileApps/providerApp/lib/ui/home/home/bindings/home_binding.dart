import 'package:banny_table/ui/bottomNavigation/controllers/bottom_navigation_controller.dart';
import 'package:get/get.dart';

import '../controllers/home_controllers.dart';


class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeControllers>(
          () => HomeControllers(),
    );
    Get.lazyPut<BottomNavigationController>(
          () => BottomNavigationController(),
      fenix: true
    );
  }
}
