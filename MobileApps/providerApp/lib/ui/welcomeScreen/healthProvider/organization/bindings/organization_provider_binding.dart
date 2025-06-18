import 'package:get/get.dart';
import '../controllers/organization_provider_controller.dart';

class OrganizationProviderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrganizationProviderController>(
          () => OrganizationProviderController(),
        fenix: true
    );
  }
}
