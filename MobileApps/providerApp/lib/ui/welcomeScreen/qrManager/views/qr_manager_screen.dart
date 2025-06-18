import 'package:banny_table/ui/welcomeScreen/qrManager/controllers/qr_manager_controller.dart';
import 'package:banny_table/ui/welcomeScreen/qrManager/views/mobile_qr_manager_screen.dart';
import 'package:banny_table/ui/welcomeScreen/qrManager/views/web_qr_manager_screen.dart';
import 'package:banny_table/utils/color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class QrManagerScreen extends StatelessWidget {
  const QrManagerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          useMaterial3: false
      ),
      child: Scaffold(
        backgroundColor: CColor.white,
        body: SafeArea(
          child: GetBuilder<QrManagerController>(builder: (logic) {
            return (kIsWeb) ? const WebQrManagerScreen(): const MobileQrManagerScreen();
          }),
        ),
      ),
    );
  }
}
