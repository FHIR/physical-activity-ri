
import 'dart:convert';

import 'package:banny_table/db_helper/box/referral_data.dart';
import 'package:banny_table/db_helper/box/to_do_form_data.dart';
import 'package:banny_table/db_helper/database_helper.dart';
import 'package:banny_table/resources/PaaProfiles.dart';
import 'package:banny_table/resources/syncing.dart';
import 'package:banny_table/ui/home/home/controllers/home_controllers.dart';
import 'package:banny_table/ui/patientIndependentMode/datamodel/ToDoListDatamodel.dart';
import 'package:banny_table/ui/referralForm/datamodel/performerData.dart';
import 'package:banny_table/ui/referralForm/datamodel/referralDataModel.dart';
import 'package:banny_table/ui/referralForm/datamodel/referralTypeCodeDataModel.dart';
import 'package:banny_table/ui/toDoList/dataModel/codeModel.dart';
import 'package:banny_table/ui/toDoList/dataModel/to_do_sync_data_model.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/qrScanner/datamodel/serverModelJson.dart';
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
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../db_helper/box/notes_data.dart';
import '../../goalForm/datamodel/notesData.dart';


class TaskReferralController extends GetxController {


  var editedToDoData = ToDoDataListModel();
  var selectedCodeType = "";
  String codeReferral = "";

  var arguments = Get.arguments;
  var isEdited = false;
  List<NotesData> notesList = [];

  // var normalStartDateStr = "Start date";
  // DateTime? normalStartDate;
  TextEditingController periodStartDateStr = TextEditingController();
  TextEditingController periodEndDateStr = TextEditingController();
  DateTime? periodStartDate = DateTime.now();
  DateTime? periodEndDate;

  var status = "";
  var statusHint = Constant.pleaseSelect;
  var statusFix = "";

  String selectedPriority = "";
  String selectedPriorityHint = Constant.pleaseSelect;

  var textReasonCodeHint = "Please Enter";
  TextEditingController referralInstructions = TextEditingController();
  FocusNode textReasonCodeFocus = FocusNode();

  QuillController notesController = QuillController.basic();
  String notesValue = "";

  List<ServerModelJson> serverUrlDataList = [];
  // List<ReferralSyncDataModel> referralListData = [];
  ReferralSyncDataModel referralData = ReferralSyncDataModel();

  ///This Id use For Update Task For Referral
  String referralId = "";

