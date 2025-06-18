import 'package:banny_table/db_helper/database_helper.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/selectPrimaryServer/datamodel/serverModelJson.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:fhir/r4/resource/resource.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:horizontal_data_table/refresh/pull_to_refresh/src/smart_refresher.dart';

import '../../../db_helper/box/notes_data.dart';
import '../../../db_helper/box/referral_data.dart';
import '../../../resources/PaaProfiles.dart';
import '../../../utils/constant.dart';
import '../../../utils/debug.dart';
import '../../mixed/datamodel/exerciseData.dart';
import '../../referralForm/datamodel/referralTypeCodeDataModel.dart';

class ExerciseListController extends GetxController {
  int selectedTabBarValue = 0;
  List<ExerciseData> rxDataList = [];

  RefreshController refreshController = RefreshController(initialRefresh: false);
  bool findData = false;

  bool isExpandRoutingDetails = true;
  var argument = Get.arguments;
  List<ServerModelJson> serverUrlDataList = [];

  @override
  void onInit() {
    getServerDataList();
    if(argument != null){
      if(argument[0] != null){
        rxDataList = argument[0];
      }
    }
    // getExerciseDataListApi();
    super.onInit();
  }
  getServerDataList(){
    serverUrlDataList = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
  }

  getExerciseDataListApi() async {
    if (serverUrlDataList.isNotEmpty) {
      rxDataList.clear();
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
                if(rxDataList.where((element) => element.objectId == id).toList().isEmpty){
                  rxDataList.add(rxData);
                }
              }
            }
          }
        }
      }
    }
    update();
  }

  void onRefresh() async{
    await getExerciseDataListApi();
    refreshController.refreshCompleted();
    Debug.printLog("Complete Api Call.......");
    update([]);
  }

  void onLoading() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.loadComplete();
  }
}
