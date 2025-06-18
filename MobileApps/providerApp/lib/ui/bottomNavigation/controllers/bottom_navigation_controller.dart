import 'dart:convert';
import 'package:banny_table/db_helper/database_helper.dart';
import 'package:banny_table/healthData/getSetHealthData.dart';
import 'package:banny_table/ui/ExercisePrescription/dataModel/exercisePrescriptionDataModel.dart';
import 'package:banny_table/ui/graph/controllers/graph_controller.dart';
import 'package:banny_table/ui/history/controllers/history_controller.dart';
import 'package:banny_table/ui/referralForm/datamodel/referralDataModel.dart';
import 'package:banny_table/ui/toDoList/dataModel/to_do_sync_data_model.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/trackingPref/dataModel/trackingPref.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/qrScanner/datamodel/serverModelJson.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../db_helper/box/activity_data.dart';
import '../../../db_helper/box/monthly_log_data.dart';
import '../../../resources/PaaProfiles.dart';
import '../../../utils/utils.dart';
import '../../carePlanForm/datamodel/carePlanSyncDataModel.dart';
import '../../conditionForm/datamodel/conditionSyncDataModel.dart';
import '../../configuration/datamodel/configuration_datamodel.dart';
import '../../goalForm/datamodel/goalDataModel.dart';
import '../../home/monthly/datamodel/syncMonthlyActivityData.dart';

class BottomNavigationController extends GetxController {
  int bottomSelectedIndex = 0;
  PageController pageController = PageController(initialPage: 0);
  PaaProfiles profiles = PaaProfiles();
  String patientId = "";
  String fName = "";
  String lName = "";
  String dob = "";
  String gender = "";

  Function? callback;

  BottomNavigationBar buildBottomNavBarItems() {
    return BottomNavigationBar(
      selectedFontSize: 0,
      onTap: (value) {
        onPageChanged(value);
      },
      currentIndex: bottomSelectedIndex,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.home, color: CColor.white),
            label: "",
            backgroundColor: CColor.primaryColor),
        BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart, color: CColor.white),
            label: "",
            backgroundColor: CColor.primaryColor),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: CColor.white),
            label: "",
            backgroundColor: CColor.primaryColor),
        BottomNavigationBarItem(
            icon: Icon(Icons.all_inbox_sharp, color: CColor.white),
            label: "",
            backgroundColor: CColor.primaryColor),
      ],
    );
  }

  void onPageChanged(int index) {
    Debug.printLog("onPageChanged index....$index");
    bottomSelectedIndex = index;
    pageController.jumpToPage(
      index,
    );
    // if(bottomSelectedIndex == 1){
    //   // callApiForTrackingChartDataAndInit();
    // }
    update();
  }

