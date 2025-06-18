import 'package:banny_table/ui/cameraScreen/controllers/camera_controllers.dart';
import 'package:get/get.dart';

class CameraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CameraControllers>(
          () => CameraControllers(),
    );
  }
}
