import 'package:banny_table/db_helper/box/condition_form_data.dart';
import 'package:banny_table/db_helper/box/notes_data.dart';
import 'package:banny_table/db_helper/box/referral_data.dart';
import 'package:banny_table/db_helper/database_helper.dart';
import 'package:banny_table/resources/syncing.dart';
import 'package:banny_table/ui/referralForm/datamodel/referralTypeCodeDataModel.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/src/date_picker/date_picker_manager.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/constant.dart';
import '../../goalForm/datamodel/notesData.dart';
import '../datamodel/performerData.dart';

class ReferralFormController extends GetxController {

  // List<GoalTableData> createdGoals = [];

  var selectedStatus = "";

  var selectedIntent = "";

  var selectedPriority = "";
  var textReasonCodeHint = "Please Enter";
  var selectedCodeType = "";
  TextEditingController textReasonCode = TextEditingController();
  FocusNode textReasonCodeFocus = FocusNode();


  // var selectedPerformer = "";
  PerformerData selectedPerformer = PerformerData();

  TextEditingController addReferralTypeController = TextEditingController();
  FocusNode addReferralTypeFocus = FocusNode();
  TextEditingController notesController = TextEditingController();
  FocusNode notesControllersFocus = FocusNode();


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

  ReferralData referralEditedData = ReferralData();
  var isEdited = false;
  List<NoteTableData> noteDatabaseList = [];

  List<String> performerLists = [];

  List<ConditionTableData> createdCondition = [];

  getConditionList() {
/*    createdCondition = Hive.box<ConditionTableData>(Constant.tableCondition)
        .values
        .toList()
        .where((element) =>
    element.patientId == Utils.getPatientId() && element.conditionID != "")
        .toList();*/

    for (int i = 0; i < createdCondition.length; i++) {
      createdCondition[i].isSelected = false;
    }
    update();
  }


  @override
  void onInit() {
    initValue();
    super.onInit();
  }

