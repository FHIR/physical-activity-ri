import 'package:banny_table/db_helper/box/condition_form_data.dart';
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
import '../../referralForm/datamodel/referralTypeCodeDataModel.dart';

class ReferralListController extends GetxController {
  int selectedTabBarValue = 0;

  RefreshController refreshController = RefreshController(initialRefresh: false);


  List<ReferralData> referralListData = [];
  List<ServerModelJson> serverUrlDataList = [];
  List<ConditionTableData> conditionDataList = [];

  bool findData = false;

  bool isExpandRoutingDetails = true;
  var argument = Get.arguments;

  @override
  void onInit() {
    // getServerDataList();
    // getReferralFormData();
    // getReferralDataListApi();
    if(argument != null){
      if(argument[0] != null){
        ///This is serverUrlList
        serverUrlDataList = argument[0];
      }
      if(argument[1] != null){
        ///This is referral data list
        referralListData = argument[1];
      }
      if(argument[2] != null){
        conditionDataList = argument[2];
      }
    }
    super.onInit();
  }

  getServerDataList(){
    // serverUrlDataList = Utils.getServerListPreference();
  }

/*  getReferralFormData() async {
    referralListData.clear();
    referralListData = Hive.box<ReferralData>(Constant.tableReferral)
        .values
        .toList()
        // .where((element) => element.patientId == Utils.getPatientId())
        .where((element) => serverUrlDataList.where((element1) => element.patientId == element1.patientId).toList().isNotEmpty)
        .toList();
    var noteDataList = Hive.box<NoteTableData>(Constant.tableNoteData).values.toList();
    Debug.printLog("noteDataList...$noteDataList");
    update();
  }*/

  Future<void> deleteItemReferral(int index, bool isRouting) async {
    await DataBaseHelper.shared.deleteSingleReferralData(index);
    // getReferralFormData();
    Get.back();
  }

  getReferralDataListApi() async {
    referralListData.clear();
    // if(Utils.getPatientId() != "" && Utils.getAPIEndPoint() != "") {
    if(serverUrlDataList.isNotEmpty) {
      for(int j=0;j<serverUrlDataList.length;j++) {
        var listData = await PaaProfiles.getReferralDataList(serverUrlDataList[j]);
        if (listData.resourceType == R4ResourceType.Bundle) {
          if (listData != null && listData.total != null) {
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


                ReferralData carePlanData = ReferralData();
                carePlanData.status = status;
                carePlanData.priority = priority;
                if (data.resource.performer != null) {
                  try {
                    carePlanData.performerId =
                        data.resource.performer[0].reference.toString().split(
                            "Practitioner/")[1].toString();
                  } catch (e) {
                    Debug.printLog(e.toString());
                  }
                  if (data.resource.performer[0].display != null) {
                    var display = data.resource.performer[0].display;
                    carePlanData.performerName = display;
                  } else {
                    var dataListIndex = Utils.performerList.indexWhere((
                        element) =>
                    element.performerId == carePlanData.performerId).toInt();
                    if (dataListIndex != -1) {
                      carePlanData.performerName =
                          Utils.performerList[dataListIndex].performerName;
                    }
                  }
                }

                if(data.resource.code != null) {
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
                    if (Utils.codeList.where((element) =>
                    element.code != carePlanData.referralCode &&
                        element.display != carePlanData.referralScope)
                        .toList()
                        .isEmpty) {
                      Utils.codeList.add(referralTypeCodeDataModel);
                    }
                  }
                  /*else if (data.resource.code.text != null) {
                    //Consider manually entered text
                    carePlanData.referralScope =
                        data.resource.code.text.toString();

                    var referralTypeCodeDataModel =
                    ReferralTypeCodeDataModel(
                        display: carePlanData.referralScope ?? "");

                    if (Utils.codeList
                        .where((element) =>
                    element.display == carePlanData.referralScope)
                        .toList()
                        .isEmpty) {
                      Utils.codeList.add(referralTypeCodeDataModel);
                    }
                  }*/
                }

                var textReasonCode = "";
                if(data.resource.code != null){
                  if (data.resource.code.text != null && data.resource.code.text != "null" && data.resource.code.text != "") {
                    try {
                      textReasonCode = data.resource.code.text.toString();
                      // extractTextFromHtml(data.resource.code.text.toString());
                      Debug.printLog("......Text .....$textReasonCode");
                      carePlanData.textReasonCode = textReasonCode;
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
                carePlanData.conditionObjectId = conditionObjectIdList;

                carePlanData.objectId = id;
                carePlanData.patientId = serverUrlDataList[j].patientId;
                carePlanData.startDate = startDate;
                carePlanData.endDate = endDate;
                carePlanData.isPeriodDate = true;
                carePlanData.isSync = true;
                carePlanData.qrUrl = serverUrlDataList[j].url;
                carePlanData.token = serverUrlDataList[j].authToken;
                carePlanData.clientId = serverUrlDataList[j].clientId;
                carePlanData.patientId = serverUrlDataList[j].patientId;
                carePlanData.patientName =
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
                    // noteTableData.referralId = insertedIdReferralId;
                    noteTableData.referralTaskId = id;
                    carePlanData.notesList.add(noteTableData);
                    // await DataBaseHelper.shared.insertNoteData(noteTableData);
                  }
                }


/*                var referralData = Hive
                    .box<ReferralData>(Constant.tableReferral)
                    .values
                    .toList()
                    .where((element) => serverUrlDataList.where((element1) => element.patientId == element1.patientId).toList().isNotEmpty)
                    .toList();*/

                var insertedIdReferralId = 0;
                if(status != Constant.statusDraft){
                  try {
                    if(data.resource.performer != null){
                      if (!data.resource.performer[0].reference
                          .toString()
                          .contains("Patient")) {
                        referralListData.add(carePlanData);
                      }
                    }else{
                      referralListData.add(carePlanData);
                    }

                  } catch (e) {
                    Debug.printLog(e.toString());
                    // referralListData.add(carePlanData);
                  }
/*                  if (referralData
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
    // await Future.delayed(Duration(milliseconds: 1000));
    await getReferralDataListApi();
    refreshController.refreshCompleted();
    Debug.printLog("Complete Api Call.......");
    update([]);

  }


  void onLoading() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.loadComplete();
  }


}
