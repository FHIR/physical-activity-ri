import 'package:banny_table/ui/welcomeScreen/integration/controllers/integration_controller.dart';
import 'package:banny_table/ui/welcomeScreen/integration/views/mobile_integration_screen.dart';
import 'package:banny_table/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class IntegrationScreen extends StatelessWidget {
  const IntegrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColor.white,
      body: SafeArea(
        child: GetBuilder<IntegrationController>(builder: (logic) {
          return  const MobileIntegrationScreen();

        }),
      ),
    );
  }







}
