import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../db_helper/box/activity_data.dart';
import '../db_helper/box/server_detail_data.dart';
import '../db_helper/box/server_detail_data_mod_min.dart';
import '../db_helper/box/server_detail_data_vig_min.dart';
import '../db_helper/database_helper.dart';
import '../resources/syncing.dart';
import '../ui/configuration/datamodel/configuration_datamodel.dart';
import '../ui/home/monthly/datamodel/syncMonthlyActivityData.dart';
import '../ui/setting/database/insertData.dart';
import '../utils/color.dart';
import '../utils/constant.dart';
import '../utils/debug.dart';
import '../utils/font_style.dart';
import '../utils/preference.dart';
import '../utils/sizer_utils.dart';
import '../utils/utils.dart';

class GetSetHealthData{

  // static HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

  static authentication(bool isHealth,Function callback) async {
    // HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

    await Permission.activityRecognition.request();
    await Permission.location.request();

    var permissions = ( (Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthTypeIos).map((e) => HealthDataAccess.READ_WRITE).toList();

    bool? hasPermissions =
    await Health().hasPermissions((Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthTypeIos, permissions: permissions);
    if(Platform.isAndroid) {
      Utils.setPermissionHealth(isHealth);
      callback.call("");
    }
    var requested = false;
    try {
      await Health().requestAuthorization((Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthTypeIos,permissions: permissions).then((value) => {
        requested = value,
        if(!requested){
          Utils.showSnackBar(Get.context!,"Auth Failed",false)
        },
        Utils.setPermissionHealth(value),
        callback.call(""),
        Debug.printLog("requestAuthorization....$value")});
        Debug.printLog("requestAuthorization...");
    } catch (e) {
      Debug.printLog("Health permission....$e");
    }
    Debug.printLog("completed............");
  }

  static importDataFromHealth(Function callBack,bool isShow,{bool needAPICall = false,DateTime? endDate,DateTime? startDate}) async {
    try {
      Debug.printLog("importDataFromHealth datetime..........$endDate  $startDate");

      var permissions = ( (Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthTypeIos).map((e) => HealthDataAccess.READ_WRITE).toList();

      // bool? hasPermissions =
      //     await health.hasPermissions((Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthTypeIos, permissions: permissions);
      bool? hasPermissions = await Health().hasPermissions((Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthTypeIos, permissions: permissions);
      if(Platform.isIOS){
        hasPermissions = Utils.getPermissionHealth();
      }
      Debug.printLog("importDataFromHealth has.......$hasPermissions");
      if(hasPermissions!) {
        /* if (isShow) {
          showDialogForProgress(Get.context!, true);
        }*/
        if(endDate == null && startDate == null){
          var now = DateTime.now();
          endDate = DateTime(now.year, now.month, now.day + 1);
          startDate = DateTime(now.year - 1, now.month, now.day);
        }/*else{
          var now = DateTime.now();
          endDate = DateTime(now.year, now.month, now.day + 1);
          startDate = DateTime(now.year , now.month, now.day - 10);
        }*/

        if (isShow) {
          Utils.showSnackBar(Get.context!, "Data syncing..", true, second: 2);
        }

        List<HealthDataPoint> healthData = [];
        try {
          healthData = await Health().getHealthDataFromTypes(
            startTime:
              startDate ?? DateTime.now(),endTime: endDate ?? DateTime.now(),
             types: (Platform.isAndroid) ? Utils.getAllHealthTypeAndroid : Utils
                  .getAllHealthTypeIos);
        } catch (e) {
          Debug.printLog("Health data error.....$e");
        }
        Debug.printLog("healthData workout also....$healthData");

        var stepsListData = getStepDataFromHealth(
            healthData, Constant.titleSteps, HealthDataType.STEPS);
        for (int i = 0; i < stepsListData.length; i++) {
          insertUpdateHealthDay(stepsListData[i].dateTime, Constant.titleSteps,
              stepsListData[i].value);
        }

        var caloriesListData = getStepDataFromHealth(
            healthData, Constant.titleCalories,
            HealthDataType.ACTIVE_ENERGY_BURNED);
        for (int i = 0; i < caloriesListData.length; i++) {
          insertUpdateHealthDay(
              caloriesListData[i].dateTime, Constant.titleCalories,
              caloriesListData[i].value);
        }

        var heartRateListData = getStepDataFromHealth(
            healthData, Constant.titleHeartRatePeak, HealthDataType.HEART_RATE);
        for (int i = 0; i < heartRateListData.length; i++) {
          insertUpdateHealthDay(
              heartRateListData[i].dateTime, Constant.titleHeartRatePeak,
              heartRateListData[i].value);
        }

        var heartRateRestingListData = getStepDataFromHealth(
            healthData, Constant.titleHeartRateRest,
            HealthDataType.RESTING_HEART_RATE);
        for (int i = 0; i < heartRateRestingListData.length; i++) {
          insertUpdateHealthDay(
              heartRateRestingListData[i].dateTime, Constant.titleHeartRateRest,
              heartRateRestingListData[i].value);
        }

        List<HealthDataPoint> activityTypeData = [];
        if (Platform.isIOS) {
          List<HealthDataPoint> healthDataIos = [];

          /*for (int i = 0; i < 40; i++) {
            try {
              final today = now.subtract(Duration(days: daysTotal));
              final yesterday = now.subtract(Duration(days: daysTotal + 10));
              daysTotal = daysTotal + 10;
              // await Future.delayed(const Duration(seconds: 5));
              var data = await getWorkoutData(yesterday, today);
              // healthDataIos.addAll(await getWorkoutData(yesterday, today));
              healthDataIos.addAll(data);
              await Debug.printLog(
                  "$daysTotal.......healthData....... ${healthDataIos.length}");
              await Debug.printLog("nowTime.......${today.toString()}....end..... ${yesterday.toString()}");
            } catch (e) {
              Debug.printLog("Health data error.....$e");
            }
          }*/
          var data = await getWorkoutData(startDate, endDate);
          healthDataIos.addAll(data);
          /* Debug.printLog("getWorkoutData...after loop...${healthDataIos.length}");
          var otherActivityData = healthDataIos.where((element) => element.type == HealthDataType.WORKOUT
          && element.value.toJson()['workoutActivityType'] == "Other").toList();
          Debug.printLog("otherActivityData...${otherActivityData.length}");*/

          activityTypeData = healthDataIos.where((element) => element.type == HealthDataType.WORKOUT).toList();
          // Debug.printLog("otherActivityData list workout also....$activityTypeData");
          for (int i = 0; i < activityTypeData.length; i++) {
            var id = await Utils.getPackageName();
            Debug.printLog(
                "activityTypeData[i].sourceId ....${activityTypeData[i].sourceId}");
            // if (activityTypeData[i].sourceId == id || activityTypeData[i].sourceId == Constant.appleHealthId) {
            // var isFromAppleHealth = activityTypeData[i].sourceId == Constant.appleHealthId;
            var isFromAppleHealth = activityTypeData[i].sourceId != id;
            Debug.printLog("isFromAppleHealth....$isFromAppleHealth");
            var activityType = "";
            var activityTypeCode = "";
            dynamic totalCalories;
            try {
              activityType =
              activityTypeData[i].value.toJson()['workout_activity_type'];
              if(activityTypeData[i].value.toJson()['total_energy_burned'] != null){
                totalCalories =
                activityTypeData[i].value.toJson()['total_energy_burned'];
              }
            } catch (e) {
              totalCalories = "0";
              // Utils.showToast(Get.context!, e.toString());
              Debug.printLog("Error from get activity data....${e.toString()}");
            }
            var dateFrom = activityTypeData[i].dateFrom;
            var dateTo = activityTypeData[i].dateTo;
            var getTotalMinFromTwoDates = "0";
            try {
              getTotalMinFromTwoDates = Utils.getTotalMinFromTwoDates(dateFrom, dateTo);
            } catch (e) {
              Utils.showToast(Get.context!, e.toString());
              Debug.printLog(e.toString());
            }
            activityType = Utils.getActivityNameFromSyncData(activityType);
            activityTypeCode = Utils.getActivityCodeFromSyncData(activityType);
            if(totalCalories != null){
              totalCalories = int.parse(totalCalories.toString()).toString();
            }
            Debug.printLog(
                "activityTypeData...$getTotalMinFromTwoDates  $activityType  $totalCalories  $dateFrom  $dateTo");
            try {
              await insertUpdateActivityLevelData(
                  dateFrom,
                  activityType,
                  double.parse(totalCalories.toString()),
                  getTotalMinFromTwoDates,
                  dateTo,
                  dateFrom,
                  activityTypeData,
                  i,
                  isFromAppleHealth,activityTypeCode);
            } catch (e) {
              await insertUpdateActivityLevelData(
                  dateFrom,
                  activityType,
                  double.parse("0"),
                  getTotalMinFromTwoDates,
                  dateTo,
                  dateFrom,
                  activityTypeData,
                  i,
                  isFromAppleHealth,activityTypeCode);
            }
            // }
          }
        }
        else {
          Debug.printLog("getWorkoutData...after loop...${healthData.length}");
          activityTypeData = healthData
              .where((element) => element.type == HealthDataType.WORKOUT)
              .toList();
          for (int i = 0; i < activityTypeData.length; i++) {
            var id = await Utils.getPackageName();
            Debug.printLog(
                "android name id...${id}  ${activityTypeData[i].sourceName}");
            // if (activityTypeData[i].sourceId == id) {
            var activityType = "";
            dynamic totalCalories = "";
            var activityTypeCode = "";
            try {
              activityType =
              activityTypeData[i].value.toJson()['workout_activity_type'];
              if(activityTypeData[i].value.toJson()['total_energy_burned'] != null){
                totalCalories =
                activityTypeData[i].value.toJson()['total_energy_burned'];
              }else{
                totalCalories = "0";
              }
            } catch (e) {
              totalCalories = "0";
              // Utils.showToast(Get.context!, e.toString());
              Debug.printLog("Error from get activity data....${e.toString()}");
            }
            var dateFrom = activityTypeData[i].dateFrom;
            var dateTo = activityTypeData[i].dateTo;
            var getTotalMinFromTwoDates =
            Utils.getTotalMinFromTwoDates(dateFrom, dateTo);
            activityType = Utils.getActivityNameFromSyncData(activityType);
            activityTypeCode = Utils.getActivityCodeFromSyncData(activityType);
            if(totalCalories != null){
              totalCalories = int.parse(totalCalories.toString()).toString();
            }
            var isAndroidGoogleFit = activityTypeData[i].sourceName != id;

            Debug.printLog(
                "activityTypeData...$getTotalMinFromTwoDates  $activityType  $totalCalories  $dateFrom  $dateTo $isAndroidGoogleFit");
            try {
              await insertUpdateActivityLevelData(
                  dateFrom,
                  activityType,
                  double.parse(totalCalories.toString()),
                  getTotalMinFromTwoDates,
                  dateTo,
                  dateFrom,
                  activityTypeData,
                  i,
                  isAndroidGoogleFit,activityTypeCode);
            } catch (e) {
              await insertUpdateActivityLevelData(
                  dateFrom,
                  activityType,
                  double.parse("0"),
                  getTotalMinFromTwoDates,
                  dateTo,
                  dateFrom,
                  activityTypeData,
                  i,
                  isAndroidGoogleFit,activityTypeCode);
            }
          }
          // }
        }
        // Constant.isCalledAppleGoogleSync = true;
        /*final SharedPreferences pref = await SharedPreferences.getInstance();
        String? selectedSyncing =
            pref.getString(Constant.keySyncing) ?? Constant.realTime;
        String? qrUrl = Preference.shared.getString(Preference.qrUrlData) ?? "";
        if(selectedSyncing == Constant.realTime && qrUrl != "" && needAPICall && activityTypeData.isNotEmpty) {
          List<SyncMonthlyActivityData> allSyncingData = [];
          await Syncing.getAndSetSyncActivityData(allSyncingData);
          await Syncing.observationSyncDataCalories(allSyncingData);
          await Syncing.observationSyncDataSteps(allSyncingData);
          await Syncing.observationSyncDataRestHeart(allSyncingData);
          await Syncing.observationSyncDataPeakHeart(allSyncingData);
          await Syncing.observationSyncDataExperience(allSyncingData);
        }
*/
        // Get.back();
        if (isShow) {
          Utils.showSnackBar(Get.context!, "Import data successfully", false);
        }
        callBack.call("");
      }else{
        callBack.call("");
      }
    } catch (e) {
      Utils.showToast(Get.context!, e.toString());
      callBack.call("");
      Debug.printLog("importDataFromHealth....$e");
    }
  }


  static getWorkoutData(yesterday,today) async {
    List<HealthDataPoint> healthData = [];
    healthData = await Health().getHealthDataFromTypes(startTime: yesterday,endTime: today,types: [HealthDataType.WORKOUT]);
    return healthData;
  }

  static addNewActivity(String text, String iconActivity,String activityCode) async {
    Constant.configurationInfo = Preference.shared.getConfigPrefList(Preference.configurationInfo) ?? [];
    if(Constant.configurationInfo.where((element) => element.title == text).toList().isEmpty) {
      Debug.printLog("addNewActivity.....$text");
      Constant.configurationInfo.add(ConfigurationClass(
          title: text, iconImage: iconActivity, activityCode: activityCode));
      var json = jsonEncode(
          Constant.configurationInfo.map((e) => e.toJson()).toList());
      Preference.shared.setList(Preference.configurationInfo, json);

      ///Call Api For configuration Data Push
      // await Utils.callPushApiForConfigurationActivity();
      Constant.configurationInfoGraphManage.clear();
      Constant.configurationInfoGraphManage.add(
        ConfigurationClass(
            title: Constant.titleNon, iconImage: "", activityCode: ""),
      );
      Constant.configurationInfoGraphManage.addAll(Constant.configurationInfo);
    }
  }

  static List<ActivityTable> getActivityListData(){
    return Hive.box<ActivityTable>(Constant.tableActivity).values.toList().where((element) =>
    element.patientId == Utils.getPatientId()).toList();
  }

  static insertUpdateActivityLevelData(
      DateTime dateStart, String activityName, double totalCalories, String getTotalMinFromTwoDates,
      DateTime activityEndDate, DateTime activityStartDate, List<HealthDataPoint> activityTypeData, int position, bool isFromAppleHealth,String activityCode) async {
    dateStart = DateTime(dateStart.year,dateStart.month,dateStart.day);
    activityName = Utils.capitalizeFirstLetter(activityName);
    var allDataFromDB = getActivityListData();
    String formattedDate = "";
    formattedDate =
        DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateStart);
    var insertedId = 0;


    var activityTypeDataList = allDataFromDB.where((element) => element.displayLabel ==
        activityName &&
        Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now())  ==  Utils.changeDateFormatBasedOnDBDate(activityStartDate) &&
        Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now())  ==  Utils.changeDateFormatBasedOnDBDate(activityEndDate)
        && element.type == Constant.typeDaysData
        && element.title == Constant.titleActivityType).toList();

    if(activityTypeDataList.isEmpty){
      var insertingData = ActivityTable();
      insertingData.displayLabel = activityName;
      insertingData.date = formattedDate;
      insertingData.dateTime = dateStart;
      insertingData.activityStartDate = activityStartDate;
      insertingData.activityEndDate = activityEndDate;
      insertingData.title = Constant.titleActivityType;
      insertingData.isFromAppleHealth = isFromAppleHealth;
      insertingData.smileyType = null;
      insertingData.total = null;
      insertingData.value1 = null;
      insertingData.value2 = null;
      insertingData.isSync = false;
      insertingData.type = Constant.typeDaysData;
      String formattedDateStart =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findFirstDateOfTheWeekImport(dateStart));
      String formattedDateEnd =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findLastDateOfTheWeekImport(dateStart));

      insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";
      var connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
      if(connectedServerUrl.isNotEmpty) {
        for (int i = 0; i < connectedServerUrl.length; i++) {
          var data = ServerDetailDataTable();
          data.dataSyncServerWise = false;
          data.objectId = "";
          data.serverUrl = connectedServerUrl[i].url;
          data.patientId = connectedServerUrl[i].patientId;
          data.clientId = connectedServerUrl[i].clientId;
          data.serverToken = connectedServerUrl[i].authToken;
          data.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
              .patientLName}";
          insertingData.serverDetailList.add(data);
        }
      }
      await DataBaseHelper.shared.insertActivityData(insertingData);
    }
    else {
      if(activityTypeDataList[0].key != null){
        activityTypeDataList[0].activityStartDate = activityStartDate;
        activityTypeDataList[0].activityEndDate = activityEndDate;
        activityTypeDataList[0].isFromAppleHealth = isFromAppleHealth;
        activityTypeDataList[0].smileyType = null;
        activityTypeDataList[0].total = null;
        activityTypeDataList[0].value1 = null;
        activityTypeDataList[0].value2 = null;

        var dbData = getActivityListData();
        var activityTypeListSync = dbData.where((element) => element.displayLabel ==
            activityName &&  Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now())  ==  Utils.changeDateFormatBasedOnDBDate(activityStartDate) &&
            Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now())  ==  Utils.changeDateFormatBasedOnDBDate(activityEndDate)
            && element.type == Constant.typeDaysData
            && element.title == Constant.titleActivityType).toList();

