import 'package:get/get.dart';

import '../controllers/tracking_pref_controller.dart';


class TrackingPrefBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrackingPrefController>(
          () => TrackingPrefController(),
    );
  }
}
