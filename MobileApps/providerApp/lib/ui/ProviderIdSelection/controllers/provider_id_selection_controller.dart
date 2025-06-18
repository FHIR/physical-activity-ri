import 'dart:async';
import 'dart:convert';

import 'package:banny_table/dataModel/patientDataModel.dart';
import 'package:banny_table/resources/PaaProfiles.dart';
import 'package:banny_table/resources/providerRequest.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/qrScanner/datamodel/serverModel.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/qrScanner/datamodel/serverModelJson.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:fhir/r4/resource/resource.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class ProfileSelectionController extends GetxController {
/// Provider Id Find USE
  var fName = "";
  var lName = "";
  var dob = "";
  var gender = "";
  Timer? _debounceTimer;
  String fromScreenType = "";
  String selectedDropDown = "";
  String displayProfileValue = "";
  FocusNode searchIdFocus = FocusNode();
  FocusNode searchNameFocus = FocusNode();
  TextEditingController searchIdControllers = TextEditingController();
  TextEditingController searchNameControllers = TextEditingController();
  List<PatientDataModel> patientProfileList = [];
  bool isShowProgress = false;
  var arguments = Get.arguments;

  List<ServerModelJson> serverModelDataList = [];
  ServerModelJson? selectedUrlModel;
  String selectedUrl = "";
  String selectedUrlClientId = "";
  bool isNavigation = false;
  bool isFromSetting = false;


  @override
  void onInit() {
    getServerModelData();
    if(arguments != null){
      if(arguments[0] != null){
        fromScreenType = arguments[0];
      }
      if(arguments[1] != null){
        isNavigation = arguments[1];
      }
    }

    selectedDropDown = Constant.profileTypeInitProvider;
    displayProfileValue = Constant.provider;
    Debug.printLog("fromScreenType.....$fromScreenType");
    getServerModelData();
    getAllPreferenceData();
    getProviderList();
    super.onInit();
  }


/*  onChangeDropDownProvider(String value){
    if(value == Utils.searchIdsAndManages[0]){
      selectedDropDown = Constant.profileTypeInitPatient;
    }else if(value == Utils.searchIdsAndManages[1]){
      selectedDropDown = Constant.profileTypeInitProvider;
    }
    displayProfileValue = value;
    // selectedDropDown = value;
    update();
  }*/

