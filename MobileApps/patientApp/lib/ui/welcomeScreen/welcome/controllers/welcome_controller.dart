
import 'dart:convert';

import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../routes/app_routes.dart';

import '../../../configuration/datamodel/configuration_datamodel.dart';
import '../../activityConfiguration/trackingPref/datamodel/trackingPref.dart';

class WelcomeController extends GetxController {




  @override
  void onInit() async{
   await getActivityLevelData();
    if(Preference.shared.getTrackingPrefList(Preference.trackingPrefList)!.isEmpty) {
      var data = [
        TrackingPref(titleName: Constant.configurationHeaderTotal,pos: 0,isSelected: true/*,toolTipText: Constant.configurationHeaderToolTipTotal*/),
        TrackingPref(titleName: Constant.configurationHeaderModerate,pos: 1,isSelected: true/*,toolTipText: Constant.configurationHeaderToolTipModMin*/),
        TrackingPref(titleName: Constant.configurationHeaderVigorous,pos: 2,isSelected: true/*,toolTipText: Constant.configurationHeaderToolTipVigMin*/),
        TrackingPref(titleName: Constant.configurationNotes,pos: 3,isSelected: true/*,toolTipText: Constant.configurationHeaderToolTipNotes*/),
        TrackingPref(titleName: Constant.configurationHeaderDays,pos: 4,isSelected: true/*,toolTipText: Constant.configurationHeaderToolTipStrengthDays*/),
        TrackingPref(titleName: Constant.configurationHeaderCalories,pos: 5,isSelected: true/*,toolTipText: Constant.configurationHeaderToolTipCalories*/),
        TrackingPref(titleName: Constant.configurationHeaderSteps,pos: 6,isSelected: true/*,toolTipText: Constant.configurationHeaderToolTipSteps*/),
        TrackingPref(titleName: Constant.configurationHeaderRest,pos: 7,isSelected: true/*,toolTipText: Constant.configurationHeaderToolTipRestingHeart*/),
        TrackingPref(titleName: Constant.configurationHeaderPeck,pos: 8,isSelected: true/*,toolTipText: Constant.configurationHeaderToolTipPeckHeart*/),
        TrackingPref(titleName: Constant.configurationExperience,pos: 9,isSelected: true/*,toolTipText: Constant.configurationHeaderToolTipExperience*/),
      ];
      var json = jsonEncode(data.map((e) => e.toJson()).toList());
      Preference.shared.setList(Preference.trackingPrefList, json);
      ///Call Api For configuration Data Push
      // Utils.callPushApiForConfigurationActivity();
    }
    super.onInit();
  }

  gotoBottomNavigationScreen(){
    Preference.shared.setBool(Preference.keyWelcomeDetails,false);
    Preference.shared.setBool(Preference.keyHealthProvider,false);
    Preference.shared.setBool(Preference.keyIntegrationScreen,false);
    Preference.shared.setBool(Preference.keyGoalView,false);
    Preference.shared.setBool(Preference.keyConfiguration,false);
    Get.offAllNamed(AppRoutes.bottomNavigation);
  }

  gotoNextScreen(){
    Preference.shared.setBool(Preference.keyWelcomeDetails,false);
    Preference.shared.setBool(Preference.keyHealthProvider,true);
    Get.toNamed(AppRoutes.healthProvider, arguments: [false]);
  }

