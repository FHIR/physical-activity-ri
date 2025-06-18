import 'package:hive/hive.dart';
part 'exercise_prescription_data.g.dart';

@HiveType(typeId: 97)
class ExerciseData extends HiveObject {

/*  @HiveField(0)
  int? goalId;*/

  @HiveField(0)
  String? status = "";



  @HiveField(1)
  String? priority = "";

  // Code IS Exercise Scope
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
  String providerId = "";

  @HiveField(15)
  DateTime? createdDate;

  @HiveField(16)
  DateTime? lastUpdatedDate;

  @HiveField(17)
  String patientName = "";

  @HiveField(18)
  String providerName = "";


  @HiveField(19)
  String qrUrl = "";

  @HiveField(20)
  String token = "";

  @HiveField(21)
  String clientId = "";

  @HiveField(22)
  String? textReasonCode = "";


}