import 'package:banny_table/ui/welcomeScreen/healthProvider/healthProvider/controllers/health_provider_controller.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/intro/controllers/health_provider_intro_controller.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/intro/views/mobile_health_provider_intro_screen.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/intro/views/web_health_provider_intro_screen.dart';
import 'package:banny_table/utils/color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HealthProviderIntroScreen extends StatelessWidget {

   HealthProviderController? healthProviderController;
   HealthProviderIntroScreen({this.healthProviderController, Key? key } ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColor.white,
      body: SafeArea(
        child: GetBuilder<HealthProviderIntroController>(builder: (logic) {
          return (kIsWeb) ?  WebHealthProviderIntroScreen(healthProviderController: healthProviderController!):  MobileHealthProviderIntroScreen(healthProviderController: healthProviderController,);
        }),
      ),
    );
  }
}
