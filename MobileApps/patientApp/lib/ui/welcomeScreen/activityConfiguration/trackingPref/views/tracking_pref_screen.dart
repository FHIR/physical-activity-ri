import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/configuration/controllers/configuration_controller.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/trackingPref/datamodel/trackingPref.dart';
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
    var orientation = MediaQuery.of(context).orientation;

    return ScreenUtilInit(
      builder: (context, child) {
        return Scaffold(
          backgroundColor: CColor.white,
          appBar : AppBar(
            toolbarHeight: 50,
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
              return LayoutBuilder(
                builder: (BuildContext context ,BoxConstraints constraints) {
                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _widgetMoreDetails(context,constraints,orientation),
                              _widgetActivityManage(context, logic,constraints,orientation),
                            ],
                          ),
                        ),
                      ),
                      _widgetButtonDetails(logic,context,constraints,orientation)
                    ],
                  );
                }
              );
            }),
          ),
        );
      },
    );
  }


  _widgetActivityManage(BuildContext context, TrackingPrefController logic,BoxConstraints constraints,Orientation orientation) {
    return (logic.trackingPrefList.isNotEmpty)?
    Container(
      margin: EdgeInsets.only(
        left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb( 2.0,constraints) : 15.w,
        right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(2.0,constraints) : 10.w,
        top: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb( 1.0,constraints) : 0,
      ),
      child: ReorderableListView(
        onReorder: logic.onReorder,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: buildListItems(logic,context,constraints,orientation) ,
      )):Container();
  }

  List<Widget> buildListItems(TrackingPrefController logic,BuildContext context,BoxConstraints constraints ,Orientation orientation) {
    return logic.trackingPrefList
        .map((item) => Container(
      key: ValueKey(item),
      margin: EdgeInsets.only(
                top: (kIsWeb)
                    ? AppFontStyle.sizesWidthManageWeb(0.7, constraints)
                    : 3.h,
                bottom: (kIsWeb)
                    ? AppFontStyle.sizesWidthManageWeb(0.7, constraints)
                    : 3.h,
              ),
              child: Row(
        children: [
          if(!kIsWeb) const Icon(Icons.menu),
          if(!kIsWeb) const SizedBox(width: 10,),
          PopupMenuButton(
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
            child:  Text(
              item.titleName,
              style: AppFontStyle.styleW500(
                  CColor.black,
                  (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : (orientation == Orientation.portrait)? 14.sp: AppFontStyle.sizesFontManageWeb(1.3, constraints) ),

            ),
          ),


          /*Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 5.w),
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
                            "This activity in ${item.titleName} details and Above manually On and Off Activity")),
                  ),
                ];
              },
              child: Icon(Icons.info_outline,
                  color: CColor.gray, size: (kIsWeb) ? 6.sp : 13.sp),
            ),
          ),*/
          const Spacer(),
          Container(
            margin: EdgeInsets.only(
              right: (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(2.5, constraints) : 0.w
            ),
            child: Checkbox(
              value: item.isSelected,
              activeColor: CColor.primaryColor,
              onChanged: (value) {
                logic.onChangeActivityManageData(
                    item.titleName,item,value!);
              },
            ),
          ),
        ],
      ),
    ))
        .toList();
  }

  _widgetMoreDetails(BuildContext context,BoxConstraints constraints,Orientation orientation) {
    return Container(
      margin: EdgeInsets.only(
          left: (kIsWeb)
              ? AppFontStyle.sizesWidthManageWeb(2.0, constraints)
              : (orientation == Orientation.portrait)?
          13.w : AppFontStyle.sizesWidthManageWeb(2.0, constraints) ,
          right: (kIsWeb)
              ? AppFontStyle.sizesWidthManageWeb(2.0, constraints)
              : (orientation == Orientation.portrait)? 10.w : AppFontStyle.sizesWidthManageWeb(2.0, constraints),
          top:(kIsWeb)
              ? AppFontStyle.sizesHeightManageWeb(1.5, constraints)
              :  (orientation == Orientation.portrait)? 20.h : AppFontStyle.sizesHeightManageWeb(0.5, constraints)),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              top:  (kIsWeb) ? AppFontStyle.sizesFontManageWeb(0.2, constraints) :1.h,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              Constant.trackingPrefDesc,
              textAlign: TextAlign.start,
              style: AppFontStyle.styleW500(
                  CColor.black,
                  (kIsWeb)
                      ? AppFontStyle.sizesFontManageWeb(1.5, constraints)
                      : (orientation == Orientation.portrait)
                          ? 15.sp
                          : AppFontStyle.sizesFontManageWeb(1.5, constraints)),
            ),
          ),
        ],
      ),
    );
  }

  _widgetButtonDetails(TrackingPrefController logic,BuildContext context,BoxConstraints constraints,Orientation orientation) {
    return Container(
      margin: EdgeInsets.only(
          top: (orientation == Orientation.portrait)
              ? 15.h
              : AppFontStyle.sizesHeightManageWeb(0.3, constraints),
          left: (kIsWeb)
              ? AppFontStyle.sizesWidthManageWeb(1.7, constraints)
              : 8.w,
          right: (kIsWeb)
              ? AppFontStyle.sizesWidthManageWeb(1.7, constraints)
              : 8.w),
      padding: EdgeInsets.only(
          top: (kIsWeb)
              ? AppFontStyle.sizesHeightManageWeb(1.5, constraints)
              : (orientation == Orientation.portrait)
              ? 4.h
              : AppFontStyle.sizesHeightManageWeb(1.5, constraints),
          bottom: (kIsWeb)
              ? AppFontStyle.sizesHeightManageWeb(1.5, constraints)
              : (orientation == Orientation.portrait)
              ? 10.h
              : AppFontStyle.sizesHeightManageWeb(1.5, constraints)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                /*logic.moveToScreen();*/
                configurationMainController!.pageConfigurationController
                    .nextPage(duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn);
              },
              child: Container(
                padding: EdgeInsets.all((kIsWeb) ? 5 : (orientation == Orientation.portrait)? 10 :5),
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
                      color: CColor.white,
                      fontSize: (kIsWeb)
                          ? AppFontStyle.sizesFontManageWeb(1.5, constraints)
                          : (orientation == Orientation.portrait)
                              ? 13.sp
                              : AppFontStyle.sizesFontManageWeb(
                                  1.6, constraints)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
