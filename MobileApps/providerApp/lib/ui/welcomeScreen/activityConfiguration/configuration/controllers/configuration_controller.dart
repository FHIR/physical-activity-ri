
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfigurationMainController extends GetxController {



  PageController pageConfigurationController = PageController();
  int selectedIndex = 0;

  onChangeIndex(int value){
    selectedIndex = value;
    update();
  }

}
