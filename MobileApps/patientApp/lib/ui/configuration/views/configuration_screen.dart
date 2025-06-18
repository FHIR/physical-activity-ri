import 'package:banny_table/ui/configuration/controllers/configuration_controllers.dart';
import 'package:banny_table/ui/configuration/views/mobile_configuratio_screen.dart';
import 'package:banny_table/ui/configuration/views/web_configuratio_screen.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConfigurationController>(builder: (logic) {
      return Scaffold(
          backgroundColor: CColor.white,
          appBar: (logic.isSkipTab)
              ? null
              : AppBar(
                  backgroundColor: CColor.primaryColor,
                  title: const Text(Constant.headerConfigurationScreen, style: TextStyle(
                      color: CColor.white,
                      // fontSize: 20,
                      fontFamily: Constant.fontFamilyPoppins,
                    ),
                  ),
                ),
          body: SafeArea(
            child: GetBuilder<ConfigurationController>(
                assignId: true,
                init: ConfigurationController(),
                builder: (logic) {
                  return (kIsWeb)
                      ? const WebConfigurationScreen()
                      : const MobileConfigurationScreen();
                }),
          ));
    });
  }
}
