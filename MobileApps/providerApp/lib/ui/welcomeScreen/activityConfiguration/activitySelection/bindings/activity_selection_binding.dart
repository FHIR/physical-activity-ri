import 'package:get/get.dart';

import '../controllers/activity_selection_controller.dart';


class ActivitySelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActivitySelectionController>(
          () => ActivitySelectionController(),
    );
  }
}
