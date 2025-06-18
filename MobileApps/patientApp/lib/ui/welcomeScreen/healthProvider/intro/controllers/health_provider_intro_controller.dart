
import 'package:banny_table/utils/preference.dart';
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
    Preference.shared.setBool(Preference.keyHealthProvider,false);
    if(kIsWeb){
      Preference.shared.setBool(Preference.keyConfiguration,true);
      Get.toNamed(AppRoutes.configurationMain);
    }else{
      Preference.shared.setBool(Preference.keyIntegrationScreen,true);
      Get.toNamed(AppRoutes.integrationScreen,arguments: [false]);
    }
  }

}