        /*if(isFromAppleHealth && activityTypeListSync.isNotEmpty) {
          activityTypeDataList[0].isSync = true;
        }else if(activityTypeListSync.isEmpty){
          activityTypeDataList[0].isSync = false;
        }*/
        var allSelectedServersUrl = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected).toList();

        if (activityTypeDataList[0].serverDetailList.length !=
            allSelectedServersUrl.length) {
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = activityTypeDataList[0].serverDetailList;
            if (url
                .where((element) =>
            element.serverUrl == allSelectedServersUrl[i].url)
                .toList()
                .isEmpty) {
              var serverDetail = ServerDetailDataTable();
              serverDetail.serverUrl = allSelectedServersUrl[i].url;
              serverDetail.patientId = allSelectedServersUrl[i].patientId;
              serverDetail.patientName = "${allSelectedServersUrl[i]
                  .patientFName}${allSelectedServersUrl[i].patientLName}";
              serverDetail.objectId = "";
              activityTypeDataList[0].serverDetailList.add(
                  serverDetail);
            }
          }
        }

        await DataBaseHelper.shared.updateActivityData(activityTypeDataList[0]);
      }
    }

    List<ActivityTable> activityMinData = [];
      activityMinData = allDataFromDB
          .where((element) =>
          element.type == Constant.typeDaysData &&
          element.title == null &&
          element.smileyType == null &&
          element.displayLabel == activityName &&
              Utils.changeDateFormatBasedOnDBDate(
                  element.activityStartDate ?? DateTime.now()) ==
                  Utils.changeDateFormatBasedOnDBDate(activityStartDate) &&
              Utils.changeDateFormatBasedOnDBDate(
                  element.activityEndDate ?? DateTime.now()) ==
                  Utils.changeDateFormatBasedOnDBDate(activityEndDate))
          .toList();
    if (activityMinData.isEmpty) {

      var checkingListData = allDataFromDB
          .where((element) =>
      element.date == formattedDate &&
          element.type == Constant.typeDaysData &&
          element.title == null &&
          element.smileyType == null)
          .toList();

      for (int i = 0; i < checkingListData.length; i++) {
        var data = checkingListData[i];

        if (data.total == double.parse(getTotalMinFromTwoDates) &&
            data.activityStartDate == activityStartDate &&
            data.activityEndDate == activityEndDate) {
          return;
        }
      }

      var insertingData = ActivityTable();
      insertingData.isOverride = false;
      insertingData.displayLabel = activityName;
      insertingData.dateTime = dateStart;
      insertingData.date = formattedDate;
      insertingData.title = null;
      insertingData.value1 = null;
      insertingData.value2 = null;
      insertingData.isSync = false;
      insertingData.needExport = false;
      insertingData.total = double.parse(getTotalMinFromTwoDates);
      insertingData.iconPath = Utils.getNumberIconNameFromType(activityName);
      insertingData.isFromAppleHealth = isFromAppleHealth;

      String formattedDateStart =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findFirstDateOfTheWeekImport(dateStart));
      String formattedDateEnd =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findLastDateOfTheWeekImport(dateStart));
      insertingData.activityStartDate = activityStartDate;
      insertingData.activityEndDate = activityEndDate;
      insertingData.type = Constant.typeDaysData;
      insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";

      var connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
      if(connectedServerUrl.isNotEmpty) {
        for (int i = 0; i < connectedServerUrl.length; i++) {
          var data = ServerDetailDataTable();
          data.dataSyncServerWise = false;
          data.objectId = "";
          data.serverUrl = connectedServerUrl[i].url;
          data.patientId = connectedServerUrl[i].patientId;
          data.clientId = connectedServerUrl[i].clientId;
          data.serverToken = connectedServerUrl[i].authToken;
          data.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
              .patientLName}";
          insertingData.serverDetailList.add(data);

          var dataMod = ServerDetailDataModMinTable();
          dataMod.modDataSyncServerWise = false;
          dataMod.modObjectId = "";
          dataMod.modServerUrl = connectedServerUrl[i].url;
          dataMod.modPatientId = connectedServerUrl[i].patientId;
          dataMod.modClientId = connectedServerUrl[i].clientId;
          dataMod.modServerToken = connectedServerUrl[i].authToken;
          dataMod.modPatientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
              .patientLName}";
          insertingData.serverDetailListModMin.add(dataMod);

          var dataVig = ServerDetailDataVigMinTable();
          dataVig.vigDataSyncServerWise = false;
          dataVig.vigObjectId = "";
          dataVig.vigServerUrl = connectedServerUrl[i].url;
          dataVig.vigPatientId = connectedServerUrl[i].patientId;
          dataVig.vigClientId = connectedServerUrl[i].clientId;
          dataVig.vigServerToken = connectedServerUrl[i].authToken;
          dataVig.vigPatientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
              .patientLName}";
          insertingData.serverDetailListVigMin.add(dataVig);
        }
      }
      insertedId =
          await DataBaseHelper.shared.insertActivityData(insertingData);
    }
    else{
      if(activityMinData[0].key != null){
        activityMinData[0].iconPath = Utils.getNumberIconNameFromType(activityName);
        activityMinData[0].total = double.parse(getTotalMinFromTwoDates);
        activityMinData[0].activityStartDate = activityStartDate;
        activityMinData[0].activityEndDate = activityEndDate;

        var dbData = getActivityListData();
        var activityMinListSync = dbData.where((element) => element.displayLabel ==
            activityName &&  Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now())  ==  Utils.changeDateFormatBasedOnDBDate(activityStartDate) &&
            Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now())  ==  Utils.changeDateFormatBasedOnDBDate(activityEndDate)
            && element.type == Constant.typeDaysData
            && element.title == null && element.smileyType == null).toList();

       /* if(isFromAppleHealth && activityMinListSync.isNotEmpty) {
          activityMinData[0].isSync = true;
        }else if(activityMinListSync.isEmpty){
          activityMinData[0].isSync = false;
        }*/
        activityMinData[0].needExport = false;
        activityMinData[0].isFromAppleHealth = isFromAppleHealth;
        var allSelectedServersUrl = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected).toList();

        if (activityMinData[0].serverDetailList.length !=
            allSelectedServersUrl.length) {
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = activityMinData[0].serverDetailList;
            if (url
                .where((element) =>
            element.serverUrl == allSelectedServersUrl[i].url)
                .toList()
                .isEmpty) {
              var serverDetail = ServerDetailDataTable();
              serverDetail.serverUrl = allSelectedServersUrl[i].url;
              serverDetail.patientId = allSelectedServersUrl[i].patientId;
              serverDetail.patientName = "${allSelectedServersUrl[i]
                  .patientFName}${allSelectedServersUrl[i].patientLName}";
              serverDetail.objectId = "";
              activityMinData[0].serverDetailList.add(
                  serverDetail);
            }
          }
        }

        if (activityMinData[0].serverDetailListModMin.length !=
            allSelectedServersUrl.length) {
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = activityMinData[0].serverDetailListModMin;
            if (url
                .where((element) =>
            element.modServerUrl == allSelectedServersUrl[i].url)
                .toList()
                .isEmpty) {
              var serverDetail = ServerDetailDataModMinTable();
              serverDetail.modServerUrl = allSelectedServersUrl[i].url;
              serverDetail.modPatientId = allSelectedServersUrl[i].patientId;
              serverDetail.modPatientName = "${allSelectedServersUrl[i]
                  .patientFName}${allSelectedServersUrl[i].patientLName}";
              serverDetail.modObjectId = "";
              activityMinData[0].serverDetailListModMin.add(
                  serverDetail);
            }
          }
        }

        if (activityMinData[0].serverDetailListVigMin.length !=
            allSelectedServersUrl.length) {
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = activityMinData[0].serverDetailListVigMin;
            if (url
                .where((element) =>
            element.vigServerUrl == allSelectedServersUrl[i].url)
                .toList()
                .isEmpty) {
              var serverDetail = ServerDetailDataVigMinTable();
              serverDetail.vigServerUrl = allSelectedServersUrl[i].url;
              serverDetail.vigPatientId = allSelectedServersUrl[i].patientId;
              serverDetail.vigPatientName = "${allSelectedServersUrl[i]
                  .patientFName}${allSelectedServersUrl[i].patientLName}";
              serverDetail.vigObjectId = "";
              activityMinData[0].serverDetailListVigMin.add(
                  serverDetail);
            }
          }
        }
        await DataBaseHelper.shared.updateActivityData(activityMinData[0]);
      }
    }

    List<ActivityTable> caloriesData = [];
      caloriesData = allDataFromDB
          .where((element) =>
          element.type == Constant.typeDaysData &&
          (element.title == Constant.titleCalories) &&
          element.displayLabel == activityName &&
              Utils.changeDateFormatBasedOnDBDate(
                  element.activityStartDate ?? DateTime.now()) ==
                  Utils.changeDateFormatBasedOnDBDate(activityStartDate) &&
              Utils.changeDateFormatBasedOnDBDate(
                  element.activityEndDate ?? DateTime.now()) ==
                  Utils.changeDateFormatBasedOnDBDate(activityEndDate))
          .toList();
    if (caloriesData.isEmpty) {
      var checkingListData =  allDataFromDB
          .where((element) =>
      element.date == formattedDate &&
          element.type == Constant.typeDaysData &&
          (element.title == Constant.titleCalories))
          .toList();

      for (int i = 0; i < checkingListData.length; i++) {
        var data = checkingListData[i];

        if (data.total == totalCalories &&
            data.activityStartDate == activityStartDate &&
            data.activityEndDate == activityEndDate) {
          return;
        }
      }


      var insertingData = ActivityTable();
      insertingData.title = Constant.titleCalories;
      insertingData.date = formattedDate;
      insertingData.dateTime = dateStart;
      insertingData.displayLabel = activityName;
      insertingData.total = totalCalories;
      insertingData.type = Constant.typeDaysData;
      insertingData.isSync = false;
      insertingData.needExport = false;
      insertingData.activityStartDate = activityStartDate;
      insertingData.activityEndDate = activityEndDate;
      insertingData.isFromAppleHealth = isFromAppleHealth;
      String formattedDateStart =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findFirstDateOfTheWeekImport(dateStart));
      String formattedDateEnd =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findLastDateOfTheWeekImport(dateStart));

      insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";
      insertingData.insertedDayDataId = insertedId;

      var connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
      if(connectedServerUrl.isNotEmpty) {
        for (int i = 0; i < connectedServerUrl.length; i++) {
          var data = ServerDetailDataTable();
          data.dataSyncServerWise = false;
          data.objectId = "";
          data.serverUrl = connectedServerUrl[i].url;
          data.patientId = connectedServerUrl[i].patientId;
          data.clientId = connectedServerUrl[i].clientId;
          data.serverToken = connectedServerUrl[i].authToken;
          data.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
              .patientLName}";
          insertingData.serverDetailList.add(data);
        }
      }

      await DataBaseHelper.shared.insertActivityData(insertingData);
      var iconPath = Utils.getNumberIconNameFromType(activityName);
      await addNewActivity(activityName,iconPath,activityCode);
      await stepsHeartExEntry(dateStart, activityName, insertedId,activityStartDate,activityEndDate,position,isFromAppleHealth);

      allDataFromDB = getActivityListData();
      await insertUpdateCaloriesAtDayLevel(dateStart,totalCalories,allDataFromDB,getTotalMinFromTwoDates);
      await insertUpdateCaloriesAtWeekLevel(dateStart,"$formattedDateStart-$formattedDateEnd"
          ,totalCalories,allDataFromDB,getTotalMinFromTwoDates);
    }
    else {
      if (caloriesData[0].key != null) {
        caloriesData[0].total = totalCalories;

        var allSelectedServersUrl = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected).toList();

        if (caloriesData[0].serverDetailList.length !=
            allSelectedServersUrl.length) {
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = caloriesData[0].serverDetailList;
            if (url
                .where((element) =>
            element.serverUrl == allSelectedServersUrl[i].url)
                .toList()
                .isEmpty) {
              var serverDetail = ServerDetailDataTable();
              serverDetail.serverUrl = allSelectedServersUrl[i].url;
              serverDetail.patientId = allSelectedServersUrl[i].patientId;
              serverDetail.patientName = "${allSelectedServersUrl[i]
                  .patientFName}${allSelectedServersUrl[i].patientLName}";
              serverDetail.objectId = "";
              caloriesData[0].serverDetailList.add(
                  serverDetail);
            }
          }
        }

        caloriesData[0].activityStartDate = activityStartDate;
        caloriesData[0].activityEndDate = activityEndDate;

        var dbData = getActivityListData();
        var caloriesListSync = dbData.where((element) => element.displayLabel ==
            activityName &&  Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now())  ==  Utils.changeDateFormatBasedOnDBDate(activityStartDate) &&
            Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now())  ==  Utils.changeDateFormatBasedOnDBDate(activityEndDate)
            && element.type == Constant.typeDaysData
            && element.title == null && element.smileyType == null).toList();

       /* if(isFromAppleHealth && caloriesListSync.isNotEmpty) {
          caloriesData[0].isSync = true;
        }else if(caloriesListSync.isEmpty){
          caloriesData[0].isSync = false;
        }*/
        caloriesData[0].needExport = false;
        await DataBaseHelper.shared.updateActivityData(caloriesData[0]);
      }
      String formattedDateStart =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findFirstDateOfTheWeekImport(dateStart));
      String formattedDateEnd =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findLastDateOfTheWeekImport(dateStart));

      allDataFromDB = getActivityListData();
      await insertUpdateCaloriesAtDayLevel(dateStart,totalCalories,allDataFromDB,getTotalMinFromTwoDates);
      await insertUpdateCaloriesAtWeekLevel(dateStart,"$formattedDateStart-$formattedDateEnd",totalCalories,
          allDataFromDB,getTotalMinFromTwoDates);

    }

    /*var activityParentListData = allDataFromDB.where((element) => element.displayLabel ==
        activityName &&  Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now())  ==  Utils.changeDateFormatBasedOnDBDate(activityStartDate) &&
        Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now())  ==  Utils.changeDateFormatBasedOnDBDate(activityEndDate)
        && element.type == Constant.typeDaysData
        && element.title == Constant.titleParent).toList();
    if(activityParentListData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.displayLabel = activityName;
      insertingData.date = formattedDate;
      insertingData.dateTime = dateStart;
      insertingData.activityStartDate = activityStartDate;
      insertingData.activityEndDate = activityEndDate;
      insertingData.title = Constant.titleParent;
      insertingData.isFromAppleHealth = isFromAppleHealth;
      insertingData.smileyType = null;
      insertingData.total = null;
      insertingData.value1 = null;
      insertingData.value2 = null;
      insertingData.isSync = false;
      insertingData.type = Constant.typeDaysData;
      String formattedDateStart =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findFirstDateOfTheWeekImport(dateStart));
      String formattedDateEnd =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findLastDateOfTheWeekImport(dateStart));

      insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";
      var connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
      if(connectedServerUrl.isNotEmpty) {
        for (int i = 0; i < connectedServerUrl.length; i++) {
          var data = ServerDetailDataTable();
          data.dataSyncServerWise = false;
          data.objectId = "";
          data.serverUrl = connectedServerUrl[i].url;
          data.patientId = connectedServerUrl[i].patientId;
          data.clientId = connectedServerUrl[i].clientId;
          data.serverToken = connectedServerUrl[i].authToken;
          data.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
              .patientLName}";
          insertingData.serverDetailList.add(data);
        }
      }
      await DataBaseHelper.shared.insertActivityData(insertingData);
    }
    else{
      if(activityParentListData[0].key != null){
        activityParentListData[0].activityStartDate = activityStartDate;
        activityParentListData[0].activityEndDate = activityEndDate;
        activityParentListData[0].isFromAppleHealth = isFromAppleHealth;
        activityParentListData[0].smileyType = null;
        activityParentListData[0].total = null;
        activityParentListData[0].value1 = null;
        activityParentListData[0].value2 = null;

        var dbData = getActivityListData();
        var parentTypeListSync = dbData.where((element) => element.displayLabel ==
            activityName &&  Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now())  ==  Utils.changeDateFormatBasedOnDBDate(activityStartDate) &&
            Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now())  ==  Utils.changeDateFormatBasedOnDBDate(activityEndDate)
            && element.type == Constant.typeDaysData
            && element.title == Constant.titleParent).toList();

        *//*if(isFromAppleHealth && parentTypeListSync.isNotEmpty) {
          activityParentListData[0].isSync = true;
        }else if(parentTypeListSync.isEmpty){
          activityParentListData[0].isSync = false;
        }*//*
        var allSelectedServersUrl = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected).toList();

        if (activityParentListData[0].serverDetailList.length !=
            allSelectedServersUrl.length) {
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = activityParentListData[0].serverDetailList;
            if (url
                .where((element) =>
            element.serverUrl == allSelectedServersUrl[i].url)
                .toList()
                .isEmpty) {
              var serverDetail = ServerDetailDataTable();
              serverDetail.serverUrl = allSelectedServersUrl[i].url;
              serverDetail.patientId = allSelectedServersUrl[i].patientId;
              serverDetail.patientName = "${allSelectedServersUrl[i]
                  .patientFName}${allSelectedServersUrl[i].patientLName}";
              serverDetail.objectId = "";
              activityParentListData[0].serverDetailList.add(
                  serverDetail);
            }
          }
        }

        await DataBaseHelper.shared.updateActivityData(activityParentListData[0]);
      }
    }*/
  }

  static insertUpdateCaloriesAtDayLevel(DateTime dateTime,double totalCalories,List<ActivityTable>
  allDataFromDB, String getTotalMinFromTwoDates)async{

    List<ActivityTable> activityDataListFor =
        Hive.box<ActivityTable>(Constant.tableActivity)
            .values
            .toList()
            .where((element) =>
                element.type == Constant.typeDaysData &&
                element.date ==
                    DateFormat(Constant.commonDateFormatDdMmYyyy)
                        .format(dateTime))
            .toList();

    var activityMinData = allDataFromDB.where((element) =>
    element.date == DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateTime)
        && element.type == Constant.typeDay &&
        element.title == null && element.smileyType == null).toList();

    if(activityMinData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.title = null;
      insertingData.smileyType = null;

      insertingData.dateTime = dateTime;
      insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateTime);


      insertingData.total = double.parse(getTotalMinFromTwoDates);


      insertingData.type = Constant.typeDay;
      insertingData.isSync = false;

      String selectedWeekStartDate =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findFirstDateOfTheWeekImport(dateTime));
      String selectedWeekEndDate =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findLastDateOfTheWeekImport(dateTime));

      insertingData.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
      insertingData.needExport = true;
      // var connectedServerUrl = Utils.getServerListPreference();
      /*var connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();

      if(connectedServerUrl.isNotEmpty) {
        for (int i = 0; i < connectedServerUrl.length; i++) {
          var serverDetail = ServerDetailDataTable();
          serverDetail.serverUrl = connectedServerUrl[i].url;
          serverDetail.patientId = connectedServerUrl[i].patientId;
          serverDetail.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i].patientLName}";
          serverDetail.objectId = "";
          serverDetail.serverToken = connectedServerUrl[i].authToken;
          serverDetail.clientId = connectedServerUrl[i].clientId;
          insertingData.serverDetailList.add(serverDetail);
        }
      }*/


      var connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
      if(connectedServerUrl.isNotEmpty) {
        for (int i = 0; i < connectedServerUrl.length; i++) {
          var data = ServerDetailDataTable();
          data.dataSyncServerWise = false;
          data.objectId = "";
          data.serverUrl = connectedServerUrl[i].url;
          data.patientId = connectedServerUrl[i].patientId;
          data.clientId = connectedServerUrl[i].clientId;
          data.serverToken = connectedServerUrl[i].authToken;
          data.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
              .patientLName}";
          insertingData.serverDetailList.add(data);

          var dataMod = ServerDetailDataModMinTable();
          dataMod.modDataSyncServerWise = false;
          dataMod.modObjectId = "";
          dataMod.modServerUrl = connectedServerUrl[i].url;
          dataMod.modPatientId = connectedServerUrl[i].patientId;
          dataMod.modClientId = connectedServerUrl[i].clientId;
          dataMod.modServerToken = connectedServerUrl[i].authToken;
          dataMod.modPatientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
              .patientLName}";
          insertingData.serverDetailListModMin.add(dataMod);

          var dataVig = ServerDetailDataVigMinTable();
          dataVig.vigDataSyncServerWise = false;
          dataVig.vigObjectId = "";
          dataVig.vigServerUrl = connectedServerUrl[i].url;
          dataVig.vigPatientId = connectedServerUrl[i].patientId;
          dataVig.vigClientId = connectedServerUrl[i].clientId;
          dataVig.vigServerToken = connectedServerUrl[i].authToken;
          dataVig.vigPatientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
              .patientLName}";
          insertingData.serverDetailListVigMin.add(dataVig);
        }
      }

      await DataBaseHelper.shared.insertActivityData(insertingData);
    }
    else{
      var totalValue = 0.0;
      for (int i = 0; i < activityDataListFor.length; i++) {
        if(activityDataListFor[i].title == null && activityDataListFor[i].smileyType == null){
          totalValue += activityDataListFor[i].total ?? 0.0;
        }
      }

      /*if(totalValue == 0.0){
        activityMinData[0].total = null;
      }else{
        activityMinData[0].total = totalValue;
      }*/

      if(totalValue != 0.0){
        activityMinData[0].total = totalValue;
      }

      var allSelectedServersUrl = Utils.getServerListPreference().where((element) =>
      element.patientId != "" && element.isSelected).toList();

     /* if(activityMinData[0].serverDetailList.length != allSelectedServersUrl.length){
        for (int i = 0; i < allSelectedServersUrl.length; i++) {
          var url = activityMinData[0].serverDetailList;
          if(url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty){
            var serverDetail = ServerDetailDataTable();
            serverDetail.serverUrl = allSelectedServersUrl[i].url;
            serverDetail.patientId = allSelectedServersUrl[i].patientId;
            serverDetail.patientName = "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
            serverDetail.objectId = "";
            activityMinData[0].serverDetailList.add(serverDetail);
          }
        }
      }*/

      if (activityMinData[0].serverDetailList.length !=
          allSelectedServersUrl.length) {
        for (int i = 0; i < allSelectedServersUrl.length; i++) {
          var url = activityMinData[0].serverDetailList;
          if (url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty) {
            var serverDetail = ServerDetailDataTable();
            serverDetail.serverUrl = allSelectedServersUrl[i].url;
            serverDetail.patientId = allSelectedServersUrl[i].patientId;
            serverDetail.patientName = "${allSelectedServersUrl[i]
                .patientFName}${allSelectedServersUrl[i].patientLName}";
            serverDetail.objectId = "";
            activityMinData[0].serverDetailList.add(
                serverDetail);
          }
        }
      }

      if (activityMinData[0].serverDetailListModMin.length !=
          allSelectedServersUrl.length) {
        for (int i = 0; i < allSelectedServersUrl.length; i++) {
          var url = activityMinData[0].serverDetailListModMin;
          if (url
              .where((element) =>
          element.modServerUrl == allSelectedServersUrl[i].url)
              .toList()
              .isEmpty) {
            var serverDetail = ServerDetailDataModMinTable();
            serverDetail.modServerUrl = allSelectedServersUrl[i].url;
            serverDetail.modPatientId = allSelectedServersUrl[i].patientId;
            serverDetail.modPatientName = "${allSelectedServersUrl[i]
                .patientFName}${allSelectedServersUrl[i].patientLName}";
            serverDetail.modObjectId = "";
            activityMinData[0].serverDetailListModMin.add(
                serverDetail);
          }
        }
      }

      if (activityMinData[0].serverDetailListVigMin.length !=
          allSelectedServersUrl.length) {
        for (int i = 0; i < allSelectedServersUrl.length; i++) {
          var url = activityMinData[0].serverDetailListVigMin;
          if (url
              .where((element) =>
          element.vigServerUrl == allSelectedServersUrl[i].url)
              .toList()
              .isEmpty) {
            var serverDetail = ServerDetailDataVigMinTable();
            serverDetail.vigServerUrl = allSelectedServersUrl[i].url;
            serverDetail.vigPatientId = allSelectedServersUrl[i].patientId;
            serverDetail.vigPatientName = "${allSelectedServersUrl[i]
                .patientFName}${allSelectedServersUrl[i].patientLName}";
            serverDetail.vigObjectId = "";
            activityMinData[0].serverDetailListVigMin.add(
                serverDetail);
          }
        }
      }
      activityMinData[0].isSync = false;
      activityMinData[0].needExport = true;
      await DataBaseHelper.shared.updateActivityData(activityMinData[0]);

    }

    List<ActivityTable> caloriesDayData = allDataFromDB.where((element) =>
    element.date == DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateTime)
        && element.type == Constant.typeDay &&
        element.title == Constant.titleCalories).toList();
    if(caloriesDayData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.title = Constant.titleCalories;
      insertingData.dateTime = dateTime;
      insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateTime);
      insertingData.total = totalCalories;
      insertingData.type = Constant.typeDay;
      insertingData.isSync = false;

      String selectedWeekStartDate =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findFirstDateOfTheWeekImport(dateTime));
      String selectedWeekEndDate =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findLastDateOfTheWeekImport(dateTime));

      insertingData.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
      insertingData.needExport = true;
      // var connectedServerUrl = Utils.getServerListPreference();
      var connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();

      if(connectedServerUrl.isNotEmpty) {
        for (int i = 0; i < connectedServerUrl.length; i++) {
          var serverDetail = ServerDetailDataTable();
          serverDetail.serverUrl = connectedServerUrl[i].url;
          serverDetail.patientId = connectedServerUrl[i].patientId;
          serverDetail.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i].patientLName}";
          serverDetail.objectId = "";
          serverDetail.serverToken = connectedServerUrl[i].authToken;
          serverDetail.clientId = connectedServerUrl[i].clientId;
          insertingData.serverDetailList.add(serverDetail);
        }
      }

      await DataBaseHelper.shared.insertActivityData(insertingData);
    }
    else{
      var totalValue = 0.0;
      for (int i = 0; i < activityDataListFor.length; i++) {
        if(activityDataListFor[i].title == Constant.titleCalories){
          totalValue += activityDataListFor[i].total ?? 0.0;
        }
      }

      /*if(totalValue == 0.0){
        caloriesDayData[0].total = null;
      }else{
        caloriesDayData[0].total = totalValue;
      }*/

      if(totalValue != 0.0){
        caloriesDayData[0].total = totalValue;
      }

      var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();

      if(caloriesDayData[0].serverDetailList.length != allSelectedServersUrl.length){
        for (int i = 0; i < allSelectedServersUrl.length; i++) {
          var url = caloriesDayData[0].serverDetailList;
          if(url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty){
            var serverDetail = ServerDetailDataTable();
            serverDetail.serverUrl = allSelectedServersUrl[i].url;
            serverDetail.patientId = allSelectedServersUrl[i].patientId;
            serverDetail.patientName = "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
            serverDetail.objectId = "";
            caloriesDayData[0].serverDetailList.add(serverDetail);
          }
        }
      }
      caloriesDayData[0].isSync = false;
      caloriesDayData[0].needExport = true;
      await DataBaseHelper.shared.updateActivityData(caloriesDayData[0]);

    }
  }

  static insertUpdateCaloriesAtWeekLevel(DateTime dateTime,String weekDate,double totalCalories, List<ActivityTable> allDataFromDB, String getTotalMinFromTwoDates)async{

    List<ActivityTable> dailyDataList = Hive.box<ActivityTable>(Constant.tableActivity).values.toList().where
      ((element) => element.type == Constant.typeDay
        && element.weeksDate == weekDate).toList();

    var activityMinWeeklyDataList = allDataFromDB
        .where((element) =>
    element.weeksDate ==  weekDate &&
        element.type == Constant.typeWeek && element.title == null && element.smileyType == null)
        .toList();
    if(activityMinWeeklyDataList.isEmpty){
      var insertingData = ActivityTable();
      insertingData.title = null;
      insertingData.smileyType = null;

      insertingData.total = double.parse(getTotalMinFromTwoDates);
      insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateTime);
      insertingData.type = Constant.typeWeek;
      insertingData.weeksDate = weekDate ;
      await DataBaseHelper.shared.insertActivityData(insertingData);
    }
    else{
      var totalValue = 0.0;
      for (int i = 0; i < dailyDataList.length; i++) {
        if(dailyDataList[i].title == null && dailyDataList[i].smileyType == null){
          totalValue += dailyDataList[i].total ?? 0.0;
        }
      }
      activityMinWeeklyDataList[0].total = totalValue;

      activityMinWeeklyDataList[0].isSync = false;
      await DataBaseHelper.shared.updateActivityData(activityMinWeeklyDataList[0]);
    }

    var caloriesWeeklyDataList = allDataFromDB
        .where((element) =>
    element.weeksDate ==  weekDate &&
        element.type == Constant.typeWeek && element.title == Constant.titleCalories)
        .toList();
    if(caloriesWeeklyDataList.isEmpty){
      var insertingData = ActivityTable();
      insertingData.title = Constant.titleCalories;

      insertingData.total = totalCalories;
      insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateTime);
      insertingData.type = Constant.typeWeek;
      insertingData.weeksDate = weekDate ;
      await DataBaseHelper.shared.insertActivityData(insertingData);
    }
    else{
      var totalValue = 0.0;
      for (int i = 0; i < dailyDataList.length; i++) {
        if(dailyDataList[i].title == Constant.titleCalories){
          totalValue += dailyDataList[i].total ?? 0.0;
        }
      }
      caloriesWeeklyDataList[0].total = totalValue;

      caloriesWeeklyDataList[0].isSync = false;
      await DataBaseHelper.shared.updateActivityData(caloriesWeeklyDataList[0]);
    }

  }

  static stepsHeartExEntry(DateTime dateTime,String activityName,int insertedId, DateTime activityStartDate,
      DateTime activityEndDate,int position, bool isFromAppleHealth) async {
    var allDataFromDBReturn = getActivityListData();
    var formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
        .format(dateTime);

    ///Activity Type
    var activityTypeDataList = allDataFromDBReturn
        .where((element) =>
            element.displayLabel == activityName &&
            Utils.changeDateFormatBasedOnDBDate(
                    element.activityStartDate ?? DateTime.now()) ==
                Utils.changeDateFormatBasedOnDBDate(activityStartDate) &&
            Utils.changeDateFormatBasedOnDBDate(
                    element.activityEndDate ?? DateTime.now()) ==
                Utils.changeDateFormatBasedOnDBDate(activityEndDate) &&
            element.type == Constant.typeDaysData &&
            element.title == Constant.titleActivityType)
        .toList();


    ///titleParent
    var activityParentListData = allDataFromDBReturn
        .where((element) =>
            element.displayLabel == activityName &&
            Utils.changeDateFormatBasedOnDBDate(
                    element.activityStartDate ?? DateTime.now()) ==
                Utils.changeDateFormatBasedOnDBDate(activityStartDate) &&
            Utils.changeDateFormatBasedOnDBDate(
                    element.activityEndDate ?? DateTime.now()) ==
                Utils.changeDateFormatBasedOnDBDate(activityEndDate) &&
            element.type == Constant.typeDaysData &&
            element.title == Constant.titleParent)
        .toList();

    ///Days str
    List<ActivityTable> dayStrengthData = [];
      dayStrengthData = allDataFromDBReturn
          .where((element) =>
              element.type == Constant.typeDaysData &&
              (element.title == Constant.titleDaysStr) &&
              element.displayLabel == activityName &&
                  Utils.changeDateFormatBasedOnDBDate(
                      element.activityStartDate ?? DateTime.now()) ==
                      Utils.changeDateFormatBasedOnDBDate(activityStartDate) &&
                  Utils.changeDateFormatBasedOnDBDate(
                      element.activityEndDate ?? DateTime.now()) ==
                      Utils.changeDateFormatBasedOnDBDate(activityEndDate))
          .toList();

    ///Steps
    List<ActivityTable> stepsData = [];
      stepsData = allDataFromDBReturn
          .where((element) =>
              element.type == Constant.typeDaysData &&
              (element.title == Constant.titleSteps) &&
              element.displayLabel == activityName &&
                  Utils.changeDateFormatBasedOnDBDate(
                      element.activityStartDate ?? DateTime.now()) ==
                      Utils.changeDateFormatBasedOnDBDate(activityStartDate) &&
                  Utils.changeDateFormatBasedOnDBDate(
                      element.activityEndDate ?? DateTime.now()) ==
                      Utils.changeDateFormatBasedOnDBDate(activityEndDate))
          .toList();

      ///Heart rate rest
    List<ActivityTable> heartRateRestData = [];
      heartRateRestData = allDataFromDBReturn
          .where((element) =>
              element.type == Constant.typeDaysData &&
              (element.title == Constant.titleHeartRateRest) &&
              element.displayLabel == activityName &&
                  Utils.changeDateFormatBasedOnDBDate(
                      element.activityStartDate ?? DateTime.now()) ==
                      Utils.changeDateFormatBasedOnDBDate(activityStartDate) &&
                  Utils.changeDateFormatBasedOnDBDate(
                      element.activityEndDate ?? DateTime.now()) ==
                      Utils.changeDateFormatBasedOnDBDate(activityEndDate))
          .toList();

      ///Heart rate peak
    List<ActivityTable> heartRatePeakData = [];
      heartRatePeakData = allDataFromDBReturn
          .where((element) =>
              element.type == Constant.typeDaysData &&
              (element.title == Constant.titleHeartRatePeak) &&
              element.displayLabel == activityName &&
                  Utils.changeDateFormatBasedOnDBDate(
                      element.activityStartDate ?? DateTime.now()) ==
                      Utils.changeDateFormatBasedOnDBDate(activityStartDate) &&
                  Utils.changeDateFormatBasedOnDBDate(
                      element.activityEndDate ?? DateTime.now()) ==
                      Utils.changeDateFormatBasedOnDBDate(activityEndDate))
          .toList();

      ///Smiley
    List<ActivityTable> exData = [];
      exData = allDataFromDBReturn
          .where((element) =>
              element.type == Constant.typeDaysData &&
              (element.title == null && element.smileyType != null) &&
              element.displayLabel == activityName &&
                  Utils.changeDateFormatBasedOnDBDate(
                      element.activityStartDate ?? DateTime.now()) ==
                      Utils.changeDateFormatBasedOnDBDate(activityStartDate) &&
                  Utils.changeDateFormatBasedOnDBDate(
                      element.activityEndDate ?? DateTime.now()) ==
                      Utils.changeDateFormatBasedOnDBDate(activityEndDate))
          .toList();

    if(dayStrengthData.isEmpty){
      var insertCheckBoxDayData = ActivityTable();
      insertCheckBoxDayData.title = Constant.titleDaysStr;
      insertCheckBoxDayData.date = formattedDate;
      insertCheckBoxDayData.dateTime = dateTime;
      insertCheckBoxDayData.isFromAppleHealth = isFromAppleHealth;
      // if(activityName == Constant.typeOther){
      //   insertCheckBoxDayData.displayLabel = activityName + position.toString();
      // }else {
      //   insertCheckBoxDayData.displayLabel = activityName;
      // }
      insertCheckBoxDayData.displayLabel = activityName;
      insertCheckBoxDayData.total = null;
      insertCheckBoxDayData.type = Constant.typeDaysData;
      String formattedDateStart =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findFirstDateOfTheWeekImport(dateTime));
      String formattedDateEnd =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findLastDateOfTheWeekImport(dateTime));

      insertCheckBoxDayData.activityStartDate = activityStartDate;
      insertCheckBoxDayData.activityEndDate = activityEndDate;
      insertCheckBoxDayData.weeksDate = "$formattedDateStart-$formattedDateEnd";
      insertCheckBoxDayData.isCheckedDayData = false;
      insertCheckBoxDayData.insertedDayDataId = insertedId;
      insertCheckBoxDayData.isSync = false;
      insertCheckBoxDayData.needExport = false;
      var connectedServerUrlDaysStr = Utils.getServerListPreference().where((
          element) => element.patientId != "" && element.isSelected).toList();
      if (connectedServerUrlDaysStr.isNotEmpty) {
        for (int i = 0; i < connectedServerUrlDaysStr.length; i++) {
          var data = ServerDetailDataTable();
          data.dataSyncServerWise = false;
          data.objectId = "";
          data.serverUrl = connectedServerUrlDaysStr[i].url;
          data.patientId = connectedServerUrlDaysStr[i].patientId;
          data.clientId = connectedServerUrlDaysStr[i].clientId;
          data.serverToken = connectedServerUrlDaysStr[i].authToken;
          data.patientName = "${connectedServerUrlDaysStr[i]
              .patientFName}${connectedServerUrlDaysStr[i]
              .patientLName}";
          insertCheckBoxDayData.serverDetailList.add(data);
        }
      }

      await DataBaseHelper.shared.insertActivityData(insertCheckBoxDayData);
    }else{
      if (dayStrengthData[0].key != null) {
        dayStrengthData[0].displayLabel = activityName;
        var allSelectedServersUrl = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected).toList();

        if (dayStrengthData[0].serverDetailList.length !=
            allSelectedServersUrl.length) {
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = dayStrengthData[0].serverDetailList;
            if (url
                .where((element) =>
            element.serverUrl == allSelectedServersUrl[i].url)
                .toList()
                .isEmpty) {
              var serverDetail = ServerDetailDataTable();
              serverDetail.serverUrl = allSelectedServersUrl[i].url;
              serverDetail.patientId = allSelectedServersUrl[i].patientId;
              serverDetail.patientName = "${allSelectedServersUrl[i]
                  .patientFName}${allSelectedServersUrl[i].patientLName}";
              serverDetail.objectId = "";
              dayStrengthData[0].serverDetailList.add(
                  serverDetail);
            }
          }
        }

        dayStrengthData[0].activityStartDate = activityStartDate;
        dayStrengthData[0].activityEndDate = activityEndDate;
        dayStrengthData[0].isSync = false;
        dayStrengthData[0].needExport = false;
        dayStrengthData[0].isFromAppleHealth = isFromAppleHealth;
        await DataBaseHelper.shared.updateActivityData(dayStrengthData[0]);
      }
    }

    if(stepsData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.title = Constant.titleSteps;
      insertingData.date = formattedDate;
      insertingData.dateTime = dateTime;
      insertingData.displayLabel = activityName;
      insertingData.isFromAppleHealth = isFromAppleHealth;
      // if(activityName == Constant.typeOther){
      //   insertingData.displayLabel = activityName + position.toString();
      // }else {
      //   insertingData.displayLabel = activityName;
      // }
      insertingData.total = null;
      insertingData.type = Constant.typeDaysData;
      String formattedDateStart =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findFirstDateOfTheWeekImport(dateTime));
      String formattedDateEnd =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findLastDateOfTheWeekImport(dateTime));

      insertingData.activityStartDate = activityStartDate;
      insertingData.activityEndDate = activityEndDate;
      insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";
      insertingData.insertedDayDataId = insertedId;
      insertingData.isSync = false;
      insertingData.needExport = false;

      var connectedServerUrlSteps = Utils.getServerListPreference().where((
          element) => element.patientId != "" && element.isSelected).toList();
      if (connectedServerUrlSteps.isNotEmpty) {
        for (int i = 0; i < connectedServerUrlSteps.length; i++) {
          var data = ServerDetailDataTable();
          data.dataSyncServerWise = false;
          data.objectId = "";
          data.serverUrl = connectedServerUrlSteps[i].url;
          data.patientId = connectedServerUrlSteps[i].patientId;
          data.clientId = connectedServerUrlSteps[i].clientId;
          data.serverToken = connectedServerUrlSteps[i].authToken;
          data.patientName = "${connectedServerUrlSteps[i]
              .patientFName}${connectedServerUrlSteps[i]
              .patientLName}";
          insertingData.serverDetailList.add(data);
        }
      }

      await DataBaseHelper.shared.insertActivityData(insertingData);
    }else{
      if (stepsData[0].key != null) {
        stepsData[0].displayLabel = activityName;
        var allSelectedServersUrl = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected).toList();

        if (stepsData[0].serverDetailList.length !=
            allSelectedServersUrl.length) {
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = stepsData[0].serverDetailList;
            if (url
                .where((element) =>
            element.serverUrl == allSelectedServersUrl[i].url)
                .toList()
                .isEmpty) {
              var serverDetail = ServerDetailDataTable();
              serverDetail.serverUrl = allSelectedServersUrl[i].url;
              serverDetail.patientId = allSelectedServersUrl[i].patientId;
              serverDetail.patientName = "${allSelectedServersUrl[i]
                  .patientFName}${allSelectedServersUrl[i].patientLName}";
              serverDetail.objectId = "";
              stepsData[0].serverDetailList.add(
                  serverDetail);
            }
          }
        }
        stepsData[0].activityStartDate = activityStartDate;
        stepsData[0].activityEndDate = activityEndDate;
        stepsData[0].isSync = false;
        stepsData[0].needExport = false;
        stepsData[0].isFromAppleHealth = isFromAppleHealth;
        await DataBaseHelper.shared.updateActivityData(stepsData[0]);
      }
    }

    if(heartRateRestData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.title = Constant.titleHeartRateRest;
      insertingData.date = formattedDate;
      insertingData.dateTime = dateTime;
      insertingData.displayLabel = activityName;
      insertingData.isFromAppleHealth = isFromAppleHealth;
      // if(activityName == Constant.typeOther){
      //   insertingData.displayLabel = activityName + position.toString();
      // }else {
      //   insertingData.displayLabel = activityName;
      // }
      insertingData.value1 = null;
      insertingData.type = Constant.typeDaysData;
      String formattedDateStart =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findFirstDateOfTheWeekImport(dateTime));
      String formattedDateEnd =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findLastDateOfTheWeekImport(dateTime));

      insertingData.activityStartDate = activityStartDate;
      insertingData.activityEndDate = activityEndDate;
      insertingData.isSync = false;
      insertingData.needExport = false;
      insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";
      insertingData.insertedDayDataId = insertedId;
      var connectedServerUrlRestHeartRate = Utils.getServerListPreference()
          .where((element) => element.patientId != "" && element.isSelected)
          .toList();
      if (connectedServerUrlRestHeartRate.isNotEmpty) {
        for (int i = 0; i < connectedServerUrlRestHeartRate.length; i++) {
          var data = ServerDetailDataTable();
          data.dataSyncServerWise = false;
          data.objectId = "";
          data.serverUrl = connectedServerUrlRestHeartRate[i].url;
          data.patientId = connectedServerUrlRestHeartRate[i].patientId;
          data.clientId = connectedServerUrlRestHeartRate[i].clientId;
          data.serverToken = connectedServerUrlRestHeartRate[i].authToken;
          data.patientName = "${connectedServerUrlRestHeartRate[i]
              .patientFName}${connectedServerUrlRestHeartRate[i]
              .patientLName}";
          insertingData.serverDetailList.add(data);
        }
      }

      await DataBaseHelper.shared.insertActivityData(insertingData);
    }else{
      if (heartRateRestData[0].key != null) {
        heartRateRestData[0].displayLabel = activityName;
        var allSelectedServersUrl = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected).toList();

        if (heartRateRestData[0].serverDetailList.length !=
            allSelectedServersUrl.length) {
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = heartRateRestData[0].serverDetailList;
            if (url
                .where((element) =>
            element.serverUrl == allSelectedServersUrl[i].url)
                .toList()
                .isEmpty) {
              var serverDetail = ServerDetailDataTable();
              serverDetail.serverUrl = allSelectedServersUrl[i].url;
              serverDetail.patientId = allSelectedServersUrl[i].patientId;
              serverDetail.patientName = "${allSelectedServersUrl[i]
                  .patientFName}${allSelectedServersUrl[i].patientLName}";
              serverDetail.objectId = "";
              heartRateRestData[0].serverDetailList.add(
                  serverDetail);
            }
          }
        }
        heartRateRestData[0].activityStartDate = activityStartDate;
        heartRateRestData[0].activityEndDate = activityEndDate;
        heartRateRestData[0].isSync = false;
        heartRateRestData[0].needExport = false;
        heartRateRestData[0].isFromAppleHealth = isFromAppleHealth;
        await DataBaseHelper.shared.updateActivityData(heartRateRestData[0]);
      }
    }

    if(heartRatePeakData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.title = Constant.titleHeartRatePeak;
      insertingData.date = formattedDate;
      insertingData.dateTime = dateTime;
      insertingData.displayLabel = activityName;
      insertingData.isFromAppleHealth = isFromAppleHealth;
      // if(activityName == Constant.typeOther){
      //   insertingData.displayLabel = activityName + position.toString();
      // }else {
      //   insertingData.displayLabel = activityName;
      // }
      insertingData.value2 = null;
      insertingData.type = Constant.typeDaysData;
      insertingData.activityStartDate = activityStartDate;
      insertingData.activityEndDate = activityEndDate;
      String formattedDateStart =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findFirstDateOfTheWeekImport(dateTime));
      String formattedDateEnd =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findLastDateOfTheWeekImport(dateTime));

      insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";
      insertingData.insertedDayDataId = insertedId;
      insertingData.isSync = false;
      insertingData.needExport = false;
      var connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
      if(connectedServerUrl.isNotEmpty) {
        for (int i = 0; i < connectedServerUrl.length; i++) {
          var data = ServerDetailDataTable();
          data.dataSyncServerWise = false;
          data.objectId = "";
          data.serverUrl = connectedServerUrl[i].url;
          data.patientId = connectedServerUrl[i].patientId;
          data.clientId = connectedServerUrl[i].clientId;
          data.serverToken = connectedServerUrl[i].authToken;
          data.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
              .patientLName}";
          insertingData.serverDetailList.add(data);
        }
      }

      await DataBaseHelper.shared.insertActivityData(insertingData);
    }else{
      if (heartRatePeakData[0].key != null) {
        heartRatePeakData[0].displayLabel = activityName;
        var allSelectedServersUrl = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected).toList();

        if (heartRatePeakData[0].serverDetailList.length !=
            allSelectedServersUrl.length) {
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = heartRatePeakData[0].serverDetailList;
            if (url
                .where((element) =>
            element.serverUrl == allSelectedServersUrl[i].url)
                .toList()
                .isEmpty) {
              var serverDetail = ServerDetailDataTable();
              serverDetail.serverUrl = allSelectedServersUrl[i].url;
              serverDetail.patientId = allSelectedServersUrl[i].patientId;
              serverDetail.patientName = "${allSelectedServersUrl[i]
                  .patientFName}${allSelectedServersUrl[i].patientLName}";
              serverDetail.objectId = "";
              heartRatePeakData[0].serverDetailList.add(
                  serverDetail);
            }
          }
        }

        heartRatePeakData[0].activityStartDate = activityStartDate;
        heartRatePeakData[0].activityEndDate = activityEndDate;
        heartRatePeakData[0].isSync = false;
        heartRatePeakData[0].needExport = false;
        heartRatePeakData[0].isFromAppleHealth = isFromAppleHealth;
        await DataBaseHelper.shared.updateActivityData(heartRatePeakData[0]);
      }
    }

    if(exData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.title = null;
      insertingData.smileyType = Constant.defaultSmileyType;
      insertingData.date = formattedDate;
      insertingData.dateTime = dateTime;
      insertingData.displayLabel = activityName;
      insertingData.isFromAppleHealth = isFromAppleHealth;
      // if(activityName == Constant.typeOther){
      //   insertingData.displayLabel = activityName + position.toString();
      // }else {
      //   insertingData.displayLabel = activityName;
      // }
      insertingData.type = Constant.typeDaysData;
      String formattedDateStart =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findFirstDateOfTheWeekImport(dateTime));
      String formattedDateEnd =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findLastDateOfTheWeekImport(dateTime));
      insertingData.isSync = false;
      insertingData.needExport = false;
      insertingData.activityStartDate = activityStartDate;
      insertingData.activityEndDate = activityEndDate;
      insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";
      insertingData.insertedDayDataId = insertedId;
      var connectedServerUrlEx = Utils.getServerListPreference().where((
          element) => element.patientId != "" && element.isSelected).toList();
      if (connectedServerUrlEx.isNotEmpty) {
        for (int i = 0; i < connectedServerUrlEx.length; i++) {
          var data = ServerDetailDataTable();
          data.dataSyncServerWise = false;
          data.objectId = "";
          data.serverUrl = connectedServerUrlEx[i].url;
          data.patientId = connectedServerUrlEx[i].patientId;
          data.clientId = connectedServerUrlEx[i].clientId;
          data.serverToken = connectedServerUrlEx[i].authToken;
          data.patientName =
          "${connectedServerUrlEx[i].patientFName}${connectedServerUrlEx[i]
              .patientLName}";
          insertingData.serverDetailList.add(data);
        }
      }

      await DataBaseHelper.shared.insertActivityData(insertingData);
    }else{
      if (exData[0].key != null) {
        exData[0].displayLabel = activityName;
        var allSelectedServersUrl = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected).toList();

        if (exData[0].serverDetailList.length !=
            allSelectedServersUrl.length) {
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = exData[0].serverDetailList;
            if (url
                .where((element) =>
            element.serverUrl == allSelectedServersUrl[i].url)
                .toList()
                .isEmpty) {
              var serverDetail = ServerDetailDataTable();
              serverDetail.serverUrl = allSelectedServersUrl[i].url;
              serverDetail.patientId = allSelectedServersUrl[i].patientId;
              serverDetail.patientName = "${allSelectedServersUrl[i]
                  .patientFName}${allSelectedServersUrl[i].patientLName}";
              serverDetail.objectId = "";
              exData[0].serverDetailList.add(
                  serverDetail);
            }
          }
        }
        exData[0].activityStartDate = activityStartDate;
        exData[0].activityEndDate = activityEndDate;
        exData[0].isSync = false;
        exData[0].needExport = false;
        exData[0].isFromAppleHealth = isFromAppleHealth;
        exData[0].smileyType = Constant.defaultSmileyType;
        await DataBaseHelper.shared.updateActivityData(exData[0]);
      }
    }

    if(activityTypeDataList.isEmpty){
      var insertingData = ActivityTable();
      insertingData.displayLabel = activityName;
      insertingData.dateTime = activityStartDate;
      insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(activityStartDate ?? DateTime.now());
      insertingData.activityStartDate = activityStartDate;
      insertingData.activityEndDate = activityEndDate;
      insertingData.title = Constant.titleActivityType;
      insertingData.type = Constant.typeDaysData;
      insertingData.isSync = false;
      insertingData.needExport = false;
      insertingData.isFromAppleHealth = isFromAppleHealth;
      String formattedDateStart =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findFirstDateOfTheWeekImport(dateTime));
      String formattedDateEnd =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findLastDateOfTheWeekImport(dateTime));

      insertingData.activityStartDate = activityStartDate;
      insertingData.activityEndDate = activityEndDate;
      insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";
      var connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != ""
          && element.isSelected).toList();
      if(connectedServerUrl.isNotEmpty) {
        for (int i = 0; i < connectedServerUrl.length; i++) {
          var data = ServerDetailDataTable();
          data.dataSyncServerWise = false;
          data.objectId = "";
          data.serverUrl = connectedServerUrl[i].url;
          data.patientId = connectedServerUrl[i].patientId;
          data.clientId = connectedServerUrl[i].clientId;
          data.serverToken = connectedServerUrl[i].authToken;
          data.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
              .patientLName}";
          insertingData.serverDetailList.add(data);
        }
      }
      await DataBaseHelper.shared.insertActivityData(insertingData);
    } else{
      if(activityTypeDataList[0].key != null){
        activityTypeDataList[0].displayLabel = activityName;
        var allSelectedServersUrl = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected).toList();

        if (activityTypeDataList[0].serverDetailList.length !=
            allSelectedServersUrl.length) {
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = activityTypeDataList[0].serverDetailList;
            if (url
                .where((element) =>
            element.serverUrl == allSelectedServersUrl[i].url)
                .toList()
                .isEmpty) {
              var serverDetail = ServerDetailDataTable();
              serverDetail.serverUrl = allSelectedServersUrl[i].url;
              serverDetail.patientId = allSelectedServersUrl[i].patientId;
              serverDetail.patientName = "${allSelectedServersUrl[i]
                  .patientFName}${allSelectedServersUrl[i].patientLName}";
              serverDetail.objectId = "";
              activityTypeDataList[0].serverDetailList.add(
                  serverDetail);
            }
          }
        }
        activityTypeDataList[0].activityStartDate = activityStartDate;
        activityTypeDataList[0].activityEndDate = activityEndDate;
        activityTypeDataList[0].isSync = false;
        activityTypeDataList[0].needExport = false;
        activityTypeDataList[0].isFromAppleHealth = isFromAppleHealth;
        await DataBaseHelper.shared.updateActivityData(activityTypeDataList[0]);
      }
    }

    if(activityParentListData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.displayLabel = activityName;
      insertingData.dateTime = activityStartDate;
      insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(activityStartDate ?? DateTime.now());
      insertingData.activityStartDate = activityStartDate;
      insertingData.activityEndDate = activityEndDate;
      insertingData.title = Constant.titleParent;
      insertingData.type = Constant.typeDaysData;
      String formattedDateStart =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findFirstDateOfTheWeekImport(dateTime));
      String formattedDateEnd =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findLastDateOfTheWeekImport(dateTime));
      insertingData.activityStartDate = activityStartDate;
      insertingData.activityEndDate = activityEndDate;
      insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";
      insertingData.isSync = false;
      insertingData.needExport = false;
      insertingData.isFromAppleHealth = isFromAppleHealth;
      var connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != ""
          && element.isSelected).toList();
      if(connectedServerUrl.isNotEmpty) {
        for (int i = 0; i < connectedServerUrl.length; i++) {
          var data = ServerDetailDataTable();
          data.dataSyncServerWise = false;
          data.objectId = "";
          data.serverUrl = connectedServerUrl[i].url;
          data.patientId = connectedServerUrl[i].patientId;
          data.clientId = connectedServerUrl[i].clientId;
          data.serverToken = connectedServerUrl[i].authToken;
          data.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
              .patientLName}";
          insertingData.serverDetailList.add(data);
        }
      }
      await DataBaseHelper.shared.insertActivityData(insertingData);
    } else{
      if(activityParentListData[0].key != null){
        activityParentListData[0].displayLabel = activityName;
        var allSelectedServersUrl = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected).toList();

        if (activityParentListData[0].serverDetailList.length !=
            allSelectedServersUrl.length) {
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = activityParentListData[0].serverDetailList;
            if (url
                .where((element) =>
            element.serverUrl == allSelectedServersUrl[i].url)
                .toList()
                .isEmpty) {
              var serverDetail = ServerDetailDataTable();
              serverDetail.serverUrl = allSelectedServersUrl[i].url;
              serverDetail.patientId = allSelectedServersUrl[i].patientId;
              serverDetail.patientName = "${allSelectedServersUrl[i]
                  .patientFName}${allSelectedServersUrl[i].patientLName}";
              serverDetail.objectId = "";
              activityParentListData[0].serverDetailList.add(
                  serverDetail);
            }
          }
        }
        activityParentListData[0].isSync = false;
        activityParentListData[0].needExport = false;
        activityParentListData[0].activityStartDate = activityStartDate;
        activityParentListData[0].activityEndDate = activityEndDate;
        activityParentListData[0].isFromAppleHealth = isFromAppleHealth;
        await DataBaseHelper.shared.updateActivityData(activityParentListData[0]);
      }
    }

  }

  static List<HealthData> getActivityLevelDataFromHealth(List<HealthDataPoint> healthData){
    List<HealthData> valueStepList = [];

    var caloriesWiseData =
    healthData.where((element) => element.type == HealthDataType.WORKOUT).toList();

   /* if(Platform.isAndroid){
      for (int a = 0; a < tempList.length; a++) {
        if (stepWiseData.isEmpty) {
          stepWiseData.add(tempList[a]);
        } else {
          var checking = stepWiseData.where((element) =>
          element.value == tempList[a].value &&
              element.value == tempList[a].value &&
              element.unit == tempList[a].unit &&
              element.dateFrom == tempList[a].dateFrom &&
              element.dateTo == tempList[a].dateTo &&
              element.platform == tempList[a].platform &&
              element.deviceId == tempList[a].deviceId &&
              element.sourceId == tempList[a].sourceId
          ).toList();
          if (checking.isEmpty) {
            stepWiseData.add(tempList[a]);
          }
        }
      }
    }else if(Platform.isIOS){
      stepWiseData = tempList;
    }
*/
    if (caloriesWiseData.isNotEmpty) {
      DateTime? lastDate;
      for (int i = 0; i < caloriesWiseData.length; i++) {
        lastDate ??= Utils.getDateFromFullDate(caloriesWiseData[i].dateFrom);
        if (lastDate == Utils.getDateFromFullDate(caloriesWiseData[i].dateFrom)
        && caloriesWiseData[i].value.toJson()["workoutActivityType"] == HealthWorkoutActivityType.BASEBALL.name.toString()) {
          if (valueStepList.isEmpty) {
            valueStepList.add(HealthData(
                Utils.getDateFromFullDate(caloriesWiseData[i].dateFrom),
                caloriesWiseData[i].value.toJson()["totalEnergyBurned"].toString(),
                Constant.titleCalories,HealthWorkoutActivityType.BASEBALL,true));
          } else {
            var getData = valueStepList.indexWhere((element) =>
            element.dateTime == lastDate).toInt();
            if (getData != -1) {
                valueStepList[getData].value =
                    (double.parse(valueStepList[getData].value.toString()) +
                        double.parse(caloriesWiseData[i].value.toJson()["totalEnergyBurned"].toString()))
                        .toString();
            }
          }
        }
        else if(caloriesWiseData[i].value.toJson()["workoutActivityType"] == HealthWorkoutActivityType.BASEBALL.name.toString()){
          lastDate = Utils.getDateFromFullDate(caloriesWiseData[i].dateFrom);
          valueStepList.add(HealthData(
              Utils.getDateFromFullDate(caloriesWiseData[i].dateFrom),
              caloriesWiseData[i].value.toJson()["totalEnergyBurned"].toString(),
              Constant.titleCalories,HealthWorkoutActivityType.BASEBALL,true));
        }
      }
    }


    return valueStepList;
  }

  static List<HealthData> getStepDataFromHealth(List<HealthDataPoint> healthData,String? type,HealthDataType healthDataType){
    List<HealthData> valueStepList = [];

    var tempList =
    healthData.where((element) => element.type == healthDataType).toList();
    List<HealthDataPoint> stepWiseData = [];

    if(Platform.isAndroid){
      for (int a = 0; a < tempList.length; a++) {
        if (stepWiseData.isEmpty) {
          stepWiseData.add(tempList[a]);
        } else {
          var checking = stepWiseData.where((element) =>
          element.value == tempList[a].value &&
              element.value == tempList[a].value &&
              element.unit == tempList[a].unit &&
              element.dateFrom == tempList[a].dateFrom &&
              element.dateTo == tempList[a].dateTo &&
              // element.platform == tempList[a].platform &&
              // element.deviceId == tempList[a].deviceId &&
              element.sourceId == tempList[a].sourceId
          ).toList();
          if (checking.isEmpty) {
            stepWiseData.add(tempList[a]);
          }
        }
      }
    }else if(Platform.isIOS){
      stepWiseData = tempList;
    }

    if (stepWiseData.isNotEmpty) {
      DateTime? lastDate;
      for (int i = 0; i < stepWiseData.length; i++) {
        lastDate ??= Utils.getDateFromFullDate(stepWiseData[i].dateFrom);
        if (lastDate == Utils.getDateFromFullDate(stepWiseData[i].dateFrom)) {
          if (valueStepList.isEmpty) {
            valueStepList.add(HealthData(
                Utils.getDateFromFullDate(stepWiseData[i].dateFrom),
                NumericHealthValue.fromJson(stepWiseData[i].value.toJson()).numericValue.toString(),
                type!,null,false));
          } else {
            var getData = valueStepList.indexWhere((element) =>
            element.dateTime == lastDate).toInt();
            if (getData != -1) {
              if (healthDataType == HealthDataType.HEART_RATE) {
                if (double.parse(valueStepList[getData].value) <
                    double.parse(NumericHealthValue.fromJson(stepWiseData[i].value.toJson()).numericValue.toString())) {
                  valueStepList[getData].value =
                      double.parse(NumericHealthValue.fromJson(stepWiseData[i].value.toJson()).numericValue.toString())
                          .toString();
                }
              } else {
                valueStepList[getData].value =
                    (double.parse(valueStepList[getData].value.toString()) +
                        double.parse(NumericHealthValue.fromJson(stepWiseData[i].value.toJson()).numericValue.toString()))
                        .toString();
              }
            }
          }
        }
        else {
          lastDate = Utils.getDateFromFullDate(stepWiseData[i].dateFrom);
          valueStepList.add(HealthData(
              Utils.getDateFromFullDate(stepWiseData[i].dateFrom),
              NumericHealthValue.fromJson(stepWiseData[i].value.toJson()).numericValue.toString(),
              type!,null,false));
        }
      }
    }


    return valueStepList;
  }

  static List<HealthData> getCaloriesData(List<HealthDataPoint> healthData,String type,HealthDataType healthDataType){
    List<HealthData> valueStepList = [];

    var stepWiseData = healthData.where((element) =>
    element.type == healthDataType).toList();

    if (stepWiseData.isNotEmpty) {
      DateTime? lastDate;
      for (int i = 0; i < stepWiseData.length; i++) {
        lastDate ??= Utils.getDateFromFullDate(stepWiseData[i].dateFrom);
        if (lastDate == Utils.getDateFromFullDate(stepWiseData[i].dateFrom)) {
          if (valueStepList.isEmpty) {
            if (Platform.isAndroid && (stepWiseData[i].sourceName ==
                "com.google.android.apps.fitness")) {
              // stepWiseData[i]].sourceName == "com.physical.activity.fitness1")){
              var value = stepWiseData[i].value.toJson()['totalEnergyBurned'];
              if(value != null || value != "0") {
                valueStepList.add(HealthData(
                    Utils.getDateFromFullDate(stepWiseData[i].dateFrom),
                    value.toString(),
                    type,Utils.getWorkoutActivityType(stepWiseData[i].value.toJson()["workoutActivityType"]),true));
                // type,stepWiseData[i].value.toJson()["workoutActivityType"] as HealthWorkoutActivityType,true));
              }
            }
          } else {
            var getData = valueStepList.indexWhere((element) =>
            element.dateTime == lastDate).toInt();
            if (getData != -1) {
              if (Platform.isAndroid && (stepWiseData[i].sourceName ==
                  "com.google.android.apps.fitness")) {
                // stepWiseData[i].sourceName == "com.physical.activity.fitness1")) {
                var value = stepWiseData[i].value.toJson()['totalEnergyBurned'];
                if(value != null || value != "0") {
                  valueStepList[getData].value =
                      (double.parse(valueStepList[getData].value.toString()) +
                          double.parse(value.toString()))
                          .toString();
                }
              }
            }
          }
        }
        else {
          if (Platform.isAndroid && (stepWiseData[i].sourceName ==
              "com.google.android.apps.fitness")) {
            // stepWiseData[i].sourceName == "com.physical.activity.fitness1")) {
            lastDate = Utils.getDateFromFullDate(stepWiseData[i].dateFrom);
            var value = stepWiseData[i].value.toJson()['totalEnergyBurned'];
            if(value != null || value != "0") {
              valueStepList.add(HealthData(
                  Utils.getDateFromFullDate(stepWiseData[i].dateFrom),
                  value.toString(),
                  type,Utils.getWorkoutActivityType(stepWiseData[i].value.toJson()["workoutActivityType"]),true));
            }
          }
        }
      }
    }


    return valueStepList;
  }

  static insertUpdateHealthDay(DateTime dateTime,String titleName,String value) async {
    Debug.printLog("insertUpdateHealthDay...$dateTime  $titleName  $value");
    var allDataFromDB = Hive.box<ActivityTable>(Constant.tableActivity).values.toList();
    List<ActivityTable> weekInsertedData = [];

    String formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateTime);

    weekInsertedData = allDataFromDB.where((element) =>
    element.date == formattedDate &&
        element.type == Constant.typeDay && element.title == ((titleName == "")?null:titleName))
        .toList();

    if(weekInsertedData.isEmpty) {
      var insertingData = ActivityTable();
      insertingData.title = ((titleName == "")?null:titleName);

      insertingData.date =
          DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateTime);
      insertingData.dateTime = dateTime;


      insertingData.total = double.parse(value);
      insertingData.type = Constant.typeDay;
      insertingData.isSync = false;
      String formattedDateStart = "";
      String formattedDateEnd = "";


      formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(Utils.findFirstDateOfTheWeekImport(dateTime));
      formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(Utils.findLastDateOfTheWeekImport(dateTime));

      insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";

      var connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();

      if(connectedServerUrl.isNotEmpty) {
        for (int i = 0; i < connectedServerUrl.length; i++) {
          var serverDetail = ServerDetailDataTable();
          serverDetail.serverUrl = connectedServerUrl[i].url;
          serverDetail.patientId = connectedServerUrl[i].patientId;
          serverDetail.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i].patientLName}";
          serverDetail.objectId = "";
          serverDetail.serverToken = connectedServerUrl[i].authToken;
          serverDetail.clientId = connectedServerUrl[i].clientId;
          insertingData.serverDetailList.add(serverDetail);
        }
      }

      await DataBaseHelper.shared.insertActivityData(insertingData);
    }
    else{
      if(weekInsertedData.isNotEmpty) {
        weekInsertedData[0].total = double.parse(value);


        var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();

        if(weekInsertedData[0].serverDetailList.length != allSelectedServersUrl.length){
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = weekInsertedData[0].serverDetailList;
            if(url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty){
              var serverDetail = ServerDetailDataTable();
              serverDetail.serverUrl = allSelectedServersUrl[i].url;
              serverDetail.patientId = allSelectedServersUrl[i].patientId;
              serverDetail.patientName = "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
              serverDetail.objectId = "";
              weekInsertedData[0].serverDetailList.add(serverDetail);
            }
          }
        }
        weekInsertedData[0].isSync = false;
        await DataBaseHelper.shared.updateActivityData(weekInsertedData[0]);
      }

    }
    insertUpdateHealthWeek(dateTime, titleName);


  }

  static String lastStartWeekDate = "";
  static String lastEndWeekDate = "";

  static insertUpdateHealthWeek(DateTime dateTime, String titleName) async {
    Debug.printLog("weekly data insertUpdateHealthWeek......$dateTime  $titleName ");
    String formattedDateStart = "";
    String formattedDateEnd = "";

    var allDataFromDB = Hive.box<ActivityTable>(Constant.tableActivity).values.toList();
    List<ActivityTable> weekInsertedData = [];

    formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy)
        .format(Utils.findFirstDateOfTheWeekImport(dateTime));
    formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy)
        .format(Utils.findLastDateOfTheWeekImport(dateTime));

    weekInsertedData = allDataFromDB.where((element) =>
    element.weeksDate == "$formattedDateStart-$formattedDateEnd" &&
        element.type == Constant.typeWeek && element.title == ((titleName == "")?null:titleName)).toList();

    if(weekInsertedData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.title = titleName;


      insertingData.isSync = false;
      var weeklyCount = 0.0;
      var allDataFromDBDayWise = Hive.box<ActivityTable>(Constant.tableActivity).values.toList();
      if(allDataFromDBDayWise.isNotEmpty){
        var dataList = allDataFromDBDayWise
            .where((element) =>
        element.type == Constant.typeDay &&
            element.weeksDate == "$formattedDateStart-$formattedDateEnd" && element.title == titleName)
            .toList();
        for (int i = 0; i < dataList.length; i++) {
          weeklyCount += dataList[i].total ?? 0.0;
        }
      }
      if(weeklyCount == 0.0){
        insertingData.total = null;
      }else{
        insertingData.total = weeklyCount;
      }
      insertingData.type = Constant.typeWeek;
      insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";
      await DataBaseHelper.shared.insertActivityData(insertingData);
    }else{
      if(weekInsertedData.isNotEmpty) {
        var weeklyCount = 0.0;
        var allDataFromDBDayWise = Hive
            .box<ActivityTable>(Constant.tableActivity)
            .values
            .toList();
        if (allDataFromDBDayWise.isNotEmpty) {
          var dataList = allDataFromDBDayWise
              .where((element) =>
          element.type == Constant.typeDay &&
              element.weeksDate == "$formattedDateStart-$formattedDateEnd" &&
              element.title == titleName)
              .toList();
          for (int i = 0; i < dataList.length; i++) {
            if (titleName == Constant.titleHeartRatePeak) {
              if ((dataList[i].total ?? 0) > weeklyCount) {
                weeklyCount = dataList[i].total ?? 0;
              }
            } else {
              weeklyCount += dataList[i].total ?? 0.0;
            }
          }
          if (weeklyCount == 0.0) {
            weekInsertedData[0].total = null;
          } else {
            if (titleName == Constant.titleHeartRateRest) {
              if (weeklyCount != 0.0 && dataList.isNotEmpty) {
                weekInsertedData[0].total = weeklyCount / dataList.length;
              }
            } else {
              weekInsertedData[0].total = weeklyCount;
            }
          }
        }

        weekInsertedData[0].isSync = false;
        await DataBaseHelper.shared.updateActivityData(weekInsertedData[0]);
      }
    }
  }

