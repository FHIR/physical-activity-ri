
import 'dart:convert';

import 'package:banny_table/db_helper/box/activity_data.dart';
import 'package:banny_table/db_helper/box/care_plan_form_data.dart';
import 'package:banny_table/db_helper/box/condition_form_data.dart';
import 'package:banny_table/db_helper/box/exercise_prescription_data.dart';
import 'package:banny_table/db_helper/box/goal_data.dart';
import 'package:banny_table/db_helper/box/notes_data.dart';
import 'package:banny_table/db_helper/box/referral_data.dart';
import 'package:banny_table/db_helper/box/to_do_form_data.dart';
import 'package:banny_table/db_helper/database_helper.dart';
import 'package:banny_table/resources/PaaProfiles.dart';
import 'package:banny_table/ui/ExercisePrescription/dataModel/exercisePrescriptionDataModel.dart';
import 'package:banny_table/ui/bottomNavigation/controllers/bottom_navigation_controller.dart';
import 'package:banny_table/ui/carePlanForm/datamodel/carePlanSyncDataModel.dart';
import 'package:banny_table/ui/conditionForm/datamodel/conditionSyncDataModel.dart';
import 'package:banny_table/ui/goalForm/datamodel/goalDataModel.dart';
import 'package:banny_table/ui/home/home/dataModel/statusFilterDataModel.dart';
import 'package:banny_table/ui/patientIndependentMode/datamodel/ToDoListDatamodel.dart';
import 'package:banny_table/ui/referralForm/datamodel/referralDataModel.dart';
import 'package:banny_table/ui/referralForm/datamodel/referralTypeCodeDataModel.dart';
import 'package:banny_table/ui/toDoList/dataModel/codeModel.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/trackingPref/dataModel/trackingPref.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/qrScanner/datamodel/serverModelJson.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:fhir/r4/resource/resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hive/hive.dart';
import 'package:horizontal_data_table/refresh/pull_to_refresh/pull_to_refresh.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:xml/xml.dart';

import '../../../../utils/preference.dart';
import '../../../history/controllers/history_controller.dart';

class HomeControllers extends GetxController with GetSingleTickerProviderStateMixin {

  final keyFabButton = GlobalKey<ExpandableFabState>();

  Function? callback;
  AnimationController? animationController;
  bool open = false;
/// This List In Apply A Primary Server to MultiServer in Convert
  List<ServerModelJson> serverUrlDataList = [];


  onChangeOpenClose(){
    open = false;
    update();
  }

  final BottomNavigationController bottomControllers = Get.find<BottomNavigationController>();

  bool isReferralProgress = false;
  bool isExerciseProgress = false;
  bool isPatientTaskProgress = false;
  bool isGoalProgress = false;
  bool isConditionProgress = false;
  bool isCarePlanProgress = false;


  /// Loading
  bool isReferralLoading = false;
  bool isExerciseLoading = false;
  bool isPatientTaskLoading = false;
  bool isGoalLoading = false;
  bool isConditionLoading = false;
  bool isCarePlanLoading = false;


  List<ReferralSyncDataModel> referralListDataLocal = [];
  List<ReferralSyncDataModel> referralListData = [];
  List<ReferralSyncDataModel> referralCreatedListData = [];
  List<ReferralSyncDataModel> referralAssignedListData = [];

  List<ExercisePrescriptionSyncDataModel> exerciseListDataLocal = [];
  List<ExercisePrescriptionSyncDataModel> exerciseListData = [];

  List<ToDoDataListModel> patientTaskDataListLocal = [];
  List<ToDoDataListModel> patientTaskDataList = [];

  List<GoalSyncDataModel> goalDataListLocal = [];
  List<GoalSyncDataModel> goalDataList = [];

  List<ConditionSyncDataModel> conditionDataListLocal = [];
  List<ConditionSyncDataModel> conditionDataList = [];

  List<CarePlanSyncDataModel> careDataListLocal = [];
  List<CarePlanSyncDataModel> careDataList = [];

  RefreshController refreshController = RefreshController(initialRefresh: false);

  List<TrackingPref> trackingPrefList = [];

  void onRefresh() async{
    await callAllAPI(true);
    refreshController.refreshCompleted();
    update([]);
  }

  void onLoading() async{
    await Future.delayed(const Duration(milliseconds: 1000));
    refreshController.loadComplete();
  }

  callAllAPI(bool needShowExpireDialog) async {
    loadingON();

    await Utils.isExpireTokenAPICall(Constant.screenTypeHome,(value) async {
      if(!value){
        await callHomeAPI();
      }else{
        loadingOFF();
      }
    }).then((value) async {
      if(!value){
        await callHomeAPI();
      }else{
        loadingOFF();
      }
    });
  }

  callHomeAPI() async {
    await callConditionAPI();
    await callGoalAPI();
    await callCarePlanAPI();
    await callExercisePrescriptionAPI();
    await callReferralAPI();
    await callPatientTaskAPI();
  }

  loadingON(){
    isReferralLoading = true;
    isExerciseLoading = true;
    isPatientTaskLoading = true;
    isGoalLoading = true;
    isConditionLoading = true;
    isCarePlanLoading = true;
  }

  loadingOFF(){
    isReferralLoading = false;
    isExerciseLoading = false;
    isPatientTaskLoading = false;
    isGoalLoading = false;
    isConditionLoading = false;
    isCarePlanLoading = false;
    update();
  }

