import 'package:get/get.dart';

import '../controllers/referral_form_controller.dart';

class ReferralFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReferralFormController>(
          () => ReferralFormController(),
    );
  }
}
