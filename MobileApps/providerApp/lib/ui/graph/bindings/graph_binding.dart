import 'package:banny_table/ui/bottomNavigation/controllers/bottom_navigation_controller.dart';
import 'package:get/get.dart';

import '../controllers/graph_controller.dart';

class GraphBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GraphController>(
          () => GraphController(),
        fenix: true
    );
  }
}
