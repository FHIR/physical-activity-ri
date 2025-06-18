import 'dart:io';

import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/ui/bottomNavigation/controllers/bottom_navigation_controller.dart';
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
  BottomNavigationController? bottomNavigationController;

  SettingScreen({Key? key ,@required this.bottomNavigationController}) : super(key: key);
  SettingController logic = Get.find<SettingController>();

  @override
  Widget build(BuildContext context) {
    logic.bottomNavigationController = bottomNavigationController;
    return Scaffold(
      backgroundColor: CColor.white,
      body: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context,BoxConstraints constraints) {
              return SingleChildScrollView(
                child: Column(
                    children: [
                      _widgetConfigurationInitial(constraints),
                      _widgetWizard(logic,constraints),
                      _widgetSettingQrScanView(logic,constraints),
                      if(!kIsWeb && Platform.isAndroid)_widgetImportData(logic,constraints),
                      if (!kIsWeb && Platform.isIOS)_widgetSettingHealthEnableDisableView(constraints),
                      _widgetConfiguration(constraints),
                      if (Utils.getAPIEndPoint() != "" && Utils.getServerList.where((element) => element.isSelected && !element.isSecure).toList().isNotEmpty)
                        _widgetProfileConfiguration(constraints),
                      _widgetTrackingChart(constraints),
                      _widgetSettingEditModeView(constraints),
                      _widgetAutoCalModeView(constraints),
                      _widgetSyncingTimeHead(constraints),
                      _widgetSyncingTime(context,logic,constraints),
                      if(Debug.debug)_widgetDiagnostics(constraints),
                      if(Debug.debug)_widgetLogData(constraints),
                      _widgetFeedbackHead(constraints),
                      _widgetFeedBack(constraints),
                      // _widgetClearTrackingChartData(constraints,logic,)

                      // if(Preference.shared.getString(Preference.authToken) != "")_widgetPatientIdEditText(logic),
                    ],
                  ),
                // }),
              );
            }
          )),
    );
  }

  _widgetConfigurationInitial(BoxConstraints constraints) {
    return Container(
      decoration: const BoxDecoration(
        color: CColor.primaryColor30,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
            top: (kIsWeb)
                ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                : Sizes.height_2,
            bottom:(kIsWeb) ?  AppFontStyle.sizesHeightManageWeb(1.0, constraints) : Sizes.height_2,
            left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.5, constraints) :Sizes.width_5),
        child: Text("Initial Configuration",
            style: AppFontStyle.styleW700(Colors.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints): FontSize.size_12)),
      ),
    );
  }

  _widgetTrackingChart(BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(top:(kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.9, constraints):  Sizes.height_2),
      decoration: const BoxDecoration(
        color: CColor.primaryColor30,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
            top: (kIsWeb)
                ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                : Sizes.height_2,
            bottom: (kIsWeb)
                ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                : Sizes.height_2,
            left: (kIsWeb)
                ? AppFontStyle.sizesWidthManageWeb(1.5, constraints)
                : Sizes.width_5),
        child: Text("Tracking Chart Settings",
            style: AppFontStyle.styleW700(Colors.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints): FontSize.size_12)),
      ),
    );
  }

  _widgetSyncingTimeHead(BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(top:(kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.9, constraints):  Sizes.height_2),
      decoration: const BoxDecoration(
        color: CColor.primaryColor30,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
            top: (kIsWeb)
                ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                : Sizes.height_2,
            bottom: (kIsWeb)
                ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                : Sizes.height_2,
            left: (kIsWeb)
                ? AppFontStyle.sizesWidthManageWeb(1.5, constraints)
                : Sizes.width_5),
        child: Text("Synchronization",
            style: AppFontStyle.styleW700(Colors.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints): FontSize.size_12)),
      ),
    );
  }

  _widgetDiagnostics(BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(top:(kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.9, constraints):  Sizes.height_2),
      decoration: const BoxDecoration(
        color: CColor.primaryColor30,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
            top: (kIsWeb)
                ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                : Sizes.height_2,
            bottom: (kIsWeb)
                ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                : Sizes.height_2,
            left: (kIsWeb)
                ? AppFontStyle.sizesWidthManageWeb(1.5, constraints)
                : Sizes.width_5),        child: Text("Diagnostics",
          style: AppFontStyle.styleW700(Colors.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints): FontSize.size_12)),
      ),
    );
  }


  Widget _widgetPatientIdEditText(SettingController logic) {
    return Container(
      margin: EdgeInsets.only(
          top: Sizes.height_1,bottom: Sizes.height_1, right: Sizes.width_3, left: Sizes.width_3),
      color: CColor.transparent,
      child: TextFormField(
        maxLines: 10,
        controller: logic.editingController,
        textAlign: TextAlign.start,
        readOnly: true,
        focusNode: logic.editFocusNode,
        keyboardType: TextInputType.number,
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
    );
  }

  _widgetWizard(SettingController logic,BoxConstraints constraints) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            hoverColor: CColor.transparent,
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
        Container(
          margin: EdgeInsets.only(right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_2),
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
                      padding:  EdgeInsets.all(6),
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
                color: CColor.black, size: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.6, constraints) : Sizes.height_2_5),
          ),
        )
      ],
    );
  }

  _widgetSettingQrScanView(SettingController logic,BoxConstraints constraints) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            hoverColor: CColor.transparent,

            onTap: () {
              // if(Preference.shared.getString(Preference.qrUrlData) == null){
                logic.qrCodeManage();
              // }
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
                    child:  Icon(Icons.qr_code_scanner,size: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.5, constraints): Sizes.width_6,),
                  ),
                  Expanded(
                    child: /*ListView.builder(
                        itemCount: logic.selectedUrlData.length,
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemBuilder: (context ,index){
                      return Container(
                        margin: EdgeInsets.only(left: Sizes.width_3),
                        child: Text(
                          logic.selectedUrlData[index].displayName,
                          style: AppFontStyle.styleW600(CColor.black,
                              (kIsWeb) ? FontSize.size_3 : FontSize.size_12),
                        ),
                      );
                    }),*/
                    Container(
                      margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_3),
                      child: Text(
                        (logic.primaryTitle.isNotEmpty && logic.primaryDisplayName.isNotEmpty)
                            ?logic.primaryTitle ?? "":Constant.connectToYourProvider,
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
        Container(
          margin: EdgeInsets.only(right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_2),
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
                      padding:  EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: CColor.white,
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                          Constant.settingConnectedServer)),
                ),
              ];
            },
            child: Icon(Icons.info_outline,
                color: CColor.black, size: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.6, constraints) : Sizes.height_2_5),
          ),
        )
      ],
    );
  }

  _widgetSettingEditModeView(BoxConstraints constraints) {
    return Row(
      children: [
        Expanded(
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
                  child: Icon(Icons.edit,size: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.5, constraints): Sizes.width_6,),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_3),
                    child: Text(
                      Constant.settingEditMode,
                      style: AppFontStyle.styleW600(CColor.black,
                          (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints) : FontSize.size_12),
                    ),
                  ),
                ),
                GetBuilder<SettingController>(builder: (logic) {
                  return Switch(
                    value: Constant.isEditMode,
                    onChanged: (value) {
                      logic.onChangeMode();
                    },
                    activeColor: CColor.primaryColor,
                  );
                })
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_2),
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
                          Constant.settingTrackingEditMode)),
                ),
              ];
            },
            child: Icon(Icons.info_outline,
                color: CColor.black, size: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.6, constraints)  : Sizes.height_2_5),
          ),
        )
      ],
    );
  }

  _widgetAutoCalModeView(BoxConstraints constraints) {
    return Row(
      children: [
        Expanded(
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
                  child:  Icon(Icons.calculate_rounded,size:(kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.5, constraints) : Sizes.width_6,),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_3),
                    child: Text(
                      Constant.settingAutoCalculation,
                      style: AppFontStyle.styleW600(CColor.black,
                          (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints) : FontSize.size_12),
                    ),
                  ),
                ),
                GetBuilder<SettingController>(builder: (logic) {
                  return Switch(
                    value: Preference.shared.getBool(Preference.isAutoCalMode) ?? false,
                    onChanged: (value) {
                      logic.onChangeAutoCalculationMode(value);
                    },
                    activeColor: CColor.primaryColor,
                  );
                })
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_2),
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
                          Constant.settingTrackingAutoCalculation)),
                ),
              ];
            },
            child: Icon(Icons.info_outline,
                color: CColor.black, size: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.6, constraints)  : Sizes.height_2_5),
          ),
        )
      ],
    );
  }

  _widgetConfiguration(BoxConstraints constraints) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            hoverColor: CColor.transparent,

            onTap: () {
              Get.toNamed(AppRoutes.configuration, arguments: [false]);
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
                    child: Image.asset(Constant.settingConfigurationIcons,
                      width: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.5, constraints) : Sizes.width_6,
                      height: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.5, constraints) : Sizes.width_6,),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_3),
                      child: Text(
                        Constant.settingConfiguration,
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
        Container(
          margin: EdgeInsets.only(right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_2),
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
                      padding:  EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: CColor.white,
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                          Constant.settingActivityConfig)),
                ),
              ];
            },
            child: Icon(Icons.info_outline,
                color: CColor.black, size: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.6, constraints)  : Sizes.height_2_5),
          ),
        )
      ],
    );
  }
  _widgetConfigurationDelete(BoxConstraints constraints) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            hoverColor: CColor.transparent,

            onTap: () {
            Utils.getConfigurationActivityDataListApi();
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
                    child: Image.asset(Constant.settingConfigurationIcons,
                      width: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.5, constraints) : Sizes.width_6,
                      height: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.5, constraints) : Sizes.width_6,),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_3),
                      child: Text(
                        Constant.settingConfiguration,
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
        Container(
          margin: EdgeInsets.only(right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_2),
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
                      padding:  EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: CColor.white,
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                          Constant.settingActivityConfig)),
                ),
              ];
            },
            child: Icon(Icons.info_outline,
                color: CColor.black, size: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.6, constraints)  : Sizes.height_2_5),
          ),
        )
      ],
    );
  }

  _widgetProfileConfiguration(BoxConstraints constraints) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            hoverColor: CColor.transparent,

            onTap: () {
              Get.toNamed(AppRoutes.healthPatientList, arguments: [false,true]);
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
                      width: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.5, constraints) : Sizes.width_6,
                      height: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.5, constraints) : Sizes.width_6,),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_3),
                      child: Text(
                        Constant.settingProfileConfiguration,
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
        Container(
          margin: EdgeInsets.only(right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_2),
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
                      padding:  EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: CColor.white,
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                          Constant.settingActivityConfig)),
                ),
              ];
            },
            child: Icon(Icons.info_outline,
                color: CColor.black, size: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.6, constraints)  : Sizes.height_2_5),
          ),
        )
      ],
    );
  }

  _widgetSyncingTime(BuildContext context, SettingController logic,BoxConstraints constraints) {
    return Row(
      children: [
        Expanded(
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
            padding: EdgeInsets.only(
                left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
                right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_0_5,
                top: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.6, constraints) : Sizes.height_1,
            bottom: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.6, constraints) : Sizes.height_1,

            ),
            child: Row(
              children: [
                Container(
                  padding:  EdgeInsets.all( (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.7, constraints) :10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: CColor.backgroundColor,
                  ),
                  child: Image.asset(Constant.settingSyncIcons,
                    width: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.5, constraints) : Sizes.width_6,
                    height: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.5, constraints) : Sizes.width_6,),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_3),
                    child: Text(
                      Constant.settingSyncingTime,
                      style: AppFontStyle.styleW600(CColor.black,
                          (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints) : FontSize.size_12),
                    ),
                  ),
                ),
                _widgetSyncingDropDown(context,logic,constraints),

              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_2),
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
                          Constant.settingSyncingTimeDesc)),
                ),
              ];
            },
            child: Icon(Icons.info_outline,
                color: CColor.black, size: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.6, constraints)  : Sizes.height_2_5),
          ),
        )
      ],
    );
  }

  _widgetSyncingDropDown(BuildContext context, SettingController logic,BoxConstraints constraints) {
    return Container(
      width: Get.width * 0.3,
      margin: EdgeInsets.only(
        left: (kIsWeb)? AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_1,
        right: (kIsWeb)? AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_3,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
          vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.7, constraints) : Sizes.height_1_5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular((kIsWeb) ?AppFontStyle.sizesWidthManageWeb(0.7, constraints) : 15),
          color: CColor.greyF8,
          border: Border.all(color: CColor.primaryColor, width: 0.7),
        ),
        child: DropdownButtonFormField<String>(
          focusColor: Colors.white,
          isExpanded: true,

          decoration: const InputDecoration.collapsed(hintText: ''),
          // value: Utils.routingReferralStatus[0],
          value: logic.selectedSyncing,
          //elevation: 5,
          style: const TextStyle(color: Colors.white),
          iconEnabledColor: Colors.black,
          items: Utils.syncingTimeList
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: AppFontStyle.styleW500(CColor.black,
                    (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_10),
              ),
            );
          }).toList(),
          onChanged: (value) {
            // logic.onChangeLifeCycleStatus(value!);
            logic.onSelectSyncingTime(value);
            Debug.printLog("lifecycle value...$value");
          },
        ),
      ),
    );
  }

  _widgetImportData(SettingController logic,BoxConstraints constraints) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            hoverColor: CColor.transparent,

            onTap: () {
              // logic.importDataFromHealth();
              Get.toNamed(AppRoutes.importExport);
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
                    child: Image.asset((Platform.isAndroid)
                        ? Constant.settingAndroidImportExportIcons
                        : Constant.settingIosImportExportIcons,
                      width: (kIsWeb) ? Sizes.width_1_5 : Sizes.width_6,
                      height: (kIsWeb) ? Sizes.width_1_5 : Sizes.width_6,),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: Sizes.width_3),
                      child: Text(
                        Constant.settingImportExportHealthData,
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
        Container(
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
                          Constant.settingHealthData)),
                ),
              ];
            },
            child: Icon(Icons.info_outline,
                color: CColor.black, size: (kIsWeb) ? Sizes.height_2_5 : Sizes.height_2_5),
          ),
        )
      ],
    );
  }

  _widgetSettingHealthEnableDisableView(BoxConstraints constraints) {
    return Row(
      children: [
        Expanded(
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
                  child: Image.asset((Platform.isAndroid)
                      ? Constant.settingAndroidImportExportIcons
                      : Constant.settingIosImportExportIcons,
                    width: (kIsWeb) ? Sizes.width_1_5 : Sizes.width_6,
                    height: (kIsWeb) ? Sizes.width_1_5 : Sizes.width_6,),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: Sizes.width_3),
                    child: Text(
                      (Platform.isAndroid)?Constant.txtHealthConnect:Constant.txtAppleHealth,
                      style: AppFontStyle.styleW600(CColor.black,
                          (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.1, constraints) : FontSize.size_12),
                    ),
                  ),
                ),
                GetBuilder<SettingController>(builder: (logic) {
                  return Switch(
                    value: logic.isHealth,
                    onChanged: (value) {
                      logic.onChangeSwitch(value);
                    },
                    activeColor: CColor.primaryColor,
                  );
                })
              ],
            ),
          ),
        ),
        Container(
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
                          Constant.settingHealthData)),
                ),
              ];
            },
            child: Icon(Icons.info_outline,
                color: CColor.black, size: (kIsWeb) ? Sizes.height_2_5 : Sizes.height_2_5),
          ),
        )
      ],
    );
  }


