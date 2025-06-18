import 'package:banny_table/db_helper/box/notes_data.dart';
import 'package:banny_table/db_helper/box/to_do_form_data.dart';
import 'package:banny_table/resources/PaaProfiles.dart';
import 'package:banny_table/ui/home/activityLog/controllers/home_controllers.dart';
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
import '../dataModel/codeModel.dart';
import '../dataModel/toDoDataListModel.dart';

class ToDoListController extends GetxController {

  List<ToDoDataListModel> toDoDataList = [];
  String filterGoalFilter = "";
  RefreshController refreshController = RefreshController(initialRefresh: false);
  List<ServerModelJson> serverUrlDataList = [];
  bool isShowAllData = false;

var argument = Get.arguments;


  @override
  void onInit() {
    getServerDataList();
    getToDoDataListApi();

/*    if(argument != null){
      if(argument[0] != null){
        toDoDataList = argument[0];
      }else{
        getToDoDataListApi();
      }
    }else{
      getToDoDataListApi();
    }*/

    super.onInit();
  }
  getServerDataList(){
    serverUrlDataList = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
  }

  selectFilter(value){
    filterGoalFilter = value;
    onFilterGoalList(value);
  }

  onFilterGoalList(value) async {
    update();
  }

  getToDoDataListApi() async {
    if(serverUrlDataList.isNotEmpty){
      toDoDataList.clear();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Utils.showDialogForProgress(
              Get.context!, Constant.txtPleaseWait,
              Constant.txtToDoDataProgress);
        });
      for(int j=0;j<serverUrlDataList.length;j++) {
        var listData = await PaaProfiles.getTaskDataList(
            serverUrlDataList[j].patientId, false,serverUrlDataList[j]);
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
                    else if (data.resource.code.coding[0].display != null) {
                      toDoListData.display = data.resource.code.coding[0].display;

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
                  toDoListData.createdDate = data.resource.authoredOn.valueDateTime;
                } else {
                  toDoListData.createdDate = DateTime.now();
                }
                if(data.resource.lastModified != null) {
                  toDoListData.lastUpdatedDate =
                      data.resource.lastModified.valueDateTime;
                }else{
                  toDoListData.lastUpdatedDate = DateTime.now();
                }

                toDoListData.statusReason = statusReason;
                toDoListData.businessStatus = businessStatusReason;
                toDoListData.qrUrl = serverUrlDataList[j].url;
                toDoListData.token = serverUrlDataList[j].authToken;
                toDoListData.clientId = serverUrlDataList[j].clientId;
                toDoListData.patientId = serverUrlDataList[j].patientId;
                toDoListData.patientName =
                "${serverUrlDataList[j].patientFName} ${serverUrlDataList[j]
                    .patientLName}";

                toDoListData.objectId = id;
                toDoListData.priority =
                    Utils.capitalizeFirstLetter(
                        data.resource.priority.toString());
                toDoListData.patientId = serverUrlDataList[j].patientId;
                toDoListData.status = status;
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

                if (data.resource.for_.reference != null) {
                  toDoListData.forReference = data.resource.for_.reference.toString();
                  toDoListData.forDisplay = data.resource.for_.display.toString();
                }

                if (data.resource.requester.reference != null) {
                  toDoListData.requesterReference = data.resource.requester.reference.toString();
                  toDoListData.requesterDisplay = data.resource.requester.display.toString();
                }
                if (data.resource.focus != null) {
                  if (data.resource.focus.reference != null) {
                    var focus = data.resource.focus.reference.toString();
                    toDoListData.focusReference = focus;
                  }
                }

                if (data.resource.owner.reference != null) {
                  toDoListData.ownerReference = data.resource.owner.reference.toString();
                  toDoListData.ownerDisplay = data.resource.owner.display.toString();
                }
                if (data.resource.authoredOn != null) {
                  toDoListData.createdDate = data.resource.authoredOn.valueDateTime;
                } else {
                  toDoListData.createdDate = DateTime.now();
                }
                if(data.resource.lastModified != null) {
                  toDoListData.lastUpdatedDate =
                      data.resource.lastModified.valueDateTime;
                }else{
                  toDoListData.lastUpdatedDate = DateTime.now();
                }


