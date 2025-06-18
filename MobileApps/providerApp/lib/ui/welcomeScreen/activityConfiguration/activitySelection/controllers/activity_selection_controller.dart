import 'dart:convert';

import 'package:banny_table/ui/configuration/datamodel/activity_dataModel.dart';
import 'package:banny_table/ui/configuration/datamodel/configuration_datamodel.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/trackingPref/dataModel/trackingPref.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ActivitySelectionController extends GetxController {
  TextEditingController addActivityControllers = TextEditingController();
  FocusNode addActivityFocus = FocusNode();
  ActivityImagesModel? selectedIcon;
  List<TrackingPref> trackingPrefList = [];


  @override
  void onInit() {
    super.onInit();
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
    selectedIcon = Utils.activityImagesList[0];
    addActivityControllers.text = Utils.activityImagesList[0].imageTitle;
  }


  onChangeCheckBox(
    String value,
    int index,
  ) {
    if (Constant.configurationHeaderPeck == value) {
      Constant.configurationInfo[index].isPeck =
          !Constant.configurationInfo[index].isPeck;
      if(!Constant.isPeck) {
        onChangeActivityManageData(Constant.configurationHeaderPeck,isActivity: true);
      }
      update();
    } else if (Constant.configurationHeaderEnabled == value) {
      Constant.configurationInfo[index].isEnabled =
          !Constant.configurationInfo[index].isEnabled;
      if (Constant.isPeck) {
        Constant.configurationInfo[index].isPeck =
            Constant.configurationInfo[index].isEnabled;
      }
      if (Constant.isModerate) {
        Constant.configurationInfo[index].isModerate =
            Constant.configurationInfo[index].isEnabled;
      }
      if (Constant.isVigorous) {
        Constant.configurationInfo[index].isVigorous =
            Constant.configurationInfo[index].isEnabled;
      }
      if (Constant.isTotal) {
        Constant.configurationInfo[index].isTotal =
            Constant.configurationInfo[index].isEnabled;
      }
      if (Constant.isStrengthDay) {
        Constant.configurationInfo[index].isDaysStr =
            Constant.configurationInfo[index].isEnabled;
      }
      if (Constant.isCalories) {
        Constant.configurationInfo[index].isCalories =
            Constant.configurationInfo[index].isEnabled;
      }
      if (Constant.isSteps) {
        Constant.configurationInfo[index].isSteps =
            Constant.configurationInfo[index].isEnabled;
      }
      if (Constant.isRest) {
        Constant.configurationInfo[index].isRest =
            Constant.configurationInfo[index].isEnabled;
      }

      update();
    } else if (Constant.configurationHeaderModerate == value) {
      Constant.configurationInfo[index].isModerate =
          !Constant.configurationInfo[index].isModerate;
      if (!Constant.isModerate) {
        onChangeActivityManageData(Constant.configurationHeaderModerate,isActivity: true);
      }
      update();
    } else if (Constant.configurationHeaderVigorous == value) {
      Constant.configurationInfo[index].isVigorous =
          !Constant.configurationInfo[index].isVigorous;
      if (!Constant.isVigorous) {
        onChangeActivityManageData(Constant.configurationHeaderVigorous,isActivity: true);
      }
      update();
    } else if (Constant.configurationHeaderTotal == value) {
      Constant.configurationInfo[index].isTotal =
          !Constant.configurationInfo[index].isTotal;
      if (!Constant.isTotal) {
        onChangeActivityManageData(Constant.configurationHeaderTotal,isActivity: true);
      }
      update();
    } else if (Constant.configurationHeaderDays == value) {
      Constant.configurationInfo[index].isDaysStr =
          !Constant.configurationInfo[index].isDaysStr;
      if (!Constant.isStrengthDay) {
        onChangeActivityManageData(Constant.configurationHeaderDays,isActivity: true);
      }
      update();
    } else if (Constant.configurationHeaderCalories == value) {
      Constant.configurationInfo[index].isCalories =
          !Constant.configurationInfo[index].isCalories;
      if (!Constant.isCalories) {
        onChangeActivityManageData(Constant.configurationHeaderCalories,isActivity: true);
      }
      update();
    } else if (Constant.configurationHeaderSteps == value) {
      Constant.configurationInfo[index].isSteps =
          !Constant.configurationInfo[index].isSteps;
      if (!Constant.isSteps) {
        onChangeActivityManageData(Constant.configurationHeaderSteps,isActivity: true);
      }
      update();
    } else if (Constant.configurationHeaderRest == value) {
      Constant.configurationInfo[index].isRest =
          !Constant.configurationInfo[index].isRest;
      if (!Constant.isRest) {
        onChangeActivityManageData(Constant.configurationHeaderRest,isActivity: true);
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
          !data.isPeck) {
        Constant.configurationInfo[index].isEnabled = false;
      } else {
        Constant.configurationInfo[index].isEnabled = true;
      }
    }
    update();
    Debug.printLog(Constant.configurationInfo.toString());
  }

  addNewActivity(String text, String iconActivity) async {
    /*Get Data For sharedPreferences*/
/*    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> activityData =
        pref.getStringList(Preference.activityData) ?? [];
    activityData.add(text);
    List<String> activityDataIcons =
        pref.getStringList(Preference.activityDataIcons) ?? [];
    activityDataIcons.add(iconActivity);
    pref.setStringList(Preference.activityData, activityData);
    pref.setStringList(Preference.activityDataIcons, activityDataIcons);
    // Constant.configurationInfo.add(ConfigurationClass(text, iconActivity));
    // Constant.configurationInfoGraphManage.clear();
    // Constant.configurationInfoGraphManage.add(ConfigurationClass(Constant.titleNon,""),);
    Constant.configurationInfoGraphManage.addAll(Constant.configurationInfo);*/

    Constant.configurationInfo = Preference.shared.getConfigPrefList(Preference.configurationInfo) ?? [];

    Constant.configurationInfoGraphManage.clear();
    Constant.configurationInfoGraphManage.add(ConfigurationClass(title: Constant.titleNon,iconImage: "",activityCode: ""),);
    Constant.configurationInfoGraphManage.addAll(Constant.configurationInfo);
    addActivityControllers.clear();
    update();
    Get.back();
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
    else {
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
    }
    var json = jsonEncode(Constant.configurationInfo.map((e) => e.toJson()).toList());
    Preference.shared.setList(Preference.configurationInfo, json);
    ///Call Api For configuration Data Push
    Utils.callPushApiForConfigurationActivity();
    update();
    Debug.printLog(Constant.configurationInfo.toString());
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
  }


  onChangeIcon(ActivityImagesModel value) {
    selectedIcon = value;
    addActivityControllers.text = value.imageTitle;
    update();
  }
}