/*  static exportDataFromHealth(Function callback) async {
    var permissions = ( (Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthTypeIos).map((e) => HealthDataAccess.READ_WRITE).toList();

    bool? hasPermissions =
    await Health().hasPermissions((Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthTypeIos, permissions: permissions);

    showDialogForProgress(Get.context!,false);
    var activityDataList = Hive.box<ActivityTable>(Constant.tableActivity).values.toList();
    if(activityDataList.isNotEmpty) {

      var nowRead = DateTime.now();
      var endDateRead = DateTime(nowRead.year, nowRead.month, nowRead.day+1);
      var startDateRead = DateTime(nowRead.year-1, nowRead.month, nowRead.day);
      List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
          startTime: startDateRead,endTime: endDateRead,types: (Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthTypeIos);
      var dailyData = activityDataList.where((element) => element.type == Constant.typeDay).toList();
      Debug.printLog("healthData.....${healthData.length}");
      if(healthData.isNotEmpty){
        for (int i = 0; i < dailyData.length; i++) {
          var dailyDataDateTime = dailyData[i].dateTime;

          List<HealthData> stepsListData = [];

          if(dailyData[i].title == Constant.titleSteps){
            stepsListData = getStepDataFromHealth(healthData,Constant.titleSteps,HealthDataType.STEPS);
          }
          else if(dailyData[i].title == Constant.titleCalories) {
            stepsListData = getStepDataFromHealth(
                healthData, Constant.titleCalories,
                HealthDataType.ACTIVE_ENERGY_BURNED);
          }
          else if(dailyData[i].title == Constant.titleHeartRatePeak){
            stepsListData = getStepDataFromHealth(healthData,Constant.titleHeartRatePeak,HealthDataType.HEART_RATE);
          }
          else if(dailyData[i].title == Constant.titleHeartRateRest){
            stepsListData = getStepDataFromHealth(healthData,Constant.titleHeartRateRest,HealthDataType.RESTING_HEART_RATE);
          }
          Debug.printLog("stepsListData.....${stepsListData.length}");

          var foundedData = stepsListData
              .where((elementHealthData) => Utils.getDateFromFullDate(elementHealthData.dateTime) == dailyDataDateTime).toList();
          Debug.printLog("foundedData.....${foundedData.length}  ${dailyData[i].title}  ${dailyData[i].total}");
          if(foundedData.isNotEmpty){
            Debug.printLog("foundedData title wise... .....${foundedData[0].type}  ${foundedData[0].value}  ${dailyData[i].total}");
          }

          if(foundedData.isNotEmpty && double.parse(foundedData[0].value.toString()) != (dailyData[i].total?.toInt() ?? 0)){
            var diff = dailyData[i].total!.toInt() - double.parse(foundedData[0].value) ;
            Debug.printLog("diff found.....$diff  ${dailyData[i].dateTime}  ${foundedData[0].dateTime} ${dailyData[i].title }");

            if (dailyData[i].title == Constant.titleSteps && (diff > 0 || 0 < -diff) ) {
            // if (dailyData[i].title == Constant.titleSteps && (diff > 0) ) {

              Utils.writeStepData(foundedData[0].dateTime, Health(), diff,i);
            }
            else if (dailyData[i].title == Constant.titleCalories && (diff > 0 || 0 < -diff)) {
            // else if (dailyData[i].title == Constant.titleCalories && (diff > 0)) {
              if (Platform.isIOS) {
                Utils.writeCaloriesData(
                    foundedData[0].dateTime, Health(), diff,false,null);
              }else if(Platform.isAndroid){
                Utils.writeCaloriesData(
                    foundedData[0].dateTime, Health(), diff,true,foundedData[0].healthWorkoutActivityType!);
              }
            }
            // else if (dailyData[i].title == Constant.titleHeartRatePeak && (diff > 0 || 0 < -diff)) {
            // else if (dailyData[i].title == Constant.titleHeartRatePeak && (diff > 0)) {
            else if (dailyData[i].title == Constant.titleHeartRatePeak) {
              Debug.printLog("Utils.writeHeartRateData...$diff  ${dailyData[i].dateTime}  ${foundedData[0].dateTime} ${dailyData[i].title } $i");
              // Utils.writeHeartRateData(foundedData[0].dateTime, health, diff);
              Utils.writeHeartRateData(foundedData[0].dateTime, Health(), dailyData[i].total!.toDouble());
            }
            // else if (dailyData[i].title == Constant.titleHeartRateRest && (diff > 0 || 0 < -diff)) {
            else if (dailyData[i].title == Constant.titleHeartRateRest && (diff > 0 )) {
              Debug.printLog("Utils.writeHeartRateRestData...$diff  ${dailyData[i].dateTime}  ${foundedData[0].dateTime} ${dailyData[i].title } $i");
              Utils.writeHeartRateRestData(foundedData[0].dateTime, Health(), diff);
            }
            *//*else if(dailyData[i].title == null && Platform.isIOS && (diff > 0 )){
              Utils.writeExerciseData(foundedData[0].dateTime, health, diff);
            }*//*
          }
          else if(foundedData.isEmpty){
            if(dailyData[i].total != 0 && dailyData[i].total != null){
              if(dailyData[i].title == Constant.titleSteps){
                Utils.writeStepData(dailyData[i].dateTime!, Health(), dailyData[i].total,i);
              }
              else if(dailyData[i].title == Constant.titleCalories){
                if (Platform.isIOS) {
                  Utils.writeCaloriesData(
                      dailyData[i].dateTime!, Health(), dailyData[i].total,false,null);
                }else if(Platform.isAndroid){
                  Utils.writeCaloriesData(
                      dailyData[i].dateTime!, Health(), dailyData[i].total,true,HealthWorkoutActivityType.WALKING);
                }
              }
              else if(dailyData[i].title == Constant.titleHeartRatePeak){
                Utils.writeHeartRateData(dailyData[i].dateTime!, Health(), dailyData[i].total);
              }
              else if(dailyData[i].title == Constant.titleHeartRateRest){
                Utils.writeHeartRateRestData(dailyData[i].dateTime!, Health(), dailyData[i].total);
              }
             *//* else if(dailyData[i].title == null && Platform.isIOS){
                Utils.writeExerciseData(dailyData[i].dateTime!, Health(), dailyData[i].total);
              }*//*
              Debug.printLog("extra data .. ${dailyData[i].total}  ${dailyData[i].dateTime} ${dailyData[i].title }");
            }
          }
        }
      }
      else{
        Debug.printLog("dailyData.....${dailyData.length}");
        if(dailyData.isNotEmpty){
          for (int i = 0; i < dailyData.length; i++) {
            if(dailyData[i].title == Constant.titleSteps){
              Utils.writeStepData(dailyData[i].dateTime!, Health(), dailyData[i].total,i);
            }else if(dailyData[i].title == Constant.titleCalories){
              if (Platform.isIOS) {
                Utils.writeCaloriesData(
                    dailyData[i].dateTime!, Health(), dailyData[i].total,false,null);
              }else if(Platform.isAndroid){
                Utils.writeCaloriesData(
                    dailyData[i].dateTime!, Health(), dailyData[i].total,true,HealthWorkoutActivityType.WALKING);
              }
            }else if(dailyData[i].title == Constant.titleHeartRatePeak){
              Utils.writeHeartRateData(dailyData[i].dateTime!, Health(), dailyData[i].total);
            }else if
            (dailyData[i].title == Constant.titleHeartRateRest){
              Utils.writeHeartRateRestData(dailyData[i].dateTime!, Health(), dailyData[i].total);
            }*//*else if(dailyData[i].title == null && Platform.isIOS){
              Utils.writeExerciseData(dailyData[i].dateTime!, Health(), dailyData[i].total);
            }*//*
          }
        }
      }
    }
    callback.call("");
    Get.back();
    Utils.showSnackBar(Get.context!,"Export data successfully",false);
  }*/

  static showDialogForProgress(BuildContext context, bool isImport) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          backgroundColor: CColor.white,
          content: Container(
            padding: EdgeInsets.only(left: Sizes.width_3),
            height: Get.height * 0.1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const CircularProgressIndicator(),
                Container(
                  margin: EdgeInsets.only(bottom: Sizes.height_0_5),
                  child: Text(
                    Constant.txtPleaseWait,
                    style: AppFontStyle.styleW700(CColor.black, FontSize.size_12),
                  ),
                ),
                (isImport)
                    ? Text("Import data is in progress...",
                    style:
                    AppFontStyle.styleW400(CColor.black, FontSize.size_10))
                    : Text("Export data is in progress...",
                    style: AppFontStyle.styleW400(
                        CColor.black, FontSize.size_8)),
              ],
            ),
          ),
        );
      },
    );
  }

  static realTimeExportDataFromHealth() async {

    try {
      var permissions = ((Platform.isAndroid)
              ? Utils.getAllHealthTypeAndroid
              : Utils.getAllHealthTypeIos)
          .map((e) => HealthDataAccess.READ_WRITE)
          .toList();

      await Health().hasPermissions(
          (Platform.isAndroid)
              ? Utils.getAllHealthTypeAndroid
              : Utils.getAllHealthTypeIos,
          permissions: permissions);

      var activityDataList =
          Hive.box<ActivityTable>(Constant.tableActivity).values.toList();
      if (activityDataList.isNotEmpty) {
        var nowRead = DateTime.now();
        var endDateRead =
            DateTime(nowRead.year, nowRead.month, nowRead.day + 1);
        var startDateRead =
            DateTime(nowRead.year - 1, nowRead.month, nowRead.day);

        List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
           startTime: startDateRead,
            endTime: endDateRead,
           types: (Platform.isAndroid)
                ? Utils.getAllHealthTypeAndroid
                : Utils.getAllHealthTypeIos);
        var dailyData = activityDataList
            .where((element) => element.type == Constant.typeDay && element.total != null)
            .toList()
            .where((element) => element.needExport && element.total != null)
            .toList();
        Debug.printLog("dailyData...${dailyData.length}  ${healthData.length}");

        if (healthData.isNotEmpty) {
          for (int i = 0; i < dailyData.length; i++) {
            Debug.printLog("dailyData.length....${dailyData[i].value1} ${dailyData[i].value2} ${dailyData[i].total}");
            var dailyDataDateTime = dailyData[i].dateTime;

            List<HealthData> stepsListData = [];

            if (dailyData[i].title == Constant.titleSteps) {
              stepsListData = getStepDataFromHealth(
                  healthData, Constant.titleSteps, HealthDataType.STEPS);
            } else if (dailyData[i].title == Constant.titleCalories) {
              stepsListData = getStepDataFromHealth(healthData,
                  Constant.titleCalories, HealthDataType.ACTIVE_ENERGY_BURNED);
            } else if (dailyData[i].title == Constant.titleHeartRatePeak) {
              stepsListData = getStepDataFromHealth(healthData,
                  Constant.titleHeartRatePeak, HealthDataType.HEART_RATE);
            } else if (dailyData[i].title == Constant.titleHeartRateRest) {
              stepsListData = getStepDataFromHealth(
                  healthData,
                  Constant.titleHeartRateRest,
                  HealthDataType.RESTING_HEART_RATE);
            }

            var foundedData = stepsListData
                .where((elementHealthData) =>
                    Utils.getDateFromFullDate(elementHealthData.dateTime) ==
                    dailyDataDateTime)
                .toList();

            if (foundedData.isNotEmpty &&
                double.parse(foundedData[0].value.toString()) !=
                    (dailyData[i].total?.toInt() ?? 0)) {
              var diff = dailyData[i].total!.toInt() -
                  double.parse(foundedData[0].value);

              // if (dailyData[i].title == Constant.titleSteps && (diff > 0) ) {
              if (dailyData[i].title == Constant.titleSteps &&
                  (diff > 0 || 0 < -diff)) {
                Utils.writeStepData(foundedData[0].dateTime, Health(), diff, i);
              }
              // else if (dailyData[i].title == Constant.titleCalories && (diff > 0)) {
              else if (dailyData[i].title == Constant.titleCalories &&
                  (diff > 0 || 0 < -diff)) {
                if (Platform.isIOS) {
                  Utils.writeCaloriesData(
                      foundedData[0].dateTime, Health(), diff, false, null);
                } else if (Platform.isAndroid) {
                  Utils.writeCaloriesData(foundedData[0].dateTime, Health(), diff,
                      true, foundedData[0].healthWorkoutActivityType!);
                }
              } else if (dailyData[i].title == Constant.titleHeartRatePeak) {
                Utils.writeHeartRateData(foundedData[0].dateTime, Health(),
                    dailyData[i].total!.toDouble());
              } else if (dailyData[i].title == Constant.titleHeartRateRest) {
                Utils.writeHeartRateRestData(foundedData[0].dateTime, Health(),
                    dailyData[i].total!.toDouble());
              }
            } else if (foundedData.isEmpty) {
              if (dailyData[i].total != 0 && dailyData[i].total != null) {
                if (dailyData[i].title == Constant.titleSteps) {
                  Utils.writeStepData(
                      dailyData[i].dateTime!, Health(), dailyData[i].total, i);
                } else if (dailyData[i].title == Constant.titleCalories) {
                  if (Platform.isIOS) {
                    Utils.writeCaloriesData(dailyData[i].dateTime!, Health(),
                        dailyData[i].total, false, null);
                  } else if (Platform.isAndroid) {
                    Utils.writeCaloriesData(
                        dailyData[i].dateTime!,
                        Health(),
                        dailyData[i].total,
                        true,
                        HealthWorkoutActivityType.WALKING);
                  }
                } else if (dailyData[i].title == Constant.titleHeartRatePeak) {
                  Utils.writeHeartRateData(
                      dailyData[i].dateTime!, Health(), dailyData[i].total);
                } else if (dailyData[i].title == Constant.titleHeartRateRest) {
                  Utils.writeHeartRateRestData(
                      dailyData[i].dateTime!, Health(), dailyData[i].total);
                }
              }
            }

            dailyData[i].needExport = false;
            await DataBaseHelper.shared.updateActivityData(dailyData[i]);
          }
        } else {
          if (dailyData.isNotEmpty) {
            for (int i = 0; i < dailyData.length; i++) {
              if (dailyData[i].title == Constant.titleSteps) {
                Utils.writeStepData(
                    dailyData[i].dateTime!, Health(), dailyData[i].total, i);
              } else if (dailyData[i].title == Constant.titleCalories) {
                if (Platform.isIOS) {
                  Utils.writeCaloriesData(dailyData[i].dateTime!, Health(),
                      dailyData[i].total, false, null);
                } else if (Platform.isAndroid) {
                  Utils.writeCaloriesData(
                      dailyData[i].dateTime!,
                      Health(),
                      dailyData[i].total,
                      true,
                      HealthWorkoutActivityType.WALKING);
                }
              } else if (dailyData[i].title == Constant.titleHeartRatePeak) {
                Utils.writeHeartRateData(
                    dailyData[i].dateTime!, Health(), dailyData[i].total);
              } else if (dailyData[i].title == Constant.titleHeartRateRest) {
                Utils.writeHeartRateRestData(
                    dailyData[i].dateTime!, Health(), dailyData[i].total);
              }

              dailyData[i].needExport = false;
              await DataBaseHelper.shared.updateActivityData(dailyData[i]);
            }
          }
        }
      }
      Debug.printLog("Import export Not Issue...");
    } catch (e) {
      Debug.printLog("Import export issue.....$e");
    }
  }

  static insertActivityIntoAppleGoogleSync(String activityName, DateTime activityStartDate, DateTime activityEndDate
      ,HealthWorkoutActivityType workoutType,String value) async {
    Debug.printLog("insertActivityIntoAppleGoogleSync done.....${double.parse(value)}  $workoutType  $activityStartDate  $activityEndDate");
    /*if(!Platform.isIOS){
      return;
    }*/
    try {
      var permissions = ((Platform.isAndroid)
          ? Utils.getAllHealthTypeAndroid
          : Utils.getAllHealthTypeIos)
          .map((e) => HealthDataAccess.READ_WRITE)
          .toList();

      await Health().hasPermissions(
          (Platform.isAndroid)
              ? Utils.getAllHealthTypeAndroid
              : Utils.getAllHealthTypeIos,
          permissions: permissions);

      var activityDataList =
      Hive.box<ActivityTable>(Constant.tableActivity).values.toList();

      if (activityDataList.isNotEmpty) {
        Utils.writeCaloriesDataActivityLevel(Health(), double.parse(value), workoutType,activityStartDate,activityEndDate);
        Debug.printLog("Import export activity level done.....${double.parse(value)}  $workoutType  $activityStartDate  $activityEndDate");
      }
    } catch (e) {
      Debug.printLog("Import export activity level issue.....$e");
    }
  }
}