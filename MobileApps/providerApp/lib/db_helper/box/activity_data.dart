import 'package:banny_table/db_helper/box/identifier_data.dart';
import 'package:banny_table/db_helper/box/server_detail_data.dart';
import 'package:banny_table/db_helper/box/server_detail_data_mod_min.dart';
import 'package:banny_table/db_helper/box/server_detail_data_vig_min.dart';
import 'package:hive/hive.dart';
part 'activity_data.g.dart';

@HiveType(typeId: 10)
class ActivityTable extends HiveObject {
  ActivityTable(
      {this.id,
      this.name,
      this.date,
      this.title,
      this.value1,
      this.value2,
      this.total,
      this.type,
      this.weeksDate,
      this.patientId,
      this.dateTime,
      this.displayLabel,
      this.insertedDayDataId,
      this.smileyType,
      this.isCheckedDay,
      this.isCheckedDayData,
      });

  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  /*YYYY-MM-DD*/
  @HiveField(2)
  String? date;

  @HiveField(3)
  String? title;

  @HiveField(4)
  double? value1;

  @HiveField(5)
  double? value2;

  @HiveField(6)
  double? total;

  /*weekData = 0, dayData = 1, daysData = 2*/
  @HiveField(7)
  int? type;

  @HiveField(8)
  String? weeksDate;

  @HiveField(9)
  String? patientId;

  @HiveField(10)
  DateTime? dateTime;

  @HiveField(11)
  String? displayLabel;

  @HiveField(12)
  int? insertedDayDataId;

  @HiveField(13)
  int? smileyType;

  @HiveField(14)
  bool? isCheckedDay = false;

  @HiveField(15)
  bool? isCheckedDayData = false;

  @HiveField(16)
  String? notes;

  @HiveField(17)
  bool isOverride = false;

  @HiveField(18)
  bool isSync = true;

  @HiveField(19)
  String objectId = "";

  @HiveField(20)
  String iconPath = "";

  @HiveField(21)
  bool needExport = false;

  @HiveField(22)
  String providerId = "";

  @HiveField(23)
  double? expreianceIconValue;


  @HiveField(24)
  List<ServerDetailDataTable> serverDetailList = [];

  @HiveField(25)
  List<IdentifierTable> identifierData = [];

  @HiveField(26)
  DateTime? activityStartDate;

  @HiveField(27)
  DateTime? activityEndDate;

  @HiveField(28)
  List<ServerDetailDataModMinTable> serverDetailListModMin = [];

  @HiveField(29)
  List<IdentifierTable> identifierDataModMin = [];

  @HiveField(30)
  List<ServerDetailDataVigMinTable> serverDetailListVigMin = [];

  @HiveField(31)
  List<IdentifierTable> identifierDataVigMin = [];

  @HiveField(32)
  String qrUrl = "";

}