/*  onChangeDropDown(String value) async {
    int selectedServerIndex = serverModelDataList.indexWhere((element) => element.displayName == value.toString()).toInt();
    selectedUrlModel = serverModelDataList[selectedServerIndex];
    selectedUrl = selectedUrlModel!.displayName ?? "";
    selectedUrlClientId = selectedUrlModel!.clientId ?? "";
    serverModelDataList = Preference.shared.getServerList(Preference.serverUrlList) ?? [];
    if(serverModelDataList.isNotEmpty){
      int selectedServerIndexMain = serverModelDataList.indexWhere((element) => element.displayName == value.toString()).toInt();
      for(int i = 0; i<serverModelDataList.length;i++){
        if(i == selectedServerIndexMain){
          serverModelDataList[selectedServerIndexMain].isPrimary = true;
        }else{
          serverModelDataList[i].isPrimary = false;
        }
      }
    }
    await selectClientANDServer();


    update();
  }*/

  onChangeProgress(bool value){
    isShowProgress = value;
    update();
  }

  getServerModelData(){
    // serverModelDataList = Preference.shared.getServerListedAllUrl(Preference.serverUrlAllListed) ?? [];
    serverModelDataList = Utils.getServerList;
    selectedUrlModel = serverModelDataList.where((element) => element.isSelected && !element.isSecure).toList()[0];
    update();
  }

  onChangeUrl(Object? value) async {
    value = value as ServerModelJson;
    selectedUrlModel = value;
    patientProfileList.clear();
    searchIdControllers.clear();
    searchNameControllers.clear();
    await getProviderList();
    update();
  }

  getProviderList() async {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), () async {
      patientProfileList.clear();
      onChangeProgressValue(true);
        var listData = await PaaProfiles.getPatientListTestUse(R4ResourceType.Practitioner, searchIdControllers.text,searchNameControllers.text,selectedUrlModel!);
        if (listData.resourceType == R4ResourceType.Bundle) {
          patientProfileList.clear();

          if (listData != null && listData.entry != null) {
            int length = listData.entry.length;
            for (int i = 0; i < length ; i++) {
              if (listData.entry[i].resource.resourceType == R4ResourceType.Practitioner) {
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
                    "Please wait",
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
    selectedUrlModel!.providerId = patientProfileList[index].patientId;
    selectedUrlModel!.providerFName =patientProfileList[index].fName;
    selectedUrlModel!.providerLName =patientProfileList[index].lName;
    selectedUrlModel!.providerDOB =patientProfileList[index].dob;
    selectedUrlModel!.providerGender =patientProfileList[index].gender;
    var json = jsonEncode(serverModelDataList.map((e) => e.toJson()).toList());
    Preference.shared.setList(Preference.serverUrlAllListed,json);
    Utils.getAndSetProviderId();
    Utils.getPerformerDataList(selectedUrlModel!);
    Utils.getConfigurationActivityDataListApi();
    /// Check For the Configuration DATA ADD
/*    if(checkConfiguration !=  "" && patientProfileList[index].fName.toLowerCase()  == "Chcek Configuration".toLowerCase()){
      Preference.shared.setList(Preference.configurationInfo, checkConfiguration);
      List<ConfigurationClass> prefData = Preference.shared.getConfigPrefList(Preference.configurationInfo) ?? [];
      Debug.printLog("Configuration data length.... ${prefData.length}");
    }*/

    update();
  }

  moveToScreen() async {
    if(serverModelDataList.where((element) => element.isSelected).toList().where((element) => element.providerId == "").toList().isEmpty){
      gotoSkipTab();
    }else{
      patientProfileList.clear();
      var nextUrlAPICall = serverModelDataList.where((element) => element.isSelected && !element.isSecure).toList().where((element) => element.providerId == "").toList();
      if(nextUrlAPICall.isNotEmpty){
        searchIdControllers.clear();
        searchNameControllers.clear();
        selectedUrlModel = nextUrlAPICall[0];
        getProviderList();
      }else if(nextUrlAPICall.isEmpty){
        gotoSkipTab();
      }
      // Utils.showToast(Get.context!, "Please select Patient for other connected server");
    }
    update();
  }



  gotoSkipTab(){
    if(isNavigation){
      Preference.shared.setString(Preference.providerId, serverModelDataList.where((element) => element.isPrimary).toList()[0].providerId);
      Preference.shared.setString(Preference.providerName, serverModelDataList.where((element) => element.isPrimary).toList()[0].providerFName);
      Preference.shared.setString(Preference.providerLastName, serverModelDataList.where((element) => element.isPrimary).toList()[0].providerLName);
      Preference.shared.setString(Preference.qrUrlData, serverModelDataList.where((element) => element.isPrimary).toList()[0].url);
      ///patient
      Preference.shared.setString(Preference.patientId,  serverModelDataList.where((element) => element.isPrimary).toList()[0].patientId);
      Preference.shared.setString(Preference.patientFName,  serverModelDataList.where((element) => element.isPrimary).toList()[0].patientFName);
      Preference.shared.setString(Preference.patientLName,  serverModelDataList.where((element) => element.isPrimary).toList()[0].patientLName);
      Preference.shared.setBool(Constant.keyWelcomeDetails,false);
      Preference.shared.setBool(Constant.keyIndependentPatient,true);
      Get.toNamed(AppRoutes.patientIndependentMode,arguments: [false,false,false,true]);

/*      Get.back();
      Get.back();
      Get.back();*/

    } else if(isFromSetting){
      Get.back();
    } else {
      Preference.shared.setString(Preference.providerId, serverModelDataList.where((element) => element.isPrimary).toList()[0].providerId);
      Preference.shared.setString(Preference.providerName, serverModelDataList.where((element) => element.isPrimary).toList()[0].providerFName);
      Preference.shared.setString(Preference.providerLastName, serverModelDataList.where((element) => element.isPrimary).toList()[0].providerLName);
      Preference.shared.setString(Preference.qrUrlData, serverModelDataList.where((element) => element.isPrimary).toList()[0].url);
      ///patient
      Preference.shared.setString(Preference.patientId,  serverModelDataList.where((element) => element.isPrimary).toList()[0].patientId);
      Preference.shared.setString(Preference.patientFName,  serverModelDataList.where((element) => element.isPrimary).toList()[0].patientFName);
      Preference.shared.setString(Preference.patientLName,  serverModelDataList.where((element) => element.isPrimary).toList()[0].patientLName);

      if(fromScreenType == Constant.profileTypeSetting) {
        Utils.getAllDbData();
        // Get.back();
        Get.toNamed(AppRoutes.patientProfileSelection ,arguments: [Constant.profileTypeSetting]);
      }
      else if(fromScreenType == Constant.profileTypeInitProvider){
        ///Next to patient selection
        // Get.toNamed(AppRoutes.patientProfileSelection);
        Preference.shared.setBool(Constant.keyWelcomeDetails,false);
        Preference.shared.setBool(Constant.keyIndependentPatient,true);
        Get.toNamed(AppRoutes.patientIndependentMode,arguments: [false,false,false,false]);

      }
      else if(fromScreenType == Constant.profileTypeInitPatient){
        ///Next to home page
        Get.offAllNamed(AppRoutes.bottomNavigation);
      }
    }
    update();
  }





/*  getServerModelData() async {
    serverModelDataList = Preference.shared.getServerList(Preference.serverUrlList) ?? [];
    serverModelDataList = serverModelDataList.where((element) => element.isSelected).toList();
    selectedUrlModel =  serverModelDataList[0];

      // if(serverModelDataList.where((element) => element.url == Preference.shared.getString(Preference.qrUrlData) && !element.isSelected ).toList().isEmpty){
      selectedUrl = selectedUrlModel!.displayName ?? "";
    // }else{
      // selectedUrl = Preference.shared.getString(Preference.qrUrlData) ?? selectedUrlModel!.displayName ?? "";
    // }

    int selectedServerIndexMain = serverModelDataList.indexWhere((element) => element.displayName == selectedUrl.toString()).toInt();
    for(int i = 0; i<serverModelDataList.length;i++){
      if(i == selectedServerIndexMain){
        serverModelDataList[selectedServerIndexMain].isPrimary = true;
      }else{
        serverModelDataList[i].isPrimary = false;
      }
    }
    // if(fromScreenType != Constant.profileTypeSetting && selectedUrl != Preference.shared.getString(Preference.qrUrlData) ){
      await selectClientANDServer();
    // }
    update();
  }*/



}

