
import 'dart:convert';

import 'package:banny_table/db_helper/box/notes_data.dart';
import 'package:banny_table/db_helper/box/to_do_form_data.dart';
import 'package:banny_table/db_helper/database_helper.dart';
import 'package:banny_table/resources/syncing.dart';
import 'package:banny_table/ui/goalForm/datamodel/notesData.dart';
import 'package:banny_table/ui/home/activityLog/controllers/home_controllers.dart';
import 'package:banny_table/ui/referralForm/datamodel/performerData.dart';
import 'package:banny_table/ui/toDoList/controllers/to_do_list_controller.dart';
import 'package:banny_table/ui/toDoList/dataModel/codeModel.dart';
import 'package:banny_table/ui/toDoList/dataModel/to_do_sync_data_model.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:fhir/r4.dart';
import 'package:fhir/r4/special_types/special_types.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:html_editor_enhanced/html_editor.dart';

import '../../../fhir_auth/r4.dart';
import '../../../providers/api.dart';
import '../../../utils/color.dart';
import '../../../utils/font_style.dart';
import '../../../utils/sizer_utils.dart';
import '../../toDoList/dataModel/toDoDataListModel.dart';


class ToDoController extends GetxController {
  // var selectedVerificationStatus = "";
  var status = "";
  var selectedDisplay = "";
  var selectedCode = "";
  String selectedPriority = "";
  TextEditingController addNewCodeController = TextEditingController();
  FocusNode addNewCodeFocus = FocusNode();
  TextEditingController statusReason = TextEditingController();
  TextEditingController generalInfoResponseReason = TextEditingController();
  TextEditingController chosenContactController = TextEditingController();
  TextEditingController businessStatus = TextEditingController();
  var editedToDoData = ToDoDataListModel();
  var arguments = Get.arguments;
  var isEdited = false;
  FocusNode statusReasonFocus = FocusNode();
  FocusNode generalInfoResponseReasonFocus = FocusNode();
  FocusNode chosenContactFocus = FocusNode();

  // TextEditingController notesController = TextEditingController();
  FocusNode notesControllersFocus = FocusNode();
  List<NotesData> notesList = [];

  PerformerData selectedPerformer = PerformerData();

  var makeContactDetalisCodeHint = "Please Enter";
  FocusNode makeContactDetalisCodeFocus = FocusNode();
  TextEditingController makeContactDetalisCode = TextEditingController();

  var generalInformationDetalisCodeHint = "Please Enter";
  FocusNode generalInformationDetalisCodeFocus = FocusNode();
  TextEditingController generalInformationDetalisCode = TextEditingController();

  var reviewMaterialHintURL = "Please Enter";
  FocusNode reviewMaterialFocusURL = FocusNode();
  TextEditingController reviewMaterialControllerURL = TextEditingController();

  var reviewMaterialHintTitle = "Please Enter";
  FocusNode reviewMaterialFocusTitle = FocusNode();
  TextEditingController reviewMaterialControllerTitle = TextEditingController();

  TextEditingController searchNameControllers = TextEditingController();
  FocusNode searchNameFocus = FocusNode();
  String notesValue = "";
  QuillController notesController = QuillController.basic();


  @override
  void onInit() {
    if (arguments != null) {
      if (arguments[0] != null) {
        editedToDoData = arguments[0];
        isEdited = true;
        getNoteList(editedToDoData.noteList);
        if (editedToDoData.status != null) {
          status = editedToDoData.status ?? "";
        }
        if (editedToDoData.statusReason != null) {
          statusReason.text = editedToDoData.statusReason ?? "";
        }
        if (editedToDoData.businessStatus != null) {
          businessStatus.text = editedToDoData.businessStatus ?? "";
        }
        if (editedToDoData.chosenContactText != null) {
          chosenContactController.text = editedToDoData.chosenContactText ?? "";
        }
        if (editedToDoData.generalResponseText != null) {
          generalInfoResponseReason.text = editedToDoData.generalResponseText!;
        }
        if(editedToDoData.performerId != "") {
          selectedPerformer.performerId = editedToDoData.performerId;
          selectedPerformer.performerName = editedToDoData.performerName;
        }
        if (editedToDoData.makeContactDescription != "") {
          makeContactDetalisCode.text = editedToDoData.makeContactDescription ?? "";
        }
        if (editedToDoData.reviewMaterialURL != "") {
          reviewMaterialControllerURL.text = editedToDoData.reviewMaterialURL ?? "";
        }
        if (editedToDoData.reviewMaterialTitle != "") {
          reviewMaterialControllerTitle.text = editedToDoData.reviewMaterialTitle ?? "";
        }
        if (editedToDoData.generalDescription != "") {
          generalInformationDetalisCode.text = editedToDoData.generalDescription ?? "";
        }

        if(editedToDoData.priority != null) {
          selectedPriority = editedToDoData.priority.toString();
        } if(editedToDoData.display != null) {
          selectedDisplay = editedToDoData.display.toString();
          selectedCode = editedToDoData.code.toString();
          Debug.printLog("..selectedCode.....${selectedCode}");
          if(Utils.codeTodoList.where((element) => element.display != selectedDisplay).toList().isEmpty){
            Utils.codeTodoList.add(CodeToDoModel(display: selectedDisplay));
          }
        }
      } else {
        status = Utils.todoStatusList[0];
        selectedPriority = Utils.priorityList[0];
        selectedDisplay = Utils.codeTodoList[0].display;
        selectedCode = Utils.codeTodoList[0].code ?? "";

      }
    } else {
      status = Utils.todoStatusList[0];
      selectedPriority = Utils.priorityList[0];
      selectedDisplay = Utils.codeTodoList[0].display;
      selectedCode = Utils.codeTodoList[0].code ?? "";

    }
    super.onInit();
  }

