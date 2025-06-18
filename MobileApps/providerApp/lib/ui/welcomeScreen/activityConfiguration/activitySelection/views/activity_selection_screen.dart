import 'package:banny_table/ui/configuration/datamodel/activity_dataModel.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/configuration/controllers/configuration_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../utils/utils.dart';
import '../controllers/activity_selection_controller.dart';

class ActivitySelectionScreen extends StatelessWidget {
  ConfigurationMainController? configurationMainController;


  ActivitySelectionScreen({ this.configurationMainController,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          useMaterial3: false
      ),
      child: ScreenUtilInit(
        builder: (context, child) {
          return Scaffold(
            backgroundColor: CColor.white,
            appBar:AppBar(
              title: Text( "Activity Selection"),
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
              child: GetBuilder<ActivitySelectionController>(builder: (logic) {
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _widgetMoreDetails(),
                            _widgetAddActivity(context,logic),
                            _widgetConfigurationDetalis(context,logic),
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

  _widgetButtonDetails(ActivitySelectionController logic,BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15.h, left: 8.w, right: 8.w),
      padding: EdgeInsets.only(top: 4.h, bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                configurationMainController!.pageConfigurationController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);

              },
              child: Container(
                padding: EdgeInsets.all((kIsWeb) ? 5:10),
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

  _widgetAddActivity(BuildContext context, ActivitySelectionController logic) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Container()),
              InkWell(
                onTap: () {
                  showDialogForAddNewCode(context, logic);
                },
                child: Container(
                    margin: EdgeInsets.only(right: 20.w),
                    child: const Icon(Icons.add)),
              ),
            ],
          )
        ],
      ),
    );
  }

