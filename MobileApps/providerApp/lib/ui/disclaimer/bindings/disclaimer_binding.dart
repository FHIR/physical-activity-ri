import 'package:get/get.dart';
import '../controllers/disclaimer_controller.dart';

class DisclaimerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DisclaimerController>(
          () => DisclaimerController(),
    );
  }
}
