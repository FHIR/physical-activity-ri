
import 'dart:convert';

import 'package:banny_table/ui/configuration/datamodel/configuration_datamodel.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/trackingPref/datamodel/trackingPref.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../routes/app_routes.dart';


class TrackingPrefController extends GetxController {

  var isShowLoader = false;
  bool isNavigation = false;
  BuildContext? context;
  List<TrackingPref> trackingPrefList = [];
  var draggingIndex = 0;

  void onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final TrackingPref item = trackingPrefList.removeAt(oldIndex);
    trackingPrefList.insert(newIndex, item);
    Debug.printLog("onReorder...$oldIndex $newIndex");
    update();
  }

  @override
  Future<void> onInit() async {
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
      await Utils.callPushApiForConfigurationActivity();
    }
    trackingPrefList = Preference.shared.getTrackingPrefList(Preference.trackingPrefList)!;
    super.onInit();
  }


  onChangeActivityManageData(String value, TrackingPref? item, bool valueCheckBox,{bool isActivity = false}) async {
    Constant.configurationInfo = Preference.shared.getConfigPrefList(Preference.configurationInfo) ?? [];

    if(item != null) {
      var getSelectedIndex = trackingPrefList.indexWhere((element) =>
      element == item).toInt();
      trackingPrefList[getSelectedIndex].isSelected =
      !trackingPrefList[getSelectedIndex].isSelected;

      var json = jsonEncode(trackingPrefList.map((e) => e.toJson()).toList());
      Preference.shared.setList(Preference.trackingPrefList, json);
    }


    if (value == Constant.configurationHeaderTotal) {

      if(isActivity){
        Debug.printLog("Only One OFF.........");
      }else{
        // Constant.isTotal = !Constant.isTotal;
        Constant.isTotal = valueCheckBox;
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
        // Constant.isModerate = !Constant.isModerate;
        Constant.isModerate = valueCheckBox;
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
        // Constant.isVigorous = !Constant.isVigorous;
        Constant.isVigorous = valueCheckBox;

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
        // Constant.isStrengthDay = !Constant.isStrengthDay;
        Constant.isStrengthDay = valueCheckBox;
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
        // Constant.isCalories = !Constant.isCalories;
        Constant.isCalories = valueCheckBox;
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
        // Constant.isSteps = !Constant.isSteps;
        Constant.isSteps = valueCheckBox;
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
        // Constant.isRest = !Constant.isRest;
        Constant.isRest = valueCheckBox;
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
        // Constant.isPeck = !Constant.isPeck;
        Constant.isPeck = valueCheckBox;
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
        // Constant.isExperience = !Constant.isExperience;
        Constant.isExperience = valueCheckBox;
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
        // Constant.isNotes = !Constant.isNotes;
        Constant.isNotes = valueCheckBox;
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
    } /*else {
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
    await Utils.callPushApiForConfigurationActivity();
    update();
  }

  Future<void> moveToScreen() async {
    Preference.shared.setBool(Preference.keyConfiguration,false);
    Preference.shared.setBool(Preference.keyIntegrationScreen,false);
    Preference.shared.setBool(Preference.keyGoalView,true);
    Get.toNamed(AppRoutes.goalViewScreen);
    var json = jsonEncode(trackingPrefList.map((e) => e.toJson()).toList());
    Preference.shared.setList(Preference.trackingPrefList, json);
    ///Call Api For configuration Data Push
    await  Utils.callPushApiForConfigurationActivity();
  }

  void changeDragIndex(int index) {
    draggingIndex = index;
    update();
  }
}