  @override
  void onInit() {
    if(Preference.shared.getTrackingPrefList(Preference.trackingPrefList)!.isEmpty) {
      var data = [
        TrackingPref(titleName: Constant.configurationHeaderTotal,pos: 0,isSelected: true),
        TrackingPref(titleName: Constant.configurationHeaderModerate,pos: 1,isSelected: true),
        TrackingPref(titleName: Constant.configurationHeaderVigorous,pos: 2,isSelected: true),
        TrackingPref(titleName: Constant.configurationNotes,pos: 3,isSelected: true),
        TrackingPref(titleName: Constant.configurationHeaderDays,pos: 4,isSelected: true),
        TrackingPref(titleName: Constant.configurationHeaderCalories,pos: 5,isSelected: true),
        TrackingPref(titleName: Constant.configurationHeaderSteps,pos: 6,isSelected: true),
        TrackingPref(titleName: Constant.configurationHeaderRest,pos: 7,isSelected: true),
        TrackingPref(titleName: Constant.configurationHeaderPeck,pos: 8,isSelected: true),
        TrackingPref(titleName: Constant.configurationExperience,pos: 9,isSelected: true),
      ];
      var json = jsonEncode(data.map((e) => e.toJson()).toList());
      Preference.shared.setList(Preference.trackingPrefList, json);
      ///Call Api For configuration Data Push
      Utils.callPushApiForConfigurationActivity();
    }
    trackingPrefList = Preference.shared.getTrackingPrefList(Preference.trackingPrefList) ?? [];

    animationController = AnimationController(
      value: 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    // getLocalData();
    getServerDataList();
    callAllAPI(false);
    super.onInit();
  }

  hideAllData(){
     isReferralProgress = false;
     isExerciseProgress = false;
     isPatientTaskProgress = false;
     isGoalProgress = false;
     isConditionProgress = false;
     isCarePlanProgress = false;
     open = false;
     update();
  }

  callPatientTaskAPI() async {
   // await getPatientTaskDataList(isPatientTaskProgress);
   await getPatientTaskAPI(isPatientTaskProgress);
   isPatientTaskLoading = false;
   update();
  }

  callReferralAPI()async{
    // await getReferralFormData(isReferralProgress);
    await getCreatedReferralDataListApi();
    await getAssignedReferralDataListApi();
    isReferralLoading = false;
    update();

  }

  callExercisePrescriptionAPI() async {
    // await getExerciseFormData(isExerciseProgress);
    await getExerciseDataListApi();
    isExerciseLoading = false;
    update();

  }

  callGoalAPI() async {
    // await getGoalDataList(isGoalProgress);
    await getGoalDataListApi();
    isGoalLoading = false;
    update();

  }

  callConditionAPI() async{
    // await getConditionDataList(isConditionProgress);
    await getConditionDataListApi();
    isConditionLoading = false;
    update();

  }

  callCarePlanAPI() async{
    // await getCarePlanDataListLocal(isCarePlanProgress);
    await getCarePlanDataListApi();
    isCarePlanLoading = false;
    update();
  }




  ///Created Referral
  getCreatedReferralDataListApi() async {
    isReferralProgress = false;
    update();
    referralListData.clear();
    referralListDataLocal.clear();
    if (serverUrlDataList.isNotEmpty) {
      for(int j=0;j<serverUrlDataList.length;j++) {
        var listData = await PaaProfiles.getReferralCreatedDataList(serverUrlDataList[j]);
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
                var status;
                var priority;
                if (data.resource != null) {
                  status = Utils.capitalizeFirstLetter(
                      data.resource.status.toString());
                  priority = Utils.capitalizeFirstLetter(
                      data.resource.priority.toString());
                }
                var startDate;
                var endDate;

                if(data.resource.occurrencePeriod  != null){
                  if (data.resource.occurrencePeriod.start != null) {
                    startDate = Utils.getSplitDateFromAPIData(
                        data.resource.occurrencePeriod.start.valueString.toString());
                  }
                  if (data.resource.occurrencePeriod.end != null) {
                    endDate = Utils.getSplitDateFromAPIData(
                        data.resource.occurrencePeriod.end.valueString.toString());
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
                ReferralSyncDataModel referralCreated = ReferralSyncDataModel();
                var textReasonCode = "";
                if(data.resource.code != null){
                  if (data.resource.code.text != null && data.resource.code.text != "null" && data.resource.code.text != "") {
                    try {
                      textReasonCode = data.resource.code.text.toString();
                      // extractTextFromHtml(data.resource.code.text.toString());
                      Debug.printLog("......Text .....$textReasonCode");
                      referralCreated.textReasonCode = textReasonCode;
                    } catch (e) {
                      Debug.printLog("Error For text referral.....");
                    }
                  }
                }

                if(data.resource.requester != null){
                  if(data.resource.requester.reference != null) {
                    referralCreated.providerId =
                        data.resource.requester.reference.toString().split(
                            "Practitioner/")[1].toString();
                  }

                  if(data.resource.requester.display != null) {
                    referralCreated.providerName = data.resource.requester.display.toString();
                  }
                }

                if (data.resource.subject != null) {
                  try {
                    referralCreated.patientId = data.resource.subject.reference.toString().split("/")[1].toString();
                    referralCreated.patientName = data.resource.subject.display.toString();
                  } catch (e) {
                    Debug.printLog(e.toString());
                  }
                }


                referralCreated.status = status;
                referralCreated.priority = priority;
                if(data.resource.performer != null){
                  try{
                    if(!data.resource.performer[0].reference.toString().contains("Patient") ) {
                      referralCreated.performerId =
                          data.resource.performer[0].reference.toString().split(
                              "Practitioner/")[1].toString();
                    }
                  }catch(e){
                    Debug.printLog("performer id...$e");
                  }
                  if(data.resource.performer[0].display != null) {
                    var display = data.resource.performer[0].display;
                    referralCreated.performerName = display;
                  }else{
                    var dataListIndex = Utils.performerList.indexWhere((element) => element.performerId == referralCreated.performerId).toInt();
                    if(dataListIndex != -1){
                      referralCreated.performerName = Utils.performerList[dataListIndex].performerName;
                    }
                  }
                }

                if(data.resource.code.coding[0].code != null &&
                    data.resource.code.coding[0].display != null){
                  referralCreated.referralTypeCode = data.resource.code.coding[0].code.toString();
                  referralCreated.referralTypeDisplay = data.resource.code.coding[0].display.toString();

                  var referralTypeCodeDataModel =
                  ReferralTypeCodeDataModel(display:referralCreated.referralTypeDisplay ?? "",
                      code: referralCreated.referralTypeCode );
                }

                if(data.resource.identifier != null){
                  if(data.resource.identifier[0] != null) {
                    var identifierData = data.resource.identifier[0];
                    referralCreated.taskId = identifierData.id.toString();
                  }
                }

                referralCreated.conditionObjectId = conditionObjectIdList;


                referralCreated.objectId = id;
                referralCreated.startDate = startDate;
                referralCreated.endDate = endDate;
                referralCreated.isPeriodDate = true;
                referralCreated.isSync = true;
                referralCreated.isCreated = true;
                referralCreated.qrUrl = serverUrlDataList[j].url;
                referralCreated.token = serverUrlDataList[j].authToken;
                referralCreated.clientId = serverUrlDataList[j].clientId;
                // referralCreated.patientId = serverUrlDataList[j].patientId;
                // referralCreated.providerId = serverUrlDataList[j].providerId;
                // referralCreated.providerName = serverUrlDataList[j].providerFName;


                if (data.resource.note != null) {
                  var notesList = data.resource.note;
                  referralCreated.notesList.clear();
                  for (int i = 0; i < notesList.length; i++) {
                    var noteTableData = NoteTableData();
                    noteTableData.notes = notesList[i].text.toString();
                    if (notesList[i].authorReference != null) {
                      noteTableData.author =
                          notesList[i].authorReference.display;
                      noteTableData.authorReference = notesList[i].authorReference.reference;
                    }
                    noteTableData.readOnly = false;
                    var date = Utils.getSplitDateFromAPIData(
                        notesList[i].time.toString());
                    noteTableData.date =
                        DateTime(date.year, date.month, date.day);
                    noteTableData.isDelete = true;
                    noteTableData.referralTaskId = id;
                    noteTableData.isCreatedNote = true;
                    noteTableData.isAssignedNote = false;
                    referralCreated.notesList.add(noteTableData);
                  }
                }
                if(data.resource.performer != null) {
                  if (!data.resource.performer[0].reference.toString().contains(
                      "Patient")) {
                    referralListData.add(referralCreated);
                    referralListDataLocal.add(referralCreated);
                  }
                }else{
                  referralListData.add(referralCreated);
                  referralListDataLocal.add(referralCreated);
                }
              }
            }
          }
        }
      }
    }
    update();
  }

  ///Assigned Referral
  getAssignedReferralDataListApi() async {
    if (serverUrlDataList.isNotEmpty) {
      for(int j=0;j<serverUrlDataList.length;j++) {
        var listData = await PaaProfiles.getReferralAssignedDataList(serverUrlDataList[j]);
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
                ReferralSyncDataModel referrlAssigned = ReferralSyncDataModel();
                if (data.resource.requester != null) {
                  if (data.resource.requester.reference != null) {
                    referrlAssigned.providerId =
                        data.resource.requester.reference.toString().split(
                            "/")[1].toString();
                  }

                  if (data.resource.requester.display != null) {
                    referrlAssigned.providerName =
                        data.resource.requester.display.toString();
                  }
                }
                referrlAssigned.status = status;
                referrlAssigned.priority = priority;

                if (data.resource.subject != null) {
                  try {
                    referrlAssigned.patientId = data.resource.subject.reference.toString().split("/")[1].toString();
                    referrlAssigned.patientName = data.resource.subject.display.toString();
                  } catch (e) {
                    Debug.printLog(e.toString());
                  }
                }

                /*if (data.resource.requester != null) {
                  try {
                    referrlAssigned.providerId = data.resource.requester.reference.toString().split("/")[1].toString();
                    referrlAssigned.providerName = data.resource.requester.display.toString();
                  } catch (e) {
                    Debug.printLog(e.toString());
                  }
                }*/

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
                referrlAssigned.conditionObjectId = conditionObjectIdList;

                var textReasonCode = "";
                if(data.resource.code != null){
                  if (data.resource.code.text != null && data.resource.code.text != "null" && data.resource.code.text != "") {
                    try {
                      textReasonCode = data.resource.code.text.toString();
                      Debug.printLog("......Text .....$textReasonCode");
                      referrlAssigned.textReasonCode = textReasonCode;
                    } catch (e) {
                      Debug.printLog("Error For text referral.....");

                    }
                  }
                }
                if (data.resource.performer != null) {
                  referrlAssigned.performerId =
                      data.resource.performer[0].reference.toString().split(
                          "/")[1].toString();
                  if (data.resource.performer[0].display != null) {
                    var display = data.resource.performer[0].display;
                    referrlAssigned.performerName = display;
                  } else {
                    var dataListIndex = Utils.performerList.indexWhere((
                        element) =>
                    element.performerId == referrlAssigned.performerId)
                        .toInt();
                    if (dataListIndex != -1) {
                      referrlAssigned.performerName =
                          Utils.performerList[dataListIndex].performerName;
                    }
                  }
                }

                if (data.resource.code.coding[0].code != null &&
                    data.resource.code.coding[0].display != null) {
                  referrlAssigned.referralTypeCode =
                      data.resource.code.coding[0].code.toString();
                  referrlAssigned.referralTypeDisplay =
                      data.resource.code.coding[0].display.toString();

                  var referralTypeCodeDataModel =
                  ReferralTypeCodeDataModel(
                      display: referrlAssigned.referralTypeDisplay ?? "",
                      code: referrlAssigned.referralTypeCode);
                }


                referrlAssigned.objectId = id;
                // referrlAssigned.patientId = Utils.getPatientId();
                // referrlAssigned.providerId = Utils.getProviderId();

                referrlAssigned.startDate = startDate;
                referrlAssigned.endDate = endDate;
                referrlAssigned.isPeriodDate = true;
                referrlAssigned.isSync = true;
                referrlAssigned.isCreated = false;
                referrlAssigned.qrUrl = serverUrlDataList[j].url;
                referrlAssigned.token = serverUrlDataList[j].authToken;
                referrlAssigned.clientId = serverUrlDataList[j].clientId;
                // referrlAssigned.patientId = serverUrlDataList[j].patientId;
                // referrlAssigned.providerId = serverUrlDataList[j].providerId;
                // referrlAssigned.providerName = serverUrlDataList[j].providerFName;

                if(data.resource.identifier != null){
                  if(data.resource.identifier[0] != null) {
                    var identifierData = data.resource.identifier[0];
                    referrlAssigned.taskId = identifierData.id.toString();
                  }
                }

                if (data.resource.note != null) {
                  var notesList = data.resource.note;
                  referrlAssigned.notesList.clear();
                  for (int i = 0; i < notesList.length; i++) {
                    var noteTableData = NoteTableData();
                    noteTableData.notes = notesList[i].text.toString();
                    if (notesList[i].authorReference != null) {
                      noteTableData.author =
                          notesList[i].authorReference.display;
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
                    referrlAssigned.notesList.add(noteTableData);
                  }
                }


                if(status.toLowerCase() != Constant.statusDraft.toLowerCase()){
                  referralListData.add(referrlAssigned);
                  referralListDataLocal.add(referrlAssigned);
/*                      insertedIdReferralId =
                      await DataBaseHelper.shared.insertReferralData(
                          referrlAssigned);*/

                }
              }
            }
          }
        }
      }
      /*if(referralAssignedListData.isEmpty) {
        Get.back();
      }*/
    }
    // getReferralFormData(isReferralProgress);
    update();
  }

  /*getReferralFormDataAllData(bool isFilter) {
    if(isFilter){
      for(int i = 0;i<statusFilter.where((element) => element.isSelected).toList().length;i++){
        statusFilter.where((element) => element.isSelected).toList()[i].isSelected = false;
      }
      // statusFilter = Utils.statusFilter.toList();
      isReferralProgress = true;
      referralListData.addAll(Hive.box<ReferralData>(Constant.tableReferral)
          .values
          .toList()
          .where((element) => element.patientId == Utils.getPatientId()  &&
          element.providerId == Utils.getProviderId() &&  element.status != Constant.statusActive)
          .toList());
      referralListData = referralListData.toSet().toList();
    }
    else{
      referralListData = Hive.box<ReferralData>(Constant.tableReferral)
          .values
          .toList()
          .where((element) => element.patientId == Utils.getPatientId()  &&
          element.providerId == Utils.getProviderId() &&  element.status != Constant.statusActive)
          .toList();
    }
    // var noteDataList = Hive.box<NoteTableData>(Constant.tableNoteData).values.toList();
    referralListDataLocal = referralListData.toList();
    update();
  }*/

