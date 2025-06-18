import 'package:get/get.dart';

import '../controllers/routing_referral_controller.dart';

class RoutingReferralBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoutingReferralController>(
          () => RoutingReferralController(),
    );
  }
}
