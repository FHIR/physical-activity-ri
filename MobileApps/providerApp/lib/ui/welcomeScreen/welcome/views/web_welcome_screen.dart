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

class WebWelcomeScreen extends StatelessWidget {
  const WebWelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: CColor.white,
          body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return SafeArea(
              child: GetBuilder<WelcomeController>(builder: (logic) {
                return _widgetFirstPageDetails(context, logic, constraints);
              }),
            );
          }),
        );
      },
    );
  }

  _widgetFirstPageDetails(BuildContext context, WelcomeController logic,
      BoxConstraints constraints) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Expanded(child: Container()),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _widgetWelcomeIcon(constraints),
                _widgetWelcomeInfo(context, constraints),
                _widgetAboveDetails(context, constraints),
                _widgetActivityMonitoring(context, constraints),
                _widgetCareCoordination(context, constraints),
                _widgetTaskTracking(context, constraints),
                _widgetPatientManager(context, constraints),
              ],
            ),
          ),
        ),
        _widgetButtonDetailsNext(logic, context, constraints),
        // _widgetButtonNOLater(logic,context),
      ],
    );
  }

  _widgetWelcomeIcon(BoxConstraints constraints) {
    return Container(
        margin: EdgeInsets.only(
            top: AppFontStyle.sizesHeightManageWeb(1.0, constraints),
            bottom: AppFontStyle.sizesHeightManageWeb(1.0, constraints)),
        decoration: BoxDecoration(shape: BoxShape.circle),
        alignment: Alignment.center,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(200),
            child: Image.asset(
              "assets/images/provider_logo.png",
              height: AppFontStyle.sizesHeightManageWeb(11.0, constraints),
              width: AppFontStyle.sizesHeightManageWeb(11.0, constraints),
              fit: BoxFit.fill,
            )));
  }

  _widgetWelcomeInfo(BuildContext context, BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(
          top: AppFontStyle.sizesHeightManageWeb(1.0, constraints),
          left: AppFontStyle.sizesWidthManageWeb(2.5, constraints),
          right: AppFontStyle.sizesWidthManageWeb(2.5, constraints),
          bottom: AppFontStyle.sizesHeightManageWeb(1.0, constraints)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Text(
            Constant.txtWelcomeMessage,
            // textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: AppFontStyle.styleW600(CColor.primaryColor,
                AppFontStyle.sizesFontManageHeadingWeb(1.8, constraints)),
          )),
        ],
      ),
    );
  }

  _widgetButtonDetails(WelcomeController logic, BuildContext context) {
    return Container(
      /*margin: EdgeInsets.only(
        left: (kIsWeb) ?Sizes.width_0_5 :Sizes.width_20,
        right: (kIsWeb) ?Sizes.width_0_5 :Sizes.width_20
      ),*/
      padding: EdgeInsets.only(
        bottom: 10.h,
      ),
      child: Row(
        children: [
          // (kIsWeb) ? Expanded(child: Container()) : Container(),
          Expanded(child: Container()),
          InkWell(
            onTap: () {
              logic.gotoNextScreen();
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: CColor.primaryColor,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: CColor.white)),
              margin: EdgeInsets.only(right: Sizes.width_2),
              child: Text(
                "Yes, Let's Set Up",
                style: AppFontStyle.styleW700(
                    CColor.white, Utils.sizesFontManage(context, 3.5)),
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

/*  _widgetWelcomeInfo(){
    return Container(
      margin: EdgeInsets.only(
          top: Sizes.height_3_5,left: Sizes.width_4,right: Sizes.width_4
      ),
      margin: EdgeInsets.only(
          top: (kIsWeb)?15.h:20.h,
          left: (kIsWeb)?30.w:25.w,
          right: (kIsWeb)?30.w:25.w
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Text(
            Constant.txtWelcomeMessage,
            // textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: AppFontStyle.styleW600(CColor.primaryColor, 17.sp),)),
        ],
      ),
    );
  }*/

  _widgetAboveDetails(BuildContext context, BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(
          top: AppFontStyle.sizesHeightManageWeb(1.0, constraints),
          left: AppFontStyle.sizesWidthManageWeb(1.5, constraints),
          right: AppFontStyle.sizesWidthManageWeb(1.5, constraints)),
      alignment: Alignment.centerLeft,
      child: Text(
        Constant.txtWelcomeAllow,
        textAlign: TextAlign.center
        // ,style: AppFontStyle.styleW700(CColor.gray, (kIsWeb)?FontSize.size_5:FontSize.size_9),),
        ,
        style: AppFontStyle.styleW600(
            CColor.black, AppFontStyle.sizesFontManageWeb(1.5, constraints)),
      ),
    );
  }

  _widgetTaskTracking(BuildContext context, BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(
        top: AppFontStyle.sizesHeightManageWeb(1.0, constraints),
        left: AppFontStyle.sizesWidthManageWeb(2.0, constraints),
        right: AppFontStyle.sizesWidthManageWeb(2.0, constraints),
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: RichText(
              maxLines: 3,
              text: TextSpan(
                text: "",
                style: AppFontStyle.styleW700(
                    CColor.black, (kIsWeb) ? 6.sp : 14.sp),
                children: [
                  WidgetSpan(
                      child: Container(
                          // alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(right: Sizes.width_1),
                          child: Image.asset(
                            Constant.icPatientManagement,
                            width: AppFontStyle.sizesFontManageWeb(
                                2.0, constraints),
                            height: AppFontStyle.sizesFontManageWeb(
                                1.40, constraints),
                          ))),

                  ///This Is use For Goal Type is mandatory
                  TextSpan(
                    text: "Patient Interaction: ",
                    style: AppFontStyle.styleW700(
                        CColor.black,
                        (kIsWeb)
                            ? AppFontStyle.sizesFontManageWeb(1.45, constraints)
                            : 14.sp),
                  ),
                  TextSpan(
                    text:
                        "Engage with patients directly, such as creating tasks for them or requesting them to fill out forms.",
                    style: AppFontStyle.styleW500(
                        CColor.black,
                        (kIsWeb)
                            ? AppFontStyle.sizesFontManageWeb(1.40, constraints)
                            : 12.sp),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _widgetPatientManager(BuildContext context, BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(
        top: AppFontStyle.sizesHeightManageWeb(1.0, constraints),
        left: AppFontStyle.sizesWidthManageWeb(2.0, constraints),
        right: AppFontStyle.sizesWidthManageWeb(2.0, constraints),
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              child: RichText(
                maxLines: 5,
                text: TextSpan(
                  text: "",
                  style: AppFontStyle.styleW700(
                      CColor.black, (kIsWeb) ? 6.sp : 14.sp),
                  children: [
                    WidgetSpan(
                        child: Container(
                            // alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(right: Sizes.width_1),
                            child: Image.asset(
                              Constant.icHomePatientTask,
                              width: AppFontStyle.sizesFontManageWeb(
                                  2.0, constraints),
                              height: AppFontStyle.sizesFontManageWeb(
                                  1.40, constraints),
                            ))),
                    TextSpan(
                      text: "System Management : ",
                      style: AppFontStyle.styleW700(
                          CColor.black,
                          (kIsWeb)
                              ? AppFontStyle.sizesFontManageWeb(
                                  1.45, constraints)
                              : 14.sp),
                    ),
                    TextSpan(
                      text:
                          "Seamlessly search for and manage patient information, enhancing operational efficiency and patient care delivery.",
                      style: AppFontStyle.styleW500(
                          CColor.black,
                          (kIsWeb)
                              ? AppFontStyle.sizesFontManageWeb(
                                  1.40, constraints)
                              : 12.sp),
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

  _widgetCareCoordination(BuildContext context, BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(
        top: AppFontStyle.sizesHeightManageWeb(1.0, constraints),
        left: AppFontStyle.sizesWidthManageWeb(2.0, constraints),
        right: AppFontStyle.sizesWidthManageWeb(2.0, constraints),
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: RichText(
              maxLines: 4,
              text: TextSpan(
                text: "",
                style: AppFontStyle.styleW700(
                    CColor.black, (kIsWeb) ? 6.sp : 14.sp),
                children: [
                  WidgetSpan(
                      child: Container(
                          // alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(right: Sizes.width_1),
                          child: Image.asset(
                            Constant.icCareCondition,
                            width: AppFontStyle.sizesFontManageWeb(
                                2.0, constraints),
                            height: AppFontStyle.sizesFontManageWeb(
                                1.40, constraints),
                          ))),
                  TextSpan(
                    text: "Care Coordination : ",
                    style: AppFontStyle.styleW700(
                        CColor.black,
                        (kIsWeb)
                            ? AppFontStyle.sizesFontManageWeb(1.40, constraints)
                            : 14.sp),
                  ),

                  ///This Is use For Goal Type is mandatory
                  TextSpan(
                    text:
                        "Review, edit, and create Conditions, Care Plans, Exercise Prescriptions, Goals, and Referrals for comprehensive patient care.",
                    style: AppFontStyle.styleW500(
                        CColor.black,
                        (kIsWeb)
                            ? AppFontStyle.sizesFontManageWeb(1.45, constraints)
                            : 12.sp),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _widgetActivityMonitoring(BuildContext context, BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(
        // top: (kIsWeb)?15.h:9.h,
        top: AppFontStyle.sizesHeightManageWeb(1.0, constraints),
        left: AppFontStyle.sizesWidthManageWeb(2.0, constraints),
        right: AppFontStyle.sizesWidthManageWeb(2.0, constraints),
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: RichText(
              maxLines: 3,
              text: TextSpan(
                text: "",
                style: AppFontStyle.styleW700(
                    CColor.black, (kIsWeb) ? 6.sp : 14.sp),
                children: [
                  WidgetSpan(
                      child: Container(
                          // alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(right: Sizes.width_1),
                          child: Image.asset(
                            Constant.icAcivityMonitoring,
                            width: AppFontStyle.sizesFontManageWeb(
                                2.0, constraints),
                            height: AppFontStyle.sizesFontManageWeb(
                                1.40, constraints),
                          ))),
                  TextSpan(
                    text: "Activity Monitoring : ",
                    style: AppFontStyle.styleW700(
                        CColor.black,
                        (kIsWeb)
                            ? AppFontStyle.sizesFontManageWeb(1.45, constraints)
                            : 14.sp),
                  ),

                  ///This Is use For Goal Type is mandatory
                  TextSpan(
                    text:
                        "Monitor patient physical activities, including steps, calories burned, heart rate, and activity minutes.",
                    style: AppFontStyle.styleW500(
                        CColor.black,
                        (kIsWeb)
                            ? AppFontStyle.sizesFontManageWeb(1.40, constraints)
                            : 12.sp),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _widgetButtonDetailsNext(WelcomeController logic, BuildContext context,
      BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(
          bottom: AppFontStyle.sizesHeightManageWeb(1.0, constraints)),
      padding: EdgeInsets.only(
        top: AppFontStyle.sizesWidthManageWeb(0.9, constraints),
        bottom: AppFontStyle.sizesWidthManageWeb(0.9, constraints),
      ),
      child: Row(
        children: [
          // (kIsWeb) ? Expanded(child: Container()) : Container(),
          Expanded(child: Container()),
          InkWell(
            onTap: () {
              logic.gotoNextScreen();
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: AppFontStyle.sizesHeightManageWeb(0.8, constraints),
                  horizontal:
                      AppFontStyle.sizesWidthManageWeb(5.0, constraints)),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: CColor.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: CColor.white)),
              margin: EdgeInsets.only(right: Sizes.width_2),
              child: Text(
                "Get Started",
                style: AppFontStyle.styleW700(CColor.white,
                    AppFontStyle.sizesFontManageWeb(1.5, constraints)),
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

  _widgetButtonNOLater(WelcomeController logic, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          // left: Sizes.width_20,
          // right: Sizes.width_20,
          bottom: 15.h),
      child: InkWell(
        onTap: () {
          logic.moveToMainScreen();
        },
        child: Text(
          "No, Later",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: CColor.primaryColor,
              fontSize: Utils.sizesFontManage(context, 3.0)),
          // fontSize:(kIsWeb) ?FontSize.size_6: FontSize.size_10),
        ),
      ),
    );
  }
}