/*  getReferralFormData(bool value) async {
    referralListData.clear();
    referralListDataLocal.clear();
    referralListData = Hive.box<ReferralData>(Constant.tableReferral)
        .values
        .toList()
        .where((element) => element.patientId == Utils.getPatientId()  &&
        element.providerId == Utils.getProviderId())
        .toList();
    referralListDataLocal = Hive.box<ReferralData>(Constant.tableReferral)
        .values
        .toList()
        .where((element) => element.patientId == Utils.getPatientId()  &&
        element.providerId == Utils.getProviderId())
        .toList();
    isReferralProgress = value;
    update();
  }*/

  void onChangeFilterDara(bool selected, int index,String fromType) {
    getFilterListStatusWise(fromType)[index].isSelected = selected;
    update();
  }

  void onChangeFilterDataTapOnOk(String fromType) {
    // referralListData.clear();
    // if(getFilterListStatusWise(fromType).where((element) => element.isSelected).toList().isNotEmpty) {

    if(fromType == Constant.homeConditions) {
      conditionDataList.clear();
    }
    if(fromType == Constant.homeCarePlans) {
      careDataList.clear();
    }
    if(fromType == Constant.homeExercisePrescription) {
      exerciseListData.clear();
    }
    if(fromType == Constant.homeGoals) {
      goalDataList.clear();
    }
    if(fromType == Constant.homeReferral) {
      referralListData.clear();
    }
    if(fromType == Constant.homePatientTask) {
      patientTaskDataList.clear();
    }

    var selectedStatusList = getFilterListStatusWise(fromType)
        .where((element) => element.isSelected)
        .toList();

    if(selectedStatusList.isNotEmpty) {
      if(fromType == Constant.homeConditions){
        var tempListData = conditionDataListLocal
            .where((element) => selectedStatusList.where((elementSelected) => elementSelected.status == element.verificationStatus).toList().isNotEmpty)
            .toList();
        conditionDataList = tempListData;
      }

      else if(fromType == Constant.homeCarePlans){
        var tempListData = careDataListLocal
            .where((element) => selectedStatusList.where((elementSelected)
        => elementSelected.status == element.status).toList().isNotEmpty)
            .toList();
        careDataList = tempListData;
      }

      else if(fromType == Constant.homeExercisePrescription){
        var tempListData = exerciseListDataLocal
            .where((element) => selectedStatusList.where((elementSelected)
        => elementSelected.status == element.status).toList().isNotEmpty)
            .toList();
        exerciseListData = tempListData;
      }

      else if(fromType == Constant.homeGoals){
        var tempListData = goalDataListLocal
            .where((element) => selectedStatusList.where((elementSelected)
        => elementSelected.status == element.lifeCycleStatus).toList().isNotEmpty)
            .toList();
        goalDataList = tempListData;
      }

      else if(fromType == Constant.homeReferral){
        var tempList = referralListDataLocal
            .where((element) => selectedStatusList.where((elementSelected)
        => elementSelected.status == element.status).toList().isNotEmpty)
            .toList();
        referralListData = tempList;
      }

      else if(fromType == Constant.homePatientTask){
        var tempList = patientTaskDataListLocal
            .where((element) => selectedStatusList.where((elementSelected)
        => elementSelected.status == element.status).toList().isNotEmpty)
            .toList();
        patientTaskDataList = tempList;
      }
    }
    else{
      if(fromType == Constant.homeConditions) {
        conditionDataList.addAll(conditionDataListLocal);
      }
      if(fromType == Constant.homeCarePlans) {
        careDataList.addAll(careDataListLocal);
      }
      if(fromType == Constant.homeExercisePrescription) {
        exerciseListData.addAll(exerciseListDataLocal);
      }
      if(fromType == Constant.homeGoals) {
        goalDataList.addAll(goalDataListLocal);
      }
      if(fromType == Constant.homeReferral) {
        referralListData.addAll(referralListDataLocal);
      }
      if(fromType == Constant.homePatientTask) {
        patientTaskDataList.addAll(patientTaskDataListLocal);
      }
    }

    Get.back();
    update();
  }


  ///getExerciseDataListApi
