import 'dart:async';
import 'dart:convert';

import 'package:banny_table/ui/bottomNavigation/controllers/bottom_navigation_controller.dart';
import 'package:banny_table/ui/home/home/dataModel/statusFilterDataModel.dart';
import 'package:banny_table/ui/referralForm/datamodel/referralTypeCodeDataModel.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/qrScanner/datamodel/serverModel.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/qrScanner/datamodel/serverModelJson.dart';
import 'package:fhir/r4/general_types/general_types.dart';
import 'package:fhir/r4/resource/resource.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:horizontal_data_table/refresh/pull_to_refresh/src/smart_refresher.dart';
import 'package:intl/intl.dart';

import '../../../dataModel/patientDataModel.dart';
import '../../../db_helper/box/notes_data.dart';
import '../../../db_helper/box/to_do_form_data.dart';
import '../../../db_helper/database_helper.dart';
import '../../../resources/PaaProfiles.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/constant.dart';
import '../../../utils/debug.dart';
import '../../../utils/preference.dart';
import '../../../utils/utils.dart';
import '../../toDoList/dataModel/codeModel.dart';
import '../datamodel/ToDoListDatamodel.dart';


class PatientIndependentController extends GetxController {

  RefreshController refreshController = RefreshController(initialRefresh: false);
  RefreshController refreshPatient = RefreshController(initialRefresh: false);
  RefreshController refreshProvider = RefreshController(initialRefresh: false);
  int selectedTabBarValue = 0;
  var fName = "";
  var lName = "";
  var dob = "";
  var gender = "";
  Timer? _debounceTimer;
  FocusNode searchIdFocus = FocusNode();
  FocusNode searchNameFocus = FocusNode();
  FocusNode searchIdFocusPractitioner = FocusNode();
  FocusNode searchNameFocusPractitioner = FocusNode();
  TextEditingController searchIdControllers = TextEditingController();
  TextEditingController searchIdControllersPractitioner = TextEditingController();
  TextEditingController searchNameControllers = TextEditingController();
  TextEditingController searchNameControllersPractitioner = TextEditingController();
  List<PatientDataModel> patientProfileList = [];
  List<PatientDataModel> practitionerProfileList = [];
  bool isShowProgress = false;

  List<ToDoDataListModel> toDoCreatedDataList = [];
  List<ToDoDataListModel> toDoCreatedDataListLocal = [];
  var argument = Get.arguments;
  List<ServerModelJson> serverModelDataList = [];
  ServerModelJson? selectedUrlModel;


///Navigation Way For Get.back()
  bool isFromSetting = false;
  bool isFromQrConnect = false;
  bool isFromSelectPrimary  = false;
  bool isFromSelectProvider  = false;

  @override
  void onInit() {
    if (argument != null) {
      if (argument[0] != null) {
        isFromSetting = argument[0];
      }
      if(argument[1] != null){
        isFromQrConnect = argument[1];
      }
      if(argument[2] != null){
        isFromSelectPrimary = argument[2];
      }
      if(argument[3] != null){
        isFromSelectProvider = argument[3];
      }
    }
    getServerModelData();
    getToDoDataList();
    getTodoApiData();
    Debug.printLog("On init...");
    Utils.setPractitionerDetailIdWise();
    super.onInit();
  }

  getTodoApiData() async {
    toDoCreatedDataList.clear();
    toDoCreatedDataListLocal.clear();
   await getToDoCreatedDataListApi();
   await getToDoAssignedAPI();
   update();
  }

  getServerModelData() async {
    serverModelDataList = Utils.getServerList;
    if(serverModelDataList.isNotEmpty){
      if(serverModelDataList.where((element) => element.isPrimary).toList().isNotEmpty){
        selectedUrlModel = serverModelDataList.where((element) => element.isPrimary).toList()[0];
      }
    }
    update();
  }

  getToDoDataList() {
   /* toDoCreatedDataList.clear();
    toDoCreatedDataListLocal.clear();
    tempRoutineList.clear();
    tempUrgentList.clear();

    var tempToDoList = Hive.box<ToDoTableData>(Constant.tableToDoList).values.toList();
    for (int i = 0; i < tempToDoList.length; i++) {
      var todoData = tempToDoList[i];
      if(todoData.providerId == Utils.getProviderId()){
        if((todoData.status == Constant.toDoStatusCompleted ||
            todoData.status == Constant.toDoStatusFailed ||
            todoData.status == Constant.toDoStatusCancelled) &&
            todoData.needDisplay){
          addStatusWiseData(todoData);
        }
        if((todoData.status != Constant.toDoStatusCompleted &&
            todoData.status != Constant.toDoStatusFailed &&
            todoData.status != Constant.toDoStatusCancelled && todoData.createdDate != null
                && todoData.lastUpdatedDate != null  && todoData.needDisplay)){
          if(todoData.createdDate!.isBefore(todoData.lastUpdatedDate!)
              && todoData.needDisplay){
            addStatusWiseData(todoData);
          }
        }
      }
    }
    toDoCreatedDataList.addAll(tempUrgentList);
    toDoCreatedDataListLocal.addAll(tempUrgentList);
    toDoCreatedDataList.addAll(tempRoutineList);
    toDoCreatedDataListLocal.addAll(tempRoutineList);
    update();*/
  }

  List<ToDoDataListModel> tempRoutineList = [];
  List<ToDoDataListModel> tempUrgentList = [];

  addStatusWiseData(ToDoDataListModel todoData){
    if(todoData.priority == Constant.priorityRoutine){
      tempRoutineList.add(todoData);
    }else if(todoData.priority == Constant.priorityUrgent){
      tempUrgentList.add(todoData);
    }
  }

