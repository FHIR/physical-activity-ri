import 'package:banny_table/ui/history/controllers/history_controller.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../../db_helper/box/activity_data.dart';
import '../../../db_helper/box/goal_data.dart';
import '../../bottomNavigation/controllers/bottom_navigation_controller.dart';
import '../datamodel/graphDatamodel.dart';
import '../views/graph_screen.dart';

class GraphController extends GetxController {
  var selectedActivity = "";
  // var selectedTime = "";
  // var selectedTimeFrame = "";
  var selectedMeaSure = "";
  // List<ListOfMeaSure> listOfMeaSure = [];
  List<ChartData> chartDataList = [];
  // var selectedRadioValue = 0;
  var lineChart1 = false;
  var lineChart2 = false;
  var lineChart3 = false;
  // List<GoalTableData> goalDataList = [];

  List<ActivityTable> activityData = [];
  var selectedNewDate = DateTime.now();
  String startDate = "";
  String endDate = "";
  DateTime previousDate = DateTime.now();
  DateTime nextDate = DateTime.now();

  @override
  Future<void> onInit() async {
    Debug.printLog("On init graph............");
    // Constant.selectedTime = Utils.timeList[0];
    // Constant.selectedTimeFrame = Utils.timeFrameList[0];
    await getLifeMeaSureData(isUpdate: true);
    // await getGraphDataAndSetTimeFrame(Constant.listOfMeaSure[Constant.selectedRadioValue].titleName);
    selectedActivity = Constant.configurationInfoGraphManage[0].title;
    // await getGraphData();
    if(activityData.isEmpty) {
      await getAndSetWeeksData(selectedNewDate);
    }else{
      getAndSetWeeksData(selectedNewDate,isShowDialog: false);
    }
    getLifeMeaSureData(isUpdate: true);
    selectedActivity = Constant.configurationInfoGraphManage[0].title;
    if(Constant.listOfMeaSure.isNotEmpty){
      onChangeActivityTimeAndFrameGraphData(selectedMeaSure,Constant.graphAMeaSureType);
    }
    update();
    super.onInit();
  }

/*
  callApiForTrackingChartDataAndInit() async {
    await getGraphData();

    HistoryController historyController = Get.find();
      if(activityData.isNotEmpty){
        await historyController.getAndSetWeeksData(selectedNewDate);
      }else{
        await historyController.getAndSetWeeksData(selectedNewDate,isNotGraph: true);
      }
     update();
    await getGraphData();

  }
*/

  getGraphData() async {
    activityData = (Utils.getPatientId() != "") ? Hive.box<ActivityTable>(Constant.tableActivity).values.toList().where((element) =>
    element.patientId == Utils.getPatientId()).toList() : Hive.box<ActivityTable>(Constant.tableActivity).values.toList();
  }

  Future<void> handleGraphUpdate(String message) async {
    Constant.selectedTimeFrame = message.toString();
    Debug.printLog('Button clicked in SubController with message: $message  ${Constant.listOfMeaSure[Constant.selectedRadioValue].titleName}  '
        '${Constant.selectedTime}');
    if(activityData.isNotEmpty){
      await onChangeActivityTimeAndFrameGraphData(
          message, Constant.graphTimeFrameType);
    }
  }

  getLifeMeaSureData({bool isUpdate = false}){
    Constant.listOfMeaSure.clear();
    activityData = Utils.getActivityGraphData();
    if(activityData.where((element) =>  element.title == null && (element.value1 != null || element.value2 != null ||
        element.total != null)).toList().isNotEmpty){
      bool isFirst = (Constant.listOfMeaSure.isEmpty && isUpdate || Constant.selectedRadioValue == 0);
      Constant.listOfMeaSure.add(ListOfMeaSure(Constant.activityMinutes, [
        SubListOfMeaSure(Constant.activityMinutesMod, isFirst),
        SubListOfMeaSure(Constant.activityMinutesVig, isFirst),
        SubListOfMeaSure(Constant.activityMinutesTotal,isFirst),
      ],(Constant.listOfMeaSure.isEmpty && isUpdate) ? true : false));
    }
    if(activityData.where((element) => (element.title == Constant.titleHeartRateRest || element.title == Constant.titleHeartRatePeak)
        && (element.total != null)).toList().isNotEmpty){
      // bool isFirst = (Constant.listOfMeaSure.isEmpty && isUpdate && Constant.selectedRadioValue != 0);
      bool isFirst = (Constant.listOfMeaSure.isEmpty && isUpdate && Constant.selectedRadioValue > 0);
      Constant.listOfMeaSure.add(ListOfMeaSure(Constant.heartRate, [
        SubListOfMeaSure(Constant.heartRateRest,isFirst),
        SubListOfMeaSure(Constant.heartRatePeak, isFirst),
      ], (Constant.listOfMeaSure.isEmpty && isUpdate) ? true : false));
    }
    if(activityData.where((element) => element.title == Constant.titleCalories && element.total != null).toList().isNotEmpty){
      Constant.listOfMeaSure.add(ListOfMeaSure(Constant.calories, [], (Constant.listOfMeaSure.isEmpty && isUpdate) ?true :false));
    }
    if(activityData.where((element) => element.title == Constant.titleSteps && element.total != null).toList().isNotEmpty){
      Constant.listOfMeaSure.add(ListOfMeaSure(Constant.steps, [],(Constant.listOfMeaSure.isEmpty && isUpdate) ?true : false));
    }
    if(activityData.where((element) => element.title == null && element.smileyType != null).toList().isNotEmpty){
      Constant.listOfMeaSure.add(ListOfMeaSure(Constant.experience, [], (Constant.listOfMeaSure.isEmpty && isUpdate) ?true : false));
    }
    if(isUpdate){
      onChangeRadioValue(0,false);
      selectedMeaSure = Constant.listOfMeaSure.isNotEmpty ? Constant.listOfMeaSure[0].titleName : "No Data";
    }
    Debug.printLog("Constant.listOfMeaSure.........${Constant.listOfMeaSure.length}");
  }

