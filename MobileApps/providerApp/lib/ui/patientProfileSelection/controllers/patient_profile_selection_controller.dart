import 'dart:async';
import 'dart:convert';

import 'package:banny_table/dataModel/patientDataModel.dart';
import 'package:banny_table/resources/PaaProfiles.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/qrScanner/datamodel/serverModel.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/qrScanner/datamodel/serverModelJson.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:fhir/r4/resource/resource.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class PatientProfileSelectionController extends GetxController {

  var fName = "";
  var lName = "";
  var dob = "";
  var gender = "";
  Timer? _debounceTimer;
  FocusNode searchIdFocus = FocusNode();
  FocusNode searchNameFocus = FocusNode();
  TextEditingController searchIdControllers = TextEditingController();
  TextEditingController searchNameControllers = TextEditingController();
  List<PatientDataModel> patientProfileList = [];
  bool isShowProgress = false;
  String fromScreenType = "";
  var arguments = Get.arguments;
  List<ServerModelJson> serverModelDataList = [];
  ServerModelJson? selectedUrlModel;

  @override
  void onInit() {
    if(arguments != null){
      if(arguments[0] != null){
        fromScreenType = arguments[0];
      }
    }
    getServerModelData();
    getAllPreferenceData();
    super.onInit();
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

  getPatientList() async {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), () async {
      patientProfileList.clear();
      onChangeProgressValue(true);
      var listData = await PaaProfiles.getPatientListTestUse(R4ResourceType.Patient, searchIdControllers.text,searchNameControllers.text,selectedUrlModel!);
      if (listData.resourceType == R4ResourceType.Bundle) {
        patientProfileList.clear();

        if (listData != null && listData.entry != null) {
          int length = listData.entry.length;
          for (int i = 0; i < length ; i++) {
            if (listData.entry[i].resource.resourceType == R4ResourceType.Patient) {
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
              try {
                fName = data.resource.name[0].given[0].toString();
              } catch (e) {
                Debug.printLog("lName...$e");
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
              } catch (e) {
                Debug.printLog("lName...$e");
              }

              /// Check For the Configuration DATA ADD
              /*if(fName.toLowerCase() == "Chcek Configuration".toLowerCase()){
                  checkConfiguration = listData.entry[i].resource.address[0].text.toString();
                  Debug.printLog("checkConfiguration json Data .... $checkConfiguration");
                }*/

              patientData.patientId = id;
              patientData.fName = fName;
              patientData.lName = lName;
              patientData.dob = dob;
              patientData.gender = gender;
              patientProfileList.add(patientData);


              Debug.printLog(
                  "patient info....$fName  $lName  $gender  $dob  $id");
            }
          }
        }
      }
      Preference.shared.setString(Preference.getPatientFNameApi, searchNameControllers.text);
      onChangeProgressValue(false);
      update();
      Debug.printLog("getPatientList....$patientProfileList");
    });
  }
  getServerModelData(){
    // serverModelDataList = Preference.shared.getServerListedAllUrl(Preference.serverUrlAllListed) ?? [];
    serverModelDataList = Utils.getServerList;
    selectedUrlModel = serverModelDataList.where((element) => element.isSelected && !element.isSecure).toList()[0];
    update();
  }

  saveDetail(int index) async {
    // serverModelDataList = Preference.shared.getServerListedAllUrl(Preference.serverUrlAllListed) ?? [];
    serverModelDataList = Utils.getServerList;
    serverModelDataList = serverModelDataList.where((element) => element.isSelected).toList();
    int serverIndex = serverModelDataList.indexWhere((element) => element.isPrimary).toInt();
    serverModelDataList[serverIndex].patientId = patientProfileList[index].patientId;
    serverModelDataList[serverIndex].patientFName = patientProfileList[index].fName;
    serverModelDataList[serverIndex].patientLName = patientProfileList[index].lName;
    serverModelDataList[serverIndex].patientDOB = patientProfileList[index].dob;
    serverModelDataList[serverIndex].patientGender = patientProfileList[index].gender;

    // selectedUrlModel!.patientId = patientProfileList[index].patientId;
    // selectedUrlModel!.patientFName =patientProfileList[index].fName;
    // selectedUrlModel!.patientLName =patientProfileList[index].lName;

    Preference.shared.setString(Preference.patientId, patientProfileList[index].patientId);
    Preference.shared.setString(Preference.patientFName, patientProfileList[index].fName);
    Preference.shared.setString(Preference.patientLName, patientProfileList[index].lName);
    Preference.shared.setString(Preference.patientDob, patientProfileList[index].dob);
    Preference.shared.setString(Preference.patientGender, patientProfileList[index].gender);

    var json = jsonEncode(serverModelDataList.map((e) => e.toJson()).toList());
    Preference.shared.setList(Preference.serverUrlAllListed,json);
    getServerModelData();
    moveToScreen();
    // patientProfileList.clear();
    // Utils.getPerformerDataList();
    update();
  }


  moveToScreen(){
    if(serverModelDataList.where((element) => element.isPrimary && element.patientId == "").toList().isEmpty) {
      Preference.shared.setString(Preference.patientId, serverModelDataList.where((element) => element.isPrimary).toList()[0].patientId);
      Preference.shared.setString(Preference.patientFName, serverModelDataList.where((element) => element.isPrimary).toList()[0].patientFName);
      Preference.shared.setString(Preference.patientLName, serverModelDataList.where((element) => element.isPrimary).toList()[0].patientLName);
      if (fromScreenType == Constant.profileTypeSetting) {
        Get.back();
        Get.back();
        Get.back();
      } else {
        Utils.getPerformerDataList(selectedUrlModel!);
        Preference.shared.setBool(Constant.keyWelcomeDetails, false);
        Get.offAllNamed(AppRoutes.bottomNavigation);
        patientProfileList.clear();
        update();
      }
    }else{
      Utils.showToast(Get.context!, "Please select Patient ");
    }
  }

}
