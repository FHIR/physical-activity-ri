import 'dart:io';

import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/ui/setting/controllers/setting_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SettingScreen extends StatelessWidget {
  SettingScreen({Key? key}) : super(key: key);
  // SettingController logic = Get.find<SettingController>();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          useMaterial3: false
      ),
      child: Scaffold(
        backgroundColor: CColor.white,
        body: SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context,BoxConstraints constraints) {
                return SingleChildScrollView(
                  child: GetBuilder<SettingController>(builder: (logic) {
                    return Column(
                      children: [
                        _widgetWizard(logic,constraints),
                        if(!Preference.shared.getBool(Preference.isSingleServer)!)
                        _widgetSettingQrScanView(logic,constraints),
                        // if (Utils.getAPIEndPoint() != "")_widgetProfileConfiguration(logic),
                        _widgetProviderIndependateMode(constraints),
                        _widgetFeedBack(constraints,logic),
                        // _widgetClearTrackingChartData(constraints,logic,)
                        // _widgetHistoryCountText(logic),
                      ],
                    );
                  }),
                );
              }
            )),
      ),
    );
  }


  _widgetSettingQrScanView(SettingController logic,BoxConstraints constraints) {
    return InkWell(
      onTap: () {
        if(Utils.getServerListPreference().isNotEmpty){
          logic.qrCodeManage();
          Debug.printLog("Goto Qr");
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CColor.greyF8,
          boxShadow: const [
            BoxShadow(
              color: CColor.txtGray50,
              // blurRadius: 1,
              spreadRadius: 0.5,
            )
          ],
        ),

        margin: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
            vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.5, constraints) :Sizes.height_1),
        padding: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
            vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.5, constraints) : Sizes.height_1),
        child: Row(
          children: [
            Container(
              padding:  EdgeInsets.all( (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.6, constraints) :10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular((kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.7, constraints) :10),
                color: CColor.backgroundColor,
              ),
              child: const Icon(Icons.qr_code_scanner),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_3),
                child: Text(
                  (logic.primaryTitle.isNotEmpty && logic.primaryDisplayName.isNotEmpty)
                      ?logic.primaryTitle ?? "":Constant.settingQRScan,
                  style: AppFontStyle.styleW600(CColor.black,
                      (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints) : FontSize.size_12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _widgetProfileConfiguration(SettingController logic) {
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.healthQrScanner, arguments: [true,])!.then((value) => {logic.getQrUrl()});
        // Get.toNamed(AppRoutes.qrManagerScreen, arguments: [Constant.profileTypeSetting,true]);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CColor.greyF8,
          boxShadow: const [
            BoxShadow(
              color: CColor.txtGray50,
              // blurRadius: 1,
              spreadRadius: 0.5,
            )
          ],
        ),

        margin: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
            vertical: Sizes.height_1),
        padding: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
            vertical: Sizes.height_1),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CColor.backgroundColor,
              ),
              child: Image.asset(Constant.settingProfileIcons,
                width: (kIsWeb) ? Sizes.width_1_5 : Sizes.width_6,
                height: (kIsWeb) ? Sizes.width_1_5 : Sizes.width_6,),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: Sizes.width_3),
                child: Text(
                  Constant.settingProfileConfiguration,
                  style: AppFontStyle.styleW600(CColor.black,
                      (kIsWeb) ? FontSize.size_3 : FontSize.size_12),
                ),
              ),
            ),
            const Icon(Icons.navigate_next_rounded)
          ],
        ),
      ),
    );
  }

  _widgetProviderIndependateMode(BoxConstraints constraints) {
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.patientIndependentMode,arguments: [true,false,false,false]);

        // Get.toNamed(AppRoutes.profileSelection, arguments: [Constant.profileTypeInitPatient,true]);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CColor.greyF8,
          boxShadow: const [
            BoxShadow(
              color: CColor.txtGray50,
              // blurRadius: 1,
              spreadRadius: 0.5,
            )
          ],
        ),

        margin: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
            vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.5, constraints) :Sizes.height_1),
        padding: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
            vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.6, constraints) : Sizes.height_1),
        child: Row(
          children: [
            Container(
              padding:  EdgeInsets.all( (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.7, constraints) :10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular((kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.7, constraints) :10),
                color: CColor.backgroundColor,
              ),
              child: Image.asset(Constant.settingProfileIcons,
                width: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.5, constraints) : Sizes.width_6,
                height: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.5, constraints) : Sizes.width_6,),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_3),
                child: Text(
                  Constant.settingProfilePhysicalActivity,
                  style: AppFontStyle.styleW600(CColor.black,
                      (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints) : FontSize.size_12),
                ),
              ),
            ),
            const Icon(Icons.navigate_next_rounded)
          ],
        ),
      ),
    );
  }

  Widget _widgetHistoryCountText(SettingController logic) {
    return Container(
      margin: EdgeInsets.only(
          top: Sizes.height_1, right: Sizes.width_3, left: Sizes.width_3),
      color: CColor.transparent,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
             right: Sizes.width_3, left: Sizes.width_4),
            child: RichText(
              text: TextSpan(
                text: "History Count",
                style: AppFontStyle.styleW700(CColor.black,(kIsWeb)?FontSize.size_3: FontSize.size_10),
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(
              top: Sizes.height_0_7
            ),
            child: TextFormField(
              maxLines: 1,
              controller: Constant.historyCount,
              enableInteractiveSelection: false,
              keyboardType: Utils.getInputTypeKeyboard(),
              textAlign: TextAlign.start,
              style: AppFontStyle.styleW500(CColor.black, (kIsWeb)?FontSize.size_3:FontSize.size_10),
              cursorColor: CColor.black,
              decoration: InputDecoration(
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
          ),
        ],
      ),
    );
  }

  _widgetWizard(SettingController logic,BoxConstraints constraints) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              Utils.wizardMode();
            },
            child: Container(
              margin: EdgeInsets.only(
                  top: (kIsWeb) ? AppFontStyle.sizesFontManageWeb(0.4, constraints): Sizes.height_0_5
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: CColor.greyF8,
                  boxShadow: const [
                    BoxShadow(
                      color: CColor.txtGray50,
                      // blurRadius: 1,
                      spreadRadius: 0.5,
                    )
                  ],
                ),

                margin: EdgeInsets.symmetric(
                    horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
                    vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.5, constraints) :Sizes.height_1),
                padding: EdgeInsets.symmetric(
                    horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
                    vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.6, constraints) : Sizes.height_1),
                child: Row(
                  children: [
                    Container(
                      padding:  EdgeInsets.all( (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.7, constraints) :10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular((kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.7, constraints) :10),
                        color: CColor.backgroundColor,
                      ),
                      child: Icon(Icons.phonelink_setup_sharp,size: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.5, constraints): Sizes.width_6,),
                    ),
                    Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_3),
                          child: Text(Constant.wizard,
                            style: AppFontStyle.styleW600(CColor.black,
                                (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints) : FontSize.size_12),
                          ),
                        )
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        /*Container(
          margin: EdgeInsets.only(right: Sizes.width_2),
          child: PopupMenuButton(
            elevation: 0,
            constraints: BoxConstraints(
                minWidth: Get.width * 0.1, maxWidth: Get.width * 0.8),
            color: Colors.transparent,
            padding: const EdgeInsets.all(0),
            position: PopupMenuPosition.under,
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: CColor.white,
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                          Constant.settingSetupWizard)),
                ),
              ];
            },
            child: Icon(Icons.info_outline,
                color: CColor.black, size: (kIsWeb) ? Sizes.height_2_5 : Sizes.height_2_5),
          ),
        )*/
      ],
    );
  }


  _widgetFeedBack(BoxConstraints constraints,SettingController logic) {
    return Container(
      margin: EdgeInsets.only(
          bottom: Sizes.height_1_5
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                logic.feedbackForm("https://docs.google.com/forms/d/e/1FAIpQLSeG6Nc_8dTyCwuBopnewxfw3sbUmUMy0rWgljupY5kpi7jjwg/viewform");
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: CColor.greyF8,
                  boxShadow: const [
                    BoxShadow(
                      color: CColor.txtGray50,
                      // blurRadius: 1,
                      spreadRadius: 0.5,
                    )
                  ],
                ),

                margin: EdgeInsets.symmetric(
                    horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
                    vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.5, constraints) :Sizes.height_1),
                padding: EdgeInsets.symmetric(
                    horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
                    vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.6, constraints) : Sizes.height_1),
                child: Row(
                  children: [
                    Container(
                      padding:  EdgeInsets.all( (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.7, constraints) :10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: CColor.backgroundColor,
                      ),
                      child: Image.asset(Constant.settingProfileIcons,
                        width: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.5, constraints) : Sizes.width_6,
                        height: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.5, constraints) : Sizes.width_6,),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_3),
                        child: Text(
                          Constant.settingFeedBackUs,
                          style: AppFontStyle.styleW600(CColor.black,
                              (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints) : FontSize.size_12),
                        ),
                      ),
                    ),
                    const Icon(Icons.navigate_next_rounded)
                  ],
                ),
              ),
            ),
          ),
          /*Container(
            margin: EdgeInsets.only(left: Sizes.width_2,right: Sizes.width_2),
            child: PopupMenuButton(
              elevation: 0,
              constraints: BoxConstraints(
                  minWidth: Get.width * 0.1, maxWidth: Get.width * 0.8),
              color: Colors.transparent,
              padding: const EdgeInsets.all(0),
              position: PopupMenuPosition.under,
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: CColor.white,
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                            Constant.settingFeedBack)),
                  ),
                ];
              },
              child: Icon(Icons.info_outline,
                  color: CColor.black, size: (kIsWeb) ? Sizes.height_2_5 : Sizes.height_2_5),
            ),
          )*/
        ],
      ),
    );
  }


  _widgetClearTrackingChartData(BoxConstraints constraints,SettingController logic) {
    return Container(
      margin: EdgeInsets.only(
          bottom: Sizes.height_1_5
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                logic.clearTrackingChartData();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: CColor.greyF8,
                  boxShadow: const [
                    BoxShadow(
                      color: CColor.txtGray50,
                      // blurRadius: 1,
                      spreadRadius: 0.5,
                    )
                  ],
                ),

                margin: EdgeInsets.symmetric(
                    horizontal: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
                    vertical: Sizes.height_1),
                padding: EdgeInsets.symmetric(
                    horizontal: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
                    vertical: Sizes.height_1),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: CColor.backgroundColor,
                      ),
                      child: Image.asset(Constant.settingProfileIcons,
                        width: (kIsWeb) ? Sizes.width_1_5 : Sizes.width_6,
                        height: (kIsWeb) ? Sizes.width_1_5 : Sizes.width_6,),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: Sizes.width_3),
                        child: Text(
                          Constant.settingClearData,
                          style: AppFontStyle.styleW600(CColor.black,
                              (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.1, constraints) : FontSize.size_12),
                        ),
                      ),
                    ),
                    const Icon(Icons.navigate_next_rounded)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



}
