import 'package:banny_table/ui/welcomeScreen/healthProvider/qrScanner/controllers/qr_scanner_controller.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CameraControllers extends GetxController {

  MobileScannerController? cameraController;

  @override
  void dispose() {
    cameraController!.dispose();
    super.dispose();
  }



  getUrlDetalis(values) {
    update();
    QrScannerController qrScannerController = Get.find();
    qrScannerController.onQRViewCreated(values,isBack: true);
  }

}