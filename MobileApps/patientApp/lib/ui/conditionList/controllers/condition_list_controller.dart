import 'package:banny_table/db_helper/box/condition_form_data.dart';
import 'package:banny_table/resources/PaaProfiles.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/selectPrimaryServer/datamodel/serverModelJson.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:fhir/r4/resource/resource.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:horizontal_data_table/refresh/pull_to_refresh/src/smart_refresher.dart';

import '../../../db_helper/database_helper.dart';
import '../../../utils/constant.dart';

class ConditionListController extends GetxController {
  List<ConditionTableData> conditionDataList = [];
  String filterGoalFilter = "";
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  List<ServerModelJson> serverUrlDataList = [];
  var argument = Get.arguments;

  @override
  void onInit() {
    if(argument != null){
      if(argument[0] != null){
        ///This is serverUrlList
        serverUrlDataList = argument[0];
      }
      if(argument[1] != null){
        ///This is condition data list
        conditionDataList = argument[1];
      }
    }
    // getServerDataList();
    // getConditionDataList();
    // getConditionDataListApi();
    super.onInit();
  }

  getServerDataList() {
    // serverUrlDataList = Utils.getServerListPreference();
  }

  selectFilter(value) {
    filterGoalFilter = value;
    onFilterGoalList(value);
  }

  onFilterGoalList(value) async {
    update();
  }

/*  void getConditionDataList() {
    *//*conditionDataList = Hive.box<ConditionTableData>(Constant.tableCondition)
        .values
        .toList()
        .where((element) => element.patientId == Utils.getPatientId())
        .toList();*//*
    conditionDataList = Hive.box<ConditionTableData>(Constant.tableCondition)
        .values
        .toList()
        .where((element) => serverUrlDataList.where((element1) => element.patientId == element1.patientId).toList().isNotEmpty)
        .toList();
    update();
  }*/

  void deteleItemNote(index) async {
    await DataBaseHelper.shared
        .deleteSingleConditionData(conditionDataList[index].key);
    conditionDataList.removeAt(index);
    Get.back();
    // getConditionDataList();
    update();
  }

  getConditionDataListApi() async {
    conditionDataList.clear();
    if (serverUrlDataList.isNotEmpty) {
      for (int j = 0; j < serverUrlDataList.length; j++) {
        var listData = await PaaProfiles.getConditionActivityList(
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
                conditionData.qrUrl = serverUrlDataList[j].url;
                conditionData.token = serverUrlDataList[j].authToken;
                conditionData.clientId = serverUrlDataList[j].clientId;
                conditionData.patientId = serverUrlDataList[j].patientId;
                conditionData.patientName =
                    "${serverUrlDataList[j].patientFName} ${serverUrlDataList[j].patientLName}";

                conditionDataList.add(conditionData);

                /*conditionDataList = Hive.box<ConditionTableData>(Constant.tableCondition)
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
                }
                else {
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

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input.replaceRange(0, 1, input[0].toUpperCase());
  }

  void onRefresh() async {
    await getConditionDataListApi();
    refreshController.refreshCompleted();
    Debug.printLog("Complete Api Call.......");
    update([]);
  }

  void onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    refreshController.loadComplete();
  }
}
