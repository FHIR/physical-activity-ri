import 'dart:convert';

import 'package:fhir/r4.dart';
import 'package:fhir/r4/resource/resource.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:horizontal_data_table/refresh/pull_to_refresh/pull_to_refresh.dart';

import '../../../db_helper/box/care_plan_form_data.dart';
import '../../../db_helper/box/condition_form_data.dart';
import '../../../db_helper/box/goal_data.dart';
import '../../../db_helper/box/notes_data.dart';
import '../../../db_helper/box/referral_data.dart';
import '../../../db_helper/database_helper.dart';
import '../../../fhir_auth/r4.dart';
import '../../../providers/api.dart';
import '../../../resources/PaaProfiles.dart';
import '../../../utils/color.dart';
import '../../../utils/constant.dart';
import '../../../utils/debug.dart';
import '../../../utils/font_style.dart';
import '../../../utils/preference.dart';
import '../../../utils/sizer_utils.dart';
import '../../../utils/utils.dart';
import '../../goalForm/datamodel/goalDataModel.dart';
import '../../referralForm/datamodel/referralTypeCodeDataModel.dart';
import '../../toDoList/dataModel/codeModel.dart';
import '../../toDoList/dataModel/toDoDataListModel.dart';
import '../../welcomeScreen/healthProvider/selectPrimaryServer/datamodel/serverModelJson.dart';
import '../datamodel/exerciseData.dart';

class MixedController extends GetxController {

  RefreshController refreshController = RefreshController(initialRefresh: false);

  String filterGoalFilter = "";

  List<ConditionTableData> conditionDataList = [];
  bool isConditionLoading = false;

  List<CarePlanTableData> careDataList = [];
  bool isCarePlanLoading = false;

  // List<GoalTableData> goalDataList = [];
  bool isGoalLoading = false;
  List goalDataList = [];

  List<ReferralData> referralListData = [];
  bool isReferralLoading = false;

  List<ServerModelJson> serverUrlDataList = [];
  final keyFabButton = GlobalKey<ExpandableFabState>();

  List<ExerciseData> rxDataList = [];
  bool isRxLoading = false;

  @override
  void onInit() {
    getServerDataList();
    if(serverUrlDataList.isEmpty){
      callGoalAPI();
    }
    callAllAPI(false);
    super.onInit();
  }

  loadingON(){
    isConditionLoading = true;
    isCarePlanLoading = true;
    isGoalLoading = true;
    isReferralLoading = true;
    isRxLoading = true;
    update();
  }

  getServerDataList(){
    serverUrlDataList = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
  }

  callAllAPI(bool isShowDialogExpire) async {
    await getServerDataList();
    await loadingON();
    await Utils.isExpireTokenAPICall(Constant.screenTypeMixed,(value) async {
      if (!value) {
        await callConditionAPI();
        await callGoalAPI();
        await callCarePlanAPI();
        await callRxDataAPI();
        await callReferralAPI();
      }
    }).then((value) async {
      if (!value) {
        await callConditionAPI();
        await callGoalAPI();
        await callCarePlanAPI();
        await callRxDataAPI();
        await callReferralAPI();
      }
    });
  }

