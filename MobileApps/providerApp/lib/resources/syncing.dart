import 'package:banny_table/db_helper/box/care_plan_form_data.dart';
import 'package:banny_table/db_helper/box/condition_form_data.dart';
import 'package:banny_table/db_helper/box/notes_data.dart';
import 'package:banny_table/db_helper/box/referral_data.dart';
import 'package:banny_table/db_helper/box/to_do_form_data.dart';
import 'package:banny_table/ui/ExercisePrescription/dataModel/exercisePrescriptionDataModel.dart';
import 'package:banny_table/ui/home/home/dataModel/taskDataModel.dart';
import 'package:banny_table/ui/referralForm/datamodel/referralDataModel.dart';
import 'package:banny_table/ui/toDoList/dataModel/to_do_sync_data_model.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:fhir/r4.dart';
import 'package:fhir/r4/general_types/general_types.dart';
import 'package:fhir/r4/resource/resource.dart';
import 'package:fhir/r4/resource_types/base/workflow/workflow.dart';
import 'package:fhir/r4/resource_types/clinical/care_provision/care_provision.dart';
import 'package:fhir/r4/resource_types/clinical/diagnostics/diagnostics.dart';
import 'package:fhir/r4/resource_types/clinical/summary/summary.dart';
import 'package:fhir/r4/resource_types/foundation/documents/documents.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../db_helper/box/activity_data.dart';
import '../db_helper/box/exercise_prescription_data.dart';
import '../db_helper/box/goal_data.dart';
import '../db_helper/box/monthly_log_data.dart';
import '../db_helper/box/routing_referral_data.dart';
import '../db_helper/database_helper.dart';
import '../ui/carePlanForm/datamodel/carePlanSyncDataModel.dart';
import '../ui/conditionForm/datamodel/conditionSyncDataModel.dart';
import '../ui/goalForm/datamodel/goalDataModel.dart';
import '../ui/home/monthly/datamodel/syncMonthlyActivityData.dart';
import '../utils/constant.dart';
import '../utils/debug.dart';
import '../utils/utils.dart';
import 'PaaProfiles.dart';
import 'package:get/get.dart' as getX;


class Syncing{

  static Future<void>  getAndSetSyncActivityData(List<SyncMonthlyActivityData> allSyncingData) async {

    // List<SyncMonthlyActivityData> allSyncingData = [];
    // List<SyncMonthlyActivityData> syncActivityData = [];
    /// Tracking chart data (Activity)
    var dataListHive =
    Hive.box<ActivityTable>(Constant.tableActivity).values.toList();
    if (dataListHive.isNotEmpty) {
      /* weekDayUnSyncData(
          dataListHive, allSyncingData, Constant.titleCalories, false);
      weekDayUnSyncData(
          dataListHive, allSyncingData, Constant.titleSteps, false);
      weekDayUnSyncData(
          dataListHive, allSyncingData, Constant.titleHeartRateRest, false);
      weekDayUnSyncData(
          dataListHive, allSyncingData, Constant.titleHeartRatePeak, false);*/

      weekDayUnSyncData(
          dataListHive, allSyncingData, Constant.titleCalories, true);
      weekDayUnSyncData(
          dataListHive, allSyncingData, Constant.titleSteps, true);
      weekDayUnSyncData(
          dataListHive, allSyncingData, Constant.titleHeartRateRest, true);
      weekDayUnSyncData(
          dataListHive, allSyncingData, Constant.titleHeartRatePeak, true);

    }
  }


  static Future<void> weekDayUnSyncData(
      List<ActivityTable> dataListHive,
      List<SyncMonthlyActivityData> syncActivityDataList,
      String titleType,
      bool isDay) async {
    /*var unSyncedCaloriesWeekData = dataListHive
        .where((element) =>
    !element.isSync &&
        element.title == titleType &&
        element.type == ((isDay) ? Constant.typeDay : Constant.typeWeek))
        .toList();*/

    var unSyncedCaloriesWeekData = dataListHive.where((element) =>
    (!element.isSync
        || element.objectId == "error"
        || element.objectId == "null")
        && element.patientId == Utils.getPatientId() &&
        element.title == titleType &&
        element.type == Constant.typeDay).toList();
        // element.type == ((isDay) ? Constant.typeDay : Constant.typeWeek)).toList();


    if (unSyncedCaloriesWeekData.isNotEmpty) {
      for (int i = 0; i < unSyncedCaloriesWeekData.length; i++) {
        var data = unSyncedCaloriesWeekData[i];
        if (isDay) {
          syncActivityDataList.add(SyncMonthlyActivityData("", data.total ?? 0,
              data.dateTime, null, data.key, titleType, true, data.objectId));
        } else {
          DateTime startDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
              .parse(data.weeksDate!.split("-")[0]);
          DateTime endDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
              .parse(data.weeksDate!.split("-")[1]);
          syncActivityDataList.add(SyncMonthlyActivityData("", data.total ?? 0,
              startDate, endDate, data.key, titleType, false, data.objectId));
        }
      }
    }
  }

  ///Monthly log data

  static Future<void> getAndSetSyncMonthlyData(List<SyncMonthlyActivityData> allSyncingData) async {
    // List<SyncMonthlyActivityData> allSyncingData = [];

    ///Monthly log data
    var monthlyDataDbList =
    Hive.box<MonthlyLogTableData>(Constant.tableMonthlyLog).values.toList();
    if (monthlyDataDbList.isNotEmpty) {
      for (int i = 0; i < Utils.allYearlyMonths.length; i++) {
        syncMonthlyDataDayPerWeek(monthlyDataDbList, allSyncingData, i);
        syncMonthlyDataAverageMin(monthlyDataDbList, allSyncingData, i);
        syncMonthlyDataAverageMinPerWeek(monthlyDataDbList, allSyncingData, i);
        syncMonthlyDataStrength(monthlyDataDbList, allSyncingData, i);
      }
    }
    Debug.printLog("allSyncingData...$allSyncingData");
  }

  static syncMonthlyDataDayPerWeek(List<MonthlyLogTableData> monthlyDataDbList,
      List<SyncMonthlyActivityData> allSyncingData, int i) {
    ///Day per week
    /*var nonSyncDayPerWeekData = monthlyDataDbList
        .where((element) =>
    !element.isSyncDayPerWeek &&
        Utils.allYearlyMonths[i].name == element.monthName)
        .toList();*/

    var nonSyncDayPerWeekData = monthlyDataDbList.where((element) =>
    (!element.isSyncDayPerWeek
        || element.dayPerWeekId == "error"
        || element.dayPerWeekId == "null") && element.patientId == Utils.getPatientId() &&
        Utils.allYearlyMonths[i].name == element.monthName).toList();



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
      List<SyncMonthlyActivityData> allSyncingData, int i) {
    ///AVG min
    /*var nonSyncDayPerWeekData = monthlyDataDbList
        .where((element) =>
    !element.isSyncAvgMin &&
        Utils.allYearlyMonths[i].name == element.monthName)
        .toList();*/

    var nonSyncDayPerWeekData = monthlyDataDbList.where((element) =>
    (!element.isSyncAvgMin
        || element.avgMinPerDayId == "error"
        || element.avgMinPerDayId == "null") && element.patientId == Utils.getPatientId() &&
        Utils.allYearlyMonths[i].name == element.monthName).toList();



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
      List<SyncMonthlyActivityData> allSyncingData, int i) {
    ///AVH min per week
   /* var nonSyncDayPerWeekData = monthlyDataDbList
        .where((element) =>
    !element.isSyncAvgMinPerWeek &&
        Utils.allYearlyMonths[i].name == element.monthName)
        .toList();*/

    var nonSyncDayPerWeekData = monthlyDataDbList.where((element) =>
    (!element.isSyncAvgMinPerWeek
        || element.avgPerWeekId == "error"
        || element.avgPerWeekId == "null") && element.patientId == Utils.getPatientId()
        &&
        Utils.allYearlyMonths[i].name == element.monthName).toList();



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
      List<SyncMonthlyActivityData> allSyncingData, int i) {
    ///Strength
   /* var nonSyncDayPerWeekData = monthlyDataDbList
        .where((element) =>
    !element.isSyncStrength &&
        Utils.allYearlyMonths[i].name == element.monthName)
        .toList();*/

    var nonSyncDayPerWeekData = monthlyDataDbList.where((element) =>
    (!element.isSyncStrength
        || element.strengthId == "error"
        || element.strengthId == "null") && element.patientId == Utils.getPatientId()
        &&
        Utils.allYearlyMonths[i].name == element.monthName).toList();

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

  /// callAPIForSyncData
/*  static Future<void> observationSyncData( List<SyncMonthlyActivityData> allSyncingData) async {

    // List<SyncMonthlyActivityData> allSyncingData = [];
    PaaProfiles profiles = PaaProfiles();


    /// Here you all data that we want to send in to backend ==>> allSyncingData
    for (int i = 0; i < allSyncingData.length; i++) {
      /// You can start your API call from here

      if (allSyncingData[i].monthName == "") {
        /// /// Tracking chart data (Activity) (Weekly and Daily)
        /// Need to find the type of activity first then IF ELSE to handle four cases
        /// Average Resting Heart Rate, Calories per day, Daily Steps, Peak Daily Heart Rate
        var activityData = allSyncingData[i];
        ActivityTable getActivityKeyWiseData = await DataBaseHelper.shared.getActivityData(activityData.keyId);
        getActivityKeyWiseData.isSync = true;
        await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);

        String observationId = "";
        if(allSyncingData[i].headerType == Constant.titleCalories){
          ///Calories
          Observation observation = profiles.createObservationCaloriesPerDay(allSyncingData[i]);
          observationId = await profiles.processResource(observation);
        }else if(allSyncingData[i].headerType == Constant.titleSteps){
          ///Step
          Observation observation = profiles.createObservationDailyStepsPerDay(allSyncingData[i]);
          observationId = await profiles.processResource(observation);
        }else if(allSyncingData[i].headerType == Constant.titleHeartRatePeak){
          ///Heart peak
          Observation observation = profiles.createObservationDailyPeakHeartRate(allSyncingData[i]);
          observationId = await profiles.processResource(observation);
        }else if(allSyncingData[i].headerType == Constant.titleHeartRateRest){
          ///Heart rest
          Observation observation = profiles.createObservationAverageRestingHeartRate(allSyncingData[i]);
          observationId = await profiles.processResource(observation);
        }

        getActivityKeyWiseData.objectId = observationId;
        await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);

      } else {
        /// Monthly (DayPerWeek, AVG min, AVG min per week and Strength)
        var activityData = allSyncingData[i];
        MonthlyLogTableData getActivityKeyWiseData =
        await DataBaseHelper.shared.getMonthlyData(activityData.keyId);
        Debug.printLog("getActivityKeyWiseData...$getActivityKeyWiseData");

        // String observationId = "";
        ///We have 4 measure data in to monthly log. (DayPerWeek, AVG min, AVG min per week and Strength) So we are comparing data with type so we can know about that
        if (activityData.headerType == Constant.headerDayPerWeek) {
          ///Day Per Week
          getActivityKeyWiseData.isSyncDayPerWeek = true;
          await DataBaseHelper.shared.updateMonthlyData(getActivityKeyWiseData);

          Observation observation = profiles.createObservationDaysPerWeeks(allSyncingData[i]);
          String observationId = await profiles.processResource(observation);
          // String observationId = Utils.getRandomNumber();

          getActivityKeyWiseData.dayPerWeekId = observationId;
          // getActivityKeyWiseData.isSyncDayPerWeek = true;
        } else if (activityData.headerType == Constant.headerAverageMin) {
          ///AVG min
          getActivityKeyWiseData.isSyncAvgMin = true;
          await DataBaseHelper.shared.updateMonthlyData(getActivityKeyWiseData);
          Observation observation = profiles.createObservationMintuesPerDay(allSyncingData[i]);
          String observationId = await profiles.processResource(observation);
          // String observationId = Utils.getRandomNumber();

          getActivityKeyWiseData.avgMinPerDayId = observationId;
          // getActivityKeyWiseData.isSyncAvgMin = true;
        } else if (activityData.headerType ==
            Constant.headerAverageMinPerWeek) {
          ///AVG min per
          getActivityKeyWiseData.isSyncAvgMinPerWeek = true;
          await DataBaseHelper.shared.updateMonthlyData(getActivityKeyWiseData);
          Observation observation = profiles.createObservationMintuesPerWeek(allSyncingData[i]);
          String observationId = await profiles.processResource(observation);
          // String observationId = Utils.getRandomNumber();

          getActivityKeyWiseData.avgPerWeekId = observationId;
          // getActivityKeyWiseData.isSyncAvgMinPerWeek = true;
        } else if (activityData.headerType == Constant.headerStrength) {
          ///Strength
          getActivityKeyWiseData.isSyncStrength = true;
          await DataBaseHelper.shared.updateMonthlyData(getActivityKeyWiseData);
          Observation observation = profiles.createObservationStrengthDaysPerWeek(allSyncingData[i]);
          String observationId = await profiles.processResource(observation);
          // String observationId = Utils.getRandomNumber();

          getActivityKeyWiseData.strengthId = observationId;
          // getActivityKeyWiseData.isSyncStrength = true;
        }

        await DataBaseHelper.shared.updateMonthlyData(getActivityKeyWiseData);
      }

      *//* await dataModel.insertData().then((value) async {
        handleInsertResponseResponse(value);
      });*//*
    }
  }*/

  /// callAPIForSyncDataGoal
  static Future<String> callApiForGoalSyncData(List<GoalSyncDataModel> allSyncingData) async {

    PaaProfiles profiles = PaaProfiles();
    String objectId = "";
    /// Here you all data that we want to send in to backend ==>> allSyncingData
    for (int i = 0; i < allSyncingData.length; i++) {
      /// You can start your API call from here
      // GoalTableData goalSingleData = await DataBaseHelper.shared.getGoalDataById(allSyncingData[i].keyId);
      Goal goal = profiles.createGoal(allSyncingData[i]);
      String goalId = await profiles.processGoal(goal,allSyncingData[i]);
      Debug.printLog("Goal Id --- >"+goalId);
      if(goalId == "null" || goalId == "" || goalId == "NULL" || goalId == "Null"){
        // await Utils.showErrorDialog(Get.context!,Constant.txtError,Constant.txtErrorGoalNotCreated);
        // return "";
      }else{
        objectId = goalId;
      }
      return goalId;
      // goalSingleData.objectId = goalId;
      // goalSingleData.isSync = true;
      // await DataBaseHelper.shared.updateGoalData(goalSingleData);
    }
    return objectId;
  }

  /*static Future<void> dataSyncingProcess(bool isFromTrackingChart) async {
    List<SyncMonthlyActivityData> allSyncingData = [];
    if(isFromTrackingChart) {
      await Syncing.getAndSetSyncActivityData(allSyncingData);
    }else {
      await Syncing.getAndSetSyncMonthlyData(allSyncingData);
    }

    await Utils.isExpireTokenAPICall(Constant.screenTypeBottom,(value) async {
      if(!value){
        if(allSyncingData.isNotEmpty) {
          if(isFromTrackingChart) {
            await Syncing.observationSyncDataCalories(allSyncingData);
            await Syncing.observationSyncDataSteps(allSyncingData);
            await Syncing.observationSyncDataRestHeart(allSyncingData);
            await Syncing.observationSyncDataPeakHeart(allSyncingData);
          }else{
            await Syncing.observationSyncDataDaysPerWeeks(allSyncingData);
            await Syncing.observationSyncDataMinPerDay(allSyncingData);
            await Syncing.observationSyncDataMinPerWeek(allSyncingData);
            await Syncing.observationSyncDataStrengthDaysPerWeek(allSyncingData);
          }
        }
      }
    }).then((value) async {
      if(!value){

        if(allSyncingData.isNotEmpty) {
          if(isFromTrackingChart) {
            await Syncing.observationSyncDataCalories(allSyncingData);
            await Syncing.observationSyncDataSteps(allSyncingData);
            await Syncing.observationSyncDataRestHeart(allSyncingData);
            await Syncing.observationSyncDataPeakHeart(allSyncingData);
          }else{
            await Syncing.observationSyncDataDaysPerWeeks(allSyncingData);
            await Syncing.observationSyncDataMinPerDay(allSyncingData);
            await Syncing.observationSyncDataMinPerWeek(allSyncingData);
            await Syncing.observationSyncDataStrengthDaysPerWeek(allSyncingData);
          }
        }
      }
    });
    // Debug.printLog("dataSyncingProcess...$allSyncingData");
  }*/

  static goalSyncingData(bool isRealTime,List<GoalSyncDataModel> goalDataList) async {
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
  }

  static Future<void> getAndSetSyncGoalData(List<GoalSyncDataModel> goalDataList)async{
    var goalDbData = Hive.box<GoalTableData>(Constant.tableGoal).values.toList();
    if(goalDbData.isNotEmpty){
      var dataFindList = goalDbData.where((element) => !element.isSync && element.patientId == Utils.getPatientId()
          || (element.objectId == null || element.objectId == "" || element.objectId == "null")).toList();
      // var NoteDataFindList = goalDbData.where((element) => element.notesList).to
      if(dataFindList.isNotEmpty){
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
          dataModel.expressedBy = dataFindList[i].expressedBy;
          dataModel.expressedByDisplay = dataFindList[i].expressedByDisplay;
          dataModel.keyId = dataFindList[i].key;
          dataModel.isSync = true;
          dataModel.token = dataFindList[i].token;
          dataModel.qrUrl = dataFindList[i].qrUrl;
          dataModel.patientId = dataFindList[i].patientId;
          dataModel.clientId = dataFindList[i].clientId;
          dataModel.patientName = dataFindList[i].patientName;
          dataModel.providerId = dataFindList[i].providerId;
          dataModel.providerName = dataFindList[i].providerName;
          var placeHolderVal = Utils.multipleGoalsList.where((element) => element.actualDescription == dataFindList[i].actualDescription).toList();
          if(placeHolderVal.isNotEmpty) {
            dataModel.placeHolderValue = placeHolderVal[0].targetPlaceHolder;
          }
          goalDataList.add(dataModel);
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
          dataModel.code = dataFindList[i].code;
          dataModel.text = dataFindList[i].text;
          dataModel.display = (dataFindList[i].display == "") ? dataFindList[i].text : dataFindList[i].display;
          dataModel.isSync = true;
          dataModel.qrUrl = dataFindList[i].qrUrl;
          dataModel.token = dataFindList[i].token;
          dataModel.clientId = dataFindList[i].clientId;
          dataModel.patientId = dataFindList[i].patientId;
          dataModel.patientName = dataFindList[i].patientName;
          dataModel.providerId = dataFindList[i].providerId;
          dataModel.providerName = dataFindList[i].providerName;
          dataModel.detalis = dataFindList[i].detalis;
          goalDataList.add(dataModel);
        }
      }
    }
  }

  static Future<String> callApiForConditionSyncData(List<ConditionSyncDataModel> allSyncingData) async {

    PaaProfiles profiles = PaaProfiles();
    String conditionId = "";
    /// Here you all data that we want to send in to backend ==>> allSyncingData
    for (int i = 0; i < allSyncingData.length; i++) {
      /// You can start your API call from here
      // ConditionTableData conditionSingleData = await DataBaseHelper.shared.getConditionDataID(allSyncingData[i].keyId);
      Condition observation = profiles.createCondition(allSyncingData[i]);
      String observationId = await profiles.processCondition(observation,allSyncingData[i]);
      Debug.printLog("observationId........$observationId");
      if(observationId == "null" || observationId == "" || observationId == "NULL" || observationId == "Null"){
        // Utils.showErrorDialog(Get.context!,Constant.txtError,Constant.txtErrorConditionNotCreated);
      }else{
        conditionId = observationId;
      }
      // conditionSingleData.conditionID = observationId;
      // conditionSingleData.isSync = true;
      // await DataBaseHelper.shared.updateConditionData(conditionSingleData);
      return observationId;
    }
    return conditionId;
  }


  /*========================================== To Do Syncing ==================================================*/

  /*static toDoSyncingData(bool isRealTime,List<TaskSyncDataModel> goalDataList) async {
    // List<GoalSyncDataModel> goalDataList = [];
    if(isRealTime){
      List<TaskSyncDataModel> toDoDataListRealTime = [];
      await getAndSetSyncToDoData(goalDataList);
      if(toDoDataListRealTime.isNotEmpty){
        await Syncing.callApiForToDoSyncData(goalDataList);
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

  // static Future<void> callApiForToDoSyncData(List<TaskSyncDataModel> allSyncingData) async {
  static Future<String> callApiForToDoSyncData(
      TaskSyncDataModel allSyncingData) async {
    PaaProfiles profiles = PaaProfiles();
    Task observation;
    if(allSyncingData.focusReference != null && allSyncingData.focusReference!.reference != ""  && allSyncingData.focusReference!.reference != null){
    // && allSyncingData.code == Constant.rxCode){

      observation =  profiles.updateFocusPatientTask(allSyncingData,allSyncingData.focusReference!.reference!.split("/")[1].toString());
    }else{
      observation =  profiles.createPatientTask(allSyncingData);
    }
    String observationId = await profiles.processTask(observation,allSyncingData.qrUrl ?? "",allSyncingData.clientId ?? "",allSyncingData.token ?? "");
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
          dataModel.keyId = dataFindList[i].key;
          dataModel.goalObjectId = dataFindList[i].goalObjectId;
          dataModel.isSync = true;
          dataModel.qrUrl = dataFindList[i].qrUrl;
          dataModel.token = dataFindList[i].token;
          dataModel.clientId = dataFindList[i].clientId;
          dataModel.patientName = dataFindList[i].patientName;
          dataModel.providerId = dataFindList[i].providerId;
          dataModel.providerName = dataFindList[i].providerName;
          goalDataList.add(dataModel);
        }
      }
    }
  }

  static Future<String> callApiForCarePlanSyncData(List<CarePlanSyncDataModel> allSyncingData) async {

    PaaProfiles profiles = PaaProfiles();
      String carePlanId= "";
    /// Here you all data that we want to send in to backend ==>> allSyncingData
    for (int i = 0; i < allSyncingData.length; i++) {
      /// You can start your API call from here
      // CarePlanTableData carePlanSingleData = await DataBaseHelper.shared.getCarePlanDataID(allSyncingData[i].keyId);
      CarePlan observation = profiles.createCarePlan(allSyncingData[i]);
      String observationId = await profiles.processCarePlan(observation,allSyncingData[i]);
      if(observationId == "null" || observationId == "" || observationId == "NULL" || observationId == "Null"){
        // Utils.showErrorDialog(Get.context!,Constant.txtError,Constant.txtErrorCarePlanNotCreated);
      }else{
        carePlanId = observationId;
      }
      return observationId;
      // carePlanSingleData.carePlanId = observationId;
      // carePlanSingleData.isSync = true;
      // await DataBaseHelper.shared.updateCarePlanData(carePlanSingleData);
    }
    return carePlanId;
  }

  /*========================================== Referral Syncing ==================================================*/
  static Future<String> updateReferralTaskWise(ReferralSyncDataModel allSyncingData,
      String baseUrl) async {

    PaaProfiles profiles = PaaProfiles();
    /// Here you all data that we want to send in to backend ==>> allSyncingData
      /// You can start your API call from here
      ServiceRequest? serviceRequest;
      List<Reference> perfomerList  = [];
      if(allSyncingData.performerId != "" && allSyncingData.performerId != null && allSyncingData.performerName != "" && allSyncingData.performerId != null ){
        perfomerList = [
          Reference(reference: 'Practitioner/${allSyncingData.performerId}',display: allSyncingData.performerName)
        ];
      }
      serviceRequest = profiles.createReferral(allSyncingData,baseUrl,perfomerList);
      String serviceRequestId = await profiles.processReferral(serviceRequest,allSyncingData);
      return serviceRequestId;
  }

