import 'package:banny_table/ui/home/monthly/controllers/home_monthly_controllers.dart';
import 'package:get/get.dart';


class HomeMonthlyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeMonthlyControllers>(
          () => HomeMonthlyControllers(),
    );
  }
}
