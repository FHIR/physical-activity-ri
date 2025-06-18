import 'package:banny_table/db_helper/box/exercise_prescription_data.dart';
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

class ExercisePrescriptionListController extends GetxController {
  int selectedTabBarValue = 0;

  RefreshController refreshController = RefreshController(initialRefresh: false);

  List<ExerciseData> exerciseListData = [];
  bool findData = false;

  bool isExpandRoutingDetails = true;
  List<ServerModelJson> serverUrlDataList = [];


  @override
  void onInit() {
    getServerDataList();
    getReferralFormData();
    // getReferralDataListApi();
    getExerciseDataListApi();
    super.onInit();
  }

  changeMode(int value){
    selectedTabBarValue = value;
    update();
  }

  /// in Hive
  getReferralFormData() async {
    exerciseListData.clear();
    exerciseListData = Hive.box<ExerciseData>(Constant.tableExerciseList)
        .values
        .toList()
        .where((element) => element.patientId == Utils.getPatientId() &&
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

  getServerDataList(){
    serverUrlDataList = Utils.getServerListPreference().where((element) => element.isPrimary && element.providerId != "" && element.patientId != "").toList();
    // serverUrlDataList = Utils.getServerListPreference();
  }

  getExerciseDataListApi() async {
    // if(Utils.getPatientId() != "" && Utils.getProviderId() != "" && Utils.getAPIEndPoint() != "") {
    if (serverUrlDataList.isNotEmpty) {
      if(exerciseListData.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Utils.showDialogForProgress(
              Get.context!, Constant.txtPleaseWait, Constant.txtReferralDataProgress);
        });
      }
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
                      .isNotEmpty &&
                      data.resource.occurrencePeriod.start != null) {
                    if (data.resource.occurrencePeriod.start.valueString !=
                        null) {
                      startDate = Utils.getSplitDateFromAPIData(
                          data.resource.occurrencePeriod.start.valueString
                              .toString());
                    }
                  }
                  if (data.resource.occurrencePeriod.end
                      .toString()
                      .isNotEmpty &&
                      data.resource.occurrencePeriod.end != null) {
                    if (data.resource.occurrencePeriod.end.valueString !=
                        null) {
                      endDate = Utils.getSplitDateFromAPIData(
                          data.resource.occurrencePeriod.end.valueString
                              .toString());
                    }
                  }
                }
                ExerciseData carePlanData = ExerciseData();
                carePlanData.status = status;
                carePlanData.priority = priority;
                /*if(data.resource.performer != null){
              carePlanData.performerId = data.resource.performer[0].reference.toString().split("Practitioner/")[1].toString();
              if(data.resource.performer[0].display != null) {
                var display = data.resource.performer[0].display;
                carePlanData.performerName = display;
              }else{
                var dataListIndex = Utils.performerList.indexWhere((element) => element.performerId == carePlanData.performerId).toInt();
                if(dataListIndex != -1){
                  carePlanData.performerName = Utils.performerList[dataListIndex].performerName;
                }
              }
            }else{
              carePlanData.performerId = Utils.performerList[0].performerId;
              carePlanData.performerName = Utils.performerList[0].performerName;
            }*/

                /*if (data.resource.code != null) {
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
                 *//* else if (data.resource.code.text != null) {
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
                  }*//*
                }*/

                carePlanData.objectId = id;
                carePlanData.patientId = Utils.getPatientId();
                carePlanData.providerId = Utils.getProviderId();
                carePlanData.startDate = startDate;
                carePlanData.endDate = endDate;
                carePlanData.isPeriodDate = true;
                carePlanData.isSync = true;


                var referralData = Hive
                    .box<ExerciseData>(Constant.tableExerciseList)
                    .values
                    .toList()
                    .where((element) =>
                element.patientId == Utils.getPatientId() &&
                    element.providerId == Utils.getProviderId())
                    .toList();
                var insertedIdReferralId = 0;
                if (referralData
                    .where((element) => element.objectId == id)
                    .toList()
                    .isEmpty) {
                  insertedIdReferralId =
                  await DataBaseHelper.shared.inserttableExerciseData(
                      carePlanData);
                } else {
                  var key = exerciseListData.where((element) =>
                  element.objectId == id).toList();
                  if (key.isNotEmpty) {
                    insertedIdReferralId = key[0].key;
                    await DataBaseHelper.shared.updateExerciseKeyWiseData(
                        carePlanData, key[0].key);
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
                    // noteTableData.author = Utils.getFullName();
                    noteTableData.readOnly = false;
                    if (notesList[i].time != null) {
                      var date = Utils.getSplitDateFromAPIData(
                          notesList[i].time.toString());
                      noteTableData.date =
                          DateTime(date.year, date.month, date.day);
                    }
                    noteTableData.isDelete = true;
                    noteTableData.exerciseId = insertedIdReferralId;
                    // noteTableData.exerciseId = id;
                    /* var noteDataList = Hive
                    .box<NoteTableData>(Constant.tableNoteData)
                    .values
                    .toList();*/
                    var noteDataList = Hive
                        .box<NoteTableData>(Constant.tableNoteData)
                        .values
                        .toList()
                        .where((element) =>
                    element.providerId == Utils.getProviderId())
                        .toList();

                    if (noteDataList.isEmpty) {
                      await DataBaseHelper.shared.insertNoteData(noteTableData);
                    } else {
                      if (noteDataList.where((element) =>
                      element.exerciseId.toString() ==
                          insertedIdReferralId.toString()
                          && element.notes == notesList[i].text.toString())
                          .toList()
                          .isEmpty) {
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
        if (exerciseListData.isEmpty) {
          Get.back();
        }
      }
    }

    getReferralFormData();
    update();
  }

  void onRefresh() async{
    // await Future.delayed(Duration(milliseconds: 1000));
    // await getReferralDataListApi();
    refreshController.refreshCompleted();
    Debug.printLog("Complete Api Call.......");
    update([]);

  }


  void onLoading() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.loadComplete();
  }


}
