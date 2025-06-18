import 'package:banny_table/db_helper/database_helper.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../db_helper/box/goal_data.dart';
import '../../../healthData/getSetHealthData.dart';
import '../../../routes/app_routes.dart';
import '../../welcomeScreen/healthProvider/qrScanner/datamodel/serverModelJson.dart';

class SettingController extends GetxController {


  TextEditingController editingController = TextEditingController();
  FocusNode editFocusNode = FocusNode();
  String selectedSyncing = Utils.syncingTimeList[0];
  List<GoalTableData> goalDataList = [];
  List<ServerModelJson> selectedUrlData = [];
  String primaryTitle = "";
  String primaryDisplayName = "";

  @override
  void onInit() async {

    var acessToken = Preference.shared.getString(Preference.authToken) ?? "";
    // editingController.text = acessToken;
    // Debug.printLog("Access token......$acessToken");
    // editFocusNode.addListener(() {
    //   var valueTotalWeek = editingController.text;
    //   if(valueTotalWeek != "" && valueTotalWeek != "0") {
    //     if (!editFocusNode.hasFocus) {
    //       Preference.shared.setString(Preference.patientId, valueTotalWeek);
    //       var data = Preference.shared.getString(Preference.patientId);
    //       Utils.getAllDbData();
    //       Debug.printLog("editFocusNode....$valueTotalWeek  $data");
    //       return;
    //     }
    //   }
    // });

    // final SharedPreferences prefs = await SharedPreferences.getInstance();

    // selectedSyncing = prefs.getString(Constant.keySyncing) ?? Constant.realTime;
    getQrUrl();
    // Utils.getGoalDataListApi();
    // isHealth = Utils.getPermissionHealth();
    update();
    super.onInit();
  }



  getQrUrl() async {
    // if(Preference.shared.getString(Preference.qrUrlData) == null){
      if(Utils.getPrimaryServerData() != null){
        String serverName = Utils.getPrimaryServerData()!.url;
        Preference.shared.setString(Preference.qrUrlData,serverName);
      }
    // }
      selectedUrlData = Preference.shared.getServerListedAllUrl(Preference.serverUrlAllListed) ?? [];
      if(selectedUrlData.isNotEmpty && selectedUrlData.where((element) => element.isPrimary).toList().isNotEmpty) {
        primaryTitle =
            selectedUrlData.where((element) => element.isPrimary).toList()[0]
                .title;
        primaryDisplayName =
            selectedUrlData.where((element) => element.isPrimary).toList()[0]
                .displayName;
      /*  Constant.settingQRScan =
            Preference.shared.getString(Preference.qrUrlData) ??
                "QR connect provider";*/
      }
    await Utils.setPractitionerDetailIdWise();
    update();
  }


  qrCodeManage(){
    // Preference.shared.setBool(Preference.qrManage,true);
    // Get.toNamed(AppRoutes.qrManagerScreen, arguments: [true])!
    //     .then((value) => {getQrUrl()});
    Get.toNamed(AppRoutes.healthQrScanner, arguments: [true])!.then((value) => {getQrUrl()});

  }

  bool isHealth = false;

/*
  onChangeSwitch(value) async {
    isHealth = value;
    update();
    if(isHealth){
      await GetSetHealthData.authentication(isHealth,(value){
        Utils.setPermissionHealth(true);
        GetSetHealthData.importDataFromHealth((val){
        }, false);
      });
    }else{
      HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
      Utils.setPermissionHealth(false);
      await health.revokePermissions();
    }
    update();
  }
*/

  Future<void> feedbackForm(String url) async {
    final Uri uri = Uri.parse(url);
    Debug.printLog('Trying to launch $url');
    try{
      await launchUrl(uri);
    }catch(e){
      Debug.printLog("error.......");
    }
  }

  clearTrackingChartData() async {
    Constant.isCalledAPI = false;
    await DataBaseHelper.shared.dbQRCodeBox?.clear();
    Debug.printLog("Clean history Data");
  }


}
