import 'package:banny_table/ui/welcomeScreen/healthProvider/qrScanner/controllers/qr_scanner_controller.dart';
import 'package:get/get.dart';


class QrScannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QrScannerController>(
          () => QrScannerController(),
    );
  }
}
