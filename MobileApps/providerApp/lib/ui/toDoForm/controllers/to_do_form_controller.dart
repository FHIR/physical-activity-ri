
import 'dart:convert';

import 'package:banny_table/db_helper/box/referral_data.dart';
import 'package:banny_table/db_helper/box/to_do_form_data.dart';
import 'package:banny_table/db_helper/database_helper.dart';
import 'package:banny_table/resources/syncing.dart';
import 'package:banny_table/ui/home/home/controllers/home_controllers.dart';
import 'package:banny_table/ui/patientIndependentMode/datamodel/ToDoListDatamodel.dart';
import 'package:banny_table/ui/referralForm/datamodel/performerData.dart';
import 'package:banny_table/ui/toDoList/dataModel/codeModel.dart';
import 'package:banny_table/ui/toDoList/dataModel/to_do_sync_data_model.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:fhir/r4.dart';
import 'package:banny_table/ui/patientIndependentMode/controllers/patient_independent_controller.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:html_editor_enhanced/html_editor.dart';

import '../../../db_helper/box/notes_data.dart';
import '../../../resources/PaaProfiles.dart';
import '../../goalForm/datamodel/notesData.dart';
import '../../welcomeScreen/healthProvider/qrScanner/datamodel/serverModelJson.dart';


class ToDoController extends GetxController {
  // var selectedVerificationStatus = "";
  var status = "";
  var statusHint = Constant.pleaseSelect;
  var statusFix = "";
  var selectedDisplay = "";
  var selectedDisplayText = "";
  var selectedDisplayTextHint = Constant.pleaseSelect;
  var selectedCode = "";
  String selectedPriority = "";
  String selectedPriorityHint = Constant.pleaseSelect;
  String selectTextFirst = "Please enter reason";
  String businessStatusFocusText = "Please enter business Status";
  TextEditingController addNewCodeController = TextEditingController();
  TextEditingController addNewPatientCodeController = TextEditingController();
  FocusNode addNewCodeFocus = FocusNode();
  FocusNode addNewPatientCodeFocus = FocusNode();
  TextEditingController statusReason = TextEditingController();
  TextEditingController businessStatus = TextEditingController();
  var editedToDoData = ToDoDataListModel();
  var arguments = Get.arguments;
  var isEdited = false;
  FocusNode statusReasonFocus = FocusNode();
  FocusNode businessStatusFocus = FocusNode();
  String fromScreenType = "";
  TextEditingController searchNameControllers = TextEditingController();
  TextEditingController generalInfoResponseReason = TextEditingController();

  TextEditingController chosenContactController = TextEditingController();

  FocusNode generalInfoResponseReasonFocus = FocusNode();
  FocusNode chosenContactFocus = FocusNode();
  FocusNode searchNameFocus = FocusNode();

  PerformerData selectedPerformer = PerformerData();


  // ReferralData referralEditedData = ReferralData();
  bool isFromIndependentMode = false;

  String notesValue = "";
  QuillController notesController = QuillController.basic();

  List<NotesData> notesList = [];
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
  List<PerformerData> restrictedDataList = [];


