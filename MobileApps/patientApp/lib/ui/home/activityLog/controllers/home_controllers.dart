
import 'dart:convert';
import 'dart:io';

import 'package:banny_table/db_helper/box/activity_data.dart';
import 'package:banny_table/db_helper/database_helper.dart';
import 'package:banny_table/ui/bottomNavigation/controllers/bottom_navigation_controller.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:fhir/r4.dart';
import 'package:fhir/r4/resource/resource.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:health/health.dart';
import 'package:hive/hive.dart';
import 'package:horizontal_data_table/refresh/pull_to_refresh/pull_to_refresh.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../db_helper/box/notes_data.dart';
import '../../../../db_helper/box/server_detail_data.dart';
import '../../../../db_helper/box/server_detail_data_mod_min.dart';
import '../../../../db_helper/box/server_detail_data_vig_min.dart';
import '../../../../db_helper/box/to_do_form_data.dart';
import '../../../../fhir_auth/r4.dart';
import '../../../../healthData/getSetHealthData.dart';
import '../../../../healthData/getWorkOutDataModel.dart';
import '../../../../providers/api.dart';
import '../../../../resources/PaaProfiles.dart';
import '../../../../resources/syncing.dart';
import '../../../../utils/color.dart';
import '../../../../utils/font_style.dart';
import '../../../../utils/preference.dart';
import '../../../../utils/sizer_utils.dart';
import '../../../../utils/utils.dart';
import '../../../history/controllers/history_controller.dart';
import '../../../toDoList/dataModel/codeModel.dart';
import '../../../toDoList/dataModel/toDoDataListModel.dart';
import '../../../welcomeScreen/activityConfiguration/trackingPref/datamodel/trackingPref.dart';
import '../../../welcomeScreen/healthProvider/selectPrimaryServer/datamodel/serverModelJson.dart';
import '../../monthly/datamodel/syncMonthlyActivityData.dart';

class HomeControllers extends GetxController{

  final BottomNavigationController bottomControllers = Get.find<BottomNavigationController>();


  /*Use on The Title 1*/
  TextEditingController value1Controller = TextEditingController();
  TextEditingController value2Controller = TextEditingController();
  TextEditingController totalValueController = TextEditingController();
  ScrollController controllerScrollBar = ScrollController();
  ScrollController controller2 = ScrollController();
  ScrollController controller = ScrollController();

  // bool isMonth = false;
  // bool isCheckedDay = false;

  /*Use on Month*/
  TextEditingController textValueWBottom = TextEditingController();
  TextEditingController textValueXBottom = TextEditingController();
  TextEditingController textValueYBottom = TextEditingController();
  TextEditingController textValueZBottom = TextEditingController();
  TextEditingController textValueNoteBottom = TextEditingController();

  List<ActivityTable>  userData = [];

  var labelIcon = "assets/icons/ic_emoji(1).jpeg";

  var selectedNewDate = DateTime.now();
  var selectedNewDateDaliy = DateTime.now();

  DateTime? startDate;
  DateTime? endDate;
  List<String> dateList = [];
  List<DailyLogClass> dailyLogDataList = [];
  List<DailyLogClass> dailyLogDataListDay = [];
  List<RowsDataClass> filterData = [];

  List<String> activityLevelData = [];
  List<String> activityLevelIconData = [];
  List<TrackingPref> trackingPrefList = [];
  // DateTime activityStartDate = DateTime.now();
  // DateTime activityEndDate = DateTime.now();
  // DateTime? activityEndDate;

  // DateTime activityStartDateLast = DateTime.now();
  // DateTime activityEndDateLast = DateTime.now();


  gotoTrackingChartPage(){
    bottomControllers.onPageChanged(1);
    update();
  }

  @override
  Future<void> onInit() async {
    // getData();
    if(Preference.shared.getTrackingPrefList(Preference.trackingPrefList)!.isEmpty) {
      var data = [
        TrackingPref(titleName: Constant.configurationHeaderTotal,pos: 0,isSelected: true,/*toolTipText: Constant.configurationHeaderToolTipTotal*/),
        TrackingPref(titleName: Constant.configurationHeaderModerate,pos: 1,isSelected: true,/*toolTipText: Constant.configurationHeaderToolTipModMin*/),
        TrackingPref(titleName: Constant.configurationHeaderVigorous,pos: 2,isSelected: true,/*toolTipText: Constant.configurationHeaderToolTipVigMin*/),
        TrackingPref(titleName: Constant.configurationNotes,pos: 3,isSelected: true,/*toolTipText: Constant.configurationHeaderToolTipNotes*/),
        TrackingPref(titleName: Constant.configurationHeaderDays,pos: 4,isSelected: true,/*toolTipText: Constant.configurationHeaderToolTipStrengthDays*/),
        TrackingPref(titleName: Constant.configurationHeaderCalories,pos: 5,isSelected: true,/*toolTipText: Constant.configurationHeaderToolTipCalories*/),
        TrackingPref(titleName: Constant.configurationHeaderSteps,pos: 6,isSelected: true,/*toolTipText: Constant.configurationHeaderToolTipSteps*/),
        TrackingPref(titleName: Constant.configurationHeaderRest,pos: 7,isSelected: true,/*toolTipText: Constant.configurationHeaderToolTipRestingHeart*/),
        TrackingPref(titleName: Constant.configurationHeaderPeck,pos: 8,isSelected: true,/*toolTipText: Constant.configurationHeaderToolTipPeckHeart*/),
        TrackingPref(titleName: Constant.configurationExperience,pos: 9,isSelected: true,/*toolTipText: Constant.configurationHeaderToolTipExperience*/),
      ];
      var json = jsonEncode(data.map((e) => e.toJson()).toList());
      Preference.shared.setList(Preference.trackingPrefList, json);
      ///Call Api For configuration Data Push
      await Utils.callPushApiForConfigurationActivity();
    }
    trackingPrefList = Preference.shared.getTrackingPrefList(Preference.trackingPrefList) ?? [];

    callToDoAPI(true);
    getFilterDataList();
    endDate = selectedNewDate;
    startDate = selectedNewDate.subtract(const Duration(days: 29));
    generateDateList();
    generateDateDayList();
    super.onInit();
  }

  callToDoAPI(bool needShowExpireDialog) async {
    // await checkTokenExpireTime();

    onLoadingImage();
    if(needShowExpireDialog) {
      await Utils.isExpireTokenAPICall(Constant.screenTypeHome,(value) async {
        if(!value){
          onLoadingImage();
          await getToDoDataList();
          await getToDoDataListApi();
          isTodoLoading = false;
          update();
        }
      }).then((value) async =>
      {
        if(!value){
          await getToDoDataList(),
          await getToDoDataListApi()
        }
      });
    }else{
      await getToDoDataList();
      await getToDoDataListApi();
    }
    isTodoLoading = false;
    update();
  }

  /*checkTokenExpireTime() async {
    var allSelectedServersUrl = Utils.getServerList.where((element) => element.patientId != "" && element.isSelected).toList();
    var primaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
    if (primaryServerData.isNotEmpty) {
      var getServerListIndex = Utils.getServerList.indexWhere((element) => element == primaryServerData[0]).toInt();
      var primaryData = primaryServerData[0];
      if (primaryData.isSecure && Utils.isExpiredToken(
              primaryData.lastLoggedTime, primaryData.expireTime)) {
        await Utils.getAccessTokenFromRefreshToken(primaryData.refreshToken,
            primaryData.clientId,primaryData.clientId).then((value) => {
          Debug.printLog("getAccessTokenFromRefreshToken....$value"),
          if(value.isEmpty){
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              showDialog(
                context: Get.context!,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Session Expired"),
                    content: const Text("Your session has expired. Please log in again."),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Get.back();
                          Utils.callSecureServerAPI(primaryData.url,
                              primaryData.clientId,
                              primaryData.title);
                        },
                        child: const Text("Log in"),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text("Cancel"),
                      ),
                    ],
                  );
                },
              );
            })
          }
          else{
            primaryData.authToken = value["access_token"],
            primaryData.expireTime = value["expires_in"],
            primaryData.refreshToken = value["refresh_token"],
            Utils.getServerList[getServerListIndex].lastLoggedTime = DateTime.now().millisecondsSinceEpoch,
            Utils.getServerList[getServerListIndex].isSecure = true,
            Utils.getServerList[getServerListIndex].isPrimary = Utils.getServerList[getServerListIndex].isPrimary,
            Utils.getServerList[getServerListIndex].isSelected = true,
            Utils.getServerList[getServerListIndex].authToken = value["access_token"],
            Utils.getServerList[getServerListIndex].refreshToken = value["refresh_token"],
            Utils.getServerList[getServerListIndex].expireTime = value["expires_in"],
            Preference.shared.setList(Preference.serverUrlAllListed,jsonEncode(Utils.getServerList.map((e) => e.toJson()).toList())),
            getToDoDataList(),
          }
        });
      }
    }
  }*/

  onLoadingImage(){
    isTodoLoading = true;
    update();
  }

  getPreferenceActivityData() async {
    activityLevelData.clear();
    activityLevelIconData.clear();
    final SharedPreferences pref = await SharedPreferences.getInstance();
    for(int i = 0 ; i < Constant.configurationInfo.length;i++){
      if(Constant.configurationInfo[i].isEnabled){
        activityLevelData.add(Constant.configurationInfo[i].title);
        activityLevelIconData.add(Constant.configurationInfo[i].iconImage);
      }
    }
    Debug.printLog("activityLevelData.....$activityLevelData  $activityLevelIconData");
    update();
  }

  getFilterDataList(){
    filterData.add(RowsDataClass(Constant.itemBicycling, true));
    filterData.add(RowsDataClass(Constant.itemJogging, true));
    filterData.add(RowsDataClass(Constant.itemRunning, true));
    filterData.add(RowsDataClass(Constant.itemSwimming, true));
    filterData.add(RowsDataClass(Constant.itemWalking, true));
    filterData.add(RowsDataClass(Constant.itemWeights, true));
    // filterData.add(RowsDataClass(Constant.itemMixed, true));
  }

  void onSelectionChangedDatePicker(DateRangePickerSelectionChangedArgs args) {
    Debug.printLog("onSelectionChangedDatePicker....${args.value}");
    selectedNewDate = args.value;
    endDate = selectedNewDate;
    startDate = selectedNewDate.subtract(const Duration(days: 29));
    var now = DateTime.now();
    selectedDateDailyLogClass.activityStartDate = DateTime(selectedNewDate.year,selectedNewDate.month,selectedNewDate.day,
        now.hour,now.minute);
    /*activityEndDate = DateTime(selectedNewDate.year,selectedNewDate.month,selectedNewDate.day,
        now.hour,now.minute);*/
    generateDateList();
    update();

  }

  resetData(){
    endDate = DateTime.now();
    startDate = DateTime.now();
    selectedNewDate = DateTime.now();
    // selectedDateDailyLogClass.activityStartDate = DateTime.now();
    // selectedDateDailyLogClass.activityEndDate = DateTime.now();
    update();
  }
  void generateDateList() {
    dailyLogDataList.clear();
    dateList.clear();
    for (var i = startDate; i!.isBefore(endDate!) || i.isAtSameMomentAs(endDate!); i = i.add(const Duration(days: 1))) {
      dateList.add(DateFormat(Constant.commonDateFormatDdMmYyyy).format(i).toString());
    }
    dateList = dateList.reversed.toList();
    getDataFromDB();
  }

  getDataFromDB() {
    List<ActivityTable> dataListHive =
        Hive.box<ActivityTable>(Constant.tableActivity).values.toList();
    var dummyData = DailyLogClass();
    dummyData.isShowHeader = true;
    dailyLogDataList.add(dummyData);

    for (int j = 0; j < dateList.length; j++) {
      var data = dataListHive
          .where((element) =>
              element.date == dateList[j] &&
              element.type == Constant.typeDaysData)
          .toList();

      if (data.isNotEmpty) {

        var filterOne = filterData.where((element) => element.titleName == Constant.itemBicycling &&
            element.selected == true ).toList();
         if(filterOne.isNotEmpty){
          var displayTitleOneList = data
              .where((element) =>
          element.displayLabel == Constant.itemBicycling &&
              element.type == Constant.typeDaysData)
              .toList();
          getDateWiseActivityData(displayTitleOneList);
        }



        var filterTwo = filterData.where((element) => element.titleName == Constant.itemJogging &&
            element.selected == true ).toList();
         if(filterTwo.isNotEmpty) {
           var displayTitleTwoList = data
               .where((element) =>
           element.displayLabel == Constant.itemJogging &&
               element.type == Constant.typeDaysData)
               .toList();
           getDateWiseActivityData(displayTitleTwoList);
         }


        var filterThree = filterData.where((element) => element.titleName == Constant.itemRunning &&
            element.selected == true ).toList();
         if(filterThree.isNotEmpty) {
           var displayTitleThreeList = data
               .where((element) =>
           element.displayLabel == Constant.itemRunning &&
               element.type == Constant.typeDaysData)
               .toList();
           getDateWiseActivityData(displayTitleThreeList);
         }

        var filterFour = filterData.where((element) => element.titleName == Constant.itemSwimming &&
            element.selected == true ).toList();
         if(filterFour.isNotEmpty) {
           var displayTitleFourList = data
               .where((element) =>
           element.displayLabel == Constant.itemSwimming &&
               element.type == Constant.typeDaysData)
               .toList();
           getDateWiseActivityData(displayTitleFourList);
         }

        var filterFive = filterData.where((element) => element.titleName == Constant.itemWalking &&
            element.selected == true ).toList();
         if(filterFive.isNotEmpty) {
           var displayTitleFiveList = data
               .where((element) =>
           element.displayLabel == Constant.itemWalking &&
               element.type == Constant.typeDaysData)
               .toList();
           getDateWiseActivityData(displayTitleFiveList);
         }

        var filterSix = filterData.where((element) => element.titleName == Constant.itemWeights &&
            element.selected == true ).toList();
        if(filterSix.isNotEmpty) {
          var displayTitleSixList = data
              .where((element) =>
          element.displayLabel == Constant.itemWeights &&
              element.type == Constant.typeDaysData)
              .toList();
          getDateWiseActivityData(displayTitleSixList);
        }

        /*var filterMixed = filterData.where((element) => element.titleName == Constant.itemMixed &&
            element.selected == true ).toList();
        if(filterMixed.isNotEmpty) {
          var displayTitleMixedList = data
              .where((element) =>
          element.displayLabel == Constant.itemMixed &&
              element.type == Constant.typeDaysData)
              .toList();
          getDateWiseActivityData(displayTitleMixedList);
        }*/
      }
    }
    update();
  }

  getDateWiseActivityData(List<ActivityTable> displayTitleTwoList) async {
    if(displayTitleTwoList.isNotEmpty) {
      var displayOneDataClass = DailyLogClass();
      for (int o = 0; o < displayTitleTwoList.length; o++){

        displayOneDataClass.displayLabel = displayTitleTwoList[o].displayLabel;
        displayOneDataClass.date = displayTitleTwoList[o].date!;
        var isShowDateBool = dailyLogDataList.where((element) => element.date == displayTitleTwoList[o].date).toList();
        if(isShowDateBool.isEmpty) {
          displayOneDataClass.isShownDate = true;
        }else{
          displayOneDataClass.isShownDate = false;
        }

        displayOneDataClass.storedDate = displayTitleTwoList[o].dateTime ?? DateTime.now();
        displayOneDataClass.insertedDayDataId = displayTitleTwoList[o].insertedDayDataId ?? 0;
        displayOneDataClass.weeksDate = displayTitleTwoList[o].weeksDate ?? "0";

        if(displayTitleTwoList[o].title == null && displayTitleTwoList[o].smileyType == null){
            ///Title 1 data
            displayOneDataClass.modValueController.text =  (displayTitleTwoList[o].value1 == null) ? "" : displayTitleTwoList[o].value1!.toInt().toString();
            displayOneDataClass.vigValueController.text =  (displayTitleTwoList[o].value2 == null) ? "" : displayTitleTwoList[o].value2!.toInt().toString();
            displayOneDataClass.totalValueController.text =  (displayTitleTwoList[o].total == null) ? "" : displayTitleTwoList[o].total!.toInt().toString();

            displayOneDataClass.modValue =  displayTitleTwoList[o].value1 ?? 0;
            displayOneDataClass.vigValue =  displayTitleTwoList[o].value2 ?? 0;
            displayOneDataClass.totalValue =  displayTitleTwoList[o].total ?? 0;

            displayOneDataClass.oldModValue =  displayTitleTwoList[o].value1 ?? 0;
            displayOneDataClass.oldVigValue =  displayTitleTwoList[o].value2 ?? 0;
            displayOneDataClass.oldTotalValue =  displayTitleTwoList[o].total ?? 0;

            displayOneDataClass.activityMinKeyId = displayTitleTwoList[o].key!;
            // await Future.delayed(const Duration(milliseconds: 1000), () {
            //   displayOneDataClass.notesController.insertHtml(displayTitleTwoList[o].notes.toString());
            //   displayOneDataClass.notesController.clear();
            //   displayOneDataClass.notesController.insertHtml(displayTitleTwoList[o].notes.toString());
            //   Debug.printLog("insertHtml...${displayTitleTwoList[o].notes}");
            // });

            displayOneDataClass.notesValues =  displayTitleTwoList[o].notes.toString();
          // }

          // displayOneDataClass.smileyType =  displayTitleTwoList[o].smileyType ?? Constant.defaultSmileyType;


        }else if(displayTitleTwoList[o].title == Constant.titleDaysStr){
          ///Title 2 data
          displayOneDataClass.isCheckedDayData =  displayTitleTwoList[o].isCheckedDayData ?? false;
          displayOneDataClass.daysStrKeyId = displayTitleTwoList[o].key!;

        }else if(displayTitleTwoList[o].title == Constant.titleCalories){
          ///Title 3 data
          displayOneDataClass.caloriesValueController.text = (displayTitleTwoList[o].total == null)? "" : (displayTitleTwoList[o].total!.toInt()).toString();
          displayOneDataClass.caloriesValue =  displayTitleTwoList[o].total ?? 0;
          displayOneDataClass.oldCaloriesValue =  displayTitleTwoList[o].total ?? 0;
          displayOneDataClass.caloriesKeyId = displayTitleTwoList[o].key!;

        }else if(displayTitleTwoList[o].title == Constant.titleSteps){
          ///Title 4 data
          displayOneDataClass.stepsValueController.text =  (displayTitleTwoList[o].total == null)? "" : (displayTitleTwoList[o].total!.toInt()).toString();
          displayOneDataClass.stepsTotal =  displayTitleTwoList[o].total ?? 0;
          displayOneDataClass.oldStepsTotal =  displayTitleTwoList[o].total ?? 0;
          displayOneDataClass.stepsKeyId = displayTitleTwoList[o].key!;

        }else if(displayTitleTwoList[o].title == Constant.titleHeartRateRest){
          ///Title 5 data
          displayOneDataClass.restHeartValueController.text = (displayTitleTwoList[o].total == null)? "" : (displayTitleTwoList[o].total!.toInt()).toString();
          displayOneDataClass.restHeartValue =  displayTitleTwoList[o].total ?? 0;
          displayOneDataClass.oldRestHeartValue =  displayTitleTwoList[o].total ?? 0;
          displayOneDataClass.restHeartKeyId = displayTitleTwoList[o].key!;

        }else if(displayTitleTwoList[o].title == Constant.titleHeartRatePeak){
          ///Title 6 data
          displayOneDataClass.peakHeartValueController.text =  (displayTitleTwoList[o].total == null)? "" : (displayTitleTwoList[o].total!.toInt()).toString();
          displayOneDataClass.peakHeartValue =  displayTitleTwoList[o].total ?? 0;
          displayOneDataClass.oldPeakHeartValue =  displayTitleTwoList[o].total ?? 0;
          displayOneDataClass.peakHeartKeyId = displayTitleTwoList[o].key!;

        }else if(displayTitleTwoList[o].title == null && displayTitleTwoList[o].smileyType != null){
          ///Title 6 data
          displayOneDataClass.smileyType = displayTitleTwoList[o].smileyType ?? Constant.defaultSmileyType;
          displayOneDataClass.smileyKeyId = displayTitleTwoList[o].key;

        }
      }
      dailyLogDataList.add(displayOneDataClass);
    }
  }

  DailyLogClass selectedDateDailyLogClass = DailyLogClass();


  void setSelectedDataClass(DailyLogClass selectedDateFirstDate) async{
    selectedDateDailyLogClass = selectedDateFirstDate;
    update();
  }

  var smileyType = 1;
  void updateSmileyForBottom(int value){
    smileyType = value;
    selectedDateDailyLogClass.smileyType = value;
    update();
  }

  void onChangeEditableModBottom(value) {
    if(value == ""){
      selectedDateDailyLogClass.modValueController.text = "";
      selectedDateDailyLogClass.modValue = null;
      selectedDateDailyLogClass.modValueController.selection =
          TextSelection.fromPosition(const TextPosition(offset: 0));
    }else {
      selectedDateDailyLogClass.modValueController.text = value.toString();
      selectedDateDailyLogClass.modValue = double.parse(value);
      selectedDateDailyLogClass.modValueController.selection =
          TextSelection.fromPosition(TextPosition(offset: value.length));
    }
    update();
  }

  void onChangeEditableVigBottom(value) {
    if(value == ""){
      selectedDateDailyLogClass.vigValueController.text = "";
      selectedDateDailyLogClass.vigValue = null;
      selectedDateDailyLogClass.vigValueController.selection =
          TextSelection.fromPosition(const TextPosition(offset: 0));
    }else {
      selectedDateDailyLogClass.vigValueController.text = value.toString();
      selectedDateDailyLogClass.vigValue = double.parse(value);
      selectedDateDailyLogClass.vigValueController.selection =
          TextSelection.fromPosition(TextPosition(offset: value.length));
    }
    update();
  }

  void onChangeEditableTotalMinBottom(value) {
    if(value == ""){
      selectedDateDailyLogClass.totalValueController.text = "";
      selectedDateDailyLogClass.totalValue = null;
      selectedDateDailyLogClass.totalValueController.selection =
          TextSelection.fromPosition(const TextPosition(offset: 0));
    }else {
      selectedDateDailyLogClass.totalValueController.text = value.toString();
      selectedDateDailyLogClass.totalValue = double.parse(value);
      selectedDateDailyLogClass.totalValueController.selection =
          TextSelection.fromPosition(TextPosition(offset: value.length));
    }
    update();
  }

