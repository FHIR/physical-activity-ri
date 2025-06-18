import 'package:banny_table/ui/welcomeScreen/activityConfiguration/activitySelection/controllers/activity_selection_controller.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/configuration/controllers/configuration_controller.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/introConfiguration/controllers/configuration_intro_controller.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/trackingPref/controllers/tracking_pref_controller.dart';
import 'package:get/get.dart';


class ConfigurationMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConfigurationMainController>(
          () => ConfigurationMainController(),
        fenix: true
    );
    Get.lazyPut<ConfigurationIntroController>(
          () => ConfigurationIntroController(),
        fenix: true
    );
    Get.lazyPut<ActivitySelectionController>(
          () => ActivitySelectionController(),
        fenix: true
    );
    Get.lazyPut<TrackingPrefController>(
          () => TrackingPrefController(),
        fenix: true
    );



  }
}