/*_widgetExportData(SettingController logic) {
    return InkWell(
      onTap: () {
        logic.exportDataFromHealth();
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
              child: Image.asset(Constant.settingExportIcons,
                width: (kIsWeb) ? Sizes.width_1_5 : Sizes.width_6,
                height: (kIsWeb) ? Sizes.width_1_5 : Sizes.width_6,),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: Sizes.width_3),
                child: Text(
                  Constant.settingExportHealthData,
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
  }*/

  _widgetLogData(BoxConstraints constraints) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            hoverColor: CColor.transparent,
            onTap: () {
              Get.toNamed(AppRoutes.logTableScreen);
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
                    child: Image.asset(Constant.settingConfigurationIcons,
                      width: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.5, constraints) : Sizes.width_6,
                      height: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.5, constraints) : Sizes.width_6,),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_3),
                      child: Text(
                        Constant.logTableAppBar,
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
        Container(
          margin: EdgeInsets.only(right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_2),
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
                          Constant.settingLogDesc)),
                ),
              ];
            },
            child: Icon(Icons.info_outline,
                color: CColor.black, size: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.6, constraints)  : Sizes.height_2_5),
          ),
        )
      ],
    );
  }


  _widgetFeedbackHead(BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(top:(kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.9, constraints):  Sizes.height_2),
      decoration: const BoxDecoration(
        color: CColor.primaryColor30,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
            top: (kIsWeb)
                ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                : Sizes.height_2,
            bottom: (kIsWeb)
                ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                : Sizes.height_2,
            left: (kIsWeb)
                ? AppFontStyle.sizesWidthManageWeb(1.5, constraints)
                : Sizes.width_5),        child: Text(Constant.settingFeedBack,
            style: AppFontStyle.styleW700(Colors.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints): FontSize.size_12)),
      ),
    );
  }


  _widgetFeedBack(BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(
        bottom: Sizes.height_1_5
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              hoverColor: CColor.transparent,
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
                        width: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.5, constraints) : Sizes.width_6,
                        height: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.5, constraints) : Sizes.width_6,),
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
          Container(
            margin: EdgeInsets.only(right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_2),
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
                  color: CColor.black, size: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.6, constraints)  : Sizes.height_2_5),
            ),
          )
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
                Utils.clearTrackingChartData();
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
                          "Clean Tracking chart",
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
