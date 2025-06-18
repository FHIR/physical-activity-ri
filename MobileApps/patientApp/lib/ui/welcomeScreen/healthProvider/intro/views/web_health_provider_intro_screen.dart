import 'package:banny_table/ui/welcomeScreen/healthProvider/healthProvider/controllers/health_provider_controller.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/intro/controllers/health_provider_intro_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WebHealthProviderIntroScreen extends StatelessWidget {
  HealthProviderController? healthProviderController;
  WebHealthProviderIntroScreen( {required this.healthProviderController, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return  Scaffold(
          backgroundColor: CColor.white,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context,BoxConstraints constraints) {
                return GetBuilder<HealthProviderIntroController>(builder: (logic) {
                  return Column(
                    children: [
                      Expanded(child: _widgetHealthProvider(context, logic,constraints)),
                      _widgetButtonYes(logic,context,constraints),
                      _widgetButtonSkip(logic,context,constraints),
                    ],
                  );
                });
              }
            ),
          ),
        );
      },
    );
  }


  _widgetHealthProvider(
      BuildContext context, HealthProviderIntroController logic,BoxConstraints constraints) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _widgetImage(constraints),
          _widgetMoreDetails(context,constraints),
   
        ],
      ),
    );
  }

  _widgetMoreDetails(BuildContext context,BoxConstraints constraints) {
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
            alignment: Alignment.centerLeft,
            child: Text(
              Constant.healthProviderIntro,
              textAlign: TextAlign.start,
              style: AppFontStyle.styleW500(CColor.black, AppFontStyle.sizesFontManageWeb(1.4, constraints))),

          ),
          Container(
            margin: EdgeInsets.only(
              top: AppFontStyle.sizesHeightManageWeb(2.0, constraints),
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              Constant.healthProviderIntroShort,
              textAlign: TextAlign.start,
              style: AppFontStyle.styleW500(CColor.black, AppFontStyle.sizesFontManageWeb(1.4, constraints)),
            ),
          )
        ],
      ),
    );
  }

  _widgetButtonYes(HealthProviderIntroController logic,BuildContext context,BoxConstraints constraints){
    return Container(
      padding: EdgeInsets.only(
        top: AppFontStyle.sizesHeightManageWeb(1.0, constraints),),
      child: Row(
        children: [
          Expanded(child: Container()),
          InkWell(
            onTap: () {
              healthProviderController!.pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
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

  _widgetButtonSkip(HealthProviderIntroController logic,BuildContext context,BoxConstraints constraints){
    return Container(
      margin: EdgeInsets.only(
        bottom: AppFontStyle.sizesHeightManageWeb(1.0, constraints),
      ),
      child: Row(
        children: [
          Expanded(child: Container()),
          InkWell(
            onTap: () {
              logic.gotoNextScreen();
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
      margin: EdgeInsets.only(top: AppFontStyle.sizesHeightManageWeb(8.5, constraints)),
      child: Image.asset("assets/images/provider.jpeg",
        height:  AppFontStyle.sizesWidthManageWeb(16.0, constraints),
        // width: 150.w,
      ),
    );
  }


}
