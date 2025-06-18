import 'package:get/get.dart';

import '../controllers/referral_list_controller.dart';

class ReferralListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReferralListController>(
          () => ReferralListController(),
    );
  }
}
