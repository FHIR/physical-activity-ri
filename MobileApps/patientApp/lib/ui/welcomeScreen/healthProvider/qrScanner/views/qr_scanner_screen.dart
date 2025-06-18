import 'package:banny_table/ui/welcomeScreen/healthProvider/healthProvider/controllers/health_provider_controller.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/qrScanner/controllers/qr_scanner_controller.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/qrScanner/views/mobile_qr_scanner_screen.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/qrScanner/views/web_qr_scanner_screen.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class QrScannerScreen extends StatelessWidget {
  HealthProviderController? healthProviderController;

   QrScannerScreen({this.healthProviderController ,Key? key}) : super(key: key);
  QrScannerController qrScannerController = Get.find<QrScannerController>();

  @override
  Widget build(BuildContext context) {
    qrScannerController.healthProviderController = healthProviderController;
    return Scaffold(
      backgroundColor: CColor.primaryColor,
      appBar: AppBar(
        backgroundColor: CColor.primaryColor,
        title: Text("Connect to Your Health Provider",
          style: TextStyle(
          color: CColor.white,
          // fontSize: 20,
          fontFamily: Constant.fontFamilyPoppins,
        ),),
        leading: IconButton(
          onPressed: () {
            if(qrScannerController.isFromSetting){
              /*if(Utils.getServerList.isEmpty){
                Utils.showToast(Get.context!, "Please add connection");
              }else {
                qrScannerController.checkServerAuth();
              }*/
              qrScannerController.checkServerAuth();
            }else{
              if(healthProviderController != null){
                healthProviderController!.pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn);
              }else{
                qrScannerController.checkServerAuth();
              }
            }
            Debug.printLog("------back");
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: GetBuilder<QrScannerController>(builder: (logic) {
        return (kIsWeb) ? WebQrScannerScreen(healthProviderController: healthProviderController,): MobileQrScannerScreen(healthProviderController: healthProviderController,);
      }),
    );
  }
}
