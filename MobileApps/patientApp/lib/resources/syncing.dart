import 'dart:convert';

import 'package:banny_table/db_helper/box/care_plan_form_data.dart';
import 'package:banny_table/db_helper/box/condition_form_data.dart';
import 'package:banny_table/db_helper/box/notes_data.dart';
import 'package:banny_table/db_helper/box/referral_data.dart';
import 'package:banny_table/db_helper/box/to_do_form_data.dart';
import 'package:banny_table/ui/referralForm/datamodel/referralDataModel.dart';
import 'package:banny_table/ui/toDoList/dataModel/to_do_sync_data_model.dart';
import 'package:fhir/r4.dart';
import 'package:fhir/r4/resource_types/base/workflow/workflow.dart';
import 'package:fhir/r4/resource_types/clinical/care_provision/care_provision.dart';
import 'package:fhir/r4/resource_types/clinical/summary/summary.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getX;
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../db_helper/box/activity_data.dart';
import '../db_helper/box/goal_data.dart';
import '../db_helper/box/monthly_log_data.dart';
import '../db_helper/box/routing_referral_data.dart';
import '../db_helper/database_helper.dart';
import '../fhir_auth/r4.dart';
import '../providers/api.dart';
import '../ui/carePlanForm/datamodel/carePlanSyncDataModel.dart';
import '../ui/conditionForm/datamodel/conditionSyncDataModel.dart';
import '../ui/goalForm/datamodel/goalDataModel.dart';
import '../ui/history/datamodel/activityLevelDataModel.dart';
import '../ui/home/monthly/datamodel/syncMonthlyActivityData.dart';
import '../ui/welcomeScreen/healthProvider/selectPrimaryServer/datamodel/serverModelJson.dart';
import '../utils/color.dart';
import '../utils/constant.dart';
import '../utils/debug.dart';
import '../utils/font_style.dart';
import '../utils/preference.dart';
import '../utils/sizer_utils.dart';
import '../utils/utils.dart';
import 'PaaProfiles.dart';

class Syncing{

  static Future<void>  getAndSetSyncActivityData(List<SyncMonthlyActivityData> allSyncingData,{String date = "",bool isFromEx = false}) async {

    /// Tracking chart data (Activity)
    var dataListHive =
    Hive.box<ActivityTable>(Constant.tableActivity).values.toList();
    if (dataListHive.isNotEmpty) {
      if(!isFromEx) {
        weekDayUnSyncData(
            dataListHive, allSyncingData, Constant.titleCalories, true,
            date: date);
        weekDayUnSyncData(
            dataListHive, allSyncingData, Constant.titleSteps, true,
            date: date);
        weekDayUnSyncData(
            dataListHive, allSyncingData, Constant.titleHeartRateRest, true,
            date: date);
        weekDayUnSyncData(
            dataListHive, allSyncingData, Constant.titleHeartRatePeak, true,
            date: date);
        weekDayUnSyncData(
            dataListHive, allSyncingData, Constant.totalMinPerDay, true,
            date: date);
        weekDayUnSyncData(
            dataListHive, allSyncingData, Constant.modMinPerDay, true,
            date: date);
        weekDayUnSyncData(
            dataListHive, allSyncingData, Constant.vigMinPerDay, true,
            date: date);
        weekDayUnSyncData(
            dataListHive, allSyncingData, Constant.titleDaysStr, true,
            date: date);
      }else {
        weekDayUnSyncData(
            dataListHive, allSyncingData, Constant.titleExperience, true,
            date: date);
      }

    }
  }


  static Future<void> weekDayUnSyncData(
      List<ActivityTable> dataListHive,
      List<SyncMonthlyActivityData> syncActivityDataList,
      String titleType,
      bool isDay,{String date = ""}) async {

    List<ActivityTable> unSyncedDataDayList = [];

    if(date == ""){
      if(titleType == Constant.totalMinPerDay || titleType == Constant.modMinPerDay || titleType == Constant.titleDaysStr){
        unSyncedDataDayList = dataListHive.where((element) =>
        !element.isSync &&
            element.title == null && element.smileyType == null &&
            element.type == Constant.typeDay).toList();
      }else if(titleType == Constant.titleDaysStr){
        unSyncedDataDayList = dataListHive.where((element) =>
        !element.isSync &&
            element.title == Constant.titleDaysStr &&
            element.type == Constant.typeDay).toList();
      }else{
        unSyncedDataDayList = dataListHive.where((element) =>
        !element.isSync &&
            element.title == titleType &&
            element.type == Constant.typeDay).toList();
      }

    }
    else{
      if(titleType == Constant.titleExperience){
        unSyncedDataDayList = dataListHive.where((element) =>
        !element.isSync &&
            element.title == null && element.total == null && element.smileyType != null  &&
            element.type == Constant.typeDay && element.date == date).toList();
      }else{
        if (titleType == Constant.totalMinPerDay) {
          unSyncedDataDayList = dataListHive
              .where((element) =>
                  !element.isSync &&
                  element.title == null &&
                  element.smileyType == null &&
                  element.type == Constant.typeDay &&
                  element.date == date &&
                      element.total != null && (element.total ?? 0.0) >= 0.0)
              .toList();
        } else if (titleType == Constant.modMinPerDay) {
          unSyncedDataDayList = dataListHive
              .where((element) =>
                  !element.isSync &&
                  element.title == null &&
                  element.smileyType == null &&
                      element.value1 != null && (element.value1 ?? 0.0) >= 0.0 &&
                  element.type == Constant.typeDay &&
                  element.date == date)
              .toList();
        }  else if (titleType == Constant.vigMinPerDay) {
          unSyncedDataDayList = dataListHive
              .where((element) =>
                  !element.isSync &&
                  element.title == null &&
                  element.smileyType == null &&
                      element.value2 != null && (element.value2 ?? 0.0) >= 0.0 &&
                  element.type == Constant.typeDay &&
                  element.date == date)
              .toList();
        } else if (titleType == Constant.titleDaysStr) {
          unSyncedDataDayList = dataListHive
              .where((element) =>
                  !element.isSync &&
                  element.title == Constant.titleDaysStr &&
                  element.type == Constant.typeDay &&
                  element.date == date)
              .toList();
        } else {
          unSyncedDataDayList = dataListHive
              .where((element) =>
                  !element.isSync &&
                  element.title == titleType &&
                  element.type == Constant.typeDay &&
                  element.date == date &&
                  element.total != null && (element.total ?? 0.0) >= 0.0 )
              .toList();
        }
      }
    }


    if (unSyncedDataDayList.isNotEmpty) {
      for (int i = 0; i < unSyncedDataDayList.length; i++) {
        var data = unSyncedDataDayList[i];
        if(titleType == Constant.titleExperience){
          if ((data.
          smileyType?.toInt()) != null) {
            syncActivityDataList.add(SyncMonthlyActivityData(
                "",
                data.smileyType?.toDouble() ?? 0.0,
                data.dateTime,
                null,
                data.key,
                Constant.titleExperience,
                true,
                data.objectId));
          }
        }
        else {
          if (titleType == Constant.totalMinPerDay) {
            if ((data.total ?? 0) > 0) {
              syncActivityDataList.add(SyncMonthlyActivityData(
                  "",
                  data.total ?? 0,
                  data.dateTime,
                  null,
                  data.key,
                  Constant.totalMinPerDay,
                  true,
                  data.objectId));
            }
          }
          else if (titleType == Constant.modMinPerDay) {
            if ((data.value1 ?? 0) > 0) {
              syncActivityDataList.add(SyncMonthlyActivityData(
                  "",
                  data.value1 ?? 0,
                  data.dateTime,
                  null,
                  data.key,
                  Constant.modMinPerDay,
                  true,
                  data.objectId));
            }
          }
          else if (titleType == Constant.vigMinPerDay) {
            if ((data.value2 ?? 0) > 0) {
              syncActivityDataList.add(SyncMonthlyActivityData(
                  "",
                  data.value2 ?? 0,
                  data.dateTime,
                  null,
                  data.key,
                  Constant.vigMinPerDay,
                  true,
                  data.objectId));
            }
          }
          else if(titleType == Constant.titleDaysStr){
            var valueStr = 0.0;
            if(data.isCheckedDay ?? false){
              valueStr = 1.0;
            }
            syncActivityDataList.add(SyncMonthlyActivityData(
                "",
                valueStr,
                data.dateTime,
                null,
                data.key,
                Constant.titleDaysStr,
                true,
                data.objectId));
          }
          else{
            /*if (titleType == Constant.totalMinPerDay) {
              syncActivityDataList.add(SyncMonthlyActivityData(
                  "",
                  data.total ?? 0,
                  data.dateTime,
                  null,
                  data.key,
                  Constant.totalMinPerDay,
                  true,
                  data.objectId,notesDayLevel: data.notes ?? ""));
            }
            else if (titleType == Constant.modMinPerDay) {
              syncActivityDataList.add(SyncMonthlyActivityData(
                  "",
                  data.value1 ?? 0,
                  data.dateTime,
                  null,
                  data.key,
                  Constant.modMinPerDay,
                  true,
                  data.objectId));
            }
            else if (titleType == Constant.vigMinPerDay) {
              syncActivityDataList.add(SyncMonthlyActivityData(
                  "",
                  data.value2 ?? 0,
                  data.dateTime,
                  null,
                  data.key,
                  Constant.vigMinPerDay,
                  true,
                  data.objectId));
            }
            else if (titleType == Constant.titleDaysStr && data.title == Constant.titleDaysStr) {
              var valueOfBox = 0.0;
              if(data.isCheckedDay ?? false){
                valueOfBox = 1.0;
              }
              syncActivityDataList.add(SyncMonthlyActivityData(
                  "",
                  valueOfBox,
                  data.dateTime,
                  null,
                  data.key,
                  Constant.titleDaysStr,
                  true,
                  data.objectId));
            }
            else {
              syncActivityDataList.add(SyncMonthlyActivityData(
                  "",
                  data.total ?? 0,
                  data.dateTime,
                  null,
                  data.key,
                  titleType,
                  true,
                  data.objectId));
            }*/

            syncActivityDataList.add(SyncMonthlyActivityData(
                "",
                data.total ?? 0,
                data.dateTime,
                null,
                data.key,
                titleType,
                true,
                data.objectId));
          }

        }
      }
    }
  }

  ///Monthly log data
  ///isFromRefresh = When we tap on refresh button in monthly screen
  static Future<void> getAndSetSyncMonthlyData(List<SyncMonthlyActivityData> allSyncingData,{bool isFromRefresh = false,
    DateTime? startDate,DateTime? endDate}) async {
    // List<SyncMonthlyActivityData> allSyncingData = [];

    ///Monthly log data
    var monthlyDataDbList =
    Hive.box<MonthlyLogTableData>(Constant.tableMonthlyLog).values.toList();
    if (monthlyDataDbList.isNotEmpty) {
      for (int i = 0; i < Utils.allYearlyMonths.length; i++) {
        syncMonthlyDataDayPerWeek(monthlyDataDbList, allSyncingData, i,isFromRefresh: isFromRefresh,startDate: startDate,endDate: endDate);
        syncMonthlyDataAverageMin(monthlyDataDbList, allSyncingData, i,isFromRefresh: isFromRefresh,startDate: startDate,endDate: endDate);
        syncMonthlyDataAverageMinPerWeek(monthlyDataDbList, allSyncingData, i,isFromRefresh: isFromRefresh,startDate: startDate,endDate: endDate);
        syncMonthlyDataStrength(monthlyDataDbList, allSyncingData, i,isFromRefresh: isFromRefresh,startDate: startDate,endDate: endDate);
      }
    }
    Debug.printLog("allSyncingData...$allSyncingData");
  }

  static syncMonthlyDataDayPerWeek(List<MonthlyLogTableData> monthlyDataDbList,
      List<SyncMonthlyActivityData> allSyncingData, int i,{bool isFromRefresh = false,DateTime? startDate,DateTime? endDate}) {
    ///Day per week
    var month = Utils.getMonthName(endDate!.month, endDate.year);
    var year = endDate.year;
    List<MonthlyLogTableData> nonSyncDayPerWeekData = [];
    if(isFromRefresh){
      Debug.printLog("syncMonthlyDataDayPerWeek....${Utils.allYearlyMonths[i].name}  $month  $year");
      nonSyncDayPerWeekData = monthlyDataDbList.where((element) =>
      element.monthName == Utils.allYearlyMonths[i].name && element.patientId == Utils.getPatientId() && (element.dayPerWeekValue ?? 0.0) > 0.0
      && element.monthName == month && element.year == year).toList();
    }else{
      nonSyncDayPerWeekData = monthlyDataDbList.where((element) =>
      !element.isSyncDayPerWeek &&
      Utils.allYearlyMonths[i].name == element.monthName && element.patientId == Utils.getPatientId() && (element.dayPerWeekValue ?? 0.0) > 0.0
          && element.monthName == month && element.year == year).toList();
    }
    Debug.printLog("syncMonthlyDataDayPerWeek length....${nonSyncDayPerWeekData.length}");



    if (nonSyncDayPerWeekData.isNotEmpty) {
      try {
        allSyncingData.add(SyncMonthlyActivityData(
            Utils.allYearlyMonths[i].name,
            nonSyncDayPerWeekData[0].dayPerWeekValue ?? 0.0,
            nonSyncDayPerWeekData[0].startDate,
            nonSyncDayPerWeekData[0].endDate,
            nonSyncDayPerWeekData[0].key,
            Constant.headerDayPerWeek,
            true, nonSyncDayPerWeekData[0].dayPerWeekId));
      } catch (e) {
        Debug.printLog("syncMonthlyDataDayPerWeek.. catch..$e");
      }
    }
  }

  static syncMonthlyDataAverageMin(List<MonthlyLogTableData> monthlyDataDbList,
      List<SyncMonthlyActivityData> allSyncingData, int i,{bool isFromRefresh = false,DateTime? startDate,DateTime? endDate}) {
    ///AVG min
    var month = Utils.getMonthName(endDate!.month, endDate.year);
    var year = endDate.year;
    List<MonthlyLogTableData> nonSyncDayPerWeekData = [];
    if(isFromRefresh){
      Debug.printLog("syncMonthlyDataAverageMin....${Utils.allYearlyMonths[i].name}  $month  $year");
      nonSyncDayPerWeekData = monthlyDataDbList.where((element) =>
      Utils.allYearlyMonths[i].name == element.monthName && element.patientId == Utils.getPatientId() && (element.avgMinValue ?? 0.0) > 0.0
          && element.monthName == month && element.year == year).toList();
    }else{
      nonSyncDayPerWeekData = monthlyDataDbList.where((element) =>
      !element.isSyncAvgMin
          && Utils.allYearlyMonths[i].name == element.monthName && element.patientId == Utils.getPatientId() && (element.avgMinValue ?? 0.0) > 0.0
          && element.monthName == month && element.year == year).toList();
    }
    Debug.printLog("syncMonthlyDataAverageMin length....${nonSyncDayPerWeekData.length}");


    if (nonSyncDayPerWeekData.isNotEmpty) {
      try {
        allSyncingData.add(SyncMonthlyActivityData(
            Utils.allYearlyMonths[i].name,
            nonSyncDayPerWeekData[0].avgMinValue ?? 0.0,
            nonSyncDayPerWeekData[0].startDate,
            nonSyncDayPerWeekData[0].endDate,
            nonSyncDayPerWeekData[0].key,
            Constant.headerAverageMin,
            true, nonSyncDayPerWeekData[0].avgMinPerDayId));
      } catch (e) {
        Debug.printLog("syncMonthlyDataAverageMin.. catch..$e");
      }
    }
  }

  static syncMonthlyDataAverageMinPerWeek(List<MonthlyLogTableData> monthlyDataDbList,
      List<SyncMonthlyActivityData> allSyncingData, int i,{bool isFromRefresh = false,DateTime? startDate,DateTime? endDate}) {
    ///AVH min per week
    var month = Utils.getMonthName(endDate!.month, endDate.year);
    var year = endDate.year;
    List<MonthlyLogTableData>  nonSyncDayPerWeekData = [];
    if (isFromRefresh) {
      Debug.printLog("syncMonthlyDataAverageMinPerWeek....${Utils.allYearlyMonths[i].name}  $month  $year");
      nonSyncDayPerWeekData = monthlyDataDbList.where((element) =>
          Utils.allYearlyMonths[i].name == element.monthName && element.patientId == Utils.getPatientId() && (element.avgMInPerWeekValue ?? 0.0) > 0.0
              && element.monthName == month && element.year == year).toList();
    } else {
      nonSyncDayPerWeekData = monthlyDataDbList.where((element) =>
      !element.isSyncAvgMinPerWeek
          && Utils.allYearlyMonths[i].name == element.monthName && element.patientId == Utils.getPatientId() && (element.avgMInPerWeekValue ?? 0.0) > 0.0
          && element.monthName == month && element.year == year).toList();
    }
    Debug.printLog("syncMonthlyDataAverageMinPerWeek length....${nonSyncDayPerWeekData.length}");


    if (nonSyncDayPerWeekData.isNotEmpty) {
      try {
        allSyncingData.add(SyncMonthlyActivityData(
            Utils.allYearlyMonths[i].name,
            nonSyncDayPerWeekData[0].avgMInPerWeekValue ?? 0.0,
            nonSyncDayPerWeekData[0].startDate,
            nonSyncDayPerWeekData[0].endDate,
            nonSyncDayPerWeekData[0].key,
            Constant.headerAverageMinPerWeek,
            true, nonSyncDayPerWeekData[0].avgPerWeekId));
      } catch (e) {
        Debug.printLog("syncMonthlyDataAverageMinPerWeek.. catch..$e");
      }
    }
  }

  static syncMonthlyDataStrength(List<MonthlyLogTableData> monthlyDataDbList,
      List<SyncMonthlyActivityData> allSyncingData, int i,{bool isFromRefresh = false,DateTime? startDate,DateTime? endDate}) {

    var month = Utils.getMonthName(endDate!.month, endDate.year);
    var year = endDate.year;
    List<MonthlyLogTableData>  nonSyncDayPerWeekData = [];
    if(isFromRefresh){
      Debug.printLog("syncMonthlyDataStrength....${Utils.allYearlyMonths[i].name}  $month  $year");
      nonSyncDayPerWeekData = monthlyDataDbList.where((element) =>
      Utils.allYearlyMonths[i].name == element.monthName && element.patientId == Utils.getPatientId()  && (element.strengthValue ?? 0.0) > 0.0
          && element.monthName == month && element.year == year).toList();
    }else{
      nonSyncDayPerWeekData = monthlyDataDbList.where((element) =>
      !element.isSyncStrength
          && Utils.allYearlyMonths[i].name == element.monthName && element.patientId == Utils.getPatientId()  && (element.strengthValue ?? 0.0) > 0.0
          && element.monthName == month && element.year == year).toList();
    }
    Debug.printLog("syncMonthlyDataStrength length....${nonSyncDayPerWeekData.length}");

    if (nonSyncDayPerWeekData.isNotEmpty) {
      try {
        allSyncingData.add(SyncMonthlyActivityData(
            Utils.allYearlyMonths[i].name,
            nonSyncDayPerWeekData[0].strengthValue ?? 0.0,
            nonSyncDayPerWeekData[0].startDate,
            nonSyncDayPerWeekData[0].endDate,
            nonSyncDayPerWeekData[0].key,
            Constant.headerStrength,
            true, nonSyncDayPerWeekData[0].strengthId));
      } catch (e) {
        Debug.printLog("syncDayPerWeekData.. catch..$e");
      }
    }
  }


  ///*Monthly observation
  static Future<void> observationSyncDataDaysPerWeeks( List<SyncMonthlyActivityData> allSyncingData) async {

    PaaProfiles profiles = PaaProfiles();
    var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
    var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
    if(getPrimaryServerData.isNotEmpty){
      allSelectedServersUrl.remove(getPrimaryServerData[0]);
      allSelectedServersUrl.add(getPrimaryServerData[0]);
    }
    /// Here you all data that we want to send in to backend ==>> allSyncingData
    int delayCount = 0;
    // int delayCountFiveSecond = 0;
    for (int i = 0; i < allSyncingData.length; i++) {
      for (int j = 0; j < allSelectedServersUrl.length; j++) {
        var activityData = allSyncingData[i];
        if (activityData.headerType == Constant.headerDayPerWeek) {
          MonthlyLogTableData getActivityKeyWiseData = await DataBaseHelper
              .shared
              .getMonthlyData(activityData.keyId);

          if (getActivityKeyWiseData.serverDetailListDayPerWeek.isNotEmpty) {
            if (activityData.headerType == Constant.headerDayPerWeek) {
              getActivityKeyWiseData.isSyncDayPerWeek = true;

              await DataBaseHelper.shared.updateMonthlyData(
                  getActivityKeyWiseData);

              String observationId = "";

              var objectId = "";
              var getServeIndex = getActivityKeyWiseData.serverDetailListDayPerWeek
                  .indexWhere((element) =>
              element.serverUrl ==
                  allSelectedServersUrl[j].url).toInt();

              if (getServeIndex != -1) {
                objectId =
                getActivityKeyWiseData.serverDetailListDayPerWeek[getServeIndex].objectId ?? "";
                getActivityKeyWiseData
                    .serverDetailListDayPerWeek[getServeIndex].dataSyncServerWise = true;

                await DataBaseHelper.shared.updateMonthlyData(
                    getActivityKeyWiseData);
              }
              if(getActivityKeyWiseData.serverDetailListDayPerWeek.isNotEmpty &&
                  getActivityKeyWiseData.dayPerWeekIdentifierData.isNotEmpty){
                var a = getActivityKeyWiseData.dayPerWeekIdentifierData.indexWhere((element) => element.url == allSelectedServersUrl[j].url).toInt();
                if(a != -1){
                  objectId = getActivityKeyWiseData.dayPerWeekIdentifierData[a].objectId ?? "";
                }
              }
              List<Identifier> identifier = [];
              if(allSelectedServersUrl[j].isPrimary){
                var withOutPrimaryDataList = allSelectedServersUrl.where((element) => !element.isPrimary).toList();
                if(withOutPrimaryDataList.isNotEmpty){
                  for (int a = 0; a < withOutPrimaryDataList.length; a++) {
                    if(getActivityKeyWiseData.serverDetailListDayPerWeek.isNotEmpty) {
                      var getServeIndex = getActivityKeyWiseData.serverDetailListDayPerWeek
                          .indexWhere((element) =>
                      element.serverUrl ==
                          withOutPrimaryDataList[a].url).toInt();
                      if(getServeIndex != -1){
                        identifier.add(Identifier(value: getActivityKeyWiseData.serverDetailListDayPerWeek[getServeIndex]
                            .objectId,
                            system: FhirUri(getActivityKeyWiseData.serverDetailListDayPerWeek[getServeIndex]
                            .serverUrl)));
                      }
                    }

                  }
                }
              }
              Observation observation = profiles.createObservationDaysPerWeeks(
                  allSyncingData[i], objectId, "${allSelectedServersUrl[j]
                  .patientFName}${allSelectedServersUrl[j].patientLName}",
                  allSelectedServersUrl[j].patientId,identifierDataList: identifier);

              observationId =
              await profiles.processResource(
                  observation, Constant.trackingChart,
                  allSelectedServersUrl[j].url,
                  allSelectedServersUrl[j].clientId,
                  allSelectedServersUrl[j].authToken);

              if(observationId != "null" && observationId != "Null" && observationId != null && observationId != "") {
                getActivityKeyWiseData.dayPerWeekId = observationId;

                if (getActivityKeyWiseData.serverDetailListDayPerWeek.where((
                    element) =>
                element.objectId
                    == observationId)
                    .toList()
                    .isEmpty) {
                  getActivityKeyWiseData
                      .serverDetailListDayPerWeek[getServeIndex].objectId =
                      observationId;
                  getActivityKeyWiseData
                      .serverDetailListDayPerWeek[getServeIndex].serverUrl =
                      allSelectedServersUrl[j].url;
                  getActivityKeyWiseData
                      .serverDetailListDayPerWeek[getServeIndex].patientId =
                      allSelectedServersUrl[j].patientId;
                  getActivityKeyWiseData
                      .serverDetailListDayPerWeek[getServeIndex].patientName =
                  "${allSelectedServersUrl[j]
                      .patientFName}${allSelectedServersUrl[j].patientLName}";
                }


                await DataBaseHelper.shared.updateMonthlyData(
                    getActivityKeyWiseData);
              }
            }
          }
        }
       /* delayCountFiveSecond++;
        if(delayCountFiveSecond == 10){
          delayCountFiveSecond = 0;
          await Utils.apiCallApplyDelay5second();
        }*/
      }

