import 'dart:convert';

import 'package:banny_table/db_helper/box/goal_data.dart';
import 'package:banny_table/db_helper/box/notes_data.dart';
import 'package:banny_table/db_helper/database_helper.dart';
import 'package:banny_table/resources/PaaProfiles.dart';
import 'package:banny_table/resources/syncing.dart';
import 'package:banny_table/ui/carePlanForm/datamodel/carePlanSyncDataModel.dart';
import 'package:banny_table/ui/goalForm/datamodel/goalDataModel.dart';
import 'package:banny_table/ui/home/home/controllers/home_controllers.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/qrScanner/datamodel/serverModelJson.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:fhir/r4.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl/intl.dart';
// import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../db_helper/box/care_plan_form_data.dart';
import '../../../utils/debug.dart';
import '../../goalForm/datamodel/notesData.dart';

class CarePlanController extends GetxController {
  var selectedStatus = "";
  String selectedStatusFix = "";
  var selectedStatusHint = Constant.pleaseSelect;
  TextEditingController onSetDateController = TextEditingController();
  TextEditingController abatementController = TextEditingController();
  TextEditingController textFirstController = TextEditingController();
  // TextEditingController notesController = TextEditingController();
  FocusNode textFirstFocus = FocusNode();
  FocusNode notesControllersFocus = FocusNode();
  List<GoalSyncDataModel> createdGoals = [];
/*  HtmlEditorController htmlEditorController = HtmlEditorController(
    processInputHtml: false,
    processOutputHtml: false,
    processNewLineAsBr: false);*/
  QuillController htmlEditorController = QuillController.basic();

  String notesValue = "";
  QuillController notesController = QuillController.basic();



  // QuillEditorController htmlEditorController = QuillEditorController();
  var selectedCarePlanGoalStatus = "";

  var selectedDateFormat = DateTime.now();
  TextEditingController periodStartDateStr = TextEditingController();
  TextEditingController periodEndDateStr = TextEditingController();
  var selectTextFirst = "Enter Text";
  DateTime? periodStartDate = DateTime.now();
  DateTime? periodEndDate;

  var editedCarePlanData = CarePlanSyncDataModel();
  var arguments = Get.arguments;
  var isEdited = false;
  var isAdd = false;
  List<NotesData> notesList = [];
  List<NoteTableData> noteDatabaseList = [];
  var htmlViewText = "";

  List<ServerModelJson> serverUrlDataList = [];


  onChangeHTML(String text){
    Debug.printLog("onChangeHTML...$text");
    htmlViewText = text;
  }


  @override
  void onInit() {
    super.onInit();
    if (arguments != null) {
      if(arguments[1] != null){
        createdGoals = arguments[1];
      }else{
        getServerDataList();
        getGoalDataListApi();
      }
    }else{
      getServerDataList();
      getGoalDataListApi();
    }

    getGoalList();
    if (arguments != null) {
      if (arguments[0] != null) {
        editedCarePlanData = arguments[0];
        isEdited = true;
        getNoteList(editedCarePlanData.notesList);
        if (editedCarePlanData.text != null) {
          // textFirstController.text = editedCarePlanData.text ?? "";
          try{
            List<dynamic> jsonList = jsonDecode(editedCarePlanData.text.toString() ?? "");
            Delta delta = Delta.fromJson(jsonList);
            htmlEditorController = QuillController(
              document: Document.fromDelta(delta),
              selection: TextSelection.collapsed(offset: 0),
            );
            Debug.printLog("insertHtml...${editedCarePlanData.text}");
          }catch(e){
            Debug.printLog("eror....");
          }

        }

        if (editedCarePlanData.status != null && editedCarePlanData.status != "") {
         selectedStatus = editedCarePlanData.status ?? "";
         selectedStatusFix = editedCarePlanData.status ?? "";
         selectedStatusHint = editedCarePlanData.status ?? "";
        }

        if (editedCarePlanData.startDate != null) {
          periodStartDateStr.text = DateFormat(Constant.commonDateFormatDdMmYyyy)
              .format(editedCarePlanData.startDate!);
          periodStartDate = editedCarePlanData.startDate!;
        }


        if (editedCarePlanData.endDate != null) {
          periodEndDateStr.text = DateFormat(Constant.commonDateFormatDdMmYyyy)
              .format(editedCarePlanData.endDate!);
          periodEndDate = editedCarePlanData.endDate!;
        }

        if(editedCarePlanData.goal == null){
          selectedCarePlanGoalStatus = Utils.multipleGoalsListString[0];
        }
        if (editedCarePlanData.goal != null) {
          selectedCarePlanGoalStatus = editedCarePlanData.goal ?? "";
        }
        editedCarePlanData.readOnly = false;

        if(editedCarePlanData.goalObjectId != null) {
          if (editedCarePlanData.goalObjectId!.isNotEmpty) {
            for (int i = 0; i < editedCarePlanData.goalObjectId!.length; i++) {
              var objectId = editedCarePlanData.goalObjectId![i];
              var matchedIndex = createdGoals.indexWhere((element) =>
              element.objectId == objectId).toInt();
              if (matchedIndex != -1) {
                createdGoals[matchedIndex].isSelected = true;
              }
            }
          }
        }
      } else {
        // selectedStatus = Utils.statusInFoList[0];
        selectedCarePlanGoalStatus = Utils.multipleGoalsListString[0];
        editedCarePlanData.readOnly = false;
        periodStartDateStr.text = DateFormat(Constant.commonDateFormatDdMmYyyy).format(periodStartDate!);
        selectedStatus = Constant.statusDraft;
        selectedStatusFix = Constant.statusDraft;
      }

    }
    else {
      periodStartDateStr.text = DateFormat(Constant.commonDateFormatDdMmYyyy).format(periodStartDate!);
      // selectedStatus = Utils.statusInFoList[0];
      selectedCarePlanGoalStatus = Utils.multipleGoalsListString[0];
      selectedStatus = Constant.statusDraft;
      selectedStatusFix = Constant.statusDraft;
    }
    update();
  }

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