  void onChangeEditableCaloriesBottom(value) {
    if(value == ""){
      selectedDateDailyLogClass.caloriesValueController.text = "";
      selectedDateDailyLogClass.caloriesValue = null;
      selectedDateDailyLogClass.caloriesValueController.selection =
          TextSelection.fromPosition(const TextPosition(offset: 0));

    }else {
      selectedDateDailyLogClass.caloriesValueController.text = value.toString();
      selectedDateDailyLogClass.caloriesValue = double.parse(value);
      selectedDateDailyLogClass.caloriesValueController.selection =
          TextSelection.fromPosition(TextPosition(offset: value.length));
    }
    update();
  }

  void onChangeEditableStepsBottom(value) {
    if(value == ""){
      selectedDateDailyLogClass.stepsValueController.text = "";
      selectedDateDailyLogClass.stepsTotal = null;
      selectedDateDailyLogClass.stepsValueController.selection =
          TextSelection.fromPosition(const TextPosition(offset: 0));
    }else {
      selectedDateDailyLogClass.stepsValueController.text = value.toString();
      selectedDateDailyLogClass.stepsTotal = double.parse(value);
      selectedDateDailyLogClass.stepsValueController.selection =
          TextSelection.fromPosition(TextPosition(offset: value.length));
    }
    update();
  }

  var bottomIsCheckedDayData = false;
  onChangeCheckBoxValueBottom(bool value){
    bottomIsCheckedDayData = value;
    selectedDateDailyLogClass.isCheckedDayData = !selectedDateDailyLogClass.isCheckedDayData;
    update();

  }

  void onChangeEditableRestHeartBottom(value) {
    if(value == ""){
      selectedDateDailyLogClass.restHeartValueController.text = "";
      selectedDateDailyLogClass.restHeartValue = null;
      selectedDateDailyLogClass.restHeartValueController.selection =
          TextSelection.fromPosition(const TextPosition(offset: 0));
    }else {
      selectedDateDailyLogClass.restHeartValueController.text = value.toString();
      selectedDateDailyLogClass.restHeartValue = double.parse(value);
      selectedDateDailyLogClass.restHeartValueController.selection =
          TextSelection.fromPosition(TextPosition(offset: value.length));
    }
    update();
  }

  void onChangeEditablePeakHeartBottom(value) {
    if(value == ""){
      selectedDateDailyLogClass.peakHeartValueController.text = "";
      selectedDateDailyLogClass.peakHeartValue = null;
      selectedDateDailyLogClass.peakHeartValueController.selection =
          TextSelection.fromPosition(const TextPosition(offset: 0));
    }else {
      selectedDateDailyLogClass.peakHeartValueController.text = value.toString();
      selectedDateDailyLogClass.peakHeartValue = double.parse(value);
      selectedDateDailyLogClass.peakHeartValueController.selection =
          TextSelection.fromPosition(TextPosition(offset: value.length));
    }
    update();
  }

  void changeExDropDown(String labelName, DateTime date,{bool isGetData = true,String iconPath = ""}) {
    var lastTitle = Constant.configurationInfo.where((element) => element.isEnabled).toList();
    if(lastTitle.isEmpty || labelName == ""){
      selectedDateDailyLogClass.displayLabel = lastTitle[0].title;
    }else{
      selectedDateDailyLogClass.displayLabel = labelName;
    }
    if(isGetData) {
      var dateStr = DateFormat(Constant.commonDateFormatDdMmYyyy).format(date);
      getDaysDataWise(selectedDateDailyLogClass.displayLabel.toString(), dateStr,date,iconPath: iconPath);
    }
    update();
  }

  /*getDaysDataWise(String labelName, String date,DateTime dateTime,{String iconPath = ""}){
    List<ActivityTable> dataListHive =
    Hive.box<ActivityTable>(Constant.tableActivity).values.toList();

    var dbDataList = dataListHive.where((element) => element.date == date &&
    element.displayLabel == labelName && element.type == Constant.typeDaysData).toList();

    // var dbDataList = dataListHive.where((element) => element.activityStartDate == activityStartDate &&
    //     element.activityEndDate == activityEndDate &&
    //     element.displayLabel == labelName && element.type == Constant.typeDaysData).toList();

    if(dbDataList.isNotEmpty) {
      selectedDateDailyLogClass = DailyLogClass();
      selectedDateDailyLogClass.iconPath = iconPath;
      for (int o = 0; o < dbDataList.length; o++){

        var now = DateTime.now();
        selectedDateDailyLogClass.activityEndDate =
            dbDataList[o].activityEndDate ??
                DateTime(dateTime.year, dateTime.month, dateTime.day, now.hour,
                    now.minute);
        if(dbDataList[o].activityEndDate == null){
          selectedDateDailyLogClass.isChangedEndTime = false;
        }else{
          selectedDateDailyLogClass.isChangedEndTime = true;
        }

        selectedDateDailyLogClass.activityStartDate =
            dbDataList[o].activityStartDate ??
                DateTime(dateTime.year, dateTime.month, dateTime.day, now.hour,
                    now.minute);

        selectedDateDailyLogClass.activityStartDateLast =
            dbDataList[o].activityStartDate ??
                DateTime(dateTime.year, dateTime.month, dateTime.day, now.hour,
                    now.minute);
        selectedDateDailyLogClass.activityEndDateLast =
            dbDataList[o].activityEndDate ??
                DateTime(dateTime.year, dateTime.month, dateTime.day, now.hour,
                    now.minute);

        selectedDateDailyLogClass.displayLabel = dbDataList[o].displayLabel;
        selectedDateDailyLogClass.date = dbDataList[o].date!;
        var isShowDateBool = dailyLogDataList.where((element) => element.date == dbDataList[o].date).toList();
        if(isShowDateBool.isEmpty) {
          selectedDateDailyLogClass.isShownDate = true;
        }else{
          selectedDateDailyLogClass.isShownDate = false;
        }

        selectedDateDailyLogClass.storedDate = dbDataList[o].dateTime ?? DateTime.now();
        selectedDateDailyLogClass.insertedDayDataId = dbDataList[o].insertedDayDataId ?? 0;
        selectedDateDailyLogClass.weeksDate = dbDataList[o].weeksDate ?? "0";
        // selectedDateDailyLogClass.userId = dbDataList[o].patientId ?? "0";

        if(dbDataList[o].title == null && dbDataList[o].smileyType == null){
          ///Title 1 data
          selectedDateDailyLogClass.modValueController.text =  (dbDataList[o].value1 == null) ? "0" : dbDataList[o].value1!.toInt().toString();
          selectedDateDailyLogClass.vigValueController.text =  (dbDataList[o].value2 == null) ? "0" : dbDataList[o].value2!.toInt().toString();
          selectedDateDailyLogClass.totalValueController.text =  (dbDataList[o].total == null) ? "0" : dbDataList[o].total!.toInt().toString();

          selectedDateDailyLogClass.modValue =  dbDataList[o].value1 ?? 0;
          selectedDateDailyLogClass.vigValue =  dbDataList[o].value2 ?? 0;
          selectedDateDailyLogClass.totalValue =  dbDataList[o].total ?? 0;

          selectedDateDailyLogClass.oldModValue =  dbDataList[o].value1 ?? 0;
          selectedDateDailyLogClass.oldVigValue =  dbDataList[o].value2 ?? 0;
          selectedDateDailyLogClass.oldTotalValue =  dbDataList[o].total ?? 0;

          // selectedDateDailyLogClass.smileyType =  dbDataList[o].smileyType ?? Constant.defaultSmileyType;
          selectedDateDailyLogClass.notesValues =  dbDataList[o].notes ?? "";
          selectedDateDailyLogClass.notesController.text =  dbDataList[o].notes ?? "";

          selectedDateDailyLogClass.activityMinKeyId = dbDataList[o].key!;

        }else if(dbDataList[o].title == Constant.titleDaysStr){
          ///Title 2 data
          selectedDateDailyLogClass.isCheckedDayData =  dbDataList[o].isCheckedDayData ?? false;
          selectedDateDailyLogClass.daysStrKeyId = dbDataList[o].key!;

        }else if(dbDataList[o].title == Constant.titleCalories){
          ///Title 3 data
          selectedDateDailyLogClass.caloriesValueController.text = (dbDataList[o].total == null)? "0" : (dbDataList[o].total!.toInt()).toString();
          selectedDateDailyLogClass.caloriesValue =  dbDataList[o].total ?? 0;
          selectedDateDailyLogClass.oldCaloriesValue =  dbDataList[o].total ?? 0;
          selectedDateDailyLogClass.caloriesKeyId = dbDataList[o].key!;

        }else if(dbDataList[o].title == Constant.titleSteps){
          ///Title 4 data
          selectedDateDailyLogClass.stepsValueController.text =  (dbDataList[o].total == null)? "0" : (dbDataList[o].total!.toInt()).toString();
          selectedDateDailyLogClass.stepsTotal =  dbDataList[o].total ?? 0;
          selectedDateDailyLogClass.oldStepsTotal =  dbDataList[o].total ?? 0;
          selectedDateDailyLogClass.stepsKeyId = dbDataList[o].key!;

        }else if(dbDataList[o].title == Constant.titleHeartRateRest){
          ///Title 5 data
          selectedDateDailyLogClass.restHeartValueController.text = (dbDataList[o].total == null)? "0" : (dbDataList[o].total!.toInt()).toString();
          selectedDateDailyLogClass.restHeartValue =  dbDataList[o].total ?? 0;
          selectedDateDailyLogClass.oldRestHeartValue =  dbDataList[o].total ?? 0;
          selectedDateDailyLogClass.restHeartKeyId = dbDataList[o].key!;

        }else if(dbDataList[o].title == Constant.titleHeartRatePeak){
          ///Title 6 data
          selectedDateDailyLogClass.peakHeartValueController.text =  (dbDataList[o].total == null)? "0" : (dbDataList[o].total!.toInt()).toString();
          selectedDateDailyLogClass.peakHeartValue =  dbDataList[o].total ?? 0;
          selectedDateDailyLogClass.oldPeakHeartValue =  dbDataList[o].total ?? 0;
          selectedDateDailyLogClass.peakHeartKeyId = dbDataList[o].key!;

        }else if(dbDataList[o].title == null && dbDataList[o].smileyType != null){
          selectedDateDailyLogClass.smileyType = dbDataList[o].smileyType ?? Constant.defaultSmileyType;
          selectedDateDailyLogClass.smileyKeyId = dbDataList[o].key;
        }
      }
    }
    else{
      selectedDateDailyLogClass = DailyLogClass();
      selectedDateDailyLogClass.displayLabel = labelName;
      selectedDateDailyLogClass.iconPath = iconPath;
      var now = DateTime.now();
      selectedDateDailyLogClass.activityStartDate = DateTime(dateTime.year,dateTime.month,dateTime.day,
          now.hour,now.minute);
      // activityEndDate = null;
      selectedDateDailyLogClass.activityEndDate = DateTime(dateTime.year,dateTime.month,dateTime.day,
          now.hour,now.minute);

      selectedDateDailyLogClass.activityStartDateLast = DateTime(dateTime.year,dateTime.month,dateTime.day,
          now.hour,now.minute);
      selectedDateDailyLogClass.activityEndDateLast = DateTime(dateTime.year,dateTime.month,dateTime.day,
          now.hour,now.minute);
    }
    update();
  }*/

  getDaysDataWise(String labelName, String date,DateTime dateTime,{String iconPath = ""}){
    selectedDateDailyLogClass = DailyLogClass();
    selectedDateDailyLogClass.displayLabel = labelName;
    selectedDateDailyLogClass.iconPath = iconPath;
    var now = DateTime.now();
    selectedDateDailyLogClass.activityStartDate = DateTime(dateTime.year,dateTime.month,dateTime.day,
        now.hour,now.minute);
    selectedDateDailyLogClass.activityEndDate = DateTime(dateTime.year,dateTime.month,dateTime.day,
        now.hour,now.minute);

    selectedDateDailyLogClass.activityStartDateLast = DateTime(dateTime.year,dateTime.month,dateTime.day,
        now.hour,now.minute);
    selectedDateDailyLogClass.activityEndDateLast = DateTime(dateTime.year,dateTime.month,dateTime.day,
        now.hour,now.minute);
    update();
  }

  Future<void> onChangeMonth(bool value) async {
    await getPreferenceActivityData();
    Debug.printLog("onChangeMonth.......${Constant.isMonth}");
    update();
  }

/*
  Future<void> onChangeEditableTextValueNotesBottom(value) async {
    if(value == ""){
      // selectedDateDailyLogClass.notesController.insertHtml("");
      selectedDateDailyLogClass.notesController.clear();
      // selectedDateDailyLogClass.notesController.insertHtml("");
      // selectedDateDailyLogClass.notesController.text = "";
      selectedDateDailyLogClass.notesValues = "";
      // selectedDateDailyLogClass.notesController.selection =
      //     TextSelection.fromPosition(const TextPosition(offset: 0));
    }else {
    */
/*  await Future.delayed(const Duration(milliseconds: 500), () {
        // selectedDateDailyLogClass.notesController.insertHtml(value.toString());
        // selectedDateDailyLogClass.notesController.clear();
        // selectedDateDailyLogClass.notesController.insertHtml(value.toString());
        Debug.printLog("insertHtml...${value.notes}");
      });*//*


      selectedDateDailyLogClass.notesValues = value;
      // selectedDateDailyLogClass.notesController.selection =
      //     TextSelection.fromPosition(TextPosition(offset: value.length));
    }
    update();
  }
*/


  List<ToDoDataListModel> toDoDataList = [];
  List<ServerModelJson> serverUrlDataList = [];
  RefreshController refreshController = RefreshController(initialRefresh: false);
  bool isTodoLoading = false;

  getToDoDataList() {
    // serverUrlDataList = Utils.getServerListPreference();
    serverUrlDataList = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();

    /*toDoDataList = Hive.box<ToDoTableData>(Constant.tableToDoList).values.toList()
        .where((element) => element.patientId == Utils.getPatientId()).toList();
    update();*/
  }

  /*getToDoDataListApi() async {
    if(serverUrlDataList.isNotEmpty){
      for(int j=0;j<serverUrlDataList.length;j++) {
        var listData = await PaaProfiles.getTaskDataList(
            Utils.getPatientId(), false,serverUrlDataList[j]);
        if (listData.resourceType == R4ResourceType.Bundle) {
          if (listData != null && listData.entry != null) {
            for (int i = 0; i < listData.entry.length; i++) {
              var data = listData.entry[i];
              if (data.resource.resourceType == R4ResourceType.Task) {
                var id;
                if (data.resource.id != null) {
                  id = data.resource.id.toString();
                }
                var statusReason;
                if (data.resource.statusReason != null) {
                  statusReason = Utils.capitalizeFirstLetter(
                      data.resource.statusReason.text.toString());
                }
                var businessStatusReason = "";
                if (data.resource.businessStatus != null) {
                  businessStatusReason = Utils.capitalizeFirstLetter(
                      data.resource.businessStatus.text.toString());
                }
                var status = Utils.capitalizeFirstLetter(
                    data.resource.status.toString());
                ToDoTableData toDoListData = ToDoTableData();

                if (data.resource.code != null) {
                  if (data.resource.code.coding != null) {
                    if (data.resource.code.coding[0].code != null &&
                        data.resource.code.coding[0].display != null) {
                      var code = data.resource.code.coding[0].code;
                      var display = data.resource.code.coding[0].display;
                      toDoListData.code = code.toString();
                      toDoListData.display = display.toString();

                      var referralTypeCodeDataModel =
                      CodeToDoModel(display: toDoListData.display ?? "",
                          code: toDoListData.code);
                      if (Utils.codeTodoList.where((element) =>
                      element.code != toDoListData.code &&
                          element.display != toDoListData.display)
                          .toList()
                          .isEmpty) {
                        if (!Utils.codeTodoList.contains(
                            referralTypeCodeDataModel)) {
                          Utils.codeTodoList.add(referralTypeCodeDataModel);
                        }
                      }
                    }
                    else if (data.resource.code.coding[0].display != null) {
                      toDoListData.display = data.resource.code.coding[0].display;

                      var referralTypeCodeDataModel =
                      CodeToDoModel(display: toDoListData.display ?? "");

                      if (Utils.codeTodoList
                          .where((element) =>
                      element.display == toDoListData.display)
                          .toList()
                          .isEmpty) {
                        Utils.codeTodoList.add(referralTypeCodeDataModel);
                      }
                    }
                  }
                }

                var tagReviewed = "";
                if (data.resource.reasonCode != null) {
                  tagReviewed = data.resource.reasonCode.text.toString();
                  toDoListData.tag = tagReviewed;
                }

                if (data.resource.authoredOn != null) {
                  toDoListData.createdDate = data.resource.authoredOn.valueDateTime;
                } else {
                  toDoListData.createdDate = DateTime.now();
                }
                if(data.resource.lastModified != null) {
                  toDoListData.lastUpdatedDate =
                      data.resource.lastModified.valueDateTime;
                }else{
                  toDoListData.lastUpdatedDate = DateTime.now();
                }

                toDoListData.statusReason = statusReason;
                toDoListData.businessStatus = businessStatusReason;
                toDoListData.qrUrl = serverUrlDataList[j].url;
                toDoListData.token = serverUrlDataList[j].authToken;
                toDoListData.clientId = serverUrlDataList[j].clientId;
                toDoListData.patientId = serverUrlDataList[j].patientId;
                toDoListData.patientName =
                "${serverUrlDataList[j].patientFName} ${serverUrlDataList[j]
                    .patientLName}";

                toDoListData.objectId = id;
                toDoListData.priority =
                    Utils.capitalizeFirstLetter(
                        data.resource.priority.toString());
                toDoListData.patientId = Utils.getPatientId();
                toDoListData.status = status;

                if(data.resource.for_ != null){
                  toDoListData.forReference = data.resource.for_.reference.toString();
                  toDoListData.forDisplay = data.resource.for_.display.toString();
                }

                if(data.resource.requester != null){
                  toDoListData.requesterReference = data.resource.requester.reference.toString();
                  toDoListData.requesterDisplay = data.resource.requester.display.toString();
                }
                if(data.resource.owner != null){
                  toDoListData.ownerReference = data.resource.owner.reference.toString();
                  toDoListData.ownerDisplay = data.resource.owner.display.toString();
                }
                if (data.resource.authoredOn != null) {
                  toDoListData.createdDate = data.resource.authoredOn.valueDateTime;
                } else {
                  toDoListData.createdDate = DateTime.now();
                }
                if(data.resource.lastModified != null) {
                  toDoListData.lastUpdatedDate =
                      data.resource.lastModified.valueDateTime;
                }else{
                  toDoListData.lastUpdatedDate = DateTime.now();
                }


                var insertedIdTaskId = 0;

                if (toDoDataList
                    .where((element) =>
                element.objectId == id &&
                    element.qrUrl == serverUrlDataList[j].url)
                    .toList()
                    .isEmpty) {
                  insertedIdTaskId = await DataBaseHelper.shared.insertToDoData(toDoListData);
                } else {
                  var data = toDoDataList.where((element) =>
                  element.objectId == id)
                      .toList()[0];
                  insertedIdTaskId = data.key;
                  data.statusReason = toDoListData.statusReason;
                  data.businessStatus = toDoListData.businessStatus;
                  data.code = toDoListData.code;
                  data.display = toDoListData.display;
                  data.status = toDoListData.status;
                  data.priority = Utils.capitalizeFirstLetter(toDoListData.priority.toString());
                  data.patientId = Utils.getPatientId();
                  data.tag = toDoListData.tag;
                  data.createdDate = toDoListData.createdDate;
                  data.lastUpdatedDate = toDoListData.lastUpdatedDate;
                  await DataBaseHelper.shared.updateToDoData(data);
                  var noteDataList = Hive
                      .box<NoteTableData>(Constant.tableNoteData)
                      .values
                      .toList().where((element) => element.TaskId == insertedIdTaskId).toList();
                  if(noteDataList.isNotEmpty){
                    for(int o=0; o < noteDataList.length;o++){
                      await DataBaseHelper.shared.deleteSingleNoteData(noteDataList[o].key);
                    }
                  }
                }
                if(data.resource.note != null) {
                  var notesList = data.resource.note;
                  for (int i = 0; i < notesList.length; i++) {
                    var noteTableData = NoteTableData();
                    noteTableData.notes = notesList[i].text.toString();
                    if(notesList[i].authorReference !=  null){
                      noteTableData.author = notesList[i].authorReference.display;
                    }
                    noteTableData.readOnly = false;
                    try{
                      var date = Utils.getSplitDateFromAPIData(
                          notesList[i].time.toString());
                      noteTableData.date =
                          DateTime(date.year, date.month, date.day);
                    }catch(e){
                      Debug.printLog("Error Date issue!!");
                    }
                    noteTableData.isDelete = true;
                    noteTableData.TaskId = insertedIdTaskId;
                    await DataBaseHelper.shared.insertNoteData(noteTableData);
                  }
                }
              }
            }
          }
        }
      }
    }
    getToDoDataList();
    update();
  }*/


