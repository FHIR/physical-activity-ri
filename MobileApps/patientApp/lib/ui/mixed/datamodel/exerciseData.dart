import '../../../db_helper/box/notes_data.dart';

class ExerciseData {
  String? status = "";
  String? priority = "";
  String? referralScope = "";
  bool isPeriodDate = false;
  DateTime? startDate;
  DateTime? endDate;
  String performerId = "";
  bool readonly = false;
  bool isSync = false;
  String? objectId = "";
  String? patientId;
  String? taskId = "";
  String? referralCode = "";
  String performerName = "";
  String providerId = "";
  DateTime? createdDate;
  DateTime? lastUpdatedDate;
  String patientName = "";
  String providerName = "";
  String qrUrl = "";
  String token = "";
  String clientId = "";
  String? textReasonCode = "";
  List<NoteTableData> noteList = [];
}