  ///For Condition Data
  callConditionAPI() async {
    // await getConditionDataList();
    await getConditionDataListApi();
    isConditionLoading = false;
    update();
  }
/*  getConditionDataList() {
    conditionDataList = Hive.box<ConditionTableData>(Constant.tableCondition)
        .values
        .toList()
        .where((element) => serverUrlDataList.where((element1) => element.patientId == element1.patientId).toList().isNotEmpty)
        .toList();
    update();
  }*/
  getConditionDataListApi() async {

    conditionDataList.clear();
    if (serverUrlDataList.isNotEmpty) {
      for (int j = 0; j < serverUrlDataList.length; j++) {
        var listData = await PaaProfiles.getConditionActivityList(
            // Utils.getPatientId(), serverUrlDataList[j]);
            serverUrlDataList[j].patientId, serverUrlDataList[j]);
        if (listData.resourceType == R4ResourceType.Bundle) {
          if (listData != null && listData.entry != null) {
            int length = listData.entry.length;
            for (int i = 0; i < length; i++) {
              var data = listData.entry[i];
              if (data.resource.resourceType == R4ResourceType.Condition) {
                var id;
                if (data.resource.id != null) {
                  id = data.resource.id.toString();
                }
                ConditionTableData conditionData = ConditionTableData();

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
                conditionData.conditionID = id;
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
                conditionData.qrUrl = serverUrlDataList[j].url;
                conditionData.token = serverUrlDataList[j].authToken;
                conditionData.clientId = serverUrlDataList[j].clientId;
                conditionData.patientId = serverUrlDataList[j].patientId;
                conditionData.patientName =
                "${serverUrlDataList[j].patientFName} ${serverUrlDataList[j].patientLName}";


                conditionDataList.add(conditionData);

/*                conditionDataList = Hive.box<ConditionTableData>(Constant.tableCondition)
                    .values
                    .toList()
                    .where((element) => serverUrlDataList.where((element1) => element.patientId == element1.patientId).toList().isNotEmpty)
                    .toList();

                if (conditionDataList
                    .where((element) => element.conditionID == id)
                    .toList()
                    .isEmpty) {
                  await DataBaseHelper.shared
                      .insertConditionData(conditionData);
                } else {
                  var key = conditionDataList
                      .where((element) =>
                  element.conditionID == id &&
                      element.qrUrl == serverUrlDataList[j].url)
                      .toList();
                  await DataBaseHelper.shared.updateConditionDataKeyWiseData(
                      conditionData, key[0].key);
                }*/
              }
            }
          }
        }
      }
    }
    // getConditionDataList();
    update();
  }


  ///For Goal Data
  callGoalAPI() async {
    // getGoalDataList();
    await getGoalDataListApi(isFirstTimeLoad: true);
    isGoalLoading = false;
    update();
  }