  onChangeMeaSureData(int mainIndex, int subIndex){
    if(subIndex == -1) {
      Constant.listOfMeaSure[mainIndex].isSelected =
      !Constant.listOfMeaSure[mainIndex].isSelected;
      if(Constant.listOfMeaSure[mainIndex].subList.isNotEmpty) {
        for (int i = 0; i < Constant.listOfMeaSure[mainIndex].subList.length; i++) {
          Constant.listOfMeaSure[mainIndex].subList[i].isSelected =
              Constant.listOfMeaSure[mainIndex].isSelected;
        }
      }
    }else {
      Constant.listOfMeaSure[mainIndex].subList[subIndex].isSelected =
      !Constant.listOfMeaSure[mainIndex].subList[subIndex].isSelected;
    }
    update();
  }

  DateTime findLastOldDate( List<DateTime> dateList) {
    if (dateList.isEmpty) {
      return null!; // Return null if the list is empty
    }

    DateTime oldestDate = dateList[0];

    for (DateTime date in dateList) {
      if (date.isBefore(oldestDate)) {
        oldestDate = date;
      }
    }

    return oldestDate;
  }

  List<DateTime> getAllDatesFromOldestToToday(DateTime oldestDate) {
    if (oldestDate == null) {
      return [];
    }

    DateTime today = DateTime.now();
    List<DateTime> allDates = [];

    for (DateTime date = oldestDate; date.isBefore(today); date = date.add(Duration(days: 1))) {
      allDates.add(date);
    }

    return allDates;
  }

  onChangeActivityTimeAndFrameGraphData(String value, int graphDropDownType,) {
    if (Constant.listOfMeaSure.isNotEmpty) {
      Debug.printLog(
          "onChangeActivityTimeAndFrameGraphData....$value  $graphDropDownType");
      if (graphDropDownType == Constant.graphActivityType) {
        selectedActivity = value;
      }
      else if (graphDropDownType == Constant.graphTimeType) {
        Constant.selectedTime = value;
      }
      else if (graphDropDownType == Constant.graphTimeFrameType) {
        Constant.selectedTimeFrame = value;
      }
      else if (graphDropDownType == Constant.graphAMeaSureType) {
        // selectedMeaSure = value;
        var selectedIndexObject = Constant.listOfMeaSure[Constant.selectedRadioValue];
        byDefaultAllFalse();

        if (selectedIndexObject.titleName == Constant.activityMinutes) {
          if (selectedIndexObject.subList[0].isSelected) {
            lineChart1 = true;
          }
          if (selectedIndexObject.subList[1].isSelected) {
            lineChart2 = true;
          }
          if (Constant.listOfMeaSure[Constant.selectedRadioValue].subList[2].isSelected) {
            lineChart3 = true;
          }
        }
        else if (selectedIndexObject.titleName == Constant.heartRate) {
          if (selectedIndexObject.subList[0].isSelected) {
            lineChart2 = true;
          }
          if (selectedIndexObject.subList[1].isSelected) {
            lineChart3 = true;
          }
        }
        else {
          lineChart1 = true;
        }
      }
      chartDataList.clear();
      // getFilteredData(selectedActivity, selectedMeaSure, selectedTime,
      getFilteredData(Constant.titleNon, Constant.listOfMeaSure[Constant.selectedRadioValue].titleName, Constant.selectedTime,
          Constant.selectedTimeFrame);
      update();
    }
  }