/*  getExerciseFormData(bool value) async {
    exerciseListData.clear();
    exerciseListDataLocal.clear();
    // isExerciseProgress = false;
    isExerciseProgress = value;
    exerciseListData = Hive.box<ExerciseData>(Constant.tableExerciseList)
        .values
        .toList()
        .where((element) => element.patientId == Utils.getPatientId() &&
        element.providerId == Utils.getProviderId() )
        .toList();
    exerciseListDataLocal = Hive.box<ExerciseData>(Constant.tableExerciseList)
        .values
        .toList()
        .where((element) => element.patientId == Utils.getPatientId() &&
        element.providerId == Utils.getProviderId() )
        .toList();
    update();
  }*/

  /*getExerciseFormAllData(bool isHide) async {
    if(isHide){
      isExerciseProgress = true;
      exerciseListData.addAll(Hive.box<ExerciseData>(Constant.tableExerciseList)
          .values
          .toList()
          .where((element) => element.patientId == Utils.getPatientId() &&
          element.providerId == Utils.getProviderId() && element.status != Constant.statusActive)
          .toList());
    }else {
      exerciseListData = Hive
          .box<ExerciseData>(Constant.tableExerciseList)
          .values
          .toList()
          .where((element) =>
      element.patientId == Utils.getPatientId() &&
          element.providerId == Utils.getProviderId())
          .toList();
    }
    exerciseListData = exerciseListData.toSet().toList();

    // var noteDataList = Hive.box<NoteTableData>(Constant.tableNoteData).values.toList();
    // Debug.printLog("noteDataList...$noteDataList");
    update();
  }*/

  getExerciseDataListApi() async {
    isExerciseProgress = false;
    update();
    exerciseListData.clear();
    exerciseListDataLocal.clear();
    // if(Utils.getPatientId() != "" && Utils.getProviderId() != "" && Utils.getAPIEndPoint() != "") {
    if (serverUrlDataList.isNotEmpty) {
      for (int j = 0; j < serverUrlDataList.length; j++) {
        var listData = await PaaProfiles.getExercisePrescriptionDataList(Utils.getPatientId(), serverUrlDataList[j]);
        if (listData.resourceType == R4ResourceType.Bundle) {
          if (listData != null && listData.total != null &&
              listData.entry != null) {
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
              // if(data.resource.reasonCode != null){
              //   if(data.resource.reasonCode[0].text != null && data.resource.reasonCode[0].text != ""){
              //     textReasonCode = data.resource.reasonCode[0].text;
              //   }
              // }

                // var textReasonCode;
                if(data.resource.code != null){
                  if (data.resource.code.text != null && data.resource.code.text != "null" && data.resource.code.text != "") {
                    try {
                      textReasonCode = data.resource.code.text.toString();
                          // extractTextFromHtml(data.resource.code.text.toString());

                      Debug.printLog("Ex Rx......Text .....$textReasonCode ");
                    } catch (e) {
                      Debug.printLog("errorr rx.......Text ....$textReasonCode");
                    }
                  }
                }

                ExercisePrescriptionSyncDataModel carePlanData = ExercisePrescriptionSyncDataModel();
              carePlanData.status = status;
              carePlanData.priority = priority;
              carePlanData.textReasonCode = textReasonCode;

              if (data.resource.code != null) {
                if (data.resource.code.coding[0].code != null &&
                    data.resource.code.coding[0].display != null) {
                  //Consider display with code
                  carePlanData.referralCode =
                      data.resource.code.coding[0].code.toString();
                  carePlanData.referralScope =
                      data.resource.code.coding[0].display.toString();

                  var referralTypeCodeDataModel =
                  ReferralTypeCodeDataModel(
                      display: carePlanData.referralScope ?? "",
                      code: carePlanData.referralCode);
                  /*if (Utils.codeList.where((element) =>
                  element.code != carePlanData.referralCode &&
                      element.display != carePlanData.referralScope)
                      .toList()
                      .isEmpty) {
                    Utils.codeList.add(referralTypeCodeDataModel);
                  }*/
                }
                /*else if (data.resource.code.text != null) {
                  //Consider manually entered text
                  carePlanData.referralScope =
                      data.resource.code.text.toString();

                  var referralTypeCodeDataModel =
                  ReferralTypeCodeDataModel(
                      display: carePlanData.referralScope ?? "");

                  *//*if (Utils.codeList
                      .where((element) =>
                  element.display == carePlanData.referralScope)
                      .toList()
                      .isEmpty) {
                    Utils.codeList.add(referralTypeCodeDataModel);
                  }*//*
                }*/
              }

                carePlanData.objectId = id;
                carePlanData.startDate = startDate;
                carePlanData.endDate = endDate;
                carePlanData.isPeriodDate = true;
                carePlanData.isSync = true;
                carePlanData.qrUrl = serverUrlDataList[j].url;
                carePlanData.token = serverUrlDataList[j].authToken;
                carePlanData.clientId = serverUrlDataList[j].clientId;
                carePlanData.patientId = serverUrlDataList[j].patientId;
                carePlanData.providerId = serverUrlDataList[j].providerId;
                carePlanData.providerName = serverUrlDataList[j].providerFName;

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
                    carePlanData.notesList.add(noteTableData);
                    // await DataBaseHelper.shared.insertNoteData(noteTableData);
                  }
                }
                exerciseListData.add(carePlanData);
                exerciseListDataLocal.add(carePlanData);
/*                var referralData = Hive
                  .box<ExerciseData>(Constant.tableExerciseList)
                  .values
                  .toList()
                  .where((element) =>
               serverUrlDataList.where((el) => el.patientId == element.patientId).toList().isNotEmpty &&
                   serverUrlDataList.where((el) => el.providerId == element.providerId).toList().isNotEmpty)
                  .toList();
              var insertedIdReferralId = 0;
              if (referralData
                  .where((element) => element.objectId == id)
                  .toList()
                  .isEmpty) {
                insertedIdReferralId = await DataBaseHelper.shared.inserttableExerciseData(carePlanData);
              }*/
              }
            }
          }
        }
        /*if(exerciseListData.isEmpty) {
        Get.back();
      }*/
      }
    }

    // getExerciseFormData(isExerciseProgress);
    update();
  }

  ///Patient Tasks
