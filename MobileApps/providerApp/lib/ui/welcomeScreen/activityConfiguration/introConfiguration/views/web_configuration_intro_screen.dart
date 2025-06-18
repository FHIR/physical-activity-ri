import 'package:banny_table/ui/welcomeScreen/activityConfiguration/configuration/controllers/configuration_controller.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/introConfiguration/controllers/configuration_intro_controller.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/intro/controllers/health_provider_intro_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WebConfigurationIntroScreen extends StatelessWidget {
  ConfigurationMainController? configurationMainController;

  WebConfigurationIntroScreen({ this.configurationMainController, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return  Scaffold(
          backgroundColor: CColor.white,
          body: SafeArea(
            child: GetBuilder<ConfigurationIntroController>(builder: (logic) {
              return Column(
                children: [
                  Expanded(child: _widgetConfigurationIntro(context,logic)),
                  _widgetButtonYes(logic,context),
                  _widgetButtonSkip(logic,context),
                ],
              );
            }),
          ),
        );
      },
    );
  }


  _widgetConfigurationIntro(
      BuildContext context, ConfigurationIntroController logic) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _widgetImage(),
        _widgetMoreDetails(),
      ],
    );
  }

  _widgetMoreDetails() {
    return Container(
      margin: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        // top: 20.h
      ),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 7.h,
            ),
            // alignment: Alignment.centerLeft,
            child: Text(
              Constant.configurationIntro,
              textAlign: TextAlign.center,
              style: AppFontStyle.styleW500(CColor.black, 6.sp),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 12.h,
            ),
            // alignment: Alignment.centerLeft,
            child: Text(
              Constant.configurationIntroShort,
              textAlign: TextAlign.center,
              style: AppFontStyle.styleW700(CColor.gray, 6.sp),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 12.h,
            ),
            // alignment: Alignment.centerLeft,
            child: Text(
              Constant.configurationIntroShortSecond,
              textAlign: TextAlign.center,
              style: AppFontStyle.styleW700(CColor.gray, 6.sp),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 12.h,
            ),
            // alignment: Alignment.centerLeft,
            child: Text(
              Constant.configurationIntroInfo,
              textAlign: TextAlign.center,
              style: AppFontStyle.styleW500(CColor.black, 6.sp),
            ),
          )
        ],
      ),
    );
  }

  _widgetButtonYes(ConfigurationIntroController logic,BuildContext context){
    return Container(
      padding: EdgeInsets.only(
        top: 5.h, bottom: 5.h,),
      child: Row(
        children: [
          Expanded(child: Container()),
          InkWell(
            onTap: () {
              configurationMainController!.pageConfigurationController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
              // logic.gotoNextScreen();
            },
            child: Container(
              padding:  EdgeInsets.symmetric(
                  vertical: 8.h,
                  horizontal: 10.w
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: CColor.primaryColor,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                      color: CColor.white
                  )
              ),
              child: Text(
                "Yes",
                style: AppFontStyle.styleW700(
                    CColor.white,
                    Utils.sizesFontManage(context ,3.5)),
                // (kIsWeb) ?FontSize.size_8 : FontSize.size_14),
              ),
            ),
          ),
          // (kIsWeb) ? Expanded(child: Container()) : Container(),
          Expanded(child: Container())
        ],
      ),
    );
  }

  _widgetButtonSkip(ConfigurationIntroController logic,BuildContext context){
    return Container(
      margin: EdgeInsets.only(
          bottom: 4.h
      ),
      child: Row(
        children: [
          Expanded(child: Container()),
          InkWell(
            onTap: () {
              logic.gotoNextPageGoalView();
              // Get.toNamed(page)
              // logic.gotoBottomNavigationScreen();
            },
            child: Text(
              "Skip",
              style: TextStyle(
                  color: CColor.primaryColor,
                  fontSize: Utils.sizesFontManage(context ,3.0)),
              // fontSize:(kIsWeb) ?FontSize.size_6: FontSize.size_10),
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }

  _widgetImage() {
    return Container(
      // color: Colors.cyanAccent,
      margin: EdgeInsets.only(top: 30.h),
      child: Image.asset("assets/images/configuration.png",
        height: 150.h,
        // width: 150.w,
      ),
    );
  }


}
