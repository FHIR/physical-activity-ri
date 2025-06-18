import 'package:banny_table/ui/toDoForm/controllers/to_do_form_controller.dart';
import 'package:get/get.dart';


class ToDoFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ToDoController>(
          () => ToDoController(),
    );
  }
}
