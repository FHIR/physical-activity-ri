
import 'package:banny_table/utils/preference.dart';
import 'package:get/get.dart';

import '../../../../../routes/app_routes.dart';

class ConfigurationIntroController extends GetxController {


  gotoNextPageGoalView(){
    Preference.shared.setBool(Preference.keyConfiguration,false);
    Preference.shared.setBool(Preference.keyIntegrationScreen,false);
    Preference.shared.setBool(Preference.keyGoalView,true);
    Get.toNamed(AppRoutes.goalViewScreen);
  }

}
