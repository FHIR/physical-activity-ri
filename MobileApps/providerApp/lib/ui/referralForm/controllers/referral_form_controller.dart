import 'dart:convert';
import 'package:banny_table/db_helper/box/condition_form_data.dart';
import 'package:banny_table/db_helper/box/notes_data.dart';
import 'package:banny_table/db_helper/box/referral_data.dart';
import 'package:banny_table/db_helper/database_helper.dart';
import 'package:banny_table/resources/PaaProfiles.dart';
import 'package:banny_table/resources/syncing.dart';
import 'package:banny_table/ui/conditionForm/datamodel/conditionSyncDataModel.dart';
import 'package:banny_table/ui/home/home/controllers/home_controllers.dart';
import 'package:banny_table/ui/referralForm/datamodel/referralDataModel.dart';
import 'package:banny_table/ui/referralForm/datamodel/referralTypeCodeDataModel.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/qrScanner/datamodel/serverModelJson.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:fhir/r4.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
// import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/src/date_picker/date_picker_manager.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/constant.dart';
import '../../goalForm/datamodel/notesData.dart';
import '../datamodel/performerData.dart';

class ReferralFormController extends GetxController {

  // List<GoalTableData> createdGoals = [];

  var selectedStatus = "";
  var selectedStatusHint = Constant.pleaseSelect;

  var selectedIntent = "";

  var selectedPriority = "";
  var selectedPriorityHint = Constant.pleaseSelect;
  var textReasonCodeHint = "Please Enter";
  TextEditingController textReasonCode = TextEditingController();
  FocusNode textReasonCodeFocus = FocusNode();
  List<ServerModelJson> serverUrlDataList = [];


  List<ConditionSyncDataModel> createdCondition = [];
    // List<ConditionTableData> showCondition = [];


  // QuillController controller = QuillController.basic();

  var selectedCodeType = "";

  // var selectedPerformer = "";
  PerformerData selectedPerformer = PerformerData();
  var htmlViewText = "";
  HtmlEditorController htmlEditorController = HtmlEditorController(processOutputHtml: false,processNewLineAsBr: true);


  TextEditingController addReferralTypeController = TextEditingController();
  TextEditingController addReferralCodeController = TextEditingController();
  TextEditingController searchNameControllers = TextEditingController();
  TextEditingController searchConditionControllers = TextEditingController();
  FocusNode searchNameFocus = FocusNode();
  FocusNode searchConditionFocus = FocusNode();
  FocusNode addReferralTypeFocus = FocusNode();
  FocusNode addReferralCodeFocus = FocusNode();
  // TextEditingController notesController = TextEditingController();
  // FocusNode notesControllersFocus = FocusNode();
  String notesValue = "";
  QuillController notesController = QuillController.basic();

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

  ReferralSyncDataModel referralEditedData = ReferralSyncDataModel();
  var isEdited = false;
  List<NoteTableData> noteDatabaseList = [];

  List<String> performerLists = [];
  List<PerformerData> restrictedDataList = [];


  @override
  void onInit() {
    initValue();
    super.onInit();
  }


  getConditionList() {
    for (int i = 0; i < createdCondition.length; i++) {
      createdCondition[i].isSelected = false;
    }
    update();
  }


