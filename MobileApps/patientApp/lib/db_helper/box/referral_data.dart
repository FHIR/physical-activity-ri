import 'package:banny_table/db_helper/box/notes_data.dart';
import 'package:hive/hive.dart';
part 'referral_data.g.dart';

@HiveType(typeId: 9)
class ReferralData extends HiveObject {

/*  @HiveField(0)
  int? goalId;*/

  @HiveField(0)
  String? status = "";

  @HiveField(1)
  String? priority = "";

  // Code IS Referral Scope
  @HiveField(2)
  String? referralScope = "";

  @HiveField(3)
  bool isPeriodDate = false;

  @HiveField(4)
  DateTime? startDate;

  @HiveField(5)
  DateTime? endDate;

  @HiveField(6)
  String performerId = "";

  /*@HiveField(10)
  List<String>? notesList;*/

 /* @HiveField(10)
  bool isAddedRoute = false;

  @HiveField(11)
  List<int>? referralIdList;*/

  @HiveField(7)
  bool readonly = false;

  @HiveField(8)
  bool isSync = false;

  @HiveField(9)
  String? objectId = "";

  @HiveField(10)
  String? patientId;

  /*@HiveField(11)
  List<String>? goalObjectId;*/

  @HiveField(11)
  String? taskId = "";

  @HiveField(12)
  String? referralCode = "";

  @HiveField(13)
  String performerName = "";

  @HiveField(14)
  String qrUrl = "";

  @HiveField(15)
  String token = "";

  @HiveField(16)
  String clientId = "";

  @HiveField(17)
  String patientName = "";


  @HiveField(18)
  String textReasonCode = "";

  @HiveField(19)
  List<String>? conditionObjectId;

  List<NoteTableData> notesList = [];
}