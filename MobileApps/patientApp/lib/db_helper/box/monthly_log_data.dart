import 'package:banny_table/db_helper/box/server_detail_data.dart';
import 'package:hive/hive.dart';

import 'identifier_data.dart';
part 'monthly_log_data.g.dart';

@HiveType(typeId: 7)
class MonthlyLogTableData extends HiveObject {
  MonthlyLogTableData(
      {this.monthName,
      this.year,
      this.dayPerWeekValue,
      this.avgMinValue,
      this.avgMInPerWeekValue,
      this.strengthValue,
      this.patientId,
      });

  @HiveField(0)
  String? monthName;

  @HiveField(1)
  int? year;

  @HiveField(2)
  double? dayPerWeekValue;

  @HiveField(3)
  double? avgMinValue;

  @HiveField(4)
  double? avgMInPerWeekValue;

  @HiveField(5)
  double? strengthValue;

  @HiveField(6)
  bool isOverrideDayPerWeek = false;

  @HiveField(7)
  bool isOverrideAvgMin = false;

  @HiveField(8)
  bool isOverrideAvgMinPerWeek = false;

  @HiveField(9)
  bool isOverrideStrength = false;

  @HiveField(10)
  bool isSyncDayPerWeek = true;

  @HiveField(11)
  bool isSyncAvgMin = true;

  @HiveField(12)
  bool isSyncAvgMinPerWeek = true;

  @HiveField(13)
  bool isSyncStrength = true;

  @HiveField(14)
  DateTime? startDate;

  @HiveField(15)
  DateTime? endDate;

  @HiveField(16)
  bool? isSync = true;

  @HiveField(17)
  String dayPerWeekId = "";

  @HiveField(18)
  String avgMinPerDayId = "";

  @HiveField(19)
  String avgPerWeekId = "";

  @HiveField(20)
  String strengthId = "";

  @HiveField(21)
  String? patientId;

  @HiveField(22)
  String qrUrl = "";

  @HiveField(23)
  List<String> serverUrlList = [];

  @HiveField(24)
  List<String> patientIdList = [];

  @HiveField(25)
  List<String> clientIdList = [];

  @HiveField(26)
  List<String> patientNameList = [];

  @HiveField(27)
  List<String> serverTokenList = [];

/*  @HiveField(28)
  List<String> objectIdList = [];*/

  @HiveField(28)
  List<ServerDetailDataTable> serverDetailListDayPerWeek = [];

  @HiveField(29)
  List<ServerDetailDataTable> serverDetailListAvgMin = [];

  @HiveField(30)
  List<ServerDetailDataTable> serverDetailListAvgMinWeek = [];

  @HiveField(31)
  List<ServerDetailDataTable> serverDetailListStrength = [];

  /*@HiveField(28)
  List<bool> syncDayPerWeekServerWiseList = [];

  @HiveField(29)
  List<bool> syncAvgMinServerWiseList = [];

  @HiveField(30)
  List<bool> syncAvgMinPerWeekServerWiseList = [];

  @HiveField(31)
  List<bool> syncStrengthServerWiseList = [];



  @HiveField(32)
  List<String> objectIdDayPerWeekList = [];

  @HiveField(33)
  List<String> objectIdAvgMinList = [];

  @HiveField(34)
  List<String> objectIdAvgMinPerWeekList = [];

  @HiveField(35)
  List<String> objectIdStrengthList = [];



  @HiveField(36)
  List<String> serverUrlDayPerWeekList = [];

  @HiveField(37)
  List<String> serverUrlAvgMinList = [];

  @HiveField(38)
  List<String> serverUrlAvgMinPerWeekList = [];

  @HiveField(39)
  List<String> serverUrlStrengthList = [];



  @HiveField(40)
  List<String> patientIdDayPerWeekList = [];

  @HiveField(41)
  List<String> patientIdAvgMinList = [];

  @HiveField(42)
  List<String> patientIdAvgMinPerWeekList = [];

  @HiveField(43)
  List<String> patientIdStrengthList = [];



  @HiveField(44)
  List<String> clientIdDayPerWeekList = [];

  @HiveField(45)
  List<String> clientIdAvgMinList = [];

  @HiveField(46)
  List<String> clientIdAvgMinPerWeekList = [];

  @HiveField(47)
  List<String> clientIdStrengthList = [];



  @HiveField(48)
  List<String> patientNameDayPerWeekList = [];

  @HiveField(49)
  List<String> patientNameAvgMinList = [];

  @HiveField(50)
  List<String> patientNameAvgMinPerWeekList = [];

  @HiveField(51)
  List<String> patientNameStrengthList = [];


  @HiveField(52)
  List<String> serverTokenListDayPerWeekList = [];

  @HiveField(53)
  List<String> serverTokenListAvgMinList = [];

  @HiveField(54)
  List<String> serverTokenListAvgMinPerWeekList = [];

  @HiveField(55)
  List<String> serverTokenListStrengthList = [];
*/

  @HiveField(32)
  List<IdentifierTable> dayPerWeekIdentifierData = [];

  @HiveField(33)
  List<IdentifierTable> avgMinIdentifierData = [];

  @HiveField(34)
  List<IdentifierTable> avgMinPerWeekIdentifierData = [];

  @HiveField(35)
  List<IdentifierTable> strengthIdentifierData = [];
}