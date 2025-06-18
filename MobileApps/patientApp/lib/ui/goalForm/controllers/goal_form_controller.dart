import 'dart:convert';

import 'package:banny_table/db_helper/box/goal_data.dart';
import 'package:banny_table/db_helper/box/notes_data.dart';
import 'package:banny_table/db_helper/database_helper.dart';
import 'package:banny_table/resources/syncing.dart';
import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/ui/goalForm/datamodel/goalDataModel.dart';
import 'package:banny_table/ui/goalList/controllers/goal_list_controller.dart';
import 'package:banny_table/ui/mixed/controllers/mixed_controller.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/selectPrimaryServer/datamodel/serverModelJson.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:fhir/r4.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

import '../../../fhir_auth/r4.dart';
import '../../../providers/api.dart';
import '../../../utils/color.dart';
import '../../../utils/debug.dart';
import '../../../utils/font_style.dart';
import '../../../utils/sizer_utils.dart';
import '../datamodel/goalTypeData.dart';
import '../datamodel/notesData.dart';

class GoalFormController extends GetxController {
  var selectedLifeCycleStatus = "";
  var selectedStatusFix = "";
  var selectedLifeCycleStatusHint = Constant.pleaseSelect;
  var selectedMultipleGoalStatus = "";
  var selectedMultipleGoalStatusHerder = "";
  var selectedAchievementStatus = "";
  var selectedAchievementStatusHint = Constant.pleaseSelect;
  // TextEditingController notesController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController targetController = TextEditingController();
  String notesValue = "";
  // HtmlEditorController notesController = HtmlEditorController(
  //     processInputHtml: false,
  //     processOutputHtml: false,
  //     processNewLineAsBr: false);

  TextEditingController dueDateController = TextEditingController();
  FocusNode targetFocus = FocusNode();
  FocusNode notesControllersFocus = FocusNode();

  var selectedDateFormat = DateTime.now();
  var selectedDateStr = "";
  GoalMeasure? selectedGoalMeasure;
  var selectedGoalMeasureHint = Constant.pleaseSelect;

  // var editedGoalData = GoalTableData();
  var editedGoalData;
  var editedNoteTableData = NoteTableData();
  var arguments = Get.arguments;
  var isEdited = false;
  var isAdd = false;
  var dataEditable = true;
  String directionScreenName = "";
  List notesList = [];
  // List<NoteTableData> noteDatabaseList = [];
  List<ServerModelJson> serverModelList = [];
  var isEditNoteStatus = false;
  QuillController notesController = QuillController.basic();

