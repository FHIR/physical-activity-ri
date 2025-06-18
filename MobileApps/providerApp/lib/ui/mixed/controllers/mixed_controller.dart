import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/ui/home/home/controllers/home_controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../db_helper/box/activity_data.dart';
import '../../../db_helper/database_helper.dart';
import '../../../utils/constant.dart';
import '../../../utils/debug.dart';
import '../../../utils/preference.dart';
import '../../../utils/utils.dart';
import '../../bottomNavigation/controllers/bottom_navigation_controller.dart';
import '../../history/controllers/history_controller.dart';

class MixedController extends GetxController {

  final BottomNavigationController bottomControllers = Get.find<BottomNavigationController>();
  List<DailyLogClass> dailyLogDataList = [];
  List<String> dateList = [];
  DateTime? startDate;
  DateTime? endDate;
  var selectedNewDate = DateTime.now();
  List<RowsDataClass> filterData = [];
  DailyLogClass selectedDateDailyLogClass = DailyLogClass();
  List<String> activityLevelData = [];
  var labelIcon = "assets/icons/ic_emoji(1).jpeg";


  gotoTrackingChartPage(){
    Get.toNamed(AppRoutes.history);
    // bottomControllers.onPageChanged(1);
    // update();
  }

  @override
  void onInit() {
    endDate = selectedNewDate;
    startDate = selectedNewDate.subtract(const Duration(days: 29));
    getDataFromDB();
    // Utils.getGoalDataListApi();
    super.onInit();
  }

