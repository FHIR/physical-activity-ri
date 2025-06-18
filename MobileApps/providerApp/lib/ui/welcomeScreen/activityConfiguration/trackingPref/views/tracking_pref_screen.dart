import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/configuration/controllers/configuration_controller.dart';
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
import '../controllers/tracking_pref_controller.dart';

class TrackingPrefScreen extends StatelessWidget {
  ConfigurationMainController? configurationMainController;

  TrackingPrefScreen({this.configurationMainController,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // patientUserListController.context = context;

    return Theme(
      data: ThemeData(
          useMaterial3: false
      ),
      child: ScreenUtilInit(
        builder: (context, child) {
          return Scaffold(
            backgroundColor: CColor.white,
            appBar : AppBar(
              title: Text( "Tracking Preference"),
              leading: IconButton(
                onPressed: () {
                  configurationMainController!.pageConfigurationController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                  Debug.printLog("------back");
                },
                icon: Icon(Icons.arrow_back),
              ),
              backgroundColor: CColor.primaryColor,
            ),
            body: SafeArea(
              child: GetBuilder<TrackingPrefController>(builder: (logic) {
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _widgetMoreDetails(),
                            _widgetActivityManage(context, logic),
                          ],
                        ),
                      ),
                    ),
                    _widgetButtonDetails(logic,context)
                  ],
                );
              }),
            ),
          );
        },
      ),
    );
  }

  _widgetActivityManage(BuildContext context, TrackingPrefController logic) {
    return Container(
      margin: EdgeInsets.only(
        left: (kIsWeb) ? 15.w : 10.w,
        right: (kIsWeb) ? 15.w : 10.w,
        top: (kIsWeb) ? 30.h : 0,
      ),
      child: Column(
        children: [
          Container(
            margin:
                EdgeInsets.only(left: 9.w, right: 10.w, top: 3.h, bottom: 3.h),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(right: 5.w),
                  child: PopupMenuButton(
                    elevation: 0,
                    constraints: BoxConstraints(
                        minWidth: Get.width * 0.1, maxWidth: Get.width * 0.6),
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(0),
                    position: PopupMenuPosition.under,
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: CColor.white,
                                  border: Border.all(width: 1.w),
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Text(
                                  "This activity in ${Constant.configurationHeaderTotal} details and Above manually On and Off Activity")),
                        ),
                      ];
                    },
                    child: Icon(Icons.info_outline,
                        color: CColor.gray, size: (kIsWeb) ? 6.sp : 13.sp),
                  ),
                ),
                Expanded(
                  child: Text(
                    Constant.configurationHeaderTotal,
                    style: AppFontStyle.styleW500(
                        CColor.black, (kIsWeb) ? 6.sp : 13.sp),
                  ),
                ),
                Checkbox(
                  value: Constant.isTotal,
                  activeColor: CColor.primaryColor,
                  onChanged: (value) {
                    logic.onChangeActivityManageData(
                        Constant.configurationHeaderTotal);
                  },
                ),
              ],
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(left: 9.w, right: 10.w, top: 3.h, bottom: 3.h),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(right: 5.w),
                  child: PopupMenuButton(
                    elevation: 0,
                    constraints: BoxConstraints(
                        minWidth: Get.width * 0.1, maxWidth: Get.width * 0.6),
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(0),
                    position: PopupMenuPosition.under,
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: CColor.white,
                                  border: Border.all(width: Sizes.width_0_1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Text(
                                  "This activity in ${Constant.configurationHeaderModerate} details and Above manually On and Off Activity")),
                        ),
                      ];
                    },
                    child: Icon(Icons.info_outline,
                        color: CColor.gray, size: (kIsWeb) ? 6.sp : 13.sp),
                  ),
                ),
                Expanded(
                  child: Text(
                    Constant.configurationHeaderModerate,
                    style: AppFontStyle.styleW500(
                        CColor.black, (kIsWeb) ? 6.sp : 13.sp),
                  ),
                ),
                Checkbox(
                  value: Constant.isModerate,
                  activeColor: CColor.primaryColor,
                  onChanged: (value) {
                    logic.onChangeActivityManageData(
                        Constant.configurationHeaderModerate);
                  },
                ),
              ],
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(left: 9.w, right: 10.w, top: 3.h, bottom: 3.h),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(right: 5.w),
                  child: PopupMenuButton(
                    elevation: 0,
                    constraints: BoxConstraints(
                        minWidth: Get.width * 0.1, maxWidth: Get.width * 0.6),
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(0),
                    position: PopupMenuPosition.under,
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: CColor.white,
                                  border: Border.all(width: 1.w),
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Text(
                                  "This activity in ${Constant.configurationHeaderVigorous} details and Above manually On and Off Activity")),
                        ),
                      ];
                    },
                    child: Icon(Icons.info_outline,
                        color: CColor.gray, size: (kIsWeb) ? 6.sp : 13.sp),
                  ),
                ),
                Expanded(
                  child: Text(
                    Constant.configurationHeaderVigorous,
                    style: AppFontStyle.styleW500(
                        CColor.black, (kIsWeb) ? 6.sp : 13.sp),
                  ),
                ),
                Checkbox(
                  value: Constant.isVigorous,
                  activeColor: CColor.primaryColor,
                  onChanged: (value) {
                    logic.onChangeActivityManageData(
                        Constant.configurationHeaderVigorous);
                  },
                ),
              ],
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(left: 9.w, right: 10.w, top: 3.h, bottom: 3.h),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(right: 5.w),
                  child: PopupMenuButton(
                    elevation: 0,
                    constraints: BoxConstraints(
                        minWidth: Get.width * 0.1, maxWidth: Get.width * 0.6),
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(0),
                    position: PopupMenuPosition.under,
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: CColor.white,
                                  border: Border.all(width: Sizes.width_0_1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Text(
                                  "This activity in ${Constant.configurationHeaderDays} details and Above manually On and Off Activity")),
                        ),
                      ];
                    },
                    child: Icon(Icons.info_outline,
                        color: CColor.gray, size: (kIsWeb) ? 6.sp : 13.sp),
                  ),
                ),
                Expanded(
                  child: Text(
                    Constant.configurationHeaderDays,
                    style: AppFontStyle.styleW500(
                      CColor.black,
                      (kIsWeb) ? 6.sp : 13.sp,
                    ),
                  ),
                ),
                Checkbox(
                  value: Constant.isStrengthDay,
                  activeColor: CColor.primaryColor,
                  onChanged: (value) {
                    logic.onChangeActivityManageData(
                        Constant.configurationHeaderDays);
                  },
                ),
              ],
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(left: 9.w, right: 10.w, top: 3.h, bottom: 3.h),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(right: 5.w),
                  child: PopupMenuButton(
                    elevation: 0,
                    constraints: BoxConstraints(
                        minWidth: Get.width * 0.1, maxWidth: Get.width * 0.6),
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(0),
                    position: PopupMenuPosition.under,
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: CColor.white,
                                  border: Border.all(width: 1.w),
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Text(
                                  "This activity in ${Constant.configurationHeaderCalories} details and Above manually On and Off Activity")),
                        ),
                      ];
                    },
                    child: Icon(Icons.info_outline,
                        color: CColor.gray, size: (kIsWeb) ? 6.sp : 13.sp),
                  ),
                ),
                Expanded(
                  child: Text(
                    Constant.configurationHeaderCalories,
                    style: AppFontStyle.styleW500(
                        CColor.black, (kIsWeb) ? 6.sp : 13.sp),
                  ),
                ),
                Checkbox(
                  value: Constant.isCalories,
                  activeColor: CColor.primaryColor,
                  onChanged: (value) {
                    logic.onChangeActivityManageData(
                        Constant.configurationHeaderCalories);
                  },
                ),
              ],
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(left: 9.w, right: 10.w, top: 3.h, bottom: 3.h),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(right: 5.w),
                  child: PopupMenuButton(
                    elevation: 0,
                    constraints: BoxConstraints(
                        minWidth: Get.width * 0.1, maxWidth: Get.width * 0.6),
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(0),
                    position: PopupMenuPosition.under,
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: CColor.white,
                                  border: Border.all(width: 1.w),
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Text(
                                  "This activity in ${Constant.configurationHeaderSteps} details and Above manually On and Off Activity")),
                        ),
                      ];
                    },
                    child: Icon(
                      Icons.info_outline,
                      color: CColor.gray,
                      size: (kIsWeb) ? 6.sp : 13.sp,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    Constant.configurationHeaderSteps,
                    style: AppFontStyle.styleW500(
                        CColor.black, (kIsWeb) ? 6.sp : 13.sp),
                  ),
                ),
                Checkbox(
                  value: Constant.isSteps,
                  activeColor: CColor.primaryColor,
                  onChanged: (value) {
                    logic.onChangeActivityManageData(
                        Constant.configurationHeaderSteps);
                  },
                ),
              ],
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(left: 9.w, right: 10.w, top: 3.h, bottom: 3.h),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(right: 5.w),
                  child: PopupMenuButton(
                    elevation: 0,
                    constraints: BoxConstraints(
                        minWidth: Get.width * 0.1, maxWidth: Get.width * 0.6),
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(0),
                    position: PopupMenuPosition.under,
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: CColor.white,
                                  border: Border.all(width: 1.w),
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Text(
                                  "This activity in ${Constant.configurationHeaderRest} details and Above manually On and Off Activity")),
                        ),
                      ];
                    },
                    child: Icon(Icons.info_outline,
                        color: CColor.gray, size: (kIsWeb) ? 6.sp : 13.sp),
                  ),
                ),
                Expanded(
                  child: Text(
                    Constant.configurationHeaderRest,
                    style: AppFontStyle.styleW500(
                        CColor.black, (kIsWeb) ? 6.sp : 13.sp),
                  ),
                ),
                Checkbox(
                  value: Constant.isRest,
                  activeColor: CColor.primaryColor,
                  onChanged: (value) {
                    logic.onChangeActivityManageData(
                        Constant.configurationHeaderRest);
                  },
                ),
              ],
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(left: 9.w, right: 10.w, top: 3.h, bottom: 3.h),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(right: 5.w),
                  child: PopupMenuButton(
                    elevation: 0,
                    constraints: BoxConstraints(
                        minWidth: Get.width * 0.1, maxWidth: Get.width * 0.6),
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(0),
                    position: PopupMenuPosition.under,
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: CColor.white,
                                  border: Border.all(width: 1.w),
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Text(
                                  "This activity in ${Constant.configurationHeaderPeck} details and Above manually On and Off Activity")),
                        ),
                      ];
                    },
                    child: Icon(Icons.info_outline,
                        color: CColor.gray, size: (kIsWeb) ? 6.sp : 13.sp),
                  ),
                ),
                Expanded(
                  child: Text(
                    Constant.configurationHeaderPeck,
                    style: AppFontStyle.styleW500(
                      CColor.black,
                      (kIsWeb) ? 6.sp : 13.sp,
                    ),
                  ),
                ),
                Checkbox(
                  value: Constant.isPeck,
                  activeColor: CColor.primaryColor,
                  onChanged: (value) {
                    logic.onChangeActivityManageData(
                        Constant.configurationHeaderPeck);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _widgetMoreDetails() {
    return Container(
      margin: EdgeInsets.only(left: 25.w, right: 25.w, top: 20.h),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 1.h,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              Constant.trackingPrefDesc,
              textAlign: TextAlign.start,
              style:
                  AppFontStyle.styleW500(CColor.black, (kIsWeb) ? 6.sp : 13.sp),
            ),
          ),
        ],
      ),
    );
  }

  _widgetButtonDetails(TrackingPrefController logic,BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15.h, left: 8.w, right: 8.w),
      padding: EdgeInsets.only(top: 4.h, bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.goalViewScreen);
              },
              child: Container(
                padding: const EdgeInsets.all((kIsWeb) ? 5:10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: CColor.primaryColor,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: CColor.white)),
                // margin: EdgeInsets.only(right: Sizes.width_2),
                child: Text(
                  "Next",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: CColor.white, fontSize: (kIsWeb) ? Utils.sizesFontManage(context ,3.5) : 13.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
