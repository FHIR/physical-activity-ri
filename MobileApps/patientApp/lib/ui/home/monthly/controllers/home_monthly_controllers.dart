import 'dart:io';

import 'package:banny_table/db_helper/box/server_detail_data.dart';
import 'package:banny_table/db_helper/database_helper.dart';
import 'package:banny_table/resources/syncing.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:fhir/dstu2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:hive/hive.dart';
import 'package:horizontal_data_table/refresh/pull_to_refresh/src/smart_refresher.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../db_helper/box/activity_data.dart';
import '../../../../db_helper/box/monthly_log_data.dart';
import '../../../../healthData/getSetHealthData.dart';
import '../../../../utils/constant.dart';
import '../datamodel/monthlyLogDataClass.dart';
import '../datamodel/syncMonthlyActivityData.dart';
import '../datamodel/weeksOfMonths.dart';

class HomeMonthlyControllers extends GetxController {
  List<MonthlyLogDataClass> monthlyDataList = [];
  ScrollController controllerScrollBar = ScrollController();
  ScrollController controller = ScrollController();
  int currentSelectedYear = DateTime.now().year;
  int currentSelectedMonth = DateTime.now().month;
  DateTime currentSelectedMonthDateTime = DateTime.now();
  List<DateTime> allLast30DaysList = [];
  List<SyncMonthlyActivityData> allSyncingData = [];
  RefreshController refreshController = RefreshController(initialRefresh: false);


  @override
  void onInit() {
    initCall();
    // getAndSetSyncMonthlyData();
    super.onInit();
  }

  initCall({bool needGetDataAgain = false}) async {
    await getMonthlyData();
    // await callApiForInsert();
    await monthlyDataAPICall(needGetDataAgain: needGetDataAgain);
    await getAndSetServerData();
  }

