
import 'package:banny_table/ui/welcomeScreen/welcome/controllers/welcome_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
              return _widgetFirstPageDetails(context, logic,orientation );
            }),
          ),
        );
      },
    );
  }

  _widgetFirstPageDetails(BuildContext context,WelcomeController logic, Orientation orientation){
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _widgetWelcomeIcon(orientation),
                _widgetWelcomeInfo(orientation),
                _widgetAboveDetails(orientation),
                _widgetActivityMonitoring(orientation),
                _widgetCareCoordination(orientation),
                _widgetPatientManager(orientation),
                _widgetTaskTracking(orientation),
                SizedBox(
                  height: Sizes.height_1_5
                ),
              ],
            ),
          ),
        ),
        _widgetButtonDetailsNext(logic,orientation)
      ],
    );
  }



  _widgetWelcomeIcon(Orientation orientation){
    return (kIsWeb) ? Container() : Container(
        margin: EdgeInsets.only(
          top: (orientation == Orientation.portrait)? Sizes.height_1 :Sizes.height_1,
          bottom:(orientation == Orientation.portrait)? Sizes.height_1 :Sizes.height_1
        ),
        decoration: const BoxDecoration(
          shape: BoxShape.circle
        ),
        alignment: Alignment.center,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(200),
            child: Image.asset("assets/images/provider_logo.png",height:(orientation == Orientation.portrait)? Sizes.width_36:Sizes.width_30,width:(orientation == Orientation.portrait)? Sizes.width_36:Sizes.width_30,fit: BoxFit.fill,)));
  }


  _widgetWelcomeInfo(Orientation orientation){
    return Container(
      /*margin: EdgeInsets.only(
          top: Sizes.height_3_5,left: Sizes.width_4,right: Sizes.width_4
      ),*/
      margin: EdgeInsets.only(
          top: (kIsWeb)?15.h:(orientation == Orientation.portrait)?20.h:10.h,
          left: (kIsWeb)?30.w:(orientation == Orientation.portrait)?25.w :10.w,
          right: (kIsWeb)?30.w:(orientation == Orientation.portrait)?25.w :10.w
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Text(
            Constant.txtWelcomeMessage,
            // textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: AppFontStyle.styleW600(CColor.primaryColor, (orientation == Orientation.portrait)?17.sp:12.sp),)),
        ],
      ),
    );
  }

  _widgetAboveDetails(Orientation orientation){
    return Container(
      margin: EdgeInsets.only(
        top: (kIsWeb)?15.h:(orientation == Orientation.portrait)?25.h:15.h,
        left: (kIsWeb)?30.w:(orientation == Orientation.portrait)?25.w:10.w,
        right: (kIsWeb)?30.w:(orientation == Orientation.portrait)?23.w:10.w

      ),
    alignment: Alignment.centerLeft,
      child: Text(Constant.txtWelcomeAllow
        ,textAlign: TextAlign.center
        // ,style: AppFontStyle.styleW700(CColor.gray, (kIsWeb)?FontSize.size_5:FontSize.size_9),),
        ,style: AppFontStyle.styleW600(CColor.black,(kIsWeb)?8.sp: (orientation == Orientation.portrait)?13.sp :8.sp),),
    );
  }


  _widgetTaskTracking(Orientation orientation){
    return Container(
      margin: EdgeInsets.only(
          top: (kIsWeb)?15.h:(orientation == Orientation.portrait)?20.h:15.h,
          left: (kIsWeb)?30.w:(orientation == Orientation.portrait)?25.w:15.w,
          right: (kIsWeb)?30.w:(orientation == Orientation.portrait)?23.w:10.w
      ),
    alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                  left: Sizes.width_1
              ),
              child: RichText(
                maxLines: 4,
                text: TextSpan(
                  text: "",
                  style: AppFontStyle.styleW700(CColor.black, (kIsWeb)?6.sp:14.sp),
                  children: [
                    WidgetSpan(child: Container(
                        // alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                        right: Sizes.width_1
                      ),
                        child: Image.asset(Constant.icHomePatientTask,width:(orientation == Orientation.portrait)? Sizes.width_4_5:Sizes.width_5,height:(orientation == Orientation.portrait)? Sizes.width_4_5:Sizes.width_5,))),
                    ///This Is use For Goal Type is mandatory
                    TextSpan(
                      text: Constant.txtActivitySystemManagement,
                      style: AppFontStyle.styleW700(
                          CColor.black, (kIsWeb) ? 6.sp : (orientation == Orientation.portrait)?14.sp :8.sp),),
                    TextSpan(
                      text: Constant.txtActivitySystemManagementDesc,
                      style: AppFontStyle.styleW500(
                          CColor.black, (kIsWeb)?5.sp:(orientation == Orientation.portrait)?12.sp:7.sp
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _widgetPatientManager(Orientation orientation){
    return Container(
      margin: EdgeInsets.only(
          top: (kIsWeb)?15.h:(orientation == Orientation.portrait)?20.h:15.h,
          left: (kIsWeb)?30.w:(orientation == Orientation.portrait)?25.w:15.w,
          right: (kIsWeb)?30.w:(orientation == Orientation.portrait)?23.w:10.w
      ),
    alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                  left: Sizes.width_1
              ),
              child: RichText(
                maxLines: 5,
                text: TextSpan(
                  text: "",
                  style: AppFontStyle.styleW700(CColor.black, (kIsWeb)?6.sp:14.sp),
                  children: [
                    WidgetSpan(child: Container(
                      // alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                            right: Sizes.width_1
                        ),
                        child: Image.asset(Constant.icPatientManagement,width:(orientation == Orientation.portrait)? Sizes.width_4_5:Sizes.width_5,height:(orientation == Orientation.portrait)? Sizes.width_4_5:Sizes.width_5,))),
                    TextSpan(
                      text: Constant.txtActivityPatientInteraction,
                      style: AppFontStyle.styleW700(CColor.black, (kIsWeb)?6.sp: (orientation == Orientation.portrait)?14.sp :8.sp),),
                    TextSpan(
                      text: Constant.txtActivityPatientInteractionDesc,
                      style: AppFontStyle.styleW500(
                          CColor.black, (kIsWeb)?5.sp:(orientation == Orientation.portrait)?12.sp:7.sp
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _widgetCareCoordination(Orientation orientation){
    return Container(
      margin: EdgeInsets.only(
          top: (kIsWeb)?15.h:(orientation == Orientation.portrait)?20.h:15.h,
          left: (kIsWeb)?30.w:(orientation == Orientation.portrait)?25.w:15.w,
          right: (kIsWeb)?30.w:(orientation == Orientation.portrait)?23.w:10.w
      ),
    alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                  left: Sizes.width_1
              ),
              child: RichText(
                maxLines: 4,
                text: TextSpan(
                  text: "",
                  style: AppFontStyle.styleW700(CColor.black, (kIsWeb)?6.sp:14.sp),
                  children: [
                    WidgetSpan(child: Container(
                      // alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                            right: Sizes.width_1
                        ),
                        child: Image.asset(Constant.icCareCondition,width:(orientation == Orientation.portrait)? Sizes.width_4_5:Sizes.width_5,height:(orientation == Orientation.portrait)? Sizes.width_4_5:Sizes.width_5,))),
            TextSpan(
              text: Constant.txtActivityCareCoordination,
              style: AppFontStyle.styleW700(CColor.black, (kIsWeb)?6.sp: (orientation == Orientation.portrait)?14.sp :8.sp),),
                    ///This Is use For Goal Type is mandatory
                    TextSpan(
                      text: Constant.txtActivityCareCoordinationDesc,
                      style: AppFontStyle.styleW500(
                          CColor.black, (kIsWeb)?5.sp:(orientation == Orientation.portrait)?12.sp:7.sp
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _widgetActivityMonitoring(Orientation orientation){
    return Container(
      margin: EdgeInsets.only(
          top: (kIsWeb)?15.h:(orientation == Orientation.portrait)?25.h:15.h,
          left: (kIsWeb)?30.w:(orientation == Orientation.portrait)?25.w:15.w,
          right: (kIsWeb)?30.w:(orientation == Orientation.portrait)?23.w:10.w
      ),
    alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                  left: Sizes.width_1
              ),
              child: RichText(
                maxLines: 4,
                text: TextSpan(
                  text: "",
                  style: AppFontStyle.styleW700(CColor.black, (kIsWeb)?6.sp:14.sp),
                  children: [
                    WidgetSpan(child: Container(
                      // alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                            right: Sizes.width_1
                        ),
                        child: Image.asset(Constant.icAcivityMonitoring,width:(orientation == Orientation.portrait)? Sizes.width_4_5:Sizes.width_5,height:(orientation == Orientation.portrait)? Sizes.width_4_5:Sizes.width_5,))),
            TextSpan(
              text: Constant.txtActivityMonitoring,
              style: AppFontStyle.styleW700(CColor.black, (kIsWeb)?6.sp: (orientation == Orientation.portrait)?14.sp :8.sp),),
                    ///This Is use For Goal Type is mandatory
                    TextSpan(
                      text: Constant.txtActivityMonitoringDesc,
                      style: AppFontStyle.styleW500(
                          CColor.black, (kIsWeb)?5.sp:(orientation == Orientation.portrait)?12.sp:7.sp
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _widgetButtonDetailsNext(WelcomeController logic,Orientation orientation){
    return Container(
      margin: EdgeInsets.only(
          bottom: Sizes.height_3
      ),
      padding: EdgeInsets.only(
        top: Sizes.height_1_8, bottom: Sizes.height_1_5,),
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
                  vertical: Sizes.height_1_5,
                  horizontal:(orientation == Orientation.portrait)? Sizes.width_5 :Sizes.width_15
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: CColor.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: CColor.white
                  )
              ),
              margin: EdgeInsets.only(
                  right: Sizes.width_2
              ),
              child: Text(
                "Get Started",
                style: AppFontStyle.styleW700(
                    CColor.white,
                    (orientation == Orientation.portrait)?14.sp:9.sp),
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

  _widgetButtonDetails(WelcomeController logic){
    return Container(
      padding: EdgeInsets.only(
          top: Sizes.height_1_8, bottom: Sizes.height_1_5,),
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
                vertical: Sizes.height_1_5,
                horizontal: Sizes.width_5
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
                   14.sp),
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



  _widgetButtonNOLater(WelcomeController logic){
    return Container(
      margin: EdgeInsets.only(
        bottom: 10.h
      ),
      child: Row(
        children: [
          Expanded(child: Container()),
          InkWell(
            onTap: () {
              logic.gotoBottomNavigationScreen();
            },
            child: Container(
              child: Text(
                "No, Later",
                style: TextStyle(
                    color: CColor.primaryColor,
                    fontSize: 12.sp),
                    // fontSize:(kIsWeb) ?FontSize.size_6: FontSize.size_10),
              ),
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }

}