  getDateWiseData(List<ActivityTable> displayTitleTwoList){
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
        // displayOneDataClass.userId = displayTitleTwoList[o].patientId ?? "0";

        if(displayTitleTwoList[o].title == null){
          ///Title 1 data
          displayOneDataClass.title1Value1Controller.text =  (displayTitleTwoList[o].value1 == null) ? "" : displayTitleTwoList[o].value1!.toInt().toString();
          displayOneDataClass.title1Value2Controller.text =  (displayTitleTwoList[o].value2 == null) ? "" : displayTitleTwoList[o].value2!.toInt().toString();
          displayOneDataClass.title1TotalValueController.text =  (displayTitleTwoList[o].total == null) ? "" : displayTitleTwoList[o].total!.toInt().toString();

          displayOneDataClass.title1Value1 =  displayTitleTwoList[o].value1 ?? 0;
          displayOneDataClass.title1Value2 =  displayTitleTwoList[o].value2 ?? 0;
          displayOneDataClass.title1Total =  displayTitleTwoList[o].total ?? 0;

          displayOneDataClass.smileyType =  displayTitleTwoList[o].smileyType ?? 1;

          displayOneDataClass.title1KeyId = displayTitleTwoList[o].key!;

        }else if(displayTitleTwoList[o].title == Constant.titleDaysStr){
          ///Title 2 data
          displayOneDataClass.isCheckedDayData =  displayTitleTwoList[o].isCheckedDayData ?? false;
          displayOneDataClass.title2KeyId = displayTitleTwoList[o].key!;

        }else if(displayTitleTwoList[o].title == Constant.titleCalories){
          ///Title 3 data
          displayOneDataClass.title3TotalValueController.text = (displayTitleTwoList[o].total == null)? "" : (displayTitleTwoList[o].total!.toInt()).toString();
          displayOneDataClass.title3total =  displayTitleTwoList[o].total ?? 0;
          displayOneDataClass.title3KeyId = displayTitleTwoList[o].key!;

        }else if(displayTitleTwoList[o].title == Constant.titleSteps){
          ///Title 4 data
          displayOneDataClass.title4TotalValueController.text =  (displayTitleTwoList[o].total == null)? "" : (displayTitleTwoList[o].total!.toInt()).toString();
          displayOneDataClass.title4total =  displayTitleTwoList[o].total ?? 0;
          displayOneDataClass.title4KeyId = displayTitleTwoList[o].key!;

        }else if(displayTitleTwoList[o].title == Constant.titleHeartRateRest){
          ///Title 5 data
          displayOneDataClass.title5Value1Controller.text = (displayTitleTwoList[o].total == null)? "" : (displayTitleTwoList[o].total!.toInt()).toString();
          displayOneDataClass.title5Value1 =  displayTitleTwoList[o].total ?? 0;
          displayOneDataClass.title5Value1KeyId = displayTitleTwoList[o].key!;

        }else if(displayTitleTwoList[o].title == Constant.titleHeartRatePeak){
          ///Title 6 data
          displayOneDataClass.title5Value2Controller.text =  (displayTitleTwoList[o].total == null)? "" : (displayTitleTwoList[o].total!.toInt()).toString();
          displayOneDataClass.title5Value2 =  displayTitleTwoList[o].total ?? 0;
          displayOneDataClass.title5Value2KeyId = displayTitleTwoList[o].key!;

        }
      }
      dailyLogDataList.add(displayOneDataClass);
    }
  }

  void generateDateList() {
    dailyLogDataList.clear();
    dateList.clear();
    for (var i = startDate; i!.isBefore(endDate!) || i.isAtSameMomentAs(endDate!); i = i.add(const Duration(days: 1))) {
      dateList.add(DateFormat(Constant.commonDateFormatDdMmYyyy).format(i).toString());
    }
    dateList = dateList.reversed.toList();
    // Debug.printLog("generateDateList....$dateList");
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
          getDateWiseData(displayTitleOneList);
        }



        var filterTwo = filterData.where((element) => element.titleName == Constant.itemJogging &&
            element.selected == true ).toList();
        if(filterTwo.isNotEmpty) {
          var displayTitleTwoList = data
              .where((element) =>
          element.displayLabel == Constant.itemJogging &&
              element.type == Constant.typeDaysData)
              .toList();
          getDateWiseData(displayTitleTwoList);
        }


        var filterThree = filterData.where((element) => element.titleName == Constant.itemRunning &&
            element.selected == true ).toList();
        if(filterThree.isNotEmpty) {
          var displayTitleThreeList = data
              .where((element) =>
          element.displayLabel == Constant.itemRunning &&
              element.type == Constant.typeDaysData)
              .toList();
          getDateWiseData(displayTitleThreeList);
        }

        var filterFour = filterData.where((element) => element.titleName == Constant.itemSwimming &&
            element.selected == true ).toList();
        if(filterFour.isNotEmpty) {
          var displayTitleFourList = data
              .where((element) =>
          element.displayLabel == Constant.itemSwimming &&
              element.type == Constant.typeDaysData)
              .toList();
          getDateWiseData(displayTitleFourList);
        }

        var filterFive = filterData.where((element) => element.titleName == Constant.itemWalking &&
            element.selected == true ).toList();
        if(filterFive.isNotEmpty) {
          var displayTitleFiveList = data
              .where((element) =>
          element.displayLabel == Constant.itemWalking &&
              element.type == Constant.typeDaysData)
              .toList();
          getDateWiseData(displayTitleFiveList);
        }

        var filterSix = filterData.where((element) => element.titleName == Constant.itemWeights &&
            element.selected == true ).toList();
        if(filterSix.isNotEmpty) {
          var displayTitleSixList = data
              .where((element) =>
          element.displayLabel == Constant.itemWeights &&
              element.type == Constant.typeDaysData)
              .toList();
          getDateWiseData(displayTitleSixList);
        }

        var filterMixed = filterData.where((element) => element.titleName == Constant.itemMixed &&
            element.selected == true ).toList();
        if(filterMixed.isNotEmpty) {
          var displayTitleMixedList = data
              .where((element) =>
          element.displayLabel == Constant.itemMixed &&
              element.type == Constant.typeDaysData)
              .toList();
          getDateWiseData(displayTitleMixedList);
        }
      }
    }
    Debug.printLog("logDataList.....$dailyLogDataList");
    update();
  }

  void setSelectedDataClass(DailyLogClass selectedDateFirstDate) {
    selectedDateDailyLogClass = selectedDateFirstDate;
    update();
  }

  void changeTitleDropDown(String labelName, DateTime date,{bool isGetData = true}) {
    var lastTitle = Constant.configurationInfo.where((element) => element.isEnabled
    && element.title == labelName).toList();
    if(lastTitle.isNotEmpty){
      selectedDateDailyLogClass.displayLabel = lastTitle[0].title;
    }else{
      selectedDateDailyLogClass.displayLabel = Constant.itemRunning;
    }
    // selectedDateDailyLogClass.displayLabel = labelName;
    if(isGetData) {
      var dateStr = DateFormat(Constant.commonDateFormatDdMmYyyy).format(date);
      getDaysDataWise(selectedDateDailyLogClass.displayLabel.toString(), dateStr);
    }
    update();
  }

  getDaysDataWise(String labelName, String date){
    List<ActivityTable> dataListHive =
    Hive.box<ActivityTable>(Constant.tableActivity).values.toList();

    var dbDataList = dataListHive.where((element) => element.date == date &&
        element.displayLabel == labelName).toList();

    if(dbDataList.isNotEmpty) {
      selectedDateDailyLogClass = DailyLogClass();
      for (int o = 0; o < dbDataList.length; o++){

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

        if(dbDataList[o].title == null){
          ///Title 1 data
          selectedDateDailyLogClass.title1Value1Controller.text =  (dbDataList[o].value1 == null) ? "0" : dbDataList[o].value1!.toInt().toString();
          selectedDateDailyLogClass.title1Value2Controller.text =  (dbDataList[o].value2 == null) ? "0" : dbDataList[o].value2!.toInt().toString();
          selectedDateDailyLogClass.title1TotalValueController.text =  (dbDataList[o].total == null) ? "0" : dbDataList[o].total!.toInt().toString();

          selectedDateDailyLogClass.title1Value1 =  dbDataList[o].value1 ?? 0;
          selectedDateDailyLogClass.title1Value2 =  dbDataList[o].value2 ?? 0;
          selectedDateDailyLogClass.title1Total =  dbDataList[o].total ?? 0;

          selectedDateDailyLogClass.smileyType =  dbDataList[o].smileyType ?? 1;

          selectedDateDailyLogClass.title1KeyId = dbDataList[o].key!;

        }else if(dbDataList[o].title == Constant.titleDaysStr){
          ///Title 2 data
          selectedDateDailyLogClass.isCheckedDayData =  dbDataList[o].isCheckedDayData ?? false;
          selectedDateDailyLogClass.title2KeyId = dbDataList[o].key!;

        }else if(dbDataList[o].title == Constant.titleCalories){
          ///Title 3 data
          selectedDateDailyLogClass.title3TotalValueController.text = (dbDataList[o].total == null)? "0" : (dbDataList[o].total!.toInt()).toString();
          selectedDateDailyLogClass.title3total =  dbDataList[o].total ?? 0;
          selectedDateDailyLogClass.title3KeyId = dbDataList[o].key!;

        }else if(dbDataList[o].title == Constant.titleSteps){
          ///Title 4 data
          selectedDateDailyLogClass.title4TotalValueController.text =  (dbDataList[o].total == null)? "0" : (dbDataList[o].total!.toInt()).toString();
          selectedDateDailyLogClass.title4total =  dbDataList[o].total ?? 0;
          selectedDateDailyLogClass.title4KeyId = dbDataList[o].key!;

        }else if(dbDataList[o].title == Constant.titleHeartRateRest){
          ///Title 5 data
          selectedDateDailyLogClass.title5Value1Controller.text = (dbDataList[o].total == null)? "0" : (dbDataList[o].total!.toInt()).toString();
          selectedDateDailyLogClass.title5Value1 =  dbDataList[o].total ?? 0;
          selectedDateDailyLogClass.title5Value1KeyId = dbDataList[o].key!;

        }else if(dbDataList[o].title == Constant.titleHeartRatePeak){
          ///Title 6 data
          selectedDateDailyLogClass.title5Value2Controller.text =  (dbDataList[o].total == null)? "0" : (dbDataList[o].total!.toInt()).toString();
          selectedDateDailyLogClass.title5Value2 =  dbDataList[o].total ?? 0;
          selectedDateDailyLogClass.title5Value2KeyId = dbDataList[o].key!;

        }
      }
    }else{
      selectedDateDailyLogClass = DailyLogClass();
      selectedDateDailyLogClass.displayLabel = labelName;
    }
    update();
  }

  void onSelectionChangedDatePicker(DateRangePickerSelectionChangedArgs args) {
    Debug.printLog("onSelectionChangedDatePicker....${args.value}");
    selectedNewDate = args.value;
    endDate = selectedNewDate;
    startDate = selectedNewDate.subtract(const Duration(days: 29));
    generateDateList();
    update();

  }

  getPreferenceActivityData() async {
    activityLevelData.clear();
    final SharedPreferences pref = await SharedPreferences.getInstance();
    var dataList = pref.getStringList(Preference.activityData) ?? [];
    for(int i = 0 ; i < Constant.configurationInfo.length;i++){
      if(Constant.configurationInfo[i].isEnabled){
        activityLevelData.add(Constant.configurationInfo[i].title);
      }
    }
    update();
  }

  void onChangeEditableTextValue1Bottom(value) {
    if(value == ""){
      selectedDateDailyLogClass.title1Value1Controller.text = "";
      selectedDateDailyLogClass.title1Value1 = null;
      selectedDateDailyLogClass.title1Value1Controller.selection =
          TextSelection.fromPosition(const TextPosition(offset: 0));
    }else {
      selectedDateDailyLogClass.title1Value1Controller.text = value.toString();
      selectedDateDailyLogClass.title1Value1 = double.parse(value);
      selectedDateDailyLogClass.title1Value1Controller.selection =
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

  void onChangeEditableTextValue1Title5Bottom(value) {
    if(value == ""){
      selectedDateDailyLogClass.title5Value1Controller.text = "";
      selectedDateDailyLogClass.title5Value1 = null;
      selectedDateDailyLogClass.title5Value1Controller.selection =
          TextSelection.fromPosition(const TextPosition(offset: 0));
    }else {
      selectedDateDailyLogClass.title5Value1Controller.text = value.toString();
      selectedDateDailyLogClass.title5Value1 = double.parse(value);
      selectedDateDailyLogClass.title5Value1Controller.selection =
          TextSelection.fromPosition(TextPosition(offset: value.length));
    }
    update();
  }

  void onChangeEditableTextValue2Title5Bottom(value) {
    if(value == ""){
      selectedDateDailyLogClass.title5Value2Controller.text = "";
      selectedDateDailyLogClass.title5Value2 = null;
      selectedDateDailyLogClass.title5Value2Controller.selection =
          TextSelection.fromPosition(const TextPosition(offset: 0));
    }else {
      selectedDateDailyLogClass.title5Value2Controller.text = value.toString();
      selectedDateDailyLogClass.title5Value2 = double.parse(value);
      selectedDateDailyLogClass.title5Value2Controller.selection =
          TextSelection.fromPosition(TextPosition(offset: value.length));
    }
    update();
  }


  var smileyType = 1;
  void updateSmileyForBottom(int value){
    smileyType = value;
    selectedDateDailyLogClass.smileyType = value;
    update();
  }

  void onChangeEditableTextValue2Bottom(value) {
    if(value == ""){
      selectedDateDailyLogClass.title1Value2Controller.text = "";
      selectedDateDailyLogClass.title1Value2 = null;
      selectedDateDailyLogClass.title1Value2Controller.selection =
          TextSelection.fromPosition(const TextPosition(offset: 0));
    }else {
      selectedDateDailyLogClass.title1Value2Controller.text = value.toString();
      selectedDateDailyLogClass.title1Value2 = double.parse(value);
      selectedDateDailyLogClass.title1Value2Controller.selection =
          TextSelection.fromPosition(TextPosition(offset: value.length));
    }
    update();
  }

  void onChangeEditableTextTotalBottom(value) {
    if(value == ""){
      selectedDateDailyLogClass.title1TotalValueController.text = "";
      selectedDateDailyLogClass.title1Total = null;
      selectedDateDailyLogClass.title1TotalValueController.selection =
          TextSelection.fromPosition(const TextPosition(offset: 0));
    }else {
      selectedDateDailyLogClass.title1TotalValueController.text = value.toString();
      selectedDateDailyLogClass.title1Total = double.parse(value);
      selectedDateDailyLogClass.title1TotalValueController.selection =
          TextSelection.fromPosition(TextPosition(offset: value.length));
    }
    update();
  }

  void onChangeEditableTextValueTitle3Bottom(value) {
    if(value == ""){
      selectedDateDailyLogClass.title3TotalValueController.text = "";
      selectedDateDailyLogClass.title3total = null;
      selectedDateDailyLogClass.title3TotalValueController.selection =
          TextSelection.fromPosition(const TextPosition(offset: 0));

    }else {
      selectedDateDailyLogClass.title3TotalValueController.text = value.toString();
      selectedDateDailyLogClass.title3total = double.parse(value);
      selectedDateDailyLogClass.title3TotalValueController.selection =
          TextSelection.fromPosition(TextPosition(offset: value.length));
    }
    update();
  }

  void onChangeEditableTextValueTitle4Bottom(value) {
    if(value == ""){
      selectedDateDailyLogClass.title4TotalValueController.text = "";
      selectedDateDailyLogClass.title4total = null;
      selectedDateDailyLogClass.title4TotalValueController.selection =
          TextSelection.fromPosition(const TextPosition(offset: 0));
    }else {
      selectedDateDailyLogClass.title4TotalValueController.text = value.toString();
      selectedDateDailyLogClass.title4total = double.parse(value);
      selectedDateDailyLogClass.title4TotalValueController.selection =
          TextSelection.fromPosition(TextPosition(offset: value.length));
    }
    update();
  }

  Future<void> updateSingleDataFromSheet() async {
    Debug.printLog("dailyLogClass updateSingleDataFromSheet....$selectedDateDailyLogClass");
    List<ActivityTable> dataListHive =
    Hive.box<ActivityTable>(Constant.tableActivity).values.toList();
    var dateLabelList = dataListHive.where((element) => element.displayLabel == selectedDateDailyLogClass.displayLabel &&
        element.date == selectedDateDailyLogClass.date).toList();
    if (dateLabelList.isNotEmpty) {
      // if()
      var title1DataFromDB = dataListHive
          .where(
              (element) => element.key == selectedDateDailyLogClass.title1KeyId)
          .toList();
      if (title1DataFromDB.isNotEmpty) {
        ///Update title 1 data (Product A B C)
        var title1Data = title1DataFromDB[0];
        title1Data.value1 = selectedDateDailyLogClass.title1Value1 ?? 0;
        title1Data.value2 = selectedDateDailyLogClass.title1Value2 ?? 0;
        title1Data.total = selectedDateDailyLogClass.title1Total ?? 0;
        title1Data.smileyType = selectedDateDailyLogClass.smileyType;
        await DataBaseHelper.shared.updateActivityData(title1Data);
      }

      var title2DataFromDB = dataListHive
          .where(
              (element) => element.key == selectedDateDailyLogClass.title2KeyId)
          .toList();
      if (title2DataFromDB.isNotEmpty) {
        ///Update title 2 data (Boxes)
        var title2Data = title2DataFromDB[0];
        title2Data.isCheckedDayData =
            selectedDateDailyLogClass.isCheckedDayData;
        await DataBaseHelper.shared.updateActivityData(title2Data);
      }

      var title3DataFromDB = dataListHive
          .where(
              (element) => element.key == selectedDateDailyLogClass.title3KeyId)
          .toList();
      if (title3DataFromDB.isNotEmpty) {
        ///Update title 3 data (Colors)
        var title3Data = title3DataFromDB[0];
        title3Data.total = selectedDateDailyLogClass.title3total;
        await DataBaseHelper.shared.updateActivityData(title3Data);
      }

      var title4DataFromDB = dataListHive
          .where(
              (element) => element.key == selectedDateDailyLogClass.title4KeyId)
          .toList();
      if (title4DataFromDB.isNotEmpty) {
        ///Update title 4 data (Sizes)
        var title4Data = title4DataFromDB[0];
        title4Data.total = selectedDateDailyLogClass.title4total;
        await DataBaseHelper.shared.updateActivityData(title4Data);
      }

      var title5Value1DataFromDB = dataListHive
          .where((element) =>
      element.key == selectedDateDailyLogClass.title5Value1KeyId)
          .toList();
      if (title5Value1DataFromDB.isNotEmpty) {
        ///Update title 5 Value 1 data (Quantity)
        var title5Val1Data = title5Value1DataFromDB[0];
        title5Val1Data.total = selectedDateDailyLogClass.title5Value1;
        await DataBaseHelper.shared.updateActivityData(title5Val1Data);
      }

      var title5Value2DataFromDB = dataListHive
          .where((element) =>
      element.key == selectedDateDailyLogClass.title5Value2KeyId)
          .toList();
      if (title5Value2DataFromDB.isNotEmpty) {
        ///Update title 5 Value 1 data (Quantity)
        var title5Val2Data = title5Value2DataFromDB[0];
        title5Val2Data.total = selectedDateDailyLogClass.title5Value2;
        await DataBaseHelper.shared.updateActivityData(title5Val2Data);
      }
    }
    else{
      ///Insert
      /* For title1
     * 1. Date
     * 2. value 1
     * 3. value 3
     * 4. total
     * 5. weeksDate
     * 6. userId
     * 7. dateTime
     * 8. displayLabel
     * 9. smileyType*/

      var selectedWeekStartDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(findFirstDateOfTheWeek(selectedNewDate));
      var selectedWeekEndDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(findLastDateOfTheWeek(selectedNewDate));

      var activityTableData = ActivityTable();
      activityTableData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);
      activityTableData.value1 = selectedDateDailyLogClass.title1Value1 ?? 0;
      activityTableData.value2 = selectedDateDailyLogClass.title1Value2 ?? 0;
      activityTableData.total = selectedDateDailyLogClass.title1Total ?? 0;
      activityTableData.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
      activityTableData.type = Constant.typeDaysData;
      //activityTableData.patientId = Utils.getPatientId();
      // activityTableData.dateTime = DateTime.now();
      activityTableData.dateTime = selectedNewDate;
      activityTableData.displayLabel = selectedDateDailyLogClass.displayLabel;
      activityTableData.smileyType = smileyType;
      activityTableData.iconPath = Utils.getNumberIconNameFromType(selectedDateDailyLogClass.displayLabel!);
      await DataBaseHelper.shared.insertActivityData(activityTableData);


      /* For title2
     * 1. Date
     * 2. title
     * 3. value 3
     * 4. total
     * 5. weeksDate
     * 6. userId
     * 7. dateTime
     * 8. displayLabel
     * 9. smileyType*/


      activityTableData = ActivityTable();
      activityTableData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);
      activityTableData.title = Constant.titleDaysStr;
      activityTableData.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
      activityTableData.isCheckedDayData = bottomIsCheckedDayData;
      //activityTableData.patientId = Utils.getPatientId();
      activityTableData.type = Constant.typeDaysData;
      activityTableData.dateTime = selectedNewDate;
      activityTableData.displayLabel = selectedDateDailyLogClass.displayLabel;
      await DataBaseHelper.shared.insertActivityData(activityTableData);


      activityTableData = ActivityTable();
      activityTableData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);
      activityTableData.title = Constant.titleCalories;
      activityTableData.total = selectedDateDailyLogClass.title3total ?? 0;
      activityTableData.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
      //activityTableData.patientId = Utils.getPatientId();
      activityTableData.dateTime = selectedNewDate;
      activityTableData.type = Constant.typeDaysData;
      activityTableData.displayLabel = selectedDateDailyLogClass.displayLabel;
      await DataBaseHelper.shared.insertActivityData(activityTableData);


      activityTableData = ActivityTable();
      activityTableData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);
      activityTableData.title = Constant.titleSteps;
      activityTableData.total = selectedDateDailyLogClass.title4total ?? 0;
      activityTableData.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
      //activityTableData.patientId = Utils.getPatientId();
      activityTableData.dateTime = selectedNewDate;
      activityTableData.type = Constant.typeDaysData;
      activityTableData.displayLabel = selectedDateDailyLogClass.displayLabel;
      await DataBaseHelper.shared.insertActivityData(activityTableData);

      activityTableData = ActivityTable();
      activityTableData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);
      activityTableData.title = Constant.titleHeartRateRest;
      activityTableData.total = selectedDateDailyLogClass.title5Value1 ?? 0;
      activityTableData.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
      //activityTableData.patientId = Utils.getPatientId();
      activityTableData.dateTime = selectedNewDate;
      activityTableData.type = Constant.typeDaysData;
      activityTableData.displayLabel = selectedDateDailyLogClass.displayLabel;
      await DataBaseHelper.shared.insertActivityData(activityTableData);

      activityTableData = ActivityTable();
      activityTableData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(selectedNewDate);
      activityTableData.title = Constant.titleHeartRatePeak;
      activityTableData.total = selectedDateDailyLogClass.title5Value2 ?? 0;
      activityTableData.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
      //activityTableData.patientId = Utils.getPatientId();
      activityTableData.dateTime = selectedNewDate;
      activityTableData.type = Constant.typeDaysData;
      activityTableData.displayLabel = selectedDateDailyLogClass.displayLabel;
      await DataBaseHelper.shared.insertActivityData(activityTableData);

      // insertDayLevelDataUpdate(selectedWeekStartDate,selectedWeekEndDate);
    }
    Get.back();
    bottomIsCheckedDayData = false;
    update();
  }

  Future<void> insertDayLevelDataUpdate(String selectedWeekStartDate,
      String selectedWeekEndDate) async {
    var allDataFromDB = Hive.box<ActivityTable>(Constant.tableActivity).values.toList();
    var selectedDateStr = DateFormat(Constant.commonDateFormatDdMmYyyy).
    format(selectedNewDate);
    var dayInsertedData = allDataFromDB
        .where((element) =>
    element.date == selectedDateStr &&
        element.type == Constant.typeDay)
        .toList();
    if(dayInsertedData.isEmpty){

      var insertingData = ActivityTable();
      insertingData.name = "";
      insertingData.type = Constant.typeDay;
      insertingData.date = selectedDateStr;
      insertingData.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
      insertingData.dateTime = selectedNewDate;
      //insertingData.patientId = Utils.getPatientId();
      for (int i = 0; i < 6; i++) {
        if( i == 0){
          ///Title 1
          insertingData.title = null;
          insertingData.value1 =
              double.parse(selectedDateDailyLogClass.title1Value1.toString());
          insertingData.value2 =
              double.parse(selectedDateDailyLogClass.title1Value2.toString());
          insertingData.total =
              double.parse(selectedDateDailyLogClass.title1Total.toString());
          await DataBaseHelper.shared.insertActivityData(insertingData);
        }else if( i == 1){
          ///Title 2
          insertingData.title = Constant.titleDaysStr;
          insertingData.value1 = null;
          insertingData.value2 = null;
          insertingData.total = null;
          insertingData.isCheckedDay = selectedDateDailyLogClass.isCheckedDayData;
          await DataBaseHelper.shared.insertActivityData(insertingData);
        }else if( i == 2){
          ///Title 3
          insertingData.title = Constant.titleCalories;
          insertingData.value1 = null;
          insertingData.value2 = null;
          insertingData.total = selectedDateDailyLogClass.title3total;
          insertingData.isCheckedDay = null;
          await DataBaseHelper.shared.insertActivityData(insertingData);
        }else if( i == 3){
          ///Title 4
          insertingData.title = Constant.titleSteps;
          insertingData.value1 = null;
          insertingData.value2 = null;
          insertingData.total = selectedDateDailyLogClass.title4total;
          insertingData.isCheckedDay = null;
          await DataBaseHelper.shared.insertActivityData(insertingData);
        }else if( i == 4){
          ///Title 5 Value 1
          insertingData.title = Constant.titleHeartRateRest;
          insertingData.value1 = null;
          insertingData.value2 = null;
          insertingData.total = selectedDateDailyLogClass.title5Value1;
          insertingData.isCheckedDay = null;
          await DataBaseHelper.shared.insertActivityData(insertingData);
        }else if( i == 5){
          ///Title 5 value 2
          insertingData.title = Constant.titleHeartRateRest;
          insertingData.value1 = null;
          insertingData.value2 = null;
          insertingData.total = selectedDateDailyLogClass.title5Value2;
          insertingData.isCheckedDay = null;
          await DataBaseHelper.shared.insertActivityData(insertingData);
        }else if( i == 6){
          ///Title 6
          insertingData.title = Constant.titleHeartRatePeak;
          insertingData.value1 = null;
          insertingData.value2 = null;
          insertingData.total = null;
          insertingData.isCheckedDay = null;
          insertingData.smileyType = selectedDateDailyLogClass.smileyType;
          await DataBaseHelper.shared.insertActivityData(insertingData);
        }
      }

    }
    else{
      var dayInsertedTitle1Data = allDataFromDB
          .where((element) =>
      element.date == selectedDateStr &&
          element.weeksDate ==  "$selectedWeekStartDate-$selectedWeekEndDate" &&
          element.title == null &&
          element.type == Constant.typeDay)
          .toList();
      if(dayInsertedTitle1Data.isNotEmpty){
        dayInsertedTitle1Data[0].value1 = (dayInsertedTitle1Data[0].value1 ?? 0 + selectedDateDailyLogClass.title1Value1!);
        dayInsertedTitle1Data[0].value2 = (dayInsertedTitle1Data[0].value1 ?? 0 + selectedDateDailyLogClass.title1Value2!);
        dayInsertedTitle1Data[0].total = (dayInsertedTitle1Data[0].value1 ?? 0 + selectedDateDailyLogClass.title1Total!);
        await DataBaseHelper.shared.updateActivityData(dayInsertedTitle1Data[0]);
      }

      var dayInsertedTitle2Data = allDataFromDB
          .where((element) =>
      element.date == selectedDateStr &&
          element.weeksDate ==  "$selectedWeekStartDate-$selectedWeekEndDate" &&
          element.title == Constant.titleDaysStr &&
          element.type == Constant.typeDay)
          .toList();
      if(dayInsertedTitle2Data.isNotEmpty){
        dayInsertedTitle2Data[0].total = (dayInsertedTitle2Data[0].value1 ?? 0 + selectedDateDailyLogClass.title1Total!);
        await DataBaseHelper.shared.updateActivityData(dayInsertedTitle2Data[0]);
      }
    }
  }

  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday));
  }
  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday - 1));
  }
}
