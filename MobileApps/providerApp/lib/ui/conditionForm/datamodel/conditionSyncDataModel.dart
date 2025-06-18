
import 'package:banny_table/db_helper/box/notes_data.dart';

class ConditionSyncDataModel{
  String objectId = "";
  int keyId = 0;
  bool isSync = true;
  String? verificationStatus;
  DateTime? onset;
  DateTime? abatement;
  bool readOnly = false;
  bool isDelete = false;
  bool isSelected = false;
  String? patientId;
  String? code;
  String? display;
  String? text;
  String? qrUrl;
  String? token;
  String? clientId;
  String? patientName;
  String? providerId;
  String? providerName;
  String? detalis;
  List<NoteTableData> noteList = [];


}

class ConditionCodeDataModel{
  String? code = "";
  String display = "";

  ConditionCodeDataModel({this.code,required this.display});

}