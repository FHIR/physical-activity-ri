import 'package:get/get.dart';

import '../controllers/referral_assigned_controller.dart';

class ReferralAssignedFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReferralAssignedFormController>(
          () => ReferralAssignedFormController(),
    );
  }
}
