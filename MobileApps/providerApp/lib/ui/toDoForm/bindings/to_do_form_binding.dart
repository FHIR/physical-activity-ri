import 'package:get/get.dart';

import '../controllers/to_do_form_controller.dart';



class ToDoFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ToDoController>(
          () => ToDoController(),
    );
  }
}
