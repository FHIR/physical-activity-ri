import 'dart:async';
import 'dart:convert';

import 'package:banny_table/dataModel/patientDataModel.dart';
import 'package:banny_table/resources/PaaProfiles.dart';
import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/ui/configuration/datamodel/configuration_datamodel.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/trackingPref/datamodel/trackingPref.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/qrScanner/datamodel/serverModel.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/selectPrimaryServer/datamodel/serverModelJson.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:fhir/r4/resource/resource.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../../../db_helper/box/activity_data.dart';
import '../../../../../db_helper/box/monthly_log_data.dart';
import '../../../../../utils/constant.dart';
import '../../../../../utils/utils.dart';

class PatientListController extends GetxController {

  var isShowLoader = false;
  var argument = Get.arguments;
  bool isNavigation = false;
  bool isFromSetting = false;
  BuildContext? context;
  var fName = "";
  var lName = "";
  var dob = "";
  var gender = "";
  Timer? _debounceTimer;
  String selectedDropDown = "";
  FocusNode searchIdFocus = FocusNode();
  FocusNode searchNameFocus = FocusNode();
  TextEditingController searchIdControllers = TextEditingController();
  TextEditingController searchNameControllers = TextEditingController();
  List<PatientDataModel> patientProfileList = [];
  bool isShowProgress = false;

  List<ServerModelJson> serverModelDataList = [];
  ServerModelJson? selectedUrlModel;



  @override
  void onInit() {
    if(argument != null){
      if(argument[0] != null){
        isNavigation = argument[0];
      }
      if(argument.length != 1){
        if(argument[1] != null){
          isFromSetting =  argument[1] ?? false;
        }
      }
    }
    selectedDropDown = Utils.searchIdsAndManages[0];
    getAllPreferenceData();
    getPatientList();
    getServerModelData();
    super.onInit();
  }

  onChangeProgress(bool value){
    isShowProgress = value;
    update();
  }

  getServerModelData(){
    serverModelDataList = Preference.shared.getServerList(Preference.serverUrlAllListed) ?? [];
    selectedUrlModel = serverModelDataList.where((element) => element.isSelected && !element.isSecure).toList()[0];
    update();
  }

  onChangeUrl(Object? value) async {
    value = value as ServerModelJson;
    selectedUrlModel = value;
    patientProfileList.clear();
    searchIdControllers.clear();
    searchNameControllers.clear();
    await getPatientList();
    update();
  }

  getPatientList() async {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), () async {
      patientProfileList.clear();
      onChangeProgressValue(true);
      if(selectedDropDown == Constant.patient) {
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



                var userName = "";
                try {
                  // fName = data.resource.name[0].given[0].toString();
                  var givenNameList = data.resource.name[0].given;
                  if(data.resource.name[0].given != null) {
                    if (givenNameList.isNotEmpty) {
                      for (int i = 0; i < givenNameList.length; i++) {
                        userName += "${givenNameList[i]} ";
                      }
                    }
                  }
                } catch (e) {
                  Debug.printLog("lName...$e");
                }

                // var lName = "";
                try {
                  userName += data.resource.name[0].family.toString();
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
                patientData.fName = userName;
                patientData.lName = userName;
                patientData.dob = dob;
                patientData.gender = gender;
                patientProfileList.add(patientData);


                Debug.printLog(
                    "patient info....$userName  $userName  $gender  $dob  $id");
              }
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

  gotoSkipTab(){
    if(isNavigation){
      Get.back();
      Get.back();
      Get.back();
    } else if(isFromSetting){
      Get.back();
    } else {
      if (kIsWeb) {
        Get.toNamed(AppRoutes.configurationMain,);
      } else {
        Get.toNamed(AppRoutes.integrationScreen, arguments: [false]);
      }
    }
    update();
  }

  showDialogForProgress(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          backgroundColor: CColor.white,
          content: Container(
            padding: EdgeInsets.only(left: Sizes.width_3),
            height: Get.height * 0.1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const CircularProgressIndicator(),
                Container(
                  margin: EdgeInsets.only(bottom: Sizes.height_0_5),
                  child: Text(
                    Constant.txtPleaseWait,
                    style: AppFontStyle.styleW700(CColor.black, FontSize.size_12),
                  ),
                ),
                Text("patient data is in progress...",
                    style:
                    AppFontStyle.styleW400(CColor.black, FontSize.size_10))
              ],
            ),
          ),
        );
      },
    );
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

  onChangeDropDown(String value){
    selectedDropDown = value;
    update();
  }
  // var listData;

  saveDetail(int index) async {
    int serverIndex = serverModelDataList.indexWhere((element) => element == selectedUrlModel).toInt();
    serverModelDataList[serverIndex].patientId = patientProfileList[index].patientId;
    selectedUrlModel!.patientId = patientProfileList[index].patientId;
    selectedUrlModel!.patientFName =patientProfileList[index].fName;
    selectedUrlModel!.patientLName =patientProfileList[index].lName;
    selectedUrlModel!.patientDOB =patientProfileList[index].dob;
    selectedUrlModel!.patientGender =patientProfileList[index].gender;
    var json = jsonEncode(serverModelDataList.map((e) => e.toJson()).toList());
    Preference.shared.setList(Preference.serverUrlAllListed,json);
    Utils.getAndSetPatientId();
    Utils.getPerformerDataList(selectedUrlModel!);
    Utils.getConfigurationActivityDataListApi();
    update();
  }

  moveToScreen() async {
    if(serverModelDataList.where((element) => element.isSelected).toList().where((element) => element.patientId == "" && !element.isSecure).toList().isEmpty){
      gotoSkipTab();
    }else{
      patientProfileList.clear();
      var nextUrlAPICall = serverModelDataList.where((element) => element.isSelected).toList().where((element) => element.patientId == "" && !element.isSecure).toList();
      if(nextUrlAPICall.isNotEmpty){
        searchIdControllers.clear();
        searchNameControllers.clear();
        selectedUrlModel = nextUrlAPICall[0];
        getPatientList();
      }
      // Utils.showToast(Get.context!, "Please select Patient for other connected server");
    }
    update();
  }

}
