import 'package:banny_table/ui/welcomeScreen/qrManager/controllers/qr_manager_controller.dart';
import 'package:get/get.dart';


class QrManagerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QrManagerController>(
          () => QrManagerController(),
    );
  }
}
