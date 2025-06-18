import 'dart:async';
import 'dart:convert';

import 'package:banny_table/db_helper/database_helper.dart';
import 'package:banny_table/resources/providerRequest.dart';
import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/healthProvider/controllers/health_provider_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:fhir/r4.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../dataModel/patientDataModel.dart';
import '../../../../../fhir_auth/r4.dart';
import '../../../../../providers/api.dart';
import '../../../../../resources/PaaProfiles.dart';
import '../../../../../utils/constant.dart';
import '../../selectPrimaryServer/datamodel/serverModelJson.dart';
import '../datamodel/serverModel.dart';

class QrScannerController extends GetxController {
  HealthProviderController? healthProviderController;

  FocusNode qrdDetails = FocusNode();
  TextEditingController qrCodeDetailsController = TextEditingController();

  MobileScannerController? cameraController;

  var argument = Get.arguments;
  bool isShowDialog = false;
  bool isFromSetting = false;
  var selectedUrl = "";
  var selectedUrlClientId = "";
  TextEditingController addOtherUrlController = TextEditingController();
  FocusNode addOtherUrlFocus = FocusNode();
  TextEditingController addOtherUrlClientIdController = TextEditingController();
  FocusNode addOtherUrlClientIdFocus = FocusNode();
  TextEditingController addServerTitleName = TextEditingController();
  FocusNode addServerTitleNameFocus = FocusNode();

  List<ServerModel> selectedUrlData = [];
  bool isEdit = false;
  bool isAuth = false;
  bool isShowDialogOpen = true;

  FocusNode searchIdFocus = FocusNode();
  FocusNode searchNameFocus = FocusNode();
  TextEditingController searchIdControllers = TextEditingController();
  TextEditingController searchNameControllers = TextEditingController();
  bool isShowProgress = false;
  List<ServerModelJson> serverModelDataList = [];
  List<PatientDataModel> patientProfileList = [];
  Timer? _debounceTimer;
  String selectedPatientId = "";

  @override
  void onInit() {
    super.onInit();
    if (argument != null) {
      if (argument[0] != null) {
        isFromSetting = argument[0];
        selectedUrl = Utils.getAPIEndPoint();
      }
    }
    if(Preference.shared.getServerListedAllUrl(Preference.serverUrlAllListed)!.isEmpty){
      var json = jsonEncode(Utils.getServerList.map((e) => e.toJson()).toList());
      Preference.shared.setList(Preference.serverUrlAllListed, json);
    }
    Utils.getServerList = Preference.shared.getServerListedAllUrl(Preference.serverUrlAllListed) ?? [];
    update();
  }

  void onChangeUrl(int index) {
    selectedUrl = Utils.getServerList[index].displayName;
    selectedUrlClientId = Utils.getServerList[index].clientId;
    Utils.getServerList[index].isSelected =
        !Utils.getServerList[index].isSelected;
    if(Utils.getServerList.where((element) => element.isSelected).toList().length == 1){
      if(Utils.getServerList.where((element) => element.isPrimary).toList().isNotEmpty){
        Utils.getServerList.where((element) => element.isPrimary).toList()[0].isPrimary = false;
      }
      Utils.getServerList.where((element) => element.isSelected).toList()[0].isPrimary = true;
    }
  }

  addNewServerUrlDataIntoList(bool isSelectedItem,setStateDialogForChooseCode,{bool isNotClose = true,int index = -1,
    bool isEditServer = false}) async {
    if(addOtherUrlController.text.isNotEmpty) {
      if(isAuth && addOtherUrlClientIdController.text.isEmpty){
        Utils.showToast(Get.context!, "Please enter valid client id");
        return;
      }
      var serverData = ServerModelJson(
          isSecure: isAuth,
          displayName: addOtherUrlController.text.toString(),
          url: addOtherUrlController.text.toString(),
          clientId: addOtherUrlClientIdController.text.toString(),
          isSelected: isSelectedItem,
          isPrimary: false,
          title: addServerTitleName.text.toString());
      if (!isEditServer) {
        if (Utils.getServerList
            .where((element) =>
        element.displayName == serverData.displayName &&
            element.url == serverData.url)
            .toList()
            .isEmpty) {
          if (!isNotClose) {
            serverData.isSelected = true;
          }
          if (index == -1) {
            Utils.getServerList.add(serverData);
          }
        }

        if (index != -1) {
          serverData.isSelected = isSelectedItem;
          Utils.getServerList[index] = serverData;
        }
      }
      var isNeedReturn = false;
      var mapDataLogin = {};

      if (isAuth) {
        await callSecureServerAPI(
            addOtherUrlController.text.toString(),
            addOtherUrlClientIdController.text.toString(),
            addServerTitleName.text.toString(),
            setStateDialogForChooseCode, callBack: (value) {
            mapDataLogin = value;
            if (mapDataLogin[Constant.type] == Constant.returnType) {
              isNeedReturn = true;
            }
        });
      }
      if(isNeedReturn){
        Get.back();
        if(!isEditServer){
          Utils.getServerList.remove(serverData);
        }
        var json = jsonEncode(
            Utils.getServerList.map((e) => e.toJson()).toList());
        Preference.shared.setList(Preference.serverUrlAllListed, json);
        clearControllersAndValues();
        Utils.showErrorDialog(Get.context!,Constant.txtError,mapDataLogin[Constant.msg]);
        update();
        // showDialogAfterSuccess();
        return;
      }
      if (isNotClose){
        await isClose();
      }


      var json = jsonEncode(
          Utils.getServerList.map((e) => e.toJson()).toList());
      Preference.shared.setList(Preference.serverUrlAllListed, json);
      update();

      if(isAuth) {
        isAuth = false;
        addOtherUrlClientIdController.clear();
        addOtherUrlController.clear();
        addServerTitleName.clear();
        showDialogAfterSuccess();
      }
    }else{
      Utils.showToast(Get.context!, "Please enter valid connection URL");
    }
  }

  addNewServerUrlAuth(bool isSelectedItem,setStateDialogForChooseCode,{bool isNotClose = true,int index = -1,bool isEditServer = false}) async {
    if(addOtherUrlController.text.isNotEmpty) {
      if(isAuth && addOtherUrlClientIdController.text.isEmpty){
        Utils.showToast(Get.context!, "Please enter valid client id");
        return;
      }
      var serverData = ServerModelJson(
          isSecure: isAuth,
          displayName: addOtherUrlController.text.toString(),
          url: addOtherUrlController.text.toString(),
          clientId: addOtherUrlClientIdController.text.toString(),
          isSelected: isSelectedItem,
          isPrimary: false,
          title: addServerTitleName.text.toString());
      if(!isEditServer) {
        if (Utils.getServerList
            .where((element) =>
        element.displayName == serverData.displayName &&
            element.url == serverData.url)
            .toList()
            .isEmpty) {
          if (!isNotClose) {
            serverData.isSelected = true;
          }
          if (index == -1) {
            Utils.getServerList.add(serverData);
          }
        }

        if (index != -1) {
          serverData.isSelected = isSelectedItem;
          Utils.getServerList[index] = serverData;
        }
      }
      var isNeedReturn = false;
      var mapDataLogin = {};
      try {
        await callSecureServerAPI(
            addOtherUrlController.text.toString(),
            addOtherUrlClientIdController.text.toString(),
            addServerTitleName.text.toString(),
            setStateDialogForChooseCode, callBack: (value) {
            mapDataLogin = value;
            if (mapDataLogin[Constant.type] == Constant.returnType) {
              isNeedReturn = true;
            }
        });
      } catch (e) {
        Debug.printLog("error.........${e.toString()}");
      }
      if(isNeedReturn){
        Get.back();
        if(!isEditServer) {
          Utils.getServerList.remove(serverData);
        }
        var json = jsonEncode(
            Utils.getServerList.map((e) => e.toJson()).toList());
        Preference.shared.setList(Preference.serverUrlAllListed, json);
        clearControllersAndValues();
        Utils.showErrorDialog(Get.context!,Constant.txtError,mapDataLogin[Constant.msg]);
        update();
        return;
      }

      await isClose();

      var json = jsonEncode(
          Utils.getServerList.map((e) => e.toJson()).toList());
      Preference.shared.setList(Preference.serverUrlAllListed, json);
      update();
      /*if(isEditServer){
        // showDialogAfterSuccess();
      }else{
        if(isAuth) {
          isAuth = false;
          addOtherUrlClientIdController.clear();
          addOtherUrlController.clear();
          addServerTitleName.clear();
          showDialogAfterSuccess();
        }
      }*/
      if(isAuth) {
        isAuth = false;
        addOtherUrlClientIdController.clear();
        addOtherUrlController.clear();
        addServerTitleName.clear();
        showDialogAfterSuccess();
      }

        // showDialogAfterSuccess();
    }else{
      Utils.showToast(Get.context!, "Please enter valid connection URL");
    }
  }

  isClose(){
    Get.back();
  }

  addUrlForMultiServer() {
    var json = jsonEncode(Utils.getServerList.map((e) => e.toJson()).toList());
    Preference.shared.setList(Preference.serverUrlAllListed, json);
    Get.back();
    update();
  }

