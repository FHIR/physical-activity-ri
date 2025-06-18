import 'package:banny_table/db_helper/box/care_plan_form_data.dart';
import 'package:banny_table/db_helper/box/goal_data.dart';
import 'package:banny_table/resources/PaaProfiles.dart';
import 'package:banny_table/ui/goalForm/datamodel/goalDataModel.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/selectPrimaryServer/datamodel/serverModelJson.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:fhir/r4/resource/resource.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:horizontal_data_table/refresh/pull_to_refresh/src/smart_refresher.dart';
import '../../../db_helper/box/notes_data.dart';
import '../../../db_helper/database_helper.dart';
import '../../../utils/constant.dart';

class CarePlanListController extends GetxController {
  List<CarePlanTableData> careDataList = [];
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  List<ServerModelJson> serverUrlDataList = [];
  var argument = Get.arguments;
  // List<GoalTableData> goalDataList = [];
  // List<GoalSyncDataModel> goalDataList = [];
  List goalDataList = [];


  @override
  void onInit() {
    // getServerDataList();
    // getCarePlanDataListLocal();
    // getCarePlanDataListApi();
    if(argument != null){
      if(argument[0] != null){
        ///This is serverUrlList
        serverUrlDataList = argument[0];
      }
      if(argument[1] != null){
        ///This is care plan data list
        careDataList = argument[1];
      }
      if(argument[2] != null){
        goalDataList = argument[2];
      }
    }
    super.onInit();
  }

  getServerDataList() {
    // serverUrlDataList = Utils.getServerListPreference();
  }

/*
  void getCarePlanDataListLocal() {
   */
/* careDataList = Hive.box<CarePlanTableData>(Constant.tableCarePlan)
        .values
        .toList()
        .where((element) => element.patientId == Utils.getPatientId())
        .toList();*//*

    careDataList = Hive.box<CarePlanTableData>(Constant.tableCarePlan)
        .values
        .toList()
        .where((element) => serverUrlDataList.where((element1) => element.patientId == element1.patientId).toList().isNotEmpty)
        .toList();
    update();
  }
*/

  void deteleItemNote(index) async {
    await DataBaseHelper.shared
        .deleteSingleCarePlanData(careDataList[index].key);
    careDataList.removeAt(index);
    Get.back();
    // getCarePlanDataListLocal();
    update();
  }

  getCarePlanDataListApi() async {
    if (serverUrlDataList.isNotEmpty) {
      for (int j = 0; j < serverUrlDataList.length; j++) {
        var listData = await PaaProfiles.getCarePlanActivityList(
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
                if (data.resource.text != null) {
                  try {
                    text =
                        Utils.extractTextFromHtml(data.resource.text.div.toString());
                  } catch (e) {
                    Debug.printLog(e.toString());
                  }
                }

                var status = "";
                if (data.resource.status != null) {
                  status =
                      capitalizeFirstLetter(data.resource.status.toString());
                }

                var startDate;
                if (data.resource.period.start
                    .toString()
                    .isNotEmpty) {
                  startDate = Utils.getSplitDateFromAPIData(
                      data.resource.period.start.valueString.toString());
                }
                var endDate;
                if(data.resource.period.end != null){
                  if (data.resource.period.end
                      .toString()
                      .isNotEmpty) {
                    endDate = Utils.getSplitDateFromAPIData(
                        data.resource.period.end.valueString.toString());
                  }
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
                "${serverUrlDataList[j].patientFName} ${serverUrlDataList[j]
                    .patientLName}";
                List<String> goalObjectIdList = [];
                for (int i = 0; i < goalList.length; i++) {
                  var goalId =
                  goalList[i].reference.toString().split("/")[1].toString();
                  if (goalId.isNotEmpty) {
                    goalObjectIdList.add(goalId);
                  }
                }
                carePlanData.goalObjectId = goalObjectIdList;

                careDataList = Hive
                    .box<CarePlanTableData>(Constant.tableCarePlan)
                    .values
                    .toList()
                    .where((element) =>
                serverUrlDataList
                    .where((element1) =>
                element.patientId == element1.patientId)
                    .toList()
                    .isNotEmpty)
                    .toList();
                if (status != Constant.statusDraft) {
                  if (careDataList
                      .where((element) => element.carePlanId == id)
                      .toList()
                      .isEmpty) {
                    var insertedId = await DataBaseHelper.shared
                        .insertCarePlanData(carePlanData);
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
                        noteTableData.carePlanId = insertedId;
                        await DataBaseHelper.shared.insertNoteData(
                            noteTableData);
                      }
                    }
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
                        await DataBaseHelper.shared.insertNoteData(
                            noteTableData);
                      }
                    }
                  }
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



  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input.replaceRange(0, 1, input[0].toUpperCase());
  }

  void onRefresh() async {
    await getCarePlanDataListApi();
    refreshController.refreshCompleted();
    Debug.printLog("Complete Api Call.......");
    update([]);
  }

  void onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    refreshController.loadComplete();
  }
}