  void onChangeConditionSelect(ConditionSyncDataModel goalData, int index) {
    createdCondition[index].isSelected = !createdCondition[index].isSelected;
    if(createdCondition[index].isSelected){
      // showCondition.add(createdCondition[index]);
    }else{
      // showCondition.remove(createdCondition[index]);
    }
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
        data.authorReference = noteList[i].authorReference;
        notesList.add(data);
      }
    }
    update();
  }


  onCancelTap(){
    Get.back();
    update();
  }


  onOkTap(){
    update();
    Get.back();
  }

  Future<void> initValue() async {
    // await getServerDataList();
    // await getConditionDataListApiForThisPatient();
    getServerDataList();
    if (arguments != null) {
      if(arguments[1] != null){
        createdCondition = arguments[1];
      }else{
        // await getServerDataList();
        await getConditionDataListApiForThisPatient();
      }
    }else{
      // await getServerDataList();
      await getConditionDataListApiForThisPatient();
    }
    await getConditionList();
    var needFalse = true;
    // getGoalList();

    if (arguments != null) {
      if (arguments[0] != null) {
        isEdited = true;
        needFalse = false;
        referralEditedData = arguments[0];
        getNoteList(referralEditedData.notesList);
        if(referralEditedData.status != null && referralEditedData.status != "") {
          selectedStatus = referralEditedData.status.toString();
          selectedStatusHint = referralEditedData.status.toString();
        }

        if(referralEditedData.textReasonCode != null && referralEditedData.textReasonCode != "") {
          textReasonCode.text = referralEditedData.textReasonCode.toString();
          selectedCodeType =  referralEditedData.textReasonCode ?? "";
        }

        if(referralEditedData.conditionObjectId != null) {
          if (referralEditedData.conditionObjectId!.isNotEmpty) {
            for (int i = 0; i < referralEditedData.conditionObjectId!.length; i++) {
              var objectId = referralEditedData.conditionObjectId![i];
              var matchedIndex = createdCondition.indexWhere((element) =>
              element.objectId == objectId).toInt();
              if (matchedIndex != -1) {
                createdCondition[matchedIndex].isSelected = true;
                if(createdCondition[matchedIndex].isSelected){
                  // showCondition.add(createdCondition[matchedIndex]);
                }
              }
            }
          }
        }

        if(referralEditedData.priority != null && referralEditedData.priority != "") {
          selectedPriority = referralEditedData.priority.toString();
          selectedPriorityHint = referralEditedData.priority.toString();
        }

        if(referralEditedData.referralTypeDisplay != null) {
          selectedCodeType = referralEditedData.referralTypeDisplay.toString();
          codeReferral = referralEditedData.referralTypeCode ?? "" ;
          // if(Utils.codeList.where((element) => element.display == selectedCodeType && element.code == codeReferral).toList().isEmpty){
          if(Utils.codeList.where((element) => element.display != selectedCodeType).toList().isEmpty){
            Utils.codeList.add(ReferralTypeCodeDataModel(display: selectedCodeType,code: codeReferral));
          }
          Debug.printLog("codeReferral....${codeReferral}");
          Utils.codeList = Utils.codeList.toSet().toList();
        }

        if(referralEditedData.performerId != "" && referralEditedData.performerId != null ) {
          /*if(Utils.performerList.where((element) => element.performerId != referralEditedData.performerId && element.performerName != referralEditedData.performerName).toList().isNotEmpty){
            PerformerData data = PerformerData();
            data.performerId = referralEditedData.performerId;
            data.performerName = referralEditedData.performerName;
            Utils.performerList.add(data);

          }*/
         /* var index = Utils.performerList.indexWhere((element) => element.performerId == referralEditedData.performerId.toString()).toInt();
          if(index != -1) {
            selectedPerformer = Utils.performerList[index];
          }*/
          selectedPerformer.performerId = referralEditedData.performerId!;
          selectedPerformer.performerName = referralEditedData.performerName!;
        }

        if(referralEditedData.isPeriodDate){
          /// Found PeriodDate
          if(referralEditedData.startDate != null){
            periodStartDate = referralEditedData.startDate;
            periodStartDateStr.text = DateFormat(Constant.commonDateFormatDdMmYyyy).format(periodStartDate!);
          }

          if(referralEditedData.endDate != null){
            periodEndDate = referralEditedData.endDate;
            periodEndDateStr.text = DateFormat(Constant.commonDateFormatDdMmYyyy).format(periodEndDate!);
          }

        }else{
          /// Found Normal start date
          if(referralEditedData.startDate != null){
            normalStartDate = referralEditedData.startDate;
            normalStartDateStr = DateFormat(Constant.commonDateFormatDdMmYyyy).format(normalStartDate!);
          }
        }
        await Debug.printLog("Utils...codeList....${Utils.codeList}  $referralEditedData");
        update();
        referralEditedData.readonly = false;
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
    selectedPriority = Utils.priorityList[0];
    selectedPriorityHint = Utils.priorityList[0];
    selectedStatus = Constant.statusDraft;
    selectedIntent = Utils.intentList[0];
    selectedCodeType = Utils.codeList[0].display;
    codeReferral = Utils.codeList[0].code ?? "";
    // if(Utils.performerList.isNotEmpty) {
    //   selectedPerformer = Utils.performerList[0];
    // }
    // notesList.add(NotesData());
    referralEditedData.readonly = false;
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
        Debug.printLog("insertHtml...$value");
        update();
    }
    update();
  }

  String getDataFromController(){
    final delta = notesController.document.toDelta();
    Debug.printLog('Current HTML content: $notesValue.......  ${delta.toJson()}');
    notesValue = jsonEncode(notesController.document.toDelta().toList());
    return notesValue;
  }



  void addNewCodeDataIntoList(String codeType,String code) {

    // if(codeType != ""){
    //   if(code != ""){
    //     Utils.codeList.add(ReferralTypeCodeDataModel(display: codeType,code: code));
    //     Get.back();
    //     addReferralTypeController.clear();
    //     addReferralCodeController.clear();
    //   }else{
    //     Utils.showToast(Get.context!, "Please Enter a Condition Code");
    //   }
    // }else{
    //   Utils.showToast(Get.context!, "Please Enter a Condition Type");
    // }

    Utils.codeList.add(ReferralTypeCodeDataModel(display: codeType));
    Get.back();
    addReferralTypeController.clear();
    update();
  }

  void onChangeCode(int index) {
    codeReferral = Utils.codeList[index].code ?? "";
    selectedCodeType = Utils.codeList[index].display;
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

  insertForSign() async {
    selectedStatus = Constant.statusActive;
    // if(selectedPerformer.performerId != "" && selectedPerformer.performerName != "") {
      // await insertUpdateData();
      await checkValidationForToken();
    // }else{
    //   Utils.showToast(Get.context!, "Please select Restricted to");
    //   Debug.printLog("Please selected  ");
    // }
  }

  insertUpdateData() async {
    String referralId = "";

    // var reasonValue = htmlViewText;
    var reasonValue = textReasonCode.text;
     // if (selectedPerformer.performerId != "" &&
     //      selectedPerformer.performerName != "") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Utils.showDialogForProgress(
            Get.context!, Constant.txtPleaseWait, Constant.dataSyncingReferral);
      });
        if (isEdited) {
          referralEditedData.status = selectedStatus;
          referralEditedData.priority = selectedPriority;
          referralEditedData.referralTypeDisplay = selectedCodeType;
          referralEditedData.performerId = selectedPerformer.performerId;
          referralEditedData.performerName = selectedPerformer.performerName;
          referralEditedData.referralTypeCode = codeReferral;
          referralEditedData.isSync = false;
          referralEditedData.isCreated = true;
          referralEditedData.textReasonCode = reasonValue;
          referralEditedData.providerId = referralEditedData.providerId;
          referralEditedData.providerName = referralEditedData.providerName;
          referralEditedData.patientId = referralEditedData.patientId;
          referralEditedData.patientName = referralEditedData.patientName;
          var selectedGoalData = createdCondition.where((element) => element.isSelected).toList();
          List<String> conditionObjectIdList = [];
          if(selectedGoalData.isNotEmpty){
            for (int i = 0; i < selectedGoalData.length; i++) {
              conditionObjectIdList.add(selectedGoalData[i].objectId.toString());
            }
          }
          referralEditedData.conditionObjectId = conditionObjectIdList;


          if (periodStartDate == null && periodEndDate == null) {
            ///Consider This is one is normal date
            referralEditedData.isPeriodDate = false;
            referralEditedData.startDate = normalStartDate;
          } else {
            ///Consider This is one is period date
            referralEditedData.isPeriodDate = true;
            referralEditedData.startDate = periodStartDate;
            referralEditedData.endDate = periodEndDate;
          }
          referralEditedData.notesList.clear();
          for (int i = 0; i < notesList.length; i++) {
            var noteTableData = NoteTableData();
            noteTableData.notes = notesList[i].notes;
            noteTableData.author = notesList[i].author;
            noteTableData.readOnly = false;
            noteTableData.date = notesList[i].date;
            noteTableData.authorReference = notesList[i].authorReference;
            referralEditedData.notesList!.add(noteTableData);
          }
          List<ReferralSyncDataModel> allSyncingDataList = [referralEditedData];
          if(Utils.getPrimaryServerData()!.url != ""){
          String id=   await Syncing.callApiForReferralSyncData(allSyncingDataList,false,allSyncingDataList[0].qrUrl!, (taskId) {
            Debug.printLog("taskId....$taskId");
            referralEditedData.taskId = taskId;
          });
          Debug.printLog("referralId...$id");
          }

          // await DataBaseHelper.shared.updateReferralKeyData(referralEditedData);
/*          var noteDataList =
              Hive.box<NoteTableData>(Constant.tableNoteData).values.toList();
          if (noteDataList.isNotEmpty && notesList.isNotEmpty) {
            for (int i = 0; i < notesList.length; i++) {
              // var noteTableData = NoteTableData();
              if (notesList[i].createdReferralId != null) {
                NoteTableData noteData = await DataBaseHelper.shared
                    .getNoteDataID(notesList[i].noteId!);
                noteData.notes = notesList[i].notes;
                noteData.author = notesList[i].author;
                noteData.date = notesList[i].date;
                noteData.isDelete = true;
                noteData.isAssignedNote = false;
                noteData.isCreatedNote = true;
                noteData.createdReferralId = referralEditedData.key;
                await DataBaseHelper.shared.updateNoteData(noteData);
              } else {
                var noteTableData = NoteTableData();
                noteTableData.notes = notesList[i].notes;
                noteTableData.author = notesList[i].author;
                noteTableData.readOnly = false;
                noteTableData.date = notesList[i].date;
                noteTableData.isDelete = true;
                noteTableData.isAssignedNote = false;
                noteTableData.isCreatedNote = true;
                noteTableData.createdReferralId = referralEditedData.key;
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
              noteTableData.isAssignedNote = false;
              noteTableData.isCreatedNote = true;
              noteTableData.createdReferralId = referralEditedData.key;
              await DataBaseHelper.shared.insertNoteData(noteTableData);
            }
          }*/
          Utils.showToast(Get.context!, "Referral update successfully");
          Get.back();
        }
        else {
          var referralData = ReferralSyncDataModel();
          referralData.status = selectedStatus;
          referralData.isSync = false;
          referralData.priority = selectedPriority;
          referralData.performerId = selectedPerformer.performerId;
          referralData.performerName = selectedPerformer.performerName;
          referralData.referralTypeDisplay = selectedCodeType;
          referralData.referralTypeCode = codeReferral;
          referralData.textReasonCode = reasonValue;

          var selectedGoalData = createdCondition.where((element) => element.isSelected).toList();
          List<String> conditionObjectIdList = [];
          if(selectedGoalData.isNotEmpty){
            for (int i = 0; i < selectedGoalData.length; i++) {
              conditionObjectIdList.add(selectedGoalData[i].objectId.toString());
            }
          }
          referralData.conditionObjectId = conditionObjectIdList;
          referralData.isCreated = true;
          if (Utils.getPrimaryServerData() != null) {
            referralData.qrUrl = Utils.getPrimaryServerData()!.url;
            referralData.token = Utils.getPrimaryServerData()!.authToken;
            referralData.clientId = Utils.getPrimaryServerData()!.clientId;
            referralData.patientId = Utils.getPrimaryServerData()!.patientId;
            referralData.providerId = Utils.getPrimaryServerData()!.providerId;
            referralData.providerName =
                "${Utils.getPrimaryServerData()!.providerFName}${Utils.getPrimaryServerData()!.providerLName}";
            referralData.patientName =
                "${Utils.getPrimaryServerData()!.patientFName}${Utils.getPrimaryServerData()!.patientLName}";
          }

          if (normalStartDate != null) {
            referralData.isPeriodDate = false;
            referralData.startDate = normalStartDate;
          } else {
            referralData.isPeriodDate = true;
            referralData.startDate = periodStartDate;
            referralData.endDate = periodEndDate;
          }

          var nowDate = DateTime.now();
          for (int i = 0; i < notesList.length; i++) {
            var noteTableData = NoteTableData();

            noteTableData.notes = notesList[i].notes;
            noteTableData.author = notesList[i].author;
            noteTableData.authorReference = notesList[i].authorReference;
            noteTableData.readOnly = false;
            noteTableData.date =
                DateTime(nowDate.year, nowDate.month, nowDate.day);
            noteTableData.isDelete = true;
            noteTableData.isAssignedNote = false;
            noteTableData.isCreatedNote = true;
            // noteTableData.createdReferralId = insertId;
            referralData.notesList.add(noteTableData);
          }
          List<ReferralSyncDataModel> allSyncingDataList = [referralData];
          if(Utils.getPrimaryServerData()!.url != ""){
            referralId = await Syncing.callApiForReferralSyncData(allSyncingDataList,false,allSyncingDataList[0].qrUrl!, (taskId) {
              Debug.printLog("taskId....$taskId");
              referralData.taskId = taskId;
            });
            referralData.objectId = referralId;
            if(referralId != "null" && referralId != "" && referralId != "NULL" && referralId != "Null"){
              referralData.status = selectedStatus;
              HomeControllers homeControllers = Get.find();
              homeControllers.referralListData.add(referralData);
              homeControllers.referralListDataLocal.add(referralData);
              homeControllers.updateMethod();
            }
          }

        /*          var insertId =
              await DataBaseHelper.shared.insertReferralData(referralData);*/
          Get.back();

          if(referralId == "null" || referralId == "" || referralId == "NULL" || referralId == "Null"){
            Utils.showErrorDialog(Get.context!,Constant.txtError,Constant.txtErrorReferralsNotCreated);
          }else{
            Get.back();
            Utils.showToast(Get.context!, "Referral created successfully");

          }
        }
    // } else {
    //   Utils.showToast(Get.context!, "Please select assign provider");
    // }
  }

  showAlertDialogForRoutingForm(BuildContext context, int insertedId) {
    // set up the button
    Widget yesButton = TextButton(
      child: const Text("Yes"),
      onPressed: () async {
        ReferralData insertedReferralData = await DataBaseHelper.shared.getReferralDataIdWise(insertedId);
        Get.back();
        Get.toNamed(AppRoutes.routingReferral,arguments: [insertedReferralData,null,null]);
      },
    );
    Widget noButton = TextButton(
      child: const Text("No"),
      onPressed: () async {
        ReferralData insertedReferralData = await DataBaseHelper.shared.getReferralDataIdWise(insertedId);
        // insertedReferralData.isAddedRoute = false;
        await DataBaseHelper.shared.updateReferralData(insertedReferralData);
        Get.back();
        Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Routing referral"),
      content: const Text("Do you want to choose performer/recipient?"),
      actions: [
        yesButton,
        noButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
    selectedPriorityHint = value ?? "";
    update();
  }

  void onChangePerformer(dynamic value) {
    selectedPerformer = value ?? Utils.performerList[0];
    update();
  }

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


  getAssignedData(String value,setStateDialog) async {
    // await Utils.getPerformerDataSearchList(value,setStateDialog);
    await getRestrictedData(value,setStateDialog);
    update();
  }

  onChangeAssignedTo(int index){
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

  getConditionData(String value,setStateDialog) async {
    try{
      await getConditionDataListApi(value,setStateDialog);
    }catch(e){
      Debug.printLog("issues!!");
    }
    update();
  }


  getConditionDataListApi(String value ,setStateDialog) async {
    createdCondition.clear();
    setStateDialog((){});
        var listData = await PaaProfiles.searchCondition(
             value);
        if(listData != null) {
          if (listData.resourceType == R4ResourceType.Bundle) {
            // if (listData != null && listData.total != null) {
            if (listData != null && listData.entry != null) {
              int length = listData.entry.length;

              for (int i = 0; i < length; i++) {
                var data = listData.entry[i];
                if (data.resource.resourceType == R4ResourceType.Condition) {
                  var id;
                  if (data.resource.id != null) {
                    id = data.resource.id.toString();
                  }

                  // var goal = data.resource.goal[0].reference.toString();


                  ConditionSyncDataModel conditionData = ConditionSyncDataModel();
                  if (data.resource.verificationStatus != null) {
                    var verificationStatus = Utils.capitalizeFirstLetter(
                        data.resource.verificationStatus.coding[0].code
                            .toString());
                    conditionData.verificationStatus = verificationStatus;
                  }
                  if (data.resource.code != null) {
                    if (data.resource.code.coding[0].display != null) {
                      var display = data.resource.code.coding[0].display
                          .toString();
                      conditionData.display = display;
                    }
                    if (data.resource.code.coding[0].code != null) {
                      var code = data.resource.code.coding[0].code.toString();
                      conditionData.code = code;
                    }
                  }
                  conditionData.objectId = id;
                  conditionData.qrUrl = Utils.getPrimaryServerData()!.url;
                  conditionData.token = Utils.getPrimaryServerData()!.authToken;
                  conditionData.clientId = Utils.getPrimaryServerData()!.clientId;
                  conditionData.patientId = Utils.getPrimaryServerData()!.patientId;
                  conditionData.providerId = Utils.getPrimaryServerData()!.providerId;
                  conditionData.providerName = Utils.getPrimaryServerData()!.providerFName;
                  if (data.resource.abatementDateTime != null) {
                    var abatementDateTime;
                    if (data.resource.abatementDateTime.valueString
                        .toString()
                        .isNotEmpty) {
                      abatementDateTime = Utils.getSplitDateFromAPIData(
                          data.resource.abatementDateTime.valueString.toString());
                      conditionData.abatement = abatementDateTime;
                    }
                  }
                  if (data.resource.onsetDateTime != null) {
                    var onsetDateTime;
                    if (data.resource.onsetDateTime.valueString.isNotEmpty) {
                      onsetDateTime = Utils.getSplitDateFromAPIData(
                          data.resource.onsetDateTime.valueString.toString());
                      conditionData.onset = onsetDateTime;
                    }
                  }
                  if(createdCondition.where((element) => element.isSelected && element.objectId == id).toList().isNotEmpty){
                    conditionData.isSelected = true;
                  }
                   createdCondition.add(conditionData);
                  // var lastUpdateDate = DateTime.parse(data.resource.meta.lastUpdated.toString());
                }
              }
            }
          }
          try{
            setStateDialog((){});
          }catch(e){
            Debug.printLog("issue Update");
          }
        }
    }

  getServerDataList(){
    serverUrlDataList = Utils.getServerListPreference().where((element) => element.isSelected && element.providerId != "" && element.patientId != "").toList();
    /*if(serverUrlDataList.isNotEmpty){
      Utils.getPerformerDataList(serverUrlDataList[0]);
    }*/
    if(serverUrlDataList.isNotEmpty){
      getRestrictedData("",update);
    }
    // serverUrlDataList = Utils.getServerListPreference();
  }

  getConditionDataListApiForThisPatient() async {
    // if(Utils.getPatientId() != "" && Utils.getAPIEndPoint() != "") {
    createdCondition.clear();
    if (serverUrlDataList.isNotEmpty) {
      // conditionDataList = Hive.box<ConditionTableData>(Constant.tableCondition).values.toList().where((element) => element.patientId == serverUrlDataList.where((el) => el.patientId == element.patientId).toList()[0].patientId).toList() ?? [];
      for (int j = 0; j < serverUrlDataList.length; j++) {

        var listData = await PaaProfiles.getConditionActivityList(
            serverUrlDataList[j].patientId, serverUrlDataList[j]);
        if(listData != null) {
          if (listData.resourceType == R4ResourceType.Bundle) {
            // if (listData != null && listData.total != null) {
            if (listData != null && listData.entry != null) {
              int length = listData.entry.length;

              for (int i = 0; i < length; i++) {
                var data = listData.entry[i];
                if (data.resource.resourceType == R4ResourceType.Condition) {
                  var id;
                  if (data.resource.id != null) {
                    id = data.resource.id.toString();
                  }

                  // var goal = data.resource.goal[0].reference.toString();


                  ConditionSyncDataModel conditionData = ConditionSyncDataModel();

                  var textReasonCode = "";
                  if(data.resource.code != null){
                    if (data.resource.code.text != null && data.resource.code.text != "null" && data.resource.code.text != "") {
                      try {
                        textReasonCode = data.resource.code.text.toString();
                        Debug.printLog("......Text .....$textReasonCode");
                        conditionData.detalis = textReasonCode;
                      } catch (e) {
                        Debug.printLog("Error For text referral.....");

                      }
                    }
                  }
                  if (data.resource.verificationStatus != null) {
                    var verificationStatus = Utils.capitalizeFirstLetter(
                        data.resource.verificationStatus.coding[0].code
                            .toString());
                    conditionData.verificationStatus = verificationStatus;
                  }
                  if (data.resource.code != null) {
                    if (data.resource.code.coding[0].display != null) {
                      var display = data.resource.code.coding[0].display
                          .toString();
                      conditionData.display = display;
                    }
                    if (data.resource.code.coding[0].code != null) {
                      var code = data.resource.code.coding[0].code.toString();
                      conditionData.code = code;
                    }
                  }
                  conditionData.objectId = id;
                  // conditionData.patientId = Utils.getPatientId();
                  conditionData.qrUrl = serverUrlDataList[j].url;
                  conditionData.token = serverUrlDataList[j].authToken;
                  conditionData.clientId = serverUrlDataList[j].clientId;
                  conditionData.patientId = serverUrlDataList[j].patientId;
                  conditionData.providerId = serverUrlDataList[j].providerId;
                  conditionData.providerName = serverUrlDataList[j].providerFName;
                  if (data.resource.abatementDateTime != null) {
                    var abatementDateTime;
                    if (data.resource.abatementDateTime.valueString
                        .toString()
                        .isNotEmpty) {
                      abatementDateTime = Utils.getSplitDateFromAPIData(
                          data.resource.abatementDateTime.valueString.toString());
                      conditionData.abatement = abatementDateTime;
                    }
                  }
                  if (data.resource.onsetDateTime != null) {
                    var onsetDateTime;
                    if (data.resource.onsetDateTime.valueString.isNotEmpty) {
                      onsetDateTime = Utils.getSplitDateFromAPIData(
                          data.resource.onsetDateTime.valueString.toString());
                      conditionData.onset = onsetDateTime;
                    }
                  }

                  createdCondition.add(conditionData);
                }
              }
            }
          }
        }
      }
    }
    // await getConditionDataList(isConditionProgress);

    update();
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
    }
    else{
      restrictedDataList.clear();
    }
    try {
      setStateDialog((){
            Debug.printLog("performerLists restrictedDataList....... ${restrictedDataList.toString()}");
          });
    } catch (e) {
      Debug.printLog(e.toString());
    }
    // update();
  }


}


