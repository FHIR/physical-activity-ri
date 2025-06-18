import 'dart:io';
import 'package:banny_table/healthData/getSetHealthData.dart';
import 'package:banny_table/ui/welcomeScreen/integration/controllers/integration_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

class MobileIntegrationScreen extends StatelessWidget {
  const MobileIntegrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // designSize: const Size(700, 600),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: CColor.white,
          body: SafeArea(
            child: GetBuilder<IntegrationController>(builder: (logic) {
              return _widgetIntegrationDetails(context, logic);
            }),
          ),
        );
      },
    );
  }

  _widgetIntegrationDetails(BuildContext context, IntegrationController logic) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(left: 8.w, right: 8.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // _widgetBackButton(),
                  _widgetTitleDetails(),
                  _widgetMainIcons(),
                  _widgetAboveDetails(),
                  _widgetPermissionDetails(),
                  _widgetImportData(logic),
                  (Utils.getPermissionHealth())?_widgetAskSyncDetails():Container(),
                  /*_widgetButtonDetails(logic),*/
                ],
              ),
            ),
          ),
        ),
        _widgetButtonDetails(logic,context),
      ],
    );
  }

  _widgetBackButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 4).w,
            child:
                Image.asset(Constant.leftArrowIcons, height: 14.w, width: 14.w),
          ),
        ),
        _widgetIcons(),
        InkWell(
          onTap: () {
            Get.toNamed(AppRoutes.configuration, arguments: [true]);
          },
          child: Container(
            margin: EdgeInsets.only(right: 4.w),
            child: Text(
              "Skip",
              style: AppFontStyle.styleW600(CColor.primaryColor, 13.sp),
            ),
          ),
        )
      ],
    );
  }

  _widgetIcons() {
    return Container(
      padding: const EdgeInsets.all(8).w,
      child: Image.asset(
        (Platform.isAndroid)
            ? Constant.settingAndroidImportExportIcons
            : Constant.settingIosImportExportIcons,
        width: 20.w,
        height: 20.w,
      ),
    );
  }

  _widgetTitleDetails() {
    return Container(
      margin: EdgeInsets.only(top: 10.h, bottom: 3.h),
      alignment: Alignment.center,
      child: Text(
        (Platform.isIOS)
            ? "Sync with apple health"
            : "Sync with health connect",
        textAlign: TextAlign.center,
        style: AppFontStyle.styleW700(CColor.black, 16.sp),
      ),
    );
  }

  _widgetMainIcons() {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: const EdgeInsets.all(10).w,
      child: Image.asset(
        Constant.settingHealthConnectIcons,
        height: 100.w,
        width: 100.w,
      ),
    );
  }

  _widgetAboveDetails() {
    return Container(
      margin: EdgeInsets.only(top: 10.h, bottom: 2.h, left: 8.w, right: 8.w),
      alignment: Alignment.centerLeft,
      child: Text(
        (Platform.isIOS) ? Constant.syncDescIos : Constant.syncDescAndroid,
        textAlign: TextAlign.start,
        style: AppFontStyle.styleW600(CColor.black, 14.sp),
      ),
    );
  }

  _widgetPermissionDetails() {
    return Container(
      margin: EdgeInsets.only(
        top: 20.h,
        bottom: 2.h,
        left: 8.w,
        right: 8.w,
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              "Permissions:",
              textAlign: TextAlign.center,
              style: AppFontStyle.styleW600(
                CColor.gray,
                14.sp,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.h),
            alignment: Alignment.center,
            child: Text(
              Constant.syncPermissionReadDetail,
              textAlign: TextAlign.center,
              style: AppFontStyle.styleW600(
                CColor.gray,
                14.sp,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.h),
            alignment: Alignment.center,
            child: Text(
              Constant.syncPermissionWriteDetail,
              textAlign: TextAlign.center,
              style: AppFontStyle.styleW600(
                CColor.gray,
                14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _widgetAskSyncDetails() {
    return Container(
      margin: EdgeInsets.only(top: 20.h, bottom: 2.h, left: 8.w, right: 8.w),
      alignment: Alignment.center,
      child: Text(
        Constant.syncConfirmAndroidIos,
        textAlign: TextAlign.center,
        style: AppFontStyle.styleW600(CColor.black, 14.sp),
      ),
    );
  }

  _widgetImportData(IntegrationController logic) {
    return Container(

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10).r,
        color: CColor.greyF8,
        boxShadow: const [
          BoxShadow(
            color: CColor.txtGray50,
            // blurRadius: 1,
            spreadRadius: 0.5,
          )
        ],
      ),
      margin: EdgeInsets.only(top: 10.h, bottom: 3.h, left: 6.w, right: 6.w),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8).w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8).r,
              color: CColor.backgroundColor,
            ),
            child: Image.asset(
              (Platform.isAndroid)
                  ? Constant.settingAndroidImportExportIcons
                  : Constant.settingIosImportExportIcons,
              width: 20.w,
              height: 20.w,
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 7.w),
              child: Text(
                (Platform.isIOS) ? Constant.appleHealth : Constant.googleFit,
                style: AppFontStyle.styleW600(CColor.black, 14.sp),
              ),
            ),
          ),
          Switch(
            value: logic.isHealth,
            onChanged: (value) {
              logic.onChangeSwitch(value);
            },
            activeColor: CColor.primaryColor,
          ),
        ],
      ),
    );
  }

  _widgetButtonDetails(IntegrationController logic, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 2.h, bottom: 10.h),
      child:/* Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                if (logic.isHealth) {
                  GetSetHealthData.importDataFromHealth((value) {
                    Get.toNamed(AppRoutes.configuration, arguments: [true]);
                  });
                } else {
                  Get.toNamed(AppRoutes.configuration, arguments: [true]);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(9).w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: CColor.primaryColor,
                    borderRadius: BorderRadius.circular(7).r,
                    border: Border.all(color: CColor.white)),
                child: Text(
                  "Next",
                  style: TextStyle(color: CColor.white, fontSize: 16.sp),
                ),
              ),
            ),
          ),
        ],
      ),*/
      Column(
        children: [
          (Utils.getPermissionHealth())?_widgetButtonYes(logic,context):Container(),
          _widgetButtonSkip(logic),
          _widgetIndication(),
        ],
      ),
    );
  }
  _widgetButtonYes(IntegrationController logic, BuildContext context){
    return Container(
      padding: EdgeInsets.only(
        top: 5.h, bottom: 5.h,),
      child: Row(
        children: [
          Expanded(child: Container()),
          InkWell(
            onTap: () {
              if(!logic.isHealth){
                Utils.showToast(context, "Please enable ${(Platform.isAndroid)?"Google fit":"Apple health"}");
              }else{
                // GetSetHealthData.importDataFromHealth((value) {
                //   Get.toNamed(AppRoutes.configurationMain);
                // },true);
              }
              // logic.pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
              // logic.gotoNextScreen();
            },
            child: Container(
              padding:  EdgeInsets.symmetric(
                  vertical: 8.h,
                  horizontal: 20.w
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: CColor.primaryColor,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                      color: CColor.white
                  )
              ),
              child: Text(
                "Yes",
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

  _widgetButtonSkip(IntegrationController logic){
    return Container(
      margin: EdgeInsets.only(
          bottom: 10.h
      ),
      child: Row(
        children: [
          Expanded(child: Container()),
          InkWell(
            onTap: () {
              // Get.toNamed(page)
              // logic.gotoBottomNavigationScreen();
              Get.toNamed(AppRoutes.configurationMain);
            },
            child: Text(
              "Skip",
              style: TextStyle(
                  color: CColor.primaryColor,
                  fontSize: 12.sp),
              // fontSize:(kIsWeb) ?FontSize.size_6: FontSize.size_10),
            ),
          ),
          Expanded(child: Container()),
        ],
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
