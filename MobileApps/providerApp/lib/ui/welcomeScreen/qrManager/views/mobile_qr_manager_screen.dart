import 'package:banny_table/ui/welcomeScreen/qrManager/controllers/qr_manager_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../utils/debug.dart';

class MobileQrManagerScreen extends StatelessWidget {
  const MobileQrManagerScreen({Key? key}) : super(key: key);

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
          left: 5.w,
          right: 5.w
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _widgetBackButton(logic),
          _widgetQrDetails(logic),
          _widgetMoreDetails(),
          Expanded(child: Container()),
          // _widgetQrCode(context,logic),
           _widgetQrCodeMoBileUse(context, logic),
          Expanded(child: Container()),
          _widgetButtonDetails(),
        ],
      ),
    );
  }


  _widgetQrDetails(QrManagerController logic) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(
        top: 12.h
      ),
      // width: double.infinity,
      height: 48.h,
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                  right: 8.w,
                  left: 8.w),
              color: CColor.transparent,
              child: TextFormField(
                  maxLines: 1,
                  controller: logic.qrCodeDetailsController,
                  textAlign: TextAlign.start,
                  focusNode: logic.qrdDetails,
                  keyboardType: TextInputType.text,
                  style: AppFontStyle.styleW500(CColor.black,
                      12.sp),
                  cursorColor: CColor.black,
                  decoration: InputDecoration(
                    hintText: "Enter a url".tr,
                    filled: true,
                    // contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: Sizes.width_5),
                    border: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: CColor.primaryColor, width: 0.7),
                      borderRadius: BorderRadius.circular(13.0).r,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: CColor.primaryColor, width: 0.7),
                      borderRadius: BorderRadius.circular(13.0).r,
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: CColor.primaryColor, width: 0.7),
                      borderRadius: BorderRadius.circular(13.0).r,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: CColor.primaryColor, width: 0.7),
                      borderRadius: BorderRadius.circular(13.0).r,
                    ),
                  ),
                ),

            ),
          ),
        ],
      ),
    );
  }

  _widgetMoreDetails() {
    return Container(
      margin: EdgeInsets.only(top: 9.h,left: 8.h,
      right: 8.h),
      alignment: Alignment.centerLeft,
      child: Text(
        "To connect with your provider's system, they will need to provide a QR code or URL.  Please scan the QR code below or enter the URL manually above.",
        textAlign: TextAlign.start,
        style: AppFontStyle.styleW500(CColor.black, 12.sp),
      ),
    );
  }

/*  _widgetQrCode(BuildContext context,QrManagerController logic){
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(
        top: Sizes.height_2,
        bottom: Sizes.height_2,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Sizes.width_3),
        child: Container(
          width: Sizes.width_58,
          height: Sizes.width_58,
          child: QRView(
            key: logic.qrKey,
            onQRViewCreated: (value){
              logic.onQRViewCreated(value);
            },
          ),
        ),
      ),
    );
  }*/

  _widgetQrCodeMoBileUse(BuildContext context, QrManagerController logic) {
    return Container(
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7).r,
        child: SizedBox(
          width: 200.w,
          height: 200.w,
          child: MobileScanner(
            controller: logic.cameraController,
            onDetect: (barcode) {
              if (barcode.barcodes[0].rawValue == null) {
                Debug.printLog('Failed to scan Barcode');
              } else {
                logic.onQRViewCreated(barcode.barcodes[0].displayValue);
              }
            },
          ),
        ),
      ),
    );
  }


  _widgetBackButton(QrManagerController logic) {
    return Container(
      margin: EdgeInsets.only(
          top: 2.h
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
                  left:8.w,
                  right:8.w,
                  // bottom:Sizes.width_5,
                // top: Sizes.height_1
              ),
              child: Image.asset(
                Constant.leftArrowIcons,
                height: 15.w,
                width: 15.w,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                right:4.w
              ),
              child: Text("Connect to Your Health Provider",
                maxLines: 2,
                style: AppFontStyle.styleW600(CColor.black, 15.sp),),
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
                  child: Container(
                    margin: EdgeInsets.only(right: 12.w),
                    child: Text(
                      "Skip",
                      style: AppFontStyle.styleW600(
                          CColor.primaryColor,15.sp),
                    ),
                  ),
                )
        ],
      ),
    );
  }


  _widgetButtonDetails() {
    return GetBuilder<QrManagerController>(builder: (logic) {
      return Container(
        margin: EdgeInsets.only(
          left:8.w,
          right:8.w,
        ),
        padding: EdgeInsets.only(
            top: 4.h, bottom: 12.h),
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
                  padding: const EdgeInsets.all(9).w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: CColor.white,
                      borderRadius: BorderRadius.circular(13).r,
                      border: Border.all(
                          color: CColor.primaryColor
                      )
                  ),
                  margin: EdgeInsets.only(
                      right: 5.w
                  ),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        color: CColor.primaryColor,
                        fontSize: 15.sp),
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
                  padding: const EdgeInsets.all(10).w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: CColor.primaryColor,
                      borderRadius: BorderRadius.circular(13).w,
                      border: Border.all(
                          color: CColor.white
                      )
                  ),
                  child: Text(
                    "Connect",
                    style: TextStyle(
                        color: CColor.white,
                        fontSize:15.sp),
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
