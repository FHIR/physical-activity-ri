
import 'package:banny_table/healthData/getSetHealthData.dart';
import 'package:get/get.dart';

import '../../../../utils/utils.dart';

class IntegrationController extends GetxController {
  bool isHealth = false;

  onChangeSwitch(value) async {
    isHealth = value;
    update();
    if(isHealth){
      // await GetSetHealthData.authentication(isHealth,(value){
      //   update();
      // });
    }else{
      // HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
      // Utils.setPermissionHealth(false);
      // await health.revokePermissions();
    }
    update();
  }
}
