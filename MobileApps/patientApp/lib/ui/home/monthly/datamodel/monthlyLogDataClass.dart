import 'package:banny_table/ui/home/monthly/datamodel/weeksOfMonths.dart';
import 'package:flutter/cupertino.dart';

class MonthlyLogDataClass{
  String monthName = "";
  TextEditingController dayPerWeekController = TextEditingController();
  TextEditingController avgMinController = TextEditingController();
  TextEditingController avgMinPerWeekController = TextEditingController();
  TextEditingController strengthController = TextEditingController();
  FocusNode dayPerWeekFocus = FocusNode();
  FocusNode avgMinFocus = FocusNode();
  FocusNode avgMinPerWeekFocus = FocusNode();
  FocusNode strengthFocus = FocusNode();
  int? dayPerWeekValue;
  int? avgMinValue;
  int? avgMinPerWeekValue;
  int? strengthValue;

  bool isOverrideDayPerWeek = false;
  bool isOverrideAvgMin = false;
  bool isOverrideAvgMinPerWeek = false;
  bool isOverrideStrength = false;

  bool isSyncDayPerWeek = false;
  bool isSyncAvgMin = false;
  bool isSyncAvgMinPerWeek = false;
  bool isSyncStrength = false;

  int keyId = 0 ;
  int year = 0 ;
  bool isShowHeader = false;
  bool isOnlyWeeklyCount = false;
  List<DateTime> monthStartAndEndDataList = [];

  List<WeeksOfMonths> weeksOfMonthsList = [];

  MonthlyLogDataClass(this.monthName,this.weeksOfMonthsList,this.year);
}