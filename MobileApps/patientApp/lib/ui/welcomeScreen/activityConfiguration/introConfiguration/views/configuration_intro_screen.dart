import 'package:banny_table/ui/welcomeScreen/activityConfiguration/configuration/controllers/configuration_controller.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/introConfiguration/controllers/configuration_intro_controller.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/introConfiguration/views/mobile_configuration_intro_screen.dart';
import 'package:banny_table/utils/color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'web_configuration_intro_screen.dart';


class ConfigurationIntroScreen extends StatelessWidget {
  ConfigurationMainController? configurationMainController;

  ConfigurationIntroScreen({this.configurationMainController, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // minTextAdapt: true,
      // splitScreenMode: true,
      builder: (context, child) {
        return  Scaffold(
          backgroundColor: CColor.white,
          body: SafeArea(
            child: GetBuilder<ConfigurationIntroController>(builder: (logic) {
              return (kIsWeb) ?  WebConfigurationIntroScreen(configurationMainController: configurationMainController!,):  MobileConfigurationIntroScreen(configurationMainController: configurationMainController!,);
            }),
          ),
        );
      },
    );
  }
}

