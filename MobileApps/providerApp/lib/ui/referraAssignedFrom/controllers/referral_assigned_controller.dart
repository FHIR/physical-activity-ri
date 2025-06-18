import 'dart:convert';

import 'package:banny_table/db_helper/box/condition_form_data.dart';
import 'package:banny_table/db_helper/box/notes_data.dart';
import 'package:banny_table/db_helper/box/referral_data.dart';
import 'package:banny_table/db_helper/database_helper.dart';
import 'package:banny_table/resources/PaaProfiles.dart';
import 'package:banny_table/resources/syncing.dart';
import 'package:banny_table/ui/conditionForm/datamodel/conditionSyncDataModel.dart';
import 'package:banny_table/ui/home/home/controllers/home_controllers.dart';
import 'package:banny_table/ui/referralForm/datamodel/performerData.dart';
import 'package:banny_table/ui/referralForm/datamodel/referralDataModel.dart';
import 'package:banny_table/ui/referralForm/datamodel/referralTypeCodeDataModel.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/qrScanner/datamodel/serverModelJson.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:fhir/r4/resource/resource.dart';
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

class ReferralAssignedFormController extends GetxController {

  // List<GoalTableData> createdGoals = [];

  var selectedStatus = "";
  var selectedStatusFix = "";
  var selectedStatusHint = Constant.pleaseSelect;

  var selectedIntent = "";

  var selectedPriority = "";
  var selectedPriorityHint = Constant.pleaseSelect;

  var selectedCodeType = "";

  var textReasonCodeHint = "Please Enter";
  TextEditingController textReasonCode = TextEditingController();
  FocusNode textReasonCodeFocus = FocusNode();
  FocusNode searchConditionFocus = FocusNode();
  TextEditingController searchConditionControllers = TextEditingController();

  // var selectedPerformer = "";
  PerformerData selectedPerformer = PerformerData();

  TextEditingController addReferralTypeController = TextEditingController();
  FocusNode addReferralTypeFocus = FocusNode();
  // TextEditingController notesController = TextEditingController();
  FocusNode notesControllersFocus = FocusNode();
  var htmlViewText = "";
  HtmlEditorController htmlEditorController = HtmlEditorController(processOutputHtml: false,processNewLineAsBr: true);
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

  TextEditingController searchNameControllers = TextEditingController();
  FocusNode searchNameFocus = FocusNode();
  List<ConditionSyncDataModel> createdCondition = [];
  List<ServerModelJson> serverUrlDataList = [];

  // List<ConditionTableData> showCondition = [];
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

    getServerDataList();
    if (arguments != null) {
      if(arguments[1] != null){
        createdCondition = arguments[1];
      }else{
        getConditionDataListApiForThisPatient();
      }
    }else{
      getConditionDataListApiForThisPatient();
    }
    getConditionList();
    var needFalse = true;
    // getGoalList();