/*  getPatientTaskAPI() async {
    // if(Utils.getProviderId() != "" && Utils.getAPIEndPoint() != "" && Utils.getPatientId() != "") {
    if (serverUrlDataList.isNotEmpty) {
      for (int j = 0; j < serverUrlDataList.length; j++) {
        var listData = await PaaProfiles.getPatientTask(serverUrlDataList[j]);
        if (listData.resourceType == R4ResourceType.Bundle) {
          if (listData != null && listData.entry != null) {
            for (int i = 0; i < listData.entry.length; i++) {
              var data = listData.entry[i];
              if (data.resource.resourceType == R4ResourceType.Task) {
                var id;
                if (data.resource.id != null) {
                  id = data.resource.id.toString();
                }
                var statusReason;
                if (data.resource.statusReason != null) {
                  statusReason = Utils.capitalizeFirstLetter(
                      data.resource.statusReason.text.toString());
                }
                var businessStatusReason = "";
                if (data.resource.businessStatus != null) {
                  businessStatusReason = Utils.capitalizeFirstLetter(
                      data.resource.businessStatus.text.toString());
                }

                var status = Utils.capitalizeFirstLetter(
                    data.resource.status.toString());
                ToDoTableData toDoListData = ToDoTableData();

                if (data.resource.code != null) {
                  if (data.resource.code.coding != null) {
                    if (data.resource.code.coding[0].code != null &&
                        data.resource.code.coding[0].display != null) {
                      var code = data.resource.code.coding[0].code;
                      var display = data.resource.code.coding[0].display;
                      toDoListData.code = code.toString();
                      toDoListData.display = display.toString();

                      var referralTypeCodeDataModel =
                      CodeToDoModel(display: toDoListData.display ?? "",
                          code: toDoListData.code);
                      if (Utils.codeTodoList.where((element) =>
                      element.code != toDoListData.code &&
                          element.display != toDoListData.display)
                          .toList()
                          .isEmpty) {
                        if (!Utils.codeTodoList.contains(
                            referralTypeCodeDataModel)) {
                          Utils.codeTodoList.add(referralTypeCodeDataModel);
                        }
                      }
                    }
                    else if (data.resource.code.text != null) {
                      //Consider manually entered text
                      toDoListData.display =
                          data.resource.code.text.toString();

                      var codeDataModelPatient =
                      CodeToDoModel(
                          display: toDoListData.display ?? "");

                      if (Utils.codeList
                          .where((element) =>
                      element.display == toDoListData.display)
                          .toList()
                          .isEmpty) {
                        Utils.codeTodoList.add(codeDataModelPatient);
                      }
                    }
                    else if (data.resource.code.coding[0].display != null) {
                      toDoListData.display =
                          data.resource.code.coding[0].display;

                      var referralTypeCodeDataModel =
                      CodeToDoModel(display: toDoListData.display ?? "");

                      if (Utils.codeTodoList
                          .where((element) =>
                      element.display == toDoListData.display)
                          .toList()
                          .isEmpty) {
                        Utils.codeTodoList.add(referralTypeCodeDataModel);
                      }
                    }
                  }
                }

                var tagReviewed = "";
                if (data.resource.reasonCode != null) {
                  tagReviewed = data.resource.reasonCode.text.toString();
                  toDoListData.tag = tagReviewed;
                }

                if (data.resource.authoredOn != null) {
                  toDoListData.createdDate =
                      data.resource.authoredOn.valueDateTime;
                } else {
                  toDoListData.createdDate = DateTime.now();
                }
                if (data.resource.lastModified != null) {
                  toDoListData.lastUpdatedDate =
                      data.resource.lastModified.valueDateTime;
                } else {
                  toDoListData.lastUpdatedDate = DateTime.now();
                }

                toDoListData.statusReason = statusReason;
                toDoListData.businessStatus = businessStatusReason;
                toDoListData.objectId = id;
                toDoListData.isCreated = true;
                toDoListData.priority =
                    Utils.capitalizeFirstLetter(
                        data.resource.priority.toString());
                toDoListData.patientId = Utils.getPatientId();
                toDoListData.providerId = Utils.getProviderId();
                toDoListData.status = status;


                if (data.resource.for_.reference != null) {
                  toDoListData.forReference =
                      data.resource.for_.reference.toString();
                  toDoListData.forDisplay =
                      data.resource.for_.display.toString();
                }

                if (data.resource.requester.reference != null) {
                  toDoListData.requesterReference =
                      data.resource.requester.reference.toString();
                  toDoListData.requesterDisplay =
                      data.resource.requester.display.toString();
                }
                if (data.resource.focus != null) {
                  if (data.resource.focus.reference != null) {
                    var focus = data.resource.focus.reference.toString();
                    toDoListData.focusReference = focus;
                  }
                }

                if (data.resource.owner.reference != null) {
                  toDoListData.ownerReference =
                      data.resource.owner.reference.toString();
                  toDoListData.ownerDisplay =
                      data.resource.owner.display.toString();
                }
                toDoListData.qrUrl = serverUrlDataList[j].url;
                toDoListData.token = serverUrlDataList[j].authToken;
                toDoListData.clientId = serverUrlDataList[j].clientId;
                toDoListData.patientId = serverUrlDataList[j].patientId;
                toDoListData.providerId = serverUrlDataList[j].providerId;
                toDoListData.providerName = serverUrlDataList[j].providerFName;

                var insertedIdTaskId = 0;

                var toDoCreatedDataList = Hive
                    .box<ToDoTableData>(Constant.tableToDoList)
                    .values
                    .toList();
                if (toDoCreatedDataList
                    .where((element) => element.objectId == id)
                    .toList()
                    .isEmpty) {
                  insertedIdTaskId =
                  await DataBaseHelper.shared.insertToDoData(toDoListData);
                } else {
                  var data = toDoCreatedDataList.where((element) =>
                  element.objectId == id)
                      .toList();
                  if (data.isNotEmpty) {
                    insertedIdTaskId = data[0].key;
                    data[0].statusReason = toDoListData.statusReason;
                    data[0].businessStatus = toDoListData.businessStatus;
                    data[0].code = toDoListData.code;
                    data[0].isCreated = true;
                    data[0].display = toDoListData.display;
                    data[0].status = toDoListData.status;
                    data[0].priority = Utils.capitalizeFirstLetter(
                        toDoListData.priority.toString());
                    data[0].patientId = Utils.getPatientId();
                    data[0].providerId = Utils.getProviderId();
                    data[0].tag = toDoListData.tag;
                    data[0].createdDate = toDoListData.createdDate;
                    data[0].lastUpdatedDate = toDoListData.lastUpdatedDate;
                    data[0].qrUrl = serverUrlDataList[j].url;
                    data[0].token = serverUrlDataList[j].authToken;
                    data[0].clientId = serverUrlDataList[j].clientId;
                    data[0].patientId = serverUrlDataList[j].patientId;
                    data[0].providerId = serverUrlDataList[j].providerId;
                    data[0].providerName = serverUrlDataList[j].providerFName;
                    await DataBaseHelper.shared.updateToDoData(data[0]);
                  }
                  var noteDataList = Hive
                      .box<NoteTableData>(Constant.tableNoteData)
                      .values
                      .toList()
                      .where((element) =>
                  element.createdTaskId == insertedIdTaskId)
                      .toList();
                  if (noteDataList.isNotEmpty) {
                    for (int o = 0; o < noteDataList.length; o++) {
                      await DataBaseHelper.shared.deleteSingleNoteData(
                          noteDataList[o].key);
                    }
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
                    var date = Utils.getSplitDateFromAPIData(
                        notesList[i].time.toString());
                    noteTableData.date =
                        DateTime(date.year, date.month, date.day);
                    noteTableData.isDelete = true;
                    noteTableData.createdTaskId = insertedIdTaskId;
                    noteTableData.isTaskNote = true;
                    noteTableData.isCreatedNote = false;
                    noteTableData.isAssignedNote = false;
                    await DataBaseHelper.shared.insertNoteData(noteTableData);
                  }
                }
              }
            }
          }
        }
      }
      getPatientTaskDataList(isPatientTaskProgress);
      update();
    }
  }*/

  getPatientTaskAPI(bool value) async {

    isPatientTaskProgress = value;
    update();

    // if(Utils.getProviderId() != "" && Utils.getAPIEndPoint() != "" && Utils.getPatientId() != "") {
    if (serverUrlDataList.isNotEmpty) {
      patientTaskDataList.clear();
      patientTaskDataListLocal.clear();
      for (int j = 0; j < serverUrlDataList.length; j++) {
        var listData = await PaaProfiles.getPatientTask(serverUrlDataList[j]);
        if (listData.resourceType == R4ResourceType.Bundle) {
          if (listData != null && listData.entry != null) {
            for (int i = 0; i < listData.entry.length; i++) {
              var data = listData.entry[i];
              if (data.resource.resourceType == R4ResourceType.Task) {
                var id;
                if (data.resource.id != null) {
                  id = data.resource.id.toString();
                }
                var statusReason;
                if (data.resource.statusReason != null) {
                  statusReason = Utils.capitalizeFirstLetter(
                      data.resource.statusReason.text.toString());
                }
                var businessStatusReason = "";
                if (data.resource.businessStatus != null) {
                  businessStatusReason = Utils.capitalizeFirstLetter(
                      data.resource.businessStatus.text.toString());
                }

                var status = Utils.capitalizeFirstLetter(
                    data.resource.status.toString());
                ToDoDataListModel toDoListData = ToDoDataListModel();

                if (data.resource.code != null) {
                  if (data.resource.code.coding != null) {
                    if (data.resource.code.coding[0].code != null &&
                        data.resource.code.coding[0].display != null) {
                      var code = data.resource.code.coding[0].code;
                      var display = data.resource.code.coding[0].display;
                      toDoListData.code = code.toString();
                      toDoListData.display = display.toString();

                      var referralTypeCodeDataModel =
                      CodeToDoModel(display: toDoListData.display ?? "",
                          code: toDoListData.code);
                      if (Utils.codeTodoList.where((element) =>
                      element.code != toDoListData.code &&
                          element.display != toDoListData.display)
                          .toList()
                          .isEmpty) {
                        if (!Utils.codeTodoList.contains(
                            referralTypeCodeDataModel)) {
                          Utils.codeTodoList.add(referralTypeCodeDataModel);
                        }
                      }
                    }
                    /*else if (data.resource.code.text != null) {
                      //Consider manually entered text
                      toDoListData.display =
                          data.resource.code.text.toString();

                      var codeDataModelPatient =
                      CodeToDoModel(
                          display: toDoListData.display ?? "");

                      if (Utils.codeTodoList
                          .where((element) =>
                      element.display == toDoListData.display)
                          .toList()
                          .isEmpty) {
                        Utils.codeTodoList.add(codeDataModelPatient);
                      }
                    }*/
                    else if (data.resource.code.coding[0].display != null) {
                      toDoListData.display =
                          data.resource.code.coding[0].display;

                      var referralTypeCodeDataModel =
                      CodeToDoModel(display: toDoListData.display ?? "");

                      if (Utils.codeTodoList
                          .where((element) =>
                      element.display == toDoListData.display)
                          .toList()
                          .isEmpty) {
                        Utils.codeTodoList.add(referralTypeCodeDataModel);
                      }
                    }
                  }
                }
                var generalText =  "";
                var chosenText =  "";
                var compareOutput = "";
                if (data.resource.output != null) {
                  if (data.resource.output[0] != null) {
                    if(data.resource.output[0].type != null){
                      if(data.resource.output[0].type.coding != null){
                        if(data.resource.output[0].type.coding[0] != null){
                          if(data.resource.output[0].type.coding[0].display != null){
                            compareOutput =  data.resource.output[0].type.coding[0].display.toString();
                            Debug.printLog("compareOutput.......$compareOutput");
                          }
                        }
                      }
                    }
                    if (data.resource.output[0].valueMarkdown != null) {
                      if (data.resource.output[0].valueMarkdown.value != null) {
                        if(compareOutput.toLowerCase() == "Chosen Contact".toLowerCase()){
                          chosenText  = data.resource.output[0].valueMarkdown.value.toString();
                          Debug.printLog("generalText.......$chosenText");
                        }else if( compareOutput.toLowerCase() == "General Information Response".toLowerCase()){
                          generalText = data.resource.output[0].valueMarkdown.value.toString();
                          Debug.printLog("chosenText.......$generalText");
                        }
                      }
                    }
                  }
                }

                var description = "";
                if(data.resource.description != null){
                  description = data.resource.description.toString();
                }
                var perfomerId = "";
                var perfomerName = "";
                if(data.resource.input != null){
                  if(data.resource.input[0] != null){
                    if(data.resource.input[0].valueReference != null){
                      if(data.resource.input[0].valueReference != null){
                        if(data.resource.input[0].valueReference.display != null){
                          perfomerName =  data.resource.input[0].valueReference.display.toString();
                        }
                      }
                      if(data.resource.input[0].valueReference.reference.toString().split(
                          "Practitioner/")[1].toString() != "null"){
                        perfomerId = data.resource.input[0].valueReference.reference.toString().split(
                            "Practitioner/")[1].toString();
                        Debug.printLog("...id $perfomerId .......Name $perfomerName");

                      }
                    }
                  }
                }

                var url = "";
                var title = "";
                if(data.resource.contained != null){
                  if(data.resource.contained[0] != null){
                    if(data.resource.contained[0].content != null){
                      if(data.resource.contained[0].content[0] != null){
                        if(data.resource.contained[0].content[0].attachment != null){
                          if(data.resource.contained[0].content[0].attachment.url != null){
                            try{
                              url = data.resource.contained[0].content[0].attachment.url.value.toString();
                            }catch(e){
                              url = "";
                            }
                          }
                          if(data.resource.contained[0].content[0].attachment.title != null){
                            try{
                              title =data.resource.contained[0].content[0].attachment.title.toString();
                            }catch(e){
                              title = "";
                            }
                          }
                        }
                      }
                    }
                  }
                }

                var tagReviewed = "";
                if (data.resource.reasonCode != null) {
                  tagReviewed = data.resource.reasonCode.text.toString();
                  toDoListData.tag = tagReviewed;
                }

                if (data.resource.authoredOn != null) {
                  toDoListData.createdDate =
                      data.resource.authoredOn.valueDateTime;
                } else {
                  toDoListData.createdDate = DateTime.now();
                }
                if (data.resource.lastModified != null) {
                  toDoListData.lastUpdatedDate =
                      data.resource.lastModified.valueDateTime;
                } else {
                  toDoListData.lastUpdatedDate = DateTime.now();
                }

                toDoListData.statusReason = statusReason;
                toDoListData.businessStatus = businessStatusReason;
                toDoListData.objectId = id;
                toDoListData.isCreated = true;
                toDoListData.priority =
                    Utils.capitalizeFirstLetter(
                        data.resource.priority.toString());
                toDoListData.patientId = Utils.getPatientId();
                toDoListData.providerId = Utils.getProviderId();
                toDoListData.status = status;


                if (data.resource.for_.reference != null) {
                  toDoListData.forReference =
                      data.resource.for_.reference.toString();
                  toDoListData.forDisplay =
                      data.resource.for_.display.toString();
                }

                if (data.resource.requester.reference != null) {
                  toDoListData.requesterReference =
                      data.resource.requester.reference.toString();
                  toDoListData.requesterDisplay =
                      data.resource.requester.display.toString();
                }
                if (data.resource.focus != null) {
                  if (data.resource.focus.reference != null) {
                    var focus = data.resource.focus.reference.toString();
                    toDoListData.focusReference = focus;
                  }
                }

                if (data.resource.owner.reference != null) {
                  toDoListData.ownerReference =
                      data.resource.owner.reference.toString();
                  toDoListData.ownerDisplay =
                      data.resource.owner.display.toString();
                }
                toDoListData.qrUrl = serverUrlDataList[j].url;
                toDoListData.token = serverUrlDataList[j].authToken;
                toDoListData.clientId = serverUrlDataList[j].clientId;
                toDoListData.patientId = serverUrlDataList[j].patientId;
                toDoListData.providerId = serverUrlDataList[j].providerId;
                toDoListData.providerName = serverUrlDataList[j].providerFName;
                toDoListData.chosenContactText = chosenText;
                toDoListData.generalResponseText = generalText;
                toDoListData.performerId = perfomerId;
                toDoListData.performerName = perfomerName;
                if(toDoListData.display == Constant.toDoCodeDisplayMakeContact){
                  toDoListData.makeContactDescription = description;
                }else{
                  toDoListData.generalDescription = description;
                }
                toDoListData.reviewMaterialURL = url;
                toDoListData.reviewMaterialTitle = title;

                /*var insertedIdTaskId = 0;

                var toDoCreatedDataList = Hive
                    .box<ToDoTableData>(Constant.tableToDoList)
                    .values
                    .toList();
                if (toDoCreatedDataList
                    .where((element) => element.objectId == id)
                    .toList()
                    .isEmpty) {
                  insertedIdTaskId =
                  await DataBaseHelper.shared.insertToDoData(toDoListData);
                }
                else {
                  var data = toDoCreatedDataList.where((element) =>
                  element.objectId == id)
                      .toList();
                  if (data.isNotEmpty) {
                    insertedIdTaskId = data[0].key;
                    data[0].statusReason = toDoListData.statusReason;
                    data[0].businessStatus = toDoListData.businessStatus;
                    data[0].code = toDoListData.code;
                    data[0].isCreated = true;
                    data[0].display = toDoListData.display;
                    data[0].status = toDoListData.status;
                    data[0].priority = Utils.capitalizeFirstLetter(
                        toDoListData.priority.toString());
                    data[0].patientId = Utils.getPatientId();
                    data[0].providerId = Utils.getProviderId();
                    data[0].tag = toDoListData.tag;
                    data[0].createdDate = toDoListData.createdDate;
                    data[0].lastUpdatedDate = toDoListData.lastUpdatedDate;
                    data[0].qrUrl = serverUrlDataList[j].url;
                    data[0].token = serverUrlDataList[j].authToken;
                    data[0].clientId = serverUrlDataList[j].clientId;
                    data[0].patientId = serverUrlDataList[j].patientId;
                    data[0].providerId = serverUrlDataList[j].providerId;
                    data[0].providerName = serverUrlDataList[j].providerFName;
                    await DataBaseHelper.shared.updateToDoData(data[0]);
                  }
                  var noteDataList = Hive
                      .box<NoteTableData>(Constant.tableNoteData)
                      .values
                      .toList()
                      .where((element) =>
                  element.createdTaskId == insertedIdTaskId)
                      .toList();
                  if (noteDataList.isNotEmpty) {
                    for (int o = 0; o < noteDataList.length; o++) {
                      await DataBaseHelper.shared.deleteSingleNoteData(
                          noteDataList[o].key);
                    }
                  }
                }*/

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
                    var date = Utils.getSplitDateFromAPIData(
                        notesList[i].time.toString());
                    noteTableData.date =
                        DateTime(date.year, date.month, date.day);
                    noteTableData.isDelete = true;
                    // noteTableData.createdTaskId = insertedIdTaskId;
                    noteTableData.isTaskNote = true;
                    // noteTableData.isCreatedNote = false;
                    // noteTableData.isAssignedNote = false;
                    noteTableData.isCreatedNote = notesList[i].authorReference.toString().contains("Practitioner");
                    toDoListData.noteList.add(noteTableData);
                    // await DataBaseHelper.shared.insertNoteData(noteTableData);
                  }
                }

                patientTaskDataList.add(toDoListData);
                patientTaskDataListLocal.add(toDoListData);
              }
            }
          }
        }
      }
      // getPatientTaskDataList(isPatientTaskProgress);
      update();
    }
  }

  /*getPatientTaskDataList(bool value) {
    patientTaskDataList.clear();
    patientTaskDataListLocal.clear();
    isPatientTaskProgress = value;

    patientTaskDataList = Hive.box<ToDoTableData>(Constant.tableToDoList).values.toList()
        .where((element) => element.patientId == Utils.getPatientId() &&
        element.providerId == Utils.getProviderId()
    && element.needDisplay).toList();

    patientTaskDataListLocal = Hive.box<ToDoTableData>(Constant.tableToDoList).values.toList()
        .where((element) => element.patientId == Utils.getPatientId() &&
        element.providerId == Utils.getProviderId()
        && element.needDisplay).toList();

    update();
  }*/

  /*void getToDoDataListAllData(bool isHide) {
    if(isHide){
      isPatientTaskProgress = true;
      patientTaskDataList.addAll(Hive.box<ToDoTableData>(Constant.tableToDoList).values.toList()
          .where((element) => element.patientId == Utils.getPatientId() &&
          element.providerId == Utils.getProviderId() && element.status != Constant.toDoStatusCompleted
      ).toList());
    }else{
      isPatientTaskProgress = true;
      patientTaskDataList = Hive.box<ToDoTableData>(Constant.tableToDoList).values.toList()
          .where((element) => element.patientId == Utils.getPatientId() &&
          element.providerId == Utils.getProviderId() && element.status != Constant.toDoStatusCompleted ).toList();
    }

    update();
  }*/