  _widgetConfigurationDetalis(
      BuildContext context, ActivitySelectionController logic) {
    return Container(
      margin: EdgeInsets.only(top: Sizes.height_1),
      child: ListView.builder(
          padding: EdgeInsets.zero,
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
              bottomSheetConfiguration(
                  context,
                  Constant.configurationInfo[index].iconImage,
                  Constant.configurationInfo[index].title,
                  logic,
                  index);
            });
          }),
    );
  }

  _widgetItemBox(BuildContext context, String title, String images, int index,
      ActivitySelectionController logic, Function callback) {
    return InkWell(
      onTap: () {
        callback("");
      },
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              // top: Sizes.height_1,
                top: (kIsWeb) ? Sizes.height_1 :0,
                bottom:(kIsWeb) ? Sizes.height_1 :0,
                left:  (kIsWeb) ? 5.w :8.w,
                right: (kIsWeb) ? 5.w :8.w),
            decoration: BoxDecoration(
              // color: colors,
              borderRadius: (kIsWeb) ?BorderRadius.circular(2.w):BorderRadius.circular(5).r,
            ),
            padding: EdgeInsets.symmetric(
                horizontal:(kIsWeb) ?4.w : 6.w, vertical: (kIsWeb) ? 7.h:8.h),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: (kIsWeb) ? 2.w :3.w),
                  child: Image.asset(
                    images,
                    width: (kIsWeb) ? 6.w:22.w,
                    height: (kIsWeb) ?6.w:22.w,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left:(kIsWeb) ? 4.w:6.w),
                  child: Text(
                    title,
                    style: AppFontStyle.styleW500(CColor.black,
                        (kIsWeb) ? 5.sp:12.sp),
                  ),
                ),

                ///This Is Use For The I On Insert Menu
                Container(
                  margin: EdgeInsets.only(left:(kIsWeb) ?1.w: Sizes.width_1),
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
                              child: Text(
                                  "This activity in $title details and Above manually On and Off Activity")),
                        ),
                      ];
                    },
                    child: Icon(
                      Icons.info_outline,
                      color: CColor.gray,
                      size: (kIsWeb) ? 5.sp:14.w,
                    ),
                  ),
                ),
                Expanded(child: Container()),
                Container(
                  margin: EdgeInsets.only(right:(kIsWeb) ? 2.w: 4.w),
                  child: itemSelectedBoxEnableMain(
                      Constant.configurationInfo[index].isEnabled,
                      Constant.configurationHeaderEnabled,
                      logic, (value) {
                    Debug.printLog("Switch");
                    logic.onChangeCheckBox(
                        Constant.configurationHeaderEnabled, index);
                  }, index),
                ),
                Icon(
                  Icons.keyboard_arrow_down_outlined,
                  size: (kIsWeb) ? 7.w :15.w,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              // top: Sizes.height_1,
                left: 8.w,
                right: 4.w),
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
      ActivitySelectionController logic, int index) {
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
                    padding: EdgeInsets.only(
                        top: 8.h, bottom: 8.h),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: CColor.white,
                        borderRadius: BorderRadius.only(
                            topRight: const Radius.circular(5).r,
                            topLeft: const Radius.circular(5).r)),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    margin:
                                    EdgeInsets.only(top: 2.h),
                                    child: Image.asset(
                                        images,
                                        width: 35.w,
                                        height:35.w
                                    ),
                                  ),
                                  Container(
                                    margin:
                                    EdgeInsets.only(top: Sizes.height_1),
                                    child: Text(
                                      title,
                                      style: TextStyle(
                                          fontSize: 15.sp,
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
                                margin: EdgeInsets.only(right: 20.w),
                                child: Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  size:
                                  (kIsWeb) ? Sizes.width_2 : Sizes.width_7,
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 8.w,
                              right: 8.w,
                              top: 9.h),
                          decoration: BoxDecoration(
                              color: CColor.primaryColor10,
                              borderRadius:
                              BorderRadius.circular(6).r),
                          padding: EdgeInsets.only(
                              top: 6.h,
                              bottom: 6.h,
                              left:9.w,
                              right: 9.w),
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


  itemSelectedBoxEnableMain(bool valueCheck, String title,
      ActivitySelectionController logic, Function callback, index) {
    return InkWell(
      onTap: () {
        // logic.onChangeCheckBox(Constant.configurationHeaderRest,index);
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



  showDialogForAddNewCode(BuildContext context, ActivitySelectionController logic) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: CColor.white,
          contentPadding: const EdgeInsets.all(0),
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
                      padding: EdgeInsets.all(
                          (kIsWeb) ? Sizes.width_2 : Sizes.width_5),
                      width: (kIsWeb) ? Sizes.width_30 : Get.width * 0.8,
                      // height: (kIsWeb) ?Sizes.height_30:,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: Sizes.height_7,
                                  color: CColor.transparent,
                                  child: TextFormField(
                                    controller: logic.addActivityControllers,
                                    focusNode: logic.addActivityFocus,
                                    textAlign: TextAlign.start,
                                    keyboardType: TextInputType.text,
                                    style: AppFontStyle.styleW500(
                                        CColor.black,
                                        (kIsWeb)
                                            ? FontSize.size_3
                                            : FontSize.size_10),
                                    maxLines: 2,
                                    cursorColor: CColor.black,
                                    decoration: InputDecoration(
                                      hintText: "Enter Activity",
                                      filled: true,
                                      // contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: Sizes.width_5),
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
                              Container(
                                margin: EdgeInsets.only(left: Sizes.width_2),
                                alignment: Alignment.center,
                                child: PopupMenuButton<ActivityImagesModel>(
                                  itemBuilder: (context) => Utils
                                      .activityImagesList
                                      .map(
                                        (e) => PopupMenuItem<
                                        ActivityImagesModel>(
                                        value: e,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                e.imageTitle.toString(),
                                                style: AppFontStyle.styleW400(
                                                    CColor.black,
                                                    (kIsWeb)
                                                        ? FontSize.size_3_5
                                                        : FontSize.size_9),
                                              ),
                                            ),
                                            Image.asset(e.imagesPath,
                                                width: Sizes.width_5,
                                                height: Sizes.height_2),
                                          ],
                                        )),
                                  )
                                      .toList(),
                                  offset: Offset(-Sizes.width_9, 0),
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
                                            logic.selectedIcon!.imagesPath,
                                            width: Sizes.width_5,
                                            height: Sizes.height_2),
                                        const Icon(
                                          Icons.arrow_drop_down_sharp,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: Sizes.height_2),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      Get.back();
                                      logic.addActivityControllers.clear();
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all(
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
                                      padding: const EdgeInsets.all(
                                          (kIsWeb) ? 10 : 5),
                                      child: Text(
                                        "Cancel",
                                        textAlign: TextAlign.center,
                                        style: AppFontStyle.styleW400(
                                            CColor.black,
                                            (kIsWeb)
                                                ? FontSize.size_3
                                                : FontSize.size_12),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: Sizes.width_2),
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      logic.addNewActivity(
                                          logic.addActivityControllers.text,
                                          logic.selectedIcon!.imagesPath);
                                      /*logic.addNotesData(logic.notesController.text,isEditNote,index).then((value) => {
                                      logic.notesController.clear(),
                                    });*/
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all(
                                          CColor.primaryColor),
                                      elevation: MaterialStateProperty.all(1),
                                      shadowColor: MaterialStateProperty.all(
                                          CColor.gray),
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
                                      padding: const EdgeInsets.all(
                                          (kIsWeb) ? 10 : 5),
                                      child: Text(
                                        "Add",
                                        textAlign: TextAlign.center,
                                        style: AppFontStyle.styleW400(
                                            CColor.white,
                                            (kIsWeb)
                                                ? FontSize.size_3
                                                : FontSize.size_12),
                                      ),
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
    );
  }


  itemSelectedBox(bool valueCheck, String title, setState,
      ActivitySelectionController logic, Function callback, index) {
    return Container(
      padding: EdgeInsets.only(top: 7.h, bottom: 7.h),
      child: Row(
        children: [
          Expanded(
            child: Text(title),
          ),
          InkWell(
            onTap: () {
              setState(() {
                // logic.onChangeCheckBox(Constant.configurationHeaderRest,index);
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
                color: valueCheck ? CColor.primaryColor : const Color(0xFFDCDCDC),
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

}
