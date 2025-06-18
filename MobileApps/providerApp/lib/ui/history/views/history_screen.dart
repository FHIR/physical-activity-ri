import 'package:banny_table/ui/history/views/web_history_screen.dart';
import 'package:banny_table/utils/color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/history_controller.dart';
import 'mobile_history_screen.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({Key? key}) : super(key: key);

  // HistoryController historyController = Get.find<HistoryController>();


  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          useMaterial3: false
      ),
      child: GetBuilder<HistoryController>(builder: (logic) {
        return Scaffold(
          backgroundColor: CColor.white,
          body: GetBuilder<HistoryController>(builder: (logic) {
            return SafeArea(
                child: (kIsWeb) ?
                WebHistoryScreen(logic) :
                MobileHistoryScreen()
                    // :
                // MobileHistoryScreen(historyController: historyController,)
                // MobileHistoryScreen()
            );
          }),
        );
      }),
    );
  }
}
