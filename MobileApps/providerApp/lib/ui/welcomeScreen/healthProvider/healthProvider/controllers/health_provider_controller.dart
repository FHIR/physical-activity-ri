
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/utils.dart';
import '../../organization/controllers/organization_provider_controller.dart';

class HealthProviderController extends GetxController {

  PageController pageController = PageController();
  int selectedIndex = 0;

  onChangeIndex(int value){
    Debug.printLog("onChangeIndex...$value");
    selectedIndex = value;
    update();
  }

  previousPage(){
    pageController.previousPage(duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
    update();
  }

  nextPage(bool isSingleServer){
    Utils.getServerList.clear();
    Debug.printLog("Next page isSingle Server bool....$isSingleServer");
    Preference.shared.setBool(Preference.isSingleServer, isSingleServer);
    pageController.nextPage(duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
    update();
  }
}
