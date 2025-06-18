import 'package:banny_table/ui/bottomNavigation/controllers/bottom_navigation_controller.dart';
import 'package:get/get.dart';
import '../controllers/history_controller.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryController>(
          () => HistoryController(),
    );
    Get.lazyPut<BottomNavigationController>(
          () => BottomNavigationController(),
      fenix: true
    );
  }
}
