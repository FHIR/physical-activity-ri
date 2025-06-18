import 'package:banny_table/utils/constant.dart';
import 'package:flutter/material.dart';

class CaloriesStepHeartRateWeek{
  TextEditingController weekValueTitleController = TextEditingController();
  TextEditingController weekValue1Title5Title5Controller = TextEditingController();
  TextEditingController weekValue2Title5Controller = TextEditingController();
  FocusNode weekValueFocus = FocusNode();
  FocusNode weekValue1Focus = FocusNode();
  FocusNode weekValue2Focus = FocusNode();
  String date = "";
  int total = 0;
  String dayName = "";
  String weekName = "";
  String titleName = "";
  DateTime? storedDate;
  List<CaloriesStepHeartRateDay> daysList = [];
  DateTime? weekStartDate;
  DateTime? weekEndDate;
  bool isExpanded = false;
  int smileyType = 1;
  bool isSync = true;
  CaloriesStepHeartRateWeek(this.weekName,this.daysList,this.weekStartDate,this.weekEndDate,this.titleName);
}

class CaloriesStepHeartRateDay{
  TextEditingController daysValueTitleController = TextEditingController();
  TextEditingController daysValue1Title5Controller = TextEditingController();
  TextEditingController daysValue2Title5Controller = TextEditingController();
  FocusNode daysValueFocus = FocusNode();
  FocusNode daysValue1Focus = FocusNode();
  FocusNode daysValue2Focus = FocusNode();
  String date = "";
  int total = 0;
  String dayName = "";
  String titleName = "";
  String weekName = "";
  DateTime? storedDate;
  List<CaloriesStepHeartRateData> daysDataList = [];
  bool isExpanded = false;
  int smileyType = Constant.defaultSmileyType;
  bool isShow = true;
  bool isSync = true;
  CaloriesStepHeartRateDay(this.dayName,this.date,this.weekName,this.titleName,this.daysDataList,this.storedDate);


}

class CaloriesStepHeartRateData{
  String name = "";
  String titleName = "";
  TextEditingController daysDataValueTitleController = TextEditingController();
  TextEditingController daysDataValue1Title5Controller = TextEditingController();
  TextEditingController daysDataValue2Title5Controller = TextEditingController();
  FocusNode daysDataValueFocus = FocusNode();
  FocusNode daysDataValue1Focus = FocusNode();
  FocusNode daysDataValue2Focus = FocusNode();
  String date = "";
  int total = 0;
  String dayName = "";
  String weekName = "";
  DateTime? storedDate;
  bool isExpanded = false;
  int smileyType = Constant.defaultSmileyType;
  DateTime? activityStartDate;
  DateTime? activityEndDate;
  String activityName = "";

}