   getFilteredData(String activity, String meaSure, String time, String timeFrame){
    var activityTableData =  Hive.box<ActivityTable>(Constant.tableActivity).values.toList();
    chartDataList.clear();
    if(activityTableData.isNotEmpty){
      String? dbMeasureType = "";
      if(meaSure == Constant.activityMinutes || meaSure == Constant.activityMinutesMod ||
          meaSure == Constant.activityMinutesVig){
        dbMeasureType = null;
      }
      else if(meaSure == Constant.daysStrength){
        dbMeasureType = Constant.titleDaysStr;
      }
      else if(meaSure == Constant.calories){
        dbMeasureType = Constant.titleCalories;
      }
      else if(meaSure == Constant.steps){
        dbMeasureType = Constant.titleSteps;
      }
      else if(meaSure == Constant.heartRate ||meaSure == Constant.titleHeartRateRest|| meaSure == Constant.titleHeartRatePeak){
        /*Wee need to show both data rest and peak*/
        dbMeasureType = Constant.heartRate;
      }
      else if(meaSure == Constant.experience){
        dbMeasureType = Constant.titleExperience;
      }


      if(time == Constant.timeWeek) {
        var totalNumberOfWeeks = 0;
        var nowDate = DateTime.now();
        var currentWeekStartDate = Utils.findCurrentWeekLastDate(nowDate);

        if (timeFrame == Constant.frameLastWeek) {
          totalNumberOfWeeks = 1;
        } else if (timeFrame == Constant.frame2Weeks) {
          totalNumberOfWeeks = 2;
        } else if (timeFrame == Constant.frame3Weeks) {
          totalNumberOfWeeks = 3;
        } else if (timeFrame == Constant.frame4Weeks) {
          totalNumberOfWeeks = 4;
        }else if (timeFrame == Constant.frame5Weeks) {
          totalNumberOfWeeks = 5;
        }else if (timeFrame == Constant.frame6Weeks) {
          totalNumberOfWeeks = 6;
        } else if (timeFrame == Constant.frame2Months) {
          totalNumberOfWeeks = 8;
        } else if (timeFrame == Constant.frame3Months) {
          totalNumberOfWeeks = 13;
        } else if (timeFrame == Constant.frame4Months) {
          totalNumberOfWeeks = 17;
        } else if (timeFrame == Constant.frame5Months) {
          totalNumberOfWeeks = 22;
        } else if (timeFrame == Constant.frame6Months) {
          totalNumberOfWeeks = 26;
        } else if (timeFrame == Constant.frame7Months) {
          totalNumberOfWeeks = 31;
        } else if (timeFrame == Constant.frame8Months) {
          totalNumberOfWeeks = 35;
        } else if (timeFrame == Constant.frame9Months) {
          totalNumberOfWeeks = 40;
        } else if (timeFrame == Constant.frame10Months) {
          totalNumberOfWeeks = 44;
        } else if (timeFrame == Constant.frame11Months) {
          totalNumberOfWeeks = 49;
        } else if (timeFrame == Constant.frame1Year) {
          totalNumberOfWeeks = 52;
        }
        else if(timeFrame == Constant.frameLifeTime){
          List<DateTime> totalDays = [];
          var activityData;
          var meaSureDataList;
          if(activity == Constant.titleNon) {
            activityData = activityTableData.where((element) =>
            element.type == Constant.typeDay).toList();
            if (dbMeasureType == Constant.heartRate) {
              meaSureDataList = activityData
                  .where((element) => (element.title == Constant.titleHeartRateRest ||
                  element.title  == Constant.titleHeartRatePeak))
                  .toList();
            } else {
              meaSureDataList = activityData
                  .where((element) => element.title == dbMeasureType)
                  .toList();
            }
          }/*else {
            activityData = activityTableData
                .where((element) => element.displayLabel == activity)
                .toList();
            meaSureDataList = activityData
                .where((element) => element.title == dbMeasureType)
                .toList();
          }*/
          for (int o = 0; o < meaSureDataList.length; o++) {
            totalDays.add(meaSureDataList[o].dateTime!);
          }
          if(totalDays.isNotEmpty) {
            DateTime oldDates = findLastOldDate(totalDays);
            totalDays = getAllDatesFromOldestToToday(oldDates);
            double totalDayValues = (totalDays.length.toInt() / 7);
            if(totalDayValues > totalDayValues.toInt()){
              totalNumberOfWeeks = (totalDays.length.toInt() / 7).toInt()+1;
            }else{
              totalNumberOfWeeks = (totalDays.length.toInt() / 7).toInt();
            }          }
          Debug.printLog("$timeFrame....... $totalNumberOfWeeks");


        }

        var totalNumberOfWeeksList = Utils.getTotalNumberOfLastWeeks(currentWeekStartDate,totalNumberOfWeeks);

        chartDataList = Utils.getChartListData(totalNumberOfWeeksList,activity,dbMeasureType,activityTableData,timeFrame);
        if(timeFrame == Constant.frameLifeTime || meaSure == Constant.heartRate){
          if(meaSure == Constant.heartRate){
            if(!lineChart2 && lineChart3){
              chartDataList = chartDataList.where((element) =>
              (element.y2 == 0.0 && element.y2 == null)
                  || (element.y3 != 0.0 && element.y3 != null)
              ).toList();
            }else if (lineChart2  &&  !lineChart3){
              chartDataList = chartDataList.where((element) =>
              (element.y2 != 0.0 && element.y2 != null)
                  || (element.y3 == 0.0 && element.y3 == null)
              ).toList();
            }else if(lineChart2  &&  lineChart3){
              chartDataList = chartDataList.where((element) =>
              (element.y2 != 0.0 && element.y2 != null)
                  || (element.y3 != 0.0 && element.y3 != null)
              ).toList();
            }
          }else{
            chartDataList = chartDataList.where((element) =>
            (element.y1 != 0 && element.y1 != null)
                || (element.y2 != 0 && element.y2 != null)
                || (element.y3 != 0 && element.y3 != null)
            ).toList();
          }

          Debug.printLog("chartDataList....$chartDataList");
        }
      }
      else {
        List<ActivityTable> activityData;
        var meaSureDataList;
        if (activity == Constant.titleNon) {
          activityData = activityTableData.where((element) =>
          element.type == Constant.typeDay).toList();

          meaSureDataList = activityData.where((element) =>
          (meaSure == Constant.heartRate)
              ? (element.title == Constant.titleHeartRateRest ||
              element.title  == Constant.titleHeartRatePeak)
              :(meaSure == Constant.experience) ? element.smileyType != null : element.title == dbMeasureType)
              .toList();

          Debug.printLog("lenghtData.....${meaSureDataList.length}");
        }else{
          activityData = activityTableData.where((element) =>
          element.displayLabel == activity).toList();
          meaSureDataList = activityData.where((element) =>
          (meaSure == Constant.heartRate)
              ? (element.title == Constant.titleHeartRateRest ||
              element.title == Constant.titleHeartRatePeak)
              : element.title == dbMeasureType)
              .toList();
        }

        List<DateTime> totalDays = [];
        var now = DateTime.now();
        now = Utils.findCurrentWeekLastDate(now);
        if (timeFrame == Constant.frameLastWeek) {
          var lastWeekEndDate = DateTime(now.year, now.month, now.day - 6);
          totalDays = Utils.getDaysInBetween(lastWeekEndDate, now);
        }        if (timeFrame == Constant.frame2Weeks) {
          var lastWeekEndDate = DateTime(now.year, now.month, now.day - 13);
          totalDays = Utils.getDaysInBetween(lastWeekEndDate, now);
        }        if (timeFrame == Constant.frame3Weeks) {
          var lastWeekEndDate = DateTime(now.year, now.month, now.day - 20);
          totalDays = Utils.getDaysInBetween(lastWeekEndDate, now);
        } else if (timeFrame == Constant.frame4Weeks) {
          var last4WeekEndDate = DateTime(now.year, now.month, now.day - 27);
          totalDays = Utils.getDaysInBetween(last4WeekEndDate, now);
        }else if (timeFrame == Constant.frame5Weeks) {
          var last4WeekEndDate = DateTime(now.year, now.month, now.day - 34);
          totalDays = Utils.getDaysInBetween(last4WeekEndDate, now);
        }else if (timeFrame == Constant.frame6Weeks) {
          var last4WeekEndDate = DateTime(now.year, now.month, now.day - 41);
          totalDays = Utils.getDaysInBetween(last4WeekEndDate, now);
        }
        else if (timeFrame == Constant.frame2Months) {
          var last3MonthEndDate = DateTime(now.year, now.month - 2, now.day);
          totalDays = Utils.getDaysInBetween(last3MonthEndDate, now);
        }        else if (timeFrame == Constant.frame3Months) {
          var last3MonthEndDate = DateTime(now.year, now.month - 3, now.day);
          totalDays = Utils.getDaysInBetween(last3MonthEndDate, now);
        }        else if (timeFrame == Constant.frame4Months) {
          var last3MonthEndDate = DateTime(now.year, now.month - 4, now.day);
          totalDays = Utils.getDaysInBetween(last3MonthEndDate, now);
        }        else if (timeFrame == Constant.frame5Months) {
          var last3MonthEndDate = DateTime(now.year, now.month - 5, now.day);
          totalDays = Utils.getDaysInBetween(last3MonthEndDate, now);
        }        else if (timeFrame == Constant.frame6Months) {
          var last3MonthEndDate = DateTime(now.year, now.month - 6, now.day);
          totalDays = Utils.getDaysInBetween(last3MonthEndDate, now);
        }        else if (timeFrame == Constant.frame7Months) {
          var last3MonthEndDate = DateTime(now.year, now.month - 7, now.day);
          totalDays = Utils.getDaysInBetween(last3MonthEndDate, now);
        }        else if (timeFrame == Constant.frame8Months) {
          var last3MonthEndDate = DateTime(now.year, now.month - 8, now.day);
          totalDays = Utils.getDaysInBetween(last3MonthEndDate, now);
        }        else if (timeFrame == Constant.frame9Months) {
          var last3MonthEndDate = DateTime(now.year, now.month - 9, now.day);
          totalDays = Utils.getDaysInBetween(last3MonthEndDate, now);
        }        else if (timeFrame == Constant.frame10Months) {
          var last3MonthEndDate = DateTime(now.year, now.month - 10, now.day);
          totalDays = Utils.getDaysInBetween(last3MonthEndDate, now);
        }        else if (timeFrame == Constant.frame11Months) {
          var last3MonthEndDate = DateTime(now.year, now.month - 11, now.day);
          totalDays = Utils.getDaysInBetween(last3MonthEndDate, now);
        }
        else if (timeFrame == Constant.frame1Year) {
          var last1YearEndDate = DateTime(now.year - 1, now.month, now.day);
          totalDays = Utils.getDaysInBetween(last1YearEndDate, now);
        }
        else if (timeFrame == Constant.frameLifeTime) {
          for (int o = 0; o < meaSureDataList.length; o++) {
            totalDays.add(DateTime.parse(meaSureDataList[o].date!.toString()));
          }
          totalDays.sort((a,b) => a.compareTo(b));
        }

        List<ActivityTable> timeLevelDataList;
        if(activity == Constant.titleNon){
          timeLevelDataList = meaSureDataList
              .where((elementMain) =>
          (elementMain.type ==
              Constant.typeDay) &&(
              totalDays
                  .where((element) => element == DateTime.parse(elementMain.date.toString()))
                  .toList()
                  .isNotEmpty))
              .toList();
        }
        else{
          timeLevelDataList = meaSureDataList.where((elementMain) =>
          elementMain.type ==
              ((time == Constant.timeDay) ? Constant.typeDaysData : Constant
                  .typeWeek)
              && totalDays
              .where((element) => element == DateTime.parse(elementMain.date.toString()))
              .toList()
              .isNotEmpty).toList();
        }


        for (int i = 0; i < totalDays.length; i++) {
          List<ActivityTable> dataList = timeLevelDataList.where((element) =>
          DateTime.parse(element.date.toString()) == totalDays[i]).toList();

          if(dbMeasureType == Constant.titleExperience){
            dataList = dataList.where((element) => element.total == null && element.smileyType != null).toList();
          }else{
            dataList = dataList.where((element) => element.total != null && element.smileyType == null).toList();
          }
          if (dataList.isNotEmpty) {
            var yPeckHeart = 0.0;
            var yRestHeart = 0.0;
            if(meaSure == Constant.heartRate){
              for(int o = 0 ; o < dataList.length;o++) {
                var data = dataList[o];
                if (data.title == Constant.titleHeartRateRest) {
                  yRestHeart = data.total ?? 0.0;
                }else if (data.title == Constant.titleHeartRatePeak) {
                  Debug.printLog("Date..heartRatePeck...............Total...${data.total.toString()}");
                  yPeckHeart = data.total ?? 0.0;
                }
              }
              var xAxisDateStr = DateFormat(Constant.commonDateForChart)
                  .format(
                  totalDays[i]);
              chartDataList.add(ChartData(
                  xAxisDateStr, 0.0, (yRestHeart == 0.0) ? null: yRestHeart,(yPeckHeart == 0.0) ? null:yPeckHeart));
            }else if(meaSure == Constant.experience){
              var data = dataList[0];
              var xAxisDateStr = DateFormat(Constant.commonDateForChart).format(
                  totalDays[i]);
              Debug.printLog("Date............${xAxisDateStr.toString()} .....Total...${data.total.toString()}");
              var yTotalChartData = data.smileyType?.toDouble() ?? 0.0;
              var yModChartData = data.value1 ?? 0.0;
              var yVigChartData = data.value2 ?? 0.0;
              chartDataList.add(ChartData(
                  xAxisDateStr, yTotalChartData, yModChartData, yVigChartData));
            }
            else{
              var data = dataList[0];
              var xAxisDateStr = DateFormat(Constant.commonDateForChart).format(
                  totalDays[i]);
              Debug.printLog("Date............${xAxisDateStr.toString()} .....Total...${data.total.toString()}"
                  "$lineChart1  $lineChart2  $lineChart3");
              ///lineChart1 = Mod
              ///lineChart2 = Mod
              ///lineChart3 = Total
              var yTotalChartData = data.total ?? 0.0;
              var yModChartData = data.value1 ?? 0.0;
              var yVigChartData = data.value2 ?? 0.0;
              if(yModChartData != 0.0 || yVigChartData != 0.0 || yTotalChartData != 0.0) {
                chartDataList.add(ChartData(
                    xAxisDateStr, yTotalChartData, yModChartData,
                    yVigChartData));
              }
            }
          }
          /*else {
            var xAxisDateStr = DateFormat(Constant.commonDateForChart).format(
                totalDays[i]);
            chartDataList.add(ChartData(xAxisDateStr, 0, 0, 0));
          }*/
        }

        if(timeFrame == Constant.frameLifeTime || meaSure == Constant.heartRate){
          if(meaSure == Constant.heartRate){
            if(!lineChart2 && lineChart3){
              chartDataList = chartDataList.where((element) =>
              (element.y2 == 0.0 && element.y2 == null)
                  || (element.y3 != 0.0 && element.y3 != null)
              ).toList();
            }else if (lineChart2  &&  !lineChart3){
              chartDataList = chartDataList.where((element) =>
              (element.y2 != 0.0 && element.y2 != null)
                  || (element.y3 == 0.0 && element.y3 == null)
              ).toList();
            }else if(lineChart2  &&  lineChart3){
              chartDataList = chartDataList.where((element) =>
              (element.y2 != 0.0 && element.y2 != null)
                  || (element.y3 != 0.0 && element.y3 != null)
              ).toList();
            }
          }else{
            chartDataList = chartDataList.where((element) =>
            (element.y1 != 0 && element.y1 != null)
                || (element.y2 != 0 && element.y2 != null)
                || (element.y3 != 0 && element.y3 != null)
            ).toList();
          }

          Debug.printLog("chartDataList....$chartDataList");
        }
      }
    }
    update();
  }



