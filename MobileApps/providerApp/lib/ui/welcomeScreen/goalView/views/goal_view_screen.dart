import 'package:banny_table/ui/welcomeScreen/goalView/controllers/goal_view_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class GoalViewScreen extends StatelessWidget {
  const GoalViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          useMaterial3: false
      ),
      child: Scaffold(
        backgroundColor: CColor.white,
        body: SafeArea(
          child: GetBuilder<GoalViewController>(builder: (logic) {
            return _widgetGoalViewDetails(context, logic);
          }),
        ),
      ),
    );
  }

  _widgetGoalViewDetails(BuildContext context, GoalViewController logic) {
    return Container(
      margin: EdgeInsets.only(left: Sizes.width_5, right: Sizes.width_5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // _widgetBackButton(logic),
          // _widgetWelcomeIcon(),
          // _widgetWelcomeInfo(),
          Expanded(child: Container()),
          _widgetMainIcons(),
          // _widgetWelcomeInfo(),
          // Expanded(child: Container()),
          _widgetAboveDetails(),
          _widgetSetGoalDetails(),
          Expanded(child: Container()),
          _widgetButtonDetails(logic,context),
          _widgetButtonNOLater(logic,context),
          _widgetIndication(),
        ],
      ),
    );
  }

  _widgetBackButton(GoalViewController logic) {
    return Container(
      margin: EdgeInsets.only(top: (kIsWeb) ? Sizes.height_3 : Sizes.height_2),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                left: (kIsWeb) ? Sizes.width_2 : Sizes.width_3,
                right: (kIsWeb) ? Sizes.width_2 : Sizes.width_3,
              ),
              child: Image.asset(
                Constant.leftArrowIcons,
                height: (kIsWeb) ? Sizes.width_1_5 : Sizes.width_4_5,
                width: (kIsWeb) ? Sizes.width_1_5 : Sizes.width_4_5,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                  right: (kIsWeb) ? Sizes.width_1 : Sizes.width_3),
              child: Text(
                "Connect to Your Health Provider",
                maxLines: 2,
                style: AppFontStyle.styleW600(CColor.black,
                    (kIsWeb) ? FontSize.size_6 : FontSize.size_12),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              logic.gotoBottomNavigationScreen();
            },
            child: Container(
              margin: EdgeInsets.only(
                  right: (kIsWeb) ? Sizes.width_1 : Sizes.width_2),
              child: Text(
                "Skip",
                style: AppFontStyle.styleW600(CColor.primaryColor,
                    (kIsWeb) ? FontSize.size_6 : FontSize.size_10),
              ),
            ),
          )
        ],
      ),
    );
  }

  _widgetMainIcons() {
    return Container(
      /*margin: EdgeInsets.only(
          top: (kIsWeb) ? Sizes.height_2 : 30.h,),*/
      padding: EdgeInsets.all(Sizes.width_5),
      child: Image.asset(
        Constant.goalViewMainIcons,
        height: (kIsWeb) ? Sizes.width_10 : Sizes.width_30,
        width: (kIsWeb) ? Sizes.width_10 : Sizes.width_30,
      ),
    );
  }

  _widgetWelcomeInfo() {
    return Container(
      margin: EdgeInsets.only(
          top: (kIsWeb) ? Sizes.height_2 : Sizes.height_3_5,
          left: Sizes.width_4,
          right: Sizes.width_4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              "Goal",
              textAlign: TextAlign.center,
              style: AppFontStyle.styleW600(CColor.primaryColor,
                  (kIsWeb) ? FontSize.size_7 : FontSize.size_15),
            ),
          ),
        ],
      ),
    );
  }

  _widgetAboveDetails() {
    return Container(
      margin: EdgeInsets.only(
        top: (kIsWeb) ? 0 : 20.h,
      ),
      alignment: Alignment.center,
      child: Text(
        "This app allows you to set and track your fitness goals, such as calories burned, exercise duration, step count, and more.",
        textAlign: TextAlign.center,
        style: AppFontStyle.styleW500(
            CColor.black, (kIsWeb) ? FontSize.size_3 : 13.sp),
      ),
    );
  }

  _widgetButtonDetails(GoalViewController logic,BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container()),
        Container(
          margin: EdgeInsets.only(left: Sizes.width_20, right: Sizes.width_20),
          padding: EdgeInsets.only(
            top: Sizes.height_1_8,
            bottom: Sizes.height_1_5,
          ),
          child: InkWell(
            onTap: () {
              logic.gotoGoalFrom();
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: Sizes.height_1_5, horizontal: Sizes.width_5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: CColor.primaryColor,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: CColor.white)),
              margin: EdgeInsets.only(right: Sizes.width_2),
              child: Text(
                "Yes",
                style: AppFontStyle.styleW700(CColor.white,
                    (kIsWeb) ? Utils.sizesFontManage(context ,3.5) : FontSize.size_12),
              ),
            ),
          ),
        ),
        Expanded(child: Container())
      ],
    );
  }

  _widgetButtonNOLater(GoalViewController logic,BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: Sizes.width_20, right: Sizes.width_20, bottom: Sizes.height_8),
      child: InkWell(
        onTap: () {
          logic.gotoBottomNavigationScreen();
        },
        child: Container(
          margin: EdgeInsets.only(right: Sizes.width_2),
          child: Text(
            "Skip",
            style: TextStyle(
                color: CColor.primaryColor,
                fontSize: (kIsWeb) ? Utils.sizesFontManage(context ,3.0) : FontSize.size_10),
          ),
        ),
      ),
    );
  }

  _widgetSetGoalDetails() {
    return Container(
      margin: EdgeInsets.only(
        top: (kIsWeb) ? 0 : 20.h,
      ),
      alignment: Alignment.center,
      child: Text(
        "Would you like to set any goals now?",
        textAlign: TextAlign.center,
        style: AppFontStyle.styleW500(
            CColor.black, (kIsWeb) ? FontSize.size_3 : 13.sp),
      ),
    );
  }

  _widgetIndication(){
    return Container(
      margin: EdgeInsets.only(bottom: 30.h, top: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<Widget>.generate(
            1,
                (index) =>
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    width: (kIsWeb) ? 5.w :10.w,
                    height:(kIsWeb) ? 5.w :10.w,
                    child: InkWell(
                      onTap: () {

                      },
                      child: const CircleAvatar(
                          radius: 8,
                          backgroundColor:
                          // logic.selectedIndex == index?
                          CColor.primaryColor
                        // : CColor.primaryColor50,
                      ),
                    ),
                  ),
                )),
      ),
    );

  }

}