  bool isGeneralInfo(){
    return selectedCode == Constant.toDoCodeGeneralInfo;
  }

  bool isChosenContact(){
    return selectedCode == Constant.toDoCodeMakeContact;
  }

  bool isReviewContact(){
    return selectedCode == Constant.toDoCodeReviewMaterial;
  }

  bool isManualTask(){
    return selectedCode == Constant.rxCode;
  }


  updatePatientTask() async {
    var statusReasonText = statusReason.text;
    var businessStatusText = businessStatus.text;
    var generalInfoText = generalInfoResponseReason.text;
    var chosenContact = chosenContactController.text;
    var dataModel = TaskSyncDataModel();
    var nowDateTime = DateTime.now();
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

    // if (isEdited) {
      editedToDoData.status = status;
      editedToDoData.statusReason = statusReasonText;
      editedToDoData.objectId = editedToDoData.objectId;
      editedToDoData.patientId = editedToDoData.patientId;
      editedToDoData.priority = selectedPriority;
      editedToDoData.display = selectedDisplay;
      editedToDoData.code = selectedCode;
      editedToDoData.isSync = false;
      editedToDoData.tag= "";

      editedToDoData.businessStatus = businessStatusText;
      editedToDoData.generalResponseText = generalInfoText;
      editedToDoData.chosenContactText = chosenContact;


      dataModel.chosenContactText = chosenContact;
      dataModel.generalResponseText = generalInfoText;
      dataModel.status = status;
      dataModel.statusReason = statusReasonText;
      // dataModel.businessStatusReason = businessStatusText;
      dataModel.objectId = editedToDoData.objectId ?? "";
      dataModel.patientId = editedToDoData.patientId ?? "";
      dataModel.patientName = editedToDoData.patientName ?? "";
      dataModel.priority = selectedPriority;
      dataModel.display = selectedDisplay;
      dataModel.code = selectedCode;
      dataModel.createdDate = editedToDoData.createdDate;
      dataModel.lastUpdatedDate = nowDateTime;
      dataModel.isSync = false;
      dataModel.createdDate = editedToDoData.createdDate;
    dataModel.reviewMaterialURL = editedToDoData.reviewMaterialURL;
    dataModel.reviewMaterialTitle = editedToDoData.reviewMaterialTitle;
    dataModel.generalDescription = editedToDoData.generalDescription;
    dataModel.makeContactDescription = editedToDoData.makeContactDescription;
    dataModel.performerId = editedToDoData.performerId;
    dataModel.performerName = editedToDoData.performerName;
      dataModel.lastUpdatedDate = nowDateTime;
      dataModel.tag = "";
    if(editedToDoData.focusReference != ""){
      dataModel.focusReference = Reference(
          reference: editedToDoData.focusReference);
    }
      dataModel.forReference = Reference(
          reference: editedToDoData.forReference,
          display: editedToDoData.forDisplay);
      dataModel.ownerReference = Reference(
          reference: editedToDoData.ownerReference,
          display: editedToDoData.ownerDisplay);
      dataModel.requesterReference = Reference(
          reference: editedToDoData.requesterReference,
          display: editedToDoData.requesterDisplay);
      dataModel.qrUrl = editedToDoData.qrUrl;
      dataModel.token = editedToDoData.token;
      dataModel.clientId = editedToDoData.clientId;
    List<NoteTableData>? noteDataList = [];
    for (int i = 0; i < notesList.length; i++) {
      var noteTableData = NoteTableData();
      noteTableData.notes = notesList[i].notes;
      noteTableData.author = notesList[i].author;
      noteTableData.readOnly = false;
      noteTableData.date = notesList[i].date;
      noteTableData.isCreatedNote = notesList[i].isCreatedNote;
      dataModel.notesList!.add(noteTableData);
      noteDataList.add(noteTableData);
    }
    editedToDoData.noteList = noteDataList;


    Utils.showToast(Get.context!, "ToDo update successfully");
    // }
    /*else {
      dataModel.statusReason = statusReasonText;
      dataModel.businessStatusReason = businessStatusText ?? "";
      dataModel.status = status;
      dataModel.priority = selectedPriority;
      dataModel.display = (selectedCode == "")? "" :selectedDisplay;
      dataModel.text = (selectedCode == "")?selectedDisplay:"";
      dataModel.code = selectedCode;
      dataModel.lastUpdatedDate = nowDateTime;
      dataModel.createdDate = nowDateTime;
      dataModel.generalResponseText = generalInfoText;
      dataModel.chosenContactText = chosenContact;
      dataModel.isSync = false;
      if(Utils.getPrimaryServerData() != null){
        dataModel.qrUrl = Utils.getPrimaryServerData()!.url;
        dataModel.token = Utils.getPrimaryServerData()!.authToken;
        dataModel.clientId = Utils.getPrimaryServerData()!.clientId;
        dataModel.patientId = Utils.getPrimaryServerData()!.patientId;
        dataModel.patientName = "${Utils.getPrimaryServerData()!.patientFName} ${Utils.getPrimaryServerData()!.patientLName}";
      }
      dataModel.patientId = Utils.getPatientId();
      Utils.showToast(Get.context!, "ToDo added successfully");
    }*/

    Get.back(result: editedToDoData);

    // String? qrUrl = Preference.shared.getString(Preference.qrUrlData) ?? "";
    if (Utils.getServerListPreference().isNotEmpty) {
      var serverUrlDataList = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
      if(serverUrlDataList.isNotEmpty) {
        String  observationId = await Syncing.callApiForToDoSyncData(
            dataModel, dataModel.qrUrl! ?? "", dataModel.clientId!, dataModel.token!);
      }
    }
  }

