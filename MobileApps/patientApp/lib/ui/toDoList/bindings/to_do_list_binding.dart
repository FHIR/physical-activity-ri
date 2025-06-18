import 'package:banny_table/ui/toDoList/controllers/to_do_list_controller.dart';
import 'package:get/get.dart';


class ToDoListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ToDoListController>(
          () => ToDoListController(),
    );
  }
}
