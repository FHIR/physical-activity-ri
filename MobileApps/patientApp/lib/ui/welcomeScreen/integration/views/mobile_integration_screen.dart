import 'dart:io';
import 'package:banny_table/healthData/getSetHealthData.dart';
import 'package:banny_table/ui/welcomeScreen/integration/controllers/integration_controller.dart';
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
import '../../../../routes/app_routes.dart';

class MobileIntegrationScreen extends StatelessWidget {
  const MobileIntegrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return LayoutBuilder(
          builder: (BuildContext context ,BoxConstraints constraints) {
            return Scaffold(
              backgroundColor: CColor.white,
              body: SafeArea(
                child: GetBuilder<IntegrationController>(builder: (logic) {
                  return _widgetIntegrationDetails(context, logic,constraints,orientation);
                }),
              ),
            );
          }
        );
      },
    );
  }

  _widgetIntegrationDetails(BuildContext context, IntegrationController logic,BoxConstraints constraints,Orientation orientation) {
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
                  _widgetMainIcons(orientation,constraints),
                  _widgetTitleDetails(orientation,constraints),
                  _widgetAboveDetails(orientation,constraints),
                  _widgetPermissionDetails(orientation,constraints),
                  _widgetImportData(logic,orientation,constraints),
                  (Utils.getPermissionHealth())?_widgetAskSyncDetails(orientation,constraints):Container(),
                  /*_widgetButtonDetails(logic),*/
                ],
              ),
            ),
          ),
        ),
        _widgetButtonDetails(logic,context,constraints,orientation),
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

  _widgetTitleDetails(Orientation orientation,BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(top: (orientation == Orientation.portrait)?10.h : AppFontStyle.sizesHeightManageWeb(1.0, constraints), bottom: 3.h,
        left: (orientation == Orientation.portrait)
            ? 8.w
            : AppFontStyle.sizesWidthManageWeb(1.0, constraints),),
      alignment: Alignment.centerLeft,
      child: Text(
        (Platform.isIOS)
            ? "Sync with apple health"
            : "Sync with health connect",
        textAlign: TextAlign.center,
        style: AppFontStyle.styleW700(CColor.black, (orientation == Orientation.portrait)? 16.sp : AppFontStyle.sizesFontManageWeb(1.5,constraints)),
      ),
    );
  }

  _widgetMainIcons(Orientation orientation,BoxConstraints constraints) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: (orientation == Orientation.portrait)? 5.h :
      AppFontStyle.sizesHeightManageWeb(0.1, constraints),),
      padding:(orientation == Orientation.portrait) ?  EdgeInsets.all(10).w : EdgeInsets.all(1).w,
      child: Image.asset(
        Constant.settingHealthConnectIcons,
        height: (orientation == Orientation.portrait) ? 80.w : AppFontStyle.sizesHeightManageWeb(9.0, constraints),
        width: (orientation == Orientation.portrait) ? 80.w : AppFontStyle.sizesHeightManageWeb(9.0, constraints),
      ),
    );
  }

  _widgetAboveDetails(Orientation orientation,BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(
          top: (orientation == Orientation.portrait)
              ? 10.h
              : AppFontStyle.sizesHeightManageWeb(0.5, constraints),
          bottom: (orientation == Orientation.portrait)
              ? 2.h
              : AppFontStyle.sizesHeightManageWeb(0.1, constraints),
          left: (orientation == Orientation.portrait)
              ? 8.w
              : AppFontStyle.sizesWidthManageWeb(1.0, constraints),
          right: (orientation == Orientation.portrait)
              ? 8.w
              : AppFontStyle.sizesWidthManageWeb(1.0, constraints)),
      alignment: Alignment.centerLeft,
      child: Text(
        (Platform.isIOS) ? Constant.syncDescIos : Constant.syncDescAndroid,
        textAlign: TextAlign.start,
        style: AppFontStyle.styleW600(CColor.black, (orientation == Orientation.portrait) ? 13.sp :AppFontStyle.sizesFontManageWeb(1.2, constraints)),
      ),
    );
  }

  _widgetPermissionDetails(Orientation orientation,BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(
          top: (orientation == Orientation.portrait)
              ? 20.h
              : AppFontStyle.sizesHeightManageWeb(0.5, constraints),
          bottom: (orientation == Orientation.portrait)
              ? 2.h
              : AppFontStyle.sizesHeightManageWeb(0.1, constraints),
          left: (orientation == Orientation.portrait)
              ? 8.w
              : AppFontStyle.sizesWidthManageWeb(1.0, constraints),
          right: (orientation == Orientation.portrait)
              ? 8.w
              : AppFontStyle.sizesWidthManageWeb(1.0, constraints)),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Permissions:",
              textAlign: TextAlign.start,
              style: AppFontStyle.styleW600(
                CColor.black,
                (orientation == Orientation.portrait) ? 13.sp :AppFontStyle.sizesFontManageWeb(1.2, constraints),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: (orientation == Orientation.portrait)
                ? 10.h
                : AppFontStyle.sizesHeightManageWeb(0.3, constraints),),
            alignment: Alignment.centerLeft,
            /*child: Text(
              Constant.syncPermissionReadDetail,
              textAlign: TextAlign.center,
              style: AppFontStyle.styleW600(
                CColor.gray,
                (orientation == Orientation.portrait) ? 13.sp :AppFontStyle.sizesFontManageWeb(1.2, constraints),
              ),
            ),*/
            child: RichText(
              text: TextSpan(
                text: "•  Read: ",
                style: AppFontStyle.styleW600(
                  CColor.black,
                  (orientation == Orientation.portrait) ? 13.sp :AppFontStyle.sizesFontManageWeb(1.2, constraints),
                ),
                children: [
                  ///This Is use For Goal Type is mandatory
                  TextSpan(
                    text: Constant.syncPermissionReadDetail,
                    style: AppFontStyle.styleW600(
                      CColor.gray,
                      (orientation == Orientation.portrait) ? 13.sp :AppFontStyle.sizesFontManageWeb(1.2, constraints),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top:(orientation == Orientation.portrait)
                ? 10.h
                : AppFontStyle.sizesHeightManageWeb(0.3, constraints),),
            alignment: Alignment.centerLeft,
            child:/* Text(
              Constant.syncPermissionWriteDetail,
              textAlign: TextAlign.start,
              style: AppFontStyle.styleW600(
                CColor.gray,
                (orientation == Orientation.portrait) ? 13.sp :AppFontStyle.sizesFontManageWeb(1.2, constraints),
              ),
            ),*/
            RichText(
              text: TextSpan(
                text: "•  Write: ",
                style: AppFontStyle.styleW600(
                  CColor.black,
                  (orientation == Orientation.portrait) ? 13.sp :AppFontStyle.sizesFontManageWeb(1.2, constraints),
                ),
                children: [
                  ///This Is use For Goal Type is mandatory
                  TextSpan(
                    text: Constant.syncPermissionWriteDetail,
                    style: AppFontStyle.styleW600(
                      CColor.gray,
                      (orientation == Orientation.portrait) ? 13.sp :AppFontStyle.sizesFontManageWeb(1.2, constraints),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top:(orientation == Orientation.portrait)
                ? 20.h
                : AppFontStyle.sizesHeightManageWeb(0.3, constraints),
            bottom: (orientation == Orientation.portrait)
                ? 10.h
                : AppFontStyle.sizesHeightManageWeb(0.3, constraints)),
            alignment: Alignment.centerLeft,
            child: Text(
              (Platform.isAndroid)?Constant.syncEditReadWriteAndroid:Constant.syncEditReadWriteIos,
              textAlign: TextAlign.start,
              style: AppFontStyle.styleW600(
                CColor.black,
                (orientation == Orientation.portrait) ? 13.sp :AppFontStyle.sizesFontManageWeb(1.2, constraints),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _widgetAskSyncDetails(Orientation orientation,BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(
          top: (orientation == Orientation.portrait)
              ? 20.h
              : AppFontStyle.sizesHeightManageWeb(0.5, constraints),
          bottom: (orientation == Orientation.portrait)
              ? 2.h
              : AppFontStyle.sizesHeightManageWeb(0.1, constraints),
          left: (orientation == Orientation.portrait)
              ? 8.w
              : AppFontStyle.sizesWidthManageWeb(1.0, constraints),
          right: (orientation == Orientation.portrait)
              ? 8.w
              : AppFontStyle.sizesWidthManageWeb(1.0, constraints)),
      alignment: Alignment.center,
      child: Text(
        Constant.syncConfirmAndroidIos,
        textAlign: TextAlign.center,
        style: AppFontStyle.styleW600(CColor.black,  (orientation == Orientation.portrait) ? 13.sp :AppFontStyle.sizesFontManageWeb(1.2, constraints),
        ),
      ),
    );
  }

  _widgetImportData(IntegrationController logic,Orientation orientation,BoxConstraints constraints) {
    return Container(
      decoration: BoxDecoration(
        borderRadius:  BorderRadius.circular(10).r,
        color: CColor.greyF8,
        boxShadow: const [
          BoxShadow(
            color: CColor.txtGray50,
            // blurRadius: 1,
            spreadRadius: 0.5,
          )
        ],
      ),
      margin: EdgeInsets.only(top: (orientation == Orientation.portrait)
          ? 10.h
          : AppFontStyle.sizesHeightManageWeb(0.5, constraints),
          bottom: (orientation == Orientation.portrait)
              ? 3.h
              : AppFontStyle.sizesHeightManageWeb(0.1, constraints),
          left: (orientation == Orientation.portrait)
              ? 6.w
              : AppFontStyle.sizesWidthManageWeb(1.0, constraints),
          right: (orientation == Orientation.portrait)
              ? 6.w
              : AppFontStyle.sizesWidthManageWeb(1.0, constraints)),
      padding: EdgeInsets.symmetric(horizontal: (orientation == Orientation.portrait) ? 8.w : AppFontStyle.sizesWidthManageWeb(1.0, constraints), vertical:(orientation == Orientation.portrait) ?7.h : AppFontStyle.sizesHeightManageWeb(0.6, constraints)),
      child: Row(
        children: [
          Container(
            padding:  (orientation == Orientation.portrait) ? EdgeInsets.all(8).w : EdgeInsets.all(1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8).r,
              color: CColor.backgroundColor,
            ),
            child: Image.asset(
              (Platform.isAndroid)
                  ? Constant.settingAndroidImportExportIcons
                  : Constant.settingIosImportExportIcons,
              width:  (orientation == Orientation.portrait) ? 20.w : AppFontStyle.sizesWidthManageWeb(3.0, constraints),
              height: (orientation == Orientation.portrait) ? 20.w : AppFontStyle.sizesWidthManageWeb(3.0, constraints),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: (orientation == Orientation.portrait) ?7.w : AppFontStyle.sizesWidthManageWeb(1.3, constraints)),
              child: Text(
                (Platform.isIOS) ? Constant.appleHealth : Constant.googleFit,
                style: AppFontStyle.styleW600(CColor.black, (orientation == Orientation.portrait) ? 14.sp : AppFontStyle.sizesWidthManageWeb(1.5, constraints)),
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

  _widgetButtonDetails(IntegrationController logic, BuildContext context,BoxConstraints constraints,Orientation orientation) {
    return Container(
      margin: EdgeInsets.only(
        bottom: (orientation == Orientation.portrait)
            ? 5.h
            : AppFontStyle.sizesWidthManageWeb(1.0, constraints),
          left: (orientation == Orientation.portrait)
              ? 15.w
              : AppFontStyle.sizesWidthManageWeb(1.0, constraints),
          right: (orientation == Orientation.portrait)
              ? 15.w
              : AppFontStyle.sizesWidthManageWeb(1.0, constraints)),
      padding: EdgeInsets.only(top: 2.h, ),
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
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _widgetButtonSkip(logic,constraints,orientation,context),
          if((Utils.getPermissionHealth()))Expanded(child: Container()),
          (Utils.getPermissionHealth())?_widgetButtonYes(logic,context,constraints,orientation):Container(),
          // _widgetIndication(constraints,orientation),
        ],
      ),
    );
  }
  _widgetButtonYes(IntegrationController logic, BuildContext context,BoxConstraints constraints,Orientation orientation){
    return Container(
      padding: EdgeInsets.only(
        top: (orientation == Orientation.portrait)?  5.h : AppFontStyle.sizesHeightManageWeb(0.4, constraints), bottom: (orientation == Orientation.portrait)? 5.h : AppFontStyle.sizesHeightManageWeb(0.4, constraints),),
      child: Row(
        children: [
          // Expanded(child: Container()),
          InkWell(
            onTap: () async {
              if(!logic.isHealth){
                Utils.showToast(context, "Please enable ${(Platform.isAndroid)?"Google fit":"Apple health"}");
              }else{
                await GetSetHealthData.importDataFromHealth((value) {
                  Get.toNamed(AppRoutes.configurationMain);
                },true,needAPICall: false,endDate: Utils.endDateTime(DateTime.now()),startDate: Utils.startDateTime(DateTime.now()));
                await Utils.callPushApiForConfigurationActivity();

              }
              // logic.pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
              // logic.gotoNextScreen();
            },
            child: Container(
              padding:  EdgeInsets.symmetric(
                  vertical:(orientation == Orientation.portrait)? 6.h : AppFontStyle.sizesHeightManageWeb(1.0, constraints),
                  horizontal: (orientation == Orientation.portrait)? 25.w : AppFontStyle.sizesWidthManageWeb(5.0, constraints)
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
                    (orientation == Orientation.portrait)? 13.sp : AppFontStyle.sizesFontManageWeb(1.5,constraints)),
                // (kIsWeb) ?FontSize.size_8 : FontSize.size_14),
              ),
            ),
          ),
          // (kIsWeb) ? Expanded(child: Container()) : Container(),
          // Expanded(child: Container())
        ],
      ),
    );
  }

  _widgetButtonSkip(IntegrationController logic,BoxConstraints constraints,Orientation orientation,BuildContext context){
    return Container(
      margin: EdgeInsets.only(
          bottom:  (orientation == Orientation.portrait)? 5.h : AppFontStyle.sizesHeightManageWeb(0.4, constraints)
      ),
      child: Row(
        children: [
          // Expanded(child: Container()),
          InkWell(
            onTap: () {
              logic.nextScreen();
            },
            child: Text(
              "Skip",
              style: TextStyle(
                  color: CColor.primaryColor,
                  fontSize: (kIsWeb) ?12.sp : AppFontStyle.sizesFontManageWeb(1.5,constraints),
              fontWeight: FontWeight.w700),
              // fontSize:(kIsWeb) ?FontSize.size_6: FontSize.size_10),
            ),
          ),
          // Expanded(child: Container()),
        ],
      ),
    );
  }

  _widgetIndication(BoxConstraints constraints,Orientation orientation){
    return Container(
      margin: EdgeInsets.only(
          bottom: (orientation == Orientation.portrait) ? 8.h : AppFontStyle
              .sizesHeightManageWeb(0.5, constraints),
        top: (orientation == Orientation.portrait)
            ? 5.h
            : AppFontStyle.sizesHeightManageWeb(0.5, constraints),
      ),
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