  @override
  Future<void> onInit() async {
    await getServerDataList();
    if (arguments != null) {
      if (arguments[0] != null) {
        isEdited = true;
        editedToDoData = arguments[0];
        getNoteList(editedToDoData.noteList);
        if (editedToDoData.status != null && editedToDoData.status != "") {
          status = editedToDoData.status ?? "";
          statusFix = editedToDoData.status ?? "";
          statusHint = editedToDoData.status ?? "";
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
        List<NoteTableData> noteListDataList = editedToDoData.noteList ?? [];

        if(editedToDoData.focusReference != null && editedToDoData.focusReference != ""){
          referralId =   editedToDoData.focusReference.split("/")[1].toString();
          if(referralId != "" && referralId.toLowerCase() != "null".toLowerCase()){
            await getAssignedReferralDataListApi(referralId);
          }else{
            callApiForMarkAsARead(noteListDataList);
          }
        }else{
          callApiForMarkAsARead(noteListDataList);
        }


        update();
      }
      else {
        initFirstTimeData();
      }
    } else {
      initFirstTimeData();
    }

    super.onInit();

  }


  initFirstTimeData(){
    selectedPriority = Constant.priorityRoutine;
    selectedPriorityHint = Constant.priorityRoutine;
    status = Constant.statusDraft;
    statusFix = Constant.statusDraft;
    selectedCodeType = Utils.codeList[0].display;
    codeReferral = Utils.codeList[0].code ?? "";
    update();
  }

  getServerDataList(){
    serverUrlDataList = Utils.getServerList.where((element) => element.isSelected && element.providerId != "").toList();
    // serverUrlDataList = Utils.getServerListPreference();
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
        data.authorReference = noteList[i].authorReference;
        notesList.add(data);
      }
    }
    update();
  }

  void onChangeCode(int index) {
    codeReferral = Utils.codeList[index].code ?? "";
    selectedCodeType = Utils.codeList[index].display;
    Get.back();
    update();
  }

  insertUpdateData () async {
    String todoId = "";

    TaskSyncDataModel dataModel = TaskSyncDataModel();
    var instructions = referralInstructions.text;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Utils.showDialogForProgress(
          Get.context!, Constant.txtPleaseWait, Constant.dataSyncingReferral);
    });
    if (isEdited) {
      editedToDoData.status = status;

      editedToDoData.referralTypeDisplay = selectedCodeType;
      editedToDoData.referralTypeCode = codeReferral;
      editedToDoData.text = instructions;
      if(periodStartDate != null){
        editedToDoData.startDate = periodStartDate;
      }

      if(periodEndDate != null){
        editedToDoData.endDate = periodEndDate;
      }
      editedToDoData.priority = selectedPriority;

      dataModel.status = status;
      dataModel.objectId = editedToDoData.objectId ?? "";
      dataModel.patientId = editedToDoData.patientId ?? "";
      dataModel.isSync = false;
      dataModel.qrUrl = editedToDoData.qrUrl;
      dataModel.token = editedToDoData.token;
      dataModel.clientId = editedToDoData.clientId;
      dataModel.patientName = editedToDoData.patientName;
      dataModel.patientName = editedToDoData.providerId;
      dataModel.providerId = editedToDoData.providerName;
      dataModel.performerId = editedToDoData.performerId;
      dataModel.performerName = editedToDoData.performerName;
      dataModel.priority = selectedPriority;
      dataModel.text = instructions;
      dataModel.referralTypeDisplay = selectedCodeType;
      dataModel.referralTypeCode = codeReferral;

      if(periodStartDate != null){
        dataModel.startDate = periodStartDate;
      }

      if(periodEndDate != null){
        dataModel.endDate = periodEndDate;
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
      if (editedToDoData.focusReference != "") {
        dataModel.focusReference = Reference(
            reference: editedToDoData.focusReference);
      }

      for (int i = 0; i < notesList.length; i++) {
        var noteTableData = NoteTableData();
        noteTableData.notes = notesList[i].notes;
        noteTableData.author = notesList[i].author;
        noteTableData.readOnly = false;
        noteTableData.date = notesList[i].date;
        noteTableData.authorReference = notesList[i].authorReference;
        dataModel.notesList!.add(noteTableData);
      }
      editedToDoData.noteList.clear();
      editedToDoData.noteList.addAll(dataModel.notesList ?? []);
      /// Call Api
      if (Utils.getPrimaryServerData()!.url != "") {
        String todoId = await Syncing.callApiForToDoSyncData(dataModel);
        Debug.printLog("todo id.....$todoId");
        if(referralData != null && referralId != ""){
          referralData.referralTypeDisplay = selectedCodeType.toString();
          referralData.referralTypeCode = codeReferral.toString();
          referralData.endDate = periodEndDate;
          referralData.startDate = periodStartDate;
          referralData.isCreated = false;
          referralData.textReasonCode = referralInstructions.text;
          referralData.priority = dataModel.priority;
          if (dataModel.status == Constant.toDoStatusCompleted) {
            referralData.status = Constant.statusCompleted;
          } else if (dataModel.status == Constant.toDoStatusCancelled || dataModel.status == Constant.toDoStatusFailed || dataModel.status == Constant.toDoStatusRejected) {
            referralData.status = Constant.statusRevoked;
          }else if (dataModel.status == Constant.toDoStatusInProgress || dataModel.status == Constant.toDoStatusReady) {
            referralData.status = Constant.statusActive;
          }else if (dataModel.status == Constant.toDoStatusOnHold) {
            referralData.status = Constant.statusOnHold;
          }
          List<NoteTableData> notesListReferral = [];
          for (int i = 0; i < notesList.length; i++) {
            var noteTableData = NoteTableData();
            noteTableData.notes = notesList[i].notes;
            noteTableData.author = notesList[i].author;
            noteTableData.readOnly = false;
            noteTableData.date = notesList[i].date;
            noteTableData.authorReference = notesList[i].authorReference;
            notesListReferral.add(noteTableData);
          }
          referralData.notesList = notesListReferral;
          String id = await Syncing.updateReferralTaskWise(referralData,referralData.qrUrl!);
          Debug.printLog(".....$id");
        }
      }

      Get.back(result: editedToDoData);
      Get.back();
      Utils.showToast(Get.context!, "ToDo update successfully");
    }
    else {
      dataModel.referralTypeDisplay = selectedCodeType;
      dataModel.referralTypeCode = codeReferral;
      dataModel.status = status;
      dataModel.priority = selectedPriority ?? "";



     /* if (normalStartDate != null) {
        dataModel.isPeriodDate = false;
        dataModel.startDate = normalStartDate;
      } else {
        dataModel.isPeriodDate = true;
        dataModel.startDate = periodStartDate;
        dataModel.endDate = periodEndDate;
      }*/

      if(periodStartDate != null){
        dataModel.startDate = periodStartDate;
      }

      if(periodEndDate != null){
        dataModel.endDate = periodEndDate;
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
        noteTableData.isCreatedNote = false;
        noteTableData.isAssignedNote = false;
        noteDataList.add(noteTableData);
      }

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
      todoModel.startDate = dataModel.startDate;
      todoModel.endDate = dataModel.endDate;
      todoModel.isPeriodDate = dataModel.isPeriodDate;

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

      if(Utils.getPrimaryServerData()!.url != ""){
        todoId = await Syncing.callApiForToDoSyncData(dataModel);
        dataModel.objectId = todoId;
        todoModel.objectId = todoId;
        if (todoId != "null" || todoId != "" || todoId != "NULL" || todoId != "Null") {
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
  }


/*
  onChangeNormalDate(DateRangePickerSelectionChangedArgs dateRangePickerSelectionChangedArgs){
    normalStartDate = dateRangePickerSelectionChangedArgs.value;
    normalStartDateStr = DateFormat(Constant.commonDateFormatDdMmYyyy).format(normalStartDate!);

    periodStartDateStr.text = "Start date";
    periodStartDate = null;
    periodEndDateStr.text = "End date";
    periodEndDate = null;
    update();
  }
*/

  onChangePeriodDate(bool isStartDate, DateRangePickerSelectionChangedArgs dateRangePickerSelectionChangedArgs){
    if(isStartDate){
      periodStartDate = dateRangePickerSelectionChangedArgs.value;
      periodStartDateStr.text = DateFormat(Constant.commonDateFormatDdMmYyyy).format(periodStartDate!);
    }else{
      periodEndDate = dateRangePickerSelectionChangedArgs.value;
      periodEndDateStr.text = DateFormat(Constant.commonDateFormatDdMmYyyy).format(periodEndDate!);
    }
    update();
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
      authorReference: "Practitioner/${Utils.getProviderId()}"),
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

  String getDataFromController(){
    final delta = notesController.document.toDelta();
    Debug.printLog('Current HTML content: $notesValue.......  ${delta.toJson()}');
    notesValue = jsonEncode(notesController.document.toDelta().toList());
    return notesValue;
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
    dataModel.chosenContactText = editedToDoData.chosenContactText;
    dataModel.referralTypeDisplay = editedToDoData.referralTypeDisplay;
    dataModel.referralTypeCode = editedToDoData.referralTypeCode;
    dataModel.isPeriodDate = editedToDoData.isPeriodDate;
    dataModel.startDate = editedToDoData.startDate;
    dataModel.endDate = editedToDoData.endDate;
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
    if (editedToDoData.focusReference != "") {
      dataModel.focusReference = Reference(
          reference: editedToDoData.focusReference);
    }
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
        todoModel.referralTypeDisplay = dataModel.referralTypeDisplay;
        todoModel.referralTypeCode = dataModel.referralTypeCode;
        todoModel.isPeriodDate = dataModel.isPeriodDate;
        todoModel.startDate = dataModel.startDate;
        todoModel.endDate = dataModel.endDate;
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
      }

      Debug.printLog("todoId....$todoId");
    }
  }


  getAssignedReferralDataListApi(String id) async {
    List<NoteTableData> noteListDataList = editedToDoData.noteList ?? [];

    if (serverUrlDataList.isNotEmpty) {
      Utils.showDialogForProgress(Get.context!, Constant.txtPleaseWait, Constant.todoMsg);
      for(int j=0;j<serverUrlDataList.length;j++) {
        var listData = await PaaProfiles.getReferralIdWise(serverUrlDataList[j],id);
        if (listData.resourceType == R4ResourceType.Bundle) {
          if (listData != null && listData.total != null &&
              listData.entry != null) {
            for (int i = 0; i < listData.entry.length; i++) {
              var data = listData.entry[i];
              if (data.resource.resourceType ==
                  R4ResourceType.ServiceRequest) {
                var id;
                if (data.resource.id != null) {
                  id = data.resource.id.toString();
                }
                var status = Utils.capitalizeFirstLetter(
                    data.resource.status.toString());
                var priority = Utils.capitalizeFirstLetter(
                    data.resource.priority.toString());
                var startDate;
                var endDate;
                if (data.resource.occurrencePeriod != null) {
                  if (data.resource.occurrencePeriod.start
                      .toString()
                      .isNotEmpty  && data.resource.occurrencePeriod.start != null) {
                    startDate = Utils.getSplitDateFromAPIData(
                        data.resource.occurrencePeriod.start.valueString
                            .toString());
                  }
                  if (data.resource.occurrencePeriod.end
                      .toString()
                      .isNotEmpty && data.resource.occurrencePeriod.end != null) {
                    endDate = Utils.getSplitDateFromAPIData(
                        data.resource.occurrencePeriod.end.valueString
                            .toString());
                  }
                }
                ReferralSyncDataModel referral = ReferralSyncDataModel();
                if (data.resource.requester != null) {
                  if (data.resource.requester.reference != null) {
                    referral.providerId =
                        data.resource.requester.reference.toString().split(
                            "Practitioner/")[1].toString();
                  }

                  if (data.resource.requester.display != null) {
                    referral.providerName =
                        data.resource.requester.display.toString();
                  }
                }
                referral.status = status;
                referral.priority = priority;

                var textReasonCode = "";
                if(data.resource.code != null){
                  if (data.resource.code.text != null && data.resource.code.text != "null" && data.resource.code.text != "") {
                    try {
                      textReasonCode = data.resource.code.text.toString();
                      Debug.printLog("......Text .....$textReasonCode");
                      referral.textReasonCode = textReasonCode;
                    } catch (e) {
                      Debug.printLog("Error For text referral.....");

                    }
                  }
                }
                if (data.resource.subject != null) {
                  try {
                    referral.patientId = data.resource.subject.reference.toString().split("/")[1].toString();
                    referral.patientName = data.resource.subject.display.toString();
                  } catch (e) {
                    try {
                      referral.patientId = editedToDoData.forReference.toString().split("/")[1].toString();
                    } catch (e) {
                      Debug.printLog(e.toString());
                    }
                  }
                }

                /*if (data.resource.requester != null) {
                  try {
                    referral.providerId = data.resource.requester.reference.toString().split("/")[1].toString();
                    referral.providerName = data.resource.requester.display.toString();
                  } catch (e) {
                    try {
                      referral.providerId = editedToDoData.requesterReference.toString().split("/")[1].toString();
                    } catch (e) {
                      Debug.printLog(e.toString());
                    }
                  }
                }*/

                if (data.resource.performer != null) {
                  referral.performerId =
                      data.resource.performer[0].reference.toString().split(
                          "Practitioner/")[1].toString();
                  if (data.resource.performer[0].display != null) {
                    var display = data.resource.performer[0].display;
                    referral.performerName = display;
                  } else {
                    var dataListIndex = Utils.performerList.indexWhere((
                        element) =>
                    element.performerId == referral.performerId)
                        .toInt();
                    if (dataListIndex != -1) {
                      referral.performerName =
                          Utils.performerList[dataListIndex].performerName;
                    }
                  }
                }
                var conditionList = [];
                if (data.resource.reasonReference != null) {
                  conditionList = data.resource.reasonReference;
                }
                List<String> conditionObjectIdList = [];
                for (int i = 0; i < conditionList.length; i++) {
                  var goalId = conditionList[i].reference.toString().split("/")[1]
                      .toString();
                  conditionObjectIdList.add(goalId);
                }
                referral.conditionObjectId = conditionObjectIdList;
                if (data.resource.code.coding[0].code != null &&
                    data.resource.code.coding[0].display != null) {
                  referral.referralTypeCode =
                      data.resource.code.coding[0].code.toString();
                  referral.referralTypeDisplay =
                      data.resource.code.coding[0].display.toString();

                  var referralTypeCodeDataModel =
                  ReferralTypeCodeDataModel(
                      display: referral.referralTypeDisplay ?? "",
                      code: referral.referralTypeCode);
                }


                referral.objectId = id;
                // referral.patientId = Utils.getPatientId();
                // referral.providerId = Utils.getProviderId();

                referral.startDate = startDate;
                referral.endDate = endDate;
                referral.isPeriodDate = true;
                referral.isSync = true;
                referral.isCreated = false;
                referral.qrUrl = serverUrlDataList[j].url;
                referral.token = serverUrlDataList[j].authToken;
                referral.clientId = serverUrlDataList[j].clientId;
                // referral.patientId = serverUrlDataList[j].patientId;
                // referral.providerId = serverUrlDataList[j].providerId;
                // referral.providerName = serverUrlDataList[j].providerFName;

                if(data.resource.identifier != null){
                  if(data.resource.identifier[0] != null) {
                    var identifierData = data.resource.identifier[0];
                    referral.taskId = identifierData.id.toString();
                  }
                }

                if (data.resource.note != null) {
                  var notesList = data.resource.note;
                  referral.notesList.clear();
                  for (int i = 0; i < notesList.length; i++) {
                    var noteTableData = NoteTableData();
                    noteTableData.notes = notesList[i].text.toString();
                    if (notesList[i].authorReference != null) {
                      noteTableData.author = notesList[i].authorReference.display;
                      noteTableData.authorReference = notesList[i].authorReference.reference;
                    }
                    noteTableData.readOnly = false;
                    var date = Utils.getSplitDateFromAPIData(
                        notesList[i].time.toString());
                    noteTableData.date =
                        DateTime(date.year, date.month, date.day);
                    noteTableData.isDelete = true;
                    noteTableData.referralTaskId = id;
                    noteTableData.isCreatedNote = false;
                    noteTableData.isAssignedNote = true;
                    referral.notesList.add(noteTableData);
                  }
                }


                  // referralListData.add(referral);
                  referralData = (referral);
              }
            }
          }
        }
      }
      if(referralData != null){
        ///Type
        if(referralData.referralTypeDisplay != null) {
          selectedCodeType = referralData.referralTypeDisplay.toString();
          codeReferral = referralData.referralTypeCode ?? "" ;
          /*if(Utils.codeList.where((element) => element.display != selectedCodeType).toList().isEmpty){
            Utils.codeList.add(ReferralTypeCodeDataModel(display: selectedCodeType,code: codeReferral));
          }
          Debug.printLog("codeReferral....${codeReferral}");
          Utils.codeList = Utils.codeList.toSet().toList();*/
        }
        ///Dates
        if(referralData.startDate != null){
          periodStartDate = referralData.startDate;
          periodStartDateStr.text = DateFormat(Constant.commonDateFormatDdMmYyyy).format(periodStartDate!);
        }
        if(referralData.endDate != null){
          periodEndDate = referralData.endDate;
          periodEndDateStr.text = DateFormat(Constant.commonDateFormatDdMmYyyy).format(periodEndDate!);
        }
        ///Instructions
        if(referralData.textReasonCode != null && referralData.textReasonCode != "") {
          referralInstructions.text = referralData.textReasonCode.toString();
        }
      }
      await callApiForMarkAsARead(noteListDataList);
      Get.back();
      update();
    }else{
      await callApiForMarkAsARead(noteListDataList);
    }


  }



}