               /* var insertedIdTaskId = 0;

                if (toDoDataList
                    .where((element) =>
                element.objectId == id &&
                    element.qrUrl == serverUrlDataList[j].url)
                    .toList()
                    .isEmpty) {
                  insertedIdTaskId = await DataBaseHelper.shared.insertToDoData(toDoListData);
                } else {
                  var data = toDoDataList.where((element) =>
                  element.objectId == id)
                      .toList()[0];
                  insertedIdTaskId = data.key;
                  data.statusReason = toDoListData.statusReason;
                  data.businessStatus = toDoListData.businessStatus;
                  data.code = toDoListData.code;
                  data.display = toDoListData.display;
                  data.status = toDoListData.status;
                  data.priority = Utils.capitalizeFirstLetter(toDoListData.priority.toString());
                  data.patientId = Utils.getPatientId();
                  data.tag = toDoListData.tag;
                  data.createdDate = toDoListData.createdDate;
                  data.lastUpdatedDate = toDoListData.lastUpdatedDate;
                  await DataBaseHelper.shared.updateToDoData(data);
                  var noteDataList = Hive
                      .box<NoteTableData>(Constant.tableNoteData)
                      .values
                      .toList().where((element) => element.TaskId == insertedIdTaskId).toList();
                  if(noteDataList.isNotEmpty){
                    for(int o=0; o < noteDataList.length;o++){
                      await DataBaseHelper.shared.deleteSingleNoteData(noteDataList[o].key);
                    }
                  }
                }*/
                if(data.resource.note != null) {
                  var notesList = data.resource.note;
                  for (int i = 0; i < notesList.length; i++) {
                    var noteTableData = NoteTableData();
                    noteTableData.notes = notesList[i].text.toString();
                    if(notesList[i].authorReference !=  null){
                      noteTableData.author = notesList[i].authorReference.display;
                    }
                    noteTableData.readOnly = false;
                    var date = Utils.getSplitDateFromAPIData(
                        notesList[i].time.toString());
                    noteTableData.date =
                        DateTime(date.year, date.month, date.day);
                    noteTableData.isDelete = true;
                    noteTableData.isCreatedNote = notesList[i].authorReference.toString().contains("Patient");
                    toDoListData.noteList.add(noteTableData);
                    // noteTableData.TaskId = insertedIdTaskId;
                    // await DataBaseHelper.shared.insertNoteData(noteTableData);
                  }
                }

                toDoDataList.add(toDoListData);

