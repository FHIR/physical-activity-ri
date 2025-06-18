
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HealthProviderController extends GetxController {

  PageController pageController = PageController();
  int selectedIndex = 0;

  onChangeIndex(int value){
    selectedIndex = value;
    update();
  }

}
