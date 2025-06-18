
import 'package:banny_table/ui/welcomeScreen/welcome/controllers/welcome_controller.dart';
import 'package:banny_table/ui/welcomeScreen/welcome/views/web_welcome_screen.dart';
import 'package:banny_table/utils/color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'mobile_welcome_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColor.white,
      body: SafeArea(
        child: GetBuilder<WelcomeController>(builder: (logic) {
          return (kIsWeb)?WebWelcomeScreen():MobileWelcomeScreen();
        }),
      ),
    );
  }
}