  @override
  void onInit() {
    if(Utils.getPrimaryServerData() != null){
      editedGoalData = GoalSyncDataModel();
    }else{
      editedGoalData = GoalTableData();
    }

    if (arguments != null) {
      if(arguments[2] != null){
        directionScreenName = arguments[2];
      }
      if (arguments[0] != null) {
        editedGoalData = arguments[0];
        isEdited = true;
        if(Utils.getPrimaryServerData() != null){
          getNoteList(editedGoalData.notesList ?? []);
        }else{
          getNoteList([]);
        }
        dataEditable = editedGoalData.isEditable;
        if(editedGoalData.expressedBy != null && editedGoalData.expressedBy != ""){
          isEditNoteStatus = !editedGoalData.expressedBy!.contains("Practitioner");
        }

        if (editedGoalData.description != null) {
          descController.text = editedGoalData.description ?? "";
        }

        if (editedGoalData.target != null) {
          targetController.text = editedGoalData.target ?? "";
        }

        if (editedGoalData.dueDate != null) {
          selectedDateStr = DateFormat(Constant.commonDateFormatDdMmYyyy)
              .format(editedGoalData.dueDate!);
          dueDateController.text = selectedDateStr.toString();
          selectedDateFormat = editedGoalData.dueDate!;
        }

        if (editedGoalData.lifeCycleStatus != null && editedGoalData.lifeCycleStatus != "" && editedGoalData.lifeCycleStatus != "Null") {
          selectedLifeCycleStatus = editedGoalData.lifeCycleStatus ?? "";
          selectedStatusFix = editedGoalData.lifeCycleStatus ?? "";
          selectedLifeCycleStatusHint = editedGoalData.lifeCycleStatus ?? "";
        }

        if (editedGoalData.achievementStatus != null && editedGoalData.achievementStatus != "" && editedGoalData.achievementStatus != "null") {
          if(Utils.achievementStatusList.contains(editedGoalData.achievementStatus)){
            selectedAchievementStatus = editedGoalData.achievementStatus ?? "";
            selectedAchievementStatusHint = editedGoalData.achievementStatus ?? "";
          }else{
            // selectedAchievementStatus = Utils.achievementStatusList[0] ?? "";
          }
        } else {
          // selectedAchievementStatus = Utils.achievementStatusList[0];
        }
        if (editedGoalData.multipleGoals != null) {
          selectedMultipleGoalStatusHerder = editedGoalData.multipleGoals ?? "";
        }
        var index = Utils.multipleGoalsList
            .indexWhere((element) =>
                element.code == editedGoalData.code &&
                element.system == editedGoalData.system &&
                element.goalValue == editedGoalData.multipleGoals)
            .toInt();
        if (index != -1) {
          selectedGoalMeasure = Utils.multipleGoalsList[index];
          selectedGoalMeasureHint = Utils.multipleGoalsList[index].goalValue;
        } else {
          // selectedGoalMeasure = Utils.multipleGoalsList[0];
        }
        editedGoalData.readOnly = false;
        update();
      } else {
        selectedLifeCycleStatus = Constant.lifeCycleProposed;
        selectedStatusFix = Constant.lifeCycleProposed;
        // selectedAchievementStatus = Utils.achievementStatusList[0];
        selectedMultipleGoalStatusHerder = Utils.multipleGoalsListString[0];
        selectedMultipleGoalStatus = "";
            // Utils.multipleGoalsList[0].targetPlaceHolder;
        // selectedGoalMeasure = Utils.multipleGoalsList[0];
        editedGoalData.readOnly = false;
      }
    } else {
      // selectedLifeCycleStatus = Utils.lifeCycleStatusList[0];
      // selectedAchievementStatus = Utils.achievementStatusList[0];
      selectedMultipleGoalStatusHerder = Utils.multipleGoalsListString[0];
      selectedMultipleGoalStatus ="";/* Utils.multipleGoalsList[0].targetPlaceHolder;*/
      // selectedGoalMeasure = Utils.multipleGoalsList[0];
      editedGoalData.readOnly = false;
    }
    getServerListData();
    super.onInit();
  }

  getServerListData() {
    serverModelList =
        // Preference.shared.getServerList(Preference.serverUrlList) ?? [];
        Preference.shared.getServerList(Preference.serverUrlAllListed) ?? [];
    serverModelList =
        serverModelList.where((element) => element.isPrimary).toList();
    update();
  }

  getNoteList(List<NoteTableData> notesListEdited) async {
    notesList = [];
    if(Utils.getPrimaryServerData() != null){
      for (int i = 0; i < notesListEdited.length; i++) {
        var data = notesListEdited[i];
        var notesData = NotesData();
        notesData.notes = data.notes;
        notesData.author = data.author;
        notesData.readOnly = data.readOnly;
        notesData.isDelete = data.isDelete;
        notesData.date = data.date;
        notesData.noteId = data.key;
        notesData.isCreatedNote = data.isCreatedNote;
        notesList.add(notesData);

      }
    }else{
       notesListEdited = Hive.box<NoteTableData>(Constant.tableNoteData)
        .values
        .toList()
        .where((element) => element.goalId == editedGoalData.key)
        .toList();

    if (notesListEdited.isNotEmpty) {
      for (int i = 0; i < notesListEdited.length; i++) {
        var data = NotesData();
        data.notes = notesListEdited[i].notes;
        data.author = notesListEdited[i].author;
        data.readOnly = notesListEdited[i].readOnly;
        data.isDelete = notesListEdited[i].isDelete;
        data.date = notesListEdited[i].date;
        data.noteId = notesListEdited[i].key;
        data.goalId = editedGoalData.key;
        data.isCreatedNote = notesListEdited[i].isCreatedNote;
        notesList.add(data);
      }
      await Debug.printLog("getdNoteData");
    }
    }

    update();
  }