                // var lastUpdateDate = DateTime.parse(data.resource.meta.lastUpdated.toString());
              }
            }
          }
        }
      }

      if(toDoDataList.isNotEmpty){
        toDoDataList = toDoDataList.where((element) => element.status != Constant.toDoStatusCompleted && element.status != Constant.toDoStatusCancelled).toList();
      }
      // if (toDoDataList.isEmpty) {
        Get.back();
      // }
    }
    // getToDoDataList();
    update();
  }

  getAllToDoApi() async {
      Utils.showDialogForProgress(
          Get.context!, Constant.txtPleaseWait,
          Constant.txtToDoDataProgress);
    await getHistoryTodoDataListApi();
    Get.back();
    update();
  }

  getHistoryTodoDataListApi() async {
    if(serverUrlDataList.isNotEmpty){
      for(int j=0;j<serverUrlDataList.length;j++) {
        var listData = await PaaProfiles.getTaskHistoryTODoDataList(
            serverUrlDataList[j].patientId,serverUrlDataList[j]);
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
                    else if (data.resource.code.coding[0].display != null) {
                      toDoListData.display = data.resource.code.coding[0].display;

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
                  toDoListData.createdDate = data.resource.authoredOn.valueDateTime;
                } else {
                  toDoListData.createdDate = DateTime.now();
                }
                if(data.resource.lastModified != null) {
                  toDoListData.lastUpdatedDate =
                      data.resource.lastModified.valueDateTime;
                }else{
                  toDoListData.lastUpdatedDate = DateTime.now();
                }

                toDoListData.statusReason = statusReason;
                toDoListData.businessStatus = businessStatusReason;
                toDoListData.qrUrl = serverUrlDataList[j].url;
                toDoListData.token = serverUrlDataList[j].authToken;
                toDoListData.clientId = serverUrlDataList[j].clientId;
                toDoListData.patientId = serverUrlDataList[j].patientId;
                toDoListData.patientName =
                "${serverUrlDataList[j].patientFName} ${serverUrlDataList[j]
                    .patientLName}";

                toDoListData.objectId = id;
                toDoListData.priority =
                    Utils.capitalizeFirstLetter(
                        data.resource.priority.toString());
                toDoListData.patientId = serverUrlDataList[j].patientId;
                toDoListData.status = status;
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

                if (data.resource.for_.reference != null) {
                  toDoListData.forReference = data.resource.for_.reference.toString();
                  toDoListData.forDisplay = data.resource.for_.display.toString();
                }

                if (data.resource.requester.reference != null) {
                  toDoListData.requesterReference = data.resource.requester.reference.toString();
                  toDoListData.requesterDisplay = data.resource.requester.display.toString();
                }
                if (data.resource.focus != null) {
                  if (data.resource.focus.reference != null) {
                    var focus = data.resource.focus.reference.toString();
                    toDoListData.focusReference = focus;
                  }
                }

                if (data.resource.owner.reference != null) {
                  toDoListData.ownerReference = data.resource.owner.reference.toString();
                  toDoListData.ownerDisplay = data.resource.owner.display.toString();
                }
                if (data.resource.authoredOn != null) {
                  toDoListData.createdDate = data.resource.authoredOn.valueDateTime;
                } else {
                  toDoListData.createdDate = DateTime.now();
                }
                if(data.resource.lastModified != null) {
                  toDoListData.lastUpdatedDate =
                      data.resource.lastModified.valueDateTime;
                }else{
                  toDoListData.lastUpdatedDate = DateTime.now();
                }


                /* var insertedIdTaskId = 0;

                if (toDoDataList
                    .where((element) =>
                element.objectId == id &&
                    element.qrUrl == serverUrlDataList[j].url)
                    .toList()
                    .isEmpty) {
                  insertedIdTaskId = await DataBaseHelper.shared.insertToDoData(toDoListData);
                } else {
                  var data = toDoDataList.where((element) =>
                  element.objectId == id)
                      .toList()[0];
                  insertedIdTaskId = data.key;
                  data.statusReason = toDoListData.statusReason;
                  data.businessStatus = toDoListData.businessStatus;
                  data.code = toDoListData.code;
                  data.display = toDoListData.display;
                  data.status = toDoListData.status;
                  data.priority = Utils.capitalizeFirstLetter(toDoListData.priority.toString());
                  data.patientId = Utils.getPatientId();
                  data.tag = toDoListData.tag;
                  data.createdDate = toDoListData.createdDate;
                  data.lastUpdatedDate = toDoListData.lastUpdatedDate;
                  await DataBaseHelper.shared.updateToDoData(data);
                  var noteDataList = Hive
                      .box<NoteTableData>(Constant.tableNoteData)
                      .values
                      .toList().where((element) => element.TaskId == insertedIdTaskId).toList();
                  if(noteDataList.isNotEmpty){
                    for(int o=0; o < noteDataList.length;o++){
                      await DataBaseHelper.shared.deleteSingleNoteData(noteDataList[o].key);
                    }
                  }
                }*/
                if(data.resource.note != null) {
                  var notesList = data.resource.note;
                  for (int i = 0; i < notesList.length; i++) {
                    var noteTableData = NoteTableData();
                    noteTableData.notes = notesList[i].text.toString();
                    if(notesList[i].authorReference !=  null){
                      noteTableData.author = notesList[i].authorReference.display;
                    }
                    noteTableData.readOnly = false;
                    var date = Utils.getSplitDateFromAPIData(
                        notesList[i].time.toString());
                    noteTableData.date =
                        DateTime(date.year, date.month, date.day);
                    noteTableData.isDelete = true;
                    noteTableData.isCreatedNote = notesList[i].authorReference.toString().contains("Patient");
                    toDoListData.noteList.add(noteTableData);
                    // noteTableData.TaskId = insertedIdTaskId;
                    // await DataBaseHelper.shared.insertNoteData(noteTableData);
                  }
                }

                toDoDataList.add(toDoListData);
                isShowAllData = true;


                // var lastUpdateDate = DateTime.parse(data.resource.meta.lastUpdated.toString());
              }
            }
          }
        }
        // Get.back();
      }
    }
    update();
  }


  void onRefresh() async{
    await getToDoDataListApi();
    refreshController.refreshCompleted();
    isShowAllData = false;
    Debug.printLog("Complete Api Call.......");
    update([]);

  }

  /*checkTokenExpire(){
    var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
    var primaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
    if (primaryServerData.isNotEmpty) {
      var primaryData = primaryServerData[0];
      if (primaryData.isSecure &&
          Utils.isExpiredToken(
              primaryData.lastLoggedTime, primaryData.expireTime)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: Get.context!,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title:  const Text(Constant.txtExpireTitle),
                content:  const Text(Constant.txtExpireDesc),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.back();
                      Utils.callSecureServerAPI(primaryData.url,
                          primaryData.clientId,
                          primaryData.title);
                    },
                    child: const Text("Log in"),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text("Cancel"),
                  ),
                ],
              );
            },
          );
        });
        return;
      }
    }
  }*/


  void onLoading() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.loadComplete();
  }

   updateLocalTodoList(value) {
    var data = value as ToDoDataListModel;
    var getIndexOfData = toDoDataList.indexWhere((element) => element.objectId == data.objectId).toInt();
    if(getIndexOfData != -1){
      toDoDataList[getIndexOfData] = data;
      update();
    }
    if(!isShowAllData){
      toDoDataList = toDoDataList.where((element) => element.status != Constant.toDoStatusCompleted && element.status != Constant.toDoStatusCancelled).toList();
    }

    update();
  }

}