  /*Local Storage in add Data*/
  addNotesData(String text, bool isEditNote, int index) async {
    if (isEditNote) {
      notesList[index].notes = getDataFromController();
    } else {
      notesList.add(NotesData(
          isDelete: false,
          author: Utils.getFullName(),
          notes: getDataFromController(),
          date: DateTime.now()));
    }
    notesController.clear();
    Get.back();
    update();
  }

  /*================================*/

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
    selectedStatus = value;
    update();
  }

  void onChangeMultipleGoalStatus(value) {
    selectedCarePlanGoalStatus = value;
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
    String carePlanId = "";
    // if (textFirstController.text.isNotEmpty) {
    // if (htmlViewText.isNotEmpty) {
      /*if (selectedStatus.isNotEmpty) {*/
        // var textValue = textFirstController.text;
        var values = getDataFromMain();
        var textValue = values;
        var status = selectedStatus;
        var goalStatus = selectedCarePlanGoalStatus;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Utils.showDialogForProgress(
              Get.context!, Constant.txtPleaseWait, Constant.dataSyncingCarePlan);
        });
        if (isEdited) {
          editedCarePlanData.text = textValue;
          editedCarePlanData.status = status;
          editedCarePlanData.startDate = periodStartDate;
          editedCarePlanData.endDate = periodEndDate;
          editedCarePlanData.goal = goalStatus;
          editedCarePlanData.readOnly = false;
          editedCarePlanData.isDelete = false;
          editedCarePlanData.isSync = false;
          editedCarePlanData.providerId = editedCarePlanData.providerId;
          editedCarePlanData.providerName = editedCarePlanData.providerName;

          var selectedGoalData = createdGoals.where((element) => element.isSelected).toList();
          List<String> goalObjectIdList = [];
          if(selectedGoalData.isNotEmpty){
            for (int i = 0; i < selectedGoalData.length; i++) {
              goalObjectIdList.add(selectedGoalData[i].objectId.toString());
            }
          }
          editedCarePlanData.goalObjectId = goalObjectIdList;
          editedCarePlanData.notesList.clear();
          for (int i = 0; i < notesList.length; i++) {
            var noteTableData = NoteTableData();
            noteTableData.notes = notesList[i].notes;
            noteTableData.author = notesList[i].author;
            noteTableData.readOnly = false;
            noteTableData.date = notesList[i].date;
            editedCarePlanData.notesList!.add(noteTableData);
          }

          List<CarePlanSyncDataModel> allSyncingDataList = [editedCarePlanData];
          if(Utils.getPrimaryServerData()!.url != ""){
           String id = await Syncing.callApiForCarePlanSyncData(allSyncingDataList);
           Debug.printLog("Careplan id .........$id");
          }


          Utils.showToast(Get.context!, "Care plan update successfully");
        }
        else {
          var data = CarePlanSyncDataModel();

          data.text = textValue;
          data.status = status;
          data.startDate = periodStartDate;
          data.endDate = periodEndDate;
          data.goal = goalStatus;
          data.isSync = false;
          var selectedGoalData = createdGoals.where((element) => element.isSelected).toList();
          List<String> goalObjectIdList = [];
          if(selectedGoalData.isNotEmpty){
            for (int i = 0; i < selectedGoalData.length; i++) {
              goalObjectIdList.add(selectedGoalData[i].objectId.toString());
            }
          }
          data.goalObjectId = goalObjectIdList;
          if (Utils.getPrimaryServerData() != null) {
            data.qrUrl = Utils.getPrimaryServerData()!.url;
            data.token = Utils.getPrimaryServerData()!.authToken;
            data.clientId = Utils.getPrimaryServerData()!.clientId;
            data.patientId = Utils.getPrimaryServerData()!.patientId;
            data.providerId = Utils.getPrimaryServerData()!.providerId;
            data.providerName = "${Utils.getPrimaryServerData()!.providerFName}${Utils.getPrimaryServerData()!.providerLName}";
            data.patientName = "${Utils.getPrimaryServerData()!.patientFName}${Utils.getPrimaryServerData()!.patientLName}";
          }

          for (int i = 0; i < notesList.length; i++) {
            var noteTableData = NoteTableData();
            noteTableData.notes = notesList[i].notes;
            noteTableData.author = notesList[i].author;
            noteTableData.readOnly = false;
            noteTableData.date = notesList[i].date;
            data.notesList!.add(noteTableData);
          }
          List<CarePlanSyncDataModel> allSyncingDataList = [data];
          if(Utils.getPrimaryServerData()!.url != ""){
            carePlanId = await Syncing.callApiForCarePlanSyncData(allSyncingDataList);
            data.objectId = carePlanId;
            if(carePlanId != "null" && carePlanId != "" && carePlanId != "NULL" && carePlanId != "Null") {
              HomeControllers homeControllers = Get.find();
              homeControllers.careDataList.add(data);
              homeControllers.careDataListLocal.add(data);
              homeControllers.updateMethod();
            }
          }

          // var insertId = await DataBaseHelper.shared.insertCarePlanData(data);
          if(carePlanId != "null" && carePlanId != "" && carePlanId != "NULL" && carePlanId != "Null") {
            Utils.showToast(Get.context!, "Care plan created successfully");
          }
        }
        // final SharedPreferences pref = await SharedPreferences.getInstance();
        // String? selectedSyncing =
        //     pref.getString(Constant.keySyncing) ?? Constant.realTime;
        Get.back();
        /*String? qrUrl = Preference.shared.getString(Preference.qrUrlData) ?? "";
        if (Utils.getPrimaryServerData() != null) {
          ///Day per week
          await Syncing.carePlanSyncingData(true, []);
        }*/
        if(isEdited){
          Get.back(result: editedCarePlanData);
        }else{
          if(carePlanId == "null" || carePlanId == "" || carePlanId == "NULL" || carePlanId == "Null"){
            Utils.showErrorDialog(Get.context!,Constant.txtError,Constant.txtErrorCarePlanNotCreated);
          }else{
            Get.back();
          }
        }

     /* } else {
        Utils.showToast(Get.context!, "Please set Status");
      }*/
    // }
    // else {
    //   Utils.showToast(Get.context!, "Please set write text");
    // }
  }

  getGoalList() {
    for (int i = 0; i < createdGoals.length; i++) {
      createdGoals[i].isSelected = false;
    }
    update();
  }

  onCancelTap(){
    Get.back();
  }

  onOkTap(){
    update();
    Get.back();
  }

  void onChangeGoalSelect(GoalSyncDataModel goalData, int index) {
    createdGoals[index].isSelected = !createdGoals[index].isSelected;
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
    selectedStatus = Constant.statusDraft;
    // await insertUpdateData();
    await checkValidationForToken();
    update();
  }

  insertForADD() async {
    if(selectedStatus == Constant.statusDraft) {
      selectedStatus = Constant.statusActive;
    }
    // await insertUpdateData();
    if (htmlEditorController.document.toDelta().toList().isNotEmpty) {

      await checkValidationForToken();
    }
    else {
      Utils.showToast(Get.context!, "Please set write text");
    }
  }

  getGoalDataListApi() async {
    createdGoals.clear();
    if (serverUrlDataList.isNotEmpty) {
      for (int j = 0; j < serverUrlDataList.length; j++) {
        var listData = await PaaProfiles.getGoalDataList(serverUrlDataList[j]);
        if (listData.resourceType == R4ResourceType.Bundle) {
          if (listData != null && listData.entry != null) {
            int length = listData.entry.length;
            for (int i = 0; i < length; i++) {
              var data = listData.entry[i];
              if (data.resource.resourceType == R4ResourceType.Goal) {
                var id;
                if (data.resource.id != null) {
                  id = data.resource.id.toString();
                }

                var code = data.resource.target[0].measure.coding[0].code
                    .toString();
                var goalTypeFromAPIData = Utils.multipleGoalsList.where((
                    element) => element.code == code).toList();
                GoalSyncDataModel conditionData = GoalSyncDataModel();
                var expressedBy;
                var expressedDisplay;
                if(data.resource.expressedBy != null){
                  expressedBy = data.resource.expressedBy.reference.toString();
                  expressedDisplay = data.resource.expressedBy.display.toString();
                  conditionData.expressedBy = expressedBy ?? "";
                  conditionData.expressedByDisplay = expressedDisplay ?? "";
                }

                // conditionData.goalId = id;
                conditionData.objectId = id;
                // conditionData.patientId = Utils.getPatientId();
                conditionData.isSync = true;
                conditionData.code = code;
                conditionData.qrUrl = serverUrlDataList[j].url;
                conditionData.token = serverUrlDataList[j].authToken;
                conditionData.clientId = serverUrlDataList[j].clientId;
                conditionData.patientId = serverUrlDataList[j].patientId;
                conditionData.patientName = "${serverUrlDataList[j].patientFName}${serverUrlDataList[j].patientLName}";
                conditionData.providerId = serverUrlDataList[j].providerId;
                conditionData.providerName = serverUrlDataList[j].providerFName;

                conditionData.createdDate = DateTime.now();
                conditionData.isSelected = false;
                var system = data.resource.target[0].measure.coding[0].system
                    .toString();
                conditionData.system = system;
                var actualDescription = data.resource.target[0].measure.coding[0]
                    .display.toString();
                conditionData.actualDescription = actualDescription;

                if (goalTypeFromAPIData.isNotEmpty) {
                  conditionData.multipleGoals = goalTypeFromAPIData[0].goalValue;
                } else {
                  conditionData.multipleGoals =
                      Utils.multipleGoalsList[0].goalValue;
                }
                /*if(data.resource.target != null && data.resource.target.length == 2) {
                if (data.resource.target[1].detailQuantity != null) {
                  var target = data.resource.target[1].detailQuantity.value
                      .toString();
                  conditionData.target = target;
                }
              }*/
                if(data.resource.target != null ) {
                  if(data.resource.target[0].detailQuantity != null){
                    var target = data.resource.target[0].detailQuantity.value
                        .toString();
                    conditionData.target = target;
                  }else if (data.resource.target[1].detailQuantity != null) {
                    var target = data.resource.target[1].detailQuantity.value
                        .toString();
                    conditionData.target = target;
                  }
                }

                if (data.resource.target[0].dueDate != null) {
                  var dueDate;
                  dueDate =
                      DateTime.parse(data.resource.target[0].dueDate.toString());
                  conditionData.dueDate = dueDate;
                }

                var description = data.resource.description.text.toString();
                conditionData.description = description;
                var lifecycleStatus = Utils.capitalizeFirstLetter(
                    data.resource.lifecycleStatus.toString());
                conditionData.lifeCycleStatus = lifecycleStatus;

                if (data.resource.achievementStatus != null) {
                  var achievementStatus = data.resource.achievementStatus
                      .coding[0]
                      .code.toString();
                  conditionData.achievementStatus = achievementStatus;
                }

                if (data.resource.note != null) {
                  var notesList = data.resource.note;
                  for (int i = 0; i < notesList.length; i++) {
                    var noteTableData = NoteTableData();

                    noteTableData.notes = notesList[i].text.toString();
                    if (notesList[i].authorReference != null) {
                      noteTableData.author =
                          notesList[i].authorReference.display;
                    }
                    noteTableData.readOnly = false;
                    noteTableData.date =
                        Utils.getSplitDateFromAPIData(
                            notesList[i].time.toString());
                    noteTableData.isDelete = true;
                    // noteTableData.goalId = insertId;
                    noteTableData.isCreatedNote = notesList[i].authorReference.toString().contains("Practitioner");
                    conditionData.notesList.add(noteTableData);
                    // await DataBaseHelper.shared.insertNoteData(noteTableData);
                  }
                }
                createdGoals.add(conditionData);
              }
            }
          }
        }
      }
    }
    // getGoalDataList(isGoalProgress);
    update();
  }


  getServerDataList(){
    serverUrlDataList = Utils.getServerListPreference().where((element) => element.isSelected && element.providerId != "" && element.patientId != "").toList();
    // serverUrlDataList = Utils.getServerListPreference();
  }


  String getDataFromController(){
    final delta = notesController.document.toDelta();
    Debug.printLog('Current HTML content: $notesValue.......  ${delta.toJson()}');
    notesValue = jsonEncode(notesController.document.toDelta().toList());
    return notesValue;
  }


  String getDataFromMain(){
    final delta = htmlEditorController.document.toDelta();
    Debug.printLog('Current HTML content: $notesValue.......  ${delta.toJson()}');
    htmlViewText = jsonEncode(htmlEditorController.document.toDelta().toList());
    return htmlViewText;
  }

}

