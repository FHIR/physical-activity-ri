
import 'dart:convert';

import 'package:banny_table/ui/welcomeScreen/activityConfiguration/trackingPref/dataModel/trackingPref.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../routes/app_routes.dart';

import '../../../configuration/datamodel/configuration_datamodel.dart';

class WelcomeController extends GetxController {




  @override
  void onInit() {
    getActivityLevelData();
    if(Preference.shared.getTrackingPrefList(Preference.trackingPrefList)!.isEmpty) {
      var data = [
        TrackingPref(titleName: Constant.configurationHeaderTotal,pos: 0,isSelected: true),
        TrackingPref(titleName: Constant.configurationHeaderModerate,pos: 1,isSelected: true),
        TrackingPref(titleName: Constant.configurationHeaderVigorous,pos: 2,isSelected: true),
        TrackingPref(titleName: Constant.configurationNotes,pos: 3,isSelected: true),
        TrackingPref(titleName: Constant.configurationHeaderDays,pos: 4,isSelected: true),
        TrackingPref(titleName: Constant.configurationHeaderCalories,pos: 5,isSelected: true),
        TrackingPref(titleName: Constant.configurationHeaderSteps,pos: 6,isSelected: true),
        TrackingPref(titleName: Constant.configurationHeaderRest,pos: 7,isSelected: true),
        TrackingPref(titleName: Constant.configurationHeaderPeck,pos: 8,isSelected: true),
        TrackingPref(titleName: Constant.configurationExperience,pos: 9,isSelected: true),
      ];
      var json = jsonEncode(data.map((e) => e.toJson()).toList());
      Preference.shared.setList(Preference.trackingPrefList, json);
      ///Call Api For configuration Data Push
      Utils.callPushApiForConfigurationActivity();
    }
    super.onInit();
  }


  gotoBottomNavigationScreen(){
    Preference.shared.setBool(Constant.keyWelcomeDetails,false);
    Preference.shared.setBool(Constant.keyIndependentPatient,false);
    Get.offAllNamed(AppRoutes.bottomNavigation);

  }


  gotoNextScreen(){
    // Get.toNamed(AppRoutes.qrManagerScreen, arguments: [false]);
    Get.toNamed(AppRoutes.healthProvider);

   /* if(kIsWeb){
      Get.toNamed(AppRoutes.configuration ,arguments: [true]);
    }else{
      Get.toNamed(AppRoutes.qrManagerScreen, arguments: [false]);

    }*/

  }

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

    List<String> prefDataIcons = pref.getStringList(Preference.activityDataIcons) ?? [];
    if(prefDataIcons.isEmpty){
      ///Set default data
      List<String> defaultStrListIcons = [Constant.iconBicycling,
        Constant.iconJogging,
        Constant.iconRunning,
        Constant.iconSwimming,
        Constant.iconWalking,
        Constant.iconWeights,
        Constant.iconMixed,
      ];
      pref.setStringList(Preference.activityDataIcons,defaultStrListIcons);
    }

    getActivityListDataAndSetOnConfiguration();
  }

  Future<void> getActivityListDataAndSetOnConfiguration() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> activityData = sharedPreferences.getStringList(Preference.activityData) ?? [];
    List<String> activityDataIcons = sharedPreferences.getStringList(Preference.activityDataIcons) ?? [];
    if(activityData.isNotEmpty){
      Constant.configurationInfo.clear();

      for(int i=0;i < activityData.length;i++){
        // Constant.configurationInfo.add(ConfigurationClass(activityData[i], Utils.getNumberIconNameFromType(activityData[i])));
        // Constant.configurationInfo.add(ConfigurationClass(activityData[i], activityDataIcons[i]));
      }
      Constant.configurationInfoGraphManage.clear();
      // Constant.configurationInfoGraphManage.add(ConfigurationClass(Constant.titleNon,""),);
      Constant.configurationInfoGraphManage.addAll(Constant.configurationInfo);
    }
  }

  moveToMainScreen() {
    Get.offAllNamed(AppRoutes.bottomNavigation);
    Preference.shared.setBool(Constant.keyIndependentPatient,false);
    Preference.shared.setBool(Constant.keyWelcomeDetails,false);
  }

}