  /// callAPIForSyncReferral
  static Future<String> callApiForReferralSyncData(List<ReferralSyncDataModel> allSyncingData,bool isAssignForm,
      String baseUrl,Function callBackId) async {

    PaaProfiles profiles = PaaProfiles();
    String referralId = "";
    /// Here you all data that we want to send in to backend ==>> allSyncingData
    for (int i = 0; i < allSyncingData.length; i++) {
      /// You can start your API call from here
      ServiceRequest? serviceRequest;
      List<Reference> perfomerList  = [];
      if(allSyncingData[i].performerId != "" && allSyncingData[i].performerId != null && allSyncingData[i].performerName != "" && allSyncingData[i].performerId != null ){
        perfomerList = [
          Reference(reference: 'Practitioner/${allSyncingData[i].performerId}',display: allSyncingData[i].performerName)
        ];
      }
      serviceRequest = profiles.createReferral(allSyncingData[i],baseUrl,perfomerList);
      String serviceRequestId = await profiles.processReferral(serviceRequest,allSyncingData[i]);
      if(serviceRequestId == "null" || serviceRequestId == "" || serviceRequestId == "NULL" || serviceRequestId == "Null"){
        return "";
      }else{
        referralId = serviceRequestId;
      }

      allSyncingData[i].objectId = serviceRequestId;
      Debug.printLog("serviceRequestId for referral.....$serviceRequestId");
      // var taskDataModel = await getTaskServiceRequestIdWise(serviceRequestId);
      // allSyncingData[i].taskId = allSyncingData[i].taskId;
      if(allSyncingData[i].isCreated) {
        if (allSyncingData[i].status != Constant.statusDraft) {
          if (allSyncingData[i].status == Constant.statusActive) {
            allSyncingData[i].status = Constant.toDoStatusRequested;
          } else if (allSyncingData[i].status == Constant.statusRevoked) {
            allSyncingData[i].status = Constant.toDoStatusCancelled;
          }
          Task task;
          if (perfomerList.isNotEmpty) {
            if (perfomerList[0] != null) {
              task = profiles.createTask(
                  allSyncingData[i], serviceRequestId, baseUrl,
                  perfomerList[0]);
            } else {
              task = profiles.createTaskWithoutOwner(
                allSyncingData[i], serviceRequestId, baseUrl,);
            }
          } else {
            task = profiles.createTaskWithoutOwner(
              allSyncingData[i], serviceRequestId, baseUrl,);
          }
          String taskIdProcess = await profiles.processTask(
              task, allSyncingData[0].qrUrl!, allSyncingData[0].clientId!,
              allSyncingData[0].token!);
          Debug.printLog(
              "callApiForReferralSyncData createTask....$serviceRequestId  $taskIdProcess  ${allSyncingData[i]
                  .taskId}");
          if (allSyncingData[i].status == Constant.toDoStatusRequested) {
            allSyncingData[i].status = Constant.statusActive;
          } else if (allSyncingData[i].status == Constant.toDoStatusCancelled) {
            allSyncingData[i].status = Constant.statusRevoked;
          }

          ///Update referral with task id
          var taskId = taskIdProcess;
          ServiceRequest? referralUpdate = profiles.updateReferralWithTaskId(allSyncingData[i],baseUrl,
              perfomerList, taskId);
          String referralUpdatedId = await profiles.processReferral(referralUpdate,allSyncingData[i]);

          callBackId.call(taskId);
        }
      }

      return referralId;
    }
    return referralId;
  }

  static Future<TaskDataModel> getTaskServiceRequestIdWise(String id) async {
    var taskDataModel = TaskDataModel();
    // if(Utils.getProviderId() != "" && Utils.getAPIEndPoint() != "" && Utils.getPatientId() != "") {
    if(Utils.getPrimaryServerData() != null){
      for(int j=0;j<Utils.getServerListPreference().where((element) => element.isSelected && element.providerId != "" && element.patientId != "").toList().length;j++) {
        var listData = await PaaProfiles.getTaskServiceRequestIdWise(id,Utils.getServerListPreference().where((element) => element.isPrimary && element.providerId != "" && element.patientId != "").toList()[0]);
        if (listData.resourceType == R4ResourceType.Bundle) {
          if (listData != null && listData.entry != null) {
            for (int i = 0; i < listData.entry.length; i++) {
              var data = listData.entry[i];
              if (data.resource.resourceType == R4ResourceType.Task) {
                if (data.resource.id != null) {
                  taskDataModel.taskId = data.resource.id.toString();
                }

                DateTime createdDate = DateTime.now();
                if (data.resource.authoredOn != null) {
                  createdDate = data.resource.authoredOn.valueDateTime;
                } else {
                  createdDate = DateTime.now();
                }
                taskDataModel.createdDate = createdDate;
              }
            }
          }
        }
      }
    }
    return taskDataModel;
  }

  /*static referralCreatedSyncingData(bool isRealTime,List<ReferralSyncDataModel> referral,
      String baseUrl) async {
    // List<ReferralSyncDataModel> referral = [];
    if(isRealTime){
      List<ReferralSyncDataModel> referralDataListRealTime = [];
      await getAndSetSyncReferralData(referralDataListRealTime,true,false);
      if(referralDataListRealTime.isNotEmpty){
        await Syncing.callApiForReferralSyncData(referralDataListRealTime,false,baseUrl);
      }
    }
  }

  static referralAssignedSyncingData(bool isRealTime,List<ReferralSyncDataModel> referral,bool isAssignForm,
      String baseUrl) async {
    // List<ReferralSyncDataModel> referral = [];
    if(isRealTime){
      List<ReferralSyncDataModel> referralDataListRealTime = [];
      await getAndSetSyncReferralData(referralDataListRealTime,false,isAssignForm);
      if(referralDataListRealTime.isNotEmpty){
        await Syncing.callApiForReferralSyncData(referralDataListRealTime,true,baseUrl);
      }
    }
  }*/

  static Future<void> getAndSetSyncReferralData(List<ReferralSyncDataModel> referral,bool isCreated,bool isAssignForm)async{
    var referralDbData = Hive.box<ReferralData>(Constant.tableReferral).values.toList();
    if(referralDbData.isNotEmpty){
      // var dataFindList = referralDbData.where((element) => !element.isSync && element.patientId == Utils.getPatientId()).toList();
      var dataFindList = referralDbData.where((element) => !element.isSync
          && element.patientId == Utils.getPatientId() || (element.objectId == null ||
      element.objectId =="" || element.objectId == "null")).toList();
      // var NoteDataFindList = referralDbData.where((element) => element.notesList).to
      if(dataFindList.isNotEmpty){
        for (int i = 0; i < dataFindList.length; i++) {
          var noteDataList = Hive.box<NoteTableData>(Constant.tableNoteData).values.toList();
          var noteData =noteDataList.where((element) =>
          ((dataFindList[i].isCreated!)?element.createdReferralId.toString():element.assignedReferralId.toString()) ==
              dataFindList[i].key.toString()).toList();
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
          dataModel.code = (dataFindList[i].referralCode == "")?"":dataFindList[i].referralCode;
          dataModel.display = (dataFindList[i].referralCode == "")?"":dataFindList[i].referralScope;
          dataModel.text = (dataFindList[i].referralCode == "")?dataFindList[i].referralScope:"";
          if(isAssignForm) {
            dataModel.requesterId = dataFindList[i].requesterId;
            dataModel.requesterName = dataFindList[i].requesterName;
          }
          dataModel.isSync = true;
          dataModel.createdDate = dataFindList[i].createdDate;
          dataModel.lastUpdatedDate = dataFindList[i].lastUpdatedDate;

          dataModel.qrUrl = dataFindList[i].qrUrl;
          dataModel.token = dataFindList[i].token;
          dataModel.clientId = dataFindList[i].clientId;
          dataModel.patientId = dataFindList[i].patientId;
          dataModel.patientName = dataFindList[i].patientName;
          dataModel.providerId = dataFindList[i].providerId;
          dataModel.providerName = dataFindList[i].providerName;
          dataModel.textReasonCode = dataFindList[i].textReasonCode;
          dataModel.conditionObjectId = dataFindList[i].conditionObjectId;
          referral.add(dataModel);
        }
      }
    }
  }


 ///*========================================== Exercise Prescription Syncing ==================================================*/
  /// callAPIForSyncExercise
  static Future<String> callApiForExercisePrescriptionSyncData(List<ExercisePrescriptionSyncDataModel> allSyncingData) async {

    PaaProfiles profiles = PaaProfiles();
String rxId = "";
    /// Here you all data that we want to send in to backend ==>> allSyncingData
    for (int i = 0; i < allSyncingData.length; i++) {
      /// You can start your API call from here
      // ExerciseData exercisePrescriptionSingleData = await DataBaseHelper.shared.gettableExerciseDataID(allSyncingData[i].keyId);

      ServiceRequest serviceRequest = profiles.createExercisePrescription(allSyncingData[i]);
      String serviceRequestId = await profiles.processExercisePrescription(serviceRequest ,allSyncingData[i]);
      if(serviceRequestId != "null" || serviceRequestId != ""){
        rxId = serviceRequestId;
        // Utils.showErrorDialog(Get.context!,Constant.txtError,Constant.txtErrorRxNotCreated);
      }

      Debug.printLog("callApiForExercisePrescriptionSyncData createReferral....$serviceRequestId  ${allSyncingData[i].taskId}");
      return serviceRequestId;
      DateTime createdDate = DateTime.now();
      /*if(allSyncingData[i].taskId != "") {
        var toDoDbData = Hive.box<ToDoTableData>(Constant.tableToDoList).values.toList();
        var tempList = toDoDbData.where((element) => element.objectId == allSyncingData[i].taskId).toList();
        if(tempList.isNotEmpty){
          createdDate = tempList[0].createdDate ?? DateTime.now();
        }
      }*/
      // Task task = profiles.createTask(allSyncingData[i], serviceRequestId,createdDate);
      // String taskId = await profiles.processTask(task);
      /*if(allSyncingData[i].status != Constant.statusDraft) {
        if (allSyncingData[i].status == Constant.statusActive) {
          allSyncingData[i].status = Constant.toDoStatusRequested;
        } else if (allSyncingData[i].status == Constant.statusRevoked) {
          allSyncingData[i].status = Constant.toDoStatusCancelled;
        }
        Task task = profiles.createTaskPrescription(
            allSyncingData[i], serviceRequestId, createdDate);
        String taskId = await profiles.processTask(
            task, exercisePrescriptionSingleData.qrUrl,
            exercisePrescriptionSingleData.clientId,
            exercisePrescriptionSingleData.token);
        Debug.printLog(
            "callApiForReferralSyncData createTask....$serviceRequestId  $taskId  ${allSyncingData[i]
                .taskId}");

        if (allSyncingData[i].taskId == "" ||
            allSyncingData[i].taskId == "null") {
          exercisePrescriptionSingleData.taskId = taskId;
        }
      }*/

      // if(allSyncingData[i].objectId == "") {
      // exercisePrescriptionSingleData.createdDate ??= DateTime.now();

      // exercisePrescriptionSingleData.lastUpdatedDate = DateTime.now();
      // exercisePrescriptionSingleData.objectId = serviceRequestId;
      Debug.printLog("Object id for exe...$serviceRequestId");
      // }
      // exercisePrescriptionSingleData.isSync = true;
      // await DataBaseHelper.shared.updatetableExerciseData(exercisePrescriptionSingleData);
    }
    return rxId;
  }

  static exercisePrescriptionSyncingData(bool isRealTime,List<ExercisePrescriptionSyncDataModel> referral) async {
    // List<ExercisePrescriptionSyncDataModel> referral = [];
    if(isRealTime){
      List<ExercisePrescriptionSyncDataModel> referralDataListRealTime = [];
      await getAndSetSyncExercisePrescriptionData(referralDataListRealTime);
      if(referralDataListRealTime.isNotEmpty){
        await Syncing.callApiForExercisePrescriptionSyncData(referralDataListRealTime);
      }
    }

    if(referral.isNotEmpty){
      await Syncing.callApiForExercisePrescriptionSyncData(referral);

    }
  }

  static Future<void> getAndSetSyncExercisePrescriptionData(List<ExercisePrescriptionSyncDataModel> referral)async{
    var referralDbData = Hive.box<ExerciseData>(Constant.tableExerciseList).values.toList();
    if(referralDbData.isNotEmpty){
      // var dataFindList = referralDbData.where((element) => !element.isSync && element.patientId == Utils.getPatientId()).toList();
      var dataFindList = referralDbData.where((element) => !element.isSync && element.patientId == Utils.getPatientId() || (element.objectId == null ||
      element.objectId =="" || element.objectId == "null")).toList();
      // var NoteDataFindList = referralDbData.where((element) => element.notesList).to
      if(dataFindList.isNotEmpty){
        for (int i = 0; i < dataFindList.length; i++) {
          var noteDataList = Hive.box<NoteTableData>(Constant.tableNoteData).values.toList();
          var noteData =noteDataList.where((element) => element.exerciseId.toString() ==dataFindList[i].key.toString()).toList();
          var dataModel = ExercisePrescriptionSyncDataModel();
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
          // dataModel.goalObjectId = dataFindList[i].goalObjectId;
          dataModel.code = (dataFindList[i].referralCode == "")?"":dataFindList[i].referralCode;
          dataModel.display = (dataFindList[i].referralCode == "")?"":dataFindList[i].referralScope;
          dataModel.text = (dataFindList[i].referralCode == "")?dataFindList[i].referralScope:"";
          dataModel.isSync = true;
          dataModel.createdDate = dataFindList[i].createdDate;
          dataModel.lastUpdatedDate = dataFindList[i].lastUpdatedDate;
          dataModel.qrUrl = dataFindList[i].qrUrl;
          dataModel.token = dataFindList[i].token;
          dataModel.clientId = dataFindList[i].clientId;
          dataModel.patientId = dataFindList[i].patientId;
          dataModel.patientName = dataFindList[i].patientName;
          dataModel.providerId = dataFindList[i].providerId;
          dataModel.providerName = dataFindList[i].providerName;
          dataModel.textReasonCode = dataFindList[i].textReasonCode;
          referral.add(dataModel);
        }
      }
    }
  }

  static Future<void> callApiForConfigurationData(data) async {
    PaaProfiles profiles = PaaProfiles();
    DocumentReference? observation = profiles.createUpdateConfigurationActivity(data);
    String? observationId = await profiles.processConfigurationActivity(observation);
    Preference.shared.setString(Preference.idActivityConfiguration, observationId);
    Debug.printLog("callApiForConfigurationData create for patient...$observationId");
  }

