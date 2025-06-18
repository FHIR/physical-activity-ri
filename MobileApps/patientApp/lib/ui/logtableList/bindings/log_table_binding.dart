import 'package:get/get.dart';

import '../controllers/log_table_controller.dart';



class LogTableBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LogTableController>(
          () => LogTableController(),
    );
  }
}