/*
  callApiForTrackingChartDataAndInit() async {
    List<ActivityTable> activityData =
    (Utils.getPatientId() != "") ? Hive.box<ActivityTable>(Constant.tableActivity).values.toList().where((element) =>
    element.patientId == Utils.getPatientId()).toList() : Hive.box<ActivityTable>(Constant.tableActivity).values.toList();

    HistoryController historyController = Get.find();
    if(activityData.isNotEmpty){
      await historyController.getAndSetWeeksData(DateTime.now());
    }else{
      await historyController.getAndSetWeeksData(DateTime.now(),isNotGraph: true);
    }
    update();
  }
*/


  String getHeaderNameFromIndex() {
    var title = "";
    if (bottomSelectedIndex == 0) {
      title = Constant.headerLogScreen;
    } else if (bottomSelectedIndex == 1) {
      title = Constant.headerGraphLogScreen;
    } else if (bottomSelectedIndex == 2) {
      title = Constant.headerHistoryScreen;
    } else if (bottomSelectedIndex == 3) {
      title = Constant.headerSettingScreen;
    }
    return title;
  }

  List<SyncMonthlyActivityData> allSyncingData = [];
  List<GoalSyncDataModel> goalDataList = [];
  List<ReferralSyncDataModel> referralDataList = [];
  List<ConditionSyncDataModel> conditionDataList = [];
  List<CarePlanSyncDataModel> carePlanDataList = [];
  List<TaskSyncDataModel> toDoDataList = [];
  List<ExercisePrescriptionSyncDataModel> exercisePrescriptionList = [];
  bool authorized = false;
  List<ServerModelJson> serverModelList = [];
  ServerModelJson? selectedData;

  @override
  void onInit() {
    if (Preference.shared
        .getTrackingPrefList(Preference.trackingPrefList)!
        .isEmpty) {
      var data = [
        TrackingPref(
            titleName: Constant.configurationHeaderTotal,
            pos: 0,
            isSelected: true),
        TrackingPref(
            titleName: Constant.configurationHeaderModerate,
            pos: 1,
            isSelected: true),
        TrackingPref(
            titleName: Constant.configurationHeaderVigorous,
            pos: 2,
            isSelected: true),
        TrackingPref(
            titleName: Constant.configurationNotes, pos: 3, isSelected: true),
        TrackingPref(
            titleName: Constant.configurationHeaderDays,
            pos: 4,
            isSelected: true),
        TrackingPref(
            titleName: Constant.configurationHeaderCalories,
            pos: 5,
            isSelected: true),
        TrackingPref(
            titleName: Constant.configurationHeaderSteps,
            pos: 6,
            isSelected: true),
        TrackingPref(
            titleName: Constant.configurationHeaderRest,
            pos: 7,
            isSelected: true),
        TrackingPref(
            titleName: Constant.configurationHeaderPeck,
            pos: 8,
            isSelected: true),
        TrackingPref(
            titleName: Constant.configurationExperience,
            pos: 9,
            isSelected: true),
      ];
      var json = jsonEncode(data.map((e) => e.toJson()).toList());
      Preference.shared.setList(Preference.trackingPrefList, json);

      ///Call Api For configuration Data Push
      Utils.callPushApiForConfigurationActivity();
    }
    // dataSyncingProcess();
    getActivityLevelData();
    getAllPatientData();
    getServerListData();
    super.onInit();
  }

  getServerListData() async {
    await Utils.setPractitionerDetailIdWise();
    serverModelList = Preference.shared
            .getServerListedAllUrl(Preference.serverUrlAllListed)!
            .where((element) =>
                element.isSingleServer ==
                (Preference.shared.getBool(Preference.isSingleServer) ?? false))
            .toList() ??
        [];
    if (serverModelList
        .where((element) => element.isPrimary)
        .toList()
        .isNotEmpty) {
      selectedData =
          serverModelList.where((element) => element.isPrimary).toList()[0];
    }
  }

  getAllPatientData() async {
    if (Utils.getPatientId() != "" && Utils.getAPIEndPoint() != "") {
      if (selectedData != null) {
        await Utils.getPerformerDataList(selectedData!);
      }
    }
  }

  Future<void> getAndSetSyncMonthlyData() async {
    var monthlyDataDbList =
        Hive.box<MonthlyLogTableData>(Constant.tableMonthlyLog).values.toList();
    if (monthlyDataDbList.isNotEmpty) {
      for (int i = 0; i < Utils.allYearlyMonths.length; i++) {
        syncMonthlyDataDayPerWeek(monthlyDataDbList, i);
        syncMonthlyDataAverageMin(monthlyDataDbList, i);
        syncMonthlyDataAverageMinPerWeek(monthlyDataDbList, i);
        syncMonthlyDataStrength(monthlyDataDbList, i);
      }
    }
    Debug.printLog("allSyncingData...$allSyncingData");
  }

  syncMonthlyDataDayPerWeek(
      List<MonthlyLogTableData> monthlyDataDbList, int i) {
    ///Day per week
    var nonSyncDayPerWeekData = monthlyDataDbList
        .where((element) =>
            !element.isSyncDayPerWeek &&
            Utils.allYearlyMonths[i].name == element.monthName)
        .toList();
    if (nonSyncDayPerWeekData.isNotEmpty) {
      try {
        allSyncingData.add(SyncMonthlyActivityData(
            Utils.allYearlyMonths[i].name,
            nonSyncDayPerWeekData[0].dayPerWeekValue ?? 0.0,
            nonSyncDayPerWeekData[0].startDate,
            nonSyncDayPerWeekData[0].endDate,
            nonSyncDayPerWeekData[0].key,
            Constant.headerDayPerWeek,
            true,
            nonSyncDayPerWeekData[0].dayPerWeekId));
      } catch (e) {
        Debug.printLog("syncMonthlyDataDayPerWeek.. catch..$e");
      }
    }
  }

  syncMonthlyDataAverageMin(
      List<MonthlyLogTableData> monthlyDataDbList, int i) {
    ///AVG min
    var nonSyncDayPerWeekData = monthlyDataDbList
        .where((element) =>
            !element.isSyncAvgMin &&
            Utils.allYearlyMonths[i].name == element.monthName)
        .toList();
    if (nonSyncDayPerWeekData.isNotEmpty) {
      try {
        allSyncingData.add(SyncMonthlyActivityData(
            Utils.allYearlyMonths[i].name,
            nonSyncDayPerWeekData[0].avgMinValue ?? 0.0,
            nonSyncDayPerWeekData[0].startDate,
            nonSyncDayPerWeekData[0].endDate,
            nonSyncDayPerWeekData[0].key,
            Constant.headerAverageMin,
            true,
            nonSyncDayPerWeekData[0].avgMinPerDayId));
      } catch (e) {
        Debug.printLog("syncMonthlyDataAverageMin.. catch..$e");
      }
    }
  }

  syncMonthlyDataAverageMinPerWeek(
      List<MonthlyLogTableData> monthlyDataDbList, int i) {
    ///AVH min per week
    var nonSyncDayPerWeekData = monthlyDataDbList
        .where((element) =>
            !element.isSyncAvgMinPerWeek &&
            Utils.allYearlyMonths[i].name == element.monthName)
        .toList();
    if (nonSyncDayPerWeekData.isNotEmpty) {
      try {
        allSyncingData.add(SyncMonthlyActivityData(
            Utils.allYearlyMonths[i].name,
            nonSyncDayPerWeekData[0].avgMInPerWeekValue ?? 0.0,
            nonSyncDayPerWeekData[0].startDate,
            nonSyncDayPerWeekData[0].endDate,
            nonSyncDayPerWeekData[0].key,
            Constant.headerAverageMinPerWeek,
            true,
            nonSyncDayPerWeekData[0].avgPerWeekId));
      } catch (e) {
        Debug.printLog("syncMonthlyDataAverageMinPerWeek.. catch..$e");
      }
    }
  }

  syncMonthlyDataStrength(List<MonthlyLogTableData> monthlyDataDbList, int i) {
    ///Strength
    var nonSyncDayPerWeekData = monthlyDataDbList
        .where((element) =>
            !element.isSyncStrength &&
            Utils.allYearlyMonths[i].name == element.monthName)
        .toList();
    if (nonSyncDayPerWeekData.isNotEmpty) {
      try {
        allSyncingData.add(SyncMonthlyActivityData(
            Utils.allYearlyMonths[i].name,
            nonSyncDayPerWeekData[0].strengthValue ?? 0.0,
            nonSyncDayPerWeekData[0].startDate,
            nonSyncDayPerWeekData[0].endDate,
            nonSyncDayPerWeekData[0].key,
            Constant.headerStrength,
            true,
            nonSyncDayPerWeekData[0].strengthId));
      } catch (e) {
        Debug.printLog("syncDayPerWeekData.. catch..$e");
      }
    }
  }

  Future<void> getAndSetSyncActivityData() async {
    /// Tracking chart data (Activity)
    var dataListHive =
        Hive.box<ActivityTable>(Constant.tableActivity).values.toList();
    if (dataListHive.isNotEmpty) {
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

  void weekDayUnSyncData(
      List<ActivityTable> dataListHive,
      List<SyncMonthlyActivityData> syncActivityDataList,
      String titleType,
      bool isDay) {
    var unSyncedCaloriesWeekData = dataListHive
        .where((element) =>
            !element.isSync &&
            element.title == titleType &&
            element.type == ((isDay) ? Constant.typeDay : Constant.typeWeek))
        .toList();
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

/*  Future<void> dataSyncingProcess() async {
    await Syncing.getAndSetSyncActivityData(allSyncingData);
    await Syncing.getAndSetSyncMonthlyData(allSyncingData);
    await Syncing.getAndSetSyncGoalData(goalDataList);

    await Utils.isExpireTokenAPICall(Constant.screenTypeBottom,(value) async {
      if (!value) {
        if (goalDataList.isNotEmpty || allSyncingData.isNotEmpty) {
          await syncTimeAPICallConfirm();
        }
        await Syncing.getAndSetSyncExercisePrescriptionData(
            exercisePrescriptionList);
        if (exercisePrescriptionList.isNotEmpty || allSyncingData.isNotEmpty) {
          await syncTimeAPICallConfirm();
        }
        await Syncing.getAndSetSyncConditionData(conditionDataList);
        if (conditionDataList.isNotEmpty || allSyncingData.isNotEmpty) {
          await syncTimeAPICallConfirm();
        }
      }
    }).then((value) async {
      if (!value) {
        if (goalDataList.isNotEmpty || allSyncingData.isNotEmpty) {
          await syncTimeAPICallConfirm();
        }
        await Syncing.getAndSetSyncExercisePrescriptionData(
            exercisePrescriptionList);
        if (exercisePrescriptionList.isNotEmpty || allSyncingData.isNotEmpty) {
          await syncTimeAPICallConfirm();
        }
        await Syncing.getAndSetSyncConditionData(conditionDataList);
        if (conditionDataList.isNotEmpty || allSyncingData.isNotEmpty) {
          await syncTimeAPICallConfirm();
        }
      }
    });
  }*/

/*  syncTimeAPICallConfirm() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? selectedSyncing =
        prefs.getString(Constant.keySyncing) ?? Constant.realTime;
    String selectedDate = prefs.getString(Constant.keySyncingTime) ?? "";
    Debug.printLog(" Date Today ----->> ${DateTime.now().toString()}");
    Debug.printLog(
        " Date Next 7 Day----->> ${DateTime.now().add(const Duration(days: 7)).toString()}");
    DateTime? savedDate;
    if (selectedDate == "") {
      savedDate = DateTime.now();
    } else {
      savedDate = DateTime.parse(selectedDate);
    }

    DateTime selectTodayDate = DateTime.now();

    if (selectedSyncing == Constant.weekly) {
      if (selectTodayDate.difference(savedDate).inDays >= 7 ||
          selectedDate == "") {
        String dateSelected = DateTime.now().toString();
        await prefs.setString(Constant.keySyncingTime, dateSelected);
        Debug.printLog(Constant.weekly);
        // callApisFunctions(allSyncingData, goalDataList, referralDataList,
        //     conditionDataList, carePlanDataList, toDoDataList);
        Debug.printLog("Running Week");
      }
    } else if (selectedSyncing == Constant.daily) {
      if (selectTodayDate.difference(savedDate).inHours >= 24 ||
          selectedDate == "") {
        Debug.printLog(Constant.daily);
        String dateSelected = DateTime.now().toString();
        prefs.setString(Constant.keySyncingTime, dateSelected);
        // callApisFunctions(allSyncingData, goalDataList, referralDataList,
        //     conditionDataList, carePlanDataList, toDoDataList);
        Debug.printLog("Running daily");
      }
    }
  }*/

/*  callApisFunctions(
      List<SyncMonthlyActivityData> allSyncingData,
      List<GoalSyncDataModel> goalDataList,
      List<ReferralSyncDataModel> referralDataList,
      List<ConditionSyncDataModel> conditionDataList,
      List<CarePlanSyncDataModel> carePlanDataList,
      List<TaskSyncDataModel> toDoDataList) {
    Syncing.observationSyncDataDaysPerWeeks(allSyncingData);
    Syncing.observationSyncDataMinPerDay(allSyncingData);
    Syncing.observationSyncDataMinPerWeek(allSyncingData);
    Syncing.observationSyncDataStrengthDaysPerWeek(allSyncingData);

    Syncing.observationSyncDataCalories(allSyncingData);
    Syncing.observationSyncDataSteps(allSyncingData);
    Syncing.observationSyncDataPeakHeart(allSyncingData);
    Syncing.observationSyncDataRestHeart(allSyncingData);
  }*/

  Future<void> getActivityLevelData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    List<String> prefData = pref.getStringList(Preference.activityData) ?? [];
    if (prefData.isEmpty) {
      ///Set default data
      List<String> defaultStrList = [
        Constant.itemBicycling,
        Constant.itemJogging,
        Constant.itemRunning,
        Constant.itemSwimming,
        Constant.itemWalking,
        Constant.itemWeights,
        Constant.itemMixed,
      ];
      pref.setStringList(Preference.activityData, defaultStrList);
    }

    List<String> prefDataIcons =
        pref.getStringList(Preference.activityDataIcons) ?? [];
    if (prefDataIcons.isEmpty) {
      ///Set default data
      List<String> defaultStrListIcons = [
        Constant.iconBicycling,
        Constant.iconJogging,
        Constant.iconRunning,
        Constant.iconSwimming,
        Constant.iconWalking,
        Constant.iconWeights,
        Constant.iconMixed,
      ];
      pref.setStringList(Preference.activityDataIcons, defaultStrListIcons);
    }

    if (Constant.configurationInfo.isEmpty) {
      getActivityListDataAndSetOnConfiguration();
    }
  }

  Future<void> getActivityListDataAndSetOnConfiguration() async {
    Constant.configurationInfo =
        Preference.shared.getConfigPrefList(Preference.configurationInfo) ?? [];
    Constant.configurationInfoGraphManage.clear();
    Constant.configurationInfoGraphManage.add(
      ConfigurationClass(
          title: Constant.titleNon, iconImage: "", activityCode: ""),
    );
    Constant.configurationInfoGraphManage.addAll(Constant.configurationInfo);
  }

  selectedTimeFrameGraph(String values) {
    Constant.selectedTimeFrame = values.toString();
    GraphController graphController = Get.find();
    graphController.handleGraphUpdate(values);
  }


  updateMethod(){
    update();
  }
}