  /*getToDoCreatedDataListApi() async {
    if (serverModelDataList.isNotEmpty) {
      for(int i =0;i<serverModelDataList.length;i++){
        var listData = await PaaProfiles.getToDoCreatedIndependentListApi(serverModelDataList[i]);
        if (listData != null) {
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
                      else if (data.resource.code.text != null) {
                        //Consider manually entered text
                        toDoListData.text = data.resource.code.text.toString();

                        var referralTypeCodeDataModel =
                        CodeToDoModel(display: toDoListData.text ?? "");

                        if (Utils.codeTodoList
                            .where((element) =>
                        element.display == toDoListData.text)
                            .toList()
                            .isEmpty) {
                          // Utils.codeTodoList.add(referralTypeCodeDataModel);
                          if (!Utils.codeTodoList.contains(
                              referralTypeCodeDataModel)) {
                            Utils.codeTodoList.add(referralTypeCodeDataModel);
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
                  if (data.resource.focus != null) {
                    if (data.resource.focus.reference != null) {
                      var focus = data.resource.focus.reference.toString();
                      toDoListData.focusReference = focus;
                    }
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

                  try {
                    if (data.resource.for_.reference != null) {
                      toDoListData.forReference =
                          data.resource.for_.reference.toString();
                      toDoListData.forDisplay =
                          data.resource.for_.display.toString();
                    }
                  } catch (e) {
                    Debug.printLog(e.toString());
                  }

                  try {
                    if (data.resource.requester.reference != null) {
                      toDoListData.requesterReference =
                          data.resource.requester.reference.toString();
                      toDoListData.requesterDisplay =
                          data.resource.requester.display.toString();
                    }
                  } catch (e) {
                    Debug.printLog(e.toString());
                  }

                  try {
                    if (data.resource.owner.reference != null) {
                      toDoListData.ownerReference =
                          data.resource.owner.reference.toString();
                      toDoListData.ownerDisplay =
                          data.resource.owner.display.toString();
                    }
                  } catch (e) {
                    Debug.printLog(e.toString());
                  }


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
                      data[0].text = toDoListData.text;
                      data[0].status = toDoListData.status;
                      data[0].priority = Utils.capitalizeFirstLetter(
                          toDoListData.priority.toString());
                      data[0].patientId = Utils.getPatientId();
                      data[0].providerId = Utils.getProviderId();
                      data[0].tag = toDoListData.tag;
                      data[0].createdDate = toDoListData.createdDate;
                      data[0].lastUpdatedDate = toDoListData.lastUpdatedDate;
                      data[0].focusReference = toDoListData.focusReference;
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
      }
    }

    update();
  }*/

