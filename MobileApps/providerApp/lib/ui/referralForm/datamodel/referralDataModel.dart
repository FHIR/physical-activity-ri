import 'package:banny_table/db_helper/box/condition_form_data.dart';
import 'package:banny_table/db_helper/box/notes_data.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:fhir/r4.dart';
import 'package:fhir/r4/general_types/general_types.dart';
import 'package:hive/hive.dart';


class ReferralSyncDataModel{
  String objectId = "";
  String taskId = "";
  int keyId = 0;
  String? status;
  String? priority;
  String? code;
  String? display;
  String? text;
  bool isPeriodDate = false;
  DateTime? startDate;
  DateTime? endDate;
  String? performerId;
  String? performerName;
  List<NoteTableData> notesList = [];
  bool readonly = true;
  bool isSync = true;
  String requesterId = "";
  String requesterName = "";
  DateTime? createdDate;
  DateTime? lastUpdatedDate;
  String? qrUrl;
  String? token;
  String? clientId;
  String? patientId;
  String? patientName;
  String? providerId;
  String? providerName;
  String? textReasonCode;
  String? referralTypeDisplay;
  String? referralTypeCode;
  List<String>? conditionObjectId;
  bool isCreated = true;

  List<Annotation> getNotesReferral()
  {
    List<Annotation> currentNotes= [];
    for(int i=0;i<notesList.length;i++)
    {
      Annotation note =  Annotation(text: Markdown(notesList[i].notes.toString()) , time: FhirDateTime(notesList[i].date), authorReference:
      Reference(reference: notesList[i].authorReference.toString(),display: notesList[i].author.toString()));
      currentNotes.add(note);
    }

    return currentNotes;
  }
/*
  List<CodeableConcept> getCondition() {
    List<ConditionTableData> createdCondition = [];
    createdCondition = Hive.box<ConditionTableData>(Constant.tableCondition)
        .values
        .toList()
        .where((element) =>
    element.patientId == Utils.getPatientId() && element.conditionID != "")
        .toList();
    List<CodeableConcept> conditionList = [];
    if(createdCondition.isNotEmpty){
      if (conditionObjectId != null) {
        for (int i = 0; i < conditionObjectId!.length; i++) {
          var data = createdCondition.where((element) => element.conditionID == conditionObjectId![i]).toList();
          CodeableConcept condition =  CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://snomed.info/sct'),
              code: Code(data[0].code), // make it dynamic as per selection
              display: data[0].display,
            ),
          ], text: data[0].detalis);
          conditionList.add(condition);
        }
      }
    }
    return conditionList;
  }*/

  List<Reference> getCondition() {
    List<Reference> createdCondition = [];
    if (conditionObjectId!.isNotEmpty) {
      for (int i = 0; i < conditionObjectId!.length; i++) {
        Reference ob = Reference(reference: 'Condition/${conditionObjectId![i]}');
        createdCondition.add(ob);
      }
    }
    return createdCondition;
  }

}
