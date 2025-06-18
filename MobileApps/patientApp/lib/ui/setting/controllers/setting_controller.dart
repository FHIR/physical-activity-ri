import 'package:banny_table/resources/syncing.dart';
import 'package:banny_table/ui/bottomNavigation/controllers/bottom_navigation_controller.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/selectPrimaryServer/datamodel/serverModelJson.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../db_helper/box/activity_data.dart';
import '../../../db_helper/box/goal_data.dart';
import '../../../db_helper/box/server_detail_data.dart';
import '../../../db_helper/box/server_detail_data_mod_min.dart';
import '../../../db_helper/box/server_detail_data_vig_min.dart';
import '../../../db_helper/database_helper.dart';
import '../../../healthData/getSetHealthData.dart';
import '../../../routes/app_routes.dart';

class SettingController extends GetxController {

  BottomNavigationController? bottomNavigationController;

  TextEditingController editingController = TextEditingController();
  FocusNode editFocusNode = FocusNode();
  String selectedSyncing = Utils.syncingTimeList[0];
  String primaryTitle = "";
  String primaryDisplayName = "";
  List<GoalTableData> goalDataList = [];
  // List<ServerModel> selectedUrlData = [];
  List<ServerModelJson> selectedUrlData = [];


  @override
  void onInit() async {

    var acessToken = Preference.shared.getString(Preference.authToken) ?? "";
    editingController.text = acessToken;
    Debug.printLog("Access token......$acessToken");
    editFocusNode.addListener(() {
      var valueTotalWeek = editingController.text;
      if(valueTotalWeek != "" && valueTotalWeek != "0") {
        if (!editFocusNode.hasFocus) {
          // Preference.shared.setString(Preference.patientId, valueTotalWeek);
          // var data = Preference.shared.getString(Preference.patientId);
          Utils.getAndSetPatientId();
          // Debug.printLog("editFocusNode....$valueTotalWeek  $data");
          return;
        }
      }
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    selectedSyncing = prefs.getString(Constant.keySyncing) ?? Constant.realTime;
    getQrUrl();
    getUrl(false);
    // Utils.getGoalDataListApi();
    isHealth = Utils.getPermissionHealth();
    update();
    super.onInit();
  }
  getUrl(bool isFromPreviousScreen) async {
    selectedUrlData = Preference.shared.getServerList(Preference.serverUrlAllListed) ?? [];
    if(selectedUrlData.isNotEmpty && selectedUrlData.where((element) => element.isPrimary).toList().isNotEmpty){
      primaryTitle = selectedUrlData.where((element) => element.isPrimary).toList()[0].title;
      primaryDisplayName = selectedUrlData.where((element) => element.isPrimary).toList()[0].displayName;
      // Debug.printLog("Primary server...${selectedUrlData.where((element) => element.isPrimary).toList()[0].url}");
      // try {
      //   Utils.callPushApiForConfigurationActivity();
      // } catch (e) {
      //   Debug.printLog(e.toString());
      // }
    }

    if(isFromPreviousScreen) {
      var dataListHive = Hive.box<ActivityTable>(Constant.tableActivity).values.toList();
      if (dataListHive.isNotEmpty) {

        // var connectedServerUrl = Utils.getServerListPreference();
        var connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();

        for (int i = 0; i < connectedServerUrl.length; i++) {
          var notConnectedDataWithNewServer = dataListHive.where((element) => element.type == Constant.typeDay)
              .toList();

          for (int j = 0; j < notConnectedDataWithNewServer.length; j++) {
            var data = notConnectedDataWithNewServer[j];
           /* if(data.serverDetailList.where((element) => element.serverUrl == connectedServerUrl[i].url).toList().isEmpty) {
              data.isSync = false;

              var serverDetail = ServerDetailDataTable();
              serverDetail.serverUrl = connectedServerUrl[i].url;
              serverDetail.patientId = connectedServerUrl[i].patientId;
              serverDetail.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i].patientLName}";
              serverDetail.objectId = "";
              serverDetail.serverToken = connectedServerUrl[i].authToken;
              serverDetail.clientId = connectedServerUrl[i].clientId;
              data.serverDetailList.add(serverDetail);
            }*/

            if(data.title == null && data.smileyType == null){
              if (data.serverDetailList
                  .where((element) => element.serverUrl == connectedServerUrl[i].url).toList().isEmpty) {
                data.isSync = false;

                var serverDetail = ServerDetailDataTable();
                serverDetail.serverUrl = connectedServerUrl[i].url;
                serverDetail.patientId = connectedServerUrl[i].patientId;
                serverDetail.patientName =
                "${connectedServerUrl[i].patientFName}${connectedServerUrl[i].patientLName}";
                serverDetail.objectId = "";
                serverDetail.serverToken = connectedServerUrl[i].authToken;
                serverDetail.clientId = connectedServerUrl[i].clientId;
                data.serverDetailList.add(serverDetail);
              }
              if (data.serverDetailListModMin
                  .where((element) => element.modServerUrl == connectedServerUrl[i].url).toList().isEmpty) {
                data.isSync = false;

                var serverDetail = ServerDetailDataModMinTable();
                serverDetail.modServerUrl = connectedServerUrl[i].url;
                serverDetail.modPatientId = connectedServerUrl[i].patientId;
                serverDetail.modPatientName =
                "${connectedServerUrl[i].patientFName}${connectedServerUrl[i].patientLName}";
                serverDetail.modObjectId = "";
                serverDetail.modServerToken = connectedServerUrl[i].authToken;
                serverDetail.modClientId = connectedServerUrl[i].clientId;
                data.serverDetailListModMin.add(serverDetail);
              }
              if (data.serverDetailListVigMin
                  .where((element) => element.vigServerUrl == connectedServerUrl[i].url).toList().isEmpty) {
                data.isSync = false;

                var serverDetail = ServerDetailDataVigMinTable();
                serverDetail.vigServerUrl = connectedServerUrl[i].url;
                serverDetail.vigPatientId = connectedServerUrl[i].patientId;
                serverDetail.vigPatientName =
                "${connectedServerUrl[i].patientFName}${connectedServerUrl[i].patientLName}";
                serverDetail.vigObjectId = "";
                serverDetail.vigServerToken = connectedServerUrl[i].authToken;
                serverDetail.vigClientId = connectedServerUrl[i].clientId;
                data.serverDetailListVigMin.add(serverDetail);
              }
            }
            else {
              if (data.serverDetailList.where((element) => element.serverUrl == connectedServerUrl[i].url).toList().isEmpty) {
                data.isSync = false;

                var serverDetail = ServerDetailDataTable();
                serverDetail.serverUrl = connectedServerUrl[i].url;
                serverDetail.patientId = connectedServerUrl[i].patientId;
                serverDetail.patientName =
                "${connectedServerUrl[i].patientFName}${connectedServerUrl[i].patientLName}";
                serverDetail.objectId = "";
                serverDetail.serverToken = connectedServerUrl[i].authToken;
                serverDetail.clientId = connectedServerUrl[i].clientId;
                data.serverDetailList.add(serverDetail);
              }
            }
            await DataBaseHelper.shared.updateActivityData(data);
          }
        }

        for (int i = 0; i < connectedServerUrl.length; i++) {
          var notConnectedDataWithNewServer = dataListHive.where((element) => element.type == Constant.typeDaysData)
              .toList();

          for (int j = 0; j < notConnectedDataWithNewServer.length; j++) {
            var data = notConnectedDataWithNewServer[j];
            if(data.title == null && data.smileyType == null){
              if (data.serverDetailList
                  .where((element) => element.serverUrl == connectedServerUrl[i].url).toList().isEmpty) {
                data.isSync = false;

                var serverDetail = ServerDetailDataTable();
                serverDetail.serverUrl = connectedServerUrl[i].url;
                serverDetail.patientId = connectedServerUrl[i].patientId;
                serverDetail.patientName =
                "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
                    .patientLName}";
                serverDetail.objectId = "";
                serverDetail.serverToken = connectedServerUrl[i].authToken;
                serverDetail.clientId = connectedServerUrl[i].clientId;
                data.serverDetailList.add(serverDetail);
              }
              if (data.serverDetailListModMin
                  .where((element) => element.modServerUrl == connectedServerUrl[i].url).toList().isEmpty) {
                data.isSync = false;

                var serverDetail = ServerDetailDataModMinTable();
                serverDetail.modServerUrl = connectedServerUrl[i].url;
                serverDetail.modPatientId = connectedServerUrl[i].patientId;
                serverDetail.modPatientName =
                "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
                    .patientLName}";
                serverDetail.modObjectId = "";
                serverDetail.modServerToken = connectedServerUrl[i].authToken;
                serverDetail.modClientId = connectedServerUrl[i].clientId;
                data.serverDetailListModMin.add(serverDetail);
              }
              if (data.serverDetailListVigMin
                  .where((element) => element.vigServerUrl == connectedServerUrl[i].url).toList().isEmpty) {
                data.isSync = false;

                var serverDetail = ServerDetailDataVigMinTable();
                serverDetail.vigServerUrl = connectedServerUrl[i].url;
                serverDetail.vigPatientId = connectedServerUrl[i].patientId;
                serverDetail.vigPatientName =
                "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
                    .patientLName}";
                serverDetail.vigObjectId = "";
                serverDetail.vigServerToken = connectedServerUrl[i].authToken;
                serverDetail.vigClientId = connectedServerUrl[i].clientId;
                data.serverDetailListVigMin.add(serverDetail);
              }
            }
            else {
              if (data.serverDetailList
                  .where((element) =>
              element.serverUrl == connectedServerUrl[i].url)
                  .toList()
                  .isEmpty) {
                data.isSync = false;

                var serverDetail = ServerDetailDataTable();
                serverDetail.serverUrl = connectedServerUrl[i].url;
                serverDetail.patientId = connectedServerUrl[i].patientId;
                serverDetail.patientName =
                "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
                    .patientLName}";
                serverDetail.objectId = "";
                serverDetail.serverToken = connectedServerUrl[i].authToken;
                serverDetail.clientId = connectedServerUrl[i].clientId;
                data.serverDetailList.add(serverDetail);
              }
            }
            await DataBaseHelper.shared.updateActivityData(data);
          }
        }
      }
      Utils.getAndSetPatientId();
    }
    await Utils.setPatientDetailIdWise();
    Debug.printLog("selectedUrlData....................${selectedUrlData.length}");
    update();
  }

  onSelectSyncingTime(value) async {
    // selectedSyncing = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constant.keySyncing,value);
    selectedSyncing = prefs.getString(Constant.keySyncing) ?? Constant.realTime;
    update();

  }


  getQrUrl(){
    // Constant.settingQRScan = Preference.shared.getString(Preference.qrUrlData) ?? "QR connect provider";
    update();
  }

  onChangeMode(){
    Constant.isEditMode = !Constant.isEditMode;
    update();
  }

  onChangeAutoCalculationMode(bool value){
    bool isAutoMode =  Preference.shared.getBool(Preference.isAutoCalMode) ?? false;
    Debug.printLog("isAutoMode.........$isAutoMode");
    // Constant.isAutoCalMode = value;
    Preference.shared.setBool(Preference.isAutoCalMode,value);
    update();
  }

  qrCodeManage(){
    // Preference.shared.setBool(Preference.qrManage,true);
    Get.toNamed(AppRoutes.healthQrScanner, arguments: [true])!
        .then((value) => {getUrl(true),
      if(bottomNavigationController != null){
        bottomNavigationController!.getServerListData(),
        bottomNavigationController!.updateMethod(),
      },
      pushGoalData(),

      update()});
  }

  bool isHealth = false;

  pushGoalData() async {
    if (Utils.getPrimaryServerData() != null  && Utils.getPrimaryServerData()!.url != "") {
      await Syncing.goalSyncingData(true, []).then((value) async =>
      {
        await Utils.clearGoalData(),
      });
    }
  }

  onChangeSwitch(value) async {
    isHealth = value;
    update();
    if(isHealth){
      await GetSetHealthData.authentication(isHealth,(value){
        Utils.setPermissionHealth(true);
        GetSetHealthData.importDataFromHealth((val){
        }, false,needAPICall: false,endDate: Utils.endDateTime(DateTime.now()),startDate: Utils.startDateTime(DateTime.now()));
      });
    }else{
      // HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
      Utils.setPermissionHealth(false);
      await Health().revokePermissions();
    }
    update();
  }

  Future<void> feedbackForm(String url) async {
    final Uri uri = Uri.parse(url);
    Debug.printLog('Trying to launch $url');
    try{
      await launchUrl(uri);
    }catch(e){
      Debug.printLog("error.......");
    }
  }


  setAutoCalMode(bool value){

  }




}