/*  getGoalDataList(bool value) {
    goalDataList.clear();
    goalDataListLocal.clear();
    isGoalProgress = value;

    goalDataList = Hive.box<GoalTableData>(Constant.tableGoal).values.toList().where((element) =>
    element.patientId == Utils.getPatientId()).toList();

    goalDataListLocal = Hive.box<GoalTableData>(Constant.tableGoal).values.toList().where((element) =>
    element.patientId == Utils.getPatientId()).toList();

    if(goalDataList.isEmpty){
      getGoalDataListAllData(false);
    }
    update();
  }*/

/*  void getGoalDataListAllData(bool isHide) {
    if(isHide){
      isGoalProgress = true;
      goalDataList.addAll(Hive.box<GoalTableData>(Constant.tableGoal).values.toList().where((element) => element.patientId == Utils.getPatientId() && element.lifeCycleStatus != Constant.lifeCycleAccepted
      ).toList());
    }else{
      goalDataList = Hive.box<GoalTableData>(Constant.tableGoal).values.toList().where((element) => element.patientId == Utils.getPatientId()).toList();
    }
    update();
  }*/

  getGoalDataListApi() async {
    isGoalProgress = false;
    update();
    goalDataList.clear();
    goalDataListLocal.clear();
    getServerDataList();
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
                goalDataList.add(conditionData);
                goalDataListLocal.add(conditionData);
              }
            }
          }
        }
        if (goalDataList.isEmpty) {
          // Get.back();
          // Utils.showToast(Get.context!, "goal Data Refresh Completed");
        }
      }
    }
    // getGoalDataList(isGoalProgress);
    update();
  }

  bool isShowOptions = false;
  void toggleOptions() {
    isShowOptions = !isShowOptions;
    update();
  }

  /// Condition Data....
