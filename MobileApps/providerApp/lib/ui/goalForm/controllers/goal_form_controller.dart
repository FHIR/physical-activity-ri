import 'dart:convert';

import 'package:banny_table/db_helper/box/goal_data.dart';
import 'package:banny_table/db_helper/box/notes_data.dart';
import 'package:banny_table/db_helper/database_helper.dart';
import 'package:banny_table/resources/syncing.dart';
import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/ui/goalForm/datamodel/goalDataModel.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../utils/debug.dart';
import '../../home/home/controllers/home_controllers.dart';
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
  TextEditingController descController = TextEditingController();
  TextEditingController targetController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  FocusNode targetFocus = FocusNode();
  FocusNode notesControllersFocus = FocusNode();

  String notesValue = "";
  QuillController notesController = QuillController.basic();


  var selectedDateFormat = DateTime.now();
  var selectedDateStr = "";
  GoalMeasure? selectedGoalMeasure;
  String selectedGoalMeasureHint = Constant.pleaseSelect;
  var editedGoalData = GoalSyncDataModel();
  var editedNoteTableData = NoteTableData();
  var arguments = Get.arguments;
  var isEdited = false;
  var isAdd = false;
  List<NotesData> notesList = [];
  List<NoteTableData> noteDatabaseList = [];

  @override
  void onInit() {
    if (arguments != null) {
      if (arguments[0] != null) {
        editedGoalData = arguments[0];
        isEdited = true;
        getNoteList(editedGoalData.notesList);
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

        if (editedGoalData.lifeCycleStatus != null && editedGoalData.lifeCycleStatus != "" ) {
          selectedLifeCycleStatus = editedGoalData.lifeCycleStatus ?? "";
          selectedStatusFix = editedGoalData.lifeCycleStatus ?? "";
          selectedLifeCycleStatusHint = editedGoalData.lifeCycleStatus ?? "";
        }

        if (editedGoalData.achievementStatus != null) {
          if(Utils.achievementStatusList.contains(editedGoalData.achievementStatus)){
            selectedAchievementStatus = editedGoalData.achievementStatus ?? "";
            selectedAchievementStatusHint = editedGoalData.achievementStatus ?? "";
          }else{
            // selectedAchievementStatus = Utils.achievementStatusList[0] ?? "";
          }
        }else{
          // selectedAchievementStatus = Utils.achievementStatusList[0];
        }
        if (editedGoalData.multipleGoals != null) {
          selectedMultipleGoalStatusHerder = editedGoalData.multipleGoals ?? "";
        }

        /*selectedGoalMeasure = GoalMeasure(code: editedGoalData.code ?? "", system: editedGoalData.system ?? "",
            goalValue: editedGoalData.multipleGoals ?? "", targetPlaceHolder:
            editedGoalData.multipleGoals ?? "");*/
        var index = Utils.multipleGoalsList.indexWhere((element) => element.code ==  editedGoalData.code &&
            element.system == editedGoalData.system
            && element.goalValue == editedGoalData.multipleGoals).toInt();
        if(index != -1) {
          selectedGoalMeasure = Utils.multipleGoalsList[index];
          selectedGoalMeasureHint = Utils.multipleGoalsList[index].goalValue;
        }else{
          // selectedGoalMeasure = Utils.multipleGoalsList[0];
        }
        editedGoalData.readOnly = false;
        update();
      } else {
        // selectedLifeCycleStatus = Utils.lifeCycleStatusList[0];
        // selectedAchievementStatus = Utils.achievementStatusList[0];
        selectedLifeCycleStatus = Constant.lifeCycleProposed;
        selectedStatusFix = Constant.lifeCycleProposed;
        selectedMultipleGoalStatusHerder = Utils.multipleGoalsListString[0];
        selectedMultipleGoalStatus = "";
        // selectedGoalMeasure = Utils.multipleGoalsList[0];
        // notesList.add(NotesData());
        editedGoalData.readOnly = false;

        // onChangeMultipleGoalStatus(selectedMultipleGoalStatusHerder);
      }
    } else {
      // selectedLifeCycleStatus = Utils.lifeCycleStatusList[0];
      // selectedAchievementStatus = Utils.achievementStatusList[0];
      selectedLifeCycleStatus = Constant.lifeCycleProposed;
      selectedStatusFix = Constant.lifeCycleProposed;
      selectedMultipleGoalStatusHerder = Utils.multipleGoalsListString[0];
      selectedMultipleGoalStatus = "";
      // selectedGoalMeasure = Utils.multipleGoalsList[0];
      // notesList.add(NotesData());
      editedGoalData.readOnly = false;
      // onChangeMultipleGoalStatus(selectedMultipleGoalStatusHerder);
    }

    super.onInit();
  }