    if (arguments != null) {
      if (arguments[0] != null) {
        isEdited = true;
        needFalse = false;
        referralEditedData = arguments[0];
        getNoteList(referralEditedData.notesList);

        /*if(referralEditedData.goalId != null){
          selectedCreatedGoals = await DataBaseHelper.shared.getGoalDataById(referralEditedData.goalId!);
        }*/

        if(referralEditedData.status != null) {
          selectedStatus = referralEditedData.status.toString();
          selectedStatusFix = referralEditedData.status.toString();
          selectedStatusHint = referralEditedData.status.toString();

        }

        if(referralEditedData.textReasonCode != null && referralEditedData.textReasonCode != "") {
          textReasonCode.text = referralEditedData.textReasonCode.toString();
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

        if(referralEditedData.priority != null && referralEditedData.priority !=  "" &&referralEditedData.priority != "Null" && referralEditedData.priority != "null") {
          selectedPriority = referralEditedData.priority.toString();
          selectedPriorityHint = referralEditedData.priority.toString();
        }else{
          // selectedPriority = Utils.priorityList[0];
        }

        if(referralEditedData.referralTypeDisplay != null) {
          selectedCodeType = referralEditedData.referralTypeDisplay.toString();
          codeReferral = referralEditedData.referralTypeCode ?? "" ;
          if(Utils.codeList.where((element) => element.display != selectedCodeType).toList().isEmpty){
            Utils.codeList.add(ReferralTypeCodeDataModel(display: selectedCodeType));
          }
          Debug.printLog("codeReferral....${codeReferral}");
          Utils.codeList = Utils.codeList.toSet().toList();
        }

        if(referralEditedData.performerId != "" && referralEditedData.performerId != null ) {
          selectedPerformer.performerId = referralEditedData.performerId!;
          selectedPerformer.performerName = referralEditedData.performerName!;
          // var index = Utils.performerList.indexWhere((element) => element.performerId == referralEditedData.performerId.toString()).toInt();
          // if(index != -1) {
            // selectedPerformer.performerName = Utils.performerList[index].performerName;
          // }
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
        /*if(referralEditedData.goalObjectId != null) {
          if (referralEditedData.goalObjectId!.isNotEmpty) {
            for (int i = 0; i < referralEditedData.goalObjectId!.length; i++) {
              var objectId = referralEditedData.goalObjectId![i];
              var matchedIndex = createdGoals.indexWhere((element) =>
              element.objectId == objectId).toInt();
              if (matchedIndex != -1) {
                createdGoals[matchedIndex].isSelected = true;
              }
            }
          }
        }*/
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
    selectedStatus = Constant.statusDraft;
    selectedPriorityHint = Utils.priorityList[0];
    selectedIntent = Utils.intentList[0];
    selectedPriority = Utils.priorityList[0];
    selectedCodeType = Utils.codeList[0].display;
    codeReferral = Utils.codeList[0].code ?? "";
    selectedPerformer.performerName = Utils.performerList[0].performerName;
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
      notesList.add(NotesData(
          isDelete: false,
          author: Utils.getFullName(),
          notes: getDataFromController(),
          date: DateTime.now(),
      authorReference: "Practitioner/${Utils.getProviderId()}"));
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
    // if(selectedPerformer.performerId != "" && selectedPerformer.performerName != "") {
      // await insertUpdateData();
      await checkValidationForToken();
    // }else{
    //   Utils.showToast(Get.context!, "Please select Restricted to");
    //   Debug.printLog("Please selected  ");
    // }
  }

  insertUpdateData () async {
    var reasonValue = textReasonCode.text;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Utils.showDialogForProgress(
          Get.context!, Constant.txtPleaseWait, Constant.dataSyncingReferral);
    });
    if (isEdited) {
      referralEditedData.status = selectedStatus;
      referralEditedData.priority = selectedPriority;
      referralEditedData.referralTypeDisplay = selectedCodeType;
      referralEditedData.textReasonCode = reasonValue;
      referralEditedData.performerId = selectedPerformer.performerId;
      referralEditedData.performerName = selectedPerformer.performerName;
      referralEditedData.referralTypeCode = codeReferral;
      // referralEditedData.patientId = referralEditedData.patientId;
      // referralEditedData.patientName = referralEditedData.patientName;
      referralEditedData.isSync = false;
      var selectedGoalData = createdCondition.where((element) => element.isSelected).toList();
      List<String> conditionObjectIdList = [];
      if(selectedGoalData.isNotEmpty){
        for (int i = 0; i < selectedGoalData.length; i++) {
          conditionObjectIdList.add(selectedGoalData[i].objectId.toString());
        }
      }
      referralEditedData.conditionObjectId = conditionObjectIdList;
      // referralEditedData.isCreated = false;
      if(periodStartDate == null && periodEndDate == null){
        ///Consider This is one is normal date
        referralEditedData.isPeriodDate = false;
        referralEditedData.startDate = normalStartDate;
      }else{
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
        referralEditedData.notesList.add(noteTableData);
      }

      List<ReferralSyncDataModel> allSyncingDataList = [referralEditedData];
      if(Utils.getPrimaryServerData()!.url != ""){
        String id = await Syncing.callApiForReferralSyncData(allSyncingDataList,referralEditedData.isCreated,allSyncingDataList[0].qrUrl!, (taskId) {
          Debug.printLog("taskId....$taskId");
          referralEditedData.taskId = taskId;
        });
        Debug.printLog("........$id");
      }
      Utils.showToast(Get.context!, "Referral update successfully");
      Get.back();
      Get.back(result:referralEditedData );
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
      referralEditedData.patientId = Utils.getPatientId();
      referralEditedData.patientName = "${Utils.getPatientFName()} ${Utils.getPatientLName()}";
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
        noteTableData.readOnly = false;
        noteTableData.date = DateTime(nowDate.year, nowDate.month, nowDate.day);
        noteTableData.isDelete = true;
        // noteTableData.isAssignedNote = true;
        noteTableData.isCreatedNote = true;
        noteTableData.isAssignedNote = false;
        referralData.notesList.add(noteTableData);
        // await DataBaseHelper.shared.insertNoteData(noteTableData);
      }
      String referralId = "";

      List<ReferralSyncDataModel> allSyncingDataList = [referralData];
      if(Utils.getPrimaryServerData()!.url != ""){
        referralId = await Syncing.callApiForReferralSyncData(allSyncingDataList,referralEditedData.isCreated,allSyncingDataList[0].qrUrl!, (taskId) {
          Debug.printLog("taskId....$taskId");
          referralData.taskId = taskId;
        });
        referralData.objectId = referralId;
        if(referralId != ""){
          HomeControllers homeControllers = Get.find();
          homeControllers.referralListData.add(referralData);
          homeControllers.referralListDataLocal.add(referralData);
        }
      }
      Get.back();
      Utils.showToast(Get.context!, "Referral is saved successfully");

    }
    Get.back();
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
    selectedPerformer.dob = Utils.performerList[index].dob;
    selectedPerformer.gender = Utils.performerList[index].gender;
    Debug.printLog("onChangeAssignedTo...${selectedPerformer.performerName}  ${selectedPerformer.performerId}");
    Get.back();
    searchNameControllers.clear();
    update();*/

    try {
      selectedPerformer.performerName = restrictedDataList[index].performerName ?? "";
      selectedPerformer.performerId = restrictedDataList[index].performerId;
      selectedPerformer.dob = restrictedDataList[index].dob;
      selectedPerformer.gender = restrictedDataList[index].gender;
    } catch (e) {
      Debug.printLog(e.toString());
    }
    Debug.printLog("onChangeAssignedTo...${selectedPerformer.performerName}  ${selectedPerformer.performerId}");
    Get.back();
    searchNameControllers.clear();
    getRestrictedData("", update);
    update();

  }

  onChangeHTML(String text){
    Debug.printLog("onChangeHTML...$text");
    htmlViewText = text;
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
              if (createdCondition
                  .where((element) => element.objectId == id)
                  .toList()
                  .isEmpty) {
                createdCondition.add(conditionData);
              }
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
    if(serverUrlDataList.isNotEmpty){
      getRestrictedData("",update);
    }
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


  String getDataFromController(){
    final delta = notesController.document.toDelta();
    Debug.printLog('Current HTML content: $notesValue.......  ${delta.toJson()}');
    notesValue = jsonEncode(notesController.document.toDelta().toList());
    return notesValue;
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
    update();
  }
}

