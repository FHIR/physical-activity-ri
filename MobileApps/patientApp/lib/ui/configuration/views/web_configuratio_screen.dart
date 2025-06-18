import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/ui/configuration/controllers/configuration_controllers.dart';
import 'package:banny_table/ui/configuration/datamodel/activity_dataModel.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/sizer_utils.dart';
import '../../../healthData/getWorkOutDataModel.dart';

class WebConfigurationScreen extends StatelessWidget {
  const WebConfigurationScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetBuilder<ConfigurationController>(builder: (logic) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                backgroundColor: CColor.primaryColor,
                onPressed: () {
                  logic.onChangeEditable(false);
                  logic.addFirstData();
                  showDialogForAddNewCode(context, logic,false,"","","",-1);
                }),
            body: SafeArea(
                child: LayoutBuilder(
                  builder: (BuildContext context,BoxConstraints constraints) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              (logic.isSkipTab) ? _widgetBackButton() : Container(),
                              _widgetActivityGeneralAbove(context,constraints),
                              _widgetActivityManage(context, logic,constraints),
                              _widgetAddActivity(context, logic,constraints),
                              Container(
                                child: _widgetConfigurationDetalis(
                                    context, logic,constraints),
                              ),
                              _widgetButtonDetails(logic,constraints),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                ),
            ),
          );
        });
      },
    );
  }

  _widgetBackButton() {
    return Container(
      margin: EdgeInsets.only(top: 6.h, bottom: 4.h),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                left: 8.w,
                right: 8.w,
              ),
              child: Image.asset(
                Constant.leftArrowIcons,
                height: 8.w,
                width: 8.w,
              ),
            ),
          ),
          Expanded(
            child: Text(
              Constant.headerConfigurationScreen,
              maxLines: 2,
              style: AppFontStyle.styleW600(CColor.black, 8.sp),
            ),
          ),
          InkWell(
            onTap: () {
              Get.toNamed(AppRoutes.goalViewScreen);
            },
            child: Container(
              margin: EdgeInsets.only(right: 12.w),
              child: Text(
                "Skip",
                style: AppFontStyle.styleW600(CColor.primaryColor, 8.sp),
              ),
            ),
          )
        ],
      ),
    );
  }

  _widgetActivityGeneralAbove(BuildContext context,BoxConstraints constraints) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: CColor.primaryColor30,
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: AppFontStyle.sizesHeightManageWeb( 0.7,constraints), bottom: AppFontStyle.sizesHeightManageWeb( 0.7,constraints), left: AppFontStyle.sizesWidthManageWeb(1.0,constraints)),
                  child: Text("General",
                      style: AppFontStyle.styleW700(Colors.black, AppFontStyle.sizesFontManageWeb(1.5,constraints))),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  /*_widgetActivityManage(BuildContext context, ConfigurationController logic) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
              left: 8.w,
              right: 8.w,
              top: Sizes.height_1_5,
              bottom: Sizes.height_1_5),
          child: Row(
            children: [
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(right: 2.w),
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
                            padding: const EdgeInsets.all(3).w,
                            decoration: BoxDecoration(
                                color: CColor.white,
                                border: Border.all(width: 1.h),
                                borderRadius: BorderRadius
                                    .circular(8)
                                    .r),
                            child: const Text(
                                "This activity in ${Constant
                                    .configurationHeaderTotal} details and Above manually On and Off Activity")),
                      ),
                    ];
                  },
                  child:
                  Icon(Icons.info_outline, color: CColor.gray, size: 5.sp),
                ),
              ),
              Expanded(
                child: Text(
                  Constant.configurationHeaderTotal,
                  style: AppFontStyle.styleW400(CColor.black, 4.7.sp),
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
              const Expanded(child: SizedBox()),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(right: 2.w),
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
                            padding: const EdgeInsets.all(3).w,
                            decoration: BoxDecoration(
                                color: CColor.white,
                                border: Border.all(width: 1.h),
                                borderRadius: BorderRadius
                                    .circular(10)
                                    .r),
                            child: const Text(
                                "This activity in ${Constant
                                    .configurationHeaderModerate} details and Above manually On and Off Activity")),
                      ),
                    ];
                  },
                  child:
                  Icon(Icons.info_outline, color: CColor.gray, size: 5.sp),
                ),
              ),
              Expanded(
                child: Text(
                  Constant.configurationHeaderModerate,
                  style: AppFontStyle.styleW400(CColor.black, 4.7.sp),
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
          margin: EdgeInsets.only(
              left: 8.w,
              right: 8.w,
              top: Sizes.height_1_5,
              bottom: Sizes.height_1_5),
          child: Row(
            children: [
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(right: 2.w),
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
                            padding: const EdgeInsets.all(3).w,
                            decoration: BoxDecoration(
                                color: CColor.white,
                                border: Border.all(width: 1.h),
                                borderRadius: BorderRadius
                                    .circular(8)
                                    .r),
                            child: const Text(
                                "This activity in ${Constant
                                    .configurationHeaderVigorous} details and Above manually On and Off Activity")),
                      ),
                    ];
                  },
                  child:
                  Icon(Icons.info_outline, color: CColor.gray, size: 5.sp),
                ),
              ),
              Expanded(
                child: Text(
                  Constant.configurationHeaderVigorous,
                  style: AppFontStyle.styleW400(CColor.black, 4.7.sp),
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
              const Expanded(child: SizedBox()),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(right: 2.w),
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
                            padding: const EdgeInsets.all(3).w,
                            decoration: BoxDecoration(
                                color: CColor.white,
                                border: Border.all(width: 1.h),
                                borderRadius: BorderRadius
                                    .circular(10)
                                    .r),
                            child: const Text(
                                "This activity in ${Constant
                                    .configurationHeaderDays} details and Above manually On and Off Activity")),
                      ),
                    ];
                  },
                  child:
                  Icon(Icons.info_outline, color: CColor.gray, size: 5.sp),
                ),
              ),
              Expanded(
                child: Text(
                  Constant.configurationHeaderDays,
                  style: AppFontStyle.styleW400(CColor.black, 4.7.sp),
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
          margin: EdgeInsets.only(
              left: 8.w,
              right: 8.w,
              top: Sizes.height_1_5,
              bottom: Sizes.height_1_5),
          child: Row(
            children: [
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(right: 2.w),
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
                            padding: const EdgeInsets.all(3).w,
                            decoration: BoxDecoration(
                                color: CColor.white,
                                border: Border.all(width: 1.h),
                                borderRadius: BorderRadius
                                    .circular(8)
                                    .r),
                            child: const Text(
                                "This activity in ${Constant
                                    .configurationHeaderCalories} details and Above manually On and Off Activity")),
                      ),
                    ];
                  },
                  child:
                  Icon(Icons.info_outline, color: CColor.gray, size: 5.sp),
                ),
              ),
              Expanded(
                child: Text(
                  Constant.configurationHeaderCalories,
                  style: AppFontStyle.styleW400(CColor.black, 4.7.sp),
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
              const Expanded(child: SizedBox()),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(right: 2.w),
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
                            padding: const EdgeInsets.all(3).w,
                            decoration: BoxDecoration(
                                color: CColor.white,
                                border: Border.all(width: 1.h),
                                borderRadius: BorderRadius
                                    .circular(10)
                                    .r),
                            child: const Text(
                                "This activity in ${Constant
                                    .configurationHeaderSteps} details and Above manually On and Off Activity")),
                      ),
                    ];
                  },
                  child:
                  Icon(Icons.info_outline, color: CColor.gray, size: 5.sp),
                ),
              ),
              Expanded(
                child: Text(
                  Constant.configurationHeaderSteps,
                  style: AppFontStyle.styleW400(
                    CColor.black,
                    4.7.sp,
                  ),
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
          margin: EdgeInsets.only(
              left: 8.w,
              right: 8.w,
              top: Sizes.height_1_5,
              bottom: Sizes.height_1_5),
          child: Row(
            children: [
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(right: 2.w),
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
                            padding: const EdgeInsets.all(3).w,
                            decoration: BoxDecoration(
                                color: CColor.white,
                                border: Border.all(width: 1.h),
                                borderRadius: BorderRadius
                                    .circular(8)
                                    .r),
                            child: const Text(
                                "This activity in ${Constant
                                    .configurationHeaderRest} details and Above manually On and Off Activity")),
                      ),
                    ];
                  },
                  child:
                  Icon(Icons.info_outline, color: CColor.gray, size: 5.sp),
                ),
              ),
              Expanded(
                child: Text(
                  Constant.configurationHeaderRest,
                  style: AppFontStyle.styleW400(CColor.black, 4.7.sp),
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
              const Expanded(child: SizedBox()),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(right: 2.w),
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
                            padding: const EdgeInsets.all(3).w,
                            decoration: BoxDecoration(
                                color: CColor.white,
                                border: Border.all(width: Sizes.width_0_1),
                                borderRadius: BorderRadius
                                    .circular(10)
                                    .r),
                            child: const Text(
                                "This activity in ${Constant
                                    .configurationHeaderPeck} details and Above manually On and Off Activity")),
                      ),
                    ];
                  },
                  child:
                  Icon(Icons.info_outline, color: CColor.gray, size: 5.sp),
                ),
              ),
              Expanded(
                child: Text(
                  Constant.configurationHeaderPeck,
                  style: AppFontStyle.styleW400(CColor.black, 4.7.sp),
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
        Container(
          margin: EdgeInsets.only(
              left: 8.w,
              right: 8.w,
              top: Sizes.height_1_5,
              bottom: Sizes.height_1_5),
          child: Row(
            children: [
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(right: 2.w),
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
                            padding: const EdgeInsets.all(3).w,
                            decoration: BoxDecoration(
                                color: CColor.white,
                                border: Border.all(width: 1.h),
                                borderRadius: BorderRadius
                                    .circular(8)
                                    .r),
                            child: const Text(
                                "This activity in ${Constant
                                    .configurationExperience} details and Above manually On and Off Activity")),
                      ),
                    ];
                  },
                  child:
                  Icon(Icons.info_outline, color: CColor.gray, size: 5.sp),
                ),
              ),
              Expanded(
                child: Text(
                  Constant.configurationExperience,
                  style: AppFontStyle.styleW400(CColor.black, 4.7.sp),
                ),
              ),
              Checkbox(
                value: Constant.isExperience,
                activeColor: CColor.primaryColor,
                onChanged: (value) {
                  logic.onChangeActivityManageData(
                      Constant.configurationExperience);
                },
              ),
              const Expanded(child: SizedBox()),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(right: 2.w),
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
                            padding: const EdgeInsets.all(3).w,
                            decoration: BoxDecoration(
                                color: CColor.white,
                                border: Border.all(width: Sizes.width_0_1),
                                borderRadius: BorderRadius
                                    .circular(10)
                                    .r),
                            child: const Text(
                                "This activity in ${Constant
                                    .configurationNotes} details and Above manually On and Off Activity")),
                      ),
                    ];
                  },
                  child:
                  Icon(Icons.info_outline, color: CColor.gray, size: 5.sp),
                ),
              ),
              Expanded(
                child: Text(
                  Constant.configurationNotes,
                  style: AppFontStyle.styleW400(CColor.black, 4.7.sp),
                ),
              ),
              Checkbox(
                value: Constant.isNotes,
                activeColor: CColor.primaryColor,
                onChanged: (value) {
                  logic.onChangeActivityManageData(
                      Constant.configurationNotes);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }*/

  _widgetActivityManage(BuildContext context, ConfigurationController logic,BoxConstraints constraints) {
    return (logic.trackingPrefList.isNotEmpty)?
    Container(
        margin: EdgeInsets.only(
          left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0,constraints) : 10.w,
          right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.5,constraints) : 10.w,
          top: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.2,constraints) : 0,
        ),
        child: ReorderableListView(
          // buildDefaultDragHandles: false,
          onReorder: logic.onReorder,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          // dragStartBehavior:DragStartBehavior.down,
          children: buildListItems(logic,context,constraints),
        )):Container();
  }

  List<Widget> buildListItems(ConfigurationController logic,BuildContext context,BoxConstraints constraints) {
    return logic.trackingPrefList
        .map((item) => Container(
      key: ValueKey(item),
      margin: EdgeInsets.only(
                  left: AppFontStyle.sizesWidthManageWeb(0.6,constraints),
                  right: AppFontStyle.sizesWidthManageWeb(1.5,constraints),
                  top: AppFontStyle.sizesHeightManageWeb( 0.5,constraints),
                  bottom: AppFontStyle.sizesHeightManageWeb( 0.5,constraints)),
              child: Row(
        children: [
          // const Icon(Icons.menu),
          Container(
            margin: EdgeInsets.only(left: AppFontStyle.sizesHeightManageWeb(1.0, constraints)),
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
                            border: Border.all(width: 0.4.w),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                            (item.titleName == Constant.configurationHeaderTotal) ? Constant.configurationHeaderToolTipTotal.toString()
                                :(item.titleName == Constant.configurationHeaderModerate) ? Constant.configurationHeaderToolTipModMin.toString()
                                :(item.titleName == Constant.configurationHeaderVigorous) ? Constant.configurationHeaderToolTipVigMin.toString()
                                :(item.titleName == Constant.configurationNotes) ? Constant.configurationHeaderToolTipNotes.toString()
                                :(item.titleName == Constant.configurationHeaderDays) ? Constant.configurationHeaderToolTipStrengthDays.toString()
                                :(item.titleName == Constant.configurationHeaderCalories) ? Constant.configurationHeaderToolTipCalories.toString()
                                :(item.titleName == Constant.configurationHeaderSteps) ? Constant.configurationHeaderToolTipSteps.toString()
                                :(item.titleName == Constant.configurationHeaderRest) ? Constant.configurationHeaderToolTipTotal.toString()
                                :(item.titleName == Constant.configurationHeaderToolTipRestingHeart) ? Constant.configurationHeaderToolTipTotal.toString()
                                :(item.titleName == Constant.configurationHeaderPeck) ? Constant.configurationHeaderToolTipPeckHeart.toString()
                                :(item.titleName == Constant.configurationExperience) ? Constant.configurationHeaderToolTipExperience.toString()
                                : ""



                        )),
                  ),
                ];
              },
              child: Text(
                item.titleName,
                style: AppFontStyle.styleW500(
                  CColor.black,
                  (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2,constraints) : 13.sp,
                ),
              ),
            ),
          ),
          // Container(
          //   alignment: Alignment.topLeft,
          //   margin: EdgeInsets.only(left: AppFontStyle.sizesWidthManageWeb(1.0, constraints)),
          //   child: PopupMenuButton(
          //     elevation: 0,
          //     constraints: BoxConstraints(
          //         minWidth: Get.width * 0.1, maxWidth: Get.width * 0.6),
          //     color: Colors.transparent,
          //     padding: const EdgeInsets.all(0),
          //     position: PopupMenuPosition.under,
          //     itemBuilder: (context) {
          //       return [
          //         PopupMenuItem(
          //           child: Container(
          //               padding: const EdgeInsets.all(8),
          //               decoration: BoxDecoration(
          //                   color: CColor.white,
          //                   border: Border.all(width: 1.w),
          //                   borderRadius: BorderRadius.circular(10)),
          //               child: Text(
          //                   "This activity in ${item.titleName} details and Above manually On and Off Activity")),
          //         ),
          //       ];
          //     },
          //     child: Icon(Icons.info_outline,
          //         color: CColor.gray, size: (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.5,constraints) : 13.sp),
          //   ),
          // ),
          const Spacer(),
          Container(
            margin: EdgeInsets.only(
              right: AppFontStyle.sizesWidthManageWeb( 2.0,constraints)
            ),
            child: Checkbox(
              value: item.isSelected,
              activeColor: CColor.primaryColor,
              onChanged: (value) {
                logic.onChangeActivityManageData(
                    item.titleName,item: item);
              },
            ),
          ),
        ],
      ),
    ))
        .toList();
  }


  _widgetAddActivity(BuildContext context, ConfigurationController logic,BoxConstraints constraints) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: CColor.primaryColor30,
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: AppFontStyle.sizesHeightManageWeb( 0.7,constraints), bottom: AppFontStyle.sizesHeightManageWeb( 0.7,constraints), left: AppFontStyle.sizesWidthManageWeb(1.0,constraints)),
                  child: Text("Activity",
                      style: AppFontStyle.styleW700(Colors.black, AppFontStyle.sizesFontManageWeb(1.5,constraints))),
                ),
              ),
              /*InkWell(
                onTap: () {
                  showDialogForAddNewCode(context, logic);
                },
                child: Container(
                    margin: EdgeInsets.only(right: AppFontStyle.sizesWidthManageWeb(2.0, constraints)),
                    child: const Icon(Icons.add)),
              ),*/
            ],
          ),
        )
      ],
    );
  }

  _widgetConfigurationDetalis(BuildContext context,
      ConfigurationController logic,BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(top: AppFontStyle.sizesHeightManageWeb(0.5, constraints)),
      child: ListView.builder(
          padding: EdgeInsets.only(
            bottom: AppFontStyle.sizesHeightManageWeb(7.0,constraints)
          ),
          itemCount: Constant.configurationInfo.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _widgetItemBox(
                context,
                Constant.configurationInfo[index].title,
                Constant.configurationInfo[index].iconImage,
                index,
                logic, (value) {
              Debug.printLog("Tap");
              if(value == "") {
                bottomSheetConfiguration(
                    context,
                    Constant.configurationInfo[index].iconImage,
                    Constant.configurationInfo[index].title,
                    logic,
                    index,constraints);
              }
              else{
                HealthWorkoutActivityType dataType = HealthWorkoutActivityType.OTHER;
                var getTypeFromName = Utils.getWorkoutDataList.where((element) =>
                element.workOutDataName == Constant.configurationInfo[index].title).toList();
                if(getTypeFromName.isNotEmpty){
                  dataType = getTypeFromName[0].datatype;
                }
                logic.selectedIcon = WorkOutData(workOutDataName: Constant.configurationInfo[index].title,
                    workOutDataImages: Constant.configurationInfo[index].iconImage, datatype: dataType,workOutDataCode:Constant.configurationInfo[index].activityCode
                );

                logic.addActivityControllers.text = Constant.configurationInfo[index].title;
                logic.addActivityCodeControllers.text = Constant.configurationInfo[index].activityCode;
                if(Constant.configurationInfo[index].activityCode != ""){
                  logic.onChangeEditable(true);
                }else{
                  logic.onChangeEditable(false);
                }
                showDialogForAddNewCode(context, logic,true,
                    Constant.configurationInfo[index].title,
                    Constant.configurationInfo[index].activityCode,
                    Constant.configurationInfo[index].iconImage,index);
              }
            },constraints);
          }),
    );
  }

  _widgetItemBox(BuildContext context, String title, String images, int index,
      ConfigurationController logic, Function callback,BoxConstraints constraints) {
    return InkWell(
      onTap: () {
        callback("");
      },
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
                left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0,constraints) : 10.w,
                right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.5,constraints) : 10.w,
                top: Sizes.height_1,
                bottom: Sizes.height_1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.w),
            ),
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 7.h),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 2.w),
                  child: Image.asset(
                    images,
                    width: AppFontStyle.sizesFontManageWeb(1.5,constraints),
                    height: AppFontStyle.sizesFontManageWeb(1.5,constraints),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: AppFontStyle.sizesWidthManageWeb(1.0, constraints)),
                  child: Text(
                    title,
                    style: AppFontStyle.styleW400(CColor.black, AppFontStyle.sizesFontManageWeb(1.4,constraints)),
                  ),
                ),

                ///This Is Use For The I On Insert Menu
                // Container(
                //   margin: EdgeInsets.only(left: AppFontStyle.sizesWidthManageWeb(1.0, constraints)),
                //   child: PopupMenuButton(
                //     elevation: 0,
                //     constraints: BoxConstraints(
                //         minWidth: Get.width * 0.1, maxWidth: Get.width * 0.6),
                //     color: Colors.transparent,
                //     padding: const EdgeInsets.all(0),
                //     position: PopupMenuPosition.under,
                //     itemBuilder: (context) {
                //       return [
                //         PopupMenuItem(
                //           child: Container(
                //               padding: const EdgeInsets.all(8),
                //               decoration: BoxDecoration(
                //                   color: CColor.white,
                //                   border: Border.all(width: Sizes.width_0_1),
                //                   borderRadius: BorderRadius.circular(10)),
                //               child: Text(
                //                   "This activity in $title details and Above manually On and Off Activity")),
                //         ),
                //       ];
                //     },
                //     child: Icon(Icons.info_outline,
                //         color: CColor.gray, size:  AppFontStyle.sizesFontManageWeb(1.5,constraints)),
                //   ),
                // ),
                Expanded(child: Container()),
                Container(
                  margin: EdgeInsets.only(right: 2.w),
                  child: itemSelectedBoxEnableMain(
                      Constant.configurationInfo[index].isEnabled,
                      Constant.configurationHeaderEnabled,
                      logic, (value) {
                    Debug.printLog("Switch");
                    logic.onChangeCheckBox(
                        Constant.configurationHeaderEnabled, index);
                  }, index),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical:AppFontStyle.sizesHeightManageWeb(0.2,constraints) ,horizontal: AppFontStyle.sizesWidthManageWeb(1.0, constraints)),
                  child: Icon(
                    Icons.settings,
                    size: AppFontStyle.sizesFontManageWeb(1.5,constraints),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              // top: Sizes.height_1,
                left: 6.w,
                right: 3.w),
            child: const Divider(
              height: 1,
              // color: CColor.black,
            ),
          ),
        ],
      ),
    );
  }

  bottomSheetConfiguration(BuildContext context, String images, String title,
      ConfigurationController logic, int index,BoxConstraints constraints) {
    Future<void> future = showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: CColor.transparent,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return Wrap(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 8.h, bottom: 6.h),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: CColor.white,
                        borderRadius: BorderRadius.only(
                            topRight: const Radius.circular(7).r,
                            topLeft: const Radius.circular(7).r)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 3.h),
                                    child: Image.asset(
                                      images,
                                      width: (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.7, constraints): 10.w,
                                      height: (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.7, constraints) : 10.w,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 2.h),
                                    child: Text(
                                      title,
                                      style: TextStyle(
                                          fontSize: AppFontStyle.sizesFontManageWeb(1.5,constraints),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 8.w),
                                child: Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  size: 5.w,
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin:
                          EdgeInsets.only(left: 6.w, right: 6.w, top: 3.h),
                          decoration: BoxDecoration(
                              color: CColor.primaryColor10,
                              borderRadius: BorderRadius
                                  .circular(5)
                                  .r),
                          padding: EdgeInsets.only(
                              top: 6.h, bottom: 6.h, left: 5.w, right: 5.w),
                          child: Column(
                            children: [
                              itemSelectedBox(
                                  Constant.configurationInfo[index].isTotal,
                                  Constant.configurationHeaderTotal,
                                  setState,
                                  logic, (value) {
                                Debug.printLog("Switch");
                                logic.onChangeCheckBox(
                                    Constant.configurationHeaderTotal, index);
                              }, index),
                              itemSelectedBox(
                                  Constant.configurationInfo[index].isModerate,
                                  Constant.configurationHeaderModerate,
                                  setState,
                                  logic, (value) {
                                Debug.printLog("Switch");
                                logic.onChangeCheckBox(
                                    Constant.configurationHeaderModerate,
                                    index);
                              }, index),
                              itemSelectedBox(
                                  Constant.configurationInfo[index].isVigorous,
                                  Constant.configurationHeaderVigorous,
                                  setState,
                                  logic, (value) {
                                Debug.printLog("Switch");
                                logic.onChangeCheckBox(
                                    Constant.configurationHeaderVigorous,
                                    index);
                              }, index),
                              itemSelectedBox(
                                  Constant.configurationInfo[index].isDaysStr,
                                  Constant.configurationHeaderDays,
                                  setState,
                                  logic, (value) {
                                Debug.printLog("Switch");
                                logic.onChangeCheckBox(
                                    Constant.configurationHeaderDays, index);
                              }, index),
                              itemSelectedBox(
                                  Constant.configurationInfo[index].isCalories,
                                  Constant.configurationHeaderCalories,
                                  setState,
                                  logic, (value) {
                                Debug.printLog("Switch");
                                logic.onChangeCheckBox(
                                    Constant.configurationHeaderCalories,
                                    index);
                              }, index),
                              itemSelectedBox(
                                  Constant.configurationInfo[index].isSteps,
                                  Constant.configurationHeaderSteps,
                                  setState,
                                  logic, (value) {
                                Debug.printLog("Switch");
                                logic.onChangeCheckBox(
                                    Constant.configurationHeaderSteps, index);
                              }, index),
                              itemSelectedBox(
                                  Constant.configurationInfo[index].isRest,
                                  Constant.configurationHeaderRest,
                                  setState,
                                  logic, (value) {
                                Debug.printLog("Switch");
                                logic.onChangeCheckBox(
                                    Constant.configurationHeaderRest, index);
                              }, index),
                              itemSelectedBox(
                                  Constant.configurationInfo[index].isPeck,
                                  Constant.configurationHeaderPeck,
                                  setState,
                                  logic, (value) {
                                Debug.printLog("Switch");
                                logic.onChangeCheckBox(
                                    Constant.configurationHeaderPeck, index);
                              }, index),
                              itemSelectedBox(
                                  Constant.configurationInfo[index]
                                      .isExperience,
                                  Constant.configurationExperience,
                                  setState,
                                  logic, (value) {
                                Debug.printLog("Switch");
                                logic.onChangeCheckBox(
                                    Constant.configurationExperience, index);
                              }, index),
                              itemSelectedBox(
                                  Constant.configurationInfo[index].isNotes,
                                  Constant.configurationNotes,
                                  setState,
                                  logic, (value) {
                                Debug.printLog("Switch");
                                logic.onChangeCheckBox(
                                    Constant.configurationNotes, index);
                              }, index),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        });
    future.then((void value) => {});
  }

  itemSelectedBox(bool valueCheck, String title, setState,
      ConfigurationController logic, Function callback, index) {
    return Container(
      padding: EdgeInsets.only(top: 6.h, bottom: 6.h),
      child: Row(
        children: [
          Expanded(
            child: Text(title),
          ),
          InkWell(
            onTap: () {
              setState(() {
                callback("");
              });
              Debug.printLog("Switch");
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.decelerate,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color:
                valueCheck ? CColor.primaryColor : const Color(0xFFDCDCDC),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                alignment:
                valueCheck ? Alignment.centerRight : Alignment.centerLeft,
                curve: Curves.decelerate,
                child: Padding(
                  padding: const EdgeInsets.all(4.5),
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  itemSelectedBoxEnableMain(bool valueCheck, String title,
      ConfigurationController logic, Function callback, index) {
    return InkWell(
      onTap: () {
        callback("");
        Debug.printLog("Switch");
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.decelerate,
        width: 50,
        height: 25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: valueCheck ? CColor.primaryColor : const Color(0xFFDCDCDC),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 300),
          alignment: valueCheck ? Alignment.centerRight : Alignment.centerLeft,
          curve: Curves.decelerate,
          child: Padding(
            padding: const EdgeInsets.all(4.5),
            child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(100.0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showDialogForAddNewCode(BuildContext context, ConfigurationController logic,bool isEdit,String title,String code,
      String iconImage, int index) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: CColor.white,
          contentPadding: const EdgeInsets.all(0),
          actionsPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, setStateDialog) {
              return Wrap(
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(5).w,
                      width: 100.w,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 2.w),
                                alignment: Alignment.center,
                                child: PopupMenuButton<WorkOutData>(
                                  itemBuilder: (context) =>
                                      Utils
                                          .getWorkoutDataList
                                          .map(
                                            (e) =>
                                            PopupMenuItem<WorkOutData>(
                                                value: e,
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                          e.workOutDataName
                                                              .toString(),
                                                          overflow:
                                                          TextOverflow.ellipsis,
                                                          style: AppFontStyle
                                                              .styleW400(
                                                              CColor.black,
                                                              5.sp),
                                                        )),
                                                    Image.asset(e.workOutDataImages,
                                                        width: 6.w,
                                                        height: 6.w),
                                                  ],
                                                )),
                                      )
                                          .toList(),
                                  offset: Offset(-5.w, 0),
                                  color: Colors.grey[60],
                                  elevation: 2,
                                  onSelected: (value) {
                                    logic.onChangeIcon(value);
                                    setStateDialog(() {});
                                  },
                                  child: SizedBox(
                                    height:
                                    Constant.commonHeightForTableBoxMobile,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                            logic.selectedIcon!.workOutDataImages,
                                            width: 6.w,
                                            height: 6.w),
                                        const Icon(
                                          Icons.arrow_drop_down_sharp,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  // height: 30.w,
                                  color: CColor.transparent,
                                  child: TextFormField(
                                    controller: logic.addActivityControllers,
                                    focusNode: logic.addActivityFocus,
                                    textAlign: TextAlign.start,
                                    keyboardType: TextInputType.text,
                                    style: AppFontStyle.styleW500(
                                        CColor.black, 5.sp),
                                    // maxLines: 2,
                                    cursorColor: CColor.black,
                                    validator: (value) {
                                      setStateDialog((){
                                        logic.validationText(value);
                                      });
                                    },
                                    decoration: InputDecoration(
                                      label: Text("Enter Activity Name"),
                                      error: Visibility(
                                        visible: logic.showError,
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Icon(Icons.error,size: 4.sp,color: CColor.red,),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 1.w
                                                ),
                                                child: Text(logic.valueValidError,style: TextStyle(
                                                    fontSize: 4.sp,
                                                    color: CColor.red
                                                ),),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // errorText: logic.valueValidError,
                                      // error: Icon(Icons.error),
                                      labelStyle: TextStyle(
                                          color: CColor.black
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: CColor.primaryColor,
                                            width: 0.7),
                                        borderRadius:
                                        BorderRadius.circular(15.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: CColor.primaryColor,
                                            width: 0.7),
                                        borderRadius:
                                        BorderRadius.circular(15.0),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: CColor.primaryColor,
                                            width: 0.7),
                                        borderRadius:
                                        BorderRadius.circular(15.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: CColor.primaryColor,
                                            width: 0.7),
                                        borderRadius:
                                        BorderRadius.circular(15.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            // height: 30.w,
                            margin: EdgeInsets.only(top: 4.h),
                            color: CColor.transparent,
                            child: TextFormField(
                              controller: logic.addActivityCodeControllers,
                              focusNode: logic.addActivityCodeFocus,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              style: AppFontStyle.styleW500(
                                  CColor.black, 5.sp),
                              maxLines: 2,
                              readOnly: logic.isEditable,
                              enabled:!logic.isEditable,
                              cursorColor: CColor.black,
                              decoration: InputDecoration(
                                hintText: "Enter Activity Code",
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: CColor.primaryColor,
                                      width: 0.7),
                                  borderRadius:
                                  BorderRadius.circular(15.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: CColor.primaryColor,
                                      width: 0.7),
                                  borderRadius:
                                  BorderRadius.circular(15.0),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: CColor.primaryColor,
                                      width: 0.7),
                                  borderRadius:
                                  BorderRadius.circular(15.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: CColor.primaryColor,
                                      width: 0.7),
                                  borderRadius:
                                  BorderRadius.circular(15.0),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 4.h),
                            child: Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                    logic.addActivityControllers.clear();
                                    logic.addActivityCodeControllers.clear();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        CColor.transparent),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(15.0),
                                        side: const BorderSide(
                                            color: CColor.primaryColor,
                                            width: 0.7),
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4).w,
                                    child: Text(
                                      "Cancel",
                                      textAlign: TextAlign.center,
                                      style: AppFontStyle.styleW400(
                                          CColor.black, 5.sp),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                TextButton(
                                  onPressed: () {
                                    if(isEdit){
                                      logic.updateActivity(index,logic.addActivityControllers.text,
                                          logic.selectedIcon!.workOutDataImages,
                                          logic.addActivityCodeControllers.text);
                                    }else{
                                      logic.addNewActivity(
                                          logic.addActivityControllers.text,
                                          logic.selectedIcon!.workOutDataImages,
                                          logic.addActivityCodeControllers.text);
                                    }
                                    setStateDialog((){});
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        CColor.primaryColor),
                                    elevation: MaterialStateProperty.all(1),
                                    shadowColor:
                                    MaterialStateProperty.all(CColor.gray),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(15.0),
                                        side: const BorderSide(
                                            color: CColor.primaryColor,
                                            width: 0.7),
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4).w,
                                    child: Text(
                                      (isEdit)?"Update":"Add",
                                      textAlign: TextAlign.center,
                                      style: AppFontStyle.styleW400(
                                          CColor.white, 5.sp),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    ).then((value) => {
      logic.valueValidError = "",
      logic.showError = false,
    });
  }

  _widgetButtonDetails(ConfigurationController logic,BoxConstraints constraints) {
    return (logic.isSkipTab)
        ? Container(
      margin: EdgeInsets.only(top: 3.h, left: 7.w, right: 7.w),
      padding: EdgeInsets.only(top: 4.h, bottom: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                logic.saveOpeningDetails();
              },
              child: Container(
                padding: const EdgeInsets.all(3).w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: CColor.primaryColor,
                    borderRadius: BorderRadius
                        .circular(7)
                        .r,
                    border: Border.all(color: CColor.white)),
                margin: EdgeInsets.only(right: 3.w),
                child: Text(
                  "Next",
                  style: TextStyle(color: CColor.white, fontSize: 8.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    )
        : Container();
  }
}