  byDefaultAllFalse(){
    lineChart1 = false;
    lineChart2 = false;
    lineChart3 = false;
  }

  void onChangeRadioValue(int value,bool isFromDropDown) {
    if(Constant.selectedRadioValue == -1 && !isFromDropDown){
      Constant.selectedRadioValue = value;
    }else if(isFromDropDown){
      Constant.selectedRadioValue = value;
    }

    for (int i = 0; i < Constant.listOfMeaSure.length; i++) {
      if(Constant.listOfMeaSure[Constant.selectedRadioValue].titleName == Constant.activityMinutes ||
          Constant.listOfMeaSure[Constant.selectedRadioValue].titleName == Constant.heartRate){

        for (int j = 0; j < Constant.listOfMeaSure[i].subList.length; j++) {
          if(Constant.listOfMeaSure[i].titleName ==
              Constant.listOfMeaSure[Constant.selectedRadioValue].titleName){
            Constant.listOfMeaSure[i].subList[j].isSelected = true;
          }else{
            Constant.listOfMeaSure[i].subList[j].isSelected = false;
          }
          /* if(value != i) {
              Constant.listOfMeaSure[i].subList[j].isSelected = false;
            }else{
              Constant.listOfMeaSure[i].subList[j].isSelected = true;
            }*/
        }

      }else if(Constant.listOfMeaSure[Constant.selectedRadioValue].titleName != Constant.activityMinutes ||
          Constant.listOfMeaSure[Constant.selectedRadioValue].titleName != Constant.heartRate){
        for (int j = 0; j < Constant.listOfMeaSure[i].subList.length; j++) {
          Constant.listOfMeaSure[i].subList[j].isSelected = false;
        }
      }
      selectedMeaSure = Constant.listOfMeaSure[Constant.selectedRadioValue].titleName;

    }
    update();
  }

