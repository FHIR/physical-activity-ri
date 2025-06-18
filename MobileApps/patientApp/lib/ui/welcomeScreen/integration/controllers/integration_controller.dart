
import 'package:banny_table/healthData/getSetHealthData.dart';
import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:health/health.dart';
import 'package:get/get.dart';

import '../../../../utils/utils.dart';

class IntegrationController extends GetxController {
  bool isHealth = false;

  onChangeSwitch(value) async {
    isHealth = value;
    update();
    if(isHealth){
      await GetSetHealthData.authentication(isHealth,(value){
        update();
      });
    }else{
      // HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
      Utils.setPermissionHealth(false);
      await Health().revokePermissions();
    }
    update();
  }

  nextScreen(){
    Preference.shared.setBool(Preference.keyConfiguration,true);
    Preference.shared.setBool(Preference.keyIntegrationScreen,false);
    Get.toNamed(AppRoutes.configurationMain);
  }

  @override
  void onInit() {
    isHealth = Utils.getPermissionHealth();
    super.onInit();
  }

}