  @override
  void onInit() {
    getServerDataList();
    if (arguments != null) {
      if (arguments[0] != null) {
        editedToDoData = arguments[0];
        if (editedToDoData.noteList.isNotEmpty) {
          getNoteList(editedToDoData.noteList);
        }
        isFromIndependentMode = arguments[2];
        isEdited = true;
        // getNoteList();
        if (editedToDoData.status != null && editedToDoData.status != "") {
          status = editedToDoData.status ?? "";
          statusFix = editedToDoData.status ?? "";
          statusHint = editedToDoData.status ?? "";
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
        if (editedToDoData.priority != null && editedToDoData.priority != "") {
          if (editedToDoData.priority.toString() == null ||
              editedToDoData.priority.toString() == "Null" ||
              editedToDoData.priority.toString() == "null") {
            selectedPriority = Constant.priorityRoutine;
          } else {
            selectedPriority = editedToDoData.priority.toString();
            selectedPriorityHint = editedToDoData.priority.toString();
          }
        }
        if (editedToDoData.performerId != "") {
          selectedPerformer.performerId = editedToDoData.performerId!;
          selectedPerformer.performerName = editedToDoData.performerName;
        }
        if (editedToDoData.makeContactDescription != "") {
          makeContactDetalisCode.text =
              editedToDoData.makeContactDescription ?? "";
        }
        if (editedToDoData.reviewMaterialURL != "") {
          reviewMaterialControllerURL.text =
              editedToDoData.reviewMaterialURL ?? "";
        }
        if (editedToDoData.reviewMaterialTitle != "") {
          reviewMaterialControllerTitle.text =
              editedToDoData.reviewMaterialTitle ?? "";
        }
        if (editedToDoData.generalDescription != "") {
          generalInformationDetalisCode.text =
              editedToDoData.generalDescription ?? "";
        }

        if (editedToDoData.display != null) {
          selectedDisplay = editedToDoData.display.toString();
          selectedDisplayTextHint = editedToDoData.display.toString();
          selectedCode = editedToDoData.code.toString();

          Debug.printLog("..selectedCode.....${selectedCode}");
          // if(Utils.codeTodoList.where((element) => element.display == selectedDisplay && element.code == selectedCode).toList().isEmpty){
          if (Utils.codeTodoList
              .where((element) => element.display != selectedDisplayText)
              .toList()
              .isEmpty) {
            Utils.codeTodoList.add(
                CodeToDoModel(display: selectedDisplay, code: selectedCode));
          }
        }
        /*if (selectedDisplay == "" && editedToDoData.text != "") {
          selectedDisplayText = editedToDoData.text.toString();
          selectedDisplayTextHint = editedToDoData.text.toString();
          if (Utils.codeTodoList
              .where((element) => element.display != selectedDisplayText)
              .toList()
              .isEmpty) {
            Utils.codeTodoList.add(CodeToDoModel(display: selectedDisplayText));
          }
        }*/
        Utils.codeTodoList.toSet().toList();
        if (isFromIndependentMode) {
          List<NoteTableData> noteListData = editedToDoData.noteList;
          callApiForMarkAsARead(noteListData);
        }
      } else {
        selectedPriority = Constant.priorityRoutine;
        selectedPriorityHint = Constant.priorityRoutine;
        status = Constant.statusDraft;
        statusFix = Constant.statusDraft;
        selectedCode = Utils.codeTodoList[0].code ?? "";
      }
      if (arguments[1] != null) {
        fromScreenType = arguments[1];
      }
    } else {
      selectedPriority = Utils.priorityList[0];
      selectedPriority = Constant.priorityRoutine;
      selectedPriorityHint = Constant.priorityRoutine;
      status = Constant.statusDraft;
      statusFix = Constant.statusDraft;
      selectedCode = Utils.codeTodoList[0].code ?? "";
    }
    super.onInit();
  }

  List<ServerModelJson> serverUrlDataList = [];
  getServerDataList(){
    serverUrlDataList = Utils.getServerListPreference().where((element) => element.isSelected && element.providerId != "" && element.patientId != "").toList();
    if(serverUrlDataList.isNotEmpty){
      getRestrictedData("",update);
    }
  }

  getRestrictedData(String? name,setStateDialog) async {
    if(serverUrlDataList.isEmpty){
      return;
    }
    var performerData = await PaaProfiles.getPerformerSearchList(name,serverUrlDataList[0]);
    if (performerData.resourceType == R4ResourceType.Bundle && performerData.entry != null) {
      var totalLength = performerData.entry.length;
      if (performerData != null) {
        restrictedDataList.clear();
        for (int i = 0; i < totalLength; i++) {
          var data = performerData.entry[i];
          if(performerData.entry[i].resource.resourceType == R4ResourceType.Practitioner) {
            var id;
            if (data.resource.id != null) {
              id = data.resource.id.toString();
            }
            var performerDataModel = PerformerData();



            try{
              var performer = data.resource.name[0].given[0].toString();

              var userName = "";
              try {
                userName += data.resource.name[0].family.toString();
              } catch (e) {
                Debug.printLog("lName. getRestrictedData..$e");
              }

              var gender = "";
              try {
                gender = data.resource.gender.toString();
              } catch (e) {
                Debug.printLog("lName. v..$e");
              }

              var dob = "";
              try {
                dob = data.resource.birthDate.toString();
              } catch (e) {
                Debug.printLog("lName. getRestrictedData..$e");
              }

              Debug.printLog("patient info. getRestrictedData...$performer  $id");
              performerDataModel.performerId = id;
              performerDataModel.performerName = "$performer $userName";
              performerDataModel.dob = dob;
              performerDataModel.gender = gender;
              performerDataModel.baseUrl = serverUrlDataList[0].url;
            }catch(e){
              Debug.printLog("patient name not found");
            }

            var loggedProvider = PerformerData();
            loggedProvider.performerId = Utils.getProviderId();
            loggedProvider.performerName = Utils.getProviderName();
            loggedProvider.baseUrl = serverUrlDataList[0].url;

            if(performerDataModel.performerId != Utils.getProviderId() &&
                performerDataModel.performerName != Utils.getProviderName()){
              if (!restrictedDataList.contains(performerDataModel) && !restrictedDataList.contains(loggedProvider)) {
                if(performerDataModel.performerId != "" && performerDataModel.performerName != ""){
                  if(restrictedDataList.where((element) => element.performerId == performerDataModel.performerId).toList().isEmpty){
                    restrictedDataList.add(performerDataModel);
                  }
                }
              }
            }
          }
        }
      }
    }else{
      restrictedDataList.clear();
    }
    try {
      setStateDialog((){
            Debug.printLog("performerLists restrictedDataList....... ${restrictedDataList.toString()}");
          });
    } catch (e) {
      Debug.printLog(e.toString());
    }
    update();
  }


  insertUpdateData() async {
    String todoId = "";
    var statusReasonText = statusReason.text;
    var businessStatusText = businessStatus.text;
    TaskSyncDataModel dataModel = TaskSyncDataModel();
    var nowDateTime = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Utils.showDialogForProgress(
          Get.context!, Constant.txtPleaseWait, Constant.dataSyncingPatientTask);
    });
    if (isEdited) {
      editedToDoData.status = status;
      editedToDoData.statusReason = statusReasonText;
      editedToDoData.objectId = editedToDoData.objectId;
      editedToDoData.patientId = editedToDoData.patientId;
      editedToDoData.priority = selectedPriority;
      editedToDoData.performerId = selectedPerformer.performerId;
      editedToDoData.performerName = selectedPerformer.performerName;
      editedToDoData.makeContactDescription = makeContactDetalisCode.text;
      editedToDoData.reviewMaterialURL = reviewMaterialControllerURL.text;
      editedToDoData.reviewMaterialTitle = reviewMaterialControllerTitle.text;
      editedToDoData.generalDescription = generalInformationDetalisCode.text;
      editedToDoData.display = selectedDisplay;
      editedToDoData.code = selectedCode;
      editedToDoData.isSync = false;
      editedToDoData.tag = "";
      if (fromScreenType == Constant.todoFromAssigned) {
        editedToDoData.isCreated = false;
      } else {
        editedToDoData.isCreated = true;
      }
      editedToDoData.businessStatus = businessStatusText;

      dataModel.status = status;
      dataModel.statusReason = statusReasonText;
      dataModel.businessStatusReason = businessStatusText;
      dataModel.objectId = editedToDoData.objectId ?? "";
      dataModel.patientId = editedToDoData.patientId ?? "";
      dataModel.priority = selectedPriority;
      dataModel.display = selectedDisplay;
      dataModel.code = selectedCode;
      dataModel.isSync = false;
      dataModel.qrUrl = editedToDoData.qrUrl;
      dataModel.token = editedToDoData.token;
      dataModel.clientId = editedToDoData.clientId;
      dataModel.patientName = editedToDoData.patientName;
      dataModel.patientName = editedToDoData.providerId;
      dataModel.providerId = editedToDoData.providerName;
      dataModel.performerId = editedToDoData.performerId;
      dataModel.performerName = editedToDoData.performerName;
      dataModel.makeContactDescription = makeContactDetalisCode.text;
      dataModel.reviewMaterialURL = reviewMaterialControllerURL.text;
      dataModel.reviewMaterialTitle = reviewMaterialControllerTitle.text;
      dataModel.generalDescription = generalInformationDetalisCode.text;
      dataModel.generalResponseText = editedToDoData.generalResponseText;
      dataModel.chosenContactText = editedToDoData.chosenContactText;

      if (editedToDoData.focusReference != "") {
        dataModel.focusReference = Reference(
            reference: editedToDoData.focusReference);
      }
      dataModel.createdDate = editedToDoData.createdDate;
      dataModel.lastUpdatedDate = nowDateTime;
      dataModel.tag = "";
      dataModel.forReference = Reference(
          reference: editedToDoData.forReference,
          display: editedToDoData.forDisplay);
      dataModel.ownerReference = Reference(
          reference: editedToDoData.ownerReference,
          display: editedToDoData.ownerDisplay);
      dataModel.requesterReference = Reference(
          reference: editedToDoData.requesterReference,
          display: editedToDoData.requesterDisplay);

      for (int i = 0; i < notesList.length; i++) {
        var noteTableData = NoteTableData();
        noteTableData.notes = notesList[i].notes;
        noteTableData.author = notesList[i].author;
        noteTableData.readOnly = false;
        noteTableData.date = notesList[i].date;
        noteTableData.isCreatedNote = notesList[i].isCreatedNote;
        dataModel.notesList!.add(noteTableData);
      }
      editedToDoData.noteList.clear();
      editedToDoData.noteList.addAll(dataModel.notesList ?? []);
      String? qrUrl = Preference.shared.getString(Preference.qrUrlData) ?? "";
      if (qrUrl != "") {
        String todoId = await Syncing.callApiForToDoSyncData(dataModel);
        Debug.printLog("todo id.....$todoId");
      }
      Get.back(result: editedToDoData);
      Get.back();
      Utils.showToast(Get.context!, "ToDo update successfully");
      // Get.back(result:editedToDoData );
    }
    else  {
      var nowDateTime = DateTime.now();
      dataModel.statusReason = statusReasonText ?? "";
      dataModel.businessStatusReason = businessStatusText ?? "";
      dataModel.status = status ?? "";
      dataModel.patientId = Utils.getPatientId() ?? "";
      dataModel.priority = selectedPriority ?? "";
      dataModel.code = selectedCode;
      dataModel.display = (selectedCode == "") ? "" : selectedDisplay;
      dataModel.text = (selectedCode == "") ? selectedDisplay : "";
      dataModel.isSync = true;
      dataModel.lastUpdatedDate = nowDateTime;
      dataModel.createdDate = nowDateTime;
      dataModel.performerId = selectedPerformer.performerId;
      dataModel.performerName = selectedPerformer.performerName;
      dataModel.makeContactDescription = makeContactDetalisCode.text;
      dataModel.reviewMaterialURL = reviewMaterialControllerURL.text;
      dataModel.reviewMaterialTitle = reviewMaterialControllerTitle.text;
      dataModel.generalDescription = generalInformationDetalisCode.text;
      dataModel.generalResponseText = generalInfoResponseReason.text;
      dataModel.chosenContactText = chosenContactController.text;
      if (Utils.getPrimaryServerData() != null) {
        dataModel.qrUrl = Utils.getPrimaryServerData()!.url;
        dataModel.token = Utils.getPrimaryServerData()!.authToken;
        dataModel.clientId = Utils.getPrimaryServerData()!.clientId;
        dataModel.patientId = Utils.getPrimaryServerData()!.patientId;
        dataModel.providerId = Utils.getPrimaryServerData()!.providerId;
        dataModel.providerName =
        "${Utils.getPrimaryServerData()!.providerFName}${Utils
            .getPrimaryServerData()!.providerLName}";
        dataModel.patientName =
        "${Utils.getPrimaryServerData()!.patientFName}${Utils
            .getPrimaryServerData()!.patientLName}";
      }
      var nowDate = DateTime.now();
      List<NoteTableData>? noteDataList = [];
      for (int i = 0; i < notesList.length; i++) {
        var noteTableData = NoteTableData();
        noteTableData.notes = notesList[i].notes;
        noteTableData.author = notesList[i].author;
        noteTableData.readOnly = false;
        noteTableData.date = DateTime(nowDate.year, nowDate.month, nowDate.day);
        noteTableData.isDelete = true;
        noteTableData.isAssignedNote = true;
        noteTableData.isCreatedNote = notesList[i].isCreatedNote;
        noteDataList.add(noteTableData);
      }
      /*var noteData =Hive.box<NoteTableData>(Constant.tableNoteData).values.toList().where((element) =>
      element.isTaskNote! && element.createdTaskId == editedToDoData.key && element.providerId == Utils.getProviderId()).toList();
      dataModel.notesList = noteData;*/
      // var noteData =Hive.box<NoteTableData>(Constant.tableNoteData).values.toList().where((element) =>
      // element.isTaskNote! && element.createdTaskId == editedToDoData.key &&
      //     element.providerId == Utils.getProviderId()).toList();
      dataModel.notesList = noteDataList;

      ///use For Local in Data Store
      ToDoDataListModel todoModel = ToDoDataListModel();
      todoModel.noteList = noteDataList;
      todoModel.statusReason = dataModel.statusReason;
      todoModel.businessStatus = dataModel.businessStatusReason;
      todoModel.status = dataModel.status;
      todoModel.patientId = dataModel.patientId;
      todoModel.priority = dataModel.priority;
      todoModel.code = dataModel.code;
      todoModel.display = dataModel.display;
      todoModel.text = dataModel.text;
      todoModel.isSync = dataModel.isSync;
      todoModel.lastUpdatedDate = dataModel.lastUpdatedDate;
      todoModel.createdDate = dataModel.createdDate;
      todoModel.performerId = dataModel.performerId!;
      todoModel.performerName = dataModel.performerName!;
      todoModel.makeContactDescription = dataModel.makeContactDescription;
      todoModel.reviewMaterialURL = dataModel.reviewMaterialURL;
      todoModel.reviewMaterialTitle = dataModel.reviewMaterialTitle;
      todoModel.generalDescription = dataModel.generalDescription;
      todoModel.generalResponseText = dataModel.generalResponseText;
      todoModel.chosenContactText = dataModel.chosenContactText;
      todoModel.ownerReferences = dataModel.ownerReference;
      todoModel.focusReferences = dataModel.focusReference;
      todoModel.forReferences = dataModel.forReference;

      if (Utils.getPrimaryServerData() != null) {
        todoModel.qrUrl = Utils.getPrimaryServerData()!.url;
        todoModel.token = Utils.getPrimaryServerData()!.authToken;
        todoModel.clientId = Utils.getPrimaryServerData()!.clientId;
        todoModel.patientId = Utils.getPrimaryServerData()!.patientId;
        todoModel.providerId = Utils.getPrimaryServerData()!.providerId;
        todoModel.requesterDisplay = Utils.getPrimaryServerData()!.providerId;
        todoModel.providerName =
        "${Utils.getPrimaryServerData()!.providerFName}${Utils
            .getPrimaryServerData()!.providerLName}";
        todoModel.requesterDisplay =
        "${Utils.getPrimaryServerData()!.providerFName}${Utils
            .getPrimaryServerData()!.providerLName}";
        todoModel.patientName =
        "${Utils.getPrimaryServerData()!.patientFName}${Utils
            .getPrimaryServerData()!.patientLName}";
        todoModel.ownerDisplay =
        "${Utils.getPrimaryServerData()!.patientFName}${Utils
            .getPrimaryServerData()!.patientLName}";
        todoModel.forDisplay =
        "${Utils.getPrimaryServerData()!.patientFName}${Utils
            .getPrimaryServerData()!.patientLName}";
      }
      todoModel.performerId = dataModel.performerId!;
      todoModel.performerName = dataModel.performerName!;

      String? qrUrl = Preference.shared.getString(Preference.qrUrlData) ?? "";
      if(Utils.getPrimaryServerData()!.url != ""){
        todoId = await Syncing.callApiForToDoSyncData(dataModel);
        dataModel.objectId = todoId;
        todoModel.objectId = todoId;
        if (todoId != "null" || todoId != "" || todoId != "NULL" || todoId != "Null") {
          if(!isEdited){
            todoModel.forReference = 'Patient/${todoModel.patientId}';
            todoModel.ownerReference = 'Patient/${todoModel.patientId}';
            todoModel.requesterReference = 'Practitioner/${todoModel.providerId}';
          }
          HomeControllers homeControllers = Get.find();
          homeControllers.patientTaskDataList.add(todoModel);
          homeControllers.patientTaskDataListLocal.add(todoModel);
          homeControllers.updateMethod();
        }
      }
      Get.back();
      if (todoId == "null" || todoId == "" || todoId == "NULL" ||
          todoId == "Null") {
        Utils.showErrorDialog(
            Get.context!, Constant.txtError, Constant.txtErrorTodoNotCreated);
      } else {
        Utils.showToast(Get.context!, "Patient task created successfully");
        Get.back();
      }
    }
    // final SharedPreferences pref = await SharedPreferences.getInstance();
    // String? selectedSyncing =
    //     pref.getString(Constant.keySyncing) ?? Constant.realTime;

  }

  void onChangeStatus(String value) {
    status = value;
    statusHint = value;
    update();
  }

  void onChangePriority(String? value) {
    selectedPriority = value ?? "";
    selectedPriorityHint = value ?? "";
    update();
  }

  void onChangeCode(int index) {
    selectedDisplay = Utils.codeTodoList[index].display;
    selectedCode = Utils.codeTodoList[index].code ?? "";
    selectedDisplayTextHint = Utils.codeTodoList[index].display ?? "";
    Get.back();
    update();
  }

  void addNewCodeDataIntoList(String displayAdd, String code) {
    // if(displayAdd != ""){
    //   if(code != ""){
    //     Utils.codeTodoList.add(CodeToDoModel(display: displayAdd,code: code));
    //     Get.back();
    //     addNewCodeController.clear();
    //     addNewPatientCodeController.clear();
    //   }else{
    //     Utils.showToast(Get.context!, "Please Enter a Patient Code");
    //   }
    // }else{
    //   Utils.showToast(Get.context!, "Please Enter a Patient Task");
    // }

    Utils.codeTodoList.add(CodeToDoModel(display: displayAdd));
    Get.back();
    addNewCodeController.clear();
    addNewPatientCodeController.clear();

    update();
  }

  callApiForMarkAsARead(List<NoteTableData> noteListData) async {
    var nowDateTime = DateTime.now();
    editedToDoData.tag = Constant.statusTaskReviewed;
    editedToDoData.lastUpdatedDate = nowDateTime;
    var dataModel = TaskSyncDataModel();
    dataModel.status = status;
    dataModel.statusReason = editedToDoData.statusReason ?? "";
    dataModel.businessStatusReason = editedToDoData.businessStatus ?? "";
    dataModel.objectId = editedToDoData.objectId ?? "";
    dataModel.patientId = editedToDoData.patientId ?? "";
    dataModel.priority = editedToDoData.priority ?? "";
    dataModel.createdDate = editedToDoData.createdDate;
    dataModel.lastUpdatedDate = nowDateTime;
    dataModel.display = editedToDoData.display ?? "";
    dataModel.code = editedToDoData.code ?? "";
    dataModel.tag = Constant.statusTaskReviewed;
    dataModel.text = editedToDoData.text ?? "";
    dataModel.qrUrl = editedToDoData.qrUrl;
    dataModel.token = editedToDoData.token;
    dataModel.clientId = editedToDoData.clientId;
    dataModel.patientName = editedToDoData.patientName;
    dataModel.patientName = editedToDoData.providerId;
    dataModel.providerId = editedToDoData.providerName;
    dataModel.reviewMaterialURL = editedToDoData.reviewMaterialURL;
    dataModel.reviewMaterialTitle = editedToDoData.reviewMaterialTitle;
    dataModel.generalDescription = editedToDoData.generalDescription;
    dataModel.makeContactDescription = editedToDoData.makeContactDescription;
    dataModel.performerId = editedToDoData.performerId;
    dataModel.performerName = editedToDoData.performerName;
    dataModel.generalResponseText = editedToDoData.generalResponseText;
    dataModel.chosenContactText = editedToDoData.chosenContactText;
    dataModel.notesList = noteListData;
    dataModel.isSync = false;
    dataModel.forReference = Reference(
        reference: editedToDoData.forReference,
        display: editedToDoData.forDisplay);
    dataModel.ownerReference = Reference(
        reference: editedToDoData.ownerReference,
        display: editedToDoData.ownerDisplay);
    dataModel.requesterReference = Reference(
        reference: editedToDoData.requesterReference,
        display: editedToDoData.requesterDisplay);
   /* if (editedToDoData.focusReference != "") {
      dataModel.focusReference = Reference(
          reference: editedToDoData.focusReference);
    }*/
    // await DataBaseHelper.shared.updateToDoData(editedToDoData);
    String? qrUrl = Preference.shared.getString(Preference.qrUrlData) ?? "";
    if (Utils.getPrimaryServerData()!.url != "") {
      String todoId = await Syncing.callApiForToDoSyncData(dataModel);
      dataModel.objectId = todoId;
      ToDoDataListModel todoModel = ToDoDataListModel();
      if (todoId != "null" && todoId != "" && todoId != "NULL" &&
          todoId != "Null") {
        todoModel.objectId = todoId;
        todoModel.noteList = dataModel.notesList;
        todoModel.statusReason = dataModel.statusReason;
        todoModel.businessStatus = dataModel.businessStatusReason;
        todoModel.status = dataModel.status;
        todoModel.patientId = dataModel.patientId;
        todoModel.priority = dataModel.priority;
        todoModel.code = dataModel.code;
        todoModel.display = dataModel.display;
        todoModel.text = dataModel.text;
        todoModel.isSync = dataModel.isSync;
        todoModel.lastUpdatedDate = dataModel.lastUpdatedDate;
        todoModel.createdDate = dataModel.createdDate;
        todoModel.performerId = dataModel.performerId!;
        todoModel.performerName = dataModel.performerName!;
        todoModel.makeContactDescription = dataModel.makeContactDescription;
        todoModel.reviewMaterialURL = dataModel.reviewMaterialURL;
        todoModel.reviewMaterialTitle = dataModel.reviewMaterialTitle;
        todoModel.generalDescription = dataModel.generalDescription;
        todoModel.generalResponseText = dataModel.generalResponseText;
        todoModel.chosenContactText = dataModel.chosenContactText;
        todoModel.ownerReferences = dataModel.ownerReference;
        todoModel.focusReferences = dataModel.focusReference;
        todoModel.forReferences = dataModel.forReference;
        todoModel.qrUrl = editedToDoData.qrUrl;
        todoModel.token = editedToDoData.token;
        todoModel.clientId = editedToDoData.clientId;
        todoModel.patientId = dataModel.patientId;
        todoModel.providerId = editedToDoData.providerId;
        todoModel.providerName = editedToDoData.providerName;
        todoModel.requesterDisplay = editedToDoData.requesterDisplay;
        todoModel.patientName = editedToDoData.patientName;
        todoModel.ownerDisplay = editedToDoData.ownerDisplay;
        todoModel.forDisplay = editedToDoData.forDisplay;
        todoModel.tag = todoModel.tag;
        todoModel.performerId = dataModel.performerId!;
        todoModel.performerName = dataModel.performerName!;
      }
      if (todoId != "null" && todoId != "" && todoId != "NULL" &&
          todoId != "Null") {
        PatientIndependentController patientIndependentController = Get.find();

        int index = patientIndependentController.toDoCreatedDataList
            .indexWhere((element) => element.objectId == todoId).toInt();
        if (index != -1) {
          patientIndependentController.toDoCreatedDataList[index] = todoModel;
          int indexLocal = patientIndependentController.toDoCreatedDataList
              .indexWhere((element) => element.objectId == todoId).toInt();
          if(indexLocal != -1){
            patientIndependentController.toDoCreatedDataListLocal[indexLocal] = todoModel;
          }
          patientIndependentController.updateMethod();
          // patientIndependentController.getTodoApiData();
        }

/*        patientIndependentController.toDoCreatedDataList.add(todoModel);
        patientIndependentController.updateMethod();*/
      }

      Debug.printLog("todoId....$todoId");
    }
  }

  addNotesData(String text, bool isEditNote, int index) async {
    if (isEditNote) {
      notesList[index].notes = getDataFromController();
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

  deleteNoteListData(int? noteId, int index) async {
    notesList.removeAt(index);

    if (noteId != null) {
      await DataBaseHelper.shared.deleteSingleNoteData(noteId);
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
    }
    update();
  }



  List<NoteTableData> noteDatabaseList = [];

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

  checkValidationForToken() async {
    await Utils.isExpireTokenAPICall(Constant.screenTypeHome, (value) async {
      if (!value) {
        await insertUpdateData();
      }
    }).then((value) async {
      if (!value) {
        await insertUpdateData();
      }
    });
  }


  insertSaveAsDraft() async {
    status = Constant.statusDraft;
    // await insertUpdateData();
    await checkValidationForToken();
    update();
  }

  insertForSign() async {
    if (status == Constant.statusDraft) {
      status = Constant.toDoStatusReady;
    }
    // await insertUpdateData();
    await checkValidationForToken();
  }

  onChangeAssignedTo(int index) {
    /*selectedPerformer.performerName = Utils.performerList[index].performerName ?? "";
    selectedPerformer.performerId = Utils.performerList[index].performerId;
    selectedPerformer.baseUrl = Utils.performerList[index].baseUrl;
    selectedPerformer.dob = Utils.performerList[index].dob;
    selectedPerformer.gender = Utils.performerList[index].gender;*/
    try {
      selectedPerformer.performerName = restrictedDataList[index].performerName ?? "";
      selectedPerformer.performerId = restrictedDataList[index].performerId;
      selectedPerformer.baseUrl = restrictedDataList[index].baseUrl;
      selectedPerformer.dob = restrictedDataList[index].dob;
      selectedPerformer.gender = restrictedDataList[index].gender;
    } catch (e) {
      Debug.printLog(e.toString());
    }
    Get.back();
    searchNameControllers.clear();
    getRestrictedData("", update);
    update();
  }


  getAssignedData(String value, setStateDialog) async {
    // await Utils.getPerformerDataSearchList(value, setStateDialog);
    await getRestrictedData(value,setStateDialog);
    update();
  }

  void onChangePerformer(dynamic value) {
    selectedPerformer = value ?? Utils.performerList[0];
    update();
  }

  insertCheckUpdate(bool isDraft) {
    if (selectedDisplay == Constant.toDoCodeDisplayMakeContact) {
      if (selectedPerformer.performerId != "" &&
          selectedPerformer.performerName != "") {
        if (makeContactDetalisCode.text != "") {
          if (isDraft) {
            insertSaveAsDraft();
          } else {
            insertForSign();
          }
        } else {
          Utils.showToast(Get.context!, "Please Enter a Description");
        }
      } else {
        Utils.showToast(Get.context!, "Please Select a Contact Provider");
      }
    }
    else if (selectedDisplay == Constant.toDoCodeDisplayReviewMaterial) {
      if (reviewMaterialControllerURL.text != "") {
        if (isValidURL(reviewMaterialControllerURL.text)) {
          if (reviewMaterialControllerTitle.text != "") {
            if (isDraft) {
              insertSaveAsDraft();
            } else {
              insertForSign();
            }
          } else {
            Utils.showToast(Get.context!, "Please Enter Title");
          }
        } else {
          Utils.showToast(Get.context!, "Please Enter a valid Url");
        }
      } else {
        Utils.showToast(Get.context!, "Please Enter Url");
      }
    }
    else if (selectedDisplay == Constant.toDoCodeDisplayGeneralInfo) {
      if (generalInformationDetalisCode.text != "") {
        if (isDraft) {
          insertSaveAsDraft();
        } else {
          insertForSign();
        }
      } else {
        Utils.showToast(Get.context!, "Please Enter a Description");
      }
    } else {
      if (isDraft) {
        insertSaveAsDraft();
      } else {
        insertForSign();
      }
    }
  }

  bool isValidURL(String url) {
    final Uri uri;
    try {
      uri = Uri.parse(url);
    } catch (_) {
      return false;
    }
    return (uri.isScheme('http') || uri.isScheme('https')) &&
        uri.host.isNotEmpty;
  }


/*  bool isValidURLs(String url) {
    final urlPattern = r'^(http|https):\/\/([\w-]+(\.[\w-]+)+)([\/\w-]*)*\/?$';
    final regex = RegExp(urlPattern);
    return regex.hasMatch(url);
  }*/

  bool isGeneralInfo() {
    return selectedDisplayTextHint.toLowerCase() ==
        Constant.toDoCodeDisplayGeneralInfo.toLowerCase();
  }

  bool isChosenContact() {
    return selectedDisplayTextHint.toLowerCase() ==
        Constant.toDoCodeDisplayMakeContact.toLowerCase();
  }

  String getDataFromController(){
    final delta = notesController.document.toDelta();
    Debug.printLog('Current HTML content: $notesValue.......  ${delta.toJson()}');
    notesValue = jsonEncode(notesController.document.toDelta().toList());
    return notesValue;
  }

}