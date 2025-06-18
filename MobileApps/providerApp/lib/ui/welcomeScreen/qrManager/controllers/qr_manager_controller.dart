import 'package:banny_table/resources/providerRequest.dart';
import 'package:banny_table/routes/app_routes.dart';
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
import 'package:mobile_scanner/mobile_scanner.dart';


class QrManagerController extends GetxController {
  // QRViewController? qrCodeController;
  // final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  // String qrCodeDetails = "";
  FocusNode qrdDetails = FocusNode();
  TextEditingController qrCodeDetailsController =
      TextEditingController();
      // TextEditingController(text: Api.hapiUrl);
  MobileScannerController? cameraController;

  var argument = Get.arguments;
  bool isShowDialog = false;
  bool isFromSetting = false;

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
    qrCodeDetailsController.text = Preference.shared.getString(Preference.qrUrlData) ?? "";
    update();
  }

  gotoSkipTab() {
    Get.toNamed(AppRoutes.patientUserListScreen, arguments: [true]);
  }

  Future<void> callServiceProvider() async {
    if (qrCodeDetailsController.text.isNotEmpty) {
      try {
        var linkAndClientId = qrCodeDetailsController.text;
        var url = qrCodeDetailsController.text;
        var clientId = "";
        if (linkAndClientId.contains("?")) {
          url = linkAndClientId.split("?")[0];
          if (linkAndClientId.split("?").length > 1) {
            clientId = linkAndClientId.split("?")[1].split("=")[1];
            ProviderRequest.setClientId(clientId);
          }
        }
        Debug.printLog("URL......$url");
        Preference.shared.setString(Preference.qrUrlData, url);
        ProviderRequest.setClient(url);

        if (clientId != "") {
          var client = ProviderRequest.getSecureClient();
          _showDialogForProgress(Get.context!);
          isShowDialog = true;
          // await client?.login();
        } else {
          var client = ProviderRequest.getClient();
          _showDialogForProgress(Get.context!);
          isShowDialog = true;
        }
        // cameraController!.stop();
        // await Utils.getPatientList((value){});
        // Utils.getPerformerDataList();
        // Utils.getTaskDataList();
        Constant.settingQRScan =
            Preference.shared.getString(Preference.qrUrlData) ??
                "QR connect provider";
        Utils.showToast(Get.context!, "Connection Successful!");
        if (isFromSetting) {
          // Get.back();
          // Get.back();
          Get.offAllNamed(AppRoutes.bottomNavigation);
        } else {
          // Preference.shared.setBool(Preference.qrManage,true);
          gotoSkipTab();
          // Get.toNamed(AppRoutes.integrationScreen);
        }

      } catch (e) {
        Debug.printLog(e.toString());
        Utils.showToast(Get.context!, e.toString());
        if (isShowDialog) {
          Get.back();
        }
      }
    }
  }

  _showDialogForProgress(BuildContext context) {
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

  void onQRViewCreated(value) {
    qrCodeDetailsController.text = value;
    Debug.printLog('Scanned data:................. $value');
    update();
  }

  @override
  void dispose() {
    qrCodeDetailsController.clear();
    cameraController!.dispose();
    super.dispose();
  }
}
