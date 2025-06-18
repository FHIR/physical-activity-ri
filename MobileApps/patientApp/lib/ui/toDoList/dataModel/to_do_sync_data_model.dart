import 'package:banny_table/db_helper/box/notes_data.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:fhir/r4.dart';
import 'package:fhir/r4/general_types/general_types.dart';
import 'package:fhir/r4/special_types/special_types.dart';

class TaskSyncDataModel{

  int keyId = 0;
  String objectId = "";
  String status = "";
  String statusReason = "";
  // String businessStatusReason = "";
  String patientId = "";
  String code = "";
  String display = "";
  String text = "";
  String priority = "";
  String tag = "";
  bool isSync = true;
  DateTime? lastUpdatedDate;
  DateTime? createdDate;
  Reference? forReference;
  Reference? requesterReference;
  Reference? ownerReference;
  Reference? focusReference;
  String? qrUrl;
  String? token;
  String? clientId;
  String? patientName;
  String? generalResponseText = "";
  String? chosenContactText = "";
  List<NoteTableData>? notesList = [];
  String? performerName;
  String? performerId;
  String makeContactDescription = "";
  String reviewMaterialURL = "";
  String reviewMaterialTitle = "";
  String generalDescription = "";

  List<Annotation> getNotes1()
  {
    List<Annotation> currentNotes= [];
    if(notesList!=null)
    {
      for(int i=0;i<notesList!.length;i++)
      {
        Annotation note =  Annotation(text: Markdown(notesList![i].notes.toString()) , time: FhirDateTime(notesList![i].date),
            authorReference: Reference(reference: 'Patient/${Utils.getPatientId()}',display: Utils.getPatientFName()));
        currentNotes.add(note);
      }
    }

    return currentNotes;
  }

  List<Annotation> getNotes()
  {
    List<Annotation> currentNotes= [];
    if(notesList!=null)
    {
      for(int i=0;i<notesList!.length;i++)
      {
        Annotation note =  Annotation(text: Markdown(notesList![i].notes.toString()) , time: FhirDateTime(notesList![i].date),
            authorReference: Reference(reference: '${(notesList![i].isCreatedNote ?? false)?"Patient":"Practitioner"}/${Utils.getPatientId()}',
            display: notesList![i].author.toString()));
        currentNotes.add(note);
      }
    }

    return currentNotes;
  }


}