
import 'package:banny_table/ui/welcomeScreen/welcome/controllers/welcome_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';


class MobileWelcomeScreen extends StatelessWidget {
  const MobileWelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    return ScreenUtilInit(
      // designSize: const Size(700, 600),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: CColor.white,
          body: SafeArea(
            child: GetBuilder<WelcomeController>(builder: (logic) {
              return _widgetFirstPageDetails(context, logic, orientation);
            }),
          ),
        );
      },
    );
  }

  _widgetFirstPageDetails(BuildContext context,WelcomeController logic,Orientation orientation){
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                (orientation == Orientation.portrait)?
                _widgetWelcomeIcon() : Container(),
                _widgetWelcomeInfo(orientation),
                _widgetAboveDetails(orientation),
                // (kIsWeb) ? Container():Expanded(child: Container()),

              ],
            ),
          ),
        ),
        _widgetButtonDetails(logic,orientation),
        _widgetButtonNOLater(logic,orientation),
      ],
    );
  }



  _widgetWelcomeIcon(){
    // return (kIsWeb) ? Container() : Image.asset(Constant.welcomeIcon,height: Sizes.height_50,width: double.infinity,fit: BoxFit.fill,);
    return (kIsWeb) ? Container() : Container(
      padding: EdgeInsets.only(top: Sizes.width_1,left: Sizes.width_10,right: Sizes.width_10),
      child: SvgPicture.asset(
        Constant.welcomeIconSvg,
        width: Sizes.height_50,
        height: Sizes.height_50,
      ),
    );
  }


  _widgetWelcomeInfo(Orientation orientation){
    return Container(
      margin: EdgeInsets.only(
          top: (orientation == Orientation.portrait)? 20.h:30.h,
          left: (orientation == Orientation.portrait)? 20.w :15.w,
          right: (orientation == Orientation.portrait)? 20.w :15.w
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Text(
            "Welcome to the Physical Activity Tracker App!",
            // textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: AppFontStyle.styleW600(CColor.primaryColor, (orientation == Orientation.portrait)? 16.sp : 12.sp),)),
        ],
      ),
    );
  }



  _widgetAboveDetails(Orientation orientation){
    return Container(
      margin: EdgeInsets.only(
        top: (orientation == Orientation.portrait)?20.h:15.h,
        left: (orientation == Orientation.portrait)?20.w:15.w,
        right: (orientation == Orientation.portrait)?20.w:15.w
      ),
    alignment: Alignment.center,
      child: Text("Set up your preferences now for a better experience. Ready to personalize?"
        ,textAlign: TextAlign.center
        // ,style: AppFontStyle.styleW700(CColor.gray, (kIsWeb)?FontSize.size_5:FontSize.size_9),),
        ,style: AppFontStyle.styleW700(CColor.gray,(orientation == Orientation.portrait)?12.sp: 10.sp),),
    );
  }

  _widgetButtonDetails(WelcomeController logic,Orientation orientation){
    return Container(
      padding: EdgeInsets.only(
          top:(orientation == Orientation.portrait)? Sizes.height_1: Sizes.height_1_8,
        bottom: (orientation == Orientation.portrait)? Sizes.height_1:Sizes.height_1_5,),
      child: Row(
        children: [
          // (kIsWeb) ? Expanded(child: Container()) : Container(),
          Expanded(child: Container()),
          InkWell(
            onTap: () {
              logic.gotoNextScreen();
            },
            child: Container(
              padding:  EdgeInsets.symmetric(
                vertical: (orientation == Orientation.portrait)? Sizes.height_1_5 : Sizes.height_1,
                horizontal: (orientation == Orientation.portrait)? Sizes.width_5 : Sizes.width_10
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: CColor.primaryColor,
                borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                      color: CColor.white
                  )
              ),
              margin: EdgeInsets.only(
                  right: Sizes.width_2
              ),
              child: Text(
                "Yes, Let's Set Up",
                style: AppFontStyle.styleW700(
                     CColor.white,
                    (orientation == Orientation.portrait)? 14.sp: 10.sp),
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


  _widgetButtonNOLater(WelcomeController logic,Orientation orientation){
    return Container(
      margin: EdgeInsets.only(
        bottom: (orientation == Orientation.portrait)? 15.h:10.h
      ),
      child: Row(
        children: [
          Expanded(child: Container()),
          InkWell(
            onTap: () {
              logic.gotoBottomNavigationScreen();
            },
            child: Text(
              "No, Later",
              style: TextStyle(
                  color: CColor.primaryColor,
                  fontSize: (orientation == Orientation.portrait)?  12.sp :8.sp),
                  // fontSize:(kIsWeb) ?FontSize.size_6: FontSize.size_10),
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }

}