/*  getConditionDataList(bool value) {
    conditionDataListLocal.clear();
    conditionDataList.clear();
    isConditionProgress = value;
    conditionDataList = Hive.box<ConditionTableData>(Constant.tableCondition)
        .values
        .toList()
        .where((element) => element.patientId == Utils.getPatientId()
            // element.verificationStatus == Constant.verificationStatusConfirmed).toList();
            )
        .toList();

    conditionDataListLocal =
        Hive.box<ConditionTableData>(Constant.tableCondition)
            .values
            .toList()
            .where((element) => element.patientId == Utils.getPatientId())
            .toList();
    update();
  }*/

  /*void getConditionDataListAllData(bool isHide) {
    if(isHide){
      isConditionProgress = true;
      conditionDataList.addAll(Hive.box<ConditionTableData>(Constant.tableCondition).values.toList()
          .where((element) => element.patientId == Utils.getPatientId() && element.verificationStatus != Constant.verificationStatusConfirmed).toList());
    }else{
      conditionDataList = Hive.box<ConditionTableData>(Constant.tableCondition).values.toList()
          .where((element) => element.patientId == Utils.getPatientId()).toList();
    }
    update();
  }*/

  getConditionDataListApi() async {
    // if(Utils.getPatientId() != "" && Utils.getAPIEndPoint() != "") {
    isConditionProgress = false;
    update();
    conditionDataList.clear();
    conditionDataListLocal.clear();
    getServerDataList();
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
                  /*var goalList = [];
                  if (data.resource.goal != null) {
                    goalList = data.resource.goal;
                  }
                  List<String> goalObjectIdList = [];
                  for (int i = 0; i < goalList.length; i++) {
                    var goalId = goalList[i].reference.toString().split("/")[1]
                        .toString();
                    conditionData.add(goalId);
                  }
                  carePlanData.goalObjectId = goalObjectIdList;*/
                  // if (conditionDataList
                  //     .where((element) => element.objectId == id)
                  //     .toList()
                  //     .isEmpty) {
                    conditionDataList.add(conditionData);
                    conditionDataListLocal.add(conditionData);
                  // }
                  // var lastUpdateDate = DateTime.parse(data.resource.meta.lastUpdated.toString());
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

  ///Care Plan
/*   getCarePlanDataListLocal(bool value) {
     careDataList.clear();
     careDataListLocal.clear();
     isCarePlanProgress = value;

    careDataList = Hive.box<CarePlanTableData>(Constant.tableCarePlan)
        .values
        .toList()
        .where((element) => element.patientId == Utils.getPatientId() )
        .toList();

    careDataListLocal = Hive.box<CarePlanTableData>(Constant.tableCarePlan)
        .values
        .toList()
        .where((element) => element.patientId == Utils.getPatientId() )
        .toList();
    update();
  }*/

/*  void getCarePlanDataListLocalAllData(bool isHide) {
    if(isHide){
      isCarePlanProgress = true;
      careDataList.addAll(Hive.box<CarePlanTableData>(Constant.tableCarePlan)
          .values
          .toList()
          .where((element) => element.patientId == Utils.getPatientId() && element.status != Constant.statusActive)
          .toList());
    }else{
      careDataList = Hive.box<CarePlanTableData>(Constant.tableCarePlan)
          .values
          .toList()
          .where((element) => element.patientId == Utils.getPatientId())
          .toList();
    }
    update();
  }*/

  getCarePlanDataListApi() async {
    isCarePlanProgress = false;
    update();
    careDataList.clear();
    careDataListLocal.clear();
    if (serverUrlDataList.isNotEmpty) {
      for (int j = 0; j < serverUrlDataList.length; j++) {
        var listData = await PaaProfiles.getCarePlanActivityList(
            serverUrlDataList[j].patientId, serverUrlDataList[j]);
        if (listData.resourceType == R4ResourceType.Bundle) {
          if (listData != null && listData.entry != null) {
            int length = listData.entry.length;
            // await DataBaseHelper.shared.deleteCarePlanData();
            for (int i = 0; i < length; i++) {
              var data = listData.entry[i];
              if (data.resource.resourceType == R4ResourceType.CarePlan) {
                var id;
                if (data.resource.id != null) {
                  id = data.resource.id.toString();
                }
                var text;
                if(data.resource.text != null){
                  if (data.resource.text.div != null) {
                    try {
                      text =
                          extractTextFromHtml(data.resource.text.div.toString());
                    } catch (e) {
                      Debug.printLog("errror......$e");
                    }
                  }
                }

              var status = Utils.capitalizeFirstLetter(
                  data.resource.status.toString());
              // var goal = data.resource.goal[0].reference.toString();
              var startDate;
              if (data.resource.period.start != null) {
                // startDate = DateTime.parse(data.resource.period.start.valueString.toString());
                startDate = Utils.getSplitDateFromAPIData(
                    data.resource.period.start.valueString.toString());
              }
              var endDate;
              if (data.resource.period.end != null) {
                // endDate = DateTime.parse(data.resource.period.end.valueString.toString());
                endDate = Utils.getSplitDateFromAPIData(
                    data.resource.period.end.valueString.toString());
              }
              var goalList = [];
              if (data.resource.goal != null) {
                goalList = data.resource.goal;
              }

                CarePlanSyncDataModel carePlanData = CarePlanSyncDataModel();
              carePlanData.text = text;
              carePlanData.status = status;
              carePlanData.objectId = id;
              // carePlanData.patientId = Utils.getPatientId();
              carePlanData.startDate = startDate;
              carePlanData.endDate = endDate;
                carePlanData.qrUrl = serverUrlDataList[j].url;
                carePlanData.token = serverUrlDataList[j].authToken;
                carePlanData.clientId = serverUrlDataList[j].clientId;
                carePlanData.patientId = serverUrlDataList[j].patientId;
                carePlanData.providerId = serverUrlDataList[j].providerId;
                carePlanData.providerName = serverUrlDataList[j].providerFName;
              List<String> goalObjectIdList = [];
              for (int i = 0; i < goalList.length; i++) {
                var goalId = goalList[i].reference.toString().split("/")[1]
                    .toString();
                goalObjectIdList.add(goalId);
              }
              carePlanData.goalObjectId = goalObjectIdList;
              // carePlanData.goal = goal;
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
                    // noteTableData.carePlanId = insertedId;
                    carePlanData.notesList.add(noteTableData);
                    // await DataBaseHelper.shared.insertNoteData(noteTableData);
                  }
                }

                careDataList.add(carePlanData);
                careDataListLocal.add(carePlanData);

                // var insertedId = await DataBaseHelper.shared.insertCarePlanData(
                //     carePlanData);


              }
              // var lastUpdateDate = DateTime.parse(data.resource.meta.lastUpdated.toString());
            }
          }
        }

      }
    }

    // getCarePlanDataListLocal(isCarePlanProgress);
    update();
  }

  String extractTextFromHtml(String htmlString) {

    /*if(htmlString.contains("div")){
      RegExp regex = RegExp(r'<div[^>]*>([^<]+)<\/div>');
      Match? match = regex.firstMatch(htmlString);
      String extractedText = match?.group(1) ?? '';
      return extractedText;
    }else{
      return htmlString.toString().split("<p>")[1].split("</")[0].toString();
    }*/

    try{
      final document = XmlDocument.parse(htmlString);
      var htmlData =  document.rootElement.children[1].firstChild.toString();
      // Debug.printLog("....$htmlData");
      return htmlData.toString();
    }catch(e){
      return "";
    }

  }

  List<StatusFilterDataModel> getFilterListStatusWise(String status){
    return Utils.statusFilter.where((element) => element.fromType == status).toList();
  }

    getServerDataList(){
      serverUrlDataList = Utils.getServerList.where((element) => element.isSelected && element.providerId != "" && element.patientId != "").toList();
      // serverUrlDataList = Utils.getServerListPreference();
    }

    fliterUnselectApply(String status){
      for(int i = 0;i< Utils.statusFilter.where((element) => element.fromType == status).toList().length;i++){
        Utils.statusFilter.where((element) => element.fromType == status).toList()[i].isSelected = false;
      }
      update();
    }

  void updateLocalToDoList(value) {
    var data = value as ToDoDataListModel;
    Debug.printLog("Get back value....${data.objectId}  ${data.performerName}");
    var getIndexOfData = patientTaskDataListLocal.indexWhere((element) => element.objectId == data.objectId).toInt();
    if(getIndexOfData != -1){
      patientTaskDataListLocal[getIndexOfData] = data;
      patientTaskDataList[getIndexOfData] = data;
      update();
    }
  }

  void updateLocalConditionList(value) {
    var data = value as ConditionSyncDataModel;
    var getIndexOfData = conditionDataListLocal.indexWhere((element) => element.objectId == data.objectId).toInt();
    if(getIndexOfData != -1){
      conditionDataListLocal[getIndexOfData] = data;
      conditionDataList[getIndexOfData] = data;
      update();
    }
  }

  void updateLocalGoalList(value) {
    var data = value as GoalSyncDataModel;
    var getIndexOfData = goalDataListLocal.indexWhere((element) => element.objectId == data.objectId).toInt();
    if(getIndexOfData != -1){
      goalDataListLocal[getIndexOfData] = data;
      goalDataList[getIndexOfData] = data;
      update();
    }
  }

  void updateLocalCarePlanList(value) {
    var data = value as CarePlanSyncDataModel;
    var getIndexOfData = careDataListLocal.indexWhere((element) => element.objectId == data.objectId).toInt();
    if(getIndexOfData != -1){
      careDataListLocal[getIndexOfData] = data;
      careDataList[getIndexOfData] = data;
      update();
    }
  }

  void updateLocalRXList(value) {
    var data = value as ExercisePrescriptionSyncDataModel;
    var getIndexOfData = exerciseListDataLocal.indexWhere((element) => element.objectId == data.objectId).toInt();
    if(getIndexOfData != -1){
      exerciseListDataLocal[getIndexOfData] = data;
      exerciseListData[getIndexOfData] = data;
      update();
    }
  }

  void updateLocalReferralsList(value) {
    var data = value as ReferralSyncDataModel;
    var getIndexOfData = referralListDataLocal.indexWhere((element) => element.objectId == data.objectId).toInt();
    if(getIndexOfData != -1){
      referralListDataLocal[getIndexOfData] = data;
      referralListData[getIndexOfData] = data;
      update();
    }
    update();
  }


  String shortingNameTODO(String value){
    if(value == Constant.toDoStatusCompleted){
      value = Constant.toDoStatusAwaitingReview;
    }
    return value;
  }

  conditionViewExpanded(bool value){
    isConditionProgress = value;
    update();
  }

  goalViewExpanded(bool value){
    isGoalProgress = value;
    update();
  }

  carePlansViewExpanded(bool value){
    isCarePlanProgress = value;
    update();
  }
  rxViewExpanded(bool value){
    isExerciseProgress = value;
    update();
  }

  referralViewExpanded(bool value){
    isReferralProgress = value;
    update();
  }

  patientTaskViewExpanded(bool value){
    isPatientTaskProgress = value;
    update();
  }

  updateMethod(){
    update();
  }

}

