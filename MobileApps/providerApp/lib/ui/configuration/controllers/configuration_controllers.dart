import 'dart:convert';
import 'dart:io';

import 'package:banny_table/resources/syncing.dart';
import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/ui/configuration/datamodel/activity_dataModel.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../healthData/getWorkOutDataModel.dart';
import '../../welcomeScreen/activityConfiguration/trackingPref/datamodel/trackingPref.dart';
import '../datamodel/configuration_datamodel.dart';

class ConfigurationController extends GetxController {
  ScrollController controllerScrollBar = ScrollController();
  ScrollController controller = ScrollController();

  TextEditingController addActivityControllers = TextEditingController();
  TextEditingController addActivityCodeControllers = TextEditingController();
  FocusNode addActivityFocus = FocusNode();
  FocusNode addActivityCodeFocus = FocusNode();
  // ActivityImagesModel? selectedIcon;
  WorkOutData? selectedIcon;

  var argument = Get.arguments;
  bool isSkipTab = false;
  List trackingPrefList = [];

  @override
  void onInit() {
    if(Utils.getServerListPreference().isNotEmpty) {
      Utils.getConfigurationActivityDataListApi();
    }
    Constant.configurationInfo = Preference.shared.getConfigPrefList(Preference.configurationInfo) ?? [];

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
    trackingPrefList = Preference.shared.getTrackingPrefList(Preference.trackingPrefList)!;

    if (argument != null) {
      if (argument[0] != null) {
        isSkipTab = argument[0];
      }
    }
    super.onInit();
    /*selectedIcon = Utils.activityImagesList[0];
    addActivityControllers.text = Utils.activityImagesList[0].imageTitle;*/
    selectedIcon = Utils.getWorkoutDataList[0];
    addActivityControllers.text = Utils.getWorkoutDataList[0].workOutDataName;
    update();
  }

