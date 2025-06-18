import 'dart:convert';

import 'package:banny_table/fhir_auth/fhir_client/fhir_client.dart';
import 'package:banny_table/fhir_auth/fhir_client/smart_fhir_client.dart';
import 'package:banny_table/resources/providerRequest.dart';
import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/healthProvider/controllers/health_provider_controller.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/qrScanner/datamodel/serverModel.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/qrScanner/datamodel/serverModelJson.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectPrimaryController extends GetxController {
  // QRViewController? qrCodeController;
  // final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  // HealthProviderController? healthProviderController;

  var argument = Get.arguments;
  bool isShowDialog = false;
  bool isFromSetting = false;
  // bool isFromQR = false;
  var selectedUrl = "";
  var selectedUrlClientId = "";
  FocusNode addOtherUrlFocus = FocusNode();

  // List<ServerModel> selectedUrlDataList = [];
  List<ServerModelJson> selectedUrlDataList = [];

  @override
  void onInit() {
    super.onInit();
    if (argument != null) {
      if (argument[0] != null) {
        isFromSetting = argument[0];
      }
/*      if(argument[1] != null){
        isFromQR =argument[1];
      }*/
    }
    getUrl();
  }


  getUrl() {
    // selectedUrlDataList = Preference.shared.getServerList(Preference.serverUrlList) ?? [];
    // selectedUrlDataList = Preference.shared.getServerListedAllUrl(Preference.serverUrlAllListed) ?? [];
    selectedUrlDataList = Utils.getServerList;
    Debug.printLog("selectedUrlData....................${selectedUrlDataList.length}");
    if(selectedUrlDataList.isNotEmpty){
      if(selectedUrlDataList.where((element) => element.isPrimary).toList().isEmpty){
        selectPrimaryUrl(0);
      }
    }
    update();
  }

/*  void onChangeUrl(int index) {
    selectedUrl = Utils.getServerList[index].displayName;
    selectedUrlClientId = Utils.getServerList[index].clientId;
    Utils.getServerList[index].isSelected = !Utils.getServerList[index].isSelected;

  }*/


  selectPrimaryUrl(int index){
    for(int i = 0;i<selectedUrlDataList.length; i++){
      selectedUrlDataList[i].isPrimary = false;
    }
    selectedUrlDataList[index].isSelected = true;
    // int mainListIndex = Utils.getServerList.indexWhere((element) => element.displayName ==selectedUrlData[index].displayName).toInt();
    selectedUrl = selectedUrlDataList[index].displayName;
    selectedUrlClientId = selectedUrlDataList[index].clientId;
    selectedUrlDataList[index].isPrimary = true;
    Preference.shared.setString(Preference.qrUrlData, selectedUrlDataList[index].url);
    var json = jsonEncode(selectedUrlDataList.map((e) => e.toJson()).toList());
    Preference.shared.setList(Preference.serverUrlAllListed,json);
    update();
  }

  // Future<void> callServiceProvider(ServerModel serverData,int index
/*  Future<void> callServiceProvider(ServerModelJson serverData,int index
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
          _showDialogForProgress(Get.context!);
          isShowDialog = true;
          // selectedUrlDataList[index].smartFhirClient = smartFhirClient;
          await smartFhirClient?.login();
          String accessToken = Preference.shared.getString(Preference.authToken) ?? "";
          selectedUrlDataList[index].authToken = accessToken;
        } else {
          fhirClientUnSecure = ProviderRequest.getClient();
          _showDialogForProgress(Get.context!);
          isShowDialog = true;
          // selectedUrlDataList[index].fhirClientUnSecure = fhirClientUnSecure;
        }

        // Preference.shared.setList(Preference.serverUrlList,selectedUrlDataList);
        var json = jsonEncode(selectedUrlDataList.map((e) => e.toJson()).toList());
        // Preference.shared.setList(Preference.serverUrlList,json);
        Preference.shared.setList(Preference.serverUrlAllListed,json);

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
  }*/


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
   /* for(int i= 0;i<selectedUrlDataList.length;i++){
      if(!selectedUrlDataList[i].isSecure){
        await callServiceProvider(selectedUrlDataList[i],i);
      }
    }*/
    if(isFromSetting){
      // if(selectedUrlDataList.where((element) => element.providerId == "").toList().isEmpty){
        // Utils.showToast(Get.context!, "Please Authorize your server");
        // Get.back();
        // Get.back();
      // }else{
        if(selectedUrlDataList.where((element) => element.providerId == "").toList().isEmpty){
          Preference.shared.setBool(Constant.keyWelcomeDetails,false);
          Preference.shared.setBool(Constant.keyIndependentPatient,true);
          Get.toNamed(AppRoutes.patientIndependentMode,arguments: [false,false,true,false]);
        }else{
          Preference.shared.setBool(Constant.keyWelcomeDetails,false);
          Preference.shared.setBool(Constant.keyIndependentPatient,true);
          Get.back();
          Get.back();
          // Get.toNamed(AppRoutes.providerIdSelection,arguments: [Constant.profileTypeInitProvider,true]);
        }
        // Get.toNamed(AppRoutes.healthPatientList,arguments: [true,false]);

      // }
    }else {
      // Get.toNamed(AppRoutes.providerIdSelection,arguments: [Constant.profileTypeInitProvider,false]);
      Preference.shared.setBool(Constant.keyWelcomeDetails,false);
      Preference.shared.setBool(Constant.keyIndependentPatient,true);
      Get.toNamed(AppRoutes.patientIndependentMode,arguments: [false,false,false,false]);
    }

  }

  _showDialogForProgress(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
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
            height: (kIsWeb) ? Sizes.height_20 : Get.height * 0.1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const CircularProgressIndicator(),
                Container(
                  margin: EdgeInsets.only(bottom: Sizes.height_0_5),
                  child: Text(
                    "Please wait",
                    style: AppFontStyle.styleW700(CColor.black,
                        (kIsWeb) ? FontSize.size_10 : FontSize.size_12),
                  ),
                ),
                Text("Connecting to provider....",
                    style: AppFontStyle.styleW400(CColor.black,
                        (kIsWeb) ? FontSize.size_8 : FontSize.size_10))
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  void dispose() {

    super.dispose();
  }
}
