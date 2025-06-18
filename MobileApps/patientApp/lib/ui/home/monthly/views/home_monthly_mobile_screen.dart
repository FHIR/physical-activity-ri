import 'package:banny_table/ui/home/activityLog/controllers/home_controllers.dart';
import 'package:banny_table/ui/home/monthly/controllers/home_monthly_controllers.dart';
import 'package:banny_table/ui/home/monthly/datamodel/monthlyLogDataClass.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../utils/color.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/font_style.dart';
import '../../../../utils/sizer_utils.dart';
import '../../../../utils/utils.dart';
import '../../../bottomNavigation/controllers/bottom_navigation_controller.dart';

class HomeMonthlyMobileScreen extends StatelessWidget {
  // const HomeMonthlyMobileScreen({super.key});

  BottomNavigationController? bottomNavigationController;

  HomeMonthlyMobileScreen(
      {super.key, @required this.bottomNavigationController});


  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery
        .of(context)
        .orientation;
    // historyController!.onChangePortraitLandscape(orientation);
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetBuilder<HomeMonthlyControllers>(builder: (logic) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () =>
                {
                  Get.back()
                },
              ),
              actions: [
                if(Utils
                    .getServerListPreference()
                    .isNotEmpty)_widgetRefresh(context, logic),
              ],
              backgroundColor: CColor.primaryColor,
              title: Container(
                margin: EdgeInsets.only(left: Sizes.width_2),
                child: const Text(
                  Constant.homeMonthly,
                ),
              ),
            ),
            body: GetBuilder<HomeMonthlyControllers>(builder: (logic) {
              return SafeArea(
                child:
                Utils.pullToRefreshApi(Container(
                  color: CColor.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // _widgetBack(),
                      _widgetSelectedDates(context, logic),
                      Expanded(
                        child: Container(
                          child: _widgetUserData(context, orientation, logic),
                        ),
                      ),
                    ],
                  ),
                ), logic.refreshController, logic.onRefresh, logic.onLoading),


              );
            }),
          );
        });
      },
    );
  }

  _widgetSelectedDates(BuildContext context, HomeMonthlyControllers logic) {
    return GetBuilder<HomeControllers>(
      // init: HomeControllers(),
        init: Get.put(HomeControllers(), permanent: true),
        assignId: true,
        builder: (logicHome) {
          return Container(
            margin: EdgeInsets.symmetric(
                horizontal: Sizes.width_4, vertical: Sizes.height_1),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /*   GestureDetector(
              onTap: () {
                logicHome.onChangeMonth(false);
                Get.back();
                Get.put(HomeControllers());
                Get.put(HomeMonthlyControllers());
              },
              child: Container(
                margin: EdgeInsets.only(left: Sizes.width_2,),
                child: Icon(Icons.arrow_back, size: Sizes.width_8),
              ),
            ),
            const Spacer(),*/
                InkWell(
                  onTap: () {
                    logic.getAndSetWeeksData(isNext: false);
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
                          CColor.black, FontSize.size_10),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    logic.getAndSetWeeksData(isNext: true);
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
        });
  }

  _widgetRefresh(BuildContext context, HomeMonthlyControllers logic) {
    return InkWell(
      onTap: () {
        logic.reloadPage();
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          right: Sizes.width_5,
        ),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          // border: Border.all(color: CColor.black, width: 1),
            borderRadius: BorderRadius.circular(7)),
        child: const Icon(
          Icons.refresh,
          color: CColor.white,
        ),
      ),
    );
  }

  _widgetUserData(BuildContext context, orientation,
      HomeMonthlyControllers logic) {
    return Scrollbar(
      controller: logic.controllerScrollBar,
      child: SingleChildScrollView(
        controller: logic.controllerScrollBar,
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        child: SingleChildScrollView(
            controller: logic.controller,
            scrollDirection: Axis.horizontal,
            physics: ClampingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: logic.monthlyDataList
                  .map((e) => _itemMonthlyTable(context, orientation, e, logic))
                  .toList(),
            )
        ),
      ),
    );
  }

  Widget _itemMonthlyTable(BuildContext context, orientation,
      MonthlyLogDataClass monthlyLogDataClass, HomeMonthlyControllers logic) {
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
                height: (orientation == Orientation.portrait)
                    ? Sizes.height_9
                    : Sizes.height_5,
                width: (orientation == Orientation.portrait)
                    ? Sizes.width_20
                    : Sizes.width_50,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Text(
                      "Month",
                      // logic.logDataList.indexOf(e).toString() ?? "",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                      // left: BorderSide(),
                        top: BorderSide(),

                        // right: BorderSide(),
                        bottom: BorderSide())),
                alignment: Alignment.center,
                height: (orientation == Orientation.portrait)
                    ? Sizes.height_9
                    : Sizes.height_5,
                width: (orientation == Orientation.portrait)
                    ? Sizes.width_20
                    : Sizes.width_50,
                child: /* Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    PopupMenuButton(
                      elevation: 0,
                      constraints: BoxConstraints(
                          minWidth: Get.width * 0.1,
                          maxWidth: Get.width * 0.6
                      ),
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
                                    border: Border.all(width: Sizes.width_0_1),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: const Text(
                                    Constant.dayPerWeek)),
                          ),
                        ];
                      },
                      child: const Icon(
                        Icons.info_outline, color: CColor.gray,),
                    ),

                    const Text(
                      Constant.headerDayPerWeek,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),*/
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
                                border: Border.all(width: 1.w),
                                borderRadius: BorderRadius.circular(10)),
                            child: const Text(Constant.dayPerWeek)),
                      ),
                    ];
                  },
                  child: const Text(
                    Constant.headerDayPerWeek,
                    textAlign:
                    TextAlign
                        .center,
                    overflow: TextOverflow
                        .ellipsis,
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                      // left: BorderSide(),
                        top: BorderSide(),

                        // right: BorderSide(),
                        bottom: BorderSide())),
                alignment: Alignment.center,
                height: (orientation == Orientation.portrait)
                    ? Sizes.height_9
                    : Sizes.height_5,
                width: (orientation == Orientation.portrait)
                    ? Sizes.width_20
                    : Sizes.width_50,
                child: /*Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    PopupMenuButton(
                      elevation: 0,
                      constraints: BoxConstraints(
                          minWidth: Get.width * 0.1,
                          maxWidth: Get.width * 0.6
                      ),
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
                                    border: Border.all(width: Sizes.width_0_1),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: const Text(
                                    Constant.avgMin)),
                          ),
                        ];
                      },
                      child: const Icon(
                        Icons.info_outline, color: CColor.gray,),
                    ),

                    const Text(
                      Constant.headerAverageMin,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),*/
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
                                border: Border.all(width: 1.w),
                                borderRadius: BorderRadius.circular(10)),
                            child: const Text(Constant.avgMin)),
                      ),
                    ];
                  },
                  child: const Text(
                    Constant.headerAverageMin,
                    textAlign:
                    TextAlign
                        .center,
                    overflow: TextOverflow
                        .ellipsis,
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                      // left: BorderSide(),
                        top: BorderSide(),
                        // right: BorderSide(),
                        bottom: BorderSide())),
                alignment: Alignment.center,
                height: (orientation == Orientation.portrait)
                    ? Sizes.height_9
                    : Sizes.height_5,
                width: (orientation == Orientation.portrait)
                    ? Sizes.width_20
                    : Sizes.width_50,
                child: /*Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    PopupMenuButton(
                      elevation: 0,
                      constraints: BoxConstraints(
                          minWidth: Get.width * 0.1,
                          maxWidth: Get.width * 0.6
                      ),
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
                                    border: Border.all(width: Sizes.width_0_1),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: const Text(
                                    Constant.avgMinPerWeek)),
                          ),
                        ];
                      },
                      child: const Icon(
                        Icons.info_outline, color: CColor.gray,),
                    ),

                    const Text(
                      Constant.headerAverageMinPerWeek,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),*/
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
                                border: Border.all(width: 1.w),
                                borderRadius: BorderRadius.circular(10)),
                            child: const Text(Constant.avgMinPerWeek)),
                      ),
                    ];
                  },
                  child: const Text(
                    Constant.headerAverageMinPerWeek,
                    textAlign:
                    TextAlign
                        .center,
                    overflow: TextOverflow
                        .ellipsis,
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                      // left: BorderSide(),
                        top: BorderSide(),

                        right: BorderSide(),
                        bottom: BorderSide())),
                alignment: Alignment.center,
                height: (orientation == Orientation.portrait)
                    ? Sizes.height_9
                    : Sizes.height_5,
                width: (orientation == Orientation.portrait)
                    ? Sizes.width_20
                    : Sizes.width_50,
                child: /*Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PopupMenuButton(
                      elevation: 0,
                      constraints: BoxConstraints(
                          minWidth: Get.width * 0.1,
                          maxWidth: Get.width * 0.6
                      ),
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
                                    border: Border.all(width: Sizes.width_0_1),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: const Text(
                                    Constant.strengthDays)),
                          ),
                        ];
                      },
                      child: const Icon(
                        Icons.info_outline, color: CColor.gray,),
                    ),

                    const Text(
                      Constant.headerStrength,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),*/
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
                                border: Border.all(width: 1.w),
                                borderRadius: BorderRadius.circular(10)),
                            child: const Text(Constant.strengthDays)),
                      ),
                    ];
                  },
                  child: const Text(
                    Constant.headerStrength,
                    textAlign:
                    TextAlign
                        .center,
                    overflow: TextOverflow
                        .ellipsis,
                    maxLines: 2,
                  ),
                ),
              ),
            ],
          )
              : _monthlyTableInfo(
              context, orientation, monthlyLogDataClass, logic),
        ],
      ),
    );
  }

  Widget _monthlyTableInfo(BuildContext context, orientation,
      MonthlyLogDataClass monthlyLogDataClass, HomeMonthlyControllers logic) {
    return Row(
      children: [
        if(monthlyLogDataClass.dayPerWeekValue == null &&
            monthlyLogDataClass.avgMinValue == null &&
            monthlyLogDataClass.avgMinPerWeekValue == null &&
            monthlyLogDataClass.strengthValue == null &&
            monthlyLogDataClass.monthStartAndEndDataList
                .where((element) =>
                element.isAfter(Utils.getLastDateOfCurrentMonth()))
                .isEmpty)
          InkWell(
            onTap: () async {
              await logic.syncMonthlyWithTrackingChartData(
                  monthlyLogDataClass.monthStartAndEndDataList);
            },
            child: Container(
              height: (orientation == Orientation.portrait)
                  ? Sizes.height_5
                  : Sizes.height_4,
              margin: EdgeInsets.only(
                  bottom: Sizes.height_0_7, left: Sizes.width_1),
              // color: CColor.primaryColor,
              alignment: Alignment.bottomCenter,
              child: const Icon(
                Icons.refresh,
              ),
            ),
          )
        else
          Container(
            height: (orientation == Orientation.portrait)
                ? Sizes.height_5
                : Sizes.height_4,
            margin: EdgeInsets.only(
                bottom: Sizes.height_0_7, left: Sizes.width_1),
            // color: CColor.primaryColor,
            alignment: Alignment.bottomCenter,
            child: const Icon(
              Icons.refresh,
              color: CColor.transparent,
            ),
          ),
        Container(
          // decoration: const BoxDecoration(
          //     border: Border(
          //       left: BorderSide(),
          //     )),
          // color: CColor.primaryColor,
          margin: EdgeInsets.only(bottom: Sizes.height_0_7,),
          // padding:EdgeInsets.only(left: Sizes.width_2),
          alignment: Alignment.bottomCenter,
          height: (orientation == Orientation.portrait)
              ? Sizes.height_5
              : Sizes.height_4,
          width: (orientation == Orientation.portrait)
              ? Sizes.width_10
              : Sizes.width_30,
          child: Text(monthlyLogDataClass.monthName,
            style: TextStyle(
                fontWeight: (DateFormat(Constant.commonDateFormatMMMM).
                format(logic.currentSelectedMonthDateTime)
                    == monthlyLogDataClass.monthName)
                    ? FontWeight.w900
                    : FontWeight.normal
            ),),
        ),
        Container(
          alignment: Alignment.center,
          height: (orientation == Orientation.portrait)
              ? Sizes.height_5
              : Sizes.height_4,
          width: (orientation == Orientation.portrait)
              ? Sizes.width_20
              : Sizes.width_50,
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
          height: (orientation == Orientation.portrait)
              ? Sizes.height_5
              : Sizes.height_4,
          width: (orientation == Orientation.portrait)
              ? Sizes.width_20
              : Sizes.width_50,
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
          height: (orientation == Orientation.portrait)
              ? Sizes.height_5
              : Sizes.height_4,
          width: (orientation == Orientation.portrait)
              ? Sizes.width_20
              : Sizes.width_50,
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
                    // logic.onChangeAvgMinPerWeek(value,monthlyLogDataClass);
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
          height: (orientation == Orientation.portrait)
              ? Sizes.height_5
              : Sizes.height_4,
          width: (orientation == Orientation.portrait)
              ? Sizes.width_20
              : Sizes.width_50,
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
                    // logic.onChangeStrengthMonthly(value,monthlyLogDataClass);
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

/*  Widget _editableDayPerWeek(HomeMonthlyControllers logic,
      MonthlyLogDataClass monthlyLogDataClass,
      {Function? onChangeData}) {
    return KeyboardActions(
      config: Utils.buildKeyboardActionsConfig
        (monthlyLogDataClass.dayPerWeekFocus),
      child: Container(
        width: 20,
        height: 20,
        color: (monthlyLogDataClass.isOverrideDayPerWeek &&
            monthlyLogDataClass.dayPerWeekValue != null &&
            !Constant.isAutoCalMode) ? CColor.primaryColor30 : CColor
            .transparent,
        child: TextField(
          textAlign: TextAlign.center,
          enableInteractiveSelection: false,
          focusNode: monthlyLogDataClass.dayPerWeekFocus,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.number,

          style: TextStyle(fontSize: FontSize.size_10,
              color: CColor.black),
          controller: monthlyLogDataClass.dayPerWeekController,
          maxLines: 1,
          autofocus: false,
          autocorrect: true,
          onChanged: (value) {
            if (onChangeData != null) {
              onChangeData.call(value);
            }
          },
        ),
      ),
    );
  }*/

  Widget _editableDayPerWeek(HomeMonthlyControllers logic,
      MonthlyLogDataClass monthlyLogDataClass,
      {Function? onChangeData}) {
    return Container(
      width: 20,
      /*color: (monthlyLogDataClass.isOverrideDayPerWeek &&
          monthlyLogDataClass.dayPerWeekValue != null &&
          !(Preference.shared.getBool(Preference.isAutoCalMode) ?? false)) ? CColor.primaryColor30 : CColor
          .transparent,*/
      child: TextField(
        textAlign: TextAlign.center,
        enableInteractiveSelection: false,
        focusNode: monthlyLogDataClass.dayPerWeekFocus,
        textInputAction: TextInputAction.done,
        keyboardType: Utils.getInputTypeKeyboard(),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(fontSize: FontSize.size_10,
            color: CColor.black),
        controller: monthlyLogDataClass.dayPerWeekController,
        maxLines: 1,
        autofocus: false,
        autocorrect: true,
        onChanged: (value) {
          Debug.printLog(".......value....${value.toString()}");
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
      width: 20,
      // height: 20,
      /* color: (monthlyLogDataClass.isOverrideAvgMin &&
            monthlyLogDataClass.avgMinValue != null &&
            !(Preference.shared.getBool(Preference.isAutoCalMode) ?? false)) ? CColor.primaryColor30 : CColor
            .transparent,*/
      child: TextField(
        textAlign: TextAlign.center,
        enableInteractiveSelection: false,
        focusNode:
        monthlyLogDataClass.avgMinFocus,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: Utils.getInputTypeKeyboard(),
        textInputAction: TextInputAction.done,
        // keyboardType: TextInputType.number,
        controller: monthlyLogDataClass.avgMinController,
        /*style: TextStyle(fontSize: FontSize.size_10,
              color: (monthlyLogDataClass.isOverrideAvgMin &&
                  !Constant.isAutoCalMode) ? CColor.primaryColor : CColor
                  .black),*/
        style: TextStyle(fontSize: FontSize.size_10,
            color: CColor.black),
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

/*  Widget _editableAvgMin(HomeMonthlyControllers logic,
      MonthlyLogDataClass monthlyLogDataClass,
      {Function? onChangeData}) {
    return KeyboardActions(
      config: Utils.buildKeyboardActionsConfig
        (monthlyLogDataClass.avgMinFocus),
      child: Container(
        width: 20,
        height: 20,
        color: (monthlyLogDataClass.isOverrideAvgMin &&
            monthlyLogDataClass.avgMinValue != null &&
            !Constant.isAutoCalMode) ? CColor.primaryColor30 : CColor
            .transparent,
        child: TextField(
          textAlign: TextAlign.center,
          enableInteractiveSelection: false,
          focusNode:
          monthlyLogDataClass.avgMinFocus,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.number,
          controller: monthlyLogDataClass.avgMinController,
          style: TextStyle(fontSize: FontSize.size_10,
              color: CColor.black),
          maxLines: 1,
          autofocus: false,
          autocorrect: true,
          onChanged: (value) {
            if (onChangeData != null) {
              onChangeData.call(value);
            }
          },
        ),
      ),
    );
  }*/

  Widget _editableAvgMinPerWeek(HomeMonthlyControllers logic,
      MonthlyLogDataClass monthlyLogDataClass,
      {Function? onChangeData}) {
    return Container(
      width: 20,
      // height: 20,
      /*color: (monthlyLogDataClass.isOverrideAvgMinPerWeek &&
            monthlyLogDataClass.avgMinPerWeekValue != null &&
            !(Preference.shared.getBool(Preference.isAutoCalMode) ?? false)) ? CColor.primaryColor30 : CColor
            .transparent,*/
      child: TextField(
        textAlign: TextAlign.center,
        enableInteractiveSelection: false,
        focusNode:
        monthlyLogDataClass.avgMinPerWeekFocus,
        textInputAction: TextInputAction.done,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: Utils.getInputTypeKeyboard(),
        // keyboardType: TextInputType.number,
        controller: monthlyLogDataClass.avgMinPerWeekController,
        style: TextStyle(fontSize: FontSize.size_10,
            color: CColor.black),
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

  Widget _editableStrengthDayWeek(HomeMonthlyControllers logic,
      MonthlyLogDataClass monthlyLogDataClass,
      {Function? onChangeData}) {
    return Container(
      width: 20,
      // height: 20,
      /*color: (monthlyLogDataClass.isOverrideStrength &&
            monthlyLogDataClass.strengthValue != null &&
            !(Preference.shared.getBool(Preference.isAutoCalMode) ?? false)) ? CColor.primaryColor30 : CColor
            .transparent,*/
      child: TextField(
        textAlign: TextAlign.center,
        enableInteractiveSelection: false,
        focusNode:
        monthlyLogDataClass.strengthFocus,
        textInputAction: TextInputAction.done,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: Utils.getInputTypeKeyboard(),
        // keyboardType: TextInputType.number,
        style: TextStyle(fontSize: FontSize.size_10,
            color: CColor.black),
        controller: monthlyLogDataClass.strengthController,
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

/*  Widget _editableStrengthDayWeek(HomeMonthlyControllers logic,
      MonthlyLogDataClass monthlyLogDataClass,
      {Function? onChangeData}) {
    return KeyboardActions(
      config: Utils.buildKeyboardActionsConfig
        (monthlyLogDataClass.strengthFocus),
      child: Container(
        width: 20,
        height: 20,
        color: (monthlyLogDataClass.isOverrideStrength &&
            monthlyLogDataClass.strengthValue != null &&
            !Constant.isAutoCalMode) ? CColor.primaryColor30 : CColor
            .transparent,
        child: TextField(
          textAlign: TextAlign.center,
          enableInteractiveSelection: false,
          focusNode:
          monthlyLogDataClass.strengthFocus,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.number,
          */ /* style: TextStyle(fontSize: FontSize.size_10,
              color: (monthlyLogDataClass.isOverrideStrength &&
                  !Constant.isAutoCalMode) ? CColor.primaryColor : CColor
                  .black),*/ /*
          style: TextStyle(fontSize: FontSize.size_10,
              color: CColor.black),
          controller: monthlyLogDataClass.strengthController,
          maxLines: 1,
          autofocus: false,
          autocorrect: true,
          onChanged: (value) {
            if (onChangeData != null) {
              onChangeData.call(value);
            }
          },
        ),
      ),
    );
  }*/
}