    getAndSetWeeksData(DateTime selectedDate,{bool isNext = false,bool isTap = false,bool isShowDialog = true}) async {
    if(isTap) {
      if (isNext) {
        selectedDate = selectedDate.add(const Duration(days: Constant.totalDaysOf5Weeks));
      }else{
        selectedDate = selectedDate.subtract(const Duration(days: 1));
      }
    }

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

    // initAllFocusNodeForTextFormFiled();

    previousDate = dateParseStartPreviousWeek1;
    nextDate = dateParseLastTimePreviousWeek5;


    await activityDataAPICall(previousDate,nextDate,isTap,isShowDialog);
    update();
  }


  activityDataAPICall(DateTime startAfterDate,DateTime beforeEndDate, bool isTap,bool isShowDialog) async {
    int year = 0;
    Debug.printLog("activityDataAPICall....$startAfterDate  $beforeEndDate");
    year = previousDate.year;
    var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();

    if(allSelectedServersUrl.isNotEmpty) {
      if(isShowDialog){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Utils.showDialogForProgress(
              Get.context!, Constant.txtPleaseWait, Constant.txtGraphDataProgress);
        });
      }
      await Utils.isExpireTokenAPICall(Constant.screenTypeHistory,(value) async {
        if(value){
          Get.back();
        }else {
          Get.back();
          if(isShowDialog){
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await Utils.showDialogForProgress(
                  Get.context!, Constant.txtPleaseWait,
                  Constant.txtGraphDataProgress);
            });
          }
          await Utils.setMonthlyAndActivityData(year.toString(),
              isFromMonth: false,
              isFromActivity: true,
              startAfterDate: startAfterDate,
              beforeEndDate: beforeEndDate);
          Get.back();
        }
      }).then((value) async {
        if(!value){
          await Utils.setMonthlyAndActivityData(year.toString(),
              isFromMonth: false,isFromActivity: true,startAfterDate: startAfterDate,beforeEndDate:beforeEndDate);
          Get.back();
        }
      });
    }

    if(isTap){
      selectedNewDate = nextDate;
    }
    update();
  }

  experienceManage(int graphDropDownType){
    Constant.selectedTime = Constant.timeDay;
    update();
    onChangeActivityTimeAndFrameGraphData(
        "", Constant.graphAMeaSureType);
  }


  getGraphDataAndSetTimeFrame(String type) async {
    var activityData = Utils.getActivityGraphData();
    List<ActivityTable> totalDaysData = activityData.where((element) => element.type == Constant.typeDay).toList();
    if(type == Constant.activityMinutes){
      totalDaysData = totalDaysData.where((element) => element.title == null && element.smileyType == null).toList();
    }else if(type == Constant.heartRate){
      totalDaysData = totalDaysData.where((element) => element.title == Constant.titleHeartRateRest || element.title == Constant.titleHeartRatePeak || element.title == Constant.heartRate ).toList();

    }else if(type == Constant.calories){
      totalDaysData = totalDaysData.where((element) => element.title == Constant.titleCalories).toList();

    }else if(type == Constant.steps){
      totalDaysData = totalDaysData.where((element) => element.title == Constant.titleSteps).toList();

    }else if(type == Constant.experience){
      totalDaysData = totalDaysData.where((element) => element.total == null && element.title == null && element.smileyType != null).toList();
    }



    List totalDays = [];
    if(totalDaysData.isNotEmpty){
      // = totalDaysData[0].date;
      //    = totalDaysData[totalDaysData.length - 1].date;
      Map data= findFirstAndLastDates(totalDaysData);
      var firstDate  = data["firstDate"];
      var lastDate = data["lastDate"];
      try {
        totalDays = getDaysInBetween(
            DateFormat(Constant.commonDateFormatDdMmYyyy)
                .parse(firstDate ?? ""),
            DateFormat(Constant.commonDateFormatDdMmYyyy)
                .parse(lastDate ?? ""));
        Debug.printLog("datetime....$firstDate  $lastDate  ${totalDays.length}");
        Debug.printLog("Total Days.....${totalDays.length}");

      } catch (e) {
        Debug.printLog(e.toString());
      }
    }
    Debug.printLog("totalDaysData...${totalDaysData.length}");
    // await getTimeFrameDayWise(totalDays.length);
    BottomNavigationController bottomNavigationController = Get.find();
    bottomNavigationController.updateMethod();
    update();

  }

