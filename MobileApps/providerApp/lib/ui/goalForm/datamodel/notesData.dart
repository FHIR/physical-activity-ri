import 'package:flutter/cupertino.dart';

class NotesData{
  String? author = "";
  String? authorReference = "";
  DateTime? date;
  String? notes = "";
  TextEditingController controller = TextEditingController();
  bool? isDelete = false;
  bool? readOnly = false;
  int? goalId;
  int? noteId;
  int? referralId;
  int? routingId;
  int? carePlanId;
  int? exerciseId;
  int? createdReferralId;
  int? assignedReferralId;
  int? createdTaskId;

  ///isCreatedNote = If notes created by patient then true otherwise false
  bool? isCreatedNote = false;


  NotesData({this.author,this.date,this.notes,this.isDelete,this.isCreatedNote,this.authorReference});

}

/*
class NoteDataHive{

  String notes = "";
  TextEditingController controller = TextEditingController();
}*/
