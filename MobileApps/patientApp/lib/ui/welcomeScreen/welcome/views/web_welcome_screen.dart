
import 'package:banny_table/ui/welcomeScreen/welcome/controllers/welcome_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';

class WebWelcomeScreen extends StatelessWidget {
  const WebWelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // designSize: const Size(700, 600),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: CColor.white,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context,BoxConstraints constraints) {
                return GetBuilder<WelcomeController>(builder: (logic) {
                  return _widgetFirstPageDetails(context, logic, constraints);
                });
              }
            ),
          ),
        );
      },
    );
  }

  _widgetFirstPageDetails(BuildContext context,WelcomeController logic,BoxConstraints constraints){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _widgetWelcomeInfo(context, constraints),
                _widgetAboveDetails(context, constraints),
              ],
            ),
          ),
        ),
        _widgetButtonDetails(logic,context,constraints),
        _widgetButtonNOLater(logic,context,constraints),
      ],
    );
  }



  _widgetWelcomeIcon(){
    return (kIsWeb) ? Container() : Image.asset(Constant.welcomeIcon,height: Sizes.height_50,width: double.infinity,fit: BoxFit.fill,);
  }


  _widgetWelcomeInfo(BuildContext context,BoxConstraints constraints){
    return Container(
      /*margin: EdgeInsets.only(
          top: Sizes.height_3_5,left: Sizes.width_4,right: Sizes.width_4
      ),*/
      margin: EdgeInsets.only(
        top:AppFontStyle.sizesHeightManageWeb(19.0, constraints),
        left:AppFontStyle.sizesWidthManageWeb(3.0, constraints),
        right:AppFontStyle.sizesWidthManageWeb(3.0, constraints),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Text(
            "Welcome to the Physical Activity Tracker App!",
            // textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: AppFontStyle.styleW600(CColor.primaryColor, AppFontStyle.commonFontHeader(constraints)),)),
        ],
      ),
    );
  }



  _widgetAboveDetails(BuildContext context,BoxConstraints constraints){
    return Container(
      margin: EdgeInsets.only(
        top:AppFontStyle.sizesHeightManageWeb(2.0, constraints),
        left:AppFontStyle.sizesWidthManageWeb(3.0, constraints),
        right:AppFontStyle.sizesWidthManageWeb(3.0, constraints),
      ),
    alignment: Alignment.center,
      child: Text("Set up your preferences now for a better experience. Ready to personalize?"
        ,textAlign: TextAlign.center
        // ,style: AppFontStyle.styleW700(CColor.gray, (kIsWeb)?FontSize.size_5:FontSize.size_9),),
        ,style: AppFontStyle.styleW700(CColor.gray,AppFontStyle.commonFontHeaderSecond(constraints)),),
    );
  }

  _widgetButtonDetails(WelcomeController logic,BuildContext context,BoxConstraints constraints){
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

            },
            child: Container(
              padding:  EdgeInsets.symmetric(
                vertical: AppFontStyle.sizesHeightManageWeb(1.2, constraints),
                horizontal: AppFontStyle.sizesWidthManageWeb(5.5, constraints)
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
                "Yes, Let's Set Up",
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


  _widgetButtonNOLater(WelcomeController logic,BuildContext context,BoxConstraints constraints){
    return Container(
      margin: EdgeInsets.only(
        bottom: AppFontStyle.sizesHeightManageWeb(2.0, constraints),
      ),
      child: InkWell(
        onTap: () {
          Get.offAllNamed(AppRoutes.bottomNavigation);
        },
        child: Text(
          "No, Later",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: CColor.primaryColor,
              fontSize:AppFontStyle.sizesFontManageWeb(1.5,constraints)),
              // fontSize:(kIsWeb) ?FontSize.size_6: FontSize.size_10),
        ),
      ),
    );
  }







}
