import 'dart:convert';

import 'package:banny_table/db_helper/box/exercise_prescription_data.dart';
import 'package:banny_table/db_helper/box/notes_data.dart';
import 'package:banny_table/db_helper/box/referral_data.dart';
import 'package:banny_table/db_helper/database_helper.dart';
import 'package:banny_table/resources/syncing.dart';
import 'package:banny_table/ui/ExercisePrescription/dataModel/exercisePrescriptionDataModel.dart';
import 'package:banny_table/ui/home/home/controllers/home_controllers.dart';
import 'package:banny_table/ui/referralForm/datamodel/performerData.dart';
import 'package:banny_table/ui/referralForm/datamodel/referralTypeCodeDataModel.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/src/date_picker/date_picker_manager.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/constant.dart';
import '../../goalForm/datamodel/notesData.dart';

class ExercisePrescriptionController extends GetxController {

  // List<GoalTableData> createdGoals = [];

  var selectedStatus = "";
  var selectedStatusFix = "";
  var selectedStatusHint = Constant.pleaseSelect;

  var selectedIntent = "";

  var selectedPriority = "";

  var selectedCodeType = "";
  var selectedCodeTypeHint = Constant.pleaseSelect;

  var textReasonCodeHint = "Please Enter";
  var htmlViewText = "";

  // var selectedPerformer = "";
  // PerformerData selectedPerformer = PerformerData();

  TextEditingController addReferralTypeController = TextEditingController();
  TextEditingController textReasonCode = TextEditingController();
  FocusNode addReferralTypeFocus = FocusNode();
  FocusNode textReasonCodeFocus = FocusNode();
  // TextEditingController notesController = TextEditingController();
  FocusNode notesControllersFocus = FocusNode();
  String notesValue = "";
  QuillController notesController = QuillController.basic();

  // HtmlEditorController htmlEditorController = HtmlEditorController(processOutputHtml: false,processNewLineAsBr: true);



  var arguments = Get.arguments;
  List<NotesData> notesList = [];
  List<int> referralIdListData = [];
  String codeReferral = "";
  var normalStartDateStr = "Start date";
  DateTime? normalStartDate;

  TextEditingController periodStartDateStr = TextEditingController();
  TextEditingController periodEndDateStr = TextEditingController();
  // var periodStartDateStr = "Start date";
  DateTime? periodStartDate = DateTime.now();
  // var periodEndDateStr = "End date";
  DateTime? periodEndDate;

  ExercisePrescriptionSyncDataModel exerciseEditedData = ExercisePrescriptionSyncDataModel();
  var isEdited = false;
  List<NoteTableData> noteDatabaseList = [];

  List<String> performerLists = [];


