import 'package:fhir/r4.dart';
import 'package:fhir/r4/general_types/general_types.dart';
import 'package:fhir/r4/special_types/special_types.dart';

import '../../../db_helper/box/notes_data.dart';
import '../../../utils/utils.dart';

class TaskSyncDataModel{

  int keyId = 0;
  String objectId = "";
  String status = "";
  String statusReason = "";
  String businessStatusReason = "";
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
  List<NoteTableData> notesList = [];
  String? qrUrl;
  String? token;
  String? clientId;
  String? patientName;
  String? providerId;
  String? providerName;
  String? performerName;
  String? performerId;
  String makeContactDescription = "";
  String reviewMaterialURL = "";
  String reviewMaterialTitle = "";
  String generalDescription = "";
  String? generalResponseText;
  String? chosenContactText;
  String referralTypeDisplay = "";
  String referralTypeCode = "";
  bool isPeriodDate = false;
  DateTime? startDate;
  DateTime? endDate;



  List<Annotation> getNotes()
  {
    List<Annotation> currentNotes= [];
    if(notesList!=null)
    {
      for(int i=0;i<notesList!.length;i++)
      {
        Annotation note =  Annotation(text: Markdown(notesList![i].notes.toString()) , time: FhirDateTime(notesList![i].date),
            authorReference: Reference(reference: '${(notesList![i].isCreatedNote ?? false)?"Practitioner":"Patient"}/${Utils.getProviderId()}',
                display: notesList![i].author.toString()));
        currentNotes.add(note);
      }
    }

    return currentNotes;
  }


  List<Annotation> getNotesBackendTask()
  {
    List<Annotation> currentNotes= [];
    for(int i=0;i<notesList.length;i++)
    {
      Annotation note =  Annotation(text: Markdown(notesList[i].notes.toString()) , time: FhirDateTime(notesList[i].date),
          authorReference: Reference(reference: notesList[i].authorReference.toString(),
              display: notesList[i].author.toString()));
      currentNotes.add(note);
    }

    return currentNotes;
  }
}