  // static Future<void> createParentActivityObservation(ActivityTable getActivityKeyWiseData) async {
  //   PaaProfiles profiles = PaaProfiles();
  //   var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
  //   var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
  //   if(getPrimaryServerData.isNotEmpty){
  //     allSelectedServersUrl.remove(getPrimaryServerData[0]);
  //     allSelectedServersUrl.add(getPrimaryServerData[0]);
  //   }
  //   // int delayCount = 0;
  //
  //   for (int j = 0; j < allSelectedServersUrl.length; j++) {
  //     if (allSelectedServersUrl[j].isSecure &&
  //         Utils.isExpiredToken(allSelectedServersUrl[j].lastLoggedTime,
  //             allSelectedServersUrl[j].expireTime)) {
  //       showDialog(
  //         context: getX.Get.context!,
  //         barrierDismissible: false,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: const Text("Session Expired"),
  //             content: Text(
  //                 "Your ${allSelectedServersUrl[j].title} has expired. Please log in again"),
  //             actions: <Widget>[
  //               TextButton(
  //                 onPressed: () async {
  //                   getX.Get.back();
  //                   Utils.callSecureServerAPI(
  //                       allSelectedServersUrl[j].url,
  //                       allSelectedServersUrl[j].clientId,
  //                       allSelectedServersUrl[j].title);
  //                 },
  //                 child: const Text("Log in"),
  //               ),
  //               TextButton(
  //                 onPressed: () {
  //                   getX.Get.back();
  //                 },
  //                 child: const Text("Cancel"),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //       return;
  //     }
  //
  //     if (getActivityKeyWiseData.serverDetailList.isNotEmpty) {
  //       getActivityKeyWiseData.isSync = true;
  //
  //       await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);
  //
  //       String observationId = "";
  //
  //       var objectId = "";
  //       var getServeIndex = getActivityKeyWiseData.serverDetailList
  //           .indexWhere(
  //               (element) => element.serverUrl == allSelectedServersUrl[j].url)
  //           .toInt();
  //       if (getServeIndex != -1) {
  //         objectId =
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ??
  //                 "";
  //         getActivityKeyWiseData
  //             .serverDetailList[getServeIndex].dataSyncServerWise = true;
  //       }
  //       if (getActivityKeyWiseData.serverDetailList.isNotEmpty &&
  //           getActivityKeyWiseData.identifierData.isNotEmpty) {
  //         var a = getActivityKeyWiseData.identifierData
  //             .indexWhere(
  //                 (element) => element.url == allSelectedServersUrl[j].url)
  //             .toInt();
  //         if (a != -1) {
  //           objectId = getActivityKeyWiseData.identifierData[a].objectId ?? "";
  //         }
  //       }
  //       List<Identifier> identifier = [];
  //       if (allSelectedServersUrl[j].isPrimary) {
  //         var withOutPrimaryDataList = allSelectedServersUrl
  //             .where((element) => !element.isPrimary)
  //             .toList();
  //         if (withOutPrimaryDataList.isNotEmpty) {
  //           for (int a = 0; a < withOutPrimaryDataList.length; a++) {
  //             if (getActivityKeyWiseData.serverDetailList.isNotEmpty) {
  //               var getServeIndex = getActivityKeyWiseData.serverDetailList
  //                   .indexWhere((element) =>
  //               element.serverUrl == withOutPrimaryDataList[a].url)
  //                   .toInt();
  //               if (getServeIndex != -1) {
  //                 identifier.add(Identifier(
  //                     value: getActivityKeyWiseData
  //                         .serverDetailList[getServeIndex].objectId,
  //                     system: FhirUri(getActivityKeyWiseData
  //                         .serverDetailList[getServeIndex].serverUrl)));
  //               }
  //             }
  //           }
  //         }
  //       }
  //
  //       var titleListHasMember = [Constant.titleActivityType,Constant.titleCalories,null,Constant.titleHeartRatePeak];
  //       List<Reference>? hasMember = [];
  //       var activityTableData = getActivityListData();
  //       if(activityTableData.isNotEmpty){
  //         /*        var childMemberList = activityTableData.where((element) => element.date == getActivityKeyWiseData.date
  //         && element.weeksDate == getActivityKeyWiseData.weeksDate && element.activityStartDate ==
  //             getActivityKeyWiseData.activityStartDate &&
  //             element.activityEndDate == getActivityKeyWiseData.activityEndDate &&
  //         titleListHasMember.contains(element.title)).toList();*/
  //         var childMemberList = activityTableData.where((element) => element.date == getActivityKeyWiseData.date
  //             && element.weeksDate == getActivityKeyWiseData.weeksDate &&
  //             // element.type == Constant.typeDaysData && element.activityStartDate == getActivityKeyWiseData.activityStartDate
  //             element.type == Constant.typeDaysData &&
  //             Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
  //                 Utils.changeDateFormatBasedOnDBDate(getActivityKeyWiseData.activityStartDate ?? DateTime.now())
  //             &&
  //             Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
  //                 Utils.changeDateFormatBasedOnDBDate(getActivityKeyWiseData.activityEndDate ?? DateTime.now()) &&
  //             titleListHasMember.contains(element.title)).toList();
  //
  //         for (int l = 0; l < childMemberList.length; l++) {
  //           if (childMemberList[l].title == null && childMemberList[l].smileyType == null) {
  //             // if(childMemberList[l].value1 != null){
  //             var serverDetailModMin = childMemberList[l].serverDetailListModMin.where((
  //                 element) =>
  //             element.modServerUrl
  //                 == allSelectedServersUrl[j].url && element.modObjectId != "")
  //                 .toList();
  //             if (serverDetailModMin.isNotEmpty) {
  //               hasMember.add(Reference(
  //                   reference: "Observation/${serverDetailModMin[0].modObjectId}",display: Constant.hasMemberTypeModMin));
  //             }
  //             // }
  //             // if(childMemberList[l].value2 != null){
  //             var serverDetailVigMin = childMemberList[l].serverDetailListVigMin.where((
  //                 element) =>
  //             element.vigServerUrl
  //                 == allSelectedServersUrl[j].url && element.vigObjectId != "")
  //                 .toList();
  //             if (serverDetailVigMin.isNotEmpty) {
  //               hasMember.add(Reference(
  //                   reference: "Observation/${serverDetailVigMin[0].vigObjectId}",display: Constant.hasMemberTypeVigMin));
  //             }
  //             // }
  //             // if(childMemberList[l].total != null){
  //             var serverDetailTotalMin = childMemberList[l].serverDetailList.where((
  //                 element) =>
  //             element.serverUrl
  //                 == allSelectedServersUrl[j].url && element.objectId != "")
  //                 .toList();
  //             if (serverDetailTotalMin.isNotEmpty) {
  //               hasMember.add(Reference(
  //                   reference: "Observation/${serverDetailTotalMin[0].objectId}",display: Constant.hasMemberTypeTotalMin));
  //             }
  //             // }
  //           }
  //           else {
  //             var displayType = "";
  //             if(childMemberList[l].title == Constant.titleActivityType){
  //               displayType = Constant.hasMemberTypeActivity;
  //             }else if(childMemberList[l].title == Constant.titleHeartRatePeak){
  //               displayType = Constant.hasMemberTypePeakHeartRate;
  //             }else if(childMemberList[l].title == Constant.titleCalories){
  //               displayType = Constant.hasMemberTypeCalories;
  //             }
  //
  //             var serverDetail = childMemberList[l].serverDetailList.where((
  //                 element) =>
  //             element.serverUrl
  //                 == allSelectedServersUrl[j].url && element.objectId != "")
  //                 .toList();
  //             if (serverDetail.isNotEmpty) {
  //               hasMember.add(Reference(
  //                   reference: "Observation/${serverDetail[0].objectId}",display: displayType));
  //             }
  //           }
  //         }
  //       }
  //       Observation observation = profiles.createParentActivityObservation(
  //           objectId,
  //           "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}",
  //           allSelectedServersUrl[j].patientId,
  //           getActivityKeyWiseData.displayLabel ?? "",
  //           getActivityKeyWiseData.activityStartDate ?? DateTime.now(),
  //           getActivityKeyWiseData.activityEndDate ?? DateTime.now(),
  //           hasMember,
  //           identifierDataList: identifier);
  //
  //       observationId = await profiles.processResource(
  //           observation,
  //           Constant.trackingChart,
  //           allSelectedServersUrl[j].url,
  //           allSelectedServersUrl[j].clientId,
  //           allSelectedServersUrl[j].authToken);
  //
  //       getActivityKeyWiseData.objectId = observationId;
  //
  //       if (getActivityKeyWiseData.serverDetailList
  //           .where((element) => element.objectId == observationId)
  //           .toList()
  //           .isEmpty) {
  //         getActivityKeyWiseData.serverDetailList[getServeIndex].objectId =
  //             observationId;
  //         getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl =
  //             allSelectedServersUrl[j].url;
  //         getActivityKeyWiseData.serverDetailList[getServeIndex].patientId =
  //             allSelectedServersUrl[j].patientId;
  //         getActivityKeyWiseData.serverDetailList[getServeIndex].patientName =
  //         "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";
  //       }
  //
  //       await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);
  //     }
  //   }
  //
  //   var withOutPrimaryData = Utils.getServerListPreference()
  //       .where((element) =>
  //   !element.isPrimary && element.isSelected && element.patientId != "")
  //       .toList();
  //   if (withOutPrimaryData.isNotEmpty) {
  //     List<Identifier> identifierDataExtra = [];
  //     for (int a = 0; a < withOutPrimaryData.length; a++) {
  //       identifierDataExtra.clear();
  //       if (withOutPrimaryData[a].isSecure &&
  //           Utils.isExpiredToken(withOutPrimaryData[a].lastLoggedTime,
  //               withOutPrimaryData[a].expireTime)) {
  //         showDialog(
  //           context: getX.Get.context!,
  //           barrierDismissible: false,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: const Text("Session Expired"),
  //               content: Text(
  //                   "Your ${withOutPrimaryData[a].title} has expired. Please log in again. RestHeart"),
  //               actions: <Widget>[
  //                 TextButton(
  //                   onPressed: () async {
  //                     getX.Get.back();
  //                     Utils.callSecureServerAPI(
  //                         withOutPrimaryData[a].url,
  //                         withOutPrimaryData[a].clientId,
  //                         withOutPrimaryData[a].title);
  //                   },
  //                   child: const Text("Log in"),
  //                 ),
  //                 TextButton(
  //                   onPressed: () {
  //                     getX.Get.back();
  //                   },
  //                   child: const Text("Cancel"),
  //                 ),
  //               ],
  //             );
  //           },
  //         );
  //         return;
  //       }
  //
  //       var callAPIWithThisURL = withOutPrimaryData[a].url;
  //
  //       var getAllObjectIdList = getActivityKeyWiseData.serverDetailList
  //           .where((element) => element.serverUrl != callAPIWithThisURL)
  //           .toList();
  //
  //       if (getAllObjectIdList.isNotEmpty) {
  //         for (int d = 0; d < getAllObjectIdList.length; d++) {
  //           identifierDataExtra.add(Identifier(
  //               value: getAllObjectIdList[d].objectId,
  //               system: FhirUri(getAllObjectIdList[d].serverUrl)));
  //         }
  //       }
  //
  //       var objectId = "";
  //       var getServeIndex = getActivityKeyWiseData.serverDetailList
  //           .indexWhere(
  //               (element) => element.serverUrl == withOutPrimaryData[a].url)
  //           .toInt();
  //       if (getServeIndex != -1) {
  //         objectId =
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ??
  //                 "";
  //         getActivityKeyWiseData
  //             .serverDetailList[getServeIndex].dataSyncServerWise = true;
  //       }
  //       if (getActivityKeyWiseData.serverDetailList.isNotEmpty &&
  //           getActivityKeyWiseData.identifierData.isNotEmpty) {
  //         var aObject = getActivityKeyWiseData.identifierData
  //             .indexWhere((element) => element.url == withOutPrimaryData[a].url)
  //             .toInt();
  //         if (aObject != -1) {
  //           objectId =
  //               getActivityKeyWiseData.identifierData[aObject].objectId ?? "";
  //         }
  //       }
  //
  //       if (identifierDataExtra.isNotEmpty) {
  //         var titleListHasMember = [Constant.titleActivityType,Constant.titleCalories,null,Constant.titleHeartRatePeak];
  //         List<Reference>? hasMember = [];
  //         var activityTableData = getActivityListData();
  //         if(activityTableData.isNotEmpty){
  //           var childMemberList = activityTableData.where((element) => element.date == getActivityKeyWiseData.date
  //               && element.weeksDate == getActivityKeyWiseData.weeksDate  &&
  //               /*element.activityStartDate == getActivityKeyWiseData.activityStartDate
  //               &&
  //               element.activityEndDate == getActivityKeyWiseData.activityEndDate
  //               &&*/
  //               Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
  //                   Utils.changeDateFormatBasedOnDBDate(getActivityKeyWiseData.activityStartDate ?? DateTime.now())
  //               &&
  //               Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
  //                   Utils.changeDateFormatBasedOnDBDate(getActivityKeyWiseData.activityEndDate ?? DateTime.now()) &&
  //               element.type == Constant.typeDaysData &&
  //               titleListHasMember.contains(element.title)).toList();
  //           for (int l = 0; l < childMemberList.length; l++) {
  //             if (childMemberList[l].title == null && childMemberList[l].smileyType == null) {
  //               // if(childMemberList[l].value1 != null){
  //               var serverDetailMod = childMemberList[l].serverDetailListModMin.where((
  //                   element) =>
  //               element.modServerUrl
  //                   == withOutPrimaryData[a].url && element.modObjectId != "")
  //                   .toList();
  //               if (serverDetailMod.isNotEmpty) {
  //                 hasMember.add(Reference(
  //                     reference: "Observation/${serverDetailMod[0].modObjectId}",display: Constant.hasMemberTypeModMin));
  //               }
  //               // }
  //               // if(childMemberList[l].value2 != null){
  //               var serverDetailVig = childMemberList[l].serverDetailListVigMin.where((
  //                   element) =>
  //               element.vigServerUrl
  //                   == withOutPrimaryData[a].url && element.vigObjectId != "")
  //                   .toList();
  //               if (serverDetailVig.isNotEmpty) {
  //                 hasMember.add(Reference(
  //                     reference: "Observation/${serverDetailVig[0].vigObjectId}",display: Constant.hasMemberTypeVigMin));
  //               }
  //               // }
  //               // if(childMemberList[l].total != null){
  //               var serverDetailTotal = childMemberList[l].serverDetailList.where((
  //                   element) =>
  //               element.serverUrl
  //                   == withOutPrimaryData[a].url && element.objectId != "")
  //                   .toList();
  //               if (serverDetailTotal.isNotEmpty) {
  //                 hasMember.add(Reference(
  //                     reference: "Observation/${serverDetailTotal[0].objectId}",display: Constant.hasMemberTypeTotalMin));
  //               }
  //               // }
  //             }
  //             else {
  //               var displayType = "";
  //               if(childMemberList[l].title == Constant.titleActivityType){
  //                 displayType = Constant.hasMemberTypeActivity;
  //               }else if(childMemberList[l].title == Constant.titleHeartRatePeak){
  //                 displayType = Constant.hasMemberTypePeakHeartRate;
  //               }else if(childMemberList[l].title == Constant.titleCalories){
  //                 displayType = Constant.hasMemberTypeCalories;
  //               }
  //
  //               var serverDetail = childMemberList[l].serverDetailList.where((
  //                   element) =>
  //               element.serverUrl
  //                   == withOutPrimaryData[a].url && element.objectId != "")
  //                   .toList();
  //               if (serverDetail.isNotEmpty) {
  //                 hasMember.add(Reference(
  //                     reference: "Observation/${serverDetail[0].objectId}",display: displayType));
  //               }
  //             }
  //           }
  //
  //         }
  //         Observation observation = profiles.createParentActivityObservation(
  //             objectId,
  //             "${withOutPrimaryData[a].patientFName}${withOutPrimaryData[a].patientLName}",
  //             withOutPrimaryData[a].patientId,
  //             getActivityKeyWiseData.displayLabel ?? "",
  //             getActivityKeyWiseData.activityStartDate ?? DateTime.now(),
  //             getActivityKeyWiseData.activityEndDate ?? DateTime.now(),
  //             hasMember,
  //             identifierDataList: identifierDataExtra);
  //
  //         await profiles.processResource(
  //             observation,
  //             Constant.trackingChart,
  //             withOutPrimaryData[a].url,
  //             withOutPrimaryData[a].clientId,
  //             withOutPrimaryData[a].authToken);
  //       }
  //     }
  //   }
  //   /*delayCount++;
  //   if (delayCount == Constant.delayTimeLength) {
  //     delayCount = 0;
  //     await Utils.apiCallApplyDelay10second();
  //   }*/
  // }
  //
  // static Future<void> createChildActivityNameObservation(String activityName,ActivityTable getActivityKeyWiseData) async {
  //   PaaProfiles profiles = PaaProfiles();
  //   var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
  //   var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
  //   if(getPrimaryServerData.isNotEmpty){
  //     allSelectedServersUrl.remove(getPrimaryServerData[0]);
  //     allSelectedServersUrl.add(getPrimaryServerData[0]);
  //   }
  //   // int delayCount = 0;
  //
  //   for (int j = 0; j < allSelectedServersUrl.length; j++) {
  //     if (allSelectedServersUrl[j].isSecure &&
  //         Utils.isExpiredToken(allSelectedServersUrl[j].lastLoggedTime,
  //             allSelectedServersUrl[j].expireTime)) {
  //       showDialog(
  //         context: getX.Get.context!,
  //         barrierDismissible: false,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: const Text("Session Expired"),
  //             content: Text(
  //                 "Your ${allSelectedServersUrl[j].title} has expired. Please log in again"),
  //             actions: <Widget>[
  //               TextButton(
  //                 onPressed: () async {
  //                   getX.Get.back();
  //                   Utils.callSecureServerAPI(
  //                       allSelectedServersUrl[j].url,
  //                       allSelectedServersUrl[j].clientId,
  //                       allSelectedServersUrl[j].title);
  //                 },
  //                 child: const Text("Log in"),
  //               ),
  //               TextButton(
  //                 onPressed: () {
  //                   getX.Get.back();
  //                 },
  //                 child: const Text("Cancel"),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //       return;
  //     }
  //
  //     if (getActivityKeyWiseData.serverDetailList.isNotEmpty) {
  //       getActivityKeyWiseData.isSync = true;
  //
  //       await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);
  //
  //       String observationId = "";
  //
  //       var objectId = "";
  //       var getServeIndex = getActivityKeyWiseData.serverDetailList
  //           .indexWhere(
  //               (element) => element.serverUrl == allSelectedServersUrl[j].url)
  //           .toInt();
  //       if (getServeIndex != -1) {
  //         objectId =
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ??
  //                 "";
  //         getActivityKeyWiseData
  //             .serverDetailList[getServeIndex].dataSyncServerWise = true;
  //       }
  //       if (getActivityKeyWiseData.serverDetailList.isNotEmpty &&
  //           getActivityKeyWiseData.identifierData.isNotEmpty) {
  //         var a = getActivityKeyWiseData.identifierData
  //             .indexWhere(
  //                 (element) => element.url == allSelectedServersUrl[j].url)
  //             .toInt();
  //         if (a != -1) {
  //           objectId = getActivityKeyWiseData.identifierData[a].objectId ?? "";
  //         }
  //       }
  //       List<Identifier> identifier = [];
  //       if (allSelectedServersUrl[j].isPrimary) {
  //         var withOutPrimaryDataList = allSelectedServersUrl
  //             .where((element) => !element.isPrimary)
  //             .toList();
  //         if (withOutPrimaryDataList.isNotEmpty) {
  //           for (int a = 0; a < withOutPrimaryDataList.length; a++) {
  //             if (getActivityKeyWiseData.serverDetailList.isNotEmpty) {
  //               var getServeIndex = getActivityKeyWiseData.serverDetailList
  //                   .indexWhere((element) =>
  //               element.serverUrl == withOutPrimaryDataList[a].url)
  //                   .toInt();
  //               if (getServeIndex != -1) {
  //                 identifier.add(Identifier(
  //                     value: getActivityKeyWiseData
  //                         .serverDetailList[getServeIndex].objectId,
  //                     system: FhirUri(getActivityKeyWiseData
  //                         .serverDetailList[getServeIndex].serverUrl)));
  //               }
  //             }
  //           }
  //         }
  //       }
  //       var configurationList = Preference.shared.getConfigPrefList(Preference.configurationInfo) ?? [];
  //       var loincCode = "";
  //       if(configurationList.isNotEmpty){
  //         var data = configurationList.where((element) => element.title == getActivityKeyWiseData.displayLabel).toList();
  //         if(data.isNotEmpty){
  //           loincCode = data[0].activityCode;
  //         }
  //       }
  //       Observation observation = profiles.createChildActivityNameObservation(
  //           objectId,
  //           "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}",
  //           allSelectedServersUrl[j].patientId,
  //           loincCode,
  //           activityName,
  //           getActivityKeyWiseData.activityStartDate ?? DateTime.now(),
  //           getActivityKeyWiseData.activityEndDate ?? DateTime.now(),
  //           identifierDataList: identifier);
  //
  //       observationId = await profiles.processResource(
  //           observation,
  //           Constant.trackingChart,
  //           allSelectedServersUrl[j].url,
  //           allSelectedServersUrl[j].clientId,
  //           allSelectedServersUrl[j].authToken);
  //
  //       getActivityKeyWiseData.objectId = observationId;
  //
  //       if (getActivityKeyWiseData.serverDetailList
  //           .where((element) => element.objectId == observationId)
  //           .toList()
  //           .isEmpty) {
  //         getActivityKeyWiseData.serverDetailList[getServeIndex].objectId =
  //             observationId;
  //         getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl =
  //             allSelectedServersUrl[j].url;
  //         getActivityKeyWiseData.serverDetailList[getServeIndex].patientId =
  //             allSelectedServersUrl[j].patientId;
  //         getActivityKeyWiseData.serverDetailList[getServeIndex].patientName =
  //         "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";
  //       }
  //
  //       await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);
  //     }
  //   }
  //
  //   var withOutPrimaryData = Utils.getServerListPreference()
  //       .where((element) =>
  //   !element.isPrimary && element.isSelected && element.patientId != "")
  //       .toList();
  //   if (withOutPrimaryData.isNotEmpty) {
  //     List<Identifier> identifierDataExtra = [];
  //     for (int a = 0; a < withOutPrimaryData.length; a++) {
  //       identifierDataExtra.clear();
  //       if (withOutPrimaryData[a].isSecure &&
  //           Utils.isExpiredToken(withOutPrimaryData[a].lastLoggedTime,
  //               withOutPrimaryData[a].expireTime)) {
  //         showDialog(
  //           context: getX.Get.context!,
  //           barrierDismissible: false,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: const Text("Session Expired"),
  //               content: Text(
  //                   "Your ${withOutPrimaryData[a].title} has expired. Please log in again. RestHeart"),
  //               actions: <Widget>[
  //                 TextButton(
  //                   onPressed: () async {
  //                     getX.Get.back();
  //                     Utils.callSecureServerAPI(
  //                         withOutPrimaryData[a].url,
  //                         withOutPrimaryData[a].clientId,
  //                         withOutPrimaryData[a].title);
  //                   },
  //                   child: const Text("Log in"),
  //                 ),
  //                 TextButton(
  //                   onPressed: () {
  //                     getX.Get.back();
  //                   },
  //                   child: const Text("Cancel"),
  //                 ),
  //               ],
  //             );
  //           },
  //         );
  //         return;
  //       }
  //
  //       var callAPIWithThisURL = withOutPrimaryData[a].url;
  //
  //       var getAllObjectIdList = getActivityKeyWiseData.serverDetailList
  //           .where((element) => element.serverUrl != callAPIWithThisURL)
  //           .toList();
  //
  //       if (getAllObjectIdList.isNotEmpty) {
  //         for (int d = 0; d < getAllObjectIdList.length; d++) {
  //           identifierDataExtra.add(Identifier(
  //               value: getAllObjectIdList[d].objectId,
  //               system: FhirUri(getAllObjectIdList[d].serverUrl)));
  //         }
  //       }
  //
  //       var objectId = "";
  //       var getServeIndex = getActivityKeyWiseData.serverDetailList
  //           .indexWhere(
  //               (element) => element.serverUrl == withOutPrimaryData[a].url)
  //           .toInt();
  //       if (getServeIndex != -1) {
  //         objectId =
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ??
  //                 "";
  //         getActivityKeyWiseData
  //             .serverDetailList[getServeIndex].dataSyncServerWise = true;
  //       }
  //       if (getActivityKeyWiseData.serverDetailList.isNotEmpty &&
  //           getActivityKeyWiseData.identifierData.isNotEmpty) {
  //         var aObject = getActivityKeyWiseData.identifierData
  //             .indexWhere((element) => element.url == withOutPrimaryData[a].url)
  //             .toInt();
  //         if (aObject != -1) {
  //           objectId =
  //               getActivityKeyWiseData.identifierData[aObject].objectId ?? "";
  //         }
  //       }
  //
  //       if (identifierDataExtra.isNotEmpty) {
  //         var configurationList = Preference.shared.getConfigPrefList(Preference.configurationInfo) ?? [];
  //         var loincCode = "";
  //         if(configurationList.isNotEmpty){
  //           var data = configurationList.where((element) => element.title == getActivityKeyWiseData.displayLabel).toList();
  //           if(data.isNotEmpty){
  //             loincCode = data[0].activityCode;
  //           }
  //         }
  //         Observation observation = profiles.createChildActivityNameObservation(
  //             objectId,
  //             "${withOutPrimaryData[a].patientFName}${withOutPrimaryData[a].patientLName}",
  //             withOutPrimaryData[a].patientId,
  //             loincCode,
  //             activityName,
  //             getActivityKeyWiseData.activityStartDate ?? DateTime.now(),
  //             getActivityKeyWiseData.activityEndDate ?? DateTime.now(),
  //             identifierDataList: identifierDataExtra);
  //
  //         await profiles.processResource(
  //             observation,
  //             Constant.observation,
  //             withOutPrimaryData[a].url,
  //             withOutPrimaryData[a].clientId,
  //             withOutPrimaryData[a].authToken);
  //       }
  //     }
  //   }
  //   /*delayCount++;
  //   if (delayCount == Constant.delayTimeLength) {
  //     delayCount = 0;
  //     await Utils.apiCallApplyDelay10second();
  //   }*/
  // }
  //
  // static Future<void> createChildActivityCaloriesObservation(String activityName,ActivityTable getActivityKeyWiseData) async {
  //
  //   PaaProfiles profiles = PaaProfiles();
  //
  //   var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" &&
  //       element.isSelected).toList();
  //
  //   var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
  //   if(getPrimaryServerData.isNotEmpty){
  //     allSelectedServersUrl.remove(getPrimaryServerData[0]);
  //     allSelectedServersUrl.add(getPrimaryServerData[0]);
  //   }
  //
  //   // int delayCount = 0;
  //
  //   for (int j = 0; j < allSelectedServersUrl.length; j++) {
  //     if (allSelectedServersUrl[j].isSecure &&
  //         Utils.isExpiredToken(allSelectedServersUrl[j].lastLoggedTime,
  //             allSelectedServersUrl[j].expireTime)) {
  //       showDialog(
  //         context: getX.Get.context!,
  //         barrierDismissible: false,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: const Text("Session Expired"),
  //             content: Text(
  //                 "Your ${allSelectedServersUrl[j].title} has expired. Please log in again"),
  //             actions: <Widget>[
  //               TextButton(
  //                 onPressed: () async {
  //                   getX.Get.back();
  //                   Utils.callSecureServerAPI(
  //                       allSelectedServersUrl[j].url,
  //                       allSelectedServersUrl[j].clientId,
  //                       allSelectedServersUrl[j].title);
  //                 },
  //                 child: const Text("Log in"),
  //               ),
  //               TextButton(
  //                 onPressed: () {
  //                   getX.Get.back();
  //                 },
  //                 child: const Text("Cancel"),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //       return;
  //     }
  //
  //     if (getActivityKeyWiseData.serverDetailList.isNotEmpty) {
  //       getActivityKeyWiseData.isSync = true;
  //
  //       await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);
  //
  //       String observationId = "";
  //
  //       var objectId = "";
  //       var getServeIndex = getActivityKeyWiseData.serverDetailList
  //           .indexWhere(
  //               (element) => element.serverUrl == allSelectedServersUrl[j].url)
  //           .toInt();
  //
  //       if (getServeIndex != -1) {
  //         objectId =
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ??
  //                 "";
  //         getActivityKeyWiseData
  //             .serverDetailList[getServeIndex].dataSyncServerWise = true;
  //       }
  //
  //       if (getActivityKeyWiseData.serverDetailList.isNotEmpty &&
  //           getActivityKeyWiseData.identifierData.isNotEmpty) {
  //         var a = getActivityKeyWiseData.identifierData
  //             .indexWhere(
  //                 (element) => element.url == allSelectedServersUrl[j].url)
  //             .toInt();
  //         if (a != -1) {
  //           objectId = getActivityKeyWiseData.identifierData[a].objectId ?? "";
  //         }
  //       }
  //
  //       List<Identifier> identifier = [];
  //       if (allSelectedServersUrl[j].isPrimary) {
  //         var withOutPrimaryDataList = allSelectedServersUrl
  //             .where((element) => !element.isPrimary)
  //             .toList();
  //
  //         if (withOutPrimaryDataList.isNotEmpty) {
  //           for (int a = 0; a < withOutPrimaryDataList.length; a++) {
  //             if (getActivityKeyWiseData.serverDetailList.isNotEmpty) {
  //               var getServeIndex = getActivityKeyWiseData.serverDetailList
  //                   .indexWhere((element) =>
  //               element.serverUrl == withOutPrimaryDataList[a].url)
  //                   .toInt();
  //               if (getServeIndex != -1) {
  //                 identifier.add(Identifier(
  //                     value: getActivityKeyWiseData
  //                         .serverDetailList[getServeIndex].objectId,
  //                     system: FhirUri(getActivityKeyWiseData
  //                         .serverDetailList[getServeIndex].serverUrl)));
  //               }
  //             }
  //           }
  //         }
  //       }
  //
  //       Observation observation = profiles.createChildActivityCaloriesObservation(
  //           objectId,
  //           "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}",
  //           allSelectedServersUrl[j].patientId,
  //           getActivityKeyWiseData.activityStartDate ?? DateTime.now(),
  //           getActivityKeyWiseData.activityEndDate ?? DateTime.now(),
  //           getActivityKeyWiseData.total ?? 0.0,
  //           identifierDataList: identifier);
  //
  //       observationId = await profiles.processResource(
  //           observation,
  //           Constant.observation,
  //           allSelectedServersUrl[j].url,
  //           allSelectedServersUrl[j].clientId,
  //           allSelectedServersUrl[j].authToken);
  //
  //       getActivityKeyWiseData.objectId = observationId;
  //
  //       if (getActivityKeyWiseData.serverDetailList
  //           .where((element) => element.objectId == observationId)
  //           .toList()
  //           .isEmpty) {
  //         getActivityKeyWiseData.serverDetailList[getServeIndex].objectId =
  //             observationId;
  //         getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl =
  //             allSelectedServersUrl[j].url;
  //         getActivityKeyWiseData.serverDetailList[getServeIndex].patientId =
  //             allSelectedServersUrl[j].patientId;
  //         getActivityKeyWiseData.serverDetailList[getServeIndex].patientName =
  //         "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";
  //       }
  //
  //       await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);
  //     }
  //   }
  //
  //   var withOutPrimaryData = Utils.getServerListPreference()
  //       .where((element) =>
  //   !element.isPrimary && element.isSelected && element.patientId != "")
  //       .toList();
  //   if (withOutPrimaryData.isNotEmpty) {
  //     List<Identifier> identifierDataExtra = [];
  //     for (int a = 0; a < withOutPrimaryData.length; a++) {
  //       identifierDataExtra.clear();
  //       if (withOutPrimaryData[a].isSecure &&
  //           Utils.isExpiredToken(withOutPrimaryData[a].lastLoggedTime,
  //               withOutPrimaryData[a].expireTime)) {
  //         showDialog(
  //           context: getX.Get.context!,
  //           barrierDismissible: false,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: const Text("Session Expired"),
  //               content: Text(
  //                   "Your ${withOutPrimaryData[a].title} has expired. Please log in again. RestHeart"),
  //               actions: <Widget>[
  //                 TextButton(
  //                   onPressed: () async {
  //                     getX.Get.back();
  //                     Utils.callSecureServerAPI(
  //                         withOutPrimaryData[a].url,
  //                         withOutPrimaryData[a].clientId,
  //                         withOutPrimaryData[a].title);
  //                   },
  //                   child: const Text("Log in"),
  //                 ),
  //                 TextButton(
  //                   onPressed: () {
  //                     getX.Get.back();
  //                   },
  //                   child: const Text("Cancel"),
  //                 ),
  //               ],
  //             );
  //           },
  //         );
  //         return;
  //       }
  //
  //       var callAPIWithThisURL = withOutPrimaryData[a].url;
  //
  //       var getAllObjectIdList = getActivityKeyWiseData.serverDetailList
  //           .where((element) => element.serverUrl != callAPIWithThisURL)
  //           .toList();
  //
  //       if (getAllObjectIdList.isNotEmpty) {
  //         for (int d = 0; d < getAllObjectIdList.length; d++) {
  //           identifierDataExtra.add(Identifier(
  //               value: getAllObjectIdList[d].objectId,
  //               system: FhirUri(getAllObjectIdList[d].serverUrl)));
  //         }
  //       }
  //
  //       var objectId = "";
  //       var getServeIndex = getActivityKeyWiseData.serverDetailList
  //           .indexWhere(
  //               (element) => element.serverUrl == withOutPrimaryData[a].url)
  //           .toInt();
  //       if (getServeIndex != -1) {
  //         objectId =
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ??
  //                 "";
  //         getActivityKeyWiseData
  //             .serverDetailList[getServeIndex].dataSyncServerWise = true;
  //       }
  //       if (getActivityKeyWiseData.serverDetailList.isNotEmpty &&
  //           getActivityKeyWiseData.identifierData.isNotEmpty) {
  //         var aObject = getActivityKeyWiseData.identifierData
  //             .indexWhere((element) => element.url == withOutPrimaryData[a].url)
  //             .toInt();
  //         if (aObject != -1) {
  //           objectId =
  //               getActivityKeyWiseData.identifierData[aObject].objectId ?? "";
  //         }
  //       }
  //
  //       if (identifierDataExtra.isNotEmpty) {
  //
  //         Observation observation = profiles.createChildActivityCaloriesObservation(
  //             objectId,
  //             "${withOutPrimaryData[a].patientFName}${withOutPrimaryData[a].patientLName}",
  //             withOutPrimaryData[a].patientId,
  //             getActivityKeyWiseData.activityStartDate ?? DateTime.now(),
  //             getActivityKeyWiseData.activityEndDate ?? DateTime.now(),
  //             getActivityKeyWiseData.total ?? 0.0,
  //             identifierDataList: identifierDataExtra);
  //
  //
  //         await profiles.processResource(
  //             observation,
  //             Constant.observation,
  //             withOutPrimaryData[a].url,
  //             withOutPrimaryData[a].clientId,
  //             withOutPrimaryData[a].authToken);
  //       }
  //     }
  //   }
  //   /*delayCount++;
  //   if (delayCount == Constant.delayTimeLength) {
  //     delayCount = 0;
  //     await Utils.apiCallApplyDelay10second();
  //   }*/
  // }
  //
  // static Future<void> createChildActivityPeakHeatRateObservation(String activityName,ActivityTable getActivityKeyWiseData) async {
  //
  //   PaaProfiles profiles = PaaProfiles();
  //
  //   var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" &&
  //       element.isSelected).toList();
  //
  //   var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
  //   if(getPrimaryServerData.isNotEmpty){
  //     allSelectedServersUrl.remove(getPrimaryServerData[0]);
  //     allSelectedServersUrl.add(getPrimaryServerData[0]);
  //   }
  //
  //   // int delayCount = 0;
  //
  //   for (int j = 0; j < allSelectedServersUrl.length; j++) {
  //     if (allSelectedServersUrl[j].isSecure &&
  //         Utils.isExpiredToken(allSelectedServersUrl[j].lastLoggedTime,
  //             allSelectedServersUrl[j].expireTime)) {
  //       showDialog(
  //         context: getX.Get.context!,
  //         barrierDismissible: false,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: const Text("Session Expired"),
  //             content: Text(
  //                 "Your ${allSelectedServersUrl[j].title} has expired. Please log in again"),
  //             actions: <Widget>[
  //               TextButton(
  //                 onPressed: () async {
  //                   getX.Get.back();
  //                   Utils.callSecureServerAPI(
  //                       allSelectedServersUrl[j].url,
  //                       allSelectedServersUrl[j].clientId,
  //                       allSelectedServersUrl[j].title);
  //                 },
  //                 child: const Text("Log in"),
  //               ),
  //               TextButton(
  //                 onPressed: () {
  //                   getX.Get.back();
  //                 },
  //                 child: const Text("Cancel"),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //       return;
  //     }
  //
  //     if (getActivityKeyWiseData.serverDetailList.isNotEmpty) {
  //       getActivityKeyWiseData.isSync = true;
  //
  //       await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);
  //
  //       String observationId = "";
  //
  //       var objectId = "";
  //       var getServeIndex = getActivityKeyWiseData.serverDetailList
  //           .indexWhere(
  //               (element) => element.serverUrl == allSelectedServersUrl[j].url)
  //           .toInt();
  //
  //       if (getServeIndex != -1) {
  //         objectId =
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ??
  //                 "";
  //         getActivityKeyWiseData
  //             .serverDetailList[getServeIndex].dataSyncServerWise = true;
  //       }
  //
  //       if (getActivityKeyWiseData.serverDetailList.isNotEmpty &&
  //           getActivityKeyWiseData.identifierData.isNotEmpty) {
  //         var a = getActivityKeyWiseData.identifierData
  //             .indexWhere(
  //                 (element) => element.url == allSelectedServersUrl[j].url)
  //             .toInt();
  //         if (a != -1) {
  //           objectId = getActivityKeyWiseData.identifierData[a].objectId ?? "";
  //         }
  //       }
  //
  //       List<Identifier> identifier = [];
  //       if (allSelectedServersUrl[j].isPrimary) {
  //         var withOutPrimaryDataList = allSelectedServersUrl
  //             .where((element) => !element.isPrimary)
  //             .toList();
  //
  //         if (withOutPrimaryDataList.isNotEmpty) {
  //           for (int a = 0; a < withOutPrimaryDataList.length; a++) {
  //             if (getActivityKeyWiseData.serverDetailList.isNotEmpty) {
  //               var getServeIndex = getActivityKeyWiseData.serverDetailList
  //                   .indexWhere((element) =>
  //               element.serverUrl == withOutPrimaryDataList[a].url)
  //                   .toInt();
  //               if (getServeIndex != -1) {
  //                 identifier.add(Identifier(
  //                     value: getActivityKeyWiseData
  //                         .serverDetailList[getServeIndex].objectId,
  //                     system: FhirUri(getActivityKeyWiseData
  //                         .serverDetailList[getServeIndex].serverUrl)));
  //               }
  //             }
  //           }
  //         }
  //       }
  //
  //       Observation observation = profiles.createChildActivityPeakHeartRateObservation(
  //           objectId,
  //           "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}",
  //           allSelectedServersUrl[j].patientId,
  //           getActivityKeyWiseData.activityStartDate ?? DateTime.now(),
  //           getActivityKeyWiseData.activityEndDate ?? DateTime.now(),
  //           getActivityKeyWiseData.total ?? 0.0,
  //           identifierDataList: identifier);
  //
  //       observationId = await profiles.processResource(
  //           observation,
  //           Constant.observation,
  //           allSelectedServersUrl[j].url,
  //           allSelectedServersUrl[j].clientId,
  //           allSelectedServersUrl[j].authToken);
  //
  //       getActivityKeyWiseData.objectId = observationId;
  //
  //       if (getActivityKeyWiseData.serverDetailList
  //           .where((element) => element.objectId == observationId)
  //           .toList()
  //           .isEmpty) {
  //         getActivityKeyWiseData.serverDetailList[getServeIndex].objectId =
  //             observationId;
  //         getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl =
  //             allSelectedServersUrl[j].url;
  //         getActivityKeyWiseData.serverDetailList[getServeIndex].patientId =
  //             allSelectedServersUrl[j].patientId;
  //         getActivityKeyWiseData.serverDetailList[getServeIndex].patientName =
  //         "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";
  //       }
  //
  //       await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);
  //     }
  //   }
  //
  //   var withOutPrimaryData = Utils.getServerListPreference()
  //       .where((element) =>
  //   !element.isPrimary && element.isSelected && element.patientId != "")
  //       .toList();
  //   if (withOutPrimaryData.isNotEmpty) {
  //     List<Identifier> identifierDataExtra = [];
  //     for (int a = 0; a < withOutPrimaryData.length; a++) {
  //       identifierDataExtra.clear();
  //       if (withOutPrimaryData[a].isSecure &&
  //           Utils.isExpiredToken(withOutPrimaryData[a].lastLoggedTime,
  //               withOutPrimaryData[a].expireTime)) {
  //         showDialog(
  //           context: getX.Get.context!,
  //           barrierDismissible: false,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: const Text("Session Expired"),
  //               content: Text(
  //                   "Your ${withOutPrimaryData[a].title} has expired. Please log in again. RestHeart"),
  //               actions: <Widget>[
  //                 TextButton(
  //                   onPressed: () async {
  //                     getX.Get.back();
  //                     Utils.callSecureServerAPI(
  //                         withOutPrimaryData[a].url,
  //                         withOutPrimaryData[a].clientId,
  //                         withOutPrimaryData[a].title);
  //                   },
  //                   child: const Text("Log in"),
  //                 ),
  //                 TextButton(
  //                   onPressed: () {
  //                     getX.Get.back();
  //                   },
  //                   child: const Text("Cancel"),
  //                 ),
  //               ],
  //             );
  //           },
  //         );
  //         return;
  //       }
  //
  //       var callAPIWithThisURL = withOutPrimaryData[a].url;
  //
  //       var getAllObjectIdList = getActivityKeyWiseData.serverDetailList
  //           .where((element) => element.serverUrl != callAPIWithThisURL)
  //           .toList();
  //
  //       if (getAllObjectIdList.isNotEmpty) {
  //         for (int d = 0; d < getAllObjectIdList.length; d++) {
  //           identifierDataExtra.add(Identifier(
  //               value: getAllObjectIdList[d].objectId,
  //               system: FhirUri(getAllObjectIdList[d].serverUrl)));
  //         }
  //       }
  //
  //       var objectId = "";
  //       var getServeIndex = getActivityKeyWiseData.serverDetailList
  //           .indexWhere(
  //               (element) => element.serverUrl == withOutPrimaryData[a].url)
  //           .toInt();
  //       if (getServeIndex != -1) {
  //         objectId =
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ??
  //                 "";
  //         getActivityKeyWiseData
  //             .serverDetailList[getServeIndex].dataSyncServerWise = true;
  //       }
  //       if (getActivityKeyWiseData.serverDetailList.isNotEmpty &&
  //           getActivityKeyWiseData.identifierData.isNotEmpty) {
  //         var aObject = getActivityKeyWiseData.identifierData
  //             .indexWhere((element) => element.url == withOutPrimaryData[a].url)
  //             .toInt();
  //         if (aObject != -1) {
  //           objectId =
  //               getActivityKeyWiseData.identifierData[aObject].objectId ?? "";
  //         }
  //       }
  //
  //       if (identifierDataExtra.isNotEmpty) {
  //
  //         Observation observation = profiles.createChildActivityPeakHeartRateObservation(
  //             objectId,
  //             "${withOutPrimaryData[a].patientFName}${withOutPrimaryData[a].patientLName}",
  //             withOutPrimaryData[a].patientId,
  //             getActivityKeyWiseData.activityStartDate ?? DateTime.now(),
  //             getActivityKeyWiseData.activityEndDate ?? DateTime.now(),
  //             getActivityKeyWiseData.total ?? 0.0,
  //             identifierDataList: identifierDataExtra);
  //
  //
  //         await profiles.processResource(
  //             observation,
  //             Constant.observation,
  //             withOutPrimaryData[a].url,
  //             withOutPrimaryData[a].clientId,
  //             withOutPrimaryData[a].authToken);
  //       }
  //     }
  //   }
  //   /* delayCount++;
  //   if (delayCount == Constant.delayTimeLength) {
  //     delayCount = 0;
  //     await Utils.apiCallApplyDelay10second();
  //   }*/
  // }
  //
  // static Future<void> createChildActivityTotalMinObservation(String activityName,ActivityTable getActivityKeyWiseData) async {
  //
  //   PaaProfiles profiles = PaaProfiles();
  //
  //   var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" &&
  //       element.isSelected).toList();
  //
  //   var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
  //   if(getPrimaryServerData.isNotEmpty){
  //     allSelectedServersUrl.remove(getPrimaryServerData[0]);
  //     allSelectedServersUrl.add(getPrimaryServerData[0]);
  //   }
  //
  //   // int delayCount = 0;
  //
  //   for (int j = 0; j < allSelectedServersUrl.length; j++) {
  //     if (allSelectedServersUrl[j].isSecure &&
  //         Utils.isExpiredToken(allSelectedServersUrl[j].lastLoggedTime,
  //             allSelectedServersUrl[j].expireTime)) {
  //       showDialog(
  //         context: getX.Get.context!,
  //         barrierDismissible: false,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: const Text("Session Expired"),
  //             content: Text(
  //                 "Your ${allSelectedServersUrl[j].title} has expired. Please log in again"),
  //             actions: <Widget>[
  //               TextButton(
  //                 onPressed: () async {
  //                   getX.Get.back();
  //                   Utils.callSecureServerAPI(
  //                       allSelectedServersUrl[j].url,
  //                       allSelectedServersUrl[j].clientId,
  //                       allSelectedServersUrl[j].title);
  //                 },
  //                 child: const Text("Log in"),
  //               ),
  //               TextButton(
  //                 onPressed: () {
  //                   getX.Get.back();
  //                 },
  //                 child: const Text("Cancel"),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //       return;
  //     }
  //
  //     if (getActivityKeyWiseData.serverDetailList.isNotEmpty) {
  //       getActivityKeyWiseData.isSync = true;
  //
  //       await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);
  //
  //       String observationId = "";
  //
  //       var objectId = "";
  //       var getServeIndex = getActivityKeyWiseData.serverDetailList
  //           .indexWhere(
  //               (element) => element.serverUrl == allSelectedServersUrl[j].url)
  //           .toInt();
  //
  //       if (getServeIndex != -1) {
  //         objectId =
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ??
  //                 "";
  //         getActivityKeyWiseData
  //             .serverDetailList[getServeIndex].dataSyncServerWise = true;
  //       }
  //
  //       if (getActivityKeyWiseData.serverDetailList.isNotEmpty &&
  //           getActivityKeyWiseData.identifierData.isNotEmpty) {
  //         var a = getActivityKeyWiseData.identifierData
  //             .indexWhere(
  //                 (element) => element.url == allSelectedServersUrl[j].url)
  //             .toInt();
  //         if (a != -1) {
  //           objectId = getActivityKeyWiseData.identifierData[a].objectId ?? "";
  //         }
  //       }
  //
  //       List<Identifier> identifier = [];
  //       if (allSelectedServersUrl[j].isPrimary) {
  //         var withOutPrimaryDataList = allSelectedServersUrl
  //             .where((element) => !element.isPrimary)
  //             .toList();
  //
  //         if (withOutPrimaryDataList.isNotEmpty) {
  //           for (int a = 0; a < withOutPrimaryDataList.length; a++) {
  //             if (getActivityKeyWiseData.serverDetailList.isNotEmpty) {
  //               var getServeIndex = getActivityKeyWiseData.serverDetailList
  //                   .indexWhere((element) =>
  //               element.serverUrl == withOutPrimaryDataList[a].url)
  //                   .toInt();
  //               if (getServeIndex != -1) {
  //                 identifier.add(Identifier(
  //                     value: getActivityKeyWiseData
  //                         .serverDetailList[getServeIndex].objectId,
  //                     system: FhirUri(getActivityKeyWiseData
  //                         .serverDetailList[getServeIndex].serverUrl)));
  //               }
  //             }
  //           }
  //         }
  //       }
  //
  //       Observation observation = profiles.createChildActivityTotalMinObservation(
  //           objectId,
  //           "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}",
  //           allSelectedServersUrl[j].patientId,
  //           getActivityKeyWiseData.activityStartDate ?? DateTime.now(),
  //           getActivityKeyWiseData.activityEndDate ?? DateTime.now(),
  //           getActivityKeyWiseData.total ?? 0.0,
  //           identifierDataList: identifier);
  //
  //       observationId = await profiles.processResource(
  //           observation,
  //           Constant.observation,
  //           allSelectedServersUrl[j].url,
  //           allSelectedServersUrl[j].clientId,
  //           allSelectedServersUrl[j].authToken);
  //
  //       getActivityKeyWiseData.objectId = observationId;
  //
  //       if (getActivityKeyWiseData.serverDetailList
  //           .where((element) => element.objectId == observationId)
  //           .toList()
  //           .isEmpty) {
  //         getActivityKeyWiseData.serverDetailList[getServeIndex].objectId =
  //             observationId;
  //         getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl =
  //             allSelectedServersUrl[j].url;
  //         getActivityKeyWiseData.serverDetailList[getServeIndex].patientId =
  //             allSelectedServersUrl[j].patientId;
  //         getActivityKeyWiseData.serverDetailList[getServeIndex].patientName =
  //         "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";
  //       }
  //
  //       await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);
  //     }
  //   }
  //
  //   var withOutPrimaryData = Utils.getServerListPreference()
  //       .where((element) =>
  //   !element.isPrimary && element.isSelected && element.patientId != "")
  //       .toList();
  //   if (withOutPrimaryData.isNotEmpty) {
  //     List<Identifier> identifierDataExtra = [];
  //     for (int a = 0; a < withOutPrimaryData.length; a++) {
  //       identifierDataExtra.clear();
  //       if (withOutPrimaryData[a].isSecure &&
  //           Utils.isExpiredToken(withOutPrimaryData[a].lastLoggedTime,
  //               withOutPrimaryData[a].expireTime)) {
  //         showDialog(
  //           context: getX.Get.context!,
  //           barrierDismissible: false,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: const Text("Session Expired"),
  //               content: Text(
  //                   "Your ${withOutPrimaryData[a].title} has expired. Please log in again. RestHeart"),
  //               actions: <Widget>[
  //                 TextButton(
  //                   onPressed: () async {
  //                     getX.Get.back();
  //                     Utils.callSecureServerAPI(
  //                         withOutPrimaryData[a].url,
  //                         withOutPrimaryData[a].clientId,
  //                         withOutPrimaryData[a].title);
  //                   },
  //                   child: const Text("Log in"),
  //                 ),
  //                 TextButton(
  //                   onPressed: () {
  //                     getX.Get.back();
  //                   },
  //                   child: const Text("Cancel"),
  //                 ),
  //               ],
  //             );
  //           },
  //         );
  //         return;
  //       }
  //
  //       var callAPIWithThisURL = withOutPrimaryData[a].url;
  //
  //       var getAllObjectIdList = getActivityKeyWiseData.serverDetailList
  //           .where((element) => element.serverUrl != callAPIWithThisURL)
  //           .toList();
  //
  //       if (getAllObjectIdList.isNotEmpty) {
  //         for (int d = 0; d < getAllObjectIdList.length; d++) {
  //           identifierDataExtra.add(Identifier(
  //               value: getAllObjectIdList[d].objectId,
  //               system: FhirUri(getAllObjectIdList[d].serverUrl)));
  //         }
  //       }
  //
  //       var objectId = "";
  //       var getServeIndex = getActivityKeyWiseData.serverDetailList
  //           .indexWhere(
  //               (element) => element.serverUrl == withOutPrimaryData[a].url)
  //           .toInt();
  //       if (getServeIndex != -1) {
  //         objectId =
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ??
  //                 "";
  //         getActivityKeyWiseData
  //             .serverDetailList[getServeIndex].dataSyncServerWise = true;
  //       }
  //       if (getActivityKeyWiseData.serverDetailList.isNotEmpty &&
  //           getActivityKeyWiseData.identifierData.isNotEmpty) {
  //         var aObject = getActivityKeyWiseData.identifierData
  //             .indexWhere((element) => element.url == withOutPrimaryData[a].url)
  //             .toInt();
  //         if (aObject != -1) {
  //           objectId =
  //               getActivityKeyWiseData.identifierData[aObject].objectId ?? "";
  //         }
  //       }
  //
  //       if (identifierDataExtra.isNotEmpty) {
  //
  //         Observation observation = profiles.createChildActivityTotalMinObservation(
  //             objectId,
  //             "${withOutPrimaryData[a].patientFName}${withOutPrimaryData[a].patientLName}",
  //             withOutPrimaryData[a].patientId,
  //             getActivityKeyWiseData.activityStartDate ?? DateTime.now(),
  //             getActivityKeyWiseData.activityEndDate ?? DateTime.now(),
  //             getActivityKeyWiseData.total ?? 0.0,
  //             identifierDataList: identifierDataExtra);
  //
  //
  //         await profiles.processResource(
  //             observation,
  //             Constant.observation,
  //             withOutPrimaryData[a].url,
  //             withOutPrimaryData[a].clientId,
  //             withOutPrimaryData[a].authToken);
  //       }
  //     }
  //   }
  // }
  //
  // static Future<void> createChildActivityModerateMinObservation(String activityName,ActivityTable getActivityKeyWiseData) async {
  //
  //   PaaProfiles profiles = PaaProfiles();
  //
  //   var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" &&
  //       element.isSelected).toList();
  //
  //   var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
  //   if(getPrimaryServerData.isNotEmpty){
  //     allSelectedServersUrl.remove(getPrimaryServerData[0]);
  //     allSelectedServersUrl.add(getPrimaryServerData[0]);
  //   }
  //
  //   // int delayCount = 0;
  //
  //   for (int j = 0; j < allSelectedServersUrl.length; j++) {
  //     if (allSelectedServersUrl[j].isSecure &&
  //         Utils.isExpiredToken(allSelectedServersUrl[j].lastLoggedTime,
  //             allSelectedServersUrl[j].expireTime)) {
  //       showDialog(
  //         context: getX.Get.context!,
  //         barrierDismissible: false,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: const Text("Session Expired"),
  //             content: Text(
  //                 "Your ${allSelectedServersUrl[j].title} has expired. Please log in again"),
  //             actions: <Widget>[
  //               TextButton(
  //                 onPressed: () async {
  //                   getX.Get.back();
  //                   Utils.callSecureServerAPI(
  //                       allSelectedServersUrl[j].url,
  //                       allSelectedServersUrl[j].clientId,
  //                       allSelectedServersUrl[j].title);
  //                 },
  //                 child: const Text("Log in"),
  //               ),
  //               TextButton(
  //                 onPressed: () {
  //                   getX.Get.back();
  //                 },
  //                 child: const Text("Cancel"),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //       return;
  //     }
  //
  //     if (getActivityKeyWiseData.serverDetailListModMin.isNotEmpty) {
  //       getActivityKeyWiseData.isSync = true;
  //
  //       await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);
  //
  //       String observationId = "";
  //
  //       var objectId = "";
  //       var getServeIndex = getActivityKeyWiseData.serverDetailListModMin
  //           .indexWhere(
  //               (element) => element.modServerUrl == allSelectedServersUrl[j].url)
  //           .toInt();
  //
  //       if (getServeIndex != -1) {
  //         objectId =
  //             getActivityKeyWiseData.serverDetailListModMin[getServeIndex].modObjectId ??
  //                 "";
  //         getActivityKeyWiseData
  //             .serverDetailListModMin[getServeIndex].modDataSyncServerWise = true;
  //       }
  //
  //       if (getActivityKeyWiseData.serverDetailListModMin.isNotEmpty &&
  //           getActivityKeyWiseData.identifierDataModMin.isNotEmpty) {
  //         var a = getActivityKeyWiseData.identifierDataModMin
  //             .indexWhere(
  //                 (element) => element.url == allSelectedServersUrl[j].url)
  //             .toInt();
  //         if (a != -1) {
  //           objectId = getActivityKeyWiseData.identifierDataModMin[a].objectId ?? "";
  //         }
  //       }
  //
  //       List<Identifier> identifier = [];
  //       if (allSelectedServersUrl[j].isPrimary) {
  //         var withOutPrimaryDataList = allSelectedServersUrl
  //             .where((element) => !element.isPrimary)
  //             .toList();
  //
  //         if (withOutPrimaryDataList.isNotEmpty) {
  //           for (int a = 0; a < withOutPrimaryDataList.length; a++) {
  //             if (getActivityKeyWiseData.serverDetailListModMin.isNotEmpty) {
  //               var getServeIndex = getActivityKeyWiseData.serverDetailListModMin
  //                   .indexWhere((element) =>
  //               element.modServerUrl == withOutPrimaryDataList[a].url)
  //                   .toInt();
  //               if (getServeIndex != -1) {
  //                 identifier.add(Identifier(
  //                     value: getActivityKeyWiseData
  //                         .serverDetailListModMin[getServeIndex].modObjectId,
  //                     system: FhirUri(getActivityKeyWiseData
  //                         .serverDetailListModMin[getServeIndex].modServerUrl)));
  //               }
  //             }
  //           }
  //         }
  //       }
  //
  //       Observation observation = profiles.createChildActivityModerateMinObservation(
  //           objectId,
  //           "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}",
  //           allSelectedServersUrl[j].patientId,
  //           getActivityKeyWiseData.activityStartDate ?? DateTime.now(),
  //           getActivityKeyWiseData.activityEndDate ?? DateTime.now(),
  //           getActivityKeyWiseData.value1 ?? 0.0,
  //           identifierDataList: identifier);
  //
  //       observationId = await profiles.processResource(
  //           observation,
  //           Constant.observation,
  //           allSelectedServersUrl[j].url,
  //           allSelectedServersUrl[j].clientId,
  //           allSelectedServersUrl[j].authToken);
  //
  //       getActivityKeyWiseData.objectId = observationId;
  //
  //       if (getActivityKeyWiseData.serverDetailListModMin
  //           .where((element) => element.modObjectId == observationId)
  //           .toList()
  //           .isEmpty) {
  //         getActivityKeyWiseData.serverDetailListModMin[getServeIndex].modObjectId =
  //             observationId;
  //         getActivityKeyWiseData.serverDetailListModMin[getServeIndex].modServerUrl =
  //             allSelectedServersUrl[j].url;
  //         getActivityKeyWiseData.serverDetailListModMin[getServeIndex].modPatientId =
  //             allSelectedServersUrl[j].patientId;
  //         getActivityKeyWiseData.serverDetailListModMin[getServeIndex].modPatientName =
  //         "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";
  //       }
  //
  //       await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);
  //     }
  //   }
  //
  //   var withOutPrimaryData = Utils.getServerListPreference()
  //       .where((element) =>
  //   !element.isPrimary && element.isSelected && element.patientId != "")
  //       .toList();
  //   if (withOutPrimaryData.isNotEmpty) {
  //     List<Identifier> identifierDataExtra = [];
  //     for (int a = 0; a < withOutPrimaryData.length; a++) {
  //       identifierDataExtra.clear();
  //       if (withOutPrimaryData[a].isSecure &&
  //           Utils.isExpiredToken(withOutPrimaryData[a].lastLoggedTime,
  //               withOutPrimaryData[a].expireTime)) {
  //         showDialog(
  //           context: getX.Get.context!,
  //           barrierDismissible: false,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: const Text("Session Expired"),
  //               content: Text(
  //                   "Your ${withOutPrimaryData[a].title} has expired. Please log in again. RestHeart"),
  //               actions: <Widget>[
  //                 TextButton(
  //                   onPressed: () async {
  //                     getX.Get.back();
  //                     Utils.callSecureServerAPI(
  //                         withOutPrimaryData[a].url,
  //                         withOutPrimaryData[a].clientId,
  //                         withOutPrimaryData[a].title);
  //                   },
  //                   child: const Text("Log in"),
  //                 ),
  //                 TextButton(
  //                   onPressed: () {
  //                     getX.Get.back();
  //                   },
  //                   child: const Text("Cancel"),
  //                 ),
  //               ],
  //             );
  //           },
  //         );
  //         return;
  //       }
  //
  //       var callAPIWithThisURL = withOutPrimaryData[a].url;
  //
  //       var getAllObjectIdList = getActivityKeyWiseData.serverDetailListModMin
  //           .where((element) => element.modServerUrl != callAPIWithThisURL)
  //           .toList();
  //
  //       if (getAllObjectIdList.isNotEmpty) {
  //         for (int d = 0; d < getAllObjectIdList.length; d++) {
  //           identifierDataExtra.add(Identifier(
  //               value: getAllObjectIdList[d].modObjectId,
  //               system: FhirUri(getAllObjectIdList[d].modServerUrl)));
  //         }
  //       }
  //
  //       var objectId = "";
  //       var getServeIndex = getActivityKeyWiseData.serverDetailListModMin
  //           .indexWhere(
  //               (element) => element.modServerUrl == withOutPrimaryData[a].url)
  //           .toInt();
  //       if (getServeIndex != -1) {
  //         objectId =
  //             getActivityKeyWiseData.serverDetailListModMin[getServeIndex].modObjectId ??
  //                 "";
  //         getActivityKeyWiseData
  //             .serverDetailListModMin[getServeIndex].modDataSyncServerWise = true;
  //       }
  //       if (getActivityKeyWiseData.serverDetailListModMin.isNotEmpty &&
  //           getActivityKeyWiseData.identifierDataModMin.isNotEmpty) {
  //         var aObject = getActivityKeyWiseData.identifierDataModMin
  //             .indexWhere((element) => element.url == withOutPrimaryData[a].url)
  //             .toInt();
  //         if (aObject != -1) {
  //           objectId =
  //               getActivityKeyWiseData.identifierDataModMin[aObject].objectId ?? "";
  //         }
  //       }
  //
  //       if (identifierDataExtra.isNotEmpty) {
  //
  //         Observation observation = profiles.createChildActivityModerateMinObservation(
  //             objectId,
  //             "${withOutPrimaryData[a].patientFName}${withOutPrimaryData[a].patientLName}",
  //             withOutPrimaryData[a].patientId,
  //             getActivityKeyWiseData.activityStartDate ?? DateTime.now(),
  //             getActivityKeyWiseData.activityEndDate ?? DateTime.now(),
  //             getActivityKeyWiseData.value1 ?? 0.0,
  //             identifierDataList: identifierDataExtra);
  //
  //
  //         await profiles.processResource(
  //             observation,
  //             Constant.observation,
  //             withOutPrimaryData[a].url,
  //             withOutPrimaryData[a].clientId,
  //             withOutPrimaryData[a].authToken);
  //       }
  //     }
  //   }
  // }
  //
  // static Future<void> createChildActivityVigMinObservation(String activityName,ActivityTable getActivityKeyWiseData) async {
  //
  //   PaaProfiles profiles = PaaProfiles();
  //
  //   var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" &&
  //       element.isSelected).toList();
  //
  //   var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
  //   if(getPrimaryServerData.isNotEmpty){
  //     allSelectedServersUrl.remove(getPrimaryServerData[0]);
  //     allSelectedServersUrl.add(getPrimaryServerData[0]);
  //   }
  //
  //   for (int j = 0; j < allSelectedServersUrl.length; j++) {
  //     if (allSelectedServersUrl[j].isSecure &&
  //         Utils.isExpiredToken(allSelectedServersUrl[j].lastLoggedTime,
  //             allSelectedServersUrl[j].expireTime)) {
  //       showDialog(
  //         context: getX.Get.context!,
  //         barrierDismissible: false,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: const Text("Session Expired"),
  //             content: Text(
  //                 "Your ${allSelectedServersUrl[j].title} has expired. Please log in again"),
  //             actions: <Widget>[
  //               TextButton(
  //                 onPressed: () async {
  //                   getX.Get.back();
  //                   Utils.callSecureServerAPI(
  //                       allSelectedServersUrl[j].url,
  //                       allSelectedServersUrl[j].clientId,
  //                       allSelectedServersUrl[j].title);
  //                 },
  //                 child: const Text("Log in"),
  //               ),
  //               TextButton(
  //                 onPressed: () {
  //                   getX.Get.back();
  //                 },
  //                 child: const Text("Cancel"),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //       return;
  //     }
  //
  //     if (getActivityKeyWiseData.serverDetailListVigMin.isNotEmpty) {
  //       getActivityKeyWiseData.isSync = true;
  //
  //       await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);
  //
  //       String observationId = "";
  //
  //       var objectId = "";
  //       var getServeIndex = getActivityKeyWiseData.serverDetailListVigMin
  //           .indexWhere(
  //               (element) => element.vigServerUrl == allSelectedServersUrl[j].url)
  //           .toInt();
  //
  //       if (getServeIndex != -1) {
  //         objectId =
  //             getActivityKeyWiseData.serverDetailListVigMin[getServeIndex].vigObjectId ??
  //                 "";
  //         getActivityKeyWiseData
  //             .serverDetailListVigMin[getServeIndex].vigDataSyncServerWise = true;
  //       }
  //
  //       if (getActivityKeyWiseData.serverDetailListVigMin.isNotEmpty &&
  //           getActivityKeyWiseData.identifierDataVigMin.isNotEmpty) {
  //         var a = getActivityKeyWiseData.identifierDataVigMin
  //             .indexWhere(
  //                 (element) => element.url == allSelectedServersUrl[j].url)
  //             .toInt();
  //         if (a != -1) {
  //           objectId = getActivityKeyWiseData.identifierDataVigMin[a].objectId ?? "";
  //         }
  //       }
  //
  //       List<Identifier> identifier = [];
  //       if (allSelectedServersUrl[j].isPrimary) {
  //         var withOutPrimaryDataList = allSelectedServersUrl
  //             .where((element) => !element.isPrimary)
  //             .toList();
  //
  //         if (withOutPrimaryDataList.isNotEmpty) {
  //           for (int a = 0; a < withOutPrimaryDataList.length; a++) {
  //             if (getActivityKeyWiseData.serverDetailListVigMin.isNotEmpty) {
  //               var getServeIndex = getActivityKeyWiseData.serverDetailListVigMin
  //                   .indexWhere((element) =>
  //               element.vigServerUrl == withOutPrimaryDataList[a].url)
  //                   .toInt();
  //               if (getServeIndex != -1) {
  //                 identifier.add(Identifier(
  //                     value: getActivityKeyWiseData
  //                         .serverDetailListVigMin[getServeIndex].vigObjectId,
  //                     system: FhirUri(getActivityKeyWiseData
  //                         .serverDetailListVigMin[getServeIndex].vigServerUrl)));
  //               }
  //             }
  //           }
  //         }
  //       }
  //
  //       Observation observation = profiles.createChildActivityVigorousMinObservation(
  //           objectId,
  //           "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}",
  //           allSelectedServersUrl[j].patientId,
  //           getActivityKeyWiseData.activityStartDate ?? DateTime.now(),
  //           getActivityKeyWiseData.activityEndDate ?? DateTime.now(),
  //           getActivityKeyWiseData.value2 ?? 0.0,
  //           identifierDataList: identifier);
  //
  //       observationId = await profiles.processResource(
  //           observation,
  //           Constant.observation,
  //           allSelectedServersUrl[j].url,
  //           allSelectedServersUrl[j].clientId,
  //           allSelectedServersUrl[j].authToken);
  //
  //       getActivityKeyWiseData.objectId = observationId;
  //
  //       if (getActivityKeyWiseData.serverDetailListVigMin
  //           .where((element) => element.vigObjectId == observationId)
  //           .toList()
  //           .isEmpty) {
  //         getActivityKeyWiseData.serverDetailListVigMin[getServeIndex].vigObjectId =
  //             observationId;
  //         getActivityKeyWiseData.serverDetailListVigMin[getServeIndex].vigServerUrl =
  //             allSelectedServersUrl[j].url;
  //         getActivityKeyWiseData.serverDetailListVigMin[getServeIndex].vigPatientId =
  //             allSelectedServersUrl[j].patientId;
  //         getActivityKeyWiseData.serverDetailListVigMin[getServeIndex].vigPatientName =
  //         "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";
  //       }
  //
  //       await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);
  //     }
  //   }
  //
  //   var withOutPrimaryData = Utils.getServerListPreference()
  //       .where((element) =>
  //   !element.isPrimary && element.isSelected && element.patientId != "")
  //       .toList();
  //   if (withOutPrimaryData.isNotEmpty) {
  //     List<Identifier> identifierDataExtra = [];
  //     for (int a = 0; a < withOutPrimaryData.length; a++) {
  //       identifierDataExtra.clear();
  //       if (withOutPrimaryData[a].isSecure &&
  //           Utils.isExpiredToken(withOutPrimaryData[a].lastLoggedTime,
  //               withOutPrimaryData[a].expireTime)) {
  //         showDialog(
  //           context: getX.Get.context!,
  //           barrierDismissible: false,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: const Text("Session Expired"),
  //               content: Text(
  //                   "Your ${withOutPrimaryData[a].title} has expired. Please log in again. RestHeart"),
  //               actions: <Widget>[
  //                 TextButton(
  //                   onPressed: () async {
  //                     getX.Get.back();
  //                     Utils.callSecureServerAPI(
  //                         withOutPrimaryData[a].url,
  //                         withOutPrimaryData[a].clientId,
  //                         withOutPrimaryData[a].title);
  //                   },
  //                   child: const Text("Log in"),
  //                 ),
  //                 TextButton(
  //                   onPressed: () {
  //                     getX.Get.back();
  //                   },
  //                   child: const Text("Cancel"),
  //                 ),
  //               ],
  //             );
  //           },
  //         );
  //         return;
  //       }
  //
  //       var callAPIWithThisURL = withOutPrimaryData[a].url;
  //
  //       var getAllObjectIdList = getActivityKeyWiseData.serverDetailListVigMin
  //           .where((element) => element.vigServerUrl != callAPIWithThisURL)
  //           .toList();
  //
  //       if (getAllObjectIdList.isNotEmpty) {
  //         for (int d = 0; d < getAllObjectIdList.length; d++) {
  //           identifierDataExtra.add(Identifier(
  //               value: getAllObjectIdList[d].vigObjectId,
  //               system: FhirUri(getAllObjectIdList[d].vigServerUrl)));
  //         }
  //       }
  //
  //       var objectId = "";
  //       var getServeIndex = getActivityKeyWiseData.serverDetailListVigMin
  //           .indexWhere(
  //               (element) => element.vigServerUrl == withOutPrimaryData[a].url)
  //           .toInt();
  //       if (getServeIndex != -1) {
  //         objectId =
  //             getActivityKeyWiseData.serverDetailListVigMin[getServeIndex].vigObjectId ??
  //                 "";
  //         getActivityKeyWiseData
  //             .serverDetailListVigMin[getServeIndex].vigDataSyncServerWise = true;
  //       }
  //       if (getActivityKeyWiseData.serverDetailListVigMin.isNotEmpty &&
  //           getActivityKeyWiseData.identifierDataVigMin.isNotEmpty) {
  //         var aObject = getActivityKeyWiseData.identifierDataVigMin
  //             .indexWhere((element) => element.url == withOutPrimaryData[a].url)
  //             .toInt();
  //         if (aObject != -1) {
  //           objectId =
  //               getActivityKeyWiseData.identifierDataVigMin[aObject].objectId ?? "";
  //         }
  //       }
  //
  //       if (identifierDataExtra.isNotEmpty) {
  //
  //         Observation observation = profiles.createChildActivityVigorousMinObservation(
  //             objectId,
  //             "${withOutPrimaryData[a].patientFName}${withOutPrimaryData[a].patientLName}",
  //             withOutPrimaryData[a].patientId,
  //             getActivityKeyWiseData.activityStartDate ?? DateTime.now(),
  //             getActivityKeyWiseData.activityEndDate ?? DateTime.now(),
  //             getActivityKeyWiseData.value2 ?? 0.0,
  //             identifierDataList: identifierDataExtra);
  //
  //
  //         await profiles.processResource(
  //             observation,
  //             Constant.observation,
  //             withOutPrimaryData[a].url,
  //             withOutPrimaryData[a].clientId,
  //             withOutPrimaryData[a].authToken);
  //       }
  //     }
  //   }
  // }

