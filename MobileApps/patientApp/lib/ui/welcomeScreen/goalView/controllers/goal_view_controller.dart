
import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/utils.dart';

class GoalViewController extends GetxController {




  @override
  void onInit() {
    super.onInit();
  }

  gotoBottomNavigationScreen() async {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Utils.showDialogForProgress(
    //       Get.context!, Constant.txtPleaseWait, Constant.txtActivityDataProgress);
    // });
    // await Utils.setMonthlyAndActivityData(DateTime.now().year.toString(),isFromMonth: false,isFromActivity: true);
    // Preference.shared.setBool(Preference.keyWelcomeDetails,false);
    // bool test = Preference.shared.getBool(Preference.keyWelcomeDetails) ?? true;
    Preference.shared.setBool(Preference.keyGoalView,false);

    Get.offAllNamed(AppRoutes.bottomNavigation);

  }

  gotoGoalFrom(){
    // Preference.shared.setBool(Preference.keyWelcomeDetails,false);
    Preference.shared.setBool(Preference.keyGoalView,false);
    Get.toNamed(AppRoutes.goalForm,arguments: [ null ,false,""]);
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
