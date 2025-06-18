import 'package:banny_table/db_helper/database_helper.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../db_helper/box/notes_data.dart';
import '../../../db_helper/box/referral_data.dart';
import '../../../db_helper/box/routing_referral_data.dart';
import '../../../utils/constant.dart';
import '../../goalForm/datamodel/notesData.dart';

class RoutingReferralController extends GetxController {

  TextEditingController statusReasonControllers = TextEditingController();
  // TextEditingController businessStatusControllers = TextEditingController();
  TextEditingController notesController = TextEditingController();

  var selectedPriority = "";
  String selectedOwner = "";
  var selectedStatusReason = "";

  TextEditingController addNewCodeController = TextEditingController();

  FocusNode statusReasonFocus = FocusNode();
  FocusNode notesControllersFocus = FocusNode();
  // FocusNode businessStatusFocus = FocusNode();

  RoutingReferralData editedRoutingReferralData = RoutingReferralData();
  var isEdited = false;
  List<NotesData> notesList = [];
  List<NoteTableData> noteDatabaseList = [];


  ReferralData insertedReferralData = ReferralData();

  var arg = Get.arguments;

  @override
  void onInit() {
    initValue();
    super.onInit();
  }

  void initValue() {
    if(arg != null){
      if(arg[0] != null){
        ///get data from previous screen Referral form (Inserted data)
        insertedReferralData = arg[0];
        selectedPriority = Utils.priorityList[0];
        selectedStatusReason = Utils.routingReferralStatus[0];
        selectedOwner = Utils.performerList[0].toString();
        update();
        // notesList.add(NotesData());
      }
      else if(arg[1] != null){
        /// Edited data
        editedRoutingReferralData = arg[1];
        isEdited = true;
        getNoteList();
        if(editedRoutingReferralData.status != null) {
          selectedStatusReason = editedRoutingReferralData.status!;
        }

        if(editedRoutingReferralData.statusReason != null) {
          statusReasonControllers.text = editedRoutingReferralData.statusReason!;
        }


        if(editedRoutingReferralData.priority != null){
          selectedPriority = editedRoutingReferralData.priority!;
        }

        if(editedRoutingReferralData.owner != null){
          selectedOwner =  editedRoutingReferralData.owner!;
        }

        /*for(int i=0; i <editedRoutingReferralData.notesList!.length;i++){
          var data = NotesData();
          data.notes = editedRoutingReferralData.notesList![i];
          data.controller.text = editedRoutingReferralData.notesList![i];
          notesList.add(data);
        }*/
      }
    }else{
      selectedStatusReason = Utils.routingReferralStatus[0];
      selectedPriority = Utils.priorityList[0];
      selectedOwner = Utils.performerList[0].toString();

      editedRoutingReferralData.readonly = false;
      update();
      // notesList.add(NotesData());
    }


  }


  getNoteList() async {
    noteDatabaseList = Hive.box<NoteTableData>(Constant.tableNoteData)
        .values
        .toList()
        .where((element) => element.routingId == editedRoutingReferralData.key)
        .toList();
    if (noteDatabaseList.isNotEmpty) {
      for (int i = 0; i < noteDatabaseList.length; i++) {
        var data = NotesData();
        data.notes = noteDatabaseList[i].notes;
        data.author = noteDatabaseList[i].author;
        data.readOnly = noteDatabaseList[i].readOnly;
        data.isDelete = noteDatabaseList[i].isDelete;
        data.date = noteDatabaseList[i].date;
        data.noteId = noteDatabaseList[i].key;
        data.routingId = editedRoutingReferralData.key;
        notesList.add(data);
      }
      await Debug.printLog("get NoteData");
    }
    update();
  }


  getSelectedStatus(value){
    selectedStatusReason = value;
    update();
  }

  getSelectedOwner(value){
    selectedOwner = value;
    update();
  }

  void onChangePriority(String value) {
    selectedPriority = value;
    update();
  }

