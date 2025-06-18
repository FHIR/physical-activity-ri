
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../../routes/app_routes.dart';

class HealthProviderIntroController extends GetxController {

/*  PageController pageController = PageController();
  int selectedIndex = 0;

  onChangeIndex(int value){
    selectedIndex = value;
    update();
  }*/

  gotoNextScreen(){
/*    if(kIsWeb){
      Get.toNamed(AppRoutes.configurationMain);
    }else{
      Get.toNamed(AppRoutes.integrationScreen,arguments: [false]);
    }*/
    Get.toNamed(AppRoutes.patientIndependentMode, arguments: [false,false,false,false]);
  }

}