      var activityData = allSyncingData[i];
      if (activityData.headerType == Constant.headerDayPerWeek) {
        var withOutPrimaryData = Utils.getServerListPreference().where((
            element) =>
        !element.isPrimary
            && element.isSelected && element.patientId != "").toList();
        if (withOutPrimaryData.isNotEmpty) {
          List<Identifier> identifierDataExtra = [];
          for (int a = 0; a < withOutPrimaryData.length; a++) {
            identifierDataExtra.clear();
            if (withOutPrimaryData[a].isSecure &&
                Utils.isExpiredToken(withOutPrimaryData[a].lastLoggedTime,
                    withOutPrimaryData[a].expireTime)) {
              // await Utils.checkTokenExpireTime(withOutPrimaryData[a]);
            }
            withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
                && element.isSelected && element.patientId != "").toList();

            var activityData = allSyncingData[i];
            MonthlyLogTableData getActivityKeyWiseData = await DataBaseHelper
                .shared
                .getMonthlyData(activityData.keyId);

            var callAPIWithThisURL = withOutPrimaryData[a].url;

            var getAllObjectIdList =
            getActivityKeyWiseData.serverDetailListDayPerWeek.where((
                element) => element.serverUrl != callAPIWithThisURL).toList();

            if (getAllObjectIdList.isNotEmpty) {
              for (int d = 0; d < getAllObjectIdList.length; d++) {
                identifierDataExtra.add(
                    Identifier(value: getAllObjectIdList[d].objectId, system:
                    FhirUri(getAllObjectIdList[d].serverUrl)));
              }
            }

            var objectId = "";
            var getServeIndex = getActivityKeyWiseData
                .serverDetailListDayPerWeek.indexWhere((element) =>
            element.serverUrl ==
                withOutPrimaryData[a].url).toInt();
            if (getServeIndex != -1) {
              objectId = getActivityKeyWiseData
                  .serverDetailListDayPerWeek[getServeIndex].objectId ?? "";
              getActivityKeyWiseData.serverDetailListDayPerWeek[getServeIndex]
                  .dataSyncServerWise = true;
            }
            if (getActivityKeyWiseData.serverDetailListDayPerWeek.isNotEmpty &&
                getActivityKeyWiseData.dayPerWeekIdentifierData.isNotEmpty) {
              var aObject = getActivityKeyWiseData.dayPerWeekIdentifierData
                  .indexWhere((element) =>
              element.url ==
                  withOutPrimaryData[a].url).toInt();
              if (aObject != -1) {
                objectId =
                    getActivityKeyWiseData.dayPerWeekIdentifierData[aObject]
                        .objectId ?? "";
              }
            }

            if (identifierDataExtra.isNotEmpty) {
              Observation observation = profiles
                  .createObservationDaysPerWeeks(
                  allSyncingData[i], objectId, "${withOutPrimaryData[a]
                  .patientFName}${withOutPrimaryData[a].patientLName}",
                  withOutPrimaryData[a].patientId,
                  identifierDataList: identifierDataExtra);


              await profiles.processResource(
                  observation, Constant.trackingChart,
                  withOutPrimaryData[a].url,
                  withOutPrimaryData[a].clientId,
                  withOutPrimaryData[a].authToken);
            }
          }
        }
      }
      delayCount++;
      if(delayCount == Constant.delayTimeLength){
        delayCount = 0;
        await Utils.apiCallApplyDelay10second();
      }
    }
  }

  static Future<void> observationSyncDataMinPerDay( List<SyncMonthlyActivityData> allSyncingData) async {

    // List<SyncMonthlyActivityData> allSyncingData = [];
    PaaProfiles profiles = PaaProfiles();
    // var allSelectedServersUrl = Utils.getServerListPreference();
    var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
    var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
    if(getPrimaryServerData.isNotEmpty){
      allSelectedServersUrl.remove(getPrimaryServerData[0]);
      allSelectedServersUrl.add(getPrimaryServerData[0]);
    }
    int delayCount = 0;
    int delayCountFiveSecond = 0;
    for (int i = 0; i < allSyncingData.length; i++) {
      var activityData = allSyncingData[i];
      if (activityData.headerType == Constant.headerAverageMin) {
        for (int j = 0; j < allSelectedServersUrl.length; j++) {
          /// You can start your API call from here
            var activityData = allSyncingData[i];
            MonthlyLogTableData getActivityKeyWiseData = await DataBaseHelper
                .shared
                .getMonthlyData(activityData.keyId);
            /*for (int a = 0; a <
                getActivityKeyWiseData.syncAvgMinServerWiseList.length; a++) {
              getActivityKeyWiseData.syncAvgMinServerWiseList[a] = true;
            }*/
            if (getActivityKeyWiseData.serverDetailListAvgMin.isNotEmpty) {
              if (activityData.headerType == Constant.headerAverageMin) {
                getActivityKeyWiseData.isSyncAvgMin = true;

                await DataBaseHelper.shared.updateMonthlyData(
                    getActivityKeyWiseData);

                String observationId = "";

                var objectId = "";
                var getServeIndex = getActivityKeyWiseData
                    .serverDetailListAvgMin
                    .indexWhere((element) =>
                element.serverUrl ==
                    allSelectedServersUrl[j].url).toInt();

                if (getServeIndex != -1) {
                  objectId =
                      getActivityKeyWiseData
                          .serverDetailListAvgMin[getServeIndex].objectId ?? "";
                  getActivityKeyWiseData
                      .serverDetailListAvgMin[getServeIndex]
                      .dataSyncServerWise =
                  true;

                  await DataBaseHelper.shared.updateMonthlyData(
                      getActivityKeyWiseData);
                }
                if (getActivityKeyWiseData.serverDetailListAvgMin.isNotEmpty &&
                    getActivityKeyWiseData.avgMinIdentifierData.isNotEmpty) {
                  var a = getActivityKeyWiseData.avgMinIdentifierData
                      .indexWhere((element) =>
                  element.url == allSelectedServersUrl[j].url).toInt();
                  if (a != -1) {
                    objectId = getActivityKeyWiseData.avgMinIdentifierData[a]
                        .objectId ?? "";
                  }
                }
                List<Identifier> identifier = [];
                if (allSelectedServersUrl[j].isPrimary) {
                  var withOutPrimaryDataList = allSelectedServersUrl.where((
                      element) => !element.isPrimary).toList();
                  if (withOutPrimaryDataList.isNotEmpty) {
                    for (int a = 0; a < withOutPrimaryDataList.length; a++) {
                      if (getActivityKeyWiseData.serverDetailListAvgMin
                          .isNotEmpty) {
                        var getServeIndex = getActivityKeyWiseData
                            .serverDetailListAvgMin
                            .indexWhere((element) =>
                        element.serverUrl ==
                            withOutPrimaryDataList[a].url).toInt();
                        if (getServeIndex != -1) {
                          identifier.add(Identifier(
                              value: getActivityKeyWiseData
                                  .serverDetailListAvgMin[getServeIndex]
                                  .objectId,
                              system: FhirUri(getActivityKeyWiseData
                                  .serverDetailListAvgMin[getServeIndex]
                                  .serverUrl)));
                        }
                      }
                    }
                  }
                }
                Observation observation = profiles
                    .createObservationMintuesPerDay(
                    allSyncingData[i], objectId, "${allSelectedServersUrl[j]
                    .patientFName}${allSelectedServersUrl[j].patientLName}",
                    allSelectedServersUrl[j].patientId,
                    identifierDataList: identifier);

                observationId =
                await profiles.processResource(
                    observation, Constant.trackingChart,
                    allSelectedServersUrl[j].url,
                    allSelectedServersUrl[j].clientId,
                    allSelectedServersUrl[j].authToken);

                if (observationId != "null" && observationId != "Null" &&
                    observationId != null && observationId != "") {
                  getActivityKeyWiseData.avgMinPerDayId = observationId;

                  if (getActivityKeyWiseData.serverDetailListAvgMin.where((
                      element) =>
                  element.objectId
                      == observationId)
                      .toList()
                      .isEmpty) {
                    getActivityKeyWiseData.serverDetailListAvgMin[getServeIndex]
                        .objectId = observationId;
                    getActivityKeyWiseData.serverDetailListAvgMin[getServeIndex]
                        .serverUrl = allSelectedServersUrl[j].url;
                    getActivityKeyWiseData.serverDetailListAvgMin[getServeIndex]
                        .patientId = allSelectedServersUrl[j].patientId;
                    getActivityKeyWiseData.serverDetailListAvgMin[getServeIndex]
                        .patientName = "${allSelectedServersUrl[j]
                        .patientFName}${allSelectedServersUrl[j].patientLName}";
                  }

                  await DataBaseHelper.shared.updateMonthlyData(
                      getActivityKeyWiseData);
                }
              }
            }
          // delayCountFiveSecond++;
            Debug.printLog("delayCountFiveSecond......$delayCountFiveSecond......$delayCount");
          /*if(delayCountFiveSecond == 10){
            delayCountFiveSecond = 0;
            await Utils.apiCallApplyDelay5second();
          }*/
        }

        var withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
            && element.isSelected && element.patientId != "").toList();
        if(withOutPrimaryData.isNotEmpty) {
          List<Identifier> identifierDataExtra = [];
          for (int a = 0; a < withOutPrimaryData.length; a++) {
            identifierDataExtra.clear();
            if (withOutPrimaryData[a].isSecure &&
                Utils.isExpiredToken(withOutPrimaryData[a].lastLoggedTime,
                    withOutPrimaryData[a].expireTime)) {
              // await Utils.checkTokenExpireTime(withOutPrimaryData[a]);
            }
            withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
                && element.isSelected && element.patientId != "").toList();

            var activityData = allSyncingData[i];
            MonthlyLogTableData getActivityKeyWiseData = await DataBaseHelper
                .shared
                .getMonthlyData(activityData.keyId);

            var callAPIWithThisURL = withOutPrimaryData[a].url;

            var getAllObjectIdList =
            getActivityKeyWiseData.serverDetailListAvgMin.where((element) => element.serverUrl != callAPIWithThisURL).toList();

            if(getAllObjectIdList.isNotEmpty){
              for (int d = 0; d < getAllObjectIdList.length; d++) {
                identifierDataExtra.add(Identifier(value:getAllObjectIdList[d].objectId ,system:
                FhirUri(getAllObjectIdList[d].serverUrl)));
              }
            }

            var objectId = "";
            var getServeIndex = getActivityKeyWiseData.serverDetailListAvgMin.indexWhere((
                element) =>
            element.serverUrl ==
                withOutPrimaryData[a].url).toInt();
            if (getServeIndex != -1) {
              objectId = getActivityKeyWiseData.serverDetailListAvgMin[getServeIndex].objectId ?? "";
              getActivityKeyWiseData.serverDetailListAvgMin[getServeIndex].dataSyncServerWise = true;
            }
            if(getActivityKeyWiseData.serverDetailListAvgMin.isNotEmpty && getActivityKeyWiseData.avgMinIdentifierData.isNotEmpty){
              var aObject = getActivityKeyWiseData.avgMinIdentifierData.indexWhere((element) => element.url ==
                  withOutPrimaryData[a].url).toInt();
              if(aObject != -1){
                objectId = getActivityKeyWiseData.avgMinIdentifierData[aObject].objectId ?? "";
              }
            }

            if(identifierDataExtra.isNotEmpty){
              Observation observation = profiles
                  .createObservationMintuesPerDay(
                  allSyncingData[i], objectId, "${withOutPrimaryData[a]
                  .patientFName}${withOutPrimaryData[a].patientLName}",
                  withOutPrimaryData[a].patientId,identifierDataList: identifierDataExtra);


              await profiles.processResource(observation, Constant.trackingChart,
                  withOutPrimaryData[a].url,
                  withOutPrimaryData[a].clientId,
                  withOutPrimaryData[a].authToken);
            }
          }
        }
        delayCount++;
        Debug.printLog("delayCountFiveSecond......$delayCountFiveSecond......$delayCount");
        if(delayCount == Constant.delayTimeLength){
          delayCount = 0;
          await Utils.apiCallApplyDelay10second();
        }
      }
    }
  }

  static Future<void> observationSyncDataMinPerWeek( List<SyncMonthlyActivityData> allSyncingData) async {
    // List<SyncMonthlyActivityData> allSyncingData = [];
    PaaProfiles profiles = PaaProfiles();
    // var allSelectedServersUrl = Utils.getServerListPreference();
    var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
    var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
    if(getPrimaryServerData.isNotEmpty){
      allSelectedServersUrl.remove(getPrimaryServerData[0]);
      allSelectedServersUrl.add(getPrimaryServerData[0]);
    }
    int delayCount = 0;
    // int delayCountFiveSecond = 0;
    for (int i = 0; i < allSyncingData.length; i++) {
      var activityData = allSyncingData[i];
      if (activityData.headerType == Constant.headerAverageMinPerWeek) {
        for (int j = 0; j < allSelectedServersUrl.length; j++) {
          var activityData = allSyncingData[i];
          MonthlyLogTableData getActivityKeyWiseData = await DataBaseHelper
              .shared
              .getMonthlyData(activityData.keyId);
          if (getActivityKeyWiseData.serverDetailListAvgMinWeek.isNotEmpty) {
            if (activityData.headerType == Constant.headerAverageMinPerWeek) {
              getActivityKeyWiseData.isSyncAvgMinPerWeek = true;

              await DataBaseHelper.shared.updateMonthlyData(
                  getActivityKeyWiseData);

              String observationId = "";

              var objectId = "";
              var getServeIndex = getActivityKeyWiseData
                  .serverDetailListAvgMinWeek.indexWhere((element) =>
              element.serverUrl ==
                  allSelectedServersUrl[j].url).toInt();

              if (getServeIndex != -1) {
                objectId =
                getActivityKeyWiseData.serverDetailListAvgMinWeek[getServeIndex].objectId ?? "";
                getActivityKeyWiseData
                    .serverDetailListAvgMinWeek[getServeIndex].dataSyncServerWise = true;

                await DataBaseHelper.shared.updateMonthlyData(
                    getActivityKeyWiseData);
              }

              if(getActivityKeyWiseData.serverDetailListAvgMinWeek.isNotEmpty && getActivityKeyWiseData.avgMinPerWeekIdentifierData.isNotEmpty){
                var a = getActivityKeyWiseData.avgMinPerWeekIdentifierData.indexWhere((element) => element.url == allSelectedServersUrl[j].url).toInt();
                if(a != -1){
                  objectId = getActivityKeyWiseData.avgMinPerWeekIdentifierData[a].objectId ?? "";
                }
              }
              List<Identifier> identifier = [];
              if(allSelectedServersUrl[j].isPrimary){
                var withOutPrimaryDataList = allSelectedServersUrl.where((element) => !element.isPrimary).toList();
                if(withOutPrimaryDataList.isNotEmpty){
                  for (int a = 0; a < withOutPrimaryDataList.length; a++) {
                    if(getActivityKeyWiseData.serverDetailListAvgMinWeek.isNotEmpty) {
                      var getServeIndex = getActivityKeyWiseData.serverDetailListAvgMinWeek
                          .indexWhere((element) =>
                      element.serverUrl ==
                          withOutPrimaryDataList[a].url).toInt();
                      if(getServeIndex != -1){
                        identifier.add(Identifier(value: getActivityKeyWiseData.serverDetailListAvgMinWeek[getServeIndex]
                            .objectId,
                            system: FhirUri(getActivityKeyWiseData.serverDetailListAvgMinWeek[getServeIndex]
                            .serverUrl)));
                      }
                    }

                  }
                }
              }

              Observation observation = profiles
                  .createObservationMintuesPerWeek(
                  allSyncingData[i], objectId, "${allSelectedServersUrl[j]
                  .patientFName}${allSelectedServersUrl[j].patientLName}",
                  allSelectedServersUrl[j].patientId,identifierDataList: identifier);

              observationId =
              await profiles.processResource(
                  observation, Constant.trackingChart,
                  allSelectedServersUrl[j].url,
                  allSelectedServersUrl[j].clientId,
                  allSelectedServersUrl[j].authToken);

              if(observationId != "null" && observationId != "Null" && observationId != null && observationId != "") {
                getActivityKeyWiseData.avgPerWeekId = observationId;

                if (getActivityKeyWiseData.serverDetailListAvgMinWeek.where((
                    element) =>
                element.objectId
                    == observationId)
                    .toList()
                    .isEmpty) {
                  getActivityKeyWiseData
                      .serverDetailListAvgMinWeek[getServeIndex].objectId =
                      observationId;
                  getActivityKeyWiseData
                      .serverDetailListAvgMinWeek[getServeIndex].serverUrl =
                      allSelectedServersUrl[j].url;
                  getActivityKeyWiseData
                      .serverDetailListAvgMinWeek[getServeIndex].patientId =
                      allSelectedServersUrl[j].patientId;
                  getActivityKeyWiseData
                      .serverDetailListAvgMinWeek[getServeIndex].patientName =
                  "${allSelectedServersUrl[j]
                      .patientFName}${allSelectedServersUrl[j].patientLName}";
                }

                await DataBaseHelper.shared.updateMonthlyData(
                    getActivityKeyWiseData);
              }
            }
          }
         /* delayCountFiveSecond++;
          if(delayCountFiveSecond == 10){
            delayCountFiveSecond = 0;
            await Utils.apiCallApplyDelay5second();
          }*/
        }

        var withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
            && element.isSelected && element.patientId != "").toList();
        if(withOutPrimaryData.isNotEmpty) {
          List<Identifier> identifierDataExtra = [];
          for (int a = 0; a < withOutPrimaryData.length; a++) {
            identifierDataExtra.clear();
            if (withOutPrimaryData[a].isSecure &&
                Utils.isExpiredToken(withOutPrimaryData[a].lastLoggedTime,
                    withOutPrimaryData[a].expireTime)) {
              // await Utils.checkTokenExpireTime(withOutPrimaryData[a]);

            }

            withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
                && element.isSelected && element.patientId != "").toList();

            var activityData = allSyncingData[i];
            MonthlyLogTableData getActivityKeyWiseData = await DataBaseHelper
                .shared
                .getMonthlyData(activityData.keyId);

            var callAPIWithThisURL = withOutPrimaryData[a].url;

            var getAllObjectIdList =
            getActivityKeyWiseData.serverDetailListAvgMinWeek.where((element) => element.serverUrl != callAPIWithThisURL).toList();

            if(getAllObjectIdList.isNotEmpty){
              for (int d = 0; d < getAllObjectIdList.length; d++) {
                identifierDataExtra.add(Identifier(value:getAllObjectIdList[d].objectId ,system:
                FhirUri(getAllObjectIdList[d].serverUrl)));
              }
            }

            var objectId = "";
            var getServeIndex = getActivityKeyWiseData.serverDetailListAvgMinWeek.indexWhere((
                element) =>
            element.serverUrl ==
                withOutPrimaryData[a].url).toInt();
            if (getServeIndex != -1) {
              objectId = getActivityKeyWiseData.serverDetailListAvgMinWeek[getServeIndex].objectId ?? "";
              getActivityKeyWiseData.serverDetailListAvgMinWeek[getServeIndex].dataSyncServerWise = true;
            }
            if(getActivityKeyWiseData.serverDetailListAvgMinWeek.isNotEmpty && getActivityKeyWiseData.avgMinPerWeekIdentifierData.isNotEmpty){
              var aObject = getActivityKeyWiseData.avgMinPerWeekIdentifierData.indexWhere((element) => element.url ==
                  withOutPrimaryData[a].url).toInt();
              if(aObject != -1){
                objectId = getActivityKeyWiseData.avgMinPerWeekIdentifierData[aObject].objectId ?? "";
              }
            }

            if(identifierDataExtra.isNotEmpty){
              Observation observation = profiles
                  .createObservationMintuesPerWeek(
                  allSyncingData[i], objectId, "${withOutPrimaryData[a]
                  .patientFName}${withOutPrimaryData[a].patientLName}",
                  withOutPrimaryData[a].patientId,identifierDataList: identifierDataExtra);


              await profiles.processResource(observation, Constant.trackingChart,
                  withOutPrimaryData[a].url,
                  withOutPrimaryData[a].clientId,
                  withOutPrimaryData[a].authToken);
            }
          }
        }
        delayCount++;
        if(delayCount == Constant.delayTimeLength){
          delayCount = 0;
          await Utils.apiCallApplyDelay10second();
        }
      }
    }
  }

  static Future<void> observationSyncDataStrengthDaysPerWeek( List<SyncMonthlyActivityData> allSyncingData) async {

    PaaProfiles profiles = PaaProfiles();
    var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
    var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
    if(getPrimaryServerData.isNotEmpty){
      allSelectedServersUrl.remove(getPrimaryServerData[0]);
      allSelectedServersUrl.add(getPrimaryServerData[0]);
    }
    int delayCount = 0;
    // int delayCountFiveSecond = 0;
    for (int i = 0; i < allSyncingData.length; i++) {
      var activityData = allSyncingData[i];
      if (activityData.headerType == Constant.headerStrength) {
        for (int j = 0; j < allSelectedServersUrl.length; j++) {
          var activityData = allSyncingData[i];
          MonthlyLogTableData getActivityKeyWiseData = await DataBaseHelper
              .shared
              .getMonthlyData(activityData.keyId);
          if (getActivityKeyWiseData.serverDetailListStrength.isNotEmpty) {
            if (activityData.headerType == Constant.headerStrength) {
              getActivityKeyWiseData.isSyncStrength = true;

              await DataBaseHelper.shared.updateMonthlyData(
                  getActivityKeyWiseData);

              String observationId = "";

              var objectId = "";
              var getServeIndex = getActivityKeyWiseData.serverDetailListStrength
                  .indexWhere((element) =>
              element.serverUrl ==
                  allSelectedServersUrl[j].url).toInt();

              if (getServeIndex != -1) {
                objectId =
                getActivityKeyWiseData.serverDetailListStrength[getServeIndex].objectId ?? "";
                getActivityKeyWiseData
                    .serverDetailListStrength[getServeIndex].dataSyncServerWise = true;

                await DataBaseHelper.shared.updateMonthlyData(
                    getActivityKeyWiseData);
              }

              if(getActivityKeyWiseData.serverDetailListStrength.isNotEmpty && getActivityKeyWiseData.strengthIdentifierData.isNotEmpty){
                var a = getActivityKeyWiseData.strengthIdentifierData.indexWhere((element) => element.url == allSelectedServersUrl[j].url).toInt();
                if(a != -1){
                  objectId = getActivityKeyWiseData.strengthIdentifierData[a].objectId ?? "";
                }
              }
              List<Identifier> identifier = [];
              if(allSelectedServersUrl[j].isPrimary){
                var withOutPrimaryDataList = allSelectedServersUrl.where((element) => !element.isPrimary).toList();
                if(withOutPrimaryDataList.isNotEmpty){
                  for (int a = 0; a < withOutPrimaryDataList.length; a++) {
                    if(getActivityKeyWiseData.serverDetailListStrength.isNotEmpty) {
                      var getServeIndex = getActivityKeyWiseData.serverDetailListStrength
                          .indexWhere((element) =>
                      element.serverUrl ==
                          withOutPrimaryDataList[a].url).toInt();
                      if(getServeIndex != -1){
                        identifier.add(Identifier(value: getActivityKeyWiseData.serverDetailListStrength[getServeIndex]
                            .objectId,
                            system: FhirUri(getActivityKeyWiseData.serverDetailListStrength[getServeIndex]
                            .serverUrl)));
                      }
                    }

                  }
                }
              }

              Observation observation = profiles
                  .createObservationStrengthDaysPerWeek(
                  allSyncingData[i], objectId, "${allSelectedServersUrl[j]
                  .patientFName}${allSelectedServersUrl[j].patientLName}",
                  allSelectedServersUrl[j].patientId,identifierDataList: identifier);

              observationId =
              await profiles.processResource(
                  observation, Constant.trackingChart,
                  allSelectedServersUrl[j].url,
                  allSelectedServersUrl[j].clientId,
                  allSelectedServersUrl[j].authToken);

              if(observationId != "null" && observationId != "Null" && observationId != null && observationId != "") {
                getActivityKeyWiseData.strengthId = observationId;

                if (getActivityKeyWiseData.serverDetailListStrength.where((
                    element) =>
                element.objectId
                    == observationId)
                    .toList()
                    .isEmpty) {
                  getActivityKeyWiseData.serverDetailListStrength[getServeIndex]
                      .objectId = observationId;
                  getActivityKeyWiseData.serverDetailListStrength[getServeIndex]
                      .serverUrl = allSelectedServersUrl[j].url;
                  getActivityKeyWiseData.serverDetailListStrength[getServeIndex]
                      .patientId = allSelectedServersUrl[j].patientId;
                  getActivityKeyWiseData.serverDetailListStrength[getServeIndex]
                      .patientName = "${allSelectedServersUrl[j]
                      .patientFName}${allSelectedServersUrl[j].patientLName}";
                }


                await DataBaseHelper.shared.updateMonthlyData(
                    getActivityKeyWiseData);
              }
            }
          }
          /*delayCountFiveSecond++;
          if(delayCountFiveSecond == 10){
            delayCountFiveSecond = 0;
            await Utils.apiCallApplyDelay5second();
          }*/

        }

        var withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
            && element.isSelected && element.patientId != "").toList();
        if(withOutPrimaryData.isNotEmpty) {
          List<Identifier> identifierDataExtra = [];
          for (int a = 0; a < withOutPrimaryData.length; a++) {
            identifierDataExtra.clear();
            if (withOutPrimaryData[a].isSecure &&
                Utils.isExpiredToken(withOutPrimaryData[a].lastLoggedTime,
                    withOutPrimaryData[a].expireTime)) {
              // await Utils.checkTokenExpireTime(withOutPrimaryData[a]);
            }

            withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
                && element.isSelected && element.patientId != "").toList();

            var activityData = allSyncingData[i];
            MonthlyLogTableData getActivityKeyWiseData = await DataBaseHelper
                .shared
                .getMonthlyData(activityData.keyId);

            var callAPIWithThisURL = withOutPrimaryData[a].url;

            var getAllObjectIdList =
            getActivityKeyWiseData.serverDetailListStrength.where((element) => element.serverUrl != callAPIWithThisURL).toList();

            if(getAllObjectIdList.isNotEmpty){
              for (int d = 0; d < getAllObjectIdList.length; d++) {
                identifierDataExtra.add(Identifier(value:getAllObjectIdList[d].objectId ,system:
                FhirUri(getAllObjectIdList[d].serverUrl)));
              }
            }

            var objectId = "";
            var getServeIndex = getActivityKeyWiseData.serverDetailListStrength.indexWhere((
                element) =>
            element.serverUrl ==
                withOutPrimaryData[a].url).toInt();
            if (getServeIndex != -1) {
              objectId = getActivityKeyWiseData.serverDetailListStrength[getServeIndex].objectId ?? "";
              getActivityKeyWiseData.serverDetailListStrength[getServeIndex].dataSyncServerWise = true;
            }
            if(getActivityKeyWiseData.serverDetailListStrength.isNotEmpty && getActivityKeyWiseData.strengthIdentifierData.isNotEmpty){
              var aObject = getActivityKeyWiseData.strengthIdentifierData.indexWhere((element) => element.url ==
                  withOutPrimaryData[a].url).toInt();
              if(aObject != -1){
                objectId = getActivityKeyWiseData.strengthIdentifierData[aObject].objectId ?? "";
              }
            }

            if(identifierDataExtra.isNotEmpty){
              Observation observation = profiles
                  .createObservationStrengthDaysPerWeek(
                  allSyncingData[i], objectId, "${withOutPrimaryData[a]
                  .patientFName}${withOutPrimaryData[a].patientLName}",
                  withOutPrimaryData[a].patientId,identifierDataList: identifierDataExtra);


              await profiles.processResource(observation, Constant.trackingChart,
                  withOutPrimaryData[a].url,
                  withOutPrimaryData[a].clientId,
                  withOutPrimaryData[a].authToken);
            }
          }
        }
        delayCount++;
        if(delayCount == Constant.delayTimeLength){
          delayCount = 0;
          await Utils.apiCallApplyDelay10second();
        }
      }
    }

  }

  ///Tracking chart observation

  static Future<void> observationSyncDataCalories(List<SyncMonthlyActivityData> allSyncingData) async {
    PaaProfiles profiles = PaaProfiles();
    var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
    var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
    if(getPrimaryServerData.isNotEmpty){
      allSelectedServersUrl.remove(getPrimaryServerData[0]);
      allSelectedServersUrl.add(getPrimaryServerData[0]);
    }
    int delayCount = 0;
    for (int i = 0; i < allSyncingData.length; i++) {
      if (allSyncingData[i].monthName == "" && allSyncingData[i].headerType == Constant.titleCalories) {
        for (int j = 0; j < allSelectedServersUrl.length; j++) {
          var activityData = allSyncingData[i];
          ActivityTable getActivityKeyWiseData = await DataBaseHelper.shared.getActivityData(activityData.keyId);
          if(getActivityKeyWiseData.serverDetailList.isNotEmpty){
            getActivityKeyWiseData.isSync = true;

            var objectId = "";
            var getServeIndex = getActivityKeyWiseData.serverDetailList.indexWhere((element) => element.serverUrl == allSelectedServersUrl[j].url).toInt();
            if(getServeIndex != -1){
              objectId = getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ?? "";
              getActivityKeyWiseData.serverDetailList[getServeIndex].dataSyncServerWise = true;
            }
            if(getActivityKeyWiseData.serverDetailList.isNotEmpty && getActivityKeyWiseData.identifierData.isNotEmpty){
              var a = getActivityKeyWiseData.identifierData.indexWhere((element) => element.url ==
                  allSelectedServersUrl[j].url).toInt();
              if(a != -1){
                objectId = getActivityKeyWiseData.identifierData[a].objectId ?? "";
              }
            }
            await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);

            String observationId = "";

            List<Identifier> identifier = [];
            if(allSelectedServersUrl[j].isPrimary){
              var withOutPrimaryDataList = allSelectedServersUrl.where((element) => !element.isPrimary).toList();
              if(withOutPrimaryDataList.isNotEmpty){
                for (int a = 0; a < withOutPrimaryDataList.length; a++) {
                  if(getActivityKeyWiseData.serverDetailList.isNotEmpty) {
                    var getServeIndex = getActivityKeyWiseData.serverDetailList
                        .indexWhere((element) =>
                    element.serverUrl ==
                        withOutPrimaryDataList[a].url).toInt();
                    if(getServeIndex != -1){
                      if(getActivityKeyWiseData.serverDetailList[getServeIndex].objectId != "") {
                        identifier.add(Identifier(value: getActivityKeyWiseData
                            .serverDetailList[getServeIndex].objectId,
                            system: FhirUri(getActivityKeyWiseData
                                .serverDetailList[getServeIndex].serverUrl)));
                      }
                    }
                  }

                }
              }
            }

            String isOverride = Constant.notOverride;
            if(getActivityKeyWiseData.isOverride){
              isOverride = Constant.override;
            }
            bool isOverrideValue = (isOverride == Constant.notOverride)? false: true;
            getActivityKeyWiseData.isOverride = isOverrideValue;
            Observation observation = profiles.createObservationCaloriesPerDay(allSyncingData[i],objectId,
                "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}",
                allSelectedServersUrl[j].patientId,identifierDataList: identifier,isOverride: isOverride);

            observationId = await profiles.processResource(observation, Constant.trackingChart,
                allSelectedServersUrl[j].url,
                allSelectedServersUrl[j].clientId,
                allSelectedServersUrl[j].authToken);

            getActivityKeyWiseData.objectId = observationId;

            if(getActivityKeyWiseData.serverDetailList.where((element) => element.objectId == observationId).toList().isEmpty) {
              getActivityKeyWiseData.serverDetailList[getServeIndex].objectId = observationId;
              getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl = allSelectedServersUrl[j].url;
              getActivityKeyWiseData.serverDetailList[getServeIndex].patientId = allSelectedServersUrl[j].patientId;
              getActivityKeyWiseData.serverDetailList[getServeIndex].patientName =  "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";

            }
            await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);
          }
        }

        var withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
            && element.isSelected && element.patientId != "").toList();
        if(withOutPrimaryData.isNotEmpty) {
          List<Identifier> identifierDataExtra = [];
          for (int a = 0; a < withOutPrimaryData.length; a++) {
            identifierDataExtra.clear();
            /*if (withOutPrimaryData[a].isSecure &&
                Utils.isExpiredToken(withOutPrimaryData[a].lastLoggedTime,
                    withOutPrimaryData[a].expireTime)) {
              // await Utils.checkTokenExpireTime(allSelectedServersUrl[a]);
            }*/
            withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
                && element.isSelected && element.patientId != "").toList();
            var activityData = allSyncingData[i];
            ActivityTable getActivityKeyWiseData = await DataBaseHelper.shared
                .getActivityData(activityData.keyId);

            var callAPIWithThisURL = withOutPrimaryData[a].url;

            var getAllObjectIdList =
            getActivityKeyWiseData.serverDetailList.where((element) => element.serverUrl != callAPIWithThisURL).toList();

            if(getAllObjectIdList.isNotEmpty){
              for (int d = 0; d < getAllObjectIdList.length; d++) {
                identifierDataExtra.add(Identifier(value:getAllObjectIdList[d].objectId ,system:
                FhirUri(getAllObjectIdList[d].serverUrl)));
              }
            }

            var objectId = "";
            var getServeIndex = getActivityKeyWiseData.serverDetailList.indexWhere((
                element) =>
            element.serverUrl ==
                withOutPrimaryData[a].url).toInt();
            if (getServeIndex != -1) {
              objectId = getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ?? "";
              getActivityKeyWiseData.serverDetailList[getServeIndex].dataSyncServerWise = true;
            }
            if(getActivityKeyWiseData.serverDetailList.isNotEmpty && getActivityKeyWiseData.identifierData.isNotEmpty){
              var aObject = getActivityKeyWiseData.identifierData.indexWhere((element) => element.url ==
                  withOutPrimaryData[a].url).toInt();
              if(aObject != -1){
                objectId = getActivityKeyWiseData.identifierData[aObject].objectId ?? "";
              }
            }

            if(identifierDataExtra.isNotEmpty){
              String isOverride = Constant.notOverride;
              if(getActivityKeyWiseData.isOverride){
                isOverride = Constant.override;
              }
              bool isOverrideValue = (isOverride == Constant.notOverride) ? false: true;
              getActivityKeyWiseData.isOverride = isOverrideValue;
              Observation observation = profiles.createObservationCaloriesPerDay(
                  allSyncingData[i], objectId,"${withOutPrimaryData[a]
                  .patientFName}${withOutPrimaryData[a].patientLName}",
                  withOutPrimaryData[a].patientId,identifierDataList: identifierDataExtra,isOverride: isOverride);


              await profiles.processResource(observation, Constant.trackingChart,
                  withOutPrimaryData[a].url,
                  withOutPrimaryData[a].clientId,
                  withOutPrimaryData[a].authToken);
            }
          }
        }
        delayCount++;
        if(delayCount == Constant.delayTimeLength){
          delayCount = 0;
          await Utils.apiCallApplyDelay10second();
        }
      }
    }
  }

  static Future<void> observationSyncDataSteps( List<SyncMonthlyActivityData> allSyncingData) async {

    PaaProfiles profiles = PaaProfiles();
    var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
    var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
    if(getPrimaryServerData.isNotEmpty){
      allSelectedServersUrl.remove(getPrimaryServerData[0]);
      allSelectedServersUrl.add(getPrimaryServerData[0]);
    }
    int delayCount = 0;
    // int delayCountFiveSecond = 0;
    for (int i = 0; i < allSyncingData.length; i++) {
      if (allSyncingData[i].monthName == "" &&
          allSyncingData[i].headerType == Constant.titleSteps) {
        for (int j = 0; j < allSelectedServersUrl.length; j++) {
          var activityData = allSyncingData[i];
          ActivityTable getActivityKeyWiseData = await DataBaseHelper.shared
              .getActivityData(activityData.keyId);

          if(getActivityKeyWiseData.serverDetailList.isNotEmpty){
            getActivityKeyWiseData.isSync = true;

            await DataBaseHelper.shared.updateActivityData(
                getActivityKeyWiseData);

            String observationId = "";

            var objectId = "";
            var getServeIndex = getActivityKeyWiseData.serverDetailList.indexWhere((
                element) =>
            element.serverUrl ==
                allSelectedServersUrl[j].url).toInt();
            if (getServeIndex != -1) {
              objectId = getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ?? "";
              getActivityKeyWiseData.serverDetailList[getServeIndex].dataSyncServerWise = true;
            }
            if(getActivityKeyWiseData.serverDetailList.isNotEmpty && getActivityKeyWiseData.identifierData.isNotEmpty){
              var a = getActivityKeyWiseData.identifierData.indexWhere((element) => element.url == allSelectedServersUrl[j].url).toInt();
              if(a != -1){
                objectId = getActivityKeyWiseData.identifierData[a].objectId ?? "";
              }
            }
            List<Identifier> identifier = [];
            if(allSelectedServersUrl[j].isPrimary){
              var withOutPrimaryDataList = allSelectedServersUrl.where((element) => !element.isPrimary).toList();
              if(withOutPrimaryDataList.isNotEmpty){
                for (int a = 0; a < withOutPrimaryDataList.length; a++) {
                  if(getActivityKeyWiseData.serverDetailList.isNotEmpty) {
                    var getServeIndex = getActivityKeyWiseData.serverDetailList
                        .indexWhere((element) =>
                    element.serverUrl ==
                        withOutPrimaryDataList[a].url).toInt();
                    if(getServeIndex != -1){
                      identifier.add(Identifier(value: getActivityKeyWiseData.serverDetailList[getServeIndex].objectId,
                          system: FhirUri(getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl)));
                    }
                  }

                }
              }
            }
            Observation observation = profiles.createObservationDailyStepsPerDay(
                allSyncingData[i], objectId,
                "${allSelectedServersUrl[j]
                    .patientFName}${allSelectedServersUrl[j].patientLName}",
                allSelectedServersUrl[j].patientId,identifierDataList: identifier);

            observationId =
            await profiles.processResource(observation, Constant.trackingChart,
                allSelectedServersUrl[j].url,
                allSelectedServersUrl[j].clientId,
                allSelectedServersUrl[j].authToken);

            getActivityKeyWiseData.objectId = observationId;

           /* if (!getActivityKeyWiseData.objectIdList.contains(observationId)) {
              getActivityKeyWiseData.objectIdList[getServeIndex] = observationId;

              if(getActivityKeyWiseData.serverUrlList[getServeIndex] != ""){
                getActivityKeyWiseData.serverUrlList[getServeIndex] = allSelectedServersUrl[j].url;
              }
              if(getActivityKeyWiseData.patientIdList[getServeIndex] != ""){
                getActivityKeyWiseData.patientIdList[getServeIndex] = allSelectedServersUrl[j].patientId;
              }
              if(getActivityKeyWiseData.patientNameList[getServeIndex] != ""){
                getActivityKeyWiseData.patientNameList[getServeIndex] = "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";
              }
            }*/

            if(getActivityKeyWiseData.serverDetailList.where((element) => element.objectId == observationId).toList().isEmpty) {
              getActivityKeyWiseData.serverDetailList[getServeIndex].objectId = observationId;
              getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl = allSelectedServersUrl[j].url;
              getActivityKeyWiseData.serverDetailList[getServeIndex].patientId = allSelectedServersUrl[j].patientId;
              getActivityKeyWiseData.serverDetailList[getServeIndex].patientName =  "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";
            }

            await DataBaseHelper.shared.updateActivityData(
                getActivityKeyWiseData);
          }
          /*delayCountFiveSecond++;
          if(delayCountFiveSecond == 10){
            delayCountFiveSecond = 0;
            await Utils.apiCallApplyDelay5second();
          }*/
        }

        var withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
            && element.isSelected && element.patientId != "").toList();
        if(withOutPrimaryData.isNotEmpty) {
          List<Identifier> identifierDataExtra = [];
          for (int a = 0; a < withOutPrimaryData.length; a++) {
            identifierDataExtra.clear();
            if (withOutPrimaryData[a].isSecure &&
                Utils.isExpiredToken(withOutPrimaryData[a].lastLoggedTime,
                    withOutPrimaryData[a].expireTime)) {
              // await Utils.checkTokenExpireTime(withOutPrimaryData[a]);

            }

            withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
                && element.isSelected && element.patientId != "").toList();

            var activityData = allSyncingData[i];
            ActivityTable getActivityKeyWiseData = await DataBaseHelper.shared
                .getActivityData(activityData.keyId);

            var callAPIWithThisURL = withOutPrimaryData[a].url;

            var getAllObjectIdList =
            getActivityKeyWiseData.serverDetailList.where((element) => element.serverUrl != callAPIWithThisURL).toList();

            if(getAllObjectIdList.isNotEmpty){
              for (int d = 0; d < getAllObjectIdList.length; d++) {
                identifierDataExtra.add(Identifier(value:getAllObjectIdList[d].objectId ,system:
                FhirUri(getAllObjectIdList[d].serverUrl)));
              }
            }

            var objectId = "";
            var getServeIndex = getActivityKeyWiseData.serverDetailList.indexWhere((
                element) =>
            element.serverUrl ==
                withOutPrimaryData[a].url).toInt();
            if (getServeIndex != -1) {
              objectId = getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ?? "";
              getActivityKeyWiseData.serverDetailList[getServeIndex].dataSyncServerWise = true;
            }
            if(getActivityKeyWiseData.serverDetailList.isNotEmpty && getActivityKeyWiseData.identifierData.isNotEmpty){
              var aObject = getActivityKeyWiseData.identifierData.indexWhere((element) => element.url ==
                  withOutPrimaryData[a].url).toInt();
              if(aObject != -1){
                objectId = getActivityKeyWiseData.identifierData[aObject].objectId ?? "";
              }
            }

            if(identifierDataExtra.isNotEmpty){
              Observation observation = profiles.createObservationDailyStepsPerDay(
                  allSyncingData[i], objectId,"${withOutPrimaryData[a]
                  .patientFName}${withOutPrimaryData[a].patientLName}",
                  withOutPrimaryData[a].patientId,identifierDataList: identifierDataExtra);


              await profiles.processResource(observation, Constant.trackingChart,
                  withOutPrimaryData[a].url,
                  withOutPrimaryData[a].clientId,
                  withOutPrimaryData[a].authToken);
            }
          }
        }
        delayCount++;
        if(delayCount == Constant.delayTimeLength){
          delayCount = 0;
          await Utils.apiCallApplyDelay10second();
        }
      }
    }
  }

  static Future<void> observationSyncDataRestHeart( List<SyncMonthlyActivityData> allSyncingData) async {

    PaaProfiles profiles = PaaProfiles();
    var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
    var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
    if(getPrimaryServerData.isNotEmpty){
      allSelectedServersUrl.remove(getPrimaryServerData[0]);
      allSelectedServersUrl.add(getPrimaryServerData[0]);
    }
    Debug.printLog("observationSyncDataRestHeart...$allSelectedServersUrl");
    int delayCount = 0;
    // int delayCountFiveSecond = 0;
    for (int i = 0; i < allSyncingData.length; i++) {
      if (allSyncingData[i].monthName == "" &&
          allSyncingData[i].headerType == Constant.titleHeartRateRest) {
        for (int j = 0; j < allSelectedServersUrl.length; j++) {
          var activityData = allSyncingData[i];
          ActivityTable getActivityKeyWiseData = await DataBaseHelper.shared
              .getActivityData(activityData.keyId);
          if(getActivityKeyWiseData.serverDetailList.isNotEmpty){
            getActivityKeyWiseData.isSync = true;

            await DataBaseHelper.shared.updateActivityData(
                getActivityKeyWiseData);

            String observationId = "";

            var objectId = "";
            var getServeIndex = getActivityKeyWiseData.serverDetailList.indexWhere((
                element) =>
            element.serverUrl ==
                allSelectedServersUrl[j].url).toInt();
            if (getServeIndex != -1) {
              objectId = getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ?? "";
              getActivityKeyWiseData.serverDetailList[getServeIndex].dataSyncServerWise = true;
            }
            if(getActivityKeyWiseData.serverDetailList.isNotEmpty && getActivityKeyWiseData.identifierData.isNotEmpty){
              var a = getActivityKeyWiseData.identifierData.indexWhere((element) => element.url == allSelectedServersUrl[j].url).toInt();
              if(a != -1){
                objectId = getActivityKeyWiseData.identifierData[a].objectId ?? "";
              }
            }
            List<Identifier> identifier = [];
            if(allSelectedServersUrl[j].isPrimary){
              var withOutPrimaryDataList = allSelectedServersUrl.where((element) => !element.isPrimary).toList();
              if(withOutPrimaryDataList.isNotEmpty){
                for (int a = 0; a < withOutPrimaryDataList.length; a++) {
                  if(getActivityKeyWiseData.serverDetailList.isNotEmpty) {
                    var getServeIndex = getActivityKeyWiseData.serverDetailList
                        .indexWhere((element) =>
                    element.serverUrl ==
                        withOutPrimaryDataList[a].url).toInt();
                    if(getServeIndex != -1){
                      identifier.add(Identifier(value: getActivityKeyWiseData.serverDetailList[getServeIndex].objectId,
                          system: FhirUri(getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl)));
                    }
                  }

                }
              }
            }
            Observation observation = profiles.createObservationAverageRestingHeartRate(
                allSyncingData[i], objectId,"${allSelectedServersUrl[j]
                .patientFName}${allSelectedServersUrl[j].patientLName}",
                allSelectedServersUrl[j].patientId,identifierDataList: identifier);

            observationId =
            await profiles.processResource(observation, Constant.trackingChart,
                allSelectedServersUrl[j].url,
                allSelectedServersUrl[j].clientId,
                allSelectedServersUrl[j].authToken);

            getActivityKeyWiseData.objectId = observationId;

            if(getActivityKeyWiseData.serverDetailList.where((element) => element.objectId == observationId).toList().isEmpty) {
              getActivityKeyWiseData.serverDetailList[getServeIndex].objectId = observationId;
              getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl = allSelectedServersUrl[j].url;
              getActivityKeyWiseData.serverDetailList[getServeIndex].patientId = allSelectedServersUrl[j].patientId;
              getActivityKeyWiseData.serverDetailList[getServeIndex].patientName =  "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";
            }
            await DataBaseHelper.shared.updateActivityData(
                getActivityKeyWiseData);
          }
          /*delayCountFiveSecond++;
          if(delayCountFiveSecond == 10){
            delayCountFiveSecond = 0;
            await Utils.apiCallApplyDelay5second();
          }*/
        }

        var withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
        && element.isSelected && element.patientId != "").toList();
        if(withOutPrimaryData.isNotEmpty) {
          List<Identifier> identifierDataExtra = [];
          for (int a = 0; a < withOutPrimaryData.length; a++) {
            identifierDataExtra.clear();
            if (withOutPrimaryData[a].isSecure &&
                Utils.isExpiredToken(withOutPrimaryData[a].lastLoggedTime,
                    withOutPrimaryData[a].expireTime)) {
              // await Utils.checkTokenExpireTime(withOutPrimaryData[a]);
            }
            withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
                && element.isSelected && element.patientId != "").toList();

            var activityData = allSyncingData[i];
            ActivityTable getActivityKeyWiseData = await DataBaseHelper.shared
                .getActivityData(activityData.keyId);

            var callAPIWithThisURL = withOutPrimaryData[a].url;

            var getAllObjectIdList =
            getActivityKeyWiseData.serverDetailList.where((element) => element.serverUrl != callAPIWithThisURL).toList();

            if(getAllObjectIdList.isNotEmpty){
              for (int d = 0; d < getAllObjectIdList.length; d++) {
                identifierDataExtra.add(Identifier(value:getAllObjectIdList[d].objectId ,system:
                FhirUri(getAllObjectIdList[d].serverUrl)));
              }
            }

            var objectId = "";
            var getServeIndex = getActivityKeyWiseData.serverDetailList.indexWhere((
                element) =>
            element.serverUrl ==
                withOutPrimaryData[a].url).toInt();
            if (getServeIndex != -1) {
              objectId = getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ?? "";
              getActivityKeyWiseData.serverDetailList[getServeIndex].dataSyncServerWise = true;
            }
            if(getActivityKeyWiseData.serverDetailList.isNotEmpty && getActivityKeyWiseData.identifierData.isNotEmpty){
              var aObject = getActivityKeyWiseData.identifierData.indexWhere((element) => element.url ==
                  withOutPrimaryData[a].url).toInt();
              if(aObject != -1){
                objectId = getActivityKeyWiseData.identifierData[aObject].objectId ?? "";
              }
            }

            if(identifierDataExtra.isNotEmpty){
              Observation observation = profiles.createObservationAverageRestingHeartRate(
                  allSyncingData[i], objectId,"${withOutPrimaryData[a]
                  .patientFName}${withOutPrimaryData[a].patientLName}",
                  withOutPrimaryData[a].patientId,identifierDataList: identifierDataExtra);


              await profiles.processResource(observation, Constant.trackingChart,
                  withOutPrimaryData[a].url,
                  withOutPrimaryData[a].clientId,
                  withOutPrimaryData[a].authToken);
            }
          }
        }
        delayCount++;
        if(delayCount == Constant.delayTimeLength){
          delayCount = 0;
          await Utils.apiCallApplyDelay10second();
        }
      }
    }
  }

  static Future<void> observationSyncDataPeakHeart( List<SyncMonthlyActivityData> allSyncingData) async {
    PaaProfiles profiles = PaaProfiles();
    var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
    var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
    if(getPrimaryServerData.isNotEmpty){
      allSelectedServersUrl.remove(getPrimaryServerData[0]);
      allSelectedServersUrl.add(getPrimaryServerData[0]);
    }
    int delayCount = 0;
    for (int i = 0; i < allSyncingData.length; i++) {
      if (allSyncingData[i].monthName == "" &&
          allSyncingData[i].headerType == Constant.titleHeartRatePeak) {
        for (int j = 0; j < allSelectedServersUrl.length; j++) {
          var activityData = allSyncingData[i];
          ActivityTable getActivityKeyWiseData = await DataBaseHelper.shared
              .getActivityData(activityData.keyId);
          if(getActivityKeyWiseData.serverDetailList.isNotEmpty){
            getActivityKeyWiseData.isSync = true;

            await DataBaseHelper.shared.updateActivityData(
                getActivityKeyWiseData);

            String observationId = "";

            var objectId = "";
            var getServeIndex = getActivityKeyWiseData.serverDetailList.indexWhere((
                element) =>
            element.serverUrl ==
                allSelectedServersUrl[j].url).toInt();
            if (getServeIndex != -1) {
              objectId = getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ?? "";
              getActivityKeyWiseData.serverDetailList[getServeIndex].dataSyncServerWise = true;
            }
            if(getActivityKeyWiseData.serverDetailList.isNotEmpty && getActivityKeyWiseData.identifierData.isNotEmpty){
              var a = getActivityKeyWiseData.identifierData.indexWhere((element) => element.url == allSelectedServersUrl[j].url).toInt();
              if(a != -1){
                objectId = getActivityKeyWiseData.identifierData[a].objectId ?? "";
              }
            }
            List<Identifier> identifier = [];
            if(allSelectedServersUrl[j].isPrimary){
              var withOutPrimaryDataList = allSelectedServersUrl.where((element) => !element.isPrimary).toList();
              if(withOutPrimaryDataList.isNotEmpty){
                for (int a = 0; a < withOutPrimaryDataList.length; a++) {
                  if(getActivityKeyWiseData.serverDetailList.isNotEmpty) {
                    var getServeIndex = getActivityKeyWiseData.serverDetailList
                        .indexWhere((element) =>
                    element.serverUrl ==
                        withOutPrimaryDataList[a].url).toInt();
                    if(getServeIndex != -1){
                      identifier.add(Identifier(value: getActivityKeyWiseData.serverDetailList[getServeIndex].objectId,
                          system: FhirUri(getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl)));
                    }
                  }

                }
              }
            }
            Observation observation = profiles.createObservationDailyPeakHeartRatePerDay(
                allSyncingData[i], objectId,"${allSelectedServersUrl[j]
                .patientFName}${allSelectedServersUrl[j].patientLName}",
                allSelectedServersUrl[j].patientId,identifierDataList:identifier );

            observationId =
            await profiles.processResource(observation, Constant.trackingChart,
                allSelectedServersUrl[j].url,
                allSelectedServersUrl[j].clientId,
                allSelectedServersUrl[j].authToken);

            getActivityKeyWiseData.objectId = observationId;

            if(getActivityKeyWiseData.serverDetailList.where((element) => element.objectId == observationId).toList().isEmpty) {
              getActivityKeyWiseData.serverDetailList[getServeIndex].objectId = observationId;
              getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl = allSelectedServersUrl[j].url;
              getActivityKeyWiseData.serverDetailList[getServeIndex].patientId = allSelectedServersUrl[j].patientId;
              getActivityKeyWiseData.serverDetailList[getServeIndex].patientName =  "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";
            }

            await DataBaseHelper.shared.updateActivityData(
                getActivityKeyWiseData);
          }
        }

        var withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
            && element.isSelected && element.patientId != "").toList();
        if(withOutPrimaryData.isNotEmpty) {
          List<Identifier> identifierDataExtra = [];
          for (int a = 0; a < withOutPrimaryData.length; a++) {
            identifierDataExtra.clear();
            if (withOutPrimaryData[a].isSecure &&
                Utils.isExpiredToken(withOutPrimaryData[a].lastLoggedTime,
                    withOutPrimaryData[a].expireTime)) {
            }
            withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
                && element.isSelected && element.patientId != "").toList();

            var activityData = allSyncingData[i];
            ActivityTable getActivityKeyWiseData = await DataBaseHelper.shared
                .getActivityData(activityData.keyId);

            var callAPIWithThisURL = withOutPrimaryData[a].url;

            var getAllObjectIdList =
            getActivityKeyWiseData.serverDetailList.where((element) => element.serverUrl != callAPIWithThisURL).toList();

            if(getAllObjectIdList.isNotEmpty){
              for (int d = 0; d < getAllObjectIdList.length; d++) {
                identifierDataExtra.add(Identifier(value:getAllObjectIdList[d].objectId ,system:
                FhirUri(getAllObjectIdList[d].serverUrl)));
              }
            }

            var objectId = "";
            var getServeIndex = getActivityKeyWiseData.serverDetailList.indexWhere((
                element) =>
            element.serverUrl ==
                withOutPrimaryData[a].url).toInt();
            if (getServeIndex != -1) {
              objectId = getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ?? "";
              getActivityKeyWiseData.serverDetailList[getServeIndex].dataSyncServerWise = true;
            }
            if(getActivityKeyWiseData.serverDetailList.isNotEmpty && getActivityKeyWiseData.identifierData.isNotEmpty){
              var aObject = getActivityKeyWiseData.identifierData.indexWhere((element) => element.url ==
                  withOutPrimaryData[a].url).toInt();
              if(aObject != -1){
                objectId = getActivityKeyWiseData.identifierData[aObject].objectId ?? "";
              }
            }

            if(identifierDataExtra.isNotEmpty){
              Observation observation = profiles.createObservationDailyPeakHeartRatePerDay(
                  allSyncingData[i], objectId,"${withOutPrimaryData[a]
                  .patientFName}${withOutPrimaryData[a].patientLName}",
                  withOutPrimaryData[a].patientId,identifierDataList: identifierDataExtra);


              await profiles.processResource(observation, Constant.trackingChart,
                  withOutPrimaryData[a].url,
                  withOutPrimaryData[a].clientId,
                  withOutPrimaryData[a].authToken);
            }
          }
        }
        delayCount++;
        if(delayCount == Constant.delayTimeLength){
          delayCount = 0;
          await Utils.apiCallApplyDelay10second();
        }
      }
    }
  }

  static Future<void> observationSyncDataExperience( List<SyncMonthlyActivityData> allSyncingData) async {
    PaaProfiles profiles = PaaProfiles();
    var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
    var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
    if(getPrimaryServerData.isNotEmpty){
      allSelectedServersUrl.remove(getPrimaryServerData[0]);
      allSelectedServersUrl.add(getPrimaryServerData[0]);
    }
    int delayCount = 0;
    for (int i = 0; i < allSyncingData.length; i++) {
      if (allSyncingData[i].monthName == "" &&
          allSyncingData[i].headerType == Constant.titleExperience) {
        for (int j = 0; j < allSelectedServersUrl.length; j++) {
          var activityData = allSyncingData[i];
          ActivityTable getActivityKeyWiseData = await DataBaseHelper.shared
              .getActivityData(activityData.keyId);
          if(getActivityKeyWiseData.serverDetailList.isNotEmpty){
            getActivityKeyWiseData.isSync = true;

            await DataBaseHelper.shared.updateActivityData(
                getActivityKeyWiseData);

            String observationId = "";

            var objectId = "";
            var getServeIndex = getActivityKeyWiseData.serverDetailList.indexWhere((
                element) =>
            element.serverUrl ==
                allSelectedServersUrl[j].url).toInt();
            if (getServeIndex != -1) {
              objectId = getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ?? "";
              getActivityKeyWiseData.serverDetailList[getServeIndex].dataSyncServerWise = true;
            }
            if(getActivityKeyWiseData.serverDetailList.isNotEmpty && getActivityKeyWiseData.identifierData.isNotEmpty){
              var a = getActivityKeyWiseData.identifierData.indexWhere((element) => element.url == allSelectedServersUrl[j].url).toInt();
              if(a != -1){
                objectId = getActivityKeyWiseData.identifierData[a].objectId ?? "";
              }
            }
            List<Identifier> identifier = [];
            if(allSelectedServersUrl[j].isPrimary){
              var withOutPrimaryDataList = allSelectedServersUrl.where((element) => !element.isPrimary).toList();
              if(withOutPrimaryDataList.isNotEmpty){
                for (int a = 0; a < withOutPrimaryDataList.length; a++) {
                  if(getActivityKeyWiseData.serverDetailList.isNotEmpty) {
                    var getServeIndex = getActivityKeyWiseData.serverDetailList
                        .indexWhere((element) =>
                    element.serverUrl ==
                        withOutPrimaryDataList[a].url).toInt();
                    if(getServeIndex != -1){
                      identifier.add(Identifier(value: getActivityKeyWiseData.serverDetailList[getServeIndex].objectId,
                          system: FhirUri(getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl)));
                    }
                  }

                }
              }
            }

            var experienceCode = "";
            var experienceDisplay = "";
            try {
              if (activityData.value.toInt() == -3) {
                experienceDisplay = Constant.smiley1Title;
              } else if (activityData.value.toInt() == -2) {
                experienceDisplay = Constant.smiley2Title;
              } else if (activityData.value.toInt() == -1) {
                experienceDisplay = Constant.smiley3Title;
              } else if (activityData.value.toInt() == 0) {
                experienceDisplay = Constant.smiley4Title;
              } else if (activityData.value.toInt() == 1) {
                experienceDisplay = Constant.smiley5Title;
              } else if (activityData.value.toInt() == 2) {
                experienceDisplay = Constant.smiley6Title;
              } else if (activityData.value.toInt() == 3) {
                experienceDisplay = Constant.smiley7Title;
              }
              experienceCode = activityData.value.toInt().toString();
            } catch (e) {
              experienceCode = "0";
              experienceDisplay = Constant.smiley4Title;
              Debug.printLog(e.toString());
            }
            Observation observation = profiles.createObservationDailyExperiencePerDay(
                allSyncingData[i], objectId,"${allSelectedServersUrl[j]
                .patientFName}${allSelectedServersUrl[j].patientLName}",
                allSelectedServersUrl[j].patientId,experienceCode,experienceDisplay,identifierDataList:identifier );

            observationId =
            await profiles.processResource(observation, Constant.trackingChart,
                allSelectedServersUrl[j].url,
                allSelectedServersUrl[j].clientId,
                allSelectedServersUrl[j].authToken);

            getActivityKeyWiseData.objectId = observationId;

            if(getActivityKeyWiseData.serverDetailList.where((element) => element.objectId == observationId).toList().isEmpty) {
              getActivityKeyWiseData.serverDetailList[getServeIndex].objectId = observationId;
              getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl = allSelectedServersUrl[j].url;
              getActivityKeyWiseData.serverDetailList[getServeIndex].patientId = allSelectedServersUrl[j].patientId;
              getActivityKeyWiseData.serverDetailList[getServeIndex].patientName =  "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";
            }

            await DataBaseHelper.shared.updateActivityData(
                getActivityKeyWiseData);
          }
        }

        var withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
            && element.isSelected && element.patientId != "").toList();
        if(withOutPrimaryData.isNotEmpty) {
          List<Identifier> identifierDataExtra = [];
          for (int a = 0; a < withOutPrimaryData.length; a++) {
            identifierDataExtra.clear();
            if (withOutPrimaryData[a].isSecure &&
                Utils.isExpiredToken(withOutPrimaryData[a].lastLoggedTime,
                    withOutPrimaryData[a].expireTime)) {
            }
            withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
                && element.isSelected && element.patientId != "").toList();

            var activityData = allSyncingData[i];
            ActivityTable getActivityKeyWiseData = await DataBaseHelper.shared
                .getActivityData(activityData.keyId);

            var callAPIWithThisURL = withOutPrimaryData[a].url;

            var getAllObjectIdList =
            getActivityKeyWiseData.serverDetailList.where((element) => element.serverUrl != callAPIWithThisURL).toList();

            if(getAllObjectIdList.isNotEmpty){
              for (int d = 0; d < getAllObjectIdList.length; d++) {
                identifierDataExtra.add(Identifier(value:getAllObjectIdList[d].objectId ,system:
                FhirUri(getAllObjectIdList[d].serverUrl)));
              }
            }

            var objectId = "";
            var getServeIndex = getActivityKeyWiseData.serverDetailList.indexWhere((
                element) =>
            element.serverUrl ==
                withOutPrimaryData[a].url).toInt();
            if (getServeIndex != -1) {
              objectId = getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ?? "";
              getActivityKeyWiseData.serverDetailList[getServeIndex].dataSyncServerWise = true;
            }
            if(getActivityKeyWiseData.serverDetailList.isNotEmpty && getActivityKeyWiseData.identifierData.isNotEmpty){
              var aObject = getActivityKeyWiseData.identifierData.indexWhere((element) => element.url ==
                  withOutPrimaryData[a].url).toInt();
              if(aObject != -1){
                objectId = getActivityKeyWiseData.identifierData[aObject].objectId ?? "";
              }
            }

            if(identifierDataExtra.isNotEmpty){
              var experienceCode = "";
              var experienceDisplay = "";
              try {
                if (activityData.value.toInt() == -3) {
                  experienceDisplay = Constant.smiley1Title;
                } else if (activityData.value.toInt() == -2) {
                  experienceDisplay = Constant.smiley2Title;
                } else if (activityData.value.toInt() == -1) {
                  experienceDisplay = Constant.smiley3Title;
                } else if (activityData.value.toInt() == 0) {
                  experienceDisplay = Constant.smiley4Title;
                } else if (activityData.value.toInt() == 1) {
                  experienceDisplay = Constant.smiley5Title;
                } else if (activityData.value.toInt() == 2) {
                  experienceDisplay = Constant.smiley6Title;
                } else if (activityData.value.toInt() == 3) {
                  experienceDisplay = Constant.smiley7Title;
                }
                experienceCode = activityData.value.toInt().toString();
              } catch (e) {
                experienceCode = "0";
                experienceDisplay = Constant.smiley4Title;
                Debug.printLog(e.toString());
              }
              Observation observation = profiles.createObservationDailyExperiencePerDay(
                  allSyncingData[i], objectId,"${withOutPrimaryData[a]
                  .patientFName}${withOutPrimaryData[a].patientLName}",
                  withOutPrimaryData[a].patientId,experienceCode,experienceDisplay,identifierDataList: identifierDataExtra);


              await profiles.processResource(observation, Constant.trackingChart,
                  withOutPrimaryData[a].url,
                  withOutPrimaryData[a].clientId,
                  withOutPrimaryData[a].authToken);
            }
          }
        }
        delayCount++;
        if(delayCount == Constant.delayTimeLength){
          delayCount = 0;
          await Utils.apiCallApplyDelay10second();
        }
      }
    }
  }

  static Future<void> observationSyncDataTotalMin(List<SyncMonthlyActivityData> allSyncingData) async {
    PaaProfiles profiles = PaaProfiles();
    var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" &&
        element.isSelected).toList();
    var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
    if(getPrimaryServerData.isNotEmpty){
      allSelectedServersUrl.remove(getPrimaryServerData[0]);
      allSelectedServersUrl.add(getPrimaryServerData[0]);
    }
    int delayCount = 0;
    for (int i = 0; i < allSyncingData.length; i++) {
      if (allSyncingData[i].monthName == "" && allSyncingData[i].headerType == Constant.totalMinPerDay) {
        for (int j = 0; j < allSelectedServersUrl.length; j++) {
          var activityData = allSyncingData[i];
          ActivityTable getActivityKeyWiseData = await DataBaseHelper.shared.getActivityData(activityData.keyId);
          if(getActivityKeyWiseData.serverDetailList.isNotEmpty){
            getActivityKeyWiseData.isSync = true;

            var objectId = "";
            var getServeIndex = getActivityKeyWiseData.serverDetailList.indexWhere((element) => element.serverUrl ==
                allSelectedServersUrl[j].url).toInt();
            if(getServeIndex != -1){
              objectId = getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ?? "";
              getActivityKeyWiseData.serverDetailList[getServeIndex].dataSyncServerWise = true;
            }
            if(getActivityKeyWiseData.serverDetailList.isNotEmpty && getActivityKeyWiseData.identifierData.isNotEmpty){
              var a = getActivityKeyWiseData.identifierData.indexWhere((element) => element.url ==
                  allSelectedServersUrl[j].url).toInt();
              if(a != -1){
                objectId = getActivityKeyWiseData.identifierData[a].objectId ?? "";
              }
            }
            await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);

            String observationId = "";

            List<Identifier> identifier = [];
            if(allSelectedServersUrl[j].isPrimary){
              var withOutPrimaryDataList = allSelectedServersUrl.where((element) => !element.isPrimary).toList();
              if(withOutPrimaryDataList.isNotEmpty){
                for (int a = 0; a < withOutPrimaryDataList.length; a++) {
                  if(getActivityKeyWiseData.serverDetailList.isNotEmpty) {
                    var getServeIndex = getActivityKeyWiseData.serverDetailList
                        .indexWhere((element) =>
                    element.serverUrl ==
                        withOutPrimaryDataList[a].url).toInt();
                    if(getServeIndex != -1){
                      identifier.add(Identifier(value: getActivityKeyWiseData.serverDetailList[getServeIndex].objectId,
                          system: FhirUri(getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl)));
                    }
                  }

                }
              }
            }

            String isOverride = Constant.notOverride;
            if(getActivityKeyWiseData.isOverride){
              isOverride = Constant.override;
            }
            bool isOverrideValue = (isOverride == Constant.notOverride)? false: true;
            getActivityKeyWiseData.isOverride = isOverrideValue;

            Observation observation = profiles.createObservationDailyTotalMinPerDay(allSyncingData[i],objectId,
                "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}",
                allSelectedServersUrl[j].patientId,activityData.notesDayLevel,identifierDataList: identifier,isOverride: isOverride);

            observationId = await profiles.processResource(observation, Constant.trackingChart,
                allSelectedServersUrl[j].url,
                allSelectedServersUrl[j].clientId,
                allSelectedServersUrl[j].authToken);

            getActivityKeyWiseData.objectId = observationId;

            if(getActivityKeyWiseData.serverDetailList.where((element) => element.objectId == observationId).toList().isEmpty) {
              getActivityKeyWiseData.serverDetailList[getServeIndex].objectId = observationId;
              getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl = allSelectedServersUrl[j].url;
              getActivityKeyWiseData.serverDetailList[getServeIndex].patientId = allSelectedServersUrl[j].patientId;
              getActivityKeyWiseData.serverDetailList[getServeIndex].patientName =  "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";

            }
            await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);
          }
        }

        var withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
            && element.isSelected && element.patientId != "").toList();
        if(withOutPrimaryData.isNotEmpty) {
          List<Identifier> identifierDataExtra = [];
          for (int a = 0; a < withOutPrimaryData.length; a++) {
            identifierDataExtra.clear();
            withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
                && element.isSelected && element.patientId != "").toList();
            var activityData = allSyncingData[i];
            ActivityTable getActivityKeyWiseData = await DataBaseHelper.shared
                .getActivityData(activityData.keyId);

            var callAPIWithThisURL = withOutPrimaryData[a].url;

            var getAllObjectIdList =
            getActivityKeyWiseData.serverDetailList.where((element) => element.serverUrl != callAPIWithThisURL).toList();

            if(getAllObjectIdList.isNotEmpty){
              for (int d = 0; d < getAllObjectIdList.length; d++) {
                identifierDataExtra.add(Identifier(value:getAllObjectIdList[d].objectId ,system:
                FhirUri(getAllObjectIdList[d].serverUrl)));
              }
            }

            var objectId = "";
            var getServeIndex = getActivityKeyWiseData.serverDetailList.indexWhere((
                element) =>
            element.serverUrl ==
                withOutPrimaryData[a].url).toInt();
            if (getServeIndex != -1) {
              objectId = getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ?? "";
              getActivityKeyWiseData.serverDetailList[getServeIndex].dataSyncServerWise = true;
            }
            if(getActivityKeyWiseData.serverDetailList.isNotEmpty && getActivityKeyWiseData.identifierData.isNotEmpty){
              var aObject = getActivityKeyWiseData.identifierData.indexWhere((element) => element.url ==
                  withOutPrimaryData[a].url).toInt();
              if(aObject != -1){
                objectId = getActivityKeyWiseData.identifierData[aObject].objectId ?? "";
              }
            }

            if(identifierDataExtra.isNotEmpty){


              String isOverride = Constant.notOverride;
              if(getActivityKeyWiseData.isOverride){
                isOverride = Constant.override;
              }
              bool isOverrideValue = (isOverride == Constant.notOverride)? false: true;
              getActivityKeyWiseData.isOverride = isOverrideValue;

              Observation observation = profiles.createObservationDailyTotalMinPerDay(
                  allSyncingData[i], objectId,"${withOutPrimaryData[a]
                  .patientFName}${withOutPrimaryData[a].patientLName}",
                  withOutPrimaryData[a].patientId,activityData.notesDayLevel,identifierDataList: identifierDataExtra,isOverride: isOverride);


              await profiles.processResource(observation, Constant.trackingChart,
                  withOutPrimaryData[a].url,
                  withOutPrimaryData[a].clientId,
                  withOutPrimaryData[a].authToken);
            }
          }
        }
        delayCount++;
        if(delayCount == Constant.delayTimeLength){
          delayCount = 0;
          await Utils.apiCallApplyDelay10second();
        }
      }
    }
  }

  static Future<void> observationSyncDataModMin(List<SyncMonthlyActivityData> allSyncingData) async {
    PaaProfiles profiles = PaaProfiles();
    var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" &&
        element.isSelected).toList();
    var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
    if(getPrimaryServerData.isNotEmpty){
      allSelectedServersUrl.remove(getPrimaryServerData[0]);
      allSelectedServersUrl.add(getPrimaryServerData[0]);
    }
    int delayCount = 0;
    for (int i = 0; i < allSyncingData.length; i++) {
      if (allSyncingData[i].monthName == "" && allSyncingData[i].headerType == Constant.modMinPerDay) {
        for (int j = 0; j < allSelectedServersUrl.length; j++) {
          var activityData = allSyncingData[i];
          ActivityTable getActivityKeyWiseData = await DataBaseHelper.shared.getActivityData(activityData.keyId);
          if(getActivityKeyWiseData.serverDetailListModMin.isNotEmpty){
            getActivityKeyWiseData.isSync = true;

            var objectId = "";
            var getServeIndex = getActivityKeyWiseData.serverDetailListModMin.indexWhere((element) => element.modServerUrl ==
                allSelectedServersUrl[j].url).toInt();
            if(getServeIndex != -1){
              objectId = getActivityKeyWiseData.serverDetailListModMin[getServeIndex].modObjectId ?? "";
              getActivityKeyWiseData.serverDetailListModMin[getServeIndex].modDataSyncServerWise = true;
            }
            if(getActivityKeyWiseData.serverDetailListModMin.isNotEmpty && getActivityKeyWiseData.identifierDataModMin.isNotEmpty){
              var a = getActivityKeyWiseData.identifierDataModMin.indexWhere((element) => element.url ==
                  allSelectedServersUrl[j].url).toInt();
              if(a != -1){
                objectId = getActivityKeyWiseData.identifierDataModMin[a].objectId ?? "";
              }
            }
            await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);

            String observationId = "";

            List<Identifier> identifier = [];
            if(allSelectedServersUrl[j].isPrimary){
              var withOutPrimaryDataList = allSelectedServersUrl.where((element) => !element.isPrimary).toList();
              if(withOutPrimaryDataList.isNotEmpty){
                for (int a = 0; a < withOutPrimaryDataList.length; a++) {
                  if(getActivityKeyWiseData.serverDetailListModMin.isNotEmpty) {
                    var getServeIndex = getActivityKeyWiseData.serverDetailListModMin
                        .indexWhere((element) =>
                    element.modServerUrl ==
                        withOutPrimaryDataList[a].url).toInt();
                    if(getServeIndex != -1){
                      identifier.add(Identifier(value: getActivityKeyWiseData.serverDetailListModMin[getServeIndex].modServerUrl,
                          system: FhirUri(getActivityKeyWiseData.serverDetailListModMin[getServeIndex].modServerUrl)));
                    }
                  }

                }
              }
            }

            Observation observation = profiles.createObservationDailyModMinPerDay(allSyncingData[i],objectId,
                "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}",
                allSelectedServersUrl[j].patientId,identifierDataList: identifier);

            observationId = await profiles.processResource(observation, Constant.trackingChart,
                allSelectedServersUrl[j].url,
                allSelectedServersUrl[j].clientId,
                allSelectedServersUrl[j].authToken);

            getActivityKeyWiseData.objectId = observationId;

            if(getActivityKeyWiseData.serverDetailListModMin.where((element) => element.modServerUrl == observationId).toList().isEmpty) {
              getActivityKeyWiseData.serverDetailListModMin[getServeIndex].modObjectId = observationId;
              getActivityKeyWiseData.serverDetailListModMin[getServeIndex].modServerUrl = allSelectedServersUrl[j].url;
              getActivityKeyWiseData.serverDetailListModMin[getServeIndex].modPatientId = allSelectedServersUrl[j].patientId;
              getActivityKeyWiseData.serverDetailListModMin[getServeIndex].modPatientName =  "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";

            }
            await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);
          }
        }

        var withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
            && element.isSelected && element.patientId != "").toList();
        if(withOutPrimaryData.isNotEmpty) {
          List<Identifier> identifierDataExtra = [];
          for (int a = 0; a < withOutPrimaryData.length; a++) {
            identifierDataExtra.clear();
            withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
                && element.isSelected && element.patientId != "").toList();
            var activityData = allSyncingData[i];
            ActivityTable getActivityKeyWiseData = await DataBaseHelper.shared
                .getActivityData(activityData.keyId);

            var callAPIWithThisURL = withOutPrimaryData[a].url;

            var getAllObjectIdList =
            getActivityKeyWiseData.serverDetailListModMin.where((element) => element.modServerUrl != callAPIWithThisURL).toList();

            if(getAllObjectIdList.isNotEmpty){
              for (int d = 0; d < getAllObjectIdList.length; d++) {
                identifierDataExtra.add(Identifier(value:getAllObjectIdList[d].modObjectId ,system:
                FhirUri(getAllObjectIdList[d].modServerUrl)));
              }
            }

            var objectId = "";
            var getServeIndex = getActivityKeyWiseData.serverDetailListModMin.indexWhere((
                element) =>
            element.modServerUrl ==
                withOutPrimaryData[a].url).toInt();
            if (getServeIndex != -1) {
              objectId = getActivityKeyWiseData.serverDetailListModMin[getServeIndex].modObjectId ?? "";
              getActivityKeyWiseData.serverDetailListModMin[getServeIndex].modDataSyncServerWise = true;
            }
            if(getActivityKeyWiseData.serverDetailListModMin.isNotEmpty && getActivityKeyWiseData.identifierDataModMin.isNotEmpty){
              var aObject = getActivityKeyWiseData.identifierDataModMin.indexWhere((element) => element.url ==
                  withOutPrimaryData[a].url).toInt();
              if(aObject != -1){
                objectId = getActivityKeyWiseData.identifierDataModMin[aObject].objectId ?? "";
              }
            }

            if(identifierDataExtra.isNotEmpty){
              Observation observation = profiles.createObservationDailyModMinPerDay(
                  allSyncingData[i], objectId,"${withOutPrimaryData[a]
                  .patientFName}${withOutPrimaryData[a].patientLName}",
                  withOutPrimaryData[a].patientId,identifierDataList: identifierDataExtra);


              await profiles.processResource(observation, Constant.trackingChart,
                  withOutPrimaryData[a].url,
                  withOutPrimaryData[a].clientId,
                  withOutPrimaryData[a].authToken);
            }
          }
        }
        delayCount++;
        if(delayCount == Constant.delayTimeLength){
          delayCount = 0;
          await Utils.apiCallApplyDelay10second();
        }
      }
    }
  }

  static Future<void> observationSyncDataVigMin(List<SyncMonthlyActivityData> allSyncingData) async {
    PaaProfiles profiles = PaaProfiles();
    var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" &&
        element.isSelected).toList();
    var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
    if(getPrimaryServerData.isNotEmpty){
      allSelectedServersUrl.remove(getPrimaryServerData[0]);
      allSelectedServersUrl.add(getPrimaryServerData[0]);
    }
    int delayCount = 0;
    for (int i = 0; i < allSyncingData.length; i++) {
      if (allSyncingData[i].monthName == "" && allSyncingData[i].headerType == Constant.vigMinPerDay) {
        for (int j = 0; j < allSelectedServersUrl.length; j++) {
          var activityData = allSyncingData[i];
          ActivityTable getActivityKeyWiseData = await DataBaseHelper.shared.getActivityData(activityData.keyId);
          if(getActivityKeyWiseData.serverDetailListVigMin.isNotEmpty){
            getActivityKeyWiseData.isSync = true;

            var objectId = "";
            var getServeIndex = getActivityKeyWiseData.serverDetailListVigMin.indexWhere((element) => element.vigServerUrl ==
                allSelectedServersUrl[j].url).toInt();
            if(getServeIndex != -1){
              objectId = getActivityKeyWiseData.serverDetailListVigMin[getServeIndex].vigObjectId ?? "";
              getActivityKeyWiseData.serverDetailListVigMin[getServeIndex].vigDataSyncServerWise = true;
            }
            if(getActivityKeyWiseData.serverDetailListVigMin.isNotEmpty && getActivityKeyWiseData.identifierDataVigMin.isNotEmpty){
              var a = getActivityKeyWiseData.identifierDataVigMin.indexWhere((element) => element.url ==
                  allSelectedServersUrl[j].url).toInt();
              if(a != -1){
                objectId = getActivityKeyWiseData.identifierDataVigMin[a].objectId ?? "";
              }
            }
            await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);

            String observationId = "";

            List<Identifier> identifier = [];
            if(allSelectedServersUrl[j].isPrimary){
              var withOutPrimaryDataList = allSelectedServersUrl.where((element) => !element.isPrimary).toList();
              if(withOutPrimaryDataList.isNotEmpty){
                for (int a = 0; a < withOutPrimaryDataList.length; a++) {
                  if(getActivityKeyWiseData.serverDetailListVigMin.isNotEmpty) {
                    var getServeIndex = getActivityKeyWiseData.serverDetailListVigMin
                        .indexWhere((element) =>
                    element.vigServerUrl ==
                        withOutPrimaryDataList[a].url).toInt();
                    if(getServeIndex != -1){
                      identifier.add(Identifier(value: getActivityKeyWiseData.serverDetailListVigMin[getServeIndex].vigObjectId,
                          system: FhirUri(getActivityKeyWiseData.serverDetailListVigMin[getServeIndex].vigServerUrl)));
                    }
                  }

                }
              }
            }

            Observation observation = profiles.createObservationDailyVigMinPerDay(allSyncingData[i],objectId,
                "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}",
                allSelectedServersUrl[j].patientId,identifierDataList: identifier);

            observationId = await profiles.processResource(observation, Constant.trackingChart,
                allSelectedServersUrl[j].url,
                allSelectedServersUrl[j].clientId,
                allSelectedServersUrl[j].authToken);

            getActivityKeyWiseData.objectId = observationId;

            if(getActivityKeyWiseData.serverDetailListVigMin.where((element) => element.vigObjectId == observationId).toList().isEmpty) {
              getActivityKeyWiseData.serverDetailListVigMin[getServeIndex].vigObjectId = observationId;
              getActivityKeyWiseData.serverDetailListVigMin[getServeIndex].vigServerUrl = allSelectedServersUrl[j].url;
              getActivityKeyWiseData.serverDetailListVigMin[getServeIndex].vigPatientId = allSelectedServersUrl[j].patientId;
              getActivityKeyWiseData.serverDetailListVigMin[getServeIndex].vigPatientName =  "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";

            }
            await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);
          }
        }

        var withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
            && element.isSelected && element.patientId != "").toList();
        if(withOutPrimaryData.isNotEmpty) {
          List<Identifier> identifierDataExtra = [];
          for (int a = 0; a < withOutPrimaryData.length; a++) {
            identifierDataExtra.clear();
            withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
                && element.isSelected && element.patientId != "").toList();
            var activityData = allSyncingData[i];
            ActivityTable getActivityKeyWiseData = await DataBaseHelper.shared
                .getActivityData(activityData.keyId);

            var callAPIWithThisURL = withOutPrimaryData[a].url;

            var getAllObjectIdList =
            getActivityKeyWiseData.serverDetailListVigMin.where((element) => element.vigServerUrl != callAPIWithThisURL).toList();

            if(getAllObjectIdList.isNotEmpty){
              for (int d = 0; d < getAllObjectIdList.length; d++) {
                identifierDataExtra.add(Identifier(value:getAllObjectIdList[d].vigObjectId ,system:
                FhirUri(getAllObjectIdList[d].vigServerUrl)));
              }
            }

            var objectId = "";
            var getServeIndex = getActivityKeyWiseData.serverDetailListVigMin.indexWhere((
                element) =>
            element.vigServerUrl ==
                withOutPrimaryData[a].url).toInt();
            if (getServeIndex != -1) {
              objectId = getActivityKeyWiseData.serverDetailListVigMin[getServeIndex].vigObjectId ?? "";
              getActivityKeyWiseData.serverDetailListVigMin[getServeIndex].vigDataSyncServerWise = true;
            }
            if(getActivityKeyWiseData.serverDetailListVigMin.isNotEmpty && getActivityKeyWiseData.identifierDataVigMin.isNotEmpty){
              var aObject = getActivityKeyWiseData.identifierDataVigMin.indexWhere((element) => element.url ==
                  withOutPrimaryData[a].url).toInt();
              if(aObject != -1){
                objectId = getActivityKeyWiseData.identifierDataVigMin[aObject].objectId ?? "";
              }
            }

            if(identifierDataExtra.isNotEmpty){
              Observation observation = profiles.createObservationDailyVigMinPerDay(
                  allSyncingData[i], objectId,"${withOutPrimaryData[a]
                  .patientFName}${withOutPrimaryData[a].patientLName}",
                  withOutPrimaryData[a].patientId,identifierDataList: identifierDataExtra);


              await profiles.processResource(observation, Constant.trackingChart,
                  withOutPrimaryData[a].url,
                  withOutPrimaryData[a].clientId,
                  withOutPrimaryData[a].authToken);
            }
          }
        }
        delayCount++;
        if(delayCount == Constant.delayTimeLength){
          delayCount = 0;
          await Utils.apiCallApplyDelay10second();
        }
      }
    }
  }

  static Future<void> observationSyncDataStrengthBox(List<SyncMonthlyActivityData> allSyncingData) async {
    PaaProfiles profiles = PaaProfiles();
    var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" &&
        element.isSelected).toList();
    var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
    if(getPrimaryServerData.isNotEmpty){
      allSelectedServersUrl.remove(getPrimaryServerData[0]);
      allSelectedServersUrl.add(getPrimaryServerData[0]);
    }
    int delayCount = 0;
    for (int i = 0; i < allSyncingData.length; i++) {
      if (allSyncingData[i].monthName == "" && allSyncingData[i].headerType == Constant.titleDaysStr) {
        for (int j = 0; j < allSelectedServersUrl.length; j++) {
          var activityData = allSyncingData[i];
          ActivityTable getActivityKeyWiseData = await DataBaseHelper.shared.getActivityData(activityData.keyId);
          if(getActivityKeyWiseData.serverDetailList.isNotEmpty){
            getActivityKeyWiseData.isSync = true;

            var objectId = "";
            var getServeIndex = getActivityKeyWiseData.serverDetailList.indexWhere((element) => element.serverUrl ==
                allSelectedServersUrl[j].url).toInt();
            if(getServeIndex != -1){
              objectId = getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ?? "";
              getActivityKeyWiseData.serverDetailList[getServeIndex].dataSyncServerWise = true;
            }
            if(getActivityKeyWiseData.serverDetailList.isNotEmpty && getActivityKeyWiseData.identifierData.isNotEmpty){
              var a = getActivityKeyWiseData.identifierData.indexWhere((element) => element.url ==
                  allSelectedServersUrl[j].url).toInt();
              if(a != -1){
                objectId = getActivityKeyWiseData.identifierData[a].objectId ?? "";
              }
            }
            await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);

            String observationId = "";

            List<Identifier> identifier = [];
            if(allSelectedServersUrl[j].isPrimary){
              var withOutPrimaryDataList = allSelectedServersUrl.where((element) => !element.isPrimary).toList();
              if(withOutPrimaryDataList.isNotEmpty){
                for (int a = 0; a < withOutPrimaryDataList.length; a++) {
                  if(getActivityKeyWiseData.serverDetailList.isNotEmpty) {
                    var getServeIndex = getActivityKeyWiseData.serverDetailList
                        .indexWhere((element) =>
                    element.serverUrl ==
                        withOutPrimaryDataList[a].url).toInt();
                    if(getServeIndex != -1){
                      identifier.add(Identifier(value: getActivityKeyWiseData.serverDetailList[getServeIndex].objectId,
                          system: FhirUri(getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl)));
                    }
                  }

                }
              }
            }

            Observation observation = profiles.createObservationDailyStrengthBoxPerDay(allSyncingData[i],objectId,
                "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}",
                allSelectedServersUrl[j].patientId,identifierDataList: identifier);

            observationId = await profiles.processResource(observation, Constant.trackingChart,
                allSelectedServersUrl[j].url,
                allSelectedServersUrl[j].clientId,
                allSelectedServersUrl[j].authToken);

            getActivityKeyWiseData.objectId = observationId;

            if(getActivityKeyWiseData.serverDetailList.where((element) => element.objectId == observationId).toList().isEmpty) {
              getActivityKeyWiseData.serverDetailList[getServeIndex].objectId = observationId;
              getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl = allSelectedServersUrl[j].url;
              getActivityKeyWiseData.serverDetailList[getServeIndex].patientId = allSelectedServersUrl[j].patientId;
              getActivityKeyWiseData.serverDetailList[getServeIndex].patientName =  "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";

            }
            await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);
          }
        }

        var withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
            && element.isSelected && element.patientId != "").toList();
        if(withOutPrimaryData.isNotEmpty) {
          List<Identifier> identifierDataExtra = [];
          for (int a = 0; a < withOutPrimaryData.length; a++) {
            identifierDataExtra.clear();
            withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
                && element.isSelected && element.patientId != "").toList();
            var activityData = allSyncingData[i];
            ActivityTable getActivityKeyWiseData = await DataBaseHelper.shared
                .getActivityData(activityData.keyId);

            var callAPIWithThisURL = withOutPrimaryData[a].url;

            var getAllObjectIdList =
            getActivityKeyWiseData.serverDetailList.where((element) => element.serverUrl != callAPIWithThisURL).toList();

            if(getAllObjectIdList.isNotEmpty){
              for (int d = 0; d < getAllObjectIdList.length; d++) {
                identifierDataExtra.add(Identifier(value:getAllObjectIdList[d].objectId ,system:
                FhirUri(getAllObjectIdList[d].serverUrl)));
              }
            }

            var objectId = "";
            var getServeIndex = getActivityKeyWiseData.serverDetailList.indexWhere((
                element) =>
            element.serverUrl ==
                withOutPrimaryData[a].url).toInt();
            if (getServeIndex != -1) {
              objectId = getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ?? "";
              getActivityKeyWiseData.serverDetailList[getServeIndex].dataSyncServerWise = true;
            }
            if(getActivityKeyWiseData.serverDetailList.isNotEmpty && getActivityKeyWiseData.identifierData.isNotEmpty){
              var aObject = getActivityKeyWiseData.identifierData.indexWhere((element) => element.url ==
                  withOutPrimaryData[a].url).toInt();
              if(aObject != -1){
                objectId = getActivityKeyWiseData.identifierData[aObject].objectId ?? "";
              }
            }

            if(identifierDataExtra.isNotEmpty){
              Observation observation = profiles.createObservationDailyStrengthBoxPerDay(
                  allSyncingData[i], objectId,"${withOutPrimaryData[a]
                  .patientFName}${withOutPrimaryData[a].patientLName}",
                  withOutPrimaryData[a].patientId,identifierDataList: identifierDataExtra);


              await profiles.processResource(observation, Constant.trackingChart,
                  withOutPrimaryData[a].url,
                  withOutPrimaryData[a].clientId,
                  withOutPrimaryData[a].authToken);
            }
          }
        }
        delayCount++;
        if(delayCount == Constant.delayTimeLength){
          delayCount = 0;
          await Utils.apiCallApplyDelay10second();
        }
      }
    }
  }


  ///Tracking activity data observation
  static Future<void> createParentActivityObservation(ActivityTable getActivityKeyWiseData,{bool isAppleHealthData = false}) async {
    PaaProfiles profiles = PaaProfiles();
    var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
    var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
    if(getPrimaryServerData.isNotEmpty){
      allSelectedServersUrl.remove(getPrimaryServerData[0]);
      allSelectedServersUrl.add(getPrimaryServerData[0]);
    }
    for (int j = 0; j < allSelectedServersUrl.length; j++) {
      if (getActivityKeyWiseData.serverDetailList.isNotEmpty) {
        getActivityKeyWiseData.isSync = true;

        await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);

        String observationId = "";

        var objectId = "";
        var getServeIndex = getActivityKeyWiseData.serverDetailList
            .indexWhere(
                (element) => element.serverUrl == allSelectedServersUrl[j].url)
            .toInt();
        if (getServeIndex != -1) {
          objectId =
              getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ??
                  "";
          getActivityKeyWiseData
              .serverDetailList[getServeIndex].dataSyncServerWise = true;
        }
        if (getActivityKeyWiseData.serverDetailList.isNotEmpty &&
            getActivityKeyWiseData.identifierData.isNotEmpty) {
          var a = getActivityKeyWiseData.identifierData
              .indexWhere(
                  (element) => element.url == allSelectedServersUrl[j].url)
              .toInt();
          if (a != -1) {
            objectId = getActivityKeyWiseData.identifierData[a].objectId ?? "";
          }
        }
        List<Identifier> identifier = [];
        if (allSelectedServersUrl[j].isPrimary) {
          var withOutPrimaryDataList = allSelectedServersUrl
              .where((element) => !element.isPrimary)
              .toList();
          if (withOutPrimaryDataList.isNotEmpty) {
            for (int a = 0; a < withOutPrimaryDataList.length; a++) {
              if (getActivityKeyWiseData.serverDetailList.isNotEmpty) {
                var getServeIndex = getActivityKeyWiseData.serverDetailList
                    .indexWhere((element) =>
                        element.serverUrl == withOutPrimaryDataList[a].url)
                    .toInt();
                if (getServeIndex != -1) {
                  identifier.add(Identifier(
                      value: getActivityKeyWiseData
                          .serverDetailList[getServeIndex].objectId,
                      system: FhirUri(getActivityKeyWiseData
                          .serverDetailList[getServeIndex].serverUrl)));
                }
              }
            }
          }
        }

        var titleListHasMember = [Constant.titleActivityType,Constant.titleCalories,null,Constant.titleHeartRatePeak,Constant.titleSteps,
        Constant.titleExperience];
        List<Reference>? hasMember = [];
        var activityTableData = getActivityListData();
        if(activityTableData.isNotEmpty){
          var childMemberList = activityTableData.where((element) => element.date == getActivityKeyWiseData.date
              && element.weeksDate == getActivityKeyWiseData.weeksDate &&
              // element.type == Constant.typeDaysData && element.activityStartDate == getActivityKeyWiseData.activityStartDate
              element.type == Constant.typeDaysData &&
              Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
              Utils.changeDateFormatBasedOnDBDate(getActivityKeyWiseData.activityStartDate ?? DateTime.now())
              &&
              Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
                  Utils.changeDateFormatBasedOnDBDate(getActivityKeyWiseData.activityEndDate ?? DateTime.now()) &&
              titleListHasMember.contains(element.title)).toList();

          for (int l = 0; l < childMemberList.length; l++) {
            if (childMemberList[l].title == null && childMemberList[l].smileyType == null) {
              // if(childMemberList[l].value1 != null){
                var serverDetailModMin = childMemberList[l].serverDetailListModMin.where((
                    element) =>
                element.modServerUrl
                    == allSelectedServersUrl[j].url && element.modObjectId != "")
                    .toList();
                if (serverDetailModMin.isNotEmpty) {
                  hasMember.add(Reference(
                      reference: "Observation/${serverDetailModMin[0].modObjectId}",display: Constant.hasMemberTypeModMin));
                }
              // }
              // if(childMemberList[l].value2 != null){
                var serverDetailVigMin = childMemberList[l].serverDetailListVigMin.where((
                    element) =>
                element.vigServerUrl
                    == allSelectedServersUrl[j].url && element.vigObjectId != "")
                    .toList();
                if (serverDetailVigMin.isNotEmpty) {
                  hasMember.add(Reference(
                      reference: "Observation/${serverDetailVigMin[0].vigObjectId}",display: Constant.hasMemberTypeVigMin));
                }
              // }
              // if(childMemberList[l].total != null){
                var serverDetailTotalMin = childMemberList[l].serverDetailList.where((
                    element) =>
                element.serverUrl
                    == allSelectedServersUrl[j].url && element.objectId != "")
                    .toList();
                if (serverDetailTotalMin.isNotEmpty) {
                  hasMember.add(Reference(
                      reference: "Observation/${serverDetailTotalMin[0].objectId}",display: Constant.hasMemberTypeTotalMin));
                }
              // }
            }
            else {
              var displayType = "";
              if(childMemberList[l].title == Constant.titleActivityType){
                displayType = Constant.hasMemberTypeActivity;
              }else if(childMemberList[l].title == Constant.titleHeartRatePeak){
                displayType = Constant.hasMemberTypePeakHeartRate;
              }else if(childMemberList[l].title == Constant.titleCalories){
                displayType = Constant.hasMemberTypeCalories;
              }else if(childMemberList[l].title == Constant.titleSteps){
                displayType = Constant.hasMemberTypeSteps;
              }else if(childMemberList[l].title == null && childMemberList[l].smileyType != null && childMemberList[l].total == null){
                displayType = Constant.hasMemberTypeEx;
              }

              var serverDetail = childMemberList[l].serverDetailList.where((
                  element) =>
              element.serverUrl
                  == allSelectedServersUrl[j].url && element.objectId != "")
                  .toList();
              if (serverDetail.isNotEmpty) {
                hasMember.add(Reference(
                    reference: "Observation/${serverDetail[0].objectId}",display: displayType));
              }
            }
          }
        }
        Debug.printLog("hasMember insert if...$hasMember");
        Observation observation = profiles.createParentActivityObservation(
            objectId,
            "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}",
            allSelectedServersUrl[j].patientId,
            getActivityKeyWiseData.displayLabel ?? "",
            getActivityKeyWiseData.activityStartDate ?? DateTime.now(),
            getActivityKeyWiseData.activityEndDate ?? DateTime.now(),
            hasMember,
            identifierDataList: identifier,isAppleHealthData: isAppleHealthData);

        observationId = await profiles.processResource(
            observation,
            Constant.trackingChart,
            allSelectedServersUrl[j].url,
            allSelectedServersUrl[j].clientId,
            allSelectedServersUrl[j].authToken);

        getActivityKeyWiseData.objectId = observationId;

        if (getActivityKeyWiseData.serverDetailList
            .where((element) => element.objectId == observationId)
            .toList()
            .isEmpty) {
          getActivityKeyWiseData.serverDetailList[getServeIndex].objectId =
              observationId;
          getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl =
              allSelectedServersUrl[j].url;
          getActivityKeyWiseData.serverDetailList[getServeIndex].patientId =
              allSelectedServersUrl[j].patientId;
          getActivityKeyWiseData.serverDetailList[getServeIndex].patientName =
              "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";
        }
        if(getActivityKeyWiseData.key != null){
          await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);
        }
      }
    }

    var withOutPrimaryData = Utils.getServerListPreference()
        .where((element) =>
            !element.isPrimary && element.isSelected && element.patientId != "")
        .toList();
    if (withOutPrimaryData.isNotEmpty) {
      List<Identifier> identifierDataExtra = [];
      for (int a = 0; a < withOutPrimaryData.length; a++) {
        identifierDataExtra.clear();
        if (withOutPrimaryData[a].isSecure &&
            Utils.isExpiredToken(withOutPrimaryData[a].lastLoggedTime,
                withOutPrimaryData[a].expireTime)) {
          // await Utils.checkTokenExpireTime(withOutPrimaryData[a]);
        }
        withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
            && element.isSelected && element.patientId != "").toList();

        var callAPIWithThisURL = withOutPrimaryData[a].url;

        var getAllObjectIdList = getActivityKeyWiseData.serverDetailList
            .where((element) => element.serverUrl != callAPIWithThisURL)
            .toList();

        if (getAllObjectIdList.isNotEmpty) {
          for (int d = 0; d < getAllObjectIdList.length; d++) {
            identifierDataExtra.add(Identifier(
                value: getAllObjectIdList[d].objectId,
                system: FhirUri(getAllObjectIdList[d].serverUrl)));
          }
        }

        var objectId = "";
        var getServeIndex = getActivityKeyWiseData.serverDetailList
            .indexWhere(
                (element) => element.serverUrl == withOutPrimaryData[a].url)
            .toInt();
        if (getServeIndex != -1) {
          objectId =
              getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ??
                  "";
          getActivityKeyWiseData
              .serverDetailList[getServeIndex].dataSyncServerWise = true;
        }
        if (getActivityKeyWiseData.serverDetailList.isNotEmpty &&
            getActivityKeyWiseData.identifierData.isNotEmpty) {
          var aObject = getActivityKeyWiseData.identifierData
              .indexWhere((element) => element.url == withOutPrimaryData[a].url)
              .toInt();
          if (aObject != -1) {
            objectId =
                getActivityKeyWiseData.identifierData[aObject].objectId ?? "";
          }
        }

        if (identifierDataExtra.isNotEmpty) {
          var titleListHasMember = [Constant.titleActivityType,Constant.titleCalories,null,Constant.titleHeartRatePeak,Constant.titleSteps,
            Constant.titleExperience];
          List<Reference>? hasMember = [];
          var activityTableData = getActivityListData();
          if(activityTableData.isNotEmpty){
            var childMemberList = activityTableData.where((element) => element.date == getActivityKeyWiseData.date
                && element.weeksDate == getActivityKeyWiseData.weeksDate  &&
                /*element.activityStartDate == getActivityKeyWiseData.activityStartDate
                &&
                element.activityEndDate == getActivityKeyWiseData.activityEndDate
                &&*/
                Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
                    Utils.changeDateFormatBasedOnDBDate(getActivityKeyWiseData.activityStartDate ?? DateTime.now())
                &&
                Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
                    Utils.changeDateFormatBasedOnDBDate(getActivityKeyWiseData.activityEndDate ?? DateTime.now()) &&
                element.type == Constant.typeDaysData &&
                titleListHasMember.contains(element.title)).toList();
            for (int l = 0; l < childMemberList.length; l++) {
              if (childMemberList[l].title == null && childMemberList[l].smileyType == null) {
                // if(childMemberList[l].value1 != null){
                  var serverDetailMod = childMemberList[l].serverDetailListModMin.where((
                      element) =>
                  element.modServerUrl
                      == withOutPrimaryData[a].url && element.modObjectId != "")
                      .toList();
                  if (serverDetailMod.isNotEmpty) {
                    hasMember.add(Reference(
                        reference: "Observation/${serverDetailMod[0].modObjectId}",display: Constant.hasMemberTypeModMin));
                  }
                // }
                // if(childMemberList[l].value2 != null){
                  var serverDetailVig = childMemberList[l].serverDetailListVigMin.where((
                      element) =>
                  element.vigServerUrl
                      == withOutPrimaryData[a].url && element.vigObjectId != "")
                      .toList();
                  if (serverDetailVig.isNotEmpty) {
                    hasMember.add(Reference(
                        reference: "Observation/${serverDetailVig[0].vigObjectId}",display: Constant.hasMemberTypeVigMin));
                  }
                // }
                // if(childMemberList[l].total != null){
                  var serverDetailTotal = childMemberList[l].serverDetailList.where((
                      element) =>
                  element.serverUrl
                      == withOutPrimaryData[a].url && element.objectId != "")
                      .toList();
                  if (serverDetailTotal.isNotEmpty) {
                    hasMember.add(Reference(
                        reference: "Observation/${serverDetailTotal[0].objectId}",display: Constant.hasMemberTypeTotalMin));
                  }
                // }
              }
              else {
                var displayType = "";
                if(childMemberList[l].title == Constant.titleActivityType){
                  displayType = Constant.hasMemberTypeActivity;
                }else if(childMemberList[l].title == Constant.titleHeartRatePeak){
                  displayType = Constant.hasMemberTypePeakHeartRate;
                }else if(childMemberList[l].title == Constant.titleCalories){
                  displayType = Constant.hasMemberTypeCalories;
                }else if(childMemberList[l].title == Constant.titleSteps){
                  displayType = Constant.hasMemberTypeSteps;
                }else if(childMemberList[l].title == null && childMemberList[l].smileyType != null && childMemberList[l].total == null){
                  displayType = Constant.hasMemberTypeEx;
                }

                var serverDetail = childMemberList[l].serverDetailList.where((
                    element) =>
                element.serverUrl
                    == withOutPrimaryData[a].url && element.objectId != "")
                    .toList();
                if (serverDetail.isNotEmpty) {
                  hasMember.add(Reference(
                      reference: "Observation/${serverDetail[0].objectId}",display: displayType));
                }
              }
            }

          }
          Debug.printLog("hasMember insert update...$hasMember");
          Observation observation = profiles.createParentActivityObservation(
              objectId,
              "${withOutPrimaryData[a].patientFName}${withOutPrimaryData[a].patientLName}",
              withOutPrimaryData[a].patientId,
              getActivityKeyWiseData.displayLabel ?? "",
              getActivityKeyWiseData.activityStartDate ?? DateTime.now(),
              getActivityKeyWiseData.activityEndDate ?? DateTime.now(),
              hasMember,
              identifierDataList: identifierDataExtra,isAppleHealthData: isAppleHealthData);

          await profiles.processResource(
              observation,
              Constant.trackingChart,
              withOutPrimaryData[a].url,
              withOutPrimaryData[a].clientId,
              withOutPrimaryData[a].authToken);
        }
      }
    }
  }

  static Future<void> createChildActivityNameObservation(String activityName,ActivityTable getActivityKeyWiseData,{bool isAppleHealthData = false}) async {
    PaaProfiles profiles = PaaProfiles();
    var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
    var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
    if(getPrimaryServerData.isNotEmpty){
      allSelectedServersUrl.remove(getPrimaryServerData[0]);
      allSelectedServersUrl.add(getPrimaryServerData[0]);
    }

    for (int j = 0; j < allSelectedServersUrl.length; j++) {
      if (getActivityKeyWiseData.serverDetailList.isNotEmpty) {
        getActivityKeyWiseData.isSync = true;

        await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);

        String observationId = "";

        var objectId = "";
        var getServeIndex = getActivityKeyWiseData.serverDetailList
            .indexWhere(
                (element) => element.serverUrl == allSelectedServersUrl[j].url)
            .toInt();
        if (getServeIndex != -1) {
          objectId =
              getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ??
                  "";
          getActivityKeyWiseData
              .serverDetailList[getServeIndex].dataSyncServerWise = true;
        }
        if (getActivityKeyWiseData.serverDetailList.isNotEmpty &&
            getActivityKeyWiseData.identifierData.isNotEmpty) {
          var a = getActivityKeyWiseData.identifierData
              .indexWhere(
                  (element) => element.url == allSelectedServersUrl[j].url)
              .toInt();
          if (a != -1) {
            objectId = getActivityKeyWiseData.identifierData[a].objectId ?? "";
          }
        }
        List<Identifier> identifier = [];
        if (allSelectedServersUrl[j].isPrimary) {
          var withOutPrimaryDataList = allSelectedServersUrl
              .where((element) => !element.isPrimary)
              .toList();
          if (withOutPrimaryDataList.isNotEmpty) {
            for (int a = 0; a < withOutPrimaryDataList.length; a++) {
              if (getActivityKeyWiseData.serverDetailList.isNotEmpty) {
                var getServeIndex = getActivityKeyWiseData.serverDetailList
                    .indexWhere((element) =>
                element.serverUrl == withOutPrimaryDataList[a].url)
                    .toInt();
                if (getServeIndex != -1) {
                  identifier.add(Identifier(
                      value: getActivityKeyWiseData
                          .serverDetailList[getServeIndex].objectId,
                      system: FhirUri(getActivityKeyWiseData
                          .serverDetailList[getServeIndex].serverUrl)));
                }
              }
            }
          }
        }
        var configurationList = Preference.shared.getConfigPrefList(Preference.configurationInfo) ?? [];
        var loincCode = "";
        if(configurationList.isNotEmpty){
          var data = configurationList.where((element) => element.title == getActivityKeyWiseData.displayLabel).toList();
          if(data.isNotEmpty){
            loincCode = data[0].activityCode;
          }
        }
        Observation observation = profiles.createChildActivityNameObservation(
            objectId,
            "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}",
            allSelectedServersUrl[j].patientId,
            loincCode,
            activityName,
            getActivityKeyWiseData.activityStartDate ?? DateTime.now(),
            getActivityKeyWiseData.activityEndDate ?? DateTime.now(),
            identifierDataList: identifier,isAppleHealthData: isAppleHealthData);

        observationId = await profiles.processResource(
            observation,
            Constant.trackingChart,
            allSelectedServersUrl[j].url,
            allSelectedServersUrl[j].clientId,
            allSelectedServersUrl[j].authToken);

        getActivityKeyWiseData.objectId = observationId;

        if (getActivityKeyWiseData.serverDetailList
            .where((element) => element.objectId == observationId)
            .toList()
            .isEmpty) {
          getActivityKeyWiseData.serverDetailList[getServeIndex].objectId =
              observationId;
          getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl =
              allSelectedServersUrl[j].url;
          getActivityKeyWiseData.serverDetailList[getServeIndex].patientId =
              allSelectedServersUrl[j].patientId;
          getActivityKeyWiseData.serverDetailList[getServeIndex].patientName =
          "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";
        }

        await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);
      }
    }

    var withOutPrimaryData = Utils.getServerListPreference()
        .where((element) =>
    !element.isPrimary && element.isSelected && element.patientId != "")
        .toList();
    if (withOutPrimaryData.isNotEmpty) {
      List<Identifier> identifierDataExtra = [];
      for (int a = 0; a < withOutPrimaryData.length; a++) {
        identifierDataExtra.clear();
        if (withOutPrimaryData[a].isSecure &&
            Utils.isExpiredToken(withOutPrimaryData[a].lastLoggedTime,
                withOutPrimaryData[a].expireTime)) {
          // await Utils.checkTokenExpireTime(withOutPrimaryData[a]);
        }
        withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
            && element.isSelected && element.patientId != "").toList();

        var callAPIWithThisURL = withOutPrimaryData[a].url;

        var getAllObjectIdList = getActivityKeyWiseData.serverDetailList
            .where((element) => element.serverUrl != callAPIWithThisURL)
            .toList();

        if (getAllObjectIdList.isNotEmpty) {
          for (int d = 0; d < getAllObjectIdList.length; d++) {
            identifierDataExtra.add(Identifier(
                value: getAllObjectIdList[d].objectId,
                system: FhirUri(getAllObjectIdList[d].serverUrl)));
          }
        }

        var objectId = "";
        var getServeIndex = getActivityKeyWiseData.serverDetailList
            .indexWhere(
                (element) => element.serverUrl == withOutPrimaryData[a].url)
            .toInt();
        if (getServeIndex != -1) {
          objectId =
              getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ??
                  "";
          getActivityKeyWiseData
              .serverDetailList[getServeIndex].dataSyncServerWise = true;
        }
        if (getActivityKeyWiseData.serverDetailList.isNotEmpty &&
            getActivityKeyWiseData.identifierData.isNotEmpty) {
          var aObject = getActivityKeyWiseData.identifierData
              .indexWhere((element) => element.url == withOutPrimaryData[a].url)
              .toInt();
          if (aObject != -1) {
            objectId =
                getActivityKeyWiseData.identifierData[aObject].objectId ?? "";
          }
        }

        if (identifierDataExtra.isNotEmpty) {
          var configurationList = Preference.shared.getConfigPrefList(Preference.configurationInfo) ?? [];
          var loincCode = "";
          if(configurationList.isNotEmpty){
            var data = configurationList.where((element) => element.title == getActivityKeyWiseData.displayLabel).toList();
            if(data.isNotEmpty){
              loincCode = data[0].activityCode;
            }
          }
          Observation observation = profiles.createChildActivityNameObservation(
              objectId,
              "${withOutPrimaryData[a].patientFName}${withOutPrimaryData[a].patientLName}",
              withOutPrimaryData[a].patientId,
              loincCode,
              activityName,
              getActivityKeyWiseData.activityStartDate ?? DateTime.now(),
              getActivityKeyWiseData.activityEndDate ?? DateTime.now(),
              identifierDataList: identifierDataExtra,isAppleHealthData: isAppleHealthData);

          await profiles.processResource(
              observation,
              Constant.observation,
              withOutPrimaryData[a].url,
              withOutPrimaryData[a].clientId,
              withOutPrimaryData[a].authToken);
        }
      }
    }
  }

  static Future<void> createChildActivityCaloriesObservation(String activityName,ActivityTable getActivityKeyWiseData,{bool isAppleHealthData = false}) async {

    PaaProfiles profiles = PaaProfiles();

    var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" &&
        element.isSelected).toList();

    var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
    if(getPrimaryServerData.isNotEmpty){
      allSelectedServersUrl.remove(getPrimaryServerData[0]);
      allSelectedServersUrl.add(getPrimaryServerData[0]);
    }

    for (int j = 0; j < allSelectedServersUrl.length; j++) {
      if (getActivityKeyWiseData.serverDetailList.isNotEmpty) {
        getActivityKeyWiseData.isSync = true;

        await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);

        String observationId = "";

        var objectId = "";
        var getServeIndex = getActivityKeyWiseData.serverDetailList
            .indexWhere(
                (element) => element.serverUrl == allSelectedServersUrl[j].url)
            .toInt();

        if (getServeIndex != -1) {
          objectId =
              getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ??
                  "";
          getActivityKeyWiseData
              .serverDetailList[getServeIndex].dataSyncServerWise = true;
        }

        if (getActivityKeyWiseData.serverDetailList.isNotEmpty &&
            getActivityKeyWiseData.identifierData.isNotEmpty) {
          var a = getActivityKeyWiseData.identifierData
              .indexWhere(
                  (element) => element.url == allSelectedServersUrl[j].url)
              .toInt();
          if (a != -1) {
            objectId = getActivityKeyWiseData.identifierData[a].objectId ?? "";
          }
        }

        List<Identifier> identifier = [];
        if (allSelectedServersUrl[j].isPrimary) {

          var withOutPrimaryDataList = allSelectedServersUrl
              .where((element) => !element.isPrimary)
              .toList();

          if (withOutPrimaryDataList.isNotEmpty) {
            for (int a = 0; a < withOutPrimaryDataList.length; a++) {
              if (getActivityKeyWiseData.serverDetailList.isNotEmpty) {
                var getServeIndex = getActivityKeyWiseData.serverDetailList
                    .indexWhere((element) =>
                element.serverUrl == withOutPrimaryDataList[a].url)
                    .toInt();
                if (getServeIndex != -1) {
                  identifier.add(Identifier(
                      value: getActivityKeyWiseData
                          .serverDetailList[getServeIndex].objectId,
                      system: FhirUri(getActivityKeyWiseData
                          .serverDetailList[getServeIndex].serverUrl)));
                }
              }
            }
          }
        }

        Observation observation = profiles.createChildActivityCaloriesObservation(
            objectId,
            "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}",
            allSelectedServersUrl[j].patientId,
            getActivityKeyWiseData.activityStartDate ?? DateTime.now(),
            getActivityKeyWiseData.activityEndDate ?? DateTime.now(),
            getActivityKeyWiseData.total ?? 0.0,
            identifierDataList: identifier,isAppleHealthData: isAppleHealthData);

        observationId = await profiles.processResource(
            observation,
            Constant.observation,
            allSelectedServersUrl[j].url,
            allSelectedServersUrl[j].clientId,
            allSelectedServersUrl[j].authToken);

        getActivityKeyWiseData.objectId = observationId;

        if (getActivityKeyWiseData.serverDetailList
            .where((element) => element.objectId == observationId)
            .toList()
            .isEmpty) {
          getActivityKeyWiseData.serverDetailList[getServeIndex].objectId =
              observationId;
          getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl =
              allSelectedServersUrl[j].url;
          getActivityKeyWiseData.serverDetailList[getServeIndex].patientId =
              allSelectedServersUrl[j].patientId;
          getActivityKeyWiseData.serverDetailList[getServeIndex].patientName =
          "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";
        }

        await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);
      }
    }

    var withOutPrimaryData = Utils.getServerListPreference()
        .where((element) =>
    !element.isPrimary && element.isSelected && element.patientId != "")
        .toList();
    if (withOutPrimaryData.isNotEmpty) {
      List<Identifier> identifierDataExtra = [];
      for (int a = 0; a < withOutPrimaryData.length; a++) {
        identifierDataExtra.clear();
        if (withOutPrimaryData[a].isSecure &&
            Utils.isExpiredToken(withOutPrimaryData[a].lastLoggedTime,
                withOutPrimaryData[a].expireTime)) {
          // await Utils.checkTokenExpireTime(withOutPrimaryData[a]);
        }
        withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
            && element.isSelected && element.patientId != "").toList();

        var callAPIWithThisURL = withOutPrimaryData[a].url;

        var getAllObjectIdList = getActivityKeyWiseData.serverDetailList
            .where((element) => element.serverUrl != callAPIWithThisURL)
            .toList();

        if (getAllObjectIdList.isNotEmpty) {
          for (int d = 0; d < getAllObjectIdList.length; d++) {
            identifierDataExtra.add(Identifier(
                value: getAllObjectIdList[d].objectId,
                system: FhirUri(getAllObjectIdList[d].serverUrl)));
          }
        }

        var objectId = "";
        var getServeIndex = getActivityKeyWiseData.serverDetailList
            .indexWhere(
                (element) => element.serverUrl == withOutPrimaryData[a].url)
            .toInt();
        if (getServeIndex != -1) {
          objectId =
              getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ??
                  "";
          getActivityKeyWiseData
              .serverDetailList[getServeIndex].dataSyncServerWise = true;
        }
        if (getActivityKeyWiseData.serverDetailList.isNotEmpty &&
            getActivityKeyWiseData.identifierData.isNotEmpty) {
          var aObject = getActivityKeyWiseData.identifierData
              .indexWhere((element) => element.url == withOutPrimaryData[a].url)
              .toInt();
          if (aObject != -1) {
            objectId =
                getActivityKeyWiseData.identifierData[aObject].objectId ?? "";
          }
        }

        if (identifierDataExtra.isNotEmpty) {

          Observation observation = profiles.createChildActivityCaloriesObservation(
              objectId,
              "${withOutPrimaryData[a].patientFName}${withOutPrimaryData[a].patientLName}",
              withOutPrimaryData[a].patientId,
              getActivityKeyWiseData.activityStartDate ?? DateTime.now(),
              getActivityKeyWiseData.activityEndDate ?? DateTime.now(),
              getActivityKeyWiseData.total ?? 0.0,
              identifierDataList: identifierDataExtra,isAppleHealthData: isAppleHealthData);


          await profiles.processResource(
              observation,
              Constant.observation,
              withOutPrimaryData[a].url,
              withOutPrimaryData[a].clientId,
              withOutPrimaryData[a].authToken);
        }
      }
    }
  }

  static Future<void> createChildActivityPeakHeatRateObservation(String activityName,ActivityTable getActivityKeyWiseData,{bool isAppleHealthData = false}) async {

    PaaProfiles profiles = PaaProfiles();

    var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" &&
        element.isSelected).toList();

    var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
    if(getPrimaryServerData.isNotEmpty){
      allSelectedServersUrl.remove(getPrimaryServerData[0]);
      allSelectedServersUrl.add(getPrimaryServerData[0]);
    }

    for (int j = 0; j < allSelectedServersUrl.length; j++) {
      if (getActivityKeyWiseData.serverDetailList.isNotEmpty) {
        getActivityKeyWiseData.isSync = true;

        await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);

        String observationId = "";

        var objectId = "";
        var getServeIndex = getActivityKeyWiseData.serverDetailList
            .indexWhere(
                (element) => element.serverUrl == allSelectedServersUrl[j].url)
            .toInt();

        if (getServeIndex != -1) {
          objectId =
              getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ??
                  "";
          getActivityKeyWiseData
              .serverDetailList[getServeIndex].dataSyncServerWise = true;
        }

        if (getActivityKeyWiseData.serverDetailList.isNotEmpty &&
            getActivityKeyWiseData.identifierData.isNotEmpty) {
          var a = getActivityKeyWiseData.identifierData
              .indexWhere(
                  (element) => element.url == allSelectedServersUrl[j].url)
              .toInt();
          if (a != -1) {
            objectId = getActivityKeyWiseData.identifierData[a].objectId ?? "";
          }
        }

        List<Identifier> identifier = [];
        if (allSelectedServersUrl[j].isPrimary) {
          var withOutPrimaryDataList = allSelectedServersUrl
              .where((element) => !element.isPrimary)
              .toList();

          if (withOutPrimaryDataList.isNotEmpty) {
            for (int a = 0; a < withOutPrimaryDataList.length; a++) {
              if (getActivityKeyWiseData.serverDetailList.isNotEmpty) {
                var getServeIndex = getActivityKeyWiseData.serverDetailList
                    .indexWhere((element) =>
                element.serverUrl == withOutPrimaryDataList[a].url)
                    .toInt();
                if (getServeIndex != -1) {
                  identifier.add(Identifier(
                      value: getActivityKeyWiseData
                          .serverDetailList[getServeIndex].objectId,
                      system: FhirUri(getActivityKeyWiseData
                          .serverDetailList[getServeIndex].serverUrl)));
                }
              }
            }
          }
        }

        Observation observation = profiles.createChildActivityPeakHeartRateObservation(
            objectId,
            "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}",
            allSelectedServersUrl[j].patientId,
            getActivityKeyWiseData.activityStartDate ?? DateTime.now(),
            getActivityKeyWiseData.activityEndDate ?? DateTime.now(),
            getActivityKeyWiseData.total ?? 0.0,
            identifierDataList: identifier,isAppleHealthData: isAppleHealthData);

        observationId = await profiles.processResource(
            observation,
            Constant.observation,
            allSelectedServersUrl[j].url,
            allSelectedServersUrl[j].clientId,
            allSelectedServersUrl[j].authToken);

        getActivityKeyWiseData.objectId = observationId;

        if (getActivityKeyWiseData.serverDetailList
            .where((element) => element.objectId == observationId)
            .toList()
            .isEmpty) {
          getActivityKeyWiseData.serverDetailList[getServeIndex].objectId =
              observationId;
          getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl =
              allSelectedServersUrl[j].url;
          getActivityKeyWiseData.serverDetailList[getServeIndex].patientId =
              allSelectedServersUrl[j].patientId;
          getActivityKeyWiseData.serverDetailList[getServeIndex].patientName =
          "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";
        }

        await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);
      }
    }

    var withOutPrimaryData = Utils.getServerListPreference()
        .where((element) =>
    !element.isPrimary && element.isSelected && element.patientId != "")
        .toList();
    if (withOutPrimaryData.isNotEmpty) {
      List<Identifier> identifierDataExtra = [];
      for (int a = 0; a < withOutPrimaryData.length; a++) {
        identifierDataExtra.clear();
        if (withOutPrimaryData[a].isSecure &&
            Utils.isExpiredToken(withOutPrimaryData[a].lastLoggedTime,
                withOutPrimaryData[a].expireTime)) {
          // await Utils.checkTokenExpireTime(withOutPrimaryData[a]);
        }
        withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
            && element.isSelected && element.patientId != "").toList();

        var callAPIWithThisURL = withOutPrimaryData[a].url;

        var getAllObjectIdList = getActivityKeyWiseData.serverDetailList
            .where((element) => element.serverUrl != callAPIWithThisURL)
            .toList();

        if (getAllObjectIdList.isNotEmpty) {
          for (int d = 0; d < getAllObjectIdList.length; d++) {
            identifierDataExtra.add(Identifier(
                value: getAllObjectIdList[d].objectId,
                system: FhirUri(getAllObjectIdList[d].serverUrl)));
          }
        }

        var objectId = "";
        var getServeIndex = getActivityKeyWiseData.serverDetailList
            .indexWhere(
                (element) => element.serverUrl == withOutPrimaryData[a].url)
            .toInt();
        if (getServeIndex != -1) {
          objectId =
              getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ??
                  "";
          getActivityKeyWiseData
              .serverDetailList[getServeIndex].dataSyncServerWise = true;
        }
        if (getActivityKeyWiseData.serverDetailList.isNotEmpty &&
            getActivityKeyWiseData.identifierData.isNotEmpty) {
          var aObject = getActivityKeyWiseData.identifierData
              .indexWhere((element) => element.url == withOutPrimaryData[a].url)
              .toInt();
          if (aObject != -1) {
            objectId =
                getActivityKeyWiseData.identifierData[aObject].objectId ?? "";
          }
        }

        if (identifierDataExtra.isNotEmpty) {

          Observation observation = profiles.createChildActivityPeakHeartRateObservation(
              objectId,
              "${withOutPrimaryData[a].patientFName}${withOutPrimaryData[a].patientLName}",
              withOutPrimaryData[a].patientId,
              getActivityKeyWiseData.activityStartDate ?? DateTime.now(),
              getActivityKeyWiseData.activityEndDate ?? DateTime.now(),
              getActivityKeyWiseData.total ?? 0.0,
              identifierDataList: identifierDataExtra,isAppleHealthData: isAppleHealthData);


          await profiles.processResource(
              observation,
              Constant.observation,
              withOutPrimaryData[a].url,
              withOutPrimaryData[a].clientId,
              withOutPrimaryData[a].authToken);
        }
      }
    }
   /* delayCount++;
    if (delayCount == Constant.delayTimeLength) {
      delayCount = 0;
      await Utils.apiCallApplyDelay10second();
    }*/
  }

  static Future<void> createChildActivityTotalMinObservation(String activityName,ActivityTable getActivityKeyWiseData,{bool isAppleHealthData = false}) async {

    PaaProfiles profiles = PaaProfiles();

    var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" &&
        element.isSelected).toList();

    var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
    if(getPrimaryServerData.isNotEmpty){
      allSelectedServersUrl.remove(getPrimaryServerData[0]);
      allSelectedServersUrl.add(getPrimaryServerData[0]);
    }

    for (int j = 0; j < allSelectedServersUrl.length; j++) {
      if (getActivityKeyWiseData.serverDetailList.isNotEmpty) {
        getActivityKeyWiseData.isSync = true;

        await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);

        String observationId = "";

        var objectId = "";
        var getServeIndex = getActivityKeyWiseData.serverDetailList
            .indexWhere(
                (element) => element.serverUrl == allSelectedServersUrl[j].url)
            .toInt();

        if (getServeIndex != -1) {
          objectId =
              getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ??
                  "";
          getActivityKeyWiseData
              .serverDetailList[getServeIndex].dataSyncServerWise = true;
        }

        if (getActivityKeyWiseData.serverDetailList.isNotEmpty &&
            getActivityKeyWiseData.identifierData.isNotEmpty) {
          var a = getActivityKeyWiseData.identifierData
              .indexWhere(
                  (element) => element.url == allSelectedServersUrl[j].url)
              .toInt();
          if (a != -1) {
            objectId = getActivityKeyWiseData.identifierData[a].objectId ?? "";
          }
        }

        List<Identifier> identifier = [];
        if (allSelectedServersUrl[j].isPrimary) {
          var withOutPrimaryDataList = allSelectedServersUrl
              .where((element) => !element.isPrimary)
              .toList();

          if (withOutPrimaryDataList.isNotEmpty) {
            for (int a = 0; a < withOutPrimaryDataList.length; a++) {
              if (getActivityKeyWiseData.serverDetailList.isNotEmpty) {
                var getServeIndex = getActivityKeyWiseData.serverDetailList
                    .indexWhere((element) =>
                element.serverUrl == withOutPrimaryDataList[a].url)
                    .toInt();
                if (getServeIndex != -1) {
                  identifier.add(Identifier(
                      value: getActivityKeyWiseData
                          .serverDetailList[getServeIndex].objectId,
                      system: FhirUri(getActivityKeyWiseData
                          .serverDetailList[getServeIndex].serverUrl)));
                }
              }
            }
          }
        }

        Observation observation = profiles.createChildActivityTotalMinObservation(
            objectId,
            "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}",
            allSelectedServersUrl[j].patientId,
            getActivityKeyWiseData.activityStartDate ?? DateTime.now(),
            getActivityKeyWiseData.activityEndDate ?? DateTime.now(),
            getActivityKeyWiseData.total ?? 0.0,getActivityKeyWiseData.notes ?? "",
            identifierDataList: identifier,isAppleHealthData: isAppleHealthData);

        observationId = await profiles.processResource(
            observation,
            Constant.observation,
            allSelectedServersUrl[j].url,
            allSelectedServersUrl[j].clientId,
            allSelectedServersUrl[j].authToken);

        getActivityKeyWiseData.objectId = observationId;

        if (getActivityKeyWiseData.serverDetailList
            .where((element) => element.objectId == observationId)
            .toList()
            .isEmpty) {
          getActivityKeyWiseData.serverDetailList[getServeIndex].objectId =
              observationId;
          getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl =
              allSelectedServersUrl[j].url;
          getActivityKeyWiseData.serverDetailList[getServeIndex].patientId =
              allSelectedServersUrl[j].patientId;
          getActivityKeyWiseData.serverDetailList[getServeIndex].patientName =
          "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";
        }

        await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);
      }
    }

    var withOutPrimaryData = Utils.getServerListPreference()
        .where((element) =>
    !element.isPrimary && element.isSelected && element.patientId != "")
        .toList();
    if (withOutPrimaryData.isNotEmpty) {
      List<Identifier> identifierDataExtra = [];
      for (int a = 0; a < withOutPrimaryData.length; a++) {
        identifierDataExtra.clear();
        if (withOutPrimaryData[a].isSecure &&
            Utils.isExpiredToken(withOutPrimaryData[a].lastLoggedTime,
                withOutPrimaryData[a].expireTime)) {
          // await Utils.checkTokenExpireTime(withOutPrimaryData[a]);
        }
        withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
            && element.isSelected && element.patientId != "").toList();

        var callAPIWithThisURL = withOutPrimaryData[a].url;

        var getAllObjectIdList = getActivityKeyWiseData.serverDetailList
            .where((element) => element.serverUrl != callAPIWithThisURL)
            .toList();

        if (getAllObjectIdList.isNotEmpty) {
          for (int d = 0; d < getAllObjectIdList.length; d++) {
            identifierDataExtra.add(Identifier(
                value: getAllObjectIdList[d].objectId,
                system: FhirUri(getAllObjectIdList[d].serverUrl)));
          }
        }

        var objectId = "";
        var getServeIndex = getActivityKeyWiseData.serverDetailList
            .indexWhere(
                (element) => element.serverUrl == withOutPrimaryData[a].url)
            .toInt();
        if (getServeIndex != -1) {
          objectId =
              getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ??
                  "";
          getActivityKeyWiseData
              .serverDetailList[getServeIndex].dataSyncServerWise = true;
        }
        if (getActivityKeyWiseData.serverDetailList.isNotEmpty &&
            getActivityKeyWiseData.identifierData.isNotEmpty) {
          var aObject = getActivityKeyWiseData.identifierData
              .indexWhere((element) => element.url == withOutPrimaryData[a].url)
              .toInt();
          if (aObject != -1) {
            objectId =
                getActivityKeyWiseData.identifierData[aObject].objectId ?? "";
          }
        }

        if (identifierDataExtra.isNotEmpty) {

          Observation observation = profiles.createChildActivityTotalMinObservation(
              objectId,
              "${withOutPrimaryData[a].patientFName}${withOutPrimaryData[a].patientLName}",
              withOutPrimaryData[a].patientId,
              getActivityKeyWiseData.activityStartDate ?? DateTime.now(),
              getActivityKeyWiseData.activityEndDate ?? DateTime.now(),
              getActivityKeyWiseData.total ?? 0.0,getActivityKeyWiseData.notes ?? "",
              identifierDataList: identifierDataExtra,isAppleHealthData: isAppleHealthData);


          await profiles.processResource(
              observation,
              Constant.observation,
              withOutPrimaryData[a].url,
              withOutPrimaryData[a].clientId,
              withOutPrimaryData[a].authToken);
        }
      }
    }
  }

  static Future<void> createChildActivityModerateMinObservation(String activityName,ActivityTable getActivityKeyWiseData) async {

    PaaProfiles profiles = PaaProfiles();

    var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" &&
        element.isSelected).toList();

    var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
    if(getPrimaryServerData.isNotEmpty){
      allSelectedServersUrl.remove(getPrimaryServerData[0]);
      allSelectedServersUrl.add(getPrimaryServerData[0]);
    }

    for (int j = 0; j < allSelectedServersUrl.length; j++) {
      if (getActivityKeyWiseData.serverDetailListModMin.isNotEmpty) {
        getActivityKeyWiseData.isSync = true;

        await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);

        String observationId = "";

        var objectId = "";
        var getServeIndex = getActivityKeyWiseData.serverDetailListModMin
            .indexWhere(
                (element) => element.modServerUrl == allSelectedServersUrl[j].url)
            .toInt();

        if (getServeIndex != -1) {
          objectId =
              getActivityKeyWiseData.serverDetailListModMin[getServeIndex].modObjectId ??
                  "";
          getActivityKeyWiseData
              .serverDetailListModMin[getServeIndex].modDataSyncServerWise = true;
        }

        if (getActivityKeyWiseData.serverDetailListModMin.isNotEmpty &&
            getActivityKeyWiseData.identifierDataModMin.isNotEmpty) {
          var a = getActivityKeyWiseData.identifierDataModMin
              .indexWhere(
                  (element) => element.url == allSelectedServersUrl[j].url)
              .toInt();
          if (a != -1) {
            objectId = getActivityKeyWiseData.identifierDataModMin[a].objectId ?? "";
          }
        }

        List<Identifier> identifier = [];
        if (allSelectedServersUrl[j].isPrimary) {
          var withOutPrimaryDataList = allSelectedServersUrl
              .where((element) => !element.isPrimary)
              .toList();

          if (withOutPrimaryDataList.isNotEmpty) {
            for (int a = 0; a < withOutPrimaryDataList.length; a++) {
              if (getActivityKeyWiseData.serverDetailListModMin.isNotEmpty) {
                var getServeIndex = getActivityKeyWiseData.serverDetailListModMin
                    .indexWhere((element) =>
                element.modServerUrl == withOutPrimaryDataList[a].url)
                    .toInt();
                if (getServeIndex != -1) {
                  identifier.add(Identifier(
                      value: getActivityKeyWiseData
                          .serverDetailListModMin[getServeIndex].modObjectId,
                      system: FhirUri(getActivityKeyWiseData
                          .serverDetailListModMin[getServeIndex].modServerUrl)));
                }
              }
            }
          }
        }

        Observation observation = profiles.createChildActivityModerateMinObservation(
            objectId,
            "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}",
            allSelectedServersUrl[j].patientId,
            getActivityKeyWiseData.activityStartDate ?? DateTime.now(),
            getActivityKeyWiseData.activityEndDate ?? DateTime.now(),
            getActivityKeyWiseData.value1 ?? 0.0,
            identifierDataList: identifier);

        observationId = await profiles.processResource(
            observation,
            Constant.observation,
            allSelectedServersUrl[j].url,
            allSelectedServersUrl[j].clientId,
            allSelectedServersUrl[j].authToken);

        getActivityKeyWiseData.objectId = observationId;

        if (getActivityKeyWiseData.serverDetailListModMin
            .where((element) => element.modObjectId == observationId)
            .toList()
            .isEmpty) {
          getActivityKeyWiseData.serverDetailListModMin[getServeIndex].modObjectId =
              observationId;
          getActivityKeyWiseData.serverDetailListModMin[getServeIndex].modServerUrl =
              allSelectedServersUrl[j].url;
          getActivityKeyWiseData.serverDetailListModMin[getServeIndex].modPatientId =
              allSelectedServersUrl[j].patientId;
          getActivityKeyWiseData.serverDetailListModMin[getServeIndex].modPatientName =
          "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";
        }

        await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);
      }
    }

    var withOutPrimaryData = Utils.getServerListPreference()
        .where((element) =>
    !element.isPrimary && element.isSelected && element.patientId != "")
        .toList();
    if (withOutPrimaryData.isNotEmpty) {
      List<Identifier> identifierDataExtra = [];
      for (int a = 0; a < withOutPrimaryData.length; a++) {
        identifierDataExtra.clear();
        if (withOutPrimaryData[a].isSecure &&
            Utils.isExpiredToken(withOutPrimaryData[a].lastLoggedTime,
                withOutPrimaryData[a].expireTime)) {
          // await Utils.checkTokenExpireTime(withOutPrimaryData[a]);
        }
        withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
            && element.isSelected && element.patientId != "").toList();

        var callAPIWithThisURL = withOutPrimaryData[a].url;

        var getAllObjectIdList = getActivityKeyWiseData.serverDetailListModMin
            .where((element) => element.modServerUrl != callAPIWithThisURL)
            .toList();

        if (getAllObjectIdList.isNotEmpty) {
          for (int d = 0; d < getAllObjectIdList.length; d++) {
            identifierDataExtra.add(Identifier(
                value: getAllObjectIdList[d].modObjectId,
                system: FhirUri(getAllObjectIdList[d].modServerUrl)));
          }
        }

        var objectId = "";
        var getServeIndex = getActivityKeyWiseData.serverDetailListModMin
            .indexWhere(
                (element) => element.modServerUrl == withOutPrimaryData[a].url)
            .toInt();
        if (getServeIndex != -1) {
          objectId =
              getActivityKeyWiseData.serverDetailListModMin[getServeIndex].modObjectId ??
                  "";
          getActivityKeyWiseData
              .serverDetailListModMin[getServeIndex].modDataSyncServerWise = true;
        }
        if (getActivityKeyWiseData.serverDetailListModMin.isNotEmpty &&
            getActivityKeyWiseData.identifierDataModMin.isNotEmpty) {
          var aObject = getActivityKeyWiseData.identifierDataModMin
              .indexWhere((element) => element.url == withOutPrimaryData[a].url)
              .toInt();
          if (aObject != -1) {
            objectId =
                getActivityKeyWiseData.identifierDataModMin[aObject].objectId ?? "";
          }
        }

        if (identifierDataExtra.isNotEmpty) {

          Observation observation = profiles.createChildActivityModerateMinObservation(
              objectId,
              "${withOutPrimaryData[a].patientFName}${withOutPrimaryData[a].patientLName}",
              withOutPrimaryData[a].patientId,
              getActivityKeyWiseData.activityStartDate ?? DateTime.now(),
              getActivityKeyWiseData.activityEndDate ?? DateTime.now(),
              getActivityKeyWiseData.value1 ?? 0.0,
              identifierDataList: identifierDataExtra);


          await profiles.processResource(
              observation,
              Constant.observation,
              withOutPrimaryData[a].url,
              withOutPrimaryData[a].clientId,
              withOutPrimaryData[a].authToken);
        }
      }
    }
  }

  static Future<void> createChildActivityVigMinObservation(String activityName,ActivityTable getActivityKeyWiseData) async {

    PaaProfiles profiles = PaaProfiles();

    var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" &&
        element.isSelected).toList();

    var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
    if(getPrimaryServerData.isNotEmpty){
      allSelectedServersUrl.remove(getPrimaryServerData[0]);
      allSelectedServersUrl.add(getPrimaryServerData[0]);
    }

    for (int j = 0; j < allSelectedServersUrl.length; j++) {
      if (getActivityKeyWiseData.serverDetailListVigMin.isNotEmpty) {
        getActivityKeyWiseData.isSync = true;

        await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);

        String observationId = "";

        var objectId = "";
        var getServeIndex = getActivityKeyWiseData.serverDetailListVigMin
            .indexWhere(
                (element) => element.vigServerUrl == allSelectedServersUrl[j].url)
            .toInt();

        if (getServeIndex != -1) {
          objectId =
              getActivityKeyWiseData.serverDetailListVigMin[getServeIndex].vigObjectId ??
                  "";
          getActivityKeyWiseData
              .serverDetailListVigMin[getServeIndex].vigDataSyncServerWise = true;
        }

        if (getActivityKeyWiseData.serverDetailListVigMin.isNotEmpty &&
            getActivityKeyWiseData.identifierDataVigMin.isNotEmpty) {
          var a = getActivityKeyWiseData.identifierDataVigMin
              .indexWhere(
                  (element) => element.url == allSelectedServersUrl[j].url)
              .toInt();
          if (a != -1) {
            objectId = getActivityKeyWiseData.identifierDataVigMin[a].objectId ?? "";
          }
        }

        List<Identifier> identifier = [];
        if (allSelectedServersUrl[j].isPrimary) {
          var withOutPrimaryDataList = allSelectedServersUrl
              .where((element) => !element.isPrimary)
              .toList();

          if (withOutPrimaryDataList.isNotEmpty) {
            for (int a = 0; a < withOutPrimaryDataList.length; a++) {
              if (getActivityKeyWiseData.serverDetailListVigMin.isNotEmpty) {
                var getServeIndex = getActivityKeyWiseData.serverDetailListVigMin
                    .indexWhere((element) =>
                element.vigServerUrl == withOutPrimaryDataList[a].url)
                    .toInt();
                if (getServeIndex != -1) {
                  identifier.add(Identifier(
                      value: getActivityKeyWiseData
                          .serverDetailListVigMin[getServeIndex].vigObjectId,
                      system: FhirUri(getActivityKeyWiseData
                          .serverDetailListVigMin[getServeIndex].vigServerUrl)));
                }
              }
            }
          }
        }

        Observation observation = profiles.createChildActivityVigorousMinObservation(
            objectId,
            "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}",
            allSelectedServersUrl[j].patientId,
            getActivityKeyWiseData.activityStartDate ?? DateTime.now(),
            getActivityKeyWiseData.activityEndDate ?? DateTime.now(),
            getActivityKeyWiseData.value2 ?? 0.0,
            identifierDataList: identifier);

        observationId = await profiles.processResource(
            observation,
            Constant.observation,
            allSelectedServersUrl[j].url,
            allSelectedServersUrl[j].clientId,
            allSelectedServersUrl[j].authToken);

        getActivityKeyWiseData.objectId = observationId;

        if (getActivityKeyWiseData.serverDetailListVigMin
            .where((element) => element.vigObjectId == observationId)
            .toList()
            .isEmpty) {
          getActivityKeyWiseData.serverDetailListVigMin[getServeIndex].vigObjectId =
              observationId;
          getActivityKeyWiseData.serverDetailListVigMin[getServeIndex].vigServerUrl =
              allSelectedServersUrl[j].url;
          getActivityKeyWiseData.serverDetailListVigMin[getServeIndex].vigPatientId =
              allSelectedServersUrl[j].patientId;
          getActivityKeyWiseData.serverDetailListVigMin[getServeIndex].vigPatientName =
          "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";
        }

        await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);
      }
    }

    var withOutPrimaryData = Utils.getServerListPreference()
        .where((element) =>
    !element.isPrimary && element.isSelected && element.patientId != "")
        .toList();
    if (withOutPrimaryData.isNotEmpty) {
      List<Identifier> identifierDataExtra = [];
      for (int a = 0; a < withOutPrimaryData.length; a++) {
        identifierDataExtra.clear();
        if (withOutPrimaryData[a].isSecure &&
            Utils.isExpiredToken(withOutPrimaryData[a].lastLoggedTime,
                withOutPrimaryData[a].expireTime)) {
          // await Utils.checkTokenExpireTime(withOutPrimaryData[a]);
        }
        withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
            && element.isSelected && element.patientId != "").toList();

        var callAPIWithThisURL = withOutPrimaryData[a].url;

        var getAllObjectIdList = getActivityKeyWiseData.serverDetailListVigMin
            .where((element) => element.vigServerUrl != callAPIWithThisURL)
            .toList();

        if (getAllObjectIdList.isNotEmpty) {
          for (int d = 0; d < getAllObjectIdList.length; d++) {
            identifierDataExtra.add(Identifier(
                value: getAllObjectIdList[d].vigObjectId,
                system: FhirUri(getAllObjectIdList[d].vigServerUrl)));
          }
        }

        var objectId = "";
        var getServeIndex = getActivityKeyWiseData.serverDetailListVigMin
            .indexWhere(
                (element) => element.vigServerUrl == withOutPrimaryData[a].url)
            .toInt();
        if (getServeIndex != -1) {
          objectId =
              getActivityKeyWiseData.serverDetailListVigMin[getServeIndex].vigObjectId ??
                  "";
          getActivityKeyWiseData
              .serverDetailListVigMin[getServeIndex].vigDataSyncServerWise = true;
        }
        if (getActivityKeyWiseData.serverDetailListVigMin.isNotEmpty &&
            getActivityKeyWiseData.identifierDataVigMin.isNotEmpty) {
          var aObject = getActivityKeyWiseData.identifierDataVigMin
              .indexWhere((element) => element.url == withOutPrimaryData[a].url)
              .toInt();
          if (aObject != -1) {
            objectId =
                getActivityKeyWiseData.identifierDataVigMin[aObject].objectId ?? "";
          }
        }

        if (identifierDataExtra.isNotEmpty) {

          Observation observation = profiles.createChildActivityVigorousMinObservation(
              objectId,
              "${withOutPrimaryData[a].patientFName}${withOutPrimaryData[a].patientLName}",
              withOutPrimaryData[a].patientId,
              getActivityKeyWiseData.activityStartDate ?? DateTime.now(),
              getActivityKeyWiseData.activityEndDate ?? DateTime.now(),
              getActivityKeyWiseData.value2 ?? 0.0,
              identifierDataList: identifierDataExtra);


          await profiles.processResource(
              observation,
              Constant.observation,
              withOutPrimaryData[a].url,
              withOutPrimaryData[a].clientId,
              withOutPrimaryData[a].authToken);
        }
      }
    }
  }

  static Future<void> createChildActivityStepsObservation(String activityName,ActivityTable getActivityKeyWiseData,{bool isAppleHealthData = false}) async {

    PaaProfiles profiles = PaaProfiles();

    var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" &&
        element.isSelected).toList();

    var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
    if(getPrimaryServerData.isNotEmpty){
      allSelectedServersUrl.remove(getPrimaryServerData[0]);
      allSelectedServersUrl.add(getPrimaryServerData[0]);
    }

    for (int j = 0; j < allSelectedServersUrl.length; j++) {
      if (getActivityKeyWiseData.serverDetailList.isNotEmpty) {
        getActivityKeyWiseData.isSync = true;

        await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);

        String observationId = "";

        var objectId = "";
        var getServeIndex = getActivityKeyWiseData.serverDetailList
            .indexWhere(
                (element) => element.serverUrl == allSelectedServersUrl[j].url)
            .toInt();

        if (getServeIndex != -1) {
          objectId =
              getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ??
                  "";
          getActivityKeyWiseData
              .serverDetailList[getServeIndex].dataSyncServerWise = true;
        }

        if (getActivityKeyWiseData.serverDetailList.isNotEmpty &&
            getActivityKeyWiseData.identifierData.isNotEmpty) {
          var a = getActivityKeyWiseData.identifierData
              .indexWhere(
                  (element) => element.url == allSelectedServersUrl[j].url)
              .toInt();
          if (a != -1) {
            objectId = getActivityKeyWiseData.identifierData[a].objectId ?? "";
          }
        }

        List<Identifier> identifier = [];
        if (allSelectedServersUrl[j].isPrimary) {
          var withOutPrimaryDataList = allSelectedServersUrl
              .where((element) => !element.isPrimary)
              .toList();

          if (withOutPrimaryDataList.isNotEmpty) {
            for (int a = 0; a < withOutPrimaryDataList.length; a++) {
              if (getActivityKeyWiseData.serverDetailList.isNotEmpty) {
                var getServeIndex = getActivityKeyWiseData.serverDetailList
                    .indexWhere((element) =>
                element.serverUrl == withOutPrimaryDataList[a].url)
                    .toInt();
                if (getServeIndex != -1) {
                  identifier.add(Identifier(
                      value: getActivityKeyWiseData
                          .serverDetailList[getServeIndex].objectId,
                      system: FhirUri(getActivityKeyWiseData
                          .serverDetailList[getServeIndex].serverUrl)));
                }
              }
            }
          }
        }

        Observation observation = profiles.createChildActivityStepsObservation(
            objectId,
            "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}",
            allSelectedServersUrl[j].patientId,
            getActivityKeyWiseData.activityStartDate ?? DateTime.now(),
            getActivityKeyWiseData.activityEndDate ?? DateTime.now(),
            getActivityKeyWiseData.total ?? 0.0,
            identifierDataList: identifier,isAppleHealthData: isAppleHealthData);

        observationId = await profiles.processResource(
            observation,
            Constant.observation,
            allSelectedServersUrl[j].url,
            allSelectedServersUrl[j].clientId,
            allSelectedServersUrl[j].authToken);

        getActivityKeyWiseData.objectId = observationId;

        if (getActivityKeyWiseData.serverDetailList
            .where((element) => element.objectId == observationId)
            .toList()
            .isEmpty) {
          getActivityKeyWiseData.serverDetailList[getServeIndex].objectId =
              observationId;
          getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl =
              allSelectedServersUrl[j].url;
          getActivityKeyWiseData.serverDetailList[getServeIndex].patientId =
              allSelectedServersUrl[j].patientId;
          getActivityKeyWiseData.serverDetailList[getServeIndex].patientName =
          "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";
        }

        await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);
      }
    }

    var withOutPrimaryData = Utils.getServerListPreference()
        .where((element) =>
    !element.isPrimary && element.isSelected && element.patientId != "")
        .toList();
    if (withOutPrimaryData.isNotEmpty) {
      List<Identifier> identifierDataExtra = [];
      for (int a = 0; a < withOutPrimaryData.length; a++) {
        identifierDataExtra.clear();
        withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
            && element.isSelected && element.patientId != "").toList();

        var callAPIWithThisURL = withOutPrimaryData[a].url;

        var getAllObjectIdList = getActivityKeyWiseData.serverDetailList
            .where((element) => element.serverUrl != callAPIWithThisURL)
            .toList();

        if (getAllObjectIdList.isNotEmpty) {
          for (int d = 0; d < getAllObjectIdList.length; d++) {
            identifierDataExtra.add(Identifier(
                value: getAllObjectIdList[d].objectId,
                system: FhirUri(getAllObjectIdList[d].serverUrl)));
          }
        }

        var objectId = "";
        var getServeIndex = getActivityKeyWiseData.serverDetailList
            .indexWhere(
                (element) => element.serverUrl == withOutPrimaryData[a].url)
            .toInt();
        if (getServeIndex != -1) {
          objectId =
              getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ??
                  "";
          getActivityKeyWiseData
              .serverDetailList[getServeIndex].dataSyncServerWise = true;
        }
        if (getActivityKeyWiseData.serverDetailList.isNotEmpty &&
            getActivityKeyWiseData.identifierData.isNotEmpty) {
          var aObject = getActivityKeyWiseData.identifierData
              .indexWhere((element) => element.url == withOutPrimaryData[a].url)
              .toInt();
          if (aObject != -1) {
            objectId =
                getActivityKeyWiseData.identifierData[aObject].objectId ?? "";
          }
        }

        if (identifierDataExtra.isNotEmpty) {

          Observation observation = profiles.createChildActivityStepsObservation(
              objectId,
              "${withOutPrimaryData[a].patientFName}${withOutPrimaryData[a].patientLName}",
              withOutPrimaryData[a].patientId,
              getActivityKeyWiseData.activityStartDate ?? DateTime.now(),
              getActivityKeyWiseData.activityEndDate ?? DateTime.now(),
              getActivityKeyWiseData.total ?? 0.0,
              identifierDataList: identifierDataExtra,isAppleHealthData: isAppleHealthData);


          await profiles.processResource(
              observation,
              Constant.observation,
              withOutPrimaryData[a].url,
              withOutPrimaryData[a].clientId,
              withOutPrimaryData[a].authToken);
        }
      }
    }
  }

  static Future<void> createChildActivityExObservation(String activityName,ActivityTable getActivityKeyWiseData,{bool isAppleHealthData = false}) async {

    PaaProfiles profiles = PaaProfiles();

    var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" &&
        element.isSelected).toList();

    var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
    if(getPrimaryServerData.isNotEmpty){
      allSelectedServersUrl.remove(getPrimaryServerData[0]);
      allSelectedServersUrl.add(getPrimaryServerData[0]);
    }

    for (int j = 0; j < allSelectedServersUrl.length; j++) {
      if (getActivityKeyWiseData.serverDetailList.isNotEmpty) {
        getActivityKeyWiseData.isSync = true;

        await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);

        String observationId = "";

        var objectId = "";
        var getServeIndex = getActivityKeyWiseData.serverDetailList
            .indexWhere(
                (element) => element.serverUrl == allSelectedServersUrl[j].url)
            .toInt();

        if (getServeIndex != -1) {
          objectId =
              getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ??
                  "";
          getActivityKeyWiseData
              .serverDetailList[getServeIndex].dataSyncServerWise = true;
        }

        if (getActivityKeyWiseData.serverDetailList.isNotEmpty &&
            getActivityKeyWiseData.identifierData.isNotEmpty) {
          var a = getActivityKeyWiseData.identifierData
              .indexWhere(
                  (element) => element.url == allSelectedServersUrl[j].url)
              .toInt();
          if (a != -1) {
            objectId = getActivityKeyWiseData.identifierData[a].objectId ?? "";
          }
        }

        List<Identifier> identifier = [];
        if (allSelectedServersUrl[j].isPrimary) {
          var withOutPrimaryDataList = allSelectedServersUrl
              .where((element) => !element.isPrimary)
              .toList();

          if (withOutPrimaryDataList.isNotEmpty) {
            for (int a = 0; a < withOutPrimaryDataList.length; a++) {
              if (getActivityKeyWiseData.serverDetailList.isNotEmpty) {
                var getServeIndex = getActivityKeyWiseData.serverDetailList
                    .indexWhere((element) =>
                element.serverUrl == withOutPrimaryDataList[a].url)
                    .toInt();
                if (getServeIndex != -1) {
                  identifier.add(Identifier(
                      value: getActivityKeyWiseData
                          .serverDetailList[getServeIndex].objectId,
                      system: FhirUri(getActivityKeyWiseData
                          .serverDetailList[getServeIndex].serverUrl)));
                }
              }
            }
          }
        }

        var experienceCode = "";
        var experienceDisplay = "";
        try {
          if ((getActivityKeyWiseData.smileyType?.toInt() ?? Constant.defaultSmileyType) == -3) {
            experienceDisplay = Constant.smiley1Title;
          } else if ((getActivityKeyWiseData.smileyType?.toInt() ?? Constant.defaultSmileyType) == -2) {
            experienceDisplay = Constant.smiley2Title;
          } else if ((getActivityKeyWiseData.smileyType?.toInt() ?? Constant.defaultSmileyType) == -1) {
            experienceDisplay = Constant.smiley3Title;
          } else if ((getActivityKeyWiseData.smileyType?.toInt() ?? Constant.defaultSmileyType) == 0) {
            experienceDisplay = Constant.smiley4Title;
          } else if ((getActivityKeyWiseData.smileyType?.toInt() ?? Constant.defaultSmileyType) == 1) {
            experienceDisplay = Constant.smiley5Title;
          } else if ((getActivityKeyWiseData.smileyType?.toInt() ?? Constant.defaultSmileyType) == 2) {
            experienceDisplay = Constant.smiley6Title;
          } else if ((getActivityKeyWiseData.smileyType?.toInt() ?? Constant.defaultSmileyType) == 3) {
            experienceDisplay = Constant.smiley7Title;
          }
          experienceCode = (getActivityKeyWiseData.smileyType?.toInt() ?? Constant.defaultSmileyType).toString();
        } catch (e) {
          experienceCode = "0";
          experienceDisplay = Constant.smiley4Title;
          Debug.printLog(e.toString());
        }
        Observation observation = profiles.createChildActivityExObservation(
            objectId,
            "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}",
            allSelectedServersUrl[j].patientId,
            getActivityKeyWiseData.activityStartDate ?? DateTime.now(),
            getActivityKeyWiseData.activityEndDate ?? DateTime.now(),
            experienceCode,experienceDisplay,
            identifierDataList: identifier,isAppleHealthData: isAppleHealthData);

        observationId = await profiles.processResource(
            observation,
            Constant.observation,
            allSelectedServersUrl[j].url,
            allSelectedServersUrl[j].clientId,
            allSelectedServersUrl[j].authToken);

        getActivityKeyWiseData.objectId = observationId;

        if (getActivityKeyWiseData.serverDetailList
            .where((element) => element.objectId == observationId)
            .toList()
            .isEmpty) {
          getActivityKeyWiseData.serverDetailList[getServeIndex].objectId =
              observationId;
          getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl =
              allSelectedServersUrl[j].url;
          getActivityKeyWiseData.serverDetailList[getServeIndex].patientId =
              allSelectedServersUrl[j].patientId;
          getActivityKeyWiseData.serverDetailList[getServeIndex].patientName =
          "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";
        }

        await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);
      }
    }

    var withOutPrimaryData = Utils.getServerListPreference()
        .where((element) =>
    !element.isPrimary && element.isSelected && element.patientId != "")
        .toList();
    if (withOutPrimaryData.isNotEmpty) {
      List<Identifier> identifierDataExtra = [];
      for (int a = 0; a < withOutPrimaryData.length; a++) {
        identifierDataExtra.clear();
        withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
            && element.isSelected && element.patientId != "").toList();

        var callAPIWithThisURL = withOutPrimaryData[a].url;

        var getAllObjectIdList = getActivityKeyWiseData.serverDetailList
            .where((element) => element.serverUrl != callAPIWithThisURL)
            .toList();

        if (getAllObjectIdList.isNotEmpty) {
          for (int d = 0; d < getAllObjectIdList.length; d++) {
            identifierDataExtra.add(Identifier(
                value: getAllObjectIdList[d].objectId,
                system: FhirUri(getAllObjectIdList[d].serverUrl)));
          }
        }

        var objectId = "";
        var getServeIndex = getActivityKeyWiseData.serverDetailList
            .indexWhere(
                (element) => element.serverUrl == withOutPrimaryData[a].url)
            .toInt();
        if (getServeIndex != -1) {
          objectId =
              getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ??
                  "";
          getActivityKeyWiseData
              .serverDetailList[getServeIndex].dataSyncServerWise = true;
        }
        if (getActivityKeyWiseData.serverDetailList.isNotEmpty &&
            getActivityKeyWiseData.identifierData.isNotEmpty) {
          var aObject = getActivityKeyWiseData.identifierData
              .indexWhere((element) => element.url == withOutPrimaryData[a].url)
              .toInt();
          if (aObject != -1) {
            objectId =
                getActivityKeyWiseData.identifierData[aObject].objectId ?? "";
          }
        }

        if (identifierDataExtra.isNotEmpty) {
          var experienceCode = "";
          var experienceDisplay = "";
          try {
            if ((getActivityKeyWiseData.smileyType?.toInt() ?? Constant.defaultSmileyType) == -3) {
              experienceDisplay = Constant.smiley1Title;
            } else if ((getActivityKeyWiseData.smileyType?.toInt() ?? Constant.defaultSmileyType) == -2) {
              experienceDisplay = Constant.smiley2Title;
            } else if ((getActivityKeyWiseData.smileyType?.toInt() ?? Constant.defaultSmileyType) == -1) {
              experienceDisplay = Constant.smiley3Title;
            } else if ((getActivityKeyWiseData.smileyType?.toInt() ?? Constant.defaultSmileyType) == 0) {
              experienceDisplay = Constant.smiley4Title;
            } else if ((getActivityKeyWiseData.smileyType?.toInt() ?? Constant.defaultSmileyType) == 1) {
              experienceDisplay = Constant.smiley5Title;
            } else if ((getActivityKeyWiseData.smileyType?.toInt() ?? Constant.defaultSmileyType) == 2) {
              experienceDisplay = Constant.smiley6Title;
            } else if ((getActivityKeyWiseData.smileyType?.toInt() ?? Constant.defaultSmileyType) == 3) {
              experienceDisplay = Constant.smiley7Title;
            }
            experienceCode = (getActivityKeyWiseData.smileyType?.toInt() ?? Constant.defaultSmileyType).toString();
          } catch (e) {
            experienceCode = "0";
            experienceDisplay = Constant.smiley4Title;
            Debug.printLog(e.toString());
          }
          Observation observation = profiles.createChildActivityExObservation(
              objectId,
              "${withOutPrimaryData[a].patientFName}${withOutPrimaryData[a].patientLName}",
              withOutPrimaryData[a].patientId,
              getActivityKeyWiseData.activityStartDate ?? DateTime.now(),
              getActivityKeyWiseData.activityEndDate ?? DateTime.now(),
              experienceCode,experienceDisplay,
              identifierDataList: identifierDataExtra,isAppleHealthData: isAppleHealthData);


          await profiles.processResource(
              observation,
              Constant.observation,
              withOutPrimaryData[a].url,
              withOutPrimaryData[a].clientId,
              withOutPrimaryData[a].authToken);
        }
      }
    }
  }
  ///Goal
  static Future<String> callApiForGoalSyncData(List<GoalSyncDataModel> allSyncingData) async {

    PaaProfiles profiles = PaaProfiles();
    String objectId = "";
    /// Here you all data that we want to send in to backend ==>> allSyncingData
    for (int i = 0; i < allSyncingData.length; i++) {
      /// You can start your API call from here
      // GoalTableData goalSingleData = await DataBaseHelper.shared.getGoalDataById(allSyncingData[i].keyId);
      Goal goal = profiles.createGoal(allSyncingData[i]);
      // String goalId = await profiles.processGoal(goal);
      String goalId = await profiles.processGoalMultiServer(goal,allSyncingData[i]);
      print("Goal Id --- >"+goalId);
      if(goalId == "null" || goalId == "" || goalId == "NULL" || goalId == "Null"){
        // await Utils.showErrorDialog(Get.context!,Constant.txtError,Constant.txtErrorGoalNotCreated);
        // return "";
      }else{
        objectId = goalId;
      }
      // return objectId;
      // goalSingleData.objectId = goalId;
      // goalSingleData.isSync = true;
      // await DataBaseHelper.shared.updateGoalData(goalSingleData);
    }
    return objectId;
  }

  ///isFromRefresh = When we tap on refresh button in monthly screen
  static Future<void> dataSyncingProcess(bool isFromTrackingChart,{DateTime? startDate,DateTime? endDate,bool isFromRefresh = false}) async {
    List<SyncMonthlyActivityData> allSyncingData = [];
    if(isFromTrackingChart) {
      await Syncing.getAndSetSyncActivityData(allSyncingData);
    }else {
      await Syncing.getAndSetSyncMonthlyData(allSyncingData,isFromRefresh: isFromRefresh,startDate: startDate,endDate: endDate);
    }

    Debug.printLog("dataSyncingProcess..$isFromTrackingChart ${allSyncingData.length}");

    if(startDate != null && endDate != null && isFromTrackingChart){
      allSyncingData = allSyncingData.where((element) => element.startDate!.isAfter(startDate) && element.startDate!.isBefore(endDate)).toList();
    }
    Debug.printLog("allSyncingData....$allSyncingData");
    await Utils.isExpireTokenAPICall(Constant.screenTypeBottom,(value) async {
      if(!value){
        if(allSyncingData.isNotEmpty) {
          if(isFromTrackingChart) {
            await Syncing.observationSyncDataCalories(allSyncingData);
            await Syncing.observationSyncDataSteps(allSyncingData);
            await Syncing.observationSyncDataRestHeart(allSyncingData);
            await Syncing.observationSyncDataPeakHeart(allSyncingData);
            // await Syncing.observationSyncDataExperience(allSyncingData);
            await Syncing.observationSyncDataTotalMin(allSyncingData);
            // await Syncing.observationSyncDataModMin(allSyncingData);
            // await Syncing.observationSyncDataVigMin(allSyncingData);
            // await Syncing.observationSyncDataStrengthBox(allSyncingData);
          }else{
            await Syncing.observationSyncDataDaysPerWeeks(allSyncingData);
            await Syncing.observationSyncDataMinPerDay(allSyncingData);
            await Syncing.observationSyncDataMinPerWeek(allSyncingData);
            await Syncing.observationSyncDataStrengthDaysPerWeek(allSyncingData);
          }

        }
      }
    }).then((value) async  {
      if(allSyncingData.isNotEmpty) {
        if(isFromTrackingChart) {
          await Syncing.observationSyncDataCalories(allSyncingData);
          await Syncing.observationSyncDataSteps(allSyncingData);
          await Syncing.observationSyncDataRestHeart(allSyncingData);
          await Syncing.observationSyncDataPeakHeart(allSyncingData);
          // await Syncing.observationSyncDataExperience(allSyncingData);
          await Syncing.observationSyncDataTotalMin(allSyncingData);
          // await Syncing.observationSyncDataModMin(allSyncingData);
          // await Syncing.observationSyncDataVigMin(allSyncingData);
          // await Syncing.observationSyncDataStrengthBox(allSyncingData);
        }else{
          await Syncing.observationSyncDataDaysPerWeeks(allSyncingData);
          await Syncing.observationSyncDataMinPerDay(allSyncingData);
          await Syncing.observationSyncDataMinPerWeek(allSyncingData);
          await Syncing.observationSyncDataStrengthDaysPerWeek(allSyncingData);
        }

      }
    });

    // Debug.printLog("dataSyncingProcess...$allSyncingData");
  }

