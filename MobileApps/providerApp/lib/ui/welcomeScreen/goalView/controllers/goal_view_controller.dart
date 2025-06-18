
import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:get/get.dart';

class GoalViewController extends GetxController {




  @override
  void onInit() {
    super.onInit();
  }

  gotoBottomNavigationScreen(){
    Preference.shared.setBool(Constant.keyWelcomeDetails,false);
    Get.offAllNamed(AppRoutes.bottomNavigation);

  }

  gotoGoalFrom(){
    Preference.shared.setBool(Constant.keyWelcomeDetails,false);
    Get.toNamed(AppRoutes.goalForm,arguments: [ null ,false]);
  }


/*
  ///This Is Use For  Get Activity Configuration Data Add
  Future<void> getActivityLevelData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    List<String> prefData = pref.getStringList(Preference.activityData) ?? [];
    if(prefData.isEmpty){
      ///Set default data
      List<String> defaultStrList = [Constant.itemBicycling,
        Constant.itemJogging,
        Constant.itemRunning,
        Constant.itemSwimming,
        Constant.itemWalking,
        Constant.itemWeights,
        Constant.itemMixed,
      ];

      pref.setStringList(Preference.activityData,defaultStrList);
    }

    getActivityListDataAndSetOnConfiguration();
  }

  Future<void> getActivityListDataAndSetOnConfiguration() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> activityData = sharedPreferences.getStringList(Preference.activityData) ?? [];
    if(activityData.isNotEmpty){
      for(int i=0;i < activityData.length;i++){
        Constant.configurationInfo.add(ConfigurationClass(activityData[i], Utils.getNumberIconNameFromType(activityData[i])));
      }
    }
  }*/

}
