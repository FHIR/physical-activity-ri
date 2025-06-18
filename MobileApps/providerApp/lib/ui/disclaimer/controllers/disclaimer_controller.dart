import 'package:get/get.dart';

class DisclaimerController extends GetxController {

  var isCheckedBox = false;

  onChangedBox(value){
    isCheckedBox = value;
    update();
  }

}
