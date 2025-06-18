import 'package:banny_table/db_helper/box/notes_data.dart';
import 'package:fhir/r4.dart';
import 'package:fhir/r4/general_types/general_types.dart';

import '../../../utils/utils.dart';

class ExercisePrescriptionSyncDataModel{
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
  String? referralScope;
  String? referralCode;
  bool isPeriodDate = false;
  DateTime? startDate;
  DateTime? endDate;
  /*Performer ID*/
  String? performerId;
  String? performerName;
  // bool isAddedRoute = false;
  List<NoteTableData> notesList = [];
  // List<int>? referralIdList;
  // List<String>? goalObjectId;
  bool readonly = true;
  bool isSync = true;
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
  // List<RoutingReferralSyncData> routingReferralList = [];



  List<Annotation> getNotes()
  {
    List<Annotation> currentNotes= [];
    if(notesList!=null)
    {
      for(int i=0;i<notesList!.length;i++)
      {
        Annotation note =  Annotation(text: Markdown(notesList![i].notes.toString()) , time: FhirDateTime(notesList![i].date), authorReference:
        Reference(reference: 'Practitioner/${Utils.getProviderId()}',display: Utils.getProviderName()));
        currentNotes.add(note);
      }
    }

    return currentNotes;
  }
}
