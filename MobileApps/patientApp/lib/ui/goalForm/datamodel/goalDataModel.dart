import 'package:banny_table/db_helper/box/notes_data.dart';
import 'package:fhir/r4.dart';

import '../../../utils/utils.dart';

class GoalSyncDataModel {
  String objectId = "";
  int keyId = 0;
  String? goalId;
  String? goalsType;
  String? target;
  DateTime? dueDate;
  String? description;
  String? lifeCycleStatus;
  String? achievementStatus;
  List<NoteTableData>? notesList = [];
  String? code;
  String? system;
  String? actualDescription;
  String? placeHolderValue;
  DateTime? createdDate;
  DateTime? updatedDate;
  String? expressedBy = "";
  String? expressedByDisplay = "";
  bool isSync = true;
  String? qrUrl;
  String? token;
  String? clientId;
  String? patientId;
  String? patientName;
  String? multipleGoals;
  bool isEditable = true;
  bool readOnly = false;
  String? notes;
  bool isSelected = false;

  List<Annotation> getNotes() {
    List<Annotation> currentNotes = [];
    if (notesList != null) {
      for (int i = 0; i < notesList!.length; i++) {
        Annotation note = Annotation(
            text: Markdown(notesList![i].notes.toString()),
            time: FhirDateTime(notesList![i].date),
            authorReference: Reference(
                reference: '${(notesList![i].isCreatedNote ?? false)?"Patient":"Practitioner"}/${Utils.getPatientId()}',
                display: notesList![i].author.toString()));
                // display: Utils.getFullName()));
        currentNotes.add(note);
      }
    }

    return currentNotes;
  }
}
