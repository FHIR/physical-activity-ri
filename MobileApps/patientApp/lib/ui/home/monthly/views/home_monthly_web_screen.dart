
import 'package:banny_table/ui/home/monthly/controllers/home_monthly_controllers.dart';
import 'package:banny_table/ui/home/monthly/datamodel/monthlyLogDataClass.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../utils/color.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/font_style.dart';
import '../../../../utils/sizer_utils.dart';

class HomeMonthlyWebScreen extends StatefulWidget {
  const HomeMonthlyWebScreen({super.key});

  @override
  State<HomeMonthlyWebScreen> createState() => _HomeMonthlyWebScreenState();
}

class _HomeMonthlyWebScreenState extends State<HomeMonthlyWebScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            leading:IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => {
                Get.back()
              },
            ),
            backgroundColor: CColor.primaryColor,
            title: Container(
              margin: EdgeInsets.only(left: Sizes.width_2),
              child: const Text(
                Constant.homeMonthly,
              ),
            ),
          ),
          body: SafeArea(
              child: LayoutBuilder(
                builder: (BuildContext context,BoxConstraints constraints) {
                  return OrientationBuilder(
                    builder: (context, orientation) {
                      return GetBuilder<HomeMonthlyControllers>(builder: (logic) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _widgetSelectedDates(context, logic,constraints),
                            Expanded(
                              child: Container(
                                child: _widgetUserData(context, orientation, logic,constraints),
                              ),
                            ),
                          ],
                        );
                      });
                    },
                  );
                }
              )
          ),
        );
      },
    );
  }

  _widgetSelectedDates(BuildContext context, HomeMonthlyControllers logic,BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: Sizes.width_4, vertical: Sizes.height_1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                logic.getAndSetWeeksData(isNext: false);
              });
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                logic.currentSelectedYear.toString(),
                style: AppFontStyle.styleW700(
                    CColor.black, FontSize.size_3),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                logic.getAndSetWeeksData(isNext: true);
              });
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              // color: CColor.backgroundColor,
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _widgetUserData(BuildContext context, orientation,
      HomeMonthlyControllers logic,constraints) {
    return SizedBox(
      width: double.infinity,
      child: Scrollbar(
        controller: logic.controllerScrollBar,
        child: SingleChildScrollView(
          controller: logic.controllerScrollBar,
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
              controller: logic.controller,
              scrollDirection: Axis.horizontal,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: logic.monthlyDataList
                    .map((e) =>
                    _itemMonthlyTable(context, orientation, e, logic,constraints))
                    .toList(),
              )
          ),
        ),
      ),
    );
  }

  Widget _itemMonthlyTable(BuildContext context, orientation,
      MonthlyLogDataClass monthlyLogDataClass, HomeMonthlyControllers logic,BoxConstraints constraints) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          monthlyLogDataClass.isShowHeader
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(),
                        // left: BorderSide(),
                        // right: BorderSide(),
                        bottom: BorderSide()
                    )),
                alignment: Alignment.center,
                height: Constant.commonHeightForTableBoxWeb,
                width: Sizes.width_15,
                child: const Text(
                  "Month",
                  // logic.logDataList.indexOf(e).toString() ?? "",
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                      // left: BorderSide(),
                      top: BorderSide(),

                      // right: BorderSide(),
                      bottom: BorderSide(),
                    )),
                alignment: Alignment.center,
                height: Constant.commonHeightForTableBoxWeb,
                width: Sizes.width_15,
                child: const Text(
                  Constant.headerDayPerWeek,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                      // left: BorderSide(),
                      top: BorderSide(),

                      // right: BorderSide(),
                      bottom: BorderSide(),
                    )),
                alignment: Alignment.center,
                height: Constant.commonHeightForTableBoxWeb,
                width: Sizes.width_15,
                child: const Text(
                  Constant.headerAverageMin,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                      // left: BorderSide(),
                      top: BorderSide(),
                      // right: BorderSide(),
                      bottom: BorderSide(),
                    )),
                alignment: Alignment.center,
                height: Constant.commonHeightForTableBoxWeb,
                width: Sizes.width_15,
                child: const Text(
                  Constant.headerAverageMinPerWeek,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                      // left: BorderSide(),
                      top: BorderSide(),

                      // right: BorderSide(),
                      bottom: BorderSide(),
                    )),
                alignment: Alignment.center,
                height: Constant.commonHeightForTableBoxWeb,
                width: Sizes.width_15,
                child: const Text(
                  Constant.headerStrength,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )
              : _monthlyTableInfo(
              context, orientation, monthlyLogDataClass, logic,constraints),
        ],
      ),
    );
  }

  Widget _monthlyTableInfo(BuildContext context, orientation,
      MonthlyLogDataClass monthlyLogDataClass, HomeMonthlyControllers logic,BoxConstraints constraints) {
    return Row(
      children: [
        if(monthlyLogDataClass.dayPerWeekValue == null &&
            monthlyLogDataClass.avgMinValue == null &&
            monthlyLogDataClass.avgMinPerWeekValue == null &&
            monthlyLogDataClass.strengthValue == null && monthlyLogDataClass.monthStartAndEndDataList
            .where((element) => element.isAfter(Utils.getLastDateOfCurrentMonth())).isEmpty)
          InkWell(
            onTap: () async {
              await logic.syncMonthlyWithTrackingChartData(monthlyLogDataClass.monthStartAndEndDataList);
            },
            child: Container(
              height: AppFontStyle.sizesHeightManageWeb(1.0, constraints),
              margin: EdgeInsets.only(bottom: AppFontStyle.sizesHeightManageWeb(0.5, constraints),left: AppFontStyle.sizesWidthManageWeb(1.0  , constraints)),
              // color: CColor.primaryColor,
              alignment: Alignment.bottomCenter,
              child: const Icon(
                Icons.refresh,
              ),
            ),
          )
        else Container(
          height: AppFontStyle.sizesHeightManageWeb(1.0, constraints),
          margin: EdgeInsets.only(bottom: Sizes.height_0_7,left: AppFontStyle.sizesWidthManageWeb(1.0 , constraints)),
          // color: CColor.primaryColor,
          alignment: Alignment.bottomCenter,
          child: const Icon(
            Icons.refresh,
            color: CColor.transparent,
          ),
        ),
        Container(
          /*decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(),
              )),*/
          margin: EdgeInsets.only(bottom: Sizes.height_0_7,),
          // padding:EdgeInsets.only(left: Sizes.width_2),
          alignment: Alignment.bottomCenter,
          height: Constant.commonHeightForTableBoxWeb,
          width: Sizes.width_11,
          child: Text(monthlyLogDataClass.monthName),
        ),
        Container(
          alignment: Alignment.center,
          height: Constant.commonHeightForTableBoxWeb,
          width: Sizes.width_15,
          child: Container(
            margin: EdgeInsets.only(bottom: Sizes.height_0_5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(left: Sizes.width_1_5),
                ),
                Expanded(
                  child: _editableDayPerWeek(
                      logic, monthlyLogDataClass, onChangeData: (value) {
                    // logic.onChangeDayPerWeekData(logic,monthlyLogDataClass,Constant.typeDayPerWeek,value);
                    // logic.monthlyDataInsertUpdate(
                    //     monthlyLogDataClass, value, Constant.typeDayPerWeek);
                  }),
                ),
                Container(
                  margin: EdgeInsets.only(right: Sizes.width_1_5),
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
              border: Border(
                // left: BorderSide(),
                //   right: BorderSide(),
                //   bottom: BorderSide()
              )),
          alignment: Alignment.center,
          height: Constant.commonHeightForTableBoxWeb,
          width: Sizes.width_15,
          child: Container(
            margin: EdgeInsets.only(bottom: Sizes.height_0_5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(left: Sizes.width_1_5),
                ),
                Expanded(
                  child: _editableAvgMin(
                      logic, monthlyLogDataClass, onChangeData: (value) {
                    // logic.onChangeDayPerWeekData(logic,monthlyLogDataClass,Constant.typeAvgMin,value);
                    // logic.monthlyDataInsertUpdate(
                    //     monthlyLogDataClass, value, Constant.typeAvgMin);
                  }),
                ),
                Container(
                  margin: EdgeInsets.only(right: Sizes.width_1_5),
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
              border: Border(
                // left: BorderSide(),
                //   right: BorderSide(),
                //   bottom: BorderSide(),
              )),
          alignment: Alignment.bottomCenter,
          height: Constant.commonHeightForTableBoxWeb,
          width: Sizes.width_15,
          child: Container(
            margin: EdgeInsets.only(bottom: Sizes.height_0_5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(left: Sizes.width_1_5),
                ),
                Expanded(
                  child: _editableAvgMinPerWeek(
                      logic, monthlyLogDataClass, onChangeData: (value) {
                    // logic.monthlyDataInsertUpdate(
                    //     monthlyLogDataClass, value, Constant.typeAvgMinPerWeek);
                  }),
                ),
                Container(
                  margin: EdgeInsets.only(right: Sizes.width_1_5),
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
              border: Border(
                // left: BorderSide(),
                //   right: BorderSide(),
                //   bottom: BorderSide(),
              )),
          alignment: Alignment.bottomCenter,
          height: Constant.commonHeightForTableBoxWeb,
          width: Sizes.width_15,
          child: Container(
            margin: EdgeInsets.only(bottom: Sizes.height_0_5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(left: Sizes.width_1_5),
                ),
                Expanded(
                  child: _editableStrengthDayWeek(
                      logic, monthlyLogDataClass, onChangeData: (value) {
                    // logic.monthlyDataInsertUpdate(
                    //     monthlyLogDataClass, value, Constant.typeStrength);
                  }),
                ),
                Container(
                  margin: EdgeInsets.only(right: Sizes.width_1_5),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _editableDayPerWeek(HomeMonthlyControllers logic,
      MonthlyLogDataClass monthlyLogDataClass,
      {Function? onChangeData}) {
    return Container(
/*      color: (monthlyLogDataClass.isOverrideDayPerWeek && monthlyLogDataClass.dayPerWeekValue != null &&
          !(Preference.shared.getBool(Preference.isAutoCalMode) ?? false)) ? CColor.primaryColor30 : CColor
          .transparent,*/
      child: TextField(
        textAlign: TextAlign.center,
        enableInteractiveSelection: false,
        keyboardType: TextInputType.number,
        controller: monthlyLogDataClass.dayPerWeekController,
        maxLines: 1,
        focusNode: monthlyLogDataClass.dayPerWeekFocus,
        cursorHeight: Constant.cursorHeightForWeb,
        /*style: TextStyle(fontSize: Constant.webTextFiledTextSize,
            color: (monthlyLogDataClass.isOverrideDayPerWeek &&
                !Constant.isAutoCalMode) ? CColor.primaryColor : CColor
                .black),*/
        style: TextStyle(fontSize: Constant.webTextFiledTextSize,
            color:CColor.black),
        autofocus: false,
        autocorrect: true,
        onChanged: (value) {
          if (onChangeData != null) {
            onChangeData.call(value);
          }
        },
      ),
    );
  }

  Widget _editableAvgMin(HomeMonthlyControllers logic,
      MonthlyLogDataClass monthlyLogDataClass,
      {Function? onChangeData}) {
    return Container(
/*      color: (monthlyLogDataClass.isOverrideAvgMin && monthlyLogDataClass.avgMinValue != null &&
          !(Preference.shared.getBool(Preference.isAutoCalMode) ?? false)) ? CColor.primaryColor30 : CColor
          .transparent,*/
      child: TextField(
        textAlign: TextAlign.center,
        enableInteractiveSelection: false,
        keyboardType: TextInputType.number,
        controller: monthlyLogDataClass.avgMinController,
        cursorHeight: Constant.cursorHeightForWeb,
        /*style: TextStyle(fontSize: Constant.webTextFiledTextSize,
            color: (monthlyLogDataClass.isOverrideAvgMin &&
                !Constant.isAutoCalMode) ? CColor.primaryColor : CColor
                .black),*/
        style: TextStyle(fontSize: Constant.webTextFiledTextSize,
            color:CColor.black),
        focusNode: monthlyLogDataClass.avgMinFocus,
        maxLines: 1,
        autofocus: false,
        autocorrect: true,
        onChanged: (value) {
          if (onChangeData != null) {
            onChangeData.call(value);
          }
        },
      ),
    );
  }

  Widget _editableAvgMinPerWeek(HomeMonthlyControllers logic,
      MonthlyLogDataClass monthlyLogDataClass,
      {Function? onChangeData}) {
    return Container(
/*        color: (monthlyLogDataClass.isOverrideAvgMinPerWeek && monthlyLogDataClass.avgMinPerWeekValue != null &&
        !(Preference.shared.getBool(Preference.isAutoCalMode) ?? false)) ? CColor.primaryColor30 : CColor
        .transparent,*/
      child: TextField(
        textAlign: TextAlign.center,
        enableInteractiveSelection: false,
        keyboardType: TextInputType.number,
        controller: monthlyLogDataClass.avgMinPerWeekController,
        cursorHeight: Constant.cursorHeightForWeb,
       /* style: TextStyle(fontSize: Constant.webTextFiledTextSize,
            color: (monthlyLogDataClass.isOverrideAvgMinPerWeek &&
                !Constant.isAutoCalMode) ? CColor.primaryColor : CColor
                .black),*/
        style: TextStyle(fontSize: Constant.webTextFiledTextSize,
            color:CColor.black),
        maxLines: 1,
        focusNode: monthlyLogDataClass.avgMinPerWeekFocus,
        autofocus: false,
        autocorrect: true,
        onChanged: (value) {
          if (onChangeData != null) {
            onChangeData.call(value);
          }
        },
      ),
    );
  }

  Widget _editableStrengthDayWeek(HomeMonthlyControllers logic,
      MonthlyLogDataClass monthlyLogDataClass,
      {Function? onChangeData}) {
    return  Container(
/*      color: (monthlyLogDataClass.isOverrideStrength && monthlyLogDataClass.strengthValue != null  &&
          !(Preference.shared.getBool(Preference.isAutoCalMode) ?? false)) ? CColor.primaryColor30 : CColor
          .transparent,*/
      child: TextField(
        textAlign: TextAlign.center,
        enableInteractiveSelection: false,
        keyboardType: TextInputType.number,
        controller: monthlyLogDataClass.strengthController,
        cursorHeight: Constant.cursorHeightForWeb,
        /*style: TextStyle(fontSize: Constant.webTextFiledTextSize,
            color: (monthlyLogDataClass.isOverrideStrength &&
                !Constant.isAutoCalMode) ? CColor.primaryColor : CColor
                .black),*/
        style: TextStyle(fontSize: Constant.webTextFiledTextSize,
            color:CColor.black),
        maxLines: 1,
        focusNode: monthlyLogDataClass.strengthFocus,
        autofocus: false,
        autocorrect: true,
        onChanged: (value) {
          if (onChangeData != null) {
            onChangeData.call(value);
          }
        },
      ),
    );
  }
}