  void onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final TrackingPref item = trackingPrefList.removeAt(oldIndex);
    trackingPrefList.insert(newIndex, item);
    var json = jsonEncode(trackingPrefList.map((e) => e.toJson()).toList());
    Preference.shared.setList(Preference.trackingPrefList, json);
    ///Call Api For configuration Data Push
    Utils.callPushApiForConfigurationActivity();
    Debug.printLog("onReorder...$oldIndex $newIndex");
    update();
  }

  saveOpeningDetails() async {
    Get.toNamed(AppRoutes.goalViewScreen);
  }

  onChangeCheckBox(String value, int index,) {
    Constant.configurationInfo = Preference.shared.getConfigPrefList(Preference.configurationInfo) ?? [];

    if (Constant.configurationHeaderPeck == value) {
      Constant.configurationInfo[index].isPeck = !Constant.configurationInfo[index].isPeck;
      if (!Constant.isPeck) {
        onChangeActivityManageData(Constant.configurationHeaderPeck,isActivity: true);
      }
      update();
    }
    else if (Constant.configurationHeaderEnabled == value) {
      Constant.configurationInfo[index].isEnabled =
          !Constant.configurationInfo[index].isEnabled;
      // if (Constant.isPeck) {
        Constant.configurationInfo[index].isPeck =
            Constant.configurationInfo[index].isEnabled;
      // }
      // if (Constant.isModerate) {
        Constant.configurationInfo[index].isModerate =
            Constant.configurationInfo[index].isEnabled;
      // }
      // if (Constant.isVigorous) {
        Constant.configurationInfo[index].isVigorous =
            Constant.configurationInfo[index].isEnabled;
      // }
      // if (Constant.isTotal) {
        Constant.configurationInfo[index].isTotal =
            Constant.configurationInfo[index].isEnabled;
      // }
      // if (Constant.isStrengthDay) {
        Constant.configurationInfo[index].isDaysStr =
            Constant.configurationInfo[index].isEnabled;
      // }
      // if (Constant.isCalories) {
        Constant.configurationInfo[index].isCalories =
            Constant.configurationInfo[index].isEnabled;
      // }
      // if (Constant.isSteps) {
        Constant.configurationInfo[index].isSteps =
            Constant.configurationInfo[index].isEnabled;
      // }
      // if (Constant.isRest) {
        Constant.configurationInfo[index].isRest =
            Constant.configurationInfo[index].isEnabled;
      // }
      // if (Constant.isExperience) {
        Constant.configurationInfo[index].isExperience =
            Constant.configurationInfo[index].isEnabled;
      // }
      // if (Constant.isNotes) {
        Constant.configurationInfo[index].isNotes =
            Constant.configurationInfo[index].isEnabled;
      // }
      update();
    }
    else if (Constant.configurationHeaderModerate == value) {
      Constant.configurationInfo[index].isModerate =
          !Constant.configurationInfo[index].isModerate;
      if (!Constant.isModerate) {
        onChangeActivityManageData(Constant.configurationHeaderModerate,isActivity: true);
      }
      update();
    }
    else if (Constant.configurationHeaderVigorous == value) {
      Constant.configurationInfo[index].isVigorous =
          !Constant.configurationInfo[index].isVigorous;
      if (!Constant.isVigorous) {
        onChangeActivityManageData(Constant.configurationHeaderVigorous,isActivity: true);
      }
      update();
    }
    else if (Constant.configurationHeaderTotal == value) {
      Constant.configurationInfo[index].isTotal = !Constant.configurationInfo[index].isTotal;
      if (!Constant.isTotal) {
        onChangeActivityManageData(Constant.configurationHeaderTotal,isActivity: true);
      }
      update();
    }
    else if (Constant.configurationHeaderDays == value) {
      Constant.configurationInfo[index].isDaysStr =
          !Constant.configurationInfo[index].isDaysStr;
      if (!Constant.isStrengthDay) {
        // Constant.isStrengthDay = true;
        onChangeActivityManageData(Constant.configurationHeaderDays,isActivity: true);
      }
      update();
    }
    else if (Constant.configurationHeaderCalories == value) {
      Constant.configurationInfo[index].isCalories =
          !Constant.configurationInfo[index].isCalories;
      if (!Constant.isCalories) {
        onChangeActivityManageData(Constant.configurationHeaderCalories,isActivity: true);
      }
      update();
    }
    else if (Constant.configurationHeaderSteps == value) {
      Constant.configurationInfo[index].isSteps =
          !Constant.configurationInfo[index].isSteps;
      if (!Constant.isSteps) {
        onChangeActivityManageData(Constant.configurationHeaderSteps,isActivity: true);
      }
      update();
    }
    else if (Constant.configurationHeaderRest == value) {
      Constant.configurationInfo[index].isRest =
          !Constant.configurationInfo[index].isRest;
      if (!Constant.isRest) {
        onChangeActivityManageData(Constant.configurationHeaderRest,isActivity: true);
      }
      update();
    }
    else if (Constant.configurationExperience == value) {
      Constant.configurationInfo[index].isExperience =
          !Constant.configurationInfo[index].isExperience;
      if (!Constant.isExperience) {
        onChangeActivityManageData(Constant.configurationExperience,isActivity: true);
      }
      update();
    }
    else if (Constant.configurationNotes == value) {
      Constant.configurationInfo[index].isNotes =
          !Constant.configurationInfo[index].isNotes;
      if (!Constant.isNotes) {
        onChangeActivityManageData(Constant.configurationNotes,isActivity: true);
      }
      update();
    }

    if (Constant.configurationHeaderEnabled != value) {
      var data = Constant.configurationInfo[index];
      if (!data.isModerate &&
          !data.isVigorous &&
          !data.isTotal &&
          !data.isDaysStr &&
          !data.isCalories &&
          !data.isSteps &&
          !data.isRest &&
          !data.isPeck  &&
          !data.isExperience &&
          !data.isNotes ) {
        Constant.configurationInfo[index].isEnabled = false;
      } else {
        Constant.configurationInfo[index].isEnabled = true;
      }
    }
    var json = jsonEncode(Constant.configurationInfo.map((e) => e.toJson()).toList());
    Preference.shared.setList(Preference.configurationInfo, json);
    ///Call Api For configuration Data Push
    Utils.callPushApiForConfigurationActivity();
    update();
    Debug.printLog(Constant.configurationInfo.toString());
  }

  onChangeActivityManageData(String value,{bool isActivity = false,TrackingPref? item}) {

    if(item != null) {
      var getSelectedIndex = trackingPrefList.indexWhere((element) =>
      element == item).toInt();
      trackingPrefList[getSelectedIndex].isSelected =
      !trackingPrefList[getSelectedIndex].isSelected;

      var json = jsonEncode(trackingPrefList.map((e) => e.toJson()).toList());
      Preference.shared.setList(Preference.trackingPrefList, json);

    }
    if(isActivity){
      var getSelectedIndex = trackingPrefList.indexWhere((element) =>
      element.titleName == value).toInt();
      /*trackingPrefList[getSelectedIndex].isSelected =
      !trackingPrefList[getSelectedIndex].isSelected;*/

      var json = jsonEncode(trackingPrefList.map((e) => e.toJson()).toList());
      Preference.shared.setList(Preference.trackingPrefList, json);
    }



    if (value == Constant.configurationHeaderTotal) {

      if(isActivity){
        Debug.printLog("Only One OFF.........");
      }else{
        Constant.isTotal = !Constant.isTotal;
        for (int i = 0; i < Constant.configurationInfo.where((element) => element.isEnabled).toList().length; i++) {
          Constant.configurationInfo.where((element) => element.isEnabled).toList()[i].isTotal = Constant.isTotal;
        }
      }


      update();
    }
    else if (value == Constant.configurationHeaderModerate) {

      if(isActivity){
        Debug.printLog("Only One OFF.........");
      }else {
        Constant.isModerate = !Constant.isModerate;
        for (int i = 0;
        i <
            Constant.configurationInfo
                .where((element) => element.isEnabled)
                .toList()
                .length;
        i++) {
          Constant.configurationInfo
              .where((element) => element.isEnabled)
              .toList()[i]
              .isModerate = Constant.isModerate;
        }
      }
      update();
    }
    else if (value == Constant.configurationHeaderVigorous) {
      if(isActivity){
        Debug.printLog("Only One OFF.........");
      }else {
        Constant.isVigorous = !Constant.isVigorous;

        for (int i = 0;
        i <
            Constant.configurationInfo
                .where((element) => element.isEnabled)
                .toList()
                .length;
        i++) {
          Constant.configurationInfo
              .where((element) => element.isEnabled)
              .toList()[i]
              .isVigorous = Constant.isVigorous;
        }
      }
      update();
    }
    else if (value == Constant.configurationHeaderDays) {
      if(isActivity){
        Debug.printLog("Only One OFF.........");
      }else {
        Constant.isStrengthDay = !Constant.isStrengthDay;
        for (int i = 0;
        i <
            Constant.configurationInfo
                .where((element) => element.isEnabled)
                .toList()
                .length;
        i++) {
          Constant.configurationInfo
              .where((element) => element.isEnabled)
              .toList()[i]
              .isDaysStr = Constant.isStrengthDay;
        }
      }
      update();
    }
    else if (value == Constant.configurationHeaderCalories) {
      if(isActivity){
        Debug.printLog("Only One OFF.........");
      }else {
        Constant.isCalories = !Constant.isCalories;
        for (int i = 0;
        i <
            Constant.configurationInfo
                .where((element) => element.isEnabled)
                .toList()
                .length;
        i++) {
          Constant.configurationInfo
              .where((element) => element.isEnabled)
              .toList()[i]
              .isCalories = Constant.isCalories;
        }
      }
      update();
    }
    else if (value == Constant.configurationHeaderSteps) {
      if(isActivity){
        Debug.printLog("Only One OFF.........");
      }else {
        Constant.isSteps = !Constant.isSteps;
        for (int i = 0;
        i <
            Constant.configurationInfo
                .where((element) => element.isEnabled)
                .toList()
                .length;
        i++) {
          Constant.configurationInfo
              .where((element) => element.isEnabled)
              .toList()[i]
              .isSteps = Constant.isSteps;
        }
      }
      update();
    }
    else if (value == Constant.configurationHeaderRest) {
      if(isActivity){
        Debug.printLog("Only One OFF.........");
      }else {
        Constant.isRest = !Constant.isRest;
        for (int i = 0;
        i <
            Constant.configurationInfo
                .where((element) => element.isEnabled)
                .toList()
                .length;
        i++) {
          Constant.configurationInfo
              .where((element) => element.isEnabled)
              .toList()[i]
              .isRest = Constant.isRest;
        }
      }
      update();
    }
    else if (value == Constant.configurationHeaderPeck) {
      if(isActivity){
        Debug.printLog("Only One OFF.........");
      }else {
        Constant.isPeck = !Constant.isPeck;
        for (int i = 0;
        i <
            Constant.configurationInfo
                .where((element) => element.isEnabled)
                .toList()
                .length;
        i++) {
          Constant.configurationInfo
              .where((element) => element.isEnabled)
              .toList()[i]
              .isPeck = Constant.isPeck;
        }
      }
      update();
    }
    else if (value == Constant.configurationExperience) {
      if(isActivity){
        Debug.printLog("Only One OFF.........");
      }else {
        Constant.isExperience = !Constant.isExperience;
        for (int i = 0;
        i <
            Constant.configurationInfo
                .where((element) => element.isEnabled)
                .toList()
                .length;
        i++) {
          Constant.configurationInfo
              .where((element) => element.isEnabled)
              .toList()[i]
              .isExperience = Constant.isExperience;
        }
      }
      update();
    }
    else if (value == Constant.configurationNotes) {
      if(isActivity){
        Debug.printLog("Only One OFF.........");
      }else {
        Constant.isNotes = !Constant.isNotes;
        for (int i = 0;
        i <
            Constant.configurationInfo
                .where((element) => element.isEnabled)
                .toList()
                .length;
        i++) {
          Constant.configurationInfo
              .where((element) => element.isEnabled)
              .toList()[i]
              .isNotes = Constant.isNotes;
        }
      }
      update();
    }

    if (Constant.isModerate ||
        Constant.isVigorous ||
        Constant.isTotal ||
        Constant.isStrengthDay ||
        Constant.isCalories ||
        Constant.isSteps ||
        Constant.isRest ||
        Constant.isPeck  ||
        Constant.isExperience ||
        Constant.isNotes
    ) {
      for (int i = 0;
      i <
          Constant.configurationInfo
              .where((element) => element.isEnabled)
              .toList()
              .length;
      i++) {
        Constant.configurationInfo
            .where((element) => element.isEnabled)
            .toList()[i]
            .isEnabled = true;
      }
    }
    /*else {
      for (int i = 0;
      i <
          Constant.configurationInfo
              .where((element) => element.isEnabled)
              .toList()
              .length;
      i++) {
        Constant.configurationInfo
            .where((element) => element.isEnabled)
            .toList()[i]
            .isEnabled = false;
        trueFalseValue(i);
      }
    }*/
    var json = jsonEncode(Constant.configurationInfo.map((e) => e.toJson()).toList());
    Preference.shared.setList(Preference.configurationInfo, json);
    ///Call Api For configuration Data Push
    Utils.callPushApiForConfigurationActivity();
    update();
    Debug.printLog(Constant.configurationInfo.toString());
  }


  addNewActivity(String text, String iconActivity,String activityCode) async {
    /*Get Data For sharedPreferences*/

    Constant.configurationInfo.add(ConfigurationClass(title: text,iconImage:  iconActivity,activityCode: activityCode));
    ///Call Api For configuration Data Push
    Utils.callPushApiForConfigurationActivity();

/*    var json = jsonEncode(Constant.configurationInfo.map((e) => e.toJson()).toList());
    Preference.shared.setList(Preference.configurationInfo, json);
    List<TrackingPref> trackingPref = Preference.shared.getTrackingPrefList(Preference.trackingPrefList)!;
    var jsonTracking = jsonEncode(trackingPref.map((e) => e.toJson()).toList());
    Syncing.callApiForConfigurationData(Utils.storeJson(jsonTracking,json));*/
    Constant.configurationInfoGraphManage.clear();
    Constant.configurationInfoGraphManage.add(
      ConfigurationClass(title: Constant.titleNon,iconImage:  "",activityCode: ""),
    );
    Constant.configurationInfoGraphManage.addAll(Constant.configurationInfo);
    addActivityControllers.clear();
    update();
    Get.back();
  }


  trueFalseValue(int i) {
    Constant.configurationInfo[i].isModerate = Constant.isModerate;
    Constant.configurationInfo[i].isVigorous = Constant.isVigorous;
    Constant.configurationInfo[i].isTotal = Constant.isTotal;
    Constant.configurationInfo[i].isDaysStr = Constant.isStrengthDay;
    Constant.configurationInfo[i].isCalories = Constant.isCalories;
    Constant.configurationInfo[i].isSteps = Constant.isSteps;
    Constant.configurationInfo[i].isRest = Constant.isRest;
    Constant.configurationInfo[i].isPeck = Constant.isPeck;
    Constant.configurationInfo[i].isExperience = Constant.isExperience;
    Constant.configurationInfo[i].isNotes = Constant.isNotes;
  }

  // onChangeIcon(ActivityImagesModel value) {
  onChangeIcon(WorkOutData value) {
    selectedIcon = value;
    addActivityControllers.text = value.workOutDataName;
    update();
  }

  Future<void> updateActivity(int index, String title, String imagesPath, String code) async {
    Constant.configurationInfo[index] = ConfigurationClass(title: title,iconImage: imagesPath,activityCode: code);


    /*SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> activityData =
        pref.getStringList(Preference.activityData) ?? [];
    activityData[index] = title;

    List<String> activityDataIcons =
        pref.getStringList(Preference.activityDataIcons) ?? [];
    activityDataIcons[index] = imagesPath;

    List<String> activityDataCode =
        pref.getStringList(Preference.activityDataCode) ?? [];
    activityDataCode[index] = code;

    *//*Set Data For sharedPreferences*//*

    pref.setStringList(Preference.activityData, activityData);
    pref.setStringList(Preference.activityDataIcons, activityDataIcons);
    pref.setStringList(Preference.activityDataCode, activityDataCode);*/


    // var json = jsonEncode(Constant.configurationInfo.map((e) => e.toJson()).toList());
    // Preference.shared.setList(Preference.configurationInfo, json);
    ///Call Api For configuration Data Push
    Utils.callPushApiForConfigurationActivity();
    Constant.configurationInfoGraphManage.clear();
    Constant.configurationInfoGraphManage.add(
      ConfigurationClass(title: Constant.titleNon,iconImage:  "",activityCode: ""),
    );
    Constant.configurationInfoGraphManage.addAll(Constant.configurationInfo);
    addActivityControllers.clear();
    update();
    Get.back();
  }

  Future<void> deleteActivity(int index, String title, String imagesPath, String code,
      {bool isRemovedFromLocal = false}) async {
    if(!isRemovedFromLocal) {
      Constant.configurationInfo.removeAt(index);
    }

  /*  SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> activityData =
        pref.getStringList(Preference.activityData) ?? [];
    activityData.removeAt(index);

    List<String> activityDataIcons =
        pref.getStringList(Preference.activityDataIcons) ?? [];
    activityDataIcons.removeAt(index);

    List<String> activityDataCode =
        pref.getStringList(Preference.activityDataCode) ?? [];
    activityDataCode.removeAt(index);

    *//*Set Data For sharedPreferences*//*

    pref.setStringList(Preference.activityData, activityData);
    pref.setStringList(Preference.activityDataIcons, activityDataIcons);
    pref.setStringList(Preference.activityDataCode, activityDataCode);*/


    // var json = jsonEncode(Constant.configurationInfo.map((e) => e.toJson()).toList());
    // Preference.shared.setList(Preference.configurationInfo, json);
    ///Call Api For configuration Data Push
    Utils.callPushApiForConfigurationActivity();

    Constant.configurationInfoGraphManage.clear();
    Constant.configurationInfoGraphManage.add(
      ConfigurationClass(title: Constant.titleNon,iconImage:  "",activityCode: ""),
    );
    Constant.configurationInfoGraphManage.addAll(Constant.configurationInfo);
    addActivityControllers.clear();
    update();
  }
}
