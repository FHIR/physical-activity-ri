import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

import '../../../utils/color.dart';
import '../../../utils/debug.dart';
import '../../../utils/font_style.dart';
import '../../../utils/utils.dart';
import '../controllers/disclaimer_controller.dart';

class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColor.white,
      appBar: AppBar(
        backgroundColor: CColor.primaryColor,
        title: const Text(
          Constant.txtDisclaimer,
          style: TextStyle(
            color: CColor.white,
            // fontSize: 20,
            fontFamily: Constant.fontFamilyPoppins,
          ),
        ),
      ),
      body: GetBuilder<DisclaimerController>(builder: (logic) {
        return LayoutBuilder(
          builder:(context, constraints) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Text(Constant.htmlDisclaimerTopText),
                        Container(
                          // color: Colors.cyan,
                          padding: EdgeInsets.only(top: Sizes.height_2,bottom: Sizes.height_2,right: Sizes.width_3,left: Sizes.width_3),
                          child: HtmlWidget(
                            Constant.htmlDisclaimerTopText,
                            customStylesBuilder: (element) {
                              if (element.classes.contains('foo')) {
                                return {'color': 'red'};
                              }
                              return null;
                            },
                            onTapUrl: (url) async {
                              Debug.printLog('Link tapped: $url');
                              await Utils.launchURL(url);
                              return true;
                            },
                            renderMode: RenderMode.column,
                            textStyle:  AppFontStyle.styleW500(CColor.black,(kIsWeb)?AppFontStyle.sizesFontManageWeb(1.0, constraints): 15),
                          ),
                        ),
                        HtmlWidget(
                          Constant.htmlDisclaimer,
                          customStylesBuilder: (element) {
                            if (element.classes.contains('foo')) {
                              return {'color': 'red'};
                            }
                            return null;
                          },
                          onTapUrl: (url) async {
                            Debug.printLog('Link tapped: $url');
                            await Utils.launchURL(url);
                            return true;
                          },
                          renderMode: RenderMode.column,
                          textStyle:  AppFontStyle.styleW500(CColor.black,(kIsWeb)?AppFontStyle.sizesFontManageWeb(1.0, constraints): 15),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: Sizes.height_2,bottom: Sizes.height_2,right: Sizes.width_3,left: Sizes.width_3),
                          child: HtmlWidget(
                            Constant.htmlDisclaimerBottomText1,
                            customStylesBuilder: (element) {
                              if (element.classes.contains('foo')) {
                                return {'color': 'red'};
                              }
                              return null;
                            },
                            onTapUrl: (url) async {
                              Debug.printLog('Link tapped: $url');
                              await Utils.launchURL(url);
                              return true;
                            },
                            renderMode: RenderMode.column,
                            textStyle:  AppFontStyle.styleW500(CColor.black,(kIsWeb)?AppFontStyle.sizesFontManageWeb(1.0, constraints): 15),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: Sizes.height_2,bottom: Sizes.height_2,right: Sizes.width_3,left: Sizes.width_3),
                          child: HtmlWidget(
                            Constant.htmlDisclaimerBottomText2,
                            customStylesBuilder: (element) {
                              if (element.classes.contains('foo')) {
                                return {'color': 'red'};
                              }
                              return null;
                            },
                            onTapUrl: (url) async {
                              Debug.printLog('Link tapped: $url');
                              await Utils.launchURL(url);
                              return true;
                            },
                            renderMode: RenderMode.column,
                            textStyle:  AppFontStyle.styleW500(CColor.black,(kIsWeb)?AppFontStyle.sizesFontManageWeb(1.0, constraints): 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, -4),
                        blurRadius: 12,
                        color: Color.fromRGBO(0, 0, 0, 0.16),
                      ),
                    ],
                    color: CColor.white
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Checkbox(
                        value: logic.isCheckedBox,
                        checkColor: CColor.white,
                        activeColor: CColor.primaryColor,
                        onChanged: (value) {
                          logic.onChangedBox(value);
                        },
                      ),
                      Expanded(
                        child: Text(
                          Constant.txtAgreeDesc,
                          style: AppFontStyle.styleW700(
                            Colors.black,
                            (kIsWeb)
                                ? AppFontStyle.sizesFontManageWeb(
                                    1.3, constraints)
                                : FontSize.size_12,
                          ),
                        ),
                      ),
                      Container(
                        color: CColor.white,
                        margin: EdgeInsets.only(right: Sizes.width_2),
                        child: FloatingActionButton.small(
                          backgroundColor: (logic.isCheckedBox)?CColor.primaryColor:CColor.primaryColor90,
                          child: const Icon(Icons.navigate_next_rounded),
                          onPressed: () {
                            if(logic.isCheckedBox) {
                              Debug.printLog("Tapped small FAB");
                              Preference.shared.setBool(
                                  Preference.isDisclaimerUnChecked, false);
                              Get.toNamed(AppRoutes.welcomeScreen);
                            }else{
                              Utils.showSnackBar(Get.context!,Constant.txtPleaseAccept,false);
                            }
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          },
        );
      }),
    );
  }
}
