import 'package:banny_table/ui/welcomeScreen/qrManager/controllers/qr_manager_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
class WebQrManagerScreen extends StatelessWidget {
  const WebQrManagerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // designSize: const Size(700, 600),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return  Scaffold(
          backgroundColor: CColor.white,
          body: SafeArea(
            child: GetBuilder<QrManagerController>(builder: (logic) {
              return _widgetQrManageDetails(context, logic);
            }),
          ),
        );
      },
    );
  }



  _widgetQrManageDetails(BuildContext context, QrManagerController logic) {
    return Container(
      margin: EdgeInsets.only(
          left: 10.w,
          right: 10.w,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _widgetBackButton(logic),
          _widgetQrDetails(logic),
          Expanded(child: Container()),
          _widgetButtonDetails(context),
        ],
      ),
    );
  }


  _widgetQrDetails(QrManagerController logic) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(
        top: 12.h,
      ),
      // width: double.infinity,
      height: 36.w,
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                  right: 4.w,
                  left: 4.w),
              color: CColor.transparent,
              child:  TextFormField(
                  maxLines: 1,
                  controller: logic.qrCodeDetailsController,
                  textAlign: TextAlign.start,
                  focusNode: logic.qrdDetails,
                  keyboardType: TextInputType.text,
                  style: AppFontStyle.styleW500(CColor.black, 8.sp),
                  cursorColor: CColor.black,
                  decoration: InputDecoration(
                    hintText: "Enter a url".tr,
                    filled: true,
                    // contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: Sizes.width_5),
                    border: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: CColor.primaryColor, width: 0.7),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: CColor.primaryColor, width: 0.7),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: CColor.primaryColor, width: 0.7),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: CColor.primaryColor, width: 0.7),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              /*KeyboardActions(
                config: Utils.buildKeyboardActionsConfig(logic.qrdDetails),
                child: TextFormField(
                  maxLines: 1,
                  controller: logic.qrCodeDetailsController,
                  textAlign: TextAlign.start,
                  focusNode: logic.qrdDetails,
                  keyboardType: TextInputType.text,
                  style: AppFontStyle.styleW500(CColor.black, 8.sp),
                  cursorColor: CColor.black,
                  decoration: InputDecoration(
                    hintText: "Enter a url".tr,
                    filled: true,
                    // contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: Sizes.width_5),
                    border: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: CColor.primaryColor, width: 0.7),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: CColor.primaryColor, width: 0.7),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: CColor.primaryColor, width: 0.7),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: CColor.primaryColor, width: 0.7),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),*/
            ),
          ),
        ],
      ),
    );
  }



  _widgetBackButton(QrManagerController logic) {
    return Container(
      margin: EdgeInsets.only(
          top: 10.h
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                  left:2.w,
                  right:8.w,
                  // bottom:Sizes.width_5,
                // top: Sizes.height_1
              ),
              child: Image.asset(
                Constant.leftArrowIcons, height:6.w,
                width:  6.w),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                right:7.w

              ),
              child: Text("Connect to Your Health Provider",
                maxLines: 2,
                style: AppFontStyle.styleW600(CColor.black, 8.sp),),
            ),
          ),
          /*InkWell(
            onTap: () {
              Get.toNamed(AppRoutes.integrationScreen);
            },
            child: Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(right: Sizes.width_2,
                  // left: Sizes.height_1
              ),
              child: Text(
                "Skip",
                style: AppFontStyle.styleW600(
                    CColor.primaryColor, FontSize.size_10),
              ),
            ),
          ),*/
          /*(Preference.shared.getBool(Preference.qrManage) ?? false)*/
          (logic.isFromSetting)
              ? Container()
              : InkWell(
                  onTap: () {
                    logic.gotoSkipTab();
                  },
                  child: Text(
                    "Skip",
                    style: AppFontStyle.styleW600(
                        CColor.primaryColor,8.sp),
                  ),
                )
        ],
      ),
    );
  }


  _widgetButtonDetails(BuildContext context) {
    return GetBuilder<QrManagerController>(builder: (logic) {
      return Container(
        padding: EdgeInsets.only(
            top: 2.h, bottom: 14.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            (!logic.isFromSetting) ?
            Expanded(
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  padding: const EdgeInsets.all(10).h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: CColor.white,
                      borderRadius: BorderRadius.circular(10).r,
                      border: Border.all(
                          color: CColor.primaryColor
                      )
                  ),
                  margin: EdgeInsets.only(
                      right: 2.w
                  ),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        color: CColor.primaryColor,
                        fontSize: Utils.sizesFontManage(context ,3.5)),
                  ),
                ),
              ),
            ) : Container(),
            Expanded(
              child: InkWell(
                onTap: () {
                  logic.callServiceProvider();
                },
                child: Container(
                  padding: const EdgeInsets.all(10).h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: CColor.primaryColor,
                      borderRadius: BorderRadius.circular(10).r,
                      border: Border.all(
                          color: CColor.white
                      )
                  ),
                  margin: EdgeInsets.only(
                      right: 2.w
                  ),
                  child: Text(
                    "Connect",
                    style: TextStyle(
                        color: CColor.white,
                        fontSize:Utils.sizesFontManage(context ,3.5)
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }


}
