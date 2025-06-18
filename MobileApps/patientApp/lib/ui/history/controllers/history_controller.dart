import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:banny_table/db_helper/box/activity_data.dart';
import 'package:banny_table/db_helper/box/server_detail_data.dart';
import 'package:banny_table/db_helper/box/server_detail_data_vig_min.dart';
import 'package:banny_table/ui/configuration/datamodel/configuration_datamodel.dart';
import 'package:banny_table/ui/history/datamodel/activityMinClass.dart';
import 'package:banny_table/ui/history/datamodel/caloriesStepHeartRate.dart';
import 'package:banny_table/ui/history/datamodel/daysStrength.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/trackingPref/datamodel/trackingPref.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:hive/hive.dart';
import 'package:horizontal_data_table/refresh/hdt_refresh_controller.dart';
import 'package:horizontal_data_table/refresh/pull_to_refresh/src/smart_refresher.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../db_helper/box/monthly_log_data.dart';
import '../../../db_helper/box/server_detail_data_mod_min.dart';
import '../../../db_helper/database_helper.dart';
import '../../../healthData/getSetHealthData.dart';
import '../../../healthData/getWorkOutDataModel.dart';
import '../../../resources/syncing.dart';
import '../../../utils/color.dart';
import '../../../utils/constant.dart';
import '../../../utils/preference.dart';
import '../../../utils/utils.dart';
import '../../home/monthly/datamodel/syncMonthlyActivityData.dart';
import '../datamodel/activityLevelDataModel.dart';

class HistoryController extends GetxController with WidgetsBindingObserver {


  final GlobalKey<PopupMenuButtonState<int>> popupMenuKey = GlobalKey<PopupMenuButtonState<int>>();
  bool isMenuOpen = false;


  menuManege(bool value){
    isMenuOpen = value;
    update();
  }

  ScrollController controllerScrollBar = ScrollController();
  ScrollController controller = ScrollController();
  HDTRefreshController refreshController = HDTRefreshController();

  int selectedExpandType = -1;
  // ScrollController freezeScrollController = ScrollController();
  // ScrollController verticalController = ScrollController();
  ScrollController controller2 = ScrollController();
  List<WeekLevelData> trackingChartDataList = [];
  List<RowsDataClass> titlesListData = [];
  var tableKey = GlobalKey();

  List<CaloriesStepHeartRateWeek> caloriesDataList = [];
  List<CaloriesStepHeartRateWeek> stepsDataList = [];
  List<CaloriesStepHeartRateWeek> heartRateRestDataList = [];
  List<CaloriesStepHeartRateWeek> heartRatePeakDataList = [];
  List<CaloriesStepHeartRateWeek> experienceDataList = [];

  List<OtherTitles2CheckBoxWeek> daysStrengthDataList = [];

  List<TrackingPref> trackingPrefList = [];

  bool isPortrait = true;

  bool isWeekExpanded = false;
  bool isDayExpanded = false;
  bool isHideRow = false;
  String startDate = "";
  String endDate = "";
  DateTime previousDate = DateTime.now();
  DateTime nextDate = DateTime.now();

  var labelIcon = "assets/icons/ic_emoji(1).jpeg";
  // TextEditingController notesController = TextEditingController();
  String notesValueLocal = "";
  QuillController notesController = QuillController.basic();


  ReceivePort receivePort = ReceivePort();
  late SendPort sendPort;

  DateTime activityStartDateLast = DateTime.now();
  DateTime activityEndDateLast = DateTime.now();

  onChangeActivityTimeLast(DateTime startTime,DateTime endTime){
    activityStartDateLast = startTime;
    activityEndDateLast = endTime;
    update();
  }

/*  editNoteDataController(String value){
    notesValueLocal = value;
    update();
  }*/

  @override
  Future<void> onInit() async {
    WidgetsBinding.instance.addObserver(this);
    Debug.printLog("Monthly data ${getMonthlyDataList()}");
    trackingPrefList = Preference.shared.getTrackingPrefList(Preference.trackingPrefList) ?? [];
    if(kIsWeb){
      FocusScope.of(Get.context!).requestFocus(new FocusNode());
      Constant.boolCalories = true;
      Constant.boolSteps = true;
      Constant.boolHeartRate = true;
      Constant.boolExperience = true;
      Constant.boolActivityMinMod = true;
      Constant.boolActivityMinVig = true;
      getTitlesData(isForceTrue: true);
      update();
    }else{
      getTitlesData();
    }

    getAndSetWeeksData(selectedNewDate);
    FocusManager.instance.primaryFocus?.unfocus();
    // verticalController.addListener(scrollListenerVertical);
    // freezeScrollController.addListener(scrollListenerFreeze);

    if (!kIsWeb) {
      receivePort.listen((message) async {
        if (message == Constant.callMessage) {
          Debug.printLog('Background isolate response:..... $message');
          await Syncing.dataSyncingProcess(true);
        }
      });

      Isolate.spawn((message) {
        Debug.printLog('Background isolate received message: $message');
      }, receivePort.sendPort);
      sendPort = receivePort.sendPort;
    }else{
      await Syncing.dataSyncingProcess(true);
    }
    super.onInit();
  }

  getAppleUnSyncActivityLevelData() async {
    List<ActivityTable> activityAppleData = await Syncing.getAndSetSyncActivityLevelData();
    if(activityAppleData.isEmpty){
      return;
    }
    for (var i = 0; i < activityAppleData.length; i++) {
      var data = activityAppleData[i];

      if(data.title == Constant.titleActivityType){
        await Syncing.createChildActivityNameObservation(
            data.displayLabel ?? "",
            data,isAppleHealthData: true);
      }

      if(data.title == null && data.smileyType == null && data.total != null && (data.total ?? 0.0) > 0.0){
        await Syncing.createChildActivityTotalMinObservation(
            data.displayLabel ?? "",
            data,isAppleHealthData: true);
      }

      if(data.title == Constant.titleCalories && data.total != null && (data.total ?? 0.0) > 0.0){
        await Syncing.createChildActivityCaloriesObservation(data.displayLabel ?? "",
            data,isAppleHealthData: true);
      }

      if(data.title == Constant.titleParent){
        await Syncing.createParentActivityObservation(
            data,isAppleHealthData: true);
      }

      Debug.printLog("getAppleUnSyncActivityLevelData data....${data.title}  ${data.total}  ${data.displayLabel}  ${data.date}   ${data.isSync}");
    }
    // await Syncing.dataSyncingProcess(true);
    Debug.printLog("getAppleUnSyncActivityLevelData length....${activityAppleData.length}");
  }

  getUnSyncActivityLevelData() async {
    List<ActivityTable> activityAppleData = await Syncing.getAndSetSyncActivityLevelDataManual();
    if(activityAppleData.isEmpty){
      return;
    }
    for (var i = 0; i < activityAppleData.length; i++) {
      var data = activityAppleData[i];

      if(data.title == Constant.titleActivityType){
        await Syncing.createChildActivityNameObservation(
            data.displayLabel ?? "",
            data,isAppleHealthData: false);
      }

      if(data.title == null && data.smileyType == null && data.total != null && (data.total ?? 0.0) > 0.0){
        await Syncing.createChildActivityTotalMinObservation(
            data.displayLabel ?? "",
            data,isAppleHealthData: false);
      }

      if(data.title == Constant.titleCalories && (data.total ?? 0.0) > 0.0){
        await Syncing.createChildActivityCaloriesObservation(data.displayLabel ?? "",
            data,isAppleHealthData: false);
      }

      if(data.title == Constant.titleHeartRatePeak && (data.total ?? 0.0) > 0.0){
        await Syncing.createChildActivityPeakHeatRateObservation(data.displayLabel ?? "",
            data,isAppleHealthData: false);
      }

      if(data.title == Constant.titleParent){
        await Syncing.createParentActivityObservation(
            data,isAppleHealthData: false);
      }

      Debug.printLog("getAppleUnSyncActivityLevelData data....${data.title}  ${data.total}  ${data.displayLabel}  ${data.date}   ${data.isSync}");
    }
    // await Syncing.dataSyncingProcess(true);
    Debug.printLog("getAppleUnSyncActivityLevelData length....${activityAppleData.length}");
  }

  double getTableHeight(){
    final BuildContext context = tableKey.currentContext!;
    Debug.printLog("getTableHeight.....${context.size!.height}");
    return context.size!.height;
  }

  onChangePortraitLandscape(orientation){
    if(orientation == Orientation.portrait){
      isPortrait = true;
    }else{
      isPortrait = false;
    }
  }

  /// This is for expand Week, Day and Hide/Show rows
  onChangeExpand(int type){
    if(type == 1){
      isWeekExpanded = !isWeekExpanded;
      onChangeExpandType(0);
      allWeeksWithDayExpand(false);
      if(isWeekExpanded){
        allWeeksExpand(true);
      }else{
        isDayExpanded = false;
        allWeeksExpand(false);
      }
    }else if(type == 2){
      isDayExpanded = !isDayExpanded;
      onChangeExpandType(1);

      if(isDayExpanded){
        allWeeksWithDayExpand(true);
        isWeekExpanded = true;
      }else{
        allWeeksWithDayExpand(false);
      }
    }else if(type == 3){
      isHideRow = !isHideRow;
      var dataListHive = getActivityListData();
      Debug.printLog("datalist $trackingChartDataList");
      if(isHideRow) {
        for (int i = 0; i < trackingChartDataList.length; i++) {
          for (int j = 0; j < trackingChartDataList[i].dayLevelDataList.length; j++) {
            var checkDataList = dataListHive
                .where((element) =>
            element.date == trackingChartDataList[i].dayLevelDataList[j].date)
                .toList();
            if (checkDataList.isEmpty) {
              trackingChartDataList[i].dayLevelDataList[j].isShow = false;
            } else {
              trackingChartDataList[i].dayLevelDataList[j].isShow = true;
            }
          }
        }
      }else{
        for (int i = 0; i < trackingChartDataList.length; i++) {
          for (int j = 0; j < trackingChartDataList[i].dayLevelDataList.length; j++) {
            trackingChartDataList[i].dayLevelDataList[j].isShow = true;
          }
        }
      }
    }
    update();
  }

  /*-1 = none, 0 = W and 1 = D*/
  onChangeExpandType(int type){
    if(selectedExpandType == type){
      selectedExpandType = -1;
      return;
    }
    selectedExpandType = type;
    update();
  }

  /// This is for filter. User can check uncheck rows from the filter dialog
  onChangeTitle(bool value, int index){
    // titlesListData[index].selected = value;
    trackingPrefList[index].isSelected = value;
    Debug.printLog("onChangeTitle.... $value   $index");
  }

  /// This is for filter. User can check uncheck rows from the filter dialog
  onChangeTitleTapOnOk() async {
    var json = jsonEncode(trackingPrefList.map((e) => e.toJson()).toList());
    Preference.shared.setList(Preference.trackingPrefList, json);
    ///Call Api For configuration Data Push
    await Utils.callPushApiForConfigurationActivity();
    Get.back();
    update();
  }


  ///This is for added list in to the filter dialog listed data
  getTitlesData({bool isForceTrue = false}){

    titlesListData.add(RowsDataClass(Constant.calories, Constant.boolCalories));
    titlesListData.add(RowsDataClass(Constant.steps, Constant.boolSteps));
    // titlesListData.add(RowsDataClass(Constant.heartRate, Constant.boolPeakHeartRate));
    titlesListData.add(RowsDataClass(Constant.heartRate, Constant.boolHeartRate));
    titlesListData.add(RowsDataClass(Constant.experience, Constant.boolExperience));
    titlesListData.add(RowsDataClass(Constant.activityMinutesMod, Constant.boolActivityMinMod));
    titlesListData.add(RowsDataClass(Constant.activityMinutesVig, Constant.boolActivityMinVig));
  }

  onExpandWeek(int index,{bool? isWeekExpanded}){
    if(isWeekExpanded == null) {
      trackingChartDataList[index].isExpanded = !trackingChartDataList[index].isExpanded;
      daysStrengthDataList[index].isExpanded = !daysStrengthDataList[index].isExpanded;
      caloriesDataList[index].isExpanded = !caloriesDataList[index].isExpanded;
      stepsDataList[index].isExpanded = !stepsDataList[index].isExpanded;
      heartRateRestDataList[index].isExpanded = !heartRateRestDataList[index].isExpanded;
      heartRatePeakDataList[index].isExpanded = !heartRatePeakDataList[index].isExpanded;
      experienceDataList[index].isExpanded = !experienceDataList[index].isExpanded;
    }else{
      trackingChartDataList[index].isExpanded = isWeekExpanded;
      daysStrengthDataList[index].isExpanded = isWeekExpanded;
      caloriesDataList[index].isExpanded = isWeekExpanded;
      stepsDataList[index].isExpanded = isWeekExpanded;
      heartRateRestDataList[index].isExpanded = isWeekExpanded;
      heartRatePeakDataList[index].isExpanded = isWeekExpanded;
      experienceDataList[index].isExpanded = isWeekExpanded;
    }
    Debug.printLog("Expanded other titles...${daysStrengthDataList[index].isExpanded} ");

    update();
  }

  onExpandDays(int mainIndex,int daysIndex){
    trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].isExpanded =
    !trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].isExpanded;
    var totalExpandableDays = 0;
    for (int i = 0; i < trackingChartDataList.length; i++) {
      totalExpandableDays = totalExpandableDays + trackingChartDataList[i].dayLevelDataList.where((element) => element.isExpanded).toList().length;
    }

    for(int i=0;i<trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList.length;i++){
      updatePopUpMenuList(
          mainIndex,
          daysIndex,
          trackingChartDataList[mainIndex]
              .dayLevelDataList[daysIndex]
              .activityLevelDataList[i]
              .displayLabel);
    }


    daysStrengthDataList[mainIndex].daysListCheckBox[daysIndex].isExpanded =
    !daysStrengthDataList[mainIndex].daysListCheckBox[daysIndex].isExpanded;
    caloriesDataList[mainIndex].daysList[daysIndex].isExpanded = !caloriesDataList[mainIndex].daysList[daysIndex].isExpanded;
    stepsDataList[mainIndex].daysList[daysIndex].isExpanded = !stepsDataList[mainIndex].daysList[daysIndex].isExpanded;
    heartRateRestDataList[mainIndex].daysList[daysIndex].isExpanded = !heartRateRestDataList[mainIndex].daysList[daysIndex].isExpanded;
    heartRatePeakDataList[mainIndex].daysList[daysIndex].isExpanded =
    !heartRatePeakDataList[mainIndex].daysList[daysIndex].isExpanded;
    experienceDataList[mainIndex].daysList[daysIndex].isExpanded =
    !experienceDataList[mainIndex].daysList[daysIndex].isExpanded;
    update();
  }

  var selectedNewDate = DateTime.now();

  getAndSetWeeksData(DateTime selectedDate,{bool isNext = false,bool isTap = false,bool isRefresh = true,
    List<WeekLevelData>? expandedWeeks,bool isFromAPICall = false,bool notShowDialog = true}) async {
    if(isTap) {
      if (isNext) {
        selectedDate = selectedDate.add(const Duration(days: Constant.totalDaysOf5Weeks));
      }else{
        selectedDate = selectedDate.subtract(const Duration(days: 1));
      }
    }
    trackingChartDataList = [];
    daysStrengthDataList = [];
    caloriesDataList = [];
    stepsDataList = [];
    heartRateRestDataList = [];
    heartRatePeakDataList = [];
    experienceDataList = [];

    if(!Constant.isCalledAPI) {
      if(!isTap){
        var allDataFromDB = getActivityListData();
        if (allDataFromDB.isNotEmpty) {
          await Utils.clearTrackingChartData();
        }
      }
    }
    var dataListHive = getActivityListData();

    var dateParseStartPreviousWeek5 = Utils.findFirstDateOfTheWeekImport(selectedDate);
    var dateParseLastTimePreviousWeek5 = Utils.findLastDateOfTheWeekImport(selectedDate);

    var dateParseStartPreviousWeek4 = Utils.findFirstDateOfTheWeekPrevious(dateParseStartPreviousWeek5);
    var dateParseLastTimePreviousWeek4 = Utils.findLastDateOfTheWeekPrevious(dateParseStartPreviousWeek5);

    var dateParseStartPreviousWeek3 = Utils.findFirstDateOfTheWeekPrevious(dateParseStartPreviousWeek4);
    var dateParseLastTimePreviousWeek3 = Utils.findLastDateOfTheWeekPrevious(dateParseStartPreviousWeek4);

    var dateParseStartPreviousWeek2 = Utils.findFirstDateOfTheWeekPrevious(dateParseStartPreviousWeek3);
    var dateParseLastTimePreviousWeek2 = Utils.findLastDateOfTheWeekPrevious(dateParseStartPreviousWeek3);

    var dateParseStartPreviousWeek1 = Utils.findFirstDateOfTheWeekPrevious(dateParseStartPreviousWeek2);
    var dateParseLastTimePreviousWeek1 = Utils.findLastDateOfTheWeekPrevious(dateParseStartPreviousWeek2);

    startDate = DateFormat(Constant.commonDateFormatMmmDdYyyy).format(dateParseStartPreviousWeek1);
    endDate = DateFormat(Constant.commonDateFormatMmmDdYyyy).format(dateParseLastTimePreviousWeek5);


    getWeek1Data(dateParseStartPreviousWeek1,dateParseLastTimePreviousWeek1,dataListHive);
    getWeek2Data(dateParseStartPreviousWeek2,dateParseLastTimePreviousWeek2,dataListHive);
    getWeek3Data(dateParseStartPreviousWeek3,dateParseLastTimePreviousWeek3,dataListHive);
    getWeek4Data(dateParseStartPreviousWeek4,dateParseLastTimePreviousWeek4,dataListHive);
    getWeek5Data(dateParseStartPreviousWeek5,dateParseLastTimePreviousWeek5,dataListHive);


    getWeek1DataOtherTitles(dateParseStartPreviousWeek1,dateParseLastTimePreviousWeek1,dataListHive);
    getWeek2DataOtherTitles(dateParseStartPreviousWeek2,dateParseLastTimePreviousWeek2,dataListHive);
    getWeek3DataOtherTitles(dateParseStartPreviousWeek3,dateParseLastTimePreviousWeek3,dataListHive);
    getWeek4DataOtherTitles(dateParseStartPreviousWeek4,dateParseLastTimePreviousWeek4,dataListHive);
    getWeek5DataOtherTitles(dateParseStartPreviousWeek5,dateParseLastTimePreviousWeek5,dataListHive);

    initAllFocusNodeForTextFormFiled();

    previousDate = dateParseStartPreviousWeek1;
    nextDate = dateParseLastTimePreviousWeek5;


      var currentDateList = trackingChartDataList.indexWhere((element) =>
      element.weekStartDate == dateParseStartPreviousWeek5 &&
          element.weekEndDate == dateParseLastTimePreviousWeek5).toInt();
      if (currentDateList != -1) {
        var selectedDateList = trackingChartDataList[currentDateList];
        var index = selectedDateList.dayLevelDataList.indexWhere((element) =>
        DateFormat(Constant.commonDateFormatDdMmYyyy).format(
            element.storedDate!) ==
            DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedDate)
        ).toInt();
        if (index != -1) {
          if(isRefresh) {
            onExpandWeek(currentDateList);
            onExpandDays(currentDateList, index);
          }else if(expandedWeeks != null && !isRefresh){
            for (var i = 0; i < expandedWeeks.length; i++) {
              onExpandWeek(i,isWeekExpanded: expandedWeeks[i].isExpanded);
            }
            // onExpandDays(0, 5,callFromAPI: true);
            var openedListMain = expandedWeeks.toList();
            if(openedListMain.isNotEmpty){
              for (int i = 0; i < openedListMain.length; i++) {
                if(openedListMain[i].isExpanded){
                  for (int j = 0; j < openedListMain[i].dayLevelDataList.length; j++) {
                    if(openedListMain[i].dayLevelDataList[j].isExpanded) {
                      trackingChartDataList[i].dayLevelDataList[j].isExpanded =
                      true;
                      daysStrengthDataList[i].daysListCheckBox[j].isExpanded =
                      true;
                      caloriesDataList[i].daysList[j].isExpanded = true;
                      stepsDataList[i].daysList[j].isExpanded = true;
                      heartRateRestDataList[i].daysList[j].isExpanded = true;
                      heartRatePeakDataList[i].daysList[j].isExpanded = true;
                      experienceDataList[i].daysList[j].isExpanded = true;
                    }
                  }
                }
              }
            }
          }
        }
      } else {
        onExpandWeek(4);
        onExpandDays(4, 0);
      }



    // getStDataAndSet(false);

    if(!Constant.isCalledAPI) {
     /* var allDataFromDB = getActivityListData();
      if(allDataFromDB.isNotEmpty){
        await Utils.clearTrackingChartData();
      }*/
      /*allDataFromDB = getActivityListData();*/
      update();
      var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != ""
          && element.isSelected).toList();

      if(!isFromAPICall){
        WidgetsBinding.instance.addPostFrameCallback((_) async {

          if(notShowDialog && allSelectedServersUrl.isNotEmpty) {
            update();
            Utils.showDialogForProgress(
                Get.context!, Constant.txtPleaseWait,
                Constant.txtActivityDataProgress);
            update();
          }
        });
        if(!kIsWeb) {
          try {
            // Health health = Health();
            var permissions = ((Platform.isAndroid)
                ? Utils.getAllHealthTypeAndroid
                : Utils.getAllHealthTypeIos)
                .map((e) => HealthDataAccess.READ_WRITE)
                .toList();
            bool? hasPermissions = await Health().hasPermissions(
                (Platform.isAndroid)
                    ? Utils.getAllHealthTypeAndroid
                    : Utils.getAllHealthTypeIos,
                permissions: permissions);
            if (Platform.isIOS) {
              hasPermissions = Utils.getPermissionHealth();
            }
            Debug.printLog(
                "hasPermissions...$hasPermissions  $nextDate  $previousDate");
            if (hasPermissions!) {
              await GetSetHealthData.importDataFromHealth((val) {}, false,
                  needAPICall: false, endDate: nextDate, startDate: previousDate);
            }
            if (allSelectedServersUrl.isEmpty) {
              Constant.isCalledAPI = true;
              getAndSetWeeksData(selectedDate,isRefresh: false,expandedWeeks:
              trackingChartDataList,isFromAPICall: true);
              update();
            }

          } catch (e) {
            Debug.printLog("Delete workout error....$e");
          }
        }
        if (allSelectedServersUrl.isNotEmpty) {
          await activityDataAPICall(
              previousDate, nextDate, isTap, notShowDialog);
          await Syncing.dataSyncingProcess(true);
          await getAndSetValuesForActivityInCal();
          await getAppleUnSyncActivityLevelData();
          await getUnSyncActivityLevelData();
          Get.back();
        }else{
          await getStDataAndSet(false);
          await getAndSetWeeksData(selectedNewDate,isRefresh: false,expandedWeeks: trackingChartDataList,isFromAPICall: true);
        }
      }
      // Constant.isCalledAPI = true;
    }
    update();
  }



  getAndSetValuesForActivityInCal() async {
    List<DateTime> dataList = Utils.generateDateList(caloriesDataList[0].weekStartDate ?? DateTime.now(),caloriesDataList[4].weekEndDate ?? DateTime.now());
    for(int i= 0;i<dataList.length;i++){
      List<ActivityTable> activityData = getActivityListData().where((element) => element.title == Constant.titleCalories && Utils.convertDateTimeFormat(element.dateTime ?? DateTime.now()) == Utils.convertDateTimeFormat(dataList[i])).toList();

      if(activityData.isNotEmpty){
        List<ActivityTable> activityDay =  activityData.where((element) => element.type == Constant.typeDay).toList();
        List<ActivityTable> activityDayData =  activityData.where((element) => element.type == Constant.typeDaysData).toList();

        if(activityDay.isNotEmpty &&  activityDayData.isNotEmpty){
          int activityTotal = activityDayData.fold(0, (previousValue, element) => previousValue + (element.total ?? 0.0).toInt());
          Debug.printLog("Day level calories....${activityTotal.toDouble()} ${activityDay[0].total}");
          if((activityDay[0].total ?? 0.0).toInt() !=   activityTotal &&  activityDay[0].isOverride == false && activityTotal > 0){
            activityDay[0].total = activityTotal.toDouble();
            activityDay[0].isOverride = false;
            await DataBaseHelper.shared.updateActivityData(activityDay[0]);

            String formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findFirstDateOfTheWeek(Utils.convertDateTimeFormat(activityDay[0].dateTime ?? DateTime.now())));
            String formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findLastDateOfTheWeek(Utils.convertDateTimeFormat(activityDay[0].dateTime ?? DateTime.now())));


            List<DateTime>  dateList =  Utils.getDaysInBetween(Utils.findFirstDateOfTheWeek(activityDay[0].dateTime ?? DateTime.now()),Utils.findLastDateOfTheWeek(activityDay[0].dateTime ?? DateTime.now()));

            int value = 0;

            var a = getActivityListData().where((element) =>
            dateList.where((elementDate) =>
            Utils.getDateFromFullDate(elementDate ?? DateTime.now())
                == Utils.getDateFromFullDate(element.dateTime ?? DateTime.now()))
                .toList()
                .isNotEmpty && element.type == Constant.typeDay && element.title == Constant.titleCalories).toList();

            value = a.fold(0, (previousValue, element) => previousValue + (element.total ?? 0.0).toInt());

            List<ActivityTable> weekInsertedData = getActivityListData().where((element) =>
            element.weeksDate == "$formattedDateStart-$formattedDateEnd" &&
                element.type == Constant.typeWeek && element.title == Constant.titleCalories).toList();


              if(weekInsertedData.isNotEmpty) {
                if (value == "" || value == "0" || value == 0) {
                  weekInsertedData[0].total = null;
                } else {
                  weekInsertedData[0].total = double.parse(value.toString());
                }
                weekInsertedData[0].isSync = false;
                await DataBaseHelper.shared.updateActivityData(weekInsertedData[0]);
              }


            var dataModel = SyncMonthlyActivityData(
                "",
                activityTotal.toDouble() ?? 0,
                Utils.changeDateFormatBasedOnDBDateWithOutTIme(
                    activityDay[0].dateTime ?? DateTime.now()),
                null,
                activityDay[0].key,
                Constant.titleCalories,
                true,
                activityDay[0].objectId);
            Debug.printLog("datalist.....${dataModel}");
            await Syncing.observationSyncDataCalories([dataModel]);


          }
        }



      }

      List<ActivityTable> activityDataMin = getActivityListData().where((element) => element.title == null &&  element.smileyType == null && element.total != null && Utils.convertDateTimeFormat(element.dateTime ?? DateTime.now()) == Utils.convertDateTimeFormat(dataList[i])).toList();

      if(activityDataMin.isNotEmpty){
        List<ActivityTable> activityDayMin =  activityDataMin.where((element) => element.type == Constant.typeDay).toList();
        List<ActivityTable> activityDayDataMIn =  activityDataMin.where((element) => element.type == Constant.typeDaysData).toList();

        if(activityDataMin.isNotEmpty &&  activityDayDataMIn.isNotEmpty){
          int activityTotal = activityDayDataMIn.fold(0, (previousValue, element) => previousValue + (element.total ?? 0.0).toInt());
          Debug.printLog("Day level min....${activityTotal.toDouble()} ${activityDayMin[0].total}");
          if((activityDayMin[0].total ?? 0.0).toInt() !=   activityTotal &&  activityDayMin[0].isOverride == false && activityTotal > 0){
            activityDayMin[0].total = activityTotal.toDouble();
            activityDayMin[0].isOverride = false;
            await DataBaseHelper.shared.updateActivityData(activityDayMin[0]);

            String formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findFirstDateOfTheWeek(Utils.convertDateTimeFormat(activityDayMin[0].dateTime ?? DateTime.now())));
            String formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findLastDateOfTheWeek(Utils.convertDateTimeFormat(activityDayMin[0].dateTime ?? DateTime.now())));


            List<DateTime>  dateList =  Utils.getDaysInBetween(Utils.findFirstDateOfTheWeek(activityDayMin[0].dateTime ?? DateTime.now()),Utils.findLastDateOfTheWeek(activityDayMin[0].dateTime ?? DateTime.now()));

            int value = 0;

            var a = getActivityListData().where((element) =>
            dateList.where((elementDate) =>
            Utils.getDateFromFullDate(elementDate ?? DateTime.now())
                == Utils.getDateFromFullDate(element.dateTime ?? DateTime.now()))
                .toList()
                .isNotEmpty && element.type == Constant.typeDay && element.title == null &&  element.smileyType == null && element.total != null ).toList();


            value = a.fold(0, (previousValue, element) => previousValue + (element.total ?? 0.0).toInt());

            List<ActivityTable> weekInsertedData = getActivityListData().where((element) =>
            element.weeksDate == "$formattedDateStart-$formattedDateEnd" &&
                element.type == Constant.typeWeek && element.title == null && element.smileyType == null && element.total != null ).toList();


            if(weekInsertedData.isNotEmpty) {
              if (value == "" || value == "0" || value == 0) {
                weekInsertedData[0].total = null;
              } else {
                weekInsertedData[0].total = double.parse(value.toString());
              }
              weekInsertedData[0].isSync = false;
              await DataBaseHelper.shared.updateActivityData(weekInsertedData[0]);
            }

            var dataModel = SyncMonthlyActivityData(
                "",
                activityTotal.toDouble() ?? 0,
                Utils.changeDateFormatBasedOnDBDateWithOutTIme(
                    activityDayMin[0].dateTime ?? DateTime.now()),
                null,
                activityDayMin[0].key,
                Constant.totalMinPerDay,
                true,
                activityDayMin[0].objectId);
            Debug.printLog("datalist.....${dataModel}");
            await Syncing.observationSyncDataTotalMin([dataModel]);
          }
        }



      }


    }
    await getAndSetWeeksData(selectedNewDate,isRefresh: false,expandedWeeks: trackingChartDataList,isFromAPICall: true);

    Debug.printLog("Helo");
  }

  getStDataAndSet(bool isApiCall) async {
    List<ActivityTable> activityData = getActivityListData().where((element) => ((element.displayLabel ?? "").toLowerCase().contains(Constant.strengthActivity.toLowerCase())) && element.title == Constant.titleDaysStr).toList();
    Debug.printLog("activityData.....$activityData");
    for(int i = 0 ; i < activityData.length ;i++ ){
      var data = activityData[i];
      List<ActivityTable> dayLevelData = getActivityListData().where((element) => element.type == Constant.typeDay && (element.isCheckedDay == false || element.isCheckedDay == null)
          && element.title == Constant.titleDaysStr && Utils.getDateFromFullDate(DateTime.parse(element.date.toString()) ?? DateTime.now()) ==
          Utils.getDateFromFullDate(DateTime.parse(data.date.toString()) ?? DateTime.now())).toList();
      if(dayLevelData.isEmpty){
        ///Consider = Need to create new data in hive and sever
        await onDaysStrengthCheckBoxDay(data.dateTime ?? DateTime.now(),true,);
      }else{
        if(data.isCheckedDay == false) {
          await onDaysStrengthCheckBoxDay(data.dateTime ?? DateTime.now(), false,);
        }
      }
      Debug.printLog("dayLevelData.....$dayLevelData");
    }
  }

  Future<void> onDaysStrengthCheckBoxDay(DateTime date,bool needToInsetInLocal) async {

    if(needToInsetInLocal) {
      var dayInsertedDataCheckBox = getActivityListData()
          .where((element) =>
      Utils.getDateFromFullDate(element.dateTime ?? DateTime.now()) ==
          Utils.getDateFromFullDate(date ?? DateTime.now()) &&
          element.type == Constant.typeDay &&
          element.title == Constant.titleDaysStr)
          .toList();
      if (dayInsertedDataCheckBox.isEmpty) {
        var insertCheckBoxDayData = ActivityTable();
        insertCheckBoxDayData.title = Constant.titleDaysStr;
        insertCheckBoxDayData.dateTime = date;
        insertCheckBoxDayData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(date);
        insertCheckBoxDayData.type = Constant.typeDay;
        insertCheckBoxDayData.total = 1;
        String formattedDateStart =
        DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findFirstDateOfTheWeekImport(date));
        String formattedDateEnd =
        DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findLastDateOfTheWeekImport(date));
        insertCheckBoxDayData.weeksDate =
        "$formattedDateStart-$formattedDateEnd";
        insertCheckBoxDayData.isCheckedDay = true;
        insertCheckBoxDayData.isSync = false;

        var connectedServerUrl = Utils.getServerListPreference().where((
            element) =>
        element.patientId != ""
            && element.isSelected).toList();
        if (connectedServerUrl.isNotEmpty) {
          for (int i = 0; i < connectedServerUrl.length; i++) {
            var data = ServerDetailDataTable();
            data.dataSyncServerWise = false;
            data.objectId = "";
            data.serverUrl = connectedServerUrl[i].url;
            data.patientId = connectedServerUrl[i].patientId;
            data.clientId = connectedServerUrl[i].clientId;
            data.serverToken = connectedServerUrl[i].authToken;
            data.patientName =
            "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
                .patientLName}";
            insertCheckBoxDayData.serverDetailList.add(data);
          }
        }

        await DataBaseHelper.shared.insertActivityData(insertCheckBoxDayData);
      }
      else {
        if (dayInsertedDataCheckBox.isNotEmpty) {
          dayInsertedDataCheckBox[0].title = Constant.titleDaysStr;
          dayInsertedDataCheckBox[0].isCheckedDay = true;
          dayInsertedDataCheckBox[0].total = 1;
          dayInsertedDataCheckBox[0].date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(date);
          var allSelectedServersUrl = Utils.getServerListPreference().where((
              element) => element.patientId != "" && element.isSelected)
              .toList();
          if (dayInsertedDataCheckBox[0].serverDetailList.length !=
              allSelectedServersUrl.length) {
            for (int i = 0; i < allSelectedServersUrl.length; i++) {
              var url = dayInsertedDataCheckBox[0].serverDetailList;
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
                dayInsertedDataCheckBox[0].serverDetailList.add(
                    serverDetail);
              }
            }
          }

          await DataBaseHelper.shared.updateActivityData(
              dayInsertedDataCheckBox[0]);
        }
      }
    }




    String formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findFirstDateOfTheWeek(date));
    String formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findLastDateOfTheWeek(date));

    List<DateTime>  dateList =  Utils.getDaysInBetween(Utils.findFirstDateOfTheWeek(date),Utils.findLastDateOfTheWeek(date));

    int totalSelectedBox = 0;

    var a = getActivityListData().where((element) =>
    dateList.where((elementDate) =>
    Utils.getDateFromFullDate(elementDate ?? DateTime.now())
        == Utils.getDateFromFullDate(element.dateTime ?? DateTime.now()))
        .toList()
        .isNotEmpty && element.type == Constant.typeDay && element.title == Constant.titleDaysStr).toList();

    totalSelectedBox = a.where((element) => element.isCheckedDay == true).toList().length;
   /* for (int i = 0; i < dateList.length; i++) {
      int totalSelectedBoxlength = getActivityListData().where((element) =>
      Utils.changeDateFormatBasedOnDBDateWithOutTIme(
          element.dateTime ?? DateTime.now())
          == Utils.changeDateFormatBasedOnDBDateWithOutTIme(
          dateList[i] ?? DateTime.now()) && element.type == Constant.typeDay
          && element.isCheckedDay == true
      )
          .toList()
          .length;
      totalSelectedBox += totalSelectedBoxlength;
    }*/
    if(totalSelectedBox > 0){
    var weekInsertedData = getActivityListData()
        .where((element) =>
    element.weeksDate == "$formattedDateStart-$formattedDateEnd" &&
        element.type == Constant.typeWeek && element.title == Constant.titleDaysStr)
        .toList();
    if(weekInsertedData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.name = "";
      insertingData.date = DateTime.now().toString();
      insertingData.title = Constant.titleDaysStr;
      insertingData.total = totalSelectedBox.toDouble();
      insertingData.type = Constant.typeWeek;
      insertingData.dateTime = date;
      String formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy).format(
          Utils.findFirstDateOfTheWeek(date));
      String formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findLastDateOfTheWeek(date));
      insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";
      var id = await DataBaseHelper.shared.insertActivityData(insertingData);
      Debug.printLog("onChangeCheckBoxDays if......$id");
    }
    else{
      if(weekInsertedData.isNotEmpty){
        weekInsertedData[0].total = totalSelectedBox.toDouble();
        await DataBaseHelper.shared.updateActivityData(weekInsertedData[0]);
      }
    }
    }
    
    ///Update count of checkbox in monthly summary
    try {
      var dayLevelDataList = getActivityListData()
          .where((elementMain) =>
      elementMain.type == Constant.typeDay &&
          elementMain.dateTime!.month ==
              date!.month &&
          elementMain.title == Constant.titleDaysStr && elementMain.isCheckedDay != null && elementMain.isCheckedDay == true).toList();

      var monthlyDataDbList = getMonthlyDataList();
      var foundedList = monthlyDataDbList.where((element) => element.monthName == Utils.getMonthName(date!.month,
          date!.year)
          && element.year == date!.year).toList();

      if (foundedList.isNotEmpty) {
        ///Update
        foundedList[0].isOverrideStrength = false;

        if(foundedList[0].strengthValue != double.parse((dayLevelDataList.length / 5).round().toStringAsFixed(2))){
          foundedList[0].isSyncStrength = false;
        }
        if (dayLevelDataList.isEmpty) {
          foundedList[0].strengthValue = null;
        } else {
          foundedList[0].strengthValue  = double.parse((dayLevelDataList.length / 5).round().toStringAsFixed(2));
        }
        var allSelectedServersUrl = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected).toList();
        if (foundedList[0].serverDetailListStrength.length !=
            allSelectedServersUrl.length) {
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = foundedList[0].serverDetailListStrength;
            if (url
                .where((element) =>
            element.serverUrl == allSelectedServersUrl[i].url)
                .toList()
                .isEmpty) {
              var data = ServerDetailDataTable();
              data.serverUrl = allSelectedServersUrl[i].url;
              data.patientId = allSelectedServersUrl[i].patientId;
              data.objectId = "";
              data.patientName = "${allSelectedServersUrl[i]
                  .patientFName}${allSelectedServersUrl[i].patientLName}";
              foundedList[0].serverDetailListStrength.add(data);
            }
          }
        }
        await DataBaseHelper.shared.updateMonthlyData(foundedList[0]);
      }
      else{
        var newMonthlyData = MonthlyLogTableData();
        var dateSelected = date;
        newMonthlyData.monthName = Utils.getMonthName(dateSelected!.month,
            dateSelected.year);
        newMonthlyData.year = dateSelected.year;
        newMonthlyData.isOverrideDayPerWeek = false;
        newMonthlyData.isOverrideAvgMin = false;
        newMonthlyData.isOverrideAvgMinPerWeek = false;
        newMonthlyData.isOverrideStrength = false;
        newMonthlyData.startDate = Utils.getMonthStartDate(dateSelected);
        newMonthlyData.endDate = Utils.getMonthEndDate(dateSelected);


        if (dayLevelDataList.isEmpty) {
          newMonthlyData.strengthValue = null;
        } else {
          newMonthlyData.strengthValue = double.parse((dayLevelDataList.length / 5).round().toStringAsFixed(2));
        }

        newMonthlyData.isSyncStrength = false;
        var connectedServerUrl = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected).toList();

        if (connectedServerUrl.isNotEmpty) {
          for (int i = 0; i < connectedServerUrl.length; i++) {
            var data = ServerDetailDataTable();
            data.serverUrl = connectedServerUrl[i].url;
            data.patientId = connectedServerUrl[i].patientId;
            data.clientId = connectedServerUrl[i].clientId;
            data.objectId = "";
            data.serverToken = connectedServerUrl[i].authToken;
            data.patientName =
            "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
                .patientLName}";
            newMonthlyData.serverDetailListStrength.add(data);
          }
        }

        await DataBaseHelper.shared.insertMonthlyData(newMonthlyData);
      }

      var startDateOfMonth = Utils.getMonthStartDate(date ?? DateTime.now());
      var endDateOfMonth = Utils.getMonthEndDate(date ?? DateTime.now());
      var getCurrentMonthDataStrength = getMonthlyDataList()
          .where((element) =>
      Utils.getDateFromFullDate(element.startDate ?? DateTime.now()) ==
          Utils.getDateFromFullDate(startDateOfMonth ?? DateTime.now()) &&
          Utils.getDateFromFullDate(element.endDate ?? DateTime.now()) ==
              Utils.getDateFromFullDate(endDateOfMonth ?? DateTime.now()))
          .toList();

      var isSyncStrength = false;
      if (getCurrentMonthDataStrength.isNotEmpty) {
        isSyncStrength = getCurrentMonthDataStrength[0].isSyncStrength;
      }
      if(Utils.getServerListPreference().isNotEmpty) {
        if (!isSyncStrength) {

          var indexOfAvgValueOfMonth =  Utils.allYearlyMonths.indexWhere((element) =>
          element.name == Utils.getMonthName(startDateOfMonth.month, startDateOfMonth.year)
          ).toInt();

          if (indexOfAvgValueOfMonth != -1) {
            List<SyncMonthlyActivityData> allSyncingData = [];
            await Syncing.syncMonthlyDataStrength(
                getMonthlyDataList(), allSyncingData, indexOfAvgValueOfMonth,
                isFromRefresh: false,
                startDate: startDateOfMonth,
                endDate: endDateOfMonth);
            await Syncing.observationSyncDataStrengthDaysPerWeek(allSyncingData);
            Debug.printLog("isSyncStrength...$indexOfAvgValueOfMonth  $allSyncingData");
          }
        }
      }

    } catch (e) {
      Debug.printLog(e.toString());
    }

    if(Utils.getServerListPreference().isNotEmpty){
      var allDataFromDBNew = getActivityListData();
      var checkBoxData = allDataFromDBNew.where((element) =>
      element.title == Constant.titleDaysStr && !element.isSync &&
          element.type == Constant.typeDay && Utils.changeDateFormatBasedOnDBDateWithOutTIme(
          element.dateTime ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDateWithOutTIme(
          date ?? DateTime.now()
      ) ).toList();
      if(checkBoxData.isNotEmpty){
        List<SyncMonthlyActivityData> checkBoxDataList = [];
        var checkBox = 1.0;
        checkBoxDataList.add(SyncMonthlyActivityData(
            "",
            checkBox,
            Utils.changeDateFormatBasedOnDBDateWithOutTIme(
                checkBoxData[0].dateTime ?? DateTime.now()),
            null,
            checkBoxData[0].key,
            Constant.titleDaysStr,
            true,
            checkBoxData[0].objectId));
        // if( checkBoxData[0].isCheckedDay == false ||  checkBoxData[0].isCheckedDay == null) {
          await Syncing.observationSyncDataStrengthBox(checkBoxDataList);
        // }
      }
    }

    update();
  }

  void showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: const Text('It requires some time to synchronize.'),
      duration: const Duration(days: 1),
      backgroundColor: CColor.primaryColor,
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'Dismiss',
        disabledTextColor: Colors.white,
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  activityDataAPICall(DateTime startAfterDate,DateTime beforeEndDate, bool isTap,bool isNotShowDialog,) async {
    int year = 0;
    Debug.printLog("activityDataAPICall....$startAfterDate  $beforeEndDate");
      year = previousDate.year;
      var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();

      if(allSelectedServersUrl.isNotEmpty) {
        bool isMonth = Hive.box<MonthlyLogTableData>(Constant.tableMonthlyLog).values.toList().where((element) => element.patientId == Utils.getPatientId()).toList().isEmpty;
        await Future.delayed(const Duration(milliseconds: 500));
        await Utils.isExpireTokenAPICall(Constant.screenTypeHistory,(value) async {
          if(!value){
            await Utils.setMonthlyAndActivityData(year.toString(),
                isFromMonth: isMonth,isFromActivity: true,startAfterDate: startAfterDate,beforeEndDate:beforeEndDate);
            Get.back();
          }
        }).then((value) async {
          Debug.printLog("isExpireTokenAPICall....$value");
          if (!value) {
            await Utils.setMonthlyAndActivityData(year.toString(),
                isFromMonth: isMonth,isFromActivity: true,startAfterDate: startAfterDate,beforeEndDate:beforeEndDate);
            Get.back();
          }
        });
      }

    if(isTap){
      selectedNewDate = nextDate;
    }
    await getStDataAndSet(true);
    await getAndSetWeeksData(selectedNewDate,isRefresh: false,expandedWeeks: trackingChartDataList,isFromAPICall: true);
    // await getAppleUnSyncActivityLevelData();
    update();
  }

  void onSelectionChangedDatePicker(DateRangePickerSelectionChangedArgs args) {
    Debug.printLog("onSelectionChangedDatePicker....${args.value}");
    selectedNewDate = args.value;
    update();
  }

  allWeeksExpand(bool value){
    for (int i = 0; i < trackingChartDataList.length; i++) {
      trackingChartDataList[i].isExpanded = value;
      for (int j = 0; j < trackingChartDataList[i].dayLevelDataList.length; j++) {
        trackingChartDataList[i].dayLevelDataList[j].isExpanded = false;
      }
    }


    for (int j = 0; j < daysStrengthDataList.length; j++) {
      daysStrengthDataList[j].isExpanded = value;
    }

    for (int j = 0; j < caloriesDataList.length; j++) {
      caloriesDataList[j].isExpanded = value;
    }

    for (int j = 0; j < stepsDataList.length; j++) {
      stepsDataList[j].isExpanded = value;
    }

    for (int j = 0; j < heartRateRestDataList.length; j++) {
      heartRateRestDataList[j].isExpanded = value;
    }

    for (int j = 0; j < heartRatePeakDataList.length; j++) {
      heartRatePeakDataList[j].isExpanded = value;
    }

    for (int j = 0; j < experienceDataList.length; j++) {
      experienceDataList[j].isExpanded = value;
    }

    update();
  }

  allWeeksWithDayExpand(var value) {
    for (int i = 0; i < trackingChartDataList.length; i++) {
      if (value) {
        trackingChartDataList[i].isExpanded = value;
      }
      for (int j = 0; j < trackingChartDataList[i].dayLevelDataList.length; j++) {
        trackingChartDataList[i].dayLevelDataList[j].isExpanded = value;
      }
    }

    for (int j = 0; j < daysStrengthDataList.length; j++) {
      if (value) {
        daysStrengthDataList[j].isExpanded = value;
      }
      for (int a = 0;
      a < daysStrengthDataList[j].daysListCheckBox.length;
      a++) {
        daysStrengthDataList[j].daysListCheckBox[a].isExpanded = value;
      }
    }

    for (int j = 0; j < caloriesDataList.length; j++) {
      if (value) {
        caloriesDataList[j].isExpanded = value;
      }
      for (int a = 0; a < caloriesDataList[j].daysList.length; a++) {
        caloriesDataList[j].daysList[a].isExpanded = value;
      }
    }

    for (int j = 0; j < stepsDataList.length; j++) {
      if (value) {
        stepsDataList[j].isExpanded = value;
      }
      for (int a = 0; a < stepsDataList[j].daysList.length; a++) {
        stepsDataList[j].daysList[a].isExpanded = value;
      }
    }

    for (int j = 0; j < heartRateRestDataList.length; j++) {
      if (value) {
        heartRateRestDataList[j].isExpanded = value;
      }
      for (int a = 0; a < heartRateRestDataList[j].daysList.length; a++) {
        heartRateRestDataList[j].daysList[a].isExpanded = value;
      }
    }

    for (int j = 0; j < heartRatePeakDataList.length; j++) {
      if (value) {
        heartRatePeakDataList[j].isExpanded = value;
      }
      for (int a = 0; a < heartRatePeakDataList[j].daysList.length; a++) {
        heartRatePeakDataList[j].daysList[a].isExpanded = value;
      }
    }

    for (int j = 0; j < experienceDataList.length; j++) {
      if (value) {
        experienceDataList[j].isExpanded = value;
      }
      for (int a = 0; a < experienceDataList[j].daysList.length; a++) {
        experienceDataList[j].daysList[a].isExpanded = value;
      }
    }

    update();
  }

  updateData(DateTime selectedDate){
    Constant.isCalledAPI = false;
    getAndSetWeeksData(selectedDate);
    update();
    trackingChartDataList[4].isExpanded = !trackingChartDataList[4].isExpanded;

    // otherTitle2Data[4].isExpanded = !otherTitle2Data[4].isExpanded;
    daysStrengthDataList[4].isExpanded = !daysStrengthDataList[4].isExpanded;
    caloriesDataList[4].isExpanded = !caloriesDataList[4].isExpanded;
    stepsDataList[4].isExpanded = !stepsDataList[4].isExpanded;
    heartRateRestDataList[4].isExpanded = !heartRateRestDataList[4].isExpanded;
    heartRatePeakDataList[4].isExpanded = !heartRatePeakDataList[4].isExpanded;
    experienceDataList[4].isExpanded = !experienceDataList[4].isExpanded;
    update();

    Get.back();
  }

  /*This is for weeks */
  void onChangeActivityMinModWeek(int index,dynamic value,{bool isFromDialog = false,bool isManualChanges = false}) async {
    if(value == ""){
      trackingChartDataList[index].modMinValue = 0;
      trackingChartDataList[index].modMinController.text = "";
    }else {
      trackingChartDataList[index].modMinValue = int.parse(value);
      trackingChartDataList[index].modMinController.text = value;
    }

    trackingChartDataList[index].modMinController.selection =
        TextSelection.fromPosition(TextPosition(offset: value.length));
    trackingChartDataList[index].totalMinController.text = (trackingChartDataList[index].modMinValue + trackingChartDataList[index].vigMinValue).toString();
    trackingChartDataList[index].totalMinValue = trackingChartDataList[index].modMinValue + trackingChartDataList[index].vigMinValue;
    insertUpdateWeekData(index,isManualChanges: isManualChanges);
    update();
  }
  void onChangeActivityMinVigWeek(int index,dynamic value,{bool isFromDialog = false
  ,bool isManualChanges = false}) {
    if(value == ""){
      trackingChartDataList[index].vigMinValue = 0;
      trackingChartDataList[index].vigMinController.text = "";
    }else {
      trackingChartDataList[index].vigMinValue = int.parse(value);
      trackingChartDataList[index].vigMinController.text = value;
    }

    trackingChartDataList[index].vigMinController.selection =
        TextSelection.fromPosition(TextPosition(offset: value.length));
    trackingChartDataList[index].totalMinController.text = (trackingChartDataList[index].modMinValue + trackingChartDataList[index].vigMinValue).toString();
    trackingChartDataList[index].totalMinValue = trackingChartDataList[index].modMinValue + trackingChartDataList[index].vigMinValue;
    insertUpdateWeekData(index,isManualChanges: isManualChanges);
    update();
  }
  Future<void> onChangeActivityMinTotalWeek(int index,dynamic value,{bool isFromDialog = false,bool isManualChanges = false}) async {
    if(value == ""){
      trackingChartDataList[index].totalMinValue = 0;
    }else{
      trackingChartDataList[index].totalMinValue = int.parse(value);
    }

    trackingChartDataList[index].totalMinController.text = (value == "")?"":value.toString();
    trackingChartDataList[index].totalMinController.selection =
        TextSelection.fromPosition(TextPosition(offset: value.length));
    var monthlyDataDbList = Hive
        .box<MonthlyLogTableData>(Constant.tableMonthlyLog)
        .values
        .toList();

    var fondedList = monthlyDataDbList.where((element) => element.monthName ==
    DateFormat(Constant.commonDateFormatMMM).format(trackingChartDataList[index].weekStartDate!)
    && element.year == trackingChartDataList[index].weekStartDate!.year).toList();

    var weekEndFoundedList = monthlyDataDbList.where((element) => element.monthName ==
        DateFormat(Constant.commonDateFormatMMM).format(trackingChartDataList[index].weekEndDate!)
        && element.year == trackingChartDataList[index].weekEndDate!.year).toList();

    if(weekEndFoundedList.isNotEmpty){
      fondedList.addAll(weekEndFoundedList);
    }

    if(fondedList.isNotEmpty && !isFromDialog){
      var isOverrideDayPerWeek  = false;
      var isOverrideAvgMin = false;
      var isOverrideAvgMinPerWeek = false;
      var isOverrideStrength = false;


      if(fondedList.length > 1){
        isOverrideDayPerWeek = fondedList.where((element) => element.isOverrideDayPerWeek).toList().isNotEmpty;
        isOverrideAvgMin = fondedList.where((element) => element.isOverrideAvgMin).toList().isNotEmpty;
        isOverrideAvgMinPerWeek = fondedList.where((element) => element.isOverrideAvgMinPerWeek).toList().isNotEmpty;
        isOverrideStrength = fondedList.where((element) => element.isOverrideStrength).toList().isNotEmpty;
      }else if(fondedList.length == 1){
        isOverrideDayPerWeek = fondedList[0].isOverrideDayPerWeek;
        isOverrideAvgMin = fondedList[0].isOverrideAvgMin;
        isOverrideAvgMinPerWeek = fondedList[0].isOverrideAvgMinPerWeek;
        isOverrideStrength = fondedList[0].isOverrideStrength;
      }


      if (isOverrideDayPerWeek ||
          isOverrideAvgMin ||
          isOverrideAvgMinPerWeek ||
          isOverrideStrength) {
        if(!(Preference.shared.getBool(Preference.isAutoCalMode) ?? false)) {
          await showAlertDialogForOverrideData(
              Constant.typeWeek, fondedList, index, -1, value, -1,);
        }else{
          if(fondedList.length == 1) {
            fondedList[0].dayPerWeekValue = null;
            fondedList[0].avgMinValue = null;
            fondedList[0].avgMInPerWeekValue = null;
            fondedList[0].strengthValue = null;

            fondedList[0].isOverrideDayPerWeek = false;
            fondedList[0].isOverrideAvgMin = false;
            fondedList[0].isOverrideAvgMinPerWeek = false;
            fondedList[0].isOverrideStrength = false;
            // await DataBaseHelper.shared.updateMonthlyData(fondedList[0]);
          }
          else{
            for (int i = 0; i < fondedList.length; i++) {

              fondedList[i].dayPerWeekValue = null;
              fondedList[i].avgMinValue = null;
              fondedList[i].avgMInPerWeekValue = null;
              fondedList[i].strengthValue = null;

              fondedList[i].isOverrideDayPerWeek = false;
              fondedList[i].isOverrideAvgMin = false;
              fondedList[i].isOverrideAvgMinPerWeek = false;
              fondedList[i].isOverrideStrength = false;

              // await DataBaseHelper.shared.updateMonthlyData(fondedList[i]);
            }
          }
          // await DataBaseHelper.shared.updateMonthlyData(fondedList[0]);
          insertUpdateWeekData(index,isFromDialog: true,isManualChanges: isManualChanges);
        }
      }else{
        insertUpdateWeekData(index,isManualChanges: isManualChanges);
      }
    }
    else{
      insertUpdateWeekData(index,isManualChanges: isManualChanges);
    }
    update();
  }

  Future<void> showAlertDialogForOverrideData(int type ,List<MonthlyLogTableData> fondedList, int mainIndex,
      int daysIndex,value ,int daysDataIndex,{bool isDaysStr = false}) async {

      // set up the button
      Widget okButton = TextButton(
        child:  Text(Constant.popupStuffManual,style: TextStyle(
            // fontSize: (kIsWeb) ? 3.sp : FontSize.size_10
        ),),
        onPressed: () async {
          if(fondedList.length == 1) {
            fondedList[0].isOverrideDayPerWeek = true;
            fondedList[0].isOverrideAvgMin = true;
            fondedList[0].isOverrideAvgMinPerWeek = true;
            fondedList[0].isOverrideStrength = true;
            // await DataBaseHelper.shared.updateMonthlyData(fondedList[0]);
          }
          else{
            for (int i = 0; i < fondedList.length; i++) {
              fondedList[i].isOverrideDayPerWeek = true;
              fondedList[i].isOverrideAvgMin = true;
              fondedList[i].isOverrideAvgMinPerWeek = true;
              fondedList[i].isOverrideStrength = true;
              // await DataBaseHelper.shared.updateMonthlyData(fondedList[i]);
            }
        }

          if(isDaysStr){
            insertUpdateAfterOverrideDaysStr(value,mainIndex);
          }else{
            if(type == Constant.typeWeek) {
              insertUpdateWeekData(mainIndex,isFromDialog: true);
            }else if(type == Constant.typeDay) {
              activityMinDayLevelInsertUpdateData(mainIndex,daysIndex,value,false,Constant.totalMinPerDay,isFromDialog: true);
            }else if(type == Constant.typeDaysData) {
              activityMinDayDataLevelInsertUpdateData(mainIndex,daysIndex,daysDataIndex,value,isFromDialog: true);
            }
          }

          Get.back();
        },
      );

      Widget overrideButton = TextButton(
        child:  Text(Constant.popupStuffReCalculate,style: TextStyle(
            // fontSize: (kIsWeb) ? 3.sp : FontSize.size_10
        ),),
        onPressed: () async {
          if(fondedList.length == 1) {
            fondedList[0].dayPerWeekValue = null;
            fondedList[0].avgMinValue = null;
            fondedList[0].avgMInPerWeekValue = null;
            fondedList[0].strengthValue = null;

            fondedList[0].isOverrideDayPerWeek = false;
            fondedList[0].isOverrideAvgMin = false;
            fondedList[0].isOverrideAvgMinPerWeek = false;
            fondedList[0].isOverrideStrength = false;

            // await DataBaseHelper.shared.updateMonthlyData(fondedList[0]);
          }
          else{
            for (int i = 0; i < fondedList.length; i++) {

              fondedList[i].dayPerWeekValue = null;
              fondedList[i].avgMinValue = null;
              fondedList[i].avgMInPerWeekValue = null;
              fondedList[i].strengthValue = null;

              fondedList[i].isOverrideDayPerWeek = false;
              fondedList[i].isOverrideAvgMin = false;
              fondedList[i].isOverrideAvgMinPerWeek = false;
              fondedList[i].isOverrideStrength = false;

              // await DataBaseHelper.shared.updateMonthlyData(fondedList[i]);
            }
          }

          // await DataBaseHelper.shared.updateMonthlyData(fondedList[0]);
          if(isDaysStr){
            insertUpdateAfterOverrideDaysStr(value,mainIndex);
          }
          else {
            if (type == Constant.typeWeek) {
              insertUpdateWeekData(mainIndex, isFromDialog: true);
            } else if (type == Constant.typeDay) {
              activityMinDayLevelInsertUpdateData(
                  mainIndex, daysIndex, value, false,Constant.totalMinPerDay,isFromDialog: true);
            } else if (type == Constant.typeDaysData) {
              activityMinDayDataLevelInsertUpdateData(
                  mainIndex, daysIndex, daysDataIndex, value,
                  isFromDialog: true);
            }
          }
          Get.back();
        },
      );

      Widget autoCalculateButton = TextButton(
        child:  Text(Constant.popupStuffAutoCalculate,style: TextStyle(
            // fontSize: (kIsWeb) ? 3.sp : FontSize.size_10
        ),),
        onPressed: () async {
          Get.back();
          showAlertDialogAutoCalculate( type ,[],fondedList,  mainIndex,
               daysIndex,value , daysDataIndex,true);

        },
      );

    Widget cancelButton = TextButton(onPressed: () {
      Get.back();
    }, child: Text(Constant.popupStuffCancel,style: TextStyle(
        // fontSize: (kIsWeb) ? 3.sp :  FontSize.size_10
    ),));

    // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        content:  Text("There are manual values for ${(daysDataIndex != 0 && daysIndex != 0 && mainIndex != 0 ) ?"Daily":(daysDataIndex == -1 && daysIndex != 0 && mainIndex != 0 )?"Weekly":(daysDataIndex == -1 && daysIndex == -1 && mainIndex != 0 )?"Monthly":"Monthly"} measures that could be affected by your entries for this ${(daysDataIndex != -1 && daysIndex != -1 && mainIndex != -1 ) ?"Activity":(daysDataIndex == -1 && daysIndex != -1 && mainIndex != -1 )?"Day":(daysDataIndex == -1 && daysIndex == -1 && mainIndex != -1 )?"Week":"Week"}. How would you like to proceed? "),
        contentPadding: EdgeInsets.only(
            top: Sizes.height_1,
            left: Sizes.width_4,
            right: Sizes.width_4
        ),
        actionsPadding: EdgeInsets.only(
          top: (kIsWeb) ? Sizes.height_2 : 0,
            right: Sizes.width_4
        ),
        actions: [
          autoCalculateButton,
          overrideButton,
          okButton,
          cancelButton,
        ],
      );

      // show the dialog
      await showDialog(
        context: Get.context!,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return alert;
        },
      );
  }

  Future<void> showAlertDialogForOverrideActivityData(int type ,List<ActivityTable> fondedList, int mainIndex,
      int daysIndex,value ,int daysDataIndex,{bool isDaysStr = false,bool isManualChanges = false}) async {

    // set up the button
    Widget okButton = TextButton(
      child:  Text(Constant.popupStuffManual,style: TextStyle(
        // fontSize:  FontSize.size_10
      ),),
      onPressed: () async {
        if(fondedList.length == 1) {
          fondedList[0].isOverride = true;
          await DataBaseHelper.shared.updateActivityData(fondedList[0]);
        }
        else{
          for (int i = 0; i < fondedList.length; i++) {
            fondedList[i].isOverride = true;
            await DataBaseHelper.shared.updateActivityData(fondedList[i]);
          }
        }

          if(type == Constant.typeWeek) {
            insertUpdateWeekData(mainIndex,isFromDialog: true);
          }else if(type == Constant.typeDay) {
            activityMinDayLevelInsertUpdateData(mainIndex,daysIndex,value,false,Constant.totalMinPerDay,isFromDialog: true,isManualChanges: isManualChanges);
          }else if(type == Constant.typeDaysData) {
            // activityMinDayDataLevelInsertUpdateData(mainIndex,daysIndex,daysDataIndex,value,isFromDialog: true);
            activityMinDayDataLevelInsertUpdateData(mainIndex,daysIndex,daysDataIndex,value,
                isManualChanges:isManualChanges);
          }

        Get.back();
      },
    );

    Widget overrideButton = TextButton(
      child:  Text(Constant.popupStuffReCalculate,style: TextStyle(
          // fontSize:  FontSize.size_10
      ),),
      onPressed: () async {
        if(fondedList.length == 1) {
          fondedList[0].isOverride = false;

          await DataBaseHelper.shared.updateActivityData(fondedList[0]);
        }
        else{
          for (int i = 0; i < fondedList.length; i++) {
            fondedList[i].isOverride = false;
            await DataBaseHelper.shared.updateActivityData(fondedList[i]);
          }
        }

        await DataBaseHelper.shared.updateActivityData(fondedList[0]);

          if (type == Constant.typeWeek) {
            insertUpdateWeekData(mainIndex, isFromDialog: true);
          }
          else if (type == Constant.typeDay) {
            activityMinDayLevelInsertUpdateData(
                mainIndex, daysIndex, value,false,Constant.totalMinPerDay, isFromDialog: true);
          }
          else if (type == Constant.typeDaysData) {
            activityMinDayDataLevelInsertUpdateData(
                mainIndex, daysIndex, daysDataIndex, value,
                isFromDialog: true);
          }
        Get.back();
      },
    );

    Widget cancelButton = TextButton(onPressed: () {
      Get.back();
    }, child:  Text(Constant.popupStuffCancel,style: TextStyle(
        // fontSize:  FontSize.size_10
    ),));

    Widget autoCalculateButton = TextButton(
      child:  Text(Constant.popupStuffAutoCalculate,style: TextStyle(
          // fontSize:  FontSize.size_10
      ),),
      onPressed: () async {
        Get.back();
        showAlertDialogAutoCalculate(type ,fondedList,[],  mainIndex,
            daysIndex,value , daysDataIndex,false);
      },
    );


    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      // title: const Text("Already data"),
      // content: Text("You want to override your data? $mainIndex  $daysIndex  $daysDataIndex"),
      // content: const Text("You want to override your data?"),
      content: Text(
          "There are manual values for ${(daysDataIndex != -1 && daysIndex != -1 && mainIndex != -1) ? "Daily" : (daysDataIndex == -1 && daysIndex != -1 && mainIndex != -1) ? "Weekly" : (daysDataIndex == -1 && daysIndex == -1 && mainIndex != -1) ? "Monthly" : "Monthly"} measures that could be affected by your entries for this ${(daysDataIndex != -1 && daysIndex != -1 && mainIndex != -1) ? "Activity" : (daysDataIndex == -1 && daysIndex != -1 && mainIndex != 0) ? "Day" : (daysDataIndex == -1 && daysIndex == -1 && mainIndex != -1) ? "Week" : "Week"}. How would you like to proceed?"),
      actionsAlignment: MainAxisAlignment.center,
      contentPadding: EdgeInsets.only(
        top: Sizes.height_1,
        left: Sizes.width_4,
        right: Sizes.width_4
      ),
      actionsPadding: EdgeInsets.only(
        right: Sizes.width_4
      ),
      actions: [
        autoCalculateButton,
        overrideButton,
        okButton,
        cancelButton,
        /*Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                autoCalculateButton,
                overrideButton,
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                okButton,
                cancelButton,
              ],
            ),
          ],
        )*/

      ],
    );

    // show the dialog
    await showDialog(
      context: Get.context!,
      // barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  Future<void> showAlertDialogAutoCalculate(int type ,List<ActivityTable>  activityFondedList,List<MonthlyLogTableData> monthlyFondedList , int mainIndex,
      int daysIndex,value ,int daysDataIndex,bool isMonth,{bool isDaysStr = false}) async {

    Widget cancelButton = TextButton(onPressed: () {
      Get.back();
    }, child: const Text("No"));

    // set up the button
    Widget okButton = TextButton(
      child: const Text("Yes"),
      onPressed: () async {
        if (isMonth) {
          /*if (monthlyFondedList.length == 1) {
            monthlyFondedList[0].dayPerWeekValue = null;
            monthlyFondedList[0].avgMinValue = null;
            monthlyFondedList[0].avgMInPerWeekValue = null;
            monthlyFondedList[0].strengthValue = null;

            monthlyFondedList[0].isOverrideDayPerWeek = false;
            monthlyFondedList[0].isOverrideAvgMin = false;
            monthlyFondedList[0].isOverrideAvgMinPerWeek = false;
            monthlyFondedList[0].isOverrideStrength = false;
            await DataBaseHelper.shared.updateMonthlyData(monthlyFondedList[0]);
          }
          else {
            for (int i = 0; i < monthlyFondedList.length; i++) {
              monthlyFondedList[i].dayPerWeekValue = null;
              monthlyFondedList[i].avgMinValue = null;
              monthlyFondedList[i].avgMInPerWeekValue = null;
              monthlyFondedList[i].strengthValue = null;

              monthlyFondedList[i].isOverrideDayPerWeek = false;
              monthlyFondedList[i].isOverrideAvgMin = false;
              monthlyFondedList[i].isOverrideAvgMinPerWeek = false;
              monthlyFondedList[i].isOverrideStrength = false;

              await DataBaseHelper.shared.updateMonthlyData(monthlyFondedList[i]);
            }
          }
          await DataBaseHelper.shared.updateMonthlyData(monthlyFondedList[0]);
          if (isDaysStr) {
            insertUpdateAfterOverrideDaysStr(value, mainIndex);
          }
          else {
            if (type == Constant.typeWeek) {
              insertUpdateWeekData(mainIndex, isFromDialog: false);
            } else if (type == Constant.typeDay) {
              activityMinDayLevelInsertUpdateData(mainIndex, daysIndex, value,false,Constant.totalMinPerDay,
                  isFromDialog: false);
            } else if (type == Constant.typeDaysData) {
              activityMinDayDataLevelInsertUpdateData(
                  mainIndex, daysIndex, daysDataIndex, value,
                  isFromDialog: false);
            }
          }*/
        }
        else {
          if (activityFondedList.length == 1) {
            activityFondedList[0].isOverride = false;
            await DataBaseHelper.shared.updateActivityData(activityFondedList[0]);
          } else {
            for (int i = 0; i < activityFondedList.length; i++) {
              activityFondedList[i].isOverride = false;
              await DataBaseHelper.shared.updateActivityData(activityFondedList[i]);
            }
          }

          await DataBaseHelper.shared.updateActivityData(activityFondedList[0]);

          if (type == Constant.typeWeek) {
            insertUpdateWeekData(mainIndex, isFromDialog: true);
          } else if (type == Constant.typeDay) {
            activityMinDayLevelInsertUpdateData(mainIndex, daysIndex, value,false,Constant.totalMinPerDay,
                isFromDialog: true);
          } else if (type == Constant.typeDaysData) {
            activityMinDayDataLevelInsertUpdateData(
                mainIndex, daysIndex, daysDataIndex, value,
                isFromDialog: true);
          }
        }
        bool isAutoMode =  Preference.shared.getBool(Preference.isAutoCalMode) ?? false;
        Debug.printLog("isAutoMode.........$isAutoMode");
        // Constant.isAutoCalMode = !isAutoMode;
        Preference.shared.setBool(Preference.isAutoCalMode,!isAutoMode);
        update();
        Get.back();
      },
    );




    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      // title: const Text("Already data"),
      // content: Text("You want to override your data? $mainIndex  $daysIndex  $daysDataIndex"),
      // content: const Text("You want to override your data?"),
      content:  const Text("Enable Auto-Calculate?"),

      actions: [

        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    await showDialog(
      context: Get.context!,
      // barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  insertUpdateWeekData(int index,{bool isFromDialog = false,bool isManualChanges = false,bool isRemove = false}) async {
    var allDataFromDB = getActivityListData();
    String formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy).format(trackingChartDataList[index].weekStartDate!);
    String formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy).format(trackingChartDataList[index].weekEndDate!);
    var weekInsertedData = allDataFromDB
        .where((element) =>
    element.weeksDate == "$formattedDateStart-$formattedDateEnd" &&
        element.type == Constant.typeWeek && element.title == null && element.displayLabel == null && element.smileyType == null)
        .toList();
    if(weekInsertedData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.isOverride = isManualChanges;
      insertingData.name = "";
      // insertingData.date = DateTime.now().toString();
      insertingData.title = null;

      if(trackingChartDataList[index].modMinValue == 0){
        insertingData.value1 = null;
      }else{
        insertingData.value1 = double.parse(trackingChartDataList[index].modMinValue.toString());
      }

      if(trackingChartDataList[index].vigMinValue == 0) {
        insertingData.value2 = null;
      }else{
        insertingData.value2 = double.parse(
            trackingChartDataList[index].vigMinValue
                .toString());
      }

      if(trackingChartDataList[index].totalMinValue == 0) {
        insertingData.total = null;
      }else{
        insertingData.total = double.parse(trackingChartDataList[index].totalMinValue
                .toString());
      }
      insertingData.type = Constant.typeWeek;
      String formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy).format(trackingChartDataList[index].weekStartDate!);
      String formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy).format(trackingChartDataList[index].weekEndDate!);
      insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";
      //insertingData.patientId = Utils.getPatientId();
      var id = await DataBaseHelper.shared.insertActivityData(insertingData);
      Debug.printLog("insertUpdate if......$id");
    }
    else{
      String formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy).format(trackingChartDataList[index].weekStartDate!);
      String formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy).format(trackingChartDataList[index].weekEndDate!);
      var weekInsertedData = allDataFromDB
          .where((element) =>
      element.weeksDate == "$formattedDateStart-$formattedDateEnd"  && element.type == Constant.typeWeek
          && element.title == null && element.displayLabel == null && element.smileyType == null)
          .toList()
          .single;
      weekInsertedData.isOverride = isManualChanges;
      if(trackingChartDataList[index].modMinValue == 0){
        weekInsertedData.value1 = null;
      }else{
        weekInsertedData.value1 = double.parse(trackingChartDataList[index].modMinValue.toString());
      }

      if(trackingChartDataList[index].vigMinValue == 0) {
        weekInsertedData.value2 = null;
      }else{
        weekInsertedData.value2 = double.parse(
            trackingChartDataList[index].vigMinValue
                .toString());
      }

      if(trackingChartDataList[index].totalMinValue == 0) {
        weekInsertedData.total = null;
      }else{
        weekInsertedData.total = double.parse(trackingChartDataList[index].totalMinValue
            .toString());
      }

      await DataBaseHelper.shared.updateActivityData(weekInsertedData);
    }

  }



  /*This is for week's days */
  void onChangeActivityMinModDay(int mainIndex,int daysIndex,dynamic value,bool needAPICall,{bool isFromDialog = false,
    bool isManualChanges = false}) async {
    if(value == "" || value == null){
      trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].modMinValue = 0;
      trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].modMinController.text = "";
    }else {
      trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].modMinValue = int.parse(value);
      trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].modMinController.text = value;
    }

    trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].modMinController.selection =
        TextSelection.fromPosition(TextPosition(offset: value.length));
    trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].totalMinController.text = (trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].modMinValue + trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].vigMinValue).toString();
    trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].totalMinValue = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].modMinValue + trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].vigMinValue;
    insertUpdateActivityMinDayLevelData(mainIndex,daysIndex,needAPICall,Constant.modMinPerDay,double.parse(value.toString()),isManualChanges: isManualChanges);

    // onChangeCountValue1Title1(mainIndex,value.toString());

    var value1TotalCount = 0;
    var value2TotalCount = 0;
    var totalValueCount = 0;
    for (int a = 0; a < trackingChartDataList[mainIndex].dayLevelDataList.length; a++) {
      value1TotalCount += trackingChartDataList[mainIndex].dayLevelDataList[a].modMinValue;
      value2TotalCount += trackingChartDataList[mainIndex].dayLevelDataList[a].vigMinValue;
      totalValueCount += trackingChartDataList[mainIndex].dayLevelDataList[a].totalMinValue;
    }
    onChangeActivityMinModWeek(mainIndex,value1TotalCount.toString(),isFromDialog: isFromDialog,isManualChanges: isManualChanges);
    // onChangeActivityMinVigWeek(mainIndex,value2TotalCount.toString(),isFromDialog: isFromDialog,isManualChanges: isManualChanges);
    onChangeActivityMinTotalWeek(mainIndex,totalValueCount.toString(),isFromDialog: isFromDialog,isManualChanges: isManualChanges);

    update();
  }
  void onChangeActivityMinVigDay(int mainIndex,int daysIndex,dynamic value,bool needAPICall,{bool isFromDialog = false,bool isManualChanges = false}) {
    if(value == "" || value == null){
      trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].vigMinValue = 0;
      trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].vigMinController.text = "";
      trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].vigMinController.selection =
          TextSelection.fromPosition(const TextPosition(offset: 0));
    }else {
      trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].vigMinValue = int.parse(value);
      trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].vigMinController.text = value;
      trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].vigMinController.selection =
          TextSelection.fromPosition(TextPosition(offset: value.length));
    }


    trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].totalMinController.text = (trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].modMinValue + trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].vigMinValue).toString();
    trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].totalMinValue = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].modMinValue + trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].vigMinValue;
    insertUpdateActivityMinDayLevelData(mainIndex,daysIndex,false,Constant.vigMinPerDay,double.parse(value.toString()));

    var value1TotalCount = 0;
    var value2TotalCount = 0;
    var totalValueCount = 0;
    for (int a = 0; a < trackingChartDataList[mainIndex].dayLevelDataList.length; a++) {
      value1TotalCount += trackingChartDataList[mainIndex].dayLevelDataList[a].modMinValue;
      value2TotalCount += trackingChartDataList[mainIndex].dayLevelDataList[a].vigMinValue;
      totalValueCount += trackingChartDataList[mainIndex].dayLevelDataList[a].totalMinValue;
    }
    // onChangeActivityMinModWeek(mainIndex,value1TotalCount.toString(),isFromDialog: isFromDialog);
    onChangeActivityMinVigWeek(mainIndex,value2TotalCount.toString(),isFromDialog: isFromDialog);
    onChangeActivityMinTotalWeek(mainIndex,totalValueCount.toString(),isFromDialog: isFromDialog);

    update();
  }
  Future<void> onChangeActivityMiTotalDays(int mainIndex,int daysIndex,dynamic value,bool needAPICall,{bool isFromDialog = false,
  bool isManualChanges = false,bool isFromDays = false,bool isOverride = false}) async {
    if(value == ""){
      trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].totalMinValue = 0;
    }else{
      trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].totalMinValue = int.parse(value);
    }

    var activityTableData = getActivityListData();

    List<ActivityTable> foundedList = activityTableData.where((element) => element.type == Constant.typeWeek &&
        Utils.getDaysInBetween(DateFormat(Constant.commonDateFormatDdMmYyyy).parse(
            "${element.weeksDate!.split("-")[0]}-${element.weeksDate!.split("-")[1]}-${element.weeksDate!.split("-")[2]}"
        ),
            DateFormat(Constant.commonDateFormatDdMmYyyy).parse(
                "${element.weeksDate!.split("-")[3]}-${element.weeksDate!.split("-")[4]}-${element.weeksDate!.split("-")[5]}"

            )).toList().where((elementDate) => elementDate ==
            trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].storedDate).isNotEmpty &&
        element.isOverride).toList();

    if(foundedList.isNotEmpty){
      if(!(Preference.shared.getBool(Preference.isAutoCalMode) ?? false)) {
        await showAlertDialogForOverrideActivityData(Constant.typeDay, foundedList, mainIndex, daysIndex, value, -1,isManualChanges: isManualChanges);
      }else{
        if((Preference.shared.getBool(Preference.isAutoCalMode) ?? false)){
          activityMinDayLevelInsertUpdateData(mainIndex,daysIndex,value,needAPICall,Constant.totalMinPerDay,isFromDialog: true,isManualChanges: false,isFromDays: true,isOverride:isOverride);
        }else{
          activityMinDayLevelInsertUpdateData(mainIndex,daysIndex,value,needAPICall,Constant.totalMinPerDay,isFromDialog: true,isManualChanges: isManualChanges,isFromDays: isFromDays,isOverride:isOverride);
        }
      }
    }else{
      if(isFromDays){
        activityMinDayLevelInsertUpdateData(mainIndex,daysIndex,value,needAPICall,Constant.totalMinPerDay,isFromDays: isFromDays,isOverride:isOverride);
      }else{
        activityMinDayLevelInsertUpdateData(mainIndex,daysIndex,value, needAPICall,Constant.totalMinPerDay,isManualChanges:isManualChanges,isOverride:isOverride);
      }
    }

    update();
  }

  activityMinDayLevelInsertUpdateData(int mainIndex,int daysIndex,value,bool needAPICall,String typeOfDay,{bool isFromDialog = false,bool isManualChanges = false,
  bool isFromDays = false,bool isOverride = false}){
    trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].totalMinController.text =
    (value == "")?"":value.toString();
    trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].totalMinController.selection =
        TextSelection.fromPosition(TextPosition(offset: value.length));
    if (isFromDays) {
      insertUpdateActivityMinDayLevelData(mainIndex, daysIndex,false,typeOfDay,double.parse(value.toString()), isManualChanges: true,isOverride:isOverride);
    } else {
      insertUpdateActivityMinDayLevelData(mainIndex, daysIndex,false,typeOfDay,double.parse(value.toString()),
          isManualChanges: isManualChanges,isOverride:isOverride);
    }

    if(!isManualChanges) {
      var value1TotalCount = 0;
      var value2TotalCount = 0;
      var totalValueCount = 0;
      for (int a = 0; a <
          trackingChartDataList[mainIndex].dayLevelDataList.length; a++) {
        value1TotalCount +=
            trackingChartDataList[mainIndex].dayLevelDataList[a].modMinValue ?? 0;
        value2TotalCount +=
            trackingChartDataList[mainIndex].dayLevelDataList[a].vigMinValue ?? 0;
        totalValueCount +=
            trackingChartDataList[mainIndex].dayLevelDataList[a].totalMinValue ?? 0;
      }
      onChangeActivityMinModWeek(mainIndex, value1TotalCount.toString(),
          isManualChanges: isManualChanges);
      onChangeActivityMinVigWeek(mainIndex, value2TotalCount.toString(),
          isManualChanges: isManualChanges);
      onChangeActivityMinTotalWeek(
          mainIndex, totalValueCount.toString(), isFromDialog: isFromDialog,
          isManualChanges: isManualChanges);
    }
  }

  insertUpdateActivityMinDayLevelData(int mainIndex,int daysIndex,bool needAPICall,String typeOfDay,double value,{bool isManualChanges = false,bool isRemove = false,bool isOverride = false}) async {
    var allDataFromDB = getActivityListData();
    List<ActivityTable> weekInsertedData = [];
    String formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
        .format(trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].storedDate!);
    if(allDataFromDB.isNotEmpty) {
      String formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy).format(
          trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].storedDate!);

      weekInsertedData = allDataFromDB.where((element) =>
      element.date == formattedDate && element.type == Constant.typeDay && element.title == null && element.smileyType == null).toList();
    }
    if(weekInsertedData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.isOverride = isManualChanges;

      insertingData.name = "";
      insertingData.dateTime = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].storedDate;
      insertingData.date = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].date;
      insertingData.title = null;
      insertingData.smileyType = null;
      insertingData.isSync = false;
      if(trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].modMinValue == 0){
        insertingData.value1 = null;
      }else{
        insertingData.value1 = double.parse(trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].modMinValue.toString());
      }

      if(trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].vigMinValue == 0) {
        insertingData.value2 = null;
      }else{
        insertingData.value2 = double.parse(
            trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].vigMinValue
                .toString());
      }

      if(trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].totalMinValue == 0) {
        insertingData.total = null;
      }else{
        insertingData.total = double.parse(
            trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].totalMinValue
                .toString());
      }
      insertingData.type = Constant.typeDay;
      String formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy).format(trackingChartDataList[mainIndex].weekStartDate!);
      String formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy).format(trackingChartDataList[mainIndex].weekEndDate!);
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

      var id = await DataBaseHelper.shared.insertActivityData(insertingData);
      Debug.printLog("insertUpdateWeekDayData if......$id");

    }
    else{
      String formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].storedDate!);

      weekInsertedData[0].isOverride = isManualChanges;
      if(trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].modMinValue == 0){
        weekInsertedData[0].value1 = null;
      }else{
        weekInsertedData[0].value1 = double.parse(trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].modMinValue.toString());
      }

      if(trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].vigMinValue == 0) {
        weekInsertedData[0].value2 = null;
      }else{
        weekInsertedData[0].value2 = double.parse(
            trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].vigMinValue
                .toString());
      }

      if(trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].totalMinValue == 0) {
        weekInsertedData[0].total = null;
      }else{
        weekInsertedData[0].total = double.parse(
            trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].totalMinValue
                .toString());
      }
      weekInsertedData[0].smileyType = null;
      weekInsertedData[0].isSync = false;

      var allSelectedServersUrl = Utils.getServerListPreference().where((
          element) => element.patientId != "" && element.isSelected).toList();

      if (weekInsertedData[0].serverDetailList.length !=
          allSelectedServersUrl.length) {
        for (int i = 0; i < allSelectedServersUrl.length; i++) {
          var url = weekInsertedData[0].serverDetailList;
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
            weekInsertedData[0].serverDetailList.add(
                serverDetail);
          }
        }
      }

      if (weekInsertedData[0].serverDetailListModMin.length !=
          allSelectedServersUrl.length) {
        for (int i = 0; i < allSelectedServersUrl.length; i++) {
          var url = weekInsertedData[0].serverDetailListModMin;
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
            weekInsertedData[0].serverDetailListModMin.add(
                serverDetail);
          }
        }
      }

      if (weekInsertedData[0].serverDetailListVigMin.length !=
          allSelectedServersUrl.length) {
        for (int i = 0; i < allSelectedServersUrl.length; i++) {
          var url = weekInsertedData[0].serverDetailListVigMin;
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
            weekInsertedData[0].serverDetailListVigMin.add(
                serverDetail);
          }
        }
      }

      await DataBaseHelper.shared.updateActivityData(weekInsertedData[0]);
    }

    var lengthOfList =  getActivityListData()
        .where((element) =>
    element.total != 0 && element.total != null &&
        element.title == null && element.type == Constant.typeDay && element.dateTime!.month == trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].storedDate
    !.month)
        .toList();
    var totalWorkedMin = 0.0;
    var totalWorkedDay = 0.0;


    totalWorkedDay += lengthOfList.length;


    ///First col days/week
    var dayPerWeekValue = 0;
    dayPerWeekValue = double.parse((totalWorkedDay / 5).ceil().toStringAsFixed(2))
        .toInt();

    for (var element in lengthOfList) {
      totalWorkedMin += element.total ?? 0;
    }

    ///Second col Mins
    var avgMinValue = 0;
    avgMinValue = double.parse(
        (totalWorkedMin / totalWorkedDay).ceil().toStringAsFixed(2))
        .toInt();

    ///Second col Mins/Week
    var avgMinPerWeekValue = 0;
    avgMinPerWeekValue = double.parse(
        (dayPerWeekValue * avgMinValue).toStringAsFixed(2))
        .toInt();


    var selectedDate = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].storedDate;

    var foundedList = getMonthlyDataList().where((element) => element.monthName == Utils.getMonthName(selectedDate!.month,
        selectedDate.year)
        && element.year == selectedDate.year).toList();

    if (foundedList.isNotEmpty) {
      ///Update

      foundedList[0].isOverrideDayPerWeek = false;
      foundedList[0].isOverrideAvgMin = false;
      foundedList[0].isOverrideAvgMinPerWeek = false;

      if (dayPerWeekValue == 0) {
        foundedList[0].dayPerWeekValue = null;
      } else {
        foundedList[0].dayPerWeekValue =
            double.parse(dayPerWeekValue.toString());
      }

      if (avgMinValue == 0) {
        foundedList[0].avgMinValue = null;
      } else {
        foundedList[0].avgMinValue = double.parse(avgMinValue.toString());
      }

      if (avgMinPerWeekValue == 0) {
        foundedList[0].avgMInPerWeekValue = null;
      } else {
        foundedList[0].avgMInPerWeekValue =
            double.parse(avgMinPerWeekValue.toString());
      }


      var allSelectedServersUrl = Utils.getServerListPreference().where((
          element) => element.patientId != "" && element.isSelected).toList();

      foundedList[0].isSyncDayPerWeek = false;
      if (foundedList[0].serverDetailListDayPerWeek.length !=
          allSelectedServersUrl.length) {
        for (int i = 0; i < allSelectedServersUrl.length; i++) {
          var url = foundedList[0].serverDetailListDayPerWeek;
          if (url
              .where((element) =>
          element.serverUrl == allSelectedServersUrl[i].url)
              .toList()
              .isEmpty) {
            var data = ServerDetailDataTable();
            data.serverUrl = allSelectedServersUrl[i].url;
            data.patientId = allSelectedServersUrl[i].patientId;
            data.objectId = "";
            data.patientName =
            "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i]
                .patientLName}";
            foundedList[0].serverDetailListDayPerWeek.add(data);
          }
        }
      }

      foundedList[0].isSyncAvgMin = false;
      if (foundedList[0].serverDetailListAvgMin.length !=
          allSelectedServersUrl.length) {
        for (int i = 0; i < allSelectedServersUrl.length; i++) {
          var url = foundedList[0].serverDetailListAvgMin;
          if (url
              .where((element) =>
          element.serverUrl == allSelectedServersUrl[i].url)
              .toList()
              .isEmpty) {
            var data = ServerDetailDataTable();
            data.serverUrl = allSelectedServersUrl[i].url;
            data.patientId = allSelectedServersUrl[i].patientId;
            data.objectId = "";
            data.patientName =
            "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i]
                .patientLName}";
            foundedList[0].serverDetailListAvgMin.add(data);
          }
        }
      }


      foundedList[0].isSyncAvgMinPerWeek = false;
      if (foundedList[0].serverDetailListAvgMinWeek.length !=
          allSelectedServersUrl.length) {
        for (int i = 0; i < allSelectedServersUrl.length; i++) {
          var url = foundedList[0].serverDetailListAvgMinWeek;
          if (url
              .where((element) =>
          element.serverUrl == allSelectedServersUrl[i].url)
              .toList()
              .isEmpty) {
            var data = ServerDetailDataTable();
            data.serverUrl = allSelectedServersUrl[i].url;
            data.patientId = allSelectedServersUrl[i].patientId;
            data.objectId = "";
            data.patientName =
            "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i]
                .patientLName}";
            foundedList[0].serverDetailListAvgMinWeek.add(data);
          }
        }
      }

      await DataBaseHelper.shared.updateMonthlyData(foundedList[0]);
    }
    else {
      ///Insert
      var selectedDate = trackingChartDataList[mainIndex]
          .dayLevelDataList[daysIndex].storedDate;

      var newMonthlyData = MonthlyLogTableData();
      newMonthlyData.monthName = Utils.getMonthName(selectedDate!.month,
          selectedDate.year);
      newMonthlyData.year = selectedDate.year;
      newMonthlyData.isOverrideDayPerWeek = false;
      newMonthlyData.isOverrideAvgMin = false;
      newMonthlyData.isOverrideAvgMinPerWeek = false;
      newMonthlyData.isOverrideStrength = false;
      newMonthlyData.startDate = Utils.getMonthStartDate(selectedDate);
      newMonthlyData.endDate = Utils.getMonthEndDate(selectedDate);

      if (dayPerWeekValue == 0) {
        newMonthlyData.dayPerWeekValue = null;
      } else {
        newMonthlyData.dayPerWeekValue =
            double.parse(dayPerWeekValue.toString());
      }

      if (avgMinValue == 0) {
        newMonthlyData.avgMinValue = null;
      } else {
        newMonthlyData.avgMinValue = double.parse(avgMinValue.toString());
      }

      if (avgMinPerWeekValue == 0) {
        newMonthlyData.avgMInPerWeekValue = null;
      } else {
        newMonthlyData.avgMInPerWeekValue =
            double.parse(avgMinPerWeekValue.toString());
      }

      newMonthlyData.isSyncDayPerWeek = false;
      var connectedServerUrl = Utils.getServerListPreference().where((
          element) => element.patientId != "" && element.isSelected).toList();
      if (connectedServerUrl.isNotEmpty) {
        for (int i = 0; i < connectedServerUrl.length; i++) {
          var data = ServerDetailDataTable();
          data.serverUrl = connectedServerUrl[i].url;
          data.patientId = connectedServerUrl[i].patientId;
          data.clientId = connectedServerUrl[i].clientId;
          data.objectId = "";
          data.serverToken = connectedServerUrl[i].authToken;
          data.patientName =
          "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
              .patientLName}";
          newMonthlyData.serverDetailListDayPerWeek.add(data);
        }
      }

      newMonthlyData.isSyncAvgMin = false;
      var connectedServerUrlSyncAvgMin = Utils.getServerListPreference().where((
          element) => element.patientId != "" && element.isSelected).toList();
      if (connectedServerUrlSyncAvgMin.isNotEmpty) {
        for (int i = 0; i < connectedServerUrlSyncAvgMin.length; i++) {
          var data = ServerDetailDataTable();
          data.serverUrl = connectedServerUrlSyncAvgMin[i].url;
          data.patientId = connectedServerUrlSyncAvgMin[i].patientId;
          data.clientId = connectedServerUrlSyncAvgMin[i].clientId;
          data.objectId = "";
          data.serverToken = connectedServerUrlSyncAvgMin[i].authToken;
          data.patientName =
          "${connectedServerUrlSyncAvgMin[i]
              .patientFName}${connectedServerUrlSyncAvgMin[i]
              .patientLName}";
          newMonthlyData.serverDetailListAvgMin.add(data);
        }
      }


      newMonthlyData.isSyncAvgMinPerWeek = false;
      var connectedServerUrlAvgMinPerWeek = Utils.getServerListPreference()
          .where((element) => element.patientId != "" && element.isSelected)
          .toList();
      if (connectedServerUrlAvgMinPerWeek.isNotEmpty) {
        for (int i = 0; i < connectedServerUrlAvgMinPerWeek.length; i++) {
          var data = ServerDetailDataTable();
          data.serverUrl = connectedServerUrlAvgMinPerWeek[i].url;
          data.patientId = connectedServerUrlAvgMinPerWeek[i].patientId;
          data.clientId = connectedServerUrlAvgMinPerWeek[i].clientId;
          data.objectId = "";
          data.serverToken = connectedServerUrlAvgMinPerWeek[i].authToken;
          data.patientName = "${connectedServerUrlAvgMinPerWeek[i]
              .patientFName}${connectedServerUrlAvgMinPerWeek[i]
              .patientLName}";
          newMonthlyData.serverDetailListAvgMinWeek.add(data);
        }
      }

      await DataBaseHelper.shared.insertMonthlyData(newMonthlyData);
    }


    var startDateOfMonth = Utils.getMonthStartDate(selectedDate ?? DateTime.now());
    var endDateOfMonth = Utils.getMonthEndDate(selectedDate ?? DateTime.now());
    var getCurrentMonthData = getMonthlyDataList()
        .where((element) =>
    Utils.getDateFromFullDate(element.startDate ?? DateTime.now()) ==
        Utils.getDateFromFullDate(startDateOfMonth ?? DateTime.now()) &&
        Utils.getDateFromFullDate(element.endDate ?? DateTime.now()) ==
            Utils.getDateFromFullDate(endDateOfMonth ?? DateTime.now()))
        .toList();
    var isSyncDayPerWeek = false;
    if (getCurrentMonthData.isNotEmpty) {
      isSyncDayPerWeek = getCurrentMonthData[0].isSyncDayPerWeek;
    }

    if (!isSyncDayPerWeek) {
        List<SyncMonthlyActivityData> allSyncingData = [];
        var indexOfAvgValueOfMonth =  Utils.allYearlyMonths.indexWhere((element) =>
          element.name == Utils.getMonthName(startDateOfMonth.month, startDateOfMonth.year)
        ).toInt();
        if(indexOfAvgValueOfMonth != -1) {
          await Syncing.syncMonthlyDataDayPerWeek(
              getMonthlyDataList(), allSyncingData, indexOfAvgValueOfMonth,
              isFromRefresh: false,
              startDate: startDateOfMonth,
              endDate: endDateOfMonth);
          await Syncing.observationSyncDataDaysPerWeeks(allSyncingData);
          Debug.printLog("avgMinValue...  $allSyncingData");
        }
    }

    var getCurrentMonthDataAvgMin = getMonthlyDataList()
        .where((element) =>
    Utils.getDateFromFullDate(element.startDate ?? DateTime.now()) ==
        Utils.getDateFromFullDate(startDateOfMonth ?? DateTime.now()) &&
        Utils.getDateFromFullDate(element.endDate ?? DateTime.now()) ==
            Utils.getDateFromFullDate(endDateOfMonth ?? DateTime.now()))
        .toList();
    var isSyncAvgMin = false;
    if (getCurrentMonthDataAvgMin.isNotEmpty) {
      isSyncAvgMin = getCurrentMonthDataAvgMin[0].isSyncAvgMin;
    }
    if (!isSyncAvgMin) {

      var indexOfAvgValueOfMonth =  Utils.allYearlyMonths.indexWhere((element) =>
      element.name == Utils.getMonthName(startDateOfMonth.month, startDateOfMonth.year)
      ).toInt();
      if(indexOfAvgValueOfMonth != -1) {
        List<SyncMonthlyActivityData> allSyncingData = [];
        await Syncing.syncMonthlyDataAverageMin(
            getMonthlyDataList(), allSyncingData, indexOfAvgValueOfMonth,
            isFromRefresh: false,
            startDate: startDateOfMonth,
            endDate: endDateOfMonth);
        await Syncing.observationSyncDataMinPerDay(allSyncingData);
        Debug.printLog("isSyncAvgMin..  $allSyncingData");
      }
    }


    var getCurrentMonthDataAvgMinPerWeek = getMonthlyDataList()
        .where((element) =>
    Utils.getDateFromFullDate(element.startDate ?? DateTime.now()) ==
        Utils.getDateFromFullDate(startDateOfMonth ?? DateTime.now()) &&
        Utils.getDateFromFullDate(element.endDate ?? DateTime.now()) ==
            Utils.getDateFromFullDate(endDateOfMonth ?? DateTime.now()))
        .toList();
    var isSyncAvgMinPerWeek = false;
    if (getCurrentMonthDataAvgMinPerWeek.isNotEmpty) {
      isSyncAvgMinPerWeek = getCurrentMonthDataAvgMinPerWeek[0].isSyncAvgMinPerWeek;
    }
    if (!isSyncAvgMinPerWeek) {

      var indexOfAvgValueOfMonth =  Utils.allYearlyMonths.indexWhere((element) =>
      element.name == Utils.getMonthName(startDateOfMonth.month, startDateOfMonth.year)
      ).toInt();

      if (indexOfAvgValueOfMonth != -1) {
        List<SyncMonthlyActivityData> allSyncingData = [];
        await Syncing.syncMonthlyDataAverageMinPerWeek(
            getMonthlyDataList(), allSyncingData, indexOfAvgValueOfMonth,
            isFromRefresh: false,
            startDate: startDateOfMonth,
            endDate: endDateOfMonth);
        await Syncing.observationSyncDataMinPerWeek(allSyncingData);
        Debug.printLog("isSyncAvgMinPerWeek...  $allSyncingData");
      }
    }
    Debug.printLog("needAPICall...$needAPICall $typeOfDay");

    allDataFromDB = Hive.box<ActivityTable>(Constant.tableActivity).values.toList().where((element) =>
    element.patientId == Utils.getPatientId()).toList();

    // if(needAPICall){
      if(typeOfDay == Constant.totalMinPerDay){
        var totalMinList= allDataFromDB.where((element) =>
        !element.isSync &&
            element.title == null &&
            element.smileyType == null &&
            element.type == Constant.typeDay && element.total != null && Utils.changeDateFormatBasedOnDBDateWithOutTIme(
            element.dateTime ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDateWithOutTIme(
            trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].storedDate ?? DateTime.now()
        ) ).toList();
        if(totalMinList.isNotEmpty){
          totalMinList[0].isOverride = isOverride;
          await DataBaseHelper.shared.updateActivityData(totalMinList[0]);
          List<SyncMonthlyActivityData> totalDataList = [];
          Debug.printLog("modMin..List.list data...${totalMinList[0].dateTime}  ${totalMinList[0].date}   ${totalMinList[0].objectId}  ${double.parse(value.toString())}");
          totalDataList.add(SyncMonthlyActivityData(
              "",
              double.parse(value.toString()),
              Utils.changeDateFormatBasedOnDBDateWithOutTIme(
                  totalMinList[0].dateTime ?? DateTime.now()),
              null,
              totalMinList[0].key,
              Constant.totalMinPerDay,
              true,
              totalMinList[0].objectId,notesDayLevel: totalMinList[0].notes ?? ""));
          await Syncing.observationSyncDataTotalMin(totalDataList);
        }
        Debug.printLog("CALL API..total MIN ");
      }
      else if(typeOfDay == Constant.modMinPerDay){
        Debug.printLog("CALL API..mod MIN ");

        var modMinList= allDataFromDB.where((element) =>
        !element.isSync &&
            element.title == null &&
            element.smileyType == null &&
            element.type == Constant.typeDay
            && element.value1 != null && Utils.changeDateFormatBasedOnDBDateWithOutTIme(
            element.dateTime ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDateWithOutTIme(
            trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].storedDate ?? DateTime.now()
        ) ).toList();
        if(modMinList.isNotEmpty){
          List<SyncMonthlyActivityData> ModDataList = [];
          Debug.printLog("modMin..List.list data...${modMinList[0].dateTime}  ${modMinList[0].date}   ${modMinList[0].objectId}  ${double.parse(value.toString())}");
          ModDataList.add(SyncMonthlyActivityData(
              "",
              modMinList[0].value1 ?? 0.0,
              Utils.changeDateFormatBasedOnDBDateWithOutTIme(
                  modMinList[0].dateTime ?? DateTime.now()),
              null,
              modMinList[0].key,
              Constant.modMinPerDay,
              true,
              modMinList[0].objectId));
          await Syncing.observationSyncDataModMin(ModDataList);
        }

        var totalMinList= allDataFromDB.where((element) =>
            element.title == null &&
            element.smileyType == null &&
            element.type == Constant.typeDay && element.total != null &&
            Utils.changeDateFormatBasedOnDBDateWithOutTIme(
            element.dateTime ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDateWithOutTIme(
            trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].storedDate ?? DateTime.now()
        ) ).toList();
        if(totalMinList.isNotEmpty){
          List<SyncMonthlyActivityData> totalDataList = [];
          Debug.printLog("modMin..List.list data...${totalMinList[0].dateTime}  ${totalMinList[0].date}   ${totalMinList[0].objectId}  ${double.parse(value.toString())}");
          totalDataList.add(SyncMonthlyActivityData(
              "",
              totalMinList[0].total ?? 0.0,
              Utils.changeDateFormatBasedOnDBDateWithOutTIme(
                  totalMinList[0].dateTime ?? DateTime.now()),
              null,
              totalMinList[0].key,
              Constant.totalMinPerDay,
              true,
              totalMinList[0].objectId,notesDayLevel: totalMinList[0].notes ?? ""));
          await Syncing.observationSyncDataTotalMin(totalDataList);
        }
      }
      else if(typeOfDay == Constant.vigMinPerDay){
        Debug.printLog("CALL API..vig MIN ");
        var vigMinList= allDataFromDB.where((element) =>
        !element.isSync &&
            element.title == null &&
            element.smileyType == null &&
            element.type == Constant.typeDay && element.value2 != null && Utils.changeDateFormatBasedOnDBDateWithOutTIme(
            element.dateTime ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDateWithOutTIme(
            trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].storedDate ?? DateTime.now()
        ) ).toList();
        if(vigMinList.isNotEmpty){
          List<SyncMonthlyActivityData> vigDataList = [];
          Debug.printLog("modMin..List.list data...${vigMinList[0].dateTime}  ${vigMinList[0].date}   ${vigMinList[0].objectId}  ${double.parse(value.toString())}");
          vigDataList.add(SyncMonthlyActivityData(
              "",
              vigMinList[0].value2 ?? 0.0,
              Utils.changeDateFormatBasedOnDBDateWithOutTIme(
                  vigMinList[0].dateTime ?? DateTime.now()),
              null,
              vigMinList[0].key,
              Constant.vigMinPerDay,
              true,
              vigMinList[0].objectId));
          await Syncing.observationSyncDataVigMin(vigDataList);
        }

        var totalMinList= allDataFromDB.where((element) =>
        element.title == null &&
            element.smileyType == null &&
            element.type == Constant.typeDay && element.total != null &&
            Utils.changeDateFormatBasedOnDBDateWithOutTIme(
                element.dateTime ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDateWithOutTIme(
                trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].storedDate ?? DateTime.now()
            ) ).toList();
        if(totalMinList.isNotEmpty){
          List<SyncMonthlyActivityData> totalDataList = [];
          Debug.printLog("modMin..List.list data...${totalMinList[0].dateTime}  ${totalMinList[0].date}   ${totalMinList[0].objectId}  ${double.parse(value.toString())}");
          totalDataList.add(SyncMonthlyActivityData(
              "",
              totalMinList[0].total ?? 0.0,
              Utils.changeDateFormatBasedOnDBDateWithOutTIme(
                  totalMinList[0].dateTime ?? DateTime.now()),
              null,
              totalMinList[0].key,
              Constant.totalMinPerDay,
              true,
              totalMinList[0].objectId,notesDayLevel: totalMinList[0].notes ?? ""));
          await Syncing.observationSyncDataTotalMin(totalDataList);
        }
      }
    // }
  }

  /*This is for days data */
  void onChangeActivityMinModDayData(int mainIndex, int daysIndex, int daysDataIndex, dynamic value
      ,{bool byDefault = false ,Function? reCall,bool isManualChanges = false}) async {

    var oldTotalMin = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
        .activityLevelDataList[daysDataIndex].totalMinValue;

    var oldModMin = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
        .activityLevelDataList[daysDataIndex].modMinValue;

    var oldVigMin = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
        .activityLevelDataList[daysDataIndex].vigMinValue;

    var startDate = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex]
        .activityStartDate;


    if(oldTotalMin != null) {
      // var finalActivityEndDate = startDate.add(Duration(
      //     minutes: (int.parse(value) + int.parse(oldTotalMin.toString()))));
      var finalActivityEndDate = DateTime.now();
      if(oldVigMin == null){
        finalActivityEndDate = startDate.add(Duration(
            minutes: int.parse(value)));
      }else if(oldVigMin != null && value != null){
        finalActivityEndDate = startDate.add(Duration(
          minutes: (int.parse(value) + int.parse(oldVigMin.toString()))));
      }


      var listOfLastData = trackingChartDataList[mainIndex]
          .dayLevelDataList[daysIndex]
          .activityLevelDataList;

      var dataIsInWithoutAnotherData = Utils.checkDateOverlap(listOfLastData,
        startDate,finalActivityEndDate,
      currentActivityData: trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
          .activityLevelDataList[daysDataIndex]);

      if (dataIsInWithoutAnotherData) {
        Utils.showToast(Get.context!, "You have to enter valid min");
        if ((oldModMin ?? 0) > 0) {
          trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
              .activityLevelDataList[daysDataIndex].modMinValue = oldModMin;
          trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
              .activityLevelDataList[daysDataIndex].modMinController.text =
              oldModMin.toString();
        }else{
          trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
              .activityLevelDataList[daysDataIndex].modMinValue = 0;
          trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
              .activityLevelDataList[daysDataIndex].modMinController.text =
              "0";
        }
        update();
        return;
      }

      var displayLabel = trackingChartDataList[mainIndex]
          .dayLevelDataList[daysIndex]
          .activityLevelDataList[daysDataIndex]
          .displayLabel;

      var endActivityDate = trackingChartDataList[mainIndex]
          .dayLevelDataList[daysIndex]
          .activityLevelDataList[daysDataIndex]
          .activityEndDate;

      var checkDateOverlap = Utils.checkDateOverlap(listOfLastData,
          startDate,endActivityDate,currentActivityData: trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
              .activityLevelDataList[daysDataIndex]);
      Debug.printLog("Total min......${startDate.isBefore(endActivityDate) && !checkDateOverlap}");

      // if(startDate.isBefore(endActivityDate) && !checkDateOverlap && !kIsWeb && Platform.isIOS){
      if(startDate.isBefore(endActivityDate) && !checkDateOverlap && !kIsWeb){
        try {
          // HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
          var permissions = ( (Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthTypeIos).map((e) => HealthDataAccess.READ_WRITE).toList();
          bool? hasPermissions = await Health().hasPermissions((Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthTypeIos, permissions: permissions);
          if (Platform.isIOS) {
            hasPermissions = Utils.getPermissionHealth();
          }
          Debug.printLog("hasPermissions...$hasPermissions");
          if(hasPermissions!) {
            var deletedData = await Utils.deleteWorkout(
                startDate, endActivityDate, Health());

            HealthWorkoutActivityType workoutType =
                HealthWorkoutActivityType.OTHER;
            var getTypeFromName = (kIsWeb)?Utils.workOutDataListAndroid: (Platform.isAndroid) ? Utils
                .workOutDataListAndroid : Utils.workOutDataListIos
                .where((element) => element.workOutDataName == displayLabel)
                .toList();

            if (getTypeFromName.isNotEmpty) {
              workoutType = getTypeFromName[0].datatype;
            } else {
              workoutType = HealthWorkoutActivityType.OTHER;
            }


            var checkDateOverlap = Utils.checkDateOverlap(listOfLastData,
                startDate,finalActivityEndDate,currentActivityData: trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
                    .activityLevelDataList[daysDataIndex]);

            if(startDate.isBefore(finalActivityEndDate) && !checkDateOverlap){
              try {
                // HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
                var permissions = ( (Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthTypeIos).map((e) => HealthDataAccess.READ_WRITE).toList();
                bool? hasPermissions = await Health().hasPermissions((Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthTypeIos, permissions: permissions);
                if (Platform.isIOS) {
                  hasPermissions = Utils.getPermissionHealth();
                }
                HealthWorkoutActivityType workoutType =
                    HealthWorkoutActivityType.OTHER;
               /* var getTypeFromName = (kIsWeb)?Utils.workOutDataListAndroid: (Platform.isAndroid)?Utils.workOutDataListAndroid:Utils.workOutDataListIos
                    .where((element) => element.workOutDataName == displayLabel)
                    .toList();*/

                List<WorkOutData> getTypeFromName = [];

                if (Platform.isAndroid) {
                  getTypeFromName = Utils.workOutDataListAndroid
                      .where((element) => element.workOutDataName == displayLabel)
                      .toList();
                } else if (Platform.isIOS) {
                  getTypeFromName = Utils.workOutDataListIos
                      .where((element) => element.workOutDataName == displayLabel)
                      .toList();
                }

                if (getTypeFromName.isNotEmpty) {
                  workoutType = getTypeFromName[0].datatype;
                } else {
                  workoutType = HealthWorkoutActivityType.OTHER;
                }
                var value = caloriesDataList[mainIndex].daysList[daysIndex]
                    .daysDataList[daysDataIndex].total;
                Debug.printLog("workoutType...$workoutType  $displayLabel  $value");

                if(Utils.getPermissionHealth()) {
                  await GetSetHealthData.insertActivityIntoAppleGoogleSync(
                      displayLabel, startDate, finalActivityEndDate,
                      workoutType, value.toString());
                }
              } catch (e) {
                Debug.printLog(e.toString());
              }
            }


          }
        } catch (e) {
          Debug.printLog(e.toString());
        }
      }


      var sDate = trackingChartDataList[mainIndex]
          .dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].activityStartDate;
      var eDate = trackingChartDataList[mainIndex]
          .dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].activityEndDate;

      /*var weekInsertedData = getActivityListData().where((element) =>
          element.type == Constant.typeDaysData && element.title == null && element.smileyType == null
          && element.displayLabel ==
          trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].displayLabel
          && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
          Utils.changeDateFormatBasedOnDBDate(sDate)
          && Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
          Utils.changeDateFormatBasedOnDBDate(eDate)).toList();
      if(weekInsertedData.isNotEmpty){
        if(weekInsertedData[0].key != null){
          weekInsertedData[0].activityStartDate = startDate;
          weekInsertedData[0].activityEndDate = finalActivityEndDate;
          await DataBaseHelper.shared.updateActivityData(weekInsertedData[0]);
        }
      }*/
      var displayName = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
          .activityLevelDataList[daysDataIndex].displayLabel;
      await updateSDateAndEDateAfterChangeModVigTotal(displayName,sDate,eDate,startDate,finalActivityEndDate);

      trackingChartDataList[mainIndex]
          .dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].activityStartDate = startDate;
      trackingChartDataList[mainIndex]
          .dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].activityEndDate = finalActivityEndDate;

    }

    if (value == "") {
      trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].modMinValue = null;
      trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].modMinController.text =
      "";
    } else {
      trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].modMinValue = int.parse(value);
      trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].modMinController.text =
          value;
      trackingChartDataList[mainIndex]
          .dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex]
          .modMinController
          .selection =
          TextSelection.fromPosition(TextPosition(offset: value.length));
    }

    trackingChartDataList[mainIndex]
        .dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex]
        .modMinController
        .selection =
        TextSelection.fromPosition(TextPosition(offset: value.length));
    if(trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].modMinValue == null &&
        trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].vigMinValue == null){
      trackingChartDataList[mainIndex]
          .dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex]
          .totalMinController
          .text = "";
      trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
          .activityLevelDataList[daysDataIndex].totalMinValue = null;
    }else {
      if(trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].modMinValue == null &&
          trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].vigMinValue == null){
        trackingChartDataList[mainIndex]
            .dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex]
            .totalMinController
            .text = "";
        trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
            .activityLevelDataList[daysDataIndex].totalMinValue = null;
      }else {
        var value1 = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
            .activityLevelDataList[daysDataIndex].modMinValue ?? 0;
        var value2 = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
            .activityLevelDataList[daysDataIndex].vigMinValue ?? 0;
        trackingChartDataList[mainIndex]
            .dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex]
            .totalMinController
            .text = (value1 + value2)
            .toString();
        trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
            .activityLevelDataList[daysDataIndex].totalMinValue = (value1 + value2);
      }

    }
    await insertUpdateWeekDayInnerData(mainIndex,daysIndex,daysDataIndex,byDefault: byDefault,reCall: reCall);


    if(!byDefault) {
      var value1TotalCount = 0;
      var value2TotalCount = 0;
      var totalValueCount = 0;
      for (int a = 0;
      a < trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
          .activityLevelDataList.length;
      a++) {
        if (trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
            .activityLevelDataList[a].modMinValue == null) {
          // value1TotalCount += 0;
        } else {
          value1TotalCount +=
          trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
              .activityLevelDataList[a].modMinValue!;
        }

        if (trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
            .activityLevelDataList[a].vigMinValue == null) {
          // value2TotalCount += 0;
        } else {
          value2TotalCount +=
          trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
              .activityLevelDataList[a].vigMinValue!;
        }

        if (trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
            .activityLevelDataList[a].totalMinValue == null) {
          // totalValueCount += 0;
        } else {
          totalValueCount +=
          trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
              .activityLevelDataList[a].totalMinValue!;
        }
      }
      Debug.printLog(
          "value1TotalCount.....$value1TotalCount  $value2TotalCount  $totalValueCount");
      onChangeActivityMinModDay(
          mainIndex, daysIndex, value1TotalCount.toString(),false,isFromDialog: false);
      // onChangeActivityMinVigDay(
      //     mainIndex, daysIndex, value2TotalCount.toString(),false,isFromDialog: false);
      onChangeActivityMiTotalDays(
          mainIndex, daysIndex, totalValueCount.toString(),false,isFromDialog: false);
    }

    var displayName = trackingChartDataList[mainIndex]
        .dayLevelDataList[daysIndex]
        .activityLevelDataList[daysDataIndex]
        .displayLabel;

    var sDate = trackingChartDataList[mainIndex]
        .dayLevelDataList[daysIndex]
        .activityLevelDataList[daysDataIndex]
        .activityStartDate;

    var eDate = trackingChartDataList[mainIndex]
        .dayLevelDataList[daysIndex]
        .activityLevelDataList[daysDataIndex]
        .activityEndDate;


    await updateEndTime(displayName,startDate,eDate,eDate);

    var activityDataTableList = getActivityListData();
    var totalMinData = activityDataTableList
        .where((element) =>
    element.type == Constant.typeDaysData &&
        element.title == null &&
        element.smileyType == null &&
        element.total != null &&
        element.displayLabel == displayName &&
        element.activityStartDate == sDate &&
        element.activityEndDate == eDate)
        .toList();
    Debug.printLog("totalMinData length......${totalMinData.length}");

    if(totalMinData.isNotEmpty) {
      if((totalMinData[0].total ?? 0.0) > 0.0 && totalMinData[0].total != null) {
        await Syncing.createChildActivityTotalMinObservation(
            displayName,
            totalMinData[0]);
      }

      var modMinData =  getActivityListData()
          .where((element) =>
      element.type == Constant.typeDaysData &&
          element.title == null &&
          element.smileyType == null &&
          element.value1 != null &&
          element.displayLabel ==
              displayName  &&
          element.activityStartDate ==
              sDate &&
          element.activityEndDate ==
              eDate)
          .toList();
      if(modMinData.isNotEmpty){
        if((modMinData[0].value1 ?? 0.0) > 0.0 && modMinData[0].value1 != null) {
          await Syncing.createChildActivityModerateMinObservation(
              displayName,
              modMinData[0]);
        }
      }

      var vigMinData =  getActivityListData()
          .where((element) =>
      element.type == Constant.typeDaysData &&
          element.title == null &&
          element.smileyType == null &&
          element.value2 != null &&
          element.displayLabel ==
              displayName  &&
          element.activityStartDate ==
              sDate &&
          element.activityEndDate ==
              eDate)
          .toList();
      if(vigMinData.isNotEmpty){
        if((vigMinData[0].value2 ?? 0.0) > 0.0 && vigMinData[0].value2 != null) {
          await Syncing.createChildActivityVigMinObservation(
              displayName,
              vigMinData[0]);
        }
      }

      var peakHeartRateData = getActivityListData()
          .where((element) =>
      element.type == Constant.typeDaysData &&
          element.title == Constant.titleHeartRatePeak &&
          element.displayLabel ==
              displayName &&
          element.activityStartDate ==
              sDate &&
          element.activityEndDate ==
              eDate)
          .toList();
      if(peakHeartRateData.isNotEmpty) {
        if((peakHeartRateData[0].total ?? 0.0) > 0.0 && peakHeartRateData[0].total != null) {
          await Syncing.createChildActivityPeakHeatRateObservation(
              displayName,
              peakHeartRateData[0]);
        }
      }

      var caloriesData = getActivityListData()
          .where((element) =>
      element.type == Constant.typeDaysData &&
          element.title == Constant.titleCalories &&
          element.displayLabel ==
              displayName &&
          element.activityStartDate ==
              sDate &&
          element.activityEndDate ==
              eDate)
          .toList();
      if(caloriesData.isNotEmpty) {
        if((caloriesData[0].total ?? 0.0) > 0.0 && caloriesData[0].total != null) {
          await Syncing.createChildActivityCaloriesObservation(
              displayName,
              caloriesData[0]);
        }
      }

      var activityTypeDataList = getActivityListData()
          .where((element) =>
      element.type == Constant.typeDaysData &&
          element.title == Constant.titleActivityType &&
          element.displayLabel ==
              displayName &&
          element.activityStartDate ==
              sDate &&
          element.activityEndDate ==
              eDate)
          .toList();
      if(activityTypeDataList.isNotEmpty){
        await Syncing.createChildActivityNameObservation(
            displayName,
            activityTypeDataList[0]);
      }

      var activityDataTableList = getActivityListData();
      if(activityDataTableList.isNotEmpty) {
        var findParentRecordActivity = activityDataTableList
            .where((element) =>
        element.date == trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].date &&
            element.type == Constant.typeDaysData &&
            element.title == Constant.titleParent &&
            element.displayLabel ==
                displayName  &&
            element.activityStartDate ==
                sDate &&
            element.activityEndDate ==
                eDate)
            .toList();
        if(findParentRecordActivity.isNotEmpty) {
          Syncing.createParentActivityObservation(
              findParentRecordActivity[0]);
        }
      }

      var allDataFromDB = getActivityListData();
      var totalMinList= allDataFromDB.where((element) =>
      element.title == null &&
          element.smileyType == null &&
          element.type == Constant.typeDay && element.total != null && Utils.changeDateFormatBasedOnDBDateWithOutTIme(
          element.dateTime ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDateWithOutTIme(
          trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].storedDate ?? DateTime.now()
      ) ).toList();
      if(totalMinList.isNotEmpty){
        List<SyncMonthlyActivityData> totalDataList = [];
        totalDataList.add(SyncMonthlyActivityData(
            "",
            totalMinList[0].total ?? 0.0,
            Utils.changeDateFormatBasedOnDBDateWithOutTIme(
                totalMinList[0].dateTime ?? DateTime.now()),
            null,
            totalMinList[0].key,
            Constant.totalMinPerDay,
            true,
            totalMinList[0].objectId,notesDayLevel: totalMinList[0].notes ?? ""));
        await Syncing.observationSyncDataTotalMin(totalDataList);
      }


      var modMinList= allDataFromDB.where((element) =>
          element.title == null &&
          element.smileyType == null &&
          element.type == Constant.typeDay
          && element.value1 != null && Utils.changeDateFormatBasedOnDBDateWithOutTIme(
          element.dateTime ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDateWithOutTIme(
          trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].storedDate ?? DateTime.now()
      ) ).toList();
      if(modMinList.isNotEmpty){
        List<SyncMonthlyActivityData> ModDataList = [];
        ModDataList.add(SyncMonthlyActivityData(
            "",
            modMinList[0].value1 ?? 0.0,
            Utils.changeDateFormatBasedOnDBDateWithOutTIme(
                modMinList[0].dateTime ?? DateTime.now()),
            null,
            modMinList[0].key,
            Constant.modMinPerDay,
            true,
            modMinList[0].objectId));
        await Syncing.observationSyncDataModMin(ModDataList);
      }
    }


    if(!kIsWeb) {
      try {
        // HealthFactory health = HealthFactory();
        var permissions = ((Platform.isAndroid)
            ? Utils.getAllHealthTypeAndroid
            : Utils.getAllHealthTypeIos)
            .map((e) => HealthDataAccess.READ_WRITE)
            .toList();
        bool? hasPermissions = await Health().hasPermissions(
            (Platform.isAndroid) ? Utils.getAllHealthTypeAndroid : Utils
                .getAllHealthTypeIos, permissions: permissions);
        if (Platform.isIOS) {
          hasPermissions = Utils.getPermissionHealth();
        }
        if (hasPermissions!) {
          await GetSetHealthData.realTimeExportDataFromHealth();
        }
        Debug.printLog("History permission...$hasPermissions");
      } catch (e) {
        Debug.printLog("Import export issue try catch.....$e");
      }
    }
    update();
  }

  updateSDateAndEDateAfterChangeModVigTotal(String displayLabel,DateTime sDate,DateTime eDate,DateTime finalStartDate
      ,DateTime finalEndDate) async {
    var weekInsertedData = getActivityListData().where((element) =>
    element.type == Constant.typeDaysData && element.title == null && element.smileyType == null
        && element.displayLabel == displayLabel
        && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
        Utils.changeDateFormatBasedOnDBDate(sDate)
        && Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
        Utils.changeDateFormatBasedOnDBDate(eDate)).toList();
    if(weekInsertedData.isNotEmpty){
      if(weekInsertedData[0].key != null){
        weekInsertedData[0].activityStartDate = finalStartDate;
        weekInsertedData[0].activityEndDate = finalEndDate;
        await DataBaseHelper.shared.updateActivityData(weekInsertedData[0]);
      }
    }

    var activityTypeDataList = getActivityListData().where((element) => element.displayLabel ==
        displayLabel && Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
        Utils.changeDateFormatBasedOnDBDate(eDate)
        && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
            Utils.changeDateFormatBasedOnDBDate(sDate)  && element.type == Constant.typeDaysData
        && element.title == Constant.titleActivityType).toList();
    if(activityTypeDataList.isNotEmpty){
      if(activityTypeDataList[0].key != null){
        activityTypeDataList[0].activityStartDate = finalStartDate;
        activityTypeDataList[0].activityEndDate = finalEndDate;
        await DataBaseHelper.shared.updateActivityData(activityTypeDataList[0]);
      }
      await DataBaseHelper.shared.updateActivityData(
          activityTypeDataList[0]);
    }

    var activityCaloriesData = getActivityListData().where((element) => element.displayLabel ==
        displayLabel &&Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
        Utils.changeDateFormatBasedOnDBDate(eDate)
        && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
            Utils.changeDateFormatBasedOnDBDate(sDate)&&
        element.type == Constant.typeDaysData
        && element.title == Constant.titleCalories).toList();
    if(activityCaloriesData.isNotEmpty){
      if(activityCaloriesData[0].key != null){
        activityCaloriesData[0].activityStartDate = finalStartDate;
        activityCaloriesData[0].activityEndDate = finalEndDate;
        await DataBaseHelper.shared.updateActivityData(activityCaloriesData[0]);
      }
      await DataBaseHelper.shared.updateActivityData(
          activityCaloriesData[0]);
    }

    var activityPeakHeartRate = getActivityListData().where((element) => element.displayLabel ==
        displayLabel && Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
        Utils.changeDateFormatBasedOnDBDate(eDate)
        && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
            Utils.changeDateFormatBasedOnDBDate(sDate) && element.type == Constant.typeDaysData
        && element.title == Constant.titleHeartRatePeak).toList();
    if(activityPeakHeartRate.isNotEmpty){
      if(activityPeakHeartRate[0].key != null){
        activityPeakHeartRate[0].activityStartDate = finalStartDate;
        activityPeakHeartRate[0].activityEndDate = finalEndDate;
        await DataBaseHelper.shared.updateActivityData(activityPeakHeartRate[0]);
      }
      await DataBaseHelper.shared.updateActivityData(
          activityPeakHeartRate[0]);
    }

    var activityRestHeartRate = getActivityListData().where((element) => element.displayLabel ==
        displayLabel && Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
        Utils.changeDateFormatBasedOnDBDate(eDate)
        && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
            Utils.changeDateFormatBasedOnDBDate(sDate) && element.type == Constant.typeDaysData
        && element.title == Constant.titleHeartRateRest).toList();
    if(activityRestHeartRate.isNotEmpty){
      if(activityRestHeartRate[0].key != null){
        activityRestHeartRate[0].activityStartDate = finalStartDate;
        activityRestHeartRate[0].activityEndDate = finalEndDate;
        await DataBaseHelper.shared.updateActivityData(activityRestHeartRate[0]);
      }
      await DataBaseHelper.shared.updateActivityData(
          activityRestHeartRate[0]);
    }

    var activityStepsData = getActivityListData().where((element) => element.displayLabel ==
        displayLabel && Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
        Utils.changeDateFormatBasedOnDBDate(eDate)
        && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
            Utils.changeDateFormatBasedOnDBDate(sDate) && element.type == Constant.typeDaysData
        && element.title == Constant.titleSteps).toList();
    if(activityStepsData.isNotEmpty){
      if(activityStepsData[0].key != null){
        activityStepsData[0].activityStartDate = finalStartDate;
        activityStepsData[0].activityEndDate = finalEndDate;
        await DataBaseHelper.shared.updateActivityData(activityStepsData[0]);
      }
      await DataBaseHelper.shared.updateActivityData(
          activityStepsData[0]);
    }

    var activityStrDays = getActivityListData().where((element) => element.displayLabel ==
        displayLabel && Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
        Utils.changeDateFormatBasedOnDBDate(eDate)
        && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
            Utils.changeDateFormatBasedOnDBDate(sDate) && element.type == Constant.typeDaysData
        && element.title == Constant.titleDaysStr).toList();
    if(activityStrDays.isNotEmpty){
      if(activityStrDays[0].key != null){
        activityStrDays[0].activityStartDate = finalStartDate;
        activityStrDays[0].activityEndDate = finalEndDate;
        await DataBaseHelper.shared.updateActivityData(activityStrDays[0]);
      }
      await DataBaseHelper.shared.updateActivityData(
          activityStrDays[0]);
    }

    var activityEx = getActivityListData().where((element) => element.displayLabel ==
        displayLabel && Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
        Utils.changeDateFormatBasedOnDBDate(eDate)
        && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
            Utils.changeDateFormatBasedOnDBDate(sDate) && element.type == Constant.typeDaysData
        && element.title == null && element.smileyType != null).toList();
    if(activityEx.isNotEmpty){
      if(activityEx[0].key != null){
        activityEx[0].activityStartDate = finalStartDate;
        activityEx[0].activityEndDate = finalEndDate;
        await DataBaseHelper.shared.updateActivityData(activityEx[0]);
      }
      await DataBaseHelper.shared.updateActivityData(
          activityEx[0]);
    }

    var activityParentListData = getActivityListData().where((element) => element.displayLabel ==
        displayLabel  &&  Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
        Utils.changeDateFormatBasedOnDBDate(eDate)
        && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
            Utils.changeDateFormatBasedOnDBDate(sDate) && element.type == Constant.typeDaysData
        && element.title == Constant.titleParent).toList();
    if(activityParentListData.isNotEmpty){
      if(activityParentListData[0].key != null){
        activityParentListData[0].activityStartDate = finalStartDate;
        activityParentListData[0].activityEndDate = finalEndDate;
        await DataBaseHelper.shared.updateActivityData(activityParentListData[0]);
      }
      await DataBaseHelper.shared.updateActivityData(
          activityParentListData[0]);
    }


  }

  Future<void> onChangeActivityMinVigDayData(int mainIndex,int daysIndex,int daysDataIndex,dynamic value) async {
    var oldTotalMin = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
        .activityLevelDataList[daysDataIndex].totalMinValue;

    var oldModMin = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
        .activityLevelDataList[daysDataIndex].modMinValue;

    var oldVigMin = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
        .activityLevelDataList[daysDataIndex].vigMinValue;

    var startDate = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex]
        .activityStartDate;
    if(oldTotalMin != null) {
      var finalActivityEndDate = DateTime.now();
      if(oldModMin == null){
        finalActivityEndDate = startDate.add(Duration(
            minutes: int.parse(value)));
      }else if(oldModMin != null && value != null){
        finalActivityEndDate = startDate.add(Duration(
            minutes: (int.parse(value) + int.parse(oldModMin.toString()))));
      }
      /*var finalActivityEndDate = startDate.add(Duration(
          minutes: (int.parse(value) + int.parse(oldTotalMin.toString()))));*/

      var listOfLastData = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
          .activityLevelDataList;

      var dataIsInWithoutAnotherData = Utils.checkDateOverlap(listOfLastData,
          startDate,finalActivityEndDate,currentActivityData: trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
              .activityLevelDataList[daysDataIndex]);

      if (dataIsInWithoutAnotherData) {
        Utils.showToast(Get.context!, "You have to enter valid min");
        if ((oldVigMin ?? 0) > 0) {
          trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
              .activityLevelDataList[daysDataIndex].vigMinValue = oldVigMin;
          trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
              .activityLevelDataList[daysDataIndex].vigMinController.text = oldVigMin.toString();
        }else{
          trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
              .activityLevelDataList[daysDataIndex].vigMinValue = 0;
          trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
              .activityLevelDataList[daysDataIndex].vigMinController.text = "0";
        }
        update();
        return;
      }

      var displayLabel = trackingChartDataList[mainIndex]
          .dayLevelDataList[daysIndex]
          .activityLevelDataList[daysDataIndex]
          .displayLabel;

      var endActivityDate = trackingChartDataList[mainIndex]
          .dayLevelDataList[daysIndex]
          .activityLevelDataList[daysDataIndex]
          .activityEndDate;

      var checkDateOverlap = Utils.checkDateOverlap(listOfLastData,
          startDate,endActivityDate,currentActivityData: trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
              .activityLevelDataList[daysDataIndex]);
      Debug.printLog("Total min......${startDate.isBefore(endActivityDate) && !checkDateOverlap}");

      // if(startDate.isBefore(endActivityDate) && !checkDateOverlap && !kIsWeb && Platform.isIOS){
      if(startDate.isBefore(endActivityDate) && !checkDateOverlap && !kIsWeb){
        try {
          // HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
          var permissions = ( (Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthTypeIos).map((e) => HealthDataAccess.READ_WRITE).toList();
          bool? hasPermissions = await Health().hasPermissions((Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthTypeIos, permissions: permissions);
          if (Platform.isIOS) {
            hasPermissions = Utils.getPermissionHealth();
          }
          Debug.printLog("hasPermissions...$hasPermissions");
          if(hasPermissions!) {
            var deletedData = await Utils.deleteWorkout(
                startDate, endActivityDate, Health());

            HealthWorkoutActivityType workoutType =
                HealthWorkoutActivityType.OTHER;
            var getTypeFromName = (Platform.isAndroid) ? Utils
                .workOutDataListAndroid : Utils.workOutDataListIos
                .where((element) => element.workOutDataName == displayLabel)
                .toList();

            if (getTypeFromName.isNotEmpty) {
              workoutType = getTypeFromName[0].datatype;
            } else {
              workoutType = HealthWorkoutActivityType.OTHER;
            }


            var checkDateOverlap = Utils.checkDateOverlap(listOfLastData,
                startDate,finalActivityEndDate,currentActivityData: trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
                    .activityLevelDataList[daysDataIndex]);

            if(startDate.isBefore(finalActivityEndDate) && !checkDateOverlap){
              try {
                // HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
                var permissions = ( (Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthTypeIos).map((e) => HealthDataAccess.READ_WRITE).toList();
                bool? hasPermissions = await Health().hasPermissions((Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthTypeIos, permissions: permissions);
                if (Platform.isIOS) {
                  hasPermissions = Utils.getPermissionHealth();
                }
                HealthWorkoutActivityType workoutType =
                    HealthWorkoutActivityType.OTHER;
               /* var getTypeFromName = (kIsWeb)?Utils.workOutDataListAndroid:(Platform.isAndroid)?Utils.workOutDataListAndroid:Utils.workOutDataListIos
                    .where((element) => element.workOutDataName == displayLabel)
                    .toList();*/
                List<WorkOutData> getTypeFromName = [];

                if (Platform.isAndroid) {
                  getTypeFromName = Utils.workOutDataListAndroid
                      .where((element) => element.workOutDataName == displayLabel)
                      .toList();
                } else if (Platform.isIOS) {
                  getTypeFromName = Utils.workOutDataListIos
                      .where((element) => element.workOutDataName == displayLabel)
                      .toList();
                }

                if (getTypeFromName.isNotEmpty) {
                  workoutType = getTypeFromName[0].datatype;
                } else {
                  workoutType = HealthWorkoutActivityType.OTHER;
                }
                var value = caloriesDataList[mainIndex].daysList[daysIndex]
                    .daysDataList[daysDataIndex].total;
                Debug.printLog("workoutType...$workoutType  $displayLabel  $value");
                if(Utils.getPermissionHealth()) {
                  await GetSetHealthData.insertActivityIntoAppleGoogleSync(
                      displayLabel, startDate, finalActivityEndDate,
                      workoutType, value.toString());
                }
              } catch (e) {
                Debug.printLog(e.toString());
              }
            }

          }
        } catch (e) {
          Debug.printLog(e.toString());
        }
      }


      var sDate = trackingChartDataList[mainIndex]
          .dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].activityStartDate;
      var eDate = trackingChartDataList[mainIndex]
          .dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].activityEndDate;

      var displayName = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
          .activityLevelDataList[daysDataIndex].displayLabel;

      await updateSDateAndEDateAfterChangeModVigTotal(displayName,sDate,eDate,startDate,finalActivityEndDate);

      trackingChartDataList[mainIndex]
          .dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].activityStartDate = startDate;
      trackingChartDataList[mainIndex]
          .dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].activityEndDate = finalActivityEndDate;
    }

    if(value == ""){
      trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].vigMinValue = 0;
      trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].vigMinController.text = "";
    }else {
      trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].vigMinValue = int.parse(value);
      trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].vigMinController.text = value;
    }

    trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].vigMinController.selection =
        TextSelection.fromPosition(TextPosition(offset: value.length));

    if(trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].modMinValue == null &&
        trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].vigMinValue == null){
      trackingChartDataList[mainIndex]
          .dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex]
          .totalMinController
          .text = "0";
      trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
          .activityLevelDataList[daysDataIndex].totalMinValue = 0;
    }else {
      var value1 = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
          .activityLevelDataList[daysDataIndex].modMinValue ?? 0;
      var value2 = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
          .activityLevelDataList[daysDataIndex].vigMinValue ?? 0;
      trackingChartDataList[mainIndex]
          .dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex]
          .totalMinController
          .text = (value1 + value2)
          .toString();
      trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
          .activityLevelDataList[daysDataIndex].totalMinValue = (value1 + value2);
    }

    await insertUpdateWeekDayInnerData(mainIndex,daysIndex,daysDataIndex);

    var value1TotalCount = 0;
    var value2TotalCount = 0;
    var totalValueCount = 0;
    for (int a = 0;
    a < trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList.length;
    a++) {
      if (trackingChartDataList[mainIndex]
          .dayLevelDataList[daysIndex]
          .activityLevelDataList[a]
          .modMinValue ==
          null) {
        // value1TotalCount += 0;
      } else {
        value1TotalCount += trackingChartDataList[mainIndex]
            .dayLevelDataList[daysIndex]
            .activityLevelDataList[a]
            .modMinValue!;
      }

      if (trackingChartDataList[mainIndex]
          .dayLevelDataList[daysIndex]
          .activityLevelDataList[a]
          .vigMinValue ==
          null) {
        // value2TotalCount += 0;
      } else {
        value2TotalCount += trackingChartDataList[mainIndex]
            .dayLevelDataList[daysIndex]
            .activityLevelDataList[a]
            .vigMinValue!;
      }

      if (trackingChartDataList[mainIndex]
          .dayLevelDataList[daysIndex]
          .activityLevelDataList[a]
          .totalMinValue ==
          null) {
        // totalValueCount += 0;
      } else {
        totalValueCount += trackingChartDataList[mainIndex]
            .dayLevelDataList[daysIndex]
            .activityLevelDataList[a]
            .totalMinValue!;
      }
    }
    Debug.printLog("value1TotalCount.....$value1TotalCount  $value2TotalCount  $totalValueCount");
    // onChangeActivityMinModDay(mainIndex,daysIndex,value1TotalCount.toString(),false);
    onChangeActivityMinVigDay(mainIndex,daysIndex,value2TotalCount.toString(),false);
    onChangeActivityMiTotalDays(mainIndex,daysIndex,totalValueCount.toString(),false);

   /* var activityDataTableList = getActivityListData();
    var vigMinData = activityDataTableList
        .where((element) =>
    element.date ==  trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].date &&
        element.type == Constant.typeDaysData &&
        element.title == null &&
        element.smileyType == null &&
        element.value2 != null &&
        element.displayLabel ==
            trackingChartDataList[mainIndex]
                .dayLevelDataList[daysIndex]
                .activityLevelDataList[daysDataIndex]
                .displayLabel  &&
        element.activityStartDate ==
            trackingChartDataList[mainIndex]
                .dayLevelDataList[daysIndex]
                .activityLevelDataList[daysDataIndex]
                .activityStartDate &&
        element.activityEndDate ==
            trackingChartDataList[mainIndex]
                .dayLevelDataList[daysIndex]
                .activityLevelDataList[daysDataIndex]
                .activityEndDate)
        .toList();

    if(vigMinData.isNotEmpty) {
      if((vigMinData[0].value2 ?? 0.0) > 0.0 && vigMinData[0].value2 != null) {
        await Syncing.createChildActivityVigMinObservation(
            trackingChartDataList[mainIndex]
                .dayLevelDataList[daysIndex]
                .activityLevelDataList[daysDataIndex]
                .displayLabel,
            vigMinData[0]);
      }

      var totalMinData = getActivityListData()
          .where((element) =>
      element.date ==  trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].date &&
          element.type == Constant.typeDaysData &&
          element.title == null &&
          element.smileyType == null &&
          element.total != null &&
          element.displayLabel ==
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .displayLabel  &&
          element.activityStartDate ==
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .activityStartDate &&
          element.activityEndDate ==
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .activityEndDate)
          .toList();
      if((totalMinData[0].total ?? 0.0) > 0.0 && totalMinData[0].total != null) {
        await Syncing.createChildActivityTotalMinObservation(
            trackingChartDataList[mainIndex]
                .dayLevelDataList[daysIndex]
                .activityLevelDataList[daysDataIndex]
                .displayLabel,
            totalMinData[0]);
      }


      var activityDataTableList = getActivityListData();
      if(activityDataTableList.isNotEmpty) {
        var findParentRecordActivity = activityDataTableList
            .where((element) =>
        element.date == trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].date &&
            element.type == Constant.typeDaysData &&
            element.title == Constant.titleParent &&
            element.displayLabel ==
                trackingChartDataList[mainIndex]
                    .dayLevelDataList[daysIndex]
                    .activityLevelDataList[daysDataIndex]
                    .displayLabel  &&
            element.activityStartDate ==
                trackingChartDataList[mainIndex]
                    .dayLevelDataList[daysIndex]
                    .activityLevelDataList[daysDataIndex]
                    .activityStartDate &&
            element.activityEndDate ==
                trackingChartDataList[mainIndex]
                    .dayLevelDataList[daysIndex]
                    .activityLevelDataList[daysDataIndex]
                    .activityEndDate)
            .toList();
        if(findParentRecordActivity.isNotEmpty) {
          Syncing.createParentActivityObservation(
              findParentRecordActivity[0]);
        }
      }
    }*/

    var displayName = trackingChartDataList[mainIndex]
        .dayLevelDataList[daysIndex]
        .activityLevelDataList[daysDataIndex]
        .displayLabel;

    var sDate = trackingChartDataList[mainIndex]
        .dayLevelDataList[daysIndex]
        .activityLevelDataList[daysDataIndex]
        .activityStartDate;

    var eDate = trackingChartDataList[mainIndex]
        .dayLevelDataList[daysIndex]
        .activityLevelDataList[daysDataIndex]
        .activityEndDate;


    await updateEndTime(displayName,startDate,eDate,eDate);

    var activityDataTableList = getActivityListData();
    var totalMinData = activityDataTableList
        .where((element) =>
        element.type == Constant.typeDaysData &&
        element.title == null &&
        element.smileyType == null &&
        element.total != null &&
        element.displayLabel == displayName &&
        element.activityStartDate == sDate &&
        element.activityEndDate == eDate)
        .toList();

    if(totalMinData.isNotEmpty) {
      if((totalMinData[0].total ?? 0.0) > 0.0 && totalMinData[0].total != null) {
        await Syncing.createChildActivityTotalMinObservation(
            displayName,
            totalMinData[0]);
      }

      var modMinData =  getActivityListData()
          .where((element) =>
      element.type == Constant.typeDaysData &&
          element.title == null &&
          element.smileyType == null &&
          element.value1 != null &&
          element.displayLabel ==
              displayName  &&
          element.activityStartDate ==
              sDate &&
          element.activityEndDate ==
              eDate)
          .toList();
      if(modMinData.isNotEmpty){
        if((modMinData[0].value1 ?? 0.0) > 0.0 && modMinData[0].value1 != null) {
          await Syncing.createChildActivityModerateMinObservation(
              displayName,
              modMinData[0]);
        }
      }

      var vigMinData =  getActivityListData()
          .where((element) =>
      element.type == Constant.typeDaysData &&
          element.title == null &&
          element.smileyType == null &&
          element.value2 != null &&
          element.displayLabel ==
              displayName  &&
          element.activityStartDate ==
              sDate &&
          element.activityEndDate ==
              eDate)
          .toList();
      if(vigMinData.isNotEmpty){
        if((vigMinData[0].value2 ?? 0.0) > 0.0 && vigMinData[0].value2 != null) {
          await Syncing.createChildActivityVigMinObservation(
              displayName,
              vigMinData[0]);
        }
      }

      var peakHeartRateData = getActivityListData()
          .where((element) =>
      element.type == Constant.typeDaysData &&
          element.title == Constant.titleHeartRatePeak &&
          element.displayLabel ==
              displayName &&
          element.activityStartDate ==
              sDate &&
          element.activityEndDate ==
              eDate)
          .toList();
      if(peakHeartRateData.isNotEmpty) {
        if((peakHeartRateData[0].total ?? 0.0) > 0.0 && peakHeartRateData[0].total != null) {
          await Syncing.createChildActivityPeakHeatRateObservation(
              displayName,
              peakHeartRateData[0]);
        }
      }

      var caloriesData = getActivityListData()
          .where((element) =>
      element.type == Constant.typeDaysData &&
          element.title == Constant.titleCalories &&
          element.displayLabel ==
              displayName &&
          element.activityStartDate ==
              sDate &&
          element.activityEndDate ==
              eDate)
          .toList();
      if(caloriesData.isNotEmpty) {
        if((caloriesData[0].total ?? 0.0) > 0.0 && caloriesData[0].total != null) {
          await Syncing.createChildActivityCaloriesObservation(
              displayName,
              caloriesData[0]);
        }
      }

      var activityTypeDataList = getActivityListData()
          .where((element) =>
      element.type == Constant.typeDaysData &&
          element.title == Constant.titleActivityType &&
          element.displayLabel ==
              displayName &&
          element.activityStartDate ==
              sDate &&
          element.activityEndDate ==
              eDate)
          .toList();
      if(activityTypeDataList.isNotEmpty){
        await Syncing.createChildActivityNameObservation(
            displayName,
            activityTypeDataList[0]);
      }

      var activityDataTableList = getActivityListData();
      if(activityDataTableList.isNotEmpty) {
        var findParentRecordActivity = activityDataTableList
            .where((element) =>
        element.date == trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].date &&
            element.type == Constant.typeDaysData &&
            element.title == Constant.titleParent &&
            element.displayLabel ==
                displayName  &&
            element.activityStartDate ==
                sDate &&
            element.activityEndDate ==
                eDate)
            .toList();
        if(findParentRecordActivity.isNotEmpty) {
          Syncing.createParentActivityObservation(
              findParentRecordActivity[0]);
        }
      }

      var allDataFromDB = getActivityListData();
      var totalMinList= allDataFromDB.where((element) =>
      element.title == null &&
          element.smileyType == null &&
          element.type == Constant.typeDay && element.total != null && Utils.changeDateFormatBasedOnDBDateWithOutTIme(
          element.dateTime ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDateWithOutTIme(
          trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].storedDate ?? DateTime.now()
      ) ).toList();
      if(totalMinList.isNotEmpty){
        List<SyncMonthlyActivityData> totalDataList = [];
        totalDataList.add(SyncMonthlyActivityData(
            "",
            totalMinList[0].total ?? 0.0,
            Utils.changeDateFormatBasedOnDBDateWithOutTIme(
                totalMinList[0].dateTime ?? DateTime.now()),
            null,
            totalMinList[0].key,
            Constant.totalMinPerDay,
            true,
            totalMinList[0].objectId,notesDayLevel: totalMinList[0].notes ?? ""));
        await Syncing.observationSyncDataTotalMin(totalDataList);
      }


      var vigMinList= allDataFromDB.where((element) =>
          element.title == null &&
          element.smileyType == null &&
          element.type == Constant.typeDay && element.value2 != null && Utils.changeDateFormatBasedOnDBDateWithOutTIme(
          element.dateTime ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDateWithOutTIme(
          trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].storedDate ?? DateTime.now()
      ) ).toList();
      if(vigMinList.isNotEmpty){
        List<SyncMonthlyActivityData> vigDataList = [];
        vigDataList.add(SyncMonthlyActivityData(
            "",
            vigMinList[0].value2 ?? 0.0,
            Utils.changeDateFormatBasedOnDBDateWithOutTIme(
                vigMinList[0].dateTime ?? DateTime.now()),
            null,
            vigMinList[0].key,
            Constant.vigMinPerDay,
            true,
            vigMinList[0].objectId));
        await Syncing.observationSyncDataVigMin(vigDataList);
      }
    }

    if(!kIsWeb) {
      try {
        // HealthFactory health = HealthFactory();
        var permissions = ((Platform.isAndroid)
            ? Utils.getAllHealthTypeAndroid
            : Utils.getAllHealthTypeIos)
            .map((e) => HealthDataAccess.READ_WRITE)
            .toList();
        bool? hasPermissions = await Health().hasPermissions(
            (Platform.isAndroid) ? Utils.getAllHealthTypeAndroid : Utils
                .getAllHealthTypeIos, permissions: permissions);
        if (Platform.isIOS) {
          hasPermissions = Utils.getPermissionHealth();
        }
        if (hasPermissions!) {
          await GetSetHealthData.realTimeExportDataFromHealth();
        }
        Debug.printLog("History permission...$hasPermissions");
      } catch (e) {
        Debug.printLog("Import export issue try catch.....$e");
      }
    }
    update();
  }
  Future<void> onChangeActivityMinTotalDaysData(int mainIndex,int daysIndex,int daysDataIndex,dynamic value,
  {bool isManualChanges = false}) async {
    if(kIsWeb){
      // FocusScope.of(Get.context!).requestFocus(new FocusNode());
      FocusScope.of(Get.context!).requestFocus(FocusNode());
    }

    var oldTotalMin = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
        .activityLevelDataList[daysDataIndex].totalMinValue;

    var startDate = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex]
        .activityStartDate;
    var finalActivityEndDate = startDate.add(Duration(minutes: int.parse(value)));

    var listOfLastData = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
        .activityLevelDataList;

 /*   var dataIsInWithoutAnotherData = listOfLastData.where((element) =>
        Utils.isBetween(element.activityStartDate, element.activityEndDate,
            startDate, finalActivityEndDate) && element != listOfLastData[daysDataIndex]
    ).toList().isEmpty;*/

    var dataIsInWithoutAnotherData = Utils.checkDateOverlap(listOfLastData,
        startDate,finalActivityEndDate,currentActivityData: trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
            .activityLevelDataList[daysDataIndex]);

    if(dataIsInWithoutAnotherData){
      Utils.showToast(Get.context!, "You have to enter valid min");
      if((oldTotalMin ?? 0) > 0) {
        trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
            .activityLevelDataList[daysDataIndex].totalMinValue = oldTotalMin;
        trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
            .activityLevelDataList[daysDataIndex].totalMinController.text = oldTotalMin.toString();
      }
      update();
      return;
    }

    var displayLabel = trackingChartDataList[mainIndex]
        .dayLevelDataList[daysIndex]
        .activityLevelDataList[daysDataIndex]
        .displayLabel;

    var endActivityDate = trackingChartDataList[mainIndex]
        .dayLevelDataList[daysIndex]
        .activityLevelDataList[daysDataIndex]
        .activityEndDate;

    var checkDateOverlap = Utils.checkDateOverlap(listOfLastData,
        startDate,finalActivityEndDate,currentActivityData: trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
            .activityLevelDataList[daysDataIndex]);
    Debug.printLog("Total min......${startDate.isBefore(endActivityDate) && !checkDateOverlap}");

    // if(startDate.isBefore(endActivityDate) && !checkDateOverlap && !kIsWeb && Platform.isIOS){
    if(startDate.isBefore(endActivityDate) && !checkDateOverlap && !kIsWeb){
      try {
        // HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
        var permissions = ( (Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthTypeIos).map((e) => HealthDataAccess.READ_WRITE).toList();
        bool? hasPermissions = await Health().hasPermissions((Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthTypeIos, permissions: permissions);
        if (Platform.isIOS) {
          hasPermissions = Utils.getPermissionHealth();
        }
        Debug.printLog("hasPermissions...$hasPermissions");
        if(hasPermissions!) {
          var deletedData = await Utils.deleteWorkout(
              startDate, endActivityDate, Health());

          HealthWorkoutActivityType workoutType =
              HealthWorkoutActivityType.OTHER;
          var getTypeFromName = (Platform.isAndroid) ? Utils
              .workOutDataListAndroid : Utils.workOutDataListIos
              .where((element) => element.workOutDataName == displayLabel)
              .toList();

          if (getTypeFromName.isNotEmpty) {
            workoutType = getTypeFromName[0].datatype;
          } else {
            workoutType = HealthWorkoutActivityType.OTHER;
          }

          var checkDateOverlap = Utils.checkDateOverlap(listOfLastData,
              startDate,finalActivityEndDate,currentActivityData: trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]);

          if(startDate.isBefore(finalActivityEndDate) && !checkDateOverlap){
            try {
              // HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
              var permissions = ( (Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthTypeIos).map((e) => HealthDataAccess.READ_WRITE).toList();
              bool? hasPermissions = await Health().hasPermissions((Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthTypeIos, permissions: permissions);
              if (Platform.isIOS) {
                hasPermissions = Utils.getPermissionHealth();
              }
              HealthWorkoutActivityType workoutType =
                  HealthWorkoutActivityType.OTHER;
              /*var getTypeFromName = (kIsWeb)?Utils.workOutDataListAndroid: (Platform.isAndroid)?Utils.workOutDataListAndroid:Utils.workOutDataListIos
                  .where((element) => element.workOutDataName == displayLabel)
                  .toList();*/
              List<WorkOutData> getTypeFromName = [];

              if (Platform.isAndroid) {
                getTypeFromName = Utils.workOutDataListAndroid
                    .where((element) => element.workOutDataName == displayLabel)
                    .toList();
              } else if (Platform.isIOS) {
                getTypeFromName = Utils.workOutDataListIos
                    .where((element) => element.workOutDataName == displayLabel)
                    .toList();
              }

              if (getTypeFromName.isNotEmpty) {
                workoutType = getTypeFromName[0].datatype;
              } else {
                workoutType = HealthWorkoutActivityType.OTHER;
              }
              var value = caloriesDataList[mainIndex].daysList[daysIndex]
                  .daysDataList[daysDataIndex].total;
              Debug.printLog("workoutType...$workoutType  $displayLabel  $value");
              if(Utils.getPermissionHealth()) {
                await GetSetHealthData.insertActivityIntoAppleGoogleSync(
                    displayLabel, startDate, finalActivityEndDate,
                    workoutType, value.toString());
              }
            } catch (e) {
              Debug.printLog(e.toString());
            }
          }

        }
      } catch (e) {
        Debug.printLog("Delete workout error....$e");
      }
    }


    if(value == ""){
      trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].totalMinValue = 0;
    }else{
      trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].totalMinValue =
          int.parse(value);
    }

    var activityTableData = getActivityListData();

    List<ActivityTable> foundedList = activityTableData.where((element) => element.type == Constant.typeDay &&
        element.dateTime ==
            trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].storedDate  && element.smileyType == null && element.title == null &&
        element.isOverride).toList();

    if(foundedList.isNotEmpty){
      if(!(Preference.shared.getBool(Preference.isAutoCalMode) ?? false)) {
        await showAlertDialogForOverrideActivityData(
            Constant.typeDaysData, foundedList, mainIndex, daysIndex, value,
            daysDataIndex,isManualChanges: isManualChanges);
      }else{
        await activityMinDayDataLevelInsertUpdateData(mainIndex,daysIndex,daysDataIndex,value,
            isManualChanges:false);
      }
    }else{
      await activityMinDayDataLevelInsertUpdateData(mainIndex,daysIndex,daysDataIndex,value,
          isManualChanges:false);
    }



    var allDataFromDB = getActivityListData();
    var activityMinDataList = allDataFromDB
        .where((element) =>
        element.type == Constant.typeDaysData &&
        element.title == null &&
        element.smileyType == null &&
        element.displayLabel == displayLabel &&
            Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
        Utils.changeDateFormatBasedOnDBDate(startDate)&&
        Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
            Utils.changeDateFormatBasedOnDBDate(endActivityDate))
        .toList();
    if(activityMinDataList.isNotEmpty) {
      if (activityMinDataList[0].key != null) {
        activityMinDataList[0].total = double.parse(value);
        activityMinDataList[0].activityStartDate = startDate;
        activityMinDataList[0].activityEndDate = finalActivityEndDate;
        await DataBaseHelper.shared.updateActivityData(activityMinDataList[0]);
      }
    }



    trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex]
        .activityEndDate = finalActivityEndDate;

    await updateEndTime(displayLabel,startDate,endActivityDate,finalActivityEndDate);

    var activityDataTableList = getActivityListData();
    var totalMinData = activityDataTableList
        .where((element) =>
    element.date ==
        trackingChartDataList[mainIndex]
            .dayLevelDataList[daysIndex]
            .date &&
        element.type == Constant.typeDaysData &&
        element.title == null &&
        element.smileyType == null &&
        element.total != null &&
        element.displayLabel ==
            trackingChartDataList[mainIndex]
                .dayLevelDataList[daysIndex]
                .activityLevelDataList[daysDataIndex]
                .displayLabel &&
        element.activityStartDate ==
            trackingChartDataList[mainIndex]
                .dayLevelDataList[daysIndex]
                .activityLevelDataList[daysDataIndex]
                .activityStartDate &&
        element.activityEndDate ==
            trackingChartDataList[mainIndex]
                .dayLevelDataList[daysIndex]
                .activityLevelDataList[daysDataIndex]
                .activityEndDate)
        .toList();

    if(totalMinData.isNotEmpty) {
      if((totalMinData[0].total ?? 0.0) > 0.0 && totalMinData[0].total != null) {
        await Syncing.createChildActivityTotalMinObservation(
            trackingChartDataList[mainIndex]
                .dayLevelDataList[daysIndex]
                .activityLevelDataList[daysDataIndex]
                .displayLabel,
            totalMinData[0]);
      }

      var modMinData =  getActivityListData()
          .where((element) =>
          element.type == Constant.typeDaysData &&
          element.title == null &&
          element.smileyType == null &&
          element.value1 != null &&
          element.displayLabel ==
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .displayLabel  &&
          element.activityStartDate ==
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .activityStartDate &&
          element.activityEndDate ==
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .activityEndDate)
          .toList();
      if(modMinData.isNotEmpty){
        if((modMinData[0].value1 ?? 0.0) > 0.0 && modMinData[0].value1 != null) {
          await Syncing.createChildActivityModerateMinObservation(
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .displayLabel,
              modMinData[0]);
        }
      }

      var vigMinData =  getActivityListData()
          .where((element) =>
      element.type == Constant.typeDaysData &&
          element.title == null &&
          element.smileyType == null &&
          element.value2 != null &&
          element.displayLabel ==
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .displayLabel  &&
          element.activityStartDate ==
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .activityStartDate &&
          element.activityEndDate ==
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .activityEndDate)
          .toList();
      if(vigMinData.isNotEmpty){
        if((vigMinData[0].value2 ?? 0.0) > 0.0 && vigMinData[0].value2 != null) {
          await Syncing.createChildActivityVigMinObservation(
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .displayLabel,
              vigMinData[0]);
        }
      }

      var peakHeartRateData = getActivityListData()
          .where((element) =>
          element.type == Constant.typeDaysData &&
          element.title == Constant.titleHeartRatePeak &&
          element.displayLabel ==
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .displayLabel &&
          element.activityStartDate ==
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .activityStartDate &&
          element.activityEndDate ==
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .activityEndDate)
          .toList();
      if(peakHeartRateData.isNotEmpty) {
        if((peakHeartRateData[0].total ?? 0.0) > 0.0 && peakHeartRateData[0].total != null) {
          await Syncing.createChildActivityPeakHeatRateObservation(
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .displayLabel,
              peakHeartRateData[0]);
        }
      }

      var caloriesData = getActivityListData()
          .where((element) =>
          element.type == Constant.typeDaysData &&
          element.title == Constant.titleCalories &&
          element.displayLabel ==
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .displayLabel &&
          element.activityStartDate ==
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .activityStartDate &&
          element.activityEndDate ==
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .activityEndDate)
          .toList();
      if(caloriesData.isNotEmpty) {
        if((caloriesData[0].total ?? 0.0) > 0.0 && caloriesData[0].total != null) {
          await Syncing.createChildActivityCaloriesObservation(
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .displayLabel,
              caloriesData[0]);
        }
      }

      var activityTypeDataList = getActivityListData()
          .where((element) =>
      element.type == Constant.typeDaysData &&
          element.title == Constant.titleActivityType &&
          element.displayLabel ==
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .displayLabel &&
          element.activityStartDate ==
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .activityStartDate &&
          element.activityEndDate ==
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .activityEndDate)
          .toList();
      if(activityTypeDataList.isNotEmpty){
          await Syncing.createChildActivityNameObservation(
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .displayLabel,
              activityTypeDataList[0]);
      }

      var activityDataTableList = getActivityListData();
      if(activityDataTableList.isNotEmpty) {
        var findParentRecordActivity = activityDataTableList
            .where((element) =>
        element.date == trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].date &&
            element.type == Constant.typeDaysData &&
            element.title == Constant.titleParent &&
            element.displayLabel ==
                trackingChartDataList[mainIndex]
                    .dayLevelDataList[daysIndex]
                    .activityLevelDataList[daysDataIndex]
                    .displayLabel  &&
            element.activityStartDate ==
                trackingChartDataList[mainIndex]
                    .dayLevelDataList[daysIndex]
                    .activityLevelDataList[daysDataIndex]
                    .activityStartDate &&
            element.activityEndDate ==
                trackingChartDataList[mainIndex]
                    .dayLevelDataList[daysIndex]
                    .activityLevelDataList[daysDataIndex]
                    .activityEndDate)
            .toList();
        if(findParentRecordActivity.isNotEmpty) {
          Syncing.createParentActivityObservation(
              findParentRecordActivity[0]);
        }
      }

      var totalMinList= allDataFromDB.where((element) =>
          element.title == null &&
          element.smileyType == null &&
          element.type == Constant.typeDay && element.total != null && Utils.changeDateFormatBasedOnDBDateWithOutTIme(
          element.dateTime ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDateWithOutTIme(
          trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].storedDate ?? DateTime.now()
      ) ).toList();
      if(totalMinList.isNotEmpty){
        List<SyncMonthlyActivityData> totalDataList = [];
        totalDataList.add(SyncMonthlyActivityData(
            "",
            totalMinList[0].total ?? 0.0,
            Utils.changeDateFormatBasedOnDBDateWithOutTIme(
                totalMinList[0].dateTime ?? DateTime.now()),
            null,
            totalMinList[0].key,
            Constant.totalMinPerDay,
            true,
            totalMinList[0].objectId,notesDayLevel: totalMinList[0].notes ?? ""));
        await Syncing.observationSyncDataTotalMin(totalDataList);
      }
    }
    if(!kIsWeb) {
      try {
        // HealthFactory health = HealthFactory();
        var permissions = ((Platform.isAndroid)
            ? Utils.getAllHealthTypeAndroid
            : Utils.getAllHealthTypeIos)
            .map((e) => HealthDataAccess.READ_WRITE)
            .toList();
        bool? hasPermissions = await Health().hasPermissions(
            (Platform.isAndroid) ? Utils.getAllHealthTypeAndroid : Utils
                .getAllHealthTypeIos, permissions: permissions);
        if (Platform.isIOS) {
          hasPermissions = Utils.getPermissionHealth();
        }
        if (hasPermissions!) {
          await GetSetHealthData.realTimeExportDataFromHealth();
        }
        Debug.printLog("History permission...$hasPermissions");
      } catch (e) {
        Debug.printLog("Import export issue try catch.....$e");
      }
    }
    update();
  }

  updateEndTime(String displayLabel, DateTime startDateActivity, DateTime endActivityDate, DateTime finalActivityEndDate) async {
    var activityTypeDataList = getActivityListData().where((element) => element.displayLabel ==
        displayLabel && Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
        Utils.changeDateFormatBasedOnDBDate(endActivityDate)
        && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
            Utils.changeDateFormatBasedOnDBDate(startDateActivity)  && element.type == Constant.typeDaysData
        && element.title == Constant.titleActivityType).toList();
    if(activityTypeDataList.isNotEmpty){
      if(activityTypeDataList[0].key != null) {
        activityTypeDataList[0].activityStartDate = startDateActivity;
        activityTypeDataList[0].activityEndDate = finalActivityEndDate;
        await DataBaseHelper.shared.updateActivityData(
            activityTypeDataList[0]);
      }
    }

    var activityCaloriesData = getActivityListData().where((element) => element.displayLabel ==
        displayLabel &&
        Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
            Utils.changeDateFormatBasedOnDBDate(endActivityDate)
        && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
            Utils.changeDateFormatBasedOnDBDate(startDateActivity) && element.type == Constant.typeDaysData
        && element.title == Constant.titleCalories).toList();
    if(activityCaloriesData.isNotEmpty){
      if(activityCaloriesData[0].key != null) {
        activityCaloriesData[0].activityStartDate = startDateActivity;
        activityCaloriesData[0].activityEndDate = finalActivityEndDate;
        await DataBaseHelper.shared.updateActivityData(
            activityCaloriesData[0]);
      }
    }

    var activityPeakHeartRate = getActivityListData().where((element) => element.displayLabel ==
        displayLabel &&
        Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
            Utils.changeDateFormatBasedOnDBDate(endActivityDate)
        && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
            Utils.changeDateFormatBasedOnDBDate(startDateActivity) && element.type == Constant.typeDaysData
        && element.title == Constant.titleHeartRatePeak).toList();
    if(activityPeakHeartRate.isNotEmpty){
      if(activityPeakHeartRate[0].key != null) {
        activityPeakHeartRate[0].activityStartDate = startDateActivity;
        activityPeakHeartRate[0].activityEndDate = finalActivityEndDate;
        await DataBaseHelper.shared.updateActivityData(
            activityPeakHeartRate[0]);
      }
    }

    var activityRestHeartRate = getActivityListData().where((element) => element.displayLabel ==
        displayLabel && Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
        Utils.changeDateFormatBasedOnDBDate(endActivityDate)
        && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
            Utils.changeDateFormatBasedOnDBDate(startDateActivity) && element.type == Constant.typeDaysData
        && element.title == Constant.titleHeartRateRest).toList();
    if(activityRestHeartRate.isNotEmpty){
      if(activityRestHeartRate[0].key != null) {
        activityRestHeartRate[0].activityStartDate = startDateActivity;
        activityRestHeartRate[0].activityEndDate = finalActivityEndDate;
        await DataBaseHelper.shared.updateActivityData(
            activityRestHeartRate[0]);
      }
    }

    var activityStepsData = getActivityListData().where((element) => element.displayLabel ==
        displayLabel && Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
        Utils.changeDateFormatBasedOnDBDate(endActivityDate)
        && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
            Utils.changeDateFormatBasedOnDBDate(startDateActivity) && element.type == Constant.typeDaysData
        && element.title == Constant.titleSteps).toList();
    if(activityStepsData.isNotEmpty){
      if(activityStepsData[0].key != null) {
        activityStepsData[0].activityStartDate = startDateActivity;
        activityStepsData[0].activityEndDate = finalActivityEndDate;
        await DataBaseHelper.shared.updateActivityData(
            activityStepsData[0]);
      }
    }

    var activityStrDays = getActivityListData().where((element) => element.displayLabel ==
        displayLabel && Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
        Utils.changeDateFormatBasedOnDBDate(endActivityDate)
        && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
            Utils.changeDateFormatBasedOnDBDate(startDateActivity) && element.type == Constant.typeDaysData
        && element.title == Constant.titleDaysStr).toList();
    if(activityStrDays.isNotEmpty){
      if(activityStrDays[0].key != null) {
        activityStrDays[0].activityStartDate = startDateActivity;
        activityStrDays[0].activityEndDate = finalActivityEndDate;
        await DataBaseHelper.shared.updateActivityData(
            activityStrDays[0]);
      }
    }

    var activityEx = getActivityListData().where((element) => element.displayLabel ==
        displayLabel && Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
        Utils.changeDateFormatBasedOnDBDate(endActivityDate)
        && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
            Utils.changeDateFormatBasedOnDBDate(startDateActivity) && element.type == Constant.typeDaysData
        && element.title == null && element.smileyType != null).toList();
    if(activityEx.isNotEmpty){
      if(activityEx[0].key != null) {
        activityEx[0].activityStartDate = startDateActivity;
        activityEx[0].activityEndDate = finalActivityEndDate;
        await DataBaseHelper.shared.updateActivityData(
            activityEx[0]);
      }
    }

    var activityParentListData = getActivityListData().where((element) => element.displayLabel ==
        displayLabel  &&  Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
        Utils.changeDateFormatBasedOnDBDate(endActivityDate)
        && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
            Utils.changeDateFormatBasedOnDBDate(startDateActivity) && element.type == Constant.typeDaysData
        && element.title == Constant.titleParent).toList();
    if(activityParentListData.isNotEmpty){
      if(activityParentListData[0].key != null) {
        activityParentListData[0].activityStartDate = startDateActivity;
        activityParentListData[0].activityEndDate = finalActivityEndDate;
        await DataBaseHelper.shared.updateActivityData(
            activityParentListData[0]);
      }
    }
  }

  activityMinDayDataLevelInsertUpdateData(int mainIndex,int daysIndex,int daysDataIndex,dynamic value,{bool isFromDialog = false,
    bool isManualChanges = false}) async {
    trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].totalMinController.text = (value == "")?"":value.toString();
    trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].totalMinController.selection =
        TextSelection.fromPosition(TextPosition(offset: value.length));
    await insertUpdateWeekDayInnerData(mainIndex,daysIndex,daysDataIndex,isManualChanges:isManualChanges );

    if(!isManualChanges) {
      var value1TotalCount = 0;
      var value2TotalCount = 0;
      var totalValueCount = 0;
      for (int a = 0;
      a < trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
          .activityLevelDataList.length;
      a++) {
        value1TotalCount +=
            trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
                .activityLevelDataList[a].modMinValue ?? 0;
        value2TotalCount +=
            trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
                .activityLevelDataList[a].vigMinValue ?? 0;
        totalValueCount +=
            trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
                .activityLevelDataList[a].totalMinValue ?? 0;
      }
      Debug.printLog(
          "value1TotalCount.....$value1TotalCount  $value2TotalCount  $totalValueCount");
      onChangeActivityMinModDay(
          mainIndex, daysIndex, value1TotalCount.toString(),false,
          isFromDialog: isFromDialog,isManualChanges: isManualChanges);
      onChangeActivityMinVigDay(
          mainIndex, daysIndex, value2TotalCount.toString(),false,
          isFromDialog: isFromDialog,isManualChanges: isManualChanges);
      onChangeActivityMiTotalDays(
          mainIndex, daysIndex, totalValueCount.toString(),false,
          isFromDialog: isFromDialog,isManualChanges: isManualChanges);
    }
  }

  insertUpdateWeekDayInnerData(int mainIndex,int daysIndex,int daysDataIndex,{bool byDefault = false,Function? reCall,
    bool isManualChanges = false,}) async {
    var allDataFromDB = getActivityListData();
    var weekInsertedData = [];
    String formattedDate = "";
    if(allDataFromDB.isNotEmpty) {

      var activityStartDate = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].activityStartDate;
      var activityEndDate = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].activityEndDate;


      formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy).format(
          trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].storedDate!);
      weekInsertedData = allDataFromDB.where((element) =>
      element.date == formattedDate &&
          element.type == Constant.typeDaysData && element.title == null && element.smileyType == null
          && element.displayLabel ==
          trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].displayLabel
      && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
          Utils.changeDateFormatBasedOnDBDate(activityStartDate)
          && Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
          Utils.changeDateFormatBasedOnDBDate(activityEndDate)).toList();
    }

    var insertedId = 0;
    if(weekInsertedData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.isOverride = isManualChanges;
      insertingData.name = "Data ${daysDataIndex+1}";
      insertingData.displayLabel = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].displayLabel.toString();
      insertingData.dateTime = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].storedDate;
      insertingData.date = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].date;
      insertingData.activityStartDate = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].activityStartDate;
      insertingData.activityEndDate = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].activityEndDate;
      insertingData.date = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].date;
      insertingData.title = null;
      insertingData.iconPath =  trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].iconPath.toString();

      var value1 = trackingChartDataList[mainIndex]
          .dayLevelDataList[daysIndex]
          .activityLevelDataList[daysDataIndex]
          .modMinValue;
      if(value1 == null){
        insertingData.value1 = null;
      }else{
        insertingData.value1 = double.parse(value1.toString());
      }

      var value2 =
          trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
              .activityLevelDataList[daysDataIndex].vigMinValue;
      if(value2 == null){
        insertingData.value2 = null;
      }else{
        insertingData.value2 = double.parse(value2.toString());
      }

      var total = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
          .activityLevelDataList[daysDataIndex].totalMinValue;

       // String diff = Utils.getTotalMinFromTwoDates(
       //    insertingData.activityStartDate ?? DateTime.now(), insertingData.activityEndDate?? DateTime.now());

      if(total == null){
        insertingData.total = null;
        // if(kIsWeb){
        //   if(total == null && diff != "0"){
        //     insertingData.total = double.parse(diff.toString());
        //   }
        // }
      }else{
        insertingData.total = double.parse(total.toString());
      }

      insertingData.type = Constant.typeDaysData;

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

      String formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy).format(trackingChartDataList[mainIndex].weekStartDate!);
      String formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy).format(trackingChartDataList[mainIndex].weekEndDate!);
      insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";
      insertedId = await DataBaseHelper.shared.insertActivityData(insertingData);
      Debug.printLog("insertUpdateWeekDayInnerData if......$insertedId");
    }
    else{
      String formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].storedDate!);

      /*var weekInsertedData = allDataFromDB
          .where((element) => element.date == formattedDate &&
          element.type == Constant.typeDaysData  && element.title == null && element.smileyType == null &&
          element.displayLabel == trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
              .activityLevelDataList[daysDataIndex].displayLabel).toList();
      */

      var activityStartDate = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].activityStartDate;
      var activityEndDate = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].activityEndDate;

      var weekInsertedData = allDataFromDB
          .where((element) =>
          element.type == Constant.typeDaysData  && element.title == null && element.smileyType == null &&
          element.displayLabel == trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
              .activityLevelDataList[daysDataIndex].displayLabel &&
              Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
                  Utils.changeDateFormatBasedOnDBDate(activityStartDate)
              && Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
              Utils.changeDateFormatBasedOnDBDate(activityEndDate)).toList();

      if(weekInsertedData.isNotEmpty) {
        if (weekInsertedData[0].key != null) {

          var value1 =
              trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex].modMinValue;
          // weekInsertedData[0].value1 = double.parse(value1.toString());
          if(value1 == null){
            weekInsertedData[0].value1 = null;
          }else{
            weekInsertedData[0].value1 = double.parse(value1.toString());
          }
          weekInsertedData[0].isOverride = isManualChanges;
          weekInsertedData[0].needExport = true;
          var value2 = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
              .activityLevelDataList[daysDataIndex].vigMinValue;
          // weekInsertedData[0].value2 = double.parse(value2.toString());
          if(value2 == null){
            weekInsertedData[0].value2 = null;
          }else{
            weekInsertedData[0].value2 = double.parse(value2.toString());
          }


          var total =
              trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex].totalMinValue;
          if(total == null){
            weekInsertedData[0].total = null;
          }else{
            weekInsertedData[0].total = double.parse(total.toString());
          }

          var allSelectedServersUrl = Utils.getServerListPreference().where((
              element) => element.patientId != "" && element.isSelected).toList();

          if (weekInsertedData[0].serverDetailList.length !=
              allSelectedServersUrl.length) {
            for (int i = 0; i < allSelectedServersUrl.length; i++) {
              var url = weekInsertedData[0].serverDetailList;
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
                weekInsertedData[0].serverDetailList.add(
                    serverDetail);
              }
            }
          }

          if (weekInsertedData[0].serverDetailListModMin.length !=
              allSelectedServersUrl.length) {
            for (int i = 0; i < allSelectedServersUrl.length; i++) {
              var url = weekInsertedData[0].serverDetailListModMin;
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
                weekInsertedData[0].serverDetailListModMin.add(
                    serverDetail);
              }
            }
          }

          if (weekInsertedData[0].serverDetailListVigMin.length !=
              allSelectedServersUrl.length) {
            for (int i = 0; i < allSelectedServersUrl.length; i++) {
              var url = weekInsertedData[0].serverDetailListVigMin;
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
                weekInsertedData[0].serverDetailListVigMin.add(
                    serverDetail);
              }
            }
          }

          weekInsertedData[0].activityStartDate = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
              .activityLevelDataList[daysDataIndex].activityStartDate;
          weekInsertedData[0].activityEndDate = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
              .activityLevelDataList[daysDataIndex].activityEndDate;
          await DataBaseHelper.shared.updateActivityData(
              weekInsertedData[0]);
        }
      }
    }

    // dummyEntry(mainIndex,daysIndex,daysDataIndex,formattedDate,insertedId,byDefault: byDefault,reCall: reCall);
  }

  /*This is for other editable */
  void onChangeCalStepWeeks(int mainIndex,String value, String titleName) async {
    insertUpdateOtherTitleWeek(mainIndex,titleName,value);
    try {
      if (titleName == Constant.titleCalories) {
        if(value == "" || value == "0"){
          caloriesDataList[mainIndex].total = 0;
          caloriesDataList[mainIndex].weekValueTitleController.text = "";
          caloriesDataList[mainIndex].weekValueTitleController.selection =
              TextSelection.fromPosition(const TextPosition(offset: 0));
        }else{
          caloriesDataList[mainIndex].total = int.parse(value.toString());
          caloriesDataList[mainIndex].weekValueTitleController.text = value;
          caloriesDataList[mainIndex].weekValueTitleController.selection =
              TextSelection.fromPosition(TextPosition(offset: value.length));
        }
        caloriesDataList[mainIndex].isSync = false;

      } else if (titleName == Constant.titleSteps) {
        if(value == "" || value == "0"){
          stepsDataList[mainIndex].total = 0;
          stepsDataList[mainIndex].weekValueTitleController.text = "";
          stepsDataList[mainIndex].weekValueTitleController.selection =
              TextSelection.fromPosition(const TextPosition(offset: 0));
        }else{
          stepsDataList[mainIndex].total = int.parse(value.toString());
          stepsDataList[mainIndex].weekValueTitleController.text = value;
          stepsDataList[mainIndex].weekValueTitleController.selection =
              TextSelection.fromPosition(TextPosition(offset: value.length));
        }
        stepsDataList[mainIndex].isSync = false;

      } else if (titleName == Constant.titleHeartRateRest) {
        if(value == "" || value == "0"){
          heartRateRestDataList[mainIndex].total = 0;
          heartRateRestDataList[mainIndex].weekValue1Title5Title5Controller.text = "";
          heartRateRestDataList[mainIndex].weekValue1Title5Title5Controller.selection =
              TextSelection.fromPosition(const TextPosition(offset: 0));
        }else{
          heartRateRestDataList[mainIndex].total = int.parse(value.toString());
          heartRateRestDataList[mainIndex].weekValue1Title5Title5Controller.text = value;
          heartRateRestDataList[mainIndex].weekValue1Title5Title5Controller.selection =
              TextSelection.fromPosition(TextPosition(offset: value.length));
        }
        heartRateRestDataList[mainIndex].isSync = false;
      } else if (titleName == Constant.titleHeartRatePeak) {
        if(value == "" || value == "0"){
          heartRatePeakDataList[mainIndex].total = 0;
          heartRatePeakDataList[mainIndex].weekValue2Title5Controller.text = "";
          heartRatePeakDataList[mainIndex].weekValue2Title5Controller.selection =
              TextSelection.fromPosition(const TextPosition(offset: 0));
        }else{
          heartRatePeakDataList[mainIndex].total = int.parse(value.toString());
          heartRatePeakDataList[mainIndex].weekValue2Title5Controller.text = value;
          heartRatePeakDataList[mainIndex].weekValue2Title5Controller.selection =
              TextSelection.fromPosition(TextPosition(offset: value.length));
        }
        heartRatePeakDataList[mainIndex].isSync = false;
      }
    } catch (e) {
      Debug.printLog("onChangeCalStepWeeks exception...$e");
    }
    Debug.printLog("onChangeCountOtherWeeks....$mainIndex  $titleName  $value");
    update();
  }

  Future<void> onChangeCalStepHeartDay(int mainIndex,int daysIndex,dynamic value, String titleName, String titleType,
      {String displayLabelName = "", int daysDataIndex = 0,bool isRemove = false,bool isOverride = false}) async {
    insertUpdateCalStepHeartDays(mainIndex, daysIndex, titleName, value,
        displayLabelName: displayLabelName,
        daysDataIndex: daysDataIndex);
    Debug.printLog("onChangeCalStepHeartDay....$mainIndex  $daysIndex  $daysDataIndex  $value  $titleName  $displayLabelName");

      if (titleName == Constant.titleCalories) {
        if(value == ""  || value == "0"){
          caloriesDataList[mainIndex].daysList[daysIndex].total = 0;
          caloriesDataList[mainIndex].daysList[daysIndex].daysValueTitleController.text = "";
          caloriesDataList[mainIndex].daysList[daysIndex].daysValueTitleController.selection =
              TextSelection.fromPosition(const TextPosition(offset: 0));
        }else {
          caloriesDataList[mainIndex].daysList[daysIndex].total =
              int.parse(value.toString());
          caloriesDataList[mainIndex].daysList[daysIndex].daysValueTitleController.text = value;
          caloriesDataList[mainIndex].daysList[daysIndex].daysValueTitleController.selection =
              TextSelection.fromPosition(TextPosition(offset: value.length));
        }
        caloriesDataList[mainIndex].daysList[daysIndex].isSync = false;
        var totalValueCount = 0;
        for (int a = 0; a < caloriesDataList[mainIndex].daysList.length; a++) {
          if(caloriesDataList[mainIndex].daysList[a].total.toString() == "" || caloriesDataList[mainIndex].daysList[a].total == 0){
            totalValueCount += 0;
          }else{
            totalValueCount += caloriesDataList[mainIndex].daysList[a].total;
          }

        }
        onChangeCalStepWeeks(mainIndex,totalValueCount.toString(),titleName);

      }
      else if (titleName == Constant.titleSteps) {
        if(value == "" || value == "0"){
          stepsDataList[mainIndex].daysList[daysIndex].total = 0;
          stepsDataList[mainIndex].daysList[daysIndex].daysValueTitleController.text = "";
          stepsDataList[mainIndex].daysList[daysIndex].daysValueTitleController.selection =
              TextSelection.fromPosition(const TextPosition(offset: 0));
        }else {
          stepsDataList[mainIndex].daysList[daysIndex].total =
              int.parse(value.toString());
          stepsDataList[mainIndex].daysList[daysIndex].daysValueTitleController.text = value;
          stepsDataList[mainIndex].daysList[daysIndex].daysValueTitleController.selection =
              TextSelection.fromPosition(TextPosition(offset: value.length));
        }
        stepsDataList[mainIndex].daysList[daysIndex].isSync = false;
        var totalValueCount = 0;
        for (int a = 0; a < stepsDataList[mainIndex].daysList.length; a++) {
          if(stepsDataList[mainIndex].daysList[a].total.toString() == "" || stepsDataList[mainIndex].daysList[a].total == 0){
            totalValueCount += 0;
          }else{
            totalValueCount += stepsDataList[mainIndex].daysList[a].total;
          }

        }
        onChangeCalStepWeeks(mainIndex,totalValueCount.toString(),titleName);

      }
      else if (titleName == Constant.titleHeartRateRest) {

        if(value == "" || value == "0"){
          heartRateRestDataList[mainIndex].daysList[daysIndex].total = 0;
          heartRateRestDataList[mainIndex].daysList[daysIndex].daysValue1Title5Controller.text = "";
          heartRateRestDataList[mainIndex].daysList[daysIndex].daysValue1Title5Controller.selection =
              TextSelection.fromPosition(const TextPosition(offset: 0));
        }else {
          heartRateRestDataList[mainIndex].daysList[daysIndex].total =
              int.parse(value.toString());
          heartRateRestDataList[mainIndex].daysList[daysIndex].daysValue1Title5Controller.text = value;
          heartRateRestDataList[mainIndex].daysList[daysIndex].daysValue1Title5Controller.selection =
              TextSelection.fromPosition(TextPosition(offset: value.length));
        }
        heartRateRestDataList[mainIndex].daysList[daysIndex].isSync = false;

        List<int> tempIntList = [];
        var avgTotal = 0;
        for( int i = 0;i<heartRateRestDataList[mainIndex].daysList.length;i++){
          if(heartRateRestDataList[mainIndex].daysList[i].total != 0) {
            tempIntList.add(heartRateRestDataList[mainIndex].daysList[i].total);
            avgTotal += heartRateRestDataList[mainIndex].daysList[i].total;
          }
        }
        if(tempIntList.isNotEmpty) {
          var min = tempIntList.reduce((a, b) => a < b ? a : b);
          var max = tempIntList.reduce((a, b) => a > b ? a : b);

          var totalFilledDataList = heartRateRestDataList[mainIndex].daysList.where((element) => element.total != 0).toList();
          if(totalFilledDataList.isNotEmpty){
            avgTotal = avgTotal ~/ totalFilledDataList.length;
          }
          Debug.printLog(
              "totalFilledDataList.... $min $max $avgTotal  ${totalFilledDataList.length}");
        }

        onChangeCalStepWeeks(mainIndex,avgTotal.toString(),titleName);

      }
      else if (titleName == Constant.titleHeartRatePeak) {

        if(value == "" || value == "0"){
          heartRatePeakDataList[mainIndex].daysList[daysIndex].total = 0;
          heartRatePeakDataList[mainIndex].daysList[daysIndex].daysValue2Title5Controller.text = "";
          heartRatePeakDataList[mainIndex].daysList[daysIndex].daysValue2Title5Controller.selection =
              TextSelection.fromPosition(const TextPosition(offset:0));
        }else {
          heartRatePeakDataList[mainIndex].daysList[daysIndex].total =
              int.parse(value.toString());
          heartRatePeakDataList[mainIndex].daysList[daysIndex].daysValue2Title5Controller.text = value;
          heartRatePeakDataList[mainIndex].daysList[daysIndex].daysValue2Title5Controller.selection =
              TextSelection.fromPosition(TextPosition(offset: value.length));
        }
        heartRatePeakDataList[mainIndex].daysList[daysIndex].isSync = false;

        List<int> tempIntList = [];
        for( int i = 0;i<heartRatePeakDataList[mainIndex].daysList.length;i++){
          if(heartRatePeakDataList[mainIndex].daysList[i].total != 0) {
            tempIntList.add(heartRatePeakDataList[mainIndex].daysList[i].total);
          }
        }
        var min = 0;
        var max = 0;
        if(tempIntList.isNotEmpty) {
          min = tempIntList.reduce((a, b) => a < b ? a : b);
          max = tempIntList.reduce((a, b) => a > b ? a : b);
          Debug.printLog("min max week level .... title 6...$min $max");
        }
        onChangeCalStepWeeks(mainIndex,max.toString(),titleName);
      }

    if(!kIsWeb) {
      try {
        // HealthFactory health = HealthFactory();
        var permissions = ((Platform.isAndroid)
            ? Utils.getAllHealthTypeAndroid
            : Utils.getAllHealthTypeIos)
            .map((e) => HealthDataAccess.READ_WRITE)
            .toList();
        bool? hasPermissions = await Health().hasPermissions(
            (Platform.isAndroid) ? Utils.getAllHealthTypeAndroid : Utils
                .getAllHealthTypeIos, permissions: permissions);
        if (Platform.isIOS) {
          hasPermissions = Utils.getPermissionHealth();
        }
        if (hasPermissions!) {
          await GetSetHealthData.realTimeExportDataFromHealth();
        }
        Debug.printLog("History permission...$hasPermissions");
      } catch (e) {
        Debug.printLog("Import export issue try catch.....$e");
      }
    }

    Debug.printLog("onChangeCountOtherDays....$mainIndex  $daysIndex $titleName  $value");
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? selectedSyncing =
        pref.getString(Constant.keySyncing) ?? Constant.realTime;
    // String? qrUrl = Preference.shared.getString(Preference.qrUrlData) ?? "";
    if(selectedSyncing == Constant.realTime && Utils.getServerListPreference().isNotEmpty) {
      //
      Debug.printLog("selectedSyncing call API......$selectedSyncing   $titleName");
      if(!isRemove) {
        /*if (kIsWeb) {
          await Syncing.dataSyncingProcess(true);
        } else {
          sendPort.send(Constant.callMessage);
        }*/
        var activityTrackingChartData = getActivityListData();
        if(titleName == Constant.titleCalories){
          var calData = activityTrackingChartData.where((element) =>
          !element.isSync &&
              element.title == Constant.titleCalories &&
              element.type == Constant.typeDay && element.total != null && Utils.changeDateFormatBasedOnDBDateWithOutTIme(
              element.dateTime ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDateWithOutTIme(
              caloriesDataList[mainIndex].daysList[daysIndex].storedDate ?? DateTime.now()
          ) ).toList();
          if(calData.isNotEmpty){
            calData[0].isOverride = isOverride;
            await DataBaseHelper.shared.updateActivityData(calData[0]);
            List<SyncMonthlyActivityData> caloriesDataList = [];
            Debug.printLog("calData...list data...${calData[0].dateTime}  ${calData[0].date}  ${double.parse(value.toString())}");
            caloriesDataList.add(SyncMonthlyActivityData(
                "",
                double.parse(value.toString()),
                calData[0].dateTime,
                null,
                calData[0].key,
                Constant.titleCalories,
                true,
                calData[0].objectId));
            await Syncing.observationSyncDataCalories(caloriesDataList);
          }

        }
        else if(titleName == Constant.titleSteps){
          var stepsData = activityTrackingChartData.where((element) =>
          !element.isSync &&
              element.title == Constant.titleSteps &&
              element.type == Constant.typeDay && element.total != null
              && Utils.changeDateFormatBasedOnDBDateWithOutTIme(
              element.dateTime ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDateWithOutTIme(
              stepsDataList[mainIndex].daysList[daysIndex].storedDate ?? DateTime.now()
          ) ).toList();
          if(stepsData.isNotEmpty){
            Debug.printLog("steps...list data...${stepsData[0].dateTime}  ${stepsData[0].date}  ${double.parse(value.toString())}");
            List<SyncMonthlyActivityData> stepsDataList = [];
            stepsDataList.add(SyncMonthlyActivityData(
                "",
                double.parse(value.toString()),
                stepsData[0].dateTime,
                null,
                stepsData[0].key,
                Constant.titleSteps,
                true,
                stepsData[0].objectId));
            await Syncing.observationSyncDataSteps(stepsDataList);
          }

        }
        else if(titleName == Constant.titleHeartRateRest){
          var heartRateRestData = activityTrackingChartData.where((element) =>
          !element.isSync &&
              element.title == Constant.titleHeartRateRest &&
              element.type == Constant.typeDay && element.total != null
              && Utils.changeDateFormatBasedOnDBDateWithOutTIme(
              element.dateTime ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDateWithOutTIme(
              heartRateRestDataList[mainIndex].daysList[daysIndex].storedDate ?? DateTime.now()
          )).toList();
          if(heartRateRestData.isNotEmpty){
            List<SyncMonthlyActivityData> heartRateRestDataList = [];
            heartRateRestDataList.add(SyncMonthlyActivityData(
                "",
                double.parse(value.toString()),
                heartRateRestData[0].dateTime,
                null,
                heartRateRestData[0].key,
                Constant.titleHeartRateRest,
                true,
                heartRateRestData[0].objectId));
            await Syncing.observationSyncDataRestHeart(heartRateRestDataList);
          }

        }
        else if(titleName == Constant.titleHeartRatePeak){
          var heartRatePeakData = activityTrackingChartData.where((element) =>
          !element.isSync &&
              element.title == Constant.titleHeartRatePeak &&
              element.type == Constant.typeDay && element.total != null
              && Utils.changeDateFormatBasedOnDBDateWithOutTIme(
              element.dateTime ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDateWithOutTIme(
              heartRatePeakDataList[mainIndex].daysList[daysIndex].storedDate ?? DateTime.now()
          )).toList();
          if(heartRatePeakData.isNotEmpty){
            List<SyncMonthlyActivityData> heartRatePeakDataList = [];
            heartRatePeakDataList.add(SyncMonthlyActivityData(
                "",
                double.parse(value.toString()),
                heartRatePeakData[0].dateTime,
                null,
                heartRatePeakData[0].key,
                Constant.titleHeartRatePeak,
                true,
                heartRatePeakData[0].objectId));
            await Syncing.observationSyncDataPeakHeart(heartRatePeakDataList);
          }

        }
      }
    }

    update();
  }

  Future<void> onChangeCountOtherDaysData(int mainIndex,int daysIndex,int daysDataIndex,dynamic value, String titleName) async {
    Debug.printLog("onChangeCountOtherDaysData....$mainIndex  $daysIndex  $daysDataIndex  $value  $titleName");
    await insertUpdateCalStepsHeartRateDaysData(mainIndex,daysIndex,daysDataIndex,titleName,value);
    try {

      if (titleName == Constant.titleCalories) {
        caloriesDataList[mainIndex].daysList[daysIndex].daysDataList[daysDataIndex].daysDataValueTitleController.text = value;
        caloriesDataList[mainIndex].daysList[daysIndex].daysDataList[daysDataIndex].total = int.parse(value.toString());
        caloriesDataList[mainIndex].daysList[daysIndex].daysDataList[daysDataIndex].daysDataValueTitleController.selection =
            TextSelection.fromPosition(TextPosition(offset: value.length));

        var totalValueCount = 0;
        for (int a = 0; a < caloriesDataList[mainIndex].daysList[daysIndex].daysDataList.length; a++) {
          totalValueCount += caloriesDataList[mainIndex].daysList[daysIndex].daysDataList[a].total;
        }
        var displayLabelName = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].displayLabel;
        await onChangeCalStepHeartDay(mainIndex, daysIndex, totalValueCount.toString(),
            titleName, titleName,
            displayLabelName: displayLabelName,
            daysDataIndex: daysDataIndex);

      }
      else if (titleName == Constant.titleSteps) {
        stepsDataList[mainIndex].daysList[daysIndex].daysDataList[daysDataIndex].daysDataValueTitleController.text = value;
        stepsDataList[mainIndex].daysList[daysIndex].daysDataList[daysDataIndex].total = int.parse(value.toString());
        stepsDataList[mainIndex].daysList[daysIndex].daysDataList[daysDataIndex].daysDataValueTitleController.selection =
            TextSelection.fromPosition(TextPosition(offset: value.length));

        var totalValueCount = 0;
        for (int a = 0; a < stepsDataList[mainIndex].daysList[daysIndex].daysDataList.length; a++) {
          totalValueCount += stepsDataList[mainIndex].daysList[daysIndex].daysDataList[a].total;
        }
        var displayLabelName = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].displayLabel;
        onChangeCalStepHeartDay(mainIndex, daysIndex, totalValueCount.toString(),
            titleName, titleName,
            displayLabelName: displayLabelName,
            daysDataIndex: daysDataIndex);

      }
      else if (titleName == Constant.titleHeartRateRest) {
        if(value != ""){
          heartRateRestDataList[mainIndex].daysList[daysIndex].daysDataList[daysDataIndex].daysDataValue1Title5Controller.text = value;
          heartRateRestDataList[mainIndex].daysList[daysIndex].daysDataList[daysDataIndex].total = int.parse(value.toString());
          heartRateRestDataList[mainIndex].daysList[daysIndex].daysDataList[daysDataIndex].daysDataValue1Title5Controller.selection =
              TextSelection.fromPosition(TextPosition(offset: value.length));
        }else{
          heartRateRestDataList[mainIndex].daysList[daysIndex].daysDataList[daysDataIndex].daysDataValue1Title5Controller.text = "";
          heartRateRestDataList[mainIndex].daysList[daysIndex].daysDataList[daysDataIndex].total = 0;
          heartRateRestDataList[mainIndex].daysList[daysIndex].daysDataList[daysDataIndex].daysDataValue1Title5Controller.selection =
              TextSelection.fromPosition(const TextPosition(offset: 0));
        }

        List<int> tempIntList = [];
        var avgTotal = 0;
        for( int i = 0;i<heartRateRestDataList[mainIndex].daysList[daysIndex].daysDataList.length;i++){
          if(heartRateRestDataList[mainIndex].daysList[daysIndex].daysDataList[i].total != 0) {
            tempIntList.add(
                heartRateRestDataList[mainIndex].daysList[daysIndex].daysDataList[i]
                    .total);
            avgTotal += heartRateRestDataList[mainIndex].daysList[daysIndex].daysDataList[i]
                .total;
          }
        }
        var min = tempIntList.reduce((a, b) => a < b? a : b);
        var max = tempIntList.reduce((a, b) => a > b? a : b);

        var totalFilledDataList = heartRateRestDataList[mainIndex].daysList[daysIndex].daysDataList
            .where((element) => element.total != 0).toList();
        if(totalFilledDataList.isNotEmpty){
          avgTotal = avgTotal ~/ totalFilledDataList.length;
        }

        Debug.printLog("totalFilledDataList day data  avgTotal....$min $max $avgTotal");

        onChangeCalStepHeartDay(mainIndex,daysIndex,avgTotal.toString(),titleName,titleName);

      }
      else if (titleName == Constant.titleHeartRatePeak) {
        if(value != ""){
          heartRatePeakDataList[mainIndex].daysList[daysIndex].daysDataList[daysDataIndex].daysDataValue2Title5Controller.text = value;
          heartRatePeakDataList[mainIndex].daysList[daysIndex].daysDataList[daysDataIndex].total = int.parse(value.toString());
          heartRatePeakDataList[mainIndex].daysList[daysIndex].daysDataList[daysDataIndex].daysDataValue2Title5Controller.selection =
              TextSelection.fromPosition(TextPosition(offset: value.length));
        }else{
          heartRatePeakDataList[mainIndex].daysList[daysIndex].daysDataList[daysDataIndex].daysDataValue2Title5Controller.text = "";
          heartRatePeakDataList[mainIndex].daysList[daysIndex].daysDataList[daysDataIndex].total = 0;
          heartRatePeakDataList[mainIndex].daysList[daysIndex].daysDataList[daysDataIndex].daysDataValue2Title5Controller.selection =
              TextSelection.fromPosition(const TextPosition(offset: 0));
        }


        List<int> tempIntList = [];
        for( int i = 0;i<heartRatePeakDataList[mainIndex].daysList[daysIndex].daysDataList.length;i++){
          if(heartRatePeakDataList[mainIndex].daysList[daysIndex].daysDataList[i].total != 0) {
            tempIntList.add(
                heartRatePeakDataList[mainIndex].daysList[daysIndex].daysDataList[i]
                    .total);
          }
        }

        var min = tempIntList.reduce((a, b) => a < b? a : b);
        var max = tempIntList.reduce((a, b) => a > b? a : b);
        Debug.printLog("min max .... title 6...$min $max");

        onChangeCalStepHeartDay(mainIndex,daysIndex,max.toString(),titleName,titleName);

      }
    } catch (e) {
      Debug.printLog("onChangeCountOtherDaysData.. $e");
    }

    /*try {
      HealthFactory health = HealthFactory();
      var permissions = ( (Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthTypeIos).map((e) => HealthDataAccess.READ_WRITE).toList();
      bool? hasPermissions = await health.hasPermissions((Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthTypeIos, permissions: permissions);
      if(Platform.isIOS){
        hasPermissions = Utils.getPermissionHealth();
      }
      if(hasPermissions!) {
        var activityName = "";
        DateTime? activityStartDate;
        DateTime? activityEndDate;
        String? healthWorkoutActivityType;
        if (titleName == Constant.titleCalories) {
          activityName = activityMinDataList[mainIndex].weekDaysDataList[daysIndex].daysDataList[daysDataIndex].displayLabel;
          healthWorkoutActivityType = HealthWorkoutActivityType.BASEBALL.name.toString();
          activityStartDate = activityMinDataList[mainIndex].weekDaysDataList[daysIndex].daysDataList[daysDataIndex].activityStartDate;
          activityEndDate = activityMinDataList[mainIndex].weekDaysDataList[daysIndex].daysDataList[daysDataIndex].activityEndDate;
        }
        await GetSetHealthData.realTimeExportDataFromHealthActivityData(activityName,activityStartDate ?? DateTime.now(),activityEndDate ?? DateTime.now(),
            healthWorkoutActivityType ?? "",HealthWorkoutActivityType.BASEBALL);
        await GetSetHealthData.realTimeExportDataFromHealth();
      }
      Debug.printLog("History permission...$hasPermissions");
    } catch (e) {
      Debug.printLog("Import export issue try catch.....$e");
    }*/


    Debug.printLog("onChangeCountOtherDaysData....$mainIndex  $daysIndex  $daysDataIndex  $titleName  $value");
    update();
  }

  insertUpdateOtherTitleWeek(int mainIndex,String titleName,String value) async {
    var allDataFromDB = getActivityListData();
    List<ActivityTable> weekInsertedData = [];

    String formattedDateStart = "";
    String formattedDateEnd = "";

    if (titleName == Constant.titleCalories) {
      formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(caloriesDataList[mainIndex].weekStartDate!);
      formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(caloriesDataList[mainIndex].weekEndDate!);
    }
    else if (titleName == Constant.titleSteps) {
      formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(stepsDataList[mainIndex].weekStartDate!);
      formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(stepsDataList[mainIndex].weekEndDate!);
    }
    else if (titleName == Constant.titleHeartRateRest) {
      formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(heartRateRestDataList[mainIndex].weekStartDate!);
      formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(heartRateRestDataList[mainIndex].weekEndDate!);
    }
    else if (titleName == Constant.titleHeartRatePeak) {
      formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(heartRatePeakDataList[mainIndex].weekStartDate!);
      formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(heartRatePeakDataList[mainIndex].weekEndDate!);
    }

    weekInsertedData = allDataFromDB.where((element) =>
    element.weeksDate == "$formattedDateStart-$formattedDateEnd" &&
        element.type == Constant.typeWeek && element.title == titleName).toList();


    if(weekInsertedData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.title = titleName;

     if (titleName == Constant.titleCalories) {
        insertingData.date = caloriesDataList[mainIndex].date;
      }
      else if (titleName == Constant.titleSteps) {
        insertingData.date = stepsDataList[mainIndex].date;
      }
      else if (titleName == Constant.titleHeartRateRest) {
        insertingData.date = heartRateRestDataList[mainIndex].date;
      }
      else if (titleName == Constant.titleHeartRatePeak) {
        insertingData.date = heartRatePeakDataList[mainIndex].date;
      }
      insertingData.isSync = false;
      if(value == "" || value == "0"){
        insertingData.total = null;
      }else{
        insertingData.total = double.parse(value);
      }
      insertingData.type = Constant.typeWeek;
      insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";
      await DataBaseHelper.shared.insertActivityData(insertingData);
    }
    else{
      /*var weekInsertedData = allDataFromDB
          .where((element) =>
      element.weeksDate == "$formattedDateStart-$formattedDateEnd"  && element.type == Constant.typeWeek
          && element.title == titleName)
          .toList()
          .single;*/
      if(weekInsertedData.isNotEmpty) {
        if (value == "" || value == "0") {
          weekInsertedData[0].total = null;
        } else {
          weekInsertedData[0].total = double.parse(value);
        }
        weekInsertedData[0].isSync = false;
        await DataBaseHelper.shared.updateActivityData(weekInsertedData[0]);
      }
    }
  }

  insertUpdateCalStepHeartDays(
      int mainIndex, int daysIndex, String titleName, String value,
      {String displayLabelName = "", int daysDataIndex = 0}) async {
    var allDataFromDB = getActivityListData();
    List<ActivityTable> weekInsertedData = [];
    String formattedDate = "";
    if (titleName == Constant.titleCalories) {
      formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(caloriesDataList[mainIndex].daysList[daysIndex].storedDate!);
    } else if (titleName == Constant.titleSteps) {
      formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(stepsDataList[mainIndex].daysList[daysIndex].storedDate!);
    } else if (titleName == Constant.titleHeartRateRest) {
      formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(heartRateRestDataList[mainIndex].daysList[daysIndex].storedDate!);
    } else if (titleName == Constant.titleHeartRatePeak) {
      formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(heartRatePeakDataList[mainIndex].daysList[daysIndex].storedDate!);
    }

    if(displayLabelName == "") {
      weekInsertedData = allDataFromDB.where((element) =>
      element.date == formattedDate &&
          element.type == Constant.typeDay && element.title == titleName)
          .toList();
    }else{
      weekInsertedData = allDataFromDB.where((element) =>
      element.date == formattedDate &&
          // element.type == Constant.typeDaysData && element.title == titleName && element.displayLabel == displayLabelName)
          element.type == Constant.typeDay && element.title == titleName)
          .toList();
    }

    Debug.printLog("insertUpdateCalStepHeartDays...$titleName  $formattedDate  $mainIndex  $daysIndex  $daysDataIndex  $value  ${weekInsertedData.length}");
    if(weekInsertedData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.title = titleName;

      if (titleName == Constant.titleCalories) {
        insertingData.date = caloriesDataList[mainIndex].daysList[daysIndex].date;
        insertingData.dateTime = caloriesDataList[mainIndex].daysList[daysIndex].storedDate;
      } else if (titleName == Constant.titleSteps) {
        insertingData.date = stepsDataList[mainIndex].daysList[daysIndex].date;
        insertingData.dateTime = stepsDataList[mainIndex].daysList[daysIndex].storedDate;
      } else if (titleName == Constant.titleHeartRateRest) {
        insertingData.date = heartRateRestDataList[mainIndex].daysList[daysIndex].date;
        insertingData.dateTime = heartRateRestDataList[mainIndex].daysList[daysIndex].storedDate;
      } else if (titleName == Constant.titleHeartRatePeak) {
        insertingData.date = heartRatePeakDataList[mainIndex].daysList[daysIndex].date;
        insertingData.dateTime = heartRatePeakDataList[mainIndex].daysList[daysIndex].storedDate;
      }

      if(value == "" || value == "0"){
        insertingData.total = null;
      }else{
        insertingData.total = double.parse(value);
      }
      insertingData.type = Constant.typeDay;
      insertingData.isSync = false;
      String formattedDateStart = "";
      String formattedDateEnd = "";

      if (titleName == Constant.titleCalories) {
        formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy)
            .format(caloriesDataList[mainIndex].weekStartDate!);
        formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy)
            .format(caloriesDataList[mainIndex].weekEndDate!);
      } else if (titleName == Constant.titleSteps) {
        formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy)
            .format(stepsDataList[mainIndex].weekStartDate!);
        formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy)
            .format(stepsDataList[mainIndex].weekEndDate!);
      } else if (titleName == Constant.titleHeartRateRest) {
        formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy)
            .format(heartRateRestDataList[mainIndex].weekStartDate!);
        formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy)
            .format(heartRateRestDataList[mainIndex].weekEndDate!);
      } else if (titleName == Constant.titleHeartRatePeak) {
        formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy)
            .format(heartRatePeakDataList[mainIndex].weekStartDate!);
        formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy)
            .format(heartRatePeakDataList[mainIndex].weekEndDate!);
      }
      insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";
      insertingData.needExport = true;
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

      var id = await DataBaseHelper.shared.insertActivityData(insertingData);
    }
    else{

      String formattedDate = "";
      if (titleName == Constant.titleCalories) {
        formattedDate = caloriesDataList[mainIndex].daysList[daysIndex].date;
      } else if (titleName == Constant.titleSteps) {
        formattedDate = stepsDataList[mainIndex].daysList[daysIndex].date;
      } else if (titleName == Constant.titleHeartRateRest) {
        formattedDate = heartRateRestDataList[mainIndex].daysList[daysIndex].date;
      } else if (titleName == Constant.titleHeartRatePeak) {
        formattedDate = heartRatePeakDataList[mainIndex].daysList[daysIndex].date;
      }

      /*List<ActivityTable>  weekInsertedData = [];

        weekInsertedData = allDataFromDB
            .where((element) => element.date == formattedDate && element.title == titleName&&
            element.type == Constant.typeDay ).toList();*/

      if(weekInsertedData.isNotEmpty) {
        if (value == "" || value == "0") {
          weekInsertedData[0].total = null;
        } else {
          weekInsertedData[0].total = double.parse(value);
        }
        var allSelectedServersUrl = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected).toList();

        if (weekInsertedData[0].serverDetailList.length !=
            allSelectedServersUrl.length) {
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = weekInsertedData[0].serverDetailList;
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
              weekInsertedData[0].serverDetailList.add(
                  serverDetail);
            }
          }
        }
        weekInsertedData[0].isSync = false;
        weekInsertedData[0].needExport = true;
        Debug.printLog(
            "insertUpdateCalStepHeartDays update data...$titleName  $formattedDate  $mainIndex  $daysIndex   $value  ${weekInsertedData
                .length}");

        await DataBaseHelper.shared.updateActivityData(
            weekInsertedData[0]);
      }
    }
  }

  insertUpdateCalStepsHeartRateDaysData(int mainIndex,int daysIndex,int daysDataIndex,String titleName,String value) async {
    var allDataFromDB = getActivityListData();
    int insertedId = 0;

    List<ActivityTable> weekInsertedData = [];
    String formattedDate = "";
     if (titleName == Constant.titleCalories) {
      formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(caloriesDataList[mainIndex].daysList[daysIndex].storedDate!);
    } else if (titleName == Constant.titleSteps) {
      formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(stepsDataList[mainIndex].daysList[daysIndex].storedDate!);
    } else if (titleName == Constant.titleHeartRateRest) {
      formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(heartRateRestDataList[mainIndex].daysList[daysIndex].storedDate!);
    } else if (titleName == Constant.titleHeartRatePeak) {
      formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(heartRatePeakDataList[mainIndex].daysList[daysIndex].storedDate!);
    }

    var activityStartDate = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].activityStartDate;
    var activityEndDate = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].activityEndDate;

    weekInsertedData = allDataFromDB
        .where((element) =>
    element.date == formattedDate &&
        element.type == Constant.typeDaysData &&
        element.title == titleName &&
        element.displayLabel ==
            trackingChartDataList[mainIndex]
                .dayLevelDataList[daysIndex]
                .activityLevelDataList[daysDataIndex]
                .displayLabel && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
        Utils.changeDateFormatBasedOnDBDate(activityStartDate)
        && Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
        Utils.changeDateFormatBasedOnDBDate(activityEndDate))
        .toList();


    if(weekInsertedData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.title = titleName;
      insertingData.needExport = true;
      insertingData.displayLabel = trackingChartDataList[mainIndex]
          .dayLevelDataList[daysIndex]
          .activityLevelDataList[daysDataIndex]
          .displayLabel;

       if (titleName == Constant.titleCalories) {
        insertingData.date = caloriesDataList[mainIndex].daysList[daysIndex].date;
        insertingData.dateTime = caloriesDataList[mainIndex].daysList[daysIndex].storedDate;
      }
      else if (titleName == Constant.titleSteps) {
        insertingData.date = stepsDataList[mainIndex].daysList[daysIndex].date;
        insertingData.dateTime = stepsDataList[mainIndex].daysList[daysIndex].storedDate;
      }
      else if (titleName == Constant.titleHeartRateRest) {
        insertingData.date = heartRateRestDataList[mainIndex].daysList[daysIndex].date;
        insertingData.dateTime = heartRateRestDataList[mainIndex].daysList[daysIndex].storedDate;
      }
      else if (titleName == Constant.titleHeartRatePeak) {
        insertingData.date = heartRatePeakDataList[mainIndex].daysList[daysIndex].date;
        insertingData.dateTime = heartRatePeakDataList[mainIndex].daysList[daysIndex].storedDate;
      }

      if(value == "" || value == "0"){
        insertingData.total = null;
      }else {
        insertingData.total = double.parse(value);
      }
      insertingData.type = Constant.typeDaysData;
      insertingData.activityStartDate = trackingChartDataList[mainIndex]
          .dayLevelDataList[daysIndex]
          .activityLevelDataList[daysDataIndex].activityStartDate;
      insertingData.activityEndDate = trackingChartDataList[mainIndex]
          .dayLevelDataList[daysIndex]
          .activityLevelDataList[daysDataIndex].activityEndDate;
      String formattedDateStart = "";
      String formattedDateEnd = "";

      if (titleName == Constant.titleCalories) {
        formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy)
            .format(caloriesDataList[mainIndex].weekStartDate!);
        formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy)
            .format(caloriesDataList[mainIndex].weekEndDate!);
      }
      else if (titleName == Constant.titleSteps) {
        formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy)
            .format(stepsDataList[mainIndex].weekStartDate!);
        formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy)
            .format(stepsDataList[mainIndex].weekEndDate!);
      }
      else if (titleName == Constant.titleHeartRateRest) {
        formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy)
            .format(heartRateRestDataList[mainIndex].weekStartDate!);
        formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy)
            .format(heartRateRestDataList[mainIndex].weekEndDate!);
      }
      else if (titleName == Constant.titleHeartRatePeak) {
        formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy)
            .format(heartRatePeakDataList[mainIndex].weekStartDate!);
        formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy)
            .format(heartRatePeakDataList[mainIndex].weekEndDate!);
      }

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

      insertedId = await DataBaseHelper.shared.insertActivityData(insertingData);
    }
    else{
      if(weekInsertedData.isNotEmpty) {
        String formattedDate = "";
        if (titleName == Constant.titleCalories) {
          formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
              .format(
              caloriesDataList[mainIndex].daysList[daysIndex].storedDate!);
        } else if (titleName == Constant.titleSteps) {
          formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
              .format(stepsDataList[mainIndex].daysList[daysIndex].storedDate!);
        } else if (titleName == Constant.titleHeartRateRest) {
          formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
              .format(
              heartRateRestDataList[mainIndex].daysList[daysIndex].storedDate!);
        } else if (titleName == Constant.titleHeartRatePeak) {
          formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
              .format(
              heartRatePeakDataList[mainIndex].daysList[daysIndex].storedDate!);
        }

        weekInsertedData[0].activityStartDate = trackingChartDataList[mainIndex]
            .dayLevelDataList[daysIndex]
            .activityLevelDataList[daysDataIndex].activityStartDate;
        weekInsertedData[0].activityEndDate = trackingChartDataList[mainIndex]
            .dayLevelDataList[daysIndex]
            .activityLevelDataList[daysDataIndex].activityEndDate;

        if (weekInsertedData[0].total == null && titleName == Constant.titleCalories) {
          Debug.printLog(
              "You have to insert activity in apple and google sync...");

          var startDate = trackingChartDataList[mainIndex]
              .dayLevelDataList[daysIndex]
              .activityLevelDataList[daysDataIndex]
              .activityStartDate;

          var endDate = trackingChartDataList[mainIndex]
              .dayLevelDataList[daysIndex]
              .activityLevelDataList[daysDataIndex]
              .activityEndDate;

          var listOfLastData = trackingChartDataList[mainIndex]
              .dayLevelDataList[daysIndex]
              .activityLevelDataList;

       /*   var dataIsInWithoutAnotherData = listOfLastData.where((element) =>
          Utils.isBetween(element.activityStartDate, element.activityEndDate, startDate, endDate)
              && element != trackingChartDataList[mainIndex]
              .dayLevelDataList[daysIndex]
              .activityLevelDataList[daysDataIndex]).toList().isEmpty;*/

          var dataIsInWithoutAnotherData = Utils.checkDateOverlap(listOfLastData,
              startDate,endDate,currentActivityData: trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]);

          Debug.printLog("startDate.isBefore(endDate)....${startDate.isBefore(endDate)}  $dataIsInWithoutAnotherData");
          if(startDate.isBefore(endDate) && !dataIsInWithoutAnotherData && !kIsWeb && Platform.isIOS) {
            try {
              // HealthFactory health = HealthFactory();
              var permissions = ((Platform.isAndroid) ? Utils
                  .getAllHealthTypeAndroid : Utils.getAllHealthTypeIos).map((
                  e) => HealthDataAccess.READ_WRITE).toList();
              bool? hasPermissions = await Health().hasPermissions(
                  (Platform.isAndroid) ? Utils.getAllHealthTypeAndroid : Utils
                      .getAllHealthTypeIos, permissions: permissions);
              if (Platform.isIOS) {
                hasPermissions = Utils.getPermissionHealth();
              }
              // if (hasPermissions!) {
              var displayName = trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .displayLabel;

              var startDate = trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .activityStartDate;

              var endDate = trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .activityEndDate;

              HealthWorkoutActivityType workoutType =
                  HealthWorkoutActivityType.OTHER;
              /*var getTypeFromName =(kIsWeb)?Utils.workOutDataListAndroid: (Platform.isAndroid) ? Utils
                  .workOutDataListAndroid : Utils.workOutDataListIos
                  .where((element) => element.workOutDataName == displayName)
                  .toList();*/
              List<WorkOutData> getTypeFromName = [];

              if (Platform.isAndroid) {
                getTypeFromName = Utils.workOutDataListAndroid
                    .where((element) => element.workOutDataName == displayName)
                    .toList();
              } else if (Platform.isIOS) {
                getTypeFromName = Utils.workOutDataListIos
                    .where((element) => element.workOutDataName == displayName)
                    .toList();
              }

              if (getTypeFromName.isNotEmpty) {
                workoutType = getTypeFromName[0].datatype;
              } else {
                workoutType = HealthWorkoutActivityType.OTHER;
              }

              Debug.printLog(
                  "workoutType...$workoutType  $displayName  $value");
              Debug.printLog("History permission...$hasPermissions");
              if (hasPermissions!) {
                var deletedData = await Utils.deleteWorkout(
                    startDate, endDate, Health());
                if(Utils.getPermissionHealth()) {
                  await GetSetHealthData.insertActivityIntoAppleGoogleSync(
                      displayName, startDate, endDate,
                      workoutType, value);
                }
              }
                // onChangeActivityTimeLast(startDate, endDate);
            } catch (e) {
              Debug.printLog("Import export issue try catch.....$e");
            }
          }
        }
        else if (weekInsertedData[0].total != null && titleName == Constant.titleCalories) {

          var startDate = trackingChartDataList[mainIndex]
              .dayLevelDataList[daysIndex]
              .activityLevelDataList[daysDataIndex]
              .activityStartDate;

          var endDate = trackingChartDataList[mainIndex]
              .dayLevelDataList[daysIndex]
              .activityLevelDataList[daysDataIndex]
              .activityEndDate;

          var listOfLastData = trackingChartDataList[mainIndex]
              .dayLevelDataList[daysIndex]
              .activityLevelDataList;

          // Debug.printLog("startDate.isBefore(endDate)....${startDate.isBefore(endDate)}");
         /* var dataIsInWithoutAnotherData = listOfLastData.where((element) =>
              Utils.isBetween(element.activityStartDate, element.activityEndDate, startDate, endDate)
          && element != trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]).toList().isEmpty;*/

          var dataIsInWithoutAnotherData = Utils.checkDateOverlap(listOfLastData,
              startDate,endDate,currentActivityData: trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]);
          Debug.printLog("startDate.isBefore(endDate)....else....${startDate.isBefore(endDate)}  $dataIsInWithoutAnotherData");

          if(startDate.isBefore(endDate) && !dataIsInWithoutAnotherData && !kIsWeb && Platform.isIOS){
            try {
              // HealthFactory health = HealthFactory();
              var permissions = ((Platform.isAndroid) ? Utils
                  .getAllHealthTypeAndroid : Utils.getAllHealthTypeIos).map((
                  e) => HealthDataAccess.READ_WRITE).toList();
              bool? hasPermissions = await Health().hasPermissions(
                  (Platform.isAndroid) ? Utils.getAllHealthTypeAndroid : Utils
                      .getAllHealthTypeIos, permissions: permissions);
              if (Platform.isIOS) {
                hasPermissions = Utils.getPermissionHealth();
              }

              Debug.printLog("deleteWorkout date...$startDate  $endDate");

              if (hasPermissions!) {
              var deletedData = await Utils.deleteWorkout(
                  startDate, endDate, Health());

              // if(deletedData!) {
              var displayName = trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .displayLabel;

              var startDateInit = trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .activityStartDate;

              var endDateInit = trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .activityEndDate;

              HealthWorkoutActivityType workoutType =
                  HealthWorkoutActivityType.OTHER;
              var getTypeFromName = (Platform.isAndroid) ? Utils
                  .workOutDataListAndroid : Utils.workOutDataListIos
                  .where((element) => element.workOutDataName == displayName)
                  .toList();

              if (getTypeFromName.isNotEmpty) {
                workoutType = getTypeFromName[0].datatype;
              } else {
                workoutType = HealthWorkoutActivityType.OTHER;
              }

              Debug.printLog(
                  "workoutType...$workoutType  $displayName  $value");
              if(Utils.getPermissionHealth()) {
                await GetSetHealthData.insertActivityIntoAppleGoogleSync(
                    displayName, startDateInit, endDateInit,
                    workoutType, value);
              }
              Debug.printLog(
                  "deletedData....$deletedData  $startDate  $endDate");
            }
              ///activityTypeData...0  Cricket  80  2024-03-15 19:20:59.000  2024-03-15 19:20:59.000
            } catch (e) {
              Debug.printLog(e.toString());
            }
          }

        }
        if (value == "" || value == "0") {
          weekInsertedData[0].total = null;
        } else {
          weekInsertedData[0].total = double.parse(value);
        }

        var allSelectedServersUrl = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected).toList();

        if (weekInsertedData[0].serverDetailList.length !=
            allSelectedServersUrl.length) {
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = weekInsertedData[0].serverDetailList;
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
              weekInsertedData[0].serverDetailList.add(
                  serverDetail);
            }
          }
        }

        weekInsertedData[0].needExport = true;

        await DataBaseHelper.shared.updateActivityData(
            weekInsertedData[0]);
      }
    }

    // dummyEntry(mainIndex,daysIndex,daysDataIndex,formattedDate,insertedId);

    if (titleName == Constant.titleCalories) {
      var activityDataTableList = getActivityListData();
      var caloriesData = activityDataTableList
          .where((element) =>
              element.date == formattedDate &&
              element.type == Constant.typeDaysData &&
              element.title == titleName &&
              element.displayLabel ==
                  trackingChartDataList[mainIndex]
                      .dayLevelDataList[daysIndex]
                      .activityLevelDataList[daysDataIndex]
                      .displayLabel &&
              element.activityStartDate ==
                  trackingChartDataList[mainIndex]
                      .dayLevelDataList[daysIndex]
                      .activityLevelDataList[daysDataIndex]
                      .activityStartDate &&
              element.activityEndDate ==
                  trackingChartDataList[mainIndex]
                      .dayLevelDataList[daysIndex]
                      .activityLevelDataList[daysDataIndex]
                      .activityEndDate)
          .toList();

      if(caloriesData.isNotEmpty) {
        if((caloriesData[0].total ?? 0.0) > 0.0 && caloriesData[0].total != null) {
          await Syncing.createChildActivityCaloriesObservation(
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .displayLabel,
              caloriesData[0]);

          var activityTrackingChartData = getActivityListData();
          var calData = activityTrackingChartData.where((element) =>
          element.title == Constant.titleCalories &&
              element.type == Constant.typeDay && element.total != null
              && Utils.changeDateFormatBasedOnDBDateWithOutTIme(
              element.dateTime ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDateWithOutTIme(
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex].storedDate ?? DateTime.now()
          ) ).toList();
          if(calData.isNotEmpty){
            Debug.printLog("calories day...list data...${calData[0].dateTime}  ${calData[0].date}  ${double.parse(value.toString())}");
            List<SyncMonthlyActivityData> calDataList = [];
            calDataList.add(SyncMonthlyActivityData(
                "",
                double.parse(value.toString()),
                calData[0].dateTime,
                null,
                calData[0].key,
                Constant.titleCalories,
                true,
                calData[0].objectId));
            await Syncing.observationSyncDataCalories(calDataList);
          }
        }
      }
    }
    else if (titleName == Constant.titleHeartRatePeak) {
      var activityDataTableList = getActivityListData();
      var peakHeartRateData = activityDataTableList
          .where((element) =>
      element.date == formattedDate &&
          element.type == Constant.typeDaysData &&
          element.title == titleName &&
          element.displayLabel ==
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .displayLabel &&
          element.activityStartDate ==
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .activityStartDate &&
          element.activityEndDate ==
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .activityEndDate)
          .toList();

      if(peakHeartRateData.isNotEmpty) {
        if((peakHeartRateData[0].total ?? 0.0) > 0.0 && peakHeartRateData[0].total != null) {
          await Syncing.createChildActivityPeakHeatRateObservation(
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .displayLabel,
              peakHeartRateData[0]);
        }
      }
    }
    else if (titleName == Constant.titleSteps) {
      var activityDataTableList = getActivityListData();
      var stepsDataActivity = activityDataTableList
          .where((element) =>
      element.date == formattedDate &&
          element.type == Constant.typeDaysData &&
          element.title == Constant.titleSteps &&
          element.displayLabel ==
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .displayLabel &&
          element.activityStartDate ==
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .activityStartDate &&
          element.activityEndDate ==
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .activityEndDate)
          .toList();

      if(stepsDataActivity.isNotEmpty) {
        if((stepsDataActivity[0].total ?? 0.0) > 0.0 && stepsDataActivity[0].total != null) {
          await Syncing.createChildActivityStepsObservation(
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .displayLabel,
              stepsDataActivity[0]);

          var activityTrackingChartData = getActivityListData();
          var stepsData = activityTrackingChartData.where((element) =>
              element.title == Constant.titleSteps &&
              element.type == Constant.typeDay && element.total != null
              && Utils.changeDateFormatBasedOnDBDateWithOutTIme(
              element.dateTime ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDateWithOutTIme(
                  trackingChartDataList[mainIndex]
                      .dayLevelDataList[daysIndex].storedDate ?? DateTime.now()
          ) ).toList();
          if(stepsData.isNotEmpty){
            Debug.printLog("steps day...list data...${stepsData[0].dateTime}  ${stepsData[0].date}  ${double.parse(value.toString())}");
            List<SyncMonthlyActivityData> stepsDataList = [];
            stepsDataList.add(SyncMonthlyActivityData(
                "",
                double.parse(value.toString()),
                stepsData[0].dateTime,
                null,
                stepsData[0].key,
                Constant.titleSteps,
                true,
                stepsData[0].objectId));
            await Syncing.observationSyncDataSteps(stepsDataList);
          }
        }
      }
    }

    var activityDataTableList = getActivityListData();
    if(activityDataTableList.isNotEmpty) {
      var findParentRecordActivity = activityDataTableList
          .where((element) =>
      element.date == formattedDate &&
          element.type == Constant.typeDaysData &&
          element.title == Constant.titleParent &&
          element.displayLabel ==
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .displayLabel  &&
          element.activityStartDate ==
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .activityStartDate &&
          element.activityEndDate ==
              trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .activityEndDate)
          .toList();
      if(findParentRecordActivity.isNotEmpty) {
        Syncing.createParentActivityObservation(
            findParentRecordActivity[0]);
      }
    }
  }

  getWeek1Data(
      DateTime dateParseStartPreviousWeek1,
      DateTime dateParseLastTimePreviousWeek1,
      List<ActivityTable> dataListHive) {
    List<DayLevelData> daysData = [];
    for (int i = 0; i < 7; i++) {
      var dates = DateTime(
          dateParseStartPreviousWeek1.year,
          dateParseStartPreviousWeek1.month,
          dateParseStartPreviousWeek1.day + i);
      String formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy).format(dates);
      String formattedDateDayName = DateFormat('EEE').format(dates);
      daysData.add(DayLevelData(formattedDateDayName, formattedDate, "Week 1", [],dates));
    }

    var data = WeekLevelData('Week 1', daysData, dateParseStartPreviousWeek1,
        dateParseLastTimePreviousWeek1);

    String formattedDateStart =
    DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateParseStartPreviousWeek1);
    String formattedDateEnd =
    DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateParseLastTimePreviousWeek1);

    var matchedWeek1Data = dataListHive
        .where((element) =>
    element.weeksDate == "$formattedDateStart-$formattedDateEnd" && element.title == null && element.smileyType == null)
        .toList();

    if (matchedWeek1Data.isNotEmpty) {
      for (int k = 0; k < matchedWeek1Data.length; k++) {

        if(matchedWeek1Data[k].type == Constant.typeWeek && matchedWeek1Data[k].displayLabel == null ) {
          data.smileyType = matchedWeek1Data[k].smileyType ?? Constant.defaultSmileyType;
          var value1Week = matchedWeek1Data[k].value1;
          if(value1Week != null) {
            data.modMinController.text =
                double.parse(value1Week.toString()).toInt().toString();
            data.modMinValue = value1Week.toInt();
          }else{
            data.modMinController.text = "";
            data.modMinValue = 0;
          }

          var value2Week = matchedWeek1Data[k].value2;
          if(value2Week != null) {
            data.vigMinController.text =
                double.parse(value2Week.toString()).toInt().toString();
            data.vigMinValue = value2Week.toInt();
          }else{
            data.vigMinController.text = "";
            data.vigMinValue = 0;
          }

          var totalWeek = matchedWeek1Data[k].total;
          if(totalWeek != null) {
            data.totalMinController.text =
                double.parse(totalWeek.toString()).toInt().toString();
            data.totalMinValue = totalWeek.toInt();
          }else{
            data.totalMinController.text =
            "";
            data.totalMinValue = 0;
          }

          data.weeklyNotes = matchedWeek1Data[k].notes ?? "";
          data.isOverride = matchedWeek1Data[k].isOverride;
        }
        else if (matchedWeek1Data[k].type == Constant.typeDay) {
          for (int l = 0; l < data.dayLevelDataList.length; l++) {
            var matchedData = matchedWeek1Data
                .where(
                    (element) => element.date == data.dayLevelDataList[l].date && element.type == Constant.typeDay)
                .toList();

            if(matchedData.isNotEmpty){
              data.dayLevelDataList[l].smileyType = matchedData[0].smileyType ?? Constant.defaultSmileyType;
              var value1DayData = matchedData[0].value1;
              if(value1DayData == null){
                data.dayLevelDataList[l].modMinValue = 0;
                data.dayLevelDataList[l].modMinController.text = "";
              }else{
                data.dayLevelDataList[l].modMinValue = value1DayData.toInt();
                data.dayLevelDataList[l].modMinController.text = value1DayData.toInt().toString() ?? "";
              }

              var value2DayData = matchedData[0].value2;
              if(value2DayData == null){
                data.dayLevelDataList[l].vigMinValue = 0;
                data.dayLevelDataList[l].vigMinController.text = "";
              }else{
                data.dayLevelDataList[l].vigMinValue = value2DayData.toInt();
                data.dayLevelDataList[l].vigMinController.text = value2DayData.toInt().toString() ?? "";
              }

              var totalDayData = matchedData[0].total;
              if(totalDayData == null){
                data.dayLevelDataList[l].totalMinValue = 0;
                data.dayLevelDataList[l].totalMinController.text = "";
              }else{
                data.dayLevelDataList[l].totalMinValue = totalDayData.toInt();
                data.dayLevelDataList[l].totalMinController.text = totalDayData.toInt().toString() ?? "";
              }

              data.dayLevelDataList[l].isOverride = matchedData[0].isOverride;
              data.dayLevelDataList[l].dailyNotes = matchedData[0].notes ?? "";
            }
          }
          // Debug.printLog("typeDay....${matchedWeek1Data[k].dateTime}");
        }
        else if (matchedWeek1Data[k].type == Constant.typeDaysData) {

          for (int l = 0; l < data.dayLevelDataList.length; l++) {
            if(data.dayLevelDataList[l].date == matchedWeek1Data[k].date){
              Debug.printLog("typeDaysData....${data.dayLevelDataList.length}");

              var daysData = ActivityLevelData();
              daysData.storedDate = matchedWeek1Data[k].dateTime;
              daysData.titleName = matchedWeek1Data[k].name.toString();
              daysData.displayLabel = matchedWeek1Data[k].displayLabel.toString();
              daysData.smileyType = matchedWeek1Data[k].smileyType ?? Constant.defaultSmileyType;
              daysData.dayDataNotes = matchedWeek1Data[k].notes ?? "";
              daysData.iconPath = matchedWeek1Data[k].iconPath ?? "";
              daysData.isFromAppleHealth = matchedWeek1Data[k].isFromAppleHealth;
              daysData.activityStartDate = matchedWeek1Data[k].activityStartDate ?? (matchedWeek1Data[k].dateTime ?? DateTime.now());
              daysData.activityEndDate = matchedWeek1Data[k].activityEndDate ?? (matchedWeek1Data[k].dateTime ?? DateTime.now());
              // daysData.activityStartDateLast = matchedWeek1Data[k].activityStartDate ?? (matchedWeek1Data[k].dateTime ?? DateTime.now());
              // daysData.activityEndDateLast = matchedWeek1Data[k].activityEndDate ?? (matchedWeek1Data[k].dateTime ?? DateTime.now());

              var value1DayData = matchedWeek1Data[k].value1;
              if(value1DayData != null) {
                daysData.modMinValue = value1DayData.toInt();
                daysData.modMinController.text = value1DayData.toInt().toString();
              }else{
                daysData.modMinValue = null;
                daysData.modMinController.text = "";
              }

              var value2DayData = matchedWeek1Data[k].value2;
              if(value2DayData != null) {
                daysData.vigMinValue = value2DayData.toInt();
                daysData.vigMinController.text = value2DayData.toInt().toString();
              }else{
                daysData.vigMinValue = null;
                daysData.vigMinController.text = "";
              }

              var totalDayData = matchedWeek1Data[k].total;
              if(totalDayData != null) {
                daysData.totalMinValue = totalDayData.toInt();
                daysData.totalMinController.text = totalDayData.toInt().toString();
              }else{
                daysData.totalMinValue = null;
                daysData.totalMinController.text = "";
              }
              daysData.dayDataNotes = matchedWeek1Data[k].notes ?? "";
              daysData.isOverride = matchedWeek1Data[k].isOverride;
              data.dayLevelDataList[l].activityLevelDataList.add(daysData);
            }
          }
        }

      }
    }
    trackingChartDataList.add(data);

    for(int i=0;i< trackingChartDataList[0].dayLevelDataList.length;i++) {
      if (trackingChartDataList[0].dayLevelDataList[i].activityLevelDataList.isEmpty) {
        updatePopUpMenuList(
            0,
            i,
            "");
      } else {
        for (int j = 4;
        j < trackingChartDataList[0].dayLevelDataList[i].activityLevelDataList.length;
        j++) {
          updatePopUpMenuList(
              0,
              i,
              trackingChartDataList[0].dayLevelDataList[i].activityLevelDataList[j]
                  .displayLabel.toString());
        }
      }
    }
  }

  getWeek2Data(
      DateTime dateParseStartPreviousWeek2,
      DateTime dateParseLastTimePreviousWeek2,
      List<ActivityTable> dataListHive) {
    List<DayLevelData> daysData = [];
    for (int i = 0; i < 7; i++) {
      var dates = DateTime(
          dateParseStartPreviousWeek2.year,
          dateParseStartPreviousWeek2.month,
          dateParseStartPreviousWeek2.day + i);
      String formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy).format(dates);
      String formattedDateDayName = DateFormat('EEE').format(dates);
      // Debug.printLog(
      //     "dates dateParseStartPreviousWeek2... $dates  $formattedDate  $formattedDateDayName");
      daysData.add(DayLevelData(formattedDateDayName, formattedDate, "Week 2",
          [],dates));
    }
    var data2 = WeekLevelData('Week 2', daysData, dateParseStartPreviousWeek2,
        dateParseLastTimePreviousWeek2);

    String formattedDateStartWeek2 =
    DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateParseStartPreviousWeek2);
    String formattedDateEndWeek2 =
    DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateParseLastTimePreviousWeek2);

    var matchedWeek2Data = dataListHive
        .where((element) =>
    element.weeksDate ==
        "$formattedDateStartWeek2-$formattedDateEndWeek2" && element.title == null && element.smileyType == null)
        .toList();

    if (matchedWeek2Data.isNotEmpty) {
      for (int k = 0; k < matchedWeek2Data.length; k++) {

        if(matchedWeek2Data[k].type == Constant.typeWeek && matchedWeek2Data[k].displayLabel == null ) {
          data2.smileyType = matchedWeek2Data[k].smileyType ?? Constant.defaultSmileyType;

          var value1Week = matchedWeek2Data[k].value1;
          if(value1Week != null) {
            data2.modMinController.text =
                double.parse(value1Week.toString()).toInt().toString();
            data2.modMinValue = value1Week.toInt();
          }else{
            data2.modMinController.text = "";
            data2.modMinValue = 0;
          }

          var value2Week = matchedWeek2Data[k].value2;
          if(value2Week != null) {
            data2.vigMinController.text =
                double.parse(value2Week.toString()).toInt().toString();
            data2.vigMinValue = value2Week.toInt();
          }else{
            data2.vigMinController.text = "";
            data2.vigMinValue = 0;
          }

          var totalWeek = matchedWeek2Data[k].total;
          if(totalWeek != null) {
            data2.totalMinController.text =
                double.parse(totalWeek.toString()).toInt().toString();
            data2.totalMinValue = totalWeek.toInt();
          }else{
            data2.totalMinController.text =
            "";
            data2.totalMinValue = 0;
          }

          data2.isOverride = matchedWeek2Data[k].isOverride;
          data2.weeklyNotes = matchedWeek2Data[k].notes ?? "";
        }
        else if (matchedWeek2Data[k].type == Constant.typeDay) {
          for (int l = 0; l < data2.dayLevelDataList.length; l++) {
            var matchedData = matchedWeek2Data
                .where(
                    (element) => element.date == data2.dayLevelDataList[l].date && element.type == Constant.typeDay)
                .toList();

            if(matchedData.isNotEmpty){
              data2.dayLevelDataList[l].smileyType = matchedData[0].smileyType ?? Constant.defaultSmileyType;

              var value1DayData = matchedData[0].value1;
              if(value1DayData == null){
                data2.dayLevelDataList[l].modMinValue = 0;
                data2.dayLevelDataList[l].modMinController.text = "";
              }else{
                data2.dayLevelDataList[l].modMinValue = value1DayData.toInt();
                data2.dayLevelDataList[l].modMinController.text = value1DayData.toInt().toString() ?? "";
              }

              var value2DayData = matchedData[0].value2;
              if(value2DayData == null){
                data2.dayLevelDataList[l].vigMinValue = 0;
                data2.dayLevelDataList[l].vigMinController.text = "";
              }else{
                data2.dayLevelDataList[l].vigMinValue = value2DayData.toInt();
                data2.dayLevelDataList[l].vigMinController.text = value2DayData.toInt().toString() ?? "";
              }

              var totalDayData = matchedData[0].total;
              if(totalDayData == null){
                data2.dayLevelDataList[l].totalMinValue = 0;
                data2.dayLevelDataList[l].totalMinController.text = "";
              }else{
                data2.dayLevelDataList[l].totalMinValue = totalDayData.toInt();
                data2.dayLevelDataList[l].totalMinController.text = totalDayData.toInt().toString() ?? "";
              }

              data2.dayLevelDataList[l].isOverride = matchedData[0].isOverride;
              data2.dayLevelDataList[l].dailyNotes = matchedData[0].notes ?? "";
            }
          }
          // Debug.printLog("typeDay....${matchedWeek2Data[k].dateTime}");
        }
        else if (matchedWeek2Data[k].type == Constant.typeDaysData) {

          for (int l = 0; l < data2.dayLevelDataList.length; l++) {
            if(data2.dayLevelDataList[l].date == matchedWeek2Data[k].date){
              Debug.printLog("typeDaysData....${data2.dayLevelDataList.length}");

              var daysData = ActivityLevelData();
              daysData.storedDate = matchedWeek2Data[k].dateTime;
              daysData.titleName = matchedWeek2Data[k].name.toString();
              daysData.displayLabel = matchedWeek2Data[k].displayLabel.toString();
              daysData.smileyType = matchedWeek2Data[k].smileyType ?? Constant.defaultSmileyType;
              daysData.dayDataNotes = matchedWeek2Data[k].notes ?? "";
              daysData.iconPath = matchedWeek2Data[k].iconPath ?? "";
              daysData.isFromAppleHealth = matchedWeek2Data[k].isFromAppleHealth;
              daysData.activityStartDate = matchedWeek2Data[k].activityStartDate ?? (matchedWeek2Data[k].dateTime ?? DateTime.now());
              daysData.activityEndDate = matchedWeek2Data[k].activityEndDate ?? (matchedWeek2Data[k].dateTime ?? DateTime.now());
              // daysData.activityStartDateLast = matchedWeek2Data[k].activityStartDate ?? (matchedWeek2Data[k].dateTime ?? DateTime.now());
              // daysData.activityEndDateLast = matchedWeek2Data[k].activityEndDate ?? (matchedWeek2Data[k].dateTime ?? DateTime.now());


              var value1DayData = matchedWeek2Data[k].value1;
              if(value1DayData != null) {
                daysData.modMinValue = value1DayData.toInt();
                daysData.modMinController.text = value1DayData.toInt().toString();
              }else{
                daysData.modMinValue = null;
                daysData.modMinController.text = "";
              }

              var value2DayData = matchedWeek2Data[k].value2;
              if(value2DayData != null) {
                daysData.vigMinValue = value2DayData.toInt();
                daysData.vigMinController.text = value2DayData.toInt().toString();
              }else{
                daysData.vigMinValue = null;
                daysData.vigMinController.text = "";
              }

              var totalDayData = matchedWeek2Data[k].total;
              if(totalDayData != null) {
                daysData.totalMinValue = totalDayData.toInt();
                daysData.totalMinController.text = totalDayData.toInt().toString();
              }else{
                daysData.totalMinValue = null;
                daysData.totalMinController.text = "";
              }

              daysData.dayDataNotes = matchedWeek2Data[k].notes ?? "";
              daysData.isOverride = matchedWeek2Data[k].isOverride;
              data2.dayLevelDataList[l].activityLevelDataList.add(daysData);
            }
          }
        }
      }
    }
    trackingChartDataList.add(data2);

    for(int i=0;i< trackingChartDataList[1].dayLevelDataList.length;i++) {
      if (trackingChartDataList[1].dayLevelDataList[i].activityLevelDataList.isEmpty) {
        updatePopUpMenuList(
            1,
            i,
            "");
      } else {
        for (int j = 0;
        j < trackingChartDataList[1].dayLevelDataList[i].activityLevelDataList.length;
        j++) {
          updatePopUpMenuList(
              1,
              i,
              trackingChartDataList[1].dayLevelDataList[i].activityLevelDataList[j]
                  .displayLabel.toString());
        }
      }
    }
  }

  getWeek3Data(
      DateTime dateParseStartPreviousWeek3,
      DateTime dateParseLastTimePreviousWeek3,
      List<ActivityTable> dataListHive) {
    List<DayLevelData> daysData = [];
    for (int i = 0; i < 7; i++) {
      var dates = DateTime(
          dateParseStartPreviousWeek3.year,
          dateParseStartPreviousWeek3.month,
          dateParseStartPreviousWeek3.day + i);
      String formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy).format(dates);
      String formattedDateDayName = DateFormat('EEE').format(dates);
      daysData.add(DayLevelData(formattedDateDayName, formattedDate, "Week 3",
          [],dates));
    }

    var data3 = WeekLevelData('Week 3', daysData, dateParseStartPreviousWeek3,
        dateParseLastTimePreviousWeek3);

    String formattedDateStartWeek3 =
    DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateParseStartPreviousWeek3);
    String formattedDateEndWeek3 =
    DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateParseLastTimePreviousWeek3);

    var matchedWeek3Data = dataListHive
        .where((element) =>
    element.weeksDate ==
        "$formattedDateStartWeek3-$formattedDateEndWeek3" && element.title == null && element.smileyType == null)
        .toList();


    if (matchedWeek3Data.isNotEmpty) {
      for (int k = 0; k < matchedWeek3Data.length; k++) {

        if(matchedWeek3Data[k].type == Constant.typeWeek && matchedWeek3Data[k].displayLabel == null ) {
          data3.smileyType = matchedWeek3Data[k].smileyType ?? Constant.defaultSmileyType;
          var value1Week = matchedWeek3Data[k].value1;
          if(value1Week != null) {
            data3.modMinController.text =
                double.parse(value1Week.toString()).toInt().toString();
            data3.modMinValue = value1Week.toInt();
          }else{
            data3.modMinController.text = "";
            data3.modMinValue = 0;
          }

          var value2Week = matchedWeek3Data[k].value2;
          if(value2Week != null) {
            data3.vigMinController.text =
                double.parse(value2Week.toString()).toInt().toString();
            data3.vigMinValue = value2Week.toInt();
          }else{
            data3.vigMinController.text = "";
            data3.vigMinValue = 0;
          }

          var totalWeek = matchedWeek3Data[k].total;
          if(totalWeek != null) {
            data3.totalMinController.text =
                double.parse(totalWeek.toString()).toInt().toString();
            data3.totalMinValue = totalWeek.toInt();
          }else{
            data3.totalMinController.text =
            "";
            data3.totalMinValue = 0;
          }


          data3.weeklyNotes = matchedWeek3Data[k].notes ?? "";
          data3.isOverride = matchedWeek3Data[k].isOverride;

        }
        else if (matchedWeek3Data[k].type == Constant.typeDay) {
          for (int l = 0; l < data3.dayLevelDataList.length; l++) {
            var matchedData = matchedWeek3Data
                .where(
                    (element) => element.date == data3.dayLevelDataList[l].date && element.type == Constant.typeDay)
                .toList();

            if(matchedData.isNotEmpty){
              data3.dayLevelDataList[l].smileyType = matchedData[0].smileyType ?? Constant.defaultSmileyType;

              var value1DayData = matchedData[0].value1;
              if(value1DayData == null){
                data3.dayLevelDataList[l].modMinValue = 0;
                data3.dayLevelDataList[l].modMinController.text = "";
              }else{
                data3.dayLevelDataList[l].modMinValue = value1DayData.toInt();
                data3.dayLevelDataList[l].modMinController.text = value1DayData.toInt().toString() ?? "";
              }

              var value2DayData = matchedData[0].value2;
              if(value2DayData == null){
                data3.dayLevelDataList[l].vigMinValue = 0;
                data3.dayLevelDataList[l].vigMinController.text = "";
              }else{
                data3.dayLevelDataList[l].vigMinValue = value2DayData.toInt();
                data3.dayLevelDataList[l].vigMinController.text = value2DayData.toInt().toString() ?? "";
              }

              var totalDayData = matchedData[0].total;
              if(totalDayData == null){
                data3.dayLevelDataList[l].totalMinValue = 0;
                data3.dayLevelDataList[l].totalMinController.text = "";
              }else{
                data3.dayLevelDataList[l].totalMinValue = totalDayData.toInt();
                data3.dayLevelDataList[l].totalMinController.text = totalDayData.toInt().toString() ?? "";
              }

              data3.dayLevelDataList[l].isOverride = matchedData[0].isOverride;
              data3.dayLevelDataList[l].dailyNotes = matchedData[0].notes ?? "";
            }
          }
          // Debug.printLog("typeDay....${matchedWeek3Data[k].dateTime}");
        }
        else if (matchedWeek3Data[k].type == Constant.typeDaysData) {

          for (int l = 0; l < data3.dayLevelDataList.length; l++) {
            if(data3.dayLevelDataList[l].date == matchedWeek3Data[k].date){
              // Debug.printLog("typeDaysData....${data3.weekDaysDataList.length}");

              var daysData = ActivityLevelData();
              daysData.storedDate = matchedWeek3Data[k].dateTime;
              daysData.titleName = matchedWeek3Data[k].name.toString();
              daysData.displayLabel = matchedWeek3Data[k].displayLabel.toString();
              daysData.smileyType = matchedWeek3Data[k].smileyType ?? Constant.defaultSmileyType;
              daysData.dayDataNotes = matchedWeek3Data[k].notes ?? "";
              daysData.iconPath = matchedWeek3Data[k].iconPath ?? "";
              daysData.activityStartDate = matchedWeek3Data[k].activityStartDate ?? (matchedWeek3Data[k].dateTime ?? DateTime.now());
              daysData.activityEndDate = matchedWeek3Data[k].activityEndDate ?? (matchedWeek3Data[k].dateTime ?? DateTime.now());
              daysData.isFromAppleHealth = matchedWeek3Data[k].isFromAppleHealth;
              // daysData.activityStartDateLast = matchedWeek3Data[k].activityStartDate ?? (matchedWeek3Data[k].dateTime ?? DateTime.now());
              // daysData.activityEndDateLast = matchedWeek3Data[k].activityEndDate ?? (matchedWeek3Data[k].dateTime ?? DateTime.now());

              var value1DayData = matchedWeek3Data[k].value1;
              if(value1DayData != null) {
                daysData.modMinValue = value1DayData.toInt();
                daysData.modMinController.text = value1DayData.toInt().toString();
              }else{
                daysData.modMinValue = null;
                daysData.modMinController.text = "";
              }

              var value2DayData = matchedWeek3Data[k].value2;
              if(value2DayData != null) {
                daysData.vigMinValue = value2DayData.toInt();
                daysData.vigMinController.text = value2DayData.toInt().toString();
              }else{
                daysData.vigMinValue = null;
                daysData.vigMinController.text = "";
              }

              var totalDayData = matchedWeek3Data[k].total;
              if(totalDayData != null) {
                daysData.totalMinValue = totalDayData.toInt();
                daysData.totalMinController.text = totalDayData.toInt().toString();
              }else{
                daysData.totalMinValue = null;
                daysData.totalMinController.text = "";
              }
              daysData.dayDataNotes = matchedWeek3Data[k].notes ?? "";

              daysData.isOverride = matchedWeek3Data[k].isOverride;
              data3.dayLevelDataList[l].activityLevelDataList.add(daysData);
            }
          }
        }
      }
    }
    trackingChartDataList.add(data3);

    for(int i=0;i< trackingChartDataList[2].dayLevelDataList.length;i++) {
      if (trackingChartDataList[2].dayLevelDataList[i].activityLevelDataList.isEmpty) {
        updatePopUpMenuList(
            2,
            i,
            "");
      } else {
        for (int j = 0;
        j < trackingChartDataList[2].dayLevelDataList[i].activityLevelDataList.length;
        j++) {
          updatePopUpMenuList(
              2,
              i,
              trackingChartDataList[2].dayLevelDataList[i].activityLevelDataList[j]
                  .displayLabel.toString());
        }
      }
    }
  }

  getWeek4Data(
      DateTime dateParseStartPreviousWeek4,
      DateTime dateParseLastTimePreviousWeek4,
      List<ActivityTable> dataListHive) {
    List<DayLevelData> daysData = [];
    for (int i = 0; i < 7; i++) {
      var dates = DateTime(dateParseStartPreviousWeek4.year, dateParseStartPreviousWeek4.month, dateParseStartPreviousWeek4.day + i);
      String formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy).format(dates);
      String formattedDateDayName = DateFormat('EEE').format(dates);
      // Debug.printLog("dates dateParseStartPreviousWeek4... $dates  $formattedDate  $formattedDateDayName");
      daysData.add(DayLevelData(formattedDateDayName,formattedDate,"Week 4",[],dates));
    }

    var data4 = WeekLevelData('Week 4',daysData,dateParseStartPreviousWeek4,dateParseLastTimePreviousWeek4);

    String formattedDateStartWeek4 = DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateParseStartPreviousWeek4);
    String formattedDateEndWeek4 = DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateParseLastTimePreviousWeek4);

    var matchedWeek4Data = dataListHive
        .where((element) =>
    element.weeksDate == "$formattedDateStartWeek4-$formattedDateEndWeek4" && element.title == null && element.smileyType == null)
        .toList();

    if (matchedWeek4Data.isNotEmpty) {
      for (int k = 0; k < matchedWeek4Data.length; k++) {

        if(matchedWeek4Data[k].type == Constant.typeWeek && matchedWeek4Data[k].displayLabel == null ) {
          data4.smileyType = matchedWeek4Data[k].smileyType ?? Constant.defaultSmileyType;

          var value1Week = matchedWeek4Data[k].value1;
          if(value1Week != null) {
            data4.modMinController.text =
                double.parse(value1Week.toString()).toInt().toString();
            data4.modMinValue = value1Week.toInt();
          }else{
            data4.modMinController.text = "";
            data4.modMinValue = 0;
          }

          var value2Week = matchedWeek4Data[k].value2;
          if(value2Week != null) {
            data4.vigMinController.text =
                double.parse(value2Week.toString()).toInt().toString();
            data4.vigMinValue = value2Week.toInt();
          }else{
            data4.vigMinController.text = "";
            data4.vigMinValue = 0;
          }

          var totalWeek = matchedWeek4Data[k].total;
          if(totalWeek != null) {
            data4.totalMinController.text =
                double.parse(totalWeek.toString()).toInt().toString();
            data4.totalMinValue = totalWeek.toInt();
          }else{
            data4.totalMinController.text =
            "";
            data4.totalMinValue = 0;
          }

          data4.weeklyNotes = matchedWeek4Data[k].notes ?? "";
          data4.isOverride = matchedWeek4Data[k].isOverride;

        }
        else if (matchedWeek4Data[k].type == Constant.typeDay) {
          for (int l = 0; l < data4.dayLevelDataList.length; l++) {
            var matchedData = matchedWeek4Data
                .where(
                    (element) => element.date == data4.dayLevelDataList[l].date && element.type == Constant.typeDay)
                .toList();

            if(matchedData.isNotEmpty){
              data4.dayLevelDataList[l].smileyType = matchedData[0].smileyType ?? Constant.defaultSmileyType;

              var value1DayData = matchedData[0].value1;
              if(value1DayData == null){
                data4.dayLevelDataList[l].modMinValue = 0;
                data4.dayLevelDataList[l].modMinController.text = "";
              }else{
                data4.dayLevelDataList[l].modMinValue = value1DayData.toInt();
                data4.dayLevelDataList[l].modMinController.text = value1DayData.toInt().toString() ?? "";
              }

              var value2DayData = matchedData[0].value2;
              if(value2DayData == null){
                data4.dayLevelDataList[l].vigMinValue = 0;
                data4.dayLevelDataList[l].vigMinController.text = "";
              }else{
                data4.dayLevelDataList[l].vigMinValue = value2DayData.toInt();
                data4.dayLevelDataList[l].vigMinController.text = value2DayData.toInt().toString() ?? "";
              }

              var totalDayData = matchedData[0].total;
              if(totalDayData == null){
                data4.dayLevelDataList[l].totalMinValue = 0;
                data4.dayLevelDataList[l].totalMinController.text = "";
              }else{
                data4.dayLevelDataList[l].totalMinValue = totalDayData.toInt();
                data4.dayLevelDataList[l].totalMinController.text = totalDayData.toInt().toString() ?? "";
              }


              data4.dayLevelDataList[l].dailyNotes = matchedData[0].notes ?? "";
              data4.dayLevelDataList[l].isOverride = matchedData[0].isOverride;
            }
          }
          // Debug.printLog("typeDay....${matchedWeek4Data[k].dateTime}");
        }
        else if (matchedWeek4Data[k].type == Constant.typeDaysData) {

          for (int l = 0; l < data4.dayLevelDataList.length; l++) {
            if(data4.dayLevelDataList[l].date == matchedWeek4Data[k].date){
              // Debug.printLog("typeDaysData....${data4.weekDaysDataList.length}");

              var daysData = ActivityLevelData();
              daysData.storedDate = matchedWeek4Data[k].dateTime;
              daysData.titleName = matchedWeek4Data[k].name.toString();
              daysData.displayLabel = matchedWeek4Data[k].displayLabel.toString();
              daysData.smileyType = matchedWeek4Data[k].smileyType ?? Constant.defaultSmileyType;
              daysData.dayDataNotes = matchedWeek4Data[k].notes ?? "";
              daysData.iconPath = matchedWeek4Data[k].iconPath ?? "";
              daysData.isFromAppleHealth = matchedWeek4Data[k].isFromAppleHealth;

              daysData.activityStartDate = matchedWeek4Data[k].activityStartDate ?? (matchedWeek4Data[k].dateTime ?? DateTime.now());
              daysData.activityEndDate = matchedWeek4Data[k].activityEndDate ?? (matchedWeek4Data[k].dateTime ?? DateTime.now());
              // daysData.activityStartDateLast = matchedWeek4Data[k].activityStartDate ?? (matchedWeek4Data[k].dateTime ?? DateTime.now());
              // daysData.activityEndDateLast = matchedWeek4Data[k].activityEndDate ?? (matchedWeek4Data[k].dateTime ?? DateTime.now());

              var value1DayData = matchedWeek4Data[k].value1;
              if(value1DayData != null) {
                daysData.modMinValue = value1DayData.toInt();
                daysData.modMinController.text = value1DayData.toInt().toString();
              }else{
                daysData.modMinValue = null;
                daysData.modMinController.text = "";
              }

              var value2DayData = matchedWeek4Data[k].value2;
              if(value2DayData != null) {
                daysData.vigMinValue = value2DayData.toInt();
                daysData.vigMinController.text = value2DayData.toInt().toString();
              }else{
                daysData.vigMinValue = null;
                daysData.vigMinController.text = "";
              }

              var totalDayData = matchedWeek4Data[k].total;
              if(totalDayData != null) {
                daysData.totalMinValue = totalDayData.toInt();
                daysData.totalMinController.text = totalDayData.toInt().toString();
              }else{
                daysData.totalMinValue = null;
                daysData.totalMinController.text = "";
              }

              daysData.dayDataNotes = matchedWeek4Data[k].notes ?? "";
              daysData.isOverride = matchedWeek4Data[k].isOverride;
              data4.dayLevelDataList[l].activityLevelDataList.add(daysData);
            }
          }
        }
      }
    }
    trackingChartDataList.add(data4);

    for(int i=0;i< trackingChartDataList[3].dayLevelDataList.length;i++){
      if (trackingChartDataList[3].dayLevelDataList[i].activityLevelDataList.isEmpty) {
        updatePopUpMenuList(
            3,
            i,
            "");
      } else {
        for (int j = 0;
        j < trackingChartDataList[3].dayLevelDataList[i].activityLevelDataList.length;
        j++) {
          updatePopUpMenuList(
              3,
              i,
              trackingChartDataList[3].dayLevelDataList[i].activityLevelDataList[j]
                  .displayLabel.toString());
        }
      }
    }
  }

  getWeek5Data(
      DateTime dateParseStartPreviousWeek5,
      DateTime dateParseLastTimePreviousWeek5,
      List<ActivityTable> dataListHive) {
    List<DayLevelData> daysData = [];
    for (int i = 0; i < 7; i++) {
      var dates = DateTime(dateParseStartPreviousWeek5.year, dateParseStartPreviousWeek5.month, dateParseStartPreviousWeek5.day + i);
      String formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy).format(dates);
      String formattedDateDayName = DateFormat('EEE').format(dates);
      // Debug.printLog("dates dateParseStartPreviousWeek5... $dates  $formattedDate  $formattedDateDayName");
      daysData.add(DayLevelData(formattedDateDayName,formattedDate,"Week 5",[],dates));
    }

    var data5 = WeekLevelData('Week 5',daysData,dateParseStartPreviousWeek5,dateParseLastTimePreviousWeek5);

    String formattedDateStartWeek5 = DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateParseStartPreviousWeek5);
    String formattedDateEndWeek5 = DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateParseLastTimePreviousWeek5);

    var matchedWeek5Data = dataListHive
        .where((element) =>
    element.weeksDate == "$formattedDateStartWeek5-$formattedDateEndWeek5" && element.title == null && element.smileyType == null)
        .toList();

    if (matchedWeek5Data.isNotEmpty) {
      for (int k = 0; k < matchedWeek5Data.length; k++) {

        if(matchedWeek5Data[k].type == Constant.typeWeek && matchedWeek5Data[k].displayLabel == null ) {
          data5.smileyType = matchedWeek5Data[k].smileyType ?? Constant.defaultSmileyType;

          var value1Week = matchedWeek5Data[k].value1;
          if(value1Week != null) {
            data5.modMinController.text =
                double.parse(value1Week.toString()).toInt().toString();
            data5.modMinValue = value1Week.toInt();
          }else{
            data5.modMinController.text = "";
            data5.modMinValue = 0;
          }

          var value2Week = matchedWeek5Data[k].value2;
          if(value2Week != null) {
            data5.vigMinController.text =
                double.parse(value2Week.toString()).toInt().toString();
            data5.vigMinValue = value2Week.toInt();
          }else{
            data5.vigMinController.text = "";
            data5.vigMinValue = 0;
          }

          var totalWeek = matchedWeek5Data[k].total;
          if(totalWeek != null) {
            data5.totalMinController.text =
                double.parse(totalWeek.toString()).toInt().toString();
            data5.totalMinValue = totalWeek.toInt();
          }else{
            data5.totalMinController.text =
                "";
            data5.totalMinValue = 0;
          }
          data5.weeklyNotes = matchedWeek5Data[k].notes ?? "";
          data5.isOverride = matchedWeek5Data[k].isOverride;
        }
        else if (matchedWeek5Data[k].type == Constant.typeDay) {
          for (int l = 0; l < data5.dayLevelDataList.length; l++) {
            var matchedData = matchedWeek5Data
                .where(
                    (element) => element.date == data5.dayLevelDataList[l].date && element.type == Constant.typeDay)
                .toList();

            if(matchedData.isNotEmpty){
              data5.dayLevelDataList[l].smileyType = matchedData[0].smileyType ?? Constant.defaultSmileyType;

              var value1DayData = matchedData[0].value1;
              if(value1DayData == null){
                data5.dayLevelDataList[l].modMinValue = 0;
                data5.dayLevelDataList[l].modMinController.text = "";
              }else{
                data5.dayLevelDataList[l].modMinValue = value1DayData.toInt();
                data5.dayLevelDataList[l].modMinController.text = value1DayData.toInt().toString() ?? "";
              }

              var value2DayData = matchedData[0].value2;
              if(value2DayData == null){
                data5.dayLevelDataList[l].vigMinValue = 0;
                data5.dayLevelDataList[l].vigMinController.text = "";
              }else{
                data5.dayLevelDataList[l].vigMinValue = value2DayData.toInt();
                data5.dayLevelDataList[l].vigMinController.text = value2DayData.toInt().toString() ?? "";
              }

              var totalDayData = matchedData[0].total;
              if(totalDayData == null){
                data5.dayLevelDataList[l].totalMinValue = 0;
                data5.dayLevelDataList[l].totalMinController.text = "";
              }else{
                data5.dayLevelDataList[l].totalMinValue = totalDayData.toInt();
                data5.dayLevelDataList[l].totalMinController.text = totalDayData.toInt().toString() ?? "";
              }


              data5.dayLevelDataList[l].dailyNotes = matchedData[0].notes ?? "";
              data5.dayLevelDataList[l].isOverride = matchedData[0].isOverride;
            }
          }
          Debug.printLog("typeDay....${matchedWeek5Data[k].dateTime}");
        }
        else if (matchedWeek5Data[k].type == Constant.typeDaysData) {

          for (int l = 0; l < data5.dayLevelDataList.length; l++) {
            if(data5.dayLevelDataList[l].date == matchedWeek5Data[k].date){
              Debug.printLog("typeDaysData....${data5.dayLevelDataList.length}");

              var daysData = ActivityLevelData();
              daysData.storedDate = matchedWeek5Data[k].dateTime;
              daysData.titleName = matchedWeek5Data[k].name.toString();
              daysData.displayLabel = matchedWeek5Data[k].displayLabel.toString();
              daysData.smileyType = matchedWeek5Data[k].smileyType ?? Constant.defaultSmileyType;
              daysData.dayDataNotes = matchedWeek5Data[k].notes ?? "";
              daysData.iconPath = matchedWeek5Data[k].iconPath ?? "";
              daysData.isFromAppleHealth = matchedWeek5Data[k].isFromAppleHealth;
              daysData.activityStartDate = matchedWeek5Data[k].activityStartDate ?? (matchedWeek5Data[k].dateTime ?? DateTime.now());
              daysData.activityEndDate = matchedWeek5Data[k].activityEndDate ?? (matchedWeek5Data[k].dateTime ?? DateTime.now());

              // daysData.activityStartDateLast = matchedWeek5Data[k].activityStartDate ?? (matchedWeek5Data[k].dateTime ?? DateTime.now());
              // daysData.activityEndDateLast = matchedWeek5Data[k].activityEndDate ?? (matchedWeek5Data[k].dateTime ?? DateTime.now());

              var value1DayData = matchedWeek5Data[k].value1;
              if(value1DayData != null) {
                daysData.modMinValue = value1DayData.toInt();
                daysData.modMinController.text = value1DayData.toInt().toString();
              }else{
                daysData.modMinValue = null;
                daysData.modMinController.text = "";
              }

              var value2DayData = matchedWeek5Data[k].value2;
              if(value2DayData != null) {
                daysData.vigMinValue = value2DayData.toInt();
                daysData.vigMinController.text = value2DayData.toInt().toString();
              }else{
                daysData.vigMinValue = null;
                daysData.vigMinController.text = "";
              }

              var totalDayData = matchedWeek5Data[k].total;
              if(totalDayData != null) {
                daysData.totalMinValue = totalDayData.toInt();
                daysData.totalMinController.text = totalDayData.toInt().toString();
              }else{
                daysData.totalMinValue = null;
                daysData.totalMinController.text = "";
              }
              daysData.dayDataNotes = matchedWeek5Data[k].notes ?? "";

              daysData.isOverride = matchedWeek5Data[k].isOverride;
              data5.dayLevelDataList[l].activityLevelDataList.add(daysData);
            }
          }
        }
      }
    }
    trackingChartDataList.add(data5);

    for(int i=0;i< trackingChartDataList[4].dayLevelDataList.length;i++) {

      if(trackingChartDataList[4].dayLevelDataList[i].activityLevelDataList.isEmpty){
        updatePopUpMenuList(
            4,
            i,
            "");
      }else {
        for (int j = 0;
        j < trackingChartDataList[4].dayLevelDataList[i].activityLevelDataList.length;
        j++) {
          updatePopUpMenuList(
              4,
              i,
              trackingChartDataList[4].dayLevelDataList[i].activityLevelDataList[j]
                  .displayLabel.toString());
        }
      }
    }
  }


  getWeek1DataOtherTitles(
      DateTime dateParseStartPreviousWeek1,
      DateTime dateParseLastTimePreviousWeek1,
      List<ActivityTable> dataListHive) {
    List<CaloriesStepHeartRateDay> daysData = [];
    List<OtherTitles2CheckBoxDay> daysDataCheckBox = [];

    // for (int j = 0; j < 5; j++) {
      for (int j = 0; j < 6; j++) {
      daysData = [];
      daysDataCheckBox = [];
      var titleName = "";
      for (int i = 0; i < 7; i++) {
        var dates = DateTime(
            dateParseStartPreviousWeek1.year,
            dateParseStartPreviousWeek1.month,
            dateParseStartPreviousWeek1.day + i);
        String formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy).format(dates);
        String formattedDateDayName = DateFormat('EEE').format(dates);
        // Debug.printLog(
        //     "dates getWeek1DataOtherTitles... $dates  $formattedDate  $formattedDateDayName");
        daysDataCheckBox.add(OtherTitles2CheckBoxDay(
            // formattedDateDayName, formattedDate, 'Week 1', 'Title A B C 2', [],
            formattedDateDayName, formattedDate, 'Week 1', Constant.titleDaysStr, [],
            dates,false));
        if(j+2 == 2){
          titleName = Constant.titleDaysStr;
        }else if(j+2 == 3){
          titleName = Constant.titleCalories;
        }else if(j+2 == 4){
          titleName = Constant.titleSteps;
        }else if(j+2 == 5){
          titleName = Constant.titleHeartRateRest;
        }else if(j+2 == 6){
          titleName = Constant.titleHeartRatePeak;
        }else if(j+2 == 7){
          titleName = Constant.titleExperience;
        }
        daysData.add(CaloriesStepHeartRateDay(
            // formattedDateDayName, formattedDate, 'Week 1', 'Title A B C ${j+2}', [],
            formattedDateDayName, formattedDate, 'Week 1', titleName, [],
            dates));
      }
      var dataCheckBox = OtherTitles2CheckBoxWeek(
          'Week 1', daysDataCheckBox, dateParseStartPreviousWeek1,
          // dateParseLastTimePreviousWeek1,'Title A B C 2');
          dateParseLastTimePreviousWeek1,Constant.titleDaysStr);

      var data = CaloriesStepHeartRateWeek(
          'Week 1', daysData, dateParseStartPreviousWeek1,
          // dateParseLastTimePreviousWeek1,'Title A B C ${j+2}');
          dateParseLastTimePreviousWeek1,titleName);

      String formattedDateStart =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateParseStartPreviousWeek1);
      String formattedDateEnd =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateParseLastTimePreviousWeek1);

      var matchedWeekOtherTitleData = dataListHive
          .where((element) =>
      element.weeksDate == "$formattedDateStart-$formattedDateEnd")
          .toList();
      if(matchedWeekOtherTitleData.isNotEmpty){
        var title = "";
        if(j == 0) {
          title = Constant.titleDaysStr;
        }else if(j == 1) {
          title = Constant.titleCalories;
        }else if(j == 2) {
          title = Constant.titleSteps;
        }else if(j == 3) {
          title = Constant.titleHeartRateRest;
        }else if(j == 4) {
          title = Constant.titleHeartRatePeak;
        }else if(j == 5){
          title = Constant.titleExperience;
        }

        for (int k = 0; k < matchedWeekOtherTitleData.length; k++) {

          if(title == Constant.titleDaysStr){

            if (matchedWeekOtherTitleData[k].type == Constant.typeWeek
                && matchedWeekOtherTitleData[k].title == Constant.titleDaysStr) {

              var daysData = OtherTitles2CheckBoxDaysData();
              daysData.titleName = Constant.titleDaysStr;
              if (matchedWeekOtherTitleData[k].total != null) {
                dataCheckBox.total = matchedWeekOtherTitleData[k].total!.toInt();
                dataCheckBox.weekValueTitle2CheckBoxController.text =
                    matchedWeekOtherTitleData[k].total!.toInt().toString();
              }
            }

            else if (matchedWeekOtherTitleData[k].type == Constant.typeDay
                && matchedWeekOtherTitleData[k].title == Constant.titleDaysStr) {
              for (int l = 0; l < dataCheckBox.daysListCheckBox.length; l++) {
                var matchedData = matchedWeekOtherTitleData
                    .where(
                        (element) =>
                    element.date == dataCheckBox.daysListCheckBox[l].date &&
                        element.title == Constant.titleDaysStr && element.type == Constant.typeDay)
                    .toList();
                if (matchedData.isNotEmpty) {
                  dataCheckBox.daysListCheckBox[l].titleName = Constant.titleDaysStr;
                  dataCheckBox.daysListCheckBox[l].isCheckedDay = matchedData[0].isCheckedDay  ?? false;
                }
              }
            }

            else if (matchedWeekOtherTitleData[k].type == Constant.typeDaysData
                && matchedWeekOtherTitleData[k].title == Constant.titleDaysStr) {
              for (int l = 0; l < dataCheckBox.daysListCheckBox.length; l++) {
                if (dataCheckBox.daysListCheckBox[l].date == matchedWeekOtherTitleData[k].date &&
                    dataCheckBox.daysListCheckBox[l].titleName == Constant.titleDaysStr) {

                  var daysData = OtherTitles2CheckBoxDaysData();
                  daysData.storedDate = matchedWeekOtherTitleData[k].dateTime;
                  daysData.titleName = Constant.titleDaysStr;

                  daysData.isCheckedDaysData = matchedWeekOtherTitleData[k].isCheckedDayData  ?? false;
                  if(matchedWeekOtherTitleData[k].isCheckedDayData != null &&
                      matchedWeekOtherTitleData[k].isCheckedDayData == true){
                    // daysDataCheckBox[i].isCheckedDay = true;
                  }

                  dataCheckBox.daysListCheckBox[l].daysDataListCheckBox.add(daysData);
                }
              }
            }


          }
          else if(title == Constant.titleExperience){
            if (matchedWeekOtherTitleData[k].type == Constant.typeWeek &&
                matchedWeekOtherTitleData[k].title == null &&
                matchedWeekOtherTitleData[k].total == null &&
                matchedWeekOtherTitleData[k].smileyType != null) {

              var daysData = CaloriesStepHeartRateData();
              daysData.titleName = matchedWeekOtherTitleData[k].title.toString();
              daysData.smileyType = matchedWeekOtherTitleData[k].smileyType ?? Constant.defaultSmileyType;
            }

            else if (matchedWeekOtherTitleData[k].type == Constant.typeDay &&
                matchedWeekOtherTitleData[k].title == null &&
                matchedWeekOtherTitleData[k].smileyType != null) {
              for (int l = 0; l < data.daysList.length; l++) {
                var matchedData = matchedWeekOtherTitleData
                    .where(
                        (element) =>
                    element.date == data.daysList[l].date &&
                        element.title == null && element.smileyType != null
                        && element.total == null && element.type == Constant.typeDay)
                    .toList();

                if (matchedData.isNotEmpty) {
                  data.daysList[l].smileyType = matchedData[0].smileyType ?? Constant.defaultSmileyType;
                }
              }
            }

            else
            if (matchedWeekOtherTitleData[k].type == Constant.typeDaysData &&
                matchedWeekOtherTitleData[k].title == null &&
                matchedWeekOtherTitleData[k].total == null &&
                matchedWeekOtherTitleData[k].smileyType != null) {
              for (int l = 0; l < data.daysList.length; l++) {
                if (data.daysList[l].date ==
                    matchedWeekOtherTitleData[k].date) {
                  var daysData = CaloriesStepHeartRateData();
                  daysData.storedDate = matchedWeekOtherTitleData[k].dateTime;
                  daysData.titleName = matchedWeekOtherTitleData[k].title.toString();
                  daysData.smileyType = matchedWeekOtherTitleData[k].smileyType ?? Constant.defaultSmileyType;
                  daysData.isFromAppleHealth = matchedWeekOtherTitleData[k].isFromAppleHealth;
                  data.daysList[l].daysDataList.add(daysData);
                }
              }
            }

          }
          else {

            if (matchedWeekOtherTitleData[k].type == Constant.typeWeek &&
                matchedWeekOtherTitleData[k].title == title) {

              var daysData = CaloriesStepHeartRateData();
              daysData.titleName =
                  matchedWeekOtherTitleData[k].title.toString();
              if (daysData.titleName == Constant.titleHeartRateRest &&
                  matchedWeekOtherTitleData[k].total != null && matchedWeekOtherTitleData[k].total!.toInt() > 0) {
                data.total = matchedWeekOtherTitleData[k].total!.toInt();
                data.weekValue1Title5Title5Controller.text =
                    matchedWeekOtherTitleData[k].total!.toInt().toString();
              }
              else if (daysData.titleName == Constant.titleHeartRatePeak &&
                  matchedWeekOtherTitleData[k].total != null && matchedWeekOtherTitleData[k].total!.toInt() > 0) {
                data.total = matchedWeekOtherTitleData[k].total!.toInt();
                data.weekValue2Title5Controller.text =
                    matchedWeekOtherTitleData[k].total!.toInt().toString();
              }
              else if (matchedWeekOtherTitleData[k].total != null &&
                  daysData.titleName != Constant.titleHeartRateRest &&
                  daysData.titleName != Constant.titleHeartRatePeak && matchedWeekOtherTitleData[k].total!.toInt() > 0) {
                data.total = matchedWeekOtherTitleData[k].total!.toInt();
                data.weekValueTitleController.text =
                    matchedWeekOtherTitleData[k].total!.toInt().toString();
              }
            }

            else if (matchedWeekOtherTitleData[k].type == Constant.typeDay &&
                matchedWeekOtherTitleData[k].title == title) {
              for (int l = 0; l < data.daysList.length; l++) {
                var matchedData = matchedWeekOtherTitleData
                    .where(
                        (element) =>
                    element.date == data.daysList[l].date &&
                        element.title == title && element.type == Constant.typeDay)
                    .toList();

                if (matchedData.isNotEmpty) {
                  if (matchedData[0].total != null) {
                    if (data.daysList[l].titleName == Constant.titleHeartRateRest) {
                      data.daysList[l].total =
                          double.parse(matchedData[0].total.toString()).toInt();
                      data.daysList[l].daysValue1Title5Controller.text =
                          double.parse(matchedData[0].total.toString())
                              .toInt()
                              .toString();
                    } else if (data.daysList[l].titleName == Constant.titleHeartRatePeak
                        && matchedData[0].total != null) {
                      data.daysList[l].total =
                          double.parse(matchedData[0].total.toString()).toInt();
                      data.daysList[l].daysValue2Title5Controller.text =
                          double.parse(matchedData[0].total.toString())
                              .toInt()
                              .toString();
                    } else if (matchedData[0].total != null &&
                        data.daysList[l].titleName != Constant.titleHeartRateRest &&
                        data.daysList[l].titleName != Constant.titleHeartRatePeak) {
                      data.daysList[l].total =
                          double.parse(matchedData[0].total.toString()).toInt();
                      data.daysList[l].daysValueTitleController.text =
                          double.parse(matchedData[0].total.toString())
                              .toInt()
                              .toString();
                    }
                  }
                }
              }
            }

            else if (matchedWeekOtherTitleData[k].type ==
                Constant.typeDaysData &&
                matchedWeekOtherTitleData[k].title == title) {
              for (int l = 0; l < data.daysList.length; l++) {
                if (data.daysList[l].date ==
                    matchedWeekOtherTitleData[k].date) {


                  var daysData = CaloriesStepHeartRateData();
                  daysData.storedDate =
                      matchedWeekOtherTitleData[k].dateTime;
                  daysData.titleName =
                      matchedWeekOtherTitleData[k].title.toString();
                  if (daysData.titleName == Constant.titleHeartRateRest) {
                    if(matchedWeekOtherTitleData[k].total != null) {
                      daysData.total =
                          matchedWeekOtherTitleData[k].total!.toInt();
                      daysData.daysDataValue1Title5Controller.text =
                          matchedWeekOtherTitleData[k].total!
                              .toInt()
                              .toString();
                    }
                    daysData.activityName = matchedWeekOtherTitleData[k].displayLabel ?? "";
                    daysData.activityStartDate = matchedWeekOtherTitleData[k].activityStartDate ?? DateTime.now();
                    daysData.activityEndDate = matchedWeekOtherTitleData[k].activityEndDate ?? DateTime.now();
                    daysData.isFromAppleHealth = matchedWeekOtherTitleData[k].isFromAppleHealth;
                  }
                  else if (daysData.titleName == Constant.titleHeartRatePeak) {
                    if(matchedWeekOtherTitleData[k].total != null) {
                      daysData.total =
                          matchedWeekOtherTitleData[k].total!.toInt();
                      daysData.daysDataValue2Title5Controller.text =
                          matchedWeekOtherTitleData[k].total!
                              .toInt()
                              .toString();
                    }
                    daysData.activityName = matchedWeekOtherTitleData[k].displayLabel ?? "";
                    daysData.activityStartDate = matchedWeekOtherTitleData[k].activityStartDate ?? DateTime.now();
                    daysData.activityEndDate = matchedWeekOtherTitleData[k].activityEndDate ?? DateTime.now();
                    daysData.isFromAppleHealth = matchedWeekOtherTitleData[k].isFromAppleHealth;
                  }
                  else if (daysData.titleName != Constant.titleHeartRateRest &&
                      daysData.titleName != Constant.titleHeartRatePeak) {
                    if(matchedWeekOtherTitleData[k].total != null) {
                      daysData.total =
                          matchedWeekOtherTitleData[k].total!.toInt();
                      daysData.daysDataValueTitleController.text =
                          matchedWeekOtherTitleData[k].total!
                              .toInt()
                              .toString();
                    }
                    daysData.activityName = matchedWeekOtherTitleData[k].displayLabel ?? "";
                    daysData.activityStartDate = matchedWeekOtherTitleData[k].activityStartDate ?? DateTime.now();
                    daysData.activityEndDate = matchedWeekOtherTitleData[k].activityEndDate ?? DateTime.now();
                    daysData.isFromAppleHealth = matchedWeekOtherTitleData[k].isFromAppleHealth;
                  }

                  data.daysList[l].daysDataList.add(daysData);
                }
              }
            }

          }

        }
      }

      if(j == 0) {
        if(dataCheckBox.daysListCheckBox.isNotEmpty){
          for (int a = 0; a < dataCheckBox.daysListCheckBox.length; a++) {
            var selectedCheckBoxList = dataCheckBox.daysListCheckBox[a].daysDataListCheckBox
                .where((element) => element.isCheckedDaysData).toList();
            if(selectedCheckBoxList.isNotEmpty){
              dataCheckBox.daysListCheckBox[a].isCheckedDay = true;
            }
          }
        }
        daysStrengthDataList.add(dataCheckBox);
      }else if(j == 1) {
        caloriesDataList.add(data);
      }else if(j == 2) {
        stepsDataList.add(data);
      }else if(j == 3) {
        heartRateRestDataList.add(data);
      }else if(j == 4) {
        heartRatePeakDataList.add(data);
      }else if(j == 5) {
        experienceDataList.add(data);
      }
    }

  }

  getWeek2DataOtherTitles(
      DateTime dateParseStartPreviousWeek2,
      DateTime dateParseLastTimePreviousWeek2,
      List<ActivityTable> dataListHive) {
    List<CaloriesStepHeartRateDay> daysData = [];
    List<OtherTitles2CheckBoxDay> daysDataCheckBox = [];

    // for (int j = 0; j < 5; j++) {
      for (int j = 0; j < 6; j++) {
      daysData = [];
      daysDataCheckBox = [];
      var titleName = "";
      for (int i = 0; i < 7; i++) {
        var dates = DateTime(
            dateParseStartPreviousWeek2.year,
            dateParseStartPreviousWeek2.month,
            dateParseStartPreviousWeek2.day + i);
        String formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy).format(dates);
        String formattedDateDayName = DateFormat('EEE').format(dates);
        // Debug.printLog(
        //     "dates getWeek1DataOtherTitles... $dates  $formattedDate  $formattedDateDayName");
        daysDataCheckBox.add(OtherTitles2CheckBoxDay(
            // formattedDateDayName, formattedDate, 'Week 2', 'Title A B C 2', [],
            formattedDateDayName, formattedDate, 'Week 2', Constant.titleDaysStr, [],
            dates,false));
        if(j+2 == 2){
          titleName = Constant.titleDaysStr;
        }else if(j+2 == 3){
          titleName = Constant.titleCalories;
        }else if(j+2 == 4){
          titleName = Constant.titleSteps;
        }else if(j+2 == 5){
          titleName = Constant.titleHeartRateRest;
        }else if(j+2 == 6){
          titleName = Constant.titleHeartRatePeak;
        }else if(j+2 == 7){
          titleName = Constant.titleExperience;
        }
        daysData.add(CaloriesStepHeartRateDay(
            // formattedDateDayName, formattedDate, 'Week 2', 'Title A B C ${j+2}', [],
            formattedDateDayName, formattedDate, 'Week 2', titleName, [],
            dates));
      }
      var dataCheckBox = OtherTitles2CheckBoxWeek(
          'Week 2', daysDataCheckBox, dateParseStartPreviousWeek2,
          // dateParseLastTimePreviousWeek2,'Title A B C 2');
          dateParseLastTimePreviousWeek2,Constant.titleDaysStr);

      var data = CaloriesStepHeartRateWeek(
          'Week 2', daysData, dateParseStartPreviousWeek2,
          dateParseLastTimePreviousWeek2,titleName);
          // dateParseLastTimePreviousWeek2,'Title A B C ${j+2}');
      //
      String formattedDateStart =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateParseStartPreviousWeek2);
      String formattedDateEnd =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateParseLastTimePreviousWeek2);

      var matchedWeekOtherTitleDataWeek2 = dataListHive
          .where((element) =>
      element.weeksDate == "$formattedDateStart-$formattedDateEnd")
          .toList();

      if(matchedWeekOtherTitleDataWeek2.isNotEmpty){
        var title = "";
        if(j == 0) {
          title = Constant.titleDaysStr;
        }else if(j == 1) {
          title = Constant.titleCalories;
        }else if(j == 2) {
          title = Constant.titleSteps;
        }else if(j == 3) {
          title = Constant.titleHeartRateRest;
        }else if(j == 4) {
          title = Constant.titleHeartRatePeak;
        }else if(j == 5) {
          title = Constant.titleExperience;
        }

        for (int k = 0; k < matchedWeekOtherTitleDataWeek2.length; k++) {

          if(title == Constant.titleDaysStr){

            if (matchedWeekOtherTitleDataWeek2[k].type == Constant.typeWeek
                && matchedWeekOtherTitleDataWeek2[k].title == Constant.titleDaysStr) {

              var daysData = OtherTitles2CheckBoxDaysData();
              daysData.titleName = Constant.titleDaysStr;
              if (matchedWeekOtherTitleDataWeek2[k].total != null) {
                dataCheckBox.total = matchedWeekOtherTitleDataWeek2[k].total!.toInt();
                dataCheckBox.weekValueTitle2CheckBoxController.text =
                    matchedWeekOtherTitleDataWeek2[k].total!.toInt().toString();
              }
            }

            else if (matchedWeekOtherTitleDataWeek2[k].type == Constant.typeDay
                && matchedWeekOtherTitleDataWeek2[k].title == Constant.titleDaysStr) {
              for (int l = 0; l < dataCheckBox.daysListCheckBox.length; l++) {
                var matchedData = matchedWeekOtherTitleDataWeek2
                    .where(
                        (element) =>
                    element.date == dataCheckBox.daysListCheckBox[l].date &&
                        element.title == Constant.titleDaysStr && element.type == Constant.typeDay)
                    .toList();
                if (matchedData.isNotEmpty) {
                  dataCheckBox.daysListCheckBox[l].titleName = Constant.titleDaysStr;
                  dataCheckBox.daysListCheckBox[l].isCheckedDay = matchedData[0].isCheckedDay  ?? false;
                }
              }
            }

            else if (matchedWeekOtherTitleDataWeek2[k].type == Constant.typeDaysData
                && matchedWeekOtherTitleDataWeek2[k].title == Constant.titleDaysStr) {
              for (int l = 0; l < dataCheckBox.daysListCheckBox.length; l++) {
                if (dataCheckBox.daysListCheckBox[l].date == matchedWeekOtherTitleDataWeek2[k].date
                    && dataCheckBox.daysListCheckBox[l].titleName == Constant.titleDaysStr) {

                  var daysData = OtherTitles2CheckBoxDaysData();
                  daysData.storedDate = matchedWeekOtherTitleDataWeek2[k].dateTime;
                  daysData.titleName = Constant.titleDaysStr;

                  daysData.isCheckedDaysData = matchedWeekOtherTitleDataWeek2[k].isCheckedDayData  ?? false;


                  dataCheckBox.daysListCheckBox[l].daysDataListCheckBox.add(daysData);
                }
              }
            }

          }
          else if(title == Constant.titleExperience){
            if (matchedWeekOtherTitleDataWeek2[k].type == Constant.typeWeek &&
                matchedWeekOtherTitleDataWeek2[k].title == null &&
                matchedWeekOtherTitleDataWeek2[k].smileyType != null) {

              var daysData = CaloriesStepHeartRateData();
              daysData.titleName = matchedWeekOtherTitleDataWeek2[k].title.toString();
              daysData.smileyType = matchedWeekOtherTitleDataWeek2[k].smileyType ?? Constant.defaultSmileyType;
            }

            else if (matchedWeekOtherTitleDataWeek2[k].type == Constant.typeDay &&
                matchedWeekOtherTitleDataWeek2[k].title == null &&
                matchedWeekOtherTitleDataWeek2[k].total == null &&
                matchedWeekOtherTitleDataWeek2[k].smileyType != null) {
              for (int l = 0; l < data.daysList.length; l++) {
                var matchedData = matchedWeekOtherTitleDataWeek2
                    .where(
                        (element) =>
                    element.date == data.daysList[l].date &&
                        element.title == null && element.smileyType != null
                        && element.total == null && element.type == Constant.typeDay )
                    .toList();

                if (matchedData.isNotEmpty) {
                  data.daysList[l].smileyType = matchedData[0].smileyType ?? Constant.defaultSmileyType;
                }
              }
            }

            else
            if (matchedWeekOtherTitleDataWeek2[k].type == Constant.typeDaysData &&
                matchedWeekOtherTitleDataWeek2[k].title == null &&
                matchedWeekOtherTitleDataWeek2[k].total == null &&
                matchedWeekOtherTitleDataWeek2[k].smileyType != null) {
              for (int l = 0; l < data.daysList.length; l++) {
                if (data.daysList[l].date ==
                    matchedWeekOtherTitleDataWeek2[k].date) {
                  var daysData = CaloriesStepHeartRateData();
                  daysData.storedDate = matchedWeekOtherTitleDataWeek2[k].dateTime;
                  daysData.titleName = matchedWeekOtherTitleDataWeek2[k].title.toString();
                  daysData.smileyType = matchedWeekOtherTitleDataWeek2[k].smileyType ?? Constant.defaultSmileyType;
                  daysData.isFromAppleHealth = matchedWeekOtherTitleDataWeek2[k].isFromAppleHealth;
                  data.daysList[l].daysDataList.add(daysData);
                }
              }
            }

          }
          else {

            if (matchedWeekOtherTitleDataWeek2[k].type == Constant.typeWeek &&
                matchedWeekOtherTitleDataWeek2[k].title == title) {

              var daysData = CaloriesStepHeartRateData();
              daysData.titleName =
                  matchedWeekOtherTitleDataWeek2[k].title.toString();
              if (daysData.titleName == Constant.titleHeartRateRest &&
                  matchedWeekOtherTitleDataWeek2[k].total != null && matchedWeekOtherTitleDataWeek2[k].total!.toInt() > 0) {
                data.total = matchedWeekOtherTitleDataWeek2[k].total!.toInt();
                data.weekValue1Title5Title5Controller.text =
                    matchedWeekOtherTitleDataWeek2[k].total!.toInt().toString();
              }
              else if (daysData.titleName == Constant.titleHeartRatePeak &&
                  matchedWeekOtherTitleDataWeek2[k].total != null && matchedWeekOtherTitleDataWeek2[k].total!.toInt() > 0) {
                data.total = matchedWeekOtherTitleDataWeek2[k].total!.toInt();
                data.weekValue2Title5Controller.text =
                    matchedWeekOtherTitleDataWeek2[k].total!.toInt().toString();
              }
              else if (matchedWeekOtherTitleDataWeek2[k].total != null &&
                  daysData.titleName != Constant.titleHeartRateRest &&
                  daysData.titleName != Constant.titleHeartRatePeak && matchedWeekOtherTitleDataWeek2[k].total!.toInt() > 0) {
                data.total = matchedWeekOtherTitleDataWeek2[k].total!.toInt();
                data.weekValueTitleController.text =
                    matchedWeekOtherTitleDataWeek2[k].total!.toInt().toString();
              }
            }

            else if (matchedWeekOtherTitleDataWeek2[k].type == Constant.typeDay &&
                matchedWeekOtherTitleDataWeek2[k].title == title) {
              for (int l = 0; l < data.daysList.length; l++) {
                var matchedData = matchedWeekOtherTitleDataWeek2
                    .where(
                        (element) =>
                    element.date == data.daysList[l].date &&
                        element.title == title && element.type == Constant.typeDay)
                    .toList();

                if (matchedData.isNotEmpty) {
                  if (matchedData[0].total != null) {
                    if (data.daysList[l].titleName == Constant.titleHeartRateRest) {
                      data.daysList[l].total =
                          double.parse(matchedData[0].total.toString()).toInt();
                      data.daysList[l].daysValue1Title5Controller.text =
                          double.parse(matchedData[0].total.toString())
                              .toInt()
                              .toString();
                    } else if (data.daysList[l].titleName == Constant.titleHeartRatePeak
                        && matchedData[0].total != null) {
                      data.daysList[l].total =
                          double.parse(matchedData[0].total.toString()).toInt();
                      data.daysList[l].daysValue2Title5Controller.text =
                          double.parse(matchedData[0].total.toString())
                              .toInt()
                              .toString();
                    } else if (matchedData[0].total != null &&
                        data.daysList[l].titleName != Constant.titleHeartRateRest &&
                        data.daysList[l].titleName != Constant.titleHeartRatePeak) {
                      data.daysList[l].total =
                          double.parse(matchedData[0].total.toString()).toInt();
                      data.daysList[l].daysValueTitleController.text =
                          double.parse(matchedData[0].total.toString())
                              .toInt()
                              .toString();
                    }
                  }
                }
              }
            }
            else if (matchedWeekOtherTitleDataWeek2[k].type ==
                Constant.typeDaysData &&
                matchedWeekOtherTitleDataWeek2[k].title == title) {
              for (int l = 0; l < data.daysList.length; l++) {
                if (data.daysList[l].date ==
                    matchedWeekOtherTitleDataWeek2[k].date) {


                  var daysData = CaloriesStepHeartRateData();
                  daysData.storedDate =
                      matchedWeekOtherTitleDataWeek2[k].dateTime;
                  daysData.titleName =
                      matchedWeekOtherTitleDataWeek2[k].title.toString();
                  if (daysData.titleName == Constant.titleHeartRateRest) {
                    if(matchedWeekOtherTitleDataWeek2[k].total != null) {
                      daysData.total =
                          matchedWeekOtherTitleDataWeek2[k].total!.toInt();
                      daysData.daysDataValue1Title5Controller.text =
                          matchedWeekOtherTitleDataWeek2[k].total!
                              .toInt()
                              .toString();
                    }
                    daysData.activityName = matchedWeekOtherTitleDataWeek2[k].displayLabel ?? "";
                    daysData.activityStartDate = matchedWeekOtherTitleDataWeek2[k].activityStartDate ?? DateTime.now();
                    daysData.activityEndDate = matchedWeekOtherTitleDataWeek2[k].activityEndDate ?? DateTime.now();
                    daysData.isFromAppleHealth = matchedWeekOtherTitleDataWeek2[k].isFromAppleHealth;
                  }
                  else if (daysData.titleName == Constant.titleHeartRatePeak) {
                    if(matchedWeekOtherTitleDataWeek2[k].total != null) {
                      daysData.total =
                          matchedWeekOtherTitleDataWeek2[k].total!.toInt();
                      daysData.daysDataValue2Title5Controller.text =
                          matchedWeekOtherTitleDataWeek2[k].total!
                              .toInt()
                              .toString();
                    }
                    daysData.activityName = matchedWeekOtherTitleDataWeek2[k].displayLabel ?? "";
                    daysData.activityStartDate = matchedWeekOtherTitleDataWeek2[k].activityStartDate ?? DateTime.now();
                    daysData.activityEndDate = matchedWeekOtherTitleDataWeek2[k].activityEndDate ?? DateTime.now();
                    daysData.isFromAppleHealth = matchedWeekOtherTitleDataWeek2[k].isFromAppleHealth;
                  }
                  else if (daysData.titleName != Constant.titleHeartRateRest &&
                      daysData.titleName != Constant.titleHeartRatePeak) {
                    if(matchedWeekOtherTitleDataWeek2[k].total != null) {
                      daysData.total =
                          matchedWeekOtherTitleDataWeek2[k].total!.toInt();
                      daysData.daysDataValueTitleController.text =
                          matchedWeekOtherTitleDataWeek2[k].total!
                              .toInt()
                              .toString();
                    }
                    daysData.activityName = matchedWeekOtherTitleDataWeek2[k].displayLabel ?? "";
                    daysData.activityStartDate = matchedWeekOtherTitleDataWeek2[k].activityStartDate ?? DateTime.now();
                    daysData.activityEndDate = matchedWeekOtherTitleDataWeek2[k].activityEndDate ?? DateTime.now();
                    daysData.isFromAppleHealth = matchedWeekOtherTitleDataWeek2[k].isFromAppleHealth;
                  }

                  data.daysList[l].daysDataList.add(daysData);
                }
              }
            }
          }
        }
      }

      if(j == 0) {
        if(dataCheckBox.daysListCheckBox.isNotEmpty){
          for (int a = 0; a < dataCheckBox.daysListCheckBox.length; a++) {
            var selectedCheckBoxList = dataCheckBox.daysListCheckBox[a].daysDataListCheckBox
                .where((element) => element.isCheckedDaysData).toList();
            if(selectedCheckBoxList.isNotEmpty){
              dataCheckBox.daysListCheckBox[a].isCheckedDay = true;
            }
          }
        }
        daysStrengthDataList.add(dataCheckBox);
      }else if(j == 1) {
        caloriesDataList.add(data);
      }else if(j == 2) {
        stepsDataList.add(data);
      }else if(j == 3) {
        heartRateRestDataList.add(data);
      }else if(j == 4) {
        heartRatePeakDataList.add(data);
      }else if(j == 5) {
        experienceDataList.add(data);
      }
    }
  }

  getWeek3DataOtherTitles(
      DateTime dateParseStartPreviousWeek3,
      DateTime dateParseLastTimePreviousWeek3,
      List<ActivityTable> dataListHive) {
    List<CaloriesStepHeartRateDay> daysData = [];
    List<OtherTitles2CheckBoxDay> daysDataCheckBox = [];

    // for (int j = 0; j < 5; j++) {
      for (int j = 0; j < 6; j++) {
      daysData = [];
      daysDataCheckBox = [];
      var titleName = "";
      for (int i = 0; i < 7; i++) {
        var dates = DateTime(
            dateParseStartPreviousWeek3.year,
            dateParseStartPreviousWeek3.month,
            dateParseStartPreviousWeek3.day + i);
        String formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy).format(dates);
        String formattedDateDayName = DateFormat('EEE').format(dates);
        // Debug.printLog(
        //     "dates getWeek1DataOtherTitles... $dates  $formattedDate  $formattedDateDayName");
        daysDataCheckBox.add(OtherTitles2CheckBoxDay(
            // formattedDateDayName, formattedDate, 'Week 3', 'Title A B C 2', [],
            formattedDateDayName, formattedDate, 'Week 3', Constant.titleDaysStr, [],
            dates,false));
        if(j+2 == 2){
          titleName = Constant.titleDaysStr;
        }else if(j+2 == 3){
          titleName = Constant.titleCalories;
        }else if(j+2 == 4){
          titleName = Constant.titleSteps;
        }else if(j+2 == 5){
          titleName = Constant.titleHeartRateRest;
        }else if(j+2 == 6){
          titleName = Constant.titleHeartRatePeak;
        }else if(j+2 == 7){
          titleName = Constant.titleExperience;
        }
        daysData.add(CaloriesStepHeartRateDay(
            // formattedDateDayName, formattedDate, 'Week 3', 'Title A B C ${j+2}', [],
            formattedDateDayName, formattedDate, 'Week 3', titleName, [],
            dates));
      }
      var dataCheckBox = OtherTitles2CheckBoxWeek(
          'Week 3', daysDataCheckBox, dateParseStartPreviousWeek3,
          // dateParseLastTimePreviousWeek3,'Title A B C 2');
          dateParseLastTimePreviousWeek3,Constant.titleDaysStr);
      var data = CaloriesStepHeartRateWeek(
          'Week 3', daysData, dateParseStartPreviousWeek3,
          // dateParseLastTimePreviousWeek3,'Title A B C ${j+2}');
          dateParseLastTimePreviousWeek3,titleName);

      String formattedDateStart =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateParseStartPreviousWeek3);
      String formattedDateEnd =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateParseLastTimePreviousWeek3);

      var matchedWeekOtherTitleDataWeek3 = dataListHive
          .where((element) =>
      element.weeksDate == "$formattedDateStart-$formattedDateEnd")
          .toList();

      if(matchedWeekOtherTitleDataWeek3.isNotEmpty){
        var title = "";
        if(j == 0) {
          title = Constant.titleDaysStr;
        }else if(j == 1) {
          title = Constant.titleCalories;
        }else if(j == 2) {
          title = Constant.titleSteps;
        }else if(j == 3) {
          title = Constant.titleHeartRateRest;
        }else if(j == 4) {
          title = Constant.titleHeartRatePeak;
        }else if(j == 5) {
          title = Constant.titleExperience;
        }

        for (int k = 0; k < matchedWeekOtherTitleDataWeek3.length; k++) {

          if(title == Constant.titleDaysStr){

            if (matchedWeekOtherTitleDataWeek3[k].type == Constant.typeWeek
                && matchedWeekOtherTitleDataWeek3[k].title == Constant.titleDaysStr) {

              var daysData = OtherTitles2CheckBoxDaysData();
              daysData.titleName = Constant.titleDaysStr;
              if (matchedWeekOtherTitleDataWeek3[k].total != null) {
                dataCheckBox.total = matchedWeekOtherTitleDataWeek3[k].total!.toInt();
                dataCheckBox.weekValueTitle2CheckBoxController.text =
                    matchedWeekOtherTitleDataWeek3[k].total!.toInt().toString();
              }
            }

            else if (matchedWeekOtherTitleDataWeek3[k].type == Constant.typeDay
                && matchedWeekOtherTitleDataWeek3[k].title == Constant.titleDaysStr) {
              for (int l = 0; l < dataCheckBox.daysListCheckBox.length; l++) {
                var matchedData = matchedWeekOtherTitleDataWeek3
                    .where(
                        (element) =>
                    element.date == dataCheckBox.daysListCheckBox[l].date &&
                        element.title == Constant.titleDaysStr && element.type == Constant.typeDay)
                    .toList();
                if (matchedData.isNotEmpty) {
                  dataCheckBox.daysListCheckBox[l].titleName = Constant.titleDaysStr;
                  dataCheckBox.daysListCheckBox[l].isCheckedDay = matchedData[0].isCheckedDay  ?? false;
                }
              }
            }

            else if (matchedWeekOtherTitleDataWeek3[k].type == Constant.typeDaysData &&
                matchedWeekOtherTitleDataWeek3[k].title == Constant.titleDaysStr) {
              for (int l = 0; l < dataCheckBox.daysListCheckBox.length; l++) {
                if (dataCheckBox.daysListCheckBox[l].date == matchedWeekOtherTitleDataWeek3[k].date
                    && dataCheckBox.daysListCheckBox[l].titleName == Constant.titleDaysStr) {

                  var daysData = OtherTitles2CheckBoxDaysData();
                  daysData.storedDate = matchedWeekOtherTitleDataWeek3[k].dateTime;
                  daysData.titleName = Constant.titleDaysStr;

                  daysData.isCheckedDaysData = matchedWeekOtherTitleDataWeek3[k].isCheckedDayData  ?? false;


                  dataCheckBox.daysListCheckBox[l].daysDataListCheckBox.add(daysData);
                }
              }
            }

          }
          else if(title == Constant.titleExperience){
            if (matchedWeekOtherTitleDataWeek3[k].type == Constant.typeWeek &&
                matchedWeekOtherTitleDataWeek3[k].title == null &&
                matchedWeekOtherTitleDataWeek3[k].smileyType != null ) {

              var daysData = CaloriesStepHeartRateData();
              daysData.titleName = matchedWeekOtherTitleDataWeek3[k].title.toString();
              daysData.smileyType = matchedWeekOtherTitleDataWeek3[k].smileyType ?? Constant.defaultSmileyType;
            }

            else if (matchedWeekOtherTitleDataWeek3[k].type == Constant.typeDay &&
                matchedWeekOtherTitleDataWeek3[k].title == null &&
                matchedWeekOtherTitleDataWeek3[k].total == null &&
                matchedWeekOtherTitleDataWeek3[k].smileyType != null) {
              for (int l = 0; l < data.daysList.length; l++) {
                var matchedData = matchedWeekOtherTitleDataWeek3
                    .where(
                        (element) =>
                    element.date == data.daysList[l].date &&
                        element.title == null && element.smileyType != null
                        && element.total == null && element.type == Constant.typeDay)
                    .toList();

                if (matchedData.isNotEmpty) {
                  data.daysList[l].smileyType = matchedData[0].smileyType ?? Constant.defaultSmileyType;
                }
              }
            }

            else
            if (matchedWeekOtherTitleDataWeek3[k].type == Constant.typeDaysData &&
                matchedWeekOtherTitleDataWeek3[k].title == null &&
                matchedWeekOtherTitleDataWeek3[k].total == null &&
                matchedWeekOtherTitleDataWeek3[k].smileyType != null) {
              for (int l = 0; l < data.daysList.length; l++) {
                if (data.daysList[l].date ==
                    matchedWeekOtherTitleDataWeek3[k].date) {
                  var daysData = CaloriesStepHeartRateData();
                  daysData.storedDate = matchedWeekOtherTitleDataWeek3[k].dateTime;
                  daysData.titleName = matchedWeekOtherTitleDataWeek3[k].title.toString();
                  daysData.smileyType = matchedWeekOtherTitleDataWeek3[k].smileyType ?? Constant.defaultSmileyType;
                  daysData.isFromAppleHealth = matchedWeekOtherTitleDataWeek3[k].isFromAppleHealth;
                  data.daysList[l].daysDataList.add(daysData);
                }
              }
            }

          }
          else {
            if (matchedWeekOtherTitleDataWeek3[k].type == Constant.typeWeek &&
                matchedWeekOtherTitleDataWeek3[k].title == title) {

              var daysData = CaloriesStepHeartRateData();
              daysData.titleName =
                  matchedWeekOtherTitleDataWeek3[k].title.toString();
              if (daysData.titleName == Constant.titleHeartRateRest &&
                  matchedWeekOtherTitleDataWeek3[k].total != null && matchedWeekOtherTitleDataWeek3[k].total!.toInt() > 0) {
                data.total = matchedWeekOtherTitleDataWeek3[k].total!.toInt();
                data.weekValue1Title5Title5Controller.text =
                    matchedWeekOtherTitleDataWeek3[k].total!.toInt().toString();
              }
              else if (daysData.titleName == Constant.titleHeartRatePeak &&
                  matchedWeekOtherTitleDataWeek3[k].total != null && matchedWeekOtherTitleDataWeek3[k].total!.toInt() > 0) {
                data.total = matchedWeekOtherTitleDataWeek3[k].total!.toInt();
                data.weekValue2Title5Controller.text =
                    matchedWeekOtherTitleDataWeek3[k].total!.toInt().toString();
              }
              else if (matchedWeekOtherTitleDataWeek3[k].total != null &&
                  daysData.titleName != Constant.titleHeartRateRest &&
                  daysData.titleName != Constant.titleHeartRatePeak && matchedWeekOtherTitleDataWeek3[k].total!.toInt() > 0) {
                data.total = matchedWeekOtherTitleDataWeek3[k].total!.toInt();
                data.weekValueTitleController.text =
                    matchedWeekOtherTitleDataWeek3[k].total!.toInt().toString();
              }
            }

            else
            if (matchedWeekOtherTitleDataWeek3[k].type == Constant.typeDay &&
                matchedWeekOtherTitleDataWeek3[k].title == title) {
              for (int l = 0; l < data.daysList.length; l++) {
                var matchedData = matchedWeekOtherTitleDataWeek3
                    .where(
                        (element) =>
                    element.date == data.daysList[l].date &&
                        element.title == title && element.type == Constant.typeDay)
                    .toList();

                /*if(matchedData.isNotEmpty){
                data.daysList[l].total = double.parse(matchedData[0].total.toString()).toInt();
                data.daysList[l].daysValueTitleController.text = double.parse(matchedData[0].total.toString()).toInt().toString();
              }*/

                if (matchedData.isNotEmpty) {
                  if (matchedData[0].total != null) {
                    if (data.daysList[l].titleName == Constant.titleHeartRateRest) {
                      data.daysList[l].total =
                          double.parse(matchedData[0].total.toString()).toInt();
                      data.daysList[l].daysValue1Title5Controller.text =
                          double.parse(matchedData[0].total.toString())
                              .toInt()
                              .toString();
                    } else if (data.daysList[l].titleName == Constant.titleHeartRatePeak
                        && matchedData[0].total != null) {
                      data.daysList[l].total =
                          double.parse(matchedData[0].total.toString()).toInt();
                      data.daysList[l].daysValue2Title5Controller.text =
                          double.parse(matchedData[0].total.toString())
                              .toInt()
                              .toString();
                    } else if (matchedData[0].total != null &&
                        data.daysList[l].titleName != Constant.titleHeartRateRest &&
                        data.daysList[l].titleName != Constant.titleHeartRatePeak) {
                      data.daysList[l].total =
                          double.parse(matchedData[0].total.toString()).toInt();
                      data.daysList[l].daysValueTitleController.text =
                          double.parse(matchedData[0].total.toString())
                              .toInt()
                              .toString();
                    }
                  }
                }
              }
            }
            else if (matchedWeekOtherTitleDataWeek3[k].type ==
                Constant.typeDaysData &&
                matchedWeekOtherTitleDataWeek3[k].title == title) {
              for (int l = 0; l < data.daysList.length; l++) {
                if (data.daysList[l].date ==
                    matchedWeekOtherTitleDataWeek3[k].date) {


                  var daysData = CaloriesStepHeartRateData();
                  daysData.storedDate =
                      matchedWeekOtherTitleDataWeek3[k].dateTime;
                  daysData.titleName =
                      matchedWeekOtherTitleDataWeek3[k].title.toString();
                  if (daysData.titleName == Constant.titleHeartRateRest) {
                    if(matchedWeekOtherTitleDataWeek3[k].total != null) {
                      daysData.total =
                          matchedWeekOtherTitleDataWeek3[k].total!.toInt();
                      daysData.daysDataValue1Title5Controller.text =
                          matchedWeekOtherTitleDataWeek3[k].total!
                              .toInt()
                              .toString();
                    }
                    daysData.activityName = matchedWeekOtherTitleDataWeek3[k].displayLabel ?? "";
                    daysData.activityStartDate = matchedWeekOtherTitleDataWeek3[k].activityStartDate ?? DateTime.now();
                    daysData.activityEndDate = matchedWeekOtherTitleDataWeek3[k].activityEndDate ?? DateTime.now();
                    daysData.isFromAppleHealth = matchedWeekOtherTitleDataWeek3[k].isFromAppleHealth;
                  }
                  else if (daysData.titleName == Constant.titleHeartRatePeak) {
                    if(matchedWeekOtherTitleDataWeek3[k].total != null) {
                      daysData.total =
                          matchedWeekOtherTitleDataWeek3[k].total!.toInt();
                      daysData.daysDataValue2Title5Controller.text =
                          matchedWeekOtherTitleDataWeek3[k].total!
                              .toInt()
                              .toString();
                    }
                    daysData.activityName = matchedWeekOtherTitleDataWeek3[k].displayLabel ?? "";
                    daysData.activityStartDate = matchedWeekOtherTitleDataWeek3[k].activityStartDate ?? DateTime.now();
                    daysData.activityEndDate = matchedWeekOtherTitleDataWeek3[k].activityEndDate ?? DateTime.now();
                    daysData.isFromAppleHealth = matchedWeekOtherTitleDataWeek3[k].isFromAppleHealth;
                  }
                  else if (daysData.titleName != Constant.titleHeartRateRest &&
                      daysData.titleName != Constant.titleHeartRatePeak) {
                    if(matchedWeekOtherTitleDataWeek3[k].total != null) {
                      daysData.total =
                          matchedWeekOtherTitleDataWeek3[k].total!.toInt();
                      daysData.daysDataValueTitleController.text =
                          matchedWeekOtherTitleDataWeek3[k].total!
                              .toInt()
                              .toString();
                    }
                    daysData.activityName = matchedWeekOtherTitleDataWeek3[k].displayLabel ?? "";
                    daysData.activityStartDate = matchedWeekOtherTitleDataWeek3[k].activityStartDate ?? DateTime.now();
                    daysData.activityEndDate = matchedWeekOtherTitleDataWeek3[k].activityEndDate ?? DateTime.now();
                    daysData.isFromAppleHealth = matchedWeekOtherTitleDataWeek3[k].isFromAppleHealth;
                  }

                  data.daysList[l].daysDataList.add(daysData);
                }
              }
            }
          }
        }
      }

      if(j == 0) {
        if(dataCheckBox.daysListCheckBox.isNotEmpty){
          for (int a = 0; a < dataCheckBox.daysListCheckBox.length; a++) {
            var selectedCheckBoxList = dataCheckBox.daysListCheckBox[a].daysDataListCheckBox
                .where((element) => element.isCheckedDaysData).toList();
            if(selectedCheckBoxList.isNotEmpty){
              dataCheckBox.daysListCheckBox[a].isCheckedDay = true;
            }
          }
        }
        daysStrengthDataList.add(dataCheckBox);
      }else if(j == 1) {
        caloriesDataList.add(data);
      }else if(j == 2) {
        stepsDataList.add(data);
      }else if(j == 3) {
        heartRateRestDataList.add(data);
      }else if(j == 4) {
        heartRatePeakDataList.add(data);
      }else if(j == 5) {
        experienceDataList.add(data);
      }
    }

  }

  getWeek4DataOtherTitles(
      DateTime dateParseStartPreviousWeek4,
      DateTime dateParseLastTimePreviousWeek4,
      List<ActivityTable> dataListHive) {
    List<CaloriesStepHeartRateDay> daysData = [];
    List<OtherTitles2CheckBoxDay> daysDataCheckBox = [];

    // for (int j = 0; j < 5; j++) {
      for (int j = 0; j < 6; j++) {
      daysData = [];
      daysDataCheckBox = [];
      var titleName = "";
      for (int i = 0; i < 7; i++) {
        var dates = DateTime(
            dateParseStartPreviousWeek4.year,
            dateParseStartPreviousWeek4.month,
            dateParseStartPreviousWeek4.day + i);
        String formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy).format(dates);
        String formattedDateDayName = DateFormat('EEE').format(dates);
        // Debug.printLog(
        //     "dates getWeek1DataOtherTitles... $dates  $formattedDate  $formattedDateDayName");
        daysDataCheckBox.add(OtherTitles2CheckBoxDay(
            // formattedDateDayName, formattedDate, 'Week 4', 'Title A B C 2', [],
            formattedDateDayName, formattedDate, 'Week 4', Constant.titleDaysStr, [],
            dates,false));
        if(j+2 == 2){
          titleName = Constant.titleDaysStr;
        }else if(j+2 == 3){
          titleName = Constant.titleCalories;
        }else if(j+2 == 4){
          titleName = Constant.titleSteps;
        }else if(j+2 == 5){
          titleName = Constant.titleHeartRateRest;
        }else if(j+2 == 6){
          titleName = Constant.titleHeartRatePeak;
        }else if(j+2 == 7){
          titleName = Constant.titleExperience;
        }
        daysData.add(CaloriesStepHeartRateDay(
            formattedDateDayName, formattedDate, 'Week 4', titleName, [],
            // formattedDateDayName, formattedDate, 'Week 4', 'Title A B C ${j+2}', [],
            dates));
      }
      var dataCheckBox = OtherTitles2CheckBoxWeek(
          'Week 4', daysDataCheckBox, dateParseStartPreviousWeek4,
          // dateParseLastTimePreviousWeek4,'Title A B C 2');
          dateParseLastTimePreviousWeek4,Constant.titleDaysStr);
      var data = CaloriesStepHeartRateWeek(
          'Week 4', daysData, dateParseStartPreviousWeek4,
          // dateParseLastTimePreviousWeek4,'Title A B C ${j+2}');
          dateParseLastTimePreviousWeek4,titleName);

      String formattedDateStart =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateParseStartPreviousWeek4);
      String formattedDateEnd =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateParseLastTimePreviousWeek4);

      var matchedWeekOtherTitleDataWeek4 = dataListHive
          .where((element) =>
      element.weeksDate == "$formattedDateStart-$formattedDateEnd")
          .toList();

      if(matchedWeekOtherTitleDataWeek4.isNotEmpty){
        var title = "";
        if(j == 0) {
          title = Constant.titleDaysStr;
        }else if(j == 1) {
          title = Constant.titleCalories;
        }else if(j == 2) {
          title = Constant.titleSteps;
        }else if(j == 3) {
          title = Constant.titleHeartRateRest;
        }else if(j == 4) {
          title = Constant.titleHeartRatePeak;
        }else if(j == 5) {
          title = Constant.titleExperience;
        }

        for (int k = 0; k < matchedWeekOtherTitleDataWeek4.length; k++) {
          if(title == Constant.titleDaysStr){

            if (matchedWeekOtherTitleDataWeek4[k].type == Constant.typeWeek
                && matchedWeekOtherTitleDataWeek4[k].title == Constant.titleDaysStr) {

              var daysData = OtherTitles2CheckBoxDaysData();
              daysData.titleName = Constant.titleDaysStr;
              if (matchedWeekOtherTitleDataWeek4[k].total != null) {
                dataCheckBox.total = matchedWeekOtherTitleDataWeek4[k].total!.toInt();
                dataCheckBox.weekValueTitle2CheckBoxController.text =
                    matchedWeekOtherTitleDataWeek4[k].total!.toInt().toString();
              }
            }

            else if (matchedWeekOtherTitleDataWeek4[k].type == Constant.typeDay
                && matchedWeekOtherTitleDataWeek4[k].title == Constant.titleDaysStr) {
              for (int l = 0; l < dataCheckBox.daysListCheckBox.length; l++) {
                var matchedData = matchedWeekOtherTitleDataWeek4
                    .where(
                        (element) =>
                    element.date == dataCheckBox.daysListCheckBox[l].date &&
                        element.title == Constant.titleDaysStr && element.type == Constant.typeDay)
                    .toList();
                if (matchedData.isNotEmpty) {
                  dataCheckBox.daysListCheckBox[l].titleName = Constant.titleDaysStr;
                  dataCheckBox.daysListCheckBox[l].isCheckedDay = matchedData[0].isCheckedDay  ?? false;
                }
              }
            }

            else if (matchedWeekOtherTitleDataWeek4[k].type == Constant.typeDaysData
                && matchedWeekOtherTitleDataWeek4[k].title == Constant.titleDaysStr) {
              for (int l = 0; l < dataCheckBox.daysListCheckBox.length; l++) {
                if (dataCheckBox.daysListCheckBox[l].date == matchedWeekOtherTitleDataWeek4[k].date
                    && dataCheckBox.daysListCheckBox[l].titleName == Constant.titleDaysStr) {

                  var daysData = OtherTitles2CheckBoxDaysData();
                  daysData.storedDate = matchedWeekOtherTitleDataWeek4[k].dateTime;
                  daysData.titleName = Constant.titleDaysStr;

                  daysData.isCheckedDaysData = matchedWeekOtherTitleDataWeek4[k].isCheckedDayData  ?? false;


                  dataCheckBox.daysListCheckBox[l].daysDataListCheckBox.add(daysData);
                }
              }
            }

          }
          else if(title == Constant.titleExperience){
            if (matchedWeekOtherTitleDataWeek4[k].type == Constant.typeWeek &&
                matchedWeekOtherTitleDataWeek4[k].title == null &&
                matchedWeekOtherTitleDataWeek4[k].smileyType != null ) {

              var daysData = CaloriesStepHeartRateData();
              daysData.titleName = matchedWeekOtherTitleDataWeek4[k].title.toString();
              daysData.smileyType = matchedWeekOtherTitleDataWeek4[k].smileyType ?? Constant.defaultSmileyType;
            }

            else if (matchedWeekOtherTitleDataWeek4[k].type == Constant.typeDay &&
                matchedWeekOtherTitleDataWeek4[k].title == null &&
                matchedWeekOtherTitleDataWeek4[k].total == null &&
                matchedWeekOtherTitleDataWeek4[k].smileyType != null) {
              for (int l = 0; l < data.daysList.length; l++) {
                var matchedData = matchedWeekOtherTitleDataWeek4
                    .where(
                        (element) =>
                    element.date == data.daysList[l].date &&
                        element.title == null && element.smileyType != null && element.total == null && element.type == Constant.typeDay)
                    .toList();

                if (matchedData.isNotEmpty) {
                  data.daysList[l].smileyType = matchedData[0].smileyType ?? Constant.defaultSmileyType;
                }
              }
            }

            else
            if (matchedWeekOtherTitleDataWeek4[k].type == Constant.typeDaysData &&
                matchedWeekOtherTitleDataWeek4[k].title == null &&
                matchedWeekOtherTitleDataWeek4[k].total == null &&
                matchedWeekOtherTitleDataWeek4[k].smileyType != null) {
              for (int l = 0; l < data.daysList.length; l++) {
                if (data.daysList[l].date ==
                    matchedWeekOtherTitleDataWeek4[k].date) {
                  var daysData = CaloriesStepHeartRateData();
                  daysData.storedDate = matchedWeekOtherTitleDataWeek4[k].dateTime;
                  daysData.titleName = matchedWeekOtherTitleDataWeek4[k].title.toString();
                  daysData.smileyType = matchedWeekOtherTitleDataWeek4[k].smileyType ?? Constant.defaultSmileyType;
                  daysData.isFromAppleHealth = matchedWeekOtherTitleDataWeek4[k].isFromAppleHealth;
                  data.daysList[l].daysDataList.add(daysData);
                }
              }
            }

          }
          else {
            if (matchedWeekOtherTitleDataWeek4[k].type == Constant.typeWeek &&
                matchedWeekOtherTitleDataWeek4[k].title == title) {

              var daysData = CaloriesStepHeartRateData();
              daysData.titleName =
                  matchedWeekOtherTitleDataWeek4[k].title.toString();
              if (daysData.titleName == Constant.titleHeartRateRest &&
                  matchedWeekOtherTitleDataWeek4[k].total != null && matchedWeekOtherTitleDataWeek4[k].total!.toInt() > 0) {
                data.total = matchedWeekOtherTitleDataWeek4[k].total!.toInt();
                data.weekValue1Title5Title5Controller.text =
                    matchedWeekOtherTitleDataWeek4[k].total!.toInt().toString();
              }
              else if (daysData.titleName == Constant.titleHeartRatePeak &&
                  matchedWeekOtherTitleDataWeek4[k].total != null && matchedWeekOtherTitleDataWeek4[k].total!.toInt() > 0) {
                data.total = matchedWeekOtherTitleDataWeek4[k].total!.toInt();
                data.weekValue2Title5Controller.text =
                    matchedWeekOtherTitleDataWeek4[k].total!.toInt().toString();
              }
              else if (matchedWeekOtherTitleDataWeek4[k].total != null &&
                  daysData.titleName != Constant.titleHeartRateRest &&
                  daysData.titleName != Constant.titleHeartRatePeak && matchedWeekOtherTitleDataWeek4[k].total!.toInt() > 0) {
                Debug.printLog("Total min calories.....week 4,,,,${matchedWeekOtherTitleDataWeek4[k].total!.toInt()}  ${daysData.titleName}  ${daysData.weekName}");
                data.total = matchedWeekOtherTitleDataWeek4[k].total!.toInt();
                data.weekValueTitleController.text =
                    matchedWeekOtherTitleDataWeek4[k].total!.toInt().toString();
              }
            }

            else
            if (matchedWeekOtherTitleDataWeek4[k].type == Constant.typeDay &&
                matchedWeekOtherTitleDataWeek4[k].title == title) {
              for (int l = 0; l < data.daysList.length; l++) {
                var matchedData = matchedWeekOtherTitleDataWeek4
                    .where(
                        (element) =>
                    element.date == data.daysList[l].date &&
                        element.title == title && element.type == Constant.typeDay)
                    .toList();

                if (matchedData.isNotEmpty) {
                  if (matchedData[0].total != null) {
                    if (data.daysList[l].titleName == Constant.titleHeartRateRest) {
                      data.daysList[l].total =
                          double.parse(matchedData[0].total.toString()).toInt();
                      data.daysList[l].daysValue1Title5Controller.text =
                          double.parse(matchedData[0].total.toString())
                              .toInt()
                              .toString();
                    } else if (data.daysList[l].titleName == Constant.titleHeartRatePeak
                        && matchedData[0].total != null) {
                      data.daysList[l].total =
                          double.parse(matchedData[0].total.toString()).toInt();
                      data.daysList[l].daysValue2Title5Controller.text =
                          double.parse(matchedData[0].total.toString())
                              .toInt()
                              .toString();
                    } else if (matchedData[0].total != null &&
                        data.daysList[l].titleName != Constant.titleHeartRateRest &&
                        data.daysList[l].titleName != Constant.titleHeartRatePeak) {
                      data.daysList[l].total =
                          double.parse(matchedData[0].total.toString()).toInt();
                      data.daysList[l].daysValueTitleController.text =
                          double.parse(matchedData[0].total.toString())
                              .toInt()
                              .toString();
                    }
                  }
                }
              }
            }
            else if (matchedWeekOtherTitleDataWeek4[k].type ==
                Constant.typeDaysData &&
                matchedWeekOtherTitleDataWeek4[k].title == title) {
              for (int l = 0; l < data.daysList.length; l++) {
                if (data.daysList[l].date ==
                    matchedWeekOtherTitleDataWeek4[k].date) {


                  var daysData = CaloriesStepHeartRateData();
                  daysData.storedDate =
                      matchedWeekOtherTitleDataWeek4[k].dateTime;
                  daysData.titleName =
                      matchedWeekOtherTitleDataWeek4[k].title.toString();
                  if (daysData.titleName == Constant.titleHeartRateRest) {
                    if(matchedWeekOtherTitleDataWeek4[k].total != null) {
                      daysData.total =
                          matchedWeekOtherTitleDataWeek4[k].total!.toInt();
                      daysData.daysDataValue1Title5Controller.text =
                          matchedWeekOtherTitleDataWeek4[k].total!
                              .toInt()
                              .toString();
                    }
                    daysData.activityName = matchedWeekOtherTitleDataWeek4[k].displayLabel ?? "";
                    daysData.activityStartDate = matchedWeekOtherTitleDataWeek4[k].activityStartDate ?? DateTime.now();
                    daysData.activityEndDate = matchedWeekOtherTitleDataWeek4[k].activityEndDate ?? DateTime.now();
                    daysData.isFromAppleHealth = matchedWeekOtherTitleDataWeek4[k].isFromAppleHealth;
                  }
                  else if (daysData.titleName == Constant.titleHeartRatePeak) {
                    if(matchedWeekOtherTitleDataWeek4[k].total != null) {
                      daysData.total =
                          matchedWeekOtherTitleDataWeek4[k].total!.toInt();
                      daysData.daysDataValue2Title5Controller.text =
                          matchedWeekOtherTitleDataWeek4[k].total!
                              .toInt()
                              .toString();
                    }
                    daysData.activityName = matchedWeekOtherTitleDataWeek4[k].displayLabel ?? "";
                    daysData.activityStartDate = matchedWeekOtherTitleDataWeek4[k].activityStartDate ?? DateTime.now();
                    daysData.activityEndDate = matchedWeekOtherTitleDataWeek4[k].activityEndDate ?? DateTime.now();
                    daysData.isFromAppleHealth = matchedWeekOtherTitleDataWeek4[k].isFromAppleHealth;
                  }
                  else if (daysData.titleName != Constant.titleHeartRateRest &&
                      daysData.titleName != Constant.titleHeartRatePeak) {
                    if(matchedWeekOtherTitleDataWeek4[k].total != null) {
                      daysData.total =
                          matchedWeekOtherTitleDataWeek4[k].total!.toInt();
                      daysData.daysDataValueTitleController.text =
                          matchedWeekOtherTitleDataWeek4[k].total!
                              .toInt()
                              .toString();
                    }
                    daysData.activityName = matchedWeekOtherTitleDataWeek4[k].displayLabel ?? "";
                    daysData.activityStartDate = matchedWeekOtherTitleDataWeek4[k].activityStartDate ?? DateTime.now();
                    daysData.activityEndDate = matchedWeekOtherTitleDataWeek4[k].activityEndDate ?? DateTime.now();
                    daysData.isFromAppleHealth = matchedWeekOtherTitleDataWeek4[k].isFromAppleHealth;
                  }

                  data.daysList[l].daysDataList.add(daysData);
                }
              }
            }
          }
        }
      }

      if(j == 0) {
        if(dataCheckBox.daysListCheckBox.isNotEmpty){
          for (int a = 0; a < dataCheckBox.daysListCheckBox.length; a++) {
            var selectedCheckBoxList = dataCheckBox.daysListCheckBox[a].daysDataListCheckBox
                .where((element) => element.isCheckedDaysData).toList();
            if(selectedCheckBoxList.isNotEmpty){
              dataCheckBox.daysListCheckBox[a].isCheckedDay = true;
            }
          }
        }
        daysStrengthDataList.add(dataCheckBox);
      }else if(j == 1) {
        caloriesDataList.add(data);
      }else if(j == 2) {
        stepsDataList.add(data);
      }else if(j == 3) {
        heartRateRestDataList.add(data);
      }else if(j == 4) {
        heartRatePeakDataList.add(data);
      }else if(j == 5) {
        experienceDataList.add(data);
      }

    }

  }

  getWeek5DataOtherTitles(
      DateTime dateParseStartPreviousWeek5,
      DateTime dateParseLastTimePreviousWeek5,
      List<ActivityTable> dataListHive) {
    List<CaloriesStepHeartRateDay> daysData = [];
    List<OtherTitles2CheckBoxDay> daysDataCheckBox = [];

    Debug.printLog("Week5. date...$dateParseStartPreviousWeek5  $dateParseLastTimePreviousWeek5");

      for (int j = 0; j < 6; j++) {
      daysData = [];
      daysDataCheckBox = [];

      var titleName = "";
      for (int i = 0; i < 7; i++) {
        var dates = DateTime(
            dateParseStartPreviousWeek5.year,
            dateParseStartPreviousWeek5.month,
            dateParseStartPreviousWeek5.day + i);
        String formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy).format(dates);
        String formattedDateDayName = DateFormat('EEE').format(dates);
        daysDataCheckBox.add(OtherTitles2CheckBoxDay(
            formattedDateDayName, formattedDate, 'Week 5', Constant.titleDaysStr, [],
            dates,false));
        if(j+2 == 2){
          titleName = Constant.titleDaysStr;
        }else if(j+2 == 3){
          titleName = Constant.titleCalories;
        }else if(j+2 == 4){
          titleName = Constant.titleSteps;
        }else if(j+2 == 5){
          titleName = Constant.titleHeartRateRest;
        }else if(j+2 == 6){
          titleName = Constant.titleHeartRatePeak;
        }else if(j+2 == 7){
          titleName = Constant.titleExperience;
        }
        daysData.add(CaloriesStepHeartRateDay(
            formattedDateDayName, formattedDate, 'Week 5', titleName, [],
            dates));
      }
      var dataCheckBox = OtherTitles2CheckBoxWeek(
          'Week 5', daysDataCheckBox, dateParseStartPreviousWeek5,
          dateParseLastTimePreviousWeek5,Constant.titleDaysStr);
      var data = CaloriesStepHeartRateWeek(
          'Week 5', daysData, dateParseStartPreviousWeek5,
          dateParseLastTimePreviousWeek5,titleName);

      String formattedDateStart =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateParseStartPreviousWeek5);
      String formattedDateEnd =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateParseLastTimePreviousWeek5);

      var matchedWeekOtherTitleDataWeek5 = dataListHive
          .where((element) =>
      element.weeksDate == "$formattedDateStart-$formattedDateEnd")
          .toList();


      if(matchedWeekOtherTitleDataWeek5.isNotEmpty){
        var title = "";
        if(j == 0) {
          title = Constant.titleDaysStr;
        }else if(j == 1) {
          title = Constant.titleCalories;
        }else if(j == 2) {
          title = Constant.titleSteps;
        }else if(j == 3) {
          title = Constant.titleHeartRateRest;
        }else if(j == 4) {
          title = Constant.titleHeartRatePeak;
        }else if(j == 5) {
          title = Constant.titleExperience;
        }

        for (int k = 0; k < matchedWeekOtherTitleDataWeek5.length; k++) {
          if (title == Constant.titleDaysStr ) {
            if (matchedWeekOtherTitleDataWeek5[k].type == Constant.typeWeek
                && matchedWeekOtherTitleDataWeek5[k].title == Constant.titleDaysStr ) {
              var daysData = OtherTitles2CheckBoxDaysData();
              daysData.titleName = Constant.titleDaysStr;
              if (matchedWeekOtherTitleDataWeek5[k].total != null) {
                dataCheckBox.total =
                    matchedWeekOtherTitleDataWeek5[k].total!.toInt();
                dataCheckBox.weekValueTitle2CheckBoxController.text =
                    matchedWeekOtherTitleDataWeek5[k].total!.toInt().toString();
              }else{
                dataCheckBox.total = 0;
                dataCheckBox.weekValueTitle2CheckBoxController.text = "";
              }
            }

            else
            if (matchedWeekOtherTitleDataWeek5[k].type == Constant.typeDay
                && matchedWeekOtherTitleDataWeek5[k].title == Constant.titleDaysStr ) {
              for (int l = 0; l < dataCheckBox.daysListCheckBox.length; l++) {
                var matchedData = matchedWeekOtherTitleDataWeek5
                    .where(
                        (element) =>
                    element.date == dataCheckBox.daysListCheckBox[l].date &&
                        element.title == Constant.titleDaysStr && element.type == Constant.typeDay)
                    .toList();
                if (matchedData.isNotEmpty) {
                  dataCheckBox.daysListCheckBox[l].titleName =
                      Constant.titleDaysStr;
                  dataCheckBox.daysListCheckBox[l].isCheckedDay =
                      matchedData[0].isCheckedDay  ?? false;
                }
              }
            }

            else if (matchedWeekOtherTitleDataWeek5[k].type ==
                Constant.typeDaysData
                && matchedWeekOtherTitleDataWeek5[k].title == Constant.titleDaysStr ) {
              for (int l = 0; l < dataCheckBox.daysListCheckBox.length; l++) {
                if (dataCheckBox.daysListCheckBox[l].date ==
                    matchedWeekOtherTitleDataWeek5[k].date && dataCheckBox.daysListCheckBox[l].titleName
                    == Constant.titleDaysStr) {
                  var daysData = OtherTitles2CheckBoxDaysData();
                  daysData.storedDate =
                      matchedWeekOtherTitleDataWeek5[k].dateTime;
                  daysData.titleName = Constant.titleDaysStr;

                  daysData.isCheckedDaysData =
                      matchedWeekOtherTitleDataWeek5[k].isCheckedDayData ?? false;
                  daysData.activityName = matchedWeekOtherTitleDataWeek5[k].displayLabel ?? "";

                  dataCheckBox.daysListCheckBox[l].daysDataListCheckBox.add(
                      daysData);
                }
              }
            }
          }
          else if(title == Constant.titleExperience){
            if (matchedWeekOtherTitleDataWeek5[k].type == Constant.typeWeek &&
                matchedWeekOtherTitleDataWeek5[k].title == null &&
                matchedWeekOtherTitleDataWeek5[k].smileyType != null ) {

              var daysData = CaloriesStepHeartRateData();
              daysData.titleName = matchedWeekOtherTitleDataWeek5[k].title.toString();
              daysData.smileyType = matchedWeekOtherTitleDataWeek5[k].smileyType ?? Constant.defaultSmileyType;
            }

            else if (matchedWeekOtherTitleDataWeek5[k].type == Constant.typeDay &&
                matchedWeekOtherTitleDataWeek5[k].title == null &&
                matchedWeekOtherTitleDataWeek5[k].total == null &&
                matchedWeekOtherTitleDataWeek5[k].smileyType != null) {
              for (int l = 0; l < data.daysList.length; l++) {
                var matchedData = matchedWeekOtherTitleDataWeek5
                    .where(
                        (element) =>
                    element.date == data.daysList[l].date &&
                        element.title == null && element.smileyType != null
                        && element.total == null && element.type == Constant.typeDay)
                    .toList();

                if (matchedData.isNotEmpty) {
                  Debug.printLog("day level type....${matchedData[0].smileyType} ${matchedData[0].date}");
                  data.daysList[l].smileyType = matchedData[0].smileyType ?? Constant.defaultSmileyType;
                }
              }
            }

            else
            if (matchedWeekOtherTitleDataWeek5[k].type == Constant.typeDaysData &&
                matchedWeekOtherTitleDataWeek5[k].title == null &&
                matchedWeekOtherTitleDataWeek5[k].total == null &&
                matchedWeekOtherTitleDataWeek5[k].smileyType != null) {
              for (int l = 0; l < data.daysList.length; l++) {
                if (data.daysList[l].date ==
                    matchedWeekOtherTitleDataWeek5[k].date) {
                  var daysData = CaloriesStepHeartRateData();
                  daysData.storedDate = matchedWeekOtherTitleDataWeek5[k].dateTime;
                  daysData.titleName = matchedWeekOtherTitleDataWeek5[k].title.toString();
                  daysData.smileyType = matchedWeekOtherTitleDataWeek5[k].smileyType ?? Constant.defaultSmileyType;
                  daysData.activityName = matchedWeekOtherTitleDataWeek5[k].displayLabel ?? "";
                  daysData.isFromAppleHealth = matchedWeekOtherTitleDataWeek5[k].isFromAppleHealth;
                  Debug.printLog("activity level type....${matchedWeekOtherTitleDataWeek5[k].smileyType}");
                  data.daysList[l].daysDataList.add(daysData);
                }
              }
            }
          }
          else {
            if (matchedWeekOtherTitleDataWeek5[k].type == Constant.typeWeek &&
                matchedWeekOtherTitleDataWeek5[k].title == title) {

              var daysData = CaloriesStepHeartRateData();
              daysData.titleName =
                  matchedWeekOtherTitleDataWeek5[k].title.toString();
              if (daysData.titleName == Constant.titleHeartRateRest &&
                  matchedWeekOtherTitleDataWeek5[k].total != null && matchedWeekOtherTitleDataWeek5[k].total!.toInt() > 0) {
                data.total = matchedWeekOtherTitleDataWeek5[k].total!.toInt();
                data.weekValue1Title5Title5Controller.text =
                    matchedWeekOtherTitleDataWeek5[k].total!.toInt().toString();
              }else{
                data.total = 0;
                data.weekValue1Title5Title5Controller.text = "";
              }

               if (daysData.titleName == Constant.titleHeartRatePeak &&
                  matchedWeekOtherTitleDataWeek5[k].total != null && matchedWeekOtherTitleDataWeek5[k].total!.toInt() > 0) {
                data.total = matchedWeekOtherTitleDataWeek5[k].total!.toInt();
                data.weekValue2Title5Controller.text =
                    matchedWeekOtherTitleDataWeek5[k].total!.toInt().toString();
              }else{
                 data.total = 0;
                 data.weekValue2Title5Controller.text = "";
               }

               if (matchedWeekOtherTitleDataWeek5[k].total != null &&
                  daysData.titleName != Constant.titleHeartRateRest &&
                  daysData.titleName != Constant.titleHeartRatePeak && matchedWeekOtherTitleDataWeek5[k].total!.toInt() > 0) {
                data.total = matchedWeekOtherTitleDataWeek5[k].total!.toInt();
                data.weekValueTitleController.text =
                    matchedWeekOtherTitleDataWeek5[k].total!.toInt().toString();
              }else{
                 data.total = 0;
                 data.weekValueTitleController.text = "";
               }
            }
            else
            if (matchedWeekOtherTitleDataWeek5[k].type == Constant.typeDay &&
                matchedWeekOtherTitleDataWeek5[k].title == title) {
              for (int l = 0; l < data.daysList.length; l++) {
                var matchedData = matchedWeekOtherTitleDataWeek5
                    .where(
                        (element) =>
                    element.date == data.daysList[l].date &&
                        element.title == title && element.type == Constant.typeDay)
                    .toList();
                if (matchedData.isNotEmpty) {
                  if (matchedData[0].total != null) {
                    if (data.daysList[l].titleName == Constant.titleHeartRateRest) {
                      data.daysList[l].total =
                          double.parse(matchedData[0].total.toString()).toInt();
                      data.daysList[l].daysValue1Title5Controller.text =
                          double.parse(matchedData[0].total.toString())
                              .toInt()
                              .toString();
                    }
                    else if (data.daysList[l].titleName == Constant.titleHeartRatePeak
                        && matchedData[0].total != null) {
                      data.daysList[l].total =
                          double.parse(matchedData[0].total.toString()).toInt();
                      data.daysList[l].daysValue2Title5Controller.text =
                          double.parse(matchedData[0].total.toString())
                              .toInt()
                              .toString();
                    }
                    else if (matchedData[0].total != null &&
                        data.daysList[l].titleName != Constant.titleHeartRateRest &&
                        data.daysList[l].titleName != Constant.titleHeartRatePeak) {
                      data.daysList[l].total =
                          double.parse(matchedData[0].total.toString()).toInt();
                      data.daysList[l].daysValueTitleController.text =
                          double.parse(matchedData[0].total.toString())
                              .toInt()
                              .toString();
                    }
                  }
                }
              }
            }
            else if (matchedWeekOtherTitleDataWeek5[k].type ==
                Constant.typeDaysData &&
                matchedWeekOtherTitleDataWeek5[k].title == title) {
              for (int l = 0; l < data.daysList.length; l++) {
                if (data.daysList[l].date ==
                    matchedWeekOtherTitleDataWeek5[k].date) {


                  var daysData = CaloriesStepHeartRateData();
                  daysData.storedDate =
                      matchedWeekOtherTitleDataWeek5[k].dateTime;
                  daysData.titleName =
                      matchedWeekOtherTitleDataWeek5[k].title.toString();
                  if (daysData.titleName == Constant.titleHeartRateRest) {
                    if(matchedWeekOtherTitleDataWeek5[k].total != null) {
                      daysData.total =
                          matchedWeekOtherTitleDataWeek5[k].total!.toInt();
                      daysData.daysDataValue1Title5Controller.text =
                          matchedWeekOtherTitleDataWeek5[k].total!
                              .toInt()
                              .toString();
                    }
                    daysData.activityName = matchedWeekOtherTitleDataWeek5[k].displayLabel ?? "";
                    daysData.activityStartDate = matchedWeekOtherTitleDataWeek5[k].activityStartDate ?? DateTime.now();
                    daysData.activityEndDate = matchedWeekOtherTitleDataWeek5[k].activityEndDate ?? DateTime.now();
                    daysData.isFromAppleHealth = matchedWeekOtherTitleDataWeek5[k].isFromAppleHealth;
                  }
                  else if (daysData.titleName == Constant.titleHeartRatePeak) {
                    if(matchedWeekOtherTitleDataWeek5[k].total != null) {
                      daysData.total =
                          matchedWeekOtherTitleDataWeek5[k].total!.toInt();
                      daysData.daysDataValue2Title5Controller.text =
                          matchedWeekOtherTitleDataWeek5[k].total!
                              .toInt()
                              .toString();
                    }
                    daysData.activityName = matchedWeekOtherTitleDataWeek5[k].displayLabel ?? "";
                    daysData.activityStartDate = matchedWeekOtherTitleDataWeek5[k].activityStartDate ?? DateTime.now();
                    daysData.activityEndDate = matchedWeekOtherTitleDataWeek5[k].activityEndDate ?? DateTime.now();
                    daysData.isFromAppleHealth = matchedWeekOtherTitleDataWeek5[k].isFromAppleHealth;
                  }
                  else if (daysData.titleName != Constant.titleHeartRateRest &&
                      daysData.titleName != Constant.titleHeartRatePeak) {
                    if(matchedWeekOtherTitleDataWeek5[k].total != null) {
                      daysData.total =
                          matchedWeekOtherTitleDataWeek5[k].total!.toInt();
                      daysData.daysDataValueTitleController.text =
                          matchedWeekOtherTitleDataWeek5[k].total!
                              .toInt()
                              .toString();
                    }
                    daysData.activityName = matchedWeekOtherTitleDataWeek5[k].displayLabel ?? "";
                    daysData.activityStartDate = matchedWeekOtherTitleDataWeek5[k].activityStartDate ?? DateTime.now();
                    daysData.activityEndDate = matchedWeekOtherTitleDataWeek5[k].activityEndDate ?? DateTime.now();
                    daysData.isFromAppleHealth = matchedWeekOtherTitleDataWeek5[k].isFromAppleHealth;
                  }

                  data.daysList[l].daysDataList.add(daysData);
                }
              }
            }
          }
        }
      }

      if(j == 0) {
        if(dataCheckBox.daysListCheckBox.isNotEmpty){
          for (int a = 0; a < dataCheckBox.daysListCheckBox.length; a++) {
            var selectedCheckBoxList = dataCheckBox.daysListCheckBox[a].daysDataListCheckBox
                .where((element) => element.isCheckedDaysData).toList();
            if(selectedCheckBoxList.isNotEmpty){
              dataCheckBox.daysListCheckBox[a].isCheckedDay = true;
            }
          }
        }
        daysStrengthDataList.add(dataCheckBox);
      }else if(j == 1) {
        caloriesDataList.add(data);
      }else if(j == 2) {
        stepsDataList.add(data);
      }else if(j == 3) {
        heartRateRestDataList.add(data);
      }else if(j == 4) {
        heartRatePeakDataList.add(data);
      }else if(j == 5) {
        experienceDataList.add(data);
      }
    }

  }

  addDaysDataSelectedActivityDateWise(int mainIndex, int dayIndex,String labelName,DateTime activityStartDate,DateTime activityEndDate,{Function? reCall}) async {
    activityStartDateLast = DateTime.now();
    activityEndDateLast = DateTime.now();
    FocusScope.of(Get.context!).requestFocus(FocusNode());

    var listOfLastData = trackingChartDataList[mainIndex].
    dayLevelDataList[dayIndex]
        .activityLevelDataList;

    var dataIsInWithoutAnotherData = Utils.checkDateOverlap(listOfLastData,
        activityStartDate,activityEndDate,);

    if(dataIsInWithoutAnotherData){
      Utils.showToast(Get.context!, "You have to select unique date");
      return;
    }
    Get.back();

    var iconPath = trackingChartDataList[mainIndex].
    dayLevelDataList[dayIndex]
        .activityLevelDataIcons[
    trackingChartDataList[mainIndex]
        .dayLevelDataList[dayIndex]
        .activityLevelData.indexWhere((element) => element == labelName).toInt()
    ].toString();

    var dataName = trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].activityLevelDataList.length;
    var data = ActivityLevelData();
    data.iconPath = iconPath;
    data.displayLabel = labelName;
    data.storedDate = trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].storedDate;
    data.activityStartDate = Utils.getPickedDateFromStoredDate(activityStartDate);
    data.activityEndDate =  Utils.getPickedDateFromStoredDate(activityEndDate);

    data.totalMinValueFocus.addListener(() {
        var valueTotalDayData = data.totalMinController.text;
        if (valueTotalDayData != data.totalMinValue.toString()) {
          if (!data.totalMinValueFocus.hasFocus) {
            var findIndex = trackingChartDataList[mainIndex]
                .dayLevelDataList[dayIndex].activityLevelDataList.indexOf(data);
            if (findIndex != -1) {
              onChangeActivityMinTotalDaysData(
                  mainIndex, dayIndex, findIndex, valueTotalDayData,
                  isManualChanges: true);
              return;
            }
          }
        }
      });


    data.modMinValueFocus.addListener(() {
      var value1TotalDayData = data.modMinController.text;
      if(value1TotalDayData != data.modMinValue.toString()) {
        if (!data.modMinValueFocus.hasFocus) {
          var findIndex = trackingChartDataList[mainIndex]
              .dayLevelDataList[dayIndex].activityLevelDataList.indexOf(data);
          if(findIndex != -1){
            onChangeActivityMinModDayData(
                mainIndex, dayIndex, findIndex, value1TotalDayData,
                isManualChanges: true);
            return;
          }
        }
      }
    });

    data.vigMinValueFocus.addListener(() {
      var value2TotalDayData = data.vigMinController.text;
      if(value2TotalDayData != data.vigMinValue.toString()) {
        if (!data.vigMinValueFocus.hasFocus) {
          var findIndex = trackingChartDataList[mainIndex]
              .dayLevelDataList[dayIndex].activityLevelDataList.indexOf(data);
          if(findIndex != -1){
            onChangeActivityMinVigDayData(
                mainIndex, dayIndex, findIndex, value2TotalDayData);
            return;
          }
        }
      }
    });


    trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].activityLevelDataList.add(data);
    trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].isExpanded = true;

    var otherTitle2CheckBoxDataModel = OtherTitles2CheckBoxDaysData();
    otherTitle2CheckBoxDataModel.titleName =  Constant.titleDaysStr;
    otherTitle2CheckBoxDataModel.storedDate =  daysStrengthDataList[mainIndex].daysListCheckBox[dayIndex].storedDate;
    daysStrengthDataList[mainIndex].daysListCheckBox[dayIndex].daysDataListCheckBox.add(otherTitle2CheckBoxDataModel);
    daysStrengthDataList[mainIndex].daysListCheckBox[dayIndex].isExpanded = true;


    var caloriesDaysDataClass = CaloriesStepHeartRateData();
    caloriesDaysDataClass.name = "Data ${dataName+1}";
    caloriesDaysDataClass.titleName = Constant.titleCalories;
    caloriesDaysDataClass.activityName = labelName;
    caloriesDaysDataClass.storedDate = activityStartDate;
    caloriesDaysDataClass.activityStartDate = Utils.getPickedDateFromStoredDate(activityStartDate);
    caloriesDaysDataClass.activityEndDate =  Utils.getPickedDateFromStoredDate(activityEndDate);
    caloriesDaysDataClass.daysDataValueFocus.addListener(() {
      var valueTotalWeek = caloriesDaysDataClass.daysDataValueTitleController.text;
      if(valueTotalWeek != "" && valueTotalWeek != "0" && valueTotalWeek !=
          caloriesDaysDataClass.total.toString()) {
        if (!caloriesDaysDataClass.daysDataValueFocus.hasFocus) {
          var findIndex = caloriesDataList[mainIndex].daysList[dayIndex].daysDataList.indexOf(caloriesDaysDataClass);
          if(findIndex != -1) {
            onChangeCountOtherDaysData(mainIndex, dayIndex,
                findIndex, valueTotalWeek,
                Constant.titleCalories);
          }
          return;
        }
      }
    });
    caloriesDataList[mainIndex].daysList[dayIndex].daysDataList.add(caloriesDaysDataClass);
    caloriesDataList[mainIndex].daysList[dayIndex].isExpanded = true;

    var stepsDaysDataClass = CaloriesStepHeartRateData();
    stepsDaysDataClass.name = "Data ${dataName+1}";
    stepsDaysDataClass.titleName = Constant.titleSteps;
    stepsDaysDataClass.activityName = labelName;
    stepsDaysDataClass.storedDate = stepsDataList[mainIndex].daysList[dayIndex].storedDate;
    stepsDaysDataClass.activityStartDate = Utils.getPickedDateFromStoredDate(stepsDataList[mainIndex].daysList[dayIndex].storedDate);
    stepsDaysDataClass.activityEndDate =  Utils.getPickedDateFromStoredDate(activityEndDate);
    stepsDaysDataClass.daysDataValueFocus.addListener(() {
      var valueTotalWeek = stepsDaysDataClass.daysDataValueTitleController.text;
      if(valueTotalWeek != "" && valueTotalWeek != "0" && valueTotalWeek != stepsDaysDataClass.total.toString()) {
        if (!stepsDaysDataClass.daysDataValueFocus.hasFocus) {
          var findIndex = stepsDataList[mainIndex].daysList[dayIndex].daysDataList.indexOf(stepsDaysDataClass);
          if(findIndex != -1) {
            onChangeCountOtherDaysData(mainIndex, dayIndex,
                findIndex, valueTotalWeek,
                Constant.titleSteps);
          }
          return;
        }
      }
    });
    stepsDataList[mainIndex].daysList[dayIndex].daysDataList.add(stepsDaysDataClass);
    stepsDataList[mainIndex].daysList[dayIndex].isExpanded = true;

    var heartRateRestDaysData = CaloriesStepHeartRateData();
    heartRateRestDaysData.name = "Data ${dataName+1}";
    heartRateRestDaysData.titleName = Constant.titleHeartRateRest;
    heartRateRestDaysData.activityName = labelName;
    heartRateRestDaysData.storedDate = heartRateRestDataList[mainIndex].daysList[dayIndex].storedDate;
    heartRateRestDaysData.activityStartDate = Utils.getPickedDateFromStoredDate(heartRateRestDataList[mainIndex].daysList[dayIndex].storedDate);
    heartRateRestDaysData.activityEndDate =  Utils.getPickedDateFromStoredDate(activityEndDate);
    heartRateRestDaysData.daysDataValue1Focus.addListener(() {
      var valueTotalWeek = heartRateRestDaysData.daysDataValue1Title5Controller.text;
      if(valueTotalWeek != "" && valueTotalWeek != "0" && valueTotalWeek !=
          heartRateRestDaysData.total.toString()) {
        if (!heartRateRestDaysData.daysDataValue1Focus.hasFocus) {
          var findIndex = heartRateRestDataList[mainIndex].daysList[dayIndex].daysDataList.indexOf(heartRateRestDaysData);
          if(findIndex != -1) {
            onChangeCountOtherDaysData(mainIndex, dayIndex,
                findIndex, valueTotalWeek,
                Constant.titleHeartRateRest);
          }
          return;
        }
      }
    });
    heartRateRestDataList[mainIndex].daysList[dayIndex].daysDataList.add(heartRateRestDaysData);
    heartRateRestDataList[mainIndex].daysList[dayIndex].isExpanded = true;

    var heartRatePeakDaysDataClass = CaloriesStepHeartRateData();
    heartRatePeakDaysDataClass.name = "Data ${dataName+1}";
    heartRatePeakDaysDataClass.titleName = Constant.titleHeartRatePeak;
    heartRatePeakDaysDataClass.activityName = labelName;
    heartRatePeakDaysDataClass.storedDate = heartRatePeakDataList[mainIndex].daysList[dayIndex].storedDate;
    heartRatePeakDaysDataClass.activityStartDate = Utils.getPickedDateFromStoredDate( heartRatePeakDataList[mainIndex].daysList[dayIndex].storedDate);
    heartRatePeakDaysDataClass.activityEndDate =  Utils.getPickedDateFromStoredDate(activityEndDate);
    heartRatePeakDaysDataClass.daysDataValue2Focus.addListener(() {
      var valueTotalWeek = heartRatePeakDaysDataClass.daysDataValue2Title5Controller.text;
      if(valueTotalWeek != "" && valueTotalWeek != "0" && valueTotalWeek !=
          heartRatePeakDaysDataClass.total.toString()) {
        if (!heartRatePeakDaysDataClass.daysDataValue2Focus.hasFocus) {
          var findIndex = heartRatePeakDataList[mainIndex].daysList[dayIndex].daysDataList.indexOf(heartRatePeakDaysDataClass);
          if(findIndex != -1) {
            onChangeCountOtherDaysData(mainIndex, dayIndex,
                findIndex, valueTotalWeek,
                Constant.titleHeartRatePeak);
          }
          return;
        }
      }
    });
    heartRatePeakDataList[mainIndex].daysList[dayIndex].daysDataList.add(heartRatePeakDaysDataClass);
    heartRatePeakDataList[mainIndex].daysList[dayIndex].isExpanded = true;

    var smileyDataClassDaysData = CaloriesStepHeartRateData();
    smileyDataClassDaysData.name = "Data ${dataName+1}";
    smileyDataClassDaysData.titleName = Constant.titleExperience;
    smileyDataClassDaysData.activityName = labelName;
    smileyDataClassDaysData.smileyType = Constant.defaultSmileyType;
    smileyDataClassDaysData.storedDate = experienceDataList[mainIndex].daysList[dayIndex].storedDate;
    smileyDataClassDaysData.activityStartDate = Utils.getPickedDateFromStoredDate( experienceDataList[mainIndex].daysList[dayIndex].storedDate);
    smileyDataClassDaysData.activityEndDate =  Utils.getPickedDateFromStoredDate(activityEndDate);
    experienceDataList[mainIndex].daysList[dayIndex].daysDataList.add(smileyDataClassDaysData);
    experienceDataList[mainIndex].daysList[dayIndex].isExpanded = true;


    updatePopUpMenuList(mainIndex,dayIndex,labelName,isRemove: true);
    // var subIndex = trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].activityLevelDataList.length-1;
    // onChangeActivityMinModDayData(mainIndex,dayIndex,subIndex,"",byDefault: true,reCall: reCall);
    if(kIsWeb){
      // reCall!();
    }
    var activityTableDataList = getActivityListData();

    if(activityTableDataList.isNotEmpty){

      var activityTypeDataList = activityTableDataList.where((element) => element.displayLabel ==
          labelName &&
          Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now())  ==  Utils.changeDateFormatBasedOnDBDate(data.activityStartDate) &&
          Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now())  ==  Utils.changeDateFormatBasedOnDBDate(data.activityEndDate)
          && element.type == Constant.typeDaysData
          && element.title == Constant.titleActivityType).toList();
      if(activityTypeDataList.isEmpty){
        var insertingData = ActivityTable();
        insertingData.displayLabel = labelName;
        insertingData.dateTime = data.storedDate;
        insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(data.storedDate ?? DateTime.now());
        insertingData.activityStartDate = data.activityStartDate;
        insertingData.activityEndDate = data.activityEndDate;
        insertingData.title = Constant.titleActivityType;
        insertingData.smileyType = null;
        insertingData.total = null;
        insertingData.value1 = null;
        insertingData.value2 = null;
        insertingData.type = Constant.typeDaysData;
        String formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy).format(trackingChartDataList[mainIndex].weekStartDate!);
        String formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy).format(trackingChartDataList[mainIndex].weekEndDate!);
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
        await Syncing.createChildActivityNameObservation(
            labelName,
            insertingData);
      }

      var activityParentListData = activityTableDataList.where((element) => element.displayLabel ==
          labelName &&  Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now())  ==  Utils.changeDateFormatBasedOnDBDate(data.activityStartDate) &&
          Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now())  ==  Utils.changeDateFormatBasedOnDBDate(data.activityEndDate)
          && element.type == Constant.typeDaysData
          && element.title == Constant.titleParent).toList();
      if(activityParentListData.isEmpty){
        var insertingData = ActivityTable();
        insertingData.displayLabel = labelName;
        insertingData.dateTime = data.storedDate;
        insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(data.storedDate ?? DateTime.now());
        insertingData.activityStartDate = data.activityStartDate;
        insertingData.activityEndDate = data.activityEndDate;
        insertingData.title = Constant.titleParent;
        insertingData.smileyType = null;
        insertingData.total = null;
        insertingData.value1 = null;
        insertingData.value2 = null;
        insertingData.type = Constant.typeDaysData;
        String formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy).format(trackingChartDataList[mainIndex].weekStartDate!);
        String formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy).format(trackingChartDataList[mainIndex].weekEndDate!);
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
        Syncing.createParentActivityObservation(
            insertingData);
      }

    }

    if(labelName.toLowerCase().contains(Constant.strengthActivity.toLowerCase())){
    onChangeDaysStrengthCheckBoxDay(mainIndex, dayIndex,isForceTrue: true);
    }

    var getTotalMinFromTwoDates = Utils.getTotalMinFromTwoDates(
        activityStartDate,activityEndDate);

    var findIndexOfActivityLevelData = -1;
    findIndexOfActivityLevelData = trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].activityLevelDataList.indexWhere((element) =>
    Utils.changeDateFormatBasedOnDBDate(element.activityStartDate)  ==  Utils.changeDateFormatBasedOnDBDate(activityStartDate)
        && Utils.changeDateFormatBasedOnDBDate(element.activityEndDate)  ==  Utils.changeDateFormatBasedOnDBDate(activityEndDate)
        && element.displayLabel == labelName).toInt();

    if(findIndexOfActivityLevelData >= 0) {
      await updateTotalMinAtActivityLevel(
          DateFormat(Constant.commonDateFormatDdMmYyyy)
              .format(activityStartDate)
          ,
          labelName,
          activityStartDate,
          activityEndDate,
          getTotalMinFromTwoDates,
          mainIndex,
          dayIndex,
          findIndexOfActivityLevelData,false);

      await updateDeleteActivityWhenChangeTime(
          trackingChartDataList[mainIndex].dayLevelDataList, mainIndex, dayIndex, findIndexOfActivityLevelData,false,
          activityStartDate,
          activityEndDate);
    }
    update();
  }

  updatePopUpMenuList(int mainIndex, int dayIndex,String labelName,{bool isRemove = false}) async {
    List<ConfigurationClass> configurationPrefData = Preference.shared.getConfigPrefList(Preference.configurationInfo) ?? [];

    if(configurationPrefData.isNotEmpty){
        for(int i=0; i < configurationPrefData.length;i++){
          var findDataList = trackingChartDataList[mainIndex]
              .dayLevelDataList[dayIndex]
              .activityLevelDataList.where((element) => element.displayLabel == configurationPrefData[i].title).toList();

          if( !trackingChartDataList[mainIndex].dayLevelDataList[dayIndex]
                  .activityLevelData.contains(configurationPrefData[i].title)) {
            if(configurationPrefData[i].isEnabled){
              trackingChartDataList[mainIndex].dayLevelDataList[dayIndex]
                  .activityLevelData.add(configurationPrefData[i].title);
              trackingChartDataList[mainIndex].dayLevelDataList[dayIndex]
                  .activityLevelDataIcons.add(configurationPrefData[i].iconImage);
            }
          }

        }
    }
    update();
  }

  /*removeDaysDataIndexWise(int mainIndex,int dayIndex,int daysDataIndex) async {
    var selectedData = trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].activityLevelDataList[daysDataIndex];

    try {
      HealthFactory health = HealthFactory();
      var permissions = ( (Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthTypeIos).map((e) => HealthDataAccess.READ_WRITE).toList();
      bool? hasPermissions = await health.hasPermissions((Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthTypeIos, permissions: permissions);
      if (Platform.isIOS) {
        hasPermissions = Utils.getPermissionHealth();
      }

      var startDate = trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].activityLevelDataList[daysDataIndex].activityStartDate;

      var endDate = trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].activityLevelDataList[daysDataIndex].activityEndDate;
      if(hasPermissions!) {
        var deletedData = await Utils.deleteWorkout(startDate, endDate, health);
        Debug.printLog("removeDaysDataIndexWise deletedData...$startDate  $endDate  $deletedData  ${selectedData.displayLabel}");
      }
    } catch (e) {
      Debug.printLog("Remove data...$e");
    }

    var dataListHive = getActivityListData();

    var indexId = dataListHive.where((element) =>
        element.type == Constant.typeDaysData &&
        (element.value1 == selectedData.modMinValue || element.value1 == null) &&
        (element.value2 == selectedData.vigMinValue || element.value2 == null) &&
        (element.total == selectedData.totalMinValue || element.total == null) &&
        element.date == trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].date &&
        element.displayLabel == selectedData.displayLabel &&
            element.title == null &&
            element.smileyType == null &&
        element.activityStartDate == trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].activityLevelDataList[daysDataIndex].activityStartDate &&
            element.activityEndDate == trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].activityLevelDataList[daysDataIndex].activityEndDate
    ).toList();


    if(indexId.isNotEmpty) {
        var dayDataInsertedIdList =  dataListHive.where((element) => element.displayLabel == selectedData.displayLabel &&
            element.type == Constant.typeDaysData &&
            element.date == trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].date &&
            element.displayLabel == selectedData.displayLabel &&
            element.activityStartDate == trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].activityLevelDataList[daysDataIndex].activityStartDate &&
            element.activityEndDate == trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].activityLevelDataList[daysDataIndex].activityEndDate).toList();
        var activityDataList  = dayDataInsertedIdList
        .where((element) => element.title == null && element.smileyType == null).toList();
        if(dayDataInsertedIdList.isNotEmpty){
          dayDataInsertedIdList.remove(activityDataList[0]);
        }
        if(dayDataInsertedIdList.isNotEmpty){
          for (int i = 0; i < dayDataInsertedIdList.length; i++) {
            var idKey = dayDataInsertedIdList[i].key;
            await DataBaseHelper.shared.deleteSingleActivityData(idKey);
          }
          var caloriesData = caloriesDataList[mainIndex].daysList[dayIndex].daysDataList[daysDataIndex].total;

          if(caloriesData <= caloriesDataList[mainIndex].daysList[dayIndex].total){
            caloriesDataList[mainIndex].daysList[dayIndex].total = caloriesDataList[mainIndex].daysList[dayIndex].total - caloriesData;
            onChangeCalStepHeartDay(mainIndex, dayIndex, caloriesDataList[mainIndex].daysList[dayIndex].total.toString()
                , Constant.titleCalories, Constant.titleCalories,isRemove: true);
          }else{
            caloriesDataList[mainIndex].daysList[dayIndex].total = 0;
            onChangeCalStepHeartDay(mainIndex, dayIndex, ""
                , Constant.titleCalories, Constant.titleCalories,isRemove: true);
          }


          var stepsData = stepsDataList[mainIndex].daysList[dayIndex].daysDataList[daysDataIndex].total;
          if(stepsData <= stepsDataList[mainIndex].daysList[dayIndex].total){
            stepsDataList[mainIndex].daysList[dayIndex].total = stepsDataList[mainIndex].daysList[dayIndex].total - stepsData;
            onChangeCalStepHeartDay(mainIndex, dayIndex, stepsDataList[mainIndex].daysList[dayIndex].total.toString()
                , Constant.titleSteps, Constant.titleSteps,isRemove: true);
          }else{
            stepsDataList[mainIndex].daysList[dayIndex].total = 0;
            onChangeCalStepHeartDay(mainIndex, dayIndex, ""
                , Constant.titleSteps, Constant.titleSteps,isRemove: true);
          }



          var heartRateData = heartRateRestDataList[mainIndex].daysList[dayIndex].daysDataList[daysDataIndex].total;
          if(heartRateData <= heartRateRestDataList[mainIndex].daysList[dayIndex].total){
            heartRateRestDataList[mainIndex].daysList[dayIndex].total = heartRateRestDataList[mainIndex].daysList[dayIndex].total - heartRateData;
            onChangeCalStepHeartDay(mainIndex, dayIndex, heartRateRestDataList[mainIndex].daysList[dayIndex].total.toString()
                , Constant.titleHeartRateRest, Constant.titleHeartRateRest,isRemove: true);
          }else{
            heartRateRestDataList[mainIndex].daysList[dayIndex].total = 0;
            onChangeCalStepHeartDay(mainIndex, dayIndex, ""
                , Constant.titleHeartRateRest, Constant.titleHeartRateRest,isRemove: true);
          }


          var heartPeakData = heartRatePeakDataList[mainIndex].daysList[dayIndex].daysDataList[daysDataIndex].total;
          if(heartPeakData <= heartRatePeakDataList[mainIndex].daysList[dayIndex].total){
            heartRatePeakDataList[mainIndex].daysList[dayIndex].total = heartRatePeakDataList[mainIndex].daysList[dayIndex].total - heartPeakData;
            onChangeCalStepHeartDay(mainIndex, dayIndex, heartRatePeakDataList[mainIndex].daysList[dayIndex].total.toString()
                , Constant.titleHeartRatePeak, Constant.titleHeartRatePeak,isRemove: true);
          }else{
            heartRatePeakDataList[mainIndex].daysList[dayIndex].total = 0;
            onChangeCalStepHeartDay(mainIndex, dayIndex, ""
                , Constant.titleHeartRatePeak, Constant.titleHeartRatePeak,isRemove: true);
          }


          daysStrengthDataList[mainIndex].daysListCheckBox[dayIndex].daysDataListCheckBox.removeAt(daysDataIndex);
          caloriesDataList[mainIndex].daysList[dayIndex].daysDataList.removeAt(daysDataIndex);
          stepsDataList[mainIndex].daysList[dayIndex].daysDataList.removeAt(daysDataIndex);
          heartRateRestDataList[mainIndex].daysList[dayIndex].daysDataList.removeAt(daysDataIndex);
          heartRatePeakDataList[mainIndex].daysList[dayIndex].daysDataList.removeAt(daysDataIndex);
          experienceDataList[mainIndex].daysList[dayIndex].daysDataList.removeAt(daysDataIndex);

          var modMinValue = selectedData.modMinValue;
          var vigMinValue = selectedData.vigMinValue;
          var totalMinValue = selectedData.totalMinValue;

          if(trackingChartDataList[mainIndex].modMinValue - ((modMinValue == null)?0:modMinValue) >= 0){
            trackingChartDataList[mainIndex].modMinValue = trackingChartDataList[mainIndex].modMinValue - ((modMinValue == null)?0:modMinValue);
            trackingChartDataList[mainIndex].modMinController.text = ((trackingChartDataList[mainIndex].modMinValue.toString() == "0")?"":
            trackingChartDataList[mainIndex].modMinValue.toString());

            if(trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].modMinValue - ((modMinValue == null)?0:modMinValue) >= 0) {
              trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].modMinValue =
                  trackingChartDataList[mainIndex].dayLevelDataList[dayIndex]
                      .modMinValue - ((modMinValue == null) ? 0 : modMinValue);
              trackingChartDataList[mainIndex].dayLevelDataList[dayIndex]
                  .modMinController.text =
              ((trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].modMinValue
                  .toString() == "0") ? "" :
              trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].modMinValue
                  .toString());
            }else{
              trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].modMinValue = 0;
              trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].modMinController.text = "";
            }
          }else{
            trackingChartDataList[mainIndex].modMinValue = 0;
            trackingChartDataList[mainIndex].modMinController.text = "";
            trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].modMinValue = 0;
            trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].modMinController.text = "";
          }


          if(trackingChartDataList[mainIndex].vigMinValue - ((vigMinValue == null)?0:vigMinValue) >= 0){
            trackingChartDataList[mainIndex].vigMinValue = trackingChartDataList[mainIndex].vigMinValue - ((vigMinValue == null)?0:vigMinValue);
            trackingChartDataList[mainIndex].vigMinController.text = ((trackingChartDataList[mainIndex].vigMinValue.toString() == "0")?"":
            trackingChartDataList[mainIndex].vigMinValue.toString());
            if(trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].vigMinValue - ((vigMinValue == null)?0:vigMinValue) >= 0) {
              trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].vigMinValue =
                  trackingChartDataList[mainIndex].dayLevelDataList[dayIndex]
                      .vigMinValue - ((vigMinValue == null) ? 0 : vigMinValue);
              trackingChartDataList[mainIndex].dayLevelDataList[dayIndex]
                  .vigMinController.text =
              ((trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].vigMinValue
                  .toString() == "0") ? "" :
              trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].vigMinValue
                  .toString());
            }else{
              trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].vigMinValue = 0;
              trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].vigMinController.text = "";
            }
          }else{
            trackingChartDataList[mainIndex].vigMinValue = 0;
            trackingChartDataList[mainIndex].vigMinController.text = "";
            trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].vigMinValue = 0;
            trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].vigMinController.text = "";
          }


          if(trackingChartDataList[mainIndex].totalMinValue - ((totalMinValue == null)?0:totalMinValue) >= 0){
            trackingChartDataList[mainIndex].totalMinValue = trackingChartDataList[mainIndex].totalMinValue - ((totalMinValue == null)?0:totalMinValue);
            trackingChartDataList[mainIndex].totalMinController.text = ((trackingChartDataList[mainIndex].totalMinValue.toString() == "0")?"":
            trackingChartDataList[mainIndex].totalMinValue.toString());

            if(trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].totalMinValue - ((totalMinValue == null)?0:totalMinValue) >= 0) {
              trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].totalMinValue =
                  trackingChartDataList[mainIndex].dayLevelDataList[dayIndex]
                      .totalMinValue - ((totalMinValue == null) ? 0 : totalMinValue);
              trackingChartDataList[mainIndex].dayLevelDataList[dayIndex]
                  .totalMinController.text =
              ((trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].totalMinValue
                  .toString() == "0") ? "" :
              trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].totalMinValue
                  .toString());
            }else{
              trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].totalMinValue = 0;
              trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].totalMinController.text = "";
            }

          }else{
            trackingChartDataList[mainIndex].totalMinValue = 0;
            trackingChartDataList[mainIndex].totalMinController.text = "";
            trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].totalMinValue = 0;
            trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].totalMinController.text = "";
          }

          insertUpdateWeekData(mainIndex,isRemove: true);

          insertUpdateActivityMinDayLevelData(mainIndex, dayIndex,false,isRemove: true);
        }



        dataListHive = getActivityListData();
        var deleteSingleEntryForActivityData = dataListHive.where((element) =>
        element.type == Constant.typeDaysData &&
            (element.value1 == selectedData.modMinValue || element.value1 == null) &&
            (element.value2 == selectedData.vigMinValue || element.value2 == null) &&
            (element.total == selectedData.totalMinValue || element.total == null) &&
            element.date == trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].date &&
            element.displayLabel == selectedData.displayLabel &&
            element.title == null &&
            element.smileyType == null &&
            element.displayLabel == selectedData.displayLabel &&
            element.activityStartDate == trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].activityLevelDataList[daysDataIndex].activityStartDate &&
            element.activityEndDate == trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].activityLevelDataList[daysDataIndex].activityEndDate).toList();
        if(deleteSingleEntryForActivityData.isNotEmpty) {
          await DataBaseHelper.shared.deleteSingleActivityData(deleteSingleEntryForActivityData[0].key);
          trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].activityLevelDataList.removeAt(
              daysDataIndex);
        }


    }
    else{
      daysStrengthDataList[mainIndex].daysListCheckBox[dayIndex].daysDataListCheckBox.removeAt(daysDataIndex);
      caloriesDataList[mainIndex].daysList[dayIndex].daysDataList.removeAt(daysDataIndex);
      stepsDataList[mainIndex].daysList[dayIndex].daysDataList.removeAt(daysDataIndex);
      heartRateRestDataList[mainIndex].daysList[dayIndex].daysDataList.removeAt(daysDataIndex);
      heartRatePeakDataList[mainIndex].daysList[dayIndex].daysDataList.removeAt(daysDataIndex);
      experienceDataList[mainIndex].daysList[dayIndex].daysDataList.removeAt(daysDataIndex);

      var modMinValue = selectedData.modMinValue;
      var vigMinValue = selectedData.vigMinValue;
      var totalMinValue = selectedData.totalMinValue;

      if(trackingChartDataList[mainIndex].modMinValue - ((modMinValue == null)?0:modMinValue) >= 0){
        trackingChartDataList[mainIndex].modMinValue = trackingChartDataList[mainIndex].modMinValue - ((modMinValue == null)?0:modMinValue);
        trackingChartDataList[mainIndex].modMinController.text = ((trackingChartDataList[mainIndex].modMinValue.toString() == "0")?"":
        trackingChartDataList[mainIndex].modMinValue.toString());
        trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].modMinValue =
            trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].modMinValue - ((modMinValue == null)?0:modMinValue);
        trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].modMinController.text =
        ((trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].modMinValue.toString() == "")?"":
        trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].modMinValue.toString());
      }else{
        trackingChartDataList[mainIndex].modMinValue = 0;
        trackingChartDataList[mainIndex].modMinController.text = "";
        trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].modMinValue = 0;
        trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].modMinController.text = "";
      }


      if(trackingChartDataList[mainIndex].vigMinValue - ((vigMinValue == null)?0:vigMinValue) >= 0){
        trackingChartDataList[mainIndex].vigMinValue = trackingChartDataList[mainIndex].vigMinValue - ((vigMinValue == null)?0:vigMinValue);
        trackingChartDataList[mainIndex].vigMinController.text = ((trackingChartDataList[mainIndex].vigMinValue.toString() == "0")?"":
        trackingChartDataList[mainIndex].vigMinValue.toString());
        trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].vigMinValue =
            trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].vigMinValue - ((vigMinValue == null)?0:vigMinValue);
        trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].vigMinController.text =
        ((trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].vigMinValue.toString() == "0")?"":
        trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].vigMinValue.toString());
      }else{
        trackingChartDataList[mainIndex].vigMinValue = 0;
        trackingChartDataList[mainIndex].vigMinController.text = "";
        trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].vigMinValue = 0;
        trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].vigMinController.text = "";
      }



      if(trackingChartDataList[mainIndex].totalMinValue - ((totalMinValue == null)?0:totalMinValue) >= 0){

        trackingChartDataList[mainIndex].totalMinValue = trackingChartDataList[mainIndex].totalMinValue - ((totalMinValue == null)?0:totalMinValue);
        trackingChartDataList[mainIndex].totalMinController.text = ((trackingChartDataList[mainIndex].totalMinValue.toString() == "0")?"":
        trackingChartDataList[mainIndex].totalMinValue.toString());
        trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].totalMinValue =
            trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].totalMinValue - ((totalMinValue == null)?0:totalMinValue);
        trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].totalMinController.text =
        ((trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].totalMinValue.toString() == "0")?"":
        trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].totalMinValue.toString());
      }else{

        trackingChartDataList[mainIndex].totalMinValue = 0;
        trackingChartDataList[mainIndex].totalMinController.text = "";
        trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].totalMinValue = 0;
        trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].totalMinController.text = "";
      }




      insertUpdateWeekData(mainIndex,isRemove: true);
      insertUpdateActivityMinDayLevelData(mainIndex, dayIndex,false,isRemove: true);
      trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].activityLevelDataList.removeAt(
          daysDataIndex);
    }

    var dataListHiveNew = getActivityListData();
    var smileyData = dataListHiveNew.where((element) => element.title == null && element.smileyType != null &&
        element.type == Constant.typeDaysData && element.date == trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].date &&
        element.displayLabel == selectedData.displayLabel).toList();
    if(smileyData.isNotEmpty){
      await DataBaseHelper.shared.deleteSingleActivityData(smileyData[0].key);
    }

    updatePopUpMenuList(
        mainIndex,
        dayIndex,
        selectedData.displayLabel,isRemove: true);
    update();
  }*/

  Future<void> onChangeDaysStrengthCheckBoxDay(int mainIndex,int dayIndex,{bool isForceTrue = false}) async {
    if(isForceTrue){
      daysStrengthDataList[mainIndex].daysListCheckBox[dayIndex]
          .isCheckedDay = true;
    }else {
      daysStrengthDataList[mainIndex].daysListCheckBox[dayIndex]
          .isCheckedDay =
      !daysStrengthDataList[mainIndex].daysListCheckBox[dayIndex]
          .isCheckedDay;
    }
    var totalSelectedBox = daysStrengthDataList[mainIndex]
        .daysListCheckBox
        .where((element) => element.isCheckedDay)
        .toList().length;
    var allDataFromDB = getActivityListData();
    String formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy).format(trackingChartDataList[mainIndex].weekStartDate!);
    String formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy).format(trackingChartDataList[mainIndex].weekEndDate!);
    var weekInsertedData = allDataFromDB
        .where((element) =>
    element.weeksDate == "$formattedDateStart-$formattedDateEnd" &&
        element.type == Constant.typeWeek && element.title == Constant.titleDaysStr)
        .toList();
    if(weekInsertedData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.name = "";
      insertingData.date = DateTime.now().toString();
      insertingData.title = Constant.titleDaysStr;
      insertingData.total = totalSelectedBox.toDouble();
      insertingData.type = Constant.typeWeek;
      insertingData.dateTime = trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].storedDate;
      String formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy).format(
          trackingChartDataList[mainIndex].weekStartDate!);
      String formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy).format(trackingChartDataList[mainIndex].weekEndDate!);
      insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";
      //insertingData.patientId = Utils.getPatientId();
      var id = await DataBaseHelper.shared.insertActivityData(insertingData);
      Debug.printLog("onChangeCheckBoxDays if......$id");
    }
    else{
      String formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy).format(trackingChartDataList[mainIndex].weekStartDate!);
      String formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy).format(trackingChartDataList[mainIndex].weekEndDate!);
      var weekInsertedData = allDataFromDB
          .where((element) =>
      element.weeksDate == "$formattedDateStart-$formattedDateEnd"  && element.type == Constant.typeWeek
          && element.title == Constant.titleDaysStr)
          .toList()
          .single;
      // weekInsertedData.dateTime = activityMinDataList[mainIndex].weekDaysDataList[dayIndex].storedDate;
      weekInsertedData.total = totalSelectedBox.toDouble();
      await DataBaseHelper.shared.updateActivityData(weekInsertedData);
    }

    var dayInsertedDataCheckBox = allDataFromDB
        .where((element) =>
    element.date ==  daysStrengthDataList[mainIndex].daysListCheckBox[dayIndex].date &&
        element.type == Constant.typeDay && element.title == Constant.titleDaysStr)
        .toList();
    if(dayInsertedDataCheckBox.isEmpty){
      /*Insert title2 checkbox days*/
      var insertCheckBoxDayData = ActivityTable();
      insertCheckBoxDayData.title = Constant.titleDaysStr;
      insertCheckBoxDayData.dateTime = trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].storedDate ?? DateTime.now();
      insertCheckBoxDayData.date = daysStrengthDataList[mainIndex].daysListCheckBox[dayIndex].date;
      insertCheckBoxDayData.type = Constant.typeDay;
      insertCheckBoxDayData.total = totalSelectedBox.toDouble();
      formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(daysStrengthDataList[mainIndex].weekStartDate!);
      formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(daysStrengthDataList[mainIndex].weekEndDate!);
      insertCheckBoxDayData.weeksDate = "$formattedDateStart-$formattedDateEnd";
      insertCheckBoxDayData.isCheckedDay = daysStrengthDataList[mainIndex].daysListCheckBox[dayIndex]
          .isCheckedDay;

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
          insertCheckBoxDayData.serverDetailList.add(data);
        }
      }

      //insertCheckBoxDayData.patientId = Utils.getPatientId();
      await DataBaseHelper.shared.insertActivityData(insertCheckBoxDayData);
    }
    else{

      String formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(daysStrengthDataList[mainIndex].daysListCheckBox[dayIndex].storedDate!);

      var weekInsertedData = allDataFromDB
          .where((element) => element.date == formattedDate && element.type == Constant.typeDay
          && element.title == Constant.titleDaysStr).toList();
      weekInsertedData[0].title = Constant.titleDaysStr;
      weekInsertedData[0].isCheckedDay =
          daysStrengthDataList[mainIndex].daysListCheckBox[dayIndex]
              .isCheckedDay;
      weekInsertedData[0].total = totalSelectedBox.toDouble();

      var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
      if (weekInsertedData[0].serverDetailList.length !=
          allSelectedServersUrl.length) {
        for (int i = 0; i < allSelectedServersUrl.length; i++) {
          var url = weekInsertedData[0].serverDetailList;
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
            weekInsertedData[0].serverDetailList.add(
                serverDetail);
          }
        }
      }

      await DataBaseHelper.shared.updateActivityData(
          weekInsertedData[0]);
    }

    ///Update count of checkbox in monthly summary
    try {
      var dayLevelDataList = getActivityListData()
              .where((elementMain) =>
          elementMain.type == Constant.typeDay &&
              elementMain.dateTime!.month ==
                  daysStrengthDataList[mainIndex].daysListCheckBox[dayIndex].storedDate!.month &&
              elementMain.title == Constant.titleDaysStr && elementMain.isCheckedDay != null && elementMain.isCheckedDay == true).toList();

      var monthlyDataDbList = getMonthlyDataList();
      var foundedList = monthlyDataDbList.where((element) => element.monthName == Utils.getMonthName(daysStrengthDataList[mainIndex].daysListCheckBox[dayIndex].storedDate!.month,
              daysStrengthDataList[mainIndex].daysListCheckBox[dayIndex].storedDate!.year)
              && element.year == daysStrengthDataList[mainIndex].daysListCheckBox[dayIndex].storedDate!.year).toList();

      if (foundedList.isNotEmpty) {
        ///Update
        foundedList[0].isOverrideStrength = false;
        foundedList[0].isSyncStrength = false;
        if (dayLevelDataList.isEmpty) {
          foundedList[0].strengthValue = null;
        } else {
          // foundedList[0].strengthValue =
          //     double.parse(dayLevelDataList.length.toString());

          foundedList[0].strengthValue  = double.parse((dayLevelDataList.length / 5).round().toStringAsFixed(2));

        }
        var allSelectedServersUrl = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected).toList();
        if (foundedList[0].serverDetailListStrength.length !=
            allSelectedServersUrl.length) {
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = foundedList[0].serverDetailListStrength;
            if (url
                .where((element) =>
            element.serverUrl == allSelectedServersUrl[i].url)
                .toList()
                .isEmpty) {
              var data = ServerDetailDataTable();
              data.serverUrl = allSelectedServersUrl[i].url;
              data.patientId = allSelectedServersUrl[i].patientId;
              data.objectId = "";
              data.patientName = "${allSelectedServersUrl[i]
                  .patientFName}${allSelectedServersUrl[i].patientLName}";
              foundedList[0].serverDetailListStrength.add(data);
            }
          }
        }
        await DataBaseHelper.shared.updateMonthlyData(foundedList[0]);
      }
      else{
        var newMonthlyData = MonthlyLogTableData();
        var dateSelected = daysStrengthDataList[mainIndex].daysListCheckBox[dayIndex].storedDate;
        newMonthlyData.monthName = Utils.getMonthName(dateSelected!.month,
            dateSelected.year);
        newMonthlyData.year = dateSelected.year;
        newMonthlyData.isOverrideDayPerWeek = false;
        newMonthlyData.isOverrideAvgMin = false;
        newMonthlyData.isOverrideAvgMinPerWeek = false;
        newMonthlyData.isOverrideStrength = false;
        newMonthlyData.startDate = Utils.getMonthStartDate(dateSelected);
        newMonthlyData.endDate = Utils.getMonthEndDate(dateSelected);


        if (dayLevelDataList.isEmpty) {
          newMonthlyData.strengthValue = null;
        } else {
          // newMonthlyData.strengthValue =
          //     double.parse(dayLevelDataList.length.toString());
          newMonthlyData.strengthValue = double.parse((dayLevelDataList.length / 5).round().toStringAsFixed(2));
        }

        newMonthlyData.isSyncStrength = false;
        var connectedServerUrl = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected).toList();

        if (connectedServerUrl.isNotEmpty) {
          for (int i = 0; i < connectedServerUrl.length; i++) {
            var data = ServerDetailDataTable();
            data.serverUrl = connectedServerUrl[i].url;
            data.patientId = connectedServerUrl[i].patientId;
            data.clientId = connectedServerUrl[i].clientId;
            data.objectId = "";
            data.serverToken = connectedServerUrl[i].authToken;
            data.patientName =
            "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
                .patientLName}";
            newMonthlyData.serverDetailListStrength.add(data);
          }
        }

        await DataBaseHelper.shared.insertMonthlyData(newMonthlyData);
      }

      var selectedDate = daysStrengthDataList[mainIndex].daysListCheckBox[dayIndex].storedDate;
      var startDateOfMonth = Utils.getMonthStartDate(selectedDate ?? DateTime.now());
      var endDateOfMonth = Utils.getMonthEndDate(selectedDate ?? DateTime.now());
      var getCurrentMonthDataStrength = getMonthlyDataList()
          .where((element) =>
      Utils.getDateFromFullDate(element.startDate ?? DateTime.now()) ==
          Utils.getDateFromFullDate(startDateOfMonth ?? DateTime.now()) &&
          Utils.getDateFromFullDate(element.endDate ?? DateTime.now()) ==
              Utils.getDateFromFullDate(endDateOfMonth ?? DateTime.now()))
          .toList();

      var isSyncStrength = false;
      if (getCurrentMonthDataStrength.isNotEmpty) {
        isSyncStrength = getCurrentMonthDataStrength[0].isSyncStrength;
      }
      if (!isSyncStrength) {

        var indexOfAvgValueOfMonth =  Utils.allYearlyMonths.indexWhere((element) =>
        element.name == Utils.getMonthName(startDateOfMonth.month, startDateOfMonth.year)
        ).toInt();

        if (indexOfAvgValueOfMonth != -1) {
          List<SyncMonthlyActivityData> allSyncingData = [];
          await Syncing.syncMonthlyDataStrength(
              getMonthlyDataList(), allSyncingData, indexOfAvgValueOfMonth,
              isFromRefresh: false,
              startDate: startDateOfMonth,
              endDate: endDateOfMonth);
          await Syncing.observationSyncDataStrengthDaysPerWeek(allSyncingData);
          Debug.printLog("isSyncStrength...$indexOfAvgValueOfMonth  $allSyncingData");
        }
      }
    } catch (e) {
      Debug.printLog(e.toString());
    }



    daysStrengthDataList[mainIndex].total = totalSelectedBox;
    daysStrengthDataList[mainIndex].weekValueTitle2CheckBoxController.text =
        totalSelectedBox.toString();
    var allDataFromDBNew = getActivityListData();
    var checkBoxData = allDataFromDBNew.where((element) =>
        element.title == Constant.titleDaysStr &&
        element.type == Constant.typeDay && Utils.changeDateFormatBasedOnDBDateWithOutTIme(
        element.dateTime ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDateWithOutTIme(
        daysStrengthDataList[mainIndex].daysListCheckBox[dayIndex].storedDate ?? DateTime.now()
    ) ).toList();
    if(checkBoxData.isNotEmpty){
      List<SyncMonthlyActivityData> checkBoxDataList = [];
      var checkBox = 0.0;
      if(daysStrengthDataList[mainIndex].daysListCheckBox[dayIndex]
          .isCheckedDay){
        checkBox = 1.0;
      }
      checkBoxDataList.add(SyncMonthlyActivityData(
          "",
          checkBox,
          Utils.changeDateFormatBasedOnDBDateWithOutTIme(
              checkBoxData[0].dateTime ?? DateTime.now()),
          null,
          checkBoxData[0].key,
          Constant.titleDaysStr,
          true,
          checkBoxData[0].objectId));
      await Syncing.observationSyncDataStrengthBox(checkBoxDataList);
    }
    update();
  }




  Future<void> onChangeDaysStrengthCheckBoxDaysData(int mainIndex,int daysIndex, int daysDataIndex,{bool byDefault = false,Function? reCall}) async {
    daysStrengthDataList[mainIndex].daysListCheckBox[daysIndex].daysDataListCheckBox[daysDataIndex].isCheckedDaysData =
    !daysStrengthDataList[mainIndex].daysListCheckBox[daysIndex].daysDataListCheckBox[daysDataIndex].isCheckedDaysData;
   /* if(byDefault){
      reCall!.call();
    }
*/
    var allDataFromDB = getActivityListData();

    var checkedListForInsertData = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList
        .where((element) =>
    (element.modMinValue == null &&
        element.vigMinValue == null &&
        element.totalMinValue == null ) && element.displayLabel == Constant.titleDaysStr
    )
        .toList();

    int insertedId = 0;
    if(checkedListForInsertData.isNotEmpty ){
      trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].modMinValue = 0;
      trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].vigMinValue = 0;
      trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].totalMinValue = 0;
      var insertingData = ActivityTable();
      insertingData.name = "Data ${daysDataIndex+1}";
      insertingData.displayLabel = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].displayLabel;
      insertingData.dateTime = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].storedDate;
      insertingData.date = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].date;
      insertingData.title = null;
      insertingData.value1 = null;
      insertingData.value2 = null;
      insertingData.total = null;
      insertingData.type = Constant.typeDaysData;
      String formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy).format(trackingChartDataList[mainIndex].weekStartDate!);
      String formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy).format(trackingChartDataList[mainIndex].weekEndDate!);
      insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";
      insertedId = await DataBaseHelper.shared.insertActivityData(insertingData);
      Debug.printLog("onChangeCheckBoxDaysData if......$insertedId");
      String formattedDate = "";
      formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(daysStrengthDataList[mainIndex].daysListCheckBox[daysIndex].storedDate!);

      /*Insert title2 checkbox daysData*/
      var insertCheckBoxDayData = ActivityTable();
      insertCheckBoxDayData.title = Constant.titleDaysStr;
      insertCheckBoxDayData.dateTime = daysStrengthDataList[mainIndex].daysListCheckBox[daysIndex].storedDate ?? DateTime.now();
      insertCheckBoxDayData.date = daysStrengthDataList[mainIndex].daysListCheckBox[daysIndex].date;
      insertCheckBoxDayData.displayLabel = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].displayLabel;
      insertCheckBoxDayData.total = null;
      insertCheckBoxDayData.type = Constant.typeDaysData;
      formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(daysStrengthDataList[mainIndex].weekStartDate!);
      formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(daysStrengthDataList[mainIndex].weekEndDate!);
      insertCheckBoxDayData.weeksDate = "$formattedDateStart-$formattedDateEnd";
      insertCheckBoxDayData.isCheckedDayData = daysStrengthDataList[mainIndex].daysListCheckBox[daysIndex].daysDataListCheckBox[daysDataIndex].isCheckedDaysData;
      //insertCheckBoxDayData.patientId = Utils.getPatientId();
      insertCheckBoxDayData.insertedDayDataId = insertedId;
      await DataBaseHelper.shared.insertActivityData(insertCheckBoxDayData);

      // dummyEntry(mainIndex, daysIndex, daysDataIndex, formattedDate, insertedId);

    }
    else{
      /*Update title2 checkbox daysData*/
      String formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].storedDate!);

      var weekInsertedData = allDataFromDB
          .where((element) => element.date == formattedDate && element.type == Constant.typeDaysData
          && element.title == Constant.titleDaysStr).toList();

      weekInsertedData[daysDataIndex].title = Constant.titleDaysStr;
      weekInsertedData[daysDataIndex].isCheckedDayData =
          daysStrengthDataList[mainIndex].daysListCheckBox[daysIndex]
              .daysDataListCheckBox[daysDataIndex].isCheckedDaysData;

      await DataBaseHelper.shared.updateActivityData(weekInsertedData[daysDataIndex]);
    }

    var selectedCheckBoxArray = daysStrengthDataList[mainIndex]
        .daysListCheckBox[daysIndex]
        .daysDataListCheckBox.where((element) => element.isCheckedDaysData).toList();
    if(selectedCheckBoxArray.isNotEmpty){
      onChangeDaysStrengthCheckBoxDay(mainIndex,daysIndex,isForceTrue: true);
    }else{
      var totalCount = daysStrengthDataList[mainIndex].total ?? 0 - 1;
      daysStrengthDataList[mainIndex].total = totalCount;
      daysStrengthDataList[mainIndex].weekValueTitle2CheckBoxController.text =
          totalCount.toString();

      onChangeDaysStrengthCheckBoxDay(mainIndex,daysIndex);
    }
    if(kIsWeb){
      // reCall!();
    }
    update();
  }

  Future<void> onChangeDaysStrWeek(int mainIndex, dynamic value, String titleName) async {
    insertUpdateAfterOverrideDaysStr(value,mainIndex);
    update();
  }

  insertUpdateAfterOverrideDaysStr(value,int mainIndex) async {
    var allDataFromDB = getActivityListData();
    String formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy).format(trackingChartDataList[mainIndex].weekStartDate!);
    String formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy).format(trackingChartDataList[mainIndex].weekEndDate!);
    var weekInsertedData = allDataFromDB
        .where((element) =>
    element.weeksDate == "$formattedDateStart-$formattedDateEnd" &&
        element.type == Constant.typeWeek && element.title == Constant.titleDaysStr)
        .toList();
    if(weekInsertedData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.name = "";
      insertingData.title = Constant.titleDaysStr;
      insertingData.date = DateTime.now().toString();
      insertingData.total = double.parse(value);
      insertingData.type = Constant.typeWeek;
      String formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy).format(trackingChartDataList[mainIndex].weekStartDate!);
      String formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy).format(trackingChartDataList[mainIndex].weekEndDate!);
      insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";
      //insertingData.patientId = Utils.getPatientId();
      var id = await DataBaseHelper.shared.insertActivityData(insertingData);
      Debug.printLog("onChangeCountOtherTitle2CheckBoxWeeks if......$id");
    }
    else{
      String formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy).format(trackingChartDataList[mainIndex].weekStartDate!);
      String formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy).format(trackingChartDataList[mainIndex].weekEndDate!);
      var weekInsertedData = allDataFromDB
          .where((element) =>
      element.weeksDate == "$formattedDateStart-$formattedDateEnd"  && element.type == Constant.typeWeek
          && element.title == Constant.titleDaysStr)
          .toList()
          .single;
      weekInsertedData.total = double.parse(value);
      await DataBaseHelper.shared.updateActivityData(weekInsertedData);
    }

    if(value != "") {
      daysStrengthDataList[mainIndex].total = int.parse(value);
      daysStrengthDataList[mainIndex].weekValueTitle2CheckBoxController
          .text =
          value.toString();
      daysStrengthDataList[mainIndex].weekValueTitle2CheckBoxController
          .selection =
          TextSelection.fromPosition(TextPosition(offset: value.length));
    }
    else{
      daysStrengthDataList[mainIndex].total = 0;
      daysStrengthDataList[mainIndex].weekValueTitle2CheckBoxController
          .text =
      "";
      daysStrengthDataList[mainIndex].weekValueTitle2CheckBoxController
          .selection =
          TextSelection.fromPosition(const TextPosition(offset: 0));
    }
  }

  /*Future<void> updateSmileyWeekLevel(String iconName, int type,int mainIndex,double expreianceIconValue) async {
    activityMinDataList[mainIndex].smileyType = type;

    var allDataFromDB = getActivityListData();

    String formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy).format(activityMinDataList[mainIndex].weekStartDate!);
    String formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy).format(activityMinDataList[mainIndex].weekEndDate!);

    var checkedListForInsertData = allDataFromDB.where((element) =>
    element.weeksDate == "$formattedDateStart-$formattedDateEnd" &&
        element.type == Constant.typeWeek && element.title == null).toList();


    int insertedId = 0;
    if(checkedListForInsertData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.title = null;
      insertingData.value1 = null;
      insertingData.value2 = null;
      insertingData.total = null;
      insertingData.type = Constant.typeWeek;
      String formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy).format(activityMinDataList[mainIndex].weekStartDate!);
      String formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy).format(activityMinDataList[mainIndex].weekEndDate!);
      insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";
      //insertingData.patientId = Utils.getPatientId();
      insertingData.smileyType = type;
      insertingData.expreianceIconValue = expreianceIconValue;
      insertedId = await DataBaseHelper.shared.insertActivityData(insertingData);
      Debug.printLog("updateSmileyDayLevel if......$insertedId");
    }
    else{
      String formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy).format(activityMinDataList[mainIndex].weekStartDate!);
      String formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy).format(activityMinDataList[mainIndex].weekEndDate!);

      var checkedListForInsertData = allDataFromDB.where((element) =>
      element.weeksDate == "$formattedDateStart-$formattedDateEnd" &&
          element.type == Constant.typeWeek && element.title == null).toList();

      checkedListForInsertData[0].smileyType = type;
      checkedListForInsertData[0].expreianceIconValue = expreianceIconValue;
      await DataBaseHelper.shared.updateActivityData(checkedListForInsertData[0]);
    }

    update();
  }*/

  /*Future<void> updateSmileyDayLevel(String iconName, int type,int mainIndex,int dayIndex,double expreianceIconValue) async {
    activityMinDataList[mainIndex].weekDaysDataList[dayIndex].smileyType = type;

    var allDataFromDB = getActivityListData();
    String formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
        .format(activityMinDataList[mainIndex].weekDaysDataList[dayIndex].storedDate!);

    var checkedListForInsertData = allDataFromDB.where((element) =>
    element.date == formattedDate &&
        element.type == Constant.typeDay && element.title == null && element.smileyType != null).toList();

    int insertedId = 0;
    if(checkedListForInsertData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.dateTime = activityMinDataList[mainIndex].weekDaysDataList[dayIndex].storedDate;
      insertingData.date = activityMinDataList[mainIndex].weekDaysDataList[dayIndex].date;
      insertingData.title = null;
      insertingData.value1 = null;
      insertingData.value2 = null;
      insertingData.total = null;
      insertingData.type = Constant.typeDay;
      String formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy).format(activityMinDataList[mainIndex].weekStartDate!);
      String formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy).format(activityMinDataList[mainIndex].weekEndDate!);
      insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";
      insertingData.smileyType = type;
      insertingData.expreianceIconValue = expreianceIconValue;
      insertedId = await DataBaseHelper.shared.insertActivityData(insertingData);
    }
    else{
      String formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(activityMinDataList[mainIndex].weekDaysDataList[dayIndex].storedDate!);

      var weekInsertedData = allDataFromDB.where((element) =>
      element.date == formattedDate &&
          element.type == Constant.typeDay && element.title == null).toList();

      weekInsertedData[0].smileyType = type;
      weekInsertedData[0].expreianceIconValue = expreianceIconValue;

      await DataBaseHelper.shared.updateActivityData(weekInsertedData[0]);
    }

    update();
  }*/

  Future<void> updateSmileyDayLevel(String iconName, int type,int mainIndex,int dayIndex,int expreianceIconValue) async {
    experienceDataList[mainIndex].daysList[dayIndex].smileyType = type;

    var allDataFromDB = getActivityListData();
    String formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
        .format(experienceDataList[mainIndex].daysList[dayIndex].storedDate!);

    var checkedListForInsertData = allDataFromDB.where((element) =>
    element.date == formattedDate &&
        element.type == Constant.typeDay && element.title == null  && element.total == null && element.smileyType != null).toList();

    int insertedId = 0;
    if(checkedListForInsertData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.dateTime = experienceDataList[mainIndex].daysList[dayIndex].storedDate;
      insertingData.date = experienceDataList[mainIndex].daysList[dayIndex].date;
      insertingData.title = null;
      insertingData.value1 = null;
      insertingData.value2 = null;
      insertingData.total = null;
      insertingData.type = Constant.typeDay;
      insertingData.isSync = false;
      String formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy).format(experienceDataList[mainIndex].weekStartDate!);
      String formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy).format(experienceDataList[mainIndex].weekEndDate!);
      insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";
      insertingData.smileyType = type;
      // insertingData.expreianceIconValue = expreianceIconValue;
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
      insertedId = await DataBaseHelper.shared.insertActivityData(insertingData);
    }
    else{
      String formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(experienceDataList[mainIndex].daysList[dayIndex].storedDate!);

      var weekInsertedData = allDataFromDB.where((element) =>
      element.date == formattedDate &&
          element.type == Constant.typeDay && element.title == null
          && element.total == null && element.smileyType != null).toList();

      weekInsertedData[0].smileyType = type;
      weekInsertedData[0].isSync = false;
      weekInsertedData[0].smileyType = expreianceIconValue;

      var allSelectedServersUrl = Utils.getServerListPreference().where((
          element) => element.patientId != "" && element.isSelected).toList();

      if (weekInsertedData[0].serverDetailList.length !=
          allSelectedServersUrl.length) {
        for (int i = 0; i < allSelectedServersUrl.length; i++) {
          var url = weekInsertedData[0].serverDetailList;
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
            weekInsertedData[0].serverDetailList.add(
                serverDetail);
          }
        }
      }

      await DataBaseHelper.shared.updateActivityData(weekInsertedData[0]);
    }

    List<SyncMonthlyActivityData> allSyncingData = [];
    await Syncing.getAndSetSyncActivityData(allSyncingData,date: formattedDate,isFromEx: true);
    if(allSyncingData.isNotEmpty) {
      await Syncing.observationSyncDataExperience(allSyncingData);
    }

    update();
  }

  /*Future<void> updateSmileyDaysDataLevel(String iconName, int type,int mainIndex,int dayIndex,int daysDataIndex,double expreianceIconValue) async {
    activityMinDataList[mainIndex].weekDaysDataList[dayIndex].daysDataList[daysDataIndex].smileyType = type;

    var allDataFromDB = getActivityListData();
    String formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
        .format(activityMinDataList[mainIndex].weekDaysDataList[dayIndex].storedDate!);

    var checkedListForInsertData = allDataFromDB.where((element) =>
    element.date == formattedDate &&
        element.type == Constant.typeDaysData && element.title == null
        && element.displayLabel ==
        activityMinDataList[mainIndex].weekDaysDataList[dayIndex].daysDataList[daysDataIndex].displayLabel).toList();

    int insertedId = 0;
    if(checkedListForInsertData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.displayLabel = activityMinDataList[mainIndex].weekDaysDataList[dayIndex].
      daysDataList[daysDataIndex].displayLabel;
      insertingData.dateTime = activityMinDataList[mainIndex].weekDaysDataList[dayIndex].storedDate;
      insertingData.date = activityMinDataList[mainIndex].weekDaysDataList[dayIndex].date;
      insertingData.title = null;
      insertingData.value1 = null;
      insertingData.value2 = null;
      insertingData.total = null;
      insertingData.type = Constant.typeDaysData;
      String formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy).format(activityMinDataList[mainIndex].weekStartDate!);
      String formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy).format(activityMinDataList[mainIndex].weekEndDate!);
      insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";
      insertingData.smileyType = type;
      insertingData.expreianceIconValue = expreianceIconValue;
      insertedId = await DataBaseHelper.shared.insertActivityData(insertingData);

      dummyEntry(mainIndex, dayIndex, daysDataIndex, formattedDate, insertedId);
    }
    else{
      String formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(activityMinDataList[mainIndex].weekDaysDataList[dayIndex].storedDate!);

      var weekInsertedData = allDataFromDB.where((element) =>
      element.date == formattedDate &&
          element.type == Constant.typeDaysData && element.title == null
          && element.displayLabel ==
          activityMinDataList[mainIndex].weekDaysDataList[dayIndex].daysDataList[daysDataIndex].displayLabel).toList();

      weekInsertedData[0].smileyType = type;
      weekInsertedData[0].expreianceIconValue = expreianceIconValue;

      await DataBaseHelper.shared.updateActivityData(weekInsertedData[0]);
    }

    update();
  }*/

  Future<void> updateSmileyDaysDataLevel(String iconName, int type,int mainIndex,int dayIndex,int daysDataIndex) async {
    experienceDataList[mainIndex].daysList[dayIndex].daysDataList[daysDataIndex].smileyType = type;

    var allDataFromDB = getActivityListData();
    String formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
        .format(experienceDataList[mainIndex].daysList[dayIndex].storedDate!);

    var checkedListForInsertData = allDataFromDB.where((element) =>
    element.date == formattedDate &&
        element.type == Constant.typeDaysData && element.title == null && element.smileyType != null
    && element.total == null
        && element.displayLabel ==
        trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].activityLevelDataList[daysDataIndex].displayLabel).toList();

    int insertedId = 0;
    if(checkedListForInsertData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.title = experienceDataList[mainIndex].daysList[dayIndex].
      daysDataList[daysDataIndex].titleName;
      insertingData.dateTime = experienceDataList[mainIndex].daysList[dayIndex].storedDate;
      insertingData.date = experienceDataList[mainIndex].daysList[dayIndex].date;
      insertingData.title = null;
      insertingData.value1 = null;
      insertingData.value2 = null;
      insertingData.total = null;
      insertingData.type = Constant.typeDaysData;
      String formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy).format(experienceDataList[mainIndex].weekStartDate!);
      String formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy).format(experienceDataList[mainIndex].weekEndDate!);
      insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";
      insertingData.smileyType = type;
      // insertingData.expreianceIconValue = expreianceIconValue;
      insertedId = await DataBaseHelper.shared.insertActivityData(insertingData);

      // dummyEntry(mainIndex, dayIndex, daysDataIndex, formattedDate, insertedId);
    }
    else{
      String formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(experienceDataList[mainIndex].daysList[dayIndex].storedDate!);

      // var weekInsertedData = allDataFromDB.where((element) =>
      // element.date == formattedDate &&
      //     element.type == Constant.typeDaysData && element.title == null
      //     && element.displayLabel ==
      //     experienceDataList[mainIndex].daysList[dayIndex].daysDataList[daysDataIndex].titleName).toList();
      checkedListForInsertData[0].smileyType = type;
      checkedListForInsertData[0].iconPath = iconName;
      await DataBaseHelper.shared.updateActivityData(checkedListForInsertData[0]);
    }

    if(checkedListForInsertData.isNotEmpty){
      if(Utils.getServerListPreference().isNotEmpty){
        await Syncing.createChildActivityExObservation(
            trackingChartDataList[mainIndex].dayLevelDataList[dayIndex].activityLevelDataList[daysDataIndex].displayLabel,
            checkedListForInsertData[0]);

        if(checkedListForInsertData.isNotEmpty){
          var activityDataTableList = getActivityListData();
          var findParentRecordActivity = activityDataTableList
              .where((element) =>
          element.date == checkedListForInsertData[0].date &&
              element.type == Constant.typeDaysData &&
              element.title == Constant.titleParent &&
              element.displayLabel ==
                  checkedListForInsertData[0]
                      .displayLabel  &&
              element.activityStartDate ==
                  checkedListForInsertData[0]
                      .activityStartDate &&
              element.activityEndDate ==
                  checkedListForInsertData[0]
                      .activityEndDate)
              .toList();
          if(findParentRecordActivity.isNotEmpty) {
            Syncing.createParentActivityObservation(
                findParentRecordActivity[0]);
          }
        }

      }
    }

    update();
  }

  insertUpdateWeekNotesData(int mainIndex,int daysIndex,int daysDataIndex, String notesValue,int type) async {

    var allDataFromDB = getActivityListData();

    if(type == Constant.typeWeek) {
      String formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy).format(
          trackingChartDataList[mainIndex].weekStartDate!);
      String formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy).format(
          trackingChartDataList[mainIndex].weekEndDate!);
      var weekInsertedData = allDataFromDB
          .where((element) =>
      element.weeksDate == "$formattedDateStart-$formattedDateEnd" &&
          element.type == Constant.typeWeek && element.title == null &&
          element.displayLabel == null)
          .toList();
      if (weekInsertedData.isEmpty) {
        var insertingData = ActivityTable();
        insertingData.name = "";
        insertingData.notes = notesValue;
        insertingData.title = null;
        insertingData.value1 = null;
        insertingData.value2 = null;
        insertingData.total = null;
        insertingData.type = Constant.typeWeek;
        String formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy).format(
            trackingChartDataList[mainIndex].weekStartDate!);
        String formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy).format(
            trackingChartDataList[mainIndex].weekEndDate!);
        insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";
        //insertingData.patientId = Utils.getPatientId();
        await DataBaseHelper.shared.insertActivityData(insertingData);
      } else {
        String formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy).format(
            trackingChartDataList[mainIndex].weekStartDate!);
        String formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy).format(
            trackingChartDataList[mainIndex].weekEndDate!);
        var weekInsertedData = allDataFromDB
            .where((element) =>
        element.weeksDate == "$formattedDateStart-$formattedDateEnd" &&
            element.type == Constant.typeWeek
            && element.title == null && element.displayLabel == null)
            .toList()
            .single;
        weekInsertedData.notes = notesValue;
        await DataBaseHelper.shared.updateActivityData(weekInsertedData);
      }
      trackingChartDataList[mainIndex].weeklyNotes = notesValue;
    }
    else if(type == Constant.typeDay){
      List<ActivityTable> weekInsertedData = [];
      if(allDataFromDB.isNotEmpty) {
        String formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy).format(
            trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].storedDate!);

        weekInsertedData = allDataFromDB.where((element) =>
        element.date == formattedDate && element.type == Constant.typeDay && element.title == null).toList();
      }
      if(weekInsertedData.isEmpty){
        var insertingData = ActivityTable();
        insertingData.name = "";
        insertingData.notes = notesValue;
        insertingData.dateTime = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].storedDate;
        insertingData.date = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].date;
        insertingData.title = null;
        insertingData.value1 = null;
        insertingData.value2 = null;
        insertingData.total = null;
        insertingData.type = Constant.typeDay;
        String formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy).format(trackingChartDataList[mainIndex].weekStartDate!);
        String formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy).format(trackingChartDataList[mainIndex].weekEndDate!);
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
        //insertingData.patientId = Utils.getPatientId();
        await DataBaseHelper.shared.insertActivityData(insertingData);
      }
      else{
        String formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
            .format(trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].storedDate!);

/*        var weekInsertedData = allDataFromDB
            .where((element) => element.date == formattedDate && element.type == Constant.typeDay
            && element.title == null).toList().single;*/

        weekInsertedData[0].notes = notesValue;

        var allSelectedServersUrl = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected).toList();

        if (weekInsertedData[0].serverDetailList.length !=
            allSelectedServersUrl.length) {
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = weekInsertedData[0].serverDetailList;
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
              weekInsertedData[0].serverDetailList.add(
                  serverDetail);
            }
          }
        }

        if (weekInsertedData[0].serverDetailListModMin.length !=
            allSelectedServersUrl.length) {
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = weekInsertedData[0].serverDetailListModMin;
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
              weekInsertedData[0].serverDetailListModMin.add(
                  serverDetail);
            }
          }
        }

        if (weekInsertedData[0].serverDetailListVigMin.length !=
            allSelectedServersUrl.length) {
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = weekInsertedData[0].serverDetailListVigMin;
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
              weekInsertedData[0].serverDetailListVigMin.add(
                  serverDetail);
            }
          }
        }

        await DataBaseHelper.shared.updateActivityData(weekInsertedData[0]);
      }
      trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].dailyNotes = notesValue;

      var allDataFromDBNew = getActivityListData();
      var notesWithTotalMinData= allDataFromDBNew.where((element) =>
          element.title == null &&
          element.smileyType == null &&
          element.type == Constant.typeDay && Utils.changeDateFormatBasedOnDBDateWithOutTIme(
          element.dateTime ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDateWithOutTIme(
          trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].storedDate ?? DateTime.now()
      ) ).toList();
      if(notesWithTotalMinData.isNotEmpty){
        List<SyncMonthlyActivityData> totalDataList = [];
        Debug.printLog("notes.. data...${notesWithTotalMinData[0].dateTime}  ${notesWithTotalMinData[0].date}   ${notesWithTotalMinData[0].objectId} ");
        totalDataList.add(SyncMonthlyActivityData(
            "",
            notesWithTotalMinData[0].total ?? 0.0,
            Utils.changeDateFormatBasedOnDBDateWithOutTIme(
                notesWithTotalMinData[0].dateTime ?? DateTime.now()),
            null,
            notesWithTotalMinData[0].key,
            Constant.totalMinPerDay,
            true,
            notesWithTotalMinData[0].objectId,notesDayLevel: notesWithTotalMinData[0].notes ?? ""));
        await Syncing.observationSyncDataTotalMin(totalDataList);
      }
    }
    else if(type == Constant.typeDaysData){
      var weekInsertedData = [];
      String formattedDate = "";
      if(allDataFromDB.isNotEmpty) {
        formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy).format(
            trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].storedDate!);

        weekInsertedData = allDataFromDB.where((element) =>
        element.date == formattedDate &&
            element.type == Constant.typeDaysData && element.title == null
            && element.displayLabel ==
            trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].displayLabel).toList();
      }

      if(weekInsertedData.isEmpty){
        var insertingData = ActivityTable();
        insertingData.name = "Data ${daysDataIndex+1}";
        insertingData.notes = notesValue;
        insertingData.displayLabel = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].displayLabel.toString();
        insertingData.dateTime = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].storedDate;
        insertingData.date = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].date;
        insertingData.title = null;
        insertingData.value1 = null;
        insertingData.value2 = null;
        insertingData.total = null;
        insertingData.type = Constant.typeDaysData;
        String formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy).format(trackingChartDataList[mainIndex].weekStartDate!);
        String formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy).format(trackingChartDataList[mainIndex].weekEndDate!);
        insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";
        //insertingData.patientId = Utils.getPatientId();
        await DataBaseHelper.shared.insertActivityData(insertingData);
      }
      else{
        String formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
            .format(trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].storedDate!);

        var weekInsertedData = allDataFromDB
            .where((element) => element.date == formattedDate &&
            element.type == Constant.typeDaysData  && element.title == null &&
            element.displayLabel == trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].displayLabel).toList();
        if(weekInsertedData.isNotEmpty) {
          if (weekInsertedData[0].key != null) {
            weekInsertedData[0].notes = notesValue;
            await DataBaseHelper.shared.updateActivityData(
                weekInsertedData[0]);
          }
        }
      }

      List<ActivityTable> allDataFromDBNew = getActivityListData();

      trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].dayDataNotes = notesValue;
      List<ActivityTable> notesWithTotalMinData = allDataFromDBNew.where((element) =>
      element.title == null &&
          element.smileyType == null &&
          element.type == Constant.typeDaysData && Utils.changeDateFormatBasedOnDBDateWithOutTIme(
          element.dateTime ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDateWithOutTIme(
          trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].storedDate ?? DateTime.now())
          &&
           Utils.changeDateFormatBasedOnDBDate(
          element.activityStartDate ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDate(
          trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].activityStartDate ?? DateTime.now())
          &&
          Utils.changeDateFormatBasedOnDBDate(
          element.activityEndDate ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDate(
          trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].activityEndDate ?? DateTime.now()
      )
      ).toList();
      if(notesWithTotalMinData.isNotEmpty){
        List<ActivityTable> totalDataList = [];
        Debug.printLog("notes.. data...${notesWithTotalMinData[0].dateTime}  ${notesWithTotalMinData[0].date}   ${notesWithTotalMinData[0].objectId} ");
        await Syncing.createChildActivityTotalMinObservation(
          trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].displayLabel ,notesWithTotalMinData[0] ,);
      }
    }
/*    Future.delayed(const Duration(milliseconds: 500), () {
      // notesController.clear();
    });*/
    update();
  }

  void setNotesOnController(String value) async {
/*    await Future.delayed(const Duration(milliseconds: 500), () {
      notesController.insertHtml(notes.toString() ?? "");
      notesController.clear();
      notesController.insertHtml(notes.toString() ?? "");
      Debug.printLog("insertHtml...$notes");
      update();
    });*/
    try {
      List<dynamic> jsonList = jsonDecode(value);
      Delta delta = Delta.fromJson(jsonList);
      notesController = QuillController(
        document: Document.fromDelta(delta),
        selection: TextSelection.collapsed(offset: 0),
      );
      update();
    } catch (e) {
      Debug.printLog(e.toString());
    }
    notesValueLocal = getDataFromController();
    // notesController.text = notes;
    update();
  }

/*  editNoteDataController(String value,bool isUpdate) {
    notesValueLocal = value;
    if(isUpdate){
      try {
        List<dynamic> jsonList = jsonDecode(value);
        Delta delta = Delta.fromJson(jsonList);
        notesController = QuillController(
          document: Document.fromDelta(delta),
          selection: TextSelection.collapsed(offset: 0),
        );
        update();
      } catch (e) {
        Debug.printLog(e.toString());
      }
      Debug.printLog("insertHtml...$value");
    }
    update();
  }*/

  String getDataFromController(){
    final delta = notesController.document.toDelta();
    Debug.printLog('Current HTML content: $notesValueLocal.......  ${delta.toJson()}');
    notesValueLocal = jsonEncode(notesController.document.toDelta().toList());
    return notesValueLocal;
  }

  void initAllFocusNodeForTextFormFiled() {
    Debug.printLog("initAllFocusNodeForTextFormFiled...$trackingChartDataList");
    for (int i = 0; i < trackingChartDataList.length; i++) {

      ///Week
      trackingChartDataList[i].totalMinValueFocus.addListener(() {
        var valueTotalWeek = trackingChartDataList[i].totalMinController.text;
        if(valueTotalWeek != "" && valueTotalWeek != "0" && valueTotalWeek != trackingChartDataList[i].totalMinValue.toString()) {
          if (!trackingChartDataList[i].totalMinValueFocus.hasFocus) {
            onChangeActivityMinTotalWeek(i, valueTotalWeek,isManualChanges: true);
            return;
          }
        }
      });
      trackingChartDataList[i].modMinValueFocus.addListener(() {
        var valueModWeek = trackingChartDataList[i].modMinController.text;
        if (valueModWeek != "" && valueModWeek != "0" &&
            valueModWeek != trackingChartDataList[i].modMinValue.toString()) {
          if (!trackingChartDataList[i].modMinValueFocus.hasFocus) {
            onChangeActivityMinModWeek(i, valueModWeek);
            return;
          }
        }
      });
      trackingChartDataList[i].vigMinValueFocus.addListener(() {
        var valueVigWeek = trackingChartDataList[i].vigMinController.text;
        if(valueVigWeek != "" && valueVigWeek != "0" && valueVigWeek != trackingChartDataList[i].vigMinValue.toString()) {
          if (!trackingChartDataList[i].vigMinValueFocus.hasFocus) {
            onChangeActivityMinVigWeek(i, valueVigWeek);
            return;
          }
        }
      });

      ///Day
      for (int a = 0;
          a < trackingChartDataList[i].dayLevelDataList.length;
          a++) {
        trackingChartDataList[i].dayLevelDataList[a].totalMinValueFocus.addListener(() {
          var valueTotalDay = trackingChartDataList[i].dayLevelDataList[a].totalMinController.text;
          if(valueTotalDay != "" && valueTotalDay != "0" && valueTotalDay != trackingChartDataList[i].dayLevelDataList[a].totalMinValue.toString()) {

            if (!trackingChartDataList[i].dayLevelDataList[a].totalMinValueFocus
                .hasFocus) {
              onChangeActivityMiTotalDays(i, a, valueTotalDay,true,isManualChanges: true,isFromDays: true,isOverride:true);
              return;
            }
          }
        });
        trackingChartDataList[i].dayLevelDataList[a].modMinValueFocus.addListener(() {
          var valueTotalDay = trackingChartDataList[i].dayLevelDataList[a].modMinController.text;
          if(valueTotalDay != "" && valueTotalDay != "0" && valueTotalDay != trackingChartDataList[i].dayLevelDataList[a].modMinValue.toString()) {
            if (!trackingChartDataList[i].dayLevelDataList[a].modMinValueFocus
                .hasFocus) {
              onChangeActivityMinModDay(i, a, valueTotalDay,true,isFromDialog: true);
              return;
            }
          }
        });
        trackingChartDataList[i].dayLevelDataList[a].vigMinValueFocus.addListener(() {
          var valueTotalDay = trackingChartDataList[i].dayLevelDataList[a].vigMinController.text;
          if(valueTotalDay != "" && valueTotalDay != "0" && valueTotalDay != trackingChartDataList[i].dayLevelDataList[a].vigMinValue.toString()) {
            if (!trackingChartDataList[i].dayLevelDataList[a].vigMinValueFocus
                .hasFocus) {
              onChangeActivityMinVigDay(i, a, valueTotalDay,true,isFromDialog: true);
              return;
            }
          }
        });

        for (int b = 0;
        b < trackingChartDataList[i].dayLevelDataList[a].activityLevelDataList.length;
        b++) {
          trackingChartDataList[i].dayLevelDataList[a].activityLevelDataList[b].totalMinValueFocus.addListener(() {
            var valueTotalDayData = trackingChartDataList[i].dayLevelDataList[a].activityLevelDataList[b].
            totalMinController.text;
            if( valueTotalDayData != "" && valueTotalDayData != "0" && valueTotalDayData != trackingChartDataList[i].dayLevelDataList[a].activityLevelDataList[b].totalMinValue.toString()) {
              if (!trackingChartDataList[i].dayLevelDataList[a].activityLevelDataList[b]
                  .totalMinValueFocus.hasFocus) {
                // Utils.showSnackBarAPI(Get.context!,"Rendering data with server may it will take some time");
                onChangeActivityMinTotalDaysData(
                    i, a, b, valueTotalDayData, isManualChanges: true);
                return;
              }
            }
          });

          trackingChartDataList[i].dayLevelDataList[a].activityLevelDataList[b].modMinValueFocus.addListener(() {
            var value1TotalDayData = trackingChartDataList[i].dayLevelDataList[a].activityLevelDataList[b].
            modMinController.text;
            if( value1TotalDayData != "" && value1TotalDayData != "0" && value1TotalDayData != trackingChartDataList
            [i].dayLevelDataList[a].activityLevelDataList[b].modMinValue.toString()) {
              if (!trackingChartDataList[i].dayLevelDataList[a].activityLevelDataList[b]
                  .modMinValueFocus.hasFocus) {
                onChangeActivityMinModDayData(
                    i, a, b, value1TotalDayData);
                return;
              }
            }
          });

          trackingChartDataList[i].dayLevelDataList[a].activityLevelDataList[b].vigMinValueFocus.addListener(() {
            var value2TotalDayData = trackingChartDataList[i].dayLevelDataList[a].activityLevelDataList[b].
            vigMinController.text;
            if( value2TotalDayData != "" && value2TotalDayData != "0" && value2TotalDayData != trackingChartDataList[i]
                .dayLevelDataList[a].activityLevelDataList[b].vigMinValue.toString()) {
              if (!trackingChartDataList[i].dayLevelDataList[a].activityLevelDataList[b]
                  .vigMinValueFocus.hasFocus) {
                onChangeActivityMinVigDayData(
                    i, a, b, value2TotalDayData);
                return;
              }
            }
          });
        }

      }

      Debug.printLog("initAllFocusNodeForTextFormFiled...$trackingChartDataList");
    }

    for (int a = 0; a < caloriesDataList.length; a++) {
      caloriesDataList[a].weekValueFocus.addListener(() {
        var valueTotalWeek = caloriesDataList[a].weekValueTitleController.text;
        if(valueTotalWeek != "" && valueTotalWeek != "0" && valueTotalWeek != caloriesDataList[a].total.toString()) {
          if (!caloriesDataList[a].weekValueFocus.hasFocus) {
            onChangeCalStepWeeks(a, valueTotalWeek, caloriesDataList[a].titleName);
            return;
          }
        }
      });

      for (int b = 0; b < caloriesDataList[a].daysList.length; b++) {
        caloriesDataList[a].daysList[b].daysValueFocus.addListener(() {
          var valueTotalWeek = caloriesDataList[a].daysList[b].daysValueTitleController.text;
          if(valueTotalWeek != "" && valueTotalWeek != "0" && valueTotalWeek !=
              caloriesDataList[a].daysList[b].total.toString()) {
            if (!caloriesDataList[a].daysList[b].daysValueFocus.hasFocus) {
              onChangeCalStepHeartDay(
                  a,
                  b,
                  valueTotalWeek,
                  caloriesDataList[a].daysList[b].titleName,
                  caloriesDataList[a].daysList[b].titleName,isOverride:true);
              return;
            }
          }
        });

        for (int c = 0; c < caloriesDataList[a].daysList[b].daysDataList.length; c++) {
          caloriesDataList[a].daysList[b].daysDataList[c].daysDataValueFocus.addListener(() {
            var valueTotalWeek = caloriesDataList[a].daysList[b].daysDataList[c].daysDataValueTitleController.text;
            if(valueTotalWeek != "" && valueTotalWeek != "0" && valueTotalWeek !=
                caloriesDataList[a].daysList[b].daysDataList[c].total.toString()) {
              if (!caloriesDataList[a].daysList[b].daysDataList[c].daysDataValueFocus.hasFocus) {
                onChangeCountOtherDaysData(a, b,
                    c, valueTotalWeek, caloriesDataList[a].daysList[b].daysDataList[c].titleName);
                return;
              }
            }
          });
        }
      }

    }

    for (int a = 0; a < stepsDataList.length; a++) {
      stepsDataList[a].weekValueFocus.addListener(() {
        var valueTotalWeek = stepsDataList[a].weekValueTitleController.text;
        if(valueTotalWeek != "" && valueTotalWeek != "0" && valueTotalWeek != stepsDataList[a].total.toString()) {
          if (!stepsDataList[a].weekValueFocus.hasFocus) {
            onChangeCalStepWeeks(a, valueTotalWeek, stepsDataList[a].titleName);
            return;
          }
        }
      });

      for (int b = 0; b < stepsDataList[a].daysList.length; b++) {
        stepsDataList[a].daysList[b].daysValueFocus.addListener(() {
          var valueTotalWeek = stepsDataList[a].daysList[b].daysValueTitleController.text;
          if(valueTotalWeek != "" && valueTotalWeek != "0" && valueTotalWeek !=
              stepsDataList[a].daysList[b].total.toString()) {
            if (!stepsDataList[a].daysList[b].daysValueFocus.hasFocus) {
              onChangeCalStepHeartDay(
                  a,
                  b,
                  valueTotalWeek,
                  stepsDataList[a].daysList[b].titleName,
                  stepsDataList[a].daysList[b].titleName);
              return;
            }
          }
        });

        for (int c = 0; c < stepsDataList[a].daysList[b].daysDataList.length; c++) {
          stepsDataList[a].daysList[b].daysDataList[c].daysDataValueFocus.addListener(() {
            var valueTotalWeek = stepsDataList[a].daysList[b].daysDataList[c].daysDataValueTitleController.text;
            if(valueTotalWeek != "" && valueTotalWeek != "0" && valueTotalWeek !=
                stepsDataList[a].daysList[b].daysDataList[c].total.toString()) {
              if (!stepsDataList[a].daysList[b].daysDataList[c].daysDataValueFocus.hasFocus) {
                onChangeCountOtherDaysData(a, b,
                    c, valueTotalWeek, stepsDataList[a].daysList[b].daysDataList[c].titleName);
                return;
              }
            }
          });
        }
      }

    }

    for (int a = 0; a < heartRateRestDataList.length; a++) {

      heartRateRestDataList[a].weekValue1Focus.addListener(() {
        var valueTotalWeek = heartRateRestDataList[a].weekValue1Title5Title5Controller.text;
        if(valueTotalWeek != "" && valueTotalWeek != "0" && valueTotalWeek != heartRateRestDataList[a].total.toString()) {
          if (!heartRateRestDataList[a].weekValue1Focus.hasFocus) {
            onChangeCalStepWeeks(
                a,
                valueTotalWeek,
                Constant.titleHeartRateRest);
            return;
          }
        }
      });

      /*heartRatePeakDataList[a].weekValue2Focus.addListener(() {
        var valueTotalWeek = heartRatePeakDataList[a].weekValue2Title5Controller.text;
        if(valueTotalWeek != "" && valueTotalWeek != "0" && valueTotalWeek != heartRatePeakDataList[a].total.toString()) {
          if (!heartRatePeakDataList[a].weekValue2Focus.hasFocus) {
            onChangeCalStepWeeks(
                a,
                valueTotalWeek,
                Constant.titleHeartRatePeak);
            return;
          }
        }
      });*/

      for (int b = 0; b < heartRateRestDataList[a].daysList.length; b++) {

        heartRateRestDataList[a].daysList[b].daysValue1Focus.addListener(() {
          Debug.printLog("day level.init...Reest heart rate...");

          var valueTotalWeek = heartRateRestDataList[a].daysList[b].daysValue1Title5Controller.text;
          if(valueTotalWeek != "" && valueTotalWeek != "0" && valueTotalWeek !=
              heartRateRestDataList[a].daysList[b].total.toString()) {
            if (!heartRateRestDataList[a].daysList[b].daysValue1Focus.hasFocus) {
              onChangeCalStepHeartDay(
                  a,
                  b,
                  valueTotalWeek,
                  heartRateRestDataList[a].daysList[b].titleName,
                  Constant.titleHeartRateRest);
              return;
            }
          }
        });

       /* heartRatePeakDataList[a].daysList[b].daysValue2Focus.addListener(() {
          Debug.printLog("day level.init...Peak heart rate...");
          var valueTotalWeek = heartRatePeakDataList[a].daysList[b].daysValue2Title5Controller.text;
          if(valueTotalWeek != "" && valueTotalWeek != "0" && valueTotalWeek !=
              heartRatePeakDataList[a].daysList[b].total.toString()) {
            if (!heartRatePeakDataList[a].daysList[b].daysValue2Focus.hasFocus) {
              onChangeCalStepHeartDay(
                  a,
                  b,
                  valueTotalWeek,
                  heartRatePeakDataList[a].daysList[b].titleName,
                  Constant.titleHeartRatePeak);
              return;
            }
          }
        });
*/
        for (int c = 0; c < heartRateRestDataList[a].daysList[b].daysDataList.length; c++) {
          Debug.printLog("Loop for inner day heart rate...");

          heartRateRestDataList[a].daysList[b].daysDataList[c].daysDataValue1Focus.addListener(() {
            Debug.printLog("daysDataValue2Focus.init...Rest heart rate...");
            var valueTotalWeek = heartRateRestDataList[a].daysList[b].daysDataList[c].daysDataValue1Title5Controller.text;
            if(valueTotalWeek != "" && valueTotalWeek != "0" && valueTotalWeek !=
                heartRateRestDataList[a].daysList[b].daysDataList[c].total.toString()) {
              if (!heartRateRestDataList[a].daysList[b].daysDataList[c].daysDataValue1Focus.hasFocus) {
                onChangeCountOtherDaysData(
                    a,
                    b,
                    c,
                    valueTotalWeek,
                    Constant.titleHeartRateRest);
                return;
              }
            }
          });

         /* heartRatePeakDataList[a].daysList[b].daysDataList[c].daysDataValue2Focus.addListener(() {
            Debug.printLog("daysDataValue2Focus.init...Peak heart rate...");
            var valueTotalWeek = heartRatePeakDataList[a].daysList[b].daysDataList[c].daysDataValue2Title5Controller.text;
            if(valueTotalWeek != "" && valueTotalWeek != "0" && valueTotalWeek !=
                heartRatePeakDataList[a].daysList[b].daysDataList[c].total.toString()) {
              if (!heartRatePeakDataList[a].daysList[b].daysDataList[c].daysDataValue2Focus.hasFocus) {
                onChangeCountOtherDaysData(
                    a,
                    b,
                    c,
                    valueTotalWeek,
                    Constant.titleHeartRatePeak);
                return;
              }
            }
          });*/
        }
      }

    }

    for (int a = 0; a < heartRatePeakDataList.length; a++) {

      heartRatePeakDataList[a].weekValue2Focus.addListener(() {
        var valueTotalWeek = heartRatePeakDataList[a].weekValue2Title5Controller.text;
        if(valueTotalWeek != "" && valueTotalWeek != "0" && valueTotalWeek != heartRatePeakDataList[a].total.toString()) {
          if (!heartRatePeakDataList[a].weekValue2Focus.hasFocus) {
            onChangeCalStepWeeks(
                a,
                valueTotalWeek,
                Constant.titleHeartRatePeak);
            return;
          }
        }
      });

      for (int b = 0; b < heartRatePeakDataList[a].daysList.length; b++) {


        heartRatePeakDataList[a].daysList[b].daysValue2Focus.addListener(() {
          Debug.printLog("day level.init...Peak heart rate...");
          var valueTotalWeek = heartRatePeakDataList[a].daysList[b].daysValue2Title5Controller.text;
          if(valueTotalWeek != "" && valueTotalWeek != "0" && valueTotalWeek !=
              heartRatePeakDataList[a].daysList[b].total.toString()) {
            if (!heartRatePeakDataList[a].daysList[b].daysValue2Focus.hasFocus) {
              onChangeCalStepHeartDay(
                  a,
                  b,
                  valueTotalWeek,
                  heartRatePeakDataList[a].daysList[b].titleName,
                  Constant.titleHeartRatePeak);
              return;
            }
          }
        });

        for (int c = 0; c < heartRatePeakDataList[a].daysList[b].daysDataList.length; c++) {
          Debug.printLog("Loop for inner day heart rate...");

          heartRatePeakDataList[a].daysList[b].daysDataList[c].daysDataValue2Focus.addListener(() {
            Debug.printLog("daysDataValue2Focus.init...Peak heart rate...");
            var valueTotalWeek = heartRatePeakDataList[a].daysList[b].daysDataList[c].daysDataValue2Title5Controller.text;
            if(valueTotalWeek != "" && valueTotalWeek != "0" && valueTotalWeek !=
                heartRatePeakDataList[a].daysList[b].daysDataList[c].total.toString()) {
              if (!heartRatePeakDataList[a].daysList[b].daysDataList[c].daysDataValue2Focus.hasFocus) {
                onChangeCountOtherDaysData(
                    a,
                    b,
                    c,
                    valueTotalWeek,
                    Constant.titleHeartRatePeak);
                return;
              }
            }
          });
        }
      }

    }
  }

  List<ActivityTable> getActivityListData(){
    return Hive.box<ActivityTable>(Constant.tableActivity).values.toList().where((element) =>
    element.patientId == Utils.getPatientId()).toList();
  }

  List<MonthlyLogTableData> getMonthlyDataList(){
    return Hive
        .box<MonthlyLogTableData>(Constant.tableMonthlyLog)
        .values
        .toList().where((element) => element.patientId == Utils.getPatientId()).toList();
  }

/*  List<ActivityTable> getActivityListData(){
    Debug.printLog("Total Data ...${Hive.box<ActivityTable>(Constant.tableActivity).values.toList().where((element) =>
    element.serverDetailList.where((element) => element.patientId == Utils.getPatientId()).toList().isNotEmpty).toList().length}");
    Debug.printLog("value");
    return Hive.box<ActivityTable>(Constant.tableActivity).values.toList().where((element) =>
    element.serverDetailList.where((element) => element.patientId == Utils.getPatientId()).toList().isNotEmpty).toList();
  }*/

  dynamic onRefresh() async{
    Constant.isCalledAPI = false;
    // await Utils.clearTrackingChartData();
    update();
    await getAndSetWeeksData(selectedNewDate,notShowDialog: true);
    refreshController.refreshCompleted();
    // await activityDataAPICall(previousDate,nextDate,false);
    Debug.printLog("Complete Api Call.......");
    update();

  }


  dynamic onLoading() async{
    await Future.delayed(Duration(seconds: 3));
    refreshController.loadComplete();
  }

  updateTotalMinAtActivityLevel(String formattedDate,String activityName,DateTime dateStart,DateTime endDate,
      getTotalMinFromTwoDates,int mainIndex,int dayIndex,int daysDataIndex,bool isShowLastDate) async {
    var allDataFromDB = getActivityListData();

    activityStartDateLast = Utils.changeDateFormatBasedOnDBDate(activityStartDateLast);
    activityEndDateLast = Utils.changeDateFormatBasedOnDBDate(activityEndDateLast);

    var activityMinDataList = allDataFromDB
        .where((element) =>
    element.date == formattedDate &&
        element.type == Constant.typeDaysData &&
        element.title == null &&
        element.smileyType == null &&
        element.displayLabel == activityName && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
        Utils.changeDateFormatBasedOnDBDate((isShowLastDate)?activityStartDateLast:dateStart)&&
        Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
            Utils.changeDateFormatBasedOnDBDate((isShowLastDate)?activityEndDateLast:endDate))
        .toList();


    if (activityMinDataList.isEmpty) {
      var insertingData = ActivityTable();
      insertingData.isOverride = false;
      insertingData.displayLabel = activityName;
      insertingData.dateTime = dateStart;
      insertingData.date = formattedDate;
      insertingData.title = null;
      insertingData.value1 = null;
      insertingData.value2 = null;
      insertingData.total = double.parse(getTotalMinFromTwoDates);
      insertingData.iconPath = Utils.getNumberIconNameFromType(activityName);

      String formattedDateStart =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findFirstDateOfTheWeekImport(dateStart));
      String formattedDateEnd =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findLastDateOfTheWeekImport(dateStart));
      insertingData.activityStartDate = dateStart;
      insertingData.activityEndDate = endDate;
      insertingData.type = Constant.typeDaysData;

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


      insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";
      await DataBaseHelper.shared.insertActivityData(insertingData);
    }
    else{
      if(activityMinDataList[0].key != null){
        activityMinDataList[0].displayLabel = activityName;

        activityMinDataList[0].total = double.parse(getTotalMinFromTwoDates);
        activityMinDataList[0].activityStartDate = dateStart;
        activityMinDataList[0].activityEndDate = endDate;
        await DataBaseHelper.shared.updateActivityData(activityMinDataList[0]);
      }
    }

    if(getTotalMinFromTwoDates != "") {
      trackingChartDataList[mainIndex]
          .dayLevelDataList[dayIndex]
          .activityLevelDataList[daysDataIndex]
          .totalMinValue = int.parse(getTotalMinFromTwoDates);
      trackingChartDataList[mainIndex]
          .dayLevelDataList[dayIndex]
          .activityLevelDataList[daysDataIndex]
          .totalMinController
          .text = getTotalMinFromTwoDates;
      await insertUpdateTotalMinAtDayLevel(dateStart,getTotalMinFromTwoDates,mainIndex,dayIndex,daysDataIndex);
    }

    update();
  }

  insertUpdateTotalMinAtDayLevel(DateTime dateTime, String getTotalMinFromTwoDates,
      int mainIndex,int dayIndex,int daysDataIndex)async{

    List<ActivityTable> allDataFromDB = getActivityListData();

    List<ActivityTable> activityDataListFor = Hive.box<ActivityTable>(Constant.tableActivity)
        .values.toList().where((element) => element.type == Constant.typeDaysData
        && element.date == DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateTime)).toList();


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

      if(getTotalMinFromTwoDates != "null" || getTotalMinFromTwoDates != "") {
        insertingData.total = double.parse(getTotalMinFromTwoDates);

        trackingChartDataList[mainIndex]
            .dayLevelDataList[dayIndex].totalMinValue = int.parse(getTotalMinFromTwoDates);
        trackingChartDataList[mainIndex]
            .dayLevelDataList[dayIndex].totalMinController
            .text = getTotalMinFromTwoDates;
      }


      insertingData.type = Constant.typeDay;
      insertingData.isSync = true;

      String selectedWeekStartDate =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findFirstDateOfTheWeekImport(dateTime));
      String selectedWeekEndDate =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findLastDateOfTheWeekImport(dateTime));

      insertingData.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
      insertingData.needExport = true;
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
        if(activityDataListFor[i].title == null && activityDataListFor[i].smileyType == null){
          totalValue += activityDataListFor[i].total ?? 0.0;
        }
      }

      if(totalValue == 0.0){
        activityMinData[0].total = null;
      }else{
        activityMinData[0].total = totalValue;

        trackingChartDataList[mainIndex]
            .dayLevelDataList[dayIndex].totalMinValue = totalValue.toInt();
        trackingChartDataList[mainIndex]
            .dayLevelDataList[dayIndex].totalMinController
            .text = totalValue.toInt().toString();
      }

      var allSelectedServersUrl = Utils.getServerListPreference().where((element) =>
      element.patientId != "" && element.isSelected).toList();

      if(activityMinData[0].serverDetailList.length != allSelectedServersUrl.length){
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
      }
      activityMinData[0].isSync = true;
      activityMinData[0].needExport = true;
      await DataBaseHelper.shared.updateActivityData(activityMinData[0]);
    }

    await insertUpdateCaloriesAtWeekLevel(dateTime,getTotalMinFromTwoDates,mainIndex,dayIndex,daysDataIndex);
  }

  insertUpdateCaloriesAtWeekLevel(DateTime dateTime, String getTotalMinFromTwoDates,
      int mainIndex,int dayIndex,int daysDataIndex)async{


    String formattedDateStart =
    DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findFirstDateOfTheWeekImport(dateTime));
    String formattedDateEnd =
    DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findLastDateOfTheWeekImport(dateTime));

    var weekDate = "$formattedDateStart-$formattedDateEnd";
    List<ActivityTable> allDataFromDB = getActivityListData();

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

      if(getTotalMinFromTwoDates != "null" || getTotalMinFromTwoDates != "") {
        insertingData.total = double.parse(getTotalMinFromTwoDates);
        trackingChartDataList[mainIndex].totalMinValue =
            int.parse(getTotalMinFromTwoDates);
        trackingChartDataList[mainIndex].totalMinController
            .text = getTotalMinFromTwoDates;
      }
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
      trackingChartDataList[mainIndex].totalMinValue =
          totalValue.toInt();
      trackingChartDataList[mainIndex].totalMinController
          .text = totalValue.toInt().toString();

      activityMinWeeklyDataList[0].isSync = false;
      await DataBaseHelper.shared.updateActivityData(activityMinWeeklyDataList[0]);
    }
  }

  updateDeleteActivityWhenChangeTime(List<DayLevelData> weekDaysDataList,int mainIndex,int daysIndex,
      int daysDataIndex,bool isShowLastDate,DateTime dateStart,DateTime endDate) async {

    activityStartDateLast = Utils.changeDateFormatBasedOnDBDate(activityStartDateLast);
    activityEndDateLast = Utils.changeDateFormatBasedOnDBDate(activityEndDateLast);

    if (weekDaysDataList[daysIndex]
        .activityLevelDataList[daysDataIndex].totalMinValue != null) {


      var startDateInit = weekDaysDataList[daysIndex]
          .activityLevelDataList[daysDataIndex]
          .activityStartDate;

      var endDateInit = weekDaysDataList[daysIndex]
          .activityLevelDataList[daysDataIndex]
          .activityEndDate;


      var listOfLastData = weekDaysDataList[daysIndex]
          .activityLevelDataList;

      var checkDateOverlap = Utils.checkDateOverlap(listOfLastData,
          startDateInit,endDateInit,currentActivityData: trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
              .activityLevelDataList[daysDataIndex]);

      var displayLabel =  weekDaysDataList[daysIndex]
          .activityLevelDataList[daysDataIndex]
          .displayLabel;

      String formattedDateStart =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findFirstDateOfTheWeekImport(dateStart));
      String formattedDateEnd =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findLastDateOfTheWeekImport(dateStart));

      var activityDataTableList = getActivityListData();
      var totalMinData = activityDataTableList
          .where((element) =>
          element.type == Constant.typeDaysData &&
          element.title == null &&
          element.smileyType == null &&
          element.total != null &&
          element.displayLabel == displayLabel &&
              Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
          Utils.changeDateFormatBasedOnDBDate(endDateInit)
          && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
          Utils.changeDateFormatBasedOnDBDate(startDateInit))
          .toList();

      var activityTypeDataList = getActivityListData().where((element) => element.displayLabel ==
          displayLabel && Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
          Utils.changeDateFormatBasedOnDBDate((isShowLastDate)?activityEndDateLast:endDateInit)
          && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
              Utils.changeDateFormatBasedOnDBDate((isShowLastDate)?activityStartDateLast:startDateInit)  && element.type == Constant.typeDaysData
          && element.title == Constant.titleActivityType).toList();
      if(activityTypeDataList.isNotEmpty){

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

        activityTypeDataList[0].activityStartDate = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
            .activityLevelDataList[daysDataIndex].activityStartDate;
        activityTypeDataList[0].activityEndDate = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
            .activityLevelDataList[daysDataIndex].activityEndDate;
        await DataBaseHelper.shared.updateActivityData(
            activityTypeDataList[0]);

      }

      var activityCaloriesData = getActivityListData().where((element) => element.displayLabel ==
          displayLabel &&Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
          Utils.changeDateFormatBasedOnDBDate((isShowLastDate)?activityEndDateLast:endDateInit)
          && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
              Utils.changeDateFormatBasedOnDBDate((isShowLastDate)?activityStartDateLast:startDateInit)&&
          element.type == Constant.typeDaysData
          && element.title == Constant.titleCalories).toList();
      if(activityCaloriesData.isNotEmpty){
        var allSelectedServersUrl = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected).toList();

        if (activityCaloriesData[0].serverDetailList.length !=
            allSelectedServersUrl.length) {
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = activityCaloriesData[0].serverDetailList;
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
              activityCaloriesData[0].serverDetailList.add(
                  serverDetail);
            }
          }
        }
        activityCaloriesData[0].activityStartDate = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
            .activityLevelDataList[daysDataIndex].activityStartDate;
        activityCaloriesData[0].activityEndDate = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
            .activityLevelDataList[daysDataIndex].activityEndDate;
        await DataBaseHelper.shared.updateActivityData(
            activityCaloriesData[0]);
      }
      else if(activityCaloriesData.isEmpty){
        var insertingCaloriesData = ActivityTable();
        insertingCaloriesData.title = Constant.titleCalories;
        insertingCaloriesData.needExport = true;
        insertingCaloriesData.isSync = false;
        insertingCaloriesData.displayLabel = displayLabel;
        insertingCaloriesData.dateTime = dateStart;
        insertingCaloriesData.total =  null;
        insertingCaloriesData.date =
            DateFormat(Constant.commonDateFormatDdMmYyyy).format(
                dateStart ?? DateTime.now());
        insertingCaloriesData.type = Constant.typeDaysData;
        insertingCaloriesData.activityStartDate = dateStart;
        insertingCaloriesData.activityEndDate = endDate;
        insertingCaloriesData.weeksDate = "$formattedDateStart-$formattedDateEnd";
        insertingCaloriesData.isFromAppleHealth = false;
        var connectedServerUrlCalories = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected)
            .toList();
        if (connectedServerUrlCalories.isNotEmpty) {
          for (int i = 0; i < connectedServerUrlCalories.length; i++) {
            var data = ServerDetailDataTable();
            data.dataSyncServerWise = false;
              data.objectId = "";

            data.serverUrl = connectedServerUrlCalories[i].url;
            data.patientId = connectedServerUrlCalories[i].patientId;
            data.clientId = connectedServerUrlCalories[i].clientId;
            data.serverToken = connectedServerUrlCalories[i].authToken;
            data.patientName =
            "${connectedServerUrlCalories[i].patientFName}${connectedServerUrlCalories[i]
                .patientLName}";
            insertingCaloriesData.serverDetailList.add(data);
          }
        }
        await DataBaseHelper.shared.insertActivityData(insertingCaloriesData);
      }

      var activityPeakHeartRate = getActivityListData().where((element) => element.displayLabel ==
          displayLabel && Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
          Utils.changeDateFormatBasedOnDBDate((isShowLastDate)?activityEndDateLast:endDateInit)
          && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
              Utils.changeDateFormatBasedOnDBDate((isShowLastDate)?activityStartDateLast:startDateInit) && element.type == Constant.typeDaysData
          && element.title == Constant.titleHeartRatePeak).toList();
      if(activityPeakHeartRate.isNotEmpty){
        var allSelectedServersUrl = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected).toList();

        if (activityPeakHeartRate[0].serverDetailList.length !=
            allSelectedServersUrl.length) {
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = activityPeakHeartRate[0].serverDetailList;
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
              activityPeakHeartRate[0].serverDetailList.add(
                  serverDetail);
            }
          }
        }

        activityPeakHeartRate[0].activityStartDate = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
            .activityLevelDataList[daysDataIndex].activityStartDate;
        activityPeakHeartRate[0].activityEndDate = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
            .activityLevelDataList[daysDataIndex].activityEndDate;
        await DataBaseHelper.shared.updateActivityData(
            activityPeakHeartRate[0]);
      }
      else if(activityPeakHeartRate.isEmpty){
        var insertingDataPeakHeartRate = ActivityTable();
        insertingDataPeakHeartRate.title = Constant.titleHeartRatePeak;
        insertingDataPeakHeartRate.needExport = true;
        insertingDataPeakHeartRate.isSync = false;
        insertingDataPeakHeartRate.displayLabel = displayLabel;
        insertingDataPeakHeartRate.dateTime = dateStart;
        insertingDataPeakHeartRate.total =  null;
        insertingDataPeakHeartRate.date =
            DateFormat(Constant.commonDateFormatDdMmYyyy).format(
                dateStart ?? DateTime.now());
        insertingDataPeakHeartRate.type = Constant.typeDaysData;
        insertingDataPeakHeartRate.activityStartDate = dateStart;
        insertingDataPeakHeartRate.activityEndDate = endDate;
        insertingDataPeakHeartRate.weeksDate = "$formattedDateStart-$formattedDateEnd";

        var connectedServerUrlPeakHeartRate = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected)
            .toList();
        if (connectedServerUrlPeakHeartRate.isNotEmpty) {
          for (int i = 0; i < connectedServerUrlPeakHeartRate.length; i++) {
            var data = ServerDetailDataTable();
            data.dataSyncServerWise = false;
              data.objectId = "";
            data.serverUrl = connectedServerUrlPeakHeartRate[i].url;
            data.patientId = connectedServerUrlPeakHeartRate[i].patientId;
            data.clientId = connectedServerUrlPeakHeartRate[i].clientId;
            data.serverToken = connectedServerUrlPeakHeartRate[i].authToken;
            data.patientName =
            "${connectedServerUrlPeakHeartRate[i].patientFName}${connectedServerUrlPeakHeartRate[i]
                .patientLName}";
            insertingDataPeakHeartRate.serverDetailList.add(data);
          }
        }
        await DataBaseHelper.shared.insertActivityData(insertingDataPeakHeartRate);
      }

      var activityRestHeartRate = getActivityListData().where((element) => element.displayLabel ==
          displayLabel && Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
          Utils.changeDateFormatBasedOnDBDate((isShowLastDate)?activityEndDateLast:endDateInit)
          && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
              Utils.changeDateFormatBasedOnDBDate((isShowLastDate)?activityStartDateLast:startDateInit) && element.type == Constant.typeDaysData
          && element.title == Constant.titleHeartRateRest).toList();
      if(activityRestHeartRate.isNotEmpty){
        var allSelectedServersUrl = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected).toList();

        if (activityRestHeartRate[0].serverDetailList.length !=
            allSelectedServersUrl.length) {
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = activityRestHeartRate[0].serverDetailList;
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
              activityRestHeartRate[0].serverDetailList.add(
                  serverDetail);
            }
          }
        }

        activityRestHeartRate[0].activityStartDate = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
            .activityLevelDataList[daysDataIndex].activityStartDate;
        activityRestHeartRate[0].activityEndDate = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
            .activityLevelDataList[daysDataIndex].activityEndDate;
        await DataBaseHelper.shared.updateActivityData(
            activityRestHeartRate[0]);
      }
      else if(activityRestHeartRate.isEmpty){
        var insertHeartRateRestData = ActivityTable();
        insertHeartRateRestData.title = Constant.titleHeartRateRest;
        insertHeartRateRestData.needExport = true;
        insertHeartRateRestData.isSync = false;
        insertHeartRateRestData.displayLabel = displayLabel;
        insertHeartRateRestData.dateTime = dateStart;
        insertHeartRateRestData.date =
            DateFormat(Constant.commonDateFormatDdMmYyyy).format(
                dateStart ?? DateTime.now());
        insertHeartRateRestData.total = null;
        insertHeartRateRestData.type = Constant.typeDaysData;
        insertHeartRateRestData.activityStartDate = dateStart;
        insertHeartRateRestData.activityEndDate = endDate;
        insertHeartRateRestData.weeksDate = "$formattedDateStart-$formattedDateEnd";
        insertHeartRateRestData.isFromAppleHealth = false;

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
            insertHeartRateRestData.serverDetailList.add(data);
          }
        }
        await DataBaseHelper.shared.insertActivityData(
            insertHeartRateRestData);
      }

      var activityStepsData = getActivityListData().where((element) => element.displayLabel ==
          displayLabel && Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
          Utils.changeDateFormatBasedOnDBDate((isShowLastDate)?activityEndDateLast:endDateInit)
          && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
              Utils.changeDateFormatBasedOnDBDate((isShowLastDate)?activityStartDateLast:startDateInit) && element.type == Constant.typeDaysData
          && element.title == Constant.titleSteps).toList();
      if(activityStepsData.isNotEmpty){
        var allSelectedServersUrl = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected).toList();

        if (activityStepsData[0].serverDetailList.length !=
            allSelectedServersUrl.length) {
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = activityStepsData[0].serverDetailList;
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
              activityStepsData[0].serverDetailList.add(
                  serverDetail);
            }
          }
        }

        activityStepsData[0].activityStartDate = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
            .activityLevelDataList[daysDataIndex].activityStartDate;
        activityStepsData[0].activityEndDate = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
            .activityLevelDataList[daysDataIndex].activityEndDate;
        await DataBaseHelper.shared.updateActivityData(
            activityStepsData[0]);
      }
      else if(activityStepsData.isEmpty){
        var insertingDataSteps = ActivityTable();
        insertingDataSteps.title = Constant.titleSteps;
        insertingDataSteps.needExport = true;
        insertingDataSteps.isSync = false;
        insertingDataSteps.displayLabel = displayLabel;
        insertingDataSteps.dateTime = dateStart;
        insertingDataSteps.total =  null;
        insertingDataSteps.date =
            DateFormat(Constant.commonDateFormatDdMmYyyy).format(
                dateStart ?? DateTime.now());
        insertingDataSteps.type = Constant.typeDaysData;
        insertingDataSteps.activityStartDate = dateStart;
        insertingDataSteps.activityEndDate = endDate;
        insertingDataSteps.weeksDate = "$formattedDateStart-$formattedDateEnd";
        insertingDataSteps.isFromAppleHealth = false;

        var connectedServerUrlSteps = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected)
            .toList();
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
            insertingDataSteps.serverDetailList.add(data);
          }
        }
        await DataBaseHelper.shared.insertActivityData(insertingDataSteps);
      }

      var activityStrDays = getActivityListData().where((element) => element.displayLabel ==
          displayLabel && Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
          Utils.changeDateFormatBasedOnDBDate((isShowLastDate)?activityEndDateLast:endDateInit)
          && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
              Utils.changeDateFormatBasedOnDBDate((isShowLastDate)?activityStartDateLast:startDateInit) && element.type == Constant.typeDaysData
          && element.title == Constant.titleDaysStr).toList();
      if(activityStrDays.isNotEmpty){
        var allSelectedServersUrl = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected).toList();

        if (activityStrDays[0].serverDetailList.length !=
            allSelectedServersUrl.length) {
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = activityStrDays[0].serverDetailList;
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
              activityStrDays[0].serverDetailList.add(
                  serverDetail);
            }
          }
        }

        activityStrDays[0].activityStartDate = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
            .activityLevelDataList[daysDataIndex].activityStartDate;
        activityStrDays[0].activityEndDate = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
            .activityLevelDataList[daysDataIndex].activityEndDate;
        await DataBaseHelper.shared.updateActivityData(
            activityStrDays[0]);
      }
      else if(activityStrDays.isEmpty){
        var insertingDataDaysStr = ActivityTable();
        insertingDataDaysStr.title = Constant.titleDaysStr;
        insertingDataDaysStr.needExport = true;
        insertingDataDaysStr.isSync = false;
        insertingDataDaysStr.displayLabel = displayLabel;
        insertingDataDaysStr.dateTime = dateStart;
        insertingDataDaysStr.date =
            DateFormat(Constant.commonDateFormatDdMmYyyy).format(
                dateStart ?? DateTime.now());
        insertingDataDaysStr.type = Constant.typeDaysData;
        insertingDataDaysStr.activityStartDate = dateStart;
        insertingDataDaysStr.activityEndDate = endDate;
        insertingDataDaysStr.isFromAppleHealth = false;
        insertingDataDaysStr.weeksDate = "$formattedDateStart-$formattedDateEnd";

        var connectedServerUrlDaysStr = Utils.getServerListPreference()
            .where((element) => element.patientId != "" && element.isSelected)
            .toList();
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
            insertingDataDaysStr.serverDetailList.add(data);
          }
        }
        await DataBaseHelper.shared.insertActivityData(insertingDataDaysStr);
      }

      var activityEx = getActivityListData().where((element) => element.displayLabel ==
          displayLabel && Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
          Utils.changeDateFormatBasedOnDBDate((isShowLastDate)?activityEndDateLast:endDateInit)
          && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
              Utils.changeDateFormatBasedOnDBDate((isShowLastDate)?activityStartDateLast:startDateInit) && element.type == Constant.typeDaysData
          && element.title == null && element.smileyType != null).toList();
      if(activityEx.isNotEmpty){
        var allSelectedServersUrl = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected).toList();

        if (activityEx[0].serverDetailList.length !=
            allSelectedServersUrl.length) {
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = activityEx[0].serverDetailList;
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
              activityEx[0].serverDetailList.add(
                  serverDetail);
            }
          }
        }

        activityEx[0].activityStartDate = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
            .activityLevelDataList[daysDataIndex].activityStartDate;
        activityEx[0].activityEndDate = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
            .activityLevelDataList[daysDataIndex].activityEndDate;
        await DataBaseHelper.shared.updateActivityData(
            activityEx[0]);
      }
      else if(activityEx.isEmpty){
        var insertingDataEx = ActivityTable();
        insertingDataEx.title = null;
        insertingDataEx.smileyType = Constant.defaultSmileyType;
        insertingDataEx.date =
            DateFormat(Constant.commonDateFormatDdMmYyyy).format(
                dateStart ?? DateTime.now());
        insertingDataEx.dateTime = dateStart;
        insertingDataEx.displayLabel = displayLabel;
        insertingDataEx.type = Constant.typeDaysData;
        insertingDataEx.activityStartDate = dateStart;
        insertingDataEx.activityEndDate = endDate;
        insertingDataEx.weeksDate = "$formattedDateStart-$formattedDateEnd";
        insertingDataEx.isFromAppleHealth = false;
        var connectedServerUrlEx = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected)
            .toList();
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
            insertingDataEx.serverDetailList.add(data);
          }
        }
        await DataBaseHelper.shared.insertActivityData(insertingDataEx);
      }

      var activityParentListData = getActivityListData().where((element) => element.displayLabel ==
          displayLabel  &&  Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
          Utils.changeDateFormatBasedOnDBDate((isShowLastDate)?activityEndDateLast:endDateInit)
          && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
              Utils.changeDateFormatBasedOnDBDate((isShowLastDate)?activityStartDateLast:startDateInit) && element.type == Constant.typeDaysData
          && element.title == Constant.titleParent).toList();
      if(activityParentListData.isNotEmpty){

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

        activityParentListData[0].activityStartDate = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
            .activityLevelDataList[daysDataIndex].activityStartDate;
        activityParentListData[0].activityEndDate = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
            .activityLevelDataList[daysDataIndex].activityEndDate;
        await DataBaseHelper.shared.updateActivityData(
            activityParentListData[0]);
      }
      /*else if(activityParentListData.isEmpty){
        var insertingData = ActivityTable();
        insertingData.displayLabel = displayLabel;
        insertingData.dateTime = activityStartDateLast;
        insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(activityStartDateLast ?? DateTime.now());
        insertingData.activityStartDate = activityStartDateLast;
        insertingData.activityEndDate = activityEndDateLast;
        insertingData.title = Constant.titleParent;
        insertingData.type = Constant.typeDaysData;
        insertingData.isFromAppleHealth = false;
        insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";
        insertingData.isSync = true;
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
      }*/


      // if(startDateInit.isBefore(endDateInit) && !checkDateOverlap){
      Debug.printLog("activityStartDateLast...$activityStartDateLast  $activityEndDateLast  $dateStart  $endDate");
      if(dateStart.isBefore(endDate) && !checkDateOverlap){
        try {
          // if(!kIsWeb && Platform.isIOS){
          if(!kIsWeb){
            // HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
            var permissions = ( (Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthTypeIos).map((e) => HealthDataAccess.READ_WRITE).toList();
            bool? hasPermissions = await Health().hasPermissions((Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthTypeIos, permissions: permissions);
            if (Platform.isIOS) {
              hasPermissions = Utils.getPermissionHealth();
            }
            /*var sDate = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
              .activityLevelDataList[daysDataIndex].activityStartDate;
          var eDate = trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
              .activityLevelDataList[daysDataIndex].activityEndDate;*/
            if(hasPermissions!) {
              // var deletedData = await Utils.deleteWorkout(sDate, eDate, health);
              var deletedData = await Utils.deleteWorkout(activityStartDateLast, activityEndDateLast, Health());
            }
          }
          HealthWorkoutActivityType workoutType =
              HealthWorkoutActivityType.OTHER;

          List<WorkOutData> getTypeFromName = [];

          if (Platform.isAndroid) {
            getTypeFromName = Utils.workOutDataListAndroid
                .where((element) => element.workOutDataName == displayLabel)
                .toList();
          } else if (Platform.isIOS) {
            getTypeFromName = Utils.workOutDataListIos
                .where((element) => element.workOutDataName == displayLabel)
                .toList();
          }

          if (getTypeFromName.isNotEmpty) {
            workoutType = getTypeFromName[0].datatype;
          } else {
            workoutType = HealthWorkoutActivityType.OTHER;
          }
          var value = caloriesDataList[mainIndex].daysList[daysIndex]
              .daysDataList[daysDataIndex].total;
          Debug.printLog("workoutType...$workoutType  $displayLabel  $value  $dateStart  $endDate  ${Utils.getPermissionHealth()}");

          /*await GetSetHealthData.insertActivityIntoAppleGoogleSync(displayLabel, startDateInit, endDateInit,
              workoutType,value.toString());*/
          // if(!kIsWeb && Utils.getPermissionHealth() && Platform.isIOS){
          if(!kIsWeb && Utils.getPermissionHealth()){
            await GetSetHealthData.insertActivityIntoAppleGoogleSync(displayLabel, dateStart, endDate,
                workoutType,value.toString());
          }

          ///Start API call for Update Time
          if(totalMinData.isNotEmpty) {
            if((totalMinData[0].total ?? 0.0) > 0.0 && totalMinData[0].total != null) {
              await Syncing.createChildActivityTotalMinObservation(
                  trackingChartDataList[mainIndex]
                      .dayLevelDataList[daysIndex]
                      .activityLevelDataList[daysDataIndex]
                      .displayLabel,
                  totalMinData[0]);
            }

            if((totalMinData[0].value1 ?? 0.0) > 0.0 && totalMinData[0].value1 != null) {
              await Syncing.createChildActivityModerateMinObservation(
                  trackingChartDataList[mainIndex]
                      .dayLevelDataList[daysIndex]
                      .activityLevelDataList[daysDataIndex]
                      .displayLabel,
                  totalMinData[0]);
            }

            if((totalMinData[0].value2 ?? 0.0) > 0.0 && totalMinData[0].value2 != null) {
              await Syncing.createChildActivityVigMinObservation(
                  trackingChartDataList[mainIndex]
                      .dayLevelDataList[daysIndex]
                      .activityLevelDataList[daysDataIndex]
                      .displayLabel,
                  totalMinData[0]);
            }
          }

          if(activityTypeDataList.isNotEmpty) {
            await Syncing.createChildActivityNameObservation(
                displayLabel,
                activityTypeDataList[0]);
          }

          if(activityCaloriesData.isNotEmpty) {
            if((activityCaloriesData[0].total ?? 0.0) > 0.0 && activityCaloriesData[0].total != null) {
              await Syncing.createChildActivityCaloriesObservation(displayLabel,
                  activityCaloriesData[0]);
            }
          }

          if(activityPeakHeartRate.isNotEmpty) {
            if((activityPeakHeartRate[0].total ?? 0.0) > 0.0 && activityPeakHeartRate[0].total != null) {
              await Syncing.createChildActivityPeakHeatRateObservation(
                  displayLabel,
                  activityPeakHeartRate[0]);
            }
          }

          if(activityParentListData.isNotEmpty) {
            await Syncing.createParentActivityObservation(
                activityParentListData[0]);
          }

          // onChangeActivityTimeLast(startDateInit, endDateInit);

          var allDataFromDB = getActivityListData();
          var totalMinList= allDataFromDB.where((element) =>
              element.title == null &&
              element.smileyType == null &&
              element.type == Constant.typeDay && element.total != null &&
              Utils.changeDateFormatBasedOnDBDateWithOutTIme(
              element.dateTime ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDateWithOutTIme(
                  weekDaysDataList[daysIndex].storedDate ?? DateTime.now()
          ) ).toList();
          if(totalMinList.isNotEmpty){
            List<SyncMonthlyActivityData> totalDataList = [];
            Debug.printLog("add days..List.list data...${totalMinList[0].dateTime}  ${totalMinList[0].date}   ${totalMinList[0].objectId}  ${double.parse(value.toString())}");
            totalDataList.add(SyncMonthlyActivityData(
                "",
                totalMinList[0].total ?? 0.0,
                Utils.changeDateFormatBasedOnDBDateWithOutTIme(
                    totalMinList[0].dateTime ?? DateTime.now()),
                null,
                totalMinList[0].key,
                Constant.totalMinPerDay,
                true,
                totalMinList[0].objectId,notesDayLevel: totalMinList[0].notes ?? ""));
            await Syncing.observationSyncDataTotalMin(totalDataList);
          }
        } catch (e) {
          Debug.printLog(e.toString());
        }
      }

    }

  }

  DateTime? localStartDate;
  DateTime? localEndDate;

  onChangeActivityDateLocal({DateTime? startDate,DateTime? endDate,bool reset = false}){
    if(reset){
      localStartDate = null;
      localEndDate = null;
    }else{
      if(startDate != null){
        localStartDate = startDate;
      }
      if(endDate != null){
        localEndDate = endDate;
      }
    }
    update();
  }

  void resetLastDate(List<DayLevelData> weekDaysDataList, int daysIndex, int daysDataIndex, DateTime startDate,
      DateTime endDate) {
      weekDaysDataList[daysIndex]
          .activityLevelDataList[daysDataIndex]
          .activityStartDate =
          activityStartDateLast;
      weekDaysDataList[daysIndex]
          .activityLevelDataList[daysDataIndex]
          .activityEndDate =
          activityEndDateLast;
      update();
      Get.back();
  }

  /*callSyncingAPIForPushData() async {
    List<SyncMonthlyActivityData> allSyncingData = [];
    await Syncing.getAndSetSyncActivityData(allSyncingData,date: DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate));
    if(allSyncingData.isNotEmpty) {
      await Syncing.observationSyncDataCalories(allSyncingData);
      await Syncing.observationSyncDataSteps(allSyncingData);
      await Syncing.observationSyncDataRestHeart(allSyncingData);
      await Syncing.observationSyncDataPeakHeart(allSyncingData);
      await Syncing.observationSyncDataTotalMin(allSyncingData);
      await Syncing.observationSyncDataModMin(allSyncingData);
      await Syncing.observationSyncDataVigMin(allSyncingData);
      await Syncing.observationSyncDataStrengthBox(allSyncingData);
    }
  }*/

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // final orientation = WidgetsBinding.instance.window.physicalSize.aspectRatio > 1
    //     ? Orientation.landscape
    //     : Orientation.portrait;
    // isLandscape.value = orientation == Orientation.landscape;
    closePopupMenu();
    update();
  }

  Future<void> closePopupMenu() async {
    if (isMenuOpen) {
      Get.back();
      await Future.delayed(const Duration(milliseconds:500));
      popupMenuKey.currentState?.showButtonMenu();
    }
      // isMenuOpen = false;
      update();
    }




  }

class RowsDataClass{
  String titleName = "";
  bool selected = false;

  RowsDataClass(this.titleName,this.selected);
}
