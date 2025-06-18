import 'dart:convert';
import 'package:banny_table/ui/referralForm/datamodel/referralDataModel.dart';
import 'package:banny_table/ui/toDoList/dataModel/to_do_sync_data_model.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/selectPrimaryServer/datamodel/serverModelJson.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../db_helper/box/monthly_log_data.dart';
import '../../../resources/PaaProfiles.dart';
import '../../../resources/syncing.dart';
import '../../../utils/utils.dart';
import '../../carePlanForm/datamodel/carePlanSyncDataModel.dart';
import '../../conditionForm/datamodel/conditionSyncDataModel.dart';
import '../../configuration/datamodel/configuration_datamodel.dart';
import '../../goalForm/datamodel/goalDataModel.dart';
import '../../graph/controllers/graph_controller.dart';
import '../../home/monthly/datamodel/syncMonthlyActivityData.dart';
import '../../welcomeScreen/activityConfiguration/trackingPref/datamodel/trackingPref.dart';

class BottomNavigationController extends GetxController {
  int bottomSelectedIndex = 0;
  PageController pageController = PageController(initialPage: 0);
  PaaProfiles profiles = PaaProfiles();
  String patientId = "";
  String fName = "";
  String lName = "";
  String dob = "";
  String gender = "";
  List<ServerModelJson> serverModelList = [];
  ServerModelJson? selectedData;
  // GraphController controller = GraphController();



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
            icon: Icon(Icons.history, color: CColor.white),
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
    pageController.jumpToPage(index);
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    update();
  }

  String getHeaderNameFromIndex() {
    var title = "";
    if (bottomSelectedIndex == 0) {
      title = Constant.headerLogScreen;
    } else if (bottomSelectedIndex == 1) {
      title = Constant.headerHistoryScreen;
    } else if (bottomSelectedIndex == 2) {
      title = Constant.headerGraphLogScreen;
    } else if (bottomSelectedIndex == 3) {
      title = Constant.headerMixedScreen;
    } else if (bottomSelectedIndex == 4) {
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
  bool authorized = false;

  @override
  Future<void> onInit() async {
    if(Preference.shared.getTrackingPrefList(Preference.trackingPrefList)!.isEmpty) {
      var data = [
        TrackingPref(titleName: Constant.configurationHeaderTotal,pos: 0,isSelected: true/*,toolTipText: Constant.configurationHeaderToolTipTotal*/,),
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
    getServerListData();
    // dataSyncingProcess();
    pushGoalData();
    getActivityLevelData();

    // await activityDataAPICall(Utils.startDateTime(DateTime.now()),Utils.endDateTime(DateTime.now()));
    if (!kIsWeb) {
      // if(!Constant.isCalledAppleGoogleSync) {
      // await getPermission();
      // }
    }
    /*List<ActivityTable> activityAppleData = await Syncing.getAndSetSyncActivityLevelData();
    for (int i = 0; i < activityAppleData.length; i++) {
      Debug.printLog("activityAppleData data...${activityAppleData[i].displayLabel}  ${activityAppleData[i].title}  ${activityAppleData[i].total}  ${activityAppleData[i].objectId}");
    }*/
    // Debug.printLog("Package name...${Utils.getPackageName()}  ${activityAppleData.length}");
    if(Utils.getServerListPreference().isNotEmpty) {
      Utils.getConfigurationActivityDataListApi();
      Utils.setPatientDetailIdWise();
    }
    // getMonthlyData();
    // getActivityListDataAndSetOnConfiguration();
    super.onInit();
  }


  /*activityDataAPICall(DateTime startAfterDate,DateTime beforeEndDate) async {
    var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
    if(allSelectedServersUrl.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Utils.showDialogForProgress(
            Get.context!, Constant.txtPleaseWait, Constant.txtActivityDataProgress);
      });
      await Future.delayed(const Duration(milliseconds: 500));
      await Utils.isExpireTokenAPICall(Constant.screenTypeBottom,(value) async {
        if(!value){
          Get.back();
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await Utils.showDialogForProgress(
                Get.context!, Constant.txtPleaseWait, Constant.txtActivityDataProgress);
          });
          var year = startAfterDate.year;
          await Utils.setMonthlyAndActivityData(year.toString(),
              isFromMonth: false,isFromActivity: true,startAfterDate: startAfterDate,beforeEndDate:beforeEndDate);
          Get.back();
        }
      }).then((value) async {
        Debug.printLog("isExpireTokenAPICall....$value");
        if (!value) {
          var year = startAfterDate.year;
          await Utils.setMonthlyAndActivityData(year.toString(),
              isFromMonth: false,isFromActivity: true,startAfterDate: startAfterDate,beforeEndDate:beforeEndDate);
          Get.back();
        }
      });
    }
    update();
  }*/

  getServerListData() async {
      await Utils.setPatientDetailIdWise();
      serverModelList =
        Preference.shared.getServerList(Preference.serverUrlAllListed) ?? [];
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
      await Utils.getPerformerDataList(selectedData!);
    }
  }

  /*getPermission() async {
    if (Utils.getPermissionHealth()) {
      try {
        GetSetHealthData.importDataFromHealth((value) {}, false,endDate: Utils.endDateTime(DateTime.now()),startDate: Utils.startDateTime(DateTime.now()));
      } catch (e) {
        Debug.printLog("GetSetHealthData.importDataFromHealth...$e");
      }
    }
  }*/

  /*Future<void> getAndSetSyncMonthlyData() async {
    ///Monthly log data
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
  }*/

 /* syncMonthlyDataDayPerWeek(
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
  }*/

  /*Future<void> getAndSetSyncActivityData() async {
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
  }*/

  /*Future<void> callAPIForSyncData() async {
    /// Here you all data that we want to send in to backend ==>> allSyncingData
    for (int i = 0; i < allSyncingData.length; i++) {
      /// You can start your API call from here

      if (allSyncingData[i].monthName == "") {
        /// /// Tracking chart data (Activity) (Weekly and Daily)
        /// Need to find the type of activity first then IF ELSE to handle four cases
        /// Average Resting Heart Rate, Calories per day, Daily Steps, Peak Daily Heart Rate
        var activityData = allSyncingData[i];
        ActivityTable getActivityKeyWiseData =
            await DataBaseHelper.shared.getActivityData(activityData.keyId);
        getActivityKeyWiseData.isSync = true;

        String observationId = "";
        if (allSyncingData[i].headerType == Constant.titleCalories) {
          ///Calories
          Observation observation =
              profiles.createObservationCaloriesPerDay(allSyncingData[i]);
          observationId = await profiles.processResource(
              observation, Constant.trackingChart);
        } else if (allSyncingData[i].headerType == Constant.titleSteps) {
          ///Step
          Observation observation =
              profiles.createObservationDailyStepsPerDay(allSyncingData[i]);
          observationId = await profiles.processResource(
              observation, Constant.trackingChart);
        } else if (allSyncingData[i].headerType ==
            Constant.titleHeartRatePeak) {
          ///Heart peak
          Observation observation =
              profiles.createObservationDailyPeakHeartRate(allSyncingData[i]);
          observationId = await profiles.processResource(
              observation, Constant.trackingChart);
        } else if (allSyncingData[i].headerType ==
            Constant.titleHeartRateRest) {
          ///Heart rest
          Observation observation = profiles
              .createObservationAverageRestingHeartRate(allSyncingData[i]);
          observationId = await profiles.processResource(
              observation, Constant.trackingChart);
        }
        getActivityKeyWiseData.objectId = observationId;
        await DataBaseHelper.shared.updateActivityData(getActivityKeyWiseData);
      } else {
        /// Monthly (DayPerWeek, AVG min, AVG min per week and Strength)
        var activityData = allSyncingData[i];
        MonthlyLogTableData getActivityKeyWiseData =
            await DataBaseHelper.shared.getMonthlyData(activityData.keyId);
        Debug.printLog("getActivityKeyWiseData...$getActivityKeyWiseData");
        String observationId = "";

        ///We have 4 measure data in to monthly log. (DayPerWeek, AVG min, AVG min per week and Strength) So we are comparing data with type so we can know about that
        if (activityData.headerType == Constant.headerDayPerWeek) {
          ///Day Per Week
          Observation observation =
              profiles.createObservationDaysPerWeeks(allSyncingData[i]);
          String observationId =
              await profiles.processResource(observation, Constant.monthly);

          getActivityKeyWiseData.dayPerWeekId = observationId;
          getActivityKeyWiseData.isSyncDayPerWeek = true;
        } else if (activityData.headerType == Constant.headerAverageMin) {
          ///AVG min
          Observation observation =
              profiles.createObservationMintuesPerDay(allSyncingData[i]);
          String observationId =
              await profiles.processResource(observation, Constant.monthly);

          getActivityKeyWiseData.avgMinPerDayId = observationId;
          getActivityKeyWiseData.isSyncAvgMin = true;
        } else if (activityData.headerType ==
            Constant.headerAverageMinPerWeek) {
          ///AVG min per
          Observation observation =
              profiles.createObservationMintuesPerWeek(allSyncingData[i]);
          String observationId =
              await profiles.processResource(observation, Constant.monthly);

          getActivityKeyWiseData.avgPerWeekId = observationId;
          getActivityKeyWiseData.isSyncAvgMinPerWeek = true;
        } else if (activityData.headerType == Constant.headerStrength) {
          ///Strength
          Observation observation =
              profiles.createObservationStrengthDaysPerWeek(allSyncingData[i]);
          String observationId =
              await profiles.processResource(observation, Constant.monthly);

          getActivityKeyWiseData.strengthId = observationId;
          getActivityKeyWiseData.isSyncStrength = true;
        }
        await DataBaseHelper.shared.updateMonthlyData(getActivityKeyWiseData);
      }
    }
  }*/

 /* Future<void> dataSyncingProcess() async {
    await Utils.isExpireTokenAPICall(Constant.screenTypeBottom,(value) async {
      if(!value){
        await Syncing.getAndSetSyncActivityData(allSyncingData);
        await Syncing.getAndSetSyncMonthlyData(allSyncingData);
        if(allSyncingData.isNotEmpty) {
          await syncTimeAPICallConfirm();
        }
      }
    }).then((value) async  {
      if(!value){
        await Syncing.getAndSetSyncActivityData(allSyncingData);
        await Syncing.getAndSetSyncMonthlyData(allSyncingData);
        if(allSyncingData.isNotEmpty) {
          await syncTimeAPICallConfirm();
        }
      }
    });

  }

  syncTimeAPICallConfirm() async {
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
        callApisFunctions(allSyncingData, goalDataList, referralDataList,
            conditionDataList, carePlanDataList, toDoDataList);
        Debug.printLog("Running Week");
      }
    } else if (selectedSyncing == Constant.daily) {
      if (selectTodayDate.difference(savedDate).inHours >= 24 ||
          selectedDate == "") {
        Debug.printLog(Constant.daily);
        String dateSelected = DateTime.now().toString();
        prefs.setString(Constant.keySyncingTime, dateSelected);
        callApisFunctions(allSyncingData, goalDataList, referralDataList,
            conditionDataList, carePlanDataList, toDoDataList);
        Debug.printLog("Running daily");
      }
    }
  }

  callApisFunctions(
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
    Syncing.observationSyncDataExperience(allSyncingData);
    Syncing.observationSyncDataTotalMin(allSyncingData);
    Syncing.observationSyncDataModMin(allSyncingData);
    Syncing.observationSyncDataVigMin(allSyncingData);
    Syncing.observationSyncDataStrengthBox(allSyncingData);

    // Syncing.goalSyncingData(false, goalDataList);
    // Syncing.referralSyncingData(false, referralDataList);
    // Syncing.conditionSyncingData(false, conditionDataList);
    // Syncing.carePlanSyncingData(false, carePlanDataList);
    // Syncing.toDoSyncingData(false,toDoDataList);
  }*/

  Future<void> getActivityLevelData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    List<ConfigurationClass> prefData = Preference.shared.getConfigPrefList(Preference.configurationInfo) ?? [];

    // List<String> prefData = pref.getStringList(Preference.activityData) ?? [];
    if (prefData.isEmpty) {
      ///Set default data
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
      ///Call Api For configuration Data Push
      await Utils.callPushApiForConfigurationActivity();
      // pref.setStringList(Preference.activityData, defaultStrList);
    }


    // List<String> prefDataIcons =
    //     pref.getStringList(Preference.activityDataIcons) ?? [];
    // if (prefDataIcons.isEmpty) {
    //   ///Set default data
    //   List<String> defaultStrListIcons = [
    //     Constant.iconBicycling,
    //     Constant.iconJogging,
    //     Constant.iconRunning,
    //     Constant.iconSwimming,
    //     Constant.iconWalking,
    //     Constant.iconWeights,
    //     Constant.iconMixed,
    //   ];
    //   pref.setStringList(Preference.activityDataIcons, defaultStrListIcons);
    // }
    //
    // List<String> prefDataCode = pref.getStringList(Preference.activityDataCode) ?? [];
    // if(prefDataCode.isEmpty){
    //   ///Set default data
    //   List<String> defaultStrListCode = [
    //     Constant.codeBicycling,
    //     Constant.codeJogging,
    //     Constant.codeRunning,
    //     Constant.codeSwimming,
    //     Constant.codeWalking,
    //     Constant.codeWeights,
    //     Constant.codeMixed,
    //   ];
    //   pref.setStringList(Preference.activityDataCode,defaultStrListCode);
    // }

    if (Constant.configurationInfo.isEmpty) {
      getActivityListDataAndSetOnConfiguration();
    }
  }

 /* Future<void> getActivityListDataAndSetOnConfiguration() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> activityData =
        sharedPreferences.getStringList(Preference.activityData) ?? [];
    List<String> activityDataIcons =
        sharedPreferences.getStringList(Preference.activityDataIcons) ?? [];
    if (activityData.isNotEmpty) {
      Constant.configurationInfo.clear();
      for (int i = 0; i < activityData.length; i++) {
        // Constant.configurationInfo.add(ConfigurationClass(activityData[i], Utils.getNumberIconNameFromType(activityData[i])));
        Constant.configurationInfo
            .add(ConfigurationClass(activityData[i], activityDataIcons[i]));
      }
      Constant.configurationInfoGraphManage.clear();
      Constant.configurationInfoGraphManage.add(
        ConfigurationClass(Constant.titleNon, ""),
      );
      Constant.configurationInfoGraphManage.addAll(Constant.configurationInfo);
    }
  }*/
  Future<void> getActivityListDataAndSetOnConfiguration() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // List<String> activityData = sharedPreferences.getStringList(Preference.activityData) ?? [];
    // List<String> activityDataIcons = sharedPreferences.getStringList(Preference.activityDataIcons) ?? [];
    // List<String> activityDataCode = sharedPreferences.getStringList(Preference.activityDataCode) ?? [];
    // if(activityData.isNotEmpty){
      /*Constant.configurationInfo.clear();
      if(Preference.shared.getConfigPrefList(Preference.configurationInfo)!.isEmpty){
        for(int i=0;i < activityData.length;i++){
          Constant.configurationInfo.add(ConfigurationClass(title: activityData[i],iconImage:  activityDataIcons[i],activityCode: activityDataCode[i]));
        }
        var json = jsonEncode(Constant.configurationInfo.map((e) => e.toJson()).toList());
        Preference.shared.setList(Preference.configurationInfo, json);
      }*/
      Constant.configurationInfo = Preference.shared.getConfigPrefList(Preference.configurationInfo) ?? [];

      Constant.configurationInfoGraphManage.clear();
      Constant.configurationInfoGraphManage.add(ConfigurationClass(title: Constant.titleNon,iconImage: "",activityCode: ""),);
      Constant.configurationInfoGraphManage.addAll(Constant.configurationInfo);
    // }


  }

  selectedTimeFrameGraph(String values) {
    Constant.selectedTimeFrame = values.toString();
    GraphController graphController = Get.find();
    graphController.handleGraphUpdate(values);
  }

  updateMethod(){
    update();
  }


  pushGoalData() async {
    if (Utils.getPrimaryServerData() != null  && Utils.getPrimaryServerData()!.url != "") {
          await Syncing.goalSyncingData(true, []).then((value) async => {
          await Utils.clearGoalData(),
          });
    }
  }

  getMonthlyData(){
    var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
    if(allSelectedServersUrl.isNotEmpty) {
      Utils.setMonthlyAndActivityData( DateTime.now().year.toString(),isFromMonth: true,isFromActivity: false);
    }
  }

  List<MonthlyLogTableData> getMonthlyDataList(){
    return Hive
        .box<MonthlyLogTableData>(Constant.tableMonthlyLog)
        .values
        .toList().where((element) => element.patientId == Utils.getPatientId()).toList();
  }

}