  getMonthlyData({bool needInsertDataAfterMethodCall = false,String monthNameSelected = "",bool needAPICall = true}) async {
    var dataListHive = Hive.box<ActivityTable>(Constant.tableActivity).values.toList().where((element) =>
    element.patientId == Utils.getPatientId()).toList();

    var data = MonthlyLogDataClass("",[],0);
    data.isShowHeader = true;
    monthlyDataList.clear();
    monthlyDataList.add(data);
    for (int i = 0; i < Utils.allYearlyMonths.length; i++) {
      List<WeeksOfMonths> weeksOfMonthsList = [];
      DateTime lastDateOfMonth =
      DateTime(currentSelectedYear, Utils.allYearlyMonths[i].number + 1, 0);
      DateTime dateTime =lastDateOfMonth;
      allLast30DaysList.clear();
      var totalDaysOfMonth = Utils.getDatesInMonthCountWise(lastDateOfMonth.year, lastDateOfMonth.month);
      Debug.printLog("totalDaysOfMonth.length...${totalDaysOfMonth.length}");
      // for (int i = 0; i < 30; i++) {
      for (int i = 0; i < totalDaysOfMonth.length; i++) {

        if(allLast30DaysList.isEmpty){
          allLast30DaysList.add(dateTime);
        }else {
          dateTime = dateTime.subtract(const Duration(days: 1));
          allLast30DaysList.add(dateTime);
        }
        if(weeksOfMonthsList.isEmpty) {
          var data = WeeksOfMonths();
          data.endDate = dateTime;
          data.startDate = findFirstDateOfTheWeek(dateTime);
          weeksOfMonthsList.add(data);
        }else {
          List<WeeksOfMonths> singleListData = [];
          singleListData.add(weeksOfMonthsList[weeksOfMonthsList.length - 1]);
          var tempDateList =
          singleListData.where((element) => element.startDate != dateTime.add(const Duration(days: 1))).toList();
          if(tempDateList.isEmpty){
            var data = WeeksOfMonths();
            data.endDate = dateTime;
            data.startDate = findFirstDateOfTheWeek(dateTime);
            weeksOfMonthsList.add(data);
          }
        }
      }

      var lastData = weeksOfMonthsList[weeksOfMonthsList.length - 1];
      var startDateReplace = lastData.startDate;
      for (int o = 0; o < 7; o++) {
        var dates = DateTime(startDateReplace.year, startDateReplace.month, startDateReplace.day + o);

        int daysInMonth = DateTimeRange(end: weeksOfMonthsList[0].endDate
            ,start: DateTime(dates.year,dates.month,dates.day - 1)).duration.inDays;
        var totalDaysOfMonth = Utils.getDatesInMonthCountWise(lastDateOfMonth.year, lastDateOfMonth.month);

        if(dates.month == Utils.allYearlyMonths[i].number && daysInMonth == totalDaysOfMonth.length){
          weeksOfMonthsList[weeksOfMonthsList.length - 1].startDate = dates;
          break;
        }
      }

      for (int p = 0; p < weeksOfMonthsList.length; p++) {
        weeksOfMonthsList[p].listAllTheDate.addAll(getDaysInBetween(weeksOfMonthsList[p].startDate,
            weeksOfMonthsList[p].endDate));
      }
      data = MonthlyLogDataClass(Utils.allYearlyMonths[i].name,weeksOfMonthsList,currentSelectedYear);

      data.monthStartAndEndDataList.addAll(getDaysInBetween(weeksOfMonthsList[weeksOfMonthsList.length - 1].startDate,
          weeksOfMonthsList[0].endDate));

      /// Above process is for the last 30 days date calculation
      /// And now it will start process for the data calculation from the history table data

      var totalWorkedDay = 0.0;
      var totalWorkedMin = 0.0;
      var totalCheckedBox = 0.0;
      var totalMinWeekly = 0.0;
      var maxWeeksDayCount = 0;
      var previousWeeksDayCount = 0;

/*      var dailyDateWiseData = dataListHive.where((elementDaily) => elementDaily.title == null &&
          elementDaily.type == Constant.typeDay && elementDaily.total != 0 && elementDaily.total != null &&
          data.monthStartAndEndDataList.where((element) => elementDaily.dateTime == element).isNotEmpty).toList();*/

      var dailyDateWiseData = dataListHive
          .where((elementDaily) =>
              elementDaily.title == null &&
              elementDaily.type == Constant.typeDay &&
              elementDaily.total != 0 &&
              elementDaily.total != null &&
                  Utils.getDatesInMonth(data.year, data.monthName)
                      .where((elementAllDate) => Utils.getDateFromFullDate(elementAllDate) ==
                      Utils.getDateFromFullDate(elementDaily.dateTime ?? DateTime.now()))
                      .toList()
                      .isNotEmpty)
          .toList();


      if(dataListHive.isNotEmpty) {
        if (dailyDateWiseData.isNotEmpty) {
          ///Date wise level and if found only week then also we have to calculate week
          for (int b = 0; b < data.weeksOfMonthsList.length; b++) {
            var dayLevelDataList = dataListHive
                .where((elementMain) =>
            elementMain.type == Constant.typeDay &&
                elementMain.dateTime!.month ==
                    Utils.allYearlyMonths[i].number &&
                data.weeksOfMonthsList[b].listAllTheDate
                    .where((element) => Utils.getDateFromFullDate(element) ==
                    Utils.getDateFromFullDate(elementMain.dateTime ?? DateTime.now()))
                    .toList()
                    .isNotEmpty && (elementMain.title == null || elementMain.title == Constant.titleDaysStr)).toList();

            ///This is for day level
            if (dayLevelDataList.isNotEmpty) {
              for (var element in dayLevelDataList) {
                if(element.title == null) {
                  totalWorkedMin += element.total ?? 0;
                }
                if (element.isCheckedDay ?? false) {
                  totalCheckedBox++;
                }
              }
              var lengthOfList = dayLevelDataList
                  .where((element) =>
              element.total != 0 && element.total != null &&
                  element.title == null)
                  .toList();
              totalWorkedDay += lengthOfList.length;
              if (maxWeeksDayCount >= 0 &&
                  maxWeeksDayCount < lengthOfList.length) {
                maxWeeksDayCount = lengthOfList.length;
              }
            }

            ///This is for week level
            else {
              var dailyDateWiseData = dataListHive.where((elementDaily) =>
              elementDaily.title == null &&
                  elementDaily.type == Constant.typeDay).toList();

              var dataWeekList = dataListHive
                  .where((elementMain) =>
              elementMain.type == Constant.typeWeek &&
                  elementMain.title == null &&
                  dailyDateWiseData
                      .where((element) =>
                  element.weeksDate != elementMain.weeksDate)
                      .toList()
                      .isNotEmpty)
                  .toList();

              for (int t = 0; t < dataWeekList.length; t++) {
                /*DateTime startDate = DateFormat(
                    Constant.commonDateFormatDdMmYyyy)
                    .parse(dataWeekList[t].weeksDate!.split("-")[0]);
                DateTime endDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
                    .parse(dataWeekList[t].weeksDate!.split("-")[1]);
*/
                DateTime startDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
                // .parse(dailyDateWiseData[e].weeksDate!.split("-")[0]);
                    .parse("${dataWeekList[t].weeksDate!.split("-")[0]}-${dataWeekList[t].weeksDate!.split("-")[1]}-${dataWeekList[t].weeksDate!.split("-")[2]}");
                DateTime endDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
                    .parse("${dataWeekList[t].weeksDate!.split("-")[3]}-${dataWeekList[t].weeksDate!.split("-")[4]}-${dataWeekList[t].weeksDate!.split("-")[5]}");
                // .parse(dailyDateWiseData[e].weeksDate!.split("-")[1]);


                var listOfWeeksData = getDaysInBetween(startDate, endDate);

                var foundedDateList = listOfWeeksData
                    .where((elementMain) =>
                data.weeksOfMonthsList[b].listAllTheDate
                    .where((element) =>
                element == elementMain &&
                    element.month == Utils.allYearlyMonths[i].number)
                    .isNotEmpty)
                    .toList();

                if (foundedDateList.isNotEmpty) {
                  if (dataWeekList[t].total != null &&
                      dataWeekList[t].total != 0) {
                    totalWorkedMin +=
                        (dataWeekList[t].total! / 7) * foundedDateList.length;
                    if (previousWeeksDayCount < maxWeeksDayCount &&
                        previousWeeksDayCount != 0) {
                      totalWorkedDay = totalWorkedDay - previousWeeksDayCount;
                      totalWorkedDay = totalWorkedDay + maxWeeksDayCount;
                    }
                    totalWorkedDay += maxWeeksDayCount;
                    previousWeeksDayCount = maxWeeksDayCount;
                    break;
                  }
                }
              }
            }
          }
        }
        /*else {
          /// Week wise level
          var dailyDateWiseData = dataListHive.where((elementDaily) =>
          elementDaily.title == null &&
              elementDaily.type == Constant.typeWeek).toList();

          for (int e = 0; e < dailyDateWiseData.length; e++) {
            DateTime startDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
                // .parse(dailyDateWiseData[e].weeksDate!.split("-")[0]);
                .parse("${dailyDateWiseData[e].weeksDate!.split("-")[0]}-${dailyDateWiseData[e].weeksDate!.split("-")[1]}-${dailyDateWiseData[e].weeksDate!.split("-")[2]}");
            DateTime endDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
                .parse("${dailyDateWiseData[e].weeksDate!.split("-")[3]}-${dailyDateWiseData[e].weeksDate!.split("-")[4]}-${dailyDateWiseData[e].weeksDate!.split("-")[5]}");
                // .parse(dailyDateWiseData[e].weeksDate!.split("-")[1]);

            var listOfWeeksData = getDaysInBetween(startDate, endDate);

            var foundedDateList = data.monthStartAndEndDataList
                .where((elementMain) =>
            listOfWeeksData
                .where((element) =>
            element == elementMain &&
                element.month == Utils.allYearlyMonths[i].number)
                .isNotEmpty)
                .toList();
            if (foundedDateList.isNotEmpty) {
              if (dailyDateWiseData[e].total != null &&
                  dailyDateWiseData[e].total != 0) {
                totalMinWeekly += (dailyDateWiseData[e].total! / 7) * foundedDateList.length;
              }
            }
          }
        }*/

        if (totalWorkedDay != 0) {
          Debug.printLog("totalWorkedDay monthly....$totalWorkedDay  $totalWorkedMin  $totalCheckedBox");
          data.dayPerWeekValue =
              double.parse((totalWorkedDay / 5).ceil().toStringAsFixed(2))
                  .toInt();
          data.dayPerWeekController.text = data.dayPerWeekValue.toString();

          data.avgMinValue = double.parse(
              (totalWorkedMin / totalWorkedDay).ceil().toStringAsFixed(2))
              .toInt();
          data.avgMinController.text = data.avgMinValue.toString();

          if(data.avgMinValue != null && data.dayPerWeekValue != null) {
            data.avgMinPerWeekValue = double.parse(
                (data.dayPerWeekValue! * data.avgMinValue!).toStringAsFixed(2))
                .toInt();
          }
          data.avgMinPerWeekController.text =
              data.avgMinPerWeekValue.toString();

          data.strengthValue =
              double.parse((totalCheckedBox / 5).round().toStringAsFixed(2))
                  .toInt();
          data.strengthController.text = data.strengthValue.toString();

          data.isOnlyWeeklyCount = false;
        }
        else if (totalMinWeekly != 0) {
          Debug.printLog("totalMinWeekly monthly....$totalWorkedDay  $totalWorkedMin  $totalCheckedBox  $totalMinWeekly");
          data.avgMinPerWeekValue =
              double.parse((totalMinWeekly / 5).ceil().toStringAsFixed(2))
                  .toInt();
          data.avgMinPerWeekController.text =
              data.avgMinPerWeekValue.toString();
          data.isOnlyWeeklyCount = true;

          // var monthlyDataDbList = Hive.box<MonthlyLogTableData>(Constant.tableMonthlyLog).values.toList();
          var monthlyDataDbList = getMonthlyDataList();

          var currentRunningMonth = Utils.allYearlyMonths[i].name;
          if (monthlyDataDbList.isNotEmpty) {
            var foundedList = monthlyDataDbList.where((element) =>
            element.year == currentSelectedYear &&
                element.monthName == currentRunningMonth).toList();
            if (foundedList.isNotEmpty) {
              var dayPerWeekValue = foundedList[0].dayPerWeekValue ?? 0;
              var avgMinValue = foundedList[0].avgMinValue ?? 0;

              if (dayPerWeekValue != 0) {
                data.dayPerWeekValue = dayPerWeekValue.ceil();
                data.dayPerWeekController.text =
                    data.dayPerWeekValue.toString();
              }
              if (avgMinValue != 0) {
                data.avgMinValue = avgMinValue.ceil();
                data.avgMinController.text = data.avgMinValue.toString();
              }
            }
          }
        }

        // if (needAPICall) {
        // }

        ///Call Api
        var monthlyDataDbList = getMonthlyDataList();

        var dataMonthlyList = monthlyDataDbList.where((element) => element.monthName ==  Utils.allYearlyMonths[i].name
            && element.year == currentSelectedYear).toList();
        if(dataMonthlyList.isNotEmpty){
          var dayPerWeekValue = dataMonthlyList[0].dayPerWeekValue;
          var avgMinValue = dataMonthlyList[0].avgMinValue;
          var avgMinPerWeekValue = dataMonthlyList[0].avgMInPerWeekValue;
          var strengthValue = dataMonthlyList[0].strengthValue;
          var isOverrideDayPerWeek = dataMonthlyList[0].isOverrideDayPerWeek;
          var isOverrideAvgMin = dataMonthlyList[0].isOverrideAvgMin;
          var isOverrideAvgMinPerWeek = dataMonthlyList[0].isOverrideAvgMinPerWeek;
          var isOverrideStrength = dataMonthlyList[0].isOverrideStrength;

          // if(isOverrideDayPerWeek) {
            if (dayPerWeekValue != null && dayPerWeekValue.toString() != "0.0") {
              data.dayPerWeekValue = dayPerWeekValue.toInt();
              data.dayPerWeekController.text = data.dayPerWeekValue.toString();
            }else if(dayPerWeekValue.toString() == "0.0" && data.dayPerWeekValue.toString() != "0"){
              data.dayPerWeekController.text = data.dayPerWeekValue.toString();
            }
          // }
          // data.isOverrideDayPerWeek = isOverrideDayPerWeek;


          // if(isOverrideAvgMin) {
            if (avgMinValue != null && avgMinValue.toString() != "0.0") {
              data.avgMinValue = avgMinValue.toInt();
              data.avgMinController.text = data.avgMinValue.toString();
            }else if(avgMinValue.toString() == "0.0" && data.avgMinValue.toString() != "0"){
              data.avgMinController.text = data.avgMinValue.toString();
            }
          // }
          // data.isOverrideAvgMin = isOverrideAvgMin;


          // if(isOverrideAvgMinPerWeek) {
            if (avgMinPerWeekValue != null && avgMinPerWeekValue.toString() != "0.0") {
              data.avgMinPerWeekValue = avgMinPerWeekValue.toInt();
              data.avgMinPerWeekController.text =
                  data.avgMinPerWeekValue.toString();
            }else if(avgMinPerWeekValue.toString() == "0.0" && data.avgMinPerWeekValue.toString() != "0"){
              data.avgMinPerWeekController.text = data.avgMinPerWeekValue.toString();
            }
          // }
          // data.isOverrideAvgMinPerWeek = isOverrideAvgMinPerWeek;


          // if(isOverrideStrength) {
            if (strengthValue != null && strengthValue.toString() != "0.0") {
              data.strengthValue = strengthValue.toInt();
              data.strengthController.text = data.strengthValue.toString();
            }else if(strengthValue.toString() == "0.0" && data.strengthValue.toString() != "0"){
              data.strengthController.text = data.strengthValue.toString();
            }
            // data.isOverrideStrength = isOverrideStrength;
          // }

        }
      }
      else {
        getDirectValueFromTheDb(data,i);
      }
      await callApiForInsert(i, data,needAPICall);

      monthlyDataList.add(data);

    }

   /* if(needInsertDataAfterMethodCall) {
      if(monthlyDataList.isNotEmpty){
        var currentMonthData = monthlyDataList.where((element) => element.monthName == monthNameSelected).toList();
        if(currentMonthData.isNotEmpty){
          if(currentMonthData[0].dayPerWeekValue != null && currentMonthData[0].dayPerWeekValue != 0) {
            monthlyDataInsertUpdate(
                currentMonthData[0], currentMonthData[0].dayPerWeekValue,
                Constant.typeDayPerWeek, false);
          }

          if(currentMonthData[0].avgMinValue != null && currentMonthData[0].avgMinValue != 0) {
            monthlyDataInsertUpdate(
                currentMonthData[0], currentMonthData[0].avgMinValue,
                Constant.typeAvgMin, false);
          }

          if(currentMonthData[0].avgMinPerWeekValue != null && currentMonthData[0].avgMinPerWeekValue != 0) {
            monthlyDataInsertUpdate(
                currentMonthData[0], currentMonthData[0].avgMinPerWeekValue,
                Constant.typeAvgMinPerWeek, false);
          }

          if(currentMonthData[0].strengthValue != null && currentMonthData[0].strengthValue != 0) {
            monthlyDataInsertUpdate(
                currentMonthData[0], currentMonthData[0].strengthValue,
                Constant.typeStrength, false);
          }
        }
      }

    }*/

    initAllFocusNode();
    update();
  }