  @override
  void onInit() {
    initValue();
    super.onInit();
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



  /*void onChangeGoalSelect(GoalTableData goalData, int index) {
    createdGoals[index].isSelected = !createdGoals[index].isSelected;
    // update();
  }*/

  onCancelTap(){
    Get.back();
  }

  onOkTap(){
    update();
    Get.back();
  }

  Future<void> initValue() async {
    var needFalse = true;
    // getGoalList();

    if (arguments != null) {
      if (arguments[0] != null) {
        isEdited = true;
        needFalse = false;
        exerciseEditedData = arguments[0];
        getNoteList(exerciseEditedData.notesList);

        /*if(exerciseEditedData.goalId != null){
          selectedCreatedGoals = await DataBaseHelper.shared.getGoalDataById(exerciseEditedData.goalId!);
        }*/
        if(exerciseEditedData.status != null && exerciseEditedData.status != "") {
          selectedStatus = exerciseEditedData.status.toString();
          selectedStatusFix = exerciseEditedData.status.toString();
          selectedStatusHint = exerciseEditedData.status.toString();
        }

        if(exerciseEditedData.textReasonCode != null && exerciseEditedData.textReasonCode != "") {
          textReasonCode.text = exerciseEditedData.textReasonCode.toString();
          selectedCodeType =  exerciseEditedData.textReasonCode ?? "";
          // Future.delayed(const Duration(milliseconds: 1500), () {
          //   htmlEditorController.insertHtml(exerciseEditedData.textReasonCode ?? "");
          //   Debug.printLog("insertHtml...${exerciseEditedData.textReasonCode.toString()}");
          //   htmlEditorController.insertHtml('<div><ul><li><br></li></ul></div>');
          // });
        }

        if(exerciseEditedData.priority != null) {
          if( exerciseEditedData.priority != "Null"){
            selectedPriority = exerciseEditedData.priority.toString();
          }else{
            selectedPriority = Utils.priorityList[0];
          }
        }else{
          selectedPriority = Utils.priorityList[0];
        }

        if(exerciseEditedData.referralScope != null) {
          selectedCodeType = exerciseEditedData.referralScope.toString();
          selectedCodeTypeHint = exerciseEditedData.referralScope.toString();
          codeReferral = exerciseEditedData.referralCode ?? "" ;

/*          if(Utils.codeList.where((element) => element.display != selectedCodeType).toList().isEmpty){
            Utils.codeList.add(ReferralTypeCodeDataModel(display: selectedCodeType));
          }*/
          Debug.printLog("codeReferral....${codeReferral}");
          // Utils.codeList = Utils.codeList.toSet().toList();
        }

        /*if(exerciseEditedData.performerId != "") {
          var index = Utils.performerList.indexWhere((element) => element.performerId == exerciseEditedData.performerId.toString()).toInt();
          if(index != -1) {
            selectedPerformer = Utils.performerList[index];
          }
        }*/

        if(exerciseEditedData.isPeriodDate){
          /// Found PeriodDate
          if(exerciseEditedData.startDate != null){
            periodStartDate = exerciseEditedData.startDate;
            periodStartDateStr.text = DateFormat(Constant.commonDateFormatDdMmYyyy).format(periodStartDate!);
          }

          if(exerciseEditedData.endDate != null){
            periodEndDate = exerciseEditedData.endDate;
            periodEndDateStr.text= DateFormat(Constant.commonDateFormatDdMmYyyy).format(periodEndDate!);
          }

        }else{
          /// Found Normal start date
          if(exerciseEditedData.startDate != null){
            normalStartDate = exerciseEditedData.startDate;
            normalStartDateStr = DateFormat(Constant.commonDateFormatDdMmYyyy).format(normalStartDate!);
          }
        }
        /*if(exerciseEditedData.goalObjectId != null) {
          if (exerciseEditedData.goalObjectId!.isNotEmpty) {
            for (int i = 0; i < exerciseEditedData.goalObjectId!.length; i++) {
              var objectId = exerciseEditedData.goalObjectId![i];
              var matchedIndex = createdGoals.indexWhere((element) =>
              element.objectId == objectId).toInt();
              if (matchedIndex != -1) {
                createdGoals[matchedIndex].isSelected = true;
              }
            }
          }
        }*/
        // await Debug.printLog("Utils...codeList....${Utils.codeList}  $exerciseEditedData");
        update();
        exerciseEditedData.readonly = false;
      }
      else {
        initFirstTimeData();
        periodStartDateStr.text = DateFormat(Constant.commonDateFormatDdMmYyyy).format(periodStartDate!);
      }
    } else {
      initFirstTimeData();
      periodStartDateStr.text = DateFormat(Constant.commonDateFormatDdMmYyyy).format(periodStartDate!);
    }
  }

  initFirstTimeData(){
    selectedStatus = Constant.statusDraft;
    selectedStatusFix = Constant.statusDraft;
    selectedIntent = Utils.intentList[0];
    selectedPriority = Utils.priorityList[0];
    // selectedCodeType = Utils.codeList[0].display;
    // codeReferral = Utils.codeList[0].code!.toInt();
    // selectedPerformer = Utils.performerList[0];
    // notesList.add(NotesData());
    exerciseEditedData.readonly = false;
    update();

  }
/*  addNotesData(){
    notesList.add(NotesData());
    update();
  }*/
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



  void addNewCodeDataIntoList(String codeType) {

    // Utils.codeList.add(ReferralTypeCodeDataModel(display: codeType));
    Get.back();
    addReferralTypeController.clear();
    update();
  }

  void onChangeCode(int index) {
    // codeReferral = Utils.codeList[index].code ?? "";
    // selectedCodeType = Utils.codeList[index].display;
    // selectedCodeTypeHint = Utils.codeList[index].display;
    Get.back();
    update();
  }

  onChangeNormalDate(DateRangePickerSelectionChangedArgs dateRangePickerSelectionChangedArgs){
    normalStartDate = dateRangePickerSelectionChangedArgs.value;
    normalStartDateStr = DateFormat(Constant.commonDateFormatDdMmYyyy).format(normalStartDate!);

    periodStartDateStr.text = "Start date";
    periodStartDate = null;
    periodEndDateStr.text = "End date";
    periodEndDate = null;
    update();
  }

  onChangePeriodDate(bool isStartDate, DateRangePickerSelectionChangedArgs dateRangePickerSelectionChangedArgs){
    if(isStartDate){
      periodStartDate = dateRangePickerSelectionChangedArgs.value;
      periodStartDateStr.text = DateFormat(Constant.commonDateFormatDdMmYyyy).format(periodStartDate!);
    }else{
      periodEndDate = dateRangePickerSelectionChangedArgs.value;
      periodEndDateStr.text = DateFormat(Constant.commonDateFormatDdMmYyyy).format(periodEndDate!);
    }
    normalStartDateStr = "Start date";
    normalStartDate = null;
    update();
  }

  bool isValidation(){
    if(normalStartDate == null && periodEndDate == null && periodStartDate == null){
      Utils.showToast(Get.context!, "Please choose your occurrence");
      return false;
    }

    if(periodEndDate != null && periodStartDate == null){
      Utils.showToast(Get.context!, "Please choose your period start date");
      return false;
    }

    if(periodEndDate == null && periodStartDate != null){
      Utils.showToast(Get.context!, "Please choose your period end date");
      return false;
    }
    return true;
  }

  insertUpdateData() async {
    String rxId = "";

    // var reasonValue = htmlViewText;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Utils.showDialogForProgress(
          Get.context!, Constant.txtPleaseWait, Constant.dataSyncingRX);
    });
      var reasonValue = textReasonCode.text;
      if (isEdited) {
        exerciseEditedData.status = selectedStatus;
        exerciseEditedData.referralScope = Constant.codeExerciseTherapy;
        exerciseEditedData.textReasonCode = reasonValue;
        exerciseEditedData.referralCode = "229065009";
        exerciseEditedData.priority = Constant.priorityRoutine;
        exerciseEditedData.providerId = exerciseEditedData.providerId;
        exerciseEditedData.providerName = exerciseEditedData.providerName;
        exerciseEditedData.isSync = false;
        if(periodStartDate == null && periodEndDate == null){
          ///Consider This is one is normal date
          exerciseEditedData.isPeriodDate = false;
          exerciseEditedData.startDate = normalStartDate;
        }else{
          ///Consider This is one is period date
          exerciseEditedData.isPeriodDate = true;
          exerciseEditedData.startDate = periodStartDate;
          exerciseEditedData.endDate = periodEndDate;
        }

        exerciseEditedData.notesList.clear();
        for (int i = 0; i < notesList.length; i++) {
          var noteTableData = NoteTableData();
          noteTableData.notes = notesList[i].notes;
          noteTableData.author = notesList[i].author;
          noteTableData.readOnly = false;
          noteTableData.date = notesList[i].date;
          exerciseEditedData.notesList.add(noteTableData);
        }
        List<ExercisePrescriptionSyncDataModel> allSyncingDataList = [exerciseEditedData];
        if(Utils.getPrimaryServerData()!.url != ""){
         String rxId =  await Syncing.callApiForExercisePrescriptionSyncData(allSyncingDataList);
         Debug.printLog("rxId.......$rxId");
        }


        // await DataBaseHelper.shared.updatetableExerciseData(exerciseEditedData);
        Get.back();
        Get.back(result:exerciseEditedData );
        Utils.showToast(Get.context!, "Exercise prescription update successfully");
      }
      else {
        var exerciseData = ExercisePrescriptionSyncDataModel();
        exerciseData.status = selectedStatus;
        exerciseData.isSync = false;
        exerciseData.priority = Constant.priorityRoutine;
        exerciseData.referralScope = Constant.codeExerciseTherapy;
        exerciseData.textReasonCode = reasonValue;
        exerciseData.referralCode = "229065009";
        if (Utils.getPrimaryServerData() != null) {
          exerciseData.qrUrl = Utils.getPrimaryServerData()!.url;
          exerciseData.token = Utils.getPrimaryServerData()!.authToken;
          exerciseData.clientId = Utils.getPrimaryServerData()!.clientId;
          exerciseData.patientId = Utils.getPrimaryServerData()!.patientId;
          exerciseData.providerId = Utils.getPrimaryServerData()!.providerId;
          exerciseData.providerName = "${Utils.getPrimaryServerData()!.providerFName}${Utils.getPrimaryServerData()!.providerLName}";
          exerciseData.patientName = "${Utils.getPrimaryServerData()!.patientFName}${Utils.getPrimaryServerData()!.patientLName}";
        }
        if (normalStartDate != null) {
          exerciseData.isPeriodDate = false;
          exerciseData.startDate = normalStartDate;
        } else {
          exerciseData.isPeriodDate = true;
          exerciseData.startDate = periodStartDate;
          exerciseData.endDate = periodEndDate;
        }

        for (int i = 0; i < notesList.length; i++) {
          var noteTableData = NoteTableData();
          noteTableData.notes = notesList[i].notes;
          noteTableData.author = notesList[i].author;
          noteTableData.readOnly = false;
          noteTableData.date = notesList[i].date;
          exerciseData.notesList!.add(noteTableData);
        }


        List<ExercisePrescriptionSyncDataModel> allSyncingDataList = [exerciseData];
        if(Utils.getPrimaryServerData()!.url != ""){
          rxId = await Syncing.callApiForExercisePrescriptionSyncData(allSyncingDataList);
          exerciseData.objectId = rxId;
          if(  rxId != "null" && rxId != "" && rxId != "NULL" && rxId != "Null") {
            HomeControllers homeControllers = Get.find();
            homeControllers.exerciseListData.add(exerciseData);
            homeControllers.exerciseListDataLocal.add(exerciseData);
            homeControllers.updateMethod();
          }
        }

        Get.back();
        if(  rxId == "null" || rxId == "" || rxId == "NULL" || rxId == "Null") {
          Utils.showErrorDialog(Get.context!,Constant.txtError,Constant.txtErrorRxNotCreated);
        }else{
          Get.back();
          Utils.showToast(Get.context!, "Exercise prescription created successfully");
        }

      }

  }

  void onChangeStatus(String? value) {
    selectedStatus = value ?? "";
    selectedStatusHint = value ?? "";
    update();
  }

  void onChangeIntent(String? value) {
    selectedIntent = value ?? "";
    update();
  }

  void onChangePriority(String? value) {
    selectedPriority = value ?? "";
    update();
  }

 /* void onChangePerformer(dynamic value) {
    selectedPerformer = value ?? Utils.performerList[0];
    update();
  }*/

  /*getGoalList() {
    createdGoals = Hive.box<GoalTableData>(Constant.tableGoal)
        .values
        .toList()
        .where((element) =>
            element.patientId == Utils.getPatientId() && element.objectId != "")
        .toList();

    for (int i = 0; i < createdGoals.length; i++) {
      createdGoals[i].isSelected = false;
    }
    update();
  }*/

  onChangeHTML(String text){
    Debug.printLog("onChangeHTML...$text");
    htmlViewText = text;
  }

  insertSaveAsDraft() async {
    selectedStatus = Constant.statusDraft;
    // await insertUpdateData();
    await checkValidationForToken();
    update();
  }

  insertForSign() async {
    if(selectedStatus == Constant.statusDraft) {
      selectedStatus = Constant.statusActive;
    }
    // await insertUpdateData();
    await checkValidationForToken();
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

  String getDataFromController(){
    final delta = notesController.document.toDelta();
    Debug.printLog('Current HTML content: $notesValue.......  ${delta.toJson()}');
    notesValue = jsonEncode(notesController.document.toDelta().toList());
    return notesValue;
  }

}

