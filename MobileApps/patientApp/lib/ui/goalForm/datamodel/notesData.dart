import 'package:flutter/cupertino.dart';

class NotesData {
  String? author = "";
  DateTime? date;
  String? notes = "";
  TextEditingController controller = TextEditingController();
  bool? isDelete = false;
  bool? readOnly = false;

  ///isCreatedNote = If notes created by patient then true otherwise false
  bool? isCreatedNote = false;

  int? goalId;
  int? noteId;
  int? referralId;
  int? routingId;
  int? carePlanId;
  int? TaskId;

  NotesData({this.author, this.date, this.notes, this.isDelete,this.isCreatedNote});
}