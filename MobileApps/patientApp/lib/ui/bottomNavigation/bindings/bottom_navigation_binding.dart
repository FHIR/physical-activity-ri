import 'package:banny_table/ui/graph/controllers/graph_controller.dart';
import 'package:banny_table/ui/history/controllers/history_controller.dart';
import 'package:banny_table/ui/home/monthly/controllers/home_monthly_controllers.dart';
import 'package:banny_table/ui/mixed/controllers/mixed_controller.dart';
import 'package:get/get.dart';

import '../../home/activityLog/controllers/home_controllers.dart';
import '../../setting/controllers/setting_controller.dart';
import '../controllers/bottom_navigation_controller.dart';

class BottomNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavigationController>(
      () => BottomNavigationController(),
    );

    Get.lazyPut<HomeControllers>(() => HomeControllers(), fenix: true);
    Get.lazyPut<HistoryController>(() => HistoryController(), fenix: true);
    Get.lazyPut<GraphController>(() => GraphController(), fenix: true);
    Get.lazyPut<SettingController>(() => SettingController(), fenix: true);
    Get.lazyPut<MixedController>(() => MixedController(), fenix: true);
    Get.lazyPut<HomeMonthlyControllers>(() => HomeMonthlyControllers(),
        fenix: true);
  }
}