  callApiForHive(){
    if(serverUrlDataList.isEmpty){
      goalDataList = Hive.box<GoalTableData>(Constant.tableGoal).values.toList();
    }
    update();
  }
  getGoalDataListApi({bool isFirstTimeLoad = false}) async {
    goalDataList.clear();
    if(serverUrlDataList.isNotEmpty) {
      for(int j=0;j<serverUrlDataList.length;j++){
        var listData = await PaaProfiles.getGoalDataList(serverUrlDataList[j]);
        if (listData.resourceType == R4ResourceType.Bundle) {
          if (listData != null && listData.entry != null) {
            for (int i = 0; i < listData.entry.length; i++) {
              var data = listData.entry[i];
              if (data.resource.resourceType == R4ResourceType.Goal) {
                var id;
                if (data.resource.id != null) {
                  id = data.resource.id.toString();
                }
                // GoalTableData conditionData = GoalTableData();
                GoalSyncDataModel conditionData = GoalSyncDataModel();

                var code = data.resource.target[0].measure.coding[0].code
                    .toString();
                var goalTypeFromAPIData = Utils.multipleGoalsList.where((
                    element) => element.code == code).toList();
                var expressedDisplay;
                var expressedBy;
                if (data.resource.expressedBy != null) {
                  expressedBy = data.resource.expressedBy.reference
                      .toString();
                  expressedDisplay = data.resource.expressedBy.display
                      .toString();
                  conditionData.expressedBy = expressedBy;
                  conditionData.expressedByDisplay = expressedDisplay;
                }
                // conditionData.goalId = id;
                conditionData.objectId = id;
                conditionData.patientId = serverUrlDataList[j].patientId;
                conditionData.isSync = true;
                conditionData.code = code;
                conditionData.createdDate = DateTime.now();
                var system = data.resource.target[0].measure.coding[0].system
                    .toString();
                conditionData.system = system;
                var actualDescription = data.resource.target[0].measure
                    .coding[0]
                    .display.toString();
                conditionData.actualDescription = actualDescription;

                if (goalTypeFromAPIData.isNotEmpty) {
                  conditionData.multipleGoals =
                      goalTypeFromAPIData[0].goalValue;
                } else {
                  conditionData.multipleGoals =
                      Utils.multipleGoalsList[0].goalValue;
                }
                String referenceValues = "";

                try {
                  if (data.resource.expressedBy.reference.split("/")[0]
                      .toString() == "Practitioner") {
                    conditionData.isEditable = false;
                    referenceValues = data.resource.expressedBy.reference.split("/")[0]
                        .toString();
                  }
                  if (data.resource.expressedBy.reference.split("/")[0]
                      .toString() == "Patient") {
                    conditionData.isEditable = true;
                  }

                  /*if(data.resource.expressedBy.reference.split("/")[0].toString() == "Patient"
                    && data.resource.expressedBy.reference.split("/")[1].toString() != Utils.getPatientId()
                ){
                  conditionData.isEditable = false;
                }

                if(data.resource.expressedBy.reference.split("/")[0].toString() == "Patient"
                    && data.resource.expressedBy.reference.split("/")[1].toString() == Utils.getPatientId()
                ){
                  conditionData.isEditable = true;
                }*/
                } catch (e) {
                  Debug.printLog(e.toString());
                }
                if
                (data.resource.target[0].detailQuantity != null) {
                  var target = data.resource.target[0].detailQuantity.value
                      .toString();
                  conditionData.target = target;
                }
                if (data.resource.target[0].dueDate != null) {
                  var dueDate;
                  dueDate =
                      DateTime.parse(
                          data.resource.target[0].dueDate.toString());
                  conditionData.dueDate = dueDate;
                }

                var description = data.resource.description.text.toString();
                conditionData.description = description;

                var lifecycleStatus = Utils.capitalizeFirstLetter(
                    data.resource.lifecycleStatus.toString());
                conditionData.lifeCycleStatus = lifecycleStatus;

                /*var achievementStatus = data.resource.achievementStatus.coding[0]
                  .code.toString();
              conditionData.achievementStatus = achievementStatus;*/
                if (data.resource.achievementStatus != null) {
                  var achievementStatus = data.resource.achievementStatus
                      .coding[0]
                      .code.toString();
                  conditionData.achievementStatus = achievementStatus;
                }

                conditionData.qrUrl = serverUrlDataList[j].url;
                conditionData.token = serverUrlDataList[j].authToken;
                conditionData.clientId = serverUrlDataList[j].clientId;
                conditionData.patientId = serverUrlDataList[j].patientId;
                conditionData.patientName =
                "${serverUrlDataList[j].patientFName}${serverUrlDataList[j]
                    .patientLName}";

                if ( !(referenceValues == "Practitioner" && lifecycleStatus == Constant.lifeCycleProposed)) {
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
                      noteTableData.isCreatedNote = notesList[i].authorReference.toString().contains("Patient");
                      conditionData.notesList!.add(noteTableData);
                    }
                  }
                  goalDataList.add(conditionData);
                }

                // conditionData.smartFhirClient = serverUrlDataList[j].smartFhirClient;
                // conditionData.fhirClient = serverUrlDataList[j].fhirClientUnSecure;
                /*goalDataList = Hive
                    .box<GoalTableData>(Constant.tableGoal)
                    .values
                    .toList()
                    .where((element) =>
                serverUrlDataList
                    .where((element1) =>
                element.patientId == element1.patientId)
                    .toList()
                    .isNotEmpty)
                    .toList();
                if ( !(referenceValues == "Practitioner" && lifecycleStatus == Constant.lifeCycleProposed)) {
                  if (goalDataList
                      .where((element) => element.objectId == id)
                      .toList()
                      .isEmpty) {
                    var insertId = await DataBaseHelper.shared.insertGoalData(
                        conditionData);
                    if (data.resource.note != null) {
                      var notesList = data.resource.note;
                      for (int i = 0; i < notesList.length; i++) {
                        var noteTableData = NoteTableData();

                        noteTableData.notes = notesList[i].text.toString();
                        // noteTableData.author = Utils.getFullName();
                        if (notesList[i].authorReference != null) {
                          noteTableData.author =
                              notesList[i].authorReference.display;
                        }
                        noteTableData.readOnly = false;
                        noteTableData.date =
                            Utils.getSplitDateFromAPIData(
                                notesList[i].time.toString());
                        noteTableData.isDelete = true;
                        noteTableData.goalId = insertId;
                        noteTableData.isCreatedNote = notesList[i].authorReference.toString().contains("Patient");
                        await DataBaseHelper.shared.insertNoteData(
                            noteTableData);
                      }
                    }
                  }
                  else {
                    var key = goalDataList.where((element) =>
                    element.objectId == id &&
                        element.qrUrl == serverUrlDataList[j].url).toList();
                    var insertId = 0;
                    if (key.isNotEmpty) {
                      insertId = key[0].key;
                      await DataBaseHelper.shared.updateGoalDataKeyWiseData(
                          conditionData, key[0].key);
                    }

                    var noteDataList = Hive
                        .box<NoteTableData>(Constant.tableNoteData)
                        .values
                        .toList()
                        .where((element) => element.goalId == insertId)
                        .toList();
                    if (noteDataList.isNotEmpty) {
                      for (int o = 0; o < noteDataList.length; o++) {
                        await DataBaseHelper.shared.deleteSingleNoteData(
                            noteDataList[o].key);
                      }
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
                        noteTableData.date = Utils.getSplitDateFromAPIData(
                            notesList[i].time.toString());
                        noteTableData.isDelete = true;
                        noteTableData.goalId = insertId;
                        ///isCreatedNote = If created by patient then true otherwise false
                        noteTableData.isCreatedNote = notesList[i].authorReference.toString().contains("Patient");
                        await DataBaseHelper.shared.insertNoteData(
                            noteTableData);
                      }
                    }
                  }
                }*/
              }
            }
          }
        }
      }
    }else{
      goalDataList = Hive.box<GoalTableData>(Constant.tableGoal).values.toList();
    }
    // getGoalDataList();
    update();
  }
  void getGoalDataList() {
    // goalDataList = Hive.box<GoalTableData>(Constant.tableGoal).values.toList();
    /*goalDataList = Hive.box<GoalTableData>(Constant.tableGoal)
        .values
        .toList()
        // .where((element) => element.patientId == Utils.getPatientId())
        .where((element) => serverUrlDataList.where((element1) => element.patientId == element1.patientId).toList().isNotEmpty)
        .toList();*/
  }


  ///For CarePlan Data
  callCarePlanAPI() async {
    // getCarePlanDataListLocal();
    await getCarePlanDataListApi();
    isCarePlanLoading = false;
    update();
  }
