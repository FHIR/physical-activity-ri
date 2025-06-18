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
    var orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      backgroundColor: CColor.white,
      body: LayoutBuilder(
        builder: (BuildContext context,BoxConstraints constraints) {
          return SafeArea(
            child: GetBuilder<GoalViewController>(builder: (logic) {
              return _widgetGoalViewDetails(context, logic,constraints,orientation);
            }),
          );
        }
      ),
    );
  }

  _widgetGoalViewDetails(BuildContext context, GoalViewController logic,BoxConstraints constraints,Orientation orientation) {
    return Container(
      margin: EdgeInsets.only(left: Sizes.width_5, right: Sizes.width_5),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _widgetMainIcons(constraints,orientation),
                  _widgetAboveDetails(constraints,orientation),
                  _widgetSetGoalDetails(constraints,orientation),
                ],
              ),
            ),
          ),
          _widgetButtonDetails(logic,context,constraints,orientation),
          _widgetButtonNOLater(logic,context,constraints,orientation),
          _widgetIndication(constraints,orientation),
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

  _widgetMainIcons(BoxConstraints constraints,Orientation orientation) {
    return Container(
      padding: EdgeInsets.all((kIsWeb) ?AppFontStyle.sizesWidthManageWeb(2.0, constraints) : (orientation == Orientation.portrait)?
      Sizes.width_5 : Sizes.width_3),
      margin: EdgeInsets.only(
          top :(kIsWeb)?AppFontStyle.sizesHeightManageWeb(4.0, constraints) :(orientation == Orientation.portrait)?
           Sizes.height_10 : Sizes.height_0_5
      ),
      child: Image.asset(
        Constant.goalViewMainIcons,
        height: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(10.0, constraints) : (orientation == Orientation.portrait)?
        Sizes.width_30 : Sizes.width_20,
        width: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(10.0, constraints) :(orientation == Orientation.portrait)?
        Sizes.width_30 : Sizes.width_20,
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

  _widgetAboveDetails(BoxConstraints constraints,Orientation orientation) {
    return Container(
      margin: EdgeInsets.only(
        top: (kIsWeb) ? 0 : (orientation == Orientation.portrait)?
        Sizes.height_10 : Sizes.height_1,
      ),
      alignment: Alignment.center,
      child: Text(
        "This app allows you to set and track your fitness goals, such as calories burned, exercise duration, step count, and more.",
        textAlign: TextAlign.center,
        style: AppFontStyle.styleW500(
            CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) :(orientation == Orientation.portrait)?
        FontSize.size_10 :AppFontStyle.sizesFontManageWeb(1.2, constraints)),
      ),
    );
  }

  _widgetButtonDetails(GoalViewController logic,BuildContext context,BoxConstraints constraints,Orientation orientation) {
    return Container(
      padding: EdgeInsets.only(
        top: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.0, constraints) :Sizes.height_1_8,
        bottom: Sizes.height_1_5,
      ),
      child: Row(
        children: [
          Expanded(child: Container()),
          Container(
            // margin: EdgeInsets.only(left: Sizes.width_20, right: Sizes.width_20),

            child: InkWell(
              onTap: () {
                logic.gotoGoalFrom();
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: (kIsWeb)
                        ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                        : Sizes.height_1_5,
                    horizontal: (kIsWeb) ?
                    AppFontStyle.sizesWidthManageWeb(5.0, constraints):
                    Sizes.width_5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: CColor.primaryColor,
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: CColor.white)),
                // margin: EdgeInsets.only(right: Sizes.width_2),
                child: Text(
                  "Yes",
                  style: AppFontStyle.styleW700(CColor.white,
                      (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.5,constraints) : FontSize.size_12),
                ),
              ),
            ),
          ),
          Expanded(child: Container())
        ],
      ),
    );
  }

  _widgetButtonNOLater(GoalViewController logic,BuildContext context,BoxConstraints constraints,Orientation orientation) {
    return Container(
      margin: EdgeInsets.only(
          bottom: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.0, constraints) :  Sizes.height_1),
      child: InkWell(
        onTap: () {
          logic.gotoBottomNavigationScreen();
        },
        child: Text(
          "Skip",
          style: TextStyle(
              color: CColor.primaryColor,
              fontSize: (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.5,constraints) : FontSize.size_10),
        ),
      ),
    );
  }

  _widgetSetGoalDetails(BoxConstraints constraints,Orientation orientation) {
    return Container(
      margin: EdgeInsets.only(
        top: (kIsWeb) ? 0 :(orientation == Orientation.portrait)?
        Sizes.height_2 : Sizes.height_1,
      ),
      alignment: Alignment.center,
      child: Text(
        "Would you like to set any goals now?",
        textAlign: TextAlign.center,
        style: AppFontStyle.styleW500(
            CColor.black, (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(1.2, constraints) : FontSize.size_10),
      ),
    );
  }

  _widgetIndication(BoxConstraints constraints,Orientation orientation){
    return Container(
      margin: EdgeInsets.only( bottom: (kIsWeb)
          ? AppFontStyle.sizesHeightManageWeb(2.0, constraints)
          :(orientation == Orientation.portrait)? 10.h :AppFontStyle.sizesHeightManageWeb(1.0, constraints),
          top: (kIsWeb)
              ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
              :(orientation == Orientation.portrait)?  20.h :AppFontStyle.sizesHeightManageWeb(0.8, constraints)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<Widget>.generate(
            1,
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
