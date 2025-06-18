import 'package:flutter/material.dart';

class WeekLevelData{
  String weekName = "";
  int modMinValue = 0;
  int vigMinValue = 0;
  int totalMinValue = 0;
  DateTime? weekStartDate;
  DateTime? weekEndDate;
  TextEditingController modMinController = TextEditingController();
  TextEditingController vigMinController = TextEditingController();
  TextEditingController totalMinController = TextEditingController();
  FocusNode modMinValueFocus = FocusNode();
  FocusNode vigMinValueFocus = FocusNode();
  FocusNode totalMinValueFocus = FocusNode();
  List<DayLevelData> dayLevelDataList = [];
  bool isExpanded = false;
  int smileyType = 0;
  String weeklyNotes = "";
  bool isOverride = false;
  WeekLevelData(this.weekName,this.dayLevelDataList,this.weekStartDate,this.weekEndDate);
}

class DayLevelData{
  String dayName = "";
  String date = "";
  String weekName = "";
  List<ActivityLevelData> activityLevelDataList = [];
  List<String> activityLevelData = [];
  List<String> activityLevelDataIcons = [];
  DateTime? storedDate;
  int modMinValue = 0;
  int vigMinValue = 0;
  int totalMinValue = 0;
  int smileyType = 0;
  bool isShow = true;
  TextEditingController modMinController = TextEditingController();
  TextEditingController vigMinController = TextEditingController();
  TextEditingController totalMinController = TextEditingController();
  FocusNode modMinValueFocus = FocusNode();
  FocusNode vigMinValueFocus = FocusNode();
  FocusNode totalMinValueFocus = FocusNode();
  bool isExpanded = false;
  String dailyNotes = "";
  bool isOverride = false;
  DayLevelData(this.dayName,this.date,this.weekName,this.activityLevelDataList,this.storedDate);
}

class ActivityLevelData{
  String titleName = "";
  String displayLabel = "";
  String iconPath = "";
  DateTime? storedDate;
  bool selected = false;
  bool isFromAppleHealth = false;
  int? modMinValue;
  int? vigMinValue;
  int? totalMinValue;
  int smileyType = 0;
  String dayDataNotes = "";
  TextEditingController modMinController = TextEditingController();
  TextEditingController vigMinController = TextEditingController();
  TextEditingController totalMinController = TextEditingController();
  FocusNode modMinValueFocus = FocusNode();
  FocusNode vigMinValueFocus = FocusNode();
  FocusNode totalMinValueFocus = FocusNode();
  DateTime activityStartDate = DateTime.now();
  DateTime activityEndDate = DateTime.now();
  // DateTime activityStartDateLast = DateTime.now();
  // DateTime activityEndDateLast = DateTime.now();
  bool isOverride = false;
}