/*  void getCarePlanDataListLocal() {
    careDataList = Hive.box<CarePlanTableData>(Constant.tableCarePlan)
        .values
        .toList()
        .where((element) => serverUrlDataList.where((element1) => element.patientId == element1.patientId).toList().isNotEmpty)
        .toList();
    update();
  }*/
  getCarePlanDataListApi() async {
    careDataList.clear();
    if (serverUrlDataList.isNotEmpty &&  serverUrlDataList.where((element) => element.isPrimary).toList().isNotEmpty) {
      for (int j = 0; j < serverUrlDataList.length; j++) {
        var listData = await PaaProfiles.getCarePlanActivityList(
            // Utils.getPatientId(), serverUrlDataList[j]);
            serverUrlDataList[j].patientId, serverUrlDataList[j]);
        if (listData.resourceType == R4ResourceType.Bundle) {
          if (listData != null && listData.entry != null) {
            int length = listData.entry.length;
            for (int i = 0; i < length; i++) {
              var data = listData.entry[i];
              if (data.resource.resourceType == R4ResourceType.CarePlan) {
                var id;
                if (data.resource.id != null) {
                  id = data.resource.id.toString();
                }

                var text = "";
                if(data.resource.text != null) {
                  try {
                    text = Utils.extractTextFromHtml(data.resource.text.div.toString());
                  } catch (e) {
                    Debug.printLog(e.toString());
                  }
                }

                var status = "";
                if(data.resource.status != null) {
                  status = capitalizeFirstLetter(data.resource.status.toString());
                }

                var startDate;
                if (data.resource.period.start.toString().isNotEmpty && data.resource.period.start != null) {
                  startDate = Utils.getSplitDateFromAPIData(
                      data.resource.period.start.valueString.toString());
                }
                var endDate;
                if (data.resource.period.end.toString().isNotEmpty && data.resource.period.end != null) {
                  endDate = Utils.getSplitDateFromAPIData(
                      data.resource.period.end.valueString.toString());
                }
                var goalList = [];
                if (data.resource.goal != null) {
                  goalList = data.resource.goal;
                }

                CarePlanTableData carePlanData = CarePlanTableData();
                carePlanData.text = text;
                carePlanData.status = status;
                carePlanData.carePlanId = id;
                carePlanData.patientId = serverUrlDataList[j].patientId;
                carePlanData.startDate = startDate;
                carePlanData.endDate = endDate;
                carePlanData.qrUrl = serverUrlDataList[j].url;
                carePlanData.token = serverUrlDataList[j].authToken;
                carePlanData.clientId = serverUrlDataList[j].clientId;
                carePlanData.patientId = serverUrlDataList[j].patientId;
                carePlanData.patientName =
                "${serverUrlDataList[j].patientFName} ${serverUrlDataList[j].patientLName}";
                List<String> goalObjectIdList = [];
                for (int i = 0; i < goalList.length; i++) {
                  var goalId =
                  goalList[i].reference.toString().split("/")[1].toString();
                  if (goalId.isNotEmpty) {
                    goalObjectIdList.add(goalId);
                  }
                }
                carePlanData.goalObjectId = goalObjectIdList;

/*                careDataList = Hive.box<CarePlanTableData>(Constant.tableCarePlan)
                    .values
                    .toList()
                    .where((element) => serverUrlDataList.where((element1) => element.patientId == element1.patientId).toList().isNotEmpty)
                    .toList();*/

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
                    noteTableData.date = Utils.getSplitDateFromAPIData(
                        notesList[i].time.toString());
                    noteTableData.isDelete = true;
                    carePlanData.notesData.add(noteTableData);
                    // await DataBaseHelper.shared.insertNoteData(noteTableData);
                  }
                }


                if(status != Constant.statusDraft) {
                  careDataList.add(carePlanData);

/*                if (careDataList
                    .where((element) => element.carePlanId == id)
                    .toList()
                    .isEmpty) {
                  var insertedId = await DataBaseHelper.shared
                      .insertCarePlanData(carePlanData);
                }
                else {
                  var key = careDataList
                      .where((element) =>
                  element.carePlanId == id &&
                      element.qrUrl == serverUrlDataList[j].url)
                      .toList();
                  var insertId = 0;
                  if (key.isNotEmpty) {
                    insertId = key[0].key;
                    await DataBaseHelper.shared
                        .updateCarePlanDataKeyWise(carePlanData, key[0].key);
                  }

                  var noteDataList =
                  Hive
                      .box<NoteTableData>(Constant.tableNoteData)
                      .values
                      .toList()
                      .where((element) => element.carePlanId == insertId)
                      .toList();
                  if (noteDataList.isNotEmpty) {
                    for (int o = 0; o < noteDataList.length; o++) {
                      await DataBaseHelper.shared
                          .deleteSingleNoteData(noteDataList[o].key);
                    }
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
                      noteTableData.date = Utils.getSplitDateFromAPIData(
                          notesList[i].time.toString());
                      noteTableData.isDelete = true;
                      noteTableData.carePlanId = insertId;
                      await DataBaseHelper.shared.insertNoteData(noteTableData);
                    }
                  }
                }*/
                }
              }
            }
          }
        }
      }
    }
    // getCarePlanDataListLocal();
    update();
  }


  ///For Referral Data
  callReferralAPI() async {
    // getReferralFormData();
    await getReferralDataListApi();
    isReferralLoading = false;
    update();
  }
