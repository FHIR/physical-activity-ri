import 'package:hive/hive.dart';
part 'referral_data.g.dart';

@HiveType(typeId: 55)
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
  bool? isCreated = true;

  @HiveField(15)
  String providerId = "";

  /*Below are local(Temp) variable this will not store in the hive*/
  String requesterId = "";
  String requesterName = "";

  @HiveField(16)
  DateTime? createdDate;

  @HiveField(17)
  DateTime? lastUpdatedDate;

  @HiveField(18)
  String qrUrl = "";

  @HiveField(19)
  String token = "";

  @HiveField(20)
  String clientId = "";

  @HiveField(21)
  String patientName = "";

  @HiveField(22)
  String providerName = "";

  @HiveField(23)
  String textReasonCode = "";

  @HiveField(24)
  List<String>? conditionObjectId;

}