  getNoteList(List<NoteTableData> list) async {
    /*noteDatabaseList = Hive.box<NoteTableData>(Constant.tableNoteData)
        .values
        .toList()
        .where((element) => (element.referralId != 0)?element.referralId ==
        int.parse(referralEditedData.objectId.toString())
        :element.referralId == referralEditedData.key)
        .toList();*/

    /*noteDatabaseList = Hive.box<NoteTableData>(Constant.tableNoteData)
        .values
        .toList()
        .where((element) => element.referralId == referralEditedData.key)
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
        data.referralId = referralEditedData.key;
        notesList.add(data);
      }
      await Debug.printLog("getdNoteData");
    }*/

    notesList = [];
    for (int i = 0; i < list.length; i++) {
      var data = list[i];
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
        if(arguments[1] != null){
          createdCondition = arguments[1];
          getConditionList();
        }
        isEdited = true;
        needFalse = false;
        referralEditedData = arguments[0];
        getNoteList(referralEditedData.notesList ?? []);

        /*if(referralEditedData.goalId != null){
          selectedCreatedGoals = await DataBaseHelper.shared.getGoalDataById(referralEditedData.goalId!);
        }*/
        if(referralEditedData.status != null) {
          selectedStatus = referralEditedData.status.toString();
        }

        if(referralEditedData.priority != null) {
          selectedPriority = referralEditedData.priority.toString();
        }

        if(referralEditedData.referralScope != null) {
          selectedCodeType = referralEditedData.referralScope.toString();
          codeReferral = referralEditedData.referralCode ?? "" ;
          if(Utils.codeList.where((element) => element.display != selectedCodeType).toList().isEmpty){
            Utils.codeList.add(ReferralTypeCodeDataModel(display: selectedCodeType));
          }
          Debug.printLog("codeReferral....${codeReferral}");
          Utils.codeList = Utils.codeList.toSet().toList();
        }
        if(referralEditedData.textReasonCode != null && referralEditedData.textReasonCode != "") {
          textReasonCode.text = referralEditedData.textReasonCode.toString();
          // selectedCodeType =  referralEditedData.textReasonCode ?? "";
          // Future.delayed(const Duration(milliseconds: 1500), () {
          //   htmlEditorController.insertHtml(referralEditedData.textReasonCode ?? "");
          //   Debug.printLog("insertHtml...${referralEditedData.textReasonCode.toString()}");
          // htmlEditorController.insertHtml('<div><ul><li><br></li></ul></div>');
          // });
        }

        if(referralEditedData.performerId != "") {
          /*var index = Utils.performerList.indexWhere((element) => element.performerId == referralEditedData.performerId.toString()).toInt();
          if(index != -1) {
            selectedPerformer = Utils.performerList[index];
          }*/
          selectedPerformer.performerId = referralEditedData.performerId;
          selectedPerformer.performerName = referralEditedData.performerName;
        }

        if(referralEditedData.conditionObjectId != null) {
          if (referralEditedData.conditionObjectId!.isNotEmpty) {
            for (int i = 0; i < referralEditedData.conditionObjectId!.length; i++) {
              var objectId = referralEditedData.conditionObjectId![i];
              var matchedIndex = createdCondition.indexWhere((element) =>
              element.conditionID == objectId).toInt();
              if (matchedIndex != -1) {
                createdCondition[matchedIndex].isSelected = true;
                if(createdCondition[matchedIndex].isSelected){
                  // showCondition.add(createdCondition[matchedIndex]);
                }
              }
            }
          }
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
    selectedStatus = Utils.statusList[0];
    selectedIntent = Utils.intentList[0];
    selectedPriority = Utils.priorityList[0];
    selectedCodeType = Utils.codeList[0].display;
    codeReferral = Utils.codeList[0].code ?? "";
    selectedPerformer = Utils.performerList[0];
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

  deleteNoteListData(int? noteId, int index) async {
    notesList.removeAt(index);

    if (noteId != null) {
      await DataBaseHelper.shared.deleteSingleNoteData(noteId);
    }
    update();
  }

  editNoteDataController(String value) {
    notesController.text = value;
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

  insertUpdateData() async {
    if (isEdited) {
      referralEditedData.status = selectedStatus;
      referralEditedData.priority = selectedPriority;
      referralEditedData.referralScope = selectedCodeType;
      referralEditedData.performerId = selectedPerformer.performerId;
      referralEditedData.performerName = selectedPerformer.performerName;
      referralEditedData.referralCode = codeReferral;
      referralEditedData.isSync = false;
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

      await DataBaseHelper.shared.updateReferralKeyWiseData(referralEditedData,referralEditedData.key);
      var noteDataList = Hive.box<NoteTableData>(Constant.tableNoteData).values.toList();
      if (noteDataList.isNotEmpty && notesList.isNotEmpty) {
        for (int i = 0; i < notesList.length; i++) {
          // var noteTableData = NoteTableData();
          if (notesList[i].referralId != null) {
            NoteTableData noteData = await DataBaseHelper.shared.getNoteDataID(notesList[i].noteId!);
            noteData.notes = notesList[i].notes;
            noteData.author = notesList[i].author;
            noteData.date = notesList[i].date;
            noteData.isDelete = true;
            noteData.referralId = referralEditedData.key;
            await DataBaseHelper.shared.updateNoteData(noteData);
          } else {
            var noteTableData = NoteTableData();

            noteTableData.notes = notesList[i].notes;
            noteTableData.author = notesList[i].author;
            noteTableData.readOnly = false;
            noteTableData.date = notesList[i].date;
            noteTableData.isDelete = true;
            noteTableData.referralId = referralEditedData.key;
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
          noteTableData.referralId = referralEditedData.key;
          await DataBaseHelper.shared.insertNoteData(noteTableData);
        }
      }
      Utils.showToast(Get.context!, "Referral update successfully");
      Get.back();
    }
    else {
      var referralData = ReferralData();
      referralData.status = selectedStatus;
      referralData.isSync = false;
      referralData.priority = selectedPriority;
      referralData.performerId = selectedPerformer.performerId;
      referralData.performerName = selectedPerformer.performerName;
      referralData.referralScope = selectedCodeType;
      referralData.referralCode = codeReferral;
      if (normalStartDate != null) {
        referralData.isPeriodDate = false;
        referralData.startDate = normalStartDate;
      } else {
        referralData.isPeriodDate = true;
        referralData.startDate = periodStartDate;
        referralData.endDate = periodEndDate;
      }
      if(Utils.getPrimaryServerData() != null){
        referralData.qrUrl = Utils.getPrimaryServerData()!.url;
        referralData.token = Utils.getPrimaryServerData()!.authToken;
        referralData.clientId = Utils.getPrimaryServerData()!.clientId;
        referralData.patientId = Utils.getPrimaryServerData()!.patientId;
        referralData.patientName = "${Utils.getPrimaryServerData()!.patientFName}${Utils.getPrimaryServerData()!.patientFName}";
      }

      var nowDate = DateTime.now();

      var insertId = await DataBaseHelper.shared.insertReferralData(referralData);
      for (int i = 0; i < notesList.length; i++) {
        var noteTableData = NoteTableData();

        noteTableData.notes = notesList[i].notes;
        noteTableData.author = notesList[i].author;
        noteTableData.readOnly = false;
        noteTableData.date = DateTime(nowDate.year, nowDate.month, nowDate.day);
        noteTableData.isDelete = true;
        noteTableData.referralId = insertId;
        await DataBaseHelper.shared.insertNoteData(noteTableData);
      }
      Get.back();
      Utils.showToast(Get.context!, "Referral is saved successfully");

    }
    if (Utils.getAPIEndPoint() != "") {
      await Syncing.referralSyncingData(true, []);
    }
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
}