/*  getReferralFormData() async {
    referralListData.clear();
    referralListData = Hive.box<ReferralData>(Constant.tableReferral)
        .values
        .toList()
        // .where((element) => element.patientId == Utils.getPatientId())
        .where((element) => serverUrlDataList.where((element1) => element.patientId == element1.patientId).toList().isNotEmpty)
        .toList();
    isReferralLoading = false;
    var noteDataList = Hive.box<NoteTableData>(Constant.tableNoteData).values.toList();
    Debug.printLog("noteDataList...$noteDataList");
    update();
  }*/
  getReferralDataListApi() async {
    referralListData.clear();
    if(serverUrlDataList.isNotEmpty) {
      for(int j=0;j<serverUrlDataList.length;j++) {
        var listData = await PaaProfiles.getReferralDataList(serverUrlDataList[j]);
        if (listData.resourceType == R4ResourceType.Bundle) {
          if (listData != null && listData.entry != null) {
            // await DataBaseHelper.shared.deleteCarePlanData();
            for (int i = 0; i < listData.entry.length; i++) {
              var data = listData.entry[i];
              if (data.resource.resourceType == R4ResourceType.ServiceRequest) {
                var id;
                if (data.resource.id != null) {
                  id = data.resource.id.toString();
                }
                var status = Utils.capitalizeFirstLetter(
                    data.resource.status.toString());
                var priority = Utils.capitalizeFirstLetter(
                    data.resource.priority.toString());
                // var goal = data.resource.goal[0].reference.toString();
                var startDate;
                var endDate;

                if (data.resource.occurrencePeriod != null) {
                  if (data.resource.occurrencePeriod.start
                      .toString()
                      .isNotEmpty) {
                    startDate = Utils.getSplitDateFromAPIData(
                        data.resource.occurrencePeriod.start.valueString
                            .toString());
                  }
                  if(data.resource.occurrencePeriod.end != null){
                    if (data.resource.occurrencePeriod.end
                        .toString()
                        .isNotEmpty) {
                      endDate = Utils.getSplitDateFromAPIData(
                          data.resource.occurrencePeriod.end.valueString
                              .toString());
                    }
                  }
                }




                ReferralData referralData = ReferralData();
                referralData.status = status;
                referralData.priority = priority;

                var textReasonCode = "";
                if(data.resource.code != null){
                  if (data.resource.code.text != null && data.resource.code.text != "null" && data.resource.code.text != "") {
                    try {
                      textReasonCode = data.resource.code.text.toString();
                      // extractTextFromHtml(data.resource.code.text.toString());
                      Debug.printLog("......Text .....$textReasonCode");
                      referralData.textReasonCode = textReasonCode;
                    } catch (e) {
                      Debug.printLog("Error For text referral.....");
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
                referralData.conditionObjectId = conditionObjectIdList;

                if (data.resource.performer != null) {
                  try {
                    referralData.performerId =
                        data.resource.performer[0].reference.toString().split(
                            "Practitioner/")[1].toString();
                  } catch (e) {
                    Debug.printLog(e.toString());
                  }
                  if (data.resource.performer[0].display != null) {
                    var display = data.resource.performer[0].display;
                    referralData.performerName = display;
                  } else {
                    var dataListIndex = Utils.performerList.indexWhere((
                        element) =>
                    element.performerId == referralData.performerId).toInt();
                    if (dataListIndex != -1) {
                      referralData.performerName =
                          Utils.performerList[dataListIndex].performerName;
                    }
                  }
                }

                if(data.resource.code != null) {
                  if (data.resource.code.coding[0].code != null &&
                      data.resource.code.coding[0].display != null) {
                    //Consider display with code
                    referralData.referralCode =
                        data.resource.code.coding[0].code.toString();
                    referralData.referralScope =
                        data.resource.code.coding[0].display.toString();

                    var referralTypeCodeDataModel =
                    ReferralTypeCodeDataModel(
                        display: referralData.referralScope ?? "",
                        code: referralData.referralCode);
                    if (Utils.codeList.where((element) =>
                    element.code != referralData.referralCode &&
                        element.display != referralData.referralScope)
                        .toList()
                        .isEmpty) {
                      Utils.codeList.add(referralTypeCodeDataModel);
                    }
                  }
                  /*else if (data.resource.code.text != null) {
                    //Consider manually entered text
                    referralData.referralScope =
                        data.resource.code.text.toString();

                    var referralTypeCodeDataModel =
                    ReferralTypeCodeDataModel(
                        display: referralData.referralScope ?? "");

                    if (Utils.codeList
                        .where((element) =>
                    element.display == referralData.referralScope)
                        .toList()
                        .isEmpty) {
                      Utils.codeList.add(referralTypeCodeDataModel);
                    }
                  }*/
                }

                referralData.objectId = id;
                referralData.patientId = serverUrlDataList[j].patientId;
                referralData.startDate = startDate;
                referralData.endDate = endDate;
                referralData.isPeriodDate = true;
                referralData.isSync = true;
                referralData.qrUrl = serverUrlDataList[j].url;
                referralData.token = serverUrlDataList[j].authToken;
                referralData.clientId = serverUrlDataList[j].clientId;
                referralData.patientId = serverUrlDataList[j].patientId;
                referralData.patientName =
                "${serverUrlDataList[j].patientFName}${serverUrlDataList[j]
                    .patientLName}";


                if (data.resource.note != null) {
                  var notesList = data.resource.note;
                  for (int i = 0; i < notesList.length; i++) {
                    var noteTableData = NoteTableData();
                    noteTableData.notes = notesList[i].text.toString();
                    // noteTableData.author = Utils.getFullName();
                    if (notesList[i].authorReference != null) {
                      noteTableData.author =
                          notesList[i].authorReference.display;
                    }
                    noteTableData.readOnly = false;
                    var date = Utils.getSplitDateFromAPIData(
                        notesList[i].time.toString());
                    noteTableData.date =
                        DateTime(date.year, date.month, date.day);
                    noteTableData.isDelete = true;
                    noteTableData.referralTaskId = id;
                    referralData.notesList.add(noteTableData);
                    // await DataBaseHelper.shared.insertNoteData(noteTableData);
                  }
                }


/*                var referralData = Hive
                    .box<ReferralData>(Constant.tableReferral)
                    .values
                    .toList()
                    .where((element) => serverUrlDataList.where((element1) => element.patientId == element1.patientId).toList().isNotEmpty)
                    .toList();
                var insertedIdReferralId = 0;*/
                if(status != Constant.statusDraft) {
                  try {
                    if(data.resource.performer != null){
                      if (!data.resource.performer[0].reference
                          .toString()
                          .contains("Patient")) {
                        referralListData.add(referralData);
                      }
                    }else{
                      referralListData.add(referralData);
                    }
                  } catch (e) {
                    Debug.printLog(e.toString());
                    // referralListData.add(carePlanData);
                  }
                /*  if (referralListData
                      .where((element) => element.objectId == id)
                      .toList()
                      .isEmpty) {
                    insertedIdReferralId =
                    await DataBaseHelper.shared.insertReferralData(
                        carePlanData);
                  }
                  else {
                    var key = referralListData.where((element) =>
                    element.objectId == id &&
                        element.qrUrl == serverUrlDataList[j].url).toList();
                    if (key.isNotEmpty) {
                      insertedIdReferralId = key[0].key;
                      await DataBaseHelper.shared.updateReferralKeyWiseData(
                          carePlanData, key[0].key);
                    }

                    var noteDataList = Hive
                        .box<NoteTableData>(Constant.tableNoteData)
                        .values
                        .toList()
                        .where((element) =>
                    element.referralId == insertedIdReferralId)
                        .toList();
                    if (noteDataList.isNotEmpty) {
                      for (int o = 0; o < noteDataList.length; o++) {
                        await DataBaseHelper.shared.deleteSingleNoteData(
                            noteDataList[o].key);
                      }
                    }
                  }*/
                }
              }
            }
          }
        }
      }
    }
    // getReferralFormData();
    update();
  }


  void onRefresh() async{
    await callAllAPI(true);
    if(serverUrlDataList.isEmpty){
      callGoalAPI();
    }
    refreshController.refreshCompleted();
    update([]);
  }

  void onLoading() async{
    await Future.delayed(const Duration(milliseconds: 1000));
    refreshController.loadComplete();
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input.replaceRange(0, 1, input[0].toUpperCase());
  }


  callRxDataAPI() async {
    await getExerciseDataListApi();
    isRxLoading = false;
    update();
  }
  getExerciseDataListApi() async {
    rxDataList.clear();
    if (serverUrlDataList.isNotEmpty) {
      for (int j = 0; j < serverUrlDataList.length; j++) {
        var listData = await PaaProfiles.getExercisePrescriptionDataList(serverUrlDataList[j]);
        if (listData.resourceType == R4ResourceType.Bundle) {
          if (listData != null && listData.total != null &&
              listData.entry != null) {
            for (int i = 0; i < listData.entry.length; i++) {
              var data = listData.entry[i];
              if (data.resource.resourceType == R4ResourceType.ServiceRequest) {
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
                      .isNotEmpty && data.resource.occurrencePeriod.start != null) {
                    if(data.resource.occurrencePeriod.start.valueString != null){
                      startDate = Utils.getSplitDateFromAPIData(
                          data.resource.occurrencePeriod.start.valueString
                              .toString());
                    }
                  }
                  if (data.resource.occurrencePeriod.end
                      .toString()
                      .isNotEmpty && data.resource.occurrencePeriod.end != null) {
                    if(data.resource.occurrencePeriod.end.valueString != null){
                      endDate = Utils.getSplitDateFromAPIData(
                          data.resource.occurrencePeriod.end.valueString
                              .toString());
                    }
                  }
                }
                var textReasonCode = "";
                if(data.resource.code != null){
                  if (data.resource.code.text != null && data.resource.code.text != "null" && data.resource.code.text != "") {
                    try {
                      textReasonCode = data.resource.code.text.toString();
                      Debug.printLog("Ex Rx......Text .....$textReasonCode ");
                    } catch (e) {
                      Debug.printLog("errorr rx.......Text ....$textReasonCode");
                    }
                  }
                }

                ExerciseData rxData = ExerciseData();
                rxData.status = status;
                rxData.priority = priority;
                rxData.textReasonCode = textReasonCode;

                if (data.resource.code != null) {
                  if (data.resource.code.coding[0].code != null &&
                      data.resource.code.coding[0].display != null) {
                    rxData.referralCode =
                        data.resource.code.coding[0].code.toString();
                    rxData.referralScope =
                        data.resource.code.coding[0].display.toString();

                    var referralTypeCodeDataModel =
                    ReferralTypeCodeDataModel(
                        display: rxData.referralScope ?? "",
                        code: rxData.referralCode);
                    if (Utils.codeList.where((element) =>
                    element.code != rxData.referralCode &&
                        element.display != rxData.referralScope)
                        .toList()
                        .isEmpty) {
                      Utils.codeList.add(referralTypeCodeDataModel);
                    }
                  }
                  else if (data.resource.code.text != null) {
                    rxData.referralScope =
                        data.resource.code.text.toString();

                    var referralTypeCodeDataModel =
                    ReferralTypeCodeDataModel(
                        display: rxData.referralScope ?? "");

                    if (Utils.codeList
                        .where((element) =>
                    element.display == rxData.referralScope)
                        .toList()
                        .isEmpty) {
                      Utils.codeList.add(referralTypeCodeDataModel);
                    }
                  }
                }

                rxData.objectId = id;
                rxData.startDate = startDate;
                rxData.endDate = endDate;
                rxData.isPeriodDate = true;
                rxData.isSync = true;
                rxData.qrUrl = serverUrlDataList[j].url;
                rxData.token = serverUrlDataList[j].authToken;
                rxData.clientId = serverUrlDataList[j].clientId;
                rxData.patientId = serverUrlDataList[j].patientId;

                if (data.resource.note != null) {
                  var notesList = data.resource.note;
                  for (int i = 0; i < notesList.length; i++) {
                    var noteTableData = NoteTableData();
                    noteTableData.notes = notesList[i].text.toString();
                    if (notesList[i].authorReference != null) {
                      noteTableData.author = notesList[i].authorReference.display;
                    }
                    noteTableData.readOnly = false;
                    if(notesList[i].time != null) {
                      var date = Utils.getSplitDateFromAPIData(
                          notesList[i].time.toString());
                      noteTableData.date =
                          DateTime(date.year, date.month, date.day);
                    }
                    noteTableData.isDelete = true;
                    rxData.noteList.add(noteTableData);
                  }
                }

                rxDataList.add(rxData);
              }
            }
          }
        }
      }
    }
    update();
  }

  updateMethod(){
    update();
  }


}
