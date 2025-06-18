import 'package:banny_table/db_helper/box/condition_form_data.dart';
import 'package:banny_table/resources/PaaProfiles.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/qrScanner/datamodel/serverModelJson.dart';
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
  RefreshController refreshController = RefreshController(initialRefresh: false);
  List<ServerModelJson> serverUrlDataList = [];

  @override
  void onInit() {
    getServerDataList();
    getConditionDataList();
    getConditionDataListApi();
    super.onInit();
  }

  selectFilter(value){
    filterGoalFilter = value;
    onFilterGoalList(value);
  }

  onFilterGoalList(value) async {
    update();
  }

  void getConditionDataList() {
    conditionDataList = Hive.box<ConditionTableData>(Constant.tableCondition).values.toList()
        .where((element) => element.patientId == Utils.getPatientId()).toList();
    update();
  }

  void deteleItemNote(index)  async {
    await DataBaseHelper.shared.deleteSingleConditionData(conditionDataList[index].key);
    conditionDataList.removeAt(index);
    Get.back();
    getConditionDataList();
    update();
  }

  getConditionDataListApi() async {
    // if(Utils.getPatientId() != "" && Utils.getAPIEndPoint() != "") {
    if (serverUrlDataList.isNotEmpty) {
      if(conditionDataList.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Utils.showDialogForProgress(
              Get.context!, Constant.txtPleaseWait, Constant.txtConditionDataProgress);
        });
      }
      for (int j = 0; j < serverUrlDataList.length; j++) {
        var listData = await PaaProfiles.getConditionActivityList(
            serverUrlDataList[j].patientId, serverUrlDataList[j]);
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


                ConditionTableData conditionData = ConditionTableData();
                if (data.resource.verificationStatus != null) {
                  var verificationStatus = capitalizeFirstLetter(
                      data.resource.verificationStatus.coding[0].code
                          .toString());
                  conditionData.verificationStatus = verificationStatus;
                }
                conditionData.conditionID = id;
                conditionData.patientId = Utils.getPatientId();
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
                if (conditionDataList
                    .where((element) => element.conditionID == id)
                    .toList()
                    .isEmpty) {
                  await DataBaseHelper.shared.insertConditionData(
                      conditionData);
                }
                // var lastUpdateDate = DateTime.parse(data.resource.meta.lastUpdated.toString());
              }
            }
          }
        }
        if (conditionDataList.isEmpty) {
          Get.back();
        }
      }
    }
    getConditionDataList();
    update();
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input.replaceRange(0, 1, input[0].toUpperCase());
  }


  void onRefresh() async{
    // await Future.delayed(Duration(milliseconds: 1000));
    await getConditionDataListApi();
    refreshController.refreshCompleted();
    Debug.printLog("Complete Api Call.......");
    update([]);

  }


  void onLoading() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.loadComplete();
  }

  getServerDataList(){
    serverUrlDataList = Utils.getServerListPreference().where((element) => element.isPrimary && element.providerId != "" && element.patientId != "").toList();
    // serverUrlDataList = Utils.getServerListPreference();
  }


}
