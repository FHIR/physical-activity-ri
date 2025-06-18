import 'package:banny_table/db_helper/database_helper.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/qrScanner/datamodel/serverModelJson.dart';
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
  // final TabController tabController = TabController( length: 2, vsync: this);

  List<ReferralData> referralCreatedListData = [];
  List<ReferralData> referralAssignedListData = [];
  bool findData = false;
  List<ServerModelJson> serverUrlDataList = [];

  bool isExpandRoutingDetails = true;

  @override
  void onInit() {
    getServerDataList();
    getReferralFormData();
    getCreatedReferralDataListApi();
    getAssignedReferralDataListApi();
    super.onInit();
  }

  changeMode(int value){
    selectedTabBarValue = value;
    update();
  }

  /// in Hive 6989448
  getReferralFormData() async {
    referralCreatedListData.clear();
    referralAssignedListData.clear();
    referralCreatedListData = Hive.box<ReferralData>(Constant.tableReferral)
        .values
        .toList()
        .where((element) => element.patientId == Utils.getPatientId() && element.isCreated == true &&
    element.providerId == Utils.getProviderId())
        .toList();

    referralAssignedListData = Hive.box<ReferralData>(Constant.tableReferral)
        .values
        .toList()
        .where((element) => element.patientId == Utils.getPatientId() && element.isCreated == false &&
        element.providerId == Utils.getProviderId())
        .toList();
    var noteDataList = Hive.box<NoteTableData>(Constant.tableNoteData).values.toList();
    Debug.printLog("noteDataList...$noteDataList");
    update();
  }

  Future<void> deleteItemReferral(int index, bool isRouting) async {
    await DataBaseHelper.shared.deleteSingleReferralData(index);
    getReferralFormData();
    Get.back();
  }

  ///Created Referral
  getCreatedReferralDataListApi() async {
    // if(Utils.getPatientId() != "" && Utils.getAPIEndPoint() != ""&&
    //      Utils.getProviderId() != "") {
    if (serverUrlDataList.isNotEmpty) {

      if(referralCreatedListData.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Utils.showDialogForProgress(
              Get.context!, Constant.txtPleaseWait, Constant.txtReferralDataProgress);
        });
      }
      for(int j=0;j<serverUrlDataList.length;j++) {
        var listData = await PaaProfiles.getReferralCreatedDataList(serverUrlDataList[j]);
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
                var status;
                var priority;
                if (data.resource != null) {
                  status = Utils.capitalizeFirstLetter(
                      data.resource.status.toString());
                  priority = Utils.capitalizeFirstLetter(
                      data.resource.priority.toString());
                }
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
                  if (data.resource.occurrencePeriod.end
                      .toString()
                      .isNotEmpty) {
                    endDate = Utils.getSplitDateFromAPIData(
                        data.resource.occurrencePeriod.end.valueString
                            .toString());
                  }
                }
                ReferralData referralCreated = ReferralData();
                if (data.resource.requester != null) {
                  if (data.resource.requester.reference != null) {
                    referralCreated.requesterId =
                        data.resource.requester.reference.toString().split(
                            "Practitioner/")[1].toString();
                  }

                  if (data.resource.requester.display != null) {
                    referralCreated.requesterName =
                        data.resource.requester.display.toString();
                  }
                }
                referralCreated.status = status;
                referralCreated.priority = priority;
                if (data.resource.performer != null) {
                  try {
                    if (!data.resource.performer[0].reference.toString()
                        .contains("Patient")) {
                      referralCreated.performerId =
                          data.resource.performer[0].reference.toString().split(
                              "Practitioner/")[1].toString();
                    }
                  } catch (e) {
                    Debug.printLog("performer id...$e");
                  }
                  if (data.resource.performer[0].display != null) {
                    var display = data.resource.performer[0].display;
                    referralCreated.performerName = display;
                  } else {
                    var dataListIndex = Utils.performerList.indexWhere((
                        element) =>
                    element.performerId == referralCreated.performerId).toInt();
                    if (dataListIndex != -1) {
                      referralCreated.performerName =
                          Utils.performerList[dataListIndex].performerName;
                    }
                  }
                } else {
                  if (Utils.performerList.isNotEmpty) {
                    referralCreated.performerId =
                        Utils.performerList[0].performerId;
                    referralCreated.performerName =
                        Utils.performerList[0].performerName;
                  }
                }

                if (data.resource.code.coding[0].code != null &&
                    data.resource.code.coding[0].display != null) {
                  //Consider display with code
                  referralCreated.referralCode =
                      data.resource.code.coding[0].code.toString();
                  referralCreated.referralScope =
                      data.resource.code.coding[0].display.toString();

                  var referralTypeCodeDataModel =
                  ReferralTypeCodeDataModel(
                      display: referralCreated.referralScope ?? "",
                      code: referralCreated.referralCode);
                  if (Utils.codeList.where((element) =>
                  element.code != referralCreated.referralCode &&
                      element.display != referralCreated.referralScope)
                      .toList()
                      .isEmpty) {
                    // Utils.codeList.add(referralTypeCodeDataModel);
                    if (!Utils.codeList.contains(referralTypeCodeDataModel)) {
                      Utils.codeList.add(referralTypeCodeDataModel);
                    }
                  }
                }
                else if (data.resource.code.text != null) {
                  //Consider manually entered text
                  referralCreated.referralScope =
                      data.resource.code.text.toString();

                  var referralTypeCodeDataModel =
                  ReferralTypeCodeDataModel(
                      display: referralCreated.referralScope ?? "");

                  if (Utils.codeList
                      .where((element) =>
                  element.display == referralCreated.referralScope)
                      .toList()
                      .isEmpty) {
                    // Utils.codeList.add(referralTypeCodeDataModel);
                    if (!Utils.codeList.contains(referralTypeCodeDataModel)) {
                      Utils.codeList.add(referralTypeCodeDataModel);
                    }
                  }
                }

                referralCreated.objectId = id;
                referralCreated.patientId = Utils.getPatientId();
                referralCreated.providerId = Utils.getProviderId();
                referralCreated.startDate = startDate;
                referralCreated.endDate = endDate;
                referralCreated.isPeriodDate = true;
                referralCreated.isSync = true;
                referralCreated.isCreated = true;

                if (!data.resource.performer[0].reference.toString().contains(
                    "Patient")) {
                  var referralData = Hive
                      .box<ReferralData>(Constant.tableReferral)
                      .values
                      .toList()
                      .where((element) =>
                  element.patientId == Utils.getPatientId() &&
                      element.isCreated == true &&
                      element.providerId == Utils.getProviderId())
                      .toList();
                  var insertedIdReferralId = 0;
                  if (referralData
                      .where((element) => element.objectId == id)
                      .toList()
                      .isEmpty) {
                    insertedIdReferralId =
                    await DataBaseHelper.shared.insertReferralData(
                        referralCreated);
                  }
                  else {
                    var key = referralCreatedListData.where((element) =>
                    element.objectId == id).toList();
                    if (key.isNotEmpty) {
                      insertedIdReferralId = key[0].key;
                      await DataBaseHelper.shared.updateReferralKeyWiseData(
                          referralCreated, key[0].key);
                    }

                    var noteDataList = Hive
                        .box<NoteTableData>(Constant.tableNoteData)
                        .values
                        .toList()
                        .where((element) =>
                    element.createdReferralId == insertedIdReferralId)
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
                      noteTableData.createdReferralId = insertedIdReferralId;
                      noteTableData.referralTaskId = id;
                      await DataBaseHelper.shared.insertNoteData(noteTableData);
                    }
                  }
                }
              }
            }
          }
        }
        if (referralCreatedListData.isEmpty) {
          Get.back();
        }
      }
    }

    getReferralFormData();
    update();
  }
  getServerDataList(){
    serverUrlDataList = Utils.getServerListPreference().where((element) => element.isPrimary && element.providerId != "" && element.patientId != "").toList();
    // serverUrlDataList = Utils.getServerListPreference();
  }

  ///Assigned Referral
  getAssignedReferralDataListApi() async {
    // if(Utils.getPatientId() != "" && Utils.getAPIEndPoint() != "" && Utils.getProviderId() != "") {
    if (serverUrlDataList.isNotEmpty) {
      /*if(referralAssignedListData.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Utils.showDialogForProgress(
              Get.context!, Constant.txtPleaseWait, Constant.txtReferralDataProgress);
        });
      }*/
      for(int j=0;j<serverUrlDataList.length;j++) {
        var listData = await PaaProfiles.getReferralAssignedDataList(serverUrlDataList[j]);
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
                      .isNotEmpty) {
                    startDate = Utils.getSplitDateFromAPIData(
                        data.resource.occurrencePeriod.start.valueString
                            .toString());
                  }
                  if (data.resource.occurrencePeriod.end
                      .toString()
                      .isNotEmpty) {
                    endDate = Utils.getSplitDateFromAPIData(
                        data.resource.occurrencePeriod.end.valueString
                            .toString());
                  }
                }
                ReferralData referrlAssigned = ReferralData();
                if (data.resource.requester != null) {
                  if (data.resource.requester.reference != null) {
                    referrlAssigned.requesterId =
                        data.resource.requester.reference.toString().split(
                            "Practitioner/")[1].toString();
                  }

                  if (data.resource.requester.display != null) {
                    referrlAssigned.requesterName =
                        data.resource.requester.display.toString();
                  }
                }
                referrlAssigned.status = status;
                referrlAssigned.priority = priority;
                if (data.resource.performer != null) {
                  referrlAssigned.performerId =
                      data.resource.performer[0].reference.toString().split(
                          "Practitioner/")[1].toString();
                  if (data.resource.performer[0].display != null) {
                    var display = data.resource.performer[0].display;
                    referrlAssigned.performerName = display;
                  } else {
                    var dataListIndex = Utils.performerList.indexWhere((
                        element) =>
                    element.performerId == referrlAssigned.performerId).toInt();
                    if (dataListIndex != -1) {
                      referrlAssigned.performerName =
                          Utils.performerList[dataListIndex].performerName;
                    }
                  }
                } else {
                  referrlAssigned.performerId =
                      Utils.performerList[0].performerId;
                  referrlAssigned.performerName =
                      Utils.performerList[0].performerName;
                }

                if (data.resource.code.coding[0].code != null &&
                    data.resource.code.coding[0].display != null) {
                  //Consider display with code
                  referrlAssigned.referralCode =
                      data.resource.code.coding[0].code.toString();
                  referrlAssigned.referralScope =
                      data.resource.code.coding[0].display.toString();

                  var referralTypeCodeDataModel =
                  ReferralTypeCodeDataModel(
                      display: referrlAssigned.referralScope ?? "",
                      code: referrlAssigned.referralCode);
                  if (Utils.codeList.where((element) =>
                  element.code != referrlAssigned.referralCode &&
                      element.display != referrlAssigned.referralScope)
                      .toList()
                      .isEmpty) {
                    // Utils.codeList.add(referralTypeCodeDataModel);
                    if (!Utils.codeList.contains(referralTypeCodeDataModel)) {
                      Utils.codeList.add(referralTypeCodeDataModel);
                    }
                  }
                }
                else if (data.resource.code.text != null) {
                  //Consider manually entered text
                  referrlAssigned.referralScope =
                      data.resource.code.text.toString();

                  var referralTypeCodeDataModel =
                  ReferralTypeCodeDataModel(
                      display: referrlAssigned.referralScope ?? "");

                  if (Utils.codeList
                      .where((element) =>
                  element.display == referrlAssigned.referralScope)
                      .toList()
                      .isEmpty) {
                    // Utils.codeList.add(referralTypeCodeDataModel);
                    if (!Utils.codeList.contains(referralTypeCodeDataModel)) {
                      Utils.codeList.add(referralTypeCodeDataModel);
                    }
                  }
                }

                referrlAssigned.objectId = id;
                referrlAssigned.patientId = Utils.getPatientId();
                referrlAssigned.providerId = Utils.getProviderId();

                referrlAssigned.startDate = startDate;
                referrlAssigned.endDate = endDate;
                referrlAssigned.isPeriodDate = true;
                referrlAssigned.isSync = true;
                referrlAssigned.isCreated = false;


                var referralData = Hive
                    .box<ReferralData>(Constant.tableReferral)
                    .values
                    .toList()
                    .where((element) =>
                element.patientId == Utils.getPatientId() &&
                    element.isCreated == false &&
                    element.providerId == Utils.getProviderId())
                    .toList();
                var insertedIdReferralId = 0;
                if (referralData
                    .where((element) => element.objectId == id)
                    .toList()
                    .isEmpty) {
                  insertedIdReferralId =
                  await DataBaseHelper.shared.insertReferralData(
                      referrlAssigned);
                } else {
                  var key = referralAssignedListData.where((element) =>
                  element.objectId == id).toList();
                  if (key.isNotEmpty) {
                    insertedIdReferralId = key[0].key;
                    await DataBaseHelper.shared.updateReferralKeyWiseData(
                        referrlAssigned, key[0].key);
                  }

                  var noteDataList = Hive
                      .box<NoteTableData>(Constant.tableNoteData)
                      .values
                      .toList()
                      .where((element) =>
                  element.assignedReferralId == insertedIdReferralId)
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
                    noteTableData.assignedReferralId = insertedIdReferralId;
                    noteTableData.referralTaskId = id;
                    await DataBaseHelper.shared.insertNoteData(noteTableData);
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
    }
    getReferralFormData();
    update();
  }

  void onRefresh() async{
    // await Future.delayed(Duration(milliseconds: 1000));
    await getCreatedReferralDataListApi();
    await getAssignedReferralDataListApi();
    refreshController.refreshCompleted();
    Debug.printLog("Complete Api Call.......");
    update([]);
  }

  void onLoading() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.loadComplete();
  }
}