  /*callApiForInsert(int i, MonthlyLogDataClass data, bool needAPICall) async {
    if(!needAPICall){
      return;
    }
    var startDateOfMonth = data.monthStartAndEndDataList[0];
    var endDateOfMonth =
        data.monthStartAndEndDataList[data.monthStartAndEndDataList.length - 1];
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
      var avgMinValue = data.dayPerWeekController.text;
      var oldValue = data.dayPerWeekValue.toString();
      Debug.printLog("dayPerWeekValue...$oldValue  $avgMinValue");
      if (oldValue != "" && oldValue != "null") {
        await callMonthGetAPICall(
            data, avgMinValue, Constant.typeDayPerWeek, true);
        List<SyncMonthlyActivityData> allSyncingData = [];
        await Syncing.syncMonthlyDataDayPerWeek(
            getMonthlyDataList(), allSyncingData, i,
            isFromRefresh: false,
            startDate: startDateOfMonth,
            endDate: endDateOfMonth);
        await Syncing.observationSyncDataDaysPerWeeks(allSyncingData);
        Debug.printLog("avgMinValue...$oldValue  $allSyncingData");
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
      var avgMinValue = data.avgMinController.text;
      var oldValue = data.avgMinValue.toString();
      if (oldValue != "" && oldValue != "null") {
        await callMonthGetAPICall(data, avgMinValue, Constant.typeAvgMin, true);
        List<SyncMonthlyActivityData> allSyncingData = [];
        await Syncing.syncMonthlyDataAverageMin(
            getMonthlyDataList(), allSyncingData, i,
            isFromRefresh: false,
            startDate: startDateOfMonth,
            endDate: endDateOfMonth);
        await Syncing.observationSyncDataMinPerDay(allSyncingData);
        Debug.printLog("isSyncAvgMin...$oldValue  $allSyncingData");
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
      var avgMinValue = data.avgMinPerWeekController.text;
      var oldValue = data.avgMinPerWeekValue.toString();
      Debug.printLog("avgMinPerWeekValue...$oldValue");
      if (oldValue != "" && oldValue != "null") {
        await callMonthGetAPICall(
            data, avgMinValue, Constant.typeAvgMinPerWeek, true);
        List<SyncMonthlyActivityData> allSyncingData = [];
        await Syncing.syncMonthlyDataAverageMinPerWeek(
            getMonthlyDataList(), allSyncingData, i,
            isFromRefresh: false,
            startDate: startDateOfMonth,
            endDate: endDateOfMonth);
        await Syncing.observationSyncDataMinPerWeek(allSyncingData);
        Debug.printLog("isSyncAvgMinPerWeek...$oldValue  $allSyncingData");
      }
    }


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
      var avgMinValue = data.strengthController.text;
      var oldValue = data.strengthValue.toString();
      Debug.printLog("strengthValue...$oldValue");
      if (oldValue != "" && oldValue != "null") {
        await callMonthGetAPICall(
            data, avgMinValue, Constant.typeStrength, true);
        List<SyncMonthlyActivityData> allSyncingData = [];
        await Syncing.syncMonthlyDataStrength(
            getMonthlyDataList(), allSyncingData, i,
            isFromRefresh: false,
            startDate: startDateOfMonth,
            endDate: endDateOfMonth);
        await Syncing.observationSyncDataStrengthDaysPerWeek(allSyncingData);
        Debug.printLog("isSyncStrength...$oldValue  $allSyncingData");
      }
    }
  }*/

  callApiForInsert(int i, MonthlyLogDataClass data, bool needAPICall) async {
    if(!needAPICall){
      return;
    }

    var dayPerWeekValue = data.dayPerWeekController.text;
    await callMonthGetAPICall(
        data, dayPerWeekValue, Constant.typeDayPerWeek, true);

    var avgMinValue = data.avgMinController.text;
    await callMonthGetAPICall(data, avgMinValue, Constant.typeAvgMin, true);

    var avgMinPerWeekValue = data.avgMinPerWeekController.text;
    await callMonthGetAPICall(
        data, avgMinPerWeekValue, Constant.typeAvgMinPerWeek, true);

    var strengthValue = data.strengthController.text;
    await callMonthGetAPICall(
        data, strengthValue, Constant.typeStrength, true);
  }

