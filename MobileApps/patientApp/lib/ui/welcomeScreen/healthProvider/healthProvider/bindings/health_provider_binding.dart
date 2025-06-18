import 'package:banny_table/ui/welcomeScreen/healthProvider/intro/controllers/health_provider_intro_controller.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/selectPrimaryServer/controllers/select_primary_controller.dart';
import 'package:get/get.dart';

import '../../patientList/controllers/patient_list_controller.dart';
import '../../qrScanner/controllers/qr_scanner_controller.dart';
import '../controllers/health_provider_controller.dart';


class HealthProviderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HealthProviderController>(
          () => HealthProviderController(),
        fenix: true
    );

    Get.lazyPut<HealthProviderIntroController>(
          () => HealthProviderIntroController(),
      fenix: true
    );

    Get.lazyPut<QrScannerController>(
          () => QrScannerController(),
        fenix: true
    );
    Get.lazyPut<SelectPrimaryController>(
            () => SelectPrimaryController(),
        fenix: true
    );
    Get.lazyPut<PatientListController>(
          () => PatientListController(),
        fenix: true
    );
  }
}
