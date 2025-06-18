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
          body: LayoutBuilder(
            builder: (BuildContext context,BoxConstraints constraints) {
              return SafeArea(
                child: GetBuilder<ConfigurationIntroController>(builder: (logic) {
                  return Column(
                    children: [
                      Expanded(child: _widgetConfigurationIntro(context,logic,constraints)),
                      _widgetButtonYes(logic,context,constraints),
                      _widgetButtonSkip(logic,context,constraints),
                    ],
                  );
                }),
              );
            }
          ),
        );
      },
    );
  }


  _widgetConfigurationIntro(
      BuildContext context, ConfigurationIntroController logic,BoxConstraints constraints) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _widgetImage(constraints),
          _widgetMoreDetails(constraints),
        ],
      ),
    );
  }

  _widgetMoreDetails(BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(
        left: AppFontStyle.sizesWidthManageWeb(2.5, constraints),
        right: AppFontStyle.sizesWidthManageWeb(2.5, constraints),
      ),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: AppFontStyle.sizesHeightManageWeb(3.2, constraints),
            ),
            // alignment: Alignment.centerLeft,
            child: Text(
              Constant.configurationIntro,
              textAlign: TextAlign.center,
               style: AppFontStyle.styleW500(CColor.black, AppFontStyle.sizesFontManageWeb(1.4, constraints))),
          ),
          /*Container(
            margin: EdgeInsets.only(
              top: AppFontStyle.sizesHeightManageWeb(2.0, constraints),
            ),
            // alignment: Alignment.centerLeft,
            child: Text(
              Constant.configurationIntroShort,
              textAlign: TextAlign.center,
              style: AppFontStyle.styleW500(CColor.gray, AppFontStyle.sizesFontManageWeb(1.4, constraints)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: AppFontStyle.sizesHeightManageWeb(2.0, constraints),
            ),
            // alignment: Alignment.centerLeft,
            child: Text(
              Constant.configurationIntroShortSecond,
              textAlign: TextAlign.center,
              style: AppFontStyle.styleW500(CColor.gray, AppFontStyle.sizesFontManageWeb(1.4, constraints)),
            ),
          ),*/
          Container(
            margin: EdgeInsets.only(
              top: AppFontStyle.sizesHeightManageWeb(2.0, constraints),
            ),
            // alignment: Alignment.centerLeft,
            child: Text(
              Constant.configurationIntroInfo,
              textAlign: TextAlign.center,
              style: AppFontStyle.styleW500(CColor.black, AppFontStyle.sizesFontManageWeb(1.4, constraints)),
            ),
          )
        ],
      ),
    );
  }

  _widgetButtonYes(ConfigurationIntroController logic,BuildContext context,BoxConstraints constraints,){
    return Container(
      padding: EdgeInsets.only(
        top: AppFontStyle.sizesHeightManageWeb(1.0, constraints),),
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
                  vertical: AppFontStyle.sizesHeightManageWeb(1.0, constraints),
                  horizontal: AppFontStyle.sizesWidthManageWeb(5.0, constraints)
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: CColor.primaryColor,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                      color: CColor.white
                  )
              ),
              child: Text(
                "Yes",
                style: AppFontStyle.styleW700(
                    CColor.white,
                    AppFontStyle.sizesFontManageWeb(1.5,constraints)),
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

  _widgetButtonSkip(ConfigurationIntroController logic,BuildContext context,BoxConstraints constraints){
    return Container(
      margin: EdgeInsets.only(
        bottom: AppFontStyle.sizesHeightManageWeb(1.0, constraints),
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
                  fontSize:AppFontStyle.sizesFontManageWeb(1.5,constraints)),
              // fontSize:(kIsWeb) ?FontSize.size_6: FontSize.size_10),
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }

  _widgetImage(BoxConstraints constraints) {
    return Container(
      // color: Colors.cyanAccent,
      margin: EdgeInsets.only(top: AppFontStyle.sizesHeightManageWeb(4.0, constraints)),
      child: Image.asset("assets/images/configuration.png",
        height:  AppFontStyle.sizesWidthManageWeb(16.0, constraints),
        // width: 150.w,
      ),
    );
  }


}
