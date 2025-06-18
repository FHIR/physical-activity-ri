import 'package:banny_table/ui/welcomeScreen/activityConfiguration/activitySelection/views/activity_selection_screen.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/introConfiguration/views/configuration_intro_screen.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/trackingPref/views/tracking_pref_screen.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/configuration_controller.dart';


class ConfigurationMainScreen extends StatelessWidget {
  const ConfigurationMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    return GetBuilder<ConfigurationMainController>(builder: (logic) {
      return ScreenUtilInit(
        // minTextAdapt: true,
        // splitScreenMode: true,
        builder: (context, child) {
          return  LayoutBuilder(
            builder: (BuildContext context,BoxConstraints constraints) {
              return Scaffold(
                backgroundColor: CColor.white,
         /*   appBar: (logic.selectedIndex == 0)?null:AppBar(
                  title: Text( (logic.selectedIndex == 1) ?"Activity Selection": "Tracking Preference"),
                  backgroundColor: CColor.primaryColor,
                ),*/
                body: _widgetPageView(logic,constraints,orientation),
              );
            }
          );
        },
      );
    });
  }



  _widgetPageView(ConfigurationMainController logic,BoxConstraints constraints,Orientation orientation) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: logic.pageConfigurationController,
            onPageChanged: (value) {
              logic.onChangeIndex(value);
              Debug.printLog("_widgetPageView...$value");
            },
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ConfigurationIntroScreen(configurationMainController: logic),
              TrackingPrefScreen(configurationMainController: logic),
              ActivitySelectionScreen(configurationMainController: logic),
            ],
          ),
        ),

        Container(
          margin: EdgeInsets.only(
              bottom: (kIsWeb)
                  ? AppFontStyle.sizesHeightManageWeb(2.0, constraints)
                  :(orientation == Orientation.portrait)? 10.h :AppFontStyle.sizesHeightManageWeb(1.0, constraints),
              top: (kIsWeb)
                  ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                  :(orientation == Orientation.portrait)?  20.h :AppFontStyle.sizesHeightManageWeb(0.8, constraints)),          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(
                3,
                    (index) =>
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        width: (kIsWeb)
                            ? AppFontStyle.sizesWidthManageWeb(1.2, constraints)
                            : (orientation == Orientation.portrait)? 10.w :AppFontStyle.sizesWidthManageWeb(1.2, constraints),
                        height: (kIsWeb)
                            ? AppFontStyle.sizesWidthManageWeb(1.2, constraints)
                            : (orientation == Orientation.portrait)? 10.w :AppFontStyle.sizesWidthManageWeb(1.2, constraints),
                        child: InkWell(
                          onTap: () {
                            // logic.pageConfigurationController.animateToPage(index,
                            //     duration: const Duration(milliseconds: 300),
                            //     curve: Curves.easeIn);
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