  getToDoDataListApi() async {
    if(serverUrlDataList.isNotEmpty){
      toDoDataList.clear();
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   Utils.showDialogForProgress(
      //       Get.context!, Constant.txtPleaseWait,
      //       Constant.txtToDoDataProgress);
      // });
      for(int j=0;j<serverUrlDataList.length;j++) {
        var listData = await PaaProfiles.getTaskDataList(
            serverUrlDataList[j].patientId, false,serverUrlDataList[j]);
        if (listData.resourceType == R4ResourceType.Bundle) {
          if (listData != null && listData.entry != null) {
            for (int i = 0; i < listData.entry.length; i++) {
              var data = listData.entry[i];
              if (data.resource.resourceType == R4ResourceType.Task) {
                var id;
                if (data.resource.id != null) {
                  id = data.resource.id.toString();
                }
                var statusReason;
                if (data.resource.statusReason != null) {
                  statusReason = Utils.capitalizeFirstLetter(
                      data.resource.statusReason.text.toString());
                }

                var generalText =  "";
                var chosenText =  "";
                var compareOutput = "";
                if (data.resource.output != null) {
                  if (data.resource.output[0] != null) {
                    if(data.resource.output[0].type != null){
                      if(data.resource.output[0].type.coding != null){
                        if(data.resource.output[0].type.coding[0] != null){
                          if(data.resource.output[0].type.coding[0].display != null){
                            compareOutput =  data.resource.output[0].type.coding[0].display.toString();
                            Debug.printLog("compareOutput.......$compareOutput");
                          }
                        }
                      }
                    }
                    if (data.resource.output[0].valueMarkdown != null) {
                      if (data.resource.output[0].valueMarkdown.value != null) {
                        if(compareOutput.toLowerCase() == "Chosen Contact".toLowerCase()){
                          chosenText  = data.resource.output[0].valueMarkdown.value.toString();
                          Debug.printLog("generalText.......$chosenText");
                        }else if( compareOutput.toLowerCase() == "General Information Response".toLowerCase()){
                          generalText = data.resource.output[0].valueMarkdown.value.toString();
                          Debug.printLog("chosenText.......$generalText");
                        }
                      }
                    }
                  }
                }

                var description = "";
                if(data.resource.description != null){
                  description = data.resource.description.toString();
                }
                var perfomerId = "";
                var perfomerName = "";
                if(data.resource.input != null){
                  if(data.resource.input[0] != null){
                    if(data.resource.input[0].valueReference != null){
                      if(data.resource.input[0].valueReference != null){
                        if(data.resource.input[0].valueReference.display != null){
                          perfomerName =  data.resource.input[0].valueReference.display.toString();
                        }
                      }
                      if(data.resource.input[0].valueReference.reference.toString().split(
                          "Practitioner/")[1].toString() != "null"){
                        perfomerId = data.resource.input[0].valueReference.reference.toString().split(
                            "Practitioner/")[1].toString();
                      }
                    }
                  }
                }

                var url = "";
                var title = "";
                if(data.resource.contained != null){
                  if(data.resource.contained[0] != null){
                    if(data.resource.contained[0].content != null){
                      if(data.resource.contained[0].content[0] != null){
                        if(data.resource.contained[0].content[0].attachment != null){
                          if(data.resource.contained[0].content[0].attachment.url != null){
                            try{
                              url = data.resource.contained[0].content[0].attachment.url.value.toString();
                            }catch(e){
                              url = "";
                            }
                          }
                          if(data.resource.contained[0].content[0].attachment.title != null){
                            try{
                              title =data.resource.contained[0].content[0].attachment.title.toString();
                            }catch(e){
                              title = "";
                            }
                          }
                        }
                      }
                    }
                  }
                }

                var businessStatusReason = "";
                if (data.resource.businessStatus != null) {
                  businessStatusReason = Utils.capitalizeFirstLetter(
                      data.resource.businessStatus.text.toString());
                }
                var status = Utils.capitalizeFirstLetter(
                    data.resource.status.toString());
                ToDoDataListModel toDoListData = ToDoDataListModel();

                if (data.resource.code != null) {
                  if (data.resource.code.coding != null) {
                    if (data.resource.code.coding[0].code != null &&
                        data.resource.code.coding[0].display != null) {
                      var code = data.resource.code.coding[0].code;
                      var display = data.resource.code.coding[0].display;
                      toDoListData.code = code.toString();
                      toDoListData.display = display.toString();

                      var referralTypeCodeDataModel =
                      CodeToDoModel(display: toDoListData.display ?? "",
                          code: toDoListData.code);
                      if (Utils.codeTodoList.where((element) =>
                      element.code != toDoListData.code &&
                          element.display != toDoListData.display)
                          .toList()
                          .isEmpty) {
                        if (!Utils.codeTodoList.contains(
                            referralTypeCodeDataModel)) {
                          Utils.codeTodoList.add(referralTypeCodeDataModel);
                        }
                      }
                    }
                    else if (data.resource.code.coding[0].display != null) {
                      toDoListData.display = data.resource.code.coding[0].display;

                      var referralTypeCodeDataModel =
                      CodeToDoModel(display: toDoListData.display ?? "");

                      if (Utils.codeTodoList
                          .where((element) =>
                      element.display == toDoListData.display)
                          .toList()
                          .isEmpty) {
                        Utils.codeTodoList.add(referralTypeCodeDataModel);
                      }
                    }
                  }
                }

                var tagReviewed = "";
                if (data.resource.reasonCode != null) {
                  tagReviewed = data.resource.reasonCode.text.toString();
                  toDoListData.tag = tagReviewed;
                }

                if (data.resource.authoredOn != null) {
                  toDoListData.createdDate = data.resource.authoredOn.valueDateTime;
                } else {
                  toDoListData.createdDate = DateTime.now();
                }
                if(data.resource.lastModified != null) {
                  toDoListData.lastUpdatedDate =
                      data.resource.lastModified.valueDateTime;
                }else{
                  toDoListData.lastUpdatedDate = DateTime.now();
                }

                toDoListData.statusReason = statusReason;
                toDoListData.businessStatus = businessStatusReason;
                toDoListData.qrUrl = serverUrlDataList[j].url;
                toDoListData.token = serverUrlDataList[j].authToken;
                toDoListData.clientId = serverUrlDataList[j].clientId;
                toDoListData.patientId = serverUrlDataList[j].patientId;
                toDoListData.patientName =
                "${serverUrlDataList[j].patientFName} ${serverUrlDataList[j]
                    .patientLName}";

                toDoListData.objectId = id;
                toDoListData.priority =
                    Utils.capitalizeFirstLetter(
                        data.resource.priority.toString());
                toDoListData.patientId = Utils.getPatientId();
                toDoListData.status = status;
                toDoListData.chosenContactText = chosenText;
                toDoListData.generalResponseText = generalText;

                toDoListData.performerId = perfomerId;
                toDoListData.performerName = perfomerName;
                if(toDoListData.display == Constant.toDoCodeDisplayMakeContact){
                  toDoListData.makeContactDescription = description;
                }else{
                  toDoListData.generalDescription = description;
                }
                toDoListData.reviewMaterialURL = url;
                toDoListData.reviewMaterialTitle = title;

                if (data.resource.for_.reference != null) {
                  toDoListData.forReference = data.resource.for_.reference.toString();
                  toDoListData.forDisplay = data.resource.for_.display.toString();
                }

                if (data.resource.requester.reference != null) {
                  toDoListData.requesterReference = data.resource.requester.reference.toString();
                  toDoListData.requesterDisplay = data.resource.requester.display.toString();
                }
                if (data.resource.focus != null) {
                  if (data.resource.focus.reference != null) {
                    var focus = data.resource.focus.reference.toString();
                    toDoListData.focusReference = focus;
                  }
                }
                if (data.resource.owner.reference != null) {
                  toDoListData.ownerReference = data.resource.owner.reference.toString();
                  toDoListData.ownerDisplay = data.resource.owner.display.toString();
                }
                if (data.resource.authoredOn != null) {
                  toDoListData.createdDate = data.resource.authoredOn.valueDateTime;
                } else {
                  toDoListData.createdDate = DateTime.now();
                }
                if(data.resource.lastModified != null) {
                  toDoListData.lastUpdatedDate =
                      data.resource.lastModified.valueDateTime;
                }else{
                  toDoListData.lastUpdatedDate = DateTime.now();
                }


                /* var insertedIdTaskId = 0;

                if (toDoDataList
                    .where((element) =>
                element.objectId == id &&
                    element.qrUrl == serverUrlDataList[j].url)
                    .toList()
                    .isEmpty) {
                  insertedIdTaskId = await DataBaseHelper.shared.insertToDoData(toDoListData);
                } else {
                  var data = toDoDataList.where((element) =>
                  element.objectId == id)
                      .toList()[0];
                  insertedIdTaskId = data.key;
                  data.statusReason = toDoListData.statusReason;
                  data.businessStatus = toDoListData.businessStatus;
                  data.code = toDoListData.code;
                  data.display = toDoListData.display;
                  data.status = toDoListData.status;
                  data.priority = Utils.capitalizeFirstLetter(toDoListData.priority.toString());
                  data.patientId = Utils.getPatientId();
                  data.tag = toDoListData.tag;
                  data.createdDate = toDoListData.createdDate;
                  data.lastUpdatedDate = toDoListData.lastUpdatedDate;
                  await DataBaseHelper.shared.updateToDoData(data);
                  var noteDataList = Hive
                      .box<NoteTableData>(Constant.tableNoteData)
                      .values
                      .toList().where((element) => element.TaskId == insertedIdTaskId).toList();
                  if(noteDataList.isNotEmpty){
                    for(int o=0; o < noteDataList.length;o++){
                      await DataBaseHelper.shared.deleteSingleNoteData(noteDataList[o].key);
                    }
                  }
                }*/
                if(data.resource.note != null) {
                  var notesList = data.resource.note;
                  for (int i = 0; i < notesList.length; i++) {
                    var noteTableData = NoteTableData();
                    noteTableData.notes = notesList[i].text.toString();
                    if(notesList[i].authorReference !=  null){
                      noteTableData.author = notesList[i].authorReference.display;
                    }
                    noteTableData.readOnly = false;
                    var date = Utils.getSplitDateFromAPIData(
                        notesList[i].time.toString());
                    noteTableData.date =
                        DateTime(date.year, date.month, date.day);
                    noteTableData.isDelete = true;
                    Debug.printLog("otesList[i].authorReference....${notesList[i].authorReference.toString()}  ${notesList[i].authorReference.toString().contains("Patient")}    ${notesList[i].authorReference.display}");
                    noteTableData.isCreatedNote = notesList[i].authorReference.toString().contains("Patient");
                    toDoListData.noteList.add(noteTableData);
                    // noteTableData.TaskId = insertedIdTaskId;
                    // await DataBaseHelper.shared.insertNoteData(noteTableData);
                  }
                }
                if(status != Constant.statusDraft) {
                  toDoDataList.add(toDoListData);
                }
                // var lastUpdateDate = DateTime.parse(data.resource.meta.lastUpdated.toString());
              }
            }
          }
        }

        if(toDoDataList.isNotEmpty){
          toDoDataList = toDoDataList.where((element) => element.status != Constant.toDoStatusCompleted && element.status != Constant.toDoStatusCancelled).toList();
        }
      }
      // if (toDoDataList.isEmpty) {
      // Get.back();
      // }
    }
    // getToDoDataList();
    update();
  }


  void onRefresh() async{
    await callToDoAPI(true);
    refreshController.refreshCompleted();
    Debug.printLog("Complete Api Call.......");
    update();
  }

  void onLoading() async{
    await Future.delayed(const Duration(milliseconds: 1000));
    refreshController.loadComplete();
  }

  ///Daliy Data Info
  DailyLogClass selectedDateDailyLogDayClass = DailyLogClass();

  void onDayChangedDatePicker(DateRangePickerSelectionChangedArgs args) {
    Debug.printLog("onSelectionChangedDatePicker....${args.value}");
    selectedNewDateDaliy = args.value;
    endDate = selectedNewDateDaliy;
    startDate = selectedNewDateDaliy.subtract(const Duration(days: 29));
    generateDateDayList();
    update();

  }

  void generateDateDayList() {
    dailyLogDataListDay.clear();
    dateList.clear();
    for (var i = startDate; i!.isBefore(endDate!) || i.isAtSameMomentAs(endDate!); i = i.add(const Duration(days: 1))) {
      dateList.add(DateFormat(Constant.commonDateFormatDdMmYyyy).format(i).toString());
    }
    dateList = dateList.reversed.toList();
    getDataFromDayDB();
  }

  getDataFromDayDB() {
    List<ActivityTable> dataListHive =
    Hive.box<ActivityTable>(Constant.tableActivity).values.toList();
    var dummyData = DailyLogClass();
    dummyData.isShowHeader = true;
    dailyLogDataListDay.add(dummyData);

   /* for (int j = 0; j < dateList.length; j++) {
      var data = dataListHive
          .where((element) =>
      element.date == dateList[j] &&
          element.type == Constant.typeDay)
          .toList();

      if (data.isNotEmpty) {
        var displayTitleOneList = data
            .where((element) =>
        element.type == Constant.typeDay)
            .toList();
        getDateWiseDataDay(displayTitleOneList);
      }
    }*/
    var data = dataListHive
        .where((element) =>
    element.date == DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDateDaliy).toString() &&
        element.type == Constant.typeDay)
        .toList();

