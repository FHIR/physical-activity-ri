import 'package:banny_table/ui/welcomeScreen/healthProvider/qrScanner/controllers/qr_scanner_controller.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CameraControllers extends GetxController {

  MobileScannerController? cameraController;

  @override
  void dispose() {
    Constant.cameraURL = "";
    cameraController!.dispose();
    super.dispose();
  }



  getUrlDetalis(values) {
    Constant.cameraURL = values;
    update();
    QrScannerController qrScannerController = Get.find();
    // Get.back();
    qrScannerController.onQRViewCreated(values,isBack: true);
    // Get.back();
  }

}