  List<ServerModelJson> getServerList() {
    return Utils.getServerList
        .where((element) => element.isSelected)
        .toList();
  }

  gotoNextPage() async {
    // update();
    if (Utils.getServerList
        .where((element) => element.isSelected)
        .toList()
        .isNotEmpty) {
      if(Utils.getServerList.where((element) => element.isSelected).toList().where((element) => element.authToken == ""
          && element.isSecure).toList().isNotEmpty){
        Utils.showToast(Get.context!, "Please Authorize your Connection");
      }
      else {
        Utils.getServerList = Preference.shared.getServerListedAllUrl(Preference.serverUrlAllListed) ?? [];
        var json = jsonEncode(Utils.getServerList.map((e) => e.toJson()).toList());
        Preference.shared.setList(Preference.serverUrlAllListed, json);
        int oldPrimaryIndex = Utils.getServerList.indexWhere((element) => element.isPrimary).toInt();
        if(oldPrimaryIndex == -1){
          for (int i = 0; i < Utils.getServerList.length; i++) {
            Utils.getServerList[i].isPrimary = false;
          }
        }
        if (isFromSetting) {
          Debug.printLog("server selected List........${Utils.getServerList.where((element) => element.isSelected).toList().length}");
          if(Utils.getServerList.where((element) => element.isSelected).toList().length > 1) {
            Get.toNamed(AppRoutes.selectPrimaryScreen, arguments: [true]);
          }
          else{
            /*if(Utils.getServerList.where((element) => element.isSelected).where((element) => element.patientId == "").toList().isEmpty){
              Debug.printLog(".....${Utils.getServerList.where((element) => element.isSelected).where((element) => element.patientId == "").toList().isEmpty}");
              var indexFind = Utils.getServerList.indexWhere((element) => element.isSelected).toInt();
              if(indexFind != -1) {
                for (int i = 0; i < Utils.getServerList.length; i++) {
                  Utils.getServerList[i].isSelected = false;
                }
                Utils.getServerList[indexFind].isPrimary = true;
                Utils.getServerList[indexFind].isSelected = true;
                Preference.shared.setString(
                    Preference.qrUrlData, Utils.getServerList[indexFind].url);
                var json = jsonEncode(
                    Utils.getServerList.map((e) => e.toJson()).toList());
                Preference.shared.setList(Preference.serverUrlAllListed, json);
              }
              Get.back();
              Get.back();
            }
            else{

              var indexFind = Utils.getServerList.indexWhere((element) => element.isSelected).toInt();
              if(indexFind != -1) {
                for (int i = 0; i < Utils.getServerList.length; i++) {
                  Utils.getServerList[i].isSelected = false;
                }
                Utils.getServerList[indexFind].isPrimary = true;
                Utils.getServerList[indexFind].isSelected = true;
                Preference.shared.setString(
                    Preference.qrUrlData, Utils.getServerList[indexFind].url);
                var json = jsonEncode(
                    Utils.getServerList.map((e) => e.toJson()).toList());
                Preference.shared.setList(Preference.serverUrlAllListed, json);
              }
              if(Utils.getServerList.where((element) => element.isSelected).toList().length > 1 && Utils.getServerList.where((element) => element.isSecure && element.patientId != "").toList().isNotEmpty){
                if(kIsWeb){
                  Get.toNamed(AppRoutes.configurationMain);
                }else{
                  Get.toNamed(AppRoutes.integrationScreen, arguments: [false]);
                }
              }else{
                Get.toNamed(AppRoutes.healthPatientList,arguments: [true,false]);
              }
            }*/
            if(Utils.getServerList.where((element) => element.isPrimary).toList().isEmpty){
              var selectedServer = Utils.getServerList.where((element) => element.isSelected).toList();
              if(selectedServer.isNotEmpty){
                selectedServer[0].isPrimary = true;
                var json = jsonEncode(
                    Utils.getServerList.map((e) => e.toJson()).toList());
                Preference.shared.setList(Preference.serverUrlAllListed, json);
              }
            }
            Get.back();
            Get.back();
          }
        }
        else {
          if(Utils.getServerList.where((element) => element.isPrimary).toList().isEmpty){
            var selectedServer = Utils.getServerList.where((element) => element.isSelected).toList();
            if(selectedServer.isNotEmpty){
              selectedServer[0].isPrimary = true;
              var json = jsonEncode(
                  Utils.getServerList.map((e) => e.toJson()).toList());
              Preference.shared.setList(Preference.serverUrlAllListed, json);
            }
          }

          if(Utils.getServerList.where((element) => element.isSelected).toList().length > 1) {
            healthProviderController!.pageController.nextPage(
                duration: const Duration(milliseconds: 300), curve: Curves.easeIn);

          }
          else{
            var indexFind = Utils.getServerList.indexWhere((element) => element.isSelected).toInt();
            if(indexFind != -1) {
              for (int i = 0; i < Utils.getServerList.length; i++) {
                Utils.getServerList[i].isSelected = false;
              }
              Utils.getServerList[indexFind].isPrimary = true;
              Utils.getServerList[indexFind].isSelected = true;
              Preference.shared.setString(
                  Preference.qrUrlData, Utils.getServerList[indexFind].url);
              var json = jsonEncode(
                  Utils.getServerList.map((e) => e.toJson()).toList());
              Preference.shared.setList(Preference.serverUrlAllListed, json);
            }


            if(Utils.getServerList.where((element) => element.isSelected  && element.isSecure && element.patientId != "").toList().isNotEmpty){
              Preference.shared.setBool(Preference.keyHealthProvider,false);

              if(kIsWeb){
                Preference.shared.setBool(Preference.keyConfiguration,true);
                Get.toNamed(AppRoutes.configurationMain);
              }else{
                Preference.shared.setBool(Preference.keyIntegrationScreen,true);
                Get.toNamed(AppRoutes.integrationScreen, arguments: [false]);
              }
            } else {
              // healthProviderController!.pageController.jumpToPage(3);
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
      }
    } else {
      Utils.showToast(Get.context!, "Please select connection");
    }
  }

  void onQRViewCreated(value,{bool isBack = false}) {

    var linkAndClientId = value;
    var url = value;
    var clientId = "";
    if (linkAndClientId.contains("?")) {
      url = linkAndClientId.split("?")[0];
      if (linkAndClientId.split("?").length > 1) {
        clientId = linkAndClientId.split("?")[1].split("=")[1];
        selectedUrlClientId = clientId;
        // ProviderRequest.setClientId(clientId);
      }
    }
    addOtherUrlController.text = url;

    Debug.printLog("isShowDialogOpen.....$isShowDialogOpen");
    if(isBack){
      Get.back();
    }
    if(clientId != ""){
        isShowDialogOpen = false;
        update();
        /*showDialogForAddNewServerUrl(
            Get.context!, update,false);*/
        Utils.checkWhetherSecureOrNot(url, Get.context!).then((value) async {
          Debug.printLog(
              "Map data from metadata....$value");
          if (value.isNotEmpty) {
            if(value[Constant.msg] == Constant.failedConnected){
              Get.back();
              Get.back();
              Utils.showErrorDialog(Get.context!, Constant.txtError,value[Constant.msg] );
              return;
            }
            if(value[Constant.metaDataServerSecure]){
              Get.back();
              changeIsAuth(true);
            }
            if(value[Constant.metaDataServerName] != "") {
              addServerTitleName.text =
                  value[Constant.metaDataServerName].toString();
            }
            addOtherUrlClientIdController.text = clientId;
            showDialogForAddNewServerUrl(
                Get.context!, update,false);
          } else {
            Utils.showToast(Get.context!,
                value[Constant.msg]
                    .toString());
          }
          update();
        });
      return;
    }
    else{
        isShowDialogOpen = false;
        update();
        isAuth = false;
        showDialogForAddNewServerUrl(
            Get.context!, update,false);
    }
    Debug.printLog('Scanned data:;;;; $value');
    update();
  }

  @override
  void dispose() {
    qrCodeDetailsController.clear();
    cameraController!.dispose();
    isFromSetting = false;
    super.dispose();
  }

  @override
  void onClose() {
    isFromSetting = false;
    super.onClose();
  }

  void removeFromUrlList(int index,{bool isRemovedFromLocal = false}) {
    if(!isRemovedFromLocal){
      Utils.getServerList.removeAt(index);
    }
    var json = jsonEncode(Utils.getServerList.map((e) => e.toJson()).toList());
    Preference.shared.setList(Preference.serverUrlAllListed, json);
    update();
  }

  void onChangeTextFiled(int index,bool isFromEdit) {
    if(isFromEdit) {
      addServerTitleName.text = Utils.getServerList[index].title;
      addOtherUrlController.text = Utils.getServerList[index].url;
      addOtherUrlClientIdController.text = Utils.getServerList[index].clientId;
      isAuth = Utils.getServerList[index].isSecure;
    }else{
      addServerTitleName.clear();
      addOtherUrlController.clear();
      addOtherUrlClientIdController.clear();
      isAuth = false;
    }
    onChangeEditAdd(isFromEdit);
    update();
  }

  void onChangeEditAdd(bool value) {
    isEdit = value;
    update();
  }

  void onChangeAuth(int index) {
    isAuth = !isAuth;
    /*if(isEdit) {
      Utils.getServerList[index].isSecure = isAuth;
      Debug.printLog("onChangeAuth...${Utils.getServerList[index].isSecure}");
      var json = jsonEncode(
          Utils.getServerList.map((e) => e.toJson()).toList());
      Preference.shared.setList(Preference.serverUrlAllListed, json);
    }*/
    update();
  }

  Future<void> callSecureServerAPI(String url,String clientId,String serverName, setStateDialogForChooseCode,
      {Function? callBack}) async {
    if (url.isNotEmpty) {

      try {
        SmartFhirClient? smartFhirClient;
        if (clientId != "") {
          FhirUri redirect;
          if(kIsWeb){
            redirect = Api.fhirCallbackWeb;
          }
          else
          {
            redirect = Api.fhirCallback;
          }
          smartFhirClient = SmartFhirClient(
              fhirUri: FhirUri(url),
              clientId: clientId,
              redirectUri: redirect
          );
          _showDialogForProgress(Get.context!);
          isShowDialog = true;
          var msg = "";
          var isSuccess = false;
          var fhirParameters = {};
          try {
            await smartFhirClient.login(callBackFunction: (value){
              Debug.printLog("Smart login.....$value");
              var mapData = value;
              msg = mapData[Constant.msg];
              isSuccess = mapData[Constant.isSuccess];
              fhirParameters = mapData[Constant.fhirParameters];
            },callBackForTokenUrl: (url){
              Debug.printLog("Token Url....$url");
              Preference.shared.setString(Preference.tokenUrl, url);
            });
          } catch (e) {
            isSuccess = false;
            Debug.printLog(e.toString());
          }

          if(!isSuccess && fhirParameters.isEmpty){
            Get.back();
            addOtherUrlClientIdController.clear();
            addOtherUrlController.clear();
            addServerTitleName.clear();
            if(callBack != null) {
              var returnValue = {};
              returnValue[Constant.type] = Constant.returnType;
              returnValue[Constant.fhirParameters] = fhirParameters;
              returnValue[Constant.isSuccess] = isSuccess;
              returnValue[Constant.msg] = Constant.txtUserCanceled;
              callBack.call(returnValue);
            }
            return;
          }else if(!isSuccess && fhirParameters["practitioner_id"] == null){
            Get.back();
            addOtherUrlClientIdController.clear();
            addOtherUrlController.clear();
            addServerTitleName.clear();
            if(callBack != null) {
              var returnValue = {};
              returnValue[Constant.type] = Constant.returnType;
              returnValue[Constant.fhirParameters] = fhirParameters;
              returnValue[Constant.isSuccess] = isSuccess;
              returnValue[Constant.msg] = msg.toString();
              callBack.call(returnValue);
            }
            return;
          }

          String authToken = Preference.shared.getString(Preference.authToken) ?? "";
          Debug.printLog("authToken.....$authToken");
          String refreshToken = Preference.shared.getString(Preference.refreshToken) ?? "";
          String smartFhirPatientDisplayName = Preference.shared.getString(Preference.smartFhirPatientName) ?? "";
          String smartFhirPatientId = Preference.shared.getString(Preference.smartFhirPatientId) ?? "";
          int expireTime = Preference.shared.getInt(Preference.expireTime) ?? 0;
          var getIndexOfSecureServer = Utils.getServerList.indexWhere((element) => element.url == url &&
          element.clientId == clientId && element.title == serverName).toInt();
          if(getIndexOfSecureServer != -1 && authToken != ""){
            Utils.getServerList[getIndexOfSecureServer].lastDateTimeStr = DateTime.now().toString();
            Utils.getServerList[getIndexOfSecureServer].lastLoggedTime = DateTime.now().millisecondsSinceEpoch;
            Utils.getServerList[getIndexOfSecureServer].isSecure = true;
            Utils.getServerList[getIndexOfSecureServer].isPrimary = Utils.getServerList[getIndexOfSecureServer].isPrimary;
            Utils.getServerList[getIndexOfSecureServer].isSelected = true;
            Utils.getServerList[getIndexOfSecureServer].authToken = authToken;
            Utils.getServerList[getIndexOfSecureServer].refreshToken = refreshToken;
            Utils.getServerList[getIndexOfSecureServer].expireTime = expireTime;
            Utils.getServerList[getIndexOfSecureServer].patientId = smartFhirPatientId;
            Utils.getServerList[getIndexOfSecureServer].patientFName = smartFhirPatientDisplayName;
            Utils.getServerList[getIndexOfSecureServer].patientLName = smartFhirPatientDisplayName;
            var json = jsonEncode(Utils.getServerList.map((e) => e.toJson()).toList());
            Preference.shared.setList(Preference.serverUrlAllListed,json);
            Utils.clearTrackingChartData();
            await DataBaseHelper.shared.dbMonthlyLogCodeBox?.clear();
          }

        }


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
      // setStateDialogForChooseCode((){});
    }
  }

  _showDialogForProgress(BuildContext context) {
    if(kIsWeb){
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            insetPadding: const EdgeInsets.all(0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            backgroundColor: CColor.white,
            child: LayoutBuilder(
              builder: (BuildContext context,BoxConstraints  constraints) {
                return Container(
                  padding: EdgeInsets.only(
                      left: AppFontStyle.sizesWidthManageWeb(1.3,constraints),
                      top: AppFontStyle.sizesHeightManageWeb(2.0,constraints),
                      right: AppFontStyle.sizesWidthManageWeb(1.3,constraints),
                      bottom:AppFontStyle.sizesHeightManageWeb(2.0,constraints)),
                  // height: (kIsWeb) ? Sizes.height_9 :Get.height * 0.1,
                  child: Wrap(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const CircularProgressIndicator(),
                          Container(
                            margin: EdgeInsets.only(bottom: Sizes.height_0_5),
                            child: Text(
                              Constant.txtPleaseWait,
                              style: AppFontStyle.styleW700(CColor.black,
                                  AppFontStyle.sizesFontManageWeb(1.5,constraints)),
                            ),
                          ),
                          Text(Constant.txtConnectingPatient,
                              style:
                              AppFontStyle.styleW400(CColor.black,
                                  AppFontStyle.sizesFontManageWeb(1.3,constraints))),

                        ],
                      ),
                    ],
                  ),
                );
              }
            ),
          );
        },
      );
    }else {
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
                      Constant.txtPleaseWait,
                      style: AppFontStyle.styleW700(CColor.black,
                          (kIsWeb) ? FontSize.size_10 : FontSize.size_12),
                    ),
                  ),
                  Text(Constant.txtConnectingPatient,
                      style: AppFontStyle.styleW400(CColor.black,
                          (kIsWeb) ? FontSize.size_8 : FontSize.size_10))
                ],
              ),
            ),
          );
        },
      );
    }
  }

  checkServerAuth(){
    if(Utils.getServerList.where((element) => element.isSelected).toList().where((element) => element.authToken == ""
        && element.isSecure).toList().isNotEmpty){
      Utils.showToast(Get.context!, "Please Authorize your Connection");
    }else{
      Get.back();
    }
  }

  void showDialogAfterSuccess() {
    if(kIsWeb){
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        barrierColor: CColor.transparent,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                backgroundColor: CColor.transparent,
                // insetPadding: const EdgeInsets.all(0),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                child: LayoutBuilder(
                  builder: (BuildContext context,BoxConstraints constraints) {
                    return Wrap(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: CColor.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          padding: EdgeInsets.all(AppFontStyle.sizesWidthManageWeb(1.0, constraints)),
                          // width: (kIsWeb) ?Get.width * 0.5: Get.width * 0.8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: Sizes.height_0_5),
                                child: Text(
                                  Constant.txtConnectionSuccess,
                                  style: AppFontStyle.styleW700(CColor.black,
                                      (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_12),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: Sizes.height_0_5),
                                child: Text(
                                  Constant.likeToAddConnection,
                                  style: AppFontStyle.styleW500(CColor.black,
                                      (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints): FontSize.size_10),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: Sizes.height_1),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () async {
                                          await isClose();
                                          isShowDialogOpen = true;
                                          gotoNextPage();
                                        },
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(
                                              CColor.transparent),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15.0),
                                              side: const BorderSide(
                                                  color: CColor.primaryColor,
                                                  width: 0.7),
                                            ),
                                          ),
                                        ),
                                        child: Padding(
                                    padding:  EdgeInsets.symmetric(vertical: 9,horizontal: 10),
                                          child: Text(
                                            "No",
                                            textAlign: TextAlign.center,
                                            style: AppFontStyle.styleW400(
                                                CColor.black, AppFontStyle.sizesFontManageWeb(1.3, constraints)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: Sizes.width_2),
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () async {
                                          await isClose();
                                          showDialogAddNewConnection();
                                        },
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(
                                              CColor.primaryColor),
                                          elevation: MaterialStateProperty.all(1),
                                          shadowColor:
                                          MaterialStateProperty.all(CColor.gray),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15.0),
                                              side: const BorderSide(
                                                  color: CColor.primaryColor,
                                                  width: 0.7),
                                            ),
                                          ),
                                        ),
                                        child: Padding(
                                    padding:  EdgeInsets.symmetric(vertical: 9,horizontal: 10),
                                          child: Text(
                                            "Yes",
                                            textAlign: TextAlign.center,
                                            style: AppFontStyle.styleW400(
                                                CColor.white, AppFontStyle.sizesFontManageWeb(1.3, constraints)),

                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                ),
              );
            },
          );
        },
      );
    }else {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: CColor.white,
                contentPadding: const EdgeInsets.all(0),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                content: Wrap(
                  children: [
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(Sizes.width_5),
                        width: Get.width * 0.8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: Sizes.height_0_5),
                              child: Text(
                                Constant.txtConnectionSuccess,
                                style: AppFontStyle.styleW700(CColor.black,
                                    (kIsWeb) ? FontSize.size_10 : FontSize
                                        .size_12),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: Sizes.height_0_5),
                              child: Text(
                                Constant.likeToAddConnection,
                                style: AppFontStyle.styleW500(CColor.black,
                                    (kIsWeb) ? FontSize.size_10 : FontSize
                                        .size_10),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: Sizes.height_2),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () async {
                                        await isClose();
                                        isShowDialogOpen = true;
                                        gotoNextPage();
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .all(
                                            CColor.transparent),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                15.0),
                                            side: const BorderSide(
                                                color: CColor.primaryColor,
                                                width: 0.7),
                                          ),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                          "No",
                                          textAlign: TextAlign.center,
                                          style: AppFontStyle.styleW400(
                                              CColor.black, FontSize.size_12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: Sizes.width_2),
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () async {
                                        await isClose();
                                        showDialogAddNewConnection();
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .all(
                                            CColor.primaryColor),
                                        elevation: MaterialStateProperty.all(1),
                                        shadowColor:
                                        MaterialStateProperty.all(CColor.gray),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                15.0),
                                            side: const BorderSide(
                                                color: CColor.primaryColor,
                                                width: 0.7),
                                          ),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                          "Yes",
                                          textAlign: TextAlign.center,
                                          style: AppFontStyle.styleW400(
                                              CColor.white, FontSize.size_12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }
  }

  /*void showDialogAfterSuccessCamera() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: CColor.white,
              contentPadding: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
              content: Wrap(
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(Sizes.width_5),
                      width: Get.width * 0.8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: Sizes.height_0_5),
                            child: Text(
                              "Connection Successful!",
                              style: AppFontStyle.styleW700(CColor.black,
                                  (kIsWeb) ? FontSize.size_10 : FontSize.size_12),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: Sizes.height_0_5),
                            child: Text(
                              "Would you like to add another connection?",
                              style: AppFontStyle.styleW500(CColor.black,
                                  (kIsWeb) ? FontSize.size_10 : FontSize.size_10),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: Sizes.height_2),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () async {
                                      Get.back();
                                      isShowDialogOpen = true;
                                      addServerUrlClientIdControllerQrView.clear();
                                      addServerUrlControllerQrView.clear();
                                      addServerTitleNameQrView.clear();
                                      changeIsAuth(false);
                                      gotoNextPage();
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(
                                          CColor.transparent),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                          side: const BorderSide(
                                              color: CColor.primaryColor,
                                              width: 0.7),
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                        "No",
                                        textAlign: TextAlign.center,
                                        style: AppFontStyle.styleW400(
                                            CColor.black, FontSize.size_12),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: Sizes.width_2),
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      Get.back();
                                      addServerUrlClientIdControllerQrView.clear();
                                      addServerUrlControllerQrView.clear();
                                      addServerTitleNameQrView.clear();
                                      changeIsAuth(false);
                                      showDialogAddNewConnection();

                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(
                                          CColor.primaryColor),
                                      elevation: MaterialStateProperty.all(1),
                                      shadowColor:
                                      MaterialStateProperty.all(CColor.gray),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                          side: const BorderSide(
                                              color: CColor.primaryColor,
                                              width: 0.7),
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                        "Yes",
                                        textAlign: TextAlign.center,
                                        style: AppFontStyle.styleW400(
                                            CColor.white, FontSize.size_12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((value) => {
      isShowDialogOpen = true,
      update(),
    });
  }*/

  showDialogAddNewConnection() {
    if(kIsWeb){
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                backgroundColor: CColor.white,
                insetPadding: const EdgeInsets.all(0),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                child: LayoutBuilder(
                  builder: (BuildContext context,BoxConstraints constraints) {
                    return Wrap(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all((kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3),
                          width: (kIsWeb) ? AppFontStyle.sizesFontManageWeb(20.0, constraints) : Get.width * 0.3,
                          child: Column(
                            children: [
                              if(addServerTitleName.text.isNotEmpty)
                                Container(
                                  margin: EdgeInsets.only(bottom: Sizes.height_2),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints):Sizes.width_2,
                                            left: (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_2,
                                            bottom: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.6, constraints) : Sizes.height_1),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Connection Name",
                                              style: AppFontStyle.styleW700(CColor.black,(kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints) : FontSize.size_3 ),
                                            ),
                                            PopupMenuButton(
                                              elevation: 0,
                                              constraints: BoxConstraints(
                                                  minWidth: Get.width * 0.1, maxWidth: Get.width * 0.3),
                                              color: Colors.transparent,
                                              padding: const EdgeInsets.all(0),
                                              position: PopupMenuPosition.under,
                                              itemBuilder: (context) {
                                                return [
                                                  PopupMenuItem(
                                                    child: Container(
                                                        padding: const EdgeInsets.all(6),
                                                        decoration: BoxDecoration(
                                                            color: CColor.white,
                                                            border: Border.all(width: 1),
                                                            borderRadius: BorderRadius.circular(10)),
                                                        child: const Text(
                                                            Constant.connectionNameToolTip)),
                                                  ),
                                                ];
                                              },
                                              child: Icon(Icons.info_outline,
                                                  color: CColor.black, size: AppFontStyle.sizesFontManageWeb(1.5, constraints)),
                                            ),

                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(bottom:  AppFontStyle.sizesHeightManageWeb(0.6, constraints)),
                                        // height: Get.height * 0.1,
                                        color: CColor.transparent,
                                        child: TextFormField(
                                          controller: addServerTitleName,
                                          focusNode: addServerTitleNameFocus,
                                          textAlign: TextAlign.start,
                                          keyboardType: TextInputType.text,
                                          style: AppFontStyle.styleW500(
                                              CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(0.8, constraints) :FontSize.size_3),
                                          maxLines: 1,
                                          cursorColor: CColor.black,
                                          decoration: InputDecoration(
                                            filled: true,
                                            // contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: Sizes.width_5),
                                            border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: CColor.primaryColor, width: 0.7),
                                              borderRadius: BorderRadius.circular(15.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: CColor.primaryColor, width: 0.7),
                                              borderRadius: BorderRadius.circular(15.0),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: CColor.primaryColor, width: 0.7),
                                              borderRadius: BorderRadius.circular(15.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: CColor.primaryColor, width: 0.7),
                                              borderRadius: BorderRadius.circular(15.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              Container(
                                margin: EdgeInsets.only(
                                    right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_1,
                                    left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) :  Sizes.width_1),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Connection URL",
                                      style: AppFontStyle.styleW700(CColor.black,(kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints): FontSize.size_3 ),
                                    ),
                                    PopupMenuButton(
                                      elevation: 0,
                                      constraints: BoxConstraints(
                                          minWidth: Get.width * 0.1, maxWidth: Get.width * 0.3),
                                      color: Colors.transparent,
                                      padding: const EdgeInsets.all(0),
                                      position: PopupMenuPosition.under,
                                      itemBuilder: (context) {
                                        return [
                                          PopupMenuItem(
                                            child: Container(
                                                padding: const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                    color: CColor.white,
                                                    border: Border.all(width: 1),
                                                    borderRadius: BorderRadius.circular(10)),
                                                child: const Text(
                                                    Constant.connectionURLToolTip)),
                                          ),
                                        ];
                                      },
                                      child: Icon(Icons.info_outline,
                                          color: CColor.black, size: AppFontStyle.sizesFontManageWeb(1.5, constraints)),
                                    ),

                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.6, constraints)  : Sizes.height_1),
                                // height: Get.height * 0.1,
                                color: CColor.transparent,
                                child: TextFormField(
                                  controller: addOtherUrlController,
                                  focusNode: addOtherUrlFocus,
                                  textAlign: TextAlign.start,
                                  keyboardType: TextInputType.text,
                                  style: AppFontStyle.styleW500(
                                      CColor.black,  (kIsWeb) ? AppFontStyle.sizesFontManageWeb(0.8, constraints) :FontSize.size_3),
                                  maxLines: 1,
                                  cursorColor: CColor.black,
                                  decoration: InputDecoration(
                                    filled: true,
                                    // contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: Sizes.width_5),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: CColor.primaryColor, width: 0.7),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: CColor.primaryColor, width: 0.7),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: CColor.primaryColor, width: 0.7),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: CColor.primaryColor, width: 0.7),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                ),
                              ),
                              if(isAuth)
                                Container(
                                  margin: EdgeInsets.only(top:(kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.8, constraints) : Sizes.height_1),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            right:  (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.0, constraints) :Sizes.width_1,
                                            left:(kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_1),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Client Id",
                                              style: AppFontStyle.styleW700(CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints) : FontSize.size_3),
                                            ),
                                            PopupMenuButton(
                                              elevation: 0,
                                              constraints: BoxConstraints(
                                                  minWidth: Get.width * 0.1, maxWidth: Get.width * 0.3),
                                              color: Colors.transparent,
                                              padding: const EdgeInsets.all(0),
                                              position: PopupMenuPosition.under,
                                              itemBuilder: (context) {
                                                return [
                                                  PopupMenuItem(
                                                    child: Container(
                                                        padding: const EdgeInsets.all(6),
                                                        decoration: BoxDecoration(
                                                            color: CColor.white,
                                                            border: Border.all(width: 1),
                                                            borderRadius: BorderRadius.circular(10)),
                                                        child: const Text(
                                                            Constant.clientIdToolTip)),
                                                  ),
                                                ];
                                              },
                                              child: Icon(Icons.info_outline,
                                                  color: CColor.black, size: AppFontStyle.sizesFontManageWeb(1.5, constraints)),
                                            ),

                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.6, constraints) : Sizes.height_1),
                                        // height: Get.height * 0.1,
                                        color: CColor.transparent,
                                        child: TextFormField(
                                          controller: addOtherUrlClientIdController,
                                          focusNode: addOtherUrlClientIdFocus,
                                          textAlign: TextAlign.start,
                                          keyboardType: TextInputType.text,
                                          style: AppFontStyle.styleW500(
                                              CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(0.8, constraints) : FontSize.size_3),
                                          maxLines: 1,
                                          cursorColor: CColor.black,
                                          decoration: InputDecoration(
                                            filled: true,
                                            // contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: Sizes.width_5),
                                            border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: CColor.primaryColor, width: 0.7),
                                              borderRadius: BorderRadius.circular(15.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: CColor.primaryColor, width: 0.7),
                                              borderRadius: BorderRadius.circular(15.0),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: CColor.primaryColor, width: 0.7),
                                              borderRadius: BorderRadius.circular(15.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: CColor.primaryColor, width: 0.7),
                                              borderRadius: BorderRadius.circular(15.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              Container(
                                margin: EdgeInsets.only(top: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.3, constraints) : Sizes.height_1),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () {
                                          isShowDialogOpen = true;
                                          clearControllersAndValues();
                                          Get.back();
                                        },
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(
                                              CColor.transparent),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15.0),
                                              side: const BorderSide(
                                                  color: CColor.primaryColor,
                                                  width: 0.7),
                                            ),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            "Cancel",
                                            textAlign: TextAlign.center,
                                            style: AppFontStyle.styleW400(
                                                CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints) : FontSize.size_3),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: Sizes.width_2),
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () {
                                          var serverInputtedUrl = addOtherUrlController.text.toString();
                                          var serverClientId = addOtherUrlClientIdController.text.toString();
                                          if(serverInputtedUrl.isNotEmpty && serverClientId.isEmpty && isValidURL(serverInputtedUrl)) {
                                            Utils.checkWhetherSecureOrNot(serverInputtedUrl, context).then((value) async {
                                              Debug.printLog(
                                                  "Map data from metadata....$value");
                                              if (value.isNotEmpty) {
                                                if(value[Constant.msg] == Constant.failedConnected){
                                                  Get.back();
                                                  Get.back();
                                                  Utils.showErrorDialog(context, Constant.txtError,value[Constant.msg] );
                                                  return;
                                                }
                                                if (value[Constant
                                                    .metaDataServerName] !=
                                                    null) {
                                                  changeServerName(value[Constant
                                                      .metaDataServerName],
                                                      false);
                                                }

                                                if (value[Constant
                                                    .metaDataServerSecure]) {
                                                  Get.back();
                                                  changeIsAuth(true);
                                                } else {
                                                  ///This is for when It will come without Secure server from the
                                                  ///Meta data API then we will close this Dialog and Show Connection success
                                                  ///Dialog
                                                  // Get.back();
                                                  addNewServerUrlDataIntoList(
                                                      true, Get.context!,
                                                      isNotClose: false);
                                                }

                                                if(!value[Constant.metaDataServerSecure]) {
                                                  if (context.mounted) {
                                                    try {
                                                      await getPatientList(
                                                          false);
                                                    } catch (e) {
                                                      Debug.printLog(
                                                          'Error fetching patient list: $e');
                                                    }
                                                  }
                                                }
                                              } else {
                                                Utils.showToast(Get.context!,
                                                    value[Constant.msg]
                                                        .toString());
                                              }
                                              setState(() {});
                                            });
                                          }
                                          else if (serverInputtedUrl.isNotEmpty &&
                                              serverClientId.isNotEmpty) {
                                            addNewServerUrlAuth(
                                                true, Get.context!);
                                            isShowDialogOpen = true;
                                            onChangeEditAdd(isEdit);
                                          }
                                          else {
                                            Utils.showToast(Get.context!,
                                                "Please enter valid connection URL");
                                          }
                                        },
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(
                                              CColor.primaryColor),
                                          elevation: MaterialStateProperty.all(1),
                                          shadowColor:
                                          MaterialStateProperty.all(CColor.gray),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15.0),
                                              side: const BorderSide(
                                                  color: CColor.primaryColor,
                                                  width: 0.7),
                                            ),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            "Connect",
                                            textAlign: TextAlign.center,
                                            style: AppFontStyle.styleW400(
                                                CColor.white, ( kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints) :FontSize.size_3),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                ),
              );
            },
          );
        },
      ).then((value) => (value) {
        onChangeEditAdd(false);
      });
    }
    else {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: CColor.white,
                contentPadding: const EdgeInsets.all(0),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                content: Wrap(
                  children: [
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(Sizes.width_5),
                        width: Get.width * 0.8,
                        child: Column(
                          children: [
                            if(addServerTitleName.text.isNotEmpty)
                              Container(
                                margin: EdgeInsets.only(bottom: Sizes.height_2),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          right: Sizes.width_2,
                                          left: Sizes.width_2,
                                          bottom: Sizes.height_1),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Connection Name",
                                            style: AppFontStyle.styleW700(
                                                CColor.black,
                                                (kIsWeb)
                                                    ? FontSize.size_3
                                                    : FontSize.size_10),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      // margin: EdgeInsets.only(top: Sizes.height_1),
                                      color: CColor.transparent,
                                      child: TextFormField(
                                        controller: addServerTitleName,
                                        focusNode: addServerTitleNameFocus,
                                        textAlign: TextAlign.start,
                                        keyboardType: TextInputType.text,
                                        style: AppFontStyle.styleW500(
                                            CColor.black, FontSize.size_10),
                                        maxLines: 1,
                                        cursorColor: CColor.black,
                                        decoration: InputDecoration(
                                          filled: true,
                                          // contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: Sizes.width_5),
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: CColor.primaryColor,
                                                width: 0.7),
                                            borderRadius: BorderRadius.circular(
                                                15.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: CColor.primaryColor,
                                                width: 0.7),
                                            borderRadius: BorderRadius.circular(
                                                15.0),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: CColor.primaryColor,
                                                width: 0.7),
                                            borderRadius: BorderRadius.circular(
                                                15.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: CColor.primaryColor,
                                                width: 0.7),
                                            borderRadius: BorderRadius.circular(
                                                15.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Container(
                              margin: EdgeInsets.only(
                                  right: Sizes.width_2, left: Sizes.width_2),
                              child: Row(
                                children: [
                                  Text(
                                    "Connection URL",
                                    style: AppFontStyle.styleW700(CColor.black,
                                        (kIsWeb) ? FontSize.size_3 : FontSize
                                            .size_10),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: Sizes.height_1),
                              color: CColor.transparent,
                              child: TextFormField(
                                controller: addOtherUrlController,
                                focusNode: addOtherUrlFocus,
                                textAlign: TextAlign.start,
                                keyboardType: TextInputType.text,
                                style: AppFontStyle.styleW500(
                                    CColor.black, FontSize.size_10),
                                maxLines: 1,
                                cursorColor: CColor.black,
                                decoration: InputDecoration(
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: CColor.primaryColor, width: 0.7),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: CColor.primaryColor, width: 0.7),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: CColor.primaryColor, width: 0.7),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: CColor.primaryColor, width: 0.7),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                              ),
                            ),
                            if(isAuth)
                              Container(
                                margin: EdgeInsets.only(top: Sizes.height_2),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          right: Sizes.width_2,
                                          left: Sizes.width_2),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Client Id",
                                            style: AppFontStyle.styleW700(
                                                CColor.black,
                                                (kIsWeb)
                                                    ? FontSize.size_3
                                                    : FontSize.size_10),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: Sizes.height_1),
                                      color: CColor.transparent,
                                      child: TextFormField(
                                        controller: addOtherUrlClientIdController,
                                        focusNode: addOtherUrlClientIdFocus,
                                        textAlign: TextAlign.start,
                                        keyboardType: TextInputType.text,
                                        style: AppFontStyle.styleW500(
                                            CColor.black, FontSize.size_10),
                                        maxLines: 1,
                                        cursorColor: CColor.black,
                                        decoration: InputDecoration(
                                          filled: true,
                                          // contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: Sizes.width_5),
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: CColor.primaryColor,
                                                width: 0.7),
                                            borderRadius: BorderRadius.circular(
                                                15.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: CColor.primaryColor,
                                                width: 0.7),
                                            borderRadius: BorderRadius.circular(
                                                15.0),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: CColor.primaryColor,
                                                width: 0.7),
                                            borderRadius: BorderRadius.circular(
                                                15.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: CColor.primaryColor,
                                                width: 0.7),
                                            borderRadius: BorderRadius.circular(
                                                15.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Container(
                              margin: EdgeInsets.only(top: Sizes.height_2),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {
                                        isShowDialogOpen = true;
                                        clearControllersAndValues();
                                        Get.back();
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .all(
                                            CColor.transparent),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                15.0),
                                            side: const BorderSide(
                                                color: CColor.primaryColor,
                                                width: 0.7),
                                          ),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                          "Cancel",
                                          textAlign: TextAlign.center,
                                          style: AppFontStyle.styleW400(
                                              CColor.black, FontSize.size_12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: Sizes.width_2),
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {
                                        var serverInputtedUrl = addOtherUrlController
                                            .text.toString();
                                        var serverClientId = addOtherUrlClientIdController
                                            .text.toString();
                                        if (serverInputtedUrl.isNotEmpty &&
                                            serverClientId.isEmpty && isValidURL(serverInputtedUrl)) {
                                          Utils.checkWhetherSecureOrNot(
                                              serverInputtedUrl, context).then((
                                              value) async {
                                            Debug.printLog(
                                                "Map data from metadata....$value");
                                            if (value.isNotEmpty) {
                                              if(value[Constant.msg] == Constant.failedConnected){
                                                Get.back();
                                                Get.back();
                                                Utils.showErrorDialog(context, Constant.txtError,value[Constant.msg] );
                                                return;
                                              }
                                              if (value[Constant
                                                  .metaDataServerName] !=
                                                  null) {
                                                changeServerName(value[Constant
                                                    .metaDataServerName],
                                                    false);
                                              }

                                              if (value[Constant
                                                  .metaDataServerSecure]) {
                                                Get.back();
                                                changeIsAuth(true);
                                              } else {
                                                ///This is for when It will come without Secure server from the
                                                ///Meta data API then we will close this Dialog and Show Connection success
                                                ///Dialog
                                                // Get.back();
                                                addNewServerUrlDataIntoList(
                                                    true, Get.context!,
                                                    isNotClose: false);
                                              }

                                              if(!value[Constant.metaDataServerSecure]) {
                                                if (context.mounted) {
                                                  try {
                                                    await getPatientList(
                                                        false);
                                                  } catch (e) {
                                                    Debug.printLog(
                                                        'Error fetching patient list: $e');
                                                  }
                                                }
                                              }
                                            } else {
                                              Utils.showToast(Get.context!,
                                                  value[Constant.msg]
                                                      .toString());
                                            }
                                            setState(() {});
                                          });
                                        }
                                        else if (serverInputtedUrl.isNotEmpty &&
                                            serverClientId.isNotEmpty) {
                                          addNewServerUrlAuth(
                                              true, Get.context!);
                                          isShowDialogOpen = true;
                                          onChangeEditAdd(isEdit);
                                        }
                                        else {
                                          Utils.showToast(Get.context!,
                                              "Please enter valid connection URL");
                                        }
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .all(
                                            CColor.primaryColor),
                                        elevation: MaterialStateProperty.all(1),
                                        shadowColor:
                                        MaterialStateProperty.all(CColor.gray),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                15.0),
                                            side: const BorderSide(
                                                color: CColor.primaryColor,
                                                width: 0.7),
                                          ),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                          "Connect",
                                          textAlign: TextAlign.center,
                                          style: AppFontStyle.styleW400(
                                              CColor.white, FontSize.size_12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ).then((value) =>
          (value) {
        onChangeEditAdd(false);
      });
    }
  }


  void changeIsAuth(bool value) {
    isAuth = value;
    update();
  }

  void changeServerName(String value,bool isFromQrView) {
    addServerTitleName.text = value;
    update();
  }

  Future<void> getPatientList(bool isFromSearch) async {
    var url =addOtherUrlController.text.toString();
    var serverName = addServerTitleName.text.toString();
    var selectedUrlModel = ServerModelJson(isSecure: false,
        displayName: serverName,
        title: serverName, url: url,
        clientId: "",
        isSelected: true, isPrimary: false);
        patientProfileList.clear();
      if(isFromSearch){
        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(milliseconds: 800), () async {
          await callApi(selectedUrlModel,isFromSearch);
        });
      }else{
        await callApi(selectedUrlModel,isFromSearch);
      }

  }

  callApi(ServerModelJson selectedUrlModel, bool isFromSearch) async {
    onChangeProgressValue(true);
    var listData = await PaaProfiles.getPatientListTestUse(
        R4ResourceType.Patient,
        searchIdControllers.text,
        searchNameControllers.text,
        selectedUrlModel);
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

            var userName = "";
            try {
              var givenNameList = data.resource.name[0].given;
              if (data.resource.name[0].given != null) {
                if (givenNameList.isNotEmpty) {
                  for (int i = 0; i < givenNameList.length; i++) {
                    userName = "${givenNameList[i]} ";
                  }
                }
              }
            } catch (e) {
              Debug.printLog("lName...$e");
            }
            var lName = "";
            try {
              lName = data.resource.name[0].family.toString();
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

            patientData.patientId = id;
            patientData.fName = userName;
            patientData.lName = lName;
            patientData.dob = dob;
            patientData.gender = gender;
            patientProfileList.add(patientData);
          }
        }
      }
    }
    Preference.shared
        .setString(Preference.getPatientFNameApi, searchNameControllers.text);
    onChangeProgressValue(false);
    update();

    ///This back is for already started dialog (Please wait...) and isFromSearch measn this is the first time init


    if(!isFromSearch) {
      Get.back();
    }
    Get.back();
    showPatientSelectionDialog(Get.context!);

    Debug.printLog("getPatientList....$patientProfileList");
  }

  onChangeProgressValue(bool value){
    isShowProgress = value;
    update();
  }

  /*getServerModelData(){
    serverModelDataList = Preference.shared.getServerList(Preference.serverUrlAllListed) ?? [];
    if(serverModelDataList.isNotEmpty) {
      var data = serverModelDataList.where((element) => element.isSelected &&
          !element.isSecure).toList();
      if(data.isNotEmpty){
        selectedUrlModel = data[0];
      }
    }
    update();
  }*/

  showPatientSelectionDialog(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: Colors.white,
          child: LayoutBuilder(
            builder: (BuildContext context,BoxConstraints constraints) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: StatefulBuilder(
                  builder: (context, setStateFromMain) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Row(
                            children: [
                              Expanded(child: _widgetSearchIDText(context,constraints)),
                              Expanded(child: _widgetSearchNameText(context,constraints)),
                            ],
                          ),
                        ),
                        (patientProfileList.isEmpty && !isShowProgress)?
                        Container(
                          margin: EdgeInsets.symmetric(vertical:(kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.0,constraints) : Sizes.height_2),
                          alignment: Alignment.center,
                          child: Text(
                            "Not found",
                            style: AppFontStyle.styleW700(
                                CColor.black, AppFontStyle.sizesFontManageWeb(1.3,constraints)),
                          ),
                        )
                            :_widgetPatientIds(constraints)
                        ,
                      ],
                    );
                  },
                ),
              );
            }
          ),
        );
      },
    );
  }

  Widget _widgetSearchIDText(BuildContext context,BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // height: Sizes.height_6,
          margin: EdgeInsets.only(
              top: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.0, constraints) :Sizes.height_2,
              right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_1_5,
              left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.3, constraints) : Sizes.width_3),
          decoration: BoxDecoration(
            color: CColor.transparent,

            border: Border.all(
              color: CColor.primaryColor, width: 0.7,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: TextFormField(
            controller: searchIdControllers,
            // keyboardType: TextInputType.text,
            keyboardType: Utils.getInputTypeKeyboard(),
            textAlign: TextAlign.start,
            focusNode: searchIdFocus,
            // cursorHeight: Utils.sizesHeightManage(context, 6.0),
            textInputAction: TextInputAction.done,
            style: AppFontStyle.styleW500(
                CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2 ,constraints)
                : FontSize.size_10),
            cursorColor: CColor.black,
            decoration: const InputDecoration(
              hintText: "Search Id",
              filled: true,
              border: InputBorder.none,
            ),
            onChanged: (value) {
              getPatientList(true);
            },
          ),
        ),
      ],
    );
  }

  Widget _widgetSearchNameText(BuildContext context,BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
    top: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.0, constraints) :Sizes.height_2,
    left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.8, constraints) : Sizes.width_1_5,
    right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.3, constraints) : Sizes.width_3),
          decoration: BoxDecoration(
            color: CColor.transparent,

            border: Border.all(
              color: CColor.primaryColor, width: 0.7,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: TextFormField(
            controller: searchNameControllers,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.start,
            focusNode: searchNameFocus,
            // cursorHeight: Utils.sizesHeightManage(context, 6.0),
            textInputAction: TextInputAction.done,
            style: AppFontStyle.styleW500(
                CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2 ,constraints)
                : FontSize.size_10),
            cursorColor: CColor.black,
            decoration: const InputDecoration(
              hintText: "Search Name",
              filled: true,
              border: InputBorder.none,
            ),
            onChanged: (value) {
              getPatientList(true);
            },
          ),
        ),
      ],
    );
  }

  _widgetPatientIds(BoxConstraints constraints) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(
            top: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.9, constraints) :Sizes.height_1_2,
            left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.8, constraints) : Sizes.width_1_3,
            right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.8, constraints) : Sizes.width_1_2,
        ),
        padding: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.5, constraints) :Sizes.width_0_5, vertical: 7),
        decoration: const BoxDecoration(
            color: CColor.white
        ),
        child: (kIsWeb) ?
        patientProfileList.isNotEmpty ?
        ///web
        ListView.builder(
          itemBuilder: (context, index) {
            return _itemPatientUser(index, context,patientProfileList[index],constraints);
          },
          itemCount: patientProfileList.length,
          padding: const EdgeInsets.all(0),
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
        ) : Container(
          alignment: Alignment.center,
          child: (isShowProgress) ?
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(CColor.primaryColor),
          ) : Container(),
        ) :

        ///Mobile
        Stack(
          alignment: Alignment.topCenter,
          children: [
            ListView.builder(
              itemBuilder: (context, index) {
                return _itemPatientUser(index, context,patientProfileList[index],constraints);
              },
              itemCount: patientProfileList.length,
              padding: const EdgeInsets.all(0),
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
            ),
            Container(
              alignment: Alignment.center,
              child: (isShowProgress) ?
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(CColor.primaryColor),
              ) : Container(),
            ),
          ],
        ),
      ),
    );
  }

  _itemPatientUser(int index, BuildContext context, PatientDataModel patientProfileList,BoxConstraints constraints) {
    return InkWell(
      onTap: () {
        // FocusManager.instance.primaryFocus?.unfocus();
        // saveDetail(index);
        serverModelDataList = Utils.getServerList ?? [];
        if(serverModelDataList.isNotEmpty){
          // var data = Utils.getServerList.where((element) => element.isSelected && !element.isSecure
          // && element.url == addOtherUrlController.text.toString()).toList();
          if(Utils.getServerList.where((element) => element.isSelected && !element.isSecure
              && element.url == addOtherUrlController.text.toString()).toList().isNotEmpty) {
            // int serverIndex = serverModelDataList.indexWhere((
            //     element) => element == data[0]).toInt();
            // serverModelDataList[serverIndex].patientId =
            //     patientProfileList.patientId;
            Utils.getServerList.where((element) => element.isSelected && !element.isSecure
                && element.url == addOtherUrlController.text.toString()).toList()[0].patientId = patientProfileList.patientId;
            Utils.getServerList.where((element) => element.isSelected && !element.isSecure
                && element.url == addOtherUrlController.text.toString()).toList()[0].patientFName = patientProfileList.fName;
            Utils.getServerList.where((element) => element.isSelected && !element.isSecure
                && element.url == addOtherUrlController.text.toString()).toList()[0].patientLName = patientProfileList.lName;
            Utils.getServerList.where((element) => element.isSelected && !element.isSecure
                && element.url == addOtherUrlController.text.toString()).toList()[0].patientDOB = patientProfileList.dob;
            Utils.getServerList.where((element) => element.isSelected && !element.isSecure
                && element.url == addOtherUrlController.text.toString()).toList()[0].patientGender = patientProfileList.gender;
            // serverModelDataList[serverIndex] = data[0];
            var json = jsonEncode(
                Utils.getServerList.map((e) => e.toJson()).toList());
            Preference.shared.setList(Preference.serverUrlAllListed, json);
            // Utils.getAndSetPatientId();
            // Utils.getPerformerDataList(data[0]);
            Utils.getConfigurationActivityDataListApi();

            searchIdControllers.clear();
            searchNameControllers.clear();
            addOtherUrlClientIdController.clear();
            addOtherUrlController.clear();
            addServerTitleName.clear();
            Get.back();
            showDialogAfterSuccess();
            update();
          }
        }

      },
      child: Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CColor.white,
          border: Border.all(
              color: (selectedPatientId ==
                  patientProfileList.patientId)
                  ? CColor.primaryColor
                  : CColor.transparent),
          boxShadow: const [
            BoxShadow(
              color: CColor.txtGray50,
              // blurRadius: 1,
              spreadRadius: 0.5,
            )
          ],
        ),
        margin: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.2, constraints): Sizes.width_0_5,
            vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.9, constraints): Sizes.height_1),
        padding: EdgeInsets.symmetric(
          horizontal:(kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.7, constraints) : Sizes.height_1_2,
          vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.8, constraints) : Sizes.height_1,
        ),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding:  EdgeInsets.all((kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.7, constraints):10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CColor.primaryColor30,
              ),
              child: const Icon(Icons.person, color: CColor.primaryColor,),
            ),
            Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : Sizes.width_3),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      patientProfileList.fName.isNotEmpty ?
                      RichText(
                        text: TextSpan(
                          // text: "Name:- ",
                          style: AppFontStyle.styleW700(
                              CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : 13.sp),
                          children: [

                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: patientProfileList.fName
                                  .toString(),
                              style: AppFontStyle.styleW700(
                                  CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints) : 12.sp
                              ),
                            ),
                            if(patientProfileList.lName != "" && patientProfileList.lName != null && patientProfileList.lName != "null")
                            TextSpan(
                              text: patientProfileList.lName
                                  .toString(),
                              style: AppFontStyle.styleW700(
                                  CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints) : 12.sp
                              ),
                            ),
                          ],
                        ),
                      ) : Container(),
                      (patientProfileList.dob.isNotEmpty && patientProfileList.dob != "null") ?
                      RichText(
                        text: TextSpan(
                          // text: "DOB:- ",
                          style: AppFontStyle.styleW700(
                              CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : 13.sp),
                          children: [
                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: Utils.checkDate(patientProfileList.dob.toString()),
                              // text: DateFormat(Constant.commonDateFormatMmmDdYyyy).format(DateTime.parse(logic.patientProfileList[index].dob.toString())) ?? "",
                              style: AppFontStyle.styleW600(
                                  CColor.gray, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints) : 12.sp
                              ),
                            ),
                          ],
                        ),
                      ) : Container(),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  showDialogForAddNewServerUrl(BuildContext context,
      setStateDialogForChooseCode,bool isEdit,{int index = -1}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: CColor.white,
              contentPadding: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
              content: Wrap(
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(Sizes.width_5),
                      width: Get.width * 0.8,
                      child: Column(
                        children: [
                          if(addServerTitleName.text.isNotEmpty)
                            Container(
                              margin: EdgeInsets.only(bottom: Sizes.height_2),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        right: Sizes.width_2, left: Sizes.width_2,bottom: Sizes.height_1),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                      children: [
                                        Text(
                                          "Connection Name",
                                          style: AppFontStyle.styleW700(CColor.black,
                                              (kIsWeb) ? FontSize.size_3 : FontSize.size_10),
                                        ),
                                        PopupMenuButton(
                                          elevation: 0,
                                          constraints: BoxConstraints(
                                              minWidth: Get.width * 0.1, maxWidth: Get.width * 0.8),
                                          color: Colors.transparent,
                                          padding: const EdgeInsets.all(0),
                                          position: PopupMenuPosition.under,
                                          itemBuilder: (context) {
                                            return [
                                              PopupMenuItem(
                                                child: Container(
                                                    padding: const EdgeInsets.all(6),
                                                    decoration: BoxDecoration(
                                                        color: CColor.white,
                                                        border: Border.all(width: 1),
                                                        borderRadius: BorderRadius.circular(10)),
                                                    child: const Text(
                                                        Constant.connectionNameToolTip)),
                                              ),
                                            ];
                                          },
                                          child: Icon(Icons.info_outline,
                                              color: CColor.black, size: Sizes.height_2_5),
                                        ),

                                      ],
                                    ),
                                  ),
                                  Container(
                                    // margin: EdgeInsets.only(top: Sizes.height_1),
                                    color: CColor.transparent,
                                    child: TextFormField(
                                      controller: addServerTitleName,
                                      focusNode: addServerTitleNameFocus,
                                      textAlign: TextAlign.start,
                                      keyboardType: TextInputType.text,
                                      style: AppFontStyle.styleW500(
                                          CColor.black, FontSize.size_10),
                                      maxLines: 1,
                                      cursorColor: CColor.black,
                                      decoration: InputDecoration(
                                        filled: true,
                                        // contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: Sizes.width_5),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: CColor.primaryColor, width: 0.7),
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: CColor.primaryColor, width: 0.7),
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: CColor.primaryColor, width: 0.7),
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: CColor.primaryColor, width: 0.7),
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Container(
                            margin: EdgeInsets.only(
                                right: Sizes.width_2, left: Sizes.width_2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                Text(
                                  "Connection URL",
                                  style: AppFontStyle.styleW700(CColor.black,
                                      (kIsWeb) ? FontSize.size_3 : FontSize.size_10),
                                ),
                                PopupMenuButton(
                                  elevation: 0,
                                  constraints: BoxConstraints(
                                      minWidth: Get.width * 0.1, maxWidth: Get.width * 0.8),
                                  color: Colors.transparent,
                                  padding: const EdgeInsets.all(0),
                                  position: PopupMenuPosition.under,
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem(
                                        child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                                color: CColor.white,
                                                border: Border.all(width: 1),
                                                borderRadius: BorderRadius.circular(10)),
                                            child: const Text(
                                                Constant.connectionURLToolTip)),
                                      ),
                                    ];
                                  },
                                  child: Icon(Icons.info_outline,
                                      color: CColor.black, size: Sizes.height_2_5),
                                ),

                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: Sizes.height_1),
                            color: CColor.transparent,
                            child: TextFormField(
                              controller: addOtherUrlController,
                              focusNode: addOtherUrlFocus,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              style: AppFontStyle.styleW500(
                                  CColor.black, FontSize.size_10),
                              maxLines: 1,
                              cursorColor: CColor.black,
                              decoration: InputDecoration(
                                filled: true,
                                // contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: Sizes.width_5),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: CColor.primaryColor, width: 0.7),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: CColor.primaryColor, width: 0.7),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: CColor.primaryColor, width: 0.7),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: CColor.primaryColor, width: 0.7),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                            ),
                          ),
                          if(isAuth)
                            Container(
                              margin: EdgeInsets.only(top: Sizes.height_2),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        right: Sizes.width_2, left: Sizes.width_2),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Client Id",
                                          style: AppFontStyle.styleW700(CColor.black,
                                              (kIsWeb) ? FontSize.size_3 : FontSize.size_10),
                                        ),
                                        PopupMenuButton(
                                          elevation: 0,
                                          constraints: BoxConstraints(
                                              minWidth: Get.width * 0.1, maxWidth: Get.width * 0.8),
                                          color: Colors.transparent,
                                          padding: const EdgeInsets.all(0),
                                          position: PopupMenuPosition.under,
                                          itemBuilder: (context) {
                                            return [
                                              PopupMenuItem(
                                                child: Container(
                                                    padding: const EdgeInsets.all(6),
                                                    decoration: BoxDecoration(
                                                        color: CColor.white,
                                                        border: Border.all(width: 1),
                                                        borderRadius: BorderRadius.circular(10)),
                                                    child: const Text(
                                                        Constant.clientIdToolTip)),
                                              ),
                                            ];
                                          },
                                          child: Icon(Icons.info_outline,
                                              color: CColor.black, size: Sizes.height_2_5),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: Sizes.height_1),
                                    color: CColor.transparent,
                                    child: TextFormField(
                                      controller: addOtherUrlClientIdController,
                                      focusNode: addOtherUrlClientIdFocus,
                                      textAlign: TextAlign.start,
                                      keyboardType: TextInputType.text,
                                      style: AppFontStyle.styleW500(
                                          CColor.black, FontSize.size_10),
                                      maxLines: 1,
                                      cursorColor: CColor.black,
                                      decoration: InputDecoration(
                                        filled: true,
                                        // contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: Sizes.width_5),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: CColor.primaryColor, width: 0.7),
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: CColor.primaryColor, width: 0.7),
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: CColor.primaryColor, width: 0.7),
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: CColor.primaryColor, width: 0.7),
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Container(
                            margin: EdgeInsets.only(top: Sizes.height_2),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      isShowDialogOpen = true;
                                      Get.back();
                                      clearControllersAndValues();
                                      onChangeEditAdd(true);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(
                                          CColor.transparent),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                          side: const BorderSide(
                                              color: CColor.primaryColor,
                                              width: 0.7),
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                        "Cancel",
                                        textAlign: TextAlign.center,
                                        style: AppFontStyle.styleW400(
                                            CColor.black, FontSize.size_12),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: Sizes.width_2),
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      var serverInputtedUrl = addOtherUrlController.text.toString();
                                      var serverClientId = addOtherUrlClientIdController.text.toString();
                                      if(serverInputtedUrl.isNotEmpty && serverClientId.isEmpty && isValidURL(serverInputtedUrl)) {
                                        Utils.checkWhetherSecureOrNot(
                                            serverInputtedUrl,context).then((value) async {
                                          Debug.printLog("Map data from metadata....$value");
                                          if(value.isNotEmpty){
                                            if(value[Constant.msg] == Constant.failedConnected){
                                              Get.back();
                                              Get.back();
                                              Utils.showErrorDialog(context, Constant.txtError,value[Constant.msg] );
                                              return;
                                            }
                                            if(value[Constant.metaDataServerName] != null){
                                              changeServerName(value[Constant.metaDataServerName],false);
                                            }

                                            if(value[Constant.metaDataServerSecure]){
                                              Get.back();
                                              addOtherUrlClientIdController.text = selectedUrlClientId;
                                              changeIsAuth(true);
                                            }else{
                                              ///This is for when It will come without Secure server from the
                                              ///Meta data API then we will close this Dialog and Show Connection success
                                              ///Dialog
                                              // Get.back();
                                              addNewServerUrlDataIntoList(
                                                  true,
                                                  index: index,setStateDialogForChooseCode,isEditServer:
                                              isEdit,isNotClose: false).then((value) => {
                                                Debug.printLog("Close Dialog"),
                                              });
                                              onChangeEditAdd(isEdit);
                                              try{

                                              }catch(e){
                                                setStateDialogForChooseCode(() {});
                                              }
                                            }

                                            if(!value[Constant.metaDataServerSecure]) {
                                              if (context.mounted) {
                                                try {
                                                  await getPatientList(
                                                      false);
                                                } catch (e) {
                                                  Debug.printLog(
                                                      'Error fetching patient list: $e');
                                                }
                                              }
                                            }
                                          }else{
                                            Utils.showToast(Get.context!, value[Constant.msg].toString());
                                          }
                                          setState((){});
                                        });
                                      }
                                      else if(serverInputtedUrl.isNotEmpty && serverClientId.isNotEmpty){
                                        if(isAuth && serverClientId.isEmpty){
                                          Utils.showToast(Get.context!, "Please enter valid client id");
                                          return;
                                        }
                                        if(isEdit) {
                                          addNewServerUrlDataIntoList(
                                              Utils.getServerList[index].isSelected,
                                              index: index,setStateDialogForChooseCode,isEditServer: true);
                                        }else{
                                          addNewServerUrlDataIntoList(
                                              true,
                                              index: index,setStateDialogForChooseCode).then((value) => {
                                            Debug.printLog("Close Dialog"),
                                          });
                                        }
                                        onChangeEditAdd(isEdit);
                                        addOtherUrlClientIdController.clear();
                                        selectedUrlClientId = "";
                                        // setStateDialogForChooseCode(() {});
                                      }
                                      else{
                                        Utils.showToast(Get.context!, "Please enter valid connection URL");
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(
                                          CColor.primaryColor),
                                      elevation: MaterialStateProperty.all(1),
                                      shadowColor:
                                      MaterialStateProperty.all(CColor.gray),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                          side: const BorderSide(
                                              color: CColor.primaryColor,
                                              width: 0.7),
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                        /*(logic.isAuth)?"Connect"
                                            "":(!logic.isEdit)?"Add":"Update",*/
                                        "Connect",
                                        textAlign: TextAlign.center,
                                        style: AppFontStyle.styleW400(
                                            CColor.white, FontSize.size_12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((value) => (value) {
      onChangeEditAdd(false);
    });
  }

  clearControllersAndValues(){
    addOtherUrlClientIdController.clear();
    addOtherUrlController.clear();
    addServerTitleName.clear();
    selectedUrlClientId = "";
    isAuth = false;
    selectedUrlClientId = "";
  }

  bool isValidURL(String url) {
    final Uri uri;
    try {
      uri = Uri.parse(url);
    } catch (_) {
      return false;
    }
    return (uri.isScheme('http') || uri.isScheme('https')) && uri.host.isNotEmpty;
  }


  Future<void> checkCameraPermissionAndOpenCamera() async {
    // PermissionStatus status = await Permission.camera.status;
    PermissionStatus status = await Permission.camera.request();
    if (status.isGranted) {
      Get.toNamed(AppRoutes.cameraScreen);
      Debug.printLog("_checkCameraPermission....$status");
    } else if (status.isDenied) {
      PermissionStatus newStatus = await Permission.camera.request();
      if (newStatus.isGranted) {
        Debug.printLog("_checkCameraPermission else if....$status");
      } else if (newStatus.isPermanentlyDenied) {
        _showPermissionDialog();
        Debug.printLog("_checkCameraPermission isPermanentlyDenied else if....$newStatus");
      }
    } else if (status.isPermanentlyDenied) {
      _showPermissionDialog();
      Debug.printLog("_checkCameraPermission isPermanentlyDenied else if else if....$status");
    }
  }


  void _showPermissionDialog() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Camera Permission Required"),
          content: const Text(
              "This app requires camera access to function properly. Please enable camera access in the app settings."),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: const Text("Open Settings"),
              onPressed: () {
                openAppSettings();
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }
}