    if (data.isNotEmpty) {
      var displayTitleOneList = data
          .where((element) =>
      element.type == Constant.typeDay)
          .toList();
      getDateWiseDataDay(displayTitleOneList);
    }
    if(dailyLogDataListDay.length == 1){
      selectedDateDailyLogDayClass = DailyLogClass();
    }
    Debug.printLog("logDataList.....$dailyLogDataListDay");
    update();
  }

  getDateWiseDataDay(List<ActivityTable> displayTitleTwoList){
    if(displayTitleTwoList.isNotEmpty) {
      selectedDateDailyLogDayClass = DailyLogClass();
      for (int o = 0; o < displayTitleTwoList.length; o++){

        selectedDateDailyLogDayClass.displayLabel = displayTitleTwoList[o].displayLabel;
        selectedDateDailyLogDayClass.date = displayTitleTwoList[o].date!;
        var isShowDateBool = dailyLogDataListDay.where((element) => element.date == displayTitleTwoList[o].date).toList();
        if(isShowDateBool.isEmpty) {
          selectedDateDailyLogDayClass.isShownDate = true;
        }else{
          selectedDateDailyLogDayClass.isShownDate = false;
        }

        selectedDateDailyLogDayClass.storedDate = displayTitleTwoList[o].dateTime ?? DateTime.now();
        selectedDateDailyLogDayClass.insertedDayDataId = displayTitleTwoList[o].insertedDayDataId ?? 0;
        selectedDateDailyLogDayClass.weeksDate = displayTitleTwoList[o].weeksDate ?? "0";
        // displayOneDataClassDay.userId = displayTitleTwoList[o].patientId ?? "0";

        if(displayTitleTwoList[o].title == null && displayTitleTwoList[o].smileyType == null){
          ///Title 1 data And Notes
          selectedDateDailyLogDayClass.modValueController.text =  (displayTitleTwoList[o].value1 == null) ? "" : displayTitleTwoList[o].value1!.toInt().toString();
          selectedDateDailyLogDayClass.vigValueController.text =  (displayTitleTwoList[o].value2 == null) ? "" : displayTitleTwoList[o].value2!.toInt().toString();
          selectedDateDailyLogDayClass.totalValueController.text =  (displayTitleTwoList[o].total == null) ? "" : displayTitleTwoList[o].total!.toInt().toString();

          selectedDateDailyLogDayClass.modValue =  displayTitleTwoList[o].value1 ?? 0;
          selectedDateDailyLogDayClass.vigValue =  displayTitleTwoList[o].value2 ?? 0;
          selectedDateDailyLogDayClass.totalValue =  displayTitleTwoList[o].total ?? 0;
          selectedDateDailyLogDayClass.activityMinKeyId = displayTitleTwoList[o].key!;
          // selectedDateDailyLogDayClass.notesController.insertHtml(displayTitleTwoList[o].notes ?? "");
          // selectedDateDailyLogDayClass.notesController.clear();
          // selectedDateDailyLogDayClass.notesController.insertHtml(displayTitleTwoList[o].notes ?? "");
          // selectedDateDailyLogDayClass.notesController.text =  displayTitleTwoList[o].notes ?? "";
          selectedDateDailyLogDayClass.notesValues =  displayTitleTwoList[o].notes ?? "";



        }else if(displayTitleTwoList[o].title == Constant.titleDaysStr){
          ///Title 2 data
          selectedDateDailyLogDayClass.isCheckedDayData =  displayTitleTwoList[o].isCheckedDay ?? false;
          selectedDateDailyLogDayClass.daysStrKeyId = displayTitleTwoList[o].key!;

        }else if(displayTitleTwoList[o].title == Constant.titleCalories){
          ///Title 3 data
          selectedDateDailyLogDayClass.caloriesValueController.text = (displayTitleTwoList[o].total == null)? "" : (displayTitleTwoList[o].total!.toInt()).toString();
          selectedDateDailyLogDayClass.caloriesValue =  displayTitleTwoList[o].total ?? 0;
          selectedDateDailyLogDayClass.caloriesKeyId = displayTitleTwoList[o].key!;

        }else if(displayTitleTwoList[o].title == Constant.titleSteps){
          ///Title 4 data
          selectedDateDailyLogDayClass.stepsValueController.text =  (displayTitleTwoList[o].total == null)? "" : (displayTitleTwoList[o].total!.toInt()).toString();
          selectedDateDailyLogDayClass.stepsTotal =  displayTitleTwoList[o].total ?? 0;
          selectedDateDailyLogDayClass.stepsKeyId = displayTitleTwoList[o].key!;

        }else if(displayTitleTwoList[o].title == Constant.titleHeartRateRest){
          ///Title 5 data
          selectedDateDailyLogDayClass.restHeartValueController.text = (displayTitleTwoList[o].total == null)? "" : (displayTitleTwoList[o].total!.toInt()).toString();
          selectedDateDailyLogDayClass.restHeartValue =  displayTitleTwoList[o].total ?? 0;
          selectedDateDailyLogDayClass.restHeartKeyId = displayTitleTwoList[o].key!;

        }else if(displayTitleTwoList[o].title == Constant.titleHeartRatePeak){
          ///Title 6 data
          selectedDateDailyLogDayClass.peakHeartValueController.text =  (displayTitleTwoList[o].total == null)? "" : (displayTitleTwoList[o].total!.toInt()).toString();
          selectedDateDailyLogDayClass.peakHeartValue =  displayTitleTwoList[o].total ?? 0;
          selectedDateDailyLogDayClass.peakHeartKeyId = displayTitleTwoList[o].key!;

        }else if(displayTitleTwoList[o].title == null && displayTitleTwoList[o].smileyType != null){
          selectedDateDailyLogDayClass.smileyType =  displayTitleTwoList[o].smileyType ?? Constant.defaultSmileyType;
          selectedDateDailyLogDayClass.smileyKeyId =  displayTitleTwoList[o].key!;
        }
      }
      dailyLogDataListDay.add(selectedDateDailyLogDayClass);
    }
    else{
      selectedDateDailyLogDayClass = DailyLogClass();
    }
  }

  void onChangeDayValue1Bottom(value) {
    if(value == ""){
      selectedDateDailyLogDayClass.modValueController.text = "";
      selectedDateDailyLogDayClass.modValue = null;
      selectedDateDailyLogDayClass.modValueController.selection =
          TextSelection.fromPosition(const TextPosition(offset: 0));
    }else {
      selectedDateDailyLogDayClass.modValueController.text = value.toString();
      selectedDateDailyLogDayClass.modValue = double.parse(value);
      selectedDateDailyLogDayClass.modValueController.selection =
          TextSelection.fromPosition(TextPosition(offset: value.length));
    }
    update();
  }

  void onChangeDayValue2Bottom(value) {
    if(value == ""){
      selectedDateDailyLogDayClass.vigValueController.text = "";
      selectedDateDailyLogDayClass.vigValue = null;
      selectedDateDailyLogDayClass.vigValueController.selection =
          TextSelection.fromPosition(const TextPosition(offset: 0));
    }else {
      selectedDateDailyLogDayClass.vigValueController.text = value.toString();
      selectedDateDailyLogDayClass.vigValue = double.parse(value);
      selectedDateDailyLogDayClass.vigValueController.selection =
          TextSelection.fromPosition(TextPosition(offset: value.length));
    }
    update();
  }

  void onChangeDayTotalBottom(value) {
    if(value == ""){
      selectedDateDailyLogDayClass.totalValueController.text = "";
      selectedDateDailyLogDayClass.totalValue = null;
      selectedDateDailyLogDayClass.totalValueController.selection =
          TextSelection.fromPosition(const TextPosition(offset: 0));
    }else {
      selectedDateDailyLogDayClass.totalValueController.text = value.toString();
      selectedDateDailyLogDayClass.totalValue = double.parse(value);
      selectedDateDailyLogDayClass.totalValueController.selection =
          TextSelection.fromPosition(TextPosition(offset: value.length));
    }
    update();
  }

  void onChangeDayTitle3Bottom(value) {
    if(value == ""){
      selectedDateDailyLogDayClass.caloriesValueController.text = "";
      selectedDateDailyLogDayClass.caloriesValue = null;
      selectedDateDailyLogDayClass.caloriesValueController.selection =
          TextSelection.fromPosition(const TextPosition(offset: 0));

    }else {
      selectedDateDailyLogDayClass.caloriesValueController.text = value.toString();
      selectedDateDailyLogDayClass.caloriesValue = double.parse(value);
      selectedDateDailyLogDayClass.caloriesValueController.selection =
          TextSelection.fromPosition(TextPosition(offset: value.length));
    }
    update();
  }

  void onChangeDayTitle4Bottom(value) {
    if(value == ""){
      selectedDateDailyLogDayClass.stepsValueController.text = "";
      selectedDateDailyLogDayClass.stepsTotal = null;
      selectedDateDailyLogDayClass.stepsValueController.selection =
          TextSelection.fromPosition(const TextPosition(offset: 0));
    }else {
      selectedDateDailyLogDayClass.stepsValueController.text = value.toString();
      selectedDateDailyLogDayClass.stepsTotal = double.parse(value);
      selectedDateDailyLogDayClass.stepsValueController.selection =
          TextSelection.fromPosition(TextPosition(offset: value.length));
    }
    update();
  }


  var bottomIsCheckedDay = false;
  onChangeCheckBoxDayValueBottom(bool value){
    bottomIsCheckedDay = value;
    selectedDateDailyLogDayClass.isCheckedDayData = value;
    update();

  }

  void onChangeDayValue1Title5Bottom(value) {
    if(value == ""){
      selectedDateDailyLogDayClass.restHeartValueController.text = "";
      selectedDateDailyLogDayClass.restHeartValue = null;
      selectedDateDailyLogDayClass.restHeartValueController.selection =
          TextSelection.fromPosition(const TextPosition(offset: 0));
    }else {
      selectedDateDailyLogDayClass.restHeartValueController.text = value.toString();
      selectedDateDailyLogDayClass.restHeartValue = double.parse(value);
      selectedDateDailyLogDayClass.restHeartValueController.selection =
          TextSelection.fromPosition(TextPosition(offset: value.length));
    }
    update();
  }

  void onChangeDayValue2Title5Bottom(value) {
    if(value == ""){
      selectedDateDailyLogDayClass.peakHeartValueController.text = "";
      selectedDateDailyLogDayClass.peakHeartValue = null;
      selectedDateDailyLogDayClass.peakHeartValueController.selection =
          TextSelection.fromPosition(const TextPosition(offset: 0));
    }else {
      selectedDateDailyLogDayClass.peakHeartValueController.text = value.toString();
      selectedDateDailyLogDayClass.peakHeartValue = double.parse(value);
      selectedDateDailyLogDayClass.peakHeartValueController.selection =
          TextSelection.fromPosition(TextPosition(offset: value.length));
    }
    update();
  }

  var smileyTypeDay = 1;
  void updateSmileyForDayBottom(int value){
    smileyTypeDay = value;
    selectedDateDailyLogDayClass.smileyType = value;
    update();
  }

  /*void onChangeDayNotesBottom(value) {
    if(value == ""){
      selectedDateDailyLogDayClass.notesController.clear();
      // selectedDateDailyLogDayClass.notesController.text = "";
      selectedDateDailyLogDayClass.notesValues = "";
      // selectedDateDailyLogDayClass.notesController.selection =
      //     TextSelection.fromPosition(const TextPosition(offset: 0));
    }else {
      // selectedDateDailyLogDayClass.notesController.insertHtml(value.toString());
      // selectedDateDailyLogDayClass.notesController.clear();
      // selectedDateDailyLogDayClass.notesController.insertHtml(value.toString());
      // selectedDateDailyLogDayClass.notesController.text = value.toString();
      selectedDateDailyLogDayClass.notesValues = value;
      // selectedDateDailyLogDayClass.notesController.selection =
      //     TextSelection.fromPosition(TextPosition(offset: value.length));
    }
    update();
  }*/

  void changeDateDropDown(DateTime date) {
      var dateStr = DateFormat(Constant.commonDateFormatDdMmYyyy).format(date);
      List<ActivityTable> dataListHive =
      Hive.box<ActivityTable>(Constant.tableActivity).values.toList();
      var dummyData = DailyLogClass();
      dummyData.isShowHeader = true;
      dailyLogDataListDay.add(dummyData);

        var data = dataListHive
            .where((element) =>
        element.date == dateStr &&
            element.type == Constant.typeDay)
            .toList();

        if (data.isNotEmpty) {
          var displayTitleOneList = data
              .where((element) =>
          element.type == Constant.typeDay)
              .toList();
          getDateWiseDataDay(displayTitleOneList);
        }
      update();
  }

  Future<void> insertUpdateDailyValuesFromSheet() async {
    Debug.printLog(
        "dailyLogClass updateSingleDataFromSheet....$selectedDateDailyLogDayClass");
    List<ActivityTable> dataListHive =
        Hive.box<ActivityTable>(Constant.tableActivity).values.toList();

    var dateLabelList = dataListHive
        .where((element) =>
            element.type == Constant.typeDay &&
            element.date == selectedDateDailyLogDayClass.date)
        .toList();

    if (dateLabelList.isNotEmpty) {
      var dataActivityMin = dataListHive
          .where((element) =>
              element.date == selectedDateDailyLogDayClass.date && element.title == null && element.smileyType == null
      && element.type == Constant.typeDay )
          .toList();
      if (dataActivityMin.isNotEmpty) {
        ///Update title 1 data (Product A B C (Mod,Vig and Total))
        var activityMinData = dataActivityMin[0];
        activityMinData.value1 = selectedDateDailyLogDayClass.modValue ?? 0;
        activityMinData.value2 = selectedDateDailyLogDayClass.vigValue ?? 0;
        double totalValues =    selectedDateDailyLogDayClass.modValue! + selectedDateDailyLogDayClass.vigValue! ;
        activityMinData.total = (selectedDateDailyLogDayClass.totalValue == 0.0 || selectedDateDailyLogDayClass.totalValue == null) ?totalValues : selectedDateDailyLogDayClass.totalValue ?? 0;
        activityMinData.notes = selectedDateDailyLogDayClass.notesValues;
        activityMinData.type = Constant.typeDay;
        activityMinData.isSync = false;
        var allSelectedServersUrl = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected).toList();

        if (activityMinData.serverDetailList.length !=
            allSelectedServersUrl.length) {
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = activityMinData.serverDetailList;
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
              activityMinData.serverDetailList.add(
                  serverDetail);
            }
          }
        }

        if (activityMinData.serverDetailListModMin.length !=
            allSelectedServersUrl.length) {
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = activityMinData.serverDetailListModMin;
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
              activityMinData.serverDetailListModMin.add(
                  serverDetail);
            }
          }
        }

        if (activityMinData.serverDetailListVigMin.length !=
            allSelectedServersUrl.length) {
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = activityMinData.serverDetailListVigMin;
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
              activityMinData.serverDetailListVigMin.add(
                  serverDetail);
            }
          }
        }


        await DataBaseHelper.shared.updateActivityData(activityMinData);
      } 
      else {
        var activityTableData = ActivityTable();
        activityTableData.date = DateFormat(Constant.commonDateFormatDdMmYyyy)
            .format(selectedNewDateDaliy);
        activityTableData.value1 =
            selectedDateDailyLogDayClass.modValue ?? 0;
        activityTableData.value2 =
            selectedDateDailyLogDayClass.vigValue ?? 0;
        double totalValues =    selectedDateDailyLogDayClass.modValue! + selectedDateDailyLogDayClass.vigValue! ;
        activityTableData.total = (selectedDateDailyLogDayClass.totalValue == 0.0 || selectedDateDailyLogDayClass.totalValue == null ) ?totalValues : selectedDateDailyLogDayClass.totalValue ?? 0;
        // activityTableData.total = selectedDateDailyLogDayClass.totalValue ?? 0;
        var selectedWeekStartDate =
            DateFormat(Constant.commonDateFormatDdMmYyyy).format(
                Utils.findFirstDateOfTheWeekImport(
                    selectedNewDateDaliy));
        var selectedWeekEndDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
            .format(Utils.findLastDateOfTheWeekImport(
                selectedNewDateDaliy));

        activityTableData.weeksDate =
            "$selectedWeekStartDate-$selectedWeekEndDate";
        activityTableData.type = Constant.typeDay;
        activityTableData.dateTime = selectedNewDateDaliy;
        activityTableData.notes =
            selectedDateDailyLogDayClass.notesValues;
        activityTableData.isSync = false;
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
            activityTableData.serverDetailList.add(data);

            var dataMod = ServerDetailDataModMinTable();
            dataMod.modDataSyncServerWise = false;
            dataMod.modObjectId = "";
            dataMod.modServerUrl = connectedServerUrl[i].url;
            dataMod.modPatientId = connectedServerUrl[i].patientId;
            dataMod.modClientId = connectedServerUrl[i].clientId;
            dataMod.modServerToken = connectedServerUrl[i].authToken;
            dataMod.modPatientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
                .patientLName}";
            activityTableData.serverDetailListModMin.add(dataMod);

            var dataVig = ServerDetailDataVigMinTable();
            dataVig.vigDataSyncServerWise = false;
            dataVig.vigObjectId = "";
            dataVig.vigServerUrl = connectedServerUrl[i].url;
            dataVig.vigPatientId = connectedServerUrl[i].patientId;
            dataVig.vigClientId = connectedServerUrl[i].clientId;
            dataVig.vigServerToken = connectedServerUrl[i].authToken;
            dataVig.vigPatientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
                .patientLName}";
            activityTableData.serverDetailListVigMin.add(dataVig);
          }
        }

        await DataBaseHelper.shared.insertActivityData(activityTableData);
      }



      var dataDayStrength = dataListHive
          .where((element) =>
              element.date == selectedDateDailyLogDayClass.date && element.title == Constant.titleDaysStr
                  && element.type == Constant.typeDay )
          .toList();
      if (dataDayStrength.isNotEmpty) {
        ///Update title 2 data (Boxes)
        var daysStr = dataDayStrength[0];
        daysStr.isCheckedDay =
            selectedDateDailyLogDayClass.isCheckedDayData;
        daysStr.type = Constant.typeDay;
        daysStr.isSync = false;
        var allSelectedServersUrl = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected).toList();

        if (daysStr.serverDetailList.length !=
            allSelectedServersUrl.length) {
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = daysStr.serverDetailList;
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
              daysStr.serverDetailList.add(
                  serverDetail);
            }
          }
        }

        await DataBaseHelper.shared.updateActivityData(daysStr);
      }
      else {
        var activityTableData = ActivityTable();
        activityTableData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDateDaliy);
        activityTableData.title = Constant.titleDaysStr;
        var selectedWeekStartDate =
        DateFormat(Constant.commonDateFormatDdMmYyyy).format(
            Utils.findFirstDateOfTheWeekImport(
                selectedNewDateDaliy));
        var selectedWeekEndDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
            .format(Utils.findLastDateOfTheWeekImport(
            selectedNewDateDaliy));
        activityTableData.weeksDate =
            "$selectedWeekStartDate-$selectedWeekEndDate";
        activityTableData.isCheckedDay =
            selectedDateDailyLogDayClass.isCheckedDayData;
        activityTableData.type = Constant.typeDay;
        activityTableData.dateTime = selectedNewDateDaliy;
        activityTableData.isSync = false;
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
            activityTableData.serverDetailList.add(data);
          }
        }

        await DataBaseHelper.shared.insertActivityData(activityTableData);
      }



      var dataCalories = dataListHive
          .where((element) =>
              element.date == selectedDateDailyLogDayClass.date && element.title == Constant.titleCalories
                  && element.type == Constant.typeDay )
          .toList();
      if (dataCalories.isNotEmpty) {
        ///Update title 3 data (Colors (Calories))
        var caloriesData = dataCalories[0];
        caloriesData.needExport = true;
        caloriesData.isSync = false;
        caloriesData.type = Constant.typeDay;
        caloriesData.total = selectedDateDailyLogDayClass.caloriesValue;

        var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
        if(caloriesData.serverDetailList.length != allSelectedServersUrl.length){
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = caloriesData.serverDetailList;
            if(url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty){

              var serverDetail = ServerDetailDataTable();
              serverDetail.serverUrl = allSelectedServersUrl[i].url;
              serverDetail.patientId = allSelectedServersUrl[i].patientId;
              serverDetail.patientName = "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
              serverDetail.objectId = "";
              caloriesData.serverDetailList.add(serverDetail);
            }
          }
        }
        caloriesData.isSync = false;
        await DataBaseHelper.shared.updateActivityData(caloriesData);
      } 
      else {
        var caloriesActivityData = ActivityTable();
        caloriesActivityData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDateDaliy);
        caloriesActivityData.title = Constant.titleCalories;
        caloriesActivityData.total = selectedDateDailyLogDayClass.caloriesValue ?? 0;
        var selectedWeekStartDate =
        DateFormat(Constant.commonDateFormatDdMmYyyy).format(
            Utils.findFirstDateOfTheWeekImport(
                selectedNewDateDaliy));
        var selectedWeekEndDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
            .format(Utils.findLastDateOfTheWeekImport(
            selectedNewDateDaliy));
        caloriesActivityData.weeksDate =
            "$selectedWeekStartDate-$selectedWeekEndDate";
        caloriesActivityData.type = Constant.typeDay;
        caloriesActivityData.dateTime = selectedNewDateDaliy;
        caloriesActivityData.needExport = true;
        caloriesActivityData.isSync = false;
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
            caloriesActivityData.serverDetailList.add(serverDetail);

          }
        }
        caloriesActivityData.isSync = false;
        await DataBaseHelper.shared.insertActivityData(caloriesActivityData);
      }


      var dataSteps = dataListHive
          .where((element) =>
              element.date == selectedDateDailyLogDayClass.date && element.title == Constant.titleSteps
                  && element.type == Constant.typeDay )
          .toList();
      if (dataSteps.isNotEmpty) {
        ///Update title 4 data (Sizes (Steps))
        var stepsData = dataSteps[0];
        stepsData.total = selectedDateDailyLogDayClass.stepsTotal;
        stepsData.type = Constant.typeDay;
        stepsData.needExport = true;
        stepsData.isSync = false;

        var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();

        if(stepsData.serverDetailList.length != allSelectedServersUrl.length){
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = stepsData.serverDetailList;
            if(url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty){

              var serverDetail = ServerDetailDataTable();
              serverDetail.serverUrl = allSelectedServersUrl[i].url;
              serverDetail.patientId = allSelectedServersUrl[i].patientId;
              serverDetail.patientName = "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
              serverDetail.objectId = "";
              stepsData.serverDetailList.add(serverDetail);
            }
          }
        }

        await DataBaseHelper.shared.updateActivityData(stepsData);
      } 
      else {
        var stepsActivityData = ActivityTable();
        stepsActivityData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDateDaliy);
        stepsActivityData.title = Constant.titleSteps;
        stepsActivityData.total = selectedDateDailyLogDayClass.stepsTotal ?? 0;
        var selectedWeekStartDate =
        DateFormat(Constant.commonDateFormatDdMmYyyy).format(
            Utils.findFirstDateOfTheWeekImport(
                selectedNewDateDaliy));
        var selectedWeekEndDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
            .format(Utils.findLastDateOfTheWeekImport(
            selectedNewDateDaliy));
        stepsActivityData.weeksDate =
            "$selectedWeekStartDate-$selectedWeekEndDate";
        stepsActivityData.type = Constant.typeDay;
        stepsActivityData.dateTime = selectedNewDateDaliy;
        stepsActivityData.needExport = true;

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
            stepsActivityData.serverDetailList.add(serverDetail);
          }
        }

        stepsActivityData.isSync = false;
        await DataBaseHelper.shared.insertActivityData(stepsActivityData);
      }

      var dataRestHeartRate = dataListHive
          .where((element) =>
              element.date == selectedDateDailyLogDayClass.date && element.title == Constant.titleHeartRateRest
                  && element.type == Constant.typeDay )
          .toList();
      if (dataRestHeartRate.isNotEmpty) {
        ///Update title 5 Value 1 data (Quantity (Rest heart rate))
        var restHeartData = dataRestHeartRate[0];
        restHeartData.total = selectedDateDailyLogDayClass.restHeartValue;
        restHeartData.needExport = true;
        restHeartData.type = Constant.typeDay;
        restHeartData.isSync = false;
        var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
        if(restHeartData.serverDetailList.length != allSelectedServersUrl.length){
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = restHeartData.serverDetailList;
            if(url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty){

              var serverDetail = ServerDetailDataTable();
              serverDetail.serverUrl = allSelectedServersUrl[i].url;
              serverDetail.patientId = allSelectedServersUrl[i].patientId;
              serverDetail.patientName = "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
              serverDetail.objectId = "";
              restHeartData.serverDetailList.add(serverDetail);
            }
          }
        }

        await DataBaseHelper.shared.updateActivityData(restHeartData);
      }
      else {
        var restHeartRateData = ActivityTable();
        restHeartRateData.date =DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDateDaliy);
        restHeartRateData.title = Constant.titleHeartRateRest;
        restHeartRateData.total =
            selectedDateDailyLogDayClass.restHeartValue ?? 0;
        var selectedWeekStartDate =
        DateFormat(Constant.commonDateFormatDdMmYyyy).format(
            Utils.findFirstDateOfTheWeekImport(
                selectedNewDateDaliy));
        var selectedWeekEndDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
            .format(Utils.findLastDateOfTheWeekImport(
            selectedNewDateDaliy));
        restHeartRateData.weeksDate =
            "$selectedWeekStartDate-$selectedWeekEndDate";
        restHeartRateData.type = Constant.typeDay;
        restHeartRateData.dateTime = selectedNewDateDaliy;
        restHeartRateData.needExport = true;
        restHeartRateData.isSync = false;

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
            restHeartRateData.serverDetailList.add(serverDetail);
          }
        }

        await DataBaseHelper.shared.insertActivityData(restHeartRateData);
      }

      var dataPeakHeart = dataListHive
          .where((element) =>
              element.date == selectedDateDailyLogDayClass.date && element.title == Constant.titleHeartRatePeak
                  && element.type == Constant.typeDay )
          .toList();
      if (dataPeakHeart.isNotEmpty) {
        ///Update title 5 Value 1 data (Quantity (Peak heart rate))
        var peakHeartData = dataPeakHeart[0];
        peakHeartData.type = Constant.typeDay;
        peakHeartData.total = selectedDateDailyLogDayClass.peakHeartValue;
        peakHeartData.needExport = true;
        peakHeartData.isSync = false;

        var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();

        if(peakHeartData.serverDetailList.length != allSelectedServersUrl.length){
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = peakHeartData.serverDetailList;
            if(url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty){

              var serverDetail = ServerDetailDataTable();
              serverDetail.serverUrl = allSelectedServersUrl[i].url;
              serverDetail.patientId = allSelectedServersUrl[i].patientId;
              serverDetail.patientName = "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
              serverDetail.objectId = "";
              peakHeartData.serverDetailList.add(serverDetail);
            }
          }
        }
        await DataBaseHelper.shared.updateActivityData(peakHeartData);
      }
      else {
        var dataPeakHeartData = ActivityTable();
        dataPeakHeartData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDateDaliy);
        dataPeakHeartData.title = Constant.titleHeartRatePeak;
        dataPeakHeartData.total =
            selectedDateDailyLogDayClass.peakHeartValue ?? 0;
        var selectedWeekStartDate =
        DateFormat(Constant.commonDateFormatDdMmYyyy).format(
            Utils.findFirstDateOfTheWeekImport(
                selectedNewDateDaliy));
        var selectedWeekEndDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
            .format(Utils.findLastDateOfTheWeekImport(
            selectedNewDateDaliy));
        dataPeakHeartData.weeksDate =
            "$selectedWeekStartDate-$selectedWeekEndDate";
        dataPeakHeartData.type = Constant.typeDay;
        dataPeakHeartData.dateTime = selectedNewDateDaliy;
        dataPeakHeartData.needExport = true;
        dataPeakHeartData.isSync = false;

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
            dataPeakHeartData.serverDetailList.add(serverDetail);
          }
        }
        await DataBaseHelper.shared.insertActivityData(dataPeakHeartData);
      }


      /*var smileyDataList = dataListHive
          .where((element) =>
          element.date == selectedDateDailyLogDayClass.date && element.title == null && element.smileyType != null
              && element.type == Constant.typeDay )
          .toList();
      if(smileyDataList.isNotEmpty){
        var smileyData = smileyDataList[0];
        smileyData.type = Constant.typeDay;
        smileyData.isSync = false;
        smileyData.smileyType = selectedDateDailyLogDayClass.smileyType;

        var allSelectedServersUrl = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected).toList();

        if (smileyData.serverDetailList.length !=
            allSelectedServersUrl.length) {
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = smileyData.serverDetailList;
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
              smileyData.serverDetailList.add(
                  serverDetail);
            }
          }
        }

        await DataBaseHelper.shared.updateActivityData(smileyData);

      }
      else{
        var insertingData = ActivityTable();
        insertingData.dateTime = selectedNewDateDaliy;
        insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDateDaliy);
        insertingData.title = null;
        insertingData.value1 = null;
        insertingData.value2 = null;
        insertingData.total = null;
        insertingData.isSync = false;
        insertingData.type = Constant.typeDay;
        var selectedWeekStartDate =
        DateFormat(Constant.commonDateFormatDdMmYyyy).format(
            Utils.findFirstDateOfTheWeekImport(
                selectedNewDateDaliy));
        var selectedWeekEndDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
            .format(Utils.findLastDateOfTheWeekImport(
            selectedNewDateDaliy));
        insertingData.weeksDate =
        "$selectedWeekStartDate-$selectedWeekEndDate";
        insertingData.smileyType = selectedDateDailyLogDayClass.smileyType;

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
      }*/
    }
    else {
      var activityTableData = ActivityTable();
      activityTableData.date = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(selectedNewDateDaliy);
      activityTableData.value1 = selectedDateDailyLogDayClass.modValue ?? 0;
      activityTableData.value2 = selectedDateDailyLogDayClass.vigValue ?? 0;
      activityTableData.total = selectedDateDailyLogDayClass.totalValue ?? 0;
      var selectedWeekStartDate =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(
          Utils.findFirstDateOfTheWeekImport(
              selectedNewDateDaliy));
      var selectedWeekEndDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(Utils.findLastDateOfTheWeekImport(
          selectedNewDateDaliy));
      activityTableData.weeksDate =
          "$selectedWeekStartDate-$selectedWeekEndDate";
      activityTableData.type = Constant.typeDay;
      activityTableData.isSync = false;
      activityTableData.dateTime = selectedNewDateDaliy;
      activityTableData.notes =
          selectedDateDailyLogDayClass.notesValues;
      await DataBaseHelper.shared.insertActivityData(activityTableData);



      activityTableData = ActivityTable();
       activityTableData.date = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(selectedNewDateDaliy);
      activityTableData.title = Constant.titleDaysStr;
      selectedWeekStartDate =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(
          Utils.findFirstDateOfTheWeekImport(
              selectedNewDateDaliy));
      selectedWeekEndDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(Utils.findLastDateOfTheWeekImport(
          selectedNewDateDaliy));
      activityTableData.weeksDate =
          "$selectedWeekStartDate-$selectedWeekEndDate";
      activityTableData.isCheckedDay =
          selectedDateDailyLogDayClass.isCheckedDayData;
      activityTableData.type = Constant.typeDay;
      activityTableData.dateTime = selectedNewDateDaliy;
      activityTableData.isSync = false;
      await DataBaseHelper.shared.insertActivityData(activityTableData);



      activityTableData = ActivityTable();
       activityTableData.date = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(selectedNewDateDaliy);
      activityTableData.title = Constant.titleCalories;
      activityTableData.isSync = false;
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
          activityTableData.serverDetailList.add(serverDetail);
        }
      }
      activityTableData.total = selectedDateDailyLogDayClass.caloriesValue ?? 0;
      selectedWeekStartDate =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(
          Utils.findFirstDateOfTheWeekImport(
              selectedNewDateDaliy));
      selectedWeekEndDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(Utils.findLastDateOfTheWeekImport(
          selectedNewDateDaliy));
      activityTableData.weeksDate =
          "$selectedWeekStartDate-$selectedWeekEndDate";
      activityTableData.type = Constant.typeDay;
      activityTableData.dateTime = selectedNewDateDaliy;
      await DataBaseHelper.shared.insertActivityData(activityTableData);



      activityTableData = ActivityTable();
       activityTableData.date = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(selectedNewDateDaliy);
      activityTableData.title = Constant.titleSteps;
      activityTableData.isSync = false;
      if(connectedServerUrl.isNotEmpty) {
        for (int i = 0; i < connectedServerUrl.length; i++) {
          var serverDetail = ServerDetailDataTable();
          serverDetail.serverUrl = connectedServerUrl[i].url;
          serverDetail.patientId = connectedServerUrl[i].patientId;
          serverDetail.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i].patientLName}";
          serverDetail.objectId = "";
          serverDetail.serverToken = connectedServerUrl[i].authToken;
          serverDetail.clientId = connectedServerUrl[i].clientId;
          activityTableData.serverDetailList.add(serverDetail);
        }
      }
      activityTableData.total = selectedDateDailyLogDayClass.stepsTotal ?? 0;
      selectedWeekStartDate =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(
          Utils.findFirstDateOfTheWeekImport(
              selectedNewDateDaliy));
      selectedWeekEndDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(Utils.findLastDateOfTheWeekImport(
          selectedNewDateDaliy));
      activityTableData.weeksDate =
          "$selectedWeekStartDate-$selectedWeekEndDate";
      activityTableData.type = Constant.typeDay;
      activityTableData.dateTime = selectedNewDateDaliy;
      await DataBaseHelper.shared.insertActivityData(activityTableData);



      activityTableData = ActivityTable();
       activityTableData.date = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(selectedNewDateDaliy);
      activityTableData.isSync = false;
      if(connectedServerUrl.isNotEmpty) {
        for (int i = 0; i < connectedServerUrl.length; i++) {
          var serverDetail = ServerDetailDataTable();
          serverDetail.serverUrl = connectedServerUrl[i].url;
          serverDetail.patientId = connectedServerUrl[i].patientId;
          serverDetail.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i].patientLName}";
          serverDetail.objectId = "";
          serverDetail.serverToken = connectedServerUrl[i].authToken;
          serverDetail.clientId = connectedServerUrl[i].clientId;
          activityTableData.serverDetailList.add(serverDetail);
        }
      }
      activityTableData.title = Constant.titleHeartRateRest;
      activityTableData.total = selectedDateDailyLogDayClass.restHeartValue ?? 0;
      selectedWeekStartDate =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(
          Utils.findFirstDateOfTheWeekImport(
              selectedNewDateDaliy));
      selectedWeekEndDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(Utils.findLastDateOfTheWeekImport(
          selectedNewDateDaliy));
      activityTableData.weeksDate =
          "$selectedWeekStartDate-$selectedWeekEndDate";
      activityTableData.type = Constant.typeDay;
      activityTableData.dateTime = selectedNewDateDaliy;
      await DataBaseHelper.shared.insertActivityData(activityTableData);


      activityTableData = ActivityTable();
       activityTableData.date = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(selectedNewDateDaliy);
      activityTableData.isSync = false;
      if(connectedServerUrl.isNotEmpty) {
        for (int i = 0; i < connectedServerUrl.length; i++) {
          var serverDetail = ServerDetailDataTable();
          serverDetail.serverUrl = connectedServerUrl[i].url;
          serverDetail.patientId = connectedServerUrl[i].patientId;
          serverDetail.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i].patientLName}";
          serverDetail.objectId = "";
          serverDetail.serverToken = connectedServerUrl[i].authToken;
          serverDetail.clientId = connectedServerUrl[i].clientId;
          activityTableData.serverDetailList.add(serverDetail);
        }
      }
      activityTableData.title = Constant.titleHeartRatePeak;
      activityTableData.total = selectedDateDailyLogDayClass.peakHeartValue ?? 0;
      selectedWeekStartDate =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(
          Utils.findFirstDateOfTheWeekImport(
              selectedNewDateDaliy));
      selectedWeekEndDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(Utils.findLastDateOfTheWeekImport(
          selectedNewDateDaliy));
      activityTableData.weeksDate =
          "$selectedWeekStartDate-$selectedWeekEndDate";
      activityTableData.type = Constant.typeDay;
      activityTableData.dateTime = selectedNewDateDaliy;
      await DataBaseHelper.shared.insertActivityData(activityTableData);


      /*var insertingData = ActivityTable();
      insertingData.dateTime = selectedNewDateDaliy;
      insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDateDaliy);
      insertingData.title = null;
      insertingData.value1 = null;
      insertingData.value2 = null;
      insertingData.total = null;
      insertingData.isSync = false;
      insertingData.type = Constant.typeDay;
      selectedWeekStartDate =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(
          Utils.findFirstDateOfTheWeekImport(
              selectedNewDateDaliy));
      selectedWeekEndDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(Utils.findLastDateOfTheWeekImport(
          selectedNewDateDaliy));
      insertingData.weeksDate =
      "$selectedWeekStartDate-$selectedWeekEndDate";
      insertingData.smileyType = selectedDateDailyLogDayClass.smileyType;
      await DataBaseHelper.shared.insertActivityData(insertingData);*/
    }

    Get.back();
    bottomIsCheckedDay = false;
    update();

    /// Now It will start for weeks data insert or update
    var selectedWeekStartDate =
    DateFormat(Constant.commonDateFormatDdMmYyyy).format(
        Utils.findFirstDateOfTheWeekImport(
            selectedNewDateDaliy));
    var selectedWeekEndDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
        .format(Utils.findLastDateOfTheWeekImport(
        selectedNewDateDaliy));
    await insertHigherLevelOfDay(selectedWeekStartDate,selectedWeekEndDate,selectedDateDailyLogDayClass);

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
    List<SyncMonthlyActivityData> allSyncingData = [];
    await Syncing.getAndSetSyncActivityData(allSyncingData,date:
    DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDateDaliy),isFromEx: false);
    if(allSyncingData.isNotEmpty) {
      await Syncing.observationSyncDataCalories(allSyncingData);
      await Syncing.observationSyncDataSteps(allSyncingData);
      await Syncing.observationSyncDataRestHeart(allSyncingData);
      await Syncing.observationSyncDataPeakHeart(allSyncingData);
      // await Syncing.observationSyncDataExperience(allSyncingData);
      await Syncing.observationSyncDataTotalMin(allSyncingData);
      await Syncing.observationSyncDataModMin(allSyncingData);
      await Syncing.observationSyncDataVigMin(allSyncingData);
      await Syncing.observationSyncDataStrengthBox(allSyncingData);
    }

  }

  void setSelectedDayClass(DailyLogClass selectedDateFirstDate) {
    selectedDateDailyLogDayClass = selectedDateFirstDate;
    update();
  }

  List<ActivityTable> getActivityListData(){
    return Hive.box<ActivityTable>(Constant.tableActivity).values.toList().where((element) =>
    element.patientId == Utils.getPatientId()).toList();
  }

  Future<void> insertUpdateRecordActivity() async {
    Debug.printLog("dailyLogClass updateSingleDataFromSheet....$selectedDateDailyLogClass");
    List<ActivityTable> dataListHive = getActivityListData();

    if(selectedDateDailyLogClass.totalValue == 0.0 || selectedDateDailyLogClass.totalValue == null ){
      double totalValues = selectedDateDailyLogClass.modValue! + selectedDateDailyLogClass.vigValue! ;
      selectedDateDailyLogClass.totalValue = totalValues ;
    }


    if((selectedDateDailyLogClass.totalValue ?? 0.0) > 0.0){
      selectedDateDailyLogClass.activityEndDate = selectedDateDailyLogClass.activityStartDate.add(Duration(minutes: (selectedDateDailyLogClass.totalValue ?? 0.0).toInt()));
    }else{
      selectedDateDailyLogClass.activityEndDate = selectedDateDailyLogClass.activityStartDate.add(const Duration(minutes: 1));
      selectedDateDailyLogClass.totalValue = 1;
    }
    String getTotalMinFromTwoDates = Utils.getTotalMinFromTwoDates(selectedDateDailyLogClass.activityStartDate, selectedDateDailyLogClass.activityEndDate);

    if (int.parse(getTotalMinFromTwoDates) >= 0) {
      var listOfLastData = getActivityListData().where((element) =>
      Utils.convertDateTimeFormat(element.dateTime ?? DateTime.now())
          == Utils.convertDateTimeFormat(selectedDateDailyLogClass.activityStartDate ?? DateTime.now()) &&
          element.type == Constant.typeDaysData
      && element.displayLabel != selectedDateDailyLogClass.displayLabel).toList();

      var isOverLap = false;
      isOverLap = Utils.checkDateOverlapFromDb(listOfLastData,
          selectedDateDailyLogClass.activityStartDate,selectedDateDailyLogClass.activityEndDate);

      if(isOverLap){
        Utils.showToast(Get.context!, "You have to select unique date");
        return;
      }

      if(!kIsWeb && Platform.isIOS) {
        try {
          // HealthFactory health = HealthFactory(
          //     useHealthConnectIfAvailable: true);
          var permissions = ((Platform.isAndroid) ? Utils
              .getAllHealthTypeAndroid : Utils.getAllHealthTypeIos).map((
              e) => HealthDataAccess.READ_WRITE).toList();
          bool? hasPermissions = await Health().hasPermissions(
              (Platform.isAndroid) ? Utils.getAllHealthTypeAndroid : Utils
                  .getAllHealthTypeIos, permissions: permissions);
          if (Platform.isIOS) {
            hasPermissions = Utils.getPermissionHealth();
          }
          Debug.printLog("hasPermissions...$hasPermissions");
          // if (hasPermissions! && !kIsWeb && Platform.isIOS) {
          if (hasPermissions! && !kIsWeb) {
            var deletedData = await Utils.deleteWorkout(
                selectedDateDailyLogClass.activityStartDateLast ??
                    DateTime.now(),
                selectedDateDailyLogClass.activityEndDateLast ?? DateTime.now(),
                Health());
            Debug.printLog("deletedData activity new...$deletedData");
            HealthWorkoutActivityType workoutType =
                HealthWorkoutActivityType.OTHER;
            var getTypeFromName = (kIsWeb)?Utils.workOutDataListAndroid:(Platform.isAndroid) ? Utils
                .workOutDataListAndroid : Utils.workOutDataListIos
                .where((element) =>
            element.workOutDataName == selectedDateDailyLogClass.displayLabel)
                .toList();

            if (getTypeFromName.isNotEmpty) {
              workoutType = getTypeFromName[0].datatype;
            }
            else {
              workoutType = HealthWorkoutActivityType.OTHER;
            }

            try {
              // HealthFactory health =
              // HealthFactory(useHealthConnectIfAvailable: true);
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
              HealthWorkoutActivityType workoutType =
                  HealthWorkoutActivityType.OTHER;
              /*var getTypeFromName = (kIsWeb)?Utils.workOutDataListAndroid:(Platform.isAndroid)
                  ? Utils.workOutDataListAndroid
                  : Utils.workOutDataListIos
                  .where((element) =>
              element.workOutDataName == selectedDateDailyLogClass.displayLabel)
                  .toList();*/

              List<WorkOutData> getTypeFromName = [];

              if (Platform.isAndroid) {
                getTypeFromName = Utils.workOutDataListAndroid
                    .where((element) => element.workOutDataName == selectedDateDailyLogClass.displayLabel)
                    .toList();
              } else if (Platform.isIOS) {
                getTypeFromName = Utils.workOutDataListIos
                    .where((element) => element.workOutDataName == selectedDateDailyLogClass.displayLabel)
                    .toList();
              }

              if (getTypeFromName.isNotEmpty) {
                workoutType = getTypeFromName[0].datatype;
              } else {
                workoutType = HealthWorkoutActivityType.OTHER;
              }
              if(Utils.getPermissionHealth()) {
                await GetSetHealthData.insertActivityIntoAppleGoogleSync(
                    selectedDateDailyLogClass.displayLabel ?? "",
                    selectedDateDailyLogClass.activityStartDate,
                    selectedDateDailyLogClass.activityEndDate,
                    workoutType,
                    selectedDateDailyLogClass.totalValue.toString());
              }
            } catch (e) {
              Debug.printLog(e.toString());
            }
          }
        } catch (e) {
          Debug.printLog(e.toString());
        }
      }

      var selectedWeekStartDate = DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findFirstDateOfTheWeekImport(selectedNewDate));
      var selectedWeekEndDate = DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findLastDateOfTheWeekImport(selectedNewDate));

      var weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
      var dateLabelList = dataListHive.where((element) => element.displayLabel == selectedDateDailyLogClass.displayLabel &&
          element.date == selectedDateDailyLogClass.date && element.type == Constant.typeDaysData).toList();
      if (dateLabelList.isNotEmpty) {

        var dataActivityMin = dataListHive
            .where((element) =>
            element.type == Constant.typeDaysData &&
            element.title == null &&
                element.weeksDate == weeksDate&&
            element.smileyType == null &&
                element.displayLabel == selectedDateDailyLogClass.displayLabel
                && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
            Utils.changeDateFormatBasedOnDBDate(selectedDateDailyLogClass.activityStartDateLast ?? DateTime.now())&&
            Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
                Utils.changeDateFormatBasedOnDBDate(selectedDateDailyLogClass.activityEndDateLast ?? DateTime.now()))
            .toList();
        if (dataActivityMin.isNotEmpty) {
          ///Update title 1 data (Product A B C)(Activity min)
          var activityMin = dataActivityMin[0];
          if(selectedDateDailyLogClass.modValue != null && (selectedDateDailyLogClass.modValue ?? 0) > 0) {
            activityMin.value1 = selectedDateDailyLogClass.modValue ?? 0;
          }

          if(selectedDateDailyLogClass.vigValue != null && (selectedDateDailyLogClass.vigValue ?? 0) > 0) {
            activityMin.value2 = selectedDateDailyLogClass.vigValue ?? 0;
          }

          if(selectedDateDailyLogClass.totalValue != null && (selectedDateDailyLogClass.totalValue ?? 0) > 0) {
            if(selectedDateDailyLogClass.totalValue == 1.0 || selectedDateDailyLogClass.totalValue == 1){
              double totalValues = selectedDateDailyLogClass.modValue! + selectedDateDailyLogClass.vigValue! ;
              activityMin.total = (selectedDateDailyLogClass.totalValue == 0.0 || selectedDateDailyLogClass.totalValue == null) ?totalValues : selectedDateDailyLogClass.totalValue ?? 0;
            }else{
              activityMin.total = selectedDateDailyLogClass.totalValue ?? 0;
            }
          }else{
            double totalValues = selectedDateDailyLogClass.modValue! + selectedDateDailyLogClass.vigValue! ;
            activityMin.total = (selectedDateDailyLogClass.totalValue == 0.0 || selectedDateDailyLogClass.totalValue == null) ?totalValues : selectedDateDailyLogClass.totalValue ?? 0;
          }

          activityMin.notes = getDataFromController();
          activityMin.activityEndDate = selectedDateDailyLogClass.activityEndDate;
          activityMin.activityStartDate = selectedDateDailyLogClass.activityStartDate;

          var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
          if(activityMin.serverDetailList.length != allSelectedServersUrl.length){
            for (int i = 0; i < allSelectedServersUrl.length; i++) {
              var url = activityMin.serverDetailList;
              if(url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty){
                var serverDetail = ServerDetailDataTable();
                serverDetail.serverUrl = allSelectedServersUrl[i].url;
                serverDetail.patientId = allSelectedServersUrl[i].patientId;
                serverDetail.patientName = "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
                serverDetail.objectId = "";
                activityMin.serverDetailList.add(serverDetail);
              }
            }
          }

          await DataBaseHelper.shared.updateActivityData(activityMin);
        }
        else{
          var activityTableData = ActivityTable();
          activityTableData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);
          activityTableData.title = null;
          activityTableData.smileyType = null;

          if((selectedDateDailyLogClass.modValue ?? 0.0) > 0.0){
            activityTableData.value1 = selectedDateDailyLogClass.modValue ?? 0;
          }

          if((selectedDateDailyLogClass.vigValue ?? 0.0) > 0.0){
            activityTableData.value2 = selectedDateDailyLogClass.vigValue ?? 0;
          }

          if((selectedDateDailyLogClass.totalValue ?? 0.0) > 0.0){
            // activityTableData.total = selectedDateDailyLogClass.totalValue ?? 0;
            if(selectedDateDailyLogClass.totalValue == 1.0 || selectedDateDailyLogClass.totalValue == 1){
              double totalValues = selectedDateDailyLogClass.modValue! + selectedDateDailyLogClass.vigValue! ;
              activityTableData.total = (selectedDateDailyLogClass.totalValue == 0.0 || selectedDateDailyLogClass.totalValue == null) ?totalValues : selectedDateDailyLogClass.totalValue ?? 0;
            }else{
              activityTableData.total = selectedDateDailyLogClass.totalValue ?? 0;
            }
          }else{
            double totalValues =    selectedDateDailyLogClass.modValue! + selectedDateDailyLogClass.vigValue! ;
            activityTableData.total = (selectedDateDailyLogClass.totalValue == 0.0 || selectedDateDailyLogClass.totalValue == null) ?totalValues : selectedDateDailyLogClass.totalValue ?? 0;
          }

          activityTableData.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
          activityTableData.type = Constant.typeDaysData;
          activityTableData.dateTime = selectedNewDate;
          activityTableData.displayLabel = selectedDateDailyLogClass.displayLabel;
          activityTableData.activityEndDate = selectedDateDailyLogClass.activityEndDate;
          activityTableData.activityStartDate = selectedDateDailyLogClass.activityStartDate;
          activityTableData.iconPath = Utils.getNumberIconNameFromType(selectedDateDailyLogClass.displayLabel?? Constant.iconBicycling);
          activityTableData.notes = getDataFromController();

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
              activityTableData.serverDetailList.add(data);

              var dataMod = ServerDetailDataModMinTable();
              dataMod.modDataSyncServerWise = false;
              dataMod.modObjectId = "";
              dataMod.modServerUrl = connectedServerUrl[i].url;
              dataMod.modPatientId = connectedServerUrl[i].patientId;
              dataMod.modClientId = connectedServerUrl[i].clientId;
              dataMod.modServerToken = connectedServerUrl[i].authToken;
              dataMod.modPatientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
                  .patientLName}";
              activityTableData.serverDetailListModMin.add(dataMod);

              var dataVig = ServerDetailDataVigMinTable();
              dataVig.vigDataSyncServerWise = false;
              dataVig.vigObjectId = "";
              dataVig.vigServerUrl = connectedServerUrl[i].url;
              dataVig.vigPatientId = connectedServerUrl[i].patientId;
              dataVig.vigClientId = connectedServerUrl[i].clientId;
              dataVig.vigServerToken = connectedServerUrl[i].authToken;
              dataVig.vigPatientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
                  .patientLName}";
              activityTableData.serverDetailListVigMin.add(dataVig);
            }
          }

          await DataBaseHelper.shared.insertActivityData(activityTableData);
        }


        var dataStrength = dataListHive
            .where(
                (element) =>
                    Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
                    Utils.changeDateFormatBasedOnDBDate(selectedDateDailyLogClass.activityStartDateLast ?? DateTime.now())&&
                    Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
                        Utils.changeDateFormatBasedOnDBDate(selectedDateDailyLogClass.activityEndDateLast ?? DateTime.now())
                && element.weeksDate == weeksDate
                && element.title == Constant.titleDaysStr && element.type == Constant.typeDaysData &&
                    element.displayLabel == selectedDateDailyLogClass.displayLabel )
            .toList();
        if (dataStrength.isNotEmpty) {
          ///Update title 2 data (Boxes)(Strength)
          var dataStrengthModel = dataStrength[0];
          dataStrengthModel.isCheckedDayData =
              selectedDateDailyLogClass.isCheckedDayData;
          dataStrengthModel.activityEndDate = selectedDateDailyLogClass.activityEndDate;
          dataStrengthModel.activityStartDate = selectedDateDailyLogClass.activityStartDate;
          await DataBaseHelper.shared.updateActivityData(dataStrengthModel);
        }
        else{
          var dataStrength = ActivityTable();
          dataStrength.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);
          dataStrength.title = Constant.titleDaysStr;
          dataStrength.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
          dataStrength.isCheckedDayData = bottomIsCheckedDayData;
          dataStrength.type = Constant.typeDaysData;
          dataStrength.dateTime = selectedNewDate;
          dataStrength.displayLabel = selectedDateDailyLogClass.displayLabel;
          dataStrength.activityEndDate = selectedDateDailyLogClass.activityEndDate;
          dataStrength.activityStartDate = selectedDateDailyLogClass.activityStartDate;
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
              dataStrength.serverDetailList.add(data);
            }
          }

          dataStrength.iconPath = Utils.getNumberIconNameFromType(selectedDateDailyLogClass.displayLabel?? Constant.iconBicycling);
          await DataBaseHelper.shared.insertActivityData(dataStrength);
        }



        var dataCalories = getActivityListData().where((element) => element.displayLabel ==
            selectedDateDailyLogClass.displayLabel && element.weeksDate == weeksDate
            && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
                Utils.changeDateFormatBasedOnDBDate(selectedDateDailyLogClass.activityStartDateLast ?? DateTime.now())&&
            Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
                Utils.changeDateFormatBasedOnDBDate(selectedDateDailyLogClass.activityEndDateLast ?? DateTime.now()) &&
            element.type == Constant.typeDaysData
            && element.title == Constant.titleCalories).toList();
        if (dataCalories.isNotEmpty) {
          ///Update title 3 data (Calories)
          var dataCaloriesModel = dataCalories[0];
          if(selectedDateDailyLogClass.caloriesValue != null && (selectedDateDailyLogClass.caloriesValue ?? 0) > 0) {
            dataCaloriesModel.total = selectedDateDailyLogClass.caloriesValue ?? 0;
          }

          dataCaloriesModel.activityEndDate = selectedDateDailyLogClass.activityEndDate;
          dataCaloriesModel.activityStartDate = selectedDateDailyLogClass.activityStartDate;

          var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
          if(dataCaloriesModel.serverDetailList.length != allSelectedServersUrl.length){
            for (int i = 0; i < allSelectedServersUrl.length; i++) {
              var url = dataCaloriesModel.serverDetailList;
              if(url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty){
                var serverDetail = ServerDetailDataTable();
                serverDetail.serverUrl = allSelectedServersUrl[i].url;
                serverDetail.patientId = allSelectedServersUrl[i].patientId;
                serverDetail.patientName = "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
                serverDetail.objectId = "";
                dataCaloriesModel.serverDetailList.add(serverDetail);
              }
            }
          }

          await DataBaseHelper.shared.updateActivityData(dataCaloriesModel);
        }
        else{
          var dataCalories = ActivityTable();
          dataCalories.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);
          dataCalories.title = Constant.titleCalories;
          if((selectedDateDailyLogClass.caloriesValue ?? 0.0) > 0.0){
            dataCalories.total = selectedDateDailyLogClass.caloriesValue ?? 0;
          }
          dataCalories.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
          dataCalories.dateTime = selectedNewDate;
          dataCalories.type = Constant.typeDaysData;
          dataCalories.displayLabel = selectedDateDailyLogClass.displayLabel;
          dataCalories.activityEndDate = selectedDateDailyLogClass.activityEndDate;
          dataCalories.activityStartDate = selectedDateDailyLogClass.activityStartDate;
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
              dataCalories.serverDetailList.add(data);
            }
          }
          dataCalories.iconPath = Utils.getNumberIconNameFromType(selectedDateDailyLogClass.displayLabel?? Constant.iconBicycling);
          await DataBaseHelper.shared.insertActivityData(dataCalories);
        }



        var dataSteps = getActivityListData().where((element) => element.displayLabel ==
            selectedDateDailyLogClass.displayLabel &&  Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
            Utils.changeDateFormatBasedOnDBDate(selectedDateDailyLogClass.activityStartDateLast ?? DateTime.now())&&
            Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
                Utils.changeDateFormatBasedOnDBDate(selectedDateDailyLogClass.activityEndDateLast ?? DateTime.now())  && element.type == Constant.typeDaysData
            && element.title == Constant.titleSteps).toList();
        if (dataSteps.isNotEmpty) {
          ///Update title 4 data (Sizes)(Steps)
          var dataStepsModels = dataSteps[0];
          // dataStepsModels.total = selectedDateDailyLogClass.stepsTotal ?? 0;

          if(selectedDateDailyLogClass.stepsTotal != null && (selectedDateDailyLogClass.stepsTotal ?? 0) > 0) {
            dataStepsModels.total = selectedDateDailyLogClass.stepsTotal ?? 0;
          }

          dataStepsModels.activityEndDate = selectedDateDailyLogClass.activityEndDate;
          dataStepsModels.activityStartDate = selectedDateDailyLogClass.activityStartDate;

          var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
          if(dataStepsModels.serverDetailList.length != allSelectedServersUrl.length){
            for (int i = 0; i < allSelectedServersUrl.length; i++) {
              var url = dataStepsModels.serverDetailList;
              if(url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty){
                var serverDetail = ServerDetailDataTable();
                serverDetail.serverUrl = allSelectedServersUrl[i].url;
                serverDetail.patientId = allSelectedServersUrl[i].patientId;
                serverDetail.patientName = "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
                serverDetail.objectId = "";
                dataStepsModels.serverDetailList.add(serverDetail);
              }
            }
          }

          await DataBaseHelper.shared.updateActivityData(dataStepsModels);
        }
        else{
          var dataSteps = ActivityTable();
          dataSteps.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);
          dataSteps.title = Constant.titleSteps;
          // dataSteps.total = selectedDateDailyLogClass.stepsTotal ?? 0;
          if((selectedDateDailyLogClass.stepsTotal ?? 0.0) > 0.0){
            dataSteps.total = selectedDateDailyLogClass.stepsTotal ?? 0;
          }
          dataSteps.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
          dataSteps.dateTime = selectedNewDate;
          dataSteps.type = Constant.typeDaysData;
          dataSteps.displayLabel = selectedDateDailyLogClass.displayLabel;
          dataSteps.activityEndDate = selectedDateDailyLogClass.activityEndDate;
          dataSteps.activityStartDate = selectedDateDailyLogClass.activityStartDate;
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
              dataSteps.serverDetailList.add(data);
            }
          }
          dataSteps.iconPath = Utils.getNumberIconNameFromType(selectedDateDailyLogClass.displayLabel?? Constant.iconBicycling);
          await DataBaseHelper.shared.insertActivityData(dataSteps);
        }

        var dataPeakHeart = getActivityListData().where((element) => element.displayLabel ==
            selectedDateDailyLogClass.displayLabel && element.weeksDate == weeksDate &&  Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
            Utils.changeDateFormatBasedOnDBDate(selectedDateDailyLogClass.activityStartDateLast ?? DateTime.now())&&
            Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
                Utils.changeDateFormatBasedOnDBDate(selectedDateDailyLogClass.activityEndDateLast ?? DateTime.now())  && element.type == Constant.typeDaysData
            && element.title == Constant.titleHeartRatePeak).toList();
        if (dataPeakHeart.isNotEmpty) {
          ///Update title 5 Value 1 data (Quantity)(Peak heart rate)
          var peakData = dataPeakHeart[0];
          // peakData.total = selectedDateDailyLogClass.peakHeartValue ?? 0;
          if(selectedDateDailyLogClass.peakHeartValue != null && (selectedDateDailyLogClass.peakHeartValue ?? 0) > 0) {
            peakData.total = selectedDateDailyLogClass.peakHeartValue ?? 0;
          }
          peakData.activityEndDate = selectedDateDailyLogClass.activityEndDate;
          peakData.activityStartDate = selectedDateDailyLogClass.activityStartDate;
          await DataBaseHelper.shared.updateActivityData(peakData);
        }
        else{
          var dataPeakHeart = ActivityTable();
          dataPeakHeart.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);
          dataPeakHeart.title = Constant.titleHeartRatePeak;
          if((selectedDateDailyLogClass.peakHeartValue ?? 0.0) > 0.0){
            dataPeakHeart.total = selectedDateDailyLogClass.peakHeartValue ?? 0;
          }
          dataPeakHeart.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
          dataPeakHeart.dateTime = selectedNewDate;
          dataPeakHeart.type = Constant.typeDaysData;
          dataPeakHeart.displayLabel = selectedDateDailyLogClass.displayLabel;
          dataPeakHeart.activityEndDate = selectedDateDailyLogClass.activityEndDate;
          dataPeakHeart.activityStartDate = selectedDateDailyLogClass.activityStartDate;
          dataPeakHeart.iconPath = Utils.getNumberIconNameFromType(selectedDateDailyLogClass.displayLabel?? Constant.iconBicycling);
          await DataBaseHelper.shared.insertActivityData(dataPeakHeart);
        }

        var smileyDataList = getActivityListData().where((element) => element.displayLabel ==
            selectedDateDailyLogClass.displayLabel  && element.weeksDate == weeksDate
            &&  Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
                Utils.changeDateFormatBasedOnDBDate(selectedDateDailyLogClass.activityStartDateLast ?? DateTime.now())&&
            Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
                Utils.changeDateFormatBasedOnDBDate(selectedDateDailyLogClass.activityEndDateLast ?? DateTime.now())  && element.type == Constant.typeDaysData
            && element.title == null && element.smileyType != null).toList();
        if(smileyDataList.isNotEmpty){
          smileyDataList[0].smileyType = smileyType;
          smileyDataList[0].activityEndDate = selectedDateDailyLogClass.activityEndDate;
          smileyDataList[0].activityStartDate = selectedDateDailyLogClass.activityStartDate;
          await DataBaseHelper.shared.updateActivityData(smileyDataList[0]);
        }
        else{
          var dataSmiley = ActivityTable();
          dataSmiley.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);
          dataSmiley.dateTime = selectedNewDate;
          dataSmiley.title = null;
          dataSmiley.value1 = null;
          dataSmiley.value2 = null;
          dataSmiley.total = null;
          dataSmiley.type = Constant.typeDaysData;
          dataSmiley.displayLabel = selectedDateDailyLogClass.displayLabel;
          dataSmiley.activityEndDate = selectedDateDailyLogClass.activityEndDate;
          dataSmiley.activityStartDate = selectedDateDailyLogClass.activityStartDate;
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
              dataSmiley.serverDetailList.add(data);
            }
          }
          dataSmiley.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
          dataSmiley.smileyType = smileyType;
          await DataBaseHelper.shared.insertActivityData(dataSmiley);
        }


        var activityTypeDataList = getActivityListData()
            .where((element) =>
        element.displayLabel ==
            selectedDateDailyLogClass.displayLabel && element.weeksDate == weeksDate &&
            Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
                Utils.changeDateFormatBasedOnDBDate(selectedDateDailyLogClass.activityStartDateLast ?? DateTime.now())&&
            Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
                Utils.changeDateFormatBasedOnDBDate(selectedDateDailyLogClass.activityEndDateLast ?? DateTime.now()) &&
            element.type == Constant.typeDaysData &&
            element.title == Constant.titleActivityType)
            .toList();
        if (activityTypeDataList.isEmpty) {
          var insertingData = ActivityTable();
          insertingData.displayLabel = selectedDateDailyLogClass.displayLabel;
          insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);
          insertingData.dateTime = selectedNewDate;
          insertingData.activityStartDate = selectedDateDailyLogClass.activityStartDate;
          insertingData.activityEndDate = selectedDateDailyLogClass.activityEndDate;
          insertingData.title = Constant.titleActivityType;
          insertingData.smileyType = null;
          insertingData.total = null;
          insertingData.value1 = null;
          insertingData.value2 = null;
          insertingData.type = Constant.typeDaysData;

          var formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy)
              .format(Utils.findFirstDateOfTheWeekImport(selectedNewDate));
          var formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy)
              .format(Utils.findLastDateOfTheWeekImport(selectedNewDate));

          insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";
          var connectedServerUrl = Utils.getServerListPreference()
              .where((element) => element.patientId != "" && element.isSelected)
              .toList();
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
              "${connectedServerUrl[i].patientFName}${connectedServerUrl[i].patientLName}";
              insertingData.serverDetailList.add(data);
            }
          }
          await DataBaseHelper.shared.insertActivityData(insertingData);
        }else  if(activityTypeDataList.isNotEmpty){
          activityTypeDataList[0].activityEndDate = selectedDateDailyLogClass.activityEndDate;
          activityTypeDataList[0].activityStartDate = selectedDateDailyLogClass.activityStartDate;

          var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
          if(activityTypeDataList[0].serverDetailList.length != allSelectedServersUrl.length){
            for (int i = 0; i < allSelectedServersUrl.length; i++) {
              var url = activityTypeDataList[0].serverDetailList;
              if(url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty){
                var serverDetail = ServerDetailDataTable();
                serverDetail.serverUrl = allSelectedServersUrl[i].url;
                serverDetail.patientId = allSelectedServersUrl[i].patientId;
                serverDetail.patientName = "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
                serverDetail.objectId = "";
                activityTypeDataList[0].serverDetailList.add(serverDetail);
              }
            }
          }

          await DataBaseHelper.shared.updateActivityData(activityTypeDataList[0]);
        }


        var activityParentListData = getActivityListData()
            .where((element) =>
        element.displayLabel ==
            selectedDateDailyLogClass.displayLabel && element.weeksDate == weeksDate &&
            Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
                Utils.changeDateFormatBasedOnDBDate(selectedDateDailyLogClass.activityStartDateLast ?? DateTime.now())&&
            Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
                Utils.changeDateFormatBasedOnDBDate(selectedDateDailyLogClass.activityEndDateLast ?? DateTime.now()) &&
            element.type == Constant.typeDaysData &&
            element.title == Constant.titleParent)
            .toList();
        if (activityParentListData.isEmpty) {
          var insertingData = ActivityTable();
          insertingData.displayLabel = selectedDateDailyLogClass.displayLabel;
          insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);
          insertingData.dateTime = selectedNewDate;
          insertingData.activityStartDate = selectedDateDailyLogClass.activityStartDate;
          insertingData.activityEndDate = selectedDateDailyLogClass.activityEndDate;
          insertingData.title = Constant.titleParent;
          insertingData.smileyType = null;
          insertingData.total = null;
          insertingData.value1 = null;
          insertingData.value2 = null;
          insertingData.type = Constant.typeDaysData;

          var formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy)
              .format(Utils.findFirstDateOfTheWeekImport(selectedNewDate));
          var formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy)
              .format(Utils.findLastDateOfTheWeekImport(selectedNewDate));

          insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";
          var connectedServerUrl = Utils.getServerListPreference()
              .where((element) => element.patientId != "" && element.isSelected)
              .toList();
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
              "${connectedServerUrl[i].patientFName}${connectedServerUrl[i].patientLName}";
              insertingData.serverDetailList.add(data);
            }
          }
          await DataBaseHelper.shared.insertActivityData(insertingData);
        }
        else if(activityParentListData.isNotEmpty){
          activityParentListData[0].activityEndDate = selectedDateDailyLogClass.activityEndDate;
          activityParentListData[0].activityStartDate = selectedDateDailyLogClass.activityStartDate;

          var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
          if(activityParentListData[0].serverDetailList.length != allSelectedServersUrl.length){
            for (int i = 0; i < allSelectedServersUrl.length; i++) {
              var url = activityParentListData[0].serverDetailList;
              if(url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty){
                var serverDetail = ServerDetailDataTable();
                serverDetail.serverUrl = allSelectedServersUrl[i].url;
                serverDetail.patientId = allSelectedServersUrl[i].patientId;
                serverDetail.patientName = "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
                serverDetail.objectId = "";
                activityParentListData[0].serverDetailList.add(serverDetail);
              }
            }
          }

          await DataBaseHelper.shared.updateActivityData(activityParentListData[0]);
        }

      }
      else{
        var connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
        var selectedWeekStartDate = DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findFirstDateOfTheWeekImport(selectedNewDate));
        var selectedWeekEndDate = DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findLastDateOfTheWeekImport(selectedNewDate));

        var activityTableData = ActivityTable();
        activityTableData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);
        activityTableData.title = null;
        if((selectedDateDailyLogClass.modValue ?? 0.0) > 0.0) {
          activityTableData.value1 = selectedDateDailyLogClass.modValue ?? 0;
        }
        if((selectedDateDailyLogClass.vigValue ?? 0.0) > 0.0) {
          activityTableData.value2 = selectedDateDailyLogClass.vigValue ?? 0;
        }
        if((selectedDateDailyLogClass.totalValue ?? 0.0) > 0.0) {
          activityTableData.total = selectedDateDailyLogClass.totalValue ?? 0;
        }
        activityTableData.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
        activityTableData.type = Constant.typeDaysData;
        activityTableData.dateTime = selectedNewDate;
        activityTableData.displayLabel = selectedDateDailyLogClass.displayLabel;
        activityTableData.iconPath = Utils.getNumberIconNameFromType(selectedDateDailyLogClass.displayLabel?? Constant.iconBicycling);
        activityTableData.notes = getDataFromController();
        activityTableData.activityEndDate = selectedDateDailyLogClass.activityEndDate;
        activityTableData.activityStartDate = selectedDateDailyLogClass.activityStartDate;
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
            activityTableData.serverDetailList.add(data);

            var dataMod = ServerDetailDataModMinTable();
            dataMod.modDataSyncServerWise = false;
            dataMod.modObjectId = "";
            dataMod.modServerUrl = connectedServerUrl[i].url;
            dataMod.modPatientId = connectedServerUrl[i].patientId;
            dataMod.modClientId = connectedServerUrl[i].clientId;
            dataMod.modServerToken = connectedServerUrl[i].authToken;
            dataMod.modPatientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
                .patientLName}";
            activityTableData.serverDetailListModMin.add(dataMod);

            var dataVig = ServerDetailDataVigMinTable();
            dataVig.vigDataSyncServerWise = false;
            dataVig.vigObjectId = "";
            dataVig.vigServerUrl = connectedServerUrl[i].url;
            dataVig.vigPatientId = connectedServerUrl[i].patientId;
            dataVig.vigClientId = connectedServerUrl[i].clientId;
            dataVig.vigServerToken = connectedServerUrl[i].authToken;
            dataVig.vigPatientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
                .patientLName}";
            activityTableData.serverDetailListVigMin.add(dataVig);
          }
        }
        await DataBaseHelper.shared.insertActivityData(activityTableData);


        var dataStrength = ActivityTable();
        dataStrength.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);
        dataStrength.title = Constant.titleDaysStr;
        dataStrength.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
        dataStrength.isCheckedDayData = bottomIsCheckedDayData;
        dataStrength.type = Constant.typeDaysData;
        dataStrength.dateTime = selectedNewDate;
        dataStrength.displayLabel = selectedDateDailyLogClass.displayLabel;
        dataStrength.activityEndDate = selectedDateDailyLogClass.activityEndDate;
        dataStrength.activityStartDate = selectedDateDailyLogClass.activityStartDate;
        dataStrength.iconPath = Utils.getNumberIconNameFromType(selectedDateDailyLogClass.displayLabel?? Constant.iconBicycling);
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
            dataStrength.serverDetailList.add(data);
          }
        }
        await DataBaseHelper.shared.insertActivityData(dataStrength);


        var dataCalories = ActivityTable();
        dataCalories.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);
        dataCalories.title = Constant.titleCalories;
        if((selectedDateDailyLogClass.caloriesValue ?? 0.0) > 0.0){
          dataCalories.total = selectedDateDailyLogClass.caloriesValue ?? 0;
        }
        dataCalories.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
        dataCalories.dateTime = selectedNewDate;
        dataCalories.type = Constant.typeDaysData;
        dataCalories.displayLabel = selectedDateDailyLogClass.displayLabel;
        dataCalories.activityEndDate = selectedDateDailyLogClass.activityEndDate;
        dataCalories.activityStartDate = selectedDateDailyLogClass.activityStartDate;
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
            dataCalories.serverDetailList.add(data);
          }
        }
        dataCalories.iconPath = Utils.getNumberIconNameFromType(selectedDateDailyLogClass.displayLabel?? Constant.iconBicycling);
        await DataBaseHelper.shared.insertActivityData(dataCalories);


        var dataSteps = ActivityTable();
        dataSteps.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);
        dataSteps.title = Constant.titleSteps;
        if((selectedDateDailyLogClass.stepsTotal ?? 0.0) > 0.0){
          dataSteps.total = selectedDateDailyLogClass.stepsTotal ?? 0;
        }
        dataSteps.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
        dataSteps.dateTime = selectedNewDate;
        dataSteps.type = Constant.typeDaysData;
        dataSteps.displayLabel = selectedDateDailyLogClass.displayLabel;
        dataSteps.activityEndDate = selectedDateDailyLogClass.activityEndDate;
        dataSteps.activityStartDate = selectedDateDailyLogClass.activityStartDate;
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
            dataSteps.serverDetailList.add(data);
          }
        }
        dataSteps.iconPath = Utils.getNumberIconNameFromType(selectedDateDailyLogClass.displayLabel?? Constant.iconBicycling);
        await DataBaseHelper.shared.insertActivityData(dataSteps);


        var dataRestHeart = ActivityTable();
        dataRestHeart.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);
        dataRestHeart.title = Constant.titleHeartRateRest;
        if((selectedDateDailyLogClass.restHeartValue ?? 0.0) > 0.0){
          dataRestHeart.total = selectedDateDailyLogClass.restHeartValue ?? 0;
        }
        dataRestHeart.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
        dataRestHeart.dateTime = selectedNewDate;
        dataRestHeart.type = Constant.typeDaysData;
        dataRestHeart.displayLabel = selectedDateDailyLogClass.displayLabel;
        dataRestHeart.activityEndDate = selectedDateDailyLogClass.activityEndDate;
        dataRestHeart.activityStartDate = selectedDateDailyLogClass.activityStartDate;
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
            dataRestHeart.serverDetailList.add(data);
          }
        }
        dataRestHeart.iconPath = Utils.getNumberIconNameFromType(selectedDateDailyLogClass.displayLabel?? Constant.iconBicycling);
        await DataBaseHelper.shared.insertActivityData(dataRestHeart);


        var dataPeakHeart = ActivityTable();
        dataPeakHeart.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);
        dataPeakHeart.title = Constant.titleHeartRatePeak;
        if((selectedDateDailyLogClass.peakHeartValue ?? 0.0) > 0.0){
          dataPeakHeart.total = selectedDateDailyLogClass.peakHeartValue ?? 0;
        }
        dataPeakHeart.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
        dataPeakHeart.dateTime = selectedNewDate;
        dataPeakHeart.type = Constant.typeDaysData;
        dataPeakHeart.displayLabel = selectedDateDailyLogClass.displayLabel;
        dataPeakHeart.activityEndDate = selectedDateDailyLogClass.activityEndDate;
        dataPeakHeart.activityStartDate = selectedDateDailyLogClass.activityStartDate;
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
            dataPeakHeart.serverDetailList.add(data);
          }
        }
        dataPeakHeart.iconPath = Utils.getNumberIconNameFromType(selectedDateDailyLogClass.displayLabel?? Constant.iconBicycling);
        await DataBaseHelper.shared.insertActivityData(dataPeakHeart);


        var dataSmiley = ActivityTable();
        dataSmiley.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);
        dataSmiley.dateTime = selectedNewDate;
        dataSmiley.title = null;
        dataSmiley.value1 = null;
        dataSmiley.value2 = null;
        dataSmiley.total = null;
        dataSmiley.type = Constant.typeDaysData;
        dataSmiley.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
        dataSmiley.smileyType = smileyType;
        dataSmiley.displayLabel = selectedDateDailyLogClass.displayLabel;
        dataSmiley.activityEndDate = selectedDateDailyLogClass.activityEndDate;
        dataSmiley.activityStartDate = selectedDateDailyLogClass.activityStartDate;
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
            dataSmiley.serverDetailList.add(data);
          }
        }
        await DataBaseHelper.shared.insertActivityData(dataSmiley);


        var activityTypeData = ActivityTable();
        activityTypeData.displayLabel = selectedDateDailyLogClass.displayLabel;
        activityTypeData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);
        activityTypeData.dateTime = selectedNewDate;
        activityTypeData.activityStartDate = selectedDateDailyLogClass.activityStartDate;
        activityTypeData.activityEndDate = selectedDateDailyLogClass.activityEndDate;
        activityTypeData.title = Constant.titleActivityType;
        activityTypeData.smileyType = null;
        activityTypeData.total = null;
        activityTypeData.value1 = null;
        activityTypeData.value2 = null;
        activityTypeData.type = Constant.typeDaysData;
        activityTypeData.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
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
            "${connectedServerUrl[i].patientFName}${connectedServerUrl[i].patientLName}";
            activityTypeData.serverDetailList.add(data);
          }
        }
        await DataBaseHelper.shared.insertActivityData(activityTypeData);



        var parentData = ActivityTable();
        parentData.displayLabel = selectedDateDailyLogClass.displayLabel;
        parentData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);
        parentData.dateTime = selectedNewDate;
        parentData.activityStartDate = selectedDateDailyLogClass.activityStartDate;
        parentData.activityEndDate = selectedDateDailyLogClass.activityEndDate;
        parentData.title = Constant.titleParent;
        parentData.smileyType = null;
        parentData.total = null;
        parentData.value1 = null;
        parentData.value2 = null;
        parentData.type = Constant.typeDaysData;
        parentData.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
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
            "${connectedServerUrl[i].patientFName}${connectedServerUrl[i].patientLName}";
            parentData.serverDetailList.add(data);
          }
        }
        await DataBaseHelper.shared.insertActivityData(parentData);

        // insertDayLevelDataUpdate(selectedWeekStartDate,selectedWeekEndDate);
      }

      Get.back();
      bottomIsCheckedDay = false;


      /// Now It will start for days data insert or update
      await insertHigherLevelOfActivity(selectedWeekStartDate,selectedWeekEndDate,selectedDateDailyLogClass);

      /// Now It will start for weeks data insert or update
      await insertHigherLevelOfDay(selectedWeekStartDate,selectedWeekEndDate,selectedDateDailyLogClass);

      Get.back();
      bottomIsCheckedDayData = false;
      update();

      if(!kIsWeb) {
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
          if (hasPermissions!) {
            await GetSetHealthData.realTimeExportDataFromHealth();
          }
          Debug.printLog("Home screen health permission...$hasPermissions");
        } catch (e) {
          Debug.printLog(
              "Home screen health Import export issue try catch.....$e");
        }
      }

      ///Start API call for Update Time
      var displayName = selectedDateDailyLogClass.displayLabel ?? "";

      var activityDataTableList = getActivityListData();
      var totalMinData = activityDataTableList
          .where((element) =>
      element.type == Constant.typeDaysData &&
          element.title == null &&
          element.smileyType == null &&
          element.total != null &&
          element.displayLabel == displayName &&
          Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
              Utils.changeDateFormatBasedOnDBDate(selectedDateDailyLogClass.activityEndDate)
          && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
          Utils.changeDateFormatBasedOnDBDate(selectedDateDailyLogClass.activityStartDate))
          .toList();
      if(totalMinData.isNotEmpty) {
        if((totalMinData[0].total ?? 0.0) > 0.0 && totalMinData[0].total != null) {
          await Syncing.createChildActivityTotalMinObservation(
              displayName,
              totalMinData[0]);
        }

        if((totalMinData[0].value1 ?? 0.0) > 0.0 && totalMinData[0].value1 != null) {
          await Syncing.createChildActivityModerateMinObservation(
              displayName,
              totalMinData[0]);
        }

        if((totalMinData[0].value2 ?? 0.0) > 0.0 && totalMinData[0].value2 != null) {
          await Syncing.createChildActivityVigMinObservation(
              displayName,
              totalMinData[0]);
        }
      }

      var activityTypeDataList = getActivityListData()
          .where((element) =>
      element.type == Constant.typeDaysData &&
          element.title == Constant.titleActivityType &&
          element.displayLabel == displayName &&
          Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
              Utils.changeDateFormatBasedOnDBDate(selectedDateDailyLogClass.activityEndDate)
          && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
          Utils.changeDateFormatBasedOnDBDate(selectedDateDailyLogClass.activityStartDate))
          .toList();
      if(activityTypeDataList.isNotEmpty) {
        await Syncing.createChildActivityNameObservation(
            displayName,
            activityTypeDataList[0]);
      }

      var activityCaloriesData = getActivityListData().where((element) => element.displayLabel ==
          displayName &&
          Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
          Utils.changeDateFormatBasedOnDBDate(selectedDateDailyLogClass.activityEndDate)
          && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
              Utils.changeDateFormatBasedOnDBDate(selectedDateDailyLogClass.activityStartDate)&&
          element.type == Constant.typeDaysData
          && element.title == Constant.titleCalories).toList();
      if(activityCaloriesData.isNotEmpty) {
        if((activityCaloriesData[0].total ?? 0.0) > 0.0 && activityCaloriesData[0].total != null) {
          await Syncing.createChildActivityCaloriesObservation(displayName,
              activityCaloriesData[0]);
        }
      }

      var activityStepData = getActivityListData().where((element) => element.displayLabel ==
          displayName &&
          Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
          Utils.changeDateFormatBasedOnDBDate(selectedDateDailyLogClass.activityEndDate)
          && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
              Utils.changeDateFormatBasedOnDBDate(selectedDateDailyLogClass.activityStartDate)&&
          element.type == Constant.typeDaysData
          && element.title == Constant.titleSteps).toList();
      if(activityStepData.isNotEmpty) {
        if((activityStepData[0].total ?? 0.0) > 0.0 && activityStepData[0].total != null) {
          await Syncing.createChildActivityStepsObservation(displayName,
              activityStepData[0]);
        }
      }

      var checkedListForInsertData = getActivityListData()
          .where((element) =>
          Utils.changeDateFormatBasedOnDBDate(
              element.activityEndDate ?? DateTime.now()) ==
              Utils.changeDateFormatBasedOnDBDate(
                  selectedDateDailyLogClass.activityEndDate) &&
          Utils.changeDateFormatBasedOnDBDate(
              element.activityStartDate ?? DateTime.now()) ==
              Utils.changeDateFormatBasedOnDBDate(
                  selectedDateDailyLogClass.activityStartDate) &&
          element.type == Constant.typeDaysData &&
          element.title == null &&
          element.smileyType != null &&
          element.total == null &&
          element.displayLabel == displayName)
          .toList();
      Debug.printLog("lenght.....${checkedListForInsertData.length}");
      if (checkedListForInsertData.isNotEmpty) {
        await Syncing.createChildActivityExObservation(
            displayName, checkedListForInsertData[0]);
      }

      var activityPeakHeartRate = getActivityListData().where((element) => element.displayLabel ==
          displayName &&
          Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
          Utils.changeDateFormatBasedOnDBDate(selectedDateDailyLogClass.activityEndDate)
          && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
              Utils.changeDateFormatBasedOnDBDate(selectedDateDailyLogClass.activityStartDate)
          && element.type == Constant.typeDaysData
          && element.title == Constant.titleHeartRatePeak).toList();
      if(activityPeakHeartRate.isNotEmpty) {
        if((activityPeakHeartRate[0].total ?? 0.0) > 0.0 && activityPeakHeartRate[0].total != null) {
          await Syncing.createChildActivityPeakHeatRateObservation(
              displayName,
              activityPeakHeartRate[0]);
        }
      }



      var activityParentListData = getActivityListData().where((element) => element.displayLabel ==
          displayName  && Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
          Utils.changeDateFormatBasedOnDBDate(selectedDateDailyLogClass.activityEndDate)
          && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
              Utils.changeDateFormatBasedOnDBDate(selectedDateDailyLogClass.activityStartDate)
          && element.type == Constant.typeDaysData
          && element.title == Constant.titleParent).toList();
      if(activityParentListData.isNotEmpty) {
        await Syncing.createParentActivityObservation(
            activityParentListData[0]);
      }
      selectedDateDailyLogClass.activityStartDate = DateTime.now();
      selectedDateDailyLogClass.activityEndDate = DateTime.now();
      update();
    }else{
      Utils.showToast(Get.context!, "Invalid dates");
    }


  }

  insertHigherLevelOfActivity(String selectedWeekStartDate, String selectedWeekEndDate, DailyLogClass selectedDateDailyLogClass) async {
    ///Day level
    List<ActivityTable> activityDataListFor = Hive.box<ActivityTable>(Constant.tableActivity).values.toList().where((element) => element.type == Constant.typeDaysData
        && element.date == DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate)).toList();

    var dailyData = Hive.box<ActivityTable>(Constant.tableActivity).values.toList();

    var weekInsertedData = dailyData.where((element) =>
    element.date == DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate)
        && element.type == Constant.typeDay &&
        element.title == null && element.smileyType == null).toList();
    if(weekInsertedData.isNotEmpty){

      var modValue = 0.0;
      var vigValue = 0.0;
      var totalValue = 0.0;
      for (int i = 0; i < activityDataListFor.length; i++) {
        if(activityDataListFor[i].title == null && activityDataListFor[i].smileyType == null){
          modValue += activityDataListFor[i].value1 ?? 0.0;
          vigValue += activityDataListFor[i].value2 ?? 0.0;
          totalValue += activityDataListFor[i].total ?? 0.0;
        }
      }

      if(modValue == 0.0){
        weekInsertedData[0].value1 = null;
      }else{
        weekInsertedData[0].value1 = modValue;
      }

      if(vigValue == 0.0){
        weekInsertedData[0].value2 = null;
      }else{
        weekInsertedData[0].value2 = vigValue;
      }

      if(totalValue == 0.0){
        weekInsertedData[0].total = null;
      }else{
        weekInsertedData[0].total = totalValue;
      }
      // weekInsertedData[0].notes = selectedDateDailyLogClass.notesValues.toString();

      await DataBaseHelper.shared.updateActivityData(weekInsertedData[0]);
    }
    else{
      var insertingData = ActivityTable();
      insertingData.isOverride = false;

      insertingData.name = "";
      insertingData.dateTime = selectedNewDate;
      insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);
      // insertingData.notes = selectedDateDailyLogClass.notesValues.toString();
      insertingData.title = null;
      if(selectedDateDailyLogClass.modValue == 0.0){
        insertingData.value1 = null;
      }else{
        if(selectedDateDailyLogClass.modValue != null) {
          insertingData.value1 =
              double.parse(selectedDateDailyLogClass.modValue.toString());
        }
      }

      if(selectedDateDailyLogClass.vigValue == 0.0) {
        insertingData.value2 = null;
      }else {
        if(selectedDateDailyLogClass.vigValue != null) {
          insertingData.value2 =
              double.parse(selectedDateDailyLogClass.vigValue.toString());
        }
      }

      if(selectedDateDailyLogClass.totalValue == 0.0) {
        insertingData.total = null;
      }else{
        if(selectedDateDailyLogClass.totalValue != null) {
          insertingData.total =
              double.parse(selectedDateDailyLogClass.totalValue.toString());
        }
      }

      insertingData.type = Constant.typeDay;
      insertingData.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
      await DataBaseHelper.shared.insertActivityData(insertingData);
    }

    var dayStr = dailyData.where((element) =>
    element.date == DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate)
        && element.type == Constant.typeDay &&
        element.title == Constant.titleDaysStr).toList();
    if(dayStr.isNotEmpty ){
      List<ActivityTable> activityDataListFor = Hive.box<ActivityTable>(Constant.tableActivity).values.toList().where((element) => element.type == Constant.typeDaysData
          && element.date == DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate) &&
      element.title == Constant.titleDaysStr && (element.isCheckedDayData ?? false)).toList();
      if(activityDataListFor.isNotEmpty){
        dayStr[0].isCheckedDay = true;
      }else{
        dayStr[0].isCheckedDay = false;
      }

      var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" &&
          element.isSelected).toList();
      if(dayStr[0].serverDetailList.length != allSelectedServersUrl.length){
        for (int i = 0; i < allSelectedServersUrl.length; i++) {
          var url = dayStr[0].serverDetailList;
          if(url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty){
            var serverDetail = ServerDetailDataTable();
            serverDetail.serverUrl = allSelectedServersUrl[i].url;
            serverDetail.patientId = allSelectedServersUrl[i].patientId;
            serverDetail.patientName = "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
            serverDetail.objectId = "";
            dayStr[0].serverDetailList.add(serverDetail);
          }
        }
      }

      await DataBaseHelper.shared.updateActivityData(dayStr[0]);
    }
    else{
      var insertCheckBoxDayData = ActivityTable();
      insertCheckBoxDayData.title = Constant.titleDaysStr;
      insertCheckBoxDayData.dateTime = selectedNewDate;
      insertCheckBoxDayData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);
      insertCheckBoxDayData.displayLabel = selectedDateDailyLogClass.displayLabel;
      insertCheckBoxDayData.total = null;
      insertCheckBoxDayData.type = Constant.typeDay;
      insertCheckBoxDayData.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
      insertCheckBoxDayData.isCheckedDay = selectedDateDailyLogClass.isCheckedDayData;

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
          insertCheckBoxDayData.serverDetailList.add(serverDetail);
        }
      }

      await DataBaseHelper.shared.insertActivityData(insertCheckBoxDayData);
    }

    var caloriesDayData = dailyData.where((element) =>
    element.date == DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate)
        && element.type == Constant.typeDay &&
        element.title == Constant.titleCalories).toList();
    if(caloriesDayData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.title = Constant.titleCalories;

      insertingData.dateTime = selectedNewDate;
      insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);


      if(selectedDateDailyLogClass.caloriesValue == 0.0){
        insertingData.total = null;
      }else{
        if(selectedDateDailyLogClass.caloriesValue != null) {
          insertingData.total =
              double.parse(selectedDateDailyLogClass.caloriesValue.toString());
        }
      }


      insertingData.type = Constant.typeDay;
      insertingData.isSync = false;

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

      if(totalValue == 0.0){
        caloriesDayData[0].total = null;
      }else{
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

    var stepsDayData = dailyData.where((element) =>
    element.date == DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate)
        && element.type == Constant.typeDay &&
        element.title == Constant.titleSteps).toList();
    if(stepsDayData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.title = Constant.titleSteps;

      insertingData.dateTime = selectedNewDate;
      insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);


      if(selectedDateDailyLogClass.stepsTotal == 0.0){
        insertingData.total = null;
      }else{
        if(selectedDateDailyLogClass.stepsTotal != null) {
          insertingData.total =
              double.parse(selectedDateDailyLogClass.stepsTotal.toString());
        }
      }


      insertingData.type = Constant.typeDay;
      insertingData.isSync = false;

      insertingData.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
      insertingData.needExport = true;
      var connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();

      // var connectedServerUrl = Utils.getServerListPreference();
      if(connectedServerUrl.isNotEmpty) {
        for (int i = 0; i < connectedServerUrl.length; i++) {
          // insertingData.dataSyncServerWiseList.add(false);
          // insertingData.objectIdList.add("");
          // insertingData.serverUrlList.add(connectedServerUrl[i].url);
          // insertingData.patientIdList.add(connectedServerUrl[i].patientId);
          // insertingData.clientIdList.add(connectedServerUrl[i].clientId);
          // insertingData.patientNameList.add(
          //     "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
          //         .patientLName}");
          // insertingData.serverTokenList.add(connectedServerUrl[i].authToken);
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

      // stepsDayData[0].dataSyncServerWiseList = [];
      // await DataBaseHelper.shared.updateActivityData(stepsDayData[0]);

      var totalValue = 0.0;
      for (int i = 0; i < activityDataListFor.length; i++) {
        if(activityDataListFor[i].title == Constant.titleSteps){
          totalValue += activityDataListFor[i].total ?? 0.0;
        }
      }

      if(totalValue == 0.0){
        stepsDayData[0].total = null;
      }else{
        stepsDayData[0].total = totalValue;
      }

      var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
      if(stepsDayData[0].serverDetailList.length != allSelectedServersUrl.length){
        for (int i = 0; i < allSelectedServersUrl.length; i++) {
          var url = stepsDayData[0].serverDetailList;
          if(url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty){
            var serverDetail = ServerDetailDataTable();
            serverDetail.serverUrl = allSelectedServersUrl[i].url;
            serverDetail.patientId = allSelectedServersUrl[i].patientId;
            serverDetail.patientName = "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
            serverDetail.objectId = "";
            stepsDayData[0].serverDetailList.add(serverDetail);
          }
        }
      }
      stepsDayData[0].isSync = false;
      stepsDayData[0].needExport = true;
      await DataBaseHelper.shared.updateActivityData(stepsDayData[0]);

    }

    var restHeartDayData = dailyData.where((element) =>
    element.date == DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate)
        && element.type == Constant.typeDay &&
        element.title == Constant.titleHeartRateRest).toList();
    if(restHeartDayData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.title = Constant.titleHeartRateRest;

      insertingData.dateTime = selectedNewDate;
      insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);


      if(selectedDateDailyLogClass.restHeartValue == 0.0){
        insertingData.total = null;
      }else{
        if(selectedDateDailyLogClass.restHeartValue != null) {
          insertingData.total =
              double.parse(selectedDateDailyLogClass.restHeartValue.toString());
        }
      }


      insertingData.type = Constant.typeDay;
      insertingData.isSync = false;

      insertingData.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
      insertingData.needExport = true;
      var connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();

      // var connectedServerUrl = Utils.getServerListPreference();
      if(connectedServerUrl.isNotEmpty) {
        for (int i = 0; i < connectedServerUrl.length; i++) {
          // insertingData.dataSyncServerWiseList.add(false);
          // insertingData.objectIdList.add("");
          // insertingData.serverUrlList.add(connectedServerUrl[i].url);
          // insertingData.patientIdList.add(connectedServerUrl[i].patientId);
          // insertingData.clientIdList.add(connectedServerUrl[i].clientId);
          // insertingData.patientNameList.add(
          //     "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
          //         .patientLName}");
          // insertingData.serverTokenList.add(connectedServerUrl[i].authToken);
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

      // restHeartDayData[0].dataSyncServerWiseList = [];
      // await DataBaseHelper.shared.updateActivityData(restHeartDayData[0]);

      var totalValue = 0.0;
      for (int i = 0; i < activityDataListFor.length; i++) {
        if(activityDataListFor[i].title == Constant.titleHeartRateRest){
          totalValue += activityDataListFor[i].total ?? 0.0;
        }
      }

      if(totalValue == 0.0){
        restHeartDayData[0].total = null;
      }else{
        restHeartDayData[0].total = totalValue;
      }

      List<int> tempIntList = [];
      var avgTotal = 0;
      for( int i = 0;i< activityDataListFor.length;i++){
        if(activityDataListFor[i].title == Constant.titleHeartRateRest && activityDataListFor[i].total != 0  ) {
          tempIntList.add((activityDataListFor[i].total ?? 0).toInt());
          avgTotal += (activityDataListFor[i].total ?? 0).toInt();
        }
      }
      if(tempIntList.isNotEmpty) {
        var min = tempIntList.reduce((a, b) => a < b ? a : b);
        var max = tempIntList.reduce((a, b) => a > b ? a : b);

        var totalFilledDataList = activityDataListFor.where((element) => element.total != 0 && element.title == Constant.titleHeartRateRest).toList();
        if(totalFilledDataList.isNotEmpty){
          avgTotal = avgTotal ~/ totalFilledDataList.length;
        }
        Debug.printLog(
            "totalFilledDataList.... $min $max $avgTotal  ${totalFilledDataList.length}");
      }
      restHeartDayData[0].total = avgTotal.toDouble();

      var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();

      // for (int i = 0; i < allSelectedServersUrl.length; i++) {
      //   restHeartDayData[0].dataSyncServerWiseList.add(false);
      // }
      //
      // if(restHeartDayData[0].serverUrlList.length != allSelectedServersUrl.length){
      //   for (int i = 0; i < allSelectedServersUrl.length; i++) {
      //     var url = restHeartDayData[0].serverUrlList;
      //     if(!url.contains(allSelectedServersUrl[i].url)){
      //       restHeartDayData[0].serverUrlList.add(allSelectedServersUrl[i].url);
      //       restHeartDayData[0].patientIdList.add(allSelectedServersUrl[i].patientId);
      //       restHeartDayData[0].patientNameList.add("${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}");
      //       restHeartDayData[0].objectIdList.add("");
      //     }
      //   }
      // }

      if(restHeartDayData[0].serverDetailList.length != allSelectedServersUrl.length){
        for (int i = 0; i < allSelectedServersUrl.length; i++) {
          var url = restHeartDayData[0].serverDetailList;
          if(url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty){
            var serverDetail = ServerDetailDataTable();
            serverDetail.serverUrl = allSelectedServersUrl[i].url;
            serverDetail.patientId = allSelectedServersUrl[i].patientId;
            serverDetail.patientName = "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
            serverDetail.objectId = "";
            restHeartDayData[0].serverDetailList.add(serverDetail);
          }
        }
      }
      restHeartDayData[0].isSync = false;
      restHeartDayData[0].needExport = true;
      await DataBaseHelper.shared.updateActivityData(restHeartDayData[0]);

    }

    var peakHeartDayData = dailyData.where((element) =>
    element.date == DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate)
        && element.type == Constant.typeDay &&
        element.title == Constant.titleHeartRatePeak).toList();
    if(peakHeartDayData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.title = Constant.titleHeartRatePeak;

      insertingData.dateTime = selectedNewDate;
      insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);


      if(selectedDateDailyLogClass.peakHeartValue == 0.0){
        insertingData.total = null;
      }else{
        insertingData.total = double.parse(selectedDateDailyLogClass.peakHeartValue.toString());
      }


      insertingData.type = Constant.typeDay;
      insertingData.isSync = false;

      insertingData.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
      insertingData.needExport = true;
      var connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
      if(connectedServerUrl.isNotEmpty) {
        for (int i = 0; i < connectedServerUrl.length; i++) {
          // insertingData.dataSyncServerWiseList.add(false);
          // insertingData.objectIdList.add("");
          // insertingData.serverUrlList.add(connectedServerUrl[i].url);
          // insertingData.patientIdList.add(connectedServerUrl[i].patientId);
          // insertingData.clientIdList.add(connectedServerUrl[i].clientId);
          // insertingData.patientNameList.add(
          //     "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
          //         .patientLName}");
          // insertingData.serverTokenList.add(connectedServerUrl[i].authToken);
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
      List<int> tempIntList = [];
      for( int i = 0;i<activityDataListFor.length;i++){
        if(activityDataListFor[i].title == Constant.titleHeartRatePeak && activityDataListFor[i].total != 0  ) {
          tempIntList.add((activityDataListFor[i].total ?? 0).toInt());
        }
      }
      var min = 0;
      var max = 0;
      if(tempIntList.isNotEmpty) {
        min = tempIntList.reduce((a, b) => a < b ? a : b);
        max = tempIntList.reduce((a, b) => a > b ? a : b);
        Debug.printLog("min max week level .... title 6...$min $max");
      }
      peakHeartDayData[0].total = max.toDouble();

      var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
      if(peakHeartDayData[0].serverDetailList.length != allSelectedServersUrl.length){
        for (int i = 0; i < allSelectedServersUrl.length; i++) {
          var url = peakHeartDayData[0].serverDetailList;
          if(url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty){
            var serverDetail = ServerDetailDataTable();
            serverDetail.serverUrl = allSelectedServersUrl[i].url;
            serverDetail.patientId = allSelectedServersUrl[i].patientId;
            serverDetail.patientName = "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
            serverDetail.objectId = "";
            peakHeartDayData[0].serverDetailList.add(serverDetail);
          }
        }
      }
      peakHeartDayData[0].isSync = false;
      peakHeartDayData[0].needExport = true;
      await DataBaseHelper.shared.updateActivityData(peakHeartDayData[0]);

    }

   /* var checkedListForInsertData = dailyData.where((element) =>
    element.date == DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate) &&
        element.type == Constant.typeDay && element.title == null && element.smileyType != null).toList();
    if(checkedListForInsertData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.dateTime = selectedNewDate;
      insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);
      insertingData.title = null;
      insertingData.value1 = null;
      insertingData.value2 = null;
      insertingData.total = null;
      insertingData.type = Constant.typeDay;
      insertingData.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
      insertingData.smileyType = selectedDateDailyLogClass.smileyType ?? Constant.defaultSmileyType;

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
      checkedListForInsertData[0].smileyType = selectedDateDailyLogClass.smileyType;


      var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
      if(checkedListForInsertData[0].serverDetailList.length != allSelectedServersUrl.length){
        for (int i = 0; i < allSelectedServersUrl.length; i++) {
          var url = checkedListForInsertData[0].serverDetailList;
          if(url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty){
            var serverDetail = ServerDetailDataTable();
            serverDetail.serverUrl = allSelectedServersUrl[i].url;
            serverDetail.patientId = allSelectedServersUrl[i].patientId;
            serverDetail.patientName = "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
            serverDetail.objectId = "";
            checkedListForInsertData[0].serverDetailList.add(serverDetail);
          }
        }
      }
      await DataBaseHelper.shared.updateActivityData(checkedListForInsertData[0]);
    }*/


    /// API call for day level after syncing Activity level
    var allDataFromDB = getActivityListData();
    var totalMinList= allDataFromDB.where((element) =>
        element.title == null &&
        element.smileyType == null &&
        element.type == Constant.typeDay && element.total != null && Utils.changeDateFormatBasedOnDBDateWithOutTIme(
        element.dateTime ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDateWithOutTIme(
        selectedNewDate
    ) ).toList();
    if(totalMinList.isNotEmpty){
      List<SyncMonthlyActivityData> totalData = [];
      totalData.add(SyncMonthlyActivityData(
          "",
          totalMinList[0].total ?? 0.0,
          Utils.changeDateFormatBasedOnDBDateWithOutTIme(
              totalMinList[0].dateTime ?? DateTime.now()),
          null,
          totalMinList[0].key,
          Constant.totalMinPerDay,
          true,
          totalMinList[0].objectId,notesDayLevel: totalMinList[0].notes ?? ""));
      await Syncing.observationSyncDataTotalMin(totalData);
    }

    var modMinList= allDataFromDB.where((element) =>
        element.title == null &&
        element.smileyType == null &&
        element.type == Constant.typeDay
        && element.value1 != null && Utils.changeDateFormatBasedOnDBDateWithOutTIme(
        element.dateTime ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDateWithOutTIme(
        selectedNewDate
    ) ).toList();
    if(modMinList.isNotEmpty){
      List<SyncMonthlyActivityData> modData = [];
      modData.add(SyncMonthlyActivityData(
          "",
          modMinList[0].value1 ?? 0.0,
          Utils.changeDateFormatBasedOnDBDateWithOutTIme(
              modMinList[0].dateTime ?? DateTime.now()),
          null,
          modMinList[0].key,
          Constant.modMinPerDay,
          true,
          modMinList[0].objectId));
      await Syncing.observationSyncDataModMin(modData);
    }

    var vigMinList= allDataFromDB.where((element) =>
        element.title == null &&
        element.smileyType == null &&
        element.type == Constant.typeDay && element.value2 != null && Utils.changeDateFormatBasedOnDBDateWithOutTIme(
        element.dateTime ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDateWithOutTIme(
            selectedNewDate
    ) ).toList();
    if(vigMinList.isNotEmpty){
      List<SyncMonthlyActivityData> vigData = [];
      vigData.add(SyncMonthlyActivityData(
          "",
          vigMinList[0].value2 ?? 0.0,
          Utils.changeDateFormatBasedOnDBDateWithOutTIme(
              vigMinList[0].dateTime ?? DateTime.now()),
          null,
          vigMinList[0].key,
          Constant.vigMinPerDay,
          true,
          vigMinList[0].objectId));
      await Syncing.observationSyncDataVigMin(vigData);
    }

    var calData = allDataFromDB.where((element) =>
        element.title == Constant.titleCalories &&
        element.type == Constant.typeDay && element.total != null && Utils.changeDateFormatBasedOnDBDateWithOutTIme(
        element.dateTime ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDateWithOutTIme(
        selectedNewDate
    ) ).toList();
    if(calData.isNotEmpty){
      List<SyncMonthlyActivityData> caloriesDataList = [];
      caloriesDataList.add(SyncMonthlyActivityData(
          "",
          calData[0].total ?? 0.0,
          calData[0].dateTime,
          null,
          calData[0].key,
          Constant.titleCalories,
          true,
          calData[0].objectId));
      await Syncing.observationSyncDataCalories(caloriesDataList);
    }

    var stepsData = allDataFromDB.where((element) =>
        element.title == Constant.titleSteps &&
        element.type == Constant.typeDay && element.total != null
        && Utils.changeDateFormatBasedOnDBDateWithOutTIme(
        element.dateTime ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDateWithOutTIme(
        selectedNewDate
    ) ).toList();
    if(stepsData.isNotEmpty){
      List<SyncMonthlyActivityData> stepsDataList = [];
      stepsDataList.add(SyncMonthlyActivityData(
          "",
          stepsData[0].total ?? 0.0,
          stepsData[0].dateTime,
          null,
          stepsData[0].key,
          Constant.titleSteps,
          true,
          stepsData[0].objectId));
      await Syncing.observationSyncDataSteps(stepsDataList);
    }

    var heartRateRestData = allDataFromDB.where((element) =>
        element.title == Constant.titleHeartRateRest &&
        element.type == Constant.typeDay && element.total != null
        && Utils.changeDateFormatBasedOnDBDateWithOutTIme(
        element.dateTime ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDateWithOutTIme(
        selectedNewDate
    )).toList();
    if(heartRateRestData.isNotEmpty){
      List<SyncMonthlyActivityData> heartRateRestDataList = [];
      heartRateRestDataList.add(SyncMonthlyActivityData(
          "",
          heartRateRestData[0].total ?? 0.0,
          heartRateRestData[0].dateTime,
          null,
          heartRateRestData[0].key,
          Constant.titleHeartRateRest,
          true,
          heartRateRestData[0].objectId));
      await Syncing.observationSyncDataRestHeart(heartRateRestDataList);
    }

    var heartRatePeakData = allDataFromDB.where((element) =>
        element.title == Constant.titleHeartRatePeak &&
        element.type == Constant.typeDay && element.total != null
        && Utils.changeDateFormatBasedOnDBDateWithOutTIme(
        element.dateTime ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDateWithOutTIme(
        selectedNewDate
    )).toList();
    if(heartRatePeakData.isNotEmpty){
      List<SyncMonthlyActivityData> heartRatePeakDataList = [];
      heartRatePeakDataList.add(SyncMonthlyActivityData(
          "",
          heartRatePeakData[0].total ?? 0.0,
          heartRatePeakData[0].dateTime,
          null,
          heartRatePeakData[0].key,
          Constant.titleHeartRatePeak,
          true,
          heartRatePeakData[0].objectId));
      await Syncing.observationSyncDataPeakHeart(heartRatePeakDataList);
    }
  }

  insertHigherLevelOfDay(String selectedWeekStartDate, String selectedWeekEndDate, DailyLogClass selectedDateDailyLogClass) async {
    ///Week level
    var dataListHive = Hive.box<ActivityTable>(Constant.tableActivity).values.toList();
    var weekDate =  "$selectedWeekStartDate-$selectedWeekEndDate";

    List<ActivityTable> dailyDataList = Hive.box<ActivityTable>(Constant.tableActivity).values.toList().where((element) => element.type == Constant.typeDay
        && element.weeksDate == weekDate).toList();


    var activityWeeklyDataList = dataListHive
        .where((element) =>
    element.weeksDate == weekDate &&
        element.type == Constant.typeWeek && element.title == null && element.displayLabel == null && element.smileyType == null)
        .toList();
    if(activityWeeklyDataList.isEmpty){
      var insertingData = ActivityTable();
      insertingData.isOverride = false;
      insertingData.name = "";
      insertingData.title = null;
      if(selectedDateDailyLogClass.modValue == 0.0){
        insertingData.value1 = null;
      }else{
        if(selectedDateDailyLogClass.modValue != null) {
          insertingData.value1 =
              double.parse(selectedDateDailyLogClass.modValue.toString());
        }
      }

      if(selectedDateDailyLogClass.vigValue == 0.0) {
        insertingData.value2 = null;
      }else {
        if(selectedDateDailyLogClass.vigValue != null) {
          insertingData.value2 =
              double.parse(selectedDateDailyLogClass.vigValue.toString());
        }
      }

      if(selectedDateDailyLogClass.totalValue == 0.0) {
        insertingData.total = null;
      }else{
        if(selectedDateDailyLogClass.totalValue != null) {
          insertingData.total =
              double.parse(selectedDateDailyLogClass.totalValue.toString());
        }
      }
      insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);
      insertingData.type = Constant.typeWeek;
      insertingData.weeksDate =  weekDate;
      await DataBaseHelper.shared.insertActivityData(insertingData);
    }
    else{
      var modValue = 0.0;
      var vigValue = 0.0;
      var totalValue = 0.0;
      for (int i = 0; i < dailyDataList.length; i++) {
        if(dailyDataList[i].title == null && dailyDataList[i].smileyType == null){
          modValue += dailyDataList[i].value1 ?? 0.0;
          vigValue += dailyDataList[i].value2 ?? 0.0;
          totalValue += dailyDataList[i].total ?? 0.0;
        }
      }

      if(modValue == 0.0){
        activityWeeklyDataList[0].value1 = null;
      }else{
        activityWeeklyDataList[0].value1 = modValue;
      }

      if(vigValue == 0.0){
        activityWeeklyDataList[0].value2 = null;
      }else{
        activityWeeklyDataList[0].value2 = vigValue;
      }

      if(totalValue == 0.0){
        activityWeeklyDataList[0].total = null;
      }else{
        activityWeeklyDataList[0].total = totalValue;
      }
      await DataBaseHelper.shared.updateActivityData(activityWeeklyDataList[0]);
    }


    var daysStrengthWeeklyDataList = dataListHive
        .where((element) =>
    element.weeksDate == weekDate &&
        element.type == Constant.typeWeek && element.title == Constant.titleDaysStr)
        .toList();
    if(daysStrengthWeeklyDataList.isEmpty){
      var insertingData = ActivityTable();
      insertingData.name = "";
      insertingData.title = Constant.titleDaysStr;
      insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);
      try {
        var strDayLength = Hive.box<ActivityTable>(Constant.tableActivity).values.toList();
        var checkedBoxLength = strDayLength.where((element) => element.weeksDate == weekDate && (element.isCheckedDay ?? false) && element.type == Constant.typeDay && element.title == Constant.titleDaysStr).toList();
        if(checkedBoxLength.isNotEmpty) {
          insertingData.total = double.parse(checkedBoxLength.length.toString());
        }else{
          insertingData.total = 0;
        }
      } catch (e) {
        Debug.printLog(e.toString());
      }
      insertingData.type = Constant.typeWeek;
      insertingData.weeksDate = weekDate;
      var id = await DataBaseHelper.shared.insertActivityData(insertingData);
      Debug.printLog("onChangeCountOtherTitle2CheckBoxWeeks if......$id");
    }
    else{
      try {
        var strDayLength = Hive.box<ActivityTable>(Constant.tableActivity).values.toList();
        var checkedBoxLength = strDayLength.where((element) => element.weeksDate == weekDate && (element.isCheckedDay ?? false) && element.type == Constant.typeDay && element.title == Constant.titleDaysStr).toList();
        if(checkedBoxLength.isNotEmpty) {
          daysStrengthWeeklyDataList[0].total  = double.parse(checkedBoxLength.length.toString());
        }else{
          daysStrengthWeeklyDataList[0].total = 0;
        }
      } catch (e) {
        Debug.printLog(e.toString());
      }
      await DataBaseHelper.shared.updateActivityData(daysStrengthWeeklyDataList[0]);
    }


    var caloriesWeeklyDataList = dataListHive
        .where((element) =>
    element.weeksDate == weekDate &&
        element.type == Constant.typeWeek && element.title == Constant.titleCalories)
        .toList();
    if(caloriesWeeklyDataList.isEmpty){
      var insertingData = ActivityTable();
      insertingData.title = Constant.titleCalories;

      if(selectedDateDailyLogClass.caloriesValue == 0.0) {
        insertingData.total = null;
      }else{
        if(selectedDateDailyLogClass.caloriesValue != null) {
          insertingData.total =
              double.parse(selectedDateDailyLogClass.caloriesValue.toString());
        }
      }
      insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);
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


    var stepsWeeklyDataList = dataListHive
        .where((element) =>
    element.weeksDate == weekDate &&
        element.type == Constant.typeWeek && element.title == Constant.titleSteps)
        .toList();
    if(stepsWeeklyDataList.isEmpty){
      var insertingData = ActivityTable();
      insertingData.title = Constant.titleSteps;

      if(selectedDateDailyLogClass.stepsTotal == 0.0) {
        insertingData.total = null;
      }else{
        if(selectedDateDailyLogClass.stepsTotal != null) {
          insertingData.total =
              double.parse(selectedDateDailyLogClass.stepsTotal.toString());
        }
      }
      insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);
      insertingData.type = Constant.typeWeek;
      insertingData.weeksDate = weekDate ;
      await DataBaseHelper.shared.insertActivityData(insertingData);
    }
    else{
      var totalValue = 0.0;
      for (int i = 0; i < dailyDataList.length; i++) {
        if(dailyDataList[i].title == Constant.titleSteps){
          totalValue += dailyDataList[i].total ?? 0.0;
        }
      }
      stepsWeeklyDataList[0].total = totalValue;


      stepsWeeklyDataList[0].isSync = false;
      await DataBaseHelper.shared.updateActivityData(stepsWeeklyDataList[0]);
    }


    var restHeartRateWeeklyDataList = dataListHive
        .where((element) =>
    element.weeksDate == weekDate &&
        element.type == Constant.typeWeek && element.title == Constant.titleHeartRateRest)
        .toList();
    if(restHeartRateWeeklyDataList.isEmpty){
      var insertingData = ActivityTable();
      insertingData.title = Constant.titleHeartRateRest;

      if(selectedDateDailyLogClass.restHeartValue == 0.0) {
        insertingData.total = null;
      }else{
        if(selectedDateDailyLogClass.restHeartValue != null) {
          insertingData.total =
              double.parse(selectedDateDailyLogClass.restHeartValue.toString());
        }
      }
      insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);
      insertingData.type = Constant.typeWeek;
      insertingData.weeksDate = weekDate ;
      await DataBaseHelper.shared.insertActivityData(insertingData);
    }
    else{

      List<int> tempIntList = [];
      var avgTotal = 0;
      for( int i = 0;i< dailyDataList.length;i++){
        if(dailyDataList[i].title == Constant.titleHeartRateRest && dailyDataList[i].total != 0  ) {
          tempIntList.add((dailyDataList[i].total ?? 0).toInt());
          avgTotal += (dailyDataList[i].total ?? 0).toInt();
        }
      }
      if(tempIntList.isNotEmpty) {
        var min = tempIntList.reduce((a, b) => a < b ? a : b);
        var max = tempIntList.reduce((a, b) => a > b ? a : b);

        var totalFilledDataList = dailyDataList.where((element) => element.total != 0 && element.title == Constant.titleHeartRateRest).toList();
        if(totalFilledDataList.isNotEmpty){
          avgTotal = avgTotal ~/ totalFilledDataList.length;
        }
        Debug.printLog(
            "totalFilledDataList.... $min $max $avgTotal  ${totalFilledDataList.length}");
      }
      restHeartRateWeeklyDataList[0].total = avgTotal.toDouble();


      restHeartRateWeeklyDataList[0].isSync = false;
      await DataBaseHelper.shared.updateActivityData(restHeartRateWeeklyDataList[0]);
    }


    var peakHeartRateWeeklyDataList = dataListHive
        .where((element) =>
    element.weeksDate == weekDate &&
        element.type == Constant.typeWeek && element.title == Constant.titleHeartRatePeak)
        .toList();
    if(peakHeartRateWeeklyDataList.isEmpty){
      var insertingData = ActivityTable();
      insertingData.title = Constant.titleHeartRatePeak;

      if(selectedDateDailyLogClass.peakHeartValue == 0.0) {
        insertingData.total = null;
      }else{
        if(selectedDateDailyLogClass.peakHeartValue != null) {
          insertingData.total =
              double.parse(selectedDateDailyLogClass.peakHeartValue.toString());
        }
      }
      insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);
      insertingData.type = Constant.typeWeek;
      insertingData.weeksDate = weekDate ;
      await DataBaseHelper.shared.insertActivityData(insertingData);
    }
    else{
      List<int> tempIntList = [];
      for( int i = 0;i<dailyDataList.length;i++){
        if(dailyDataList[i].title == Constant.titleHeartRatePeak && dailyDataList[i].total != 0  ) {
          tempIntList.add((dailyDataList[i].total ?? 0).toInt());
        }
      }
      var min = 0;
      var max = 0;
      if(tempIntList.isNotEmpty) {
        min = tempIntList.reduce((a, b) => a < b ? a : b);
        max = tempIntList.reduce((a, b) => a > b ? a : b);
      }

      peakHeartRateWeeklyDataList[0].total = max.toDouble();
      peakHeartRateWeeklyDataList[0].isSync = false;
      await DataBaseHelper.shared.updateActivityData(peakHeartRateWeeklyDataList[0]);
    }

    var smileyDataList = dataListHive.where((element) =>
    element.weeksDate == weekDate &&
        element.type == Constant.typeWeek && element.title == null && element.smileyType != null).toList();

    if(smileyDataList.isEmpty){
      var insertingData = ActivityTable();
      insertingData.title = null;
      insertingData.value1 = null;
      insertingData.value2 = null;
      insertingData.total = null;
      insertingData.type = Constant.typeWeek;
      insertingData.weeksDate = weekDate;
      insertingData.smileyType = selectedDateDailyLogClass.smileyType;
      await DataBaseHelper.shared.insertActivityData(insertingData);
    }
    else{
      smileyDataList[0].smileyType = selectedDateDailyLogClass.smileyType;
      await DataBaseHelper.shared.updateActivityData(smileyDataList[0]);
    }


    List<SyncMonthlyActivityData> allSyncingData = [];

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

    /*await Syncing.getAndSetSyncActivityData(allSyncingData,date: DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate));
    if(allSyncingData.isNotEmpty) {
      await Syncing.observationSyncDataCalories(allSyncingData);
      await Syncing.observationSyncDataSteps(allSyncingData);
      await Syncing.observationSyncDataRestHeart(allSyncingData);
      await Syncing.observationSyncDataPeakHeart(allSyncingData);
      await Syncing.observationSyncDataExperience(allSyncingData);
      await Syncing.observationSyncDataTotalMin(allSyncingData);
      await Syncing.observationSyncDataModMin(allSyncingData);
      await Syncing.observationSyncDataVigMin(allSyncingData);
      await Syncing.observationSyncDataStrengthBox(allSyncingData);
    }*/

  }

  String getDataFromController(){
    final delta = selectedDateDailyLogClass.notesController.document.toDelta();
    Debug.printLog('Current HTML content: ${selectedDateDailyLogClass.notesValues}.......  ${delta.toJson()}');
    selectedDateDailyLogClass.notesValues = jsonEncode(selectedDateDailyLogClass.notesController.document.toDelta().toList());
    return selectedDateDailyLogClass.notesValues;
  }

}

class DailyLogClass{

  bool isShowHeader = false;
  TextEditingController modValueController = TextEditingController();
  TextEditingController vigValueController = TextEditingController();
  TextEditingController totalValueController = TextEditingController();
  double? modValue = 0.0;
  double? vigValue = 0.0;
  double? totalValue = 0.0;
  double? oldModValue = 0.0;
  double? oldVigValue = 0.0;
  double? oldTotalValue = 0.0;
  int activityMinKeyId = 0;

  bool isCheckedDayData = false;
  int daysStrKeyId = 0;

  TextEditingController caloriesValueController = TextEditingController();
  double? caloriesValue = 0.0;
  double? oldCaloriesValue = 0.0;
  int caloriesKeyId = 0;

  TextEditingController stepsValueController = TextEditingController();
  double? stepsTotal = 0.0;
  double? oldStepsTotal = 0.0;
  int stepsKeyId = 0;

  TextEditingController restHeartValueController = TextEditingController();
  double? restHeartValue = 0.0;
  double? oldRestHeartValue = 0.0;
  int restHeartKeyId = 0;
  TextEditingController peakHeartValueController = TextEditingController();
  int notesKeyId = 0;
  String notesValues = "";
  // TextEditingController notesController = TextEditingController();
  QuillController notesController = QuillController.basic();

  double? peakHeartValue = 0.0;
  double? oldPeakHeartValue = 0.0;
  int peakHeartKeyId = 0;
  // String notesValueLocal = "";


  int smileyKeyId = 0;
  int smileyType = Constant.defaultSmileyType;

  String date = "";
  String? displayLabel;
  DateTime? storedDate;
  int? insertedDayDataId;
  String? weeksDate;
  String? userId;
  String? iconPath;
  bool isShownDate = true;

  DateTime activityStartDate = DateTime.now();
  DateTime activityEndDate = DateTime.now();
  bool isChangedEndTime = false;

  DateTime? activityStartDateLast;
  DateTime? activityEndDateLast;
}



