import 'package:flutter/material.dart';

class OtherTitles2CheckBoxWeek{
  TextEditingController weekValueTitle2CheckBoxController = TextEditingController();
  FocusNode weekValueTitle2CheckBoxFocus = FocusNode();
  String date = "";
  // int total = 0;
  int? total;
  String dayName = "";
  String weekName = "";
  String titleName = "";
  DateTime? storedDate;
  List<OtherTitles2CheckBoxDay> daysListCheckBox = [];
  DateTime? weekStartDate;
  DateTime? weekEndDate;
  bool isExpanded = false;
  OtherTitles2CheckBoxWeek(this.weekName,this.daysListCheckBox,this.weekStartDate,this.weekEndDate,this.titleName);
}

class OtherTitles2CheckBoxDay{
  String date = "";
  String dayName = "";
  String titleName = "";
  String weekName = "";
  DateTime? storedDate;
  List<OtherTitles2CheckBoxDaysData> daysDataListCheckBox = [];
  bool isExpanded = false;
  bool isCheckedDay = false;
  bool isShow = true;
  OtherTitles2CheckBoxDay(this.dayName,this.date,this.weekName,this.titleName,this.daysDataListCheckBox,this.storedDate,
      this.isCheckedDay);


}

class OtherTitles2CheckBoxDaysData{
  String name = "";
  String titleName = "";
  String date = "";
  String dayName = "";
  String weekName = "";
  DateTime? storedDate;
  bool isExpanded = false;
  bool isCheckedDaysData = false;
  String activityName = "";
}
