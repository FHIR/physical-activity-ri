import 'package:banny_table/ui/welcomeScreen/activityConfiguration/configuration/controllers/configuration_controller.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/introConfiguration/controllers/configuration_intro_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../utils/font_style.dart';

class MobileConfigurationIntroScreen extends StatelessWidget {
  ConfigurationMainController? configurationMainController;

  MobileConfigurationIntroScreen({ this.configurationMainController, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return LayoutBuilder(
          builder: (BuildContext context ,BoxConstraints constraints) {
            return Scaffold(
              backgroundColor: CColor.white,
              body: SafeArea(
                child: GetBuilder<ConfigurationIntroController>(builder: (logic) {
                  return Column(
                    children: [
                      Expanded(child: _widgetConfigurationIntro(context,logic,orientation,constraints)),
                      _widgetButtonYes(logic,orientation,constraints),
                      _widgetButtonSkip(logic,orientation,constraints),
                    ],
                  );
                }
                ),
              ),
            );
          }
        );
      },
    );
  }

  _widgetConfigurationIntro(
      BuildContext context, ConfigurationIntroController logic,Orientation orientation,BoxConstraints constraints) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _widgetImage(orientation,constraints),
          _widgetMoreDetails(orientation,constraints),
        ],
      ),
    );
  }

  _widgetMoreDetails(Orientation orientation,BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(
        left:  (orientation == Orientation.portrait)
            ? 25.w : AppFontStyle.sizesWidthManageWeb(2.5, constraints),
        right: (orientation == Orientation.portrait)
            ? 25.w : AppFontStyle.sizesWidthManageWeb(2.5, constraints),
      ),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: (orientation == Orientation.portrait)
                  ?  9.h : AppFontStyle.sizesHeightManageWeb(0.3, constraints),
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              Constant.configurationIntro,
              textAlign: TextAlign.start,
              style: AppFontStyle.styleW500(CColor.black, (orientation == Orientation.portrait)
                  ?13.sp :  AppFontStyle.sizesFontManageWeb(1.4, constraints)),
            ),
          ),
         /* Container(
            margin: EdgeInsets.only(
              top: (orientation == Orientation.portrait)
                  ?  9.h : AppFontStyle.sizesHeightManageWeb(0.4, constraints),
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              Constant.configurationIntroShort,
              textAlign: TextAlign.start,
              style: AppFontStyle.styleW700(CColor.gray, (orientation == Orientation.portrait)
                  ?13.sp :  AppFontStyle.sizesFontManageWeb(1.4, constraints)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: (orientation == Orientation.portrait)
                  ?  9.h : AppFontStyle.sizesHeightManageWeb(0.4, constraints),
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              Constant.configurationIntroShortSecond,
              textAlign: TextAlign.start,
              style: AppFontStyle.styleW700(CColor.gray,(orientation == Orientation.portrait) ? 12.sp : AppFontStyle.sizesFontManageWeb(1.4, constraints)),
            ),
          ),*/
          Container(
            margin: EdgeInsets.only(
              top: (orientation == Orientation.portrait)
                  ?  9.h : AppFontStyle.sizesHeightManageWeb(0.4, constraints),
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              Constant.configurationIntroInfo,
              textAlign: TextAlign.start,
              style: AppFontStyle.styleW500(CColor.black,(orientation == Orientation.portrait) ? 12.sp : AppFontStyle.sizesFontManageWeb(1.4, constraints)),
            ),
          )
        ],
      ),
    );
  }

  _widgetButtonYes(ConfigurationIntroController logic,Orientation orientation,BoxConstraints constraints){
    return Container(
      padding: EdgeInsets.only(
        top:   (orientation == Orientation.portrait) ? 5.h : AppFontStyle.sizesHeightManageWeb(0.5, constraints), bottom:  (orientation == Orientation.portrait) ? 5.h : AppFontStyle.sizesHeightManageWeb(0.5, constraints),),
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
                vertical: (orientation == Orientation.portrait) ? 8.h : AppFontStyle.sizesHeightManageWeb(1.0, constraints),
                  horizontal:  (orientation == Orientation.portrait) ? 20.w :AppFontStyle.sizesWidthManageWeb(5.0, constraints)
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
                    (orientation == Orientation.portrait) ? 14.sp :  AppFontStyle.sizesFontManageWeb(1.5,constraints)),
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

  _widgetButtonSkip(ConfigurationIntroController logic,Orientation orientation,BoxConstraints constraints){
    return Container(
      margin: EdgeInsets.only(
          bottom: (orientation == Orientation.portrait) ? 10.h:AppFontStyle.sizesHeightManageWeb(0.3, constraints),
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
                  fontSize:  (orientation == Orientation.portrait) ? 12.sp : AppFontStyle.sizesFontManageWeb(1.5,constraints)),
              // fontSize:(kIsWeb) ?FontSize.size_6: FontSize.size_10),
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }

  _widgetImage(Orientation orientation, BoxConstraints constraints) {
    return Container(
      // color: Colors.cyanAccent,
      margin: EdgeInsets.only(
          top: (orientation == Orientation.portrait)
              ? 30.h
              : AppFontStyle.sizesHeightManageWeb(0.1, constraints)),
      child: Image.asset(
        "assets/images/configuration.png",
        height: (orientation == Orientation.portrait)
            ? 200.h
            : AppFontStyle.sizesWidthManageWeb(7.0, constraints),
        // width: 150.w,
      ),
    );
  }
}