  editNoteDataController(String value,bool isUpdate) {
    notesValue = value;
    if(isUpdate){
      try {
        List<dynamic> jsonList = jsonDecode(value);
        Delta delta = Delta.fromJson(jsonList);
        notesController = QuillController(
          document: Document.fromDelta(delta),
          selection: TextSelection.collapsed(offset: 0),
        );
        update();
      } catch (e) {
        Debug.printLog(e.toString());
      }
      Debug.printLog("insertHtml...$value");
    }
    update();
  }

  addNotesData(String text, bool isEditNote, int index) async {
    if (isEditNote) {
      notesList[index].notes = text;
    } else {
      if(Utils.getPrimaryServerData() != null){
        notesList.add(NotesData(
            isDelete: false,
            author: Utils.getFullName(),
            notes: text,
            date: DateTime.now(),
            isCreatedNote: true));

      }else{
        notesList.add(NoteTableData(
            author: Utils.getFullName(),
            notes: text,
            date: DateTime.now(),
        ));

      }
    }
    notesController.clear();
    Get.back();
    update();
  }

  void onSelectionChangedDatePicker(DateRangePickerSelectionChangedArgs args) {
    selectedDateFormat = args.value;
    selectedDateStr = DateFormat(Constant.commonDateFormatDdMmYyyy)
        .format(selectedDateFormat);
    dueDateController.text = selectedDateStr;
    update();
  }

  deleteNoteListData(int? noteId, int index) async {
    notesList.removeAt(index);
    if (noteId != null) {
      await DataBaseHelper.shared.deleteSingleNoteData(noteId);
    }
    update();
  }

