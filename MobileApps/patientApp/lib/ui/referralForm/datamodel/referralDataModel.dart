import 'package:banny_table/db_helper/box/notes_data.dart';
import 'package:fhir/r4.dart';
import 'package:fhir/r4/general_types/general_types.dart';


class ReferralSyncDataModel{
  String objectId = "";
  String taskId = "";
  int keyId = 0;
  // int? goalId;
  String? status;
  // String? intent;
  String? priority;
  String? code;
  String? display;
  String? text;
  bool isPeriodDate = false;
  DateTime? startDate;
  DateTime? endDate;
  /*Performer ID*/
  String? performerId;
  String? performerName;
  // bool isAddedRoute = false;
  List<NoteTableData>? notesList;
  // List<int>? referralIdList;
  // List<String>? goalObjectId;
  bool readonly = true;
  bool isSync = true;
  String? qrUrl;
  String? token;
  String? clientId;
  String? patientId;
  String? patientName;

  // List<RoutingReferralSyncData> routingReferralList = [];


  /*List<Reference> getGoals() {
    List<Reference> goals = [];
    if (goalObjectId != null) {
      for (int i = 0; i < goalObjectId!.length; i++) {
        Reference ob = Reference(reference: 'Goal/${goalObjectId![i]}');
        goals.add(ob);
      }
    }

    return goals;
  }*/

  List<Annotation> getNotes()
  {
    List<Annotation> currentNotes= [];
    if(notesList!=null)
    {
      for(int i=0;i<notesList!.length;i++)
      {
        Annotation note =  Annotation(text: Markdown(notesList![i].notes.toString()) , time: FhirDateTime(notesList![i].date), authorReference: Reference(reference: 'Practitioner/250195'));
        currentNotes.add(note);
      }
    }

    return currentNotes;
  }
}