class DailyLogClass{

  bool isShowHeader = false;
  /*This is for title 1*/
  TextEditingController title1Value1Controller = TextEditingController();
  TextEditingController title1Value2Controller = TextEditingController();
  TextEditingController title1TotalValueController = TextEditingController();
  double? title1Value1 = 0.0;
  double? title1Value2 = 0.0;
  double? title1Total = 0.0;
  int title1KeyId = 0;

  /*This is for title 2*/
  bool isCheckedDayData = false;
  int title2KeyId = 0;

  /*This is for title 3*/
  TextEditingController title3TotalValueController = TextEditingController();
  double? title3total = 0.0;
  int title3KeyId = 0;

  /*This is for title 4*/
  TextEditingController title4TotalValueController = TextEditingController();
  double? title4total = 0.0;
  int title4KeyId = 0;

  /*This is for title 5*/
  TextEditingController title5Value1Controller = TextEditingController();
  double? title5Value1;
  int title5Value1KeyId = 0;
  TextEditingController title5Value2Controller = TextEditingController();
  double? title5Value2;
  int title5Value2KeyId = 0;


  // This is for title 5 smiley
  int smileyType = 4;

  String date = "";
  String? displayLabel;
  DateTime? storedDate;
  int? insertedDayDataId;
  String? weeksDate;
  String? userId;
  bool isShownDate = true;
}