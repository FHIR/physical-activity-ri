import 'package:get/get.dart';

import '../controllers/task_referral_form_controller.dart';



class TaskReferralBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskReferralController>(
          () => TaskReferralController(),
    );
  }
}
