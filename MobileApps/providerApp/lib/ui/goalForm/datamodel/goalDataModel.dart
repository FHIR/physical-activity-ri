import 'package:banny_table/db_helper/box/notes_data.dart';
import 'package:fhir/primitive_types/decimal.dart';
import 'package:fhir/r4.dart';
import 'package:fhir/r4/general_types/general_types.dart';
import 'package:fhir/r4/special_types/special_types.dart';

import '../../../utils/utils.dart';

class GoalSyncDataModel{
  String objectId = "";
  int keyId = 0;
  String? goalId;
  String? goalsType;
  String? target;
  DateTime? dueDate;
  String? description;
  String? lifeCycleStatus;
  String? achievementStatus;
  List<NoteTableData> notesList = [];
  String? code;
  String? system;
  String? actualDescription;
  String? placeHolderValue;
  DateTime? createdDate;
  DateTime? updatedDate;
  String? expressedBy;
  String? expressedByDisplay;
  bool isSync = true;
  String? qrUrl;
  String? token;
  String? clientId;
  String? patientId;
  String? patientName;
  String? providerId;
  String? providerName;
  String? multipleGoals;
  bool? readOnly = false;
  bool isSelected = false;


  List<Annotation> getNotes()
  {
    List<Annotation> currentNotes= [];
    if(notesList!=null)
      {
        for(int i=0;i<notesList!.length;i++)
          {
            Annotation note =  Annotation(text: Markdown(notesList![i].notes.toString()) , time: FhirDateTime(notesList![i].date), authorReference:
            // Reference(reference: 'Practitioner/${Utils.getProviderId()}',display: Utils.getFullName()));
            Reference(reference: '${(notesList![i].isCreatedNote ?? false)?"Practitioner":"Patient"}/${Utils.getPatientId()}',
                display: notesList![i].author.toString()));
            currentNotes.add(note);
          }
      }
    
    return currentNotes;
  }
}