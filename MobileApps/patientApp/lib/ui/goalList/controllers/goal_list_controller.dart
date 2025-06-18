import 'package:banny_table/ui/goalForm/datamodel/goalDataModel.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/qrScanner/datamodel/serverModel.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/selectPrimaryServer/datamodel/serverModelJson.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:fhir/dstu2.dart';
import 'package:fhir/r4/resource/resource.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:horizontal_data_table/refresh/pull_to_refresh/src/smart_refresher.dart';

import '../../../db_helper/box/goal_data.dart';
import '../../../db_helper/box/notes_data.dart';
import '../../../db_helper/database_helper.dart';
import '../../../resources/PaaProfiles.dart';
import '../../../utils/constant.dart';


class GoalListController extends GetxController {

  // List<GoalTableData> goalDataList = [];
  List goalDataList = [];
  RefreshController refreshController = RefreshController(initialRefresh: false);

  String filterGoalFilter = "";
  // String selectedRadio = 0;
  // List<GoalTableData> filterGoalDataList = [];
  List filterGoalDataList = [];
  // Utils.filterGoalList value = Utils.filterGoalList.
  // List<ServerModel> serverUrlDataList = [];
  List<ServerModelJson> serverUrlDataList = [];
  var argument = Get.arguments;

  @override
  void onInit() {
    // getServerDataList();
    // getGoalDataList();
    // getGoalDataListApi();
    if(argument != null){
      if(argument[0] != null){
        ///This is serverUrlList
        serverUrlDataList = argument[0];
      }
      if(argument[1] != null){
        ///This is goal data list
        filterGoalDataList = argument[1];
      }
      goalDataList.addAll(filterGoalDataList);
    }
    super.onInit();
  }

  selectFilter(value){
    // Utils.filterGoalList[value];
    filterGoalFilter = value;
    onFilterGoalList(value);
  }

  onFilterGoalList(value) async {
    // selectedSyncing = value;
    if(value == Constant.statusActive){
      voidGetActiveData();
      update();
    }else if (value == Constant.statusAll){
      voidGetAllData();
    }
    update();
  }

  voidGetActiveData(){
    filterGoalDataList = goalDataList.where((element) => element.lifeCycleStatus == Constant.lifeCycleActive).toList();
  }
  voidGetAllData(){
    filterGoalDataList = goalDataList.toList();
  }


  void getGoalDataList() {
    // goalDataList = Hive.box<GoalTableData>(Constant.tableGoal).values.toList().where((element) => element.patientId == Utils.getPatientId()).toList();
    // goalDataList = Hive.box<GoalTableData>(Constant.tableGoal).values.toList().where((element) => element.patientId == Utils.getPatientId()).toList();
   /* goalDataList = Hive.box<GoalTableData>(Constant.tableGoal)
        .values
        .toList()
        .where((element) => serverUrlDataList
            .where((element1) => element.patientId == element1.patientId)
            .toList()
            .isNotEmpty)
        .toList();
    if(Constant.isSetDummyDataForGoal) {
      setDummyData();
    }*/
    if(Utils.getPrimaryServerData() == null){
      goalDataList = Hive.box<GoalTableData>(Constant.tableGoal).values.toList();
    }
    onFilterGoalList(Constant.statusAll);

    update();
  }

  void deteleItemNote(index)  async {
    if(Utils.getPrimaryServerData() == null){
      await DataBaseHelper.shared.deleteSingleGoalData(goalDataList[index].key);
    }
    goalDataList.removeAt(index);
    Get.back();
    getGoalDataList();
    update();
  }

  getServerDataList(){
    // serverUrlDataList = Utils.getServerListPreference();
  }

  getGoalDataListApi({bool isFirstTimeLoad = false}) async {
    goalDataList.clear();
    filterGoalDataList.clear();
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
                  filterGoalDataList.add(conditionData);

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
      filterGoalDataList = Hive.box<GoalTableData>(Constant.tableGoal).values.toList();
    }
    goalDataList.addAll(filterGoalDataList);
    // getGoalDataList();
    update();
  }

  void onRefresh() async{
    // await Future.delayed(Duration(milliseconds: 1000));
    await getGoalDataListApi();
    refreshController.refreshCompleted();
    Debug.printLog("Complete Api Call.......");
    update([]);

  }


  void onLoading() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.loadComplete();
  }

  void updateLocalGoalList(value) {
    if(Utils.getPrimaryServerData() != null){
      var data = value as GoalSyncDataModel;
      var getIndexOfData = goalDataList.indexWhere((element) => element.objectId == data.objectId).toInt();
      if(getIndexOfData != -1){
        goalDataList[getIndexOfData] = data;
        update();
      }

      var filterListIndex = filterGoalDataList.indexWhere((element) => element.objectId == data.objectId).toInt();
      if(getIndexOfData != -1){
        filterGoalDataList[filterListIndex] = data;
        update();
      }
    }else{
      var data = value as GoalTableData;
      var getIndexOfData = goalDataList.indexWhere((element) => element.key == data.key).toInt();
      if(getIndexOfData != -1){
        goalDataList[getIndexOfData] = data;
        update();
      }

      var filterListIndex = filterGoalDataList.indexWhere((element) => element.key == data.key).toInt();
      if(getIndexOfData != -1){
        filterGoalDataList[filterListIndex] = data;
        update();
      }
    }



  }

  updateMethod(){
    update();
  }

}