  callMonthGetAPICall(MonthlyLogDataClass monthlyLogDataClass, value, int type,
      bool needAPICall) async {
    var monthlyDataDbList = getMonthlyDataList();

    if (type == Constant.typeDayPerWeek) {
      if (value == "") {
        monthlyLogDataClass.dayPerWeekValue = null;
        monthlyLogDataClass.dayPerWeekController.text = "";
        textFiledSelectionValueLength(
            monthlyLogDataClass.dayPerWeekController, 0);
      } else {
        monthlyLogDataClass.dayPerWeekValue = double.parse(value).toInt();
        monthlyLogDataClass.dayPerWeekController.text = value;
        textFiledSelectionValueLength(
            monthlyLogDataClass.dayPerWeekController, value.length);
      }
      // monthlyLogDataClass.isOverrideDayPerWeek = true;
      monthlyLogDataClass.isSyncDayPerWeek = false;
    }

    if (type == Constant.typeAvgMin) {
      if (value == "") {
        monthlyLogDataClass.avgMinValue = null;
        monthlyLogDataClass.avgMinController.text = "";
        textFiledSelectionValueLength(monthlyLogDataClass.avgMinController, 0);
      } else {
        monthlyLogDataClass.avgMinValue = double.parse(value).toInt();
        monthlyLogDataClass.avgMinController.text = value;
        textFiledSelectionValueLength(
            monthlyLogDataClass.avgMinController, value.length);
      }
      // monthlyLogDataClass.isOverrideAvgMin = true;
      monthlyLogDataClass.isSyncAvgMin = false;
    }

    if (type == Constant.typeAvgMinPerWeek) {
      if (value == "") {
        monthlyLogDataClass.avgMinPerWeekValue = null;
        monthlyLogDataClass.avgMinPerWeekController.text = "";
        textFiledSelectionValueLength(
            monthlyLogDataClass.avgMinPerWeekController, 0);
      } else {
        monthlyLogDataClass.avgMinPerWeekValue = double.parse(value).toInt();
        monthlyLogDataClass.avgMinPerWeekController.text = value;
        textFiledSelectionValueLength(
            monthlyLogDataClass.avgMinPerWeekController, value.length);
      }
      // monthlyLogDataClass.isOverrideAvgMinPerWeek = true;
      monthlyLogDataClass.isSyncAvgMinPerWeek = false;
    }

    if (type == Constant.typeStrength) {
      if (value == "") {
        monthlyLogDataClass.strengthValue = null;
        monthlyLogDataClass.strengthController.text = "";
        textFiledSelectionValueLength(
            monthlyLogDataClass.strengthController, 0);
      } else {
        monthlyLogDataClass.strengthValue = double.parse(value).toInt();
        monthlyLogDataClass.strengthController.text = value;
        textFiledSelectionValueLength(
            monthlyLogDataClass.strengthController, value.length);
      }
      // monthlyLogDataClass.isOverrideStrength = true;
      monthlyLogDataClass.isSyncStrength = false;
    }

    update();

    var dayPerWeekValue = monthlyLogDataClass.dayPerWeekController.text;
    var avgMinValue = monthlyLogDataClass.avgMinController.text;
    var avgMinPerWeekValue = monthlyLogDataClass.avgMinPerWeekController.text;
    var strengthValue = monthlyLogDataClass.strengthController.text;

    var foundedList = monthlyDataDbList
        .where((element) =>
            element.monthName == monthlyLogDataClass.monthName &&
            element.year == currentSelectedYear)
        .toList();

    if (foundedList.isNotEmpty) {
      ///Update

      // foundedList[0].isOverrideDayPerWeek = true;
      // foundedList[0].isOverrideAvgMin = true;
      // foundedList[0].isOverrideAvgMinPerWeek = true;
      // foundedList[0].isOverrideStrength = true;

      if (dayPerWeekValue == "") {
        foundedList[0].dayPerWeekValue = null;
      } else {
        foundedList[0].dayPerWeekValue =
            double.parse(dayPerWeekValue.toString());
      }

      if (avgMinValue == "") {
        foundedList[0].avgMinValue = null;
      } else {
        foundedList[0].avgMinValue = double.parse(avgMinValue.toString());
      }

      if (avgMinPerWeekValue == "") {
        foundedList[0].avgMInPerWeekValue = null;
      } else {
        foundedList[0].avgMInPerWeekValue =
            double.parse(avgMinPerWeekValue.toString());
      }

      if (strengthValue == "") {
        foundedList[0].strengthValue = null;
      } else {
        foundedList[0].strengthValue = double.parse(strengthValue.toString());
      }

      var allSelectedServersUrl = Utils.getServerListPreference()
          .where((element) => element.patientId != "" && element.isSelected)
          .toList();

      if (type == Constant.typeDayPerWeek) {
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
                  "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
              foundedList[0].serverDetailListDayPerWeek.add(data);
            }
          }
        }
      } else if (type == Constant.typeAvgMin) {
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
                  "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
              foundedList[0].serverDetailListAvgMin.add(data);
            }
          }
        }
      } else if (type == Constant.typeAvgMinPerWeek) {
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
                  "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
              foundedList[0].serverDetailListAvgMinWeek.add(data);
            }
          }
        }
      } else if (type == Constant.typeStrength) {
        foundedList[0].isSyncStrength = false;
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
              data.patientName =
                  "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
              foundedList[0].serverDetailListStrength.add(data);
            }
          }
        }
      }


      foundedList[0].startDate =
      monthlyLogDataClass.monthStartAndEndDataList[0];
      foundedList[0].endDate = monthlyLogDataClass.monthStartAndEndDataList[
      monthlyLogDataClass.monthStartAndEndDataList.length - 1];

      await DataBaseHelper.shared.updateMonthlyData(foundedList[0]);
    } else {
      ///Insert
      // var selectedData = monthlyDataList[index];
      var newMonthlyData = MonthlyLogTableData();
      newMonthlyData.monthName = monthlyLogDataClass.monthName;
      newMonthlyData.year = currentSelectedYear;
      newMonthlyData.isOverrideDayPerWeek = true;
      newMonthlyData.isOverrideAvgMin = true;
      newMonthlyData.isOverrideAvgMinPerWeek = true;
      newMonthlyData.isOverrideStrength = true;
      newMonthlyData.startDate =
          monthlyLogDataClass.monthStartAndEndDataList[0];
      newMonthlyData.endDate = monthlyLogDataClass.monthStartAndEndDataList[
          monthlyLogDataClass.monthStartAndEndDataList.length - 1];

      if (dayPerWeekValue == "") {
        newMonthlyData.dayPerWeekValue = null;
      } else {
        newMonthlyData.dayPerWeekValue =
            double.parse(dayPerWeekValue.toString());
      }

      if (avgMinValue == "") {
        newMonthlyData.avgMinValue = null;
      } else {
        newMonthlyData.avgMinValue = double.parse(avgMinValue.toString());
      }

      if (avgMinPerWeekValue == "") {
        newMonthlyData.avgMInPerWeekValue = null;
      } else {
        newMonthlyData.avgMInPerWeekValue =
            double.parse(avgMinPerWeekValue.toString());
      }

      if (strengthValue == "") {
        newMonthlyData.strengthValue = null;
      } else {
        newMonthlyData.strengthValue = double.parse(strengthValue.toString());
      }

      if (type == Constant.typeDayPerWeek) {
        newMonthlyData.isSyncDayPerWeek = false;
        var connectedServerUrl = Utils.getServerListPreference()
            .where((element) => element.patientId != "" && element.isSelected)
            .toList();
        if (connectedServerUrl.isNotEmpty) {
          for (int i = 0; i < connectedServerUrl.length; i++) {
            var data = ServerDetailDataTable();
            data.serverUrl = connectedServerUrl[i].url;
            data.patientId = connectedServerUrl[i].patientId;
            data.clientId = connectedServerUrl[i].clientId;
            data.objectId = "";
            data.serverToken = connectedServerUrl[i].authToken;
            data.patientName =
                "${connectedServerUrl[i].patientFName}${connectedServerUrl[i].patientLName}";
            newMonthlyData.serverDetailListDayPerWeek.add(data);
          }
        }
      } else if (type == Constant.typeAvgMin) {
        newMonthlyData.isSyncAvgMin = false;
        var connectedServerUrl = Utils.getServerListPreference()
            .where((element) => element.patientId != "" && element.isSelected)
            .toList();

        if (connectedServerUrl.isNotEmpty) {
          for (int i = 0; i < connectedServerUrl.length; i++) {
            var data = ServerDetailDataTable();
            data.serverUrl = connectedServerUrl[i].url;
            data.patientId = connectedServerUrl[i].patientId;
            data.clientId = connectedServerUrl[i].clientId;
            data.objectId = "";
            data.serverToken = connectedServerUrl[i].authToken;
            data.patientName =
                "${connectedServerUrl[i].patientFName}${connectedServerUrl[i].patientLName}";
            newMonthlyData.serverDetailListAvgMin.add(data);
          }
        }
      } else if (type == Constant.typeAvgMinPerWeek) {
        newMonthlyData.isSyncAvgMinPerWeek = false;
        var connectedServerUrl = Utils.getServerListPreference()
            .where((element) => element.patientId != "" && element.isSelected)
            .toList();

        if (connectedServerUrl.isNotEmpty) {
          for (int i = 0; i < connectedServerUrl.length; i++) {
            var data = ServerDetailDataTable();
            data.serverUrl = connectedServerUrl[i].url;
            data.patientId = connectedServerUrl[i].patientId;
            data.clientId = connectedServerUrl[i].clientId;
            data.objectId = "";
            data.serverToken = connectedServerUrl[i].authToken;
            data.patientName =
                "${connectedServerUrl[i].patientFName}${connectedServerUrl[i].patientLName}";
            newMonthlyData.serverDetailListAvgMinWeek.add(data);
          }
        }
      } else if (type == Constant.typeStrength) {
        newMonthlyData.isSyncStrength = false;
        var connectedServerUrl = Utils.getServerListPreference()
            .where((element) => element.patientId != "" && element.isSelected)
            .toList();

        if (connectedServerUrl.isNotEmpty) {
          for (int i = 0; i < connectedServerUrl.length; i++) {
            var data = ServerDetailDataTable();
            data.serverUrl = connectedServerUrl[i].url;
            data.patientId = connectedServerUrl[i].patientId;
            data.clientId = connectedServerUrl[i].clientId;
            data.objectId = "";
            data.serverToken = connectedServerUrl[i].authToken;
            data.patientName =
                "${connectedServerUrl[i].patientFName}${connectedServerUrl[i].patientLName}";
            newMonthlyData.serverDetailListStrength.add(data);
          }
        }
      }

      await DataBaseHelper.shared.insertMonthlyData(newMonthlyData);
    }
  }

  getDirectValueFromTheDb(MonthlyLogDataClass data, int i){
    // var monthlyDataDbList = Hive.box<MonthlyLogTableData>(Constant.tableMonthlyLog).values.toList();
    var monthlyDataDbList = getMonthlyDataList();

    var dataMonthlyList = monthlyDataDbList.where((element) => element.monthName ==  Utils.allYearlyMonths[i].name
        && element.year == currentSelectedYear).toList();

    if(dataMonthlyList.isNotEmpty){
      var dayPerWeekValue = dataMonthlyList[0].dayPerWeekValue;
      var avgMinValue = dataMonthlyList[0].avgMinValue;
      var avgMinPerWeekValue = dataMonthlyList[0].avgMInPerWeekValue;
      var strengthValue = dataMonthlyList[0].strengthValue;
      var isOverrideDayPerWeek = dataMonthlyList[0].isOverrideDayPerWeek;
      var isOverrideAvgMin = dataMonthlyList[0].isOverrideAvgMin;
      var isOverrideAvgMinPerWeek = dataMonthlyList[0].isOverrideAvgMinPerWeek;
      var isOverrideStrength = dataMonthlyList[0].isOverrideStrength;

      if(dayPerWeekValue != null) {
        data.dayPerWeekValue = dayPerWeekValue.toInt();
        data.dayPerWeekController.text = data.dayPerWeekValue.toString();
      }else{
        data.dayPerWeekValue = null;
        data.dayPerWeekController.text = "";
      }
      data.isOverrideDayPerWeek = isOverrideDayPerWeek;

      if(avgMinValue != null) {
        data.avgMinValue = avgMinValue.toInt();
        data.avgMinController.text = data.avgMinValue.toString();
      }else{
        data.avgMinValue = null;
        data.avgMinController.text = "";
      }
      data.isOverrideAvgMin = isOverrideAvgMin;

      if(avgMinPerWeekValue != null) {
        data.avgMinPerWeekValue = avgMinPerWeekValue.toInt();
        data.avgMinPerWeekController.text =
            data.avgMinPerWeekValue.toString();
      }else{
        data.avgMinPerWeekValue = null;
        data.avgMinPerWeekController.text = "";
      }
      data.isOverrideAvgMinPerWeek = isOverrideAvgMinPerWeek;

      if(strengthValue != null) {
        data.strengthValue = strengthValue.toInt();
        data.strengthController.text = data.strengthValue.toString();
      }else{
        data.strengthValue = null;
        data.strengthController.text = "";
      }
      data.isOverrideStrength = isOverrideStrength;

    }
  }

  List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    final daysToGenerate = endDate.difference(startDate).inDays + 1;
    return List.generate(daysToGenerate, (i) => startDate.add(Duration(days: i)));
  }

  Future<void> getAndSetWeeksData({required bool isNext}) async {
    if(isNext) {
      currentSelectedYear = DateTime(currentSelectedYear).year + 1;
    }else{
      currentSelectedYear = DateTime(currentSelectedYear).year - 1;
    }
    currentSelectedMonth = DateTime(currentSelectedYear).month -1;
    getMonthlyData();
    await monthlyDataAPICall();
    // if(patientId != "" && foundedList.isEmpty&&

  }

  monthlyDataAPICall({bool needGetDataAgain = false}) async {

    // if(Utils.getAPIEndPoint() != "" && Utils.getPatientId() != "") {
    var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();

    if(allSelectedServersUrl.isNotEmpty) {
      var monthlyData = getMonthlyDataList().where((element) => element.year == currentSelectedYear);
      // if(monthlyData.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Utils.showDialogForProgress(Get.context!,Constant.txtPleaseWait,Constant.txtMonthlyDataProgress);
        });
      // }
      await Utils.setMonthlyAndActivityData(currentSelectedYear.toString(),isFromMonth: true,isFromActivity: false);
      await getMonthlyData(needAPICall: false);
      // if(monthlyData.isEmpty) {
        Get.back();
      // }
    }
  }

  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    DateTime date = dateTime.subtract(Duration(days: dateTime.weekday));
    if(dateTime.month != date.month) {
      date = DateTime(dateTime.year, dateTime.month, 1);
    }
    return date;
  }

  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday - 1));
  }

  monthlyDataInsertUpdate(MonthlyLogDataClass monthlyLogDataClass,value,int type,bool needAPICall) async {
    var index = monthlyDataList.indexOf(monthlyLogDataClass);
    Debug.printLog("monthlyDataInsertUpdate..$type  $value $index");
    if(index != -1){
      // var monthlyDataDbList = Hive.box<MonthlyLogTableData>(Constant.tableMonthlyLog).values.toList();
      var monthlyDataDbList = getMonthlyDataList();

      if(type == Constant.typeDayPerWeek){
        if(value == ""){
          // monthlyLogDataClass.dayPerWeekValue = null;
          monthlyLogDataClass.dayPerWeekController.text = "";
          textFiledSelectionValueLength(monthlyLogDataClass.dayPerWeekController,0);
        }else{
          monthlyLogDataClass.dayPerWeekValue = double.parse(value).toInt();
          monthlyLogDataClass.dayPerWeekController.text = value;
          textFiledSelectionValueLength(monthlyLogDataClass.dayPerWeekController,value.length);
        }
        monthlyLogDataClass.isOverrideDayPerWeek = true;
        monthlyLogDataClass.isSyncDayPerWeek = false;
        monthlyDataList[index].isSyncDayPerWeek = false;
      }

      if(type == Constant.typeAvgMin){
        if(value == ""){
          // monthlyLogDataClass.avgMinValue = null;
          monthlyLogDataClass.avgMinController.text = "";
          textFiledSelectionValueLength(monthlyLogDataClass.avgMinController,0);
        }else{
          monthlyLogDataClass.avgMinValue = double.parse(value).toInt();
          monthlyLogDataClass.avgMinController.text = value;
          textFiledSelectionValueLength(monthlyLogDataClass.avgMinController,value.length);
        }
        monthlyLogDataClass.isOverrideAvgMin = true;
        monthlyLogDataClass.isSyncAvgMin = false;
        monthlyDataList[index].isSyncAvgMin = false;
      }

      if(type == Constant.typeAvgMinPerWeek){
        if(value == ""){
          // monthlyLogDataClass.avgMinPerWeekValue = null;
          monthlyLogDataClass.avgMinPerWeekController.text = "";
          textFiledSelectionValueLength(monthlyLogDataClass.avgMinPerWeekController,0);
        }else{
          monthlyLogDataClass.avgMinPerWeekValue = double.parse(value).toInt();
          monthlyLogDataClass.avgMinPerWeekController.text = value;
          textFiledSelectionValueLength(monthlyLogDataClass.avgMinPerWeekController,value.length);
        }
        monthlyLogDataClass.isOverrideAvgMinPerWeek = true;
        monthlyLogDataClass.isSyncAvgMinPerWeek = false;
        monthlyDataList[index].isSyncAvgMinPerWeek = false;
      }

      if(type == Constant.typeStrength){
        if(value == ""){
          // monthlyLogDataClass.strengthValue = null;
          monthlyLogDataClass.strengthController.text = "";
          textFiledSelectionValueLength(monthlyLogDataClass.strengthController,0);
        }else{
          monthlyLogDataClass.strengthValue = double.parse(value).toInt();
          monthlyLogDataClass.strengthController.text = value;
          textFiledSelectionValueLength(monthlyLogDataClass.strengthController,value.length);
        }
        monthlyLogDataClass.isOverrideStrength = true;
        monthlyLogDataClass.isSyncStrength = false;
        monthlyDataList[index].isSyncStrength = false;
      }

      update();

      var dayPerWeekValue = monthlyLogDataClass.dayPerWeekController.text;
      var avgMinValue = monthlyLogDataClass.avgMinController.text;
      var avgMinPerWeekValue = monthlyLogDataClass.avgMinPerWeekController.text;
      var strengthValue = monthlyLogDataClass.strengthController.text;

      if (dayPerWeekValue == "") {
        monthlyDataList[index].dayPerWeekController.text = "";
        // monthlyDataList[index].dayPerWeekValue = null;
        monthlyDataList[index].dayPerWeekController.selection =
            TextSelection.fromPosition(const TextPosition(offset: 0));
      } else {
        monthlyDataList[index].dayPerWeekController.text = dayPerWeekValue.toString();
        monthlyDataList[index].dayPerWeekValue = int.parse(dayPerWeekValue.toString());
        monthlyDataList[index].dayPerWeekController.selection =
            TextSelection.fromPosition(TextPosition(offset: dayPerWeekValue.length));
      }


      if (avgMinValue == "") {
        monthlyDataList[index].avgMinController.text = "";
        // monthlyDataList[index].avgMinValue = null;
        monthlyDataList[index].avgMinController.selection =
            TextSelection.fromPosition(const TextPosition(offset: 0));
      } else {
        monthlyDataList[index].avgMinController.text = avgMinValue.toString();
        monthlyDataList[index].avgMinValue = int.parse(avgMinValue.toString());
        monthlyDataList[index].avgMinController.selection =
            TextSelection.fromPosition(TextPosition(offset: avgMinValue.length));
      }


      if (avgMinPerWeekValue == "") {
        monthlyDataList[index].avgMinPerWeekController.text = "";
        // monthlyDataList[index].avgMinPerWeekValue = null;
        monthlyDataList[index].avgMinPerWeekController.selection =
            TextSelection.fromPosition(const TextPosition(offset: 0));
      } else {
        monthlyDataList[index].avgMinPerWeekController.text = avgMinPerWeekValue.toString();
        monthlyDataList[index].avgMinPerWeekValue = int.parse(avgMinPerWeekValue.toString());
        monthlyDataList[index].avgMinPerWeekController.selection =
            TextSelection.fromPosition(TextPosition(offset: avgMinPerWeekValue.length));
      }


      if (strengthValue == "") {
        monthlyDataList[index].strengthController.text = "";
        // monthlyDataList[index].strengthValue = null;
        monthlyDataList[index].strengthController.selection =
            TextSelection.fromPosition(const TextPosition(offset: 0));
      } else {
        monthlyDataList[index].strengthController.text = strengthValue.toString();
        monthlyDataList[index].strengthValue = int.parse(strengthValue.toString());
        monthlyDataList[index].strengthController.selection =
            TextSelection.fromPosition(TextPosition(offset: strengthValue.length));
      }


      var foundedList = monthlyDataDbList.where((element) => element.monthName == monthlyLogDataClass.monthName
          && element.year == currentSelectedYear).toList();

      if(foundedList.isNotEmpty){
        ///Update


        // if (type == Constant.typeDayPerWeek) {
        //   foundedList[0].syncDayPerWeekServerWiseList = [];
        //   await DataBaseHelper.shared.updateMonthlyData(foundedList[0]);
        // }
        // else if (type == Constant.typeAvgMin) {
        //   foundedList[0].syncAvgMinServerWiseList = [];
        //   await DataBaseHelper.shared.updateMonthlyData(foundedList[0]);
        // }
        // else if (type == Constant.typeAvgMinPerWeek) {
        //   foundedList[0].syncAvgMinPerWeekServerWiseList = [];
        //   await DataBaseHelper.shared.updateMonthlyData(foundedList[0]);
        // }
        // else if (type == Constant.typeStrength) {
        //   foundedList[0].syncStrengthServerWiseList = [];
        //   await DataBaseHelper.shared.updateMonthlyData(foundedList[0]);
        // }

        foundedList[0].isOverrideDayPerWeek = true;
        foundedList[0].isOverrideAvgMin = true;
        foundedList[0].isOverrideAvgMinPerWeek = true;
        foundedList[0].isOverrideStrength = true;

        if(dayPerWeekValue == ""){
          // foundedList[0].dayPerWeekValue  = null;
        }else{
          foundedList[0].dayPerWeekValue  = double.parse(dayPerWeekValue.toString());
        }

        if(avgMinValue == ""){
          // foundedList[0].avgMinValue  = null;
        }else{
          foundedList[0].avgMinValue  = double.parse(avgMinValue.toString());
        }

        if(avgMinPerWeekValue == ""){
          // foundedList[0].avgMInPerWeekValue  = null;
        }else{
          foundedList[0].avgMInPerWeekValue  = double.parse(avgMinPerWeekValue.toString());
        }

        if(strengthValue == ""){
          // foundedList[0].strengthValue  = null;
        }else{
          foundedList[0].strengthValue  = double.parse(strengthValue.toString());
        }

        var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();

        if (type == Constant.typeDayPerWeek) {
          foundedList[0].isSyncDayPerWeek = false;
          /*for (int i = 0; i < allSelectedServersUrl.length; i++) {
            foundedList[0].syncDayPerWeekServerWiseList.add(false);
          }*/
          if(foundedList[0].serverDetailListDayPerWeek.length != allSelectedServersUrl.length){
            for (int i = 0; i < allSelectedServersUrl.length; i++) {
              var url = foundedList[0].serverDetailListDayPerWeek;
              if(url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty){
                var data = ServerDetailDataTable();
                data.serverUrl = allSelectedServersUrl[i].url;
                data.patientId = allSelectedServersUrl[i].patientId;
                data.objectId = "";
                data.patientName = "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
                foundedList[0].serverDetailListDayPerWeek.add(data);
              }
            }
          }
        }
        else if (type == Constant.typeAvgMin) {
          foundedList[0].isSyncAvgMin = false;
          if(foundedList[0].serverDetailListAvgMin.length != allSelectedServersUrl.length){
            for (int i = 0; i < allSelectedServersUrl.length; i++) {
              var url = foundedList[0].serverDetailListAvgMin;
              if(url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty){
                var data = ServerDetailDataTable();
                data.serverUrl = allSelectedServersUrl[i].url;
                data.patientId = allSelectedServersUrl[i].patientId;
                data.objectId = "";
                data.patientName = "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
                foundedList[0].serverDetailListAvgMin.add(data);
              }
            }
          }
        }
        else if (type == Constant.typeAvgMinPerWeek) {
          foundedList[0].isSyncAvgMinPerWeek = false;
          if(foundedList[0].serverDetailListAvgMinWeek.length != allSelectedServersUrl.length){
            for (int i = 0; i < allSelectedServersUrl.length; i++) {
              var url = foundedList[0].serverDetailListAvgMinWeek;
              if(url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty){
                var data = ServerDetailDataTable();
                data.serverUrl = allSelectedServersUrl[i].url;
                data.patientId = allSelectedServersUrl[i].patientId;
                data.objectId = "";
                data.patientName = "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
                foundedList[0].serverDetailListAvgMinWeek.add(data);
              }
            }
          }
        }
        else if (type == Constant.typeStrength) {
          foundedList[0].isSyncStrength = false;
          if(foundedList[0].serverDetailListStrength.length != allSelectedServersUrl.length){
            for (int i = 0; i < allSelectedServersUrl.length; i++) {
              var url = foundedList[0].serverDetailListStrength;
              if(url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty){
                var data = ServerDetailDataTable();
                data.serverUrl = allSelectedServersUrl[i].url;
                data.patientId = allSelectedServersUrl[i].patientId;
                data.objectId = "";
                data.patientName = "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
                foundedList[0].serverDetailListStrength.add(data);
              }
            }
          }
        }
        await DataBaseHelper.shared.updateMonthlyData(foundedList[0]);
      }
      else{
        ///Insert
        var selectedData = monthlyDataList[index];
        var newMonthlyData = MonthlyLogTableData();
        newMonthlyData.monthName = selectedData.monthName;
        newMonthlyData.year = currentSelectedYear;
        newMonthlyData.isOverrideDayPerWeek = true;
        newMonthlyData.isOverrideAvgMin = true;
        newMonthlyData.isOverrideAvgMinPerWeek = true;
        newMonthlyData.isOverrideStrength = true;
        newMonthlyData.startDate = monthlyLogDataClass.monthStartAndEndDataList[0];
        newMonthlyData.endDate = monthlyLogDataClass.monthStartAndEndDataList[monthlyLogDataClass.monthStartAndEndDataList.length - 1];

        if(dayPerWeekValue == ""){
          // newMonthlyData.dayPerWeekValue  = null;
        }else{
          newMonthlyData.dayPerWeekValue  = double.parse(dayPerWeekValue.toString());
        }

        if(avgMinValue == ""){
          // newMonthlyData.avgMinValue  = null;
        }else{
          newMonthlyData.avgMinValue  = double.parse(avgMinValue.toString());
        }

        if(avgMinPerWeekValue == ""){
          // newMonthlyData.avgMInPerWeekValue  = null;
        }else{
          newMonthlyData.avgMInPerWeekValue  = double.parse(avgMinPerWeekValue.toString());
        }

        if(strengthValue == ""){
          // newMonthlyData.strengthValue  = null;
        }else{
          newMonthlyData.strengthValue  = double.parse(strengthValue.toString());
        }

        if (type == Constant.typeDayPerWeek) {
          newMonthlyData.isSyncDayPerWeek = false;
          var connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
          if(connectedServerUrl.isNotEmpty) {
            for (int i = 0; i < connectedServerUrl.length; i++) {
              var data = ServerDetailDataTable();
              data.serverUrl = connectedServerUrl[i].url;
              data.patientId = connectedServerUrl[i].patientId;
              data.clientId = connectedServerUrl[i].clientId;
              data.objectId = "";
              data.serverToken = connectedServerUrl[i].authToken;
              data.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
                  .patientLName}";
              newMonthlyData.serverDetailListDayPerWeek.add(data);
            }
          }
        } else if (type == Constant.typeAvgMin) {
          newMonthlyData.isSyncAvgMin = false;
          var connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();

          if(connectedServerUrl.isNotEmpty) {
            for (int i = 0; i < connectedServerUrl.length; i++) {
              var data = ServerDetailDataTable();
              data.serverUrl = connectedServerUrl[i].url;
              data.patientId = connectedServerUrl[i].patientId;
              data.clientId = connectedServerUrl[i].clientId;
              data.objectId = "";
              data.serverToken = connectedServerUrl[i].authToken;
              data.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
                  .patientLName}";
              newMonthlyData.serverDetailListAvgMin.add(data);
            }
          }
        } else if (type == Constant.typeAvgMinPerWeek) {
          newMonthlyData.isSyncAvgMinPerWeek = false;
          var connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();

          if(connectedServerUrl.isNotEmpty) {
            for (int i = 0; i < connectedServerUrl.length; i++) {
              var data = ServerDetailDataTable();
              data.serverUrl = connectedServerUrl[i].url;
              data.patientId = connectedServerUrl[i].patientId;
              data.clientId = connectedServerUrl[i].clientId;
              data.objectId = "";
              data.serverToken = connectedServerUrl[i].authToken;
              data.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
                  .patientLName}";
              newMonthlyData.serverDetailListAvgMinWeek.add(data);
            }
          }
        } else if (type == Constant.typeStrength) {
          newMonthlyData.isSyncStrength = false;
          var connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();

          if(connectedServerUrl.isNotEmpty) {
            for (int i = 0; i < connectedServerUrl.length; i++) {
              var data = ServerDetailDataTable();
              data.serverUrl = connectedServerUrl[i].url;
              data.patientId = connectedServerUrl[i].patientId;
              data.clientId = connectedServerUrl[i].clientId;
              data.objectId = "";
              data.serverToken = connectedServerUrl[i].authToken;
              data.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
                  .patientLName}";
              newMonthlyData.serverDetailListStrength.add(data);
            }
          }
        }

        await DataBaseHelper.shared.insertMonthlyData(newMonthlyData);
      }

    }
    if(needAPICall) {
      if (Utils
          .getServerListPreference()
          .isNotEmpty) {
        var allSelectedServersUrl = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected).toList();
        var primaryServerData = allSelectedServersUrl.where((element) =>
        element.isPrimary).toList();
        /*if (primaryServerData.isNotEmpty) {
        var primaryData = primaryServerData[0];
        if (primaryData.isSecure &&
            Utils.isExpiredToken(
                primaryData.lastLoggedTime, primaryData.expireTime)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: Get.context!,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title:  const Text(Constant.txtExpireTitle),
                  content:  const Text(Constant.txtExpireDesc),
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
          });
          return;
        }
      }*/
        Debug.printLog("getServerListPreference..${Utils
            .getServerListPreference()
            .length}");
        DateTime monthStartDate = Utils.getFirstDateOfMonth(Utils.getMonthNumber(monthlyDataList[index].monthName), currentSelectedYear);
        DateTime monthEndDate = Utils.getLastDateOfMonth(Utils.getMonthNumber(monthlyDataList[index].monthName), currentSelectedYear);

        await Syncing.dataSyncingProcess(false,startDate: monthStartDate,endDate: monthEndDate);
      }
    }
  }

  textFiledSelectionValueLength(TextEditingController controller,int length){
    controller.selection =
        TextSelection.fromPosition(TextPosition(offset:length));
  }

  initAllFocusNode(){
    for (int i = 0; i < monthlyDataList.length; i++) {
      monthlyDataList[i].dayPerWeekFocus.addListener(() {
        var avgMinValue = monthlyDataList[i].dayPerWeekController.text;
        var oldValue = monthlyDataList[i].dayPerWeekValue.toString();
        Debug.printLog("dayPerWeekValue...$oldValue  $avgMinValue");
        if (oldValue != "" && oldValue != "null" &&
            avgMinValue != monthlyDataList[i].dayPerWeekValue.toString()) {
          if (!monthlyDataList[i].dayPerWeekFocus.hasFocus) {
            monthlyDataInsertUpdate(
                monthlyDataList[i], avgMinValue, Constant.typeDayPerWeek,true);
            return;
          }
        }else if(oldValue == "null" && avgMinValue != ""){
          if (!monthlyDataList[i].dayPerWeekFocus.hasFocus) {
            monthlyDataInsertUpdate(
                monthlyDataList[i], avgMinValue, Constant.typeDayPerWeek,true);
            return;
          }
        }
      });

      monthlyDataList[i].avgMinFocus.addListener(() {
        var avgMinValue = monthlyDataList[i].avgMinController.text;
        /*if (avgMinValue != "" &&
            avgMinValue != "0" &&*/
        var oldValue = monthlyDataList[i].avgMinValue.toString();
        Debug.printLog("avgMinValue...$oldValue");
        if (oldValue != "" && oldValue != "null" &&
            avgMinValue != monthlyDataList[i].avgMinValue.toString()) {
          if (!monthlyDataList[i].avgMinFocus.hasFocus) {
            monthlyDataInsertUpdate(
                monthlyDataList[i], avgMinValue, Constant.typeAvgMin,true);
            return;
          }
        }else if(oldValue == "null" && avgMinValue != ""){
          if (!monthlyDataList[i].avgMinFocus.hasFocus) {
            monthlyDataInsertUpdate(
                monthlyDataList[i], avgMinValue, Constant.typeAvgMin,true);
            return;
          }
        }
      });

      monthlyDataList[i].avgMinPerWeekFocus.addListener(() {
        var avgMinValue = monthlyDataList[i].avgMinPerWeekController.text;
        /*if (avgMinValue != "" &&
            avgMinValue != "0" &&*/
        var oldValue = monthlyDataList[i].avgMinPerWeekValue.toString();
        Debug.printLog("avgMinPerWeekValue...$oldValue");
        if (oldValue != "" && oldValue != "null" &&
            avgMinValue != monthlyDataList[i].avgMinPerWeekValue.toString()) {
          if (!monthlyDataList[i].avgMinPerWeekFocus.hasFocus) {
            monthlyDataInsertUpdate(
                monthlyDataList[i], avgMinValue, Constant.typeAvgMinPerWeek,true);
            return;
          }
        }else if(oldValue == "null" && avgMinValue != ""){
          if (!monthlyDataList[i].avgMinPerWeekFocus.hasFocus) {
            monthlyDataInsertUpdate(
                monthlyDataList[i], avgMinValue, Constant.typeAvgMinPerWeek,true);
            return;
          }
        }
      });

      monthlyDataList[i].strengthFocus.addListener(() {
        var avgMinValue = monthlyDataList[i].strengthController.text;
        /*if (avgMinValue != "" &&
            avgMinValue != "0" &&*/
        var oldValue = monthlyDataList[i].strengthValue.toString();
        Debug.printLog("strengthValue...$oldValue");
        if (oldValue != "" && oldValue != "null" &&
            avgMinValue != monthlyDataList[i].strengthValue.toString()) {
          if (!monthlyDataList[i].strengthFocus.hasFocus) {
            monthlyDataInsertUpdate(
                monthlyDataList[i], avgMinValue, Constant.typeStrength,true);
            return;
          }
        }else if(oldValue == "null" && avgMinValue != ""){
          if (!monthlyDataList[i].strengthFocus.hasFocus) {
            monthlyDataInsertUpdate(
                monthlyDataList[i], avgMinValue, Constant.typeStrength,true);
            return;
          }
        }
      });
    }
  }

  List<MonthlyLogTableData> getMonthlyDataList(){
    return Hive
        .box<MonthlyLogTableData>(Constant.tableMonthlyLog)
        .values
        .toList().where((element) => element.patientId == Utils.getPatientId()).toList();
  }


  void onRefresh() async{
    // await Future.delayed(Duration(milliseconds: 1000));
    // await monthlyDataAPICall();
    await initCall();
    refreshController.refreshCompleted();
    Debug.printLog("Complete Api Call.......");
    update([]);

  }

  reloadPage() async {
    await initCall(needGetDataAgain: true);
    update([]);
  }


  void onLoading() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.loadComplete();
  }

  Future<void> syncMonthlyWithTrackingChartData(List<DateTime> monthStartAndEndDataList) async {
    if(monthStartAndEndDataList.isNotEmpty) {
      // var monthStartDate = monthStartAndEndDataList[0];
      // var monthEndDate = monthStartAndEndDataList[monthStartAndEndDataList.length - 1];
      var currentYear = monthStartAndEndDataList[monthStartAndEndDataList.length - 1].year;
      var currentMonth = monthStartAndEndDataList[monthStartAndEndDataList.length - 1].month;

      DateTime monthStartDate = Utils.getFirstDateOfMonth(currentMonth, currentYear);
      DateTime monthEndDate = Utils.getLastDateOfMonth(currentMonth, currentYear);

      Debug.printLog("month start and end date...$monthStartDate  $monthEndDate");
        Utils.showDialogForProgress(
            Get.context!, Constant.txtMonthlySync, Constant.txtMonthlySyncDesc);
        update();
        var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != ""
            && element.isSelected).toList();

          if(!kIsWeb) {
            try {
              // HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
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
                  "hasPermissions...$hasPermissions ");
              if (hasPermissions!) {
                await GetSetHealthData.importDataFromHealth((val) {}, false,
                    needAPICall: false, endDate: monthEndDate, startDate: monthStartDate);
              }
            } catch (e) {
              Debug.printLog("Delete workout error....$e");
            }
          }
          if (allSelectedServersUrl.isNotEmpty) {
            await Future.delayed(const Duration(milliseconds: 500));
            await Utils.isExpireTokenAPICall(Constant.screenTypeHistory,(value) async {
              if(!value){
                await Utils.setMonthlyAndActivityData(currentYear.toString(),
                    isFromMonth: false,isFromActivity: true,startAfterDate: monthStartDate,beforeEndDate:monthEndDate);
                // Get.back();
              }
            }).then((value) async {
              Debug.printLog("isExpireTokenAPICall monthly....$value");
              if (!value) {
                await Utils.setMonthlyAndActivityData(currentYear.toString(),
                    isFromMonth: false,isFromActivity: true,startAfterDate: monthStartDate,beforeEndDate:monthEndDate);
                // Get.back();
              }
            });
            getMonthlyData(needInsertDataAfterMethodCall: true,monthNameSelected: currentMonth.toString(),needAPICall: false);
            update();
            Get.back();
            await Syncing.dataSyncingProcess(true,startDate: monthStartDate,endDate: monthEndDate);
            await getAppleUnSyncActivityLevelData();
            await getUnSyncActivityLevelData();
            var monthData = monthlyDataList.where((element) => element.monthName == Utils.getMonthName(currentMonth,currentYear) && element.year == currentYear).toList();
            Debug.printLog("monthData on button....${monthData.length}   $currentMonth   ${Utils.getMonthName(currentMonth,currentYear)}    $currentYear");

            if(monthData.isNotEmpty) {
              String dayPerWeek = monthData[0].dayPerWeekValue.toString();
              String avgMin = monthData[0].avgMinValue.toString();
              String avgMinPerWeek = monthData[0].avgMinPerWeekValue.toString();
              String strength = monthData[0].strengthValue.toString();
              Debug.printLog("monthData on button data......$dayPerWeek  $avgMin  $avgMinPerWeek  $strength  $monthStartDate  $monthEndDate");
              await insertUpdateMonthlyData(
                  monthStartDate, monthEndDate, monthStartAndEndDataList,
                  Utils.getMonthName(currentMonth,currentYear), currentYear.toString(),dayPerWeek,avgMin,avgMinPerWeek,strength);
              await Syncing.dataSyncingProcess(false,startDate: monthStartDate,endDate: monthEndDate,isFromRefresh: true);
            }
          } else {
               getMonthlyData(
                   needInsertDataAfterMethodCall: true,
                   monthNameSelected: currentMonth.toString(),needAPICall: false);
               update();
               Get.back();
           }
    }
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
    }
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
    }
  }

  insertUpdateMonthlyData(
      DateTime startDate,
      DateTime endDate,
      List<DateTime> monthStartAndEndDataList,
      String monthName,
      String currentYear,
      String dayPerWeek,
      String avgMin,
      String avgMinPerWeek,
      String strength) async {
    var monthlyDataDbList = getMonthlyDataList();
    if (monthlyDataDbList.isNotEmpty) {
      ///Update
      var foundedList = monthlyDataDbList
          .where((element) =>
              element.monthName == monthName &&
              element.year == int.parse(currentYear))
          .toList();
      Debug.printLog("foundedList...${foundedList.length}  $monthName  ${int.parse(currentYear)}");
      if (foundedList.isNotEmpty) {
        foundedList[0].isOverrideDayPerWeek = true;
        foundedList[0].isOverrideAvgMin = true;
        foundedList[0].isOverrideAvgMinPerWeek = true;
        foundedList[0].isOverrideStrength = true;

        if (dayPerWeek != "" && dayPerWeek.toLowerCase() != "null") {
          foundedList[0].dayPerWeekValue = double.parse(dayPerWeek.toString());
        }

        if (avgMin != "" && avgMin.toLowerCase() != "null") {
          foundedList[0].avgMinValue = double.parse(avgMin.toString());
        }

        if (avgMinPerWeek != "" && avgMinPerWeek.toLowerCase() != "null") {
          foundedList[0].avgMInPerWeekValue =
              double.parse(avgMinPerWeek.toString());
        }

        if (strength != "" && strength.toLowerCase() != "null") {
          foundedList[0].strengthValue = double.parse(strength.toString());
        }

        var allSelectedServersUrl = Utils.getServerListPreference()
            .where((element) => element.patientId != "" && element.isSelected)
            .toList();

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
                  "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
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
                  "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
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
                  "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
              foundedList[0].serverDetailListAvgMinWeek.add(data);
            }
          }
        }

        foundedList[0].isSyncStrength = false;
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
              data.patientName =
                  "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
              foundedList[0].serverDetailListStrength.add(data);
            }
          }
        }
        Debug.printLog("updateMonthlyData......${foundedList[0].monthName}  ${foundedList[0].year}");

        await DataBaseHelper.shared.updateMonthlyData(foundedList[0]);
      }
      else {
        ///Insert
        Debug.printLog("Trying insert...$monthName  ${int.parse(currentYear)}");
        var newMonthlyData = MonthlyLogTableData();
        newMonthlyData.monthName = monthName;
        newMonthlyData.year = int.parse(currentYear);
        newMonthlyData.isOverrideDayPerWeek = true;
        newMonthlyData.isOverrideAvgMin = true;
        newMonthlyData.isOverrideAvgMinPerWeek = true;
        newMonthlyData.isOverrideStrength = true;
        newMonthlyData.startDate = startDate;
        newMonthlyData.endDate = endDate;

        if (dayPerWeek != "" && dayPerWeek != "null") {
          newMonthlyData.dayPerWeekValue = double.parse(dayPerWeek.toString());
        }

        if (avgMin != "" && avgMin != "null") {
          newMonthlyData.avgMinValue = double.parse(avgMin.toString());
        }

        if (avgMinPerWeek != "" && avgMinPerWeek != "null") {
          newMonthlyData.avgMInPerWeekValue =
              double.parse(avgMinPerWeek.toString());
        }

        if (strength != "" && strength != "null") {
          newMonthlyData.strengthValue = double.parse(strength.toString());
        }

        newMonthlyData.isSyncDayPerWeek = false;
        var connectedServerUrl = Utils.getServerListPreference()
            .where((element) => element.patientId != "" && element.isSelected)
            .toList();
        if (connectedServerUrl.isNotEmpty) {
          for (int i = 0; i < connectedServerUrl.length; i++) {
            var data = ServerDetailDataTable();
            data.serverUrl = connectedServerUrl[i].url;
            data.patientId = connectedServerUrl[i].patientId;
            data.clientId = connectedServerUrl[i].clientId;
            data.objectId = "";
            data.serverToken = connectedServerUrl[i].authToken;
            data.patientName =
            "${connectedServerUrl[i].patientFName}${connectedServerUrl[i].patientLName}";
            newMonthlyData.serverDetailListDayPerWeek.add(data);
          }
        }

        newMonthlyData.isSyncAvgMin = false;
        var connectedServerUrlAvgMin = Utils.getServerListPreference()
            .where((element) => element.patientId != "" && element.isSelected)
            .toList();

        if (connectedServerUrlAvgMin.isNotEmpty) {
          for (int i = 0; i < connectedServerUrlAvgMin.length; i++) {
            var data = ServerDetailDataTable();
            data.serverUrl = connectedServerUrlAvgMin[i].url;
            data.patientId = connectedServerUrlAvgMin[i].patientId;
            data.clientId = connectedServerUrlAvgMin[i].clientId;
            data.objectId = "";
            data.serverToken = connectedServerUrlAvgMin[i].authToken;
            data.patientName =
            "${connectedServerUrlAvgMin[i].patientFName}${connectedServerUrlAvgMin[i].patientLName}";
            newMonthlyData.serverDetailListAvgMin.add(data);
          }
        }

        newMonthlyData.isSyncAvgMinPerWeek = false;
        var connectedServerUrlAvgMinWeek = Utils.getServerListPreference()
            .where((element) => element.patientId != "" && element.isSelected)
            .toList();

        if (connectedServerUrlAvgMinWeek.isNotEmpty) {
          for (int i = 0; i < connectedServerUrlAvgMinWeek.length; i++) {
            var data = ServerDetailDataTable();
            data.serverUrl = connectedServerUrlAvgMinWeek[i].url;
            data.patientId = connectedServerUrlAvgMinWeek[i].patientId;
            data.clientId = connectedServerUrlAvgMinWeek[i].clientId;
            data.objectId = "";
            data.serverToken = connectedServerUrlAvgMinWeek[i].authToken;
            data.patientName =
            "${connectedServerUrlAvgMinWeek[i].patientFName}${connectedServerUrlAvgMinWeek[i].patientLName}";
            newMonthlyData.serverDetailListAvgMinWeek.add(data);
          }
        }

        newMonthlyData.isSyncStrength = false;
        var connectedServerUrlStr = Utils.getServerListPreference()
            .where((element) => element.patientId != "" && element.isSelected)
            .toList();

        if (connectedServerUrlStr.isNotEmpty) {
          for (int i = 0; i < connectedServerUrlStr.length; i++) {
            var data = ServerDetailDataTable();
            data.serverUrl = connectedServerUrlStr[i].url;
            data.patientId = connectedServerUrlStr[i].patientId;
            data.clientId = connectedServerUrlStr[i].clientId;
            data.objectId = "";
            data.serverToken = connectedServerUrlStr[i].authToken;
            data.patientName =
            "${connectedServerUrlStr[i].patientFName}${connectedServerUrlStr[i].patientLName}";
            newMonthlyData.serverDetailListStrength.add(data);
          }
        }
        Debug.printLog("insertMonthlyData......${newMonthlyData.monthName}  ${newMonthlyData.year}");
        await DataBaseHelper.shared.insertMonthlyData(newMonthlyData);
      }
    }
    else {
      ///Insert
      Debug.printLog("Trying insert...$monthName  ${int.parse(currentYear)}");
      var newMonthlyData = MonthlyLogTableData();
      newMonthlyData.monthName = monthName;
      newMonthlyData.year = int.parse(currentYear);
      newMonthlyData.isOverrideDayPerWeek = true;
      newMonthlyData.isOverrideAvgMin = true;
      newMonthlyData.isOverrideAvgMinPerWeek = true;
      newMonthlyData.isOverrideStrength = true;
      newMonthlyData.startDate = startDate;
      newMonthlyData.endDate = endDate;

      if (dayPerWeek != "" && dayPerWeek != "null") {
        newMonthlyData.dayPerWeekValue = double.parse(dayPerWeek.toString());
      }

      if (avgMin != "" && avgMin != "null") {
        newMonthlyData.avgMinValue = double.parse(avgMin.toString());
      }

      if (avgMinPerWeek != "" && avgMinPerWeek != "null") {
        newMonthlyData.avgMInPerWeekValue =
            double.parse(avgMinPerWeek.toString());
      }

      if (strength != "" && strength != "null") {
        newMonthlyData.strengthValue = double.parse(strength.toString());
      }

      newMonthlyData.isSyncDayPerWeek = false;
      var connectedServerUrl = Utils.getServerListPreference()
          .where((element) => element.patientId != "" && element.isSelected)
          .toList();
      if (connectedServerUrl.isNotEmpty) {
        for (int i = 0; i < connectedServerUrl.length; i++) {
          var data = ServerDetailDataTable();
          data.serverUrl = connectedServerUrl[i].url;
          data.patientId = connectedServerUrl[i].patientId;
          data.clientId = connectedServerUrl[i].clientId;
          data.objectId = "";
          data.serverToken = connectedServerUrl[i].authToken;
          data.patientName =
              "${connectedServerUrl[i].patientFName}${connectedServerUrl[i].patientLName}";
          newMonthlyData.serverDetailListDayPerWeek.add(data);
        }
      }

      newMonthlyData.isSyncAvgMin = false;
      var connectedServerUrlAvgMin = Utils.getServerListPreference()
          .where((element) => element.patientId != "" && element.isSelected)
          .toList();

      if (connectedServerUrlAvgMin.isNotEmpty) {
        for (int i = 0; i < connectedServerUrlAvgMin.length; i++) {
          var data = ServerDetailDataTable();
          data.serverUrl = connectedServerUrlAvgMin[i].url;
          data.patientId = connectedServerUrlAvgMin[i].patientId;
          data.clientId = connectedServerUrlAvgMin[i].clientId;
          data.objectId = "";
          data.serverToken = connectedServerUrlAvgMin[i].authToken;
          data.patientName =
              "${connectedServerUrlAvgMin[i].patientFName}${connectedServerUrlAvgMin[i].patientLName}";
          newMonthlyData.serverDetailListAvgMin.add(data);
        }
      }

      newMonthlyData.isSyncAvgMinPerWeek = false;
      var connectedServerUrlAvgMinWeek = Utils.getServerListPreference()
          .where((element) => element.patientId != "" && element.isSelected)
          .toList();

      if (connectedServerUrlAvgMinWeek.isNotEmpty) {
        for (int i = 0; i < connectedServerUrlAvgMinWeek.length; i++) {
          var data = ServerDetailDataTable();
          data.serverUrl = connectedServerUrlAvgMinWeek[i].url;
          data.patientId = connectedServerUrlAvgMinWeek[i].patientId;
          data.clientId = connectedServerUrlAvgMinWeek[i].clientId;
          data.objectId = "";
          data.serverToken = connectedServerUrlAvgMinWeek[i].authToken;
          data.patientName =
              "${connectedServerUrlAvgMinWeek[i].patientFName}${connectedServerUrlAvgMinWeek[i].patientLName}";
          newMonthlyData.serverDetailListAvgMinWeek.add(data);
        }
      }

      newMonthlyData.isSyncStrength = false;
      var connectedServerUrlStr = Utils.getServerListPreference()
          .where((element) => element.patientId != "" && element.isSelected)
          .toList();

      if (connectedServerUrlStr.isNotEmpty) {
        for (int i = 0; i < connectedServerUrlStr.length; i++) {
          var data = ServerDetailDataTable();
          data.serverUrl = connectedServerUrlStr[i].url;
          data.patientId = connectedServerUrlStr[i].patientId;
          data.clientId = connectedServerUrlStr[i].clientId;
          data.objectId = "";
          data.serverToken = connectedServerUrlStr[i].authToken;
          data.patientName =
              "${connectedServerUrlStr[i].patientFName}${connectedServerUrlStr[i].patientLName}";
          newMonthlyData.serverDetailListStrength.add(data);
        }
      }
      Debug.printLog("insertMonthlyData......${newMonthlyData.monthName}  ${newMonthlyData.year}");
      await DataBaseHelper.shared.insertMonthlyData(newMonthlyData);
    }
  }

  getAndSetServerData()async{
    var unSyncedDataMonthly =  getMonthlyDataList().where((element) => (element.isSyncAvgMin == false ||
    element.isSyncDayPerWeek == false || element.isSyncAvgMinPerWeek == false || element.isSyncStrength == false) && ((element.avgMinValue ?? 0.0) > 0
        || (element.avgMInPerWeekValue ?? 0.0) > 0 || (element.dayPerWeekValue ?? 0.0) > 0 || (element.strengthValue ?? 0.0) > 0)).toList();

    for (int i = 0; i < unSyncedDataMonthly.length; i++) {
      var data = unSyncedDataMonthly[i];
      if(!data.isSyncDayPerWeek){
        ///Call API For First Col Days/Week
        List<SyncMonthlyActivityData> allSyncingData = [];
        if ((data.dayPerWeekValue ?? 0.0) > 0) {
          try {
            allSyncingData.add(SyncMonthlyActivityData(
                data.monthName!,
                data.dayPerWeekValue ?? 0.0,
                data.startDate,
                data.endDate,
                data.key,
                Constant.headerDayPerWeek,
                true, data.dayPerWeekId));
            Debug.printLog("data.dayPerWeekValue.. catch..$allSyncingData");
            await Syncing.observationSyncDataDaysPerWeeks(allSyncingData);
          } catch (e) {
            Debug.printLog("syncMonthlyDataDayPerWeek.. catch..$e");
          }
        }
      }

      if(!data.isSyncAvgMin){
        ///Call API For Second Col Mins
        List<SyncMonthlyActivityData> allSyncingData = [];
        if ((data.avgMinValue ?? 0.0) > 0) {
          try {
            allSyncingData.add(SyncMonthlyActivityData(
                data.monthName!,
                data.avgMinValue ?? 0.0,
                data.startDate,
                data.endDate,
                data.key,
                Constant.headerAverageMin,
                true, data.avgMinPerDayId));
            Debug.printLog("data.avgMinValue.. catch..$allSyncingData");
            await Syncing.observationSyncDataMinPerDay(allSyncingData);
          } catch (e) {
            Debug.printLog("syncMonthlyDataDayPerWeek.. catch..$e");
          }
        }
      }

      if(!data.isSyncAvgMinPerWeek){
        ///Call API For Third Col Mins/Week
        List<SyncMonthlyActivityData> allSyncingData = [];
        if ((data.avgMInPerWeekValue ?? 0.0) > 0) {
          try {
            allSyncingData.add(SyncMonthlyActivityData(
                data.monthName!,
                data.avgMInPerWeekValue ?? 0.0,
                data.startDate,
                data.endDate,
                data.key,
                Constant.headerAverageMinPerWeek,
                true, data.avgPerWeekId));
            Debug.printLog("data.avgMInPerWeekValue.. catch..$allSyncingData");
            await Syncing.observationSyncDataMinPerWeek(allSyncingData);
          } catch (e) {
            Debug.printLog("syncMonthlyDataDayPerWeek.. catch..$e");
          }
        }
      }

      if(!data.isSyncStrength){
        ///Call API For Fourth Col Strength days/Week
        List<SyncMonthlyActivityData> allSyncingData = [];
        if ((data.strengthValue ?? 0.0) > 0) {
          try {
            allSyncingData.add(SyncMonthlyActivityData(
                data.monthName!,
                data.strengthValue ?? 0.0,
                data.startDate,
                data.endDate,
                data.key,
                Constant.headerStrength,
                true, data.strengthId));
            Debug.printLog("data.isSyncStrength.. catch..$allSyncingData");
            await Syncing.observationSyncDataStrengthDaysPerWeek(allSyncingData);
          } catch (e) {
            Debug.printLog("syncMonthlyDataDayPerWeek.. catch..$e");
          }
        }
      }
    }
    /*var dataListAvgMinPerWeek = getMonthlyDataList().where((element) => !element.isSyncAvgMinPerWeek && ((element.avgMinValue ?? 0.0) > 0
        || (element.avgMInPerWeekValue ?? 0.0) > 0 || (element.dayPerWeekValue ?? 0.0) > 0 || (element.strengthValue ?? 0.0) > 0)).toList();
    var dataListDayPerWeek = getMonthlyDataList().where((element) => element.isSyncDayPerWeek == false && ((element.avgMinValue ?? 0.0) > 0
        || (element.avgMInPerWeekValue ?? 0.0) > 0 || (element.dayPerWeekValue ?? 0.0) > 0 || (element.strengthValue ?? 0.0) > 0)).toList();
    var dataListStrength = getMonthlyDataList().where((element) => element.isSyncStrength == false && ((element.avgMinValue ?? 0.0) > 0
        || (element.avgMInPerWeekValue ?? 0.0) > 0 || (element.dayPerWeekValue ?? 0.0) > 0 || (element.strengthValue ?? 0.0) > 0)).toList();*/

  }
}
