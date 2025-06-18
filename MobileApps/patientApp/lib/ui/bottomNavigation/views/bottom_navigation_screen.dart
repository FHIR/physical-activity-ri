import 'package:banny_table/ui/bottomNavigation/controllers/bottom_navigation_controller.dart';
import 'package:banny_table/ui/graph/views/graph_screen.dart';
import 'package:banny_table/ui/history/views/history_screen.dart';
import 'package:banny_table/ui/mixed/views/mixed_screen.dart';
import 'package:banny_table/ui/setting/views/setting_screen.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../home/activityLog/views/home_screen.dart';

class BottomNavigationScreen extends StatelessWidget {
  BottomNavigationScreen({Key? key}) : super(key: key);
  BottomNavigationController bottomNavigationController =
      Get.find<BottomNavigationController>();

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            useMaterial3: false
          ),
          child: LayoutBuilder(
            builder: (BuildContext context,BoxConstraints constraints) {
              return GetBuilder<BottomNavigationController>(builder: (logic) {
                return Scaffold(
                    backgroundColor: CColor.white,
                    appBar: AppBar(
                      leading: (logic.bottomSelectedIndex == 0 &&
                              Utils.isSelectMonth())
                          ? IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => {},
                            )
                          : null,
                      backgroundColor: CColor.primaryColor,
                      title: Container(
                        margin: EdgeInsets.only(left: Sizes.width_2),
                        child: Text(
                          logic.getHeaderNameFromIndex(),

                          style: TextStyle(
                          color: CColor.white,
                          // fontSize: 20,
                          fontFamily: Constant.fontFamilyPoppins,
                        ),
                        ),
                      ),
                      actions: [
                        if (Utils.getAPIEndPoint() != "")
                          GestureDetector(
                            onTap: () async {
                              logic.getServerListData();
                              showDialogForChooseUser(logic, context,constraints);
                              Debug.printLog("Goto patientProfileScreen .........");
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                      top: (kIsWeb) ? 1 : 5,
                                      bottom: (kIsWeb) ? 1 : 5,
                                      right: 5)
                                  .w,
                              padding: const EdgeInsets.only(left: 10, right: 10).w,
                              child: Icon(
                                Icons.person_pin,
                                size: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(2.5, constraints) : (orientation == Orientation.portrait)?29.sp : AppFontStyle.sizesFontManageWeb(3.0, constraints),
                              ),
                            ),
                          ),
                        /*Constant.listOfMeaSure.isNotEmpty &&*/ logic.bottomSelectedIndex == 2 && Utils.timeFrame.isNotEmpty
                            ? PopupMenuButton<String>(
                                itemBuilder: (context) {
                                  return Utils.timeFrame.map((String timeFrame) {
                                    return PopupMenuItem(
                                      value: timeFrame,
                                      // row has two child icon and text
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(timeFrame,style: TextStyle(
                                              color: (timeFrame == Constant.selectedTimeFrame)?CColor.primaryColor:CColor.black
                                          ),)
                                        ],
                                      ),
                                    );
                                  }).toList();
                                },
                                padding: EdgeInsets.zero,
                                tooltip: "Time",
                                offset: const Offset(5, 6),
                                color: Colors.white,
                                elevation: 5,
                                onSelected: (values) {
                                  logic.selectedTimeFrameGraph(values);
                                },
                              )
                             /*PopupMenuButton<String>(
                                itemBuilder: (context) => [
                                  _widgetMenuItem(Constant.frameLastWeek),
                                  _widgetMenuItem(Constant.frame4Weeks),
                                  _widgetMenuItem(Constant.frame3Months),
                                  _widgetMenuItem(Constant.frame6Months),
                                  _widgetMenuItem(Constant.frame1Year),
                                  _widgetMenuItem(Constant.frameLifeTime),
                                ],
                                padding: EdgeInsets.zero,
                                tooltip: "Time",
                                offset: const Offset(5, 6),
                                color: Colors.white,
                                elevation: 5,
                                onSelected: (values) {
                                  logic.selectedTimeFrameGraph(values);
                                },
                              )*/
                            : Container(),
                      ],
                    ),
                    body: Column(
                      children: [
                        Expanded(
                          child: PageView(
                            allowImplicitScrolling: false,
                            onPageChanged: (value) {
                              Debug.printLog(
                                  "onPageChanged......${value.toString()}");
                            },
                            controller: bottomNavigationController.pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            children: <Widget>[
                              HomeScreen(
                                  bottomNavigationController:
                                      bottomNavigationController),
                              HistoryScreen(),
                              GraphScreen(
                                  bottomNavigationController:
                                      bottomNavigationController,),
                              const MixedScreen(),
                              SettingScreen(bottomNavigationController: bottomNavigationController),
                            ],
                          ),
                        ),
                        _widgetBottomBar()
                      ],
                    ));
              });
            }
          ),
        );
      },
    );
  }

  _widgetMenuItem(values) {
    return PopupMenuItem(
      value: values,
      // row has two child icon and text
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          Text(values,style: TextStyle(
              color: (values == Constant.selectedTimeFrame)?CColor.primaryColor:CColor.black
          ),)
        ],
      ),
    );
  }

  void showDialogForChooseUser(
      BottomNavigationController logic, BuildContext context,BoxConstraints constraints) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setStateDialogForChooseCode) {
            return AlertDialog(
              backgroundColor: CColor.white,
              contentPadding: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
              content: SingleChildScrollView(
                child: Container(
                  width: Get.width * 0.8,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                      color: CColor.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 5.h),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 5.w),
                                child: const Icon(
                                  Icons.close,
                                  color: CColor.red,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "Patient profile",
                                  style: AppFontStyle.styleW700(
                                      CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.6, constraints) : 14.sp),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      if (logic.selectedData != null && logic.selectedData!.patientId != "")
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 7.h,
                            ),
                            width: double.infinity,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding:
                                      EdgeInsets.all((kIsWeb) ? 5.w : 10.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10).r,
                                    color: CColor.primaryColor30,
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    color: CColor.primaryColor,
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                  margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints) : 14.w),
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      (logic.selectedData!.patientFName
                                                      .toString() !=
                                                  "" &&
                                              logic.selectedData!.patientFName
                                                      .toString() !=
                                                  "null" &&
                                              logic.selectedData!.patientFName
                                                      .toString() !=
                                                  "Null")
                                          ? RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: logic.selectedData!
                                                        .patientFName,
                                                    style:
                                                        AppFontStyle.styleW700(
                                                            CColor.black,
                                                            (kIsWeb)
                                                                ? AppFontStyle.sizesFontManageWeb(1.5, constraints)
                                                                : 12.sp),
                                                  ),
                                                  if(logic.selectedData!.patientLName
                                                      .toString() !=
                                                      "" &&
                                                      logic.selectedData!.patientLName
                                                          .toString() !=
                                                          "null" &&
                                                      logic.selectedData!.patientLName
                                                          .toString() !=
                                                          "Null")TextSpan(
                                                    text: logic.selectedData!
                                                        .patientLName,
                                                    style:
                                                    AppFontStyle.styleW700(
                                                        CColor.black,
                                                        (kIsWeb)
                                                            ? AppFontStyle.sizesFontManageWeb(1.5, constraints)
                                                            : 12.sp),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      (logic.selectedData!.patientDOB
                                                      .toString() !=
                                                  "" &&
                                              logic.selectedData!.patientDOB
                                                      .toString() !=
                                                  "null" &&
                                              logic.selectedData!.patientDOB
                                                      .toString() !=
                                                  "Null")
                                          ? RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: Utils.checkDate(logic
                                                        .selectedData!
                                                        .patientDOB
                                                        .toString()),
                                                    style:
                                                        AppFontStyle.styleW600(
                                                            CColor.gray,
                                                            (kIsWeb)
                                                                ? AppFontStyle.sizesFontManageWeb(1.3, constraints)
                                                                : 12.sp),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      (logic.selectedData!.patientGender
                                                      .toString() !=
                                                  "" &&
                                              logic.selectedData!.patientGender
                                                      .toString() !=
                                                  "null" &&
                                              logic.selectedData!.patientGender
                                                      .toString() !=
                                                  "Null")
                                          ? RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: logic.selectedData!
                                                        .patientGender
                                                        .toString(),
                                                    style:
                                                        AppFontStyle.styleW600(
                                                            CColor.gray,
                                                            (kIsWeb)
                                                                ? AppFontStyle.sizesFontManageWeb(1.3, constraints)
                                                                : 12.sp),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                )),
                              ],
                            )),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  _widgetBottomBar() {
    return GetBuilder<BottomNavigationController>(builder: (logic) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: Sizes.height_2_5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(Sizes.width_3),
            topLeft: Radius.circular(Sizes.width_3),
          ),
          color: CColor.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 1,
              spreadRadius: 1,
            )
          ],
        ),
        child: Row(
          children: [
            _itemBar(
                Icon(
                  Icons.home,
                  color: (logic.bottomSelectedIndex == 0)
                      ? CColor.primaryColor
                      : CColor.black,
                ), (val) {
              logic.onPageChanged(0);
            }),
            _itemBar(
                Icon(
                  Icons.history,
                  color: (logic.bottomSelectedIndex == 1)
                      ? CColor.primaryColor
                      : CColor.black,
                ), (val) {
              logic.onPageChanged(1);
            }),
            _itemBar(
                Icon(
                  Icons.bar_chart,
                  color: (logic.bottomSelectedIndex == 2)
                      ? CColor.primaryColor
                      : CColor.black,
                ), (val) {
              logic.onPageChanged(2);
            }),
            _itemBar(
                Icon(
                  Icons.all_inbox_sharp,
                  color: (logic.bottomSelectedIndex == 3)
                      ? CColor.primaryColor
                      : CColor.black,
                ), (val) {
              logic.onPageChanged(3);
            }),
            _itemBar(
                Icon(
                  Icons.settings,
                  color: (logic.bottomSelectedIndex == 4)
                      ? CColor.primaryColor
                      : CColor.black,
                ), (val) {
              logic.onPageChanged(4);
            }),
          ],
        ),
      );
    });
  }

  _itemBar(Icon icons, Function callBack) {
    return Expanded(
      child: InkWell(
        onTap: () {
          callBack.call("");
        },
        child: Container(
          child: icons,
        ),
      ),
    );
  }
}