  insertUpdateData() async {
    if (isEdited) {

      editedRoutingReferralData.status = selectedStatusReason;
      editedRoutingReferralData.statusReason = statusReasonControllers.text;
      editedRoutingReferralData.priority = selectedPriority;
      editedRoutingReferralData.owner = selectedOwner;
      await DataBaseHelper.shared.updateReferralRouteData(editedRoutingReferralData);
      var noteDataList = Hive.box<NoteTableData>(Constant.tableNoteData).values.toList();
      if (noteDataList.isNotEmpty && notesList.isNotEmpty) {
        for (int i = 0; i < notesList.length; i++) {
          // var noteTableData = NoteTableData();
          if (notesList[i].routingId != null) {
            var noteData = await DataBaseHelper.shared.getNoteDataID(notesList[i].noteId!);
            noteData.notes = notesList[i].notes;
            noteData.author = notesList[i].author;
            noteData.readOnly = notesList[i].readOnly!;
            noteData.date = notesList[i].date;
            noteData.isDelete = true;
            noteData.routingId = editedRoutingReferralData.key;
            await DataBaseHelper.shared.updateNoteData(noteData);
          } else {
            var noteTableData = NoteTableData();
            noteTableData.notes = notesList[i].notes;
            noteTableData.author = notesList[i].author;
            noteTableData.readOnly = false;
            noteTableData.date = notesList[i].date;
            noteTableData.isDelete = true;
            noteTableData.routingId = editedRoutingReferralData.key;
            await DataBaseHelper.shared.insertNoteData(noteTableData);
          }
        }
      }else{
        for (int i = 0; i < notesList.length; i++) {
          var noteTableData = NoteTableData();

          noteTableData.notes = notesList[i].notes;
          noteTableData.author = notesList[i].author;
          noteTableData.readOnly = false;
          noteTableData.date = notesList[i].date;
          noteTableData.isDelete = true;
          noteTableData.routingId = editedRoutingReferralData.key;
          await DataBaseHelper.shared.insertNoteData(noteTableData);
        }
      }


      Get.back();
    } else {
      RoutingReferralData data = RoutingReferralData();
      data.referralId = insertedReferralData!.key;
      data.status = selectedStatusReason;
      data.statusReason = statusReasonControllers.text;
      data.priority = selectedPriority;
      data.owner = selectedOwner;
      var insertId = await DataBaseHelper.shared.insertReferralRouteData(data);
      /*ADD Note Data*/
      DateTime nowDate = DateTime.now();
      for (int i = 0; i < notesList.length; i++) {
        var noteTableData = NoteTableData();
        noteTableData.notes = notesList[i].notes;
        noteTableData.author = notesList[i].author;
        noteTableData.readOnly = false;
        noteTableData.date =
            DateTime(nowDate.year, nowDate.month, nowDate.day);
        noteTableData.isDelete = true;
        noteTableData.routingId = insertId;
        await DataBaseHelper.shared.insertNoteData(noteTableData);
        /*Add Id */


      }
      // insertedReferralData.referralIdList!.add(insertId);
      // insertedReferralData.isAddedRoute = true;
      await DataBaseHelper.shared.updateReferralData(insertedReferralData);

      if (arg[2] != null) {
        Get.back();
      } else {
        Get.back();
        Get.back();
      }

    }

    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? selectedSyncing =
        pref.getString(Constant.keySyncing) ?? Constant.realTime;
    if (selectedSyncing == Constant.realTime) {
      // await Syncing.referralSyncingData(true, []);
    }
  }

  /*addNotesData(){
    notesList.add(NotesData());
    update();
  }*/
  addNotesData(String text, bool isEditNote, int index) async {
    if (isEditNote) {
      notesList[index].notes = text;
    } else {
      notesList.add(NotesData(
          isDelete: false,
          author: Utils.getFullName(),
          notes: text,
          date: DateTime.now()));
    }
    notesController.clear();
    Get.back();
    update();
  }

  editNoteDataController(String value) {
    notesController.text = value;
    update();
  }

  deleteNoteListData(int? noteId, int index) async {
    notesList.removeAt(index);

    if (noteId != null) {
      await DataBaseHelper.shared.deleteSingleNoteData(noteId);
    }
    update();
  }





}