/*  static goalSyncingData(bool isRealTime, List<GoalSyncDataModel> goalDataList) async {
    List<GoalSyncDataModel> goalDataListRealTime = [];
    await getAndSetSyncGoalData(goalDataListRealTime);
    if (goalDataListRealTime.isNotEmpty) {
      var selectedUrlList = Utils.getServerListPreference();
      for (int i = 0; i < selectedUrlList.length; i++) {
        var url = selectedUrlList[i].url;
        var clientId = selectedUrlList[i].clientId;
        var token = selectedUrlList[i].authToken;
        var pId = selectedUrlList[i].patientId;
        var pName = "${selectedUrlList[i].patientFName}${selectedUrlList[i].patientLName}";
        await Syncing.callApiForGoalSyncData(goalDataListRealTime,url,clientId,token,pId,pName);
      }
    }
  }*/

  static Future<String> goalSyncingData(bool isRealTime,List<GoalSyncDataModel> goalDataList) async {
    // List<GoalSyncDataModel> goalDataList = [];
    if(isRealTime){
      List<GoalSyncDataModel> goalDataListRealTime = [];
      await getAndSetSyncGoalData(goalDataListRealTime);
      if(goalDataListRealTime.isNotEmpty){
        await Syncing.callApiForGoalSyncData(goalDataListRealTime);
      }
    }

    if(goalDataList.isNotEmpty){
      await Syncing.callApiForGoalSyncData(goalDataList);
    }
    return "";
  }

  static Future<void> getAndSetSyncGoalData(List<GoalSyncDataModel> goalDataList)async{
    var goalDbData = Hive.box<GoalTableData>(Constant.tableGoal).values.toList();
    if(goalDbData.isNotEmpty){
      var dataFindList = goalDbData.where((element) =>
          (element.objectId == null || element.objectId == "" || element.objectId == "null")).toList();
      if(dataFindList.isNotEmpty){
        ServerModelJson? selectedUrlList = Utils.getPrimaryServerData()!;
        if(selectedUrlList != null){
          for (int i = 0; i < dataFindList.length; i++) {
            var noteDataList = Hive.box<NoteTableData>(Constant.tableNoteData).values.toList();
            var noteData =noteDataList.where((element) => element.goalId == dataFindList[i].key).toList();
            var dataModel = GoalSyncDataModel();
            dataModel.goalId = dataFindList[i].goalId;
            dataModel.objectId = (dataFindList[i].objectId == "null" ||
                dataFindList[i].objectId == null || dataFindList[i].objectId == "")?"":dataFindList[i].objectId ?? "";
            dataModel.goalsType = dataFindList[i].multipleGoals;
            dataModel.target = dataFindList[i].target;
            dataModel.dueDate = dataFindList[i].dueDate;
            dataModel.description = dataFindList[i].description;
            dataModel.lifeCycleStatus = dataFindList[i].lifeCycleStatus;
            dataModel.achievementStatus = dataFindList[i].achievementStatus;
            dataModel.notesList = noteData;
            dataModel.createdDate = dataFindList[i].createdDate;
            dataModel.code = dataFindList[i].code;
            dataModel.system = dataFindList[i].system;
            dataModel.actualDescription = dataFindList[i].actualDescription;
            dataModel.updatedDate = dataFindList[i].updatedDate;
            dataModel.keyId = dataFindList[i].key;
            dataModel.expressedBy = dataFindList[i].expressedBy;
            dataModel.expressedByDisplay = dataFindList[i].expressedByDisplay;
            dataModel.token = selectedUrlList.authToken;
            dataModel.qrUrl = selectedUrlList.url;
            dataModel.patientId = selectedUrlList.patientId;
            dataModel.clientId = selectedUrlList.clientId;
            dataModel.patientName = selectedUrlList.patientFName;
            dataModel.isSync = true;
            var placeHolderVal = Utils.multipleGoalsList.where((element) => element.actualDescription == dataFindList[i].actualDescription).toList();
            if(placeHolderVal.isNotEmpty) {
              dataModel.placeHolderValue = placeHolderVal[0].targetPlaceHolder;
            }
            goalDataList.add(dataModel);
          }

        }
      }
    }
  }

  /*========================================== Condition Syncing ==================================================*/

  static conditionSyncingData(bool isRealTime,List<ConditionSyncDataModel> goalDataList) async {
    // List<GoalSyncDataModel> goalDataList = [];
    if(isRealTime){
      List<ConditionSyncDataModel> goalDataListRealTime = [];
      await getAndSetSyncConditionData(goalDataListRealTime);
      if(goalDataListRealTime.isNotEmpty){
        await Syncing.callApiForConditionSyncData(goalDataListRealTime);
      }
    }

    if(goalDataList.isNotEmpty){
      await Syncing.callApiForConditionSyncData(goalDataList);
    }
  }

  static Future<void> getAndSetSyncConditionData(List<ConditionSyncDataModel> goalDataList)async{
    var goalDbData = Hive.box<ConditionTableData>(Constant.tableCondition).values.toList();
    if(goalDbData.isNotEmpty){
      // var dataFindList = goalDbData.where((element) => !element.isSync).toList();
      var dataFindList = goalDbData.where((element) => !element.isSync && element.patientId == Utils.getPatientId() || (element.conditionID == null ||
          element.conditionID =="" || element.conditionID == "null")).toList();
      // var NoteDataFindList = goalDbData.where((element) => element.notesList).to
      if(dataFindList.isNotEmpty){
        for (int i = 0; i < dataFindList.length; i++) {
          var dataModel = ConditionSyncDataModel();
          // dataModel.objectId = dataFindList[i].conditionID ?? "";
          dataModel.objectId = (dataFindList[i].conditionID == null ||
              dataFindList[i].conditionID =="" || dataFindList[i].conditionID == "null") ?"":dataFindList[i].conditionID!;
          dataModel.keyId = dataFindList[i].key;
          dataModel.verificationStatus = dataFindList[i].verificationStatus;
          dataModel.onset = dataFindList[i].onset;
          dataModel.abatement = dataFindList[i].abatement;
          dataModel.readOnly = dataFindList[i].readOnly;
          dataModel.isDelete = dataFindList[i].isDelete;
          dataModel.patientId = dataFindList[i].patientId;
          dataModel.qrUrl = dataFindList[i].qrUrl;
          dataModel.token = dataFindList[i].token;
          dataModel.clientId = dataFindList[i].clientId;
          dataModel.patientId = dataFindList[i].patientId;
          dataModel.patientName = dataFindList[i].patientName;
          dataModel.isSync = true;
          goalDataList.add(dataModel);
        }
      }
    }
  }

  static Future<void> callApiForConditionSyncData(List<ConditionSyncDataModel> allSyncingData) async {

    PaaProfiles profiles = PaaProfiles();

    /// Here you all data that we want to send in to backend ==>> allSyncingData
    for (int i = 0; i < allSyncingData.length; i++) {
      /// You can start your API call from here
      ConditionTableData goalSingleData = await DataBaseHelper.shared.getConditionDataID(allSyncingData[i].keyId);
      Condition observation = profiles.createCondition(allSyncingData[i]);
      String observationId = await profiles.processConditionMultiServer(observation,goalSingleData);
      goalSingleData.conditionID = observationId;
      goalSingleData.isSync = true;
      await DataBaseHelper.shared.updateConditionData(goalSingleData);
    }
  }


  /*========================================== To Do Syncing ==================================================*/

  /*static toDoSyncingData(bool isRealTime,List<TaskSyncDataModel> goalDataList) async {
    // List<GoalSyncDataModel> goalDataList = [];
    if(isRealTime){
      List<TaskSyncDataModel> toDoDataListRealTime = [];
      await getAndSetSyncToDoData(toDoDataListRealTime);
      if(toDoDataListRealTime.isNotEmpty){
        await Syncing.callApiForToDoSyncData(toDoDataListRealTime);
      }
    }

    if(goalDataList.isNotEmpty){
      await Syncing.callApiForToDoSyncData(goalDataList);
    }
  }*/

  static Future<void> getAndSetSyncToDoData(List<TaskSyncDataModel> toDoDataList)async{
    var toDoDbData = Hive.box<ToDoTableData>(Constant.tableToDoList).values.toList();
    if(toDoDbData.isNotEmpty){
      var dataFindList = toDoDbData.where((element) => !element.isSync).toList();
      // var NoteDataFindList = goalDbData.where((element) => element.notesList).to
      if(dataFindList.isNotEmpty){
        for (int i = 0; i < dataFindList.length; i++) {
          var dataModel = TaskSyncDataModel();
          dataModel.objectId = dataFindList[i].objectId ?? "";
          dataModel.keyId = dataFindList[i].key;
          dataModel.statusReason = dataFindList[i].statusReason ?? "";
          dataModel.status = dataFindList[i].status ?? "";
          dataModel.patientId = dataFindList[i].patientId ?? "";
          dataModel.qrUrl = dataFindList[i].qrUrl ?? "";
          dataModel.clientId = dataFindList[i].clientId ?? "";
          dataModel.patientId = dataFindList[i].patientId ?? "";
          dataModel.patientName = dataFindList[i].patientName ?? "";
          dataModel.token = dataFindList[i].token ?? "";
          // dataModel.code = dataFindList[i].code ?? "";
          // dataModel.display = dataFindList[i].display ?? "";
          dataModel.priority = dataFindList[i].priority ?? "";
          dataModel.code = (dataFindList[i].code == "")?"":dataFindList[i].code!;
          dataModel.display = (dataFindList[i].code == "")?"":dataFindList[i].display!;
          dataModel.text = (dataFindList[i].code == "")?dataFindList[i].display!:"";

          dataModel.isSync = true;
          toDoDataList.add(dataModel);
        }
      }
    }
  }

  /*static Future<void> callApiForToDoSyncData(List<TaskSyncDataModel> allSyncingData) async {

    PaaProfiles profiles = PaaProfiles();

    /// Here you all data that we want to send in to backend ==>> allSyncingData
    for (int i = 0; i < allSyncingData.length; i++) {
      /// You can start your API call from here
      ToDoTableData goalSingleData = await DataBaseHelper.shared.getToDoDataID(allSyncingData[i].keyId);
      Task observation = profiles.createPatientTask(allSyncingData[i]);
      String observationId = await profiles.processTaskMultiServer(observation,goalSingleData);
      goalSingleData.objectId = observationId;
      goalSingleData.isSync = true;
      await DataBaseHelper.shared.updateToDoData(goalSingleData);
    }
  }*/
  static Future<String> callApiForToDoSyncData(
      TaskSyncDataModel allSyncingData,String qrUrl,String clientId,String token) async {
    PaaProfiles profiles = PaaProfiles();

    Task observation;
    // if(allSyncingData.focusReference != null && allSyncingData.focusReference!.reference != ""  && allSyncingData.focusReference!.reference != null && allSyncingData.code == Constant.rxCode){
    if(allSyncingData.focusReference != null && allSyncingData.focusReference!.reference != ""
        && allSyncingData.focusReference!.reference != null
        && allSyncingData.code == Constant.rxCode){

      observation =  profiles.updateFocusPatientTask(allSyncingData,allSyncingData.focusReference!.reference!.split("/")[1].toString());
    }else{
      observation =  profiles.createPatientTask(allSyncingData);
    }

    // Task observation = profiles.createPatientTask(allSyncingData);
    String observationId = await profiles.processTaskPatientMultiServer(observation,qrUrl,clientId,token);
    Debug.printLog(
        "callApiForToDoSyncData create for patient...$observationId");
    return observationId;
  }


  /*========================================== Care plan Syncing ==================================================*/

  static carePlanSyncingData(bool isRealTime,List<CarePlanSyncDataModel> goalDataList) async {
    // List<GoalSyncDataModel> goalDataList = [];
    if(isRealTime){
      List<CarePlanSyncDataModel> goalDataListRealTime = [];
      await getAndSetSyncCarePlanData(goalDataListRealTime);
      if(goalDataListRealTime.isNotEmpty){
        await Syncing.callApiForCarePlanSyncData(goalDataListRealTime);
      }
    }

    if(goalDataList.isNotEmpty){
      await Syncing.callApiForCarePlanSyncData(goalDataList);
    }
  }

  static Future<void> getAndSetSyncCarePlanData(List<CarePlanSyncDataModel> goalDataList)async{
    var goalDbData = Hive.box<CarePlanTableData>(Constant.tableCarePlan).values.toList();
    if(goalDbData.isNotEmpty){
      // var dataFindList = goalDbData.where((element) => !element.isSync).toList();
      var dataFindList = goalDbData.where((element) => !element.isSync && element.patientId == Utils.getPatientId() || (element.carePlanId == null ||
          element.carePlanId =="" || element.carePlanId == "null")).toList();
      if(dataFindList.isNotEmpty){
        for (int i = 0; i < dataFindList.length; i++) {
          var noteDataList = Hive.box<NoteTableData>(Constant.tableNoteData).values.toList();
          var noteData =noteDataList.where((element) => element.carePlanId == dataFindList[i].key).toList();
          var dataModel = CarePlanSyncDataModel();
          dataModel.keyId = dataFindList[i].key;
          // dataModel.objectId = dataFindList[i].carePlanId ?? "";
          dataModel.objectId = (dataFindList[i].carePlanId == null ||
              dataFindList[i].carePlanId =="" || dataFindList[i].carePlanId == "null") ?"":dataFindList[i].carePlanId!;
          dataModel.text = dataFindList[i].text;
          dataModel.statusDropDown = dataFindList[i].statusDropDown;
          dataModel.status = dataFindList[i].status;
          dataModel.startDate = dataFindList[i].startDate;
          dataModel.endDate = dataFindList[i].endDate;
          dataModel.goal = dataFindList[i].goal;
          dataModel.notesList = noteData;
          dataModel.isSync = dataFindList[i].isSync;
          dataModel.readOnly = dataFindList[i].readOnly;
          dataModel.isDelete = dataFindList[i].isDelete;
          dataModel.patientId = dataFindList[i].patientId;
          dataModel.qrUrl = dataFindList[i].qrUrl;
          dataModel.token = dataFindList[i].token;
          dataModel.clientId = dataFindList[i].clientId;
          dataModel.patientId = dataFindList[i].patientId;
          dataModel.patientName = dataFindList[i].patientName;
          dataModel.keyId = dataFindList[i].key;
          dataModel.goalObjectId = dataFindList[i].goalObjectId;
          dataModel.isSync = true;
          goalDataList.add(dataModel);
        }
      }
    }
  }

  static Future<void> callApiForCarePlanSyncData(List<CarePlanSyncDataModel> allSyncingData) async {

    PaaProfiles profiles = PaaProfiles();

    /// Here you all data that we want to send in to backend ==>> allSyncingData
    for (int i = 0; i < allSyncingData.length; i++) {
      /// You can start your API call from here
      CarePlanTableData goalSingleData = await DataBaseHelper.shared.getCarePlanDataID(allSyncingData[i].keyId);
      CarePlan observation = profiles.createCarePlan(allSyncingData[i]);
      String observationId = await profiles.processCarePlanMultiServer(observation,goalSingleData);
      goalSingleData.carePlanId = observationId;
      goalSingleData.isSync = true;
      await DataBaseHelper.shared.updateCarePlanData(goalSingleData);
    }
  }

  /*========================================== Referral Syncing ==================================================*/
  /// callAPIForSyncReferral
  static Future<void> callApiForReferralSyncData(List<ReferralSyncDataModel> allSyncingData) async {

    PaaProfiles profiles = PaaProfiles();

    /// Here you all data that we want to send in to backend ==>> allSyncingData
    for (int i = 0; i < allSyncingData.length; i++) {
      /// You can start your API call from here
      ReferralData referralSingleData = await DataBaseHelper.shared.getReferralDataIdWise(allSyncingData[i].keyId);

      ServiceRequest serviceRequest = profiles.createReferral(allSyncingData[i]);
      String serviceRequestId = await profiles.processReferralMultiServer(serviceRequest,referralSingleData);

      Debug.printLog("callApiForReferralSyncData createReferral....$serviceRequestId  ${allSyncingData[i].taskId}");
      Task task = profiles.createTask(allSyncingData[i], serviceRequestId);
      String taskId = await profiles.processTaskReferalMultiServer(task,referralSingleData);

      Debug.printLog("callApiForReferralSyncData createTask....$serviceRequestId  $taskId  ${allSyncingData[i].taskId}");

      if(allSyncingData[i].taskId == "") {
        referralSingleData.taskId = taskId;
      }

      if(allSyncingData[i].objectId == "") {
        referralSingleData.objectId = serviceRequestId;
      }
      referralSingleData.isSync = true;
      await DataBaseHelper.shared.updateReferralData(referralSingleData);
    }
  }

  static referralSyncingData(bool isRealTime,List<ReferralSyncDataModel> referral) async {
    // List<ReferralSyncDataModel> referral = [];
    if(isRealTime){
      List<ReferralSyncDataModel> referralDataListRealTime = [];
      await getAndSetSyncReferralData(referralDataListRealTime);
      if(referralDataListRealTime.isNotEmpty){
        await Syncing.callApiForReferralSyncData(referralDataListRealTime);

      }
    }

    if(referral.isNotEmpty){
      await Syncing.callApiForReferralSyncData(referral);

    }
  }

  static Future<void> getAndSetSyncReferralData(List<ReferralSyncDataModel> referral)async{
    var referralDbData = Hive.box<ReferralData>(Constant.tableReferral).values.toList();
    if(referralDbData.isNotEmpty){
      // var dataFindList = referralDbData.where((element) => !element.isSync && element.patientId == Utils.getPatientId()).toList();
      var dataFindList = referralDbData.where((element) => !element.isSync && element.patientId == Utils.getPatientId() || (element.objectId == null ||
      element.objectId =="" || element.objectId == "null")).toList();
      // var NoteDataFindList = referralDbData.where((element) => element.notesList).to
      if(dataFindList.isNotEmpty){
        for (int i = 0; i < dataFindList.length; i++) {
          var noteDataList = Hive.box<NoteTableData>(Constant.tableNoteData).values.toList();
          var noteData =noteDataList.where((element) => element.referralId.toString() ==dataFindList[i].key.toString()).toList();
          var dataModel = ReferralSyncDataModel();
          dataModel.objectId = (dataFindList[i].objectId == null ||
              dataFindList[i].objectId =="" || dataFindList[i].objectId == "null") ?"":dataFindList[i].objectId!;
          dataModel.status = dataFindList[i].status;
          dataModel.startDate = dataFindList[i].startDate;
          dataModel.endDate = dataFindList[i].endDate;
          dataModel.priority = dataFindList[i].priority;
          dataModel.notesList = noteData;
          dataModel.isPeriodDate = dataFindList[i].isPeriodDate;
          dataModel.performerId = dataFindList[i].performerId;
          dataModel.performerName = dataFindList[i].performerName;
          dataModel.readonly = dataFindList[i].readonly;
          dataModel.keyId = dataFindList[i].key;
          Debug.printLog("Task id get...........${dataFindList[i].taskId}  ${dataModel.objectId}  ${dataFindList[i].objectId!}");
          dataModel.taskId = dataFindList[i].taskId!;
          dataModel.qrUrl = dataFindList[i].qrUrl;
          dataModel.token = dataFindList[i].token;
          dataModel.clientId = dataFindList[i].clientId;
          dataModel.patientName = dataFindList[i].patientName;
          dataModel.patientId = dataFindList[i].patientId!;
          // dataModel.goalObjectId = dataFindList[i].goalObjectId;
          dataModel.code = (dataFindList[i].referralCode == "")?"":dataFindList[i].referralCode;
          dataModel.display = (dataFindList[i].referralCode == "")?"":dataFindList[i].referralScope;
          dataModel.text = (dataFindList[i].referralCode == "")?dataFindList[i].referralScope:"";
          dataModel.isSync = true;
          referral.add(dataModel);
        }
      }
    }
  }

  static Future<List<ActivityTable>> getAndSetSyncActivityLevelData()async{
    var activityLevelData = getActivityListData();
    List<ActivityTable> appleUnSyncActivityDataList = [];
    if(activityLevelData.isNotEmpty){
      appleUnSyncActivityDataList = activityLevelData.where((element) => !element.isSync && element.patientId == Utils.getPatientId()  && element.isFromAppleHealth
      && element.type == Constant.typeDaysData &&
      ((element.title == null && element.smileyType == null) || element.title == Constant.titleCalories  || element.title == Constant.titleActivityType
          || element.title == Constant.titleParent)).toList();
      Debug.printLog("data apple .....${appleUnSyncActivityDataList.length}");
    }
    return appleUnSyncActivityDataList;
  }

  static Future<List<ActivityTable>> getAndSetSyncActivityLevelDataManual()async{
    var activityLevelData = getActivityListData();
    List<ActivityTable> appleUnSyncActivityDataList = [];
    if(activityLevelData.isNotEmpty){
      appleUnSyncActivityDataList = activityLevelData.where((element) => !element.isSync && element.patientId == Utils.getPatientId()
          && element.type == Constant.typeDaysData &&
          ((element.title == null && element.smileyType == null) || (element.title == Constant.titleCalories && element.total != null)
              || (element.title == Constant.titleActivityType)
              || element.title == Constant.titleParent || (element.title == Constant.titleHeartRatePeak && element.total != null))).toList();
      Debug.printLog("getAndSetSyncActivityLevelDataManual apple .....${appleUnSyncActivityDataList.length}");
    }
    return appleUnSyncActivityDataList;
  }
  static Future<void> callApiForConfigurationData(data) async {
    PaaProfiles profiles = PaaProfiles();
    DocumentReference? observation = profiles.createUpdateConfigurationActivity(data);
    String? observationId = await profiles.processConfigurationActivity(observation);
    Preference.shared.setString(Preference.idActivityConfiguration, observationId);
    Debug.printLog("callApiForConfigurationData create for patient...$observationId");
  }

  static List<ActivityTable> getActivityListData(){
    return Hive.box<ActivityTable>(Constant.tableActivity).values.toList().where((element) =>
    element.patientId == Utils.getPatientId()).toList();
  }
}