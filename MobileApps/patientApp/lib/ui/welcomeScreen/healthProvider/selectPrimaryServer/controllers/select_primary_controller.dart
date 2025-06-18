import 'dart:convert';
import 'package:banny_table/resources/providerRequest.dart';
import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/healthProvider/controllers/health_provider_controller.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../datamodel/serverModelJson.dart';

class SelectPrimaryController extends GetxController {

  var argument = Get.arguments;
  bool isShowDialog = false;
  bool isFromSetting = false;
  var selectedUrl = "";
  var selectedUrlClientId = "";
  FocusNode addOtherUrlFocus = FocusNode();

  List<ServerModelJson> selectedUrlDataList = [];

  @override
  void onInit() {
    super.onInit();
    if (argument != null) {
      if (argument[0] != null) {
        isFromSetting = argument[0];
      }
    }
    getUrl();
  }

  getUrl() {
    selectedUrlDataList = Preference.shared.getServerList(Preference.serverUrlAllListed) ?? [];
    Debug.printLog("selectedUrlData....................${selectedUrlDataList.length}");
    if(selectedUrlDataList.isNotEmpty){
      if(selectedUrlDataList.where((element) => element.isPrimary).toList().isEmpty){
        selectPrimaryUrl(0);
      }
    }
    update();
  }

  selectPrimaryUrl(int index){
    for(int i = 0;i<selectedUrlDataList.length; i++){
      selectedUrlDataList[i].isPrimary = false;
    }
    selectedUrlDataList[index].isSelected = true;
    selectedUrl = selectedUrlDataList[index].displayName;
    selectedUrlClientId = selectedUrlDataList[index].clientId;
    selectedUrlDataList[index].isPrimary = true;
    Preference.shared.setString(Preference.qrUrlData, selectedUrlDataList[index].url);
    var json = jsonEncode(selectedUrlDataList.map((e) => e.toJson()).toList());
    Preference.shared.setList(Preference.serverUrlAllListed,json);
    update();
  }

  Future<void> callServiceProvider(ServerModelJson serverData,int index
       ) async {
    if (serverData.url.isNotEmpty) {

      try {
        var url = serverData.url;
        var clientId = serverData.clientId;
        if (clientId != "") {
          ProviderRequest.setClientId(clientId);
        }else{
          ProviderRequest.setClientId("");
        }
        ProviderRequest.setClient(url);
        dynamic smartFhirClient;
        dynamic fhirClientUnSecure;
        if (clientId != "") {
          smartFhirClient = ProviderRequest.getSecureClient();
          Utils.showDialogForProgress(Get.context!,Constant.txtPleaseWait,Constant.txtConnectingPatient);
          isShowDialog = true;
          await smartFhirClient?.login();
          String accessToken = Preference.shared.getString(Preference.authToken) ?? "";
          selectedUrlDataList[index].authToken = accessToken;
        } else {
          fhirClientUnSecure = ProviderRequest.getClient();
          Utils.showDialogForProgress(Get.context!,Constant.txtPleaseWait,Constant.txtConnectingPatient);
          isShowDialog = true;
        }

        var json = jsonEncode(selectedUrlDataList.map((e) => e.toJson()).toList());
        Preference.shared.setList(Preference.serverUrlAllListed,json);
        await Utils.setPatientDetailIdWise();

        if (isShowDialog) {
          isShowDialog = false;
          Get.back();
        }
      } catch (e) {
        Debug.printLog(e.toString());
        Utils.showToast(Get.context!, e.toString());
        if (isShowDialog) {
          Get.back();
        }
      }
      update();
    }
  }


  nextPage({HealthProviderController? healthProviderController}){
    if(selectedUrlDataList.where((element) => element.isSelected).toList().where((element) => element.isSecure).toList().isNotEmpty){
      if(selectedUrlDataList.where((element) => element.isSelected).toList().where((element) => element.authToken == ""
      && element.isSecure).toList().isNotEmpty){
        Utils.showToast(Get.context!, "Please Authorize your Connection");
      }else{
        moveToScreen(healthProviderController: healthProviderController);
      }
    }else{
      moveToScreen(healthProviderController: healthProviderController);
    }

  }

  moveToScreen({HealthProviderController? healthProviderController}) async {
    selectedUrlDataList = Preference.shared.getServerList(Preference.serverUrlAllListed) ?? [];
    var json = jsonEncode(selectedUrlDataList.map((e) => e.toJson()).toList());
    Preference.shared.setList(Preference.serverUrlAllListed, json);
    if(isFromSetting){
      if(selectedUrlDataList.where((element) => element.patientId == "").toList().isEmpty){
        Get.back();
        Get.back();
      }else{
        Get.toNamed(AppRoutes.healthPatientList,arguments: [true,false]);
      }
    }else {
      Preference.shared.setBool(Preference.keyHealthProvider,false);
      if(kIsWeb){
        Preference.shared.setBool(Preference.keyConfiguration,true);
        Get.toNamed(AppRoutes.configurationMain);
      }else{
        Preference.shared.setBool(Preference.keyIntegrationScreen,true);
        Get.toNamed(AppRoutes.integrationScreen, arguments: [false]);
      }
    }
  }
}
