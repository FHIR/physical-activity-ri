import 'package:banny_table/db_helper/box/notes_data.dart';
import 'package:fhir/r4.dart';
import 'package:fhir/r4/general_types/general_types.dart';
import 'package:fhir/r4/special_types/special_types.dart';

import '../../../db_helper/box/goal_data.dart';
import '../../../utils/utils.dart';

class CarePlanSyncDataModel{
  String objectId = "";
  int keyId = 0;
  List<NoteTableData> notesList = [];

  List<GoalTableData>? goalList;

  String? text;

  String? statusDropDown;

  String? status;

  DateTime? startDate;

  DateTime? endDate;

  String? goal;

  bool isSync = true;

  bool readOnly = false;

  bool isDelete = false;

  String? qrUrl;
  String? token;
  String? clientId;
  String? patientId;
  String? patientName;
  String? providerId;
  String? providerName;

  List<String>? goalObjectId;

  List<Annotation> getNotes()
  {
    List<Annotation> currentNotes= [];
    if(notesList!=null)
    {
      for(int i=0;i<notesList!.length;i++)
      {
        Annotation note =  Annotation(text: Markdown(notesList![i].notes.toString()) , time: FhirDateTime(notesList![i].date),
            authorReference: Reference(reference: 'Practitioner/${Utils.getProviderId()}',display: Utils.getProviderName()));
        currentNotes.add(note);
      }
    }

    return currentNotes;
  }

  List<Reference> getGoals() {
    List<Reference> goals = [];
    if (goalObjectId != null) {
      for (int i = 0; i < goalObjectId!.length; i++) {
        Reference ob = Reference(reference: 'Goal/${goalObjectId![i]}');
        goals.add(ob);
      }
    }

    return goals;
  }
}