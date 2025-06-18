import 'package:banny_table/ui/welcomeScreen/activityConfiguration/activitySelection/views/activity_selection_screen.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/introConfiguration/views/configuration_intro_screen.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/trackingPref/views/tracking_pref_screen.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/configuration_controller.dart';


class ConfigurationMainScreen extends StatelessWidget {
  const ConfigurationMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          useMaterial3: false
      ),

      child: GetBuilder<ConfigurationMainController>(builder: (logic) {
        return ScreenUtilInit(
          // minTextAdapt: true,
          // splitScreenMode: true,
          builder: (context, child) {
            return  Scaffold(
              backgroundColor: CColor.white,
           /*   appBar: (logic.selectedIndex == 0)?null:AppBar(
                title: Text( (logic.selectedIndex == 1) ?"Activity Selection": "Tracking Preference"),
                backgroundColor: CColor.primaryColor,
              ),*/
              body: _widgetPageView(logic),
            );
          },
        );
      }),
    );
  }



  _widgetPageView(ConfigurationMainController logic) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: logic.pageConfigurationController,
            onPageChanged: (value) {
              logic.onChangeIndex(value);
              Debug.printLog("_widgetPageView...$value");
            },
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              ConfigurationIntroScreen(configurationMainController: logic),
              ActivitySelectionScreen(configurationMainController: logic),
              TrackingPrefScreen(configurationMainController: logic),
            ],
          ),
        ),

        Container(
          margin: EdgeInsets.only(bottom: 30.h, top: 20.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(
                3,
                    (index) =>
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        width: (kIsWeb) ? 5.w :10.w,
                        height:(kIsWeb) ? 5.w :10.w,
                        child: InkWell(
                          onTap: () {
                            logic.pageConfigurationController.animateToPage(index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn);
                          },
                          child: CircleAvatar(
                            radius: 8,
                            backgroundColor: logic.selectedIndex == index
                                ? CColor.primaryColor
                                : CColor.primaryColor50,
                          ),
                        ),
                      ),
                    )),
          ),
        ),
      ],
    );
  }
}