  ///This Is Use For  Get Activity Configuration Data Add
  Future<void> getActivityLevelData() async {
    // final SharedPreferences pref = await SharedPreferences.getInstance();

    // List<String> prefData = pref.getStringList(Preference.activityData) ?? [];
    List<ConfigurationClass> prefData = Preference.shared.getConfigPrefList(Preference.configurationInfo) ?? [];
    // if(Constant.configurationJson.isNotEmpty){
    //   var json = jsonEncode(Constant.configurationJson.toList());
    //   Preference.shared.setList(Preference.configurationInfo, json);
    // }else
      if(prefData.isEmpty){

      List<ConfigurationClass> defaultStrList = [
        ConfigurationClass(title:Constant.itemBicycling , iconImage: Constant.iconBicycling, activityCode: Constant.codeBicycling),
        ConfigurationClass(title:Constant.itemJogging , iconImage: Constant.iconJogging, activityCode: Constant.codeJogging),
        ConfigurationClass(title:Constant.itemRunning , iconImage: Constant.iconRunning, activityCode: Constant.codeRunning),
        ConfigurationClass(title:Constant.itemSwimming , iconImage: Constant.iconSwimming, activityCode: Constant.codeSwimming),
        ConfigurationClass(title:Constant.itemWalking , iconImage: Constant.iconWalking, activityCode: Constant.codeWalking),
        ConfigurationClass(title:Constant.itemWeights , iconImage: Constant.iconWeights, activityCode: Constant.codeWeights),
        // ConfigurationClass(title:Constant.itemMixed , iconImage: Constant.iconMixed, activityCode: Constant.codeMixed),
        // Constant.itemBicycling,
        // Constant.itemJogging,
        // Constant.itemRunning,
        // Constant.itemSwimming,
        // Constant.itemWalking,
        // Constant.itemWeights,
        // Constant.itemMixed,
      ];

      Constant.configurationInfo.addAll(defaultStrList);
      var json = jsonEncode(Constant.configurationInfo.map((e) => e.toJson()).toList());
      Preference.shared.setList(Preference.configurationInfo, json);
      // Call Api For configuration Data Push
      // Utils.callPushApiForConfigurationActivity();
      ///Set default data
     /* List<String> defaultStrList = [Constant.itemBicycling,
        Constant.itemJogging,
        Constant.itemRunning,
        Constant.itemSwimming,
        Constant.itemWalking,
        Constant.itemWeights,
        Constant.itemMixed,
      ];

      pref.setStringList(Preference.activityData,defaultStrList);*/

    }

    /*List<String> prefDataIcons = pref.getStringList(Preference.activityDataIcons) ?? [];
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



    List<String> prefDataCode = pref.getStringList(Preference.activityDataCode) ?? [];
    if(prefDataCode.isEmpty){
      ///Set default data
      List<String> defaultStrListCode = [
        Constant.codeBicycling,
        Constant.codeJogging,
        Constant.codeRunning,
        Constant.codeSwimming,
        Constant.codeWalking,
        Constant.codeWeights,
        Constant.codeMixed,
      ];
      pref.setStringList(Preference.activityDataCode,defaultStrListCode);
    }*/

    getActivityListDataAndSetOnConfiguration();
  }

  Future<void> getActivityListDataAndSetOnConfiguration() async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // List<String> activityData = sharedPreferences.getStringList(Preference.activityData) ?? [];
    // List<String> activityDataIcons = sharedPreferences.getStringList(Preference.activityDataIcons) ?? [];
    // List<String> activityDataCode = sharedPreferences.getStringList(Preference.activityDataCode) ?? [];
    // if(activityData.isNotEmpty){
    //   Constant.configurationInfo.clear();
    //   if(Preference.shared.getConfigPrefList(Preference.configurationInfo)!.isEmpty){
    //     for(int i=0;i < activityData.length;i++){
    //       Constant.configurationInfo.add(ConfigurationClass(title: activityData[i],iconImage:  activityDataIcons[i],activityCode: activityDataCode[i]));
    //     }
    //     var json = jsonEncode(Constant.configurationInfo.map((e) => e.toJson()).toList());
    //     Preference.shared.setList(Preference.configurationInfo, json);
    //   }
      Constant.configurationInfo = Preference.shared.getConfigPrefList(Preference.configurationInfo) ?? [];

      Constant.configurationInfoGraphManage.clear();
      Constant.configurationInfoGraphManage.add(ConfigurationClass(title: Constant.titleNon,iconImage: "",activityCode: ""),);
      Constant.configurationInfoGraphManage.addAll(Constant.configurationInfo);
    // }
  }

}