  onChangeStatus(String value) {
    status = value;
    update();
  }

  void onChangePriority(String? value) {
    selectedPriority = value ?? "";
    update();
  }

  void onChangeCode(int index) {
    selectedDisplay =Utils.codeTodoList[index].display;
    selectedCode = Utils.codeTodoList[index].code ?? "";
    Get.back();
    update();
  }

  void addNewCodeDataIntoList(String displayAdd) {
    Utils.codeTodoList.add(CodeToDoModel(display: displayAdd));
    Get.back();
    addNewCodeController.clear();
    update();
  }

  addNotesData(String text, bool isEditNote, int index) async {
    if (isEditNote) {
      notesList[index].notes = text;
    } else {
      // NotesData notesData = NotesData();
      // notesData
      notesList.add(NotesData(
          isDelete: false,
          author: Utils.getFullName(),
          notes: getDataFromController(),
          date: DateTime.now(),
          isCreatedNote: true),
      );
    }
    notesController.clear();
    Get.back();
    update();
  }
  /*editNoteDataController(String value) {
    notesController.text = value;
    update();
  }*/
  editNoteDataController(String value,bool isUpdate) {
    notesValue = value;
    if(isUpdate){
      Future.delayed(const Duration(milliseconds: 0), () async {
        List<dynamic> jsonList = jsonDecode(value);
        Delta delta = Delta.fromJson(jsonList);
        notesController = QuillController(
          document: Document.fromDelta(delta),
          selection: TextSelection.collapsed(offset: 0),
        );
        Debug.printLog("insertHtml...$value");
      });
    }
    update();
  }


  List<NoteTableData> noteDatabaseList = [];

  getNoteList(List<NoteTableData> noteList) async {
/*    noteDatabaseList = Hive.box<NoteTableData>(Constant.tableNoteData)
        .values
        .toList()
        .where((element) => element.TaskId == editedToDoData.key)
        .toList();*/

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
        // data.TaskId = editedToDoData.key;
        notesList.add(data);
      }
    }
    update();
  }

  deleteNoteListData(int? noteId, int index) async {
    notesList.removeAt(index);

    if (noteId != null) {
      await DataBaseHelper.shared.deleteSingleNoteData(noteId);
    }
    update();
  }

  getAssignedData(String value,setStateDialog) async {
    // await Utils.getPerformerDataSearchList(value,setStateDialog);
    update();
  }

  onChangeAssignedTo(int index){
    selectedPerformer.performerName = Utils.performerList[index].performerName ?? "";
    selectedPerformer.performerId = Utils.performerList[index].performerId;
    selectedPerformer.baseUrl = Utils.performerList[index].baseUrl;
    selectedPerformer.dob = Utils.performerList[index].dob;
    selectedPerformer.gender = Utils.performerList[index].gender;
    Get.back();
    searchNameControllers.clear();
    update();
  }


  manageToDOStatus(String value) async {
    if(Constant.isCancel == value){
      await onChangeStatus(Constant.toDoStatusCancelled);
    }else if(Constant.isCompleted == value){
      await onChangeStatus(Constant.toDoStatusCompleted);
    }else if(Constant.isProgress == value){
      await onChangeStatus(Constant.toDoStatusInProgress);
    }
    await updatePatientTask();
  }

  String getDataFromController(){
    final delta = notesController.document.toDelta();
    Debug.printLog('Current HTML content: $notesValue.......  ${delta.toJson()}');
    notesValue = jsonEncode(notesController.document.toDelta().toList());
    return notesValue;
  }


}
