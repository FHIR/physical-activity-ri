
import 'dart:convert';

import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/trackingPref/dataModel/trackingPref.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
var draggingIndex = 0;


class TrackingPrefController extends GetxController {

  var isShowLoader = false;
  bool isNavigation = false;
  BuildContext? context;
  List<TrackingPref> trackingPrefList = [];


  @override
  void onInit() {
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
    super.onInit();
  }

  onChangeActivityManageData(String value){
    if(value == Constant.configurationHeaderTotal){
      Constant.isTotal = !Constant.isTotal;
      for(int i =0;i<Constant.configurationInfo.length ; i++){
        // Constant.configurationInfo[i].isTotal = !Constant.configurationInfo[i].isTotal;
        Constant.configurationInfo[i].isTotal = Constant.isTotal;
      }

      update();
    }else if( value == Constant.configurationHeaderModerate){
      Constant.isModerate = !Constant.isModerate;

      for(int i =0;i<Constant.configurationInfo.length ; i++){
        Constant.configurationInfo[i].isModerate = Constant.isModerate;
      }
      update();
    }else if( value == Constant.configurationHeaderVigorous){
      Constant.isVigorous = !Constant.isVigorous;

      for(int i =0;i<Constant.configurationInfo.length ; i++){
        Constant.configurationInfo[i].isVigorous = Constant.isVigorous;
      }
      update();
    }else if( value == Constant.configurationHeaderDays){
      Constant.isStrengthDay = !Constant.isStrengthDay;

      for(int i =0;i<Constant.configurationInfo.length ; i++){
        Constant.configurationInfo[i].isDaysStr = Constant.isStrengthDay;
      }
      update();
    }else if( value == Constant.configurationHeaderCalories){
      Constant.isCalories = !Constant.isCalories;

      for(int i =0;i<Constant.configurationInfo.length ; i++){
        Constant.configurationInfo[i].isCalories = Constant.isCalories;
      }
      update();
    }else if( value == Constant.configurationHeaderSteps){
      Constant.isSteps = !Constant.isSteps;

      for(int i =0;i<Constant.configurationInfo.length ; i++){
        Constant.configurationInfo[i].isSteps = Constant.isSteps;
      }
      update();
    }else if( value == Constant.configurationHeaderRest){
      Constant.isRest = !Constant.isRest;

      for(int i =0;i<Constant.configurationInfo.length ; i++){
        Constant.configurationInfo[i].isRest = Constant.isRest;
      }
      update();
    }else if( value == Constant.configurationHeaderPeck){
      Constant.isPeck = !Constant.isPeck;

      for(int i =0;i<Constant.configurationInfo.length ; i++){
        Constant.configurationInfo[i].isPeck = Constant.isPeck;
      }
      update();
    }

    bool checkActivity = Constant.configurationInfo.where((element) => !element.isModerate && !element.isVigorous && !element.isTotal  && !element.isDaysStr  && !element.isCalories  && !element.isSteps  && !element.isRest  && !element.isPeck ).toList().isNotEmpty;
    /*if(checkActivity){
      for(int i =0;i<Constant.configurationInfo.length ; i++) {
        Constant.configurationInfo[i].isEnabled = false;
      }
    }else if(!checkActivity){
      for(int i =0;i<Constant.configurationInfo.length ; i++) {
        Constant.configurationInfo[i].isEnabled = true;
      }
    }*/
    /* for(int i =0;i<Constant.configurationInfo.length ; i++) {
      Constant.configurationInfo[i].isEnabled = !checkActivity;
    }
*/
    if (Constant.isModerate ||
        Constant.isVigorous ||
        Constant.isTotal ||
        Constant.isStrengthDay ||
        Constant.isCalories ||
        Constant.isSteps ||
        Constant.isRest ||
        Constant.isPeck) {
      for(int i =0;i<Constant.configurationInfo.length ; i++) {
        Constant.configurationInfo[i].isEnabled = true;
        trueFalseValue(i);
      }
    }else{
      for(int i =0;i<Constant.configurationInfo.length ; i++) {
        Constant.configurationInfo[i].isEnabled = false;
        trueFalseValue(i);
      }
    }
    update();
    Debug.printLog(Constant.configurationInfo.toString());
  }

  trueFalseValue(int i){
    Constant.configurationInfo[i].isModerate = Constant.isModerate;
    Constant.configurationInfo[i].isVigorous = Constant.isVigorous;
    Constant.configurationInfo[i].isTotal = Constant.isTotal;
    Constant.configurationInfo[i].isDaysStr = Constant.isStrengthDay;
    Constant.configurationInfo[i].isCalories = Constant.isCalories;
    Constant.configurationInfo[i].isSteps = Constant.isSteps;
    Constant.configurationInfo[i].isRest = Constant.isRest;
    Constant.configurationInfo[i].isPeck = Constant.isPeck;
  }


  void moveToScreen() {
    Get.toNamed(AppRoutes.goalViewScreen);
    var json = jsonEncode(trackingPrefList.map((e) => e.toJson()).toList());
    Preference.shared.setList(Preference.trackingPrefList, json);
    ///Call Api For configuration Data Push
    Utils.callPushApiForConfigurationActivity();
  }

  void changeDragIndex(int index) {
    draggingIndex = index;
    update();
  }

}