  static List<ActivityTable> getActivityListData(){
    return Hive.box<ActivityTable>(Constant.tableActivity).values.toList().where((element) =>
    element.patientId == Utils.getPatientId()).toList();
  }

  ///*Monthly observation
  // static Future<void> observationSyncDataDaysPerWeeks( List<SyncMonthlyActivityData> allSyncingData) async {
  //
  //   PaaProfiles profiles = PaaProfiles();
  //   var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
  //   var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
  //   if(getPrimaryServerData.isNotEmpty){
  //     allSelectedServersUrl.remove(getPrimaryServerData[0]);
  //     allSelectedServersUrl.add(getPrimaryServerData[0]);
  //   }
  //   /// Here you all data that we want to send in to backend ==>> allSyncingData
  //   int delayCount = 0;
  //   // int delayCountFiveSecond = 0;
  //   for (int i = 0; i < allSyncingData.length; i++) {
  //     for (int j = 0; j < allSelectedServersUrl.length; j++) {
  //       /// You can start your API call from here
  //       if(allSelectedServersUrl[j].isSecure && Utils.isExpiredToken(allSelectedServersUrl[j].lastLoggedTime,allSelectedServersUrl[j].expireTime)){
  //         showDialog(
  //           context: getX.Get.context!,
  //           barrierDismissible: false,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: const Text("Session Expired"),
  //               content: Text("Your ${allSelectedServersUrl[j].title} has expired. Please log in again. DaysPerWeeks"),
  //               actions: <Widget>[
  //                 TextButton(
  //                   onPressed: () async {
  //                     getX.Get.back();
  //                     Utils.callSecureServerAPI(allSelectedServersUrl[j].url,
  //                         allSelectedServersUrl[j].clientId,
  //                         allSelectedServersUrl[j].title);
  //                   },
  //                   child: const Text("Log in"),
  //                 ),
  //                 TextButton(
  //                   onPressed: () {
  //                     getX.Get.back();
  //                   },
  //                   child: const Text("Cancel"),
  //                 ),
  //               ],
  //             );
  //           },
  //         );
  //         return;
  //       }
  //       var activityData = allSyncingData[i];
  //       if (activityData.headerType == Constant.headerDayPerWeek) {
  //         MonthlyLogTableData getActivityKeyWiseData = await DataBaseHelper
  //             .shared
  //             .getMonthlyData(activityData.keyId);
  //         // for (int a = 0; a <
  //         //     getActivityKeyWiseData.syncDayPerWeekServerWiseList.length; a++) {
  //         //   getActivityKeyWiseData.syncDayPerWeekServerWiseList[a] = true;
  //         // }
  //         if (getActivityKeyWiseData.serverDetailListDayPerWeek.isNotEmpty) {
  //           if (activityData.headerType == Constant.headerDayPerWeek) {
  //             getActivityKeyWiseData.isSyncDayPerWeek = true;
  //
  //             await DataBaseHelper.shared.updateMonthlyData(
  //                 getActivityKeyWiseData);
  //
  //             String observationId = "";
  //
  //             var objectId = "";
  //             var getServeIndex = getActivityKeyWiseData.serverDetailListDayPerWeek
  //                 .indexWhere((element) =>
  //             element.serverUrl ==
  //                 allSelectedServersUrl[j].url).toInt();
  //
  //             if (getServeIndex != -1) {
  //               objectId =
  //                   getActivityKeyWiseData.serverDetailListDayPerWeek[getServeIndex].objectId ?? "";
  //               getActivityKeyWiseData
  //                   .serverDetailListDayPerWeek[getServeIndex].dataSyncServerWise = true;
  //
  //               await DataBaseHelper.shared.updateMonthlyData(
  //                   getActivityKeyWiseData);
  //             }
  //             if(getActivityKeyWiseData.serverDetailListDayPerWeek.isNotEmpty &&
  //                 getActivityKeyWiseData.dayPerWeekIdentifierData.isNotEmpty){
  //               var a = getActivityKeyWiseData.dayPerWeekIdentifierData.indexWhere((element) => element.url == allSelectedServersUrl[j].url).toInt();
  //               if(a != -1){
  //                 objectId = getActivityKeyWiseData.dayPerWeekIdentifierData[a].objectId ?? "";
  //               }
  //             }
  //             List<Identifier> identifier = [];
  //             if(allSelectedServersUrl[j].isPrimary){
  //               var withOutPrimaryDataList = allSelectedServersUrl.where((element) => !element.isPrimary).toList();
  //               if(withOutPrimaryDataList.isNotEmpty){
  //                 for (int a = 0; a < withOutPrimaryDataList.length; a++) {
  //                   if(getActivityKeyWiseData.serverDetailListDayPerWeek.isNotEmpty) {
  //                     var getServeIndex = getActivityKeyWiseData.serverDetailListDayPerWeek
  //                         .indexWhere((element) =>
  //                     element.serverUrl ==
  //                         withOutPrimaryDataList[a].url).toInt();
  //                     if(getServeIndex != -1){
  //                       identifier.add(Identifier(value: getActivityKeyWiseData.serverDetailListDayPerWeek[getServeIndex]
  //                           .objectId,
  //                           system: FhirUri(getActivityKeyWiseData.serverDetailListDayPerWeek[getServeIndex]
  //                               .serverUrl)));
  //                     }
  //                   }
  //
  //                 }
  //               }
  //             }
  //             Observation observation = profiles.createObservationDaysPerWeeks(
  //                 allSyncingData[i], objectId, "${allSelectedServersUrl[j]
  //                 .patientFName}${allSelectedServersUrl[j].patientLName}",
  //                 allSelectedServersUrl[j].patientId,identifierDataList: identifier);
  //
  //             observationId =
  //             await profiles.processResource(
  //                 observation, Constant.trackingChart,
  //                 allSelectedServersUrl[j].url,
  //                 allSelectedServersUrl[j].clientId,
  //                 allSelectedServersUrl[j].authToken);
  //
  //             getActivityKeyWiseData.dayPerWeekId = observationId;
  //
  //             /*if (!getActivityKeyWiseData.objectIdDayPerWeekList.contains(
  //                 observationId)) {
  //               getActivityKeyWiseData.objectIdDayPerWeekList[getServeIndex] =
  //                   observationId;
  //
  //               if (getActivityKeyWiseData
  //                   .serverUrlDayPerWeekList[getServeIndex] != "") {
  //                 getActivityKeyWiseData
  //                     .serverUrlDayPerWeekList[getServeIndex] =
  //                     allSelectedServersUrl[j].url;
  //               }
  //               if (getActivityKeyWiseData
  //                   .patientIdDayPerWeekList[getServeIndex] != "") {
  //                 getActivityKeyWiseData
  //                     .patientIdDayPerWeekList[getServeIndex] =
  //                     allSelectedServersUrl[j].patientId;
  //               }
  //               if (getActivityKeyWiseData
  //                   .patientNameDayPerWeekList[getServeIndex] != "") {
  //                 getActivityKeyWiseData
  //                     .patientNameDayPerWeekList[getServeIndex] =
  //                 "${allSelectedServersUrl[j]
  //                     .patientFName}${allSelectedServersUrl[j].patientLName}";
  //               }
  //             }*/
  //
  //             if(getActivityKeyWiseData.serverDetailListDayPerWeek.where((element) => element.objectId
  //                 == observationId).toList().isEmpty) {
  //               getActivityKeyWiseData.serverDetailListDayPerWeek[getServeIndex].objectId = observationId;
  //               getActivityKeyWiseData.serverDetailListDayPerWeek[getServeIndex].serverUrl = allSelectedServersUrl[j].url;
  //               getActivityKeyWiseData.serverDetailListDayPerWeek[getServeIndex].patientId = allSelectedServersUrl[j].patientId;
  //               getActivityKeyWiseData.serverDetailListDayPerWeek[getServeIndex].patientName =  "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";
  //             }
  //
  //
  //             await DataBaseHelper.shared.updateMonthlyData(
  //                 getActivityKeyWiseData);
  //           }
  //         }
  //       }
  //       /* delayCountFiveSecond++;
  //       if(delayCountFiveSecond == 10){
  //         delayCountFiveSecond = 0;
  //         await Utils.apiCallApplyDelay5second();
  //       }*/
  //     }
  //
  //     var activityData = allSyncingData[i];
  //     if (activityData.headerType == Constant.headerDayPerWeek) {
  //       var withOutPrimaryData = Utils.getServerListPreference().where((
  //           element) =>
  //       !element.isPrimary
  //           && element.isSelected && element.patientId != "").toList();
  //       if (withOutPrimaryData.isNotEmpty) {
  //         List<Identifier> identifierDataExtra = [];
  //         for (int a = 0; a < withOutPrimaryData.length; a++) {
  //           identifierDataExtra.clear();
  //           if (withOutPrimaryData[a].isSecure &&
  //               Utils.isExpiredToken(withOutPrimaryData[a].lastLoggedTime,
  //                   withOutPrimaryData[a].expireTime)) {
  //             showDialog(
  //               context: getX.Get.context!,
  //               barrierDismissible: false,
  //               builder: (BuildContext context) {
  //                 return AlertDialog(
  //                   title: const Text("Session Expired"),
  //                   content: Text("Your ${withOutPrimaryData[a]
  //                       .title} has expired. Please log in again. RestHeart"),
  //                   actions: <Widget>[
  //                     TextButton(
  //                       onPressed: () async {
  //                         getX.Get.back();
  //                         Utils.callSecureServerAPI(withOutPrimaryData[a].url,
  //                             withOutPrimaryData[a].clientId,
  //                             withOutPrimaryData[a].title);
  //                       },
  //                       child: const Text("Log in"),
  //                     ),
  //                     TextButton(
  //                       onPressed: () {
  //                         getX.Get.back();
  //                       },
  //                       child: const Text("Cancel"),
  //                     ),
  //                   ],
  //                 );
  //               },
  //             );
  //             return;
  //           }
  //
  //           var activityData = allSyncingData[i];
  //           MonthlyLogTableData getActivityKeyWiseData = await DataBaseHelper
  //               .shared
  //               .getMonthlyData(activityData.keyId);
  //
  //           var callAPIWithThisURL = withOutPrimaryData[a].url;
  //
  //           var getAllObjectIdList =
  //           getActivityKeyWiseData.serverDetailListDayPerWeek.where((
  //               element) => element.serverUrl != callAPIWithThisURL).toList();
  //
  //           if (getAllObjectIdList.isNotEmpty) {
  //             for (int d = 0; d < getAllObjectIdList.length; d++) {
  //               identifierDataExtra.add(
  //                   Identifier(value: getAllObjectIdList[d].objectId, system:
  //                   FhirUri(getAllObjectIdList[d].serverUrl)));
  //             }
  //           }
  //
  //           var objectId = "";
  //           var getServeIndex = getActivityKeyWiseData
  //               .serverDetailListDayPerWeek.indexWhere((element) =>
  //           element.serverUrl ==
  //               withOutPrimaryData[a].url).toInt();
  //           if (getServeIndex != -1) {
  //             objectId = getActivityKeyWiseData
  //                 .serverDetailListDayPerWeek[getServeIndex].objectId ?? "";
  //             getActivityKeyWiseData.serverDetailListDayPerWeek[getServeIndex]
  //                 .dataSyncServerWise = true;
  //           }
  //           if (getActivityKeyWiseData.serverDetailListDayPerWeek.isNotEmpty &&
  //               getActivityKeyWiseData.dayPerWeekIdentifierData.isNotEmpty) {
  //             var aObject = getActivityKeyWiseData.dayPerWeekIdentifierData
  //                 .indexWhere((element) =>
  //             element.url ==
  //                 withOutPrimaryData[a].url).toInt();
  //             if (aObject != -1) {
  //               objectId =
  //                   getActivityKeyWiseData.dayPerWeekIdentifierData[aObject]
  //                       .objectId ?? "";
  //             }
  //           }
  //
  //           if (identifierDataExtra.isNotEmpty) {
  //             Observation observation = profiles
  //                 .createObservationDaysPerWeeks(
  //                 allSyncingData[i], objectId, "${withOutPrimaryData[a]
  //                 .patientFName}${withOutPrimaryData[a].patientLName}",
  //                 withOutPrimaryData[a].patientId,
  //                 identifierDataList: identifierDataExtra);
  //
  //
  //             await profiles.processResource(
  //                 observation, Constant.trackingChart,
  //                 withOutPrimaryData[a].url,
  //                 withOutPrimaryData[a].clientId,
  //                 withOutPrimaryData[a].authToken);
  //           }
  //         }
  //       }
  //     }
  //     delayCount++;
  //     if(delayCount == Constant.delayTimeLength){
  //       delayCount = 0;
  //       await Utils.apiCallApplyDelay10second();
  //     }
  //   }
  // }
  //
  // static Future<void> observationSyncDataMinPerDay( List<SyncMonthlyActivityData> allSyncingData) async {
  //
  //   // List<SyncMonthlyActivityData> allSyncingData = [];
  //   PaaProfiles profiles = PaaProfiles();
  //   // var allSelectedServersUrl = Utils.getServerListPreference();
  //   var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
  //   var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
  //   if(getPrimaryServerData.isNotEmpty){
  //     allSelectedServersUrl.remove(getPrimaryServerData[0]);
  //     allSelectedServersUrl.add(getPrimaryServerData[0]);
  //   }
  //   int delayCount = 0;
  //   int delayCountFiveSecond = 0;
  //   for (int i = 0; i < allSyncingData.length; i++) {
  //     var activityData = allSyncingData[i];
  //     if (activityData.headerType == Constant.headerAverageMin) {
  //       for (int j = 0; j < allSelectedServersUrl.length; j++) {
  //         if(allSelectedServersUrl[j].isSecure && Utils.isExpiredToken(allSelectedServersUrl[j].lastLoggedTime,allSelectedServersUrl[j].expireTime)){
  //           showDialog(
  //             context: getX.Get.context!,
  //             barrierDismissible: false,
  //             builder: (BuildContext context) {
  //               return AlertDialog(
  //                 title: const Text("Session Expired"),
  //                 content: Text("Your ${allSelectedServersUrl[j].title} has expired. Please log in again. MinPerDay"),
  //                 actions: <Widget>[
  //                   TextButton(
  //                     onPressed: () async {
  //                       getX.Get.back();
  //                       Utils.callSecureServerAPI(allSelectedServersUrl[j].url,
  //                           allSelectedServersUrl[j].clientId,
  //                           allSelectedServersUrl[j].title);
  //                     },
  //                     child: const Text("Log in"),
  //                   ),
  //                   TextButton(
  //                     onPressed: () {
  //                       getX.Get.back();
  //                     },
  //                     child: const Text("Cancel"),
  //                   ),
  //                 ],
  //               );
  //             },
  //           );
  //           return;
  //         }
  //         /// You can start your API call from here
  //         var activityData = allSyncingData[i];
  //         MonthlyLogTableData getActivityKeyWiseData = await DataBaseHelper
  //             .shared
  //             .getMonthlyData(activityData.keyId);
  //         /*for (int a = 0; a <
  //               getActivityKeyWiseData.syncAvgMinServerWiseList.length; a++) {
  //             getActivityKeyWiseData.syncAvgMinServerWiseList[a] = true;
  //           }*/
  //         if (getActivityKeyWiseData.serverDetailListAvgMin.isNotEmpty) {
  //           if (activityData.headerType == Constant.headerAverageMin) {
  //             getActivityKeyWiseData.isSyncAvgMin = true;
  //
  //             await DataBaseHelper.shared.updateMonthlyData(
  //                 getActivityKeyWiseData);
  //
  //             String observationId = "";
  //
  //             var objectId = "";
  //             var getServeIndex = getActivityKeyWiseData.serverDetailListAvgMin
  //                 .indexWhere((element) =>
  //             element.serverUrl ==
  //                 allSelectedServersUrl[j].url).toInt();
  //
  //             if (getServeIndex != -1) {
  //               objectId =
  //                   getActivityKeyWiseData.serverDetailListAvgMin[getServeIndex].objectId ?? "";
  //               getActivityKeyWiseData
  //                   .serverDetailListAvgMin[getServeIndex].dataSyncServerWise =
  //               true;
  //
  //               await DataBaseHelper.shared.updateMonthlyData(
  //                   getActivityKeyWiseData);
  //             }
  //             if(getActivityKeyWiseData.serverDetailListAvgMin.isNotEmpty &&
  //                 getActivityKeyWiseData.avgMinIdentifierData.isNotEmpty){
  //               var a = getActivityKeyWiseData.avgMinIdentifierData.indexWhere((element) => element.url == allSelectedServersUrl[j].url).toInt();
  //               if(a != -1){
  //                 objectId = getActivityKeyWiseData.avgMinIdentifierData[a].objectId ?? "";
  //               }
  //             }
  //             List<Identifier> identifier = [];
  //             if(allSelectedServersUrl[j].isPrimary){
  //               var withOutPrimaryDataList = allSelectedServersUrl.where((element) => !element.isPrimary).toList();
  //               if(withOutPrimaryDataList.isNotEmpty){
  //                 for (int a = 0; a < withOutPrimaryDataList.length; a++) {
  //                   if(getActivityKeyWiseData.serverDetailListAvgMin.isNotEmpty) {
  //                     var getServeIndex = getActivityKeyWiseData.serverDetailListAvgMin
  //                         .indexWhere((element) =>
  //                     element.serverUrl ==
  //                         withOutPrimaryDataList[a].url).toInt();
  //                     if(getServeIndex != -1){
  //                       identifier.add(Identifier(value: getActivityKeyWiseData.serverDetailListAvgMin[getServeIndex]
  //                           .objectId,
  //                           system: FhirUri(getActivityKeyWiseData.serverDetailListAvgMin[getServeIndex].serverUrl)));
  //                     }
  //                   }
  //
  //                 }
  //               }
  //             }
  //             Observation observation = profiles
  //                 .createObservationMintuesPerDay(
  //                 allSyncingData[i], objectId, "${allSelectedServersUrl[j]
  //                 .patientFName}${allSelectedServersUrl[j].patientLName}",
  //                 allSelectedServersUrl[j].patientId,identifierDataList: identifier);
  //
  //             observationId =
  //             await profiles.processResource(
  //                 observation, Constant.trackingChart,
  //                 allSelectedServersUrl[j].url,
  //                 allSelectedServersUrl[j].clientId,
  //                 allSelectedServersUrl[j].authToken);
  //
  //             getActivityKeyWiseData.avgMinPerDayId = observationId;
  //
  //             /*if (!getActivityKeyWiseData.objectIdAvgMinList.contains(
  //                   observationId)) {
  //                 getActivityKeyWiseData.objectIdAvgMinList[getServeIndex] =
  //                     observationId;
  //
  //                 if (getActivityKeyWiseData
  //                     .serverUrlAvgMinList[getServeIndex] !=
  //                     "") {
  //                   getActivityKeyWiseData.serverUrlAvgMinList[getServeIndex] =
  //                       allSelectedServersUrl[j].url;
  //                 }
  //                 if (getActivityKeyWiseData
  //                     .patientIdAvgMinList[getServeIndex] !=
  //                     "") {
  //                   getActivityKeyWiseData.patientIdAvgMinList[getServeIndex] =
  //                       allSelectedServersUrl[j].patientId;
  //                 }
  //                 if (getActivityKeyWiseData
  //                     .patientNameAvgMinList[getServeIndex] != "") {
  //                   getActivityKeyWiseData
  //                       .patientNameAvgMinList[getServeIndex] =
  //                   "${allSelectedServersUrl[j]
  //                       .patientFName}${allSelectedServersUrl[j].patientLName}";
  //                 }
  //               }*/
  //
  //             if(getActivityKeyWiseData.serverDetailListAvgMin.where((element) => element.objectId
  //                 == observationId).toList().isEmpty) {
  //               getActivityKeyWiseData.serverDetailListAvgMin[getServeIndex].objectId = observationId;
  //               getActivityKeyWiseData.serverDetailListAvgMin[getServeIndex].serverUrl = allSelectedServersUrl[j].url;
  //               getActivityKeyWiseData.serverDetailListAvgMin[getServeIndex].patientId = allSelectedServersUrl[j].patientId;
  //               getActivityKeyWiseData.serverDetailListAvgMin[getServeIndex].patientName =  "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";
  //             }
  //
  //             await DataBaseHelper.shared.updateMonthlyData(
  //                 getActivityKeyWiseData);
  //           }
  //         }
  //         // delayCountFiveSecond++;
  //         Debug.printLog("delayCountFiveSecond......$delayCountFiveSecond......$delayCount");
  //         /*if(delayCountFiveSecond == 10){
  //           delayCountFiveSecond = 0;
  //           await Utils.apiCallApplyDelay5second();
  //         }*/
  //       }
  //
  //       var withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
  //           && element.isSelected && element.patientId != "").toList();
  //       if(withOutPrimaryData.isNotEmpty) {
  //         List<Identifier> identifierDataExtra = [];
  //         for (int a = 0; a < withOutPrimaryData.length; a++) {
  //           identifierDataExtra.clear();
  //           if (withOutPrimaryData[a].isSecure &&
  //               Utils.isExpiredToken(withOutPrimaryData[a].lastLoggedTime,
  //                   withOutPrimaryData[a].expireTime)) {
  //             showDialog(
  //               context: getX.Get.context!,
  //               barrierDismissible: false,
  //               builder: (BuildContext context) {
  //                 return AlertDialog(
  //                   title: const Text("Session Expired"),
  //                   content: Text("Your ${withOutPrimaryData[a]
  //                       .title} has expired. Please log in again. RestHeart"),
  //                   actions: <Widget>[
  //                     TextButton(
  //                       onPressed: () async {
  //                         getX.Get.back();
  //                         Utils.callSecureServerAPI(withOutPrimaryData[a].url,
  //                             withOutPrimaryData[a].clientId,
  //                             withOutPrimaryData[a].title);
  //                       },
  //                       child: const Text("Log in"),
  //                     ),
  //                     TextButton(
  //                       onPressed: () {
  //                         getX.Get.back();
  //                       },
  //                       child: const Text("Cancel"),
  //                     ),
  //                   ],
  //                 );
  //               },
  //             );
  //             return;
  //           }
  //
  //           var activityData = allSyncingData[i];
  //           MonthlyLogTableData getActivityKeyWiseData = await DataBaseHelper
  //               .shared
  //               .getMonthlyData(activityData.keyId);
  //
  //           var callAPIWithThisURL = withOutPrimaryData[a].url;
  //
  //           var getAllObjectIdList =
  //           getActivityKeyWiseData.serverDetailListAvgMin.where((element) => element.serverUrl != callAPIWithThisURL).toList();
  //
  //           if(getAllObjectIdList.isNotEmpty){
  //             for (int d = 0; d < getAllObjectIdList.length; d++) {
  //               identifierDataExtra.add(Identifier(value:getAllObjectIdList[d].objectId ,system:
  //               FhirUri(getAllObjectIdList[d].serverUrl)));
  //             }
  //           }
  //
  //           var objectId = "";
  //           var getServeIndex = getActivityKeyWiseData.serverDetailListAvgMin.indexWhere((
  //               element) =>
  //           element.serverUrl ==
  //               withOutPrimaryData[a].url).toInt();
  //           if (getServeIndex != -1) {
  //             objectId = getActivityKeyWiseData.serverDetailListAvgMin[getServeIndex].objectId ?? "";
  //             getActivityKeyWiseData.serverDetailListAvgMin[getServeIndex].dataSyncServerWise = true;
  //           }
  //           if(getActivityKeyWiseData.serverDetailListAvgMin.isNotEmpty && getActivityKeyWiseData.avgMinIdentifierData.isNotEmpty){
  //             var aObject = getActivityKeyWiseData.avgMinIdentifierData.indexWhere((element) => element.url ==
  //                 withOutPrimaryData[a].url).toInt();
  //             if(aObject != -1){
  //               objectId = getActivityKeyWiseData.avgMinIdentifierData[aObject].objectId ?? "";
  //             }
  //           }
  //
  //           if(identifierDataExtra.isNotEmpty){
  //             Observation observation = profiles
  //                 .createObservationMintuesPerDay(
  //                 allSyncingData[i], objectId, "${withOutPrimaryData[a]
  //                 .patientFName}${withOutPrimaryData[a].patientLName}",
  //                 withOutPrimaryData[a].patientId,identifierDataList: identifierDataExtra);
  //
  //
  //             await profiles.processResource(observation, Constant.trackingChart,
  //                 withOutPrimaryData[a].url,
  //                 withOutPrimaryData[a].clientId,
  //                 withOutPrimaryData[a].authToken);
  //           }
  //         }
  //       }
  //       delayCount++;
  //       Debug.printLog("delayCountFiveSecond......$delayCountFiveSecond......$delayCount");
  //       if(delayCount == Constant.delayTimeLength){
  //         delayCount = 0;
  //         await Utils.apiCallApplyDelay10second();
  //       }
  //     }
  //   }
  // }
  //
  // static Future<void> observationSyncDataMinPerWeek( List<SyncMonthlyActivityData> allSyncingData) async {
  //   // List<SyncMonthlyActivityData> allSyncingData = [];
  //   PaaProfiles profiles = PaaProfiles();
  //   // var allSelectedServersUrl = Utils.getServerListPreference();
  //   var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
  //   var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
  //   if(getPrimaryServerData.isNotEmpty){
  //     allSelectedServersUrl.remove(getPrimaryServerData[0]);
  //     allSelectedServersUrl.add(getPrimaryServerData[0]);
  //   }
  //   int delayCount = 0;
  //   // int delayCountFiveSecond = 0;
  //   for (int i = 0; i < allSyncingData.length; i++) {
  //     var activityData = allSyncingData[i];
  //     if (activityData.headerType == Constant.headerAverageMinPerWeek) {
  //       for (int j = 0; j < allSelectedServersUrl.length; j++) {
  //         /// You can start your API call from here
  //         if(allSelectedServersUrl[j].isSecure && Utils.isExpiredToken(allSelectedServersUrl[j].lastLoggedTime,allSelectedServersUrl[j].expireTime)){
  //           showDialog(
  //             context: getX.Get.context!,
  //             barrierDismissible: false,
  //             builder: (BuildContext context) {
  //               return AlertDialog(
  //                 title: const Text("Session Expired"),
  //                 content: Text("Your ${allSelectedServersUrl[j].title} has expired. Please log in again. MinPerWeek"),
  //                 actions: <Widget>[
  //                   TextButton(
  //                     onPressed: () async {
  //                       getX.Get.back();
  //                       Utils.callSecureServerAPI(allSelectedServersUrl[j].url,
  //                           allSelectedServersUrl[j].clientId,
  //                           allSelectedServersUrl[j].title);
  //                     },
  //                     child: const Text("Log in"),
  //                   ),
  //                   TextButton(
  //                     onPressed: () {
  //                       getX.Get.back();
  //                     },
  //                     child: const Text("Cancel"),
  //                   ),
  //                 ],
  //               );
  //             },
  //           );
  //           return;
  //         }
  //         var activityData = allSyncingData[i];
  //         MonthlyLogTableData getActivityKeyWiseData = await DataBaseHelper
  //             .shared
  //             .getMonthlyData(activityData.keyId);
  //         // for (int a = 0; a <
  //         //     getActivityKeyWiseData.syncAvgMinPerWeekServerWiseList
  //         //         .length; a++) {
  //         //   getActivityKeyWiseData.syncAvgMinPerWeekServerWiseList[a] = true;
  //         // }
  //         if (getActivityKeyWiseData.serverDetailListAvgMinWeek.isNotEmpty) {
  //           if (activityData.headerType == Constant.headerAverageMinPerWeek) {
  //             getActivityKeyWiseData.isSyncAvgMinPerWeek = true;
  //
  //             await DataBaseHelper.shared.updateMonthlyData(
  //                 getActivityKeyWiseData);
  //
  //             String observationId = "";
  //
  //             var objectId = "";
  //             var getServeIndex = getActivityKeyWiseData
  //                 .serverDetailListAvgMinWeek.indexWhere((element) =>
  //             element.serverUrl ==
  //                 allSelectedServersUrl[j].url).toInt();
  //
  //             if (getServeIndex != -1) {
  //               objectId =
  //                   getActivityKeyWiseData.serverDetailListAvgMinWeek[getServeIndex].objectId ?? "";
  //               getActivityKeyWiseData
  //                   .serverDetailListAvgMinWeek[getServeIndex].dataSyncServerWise = true;
  //
  //               await DataBaseHelper.shared.updateMonthlyData(
  //                   getActivityKeyWiseData);
  //             }
  //
  //             if(getActivityKeyWiseData.serverDetailListAvgMinWeek.isNotEmpty && getActivityKeyWiseData.avgMinPerWeekIdentifierData.isNotEmpty){
  //               var a = getActivityKeyWiseData.avgMinPerWeekIdentifierData.indexWhere((element) => element.url == allSelectedServersUrl[j].url).toInt();
  //               if(a != -1){
  //                 objectId = getActivityKeyWiseData.avgMinPerWeekIdentifierData[a].objectId ?? "";
  //               }
  //             }
  //             List<Identifier> identifier = [];
  //             if(allSelectedServersUrl[j].isPrimary){
  //               var withOutPrimaryDataList = allSelectedServersUrl.where((element) => !element.isPrimary).toList();
  //               if(withOutPrimaryDataList.isNotEmpty){
  //                 for (int a = 0; a < withOutPrimaryDataList.length; a++) {
  //                   if(getActivityKeyWiseData.serverDetailListAvgMinWeek.isNotEmpty) {
  //                     var getServeIndex = getActivityKeyWiseData.serverDetailListAvgMinWeek
  //                         .indexWhere((element) =>
  //                     element.serverUrl ==
  //                         withOutPrimaryDataList[a].url).toInt();
  //                     if(getServeIndex != -1){
  //                       identifier.add(Identifier(value: getActivityKeyWiseData.serverDetailListAvgMinWeek[getServeIndex]
  //                           .objectId,
  //                           system: FhirUri(getActivityKeyWiseData.serverDetailListAvgMinWeek[getServeIndex]
  //                               .serverUrl)));
  //                     }
  //                   }
  //
  //                 }
  //               }
  //             }
  //
  //             Observation observation = profiles
  //                 .createObservationMintuesPerWeek(
  //                 allSyncingData[i], objectId, "${allSelectedServersUrl[j]
  //                 .patientFName}${allSelectedServersUrl[j].patientLName}",
  //                 allSelectedServersUrl[j].patientId,identifierDataList: identifier);
  //
  //             observationId =
  //             await profiles.processResource(
  //                 observation, Constant.trackingChart,
  //                 allSelectedServersUrl[j].url,
  //                 allSelectedServersUrl[j].clientId,
  //                 allSelectedServersUrl[j].authToken);
  //
  //             getActivityKeyWiseData.avgPerWeekId = observationId;
  //
  //             /*if (!getActivityKeyWiseData.objectIdAvgMinPerWeekList.contains(
  //                 observationId)) {
  //               getActivityKeyWiseData
  //                   .objectIdAvgMinPerWeekList[getServeIndex] = observationId;
  //
  //               if (getActivityKeyWiseData
  //                   .serverUrlAvgMinPerWeekList[getServeIndex] != "") {
  //                 getActivityKeyWiseData
  //                     .serverUrlAvgMinPerWeekList[getServeIndex] =
  //                     allSelectedServersUrl[j].url;
  //               }
  //               if (getActivityKeyWiseData
  //                   .patientIdAvgMinPerWeekList[getServeIndex] != "") {
  //                 getActivityKeyWiseData
  //                     .patientIdAvgMinPerWeekList[getServeIndex] =
  //                     allSelectedServersUrl[j].patientId;
  //               }
  //               if (getActivityKeyWiseData
  //                   .patientNameAvgMinPerWeekList[getServeIndex] != "") {
  //                 getActivityKeyWiseData
  //                     .patientNameAvgMinPerWeekList[getServeIndex] =
  //                 "${allSelectedServersUrl[j]
  //                     .patientFName}${allSelectedServersUrl[j].patientLName}";
  //               }
  //             }*/
  //
  //             if(getActivityKeyWiseData.serverDetailListAvgMinWeek.where((element) => element.objectId
  //                 == observationId).toList().isEmpty) {
  //               getActivityKeyWiseData.serverDetailListAvgMinWeek[getServeIndex].objectId = observationId;
  //               getActivityKeyWiseData.serverDetailListAvgMinWeek[getServeIndex].serverUrl = allSelectedServersUrl[j].url;
  //               getActivityKeyWiseData.serverDetailListAvgMinWeek[getServeIndex].patientId = allSelectedServersUrl[j].patientId;
  //               getActivityKeyWiseData.serverDetailListAvgMinWeek[getServeIndex].patientName =  "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";
  //             }
  //
  //             await DataBaseHelper.shared.updateMonthlyData(
  //                 getActivityKeyWiseData);
  //           }
  //         }
  //         /* delayCountFiveSecond++;
  //         if(delayCountFiveSecond == 10){
  //           delayCountFiveSecond = 0;
  //           await Utils.apiCallApplyDelay5second();
  //         }*/
  //       }
  //
  //       var withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
  //           && element.isSelected && element.patientId != "").toList();
  //       if(withOutPrimaryData.isNotEmpty) {
  //         List<Identifier> identifierDataExtra = [];
  //         for (int a = 0; a < withOutPrimaryData.length; a++) {
  //           identifierDataExtra.clear();
  //           if (withOutPrimaryData[a].isSecure &&
  //               Utils.isExpiredToken(withOutPrimaryData[a].lastLoggedTime,
  //                   withOutPrimaryData[a].expireTime)) {
  //             showDialog(
  //               context: getX.Get.context!,
  //               barrierDismissible: false,
  //               builder: (BuildContext context) {
  //                 return AlertDialog(
  //                   title: const Text("Session Expired"),
  //                   content: Text("Your ${withOutPrimaryData[a]
  //                       .title} has expired. Please log in again. RestHeart"),
  //                   actions: <Widget>[
  //                     TextButton(
  //                       onPressed: () async {
  //                         getX.Get.back();
  //                         Utils.callSecureServerAPI(withOutPrimaryData[a].url,
  //                             withOutPrimaryData[a].clientId,
  //                             withOutPrimaryData[a].title);
  //                       },
  //                       child: const Text("Log in"),
  //                     ),
  //                     TextButton(
  //                       onPressed: () {
  //                         getX.Get.back();
  //                       },
  //                       child: const Text("Cancel"),
  //                     ),
  //                   ],
  //                 );
  //               },
  //             );
  //             return;
  //           }
  //
  //           var activityData = allSyncingData[i];
  //           MonthlyLogTableData getActivityKeyWiseData = await DataBaseHelper
  //               .shared
  //               .getMonthlyData(activityData.keyId);
  //
  //           var callAPIWithThisURL = withOutPrimaryData[a].url;
  //
  //           var getAllObjectIdList =
  //           getActivityKeyWiseData.serverDetailListAvgMinWeek.where((element) => element.serverUrl != callAPIWithThisURL).toList();
  //
  //           if(getAllObjectIdList.isNotEmpty){
  //             for (int d = 0; d < getAllObjectIdList.length; d++) {
  //               identifierDataExtra.add(Identifier(value:getAllObjectIdList[d].objectId ,system:
  //               FhirUri(getAllObjectIdList[d].serverUrl)));
  //             }
  //           }
  //
  //           var objectId = "";
  //           var getServeIndex = getActivityKeyWiseData.serverDetailListAvgMinWeek.indexWhere((
  //               element) =>
  //           element.serverUrl ==
  //               withOutPrimaryData[a].url).toInt();
  //           if (getServeIndex != -1) {
  //             objectId = getActivityKeyWiseData.serverDetailListAvgMinWeek[getServeIndex].objectId ?? "";
  //             getActivityKeyWiseData.serverDetailListAvgMinWeek[getServeIndex].dataSyncServerWise = true;
  //           }
  //           if(getActivityKeyWiseData.serverDetailListAvgMinWeek.isNotEmpty && getActivityKeyWiseData.avgMinPerWeekIdentifierData.isNotEmpty){
  //             var aObject = getActivityKeyWiseData.avgMinPerWeekIdentifierData.indexWhere((element) => element.url ==
  //                 withOutPrimaryData[a].url).toInt();
  //             if(aObject != -1){
  //               objectId = getActivityKeyWiseData.avgMinPerWeekIdentifierData[aObject].objectId ?? "";
  //             }
  //           }
  //
  //           if(identifierDataExtra.isNotEmpty){
  //             Observation observation = profiles
  //                 .createObservationMintuesPerWeek(
  //                 allSyncingData[i], objectId, "${withOutPrimaryData[a]
  //                 .patientFName}${withOutPrimaryData[a].patientLName}",
  //                 withOutPrimaryData[a].patientId,identifierDataList: identifierDataExtra);
  //
  //
  //             await profiles.processResource(observation, Constant.trackingChart,
  //                 withOutPrimaryData[a].url,
  //                 withOutPrimaryData[a].clientId,
  //                 withOutPrimaryData[a].authToken);
  //           }
  //         }
  //       }
  //       delayCount++;
  //       if(delayCount == Constant.delayTimeLength){
  //         delayCount = 0;
  //         await Utils.apiCallApplyDelay10second();
  //       }
  //     }
  //   }
  // }
  //
  // static Future<void> observationSyncDataStrengthDaysPerWeek( List<SyncMonthlyActivityData> allSyncingData) async {
  //
  //   PaaProfiles profiles = PaaProfiles();
  //   var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
  //   var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
  //   if(getPrimaryServerData.isNotEmpty){
  //     allSelectedServersUrl.remove(getPrimaryServerData[0]);
  //     allSelectedServersUrl.add(getPrimaryServerData[0]);
  //   }
  //   int delayCount = 0;
  //   // int delayCountFiveSecond = 0;
  //   for (int i = 0; i < allSyncingData.length; i++) {
  //     var activityData = allSyncingData[i];
  //     if (activityData.headerType == Constant.headerStrength) {
  //       for (int j = 0; j < allSelectedServersUrl.length; j++) {
  //         /// You can start your API call from here
  //         if(allSelectedServersUrl[j].isSecure && Utils.isExpiredToken(allSelectedServersUrl[j].lastLoggedTime,allSelectedServersUrl[j].expireTime)){
  //           showDialog(
  //             context: getX.Get.context!,
  //             barrierDismissible: false,
  //             builder: (BuildContext context) {
  //               return AlertDialog(
  //                 title: const Text("Session Expired"),
  //                 content: Text("Your ${allSelectedServersUrl[j].title} has expired. Please log in again. StrengthDaysPerWeek"),
  //                 actions: <Widget>[
  //                   TextButton(
  //                     onPressed: () async {
  //                       getX.Get.back();
  //                       Utils.callSecureServerAPI(allSelectedServersUrl[j].url,
  //                           allSelectedServersUrl[j].clientId,
  //                           allSelectedServersUrl[j].title);
  //                     },
  //                     child: const Text("Log in"),
  //                   ),
  //                   TextButton(
  //                     onPressed: () {
  //                       getX.Get.back();
  //                     },
  //                     child: const Text("Cancel"),
  //                   ),
  //                 ],
  //               );
  //             },
  //           );
  //           return;
  //         }
  //         var activityData = allSyncingData[i];
  //         MonthlyLogTableData getActivityKeyWiseData = await DataBaseHelper
  //             .shared
  //             .getMonthlyData(activityData.keyId);
  //         // for (int a = 0; a <
  //         //     getActivityKeyWiseData.syncStrengthServerWiseList.length; a++) {
  //         //   getActivityKeyWiseData.syncStrengthServerWiseList[a] = true;
  //         // }
  //         if (getActivityKeyWiseData.serverDetailListStrength.isNotEmpty) {
  //           if (activityData.headerType == Constant.headerStrength) {
  //             getActivityKeyWiseData.isSyncStrength = true;
  //
  //             await DataBaseHelper.shared.updateMonthlyData(
  //                 getActivityKeyWiseData);
  //
  //             String observationId = "";
  //
  //             var objectId = "";
  //             var getServeIndex = getActivityKeyWiseData.serverDetailListStrength
  //                 .indexWhere((element) =>
  //             element.serverUrl ==
  //                 allSelectedServersUrl[j].url).toInt();
  //
  //             if (getServeIndex != -1) {
  //               objectId =
  //                   getActivityKeyWiseData.serverDetailListStrength[getServeIndex].objectId ?? "";
  //               getActivityKeyWiseData
  //                   .serverDetailListStrength[getServeIndex].dataSyncServerWise = true;
  //
  //               await DataBaseHelper.shared.updateMonthlyData(
  //                   getActivityKeyWiseData);
  //             }
  //
  //             if(getActivityKeyWiseData.serverDetailListStrength.isNotEmpty && getActivityKeyWiseData.strengthIdentifierData.isNotEmpty){
  //               var a = getActivityKeyWiseData.strengthIdentifierData.indexWhere((element) => element.url == allSelectedServersUrl[j].url).toInt();
  //               if(a != -1){
  //                 objectId = getActivityKeyWiseData.strengthIdentifierData[a].objectId ?? "";
  //               }
  //             }
  //             List<Identifier> identifier = [];
  //             if(allSelectedServersUrl[j].isPrimary){
  //               var withOutPrimaryDataList = allSelectedServersUrl.where((element) => !element.isPrimary).toList();
  //               if(withOutPrimaryDataList.isNotEmpty){
  //                 for (int a = 0; a < withOutPrimaryDataList.length; a++) {
  //                   if(getActivityKeyWiseData.serverDetailListStrength.isNotEmpty) {
  //                     var getServeIndex = getActivityKeyWiseData.serverDetailListStrength
  //                         .indexWhere((element) =>
  //                     element.serverUrl ==
  //                         withOutPrimaryDataList[a].url).toInt();
  //                     if(getServeIndex != -1){
  //                       identifier.add(Identifier(value: getActivityKeyWiseData.serverDetailListStrength[getServeIndex]
  //                           .objectId,
  //                           system: FhirUri(getActivityKeyWiseData.serverDetailListStrength[getServeIndex]
  //                               .serverUrl)));
  //                     }
  //                   }
  //
  //                 }
  //               }
  //             }
  //
  //             Observation observation = profiles
  //                 .createObservationStrengthDaysPerWeek(
  //                 allSyncingData[i], objectId, "${allSelectedServersUrl[j]
  //                 .patientFName}${allSelectedServersUrl[j].patientLName}",
  //                 allSelectedServersUrl[j].patientId,identifierDataList: identifier);
  //
  //             observationId =
  //             await profiles.processResource(
  //                 observation, Constant.trackingChart,
  //                 allSelectedServersUrl[j].url,
  //                 allSelectedServersUrl[j].clientId,
  //                 allSelectedServersUrl[j].authToken);
  //
  //             getActivityKeyWiseData.strengthId = observationId;
  //
  //             /* if (!getActivityKeyWiseData.objectIdStrengthList.contains(
  //                 observationId)) {
  //               getActivityKeyWiseData.objectIdStrengthList[getServeIndex] =
  //                   observationId;
  //
  //               if (getActivityKeyWiseData
  //                   .serverUrlStrengthList[getServeIndex] != "") {
  //                 getActivityKeyWiseData.serverUrlStrengthList[getServeIndex] =
  //                     allSelectedServersUrl[j].url;
  //               }
  //               if (getActivityKeyWiseData
  //                   .patientIdStrengthList[getServeIndex] != "") {
  //                 getActivityKeyWiseData.patientIdStrengthList[getServeIndex] =
  //                     allSelectedServersUrl[j].patientId;
  //               }
  //               if (getActivityKeyWiseData
  //                   .patientNameStrengthList[getServeIndex] != "") {
  //                 getActivityKeyWiseData
  //                     .patientNameStrengthList[getServeIndex] =
  //                 "${allSelectedServersUrl[j]
  //                     .patientFName}${allSelectedServersUrl[j].patientLName}";
  //               }
  //             }*/
  //
  //             if(getActivityKeyWiseData.serverDetailListStrength.where((element) => element.objectId
  //                 == observationId).toList().isEmpty) {
  //               getActivityKeyWiseData.serverDetailListStrength[getServeIndex].objectId = observationId;
  //               getActivityKeyWiseData.serverDetailListStrength[getServeIndex].serverUrl = allSelectedServersUrl[j].url;
  //               getActivityKeyWiseData.serverDetailListStrength[getServeIndex].patientId = allSelectedServersUrl[j].patientId;
  //               getActivityKeyWiseData.serverDetailListStrength[getServeIndex].patientName =  "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";
  //             }
  //
  //
  //             await DataBaseHelper.shared.updateMonthlyData(
  //                 getActivityKeyWiseData);
  //           }
  //         }
  //         /*delayCountFiveSecond++;
  //         if(delayCountFiveSecond == 10){
  //           delayCountFiveSecond = 0;
  //           await Utils.apiCallApplyDelay5second();
  //         }*/
  //
  //       }
  //
  //       var withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
  //           && element.isSelected && element.patientId != "").toList();
  //       if(withOutPrimaryData.isNotEmpty) {
  //         List<Identifier> identifierDataExtra = [];
  //         for (int a = 0; a < withOutPrimaryData.length; a++) {
  //           identifierDataExtra.clear();
  //           if (withOutPrimaryData[a].isSecure &&
  //               Utils.isExpiredToken(withOutPrimaryData[a].lastLoggedTime,
  //                   withOutPrimaryData[a].expireTime)) {
  //             showDialog(
  //               context: getX.Get.context!,
  //               barrierDismissible: false,
  //               builder: (BuildContext context) {
  //                 return AlertDialog(
  //                   title: const Text("Session Expired"),
  //                   content: Text("Your ${withOutPrimaryData[a]
  //                       .title} has expired. Please log in again. RestHeart"),
  //                   actions: <Widget>[
  //                     TextButton(
  //                       onPressed: () async {
  //                         getX.Get.back();
  //                         Utils.callSecureServerAPI(withOutPrimaryData[a].url,
  //                             withOutPrimaryData[a].clientId,
  //                             withOutPrimaryData[a].title);
  //                       },
  //                       child: const Text("Log in"),
  //                     ),
  //                     TextButton(
  //                       onPressed: () {
  //                         getX.Get.back();
  //                       },
  //                       child: const Text("Cancel"),
  //                     ),
  //                   ],
  //                 );
  //               },
  //             );
  //             return;
  //           }
  //
  //           var activityData = allSyncingData[i];
  //           MonthlyLogTableData getActivityKeyWiseData = await DataBaseHelper
  //               .shared
  //               .getMonthlyData(activityData.keyId);
  //
  //           var callAPIWithThisURL = withOutPrimaryData[a].url;
  //
  //           var getAllObjectIdList =
  //           getActivityKeyWiseData.serverDetailListStrength.where((element) => element.serverUrl != callAPIWithThisURL).toList();
  //
  //           if(getAllObjectIdList.isNotEmpty){
  //             for (int d = 0; d < getAllObjectIdList.length; d++) {
  //               identifierDataExtra.add(Identifier(value:getAllObjectIdList[d].objectId ,system:
  //               FhirUri(getAllObjectIdList[d].serverUrl)));
  //             }
  //           }
  //
  //           var objectId = "";
  //           var getServeIndex = getActivityKeyWiseData.serverDetailListStrength.indexWhere((
  //               element) =>
  //           element.serverUrl ==
  //               withOutPrimaryData[a].url).toInt();
  //           if (getServeIndex != -1) {
  //             objectId = getActivityKeyWiseData.serverDetailListStrength[getServeIndex].objectId ?? "";
  //             getActivityKeyWiseData.serverDetailListStrength[getServeIndex].dataSyncServerWise = true;
  //           }
  //           if(getActivityKeyWiseData.serverDetailListStrength.isNotEmpty && getActivityKeyWiseData.strengthIdentifierData.isNotEmpty){
  //             var aObject = getActivityKeyWiseData.strengthIdentifierData.indexWhere((element) => element.url ==
  //                 withOutPrimaryData[a].url).toInt();
  //             if(aObject != -1){
  //               objectId = getActivityKeyWiseData.strengthIdentifierData[aObject].objectId ?? "";
  //             }
  //           }
  //
  //           if(identifierDataExtra.isNotEmpty){
  //             Observation observation = profiles
  //                 .createObservationStrengthDaysPerWeek(
  //                 allSyncingData[i], objectId, "${withOutPrimaryData[a]
  //                 .patientFName}${withOutPrimaryData[a].patientLName}",
  //                 withOutPrimaryData[a].patientId,identifierDataList: identifierDataExtra);
  //
  //
  //             await profiles.processResource(observation, Constant.trackingChart,
  //                 withOutPrimaryData[a].url,
  //                 withOutPrimaryData[a].clientId,
  //                 withOutPrimaryData[a].authToken);
  //           }
  //         }
  //       }
  //       delayCount++;
  //       if(delayCount == Constant.delayTimeLength){
  //         delayCount = 0;
  //         await Utils.apiCallApplyDelay10second();
  //       }
  //     }
  //   }
  //
  // }
  //
  // ///Tracking chart observation
  //
  // static Future<void> observationSyncDataCalories(List<SyncMonthlyActivityData> allSyncingData) async {
  //   PaaProfiles profiles = PaaProfiles();
  //   var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
  //   var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
  //   if(getPrimaryServerData.isNotEmpty){
  //     allSelectedServersUrl.remove(getPrimaryServerData[0]);
  //     allSelectedServersUrl.add(getPrimaryServerData[0]);
  //   }
  //   int delayCount = 0;
  //   for (int i = 0; i < allSyncingData.length; i++) {
  //     if (allSyncingData[i].monthName == "" && allSyncingData[i].headerType == Constant.titleCalories) {
  //       for (int j = 0; j < allSelectedServersUrl.length; j++) {
  //         if(allSelectedServersUrl[j].isSecure && Utils.isExpiredToken(allSelectedServersUrl[j].lastLoggedTime,allSelectedServersUrl[j].expireTime)){
  //           showDialog(
  //             context: getX.Get.context!,
  //             barrierDismissible: false,
  //             builder: (BuildContext context) {
  //               return AlertDialog(
  //                 title: const Text("Session Expired"),
  //                 content: Text("Your ${allSelectedServersUrl[j].title} has expired. Please log in again. Calories"),
  //                 actions: <Widget>[
  //                   TextButton(
  //                     onPressed: () async {
  //                       getX.Get.back();
  //                       Utils.callSecureServerAPI(allSelectedServersUrl[j].url,
  //                           allSelectedServersUrl[j].clientId,
  //                           allSelectedServersUrl[j].title);
  //                     },
  //                     child: const Text("Log in"),
  //                   ),
  //                   TextButton(
  //                     onPressed: () {
  //                       getX.Get.back();
  //                     },
  //                     child: const Text("Cancel"),
  //                   ),
  //                 ],
  //               );
  //             },
  //           );
  //           return;
  //         }
  //         var activityData = allSyncingData[i];
  //         ActivityTable getActivityKeyWiseData = await DataBaseHelper.shared.getActivityData(activityData.keyId);
  //         if(getActivityKeyWiseData.serverDetailList.isNotEmpty){
  //           getActivityKeyWiseData.isSync = true;
  //
  //           var objectId = "";
  //           var getServeIndex = getActivityKeyWiseData.serverDetailList.indexWhere((element) => element.serverUrl == allSelectedServersUrl[j].url).toInt();
  //           if(getServeIndex != -1){
  //             objectId = getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ?? "";
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].dataSyncServerWise = true;
  //           }
  //           if(getActivityKeyWiseData.serverDetailList.isNotEmpty && getActivityKeyWiseData.identifierData.isNotEmpty){
  //             var a = getActivityKeyWiseData.identifierData.indexWhere((element) => element.url ==
  //                 allSelectedServersUrl[j].url).toInt();
  //             if(a != -1){
  //               objectId = getActivityKeyWiseData.identifierData[a].objectId ?? "";
  //             }
  //           }
  //           await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);
  //
  //           String observationId = "";
  //
  //           List<Identifier> identifier = [];
  //           if(allSelectedServersUrl[j].isPrimary){
  //             var withOutPrimaryDataList = allSelectedServersUrl.where((element) => !element.isPrimary).toList();
  //             if(withOutPrimaryDataList.isNotEmpty){
  //               for (int a = 0; a < withOutPrimaryDataList.length; a++) {
  //                 if(getActivityKeyWiseData.serverDetailList.isNotEmpty) {
  //                   var getServeIndex = getActivityKeyWiseData.serverDetailList
  //                       .indexWhere((element) =>
  //                   element.serverUrl ==
  //                       withOutPrimaryDataList[a].url).toInt();
  //                   if(getServeIndex != -1){
  //                     identifier.add(Identifier(value: getActivityKeyWiseData.serverDetailList[getServeIndex].objectId,
  //                         system: FhirUri(getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl)));
  //                   }
  //                 }
  //
  //               }
  //             }
  //           }
  //
  //           Observation observation = profiles.createObservationCaloriesPerDay(allSyncingData[i],objectId,
  //               "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}",
  //               allSelectedServersUrl[j].patientId,identifierDataList: identifier);
  //
  //           observationId = await profiles.processResource(observation, Constant.trackingChart,
  //               allSelectedServersUrl[j].url,
  //               allSelectedServersUrl[j].clientId,
  //               allSelectedServersUrl[j].authToken);
  //
  //           getActivityKeyWiseData.objectId = observationId;
  //
  //           if(getActivityKeyWiseData.serverDetailList.where((element) => element.objectId == observationId).toList().isEmpty) {
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].objectId = observationId;
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl = allSelectedServersUrl[j].url;
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].patientId = allSelectedServersUrl[j].patientId;
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].patientName =  "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";
  //
  //           }
  //           await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);
  //         }
  //       }
  //
  //       var withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
  //           && element.isSelected && element.patientId != "").toList();
  //       if(withOutPrimaryData.isNotEmpty) {
  //         List<Identifier> identifierDataExtra = [];
  //         for (int a = 0; a < withOutPrimaryData.length; a++) {
  //           identifierDataExtra.clear();
  //           if (withOutPrimaryData[a].isSecure &&
  //               Utils.isExpiredToken(withOutPrimaryData[a].lastLoggedTime,
  //                   withOutPrimaryData[a].expireTime)) {
  //             showDialog(
  //               context: getX.Get.context!,
  //               barrierDismissible: false,
  //               builder: (BuildContext context) {
  //                 return AlertDialog(
  //                   title: const Text("Session Expired"),
  //                   content: Text("Your ${withOutPrimaryData[a]
  //                       .title} has expired. Please log in again. RestHeart"),
  //                   actions: <Widget>[
  //                     TextButton(
  //                       onPressed: () async {
  //                         getX.Get.back();
  //                         Utils.callSecureServerAPI(withOutPrimaryData[a].url,
  //                             withOutPrimaryData[a].clientId,
  //                             withOutPrimaryData[a].title);
  //                       },
  //                       child: const Text("Log in"),
  //                     ),
  //                     TextButton(
  //                       onPressed: () {
  //                         getX.Get.back();
  //                       },
  //                       child: const Text("Cancel"),
  //                     ),
  //                   ],
  //                 );
  //               },
  //             );
  //             return;
  //           }
  //
  //           var activityData = allSyncingData[i];
  //           ActivityTable getActivityKeyWiseData = await DataBaseHelper.shared
  //               .getActivityData(activityData.keyId);
  //
  //           var callAPIWithThisURL = withOutPrimaryData[a].url;
  //
  //           var getAllObjectIdList =
  //           getActivityKeyWiseData.serverDetailList.where((element) => element.serverUrl != callAPIWithThisURL).toList();
  //
  //           if(getAllObjectIdList.isNotEmpty){
  //             for (int d = 0; d < getAllObjectIdList.length; d++) {
  //               identifierDataExtra.add(Identifier(value:getAllObjectIdList[d].objectId ,system:
  //               FhirUri(getAllObjectIdList[d].serverUrl)));
  //             }
  //           }
  //
  //           var objectId = "";
  //           var getServeIndex = getActivityKeyWiseData.serverDetailList.indexWhere((
  //               element) =>
  //           element.serverUrl ==
  //               withOutPrimaryData[a].url).toInt();
  //           if (getServeIndex != -1) {
  //             objectId = getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ?? "";
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].dataSyncServerWise = true;
  //           }
  //           if(getActivityKeyWiseData.serverDetailList.isNotEmpty && getActivityKeyWiseData.identifierData.isNotEmpty){
  //             var aObject = getActivityKeyWiseData.identifierData.indexWhere((element) => element.url ==
  //                 withOutPrimaryData[a].url).toInt();
  //             if(aObject != -1){
  //               objectId = getActivityKeyWiseData.identifierData[aObject].objectId ?? "";
  //             }
  //           }
  //
  //           if(identifierDataExtra.isNotEmpty){
  //             Observation observation = profiles.createObservationCaloriesPerDay(
  //                 allSyncingData[i], objectId,"${withOutPrimaryData[a]
  //                 .patientFName}${withOutPrimaryData[a].patientLName}",
  //                 withOutPrimaryData[a].patientId,identifierDataList: identifierDataExtra);
  //
  //
  //             await profiles.processResource(observation, Constant.trackingChart,
  //                 withOutPrimaryData[a].url,
  //                 withOutPrimaryData[a].clientId,
  //                 withOutPrimaryData[a].authToken);
  //           }
  //         }
  //       }
  //       delayCount++;
  //       if(delayCount == Constant.delayTimeLength){
  //         delayCount = 0;
  //         await Utils.apiCallApplyDelay10second();
  //       }
  //     }
  //   }
  // }
  //
  // static Future<void> observationSyncDataSteps( List<SyncMonthlyActivityData> allSyncingData) async {
  //
  //   PaaProfiles profiles = PaaProfiles();
  //   var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
  //   var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
  //   if(getPrimaryServerData.isNotEmpty){
  //     allSelectedServersUrl.remove(getPrimaryServerData[0]);
  //     allSelectedServersUrl.add(getPrimaryServerData[0]);
  //   }
  //   int delayCount = 0;
  //   // int delayCountFiveSecond = 0;
  //   for (int i = 0; i < allSyncingData.length; i++) {
  //     if (allSyncingData[i].monthName == "" &&
  //         allSyncingData[i].headerType == Constant.titleSteps) {
  //       for (int j = 0; j < allSelectedServersUrl.length; j++) {
  //         if(allSelectedServersUrl[j].isSecure && Utils.isExpiredToken(allSelectedServersUrl[j].lastLoggedTime,allSelectedServersUrl[j].expireTime)){
  //           showDialog(
  //             context: getX.Get.context!,
  //             barrierDismissible: false,
  //             builder: (BuildContext context) {
  //               return AlertDialog(
  //                 title: const Text("Session Expired"),
  //                 content: Text("Your ${allSelectedServersUrl[j].title} has expired. Please log in again. Steps"),
  //                 actions: <Widget>[
  //                   TextButton(
  //                     onPressed: () async {
  //                       getX.Get.back();
  //                       Utils.callSecureServerAPI(allSelectedServersUrl[j].url,
  //                           allSelectedServersUrl[j].clientId,
  //                           allSelectedServersUrl[j].title);
  //                     },
  //                     child: const Text("Log in"),
  //                   ),
  //                   TextButton(
  //                     onPressed: () {
  //                       getX.Get.back();
  //                     },
  //                     child: const Text("Cancel"),
  //                   ),
  //                 ],
  //               );
  //             },
  //           );
  //           return;
  //         }
  //         var activityData = allSyncingData[i];
  //         ActivityTable getActivityKeyWiseData = await DataBaseHelper.shared
  //             .getActivityData(activityData.keyId);
  //
  //         if(getActivityKeyWiseData.serverDetailList.isNotEmpty){
  //           getActivityKeyWiseData.isSync = true;
  //
  //           await DataBaseHelper.shared.updateActivityData(
  //               getActivityKeyWiseData);
  //
  //           String observationId = "";
  //
  //           var objectId = "";
  //           var getServeIndex = getActivityKeyWiseData.serverDetailList.indexWhere((
  //               element) =>
  //           element.serverUrl ==
  //               allSelectedServersUrl[j].url).toInt();
  //           if (getServeIndex != -1) {
  //             objectId = getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ?? "";
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].dataSyncServerWise = true;
  //           }
  //           if(getActivityKeyWiseData.serverDetailList.isNotEmpty && getActivityKeyWiseData.identifierData.isNotEmpty){
  //             var a = getActivityKeyWiseData.identifierData.indexWhere((element) => element.url == allSelectedServersUrl[j].url).toInt();
  //             if(a != -1){
  //               objectId = getActivityKeyWiseData.identifierData[a].objectId ?? "";
  //             }
  //           }
  //           List<Identifier> identifier = [];
  //           if(allSelectedServersUrl[j].isPrimary){
  //             var withOutPrimaryDataList = allSelectedServersUrl.where((element) => !element.isPrimary).toList();
  //             if(withOutPrimaryDataList.isNotEmpty){
  //               for (int a = 0; a < withOutPrimaryDataList.length; a++) {
  //                 if(getActivityKeyWiseData.serverDetailList.isNotEmpty) {
  //                   var getServeIndex = getActivityKeyWiseData.serverDetailList
  //                       .indexWhere((element) =>
  //                   element.serverUrl ==
  //                       withOutPrimaryDataList[a].url).toInt();
  //                   if(getServeIndex != -1){
  //                     identifier.add(Identifier(value: getActivityKeyWiseData.serverDetailList[getServeIndex].objectId,
  //                         system: FhirUri(getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl)));
  //                   }
  //                 }
  //
  //               }
  //             }
  //           }
  //           Observation observation = profiles.createObservationDailyStepsPerDay(
  //               allSyncingData[i], objectId,
  //               "${allSelectedServersUrl[j]
  //                   .patientFName}${allSelectedServersUrl[j].patientLName}",
  //               allSelectedServersUrl[j].patientId,identifierDataList: identifier);
  //
  //           observationId =
  //           await profiles.processResource(observation, Constant.trackingChart,
  //               allSelectedServersUrl[j].url,
  //               allSelectedServersUrl[j].clientId,
  //               allSelectedServersUrl[j].authToken);
  //
  //           getActivityKeyWiseData.objectId = observationId;
  //
  //           /* if (!getActivityKeyWiseData.objectIdList.contains(observationId)) {
  //             getActivityKeyWiseData.objectIdList[getServeIndex] = observationId;
  //
  //             if(getActivityKeyWiseData.serverUrlList[getServeIndex] != ""){
  //               getActivityKeyWiseData.serverUrlList[getServeIndex] = allSelectedServersUrl[j].url;
  //             }
  //             if(getActivityKeyWiseData.patientIdList[getServeIndex] != ""){
  //               getActivityKeyWiseData.patientIdList[getServeIndex] = allSelectedServersUrl[j].patientId;
  //             }
  //             if(getActivityKeyWiseData.patientNameList[getServeIndex] != ""){
  //               getActivityKeyWiseData.patientNameList[getServeIndex] = "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";
  //             }
  //           }*/
  //
  //           if(getActivityKeyWiseData.serverDetailList.where((element) => element.objectId == observationId).toList().isEmpty) {
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].objectId = observationId;
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl = allSelectedServersUrl[j].url;
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].patientId = allSelectedServersUrl[j].patientId;
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].patientName =  "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";
  //           }
  //
  //           await DataBaseHelper.shared.updateActivityData(
  //               getActivityKeyWiseData);
  //         }
  //         /*delayCountFiveSecond++;
  //         if(delayCountFiveSecond == 10){
  //           delayCountFiveSecond = 0;
  //           await Utils.apiCallApplyDelay5second();
  //         }*/
  //       }
  //
  //       var withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
  //           && element.isSelected && element.patientId != "").toList();
  //       if(withOutPrimaryData.isNotEmpty) {
  //         List<Identifier> identifierDataExtra = [];
  //         for (int a = 0; a < withOutPrimaryData.length; a++) {
  //           identifierDataExtra.clear();
  //           if (withOutPrimaryData[a].isSecure &&
  //               Utils.isExpiredToken(withOutPrimaryData[a].lastLoggedTime,
  //                   withOutPrimaryData[a].expireTime)) {
  //             showDialog(
  //               context: getX.Get.context!,
  //               barrierDismissible: false,
  //               builder: (BuildContext context) {
  //                 return AlertDialog(
  //                   title: const Text("Session Expired"),
  //                   content: Text("Your ${withOutPrimaryData[a]
  //                       .title} has expired. Please log in again. RestHeart"),
  //                   actions: <Widget>[
  //                     TextButton(
  //                       onPressed: () async {
  //                         getX.Get.back();
  //                         Utils.callSecureServerAPI(withOutPrimaryData[a].url,
  //                             withOutPrimaryData[a].clientId,
  //                             withOutPrimaryData[a].title);
  //                       },
  //                       child: const Text("Log in"),
  //                     ),
  //                     TextButton(
  //                       onPressed: () {
  //                         getX.Get.back();
  //                       },
  //                       child: const Text("Cancel"),
  //                     ),
  //                   ],
  //                 );
  //               },
  //             );
  //             return;
  //           }
  //
  //           var activityData = allSyncingData[i];
  //           ActivityTable getActivityKeyWiseData = await DataBaseHelper.shared
  //               .getActivityData(activityData.keyId);
  //
  //           var callAPIWithThisURL = withOutPrimaryData[a].url;
  //
  //           var getAllObjectIdList =
  //           getActivityKeyWiseData.serverDetailList.where((element) => element.serverUrl != callAPIWithThisURL).toList();
  //
  //           if(getAllObjectIdList.isNotEmpty){
  //             for (int d = 0; d < getAllObjectIdList.length; d++) {
  //               identifierDataExtra.add(Identifier(value:getAllObjectIdList[d].objectId ,system:
  //               FhirUri(getAllObjectIdList[d].serverUrl)));
  //             }
  //           }
  //
  //           var objectId = "";
  //           var getServeIndex = getActivityKeyWiseData.serverDetailList.indexWhere((
  //               element) =>
  //           element.serverUrl ==
  //               withOutPrimaryData[a].url).toInt();
  //           if (getServeIndex != -1) {
  //             objectId = getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ?? "";
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].dataSyncServerWise = true;
  //           }
  //           if(getActivityKeyWiseData.serverDetailList.isNotEmpty && getActivityKeyWiseData.identifierData.isNotEmpty){
  //             var aObject = getActivityKeyWiseData.identifierData.indexWhere((element) => element.url ==
  //                 withOutPrimaryData[a].url).toInt();
  //             if(aObject != -1){
  //               objectId = getActivityKeyWiseData.identifierData[aObject].objectId ?? "";
  //             }
  //           }
  //
  //           if(identifierDataExtra.isNotEmpty){
  //             Observation observation = profiles.createObservationDailyStepsPerDay(
  //                 allSyncingData[i], objectId,"${withOutPrimaryData[a]
  //                 .patientFName}${withOutPrimaryData[a].patientLName}",
  //                 withOutPrimaryData[a].patientId,identifierDataList: identifierDataExtra);
  //
  //
  //             await profiles.processResource(observation, Constant.trackingChart,
  //                 withOutPrimaryData[a].url,
  //                 withOutPrimaryData[a].clientId,
  //                 withOutPrimaryData[a].authToken);
  //           }
  //         }
  //       }
  //       delayCount++;
  //       if(delayCount == Constant.delayTimeLength){
  //         delayCount = 0;
  //         await Utils.apiCallApplyDelay10second();
  //       }
  //     }
  //   }
  // }
  //
  // static Future<void> observationSyncDataRestHeart( List<SyncMonthlyActivityData> allSyncingData) async {
  //
  //   PaaProfiles profiles = PaaProfiles();
  //   var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
  //   var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
  //   if(getPrimaryServerData.isNotEmpty){
  //     allSelectedServersUrl.remove(getPrimaryServerData[0]);
  //     allSelectedServersUrl.add(getPrimaryServerData[0]);
  //   }
  //   Debug.printLog("observationSyncDataRestHeart...$allSelectedServersUrl");
  //   int delayCount = 0;
  //   // int delayCountFiveSecond = 0;
  //   for (int i = 0; i < allSyncingData.length; i++) {
  //     if (allSyncingData[i].monthName == "" &&
  //         allSyncingData[i].headerType == Constant.titleHeartRateRest) {
  //       for (int j = 0; j < allSelectedServersUrl.length; j++) {
  //         if(allSelectedServersUrl[j].isSecure && Utils.isExpiredToken(allSelectedServersUrl[j].lastLoggedTime,allSelectedServersUrl[j].expireTime)){
  //           showDialog(
  //             context: getX.Get.context!,
  //             barrierDismissible: false,
  //             builder: (BuildContext context) {
  //               return AlertDialog(
  //                 title: const Text("Session Expired"),
  //                 content: Text("Your ${allSelectedServersUrl[j].title} has expired. Please log in again. RestHeart"),
  //                 actions: <Widget>[
  //                   TextButton(
  //                     onPressed: () async {
  //                       getX.Get.back();
  //                       Utils.callSecureServerAPI(allSelectedServersUrl[j].url,
  //                           allSelectedServersUrl[j].clientId,
  //                           allSelectedServersUrl[j].title);
  //                     },
  //                     child: const Text("Log in"),
  //                   ),
  //                   TextButton(
  //                     onPressed: () {
  //                       getX.Get.back();
  //                     },
  //                     child: const Text("Cancel"),
  //                   ),
  //                 ],
  //               );
  //             },
  //           );
  //           return;
  //         }
  //         var activityData = allSyncingData[i];
  //         ActivityTable getActivityKeyWiseData = await DataBaseHelper.shared
  //             .getActivityData(activityData.keyId);
  //         if(getActivityKeyWiseData.serverDetailList.isNotEmpty){
  //           getActivityKeyWiseData.isSync = true;
  //
  //           await DataBaseHelper.shared.updateActivityData(
  //               getActivityKeyWiseData);
  //
  //           String observationId = "";
  //
  //           var objectId = "";
  //           var getServeIndex = getActivityKeyWiseData.serverDetailList.indexWhere((
  //               element) =>
  //           element.serverUrl ==
  //               allSelectedServersUrl[j].url).toInt();
  //           if (getServeIndex != -1) {
  //             objectId = getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ?? "";
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].dataSyncServerWise = true;
  //           }
  //           if(getActivityKeyWiseData.serverDetailList.isNotEmpty && getActivityKeyWiseData.identifierData.isNotEmpty){
  //             var a = getActivityKeyWiseData.identifierData.indexWhere((element) => element.url == allSelectedServersUrl[j].url).toInt();
  //             if(a != -1){
  //               objectId = getActivityKeyWiseData.identifierData[a].objectId ?? "";
  //             }
  //           }
  //           List<Identifier> identifier = [];
  //           if(allSelectedServersUrl[j].isPrimary){
  //             var withOutPrimaryDataList = allSelectedServersUrl.where((element) => !element.isPrimary).toList();
  //             if(withOutPrimaryDataList.isNotEmpty){
  //               for (int a = 0; a < withOutPrimaryDataList.length; a++) {
  //                 if(getActivityKeyWiseData.serverDetailList.isNotEmpty) {
  //                   var getServeIndex = getActivityKeyWiseData.serverDetailList
  //                       .indexWhere((element) =>
  //                   element.serverUrl ==
  //                       withOutPrimaryDataList[a].url).toInt();
  //                   if(getServeIndex != -1){
  //                     identifier.add(Identifier(value: getActivityKeyWiseData.serverDetailList[getServeIndex].objectId,
  //                         system: FhirUri(getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl)));
  //                   }
  //                 }
  //
  //               }
  //             }
  //           }
  //           Observation observation = profiles.createObservationAverageRestingHeartRate(
  //               allSyncingData[i], objectId,"${allSelectedServersUrl[j]
  //               .patientFName}${allSelectedServersUrl[j].patientLName}",
  //               allSelectedServersUrl[j].patientId,identifierDataList: identifier);
  //
  //           observationId =
  //           await profiles.processResource(observation, Constant.trackingChart,
  //               allSelectedServersUrl[j].url,
  //               allSelectedServersUrl[j].clientId,
  //               allSelectedServersUrl[j].authToken);
  //
  //           getActivityKeyWiseData.objectId = observationId;
  //
  //           if(getActivityKeyWiseData.serverDetailList.where((element) => element.objectId == observationId).toList().isEmpty) {
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].objectId = observationId;
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl = allSelectedServersUrl[j].url;
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].patientId = allSelectedServersUrl[j].patientId;
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].patientName =  "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";
  //           }
  //           await DataBaseHelper.shared.updateActivityData(
  //               getActivityKeyWiseData);
  //         }
  //         /*delayCountFiveSecond++;
  //         if(delayCountFiveSecond == 10){
  //           delayCountFiveSecond = 0;
  //           await Utils.apiCallApplyDelay5second();
  //         }*/
  //       }
  //
  //       var withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
  //           && element.isSelected && element.patientId != "").toList();
  //       if(withOutPrimaryData.isNotEmpty) {
  //         List<Identifier> identifierDataExtra = [];
  //         for (int a = 0; a < withOutPrimaryData.length; a++) {
  //           identifierDataExtra.clear();
  //           if (withOutPrimaryData[a].isSecure &&
  //               Utils.isExpiredToken(withOutPrimaryData[a].lastLoggedTime,
  //                   withOutPrimaryData[a].expireTime)) {
  //             showDialog(
  //               context: getX.Get.context!,
  //               barrierDismissible: false,
  //               builder: (BuildContext context) {
  //                 return AlertDialog(
  //                   title: const Text("Session Expired"),
  //                   content: Text("Your ${withOutPrimaryData[a]
  //                       .title} has expired. Please log in again. RestHeart"),
  //                   actions: <Widget>[
  //                     TextButton(
  //                       onPressed: () async {
  //                         getX.Get.back();
  //                         Utils.callSecureServerAPI(withOutPrimaryData[a].url,
  //                             withOutPrimaryData[a].clientId,
  //                             withOutPrimaryData[a].title);
  //                       },
  //                       child: const Text("Log in"),
  //                     ),
  //                     TextButton(
  //                       onPressed: () {
  //                         getX.Get.back();
  //                       },
  //                       child: const Text("Cancel"),
  //                     ),
  //                   ],
  //                 );
  //               },
  //             );
  //             return;
  //           }
  //
  //           var activityData = allSyncingData[i];
  //           ActivityTable getActivityKeyWiseData = await DataBaseHelper.shared
  //               .getActivityData(activityData.keyId);
  //
  //           var callAPIWithThisURL = withOutPrimaryData[a].url;
  //
  //           var getAllObjectIdList =
  //           getActivityKeyWiseData.serverDetailList.where((element) => element.serverUrl != callAPIWithThisURL).toList();
  //
  //           if(getAllObjectIdList.isNotEmpty){
  //             for (int d = 0; d < getAllObjectIdList.length; d++) {
  //               identifierDataExtra.add(Identifier(value:getAllObjectIdList[d].objectId ,system:
  //               FhirUri(getAllObjectIdList[d].serverUrl)));
  //             }
  //           }
  //
  //           var objectId = "";
  //           var getServeIndex = getActivityKeyWiseData.serverDetailList.indexWhere((
  //               element) =>
  //           element.serverUrl ==
  //               withOutPrimaryData[a].url).toInt();
  //           if (getServeIndex != -1) {
  //             objectId = getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ?? "";
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].dataSyncServerWise = true;
  //           }
  //           if(getActivityKeyWiseData.serverDetailList.isNotEmpty && getActivityKeyWiseData.identifierData.isNotEmpty){
  //             var aObject = getActivityKeyWiseData.identifierData.indexWhere((element) => element.url ==
  //                 withOutPrimaryData[a].url).toInt();
  //             if(aObject != -1){
  //               objectId = getActivityKeyWiseData.identifierData[aObject].objectId ?? "";
  //             }
  //           }
  //
  //           if(identifierDataExtra.isNotEmpty){
  //             Observation observation = profiles.createObservationAverageRestingHeartRate(
  //                 allSyncingData[i], objectId,"${withOutPrimaryData[a]
  //                 .patientFName}${withOutPrimaryData[a].patientLName}",
  //                 withOutPrimaryData[a].patientId,identifierDataList: identifierDataExtra);
  //
  //
  //             await profiles.processResource(observation, Constant.trackingChart,
  //                 withOutPrimaryData[a].url,
  //                 withOutPrimaryData[a].clientId,
  //                 withOutPrimaryData[a].authToken);
  //           }
  //         }
  //       }
  //       delayCount++;
  //       if(delayCount == Constant.delayTimeLength){
  //         delayCount = 0;
  //         await Utils.apiCallApplyDelay10second();
  //       }
  //     }
  //   }
  // }
  //
  // static Future<void> observationSyncDataPeakHeart( List<SyncMonthlyActivityData> allSyncingData) async {
  //   PaaProfiles profiles = PaaProfiles();
  //   var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
  //   var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
  //   if(getPrimaryServerData.isNotEmpty){
  //     allSelectedServersUrl.remove(getPrimaryServerData[0]);
  //     allSelectedServersUrl.add(getPrimaryServerData[0]);
  //   }
  //   int delayCount = 0;
  //   // int delayCountFiveSecond = 0;
  //   for (int i = 0; i < allSyncingData.length; i++) {
  //     if (allSyncingData[i].monthName == "" &&
  //         allSyncingData[i].headerType == Constant.titleHeartRatePeak) {
  //       for (int j = 0; j < allSelectedServersUrl.length; j++) {
  //         if(allSelectedServersUrl[j].isSecure && Utils.isExpiredToken(allSelectedServersUrl[j].lastLoggedTime,allSelectedServersUrl[j].expireTime)){
  //           showDialog(
  //             context: getX.Get.context!,
  //             barrierDismissible: false,
  //             builder: (BuildContext context) {
  //               return AlertDialog(
  //                 title: const Text("Session Expired"),
  //                 content: Text("Your ${allSelectedServersUrl[j].title} has expired. Please log in again. PeakHeart"),
  //                 actions: <Widget>[
  //                   TextButton(
  //                     onPressed: () async {
  //                       getX.Get.back();
  //                       Utils.callSecureServerAPI(allSelectedServersUrl[j].url,
  //                           allSelectedServersUrl[j].clientId,
  //                           allSelectedServersUrl[j].title);
  //                     },
  //                     child: const Text("Log in"),
  //                   ),
  //                   TextButton(
  //                     onPressed: () {
  //                       getX.Get.back();
  //                     },
  //                     child: const Text("Cancel"),
  //                   ),
  //                 ],
  //               );
  //             },
  //           );
  //           return;
  //         }
  //         var activityData = allSyncingData[i];
  //         ActivityTable getActivityKeyWiseData = await DataBaseHelper.shared
  //             .getActivityData(activityData.keyId);
  //         if(getActivityKeyWiseData.serverDetailList.isNotEmpty){
  //           getActivityKeyWiseData.isSync = true;
  //
  //           await DataBaseHelper.shared.updateActivityData(
  //               getActivityKeyWiseData);
  //
  //           String observationId = "";
  //
  //           var objectId = "";
  //           var getServeIndex = getActivityKeyWiseData.serverDetailList.indexWhere((
  //               element) =>
  //           element.serverUrl ==
  //               allSelectedServersUrl[j].url).toInt();
  //           if (getServeIndex != -1) {
  //             objectId = getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ?? "";
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].dataSyncServerWise = true;
  //           }
  //           if(getActivityKeyWiseData.serverDetailList.isNotEmpty && getActivityKeyWiseData.identifierData.isNotEmpty){
  //             var a = getActivityKeyWiseData.identifierData.indexWhere((element) => element.url == allSelectedServersUrl[j].url).toInt();
  //             if(a != -1){
  //               objectId = getActivityKeyWiseData.identifierData[a].objectId ?? "";
  //             }
  //           }
  //           List<Identifier> identifier = [];
  //           if(allSelectedServersUrl[j].isPrimary){
  //             var withOutPrimaryDataList = allSelectedServersUrl.where((element) => !element.isPrimary).toList();
  //             if(withOutPrimaryDataList.isNotEmpty){
  //               for (int a = 0; a < withOutPrimaryDataList.length; a++) {
  //                 if(getActivityKeyWiseData.serverDetailList.isNotEmpty) {
  //                   var getServeIndex = getActivityKeyWiseData.serverDetailList
  //                       .indexWhere((element) =>
  //                   element.serverUrl ==
  //                       withOutPrimaryDataList[a].url).toInt();
  //                   if(getServeIndex != -1){
  //                     identifier.add(Identifier(value: getActivityKeyWiseData.serverDetailList[getServeIndex].objectId,
  //                         system: FhirUri(getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl)));
  //                   }
  //                 }
  //
  //               }
  //             }
  //           }
  //           Observation observation = profiles.createObservationDailyPeakHeartRate(
  //               allSyncingData[i], objectId,"${allSelectedServersUrl[j]
  //               .patientFName}${allSelectedServersUrl[j].patientLName}",
  //               allSelectedServersUrl[j].patientId,identifierDataList:identifier );
  //
  //           observationId =
  //           await profiles.processResource(observation, Constant.trackingChart,
  //               allSelectedServersUrl[j].url,
  //               allSelectedServersUrl[j].clientId,
  //               allSelectedServersUrl[j].authToken);
  //
  //           getActivityKeyWiseData.objectId = observationId;
  //
  //           /*if (!getActivityKeyWiseData.objectIdList.contains(observationId)) {
  //             getActivityKeyWiseData.objectIdList[getServeIndex] = observationId;
  //
  //             if(getActivityKeyWiseData.serverUrlList[getServeIndex] != ""){
  //               getActivityKeyWiseData.serverUrlList[getServeIndex] = allSelectedServersUrl[j].url;
  //             }
  //             if(getActivityKeyWiseData.patientIdList[getServeIndex] != ""){
  //               getActivityKeyWiseData.patientIdList[getServeIndex] = allSelectedServersUrl[j].patientId;
  //             }
  //             if(getActivityKeyWiseData.patientNameList[getServeIndex] != ""){
  //               getActivityKeyWiseData.patientNameList[getServeIndex] = "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";
  //             }
  //           }*/
  //
  //           if(getActivityKeyWiseData.serverDetailList.where((element) => element.objectId == observationId).toList().isEmpty) {
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].objectId = observationId;
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].serverUrl = allSelectedServersUrl[j].url;
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].patientId = allSelectedServersUrl[j].patientId;
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].patientName =  "${allSelectedServersUrl[j].patientFName}${allSelectedServersUrl[j].patientLName}";
  //           }
  //
  //           await DataBaseHelper.shared.updateActivityData(
  //               getActivityKeyWiseData);
  //         }
  //         /* delayCountFiveSecond++;
  //         if(delayCountFiveSecond == 10){
  //           delayCountFiveSecond = 0;
  //           await Utils.apiCallApplyDelay5second();
  //         }*/
  //       }
  //
  //       var withOutPrimaryData = Utils.getServerListPreference().where((element) => !element.isPrimary
  //           && element.isSelected && element.patientId != "").toList();
  //       if(withOutPrimaryData.isNotEmpty) {
  //         List<Identifier> identifierDataExtra = [];
  //         for (int a = 0; a < withOutPrimaryData.length; a++) {
  //           identifierDataExtra.clear();
  //           if (withOutPrimaryData[a].isSecure &&
  //               Utils.isExpiredToken(withOutPrimaryData[a].lastLoggedTime,
  //                   withOutPrimaryData[a].expireTime)) {
  //             showDialog(
  //               context: getX.Get.context!,
  //               barrierDismissible: false,
  //               builder: (BuildContext context) {
  //                 return AlertDialog(
  //                   title: const Text("Session Expired"),
  //                   content: Text("Your ${withOutPrimaryData[a]
  //                       .title} has expired. Please log in again. RestHeart"),
  //                   actions: <Widget>[
  //                     TextButton(
  //                       onPressed: () async {
  //                         getX.Get.back();
  //                         Utils.callSecureServerAPI(withOutPrimaryData[a].url,
  //                             withOutPrimaryData[a].clientId,
  //                             withOutPrimaryData[a].title);
  //                       },
  //                       child: const Text("Log in"),
  //                     ),
  //                     TextButton(
  //                       onPressed: () {
  //                         getX.Get.back();
  //                       },
  //                       child: const Text("Cancel"),
  //                     ),
  //                   ],
  //                 );
  //               },
  //             );
  //             return;
  //           }
  //
  //           var activityData = allSyncingData[i];
  //           ActivityTable getActivityKeyWiseData = await DataBaseHelper.shared
  //               .getActivityData(activityData.keyId);
  //
  //           var callAPIWithThisURL = withOutPrimaryData[a].url;
  //
  //           var getAllObjectIdList =
  //           getActivityKeyWiseData.serverDetailList.where((element) => element.serverUrl != callAPIWithThisURL).toList();
  //
  //           if(getAllObjectIdList.isNotEmpty){
  //             for (int d = 0; d < getAllObjectIdList.length; d++) {
  //               identifierDataExtra.add(Identifier(value:getAllObjectIdList[d].objectId ,system:
  //               FhirUri(getAllObjectIdList[d].serverUrl)));
  //             }
  //           }
  //
  //           var objectId = "";
  //           var getServeIndex = getActivityKeyWiseData.serverDetailList.indexWhere((
  //               element) =>
  //           element.serverUrl ==
  //               withOutPrimaryData[a].url).toInt();
  //           if (getServeIndex != -1) {
  //             objectId = getActivityKeyWiseData.serverDetailList[getServeIndex].objectId ?? "";
  //             getActivityKeyWiseData.serverDetailList[getServeIndex].dataSyncServerWise = true;
  //           }
  //           if(getActivityKeyWiseData.serverDetailList.isNotEmpty && getActivityKeyWiseData.identifierData.isNotEmpty){
  //             var aObject = getActivityKeyWiseData.identifierData.indexWhere((element) => element.url ==
  //                 withOutPrimaryData[a].url).toInt();
  //             if(aObject != -1){
  //               objectId = getActivityKeyWiseData.identifierData[aObject].objectId ?? "";
  //             }
  //           }
  //
  //           if(identifierDataExtra.isNotEmpty){
  //             Observation observation = profiles.createObservationDailyPeakHeartRate(
  //                 allSyncingData[i], objectId,"${withOutPrimaryData[a]
  //                 .patientFName}${withOutPrimaryData[a].patientLName}",
  //                 withOutPrimaryData[a].patientId,identifierDataList: identifierDataExtra);
  //
  //
  //             await profiles.processResource(observation, Constant.trackingChart,
  //                 withOutPrimaryData[a].url,
  //                 withOutPrimaryData[a].clientId,
  //                 withOutPrimaryData[a].authToken);
  //           }
  //         }
  //       }
  //       delayCount++;
  //       if(delayCount == Constant.delayTimeLength){
  //         delayCount = 0;
  //         await Utils.apiCallApplyDelay10second();
  //       }
  //     }
  //   }
  // }

}