/*  List<String> getTimeFrameDayWise(int days){
    // List<String> timeFrame = [];
    Utils.timeFrame.clear();
    if(days <= 14){
      Utils.timeFrame.add(Constant.frameLastWeek);
      Debug.printLog("1 Weeks......");
    }else if(days <= 21){
      Utils.timeFrame.add(Constant.frameLastWeek);
      Utils.timeFrame.add(Constant.frame2Weeks);
      // Utils.timeFrame.add(Constant.frame3Weeks);
    }else if(days <= 28){
      Utils.timeFrame.add(Constant.frameLastWeek);
      Utils.timeFrame.add(Constant.frame2Weeks);
      Utils.timeFrame.add(Constant.frame3Weeks);
      // Utils.timeFrame.add(Constant.frame4Weeks);
    }else if(days <= 35){
      Utils.timeFrame.add(Constant.frameLastWeek);
      Utils.timeFrame.add(Constant.frame2Weeks);
      Utils.timeFrame.add(Constant.frame4Weeks);
      // Utils.timeFrame.add(Constant.frame5Weeks);
    }else if(days <= 42){
      Utils.timeFrame.add(Constant.frameLastWeek);
      Utils.timeFrame.add(Constant.frame4Weeks);
      Utils.timeFrame.add(Constant.frame6Weeks);
    }else if(days >= 43  && days <= 60){
      Utils.timeFrame.add(Constant.frameLastWeek);
      Utils.timeFrame.add(Constant.frame4Weeks);
      Utils.timeFrame.add(Constant.frame2Months);
    }else if(days >= 61  && days <= 90){
      Utils.timeFrame.add(Constant.frameLastWeek);
      Utils.timeFrame.add(Constant.frame4Weeks);
      Utils.timeFrame.add(Constant.frame2Months);
      Utils.timeFrame.add(Constant.frame3Months);
    }else if(days >= 61  && days <= 120){
      Utils.timeFrame.add(Constant.frameLastWeek);
      Utils.timeFrame.add(Constant.frame4Weeks);
      Utils.timeFrame.add(Constant.frame2Months);
      Utils.timeFrame.add(Constant.frame3Months);
      // Utils.timeFrame.add(Constant.frame4Months);
    }else if(days >= 121  && days <= 150){
      Utils.timeFrame.add(Constant.frameLastWeek);
      Utils.timeFrame.add(Constant.frame4Weeks);
      Utils.timeFrame.add(Constant.frame2Months);
      Utils.timeFrame.add(Constant.frame4Months);
      // Utils.timeFrame.add(Constant.frame5Months);
    }else if(days >= 151  && days <= 180){
      Utils.timeFrame.add(Constant.frameLastWeek);
      Utils.timeFrame.add(Constant.frame4Weeks);
      Utils.timeFrame.add(Constant.frame2Months);
      Utils.timeFrame.add(Constant.frame4Months);
      // Utils.timeFrame.add(Constant.frame6Months);
    }else if(days >= 181  && days <= 210){
      Utils.timeFrame.add(Constant.frameLastWeek);
      Utils.timeFrame.add(Constant.frame4Weeks);
      Utils.timeFrame.add(Constant.frame2Months);
      Utils.timeFrame.add(Constant.frame4Months);
      // Utils.timeFrame.add(Constant.frame6Months);
    }else if(days >= 211  && days <= 240) {
      Utils.timeFrame.add(Constant.frameLastWeek);
      Utils.timeFrame.add(Constant.frame4Weeks);
      Utils.timeFrame.add(Constant.frame4Months);
      Utils.timeFrame.add(Constant.frame6Months);
      // Utils.timeFrame.add(Constant.frame7Months);
    }else if(days >= 241  && days <= 270) {
      Utils.timeFrame.add(Constant.frameLastWeek);
      Utils.timeFrame.add(Constant.frame4Weeks);
      Utils.timeFrame.add(Constant.frame4Months);
      Utils.timeFrame.add(Constant.frame6Months);
      // Utils.timeFrame.add(Constant.frame8Months);
    }else if(days >= 271  && days <= 300) {
      Utils.timeFrame.add(Constant.frameLastWeek);
      Utils.timeFrame.add(Constant.frame4Weeks);
      Utils.timeFrame.add(Constant.frame4Months);
      Utils.timeFrame.add(Constant.frame8Months);
      // Utils.timeFrame.add(Constant.frame9Months);
    }else if(days >= 301  && days <= 330) {
      Utils.timeFrame.add(Constant.frameLastWeek);
      Utils.timeFrame.add(Constant.frame4Weeks);
      Utils.timeFrame.add(Constant.frame4Months);
      Utils.timeFrame.add(Constant.frame8Months);
      // Utils.timeFrame.add(Constant.frame10Months);
    }else if(days >= 331  && days <= 360) {
      Utils.timeFrame.add(Constant.frameLastWeek);
      Utils.timeFrame.add(Constant.frame4Weeks);
      Utils.timeFrame.add(Constant.frame4Months);
      Utils.timeFrame.add(Constant.frame8Months);
      // Utils.timeFrame.add(Constant.frame11Months);
    }else if (days >= 361){
      Utils.timeFrame.add(Constant.frameLastWeek);
      Utils.timeFrame.add(Constant.frame4Weeks);
      Utils.timeFrame.add(Constant.frame3Months);
      Utils.timeFrame.add(Constant.frame6Months);
      Utils.timeFrame.add(Constant.frame1Year);
    }
    Utils.timeFrame.add(Constant.frameLifeTime);
    update();
    return Utils.timeFrame;
  }*/


  Map findFirstAndLastDates(List<ActivityTable> dataList) {
    if (dataList.isEmpty) {
      throw ArgumentError('The data list should not be empty.');
    }

    DateTime firstDate = DateTime.parse( dataList[0].date.toString());
    DateTime lastDate = DateTime.parse( dataList[0].date.toString());

    for (var data in dataList) {
      if (DateTime.parse(data.date.toString()) != null) {
        if (DateTime.parse(data.date.toString()).isBefore(firstDate)) {
          firstDate = DateTime.parse(data.date.toString());
        }
        if (DateTime.parse(data.date.toString()).isAfter(lastDate)) {
          lastDate = DateTime.parse(data.date.toString());
        }
      }
    }

    Map data= Map();
    data["firstDate"] = firstDate.toString();
    data["lastDate"] = lastDate.toString();

    return data;
  }
  List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    DateTime currentDate = startDate;
    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      days.add(currentDate);
      currentDate = currentDate.add(Duration(days: 1));
    }
    return days;
  }

}