/*  getNoteList() async {
    noteDatabaseList = Hive.box<NoteTableData>(Constant.tableNoteData)
        .values
        .toList()
        .where((element) => element.goalId == editedGoalData.key)
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
        data.goalId = editedGoalData.key;
        data.isCreatedNote = noteDatabaseList[i].isCreatedNote;
        notesList.add(data);
      }
      await Debug.printLog("getdNoteData");
    }
    update();
  }*/

  getNoteList(List<NoteTableData> noteList) async {

    if (noteList.isNotEmpty) {
      for (int i = 0; i < noteList.length; i++) {
        var data = NotesData();
        data.notes = noteList[i].notes;
        data.author = noteList[i].author;
        data.readOnly = noteList[i].readOnly;
        data.isDelete = noteList[i].isDelete;
        data.date = noteList[i].date;
        data.noteId = noteList[i].key;
        data.isCreatedNote = noteList[i].isCreatedNote;
        notesList.add(data);
      }
    }
    update();
  }


  editNoteDataController(String value,bool isUpdate) {
    notesValue = value;
    if(isUpdate){
        List<dynamic> jsonList = jsonDecode(value);
        Delta delta = Delta.fromJson(jsonList);
        notesController = QuillController(
          document: Document.fromDelta(delta),
          selection: TextSelection.collapsed(offset: 0),
        );
        Debug.printLog("insertHtml...$value");
    }
    update();
  }

  addNotesData(String text, bool isEditNote, int index) async {
    if (isEditNote) {
      notesList[index].notes = getDataFromController();
    } else {
      notesList.add(NotesData(
          isDelete: false,
          author: Utils.getFullName(),
          notes: getDataFromController(),
          date: DateTime.now(),
          isCreatedNote: true));
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
    if(selectedGoalMeasure != null) {
      if (targetController.text.isNotEmpty) {
        // arguments[1] ? Get.back() : Get.offAllNamed(AppRoutes.bottomNavigation);
        // var notes = notesController.text;
        // var desc = descController.text;
    var desc;
    if (selectedGoalMeasure != null) {
      desc = "${selectedGoalMeasure!.goalValue} - ${targetController.text}";
    }
    var target = targetController.text;
        DateTime dueDate = selectedDateFormat;
        var lifeCycleStatus = selectedLifeCycleStatus;
        var achievementStatus = selectedAchievementStatus;
        var multipleGoalStatus = selectedMultipleGoalStatusHerder;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Utils.showDialogForProgress(
              Get.context!, Constant.txtPleaseWait, Constant.dataSyncingGoal);
        });
        if (isEdited) {
          editedGoalData.code = selectedGoalMeasure!.code;
          editedGoalData.system = selectedGoalMeasure!.system;
          editedGoalData.lifeCycleStatus = selectedLifeCycleStatus;
          editedGoalData.achievementStatus = selectedAchievementStatus;
          editedGoalData.providerId = editedGoalData.providerId;
          editedGoalData.providerName = editedGoalData.providerName;
          editedGoalData.dueDate = selectedDateFormat;
          editedGoalData.target = target;
          editedGoalData.description = desc;
          // dataModel.notesList = editedToDoData.noteList;
          editedGoalData.notesList.clear();
          for (int i = 0; i < notesList.length; i++) {
            var noteTableData = NoteTableData();
            noteTableData.notes = notesList[i].notes;
            noteTableData.author = notesList[i].author;
            noteTableData.readOnly = false;
            noteTableData.date = notesList[i].date;
            noteTableData.isCreatedNote = notesList[i].isCreatedNote;
            editedGoalData.notesList!.add(noteTableData);
          }
          // editedGoalData.notesList.addAll(dataModel.notesList ?? []);
          // Get.back(result:editedGoalData);
          // editedGoalData.notesList = note;
          // editedGoalData.notesList = stringNotesList;
          editedGoalData.updatedDate = DateTime.now();
          editedGoalData.multipleGoals = selectedMultipleGoalStatusHerder;
          editedGoalData.isSync = false;
          // await DataBaseHelper.shared.updateGoalData(editedGoalData);

          List<GoalSyncDataModel> allSyncingDataList = [editedGoalData];
          String goalId = "";
          if(Utils.getPrimaryServerData()!.url != ""){
            goalId = await Syncing.callApiForGoalSyncData(allSyncingDataList);
            Debug.printLog("Goal id ......$goalId");
          }
          Utils.showToast(Get.context!, "Goal update successfully");
        }
        else {
          var data = GoalSyncDataModel();

          data.description = desc;
          data.target = target;
          data.dueDate = dueDate;
          var nowDate = DateTime.now();
          data.createdDate =
              DateTime(nowDate.year, nowDate.month, nowDate.day - 10);
          Debug.printLog("created date....${data.createdDate}");
          if(selectedGoalMeasure != null){
            data.code = selectedGoalMeasure!.code;
            data.system = selectedGoalMeasure!.system;
            data.actualDescription = selectedGoalMeasure!.actualDescription;
          }
          data.lifeCycleStatus = lifeCycleStatus;
          data.achievementStatus = achievementStatus;
          data.multipleGoals = multipleGoalStatus;
          if (Utils.getPrimaryServerData() != null) {
            data.qrUrl = Utils.getPrimaryServerData()!.url;
            data.token = Utils.getPrimaryServerData()!.authToken;
            data.clientId = Utils.getPrimaryServerData()!.clientId;
            data.patientId = Utils.getPrimaryServerData()!.patientId;
            data.providerId = Utils.getPrimaryServerData()!.providerId;
            data.providerName = Utils.getPrimaryServerData()!.providerFName;
            data.patientName = "${Utils.getPrimaryServerData()!.patientFName}${Utils.getPrimaryServerData()!.patientLName}";
          }

          for (int i = 0; i < notesList.length; i++) {
            var noteTableData = NoteTableData();
            noteTableData.notes = notesList[i].notes;
            noteTableData.author = notesList[i].author;
            noteTableData.readOnly = false;
            noteTableData.date = notesList[i].date;
            noteTableData.isCreatedNote = notesList[i].isCreatedNote;
            data.notesList!.add(noteTableData);
          }

          data.isSync = false;
          List<GoalSyncDataModel> allSyncingDataList = [data];
          if(Utils.getPrimaryServerData()!.url != ""){
            goalId = await Syncing.callApiForGoalSyncData(allSyncingDataList);
            data.objectId = goalId;
            if(goalId != "null" && goalId != "" && goalId != "NULL" && goalId != "Null") {
              HomeControllers homeControllers = Get.find();
              homeControllers.goalDataList.add(data);
              homeControllers.goalDataListLocal.add(data);
              homeControllers.updateMethod();
            }
          }
          if(goalId != "null" && goalId != "" && goalId != "NULL" && goalId != "Null") {
            Utils.showToast(Get.context!, "Goal added successfully");
          }
        }
        Get.back();
        if (isEdited) {
          Get.back(result: editedGoalData);
        }
        else{
          if(goalId == "null" || goalId == "" || goalId == "NULL" || goalId == "Null"){
            await Utils.showErrorDialog(Get.context!,Constant.txtError,Constant.txtErrorGoalNotCreated);
          }else{
            Get.back();
          }
        }

        /*final SharedPreferences pref = await SharedPreferences.getInstance();
        String? selectedSyncing =
            pref.getString(Constant.keySyncing) ?? Constant.realTime;
        String url = Preference.shared.getString(Preference.qrUrlData) ?? "";
        if (url != "") {
          ///Day per week
          await Syncing.goalSyncingData(true, []);
        }
        HomeControllers graphController = Get.find();
        graphController.callAllAPI(false);*/
      } else {
        if(targetController.text.isEmpty){
          Utils.showToast(Get.context!, "Please set your target");
        }else{
          Utils.showToast(Get.context!, "Please enter your description");
        }
      }
    }else{
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
    selectedMultipleGoalStatusHerder = data.goalValue;
    selectedGoalMeasureHint = data.goalValue;
    // selectedMultipleGoalStatusHerder = value;
    for (int i = 0; i < Utils.multipleGoalsList.length; i++) {
      if (data.goalValue == Utils.multipleGoalsList[i].goalValue) {
        selectedMultipleGoalStatus = Utils.multipleGoalsList[i].targetPlaceHolder;
        // selectedMultipleGoalStatusHerder =va;
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
    }
    if(selectedGoalMeasure != null) {
      if (targetController.text.isNotEmpty) {
    await checkValidationForToken();
      } else {
        if(targetController.text.isEmpty){
          Utils.showToast(Get.context!, "Please set your target");
        }else{
          Utils.showToast(Get.context!, "Please enter your description");
        }
      }
    }else{
      Utils.showToast(Get.context!, "Please set your Goal");
    }

    // await insertUpdateData();
  }

  String getDataFromController(){
    final delta = notesController.document.toDelta();
    Debug.printLog('Current HTML content: $notesValue.......  ${delta.toJson()}');
    notesValue = jsonEncode(notesController.document.toDelta().toList());
    return notesValue;
  }
}