  getToDoCreatedDataListApi() async {
    if (serverModelDataList.isNotEmpty) {
      for(int i =0;i<serverModelDataList.length;i++){
        var listData = await PaaProfiles.getToDoCreatedIndependentListApi(serverModelDataList[i]);
        if (listData != null) {
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

                        if(data.resource.code.text != null){
                          toDoListData.text = data.resource.code.text;
                        }

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
                        toDoListData.display =
                            data.resource.code.coding[0].display;

                        if(data.resource.code.text != null){
                          toDoListData.text = data.resource.code.text;
                        }

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
                      /*else if (data.resource.code.text != null) {
                        //Consider manually entered text
                        toDoListData.text = data.resource.code.text.toString();

                        var referralTypeCodeDataModel =
                        CodeToDoModel(display: toDoListData.text ?? "");

                        if (Utils.codeTodoList
                            .where((element) =>
                        element.display == toDoListData.text)
                            .toList()
                            .isEmpty) {
                          // Utils.codeTodoList.add(referralTypeCodeDataModel);
                          if (!Utils.codeTodoList.contains(
                              referralTypeCodeDataModel)) {
                            Utils.codeTodoList.add(referralTypeCodeDataModel);
                          }
                        }
                      }*/
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
                  if (data.resource.focus != null) {
                    if (data.resource.focus.reference != null) {
                      var focus = data.resource.focus.reference.toString();
                      toDoListData.focusReference = focus;
                    }
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
                  if(data.resource.executionPeriod != null){
                    if(data.resource.executionPeriod.start != null){
                      toDoListData.startDate = data.resource.executionPeriod.start.valueDateTime;
                    }
                    if(data.resource.executionPeriod.end != null){
                      toDoListData.endDate = data.resource.executionPeriod.end.valueDateTime;
                    }
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

                  try {
                    if (data.resource.for_.reference != null) {
                      toDoListData.forReference =
                          data.resource.for_.reference.toString();
                      toDoListData.forDisplay =
                          data.resource.for_.display.toString();
                    }
                  } catch (e) {
                    Debug.printLog(e.toString());
                  }

                  try {
                    if (data.resource.requester.reference != null) {
                      toDoListData.requesterReference =
                          data.resource.requester.reference.toString();
                      toDoListData.requesterDisplay =
                          data.resource.requester.display.toString();
                    }
                  } catch (e) {
                    Debug.printLog(e.toString());
                  }

                  try {
                    if (data.resource.owner.reference != null) {
                      toDoListData.ownerReference =
                          data.resource.owner.reference.toString();
                      toDoListData.ownerDisplay =
                          data.resource.owner.display.toString();
                    }
                  } catch (e) {
                    Debug.printLog(e.toString());
                  }


                  var insertedIdTaskId = 0;

                  /*var toDoCreatedDataList = Hive
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
                      data[0].text = toDoListData.text;
                      data[0].status = toDoListData.status;
                      data[0].priority = Utils.capitalizeFirstLetter(
                          toDoListData.priority.toString());
                      data[0].patientId = Utils.getPatientId();
                      data[0].providerId = Utils.getProviderId();
                      data[0].tag = toDoListData.tag;
                      data[0].createdDate = toDoListData.createdDate;
                      data[0].lastUpdatedDate = toDoListData.lastUpdatedDate;
                      data[0].focusReference = toDoListData.focusReference;
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
                        noteTableData.author = notesList[i].authorReference.display;
                        noteTableData.authorReference = notesList[i].authorReference.reference;
                      }
                      noteTableData.readOnly = false;
                      var date = Utils.getSplitDateFromAPIData(
                          notesList[i].time.toString());
                      noteTableData.date =
                          DateTime(date.year, date.month, date.day);
                      noteTableData.isDelete = true;
                      noteTableData.createdTaskId = insertedIdTaskId;
                      noteTableData.isTaskNote = true;
                      // noteTableData.isCreatedNote = false;
                      noteTableData.isCreatedNote = notesList[i].authorReference.toString().contains("Practitioner");
                      noteTableData.isAssignedNote = false;
                      toDoListData.noteList.add(noteTableData);
                      // await DataBaseHelper.shared.insertNoteData(noteTableData);
                    }
                  }

                  toDoCreatedDataList.add(toDoListData);
                  toDoCreatedDataListLocal.add(toDoListData);
                }
              }
            }
          }
        }
      }
    }

    update();
  }

  getToDoAssignedAPI() async {
    if (serverModelDataList.isNotEmpty) {
      for (int i = 0; i < serverModelDataList.length; i++) {
        var listData = await PaaProfiles.getToDoAssignedIndependentListApi(serverModelDataList[i]);
        if (listData != null) {
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
                        toDoListData.referralTypeCode = code.toString();
                        toDoListData.display = display.toString();
                        toDoListData.referralTypeDisplay = display.toString();
                        if(data.resource.code.text != null){
                          toDoListData.text = data.resource.code.text;
                        }
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
                        toDoListData.referralTypeDisplay = data.resource.code.coding[0].display;

                        if(data.resource.code.text != null){
                          toDoListData.text = data.resource.code.text;
                        }

                        var referralTypeCodeDataModel =
                        CodeToDoModel(display: toDoListData.display ?? "");

                        if (Utils.codeTodoList
                            .where((element) =>
                        element.display == toDoListData.display)
                            .toList()
                            .isEmpty) {
                          Utils.codeTodoList.add(referralTypeCodeDataModel);
                        }
                      }/* else if (data.resource.code.text != null) {
                        //Consider manually entered text
                        toDoListData.text = data.resource.code.text.toString();

                        var referralTypeCodeDataModel =
                        CodeToDoModel(display: toDoListData.text ?? "");

                        if (Utils.codeTodoList
                            .where((element) =>
                        element.display == toDoListData.text)
                            .toList()
                            .isEmpty) {
                          // Utils.codeTodoList.add(referralTypeCodeDataModel);
                          if (!Utils.codeTodoList.contains(
                              referralTypeCodeDataModel)) {
                            Utils.codeTodoList.add(referralTypeCodeDataModel);
                          }
                        }
                      }*/
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
                  if (data.resource.focus != null) {
                    if (data.resource.focus.reference != null) {
                      var focus = data.resource.focus.reference.toString();
                      toDoListData.focusReference = focus;
                    }
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
                  toDoListData.isCreated = false;
                  toDoListData.priority =
                      Utils.capitalizeFirstLetter(
                          data.resource.priority.toString());
                  // toDoListData.patientId = Utils.getPatientId();
                  // toDoListData.providerId = Utils.getProviderId();
                  toDoListData.status = status;
                  toDoListData.chosenContactText = chosenText;
                  toDoListData.generalResponseText = generalText;

                  if(data.resource.executionPeriod != null){
                    if(data.resource.executionPeriod.start != null){
                      toDoListData.startDate = data.resource.executionPeriod.start.valueDateTime;
                    }
                    if(data.resource.executionPeriod.end != null){
                      toDoListData.endDate = data.resource.executionPeriod.end.valueDateTime;
                    }
                  }
                  toDoListData.performerId = perfomerId;
                  toDoListData.performerName = perfomerName;
                  if(toDoListData.display == Constant.toDoCodeDisplayMakeContact){
                    toDoListData.makeContactDescription = description;
                  }else{
                    toDoListData.generalDescription = description;
                  }
                  toDoListData.reviewMaterialURL = url;
                  toDoListData.reviewMaterialTitle = title;

                  try {
                    if (data.resource.for_.reference != null) {
                      toDoListData.forReference =
                          data.resource.for_.reference.toString();
                      toDoListData.forDisplay =
                          data.resource.for_.display.toString();
                    }
                  } catch (e) {
                    Debug.printLog(e.toString());
                  }

                  try {
                    if (data.resource.requester.reference != null) {
                      toDoListData.requesterReference =
                          data.resource.requester.reference.toString();
                      toDoListData.requesterDisplay =
                          data.resource.requester.display.toString();
                    }
                  } catch (e) {
                    Debug.printLog(e.toString());
                  }


                  try {
                    if (data.resource.owner.reference != null) {
                      toDoListData.ownerReference =
                          data.resource.owner.reference.toString();
                      toDoListData.ownerDisplay =
                          data.resource.owner.display.toString();
                    }
                  } catch (e) {
                    Debug.printLog(e.toString());
                  }

                  if (data.resource.note != null) {
                    var notesList = data.resource.note;
                    for (int i = 0; i < notesList.length; i++) {
                      var noteTableData = NoteTableData();
                      noteTableData.notes = notesList[i].text.toString();
                      if (notesList[i].authorReference != null) {
                        noteTableData.author =
                            notesList[i].authorReference.display;
                        noteTableData.authorReference = notesList[i].authorReference.reference;
                      }
                      noteTableData.readOnly = false;
                      try {
                        var date = Utils.getSplitDateFromAPIData(
                            notesList[i].time.toString());
                        noteTableData.date =
                            DateTime(date.year, date.month, date.day);
                      } catch (e) {
                        Debug.printLog(e.toString());
                      }
                      noteTableData.isDelete = true;
                      // noteTableData.createdTaskId = insertedIdTaskId;
                      noteTableData.isTaskNote = true;
                      // noteTableData.isCreatedNote = false;
                      noteTableData.isCreatedNote = notesList[i].authorReference.toString().contains("Practitioner");
                      noteTableData.isAssignedNote = false;
                      toDoListData.noteList.add(noteTableData);
                      // await DataBaseHelper.shared.insertNoteData(noteTableData);
                    }
                  }

                  toDoCreatedDataList.add(toDoListData);
                  toDoCreatedDataListLocal.add(toDoListData);
                }
              }
            }
          }
        }
      }
    }
    // await getToDoDataList();
    update();
  }

  /*getToDoAssignedAPI() async {
    if (serverModelDataList.isNotEmpty) {
      for (int i = 0; i < serverModelDataList.length; i++) {
        var listData = await PaaProfiles.getToDoAssignedIndependentListApi(serverModelDataList[i]);
        if (listData != null) {
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
                      } else if (data.resource.code.text != null) {
                        //Consider manually entered text
                        toDoListData.text = data.resource.code.text.toString();

                        var referralTypeCodeDataModel =
                        CodeToDoModel(display: toDoListData.text ?? "");

                        if (Utils.codeTodoList
                            .where((element) =>
                        element.display == toDoListData.text)
                            .toList()
                            .isEmpty) {
                          // Utils.codeTodoList.add(referralTypeCodeDataModel);
                          if (!Utils.codeTodoList.contains(
                              referralTypeCodeDataModel)) {
                            Utils.codeTodoList.add(referralTypeCodeDataModel);
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
                  if (data.resource.focus != null) {
                    if (data.resource.focus.reference != null) {
                      var focus = data.resource.focus.reference.toString();
                      toDoListData.focusReference = focus;
                    }
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
                  toDoListData.isCreated = false;
                  toDoListData.priority =
                      Utils.capitalizeFirstLetter(
                          data.resource.priority.toString());
                  toDoListData.patientId = Utils.getPatientId();
                  toDoListData.providerId = Utils.getProviderId();
                  toDoListData.status = status;

                  try {
                    if (data.resource.for_.reference != null) {
                      toDoListData.forReference =
                          data.resource.for_.reference.toString();
                      toDoListData.forDisplay =
                          data.resource.for_.display.toString();
                    }
                  } catch (e) {
                    Debug.printLog(e.toString());
                  }

                  try {
                    if (data.resource.requester.reference != null) {
                      toDoListData.requesterReference =
                          data.resource.requester.reference.toString();
                      toDoListData.requesterDisplay =
                          data.resource.requester.display.toString();
                    }
                  } catch (e) {
                    Debug.printLog(e.toString());
                  }


                  try {
                    if (data.resource.owner.reference != null) {
                      toDoListData.ownerReference =
                          data.resource.owner.reference.toString();
                      toDoListData.ownerDisplay =
                          data.resource.owner.display.toString();
                    }
                  } catch (e) {
                    Debug.printLog(e.toString());
                  }

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
                      data[0].isCreated = false;
                      data[0].display = toDoListData.display;
                      data[0].status = toDoListData.status;
                      data[0].priority = Utils.capitalizeFirstLetter(
                          toDoListData.priority.toString());
                      data[0].patientId = Utils.getPatientId();
                      data[0].providerId = Utils.getProviderId();
                      data[0].text = toDoListData.text;
                      data[0].tag = toDoListData.tag;
                      data[0].createdDate = toDoListData.createdDate;
                      data[0].lastUpdatedDate = toDoListData.lastUpdatedDate;
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
                      try {
                        var date = Utils.getSplitDateFromAPIData(
                            notesList[i].time.toString());
                        noteTableData.date =
                            DateTime(date.year, date.month, date.day);
                      } catch (e) {
                        Debug.printLog(e.toString());
                      }
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
      }
    }
    await getToDoDataList();
    update();
  }*/

  changeMode(int value){
    selectedTabBarValue = value;
    if(value == 1){
      getPatientList();
    }else if (value == 2){
      getListPractitioner();
    }
    update();
  }

  onChangeProgressValue(bool value){
    isShowProgress = value;
    update();
  }

  getAllPreferenceData(){
    fName = Preference.shared.getString(Preference.patientFName) ?? "";
    lName = Preference.shared.getString(Preference.patientLName) ?? "";
    dob = Preference.shared.getString(Preference.patientDob) ?? "";
    gender = Preference.shared.getString(Preference.patientGender) ?? "";
  }

  var listData;

  getPatientList({bool isBack = false,String valuesId = "",String valuesName = ""}) async {
    await Utils.isExpireTokenAPICall(Constant.screenTypeHome,(value) async {
      if(!value){
        await callPatientGetAPI(isBack: isBack,valuesId:valuesId,valuesName:valuesName);
      }
    }).then((value) async {
      if(!value){
        await callPatientGetAPI(isBack: isBack,valuesId:valuesId,valuesName:valuesName);
      }
    });
  }

  callPatientGetAPI({bool isBack = false,String valuesId = "",String valuesName = ""}){
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), () async {
      patientProfileList.clear();
      onChangeProgressValue(true);
      if(isBack){
        Get.back();
      }
      listData = await PaaProfiles.getPatientListTestUse(R4ResourceType.Patient, searchIdControllers.text,searchNameControllers.text,selectedUrlModel!);
      if (listData.resourceType == R4ResourceType.Bundle) {
        patientProfileList.clear();

        if (listData != null && listData.entry != null) {
          int length = listData.entry.length;
          for (int i = 0; i < length; i++) {
            if (listData.entry[i].resource.resourceType ==
                R4ResourceType.Patient) {
              var patientData = PatientDataModel();
              var data = listData.entry[i];
              var id;
              if (data.resource.id != null) {
                id = data.resource.id.toString();
              }
              List<EmergencyContactModelLocal>  emergencyContactModelLocalList = [];
              List<GeneralPractitioner>  generalPractitionerList = [];

              try{
                if(data.resource.generalPractitioner != null){
                  for(int i = 0;i<data.resource.generalPractitioner.length;i++){
                    GeneralPractitioner generalPractitioner = GeneralPractitioner();
                    generalPractitioner.providerId = data.resource.generalPractitioner[i].reference.toString().split("/")[1];
                    generalPractitioner.displayName = data.resource.generalPractitioner[i].display.toString();
                    if(generalPractitioner.providerId != "" ||  generalPractitioner.providerId != null ){
                      generalPractitionerList.add(generalPractitioner);
                    }
                  }
                }
              }catch (e){
                Debug.printLog("...$e");
              }

              try{
                if(data.resource.contact != null){
                  for(int i =0 ;i< data.resource.contact.length;i++){
                    EmergencyContactModelLocal emergencyContactModel = EmergencyContactModelLocal();
                    emergencyContactModel.patientNameController.text = data.resource.contact[i].name.text.toString();
                    emergencyContactModel.phoneNumberController.text = data.resource.contact[i].telecom[0].value.toString();
                    emergencyContactModelLocalList.add(emergencyContactModel);
                    Debug.printLog("emergencyContactModelLocalList......${emergencyContactModel.phoneNumberController.text.toString()}");
                  }
                }
              }catch(e){
                Debug.printLog("...$e");
              }

              List<PhoneNumberListModelLocal>  phoneNoList = [];
              List<EmailIdModelLocal>  emailIdList = [];

              try{
                if(data.resource.telecom != null){
                  for(int i =0 ;i<data.resource.telecom.length;i++ ){
                    PhoneNumberListModelLocal phoneNoModel = PhoneNumberListModelLocal();
                    EmailIdModelLocal emailIdModel = EmailIdModelLocal();
                    if(data.resource.telecom[i].system == ContactPointSystem.email){
                      emailIdModel.emailIdType = data.resource.telecom[i].system;
                      emailIdModel.emailIdControllers.text = data.resource.telecom[i].value.toString();
                      emailIdList.add(emailIdModel);
                    }else{
                      phoneNoModel.phoneSystemType = data.resource.telecom[i].system;
                      phoneNoModel.phoneUse = data.resource.telecom[i].use;
                      phoneNoModel.phoneNumberController.text = data.resource.telecom[i].value.toString();
                      phoneNoList.add(phoneNoModel);
                    }
                  }
                }
              }catch(e){
                Debug.printLog("...$e");
              }

              List<AddressModelLocal>  addressList = [];

              try{
                if(data.resource.address != null){
                  AddressModelLocal addressModelList = AddressModelLocal();
                  for(int i=0 ; i <data.resource.address.length; i++){
                    addressModelList = AddressModelLocal();
                    addressModelList.addressType = data.resource.address[i].type;
                    addressModelList.city.text = data.resource.address[i].city.toString();
                    addressModelList.state.text = data.resource.address[i].state.toString();
                    addressModelList.pinCode.text = data.resource.address[i].postalCode.toString();
                    addressModelList.address1.text = data.resource.address[i].line[0].toString();
                    addressModelList.address2.text = data.resource.address[i].line[1].toString();
                    addressList.add(addressModelList);
                  }
                }
              }catch(e){
                Debug.printLog("...$e");
              }


              var lName = "";
              try {
                lName = data.resource.name[0].family.toString();
              } catch (e) {
                Debug.printLog("lName...$e");
              }
              var fName = "";
              List<String> givenNameList = [];
              try {
                for(int i = 0; i<data.resource.name[0].given.length;i++){
                  givenNameList.add("${data.resource.name[0].given[i]} ");
                  fName += "${data.resource.name[0].given[i]} ";
                }
                // fName = data.resource.name[0].given[0].toString();
              } catch (e) {
                Debug.printLog("fName...$e");
              }

              var gender = "";
              try {
                gender = data.resource.gender.toString();
              } catch (e) {
                Debug.printLog("lName...$e");
              }

              var dob = "";
              try {
                dob = data.resource.birthDate.toString();
                // DateTime dateTime = DateTime.parse(dob);
                // String formattedDateTime = DateFormat(Constant.commonDateFormatMmmDdYyyy).format(dateTime);
                // Debug.printLog('Formatted DateTime: $formattedDateTime');
                // dob = formattedDateTime;
              } catch (e) {
                Debug.printLog("lName...$e");
              }

              patientData.patientId = id;
              patientData.fName = fName;
              patientData.givenNameList = givenNameList;
              patientData.lName = lName;
              patientData.dob = dob;
              patientData.gender = gender;
              patientData.phoneNoList = phoneNoList;
              patientData.emailIdList = emailIdList;
              patientData.addressModelList = addressList;
              patientData.emergencyContactModelLocalList = emergencyContactModelLocalList;
              patientData.generalPractitioner = generalPractitionerList;
              patientProfileList.add(patientData);
              Debug.printLog(
                  "patient info....$fName  $lName  $gender  $dob  $id");
            }
          }
        }
      }
      Preference.shared
          .setString(Preference.getPatientFNameApi, searchNameControllers.text);
      onChangeProgressValue(false);
      update();
      if(isBack){
        callApiAndGetPatient(valuesId,valuesName);
      }
      Debug.printLog("getPatientList....$patientProfileList");
    });
  }
   callApiAndGetPatient(String id,String name) async {
    listData = await PaaProfiles.getPatientListTestUse(R4ResourceType.Patient, id,name,selectedUrlModel!);
    if (listData.resourceType == R4ResourceType.Bundle) {
      if (listData != null && listData.entry != null) {
        int length = listData.entry.length;
        for (int i = 0; i < length; i++) {
          if (listData.entry[i].resource.resourceType ==
              R4ResourceType.Patient) {
            var patientData = PatientDataModel();
            var data = listData.entry[i];
            var id;
            if (data.resource.id != null) {
              id = data.resource.id.toString();
            }
            List<EmergencyContactModelLocal>  emergencyContactModelLocalList = [];
            List<GeneralPractitioner>  generalPractitionerList = [];

            try{
              if(data.resource.generalPractitioner != null){
                for(int i = 0;i<data.resource.generalPractitioner.length;i++){
                  GeneralPractitioner generalPractitioner = GeneralPractitioner();
                  generalPractitioner.providerId = data.resource.generalPractitioner[i].reference.toString().split("/")[1];
                  generalPractitioner.displayName = data.resource.generalPractitioner[i].display.toString();
                  if(generalPractitioner.providerId != "" ||  generalPractitioner.providerId != null ){
                    generalPractitionerList.add(generalPractitioner);
                  }
                }
              }
            }catch (e){
              Debug.printLog("...$e");
            }

            try{
              if(data.resource.contact != null){
                for(int i =0 ;i< data.resource.contact.length;i++){
                  EmergencyContactModelLocal emergencyContactModel = EmergencyContactModelLocal();
                  emergencyContactModel.patientNameController.text = data.resource.contact[i].name.text.toString();
                  emergencyContactModel.phoneNumberController.text = data.resource.contact[i].telecom[0].value.toString();
                  emergencyContactModelLocalList.add(emergencyContactModel);
                  Debug.printLog("emergencyContactModelLocalList......${emergencyContactModel.phoneNumberController.text.toString()}");
                }
              }
            }catch(e){
              Debug.printLog("...$e");
            }

            List<PhoneNumberListModelLocal>  phoneNoList = [];
            List<EmailIdModelLocal>  emailIdList = [];

            try{
              if(data.resource.telecom != null){
                for(int i =0 ;i<data.resource.telecom.length;i++ ){
                  PhoneNumberListModelLocal phoneNoModel = PhoneNumberListModelLocal();
                  EmailIdModelLocal emailIdModel = EmailIdModelLocal();
                  if(data.resource.telecom[i].system == ContactPointSystem.email){
                    emailIdModel.emailIdType = data.resource.telecom[i].system;
                    emailIdModel.emailIdControllers.text = data.resource.telecom[i].value.toString();
                    emailIdList.add(emailIdModel);
                  }else{
                    phoneNoModel.phoneSystemType = data.resource.telecom[i].system;
                    phoneNoModel.phoneUse = data.resource.telecom[i].use;
                    phoneNoModel.phoneNumberController.text = data.resource.telecom[i].value.toString();
                    phoneNoList.add(phoneNoModel);
                  }
                }
              }
            }catch(e){
              Debug.printLog("...$e");
            }

            List<AddressModelLocal>  addressList = [];

            try{
              if(data.resource.address != null){
                AddressModelLocal addressModelList = AddressModelLocal();
                for(int i=0 ; i <data.resource.address.length; i++){
                  addressModelList = AddressModelLocal();
                  addressModelList.addressType = data.resource.address[i].type;
                  addressModelList.city.text = data.resource.address[i].city.toString();
                  addressModelList.state.text = data.resource.address[i].state.toString();
                  addressModelList.pinCode.text = data.resource.address[i].postalCode.toString();
                  addressModelList.address1.text = data.resource.address[i].line[0].toString();
                  addressModelList.address2.text = data.resource.address[i].line[1].toString();
                  addressList.add(addressModelList);
                }
              }
            }catch(e){
              Debug.printLog("...$e");
            }


            var lName = "";
            try {
              lName = data.resource.name[0].family.toString();
            } catch (e) {
              Debug.printLog("lName...$e");
            }
            var fName = "";
            List<String> givenNameList = [];
            try {
              for(int i = 0; i<data.resource.name[0].given.length;i++){
                givenNameList.add("${data.resource.name[0].given[i]} ");
                fName += "${data.resource.name[0].given[i]} ";
              }
              // fName = data.resource.name[0].given[0].toString();
            } catch (e) {
              Debug.printLog("fName...$e");
            }

            var gender = "";
            try {
              gender = data.resource.gender.toString();
            } catch (e) {
              Debug.printLog("lName...$e");
            }

            var dob = "";
            try {
              dob = data.resource.birthDate.toString();
              // DateTime dateTime = DateTime.parse(dob);
              // String formattedDateTime = DateFormat(Constant.commonDateFormatMmmDdYyyy).format(dateTime);
              // Debug.printLog('Formatted DateTime: $formattedDateTime');
              // dob = formattedDateTime;
            } catch (e) {
              Debug.printLog("lName...$e");
            }

            patientData.patientId = id;
            patientData.fName = fName;
            patientData.givenNameList = givenNameList;
            patientData.lName = lName;
            patientData.dob = dob;
            patientData.gender = gender;
            patientData.phoneNoList = phoneNoList;
            patientData.emailIdList = emailIdList;
            patientData.addressModelList = addressList;
            patientData.emergencyContactModelLocalList = emergencyContactModelLocalList;
            patientData.generalPractitioner = generalPractitionerList;
            if(patientProfileList.where((element) => element.patientId == id).toList().isEmpty){
              patientProfileList.insert(0,patientData);
            }
            Debug.printLog(
                "patient info....$fName  $lName  $gender  $dob  $id");
          }
        }
      }
    }
    Preference.shared
        .setString(Preference.getPatientFNameApi, searchNameControllers.text);
    update();
  }

  saveDetail(int index) async {
    // serverModelDataList = Preference.shared.getServerListedAllUrl(Preference.serverUrlAllListed) ?? [];
    serverModelDataList = Utils.getServerList;
    // serverModelDataList = serverModelDataList.where((element) => element.isSelected).toList();
    int serverIndex = serverModelDataList.indexWhere((element) => element.isPrimary && element.isSelected).toInt();
    serverModelDataList[serverIndex].patientId = patientProfileList[index].patientId;
    // String fName = "";
    // for(int i =0 ;i<practitionerProfileList[index].fName.length;i++){
    //   fName += practitionerProfileList[index].fName[i];
    // }
    serverModelDataList[serverIndex].patientFName = patientProfileList[index].fName;
    serverModelDataList[serverIndex].patientLName = patientProfileList[index].lName;
    serverModelDataList[serverIndex].patientDOB = patientProfileList[index].dob;
    serverModelDataList[serverIndex].patientGender = patientProfileList[index].gender;


    Preference.shared.setString(Preference.patientId, patientProfileList[index].patientId);
    Preference.shared.setString(Preference.patientFName, patientProfileList[index].fName);
    Preference.shared.setString(Preference.patientLName, patientProfileList[index].lName);
    Preference.shared.setString(Preference.patientDob, patientProfileList[index].dob);
    Preference.shared.setString(Preference.patientGender, patientProfileList[index].gender);

    var json = jsonEncode(serverModelDataList.map((e) => e.toJson()).toList());
    Preference.shared.setList(Preference.serverUrlAllListed,json);

    Preference.shared.setBool(Constant.keyIndependentPatient, false);
    Preference.shared.setBool(Constant.keyWelcomeDetails, false);
    Utils.clearTrackingChartData();
    moveToScreen();
    update();
  }

  moveToScreen() async {
    Utils.getPerformerDataList(selectedUrlModel!);
    Preference.shared.setBool(Constant.keyWelcomeDetails,false);

    if(isFromSetting){
      BottomNavigationController bottomNavigationController = Get.find();
      bottomNavigationController.updateMethod();
      Get.back();
    }else if(isFromQrConnect) {
      Get.back();Get.back();
    }else if(isFromSelectPrimary){
      Get.back();Get.back();Get.back();
    }else if(isFromSelectProvider){
      Get.back();Get.back();Get.back();Get.back();
    } else {
      Get.offAllNamed(AppRoutes.bottomNavigation);
    }
    patientProfileList.clear();
    update();
  }

  void onRefresh() async{
    // await Future.delayed(Duration(milliseconds: 1000));
    toDoCreatedDataList.clear();
    toDoCreatedDataListLocal.clear();
    await getToDoCreatedDataListApi();
    await getToDoAssignedAPI();
    refreshController.refreshCompleted();
    Debug.printLog("Complete Api Call.......");
    update([]);
  }
  void onLoading() async{
    await Future.delayed(const Duration(milliseconds: 1000));
    refreshController.loadComplete();
  }

  List<StatusFilterDataModel> getFilterListStatusWise(String status){
    return Utils.statusFilter.where((element) => element.fromType == status).toList();
  }

  void onChangeFilterDataTapOnOk(String fromType) {
    // referralListData.clear();
    // if(getFilterListStatusWise(fromType).where((element) => element.isSelected).toList().isNotEmpty) {


    if(fromType == Constant.homePatientTask) {
      toDoCreatedDataList.clear();
    }

    var selectedStatusList = getFilterListStatusWise(fromType)
        .where((element) => element.isSelected)
        .toList();

    if(selectedStatusList.isNotEmpty) {


      if(fromType == Constant.homePatientTask){
        var tempList = toDoCreatedDataListLocal
            .where((element) => selectedStatusList.where((elementSelected)
        => elementSelected.status == element.status).toList().isNotEmpty)
            .toList();
        toDoCreatedDataList = tempList;
      }
    }
    else{

      if(fromType == Constant.homePatientTask) {
        toDoCreatedDataList.addAll(toDoCreatedDataListLocal);
      }
    }

    Get.back();
    update();
  }

  void onChangeFilterDara(bool selected, int index,String fromType) {
    getFilterListStatusWise(fromType)[index].isSelected = selected;
    update();
  }


  getListPractitioner({bool isBack = false ,String valueId = "",String valueName = ""}) async {
    await Utils.isExpireTokenAPICall(Constant.screenTypeHome,(value) async {
      if(!value){
        await callProviderGetAPI(isBack: isBack,valueId:valueId,valueName:valueName);
      }
    }).then((value) async {
      if(!value){
        await callProviderGetAPI(isBack: isBack,valueId:valueId,valueName:valueName);
      }
    });
  }

  callProviderGetAPI({bool isBack = false ,String valueId = "",String valueName = ""}){
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), () async {
      practitionerProfileList.clear();
      onChangeProgressValue(true);
      if(isBack){
        Get.back();
      }
      listData = await PaaProfiles.getPractitionerListTestUse(
          R4ResourceType.Practitioner,
          searchIdControllersPractitioner.text,
          searchNameControllersPractitioner.text);
      if (listData.resourceType == R4ResourceType.Bundle) {
        practitionerProfileList.clear();
        if (listData != null && listData.entry != null) {
          int length = listData.entry.length;
          for (int i = 0; i < length; i++) {
            if (listData.entry[i].resource.resourceType ==
                R4ResourceType.Practitioner) {
              var patientData = PatientDataModel();
              var data = listData.entry[i];
              var id;
              if (data.resource.id != null) {
                id = data.resource.id.toString();
              }
              var lName = "";
              try {
                lName = data.resource.name[0].family.toString();
              } catch (e) {
                Debug.printLog("lName...$e");
              }

              var fName = "";
              List<String> givenNameList = [];
              try {
                for(int i = 0; i<data.resource.name[0].given.length;i++){
                  givenNameList.add("${data.resource.name[0].given[i]} ");
                  fName += "${data.resource.name[0].given[i]} ";
                }
                // fName = data.resource.name[0].given[0].toString();
              } catch (e) {
                Debug.printLog("fName...$e");
              }

              List<PhoneNumberListModelLocal>  phoneNoList = [];
              List<EmailIdModelLocal>  emailIdList = [];

              try{
                if(data.resource.telecom != null){
                  for(int i =0 ;i<data.resource.telecom.length;i++ ){
                    PhoneNumberListModelLocal phoneNoModel = PhoneNumberListModelLocal();
                    EmailIdModelLocal emailIdModel = EmailIdModelLocal();
                    if(data.resource.telecom[i].system == ContactPointSystem.email){
                      emailIdModel.emailIdType = data.resource.telecom[i].system;
                      emailIdModel.emailIdControllers.text = data.resource.telecom[i].value.toString();
                      emailIdList.add(emailIdModel);
                    }else{
                      phoneNoModel.phoneSystemType = data.resource.telecom[i].system;
                      phoneNoModel.phoneUse = data.resource.telecom[i].use;
                      phoneNoModel.phoneNumberController.text = data.resource.telecom[i].value.toString();
                      phoneNoList.add(phoneNoModel);
                    }
                  }
                }
              }catch(e){
                Debug.printLog("...$e");
              }

              List<AddressModelLocal>  addressList = [];
              try{
                if(data.resource.address != null){
                  AddressModelLocal addressModelList = AddressModelLocal();
                  for(int i=0 ; i <data.resource.address.length; i++){
                    if(data.resource.address[i].type != null) {
                      addressModelList.addressType =
                          data.resource.address[i].type;
                    }
                    if(data.resource.address[i].city != null) {
                      addressModelList.city.text =
                          data.resource.address[i].city.toString();
                    }

                    if(data.resource.address[i].state != null) {
                      addressModelList.state.text =
                          data.resource.address[i].state.toString();
                    }

                    if(data.resource.address[i].postalCode != null) {
                      addressModelList.pinCode.text = data.resource.address[i].postalCode.toString();
                    }

                    if(data.resource.address[i].line[0] != null) {
                      addressModelList.address1.text = data.resource.address[i].line[0].toString();

                    }
                    if(data.resource.address[i].line[1] != null) {
                      addressModelList.address2.text = data.resource.address[i].line[1].toString();

                    }
                    addressList.add(addressModelList);
                  }
                }
              }catch(e){
                Debug.printLog("...$e");
              }

              List<QualificationDataClass>  qualificationLocalList = [];
              try{
                if(data.resource.qualification != null){
                  for(int i =0 ;i< data.resource.qualification.length;i++){
                    QualificationDataClass emergencyContactModel = QualificationDataClass();
                    emergencyContactModel.codeText = data.resource.qualification[i].code.coding[0].code.toString();
                    Debug.printLog("qualificationLocalList codeText......${emergencyContactModel.codeText}");
                    qualificationLocalList.add(emergencyContactModel);
                  }
                }
              }catch(e){
                Debug.printLog("...$e");
              }

              var gender = "";
              try {
                gender = Utils.capitalizeFirstLetter(data.resource.gender.toString());
              } catch (e) {
                Debug.printLog("lName...$e");
              }

              var dob = "";
              try {
                dob = data.resource.birthDate.toString();
                // DateTime dateTime = DateTime.parse(dob);
                // String formattedDateTime = DateFormat(Constant.commonDateFormatMmmDdYyyy).format(dateTime);
                // Debug.printLog('Formatted DateTime: $formattedDateTime');
                // dob = formattedDateTime;
              } catch (e) {
                Debug.printLog("lName...$e");
              }

              patientData.patientId = id;
              patientData.fName = fName;
              patientData.givenNameList = givenNameList;
              patientData.lName = lName;
              patientData.dob = dob;
              patientData.gender = gender;
              patientData.phoneNoList = phoneNoList;
              patientData.addressModelList = addressList;
              patientData.emailIdList = emailIdList;
              patientData.qualificationDataList = qualificationLocalList;
              practitionerProfileList.add(patientData);
              Debug.printLog(
                  "patient info....$fName  $lName  $gender  $dob  $id");
            }
          }
        }
      }
      Preference.shared
          .setString(Preference.getPractitionerFNameApi, searchNameControllers.text);
      onChangeProgressValue(false);
      update();
      if(isBack){
        await callApiAndGetPractitioner(valueId,valueName);
      }
      Debug.printLog("getPatientList....$practitionerProfileList");
    });
  }


  callApiAndGetPractitioner(String id,String name) async {
    listData = await PaaProfiles.getPractitionerListTestUse(
        R4ResourceType.Practitioner,
        id,
        name);
    if (listData.resourceType == R4ResourceType.Bundle) {
      if (listData != null && listData.entry != null) {
        int length = listData.entry.length;
        for (int i = 0; i < length; i++) {
          if (listData.entry[i].resource.resourceType ==
              R4ResourceType.Practitioner) {
            var patientData = PatientDataModel();
            var data = listData.entry[i];
            var id;
            if (data.resource.id != null) {
              id = data.resource.id.toString();
            }
            var lName = "";
            try {
              lName = data.resource.name[0].family.toString();
            } catch (e) {
              Debug.printLog("lName...$e");
            }

            var fName = "";
            List<String> givenNameList = [];
            try {
              for(int i = 0; i<data.resource.name[0].given.length;i++){
                givenNameList.add("${data.resource.name[0].given[i]} ");
                fName += "${data.resource.name[0].given[i]} ";
              }
              // fName = data.resource.name[0].given[0].toString();
            } catch (e) {
              Debug.printLog("fName...$e");
            }

            List<PhoneNumberListModelLocal>  phoneNoList = [];
            List<EmailIdModelLocal>  emailIdList = [];

            try{
              if(data.resource.telecom != null){
                for(int i =0 ;i<data.resource.telecom.length;i++ ){
                  PhoneNumberListModelLocal phoneNoModel = PhoneNumberListModelLocal();
                  EmailIdModelLocal emailIdModel = EmailIdModelLocal();
                  if(data.resource.telecom[i].system == ContactPointSystem.email){
                    emailIdModel.emailIdType = data.resource.telecom[i].system;
                    emailIdModel.emailIdControllers.text = data.resource.telecom[i].value.toString();
                    emailIdList.add(emailIdModel);
                  }else{
                    phoneNoModel.phoneSystemType = data.resource.telecom[i].system;
                    phoneNoModel.phoneUse = data.resource.telecom[i].use;
                    phoneNoModel.phoneNumberController.text = data.resource.telecom[i].value.toString();
                    phoneNoList.add(phoneNoModel);
                  }
                }
              }
            }catch(e){
              Debug.printLog("...$e");
            }

            List<AddressModelLocal>  addressList = [];
            try{
              if(data.resource.address != null){
                AddressModelLocal addressModelList = AddressModelLocal();
                for(int i=0 ; i <data.resource.address.length; i++){
                  if(data.resource.address[i].type != null) {
                    addressModelList.addressType =
                        data.resource.address[i].type;
                  }
                  if(data.resource.address[i].city != null) {
                    addressModelList.city.text =
                        data.resource.address[i].city.toString();
                  }

                  if(data.resource.address[i].state != null) {
                    addressModelList.state.text =
                        data.resource.address[i].state.toString();
                  }

                  if(data.resource.address[i].postalCode != null) {
                    addressModelList.pinCode.text = data.resource.address[i].postalCode.toString();
                  }

                  if(data.resource.address[i].line[0] != null) {
                    addressModelList.address1.text = data.resource.address[i].line[0].toString();

                  }
                  if(data.resource.address[i].line[1] != null) {
                    addressModelList.address2.text = data.resource.address[i].line[1].toString();

                  }
                  addressList.add(addressModelList);
                }
              }
            }catch(e){
              Debug.printLog("...$e");
            }

            List<QualificationDataClass>  qualificationLocalList = [];
            try{
              if(data.resource.qualification != null){
                for(int i =0 ;i< data.resource.qualification.length;i++){
                  QualificationDataClass emergencyContactModel = QualificationDataClass();
                  emergencyContactModel.codeText = data.resource.qualification[i].code.coding[0].code.toString();
                  Debug.printLog("qualificationLocalList codeText......${emergencyContactModel.codeText}");
                  qualificationLocalList.add(emergencyContactModel);
                }
              }
            }catch(e){
              Debug.printLog("...$e");
            }

            var gender = "";
            try {
              gender = Utils.capitalizeFirstLetter(data.resource.gender.toString());
            } catch (e) {
              Debug.printLog("lName...$e");
            }

            var dob = "";
            try {
              dob = data.resource.birthDate.toString();
              // DateTime dateTime = DateTime.parse(dob);
              // String formattedDateTime = DateFormat(Constant.commonDateFormatMmmDdYyyy).format(dateTime);
              // Debug.printLog('Formatted DateTime: $formattedDateTime');
              // dob = formattedDateTime;
            } catch (e) {
              Debug.printLog("lName...$e");
            }

            patientData.patientId = id;
            patientData.fName = fName;
            patientData.givenNameList = givenNameList;
            patientData.lName = lName;
            patientData.dob = dob;
            patientData.gender = gender;
            patientData.phoneNoList = phoneNoList;
            patientData.addressModelList = addressList;
            patientData.emailIdList = emailIdList;
            patientData.qualificationDataList = qualificationLocalList;
            if(practitionerProfileList.where((element) => element.patientId ==id ).toList().isEmpty){
              practitionerProfileList.insert(0,patientData);
            }
            Debug.printLog(
                "patient info....$fName  $lName  $gender  $dob  $id");
          }
        }
      }
    }
    Preference.shared
        .setString(Preference.getPractitionerFNameApi, searchNameControllers.text);
    update();

  }

  saveDetailPractitioner(int index) async {

    // serverModelDataList = Preference.shared.getServerListedAllUrl(Preference.serverUrlAllListed) ?? [];
    serverModelDataList = Utils.getServerList;
    serverModelDataList = serverModelDataList.where((element) => element.isSelected).toList();
    int serverIndex = serverModelDataList.indexWhere((element) => element.isPrimary).toInt();
    /// use Patient Name But That inside a Value is a Provider .... Ids, name,Lastname etc...
    serverModelDataList[serverIndex].providerId = practitionerProfileList[index].patientId;
    // String fName = "";
    // for(int i =0 ;i<practitionerProfileList[index].fName.length;i++){
    //   fName += practitionerProfileList[index].fName[i];
    // }
    serverModelDataList[serverIndex].providerFName = practitionerProfileList[index].fName;
    serverModelDataList[serverIndex].providerLName = practitionerProfileList[index].lName;
    serverModelDataList[serverIndex].providerDOB = practitionerProfileList[index].dob;
    serverModelDataList[serverIndex].providerGender = practitionerProfileList[index].gender;
    // serverModelDataList[serverIndex].patientDOB = practitionerProfileList[index].dob;
    // serverModelDataList[serverIndex].patientGender = practitionerProfileList[index].gender;

    Preference.shared.setString(Preference.providerId, practitionerProfileList[index].patientId);
    Preference.shared.setString(Preference.providerName, practitionerProfileList[index].fName);
    Preference.shared.setString(Preference.providerLastName, practitionerProfileList[index].lName);

    var json = jsonEncode(serverModelDataList.map((e) => e.toJson()).toList());
    Preference.shared.setList(Preference.serverUrlAllListed,json);

    Preference.shared.setBool(Constant.keyIndependentPatient, false);
    Preference.shared.setBool(Constant.keyWelcomeDetails, false);
    if(Utils.getPatientId() != ""){
      moveToScreen();
    }/*else{
      Utils.showToast(Get.context!, "Please select PatientId");
    }*/
    update();
  }


  void onRefreshPatient() async{
    await getPatientList();
    refreshPatient.refreshCompleted();
    Debug.printLog("Complete Api Call.......");
    update([]);
  }
  void onLoadingPatient() async{
    await Future.delayed(const Duration(milliseconds: 1000));
    refreshPatient.loadComplete();
  }

  void onRefreshProvider() async{
    await getListPractitioner();
    refreshProvider.refreshCompleted();
    Debug.printLog("Complete Api Call.......");
    update([]);
  }
  void onLoadingProvider() async{
    await Future.delayed(const Duration(milliseconds: 1000));
    refreshProvider.loadComplete();
  }

  String shortingNameTODO(String value){
    if(value == Constant.toDoStatusCompleted){
      value = Constant.toDoStatusAwaitingReview;
    }
    return value;
  }

  updateMethod() {
    update();
  }
}
