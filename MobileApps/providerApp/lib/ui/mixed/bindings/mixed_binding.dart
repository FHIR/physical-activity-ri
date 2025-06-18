import 'package:get/get.dart';

import '../controllers/mixed_controller.dart';

class MixedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MixedController>(
          () => MixedController(),
    );
  }
}