  insertUpdateData() async {
    String goalId = "";

    ///This Is // use on The Goal Type is mandatory To use
    if (selectedMultipleGoalStatusHerder.isNotEmpty) {
      if (targetController.text.isNotEmpty) {
        var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
        var primaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
        if (primaryServerData.isNotEmpty) {
          var primaryData = primaryServerData[0];
          if (primaryData.isSecure &&
              Utils.isExpiredToken(
                  primaryData.lastLoggedTime, primaryData.expireTime)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: Get.context!,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title:  const Text(Constant.txtExpireTitle),
                    content:  const Text(Constant.txtExpireDesc),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Get.back();
                          Utils.callSecureServerAPI(primaryData.url,
                              primaryData.clientId,
                              primaryData.title);
                        },
                        child: const Text("Log in"),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text("Cancel"),
                      ),
                    ],
                  );
                },
              );
            });
            return;
          }
        }

        // arguments[1] ? Get.back() : Get.offAllNamed(AppRoutes.bottomNavigation);
        // var notes = notesController.text;
        var notes = notesValue;
        var desc = "${selectedGoalMeasure!.goalValue} - ${targetController.text}";
        var target = targetController.text;
        DateTime dueDate = selectedDateFormat;
        var lifeCycleStatus = selectedLifeCycleStatus;
        var achievementStatus = selectedAchievementStatus;
        var multipleGoalStatus = selectedMultipleGoalStatusHerder;
        if(Utils.getPrimaryServerData() != null){
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Utils.showDialogForProgress(
                Get.context!, Constant.txtPleaseWait, Constant.dataSyncingGoal);
          });
        }
        if (isEdited) {
          editedGoalData.code = selectedGoalMeasure!.code;
          editedGoalData.system = selectedGoalMeasure!.system;
          editedGoalData.lifeCycleStatus = selectedLifeCycleStatus;
          editedGoalData.achievementStatus = selectedAchievementStatus;
          editedGoalData.dueDate = selectedDateFormat;
          editedGoalData.target = target;
          editedGoalData.description = desc;
          editedGoalData.notes = notes;
          editedGoalData.updatedDate = DateTime.now();
          editedGoalData.multipleGoals = selectedMultipleGoalStatusHerder;
          editedGoalData.isSync = false;
          if(Utils.getPrimaryServerData() != null){
            editedGoalData.notesList!.clear();
            for (int i = 0; i < notesList.length; i++) {
              var noteTableData = NoteTableData();
              noteTableData.notes = notesList[i].notes;
              noteTableData.author = notesList[i].author;
              noteTableData.readOnly = false;
              noteTableData.date = notesList[i].date;
              noteTableData.isCreatedNote = notesList[i].isCreatedNote;
              editedGoalData.notesList!.add(noteTableData);
            }
          }

          if(Utils.getPrimaryServerData() != null && Utils.getPrimaryServerData()!.url != ""){
            List<GoalSyncDataModel> allSyncingDataList = [editedGoalData];
            await Syncing.callApiForGoalSyncData(allSyncingDataList);
            Get.back();
          }
          else{
            await DataBaseHelper.shared.updateGoalData(editedGoalData);
            var noteDataList =
              Hive.box<NoteTableData>(Constant.tableNoteData).values.toList();
          if (noteDataList.isNotEmpty && notesList.isNotEmpty) {
            for (int i = 0; i < notesList.length; i++) {
              if (notesList[i].goalId != null) {
                NoteTableData noteData = await DataBaseHelper.shared
                    .getNoteDataID(notesList[i].noteId);
                noteData.notes = notesList[i].notes;
                noteData.author = notesList[i].author;
                noteData.date = notesList[i].date;
                noteData.isDelete = true;
                noteData.goalId = editedGoalData.key;
                noteData.isCreatedNote = notesList[i].isCreatedNote;
                await DataBaseHelper.shared.updateNoteData(noteData);
              } else {
                var noteTableData = NoteTableData();
                noteTableData.notes = notesList[i].notes;
                noteTableData.author = notesList[i].author;
                noteTableData.readOnly = false;
                noteTableData.date = notesList[i].date;
                noteTableData.isDelete = true;
                noteTableData.goalId = editedGoalData.key;
                noteTableData.isCreatedNote = notesList[i].isCreatedNote;
                await DataBaseHelper.shared.insertNoteData(noteTableData);
              }
            }
          }
          else {
            for (int i = 0; i < notesList.length; i++) {
              var noteTableData = NoteTableData();

              noteTableData.notes = notesList[i].notes;
              noteTableData.author = notesList[i].author;
              noteTableData.readOnly = false;
              noteTableData.date = notesList[i].date;
              noteTableData.isDelete = true;
              noteTableData.goalId = editedGoalData.key;
              noteTableData.isCreatedNote = true;
              await DataBaseHelper.shared.insertNoteData(noteTableData);
            }
          }
          }
          // Get.back();
          Utils.showToast(Get.context!, "Goal update successfully");
        }
        else {
          // var data = GoalTableData();
          var data = GoalSyncDataModel();

          data.description = desc;
          data.target = target;
          data.dueDate = dueDate;
          var nowDate = DateTime.now();
          data.createdDate =
              DateTime(nowDate.year, nowDate.month, nowDate.day - 10);
          Debug.printLog("created date....${data.createdDate}");
          data.code = selectedGoalMeasure!.code;
          data.system = selectedGoalMeasure!.system;
          data.actualDescription = selectedGoalMeasure!.actualDescription;
          data.lifeCycleStatus = lifeCycleStatus;
          data.achievementStatus = achievementStatus;
          data.multipleGoals = multipleGoalStatus;
          if (Utils.getPrimaryServerData() != null) {
            data.qrUrl = Utils.getPrimaryServerData()!.url;
            data.token = Utils.getPrimaryServerData()!.authToken;
            data.clientId = Utils.getPrimaryServerData()!.clientId;
            data.patientId = Utils.getPrimaryServerData()!.patientId;
            data.patientName =
            "${Utils.getPrimaryServerData()!.patientFName}${Utils
                .getPrimaryServerData()!.patientLName}";
          }
          /*else {
            var dataHive = GoalTableData();
            dataHive.description = desc;
            dataHive.target = target;
            dataHive.dueDate = dueDate;
            var nowDate = DateTime.now();
            dataHive.createdDate =
                DateTime(nowDate.year, nowDate.month, nowDate.day - 10);
            Debug.printLog("created date....${dataHive.createdDate}");
            dataHive.code = selectedGoalMeasure!.code;
            dataHive.system = selectedGoalMeasure!.system;
            dataHive.actualDescription = selectedGoalMeasure!.actualDescription;
            dataHive.lifeCycleStatus = lifeCycleStatus;
            dataHive.achievementStatus = achievementStatus;
            dataHive.multipleGoals = multipleGoalStatus;
            var insertId = await DataBaseHelper.shared.insertGoalData(dataHive);
            for (int i = 0; i < notesList.length; i++) {
              var noteTableData = NoteTableData();

              noteTableData.notes = notesList[i].notes;
              noteTableData.author = notesList[i].author;
              noteTableData.readOnly = false;
              noteTableData.date =
                  DateTime(nowDate.year, nowDate.month, nowDate.day);
              noteTableData.isDelete = true;
              noteTableData.goalId = insertId;
              noteTableData.isCreatedNote = notesList[i].isCreatedNote;
              await DataBaseHelper.shared.insertNoteData(noteTableData);
              Get.back();
            }
          }*/
          data.isSync = false;


          for (int i = 0; i < notesList.length; i++) {
            var noteTableData = NoteTableData();
            noteTableData.notes = notesList[i].notes;
            noteTableData.author = notesList[i].author;
            noteTableData.readOnly = false;
            noteTableData.date = notesList[i].date;
            noteTableData.isCreatedNote = notesList[i].isCreatedNote;
            data.notesList!.add(noteTableData);
          }
          List<GoalSyncDataModel> allSyncingDataList = [data];
          if (Utils.getPrimaryServerData() != null &&  Utils.getPrimaryServerData()!.url != "") {
            goalId = await Syncing.callApiForGoalSyncData(allSyncingDataList);
            data.objectId = goalId;
            if (goalId != "null" && goalId != "" && goalId != "NULL" &&
                goalId != "Null") {
              if (directionScreenName == Constant.dataGoalList) {
                GoalListController goalListController = Get.find();
                goalListController.goalDataList.add(data);
                goalListController.filterGoalDataList.add(data);
                goalListController.updateMethod();
              }
              if (directionScreenName == Constant.dataGoalList ||
                  directionScreenName == Constant.dataMixScreen) {
                MixedController mixedController = Get.find();
                if(mixedController.goalDataList.where((element) => element.objectId == goalId).toList().isEmpty){
                  mixedController.goalDataList.add(data);
                }
                mixedController.updateMethod();
              }
            }
          }
          else {
            var dataHive = GoalTableData();
            dataHive.description = desc;
            dataHive.target = target;
            dataHive.dueDate = dueDate;
            var nowDate = DateTime.now();
            dataHive.createdDate =
                DateTime(nowDate.year, nowDate.month, nowDate.day - 10);
            Debug.printLog("created date....${dataHive.createdDate}");
            dataHive.code = selectedGoalMeasure!.code;
            dataHive.system = selectedGoalMeasure!.system;
            dataHive.actualDescription = selectedGoalMeasure!.actualDescription;
            dataHive.lifeCycleStatus = lifeCycleStatus;
            dataHive.achievementStatus = achievementStatus;
            dataHive.multipleGoals = multipleGoalStatus;
            var insertId = await DataBaseHelper.shared.insertGoalData(dataHive);
            for (int i = 0; i < notesList.length; i++) {
              var noteTableData = NoteTableData();
              noteTableData.notes = notesList[i].notes;
              noteTableData.author = notesList[i].author;
              noteTableData.readOnly = false;
              noteTableData.date =
                  DateTime(nowDate.year, nowDate.month, nowDate.day);
              noteTableData.isDelete = true;
              noteTableData.goalId = insertId;
              noteTableData.isCreatedNote = notesList[i].isCreatedNote;
              await DataBaseHelper.shared.insertNoteData(noteTableData);
            }
            Utils.showToast(Get.context!, "Goal added successfully");
          }

          /*if (Utils.getPrimaryServerData()!.url != "") {
          await Syncing.goalSyncingData(true, []);
        }*/

          /*Get.back();
          if (isEdited) {
            Get.back(result: editedGoalData);
          } else {
            if (Utils.getPrimaryServerData() != null) {
              if (goalId == "null" || goalId == "" || goalId == "NULL" ||
                  goalId == "Null") {
                await Utils.showErrorDialog(Get.context!, Constant.txtError,
                    Constant.txtErrorGoalNotCreated);
              } else {
                Get.back();
              }
            } else {
              Get.back();
            }
          }*/
        }

        if (isEdited) {
          Get.back(result: editedGoalData);
        } else {
          if (Utils.getPrimaryServerData() != null) {
            Get.back();
            if (goalId == "null" || goalId == "" || goalId == "NULL" ||
                goalId == "Null") {
              await Utils.showErrorDialog(Get.context!, Constant.txtError,
                  Constant.txtErrorGoalNotCreated);
            } else {
              Get.back();
            }
          } else {
            Get.back();
          }
        }
      } else {
        if (targetController.text.isEmpty) {
          Utils.showToast(Get.context!, "Please set your target");
        }
      }
    } else {
      Utils.showToast(Get.context!, "Please set your Goal");
    }
  }

  void onChangeLifeCycleStatus(String value) {
    selectedLifeCycleStatus = value;
    selectedLifeCycleStatusHint = value;
    update();
  }

  void onChangeMultipleGoalStatus(dynamic value) {
    var data = value as GoalMeasure;
    selectedGoalMeasure = data;
    selectedGoalMeasureHint = data.goalValue;
    selectedMultipleGoalStatusHerder = data.goalValue;
    for (int i = 0; i < Utils.multipleGoalsList.length; i++) {
      if (data.goalValue == Utils.multipleGoalsList[i].goalValue) {
        selectedMultipleGoalStatus =
            Utils.multipleGoalsList[i].targetPlaceHolder;
      }
    }
    update();
  }

  void onChangeAchievementStatus(String value) {
    selectedAchievementStatus = value;
    selectedAchievementStatusHint = value;
    update();
  }

  checkValidationForToken() async {
    await Utils.isExpireTokenAPICall(Constant.screenTypeHome,(value) async {
      if(!value){
        await insertUpdateData();
      }
    }).then((value) async {
      if(!value){
        await insertUpdateData();
      }
    });
  }

  insertSaveAsDraft() async {
    selectedLifeCycleStatus = Constant.lifeCycleProposed;
    // await insertUpdateData();
    await checkValidationForToken();
    update();
  }

  insertForSign() async {
    if(selectedLifeCycleStatus == Constant.lifeCycleProposed) {
      selectedLifeCycleStatus = Constant.lifeCycleActive;
      await checkValidationForToken();
    }else{
        await checkValidationForToken();
    }
    // await insertUpdateData();
  }

  String getDataFromController(){
    final delta = notesController.document.toDelta();
    Debug.printLog('Current HTML content: $notesValue.......  ${delta.toJson()}');
    notesValue = jsonEncode(notesController.document.toDelta().toList());
    return notesValue;
  }

  /*String getHtmlFromDelta(String jsonData){
    List<Map<String, dynamic>> parsedList = List<Map<String, dynamic>>.from(jsonDecode(jsonData));
    final converter = QuillDeltaToHtmlConverter(parsedList);
    final html = converter.convert();
    Debug.printLog('getHtmlFromDelta: $html.......$converter');
    return html;
  }*/

}
