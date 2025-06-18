import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../utils/font_style.dart';
import '../../../../utils/utils.dart';
import '../controllers/home_controllers.dart';

class MobileHomeScreen extends StatelessWidget {
  MobileHomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColor.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context,BoxConstraints constraints) {
            return GetBuilder<HomeControllers>(
                init: HomeControllers(),
                assignId: true,
                builder: (logic) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: Sizes.width_8,vertical: Sizes.height_2),
                    child: Utils.pullToRefreshApi(_widgetHomeScreen(context,logic,constraints)
                        , logic.refreshController, logic.onRefresh, logic.onLoading),
                  );
                });
          }
        ),
      ),
    );
  }

  _widgetHomeScreen(BuildContext context,HomeControllers logic,BoxConstraints constraints){
    return SingleChildScrollView(
      child: Column(
        children: [
          _widgetNewActivity( context, logic, constraints),
          _widgetDaliyValues( context, logic, constraints),
          _widgetMonthlySummary( context, logic, constraints),
          _widgetTrackingChart( context, logic, constraints),
          _widgetToDoList( context, logic, constraints),
        ],
      ),
    );
  }

  _widgetNewActivity(BuildContext context,HomeControllers logic,BoxConstraints constraints){
    return Container(
        child:_widgetContainerBox(Constant.homeRecord,
            Constant.homeRecordActivity, (value) async {
              /*logic.onChangeMonth(false);
              var defaultImagePath = "";
              if(logic.activityLevelIconData.isNotEmpty){
                defaultImagePath = logic.activityLevelIconData[0];
              }else{
                defaultImagePath = Constant.iconBicycling;
              }
              var selectedDateFirstDate = logic.dailyLogDataList.where((
                  element) =>
              element.date
                  ==
                  DateFormat(Constant.commonDateFormatDdMmYyyy).format(
                      logic.selectedNewDate)
                  && element.displayLabel == Constant.itemBicycling)
                  .toList();

              if (selectedDateFirstDate.isNotEmpty) {
                logic.setSelectedDataClass(selectedDateFirstDate[0]);
              } else {
                logic.setSelectedDataClass(DailyLogClass());
              }

              logic.changeExDropDown(
                  "",
                  logic.selectedNewDate,
                  isGetData: true,iconPath: defaultImagePath);
              bottomNewActivityRecordData(context, logic);*/

              logic.onChangeMonth(false);
              var defaultImagePath = "";
              if(logic.activityLevelIconData.isNotEmpty){
                defaultImagePath = logic.activityLevelIconData[0];
              }else{
                defaultImagePath = Constant.iconBicycling;
              }

               logic.setSelectedDataClass(DailyLogClass());

              logic.changeExDropDown(
                  "",
                  logic.selectedNewDate,
                  isGetData: true,iconPath: defaultImagePath);
              bottomNewActivityRecordData(context, logic);

            },constraints)
    );
  }
  _widgetDaliyValues(BuildContext context,HomeControllers logic,BoxConstraints constraints){
    return Container(
      child:  _widgetContainerBox(Constant.homeDailyValues,
          Constant.homeDailyValuesIconsPath, (value) {
            logic.selectedNewDateDaliy = DateTime.now();
            var selectedDateFirstDate = logic.dailyLogDataListDay.where((
                element) =>
            element.date
                ==
                DateFormat(Constant.commonDateFormatDdMmYyyy).format(
                    logic.selectedNewDateDaliy))
                .toList();

            if (selectedDateFirstDate.isNotEmpty) {
              logic.setSelectedDayClass(selectedDateFirstDate[0]);
            } else {
              logic.setSelectedDayClass(DailyLogClass());
            }

            logic.changeDateDropDown(
                logic.selectedNewDateDaliy);
            bottomTapDetailsDaily(context, logic);

          },constraints),
    );
  }

  _widgetMonthlySummary(BuildContext context,HomeControllers logic,BoxConstraints constraints){
    return Container(
      child:  _widgetContainerBox(Constant.homeMonthly,
          Constant.homeMonthlySummary, (value) {
            Get.toNamed(AppRoutes.homeMonthly);
          },constraints),
    );
  }

  _widgetTrackingChart(BuildContext context,HomeControllers logic,BoxConstraints constraints){
    return Container(
      child:  _widgetContainerBox(Constant.homeTracking,
          Constant.homeTrackingChart, (value) {
            logic.gotoTrackingChartPage();
          },constraints),
    );
  }

  _widgetToDoList(BuildContext context,HomeControllers logic,BoxConstraints constraints){
    return  Container(
      // margin: EdgeInsets.only(bottom: Sizes.height_1_5),
      child:  _widgetContainerBoxToDo(Constant.homeToDoList,
          Constant.homeToDO, (value) {
            if(logic.toDoDataList.isNotEmpty) {
               Get.toNamed(AppRoutes.toDoListScreen)!.then((value) => {
                 logic.getToDoDataListApi(),
              });
            }
          },logic,constraints),
    );
  }


  _widgetContainerBox(String title, String icons, Function callBack,BoxConstraints constraints) {
    return InkWell(
      onTap: () {
        callBack.call("");
      },
      child: Container(
        margin: EdgeInsets.only(top: Sizes.height_2_1),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: CColor.txtGray50, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: Sizes.width_4, vertical: Sizes.height_2),
        child: Row(
          children: [
            Image.asset(icons,width: Sizes.width_6_5,height: Sizes.width_6_5,color: CColor.primaryColor ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                    left: Sizes.width_3
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppFontStyle.styleW700(
                          CColor.primaryColor, FontSize.size_13),
                    ),
                  ],
                ),
              ),
            ),
            Icon(Icons.navigate_next_rounded)
          ],
        ),
      ),
    );
  }

  _widgetContainerBoxToDo(String title, String icons, Function callBack, HomeControllers logic,BoxConstraints constraints) {
    return InkWell(
      onTap: () {
        callBack.call("");
      },
      child: Container(
        margin: EdgeInsets.only(top: Sizes.height_2_1),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: CColor.txtGray50, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: Sizes.width_4, vertical: Sizes.height_2),
        child: Row(
          children: [
            Image.asset(icons,width: Sizes.width_6_5,height: Sizes.width_6_5,color: CColor.primaryColor ),
            /*Expanded(
              child: Container(
                margin: EdgeInsets.only(
                    left: Sizes.width_3
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppFontStyle.styleW700(
                          CColor.primaryColor, FontSize.size_13),
                    ),
                  ],
                ),
              ),
            ),
            const Icon(Icons.navigate_next_rounded)*/
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: Sizes.width_3),
                child: Row(
                  children: [
                    Text(
                      // "Goal ${(logic.goalDataList.isEmpty && !logic.isGoalLoading)?"(None)":""}",
                      (logic.isTodoLoading) ? title :
                      (logic.toDoDataList.isEmpty) ? "$title (None)" : "$title (${logic.toDoDataList.length})",

                      style: AppFontStyle.styleW600(CColor.primaryColor, FontSize.size_12,),

                    ),
                    (logic.isTodoLoading) ?
                    Lottie.asset(
                        Constant.progressLoader, height: Sizes.height_4,delegates: LottieDelegates(
                      values: [
                        ValueDelegate.color(
                          const ['**', 'Ellipse 1', '**'],
                          value: CColor.primaryColor,
                        ),
                      ],
                    ),)
                        : Container(),
                  ],
                ),
              ),
            ),
            if(logic.toDoDataList.isNotEmpty &&
                !logic.isTodoLoading) const Icon(
                Icons.navigate_next_rounded)
          ],
        ),
      ),
    );
  }

  Future<void> showDatePickerDialog(HomeControllers logic, BuildContext context,
      StateSetter setStateBottom,bool isActivity) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          // backgroundColor: Colors.transparent,
          // insetPadding: const EdgeInsets.all(10),
          contentPadding: const EdgeInsets.all(0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          content: Container(
              // margin: const EdgeInsets.all(40),
              width: Get.width * 0.9,
              height: Get.height * 0.5,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                  color: CColor.white),
              child: SfDateRangePicker(
                onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                  if(isActivity) {
                    logic.onSelectionChangedDatePicker(
                        dateRangePickerSelectionChangedArgs);
                    setStateBottom(() {});
                  }else{
                    logic.onDayChangedDatePicker(
                        dateRangePickerSelectionChangedArgs);
                  }
                },
                selectionMode: DateRangePickerSelectionMode.single,
                view: DateRangePickerView.month,
                // showTodayButton: true,
                // allowViewNavigation: true,
                showActionButtons: true,
                showNavigationArrow: Utils.manageCalenderInNavigation(),
                cancelText: "Cancel",
                confirmText: "Ok",
                onCancel: () {
                  Get.back();
                },
                onSubmit: (p0) {
                  setStateBottom(() {
                    if(isActivity){
                      var iconPath = "";
                      try {
                        iconPath = logic.activityLevelIconData[logic.activityLevelData.indexWhere((element) => element ==
                                                  logic.selectedDateDailyLogClass.displayLabel).toInt()];
                      } catch (e) {
                        iconPath = Constant.iconBicycling;
                        Debug.printLog("..e..$e");
                      }
                      logic.changeExDropDown(
                          logic.selectedDateDailyLogClass.displayLabel!, logic.selectedNewDate,iconPath: iconPath);
                    }else{
                      logic.changeDateDropDown(logic.selectedNewDateDaliy);
                    }
                  });
                  Get.back();
                },
              )),
        );
      },
    ).then((value) => (value) {
          Debug.printLog("Close....");
          setStateBottom(() {});
        });
  }

  Widget _widgetNumberImage(String type,String icon) {
    return Row(
      children: [
        SizedBox(
          width:Sizes.width_8
        ),
        Image.asset(
          // Utils.getNumberIconNameFromType(type),
          icon,
          height: Sizes.width_5,
          width: Sizes.width_5,
        ),
        Container(
          margin: EdgeInsets.only(left: Sizes.width_2),
          width: Get.width * 0.3,
          child: Text(type,style: TextStyle(
            fontSize: FontSize.size_13
          ),
          overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
  ///Activity
  bottomNewActivityRecordData(BuildContext context, HomeControllers logic) {
    Future<void> future = showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: CColor.transparent,
        useSafeArea: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, StateSetter setStateBottom) {
              return/* Wrap(
                children: [*/
                  Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).viewInsets.top,
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    decoration: BoxDecoration(
                        color: CColor.white,
                        borderRadius: BorderRadius.circular(9)),
                    margin: EdgeInsets.only(
                        left: Sizes.width_1,
                        right: Sizes.width_1,
                        bottom: Sizes.height_0_5),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: CColor.primaryColor
                          ),
                          width: double.infinity,
                          height: Sizes.height_6,
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  left: Sizes.width_3
                                ),
                                child: InkWell(
                                    onTap: (){
                                      Get.back();
                                    },
                                    child: Icon(Icons.arrow_back_rounded,color: CColor.white,)),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(
                                    left: Sizes.width_5
                                  ),
                                  child: Text("New Activity",style:
                                  AppFontStyle.styleW500(CColor.white, FontSize.size_14)),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.back();
                                  Get.toNamed(AppRoutes.configuration, arguments: [false]);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                    right: Sizes.width_4
                                  ),
                                  child: Image.asset(Constant.settingConfigurationIcons,
                                    width: Sizes.width_6,
                                    height: Sizes.width_6,color: CColor.white,),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              margin: EdgeInsets.only(
                                left: Sizes.width_4_5,
                                right: Sizes.width_4_5,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          showDatePickerDialog(
                                              logic, context, setStateBottom, true)
                                              .then((value) => (value) {
                                            setStateBottom(() {});
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: Sizes.height_2
                                          ),
                                          padding: EdgeInsets.only(top: Sizes.height_1_2),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.calendar_month),
                                              Container(
                                                margin: EdgeInsets.only(
                                                  left: Sizes.width_3
                                                ),
                                                child: Text(
                                                  DateFormat(
                                                      Constant.commonDateFormatDdMmmYyyy)
                                                      .format(logic.selectedNewDate),
                                                  style: TextStyle(
                                                      color: CColor.black,
                                                      fontSize: FontSize.size_12,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: Sizes.height_2_8,
                                                  right: Sizes.width_0_3,
                                                  left: Sizes.width_0_3),
                                              child: PopupMenuButton<String>(
                                                itemBuilder: (context) => logic
                                                    .activityLevelData
                                                    .map(
                                                      (e) => PopupMenuItem<String>(
                                                      value: e.toString(),
                                                      child: Row(
                                                        children: [
                                                          _widgetNumberImage(e,
                                                              logic.activityLevelIconData[
                                                              logic.activityLevelData.indexWhere(
                                                                      (element) => element == e)
                                                                  .toInt()])
                                                        ],
                                                      )),
                                                )
                                                    .toList(),
                                                offset: Offset(-Sizes.width_9, (MediaQuery.of(context).viewInsets.bottom != 0.0) ? Sizes.height_27 : 0.0),
                                                color: Colors.grey[60],
                                                elevation: 2,
                                                onOpened: () {
                                                  FocusScope.of(Get.context!).requestFocus(new FocusNode());
                                                  Debug.printLog("Open Activity");
                                                  Debug.printLog("${MediaQuery.of(context).devicePixelRatio.toString()},,,,,,,,,,,,,${MediaQuery.of(context).viewInsets.bottom.toString()}");
                                                },
                                                onSelected: (value) {
                                                  setStateBottom(() {
                                                    logic.changeExDropDown(
                                                        value, logic.selectedNewDate,
                                                        iconPath: logic.activityLevelIconData[
                                                        logic.activityLevelData.indexWhere(
                                                                (element) => element == value).toInt()]);
                                                  });
                                                },
                                                child: Row(
                                                  children: [
                                                    _widgetNumberImage(
                                                        logic.selectedDateDailyLogClass
                                                            .displayLabel ?? Constant.itemBicycling,
                                                        logic.activityLevelIconData[
                                                        logic.activityLevelData.indexWhere(
                                                                (element) => element == logic.selectedDateDailyLogClass
                                                                .displayLabel).toInt()]),
                                                    const Icon(
                                                      Icons.arrow_drop_down_sharp,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: Sizes.height_2_5,
                                      bottom:Sizes.height_1_5
                                    ),
                                    child: Row(
                                      children: [
                                        /*Text(
                                          "Start Date: ",
                                          style: TextStyle(
                                              color: CColor.black,
                                              fontSize: FontSize.size_12),
                                        ),*/
                                        const Icon(Icons.access_time_outlined),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              selectDateTimeActivity(
                                                  context, false,
                                                  logic.selectedDateDailyLogClass.activityStartDate,
                                                  logic.selectedDateDailyLogClass.activityEndDate ?? DateTime.now(),
                                                      (dateTime) {
                                                    setStateBottom(() {
                                                      logic.selectedDateDailyLogClass.activityStartDate = dateTime;
                                                    });
                                                  });
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(left: Sizes.width_2),
                                              padding: const EdgeInsets.all(5),
                                              child: Text( DateFormat(
                                                  Constant.commonDateFormatHhMmA)
                                                  .format(logic.selectedDateDailyLogClass.activityStartDate),
                                                // DateFormat.yMMMd().add_jm().format(logic.selectedDateDailyLogClass.activityStartDate),
                                                style: TextStyle(fontSize: FontSize.size_12),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: activityRecordWidgetList(logic, context, setStateBottom)!,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        /*Container(
                          margin: EdgeInsets.only(top: Sizes.height_2),
                          child: Row(
                            children: [
                              Text(
                                "Start Date: ",
                                style: TextStyle(
                                    color: CColor.black,
                                    fontSize: FontSize.size_12),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    selectDateTimeActivity(
                                        context, false,
                                        logic.selectedDateDailyLogClass.activityStartDate,
                                        logic.selectedDateDailyLogClass.activityEndDate ?? DateTime.now(),
                                            (dateTime) {
                                          setStateBottom(() {
                                            logic.selectedDateDailyLogClass.activityStartDate = dateTime;
                                          });
                                        });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: Sizes.width_2),
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      DateFormat.yMMMd().add_jm().format(logic.selectedDateDailyLogClass.activityStartDate),
                                      style: TextStyle(fontSize: FontSize.size_12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),*/

                      ],
                    ),
                  );
                /*],
              );*/
            },
          );
        });
    future.then((void value) {
      logic.generateDateList();
      logic.resetData();
    });
  }

  Future<void> selectDateTimeActivity(BuildContext context,bool isEndDate,DateTime fromDate,DateTime toDate,
      Function callBack) async {
    var tempDate = DateTime.now();
    tempDate = (isEndDate)?toDate:fromDate;
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Wrap(
              children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  color: CColor.white,
                  child: Column(
                    children: [
                      Container(
                        height: Sizes.height_30,
                        padding: EdgeInsets.zero,
                        width: double.infinity,
                        margin: EdgeInsets.zero,
                        child: CupertinoTheme(
                          data: CupertinoThemeData(
                            textTheme: CupertinoTextThemeData(
                              dateTimePickerTextStyle: TextStyle(
                                color: Colors.black,
                                fontSize: FontSize.size_12,
                              ),
                            ),
                          ),
                          child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.time,
                            initialDateTime: (isEndDate)?toDate:fromDate,
                            backgroundColor: CColor.white,
                            onDateTimeChanged: (DateTime dateTime) {
                              tempDate = dateTime;
                              Debug.printLog("date......$tempDate");
                            },
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        color: CColor.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: Sizes.height_2),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: CColor.black,
                                    fontSize: FontSize.size_12,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                callBack.call(tempDate);
                                Get.back();
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: Sizes.width_5,right: Sizes.width_10,bottom: Sizes.height_2),
                                child: Text(
                                  "Select",
                                  style: TextStyle(
                                    color: CColor.black,
                                    fontSize: FontSize.size_12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget>? activityRecordWidgetList(HomeControllers logic, BuildContext context,setStateBottom){
    List<Widget> header = [];
    for (int i = 0; i < logic.trackingPrefList.length; i++) {
      if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderModerate && logic.trackingPrefList[i].isSelected){
        var modWidget = (Constant.configurationInfo.
        where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
            (element.isModerate) ).toList().isNotEmpty)?
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_1
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                    bottom: Sizes.height_3
                  ),
                  child: Icon(Icons.more_time)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    left: Sizes.width_4_5
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
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
                                      child: const Text(
                                          Constant.newActivityModMin)),
                                ),
                              ];
                            },
                            child: Text(
                              "${Constant.configurationHeaderModerate}",
                              style: TextStyle(
                                  color: CColor.black,
                                  fontSize: FontSize.size_10),
                            ),
                          ),
                        ],
                      ),

                      Container(
                        margin:
                        EdgeInsets.only(top: Sizes.height_1_7),
                      ),
                      (Constant.configurationInfo.
                      where((element) => element.title ==
                          logic.selectedDateDailyLogClass.displayLabel &&
                          element.isModerate ).toList().isNotEmpty) ?
                      Row(
                        children: [
                          Expanded(
                            child: _editableTextMod(logic,true,
                                onChangeData: (value) {
                                  logic.onChangeEditableModBottom(
                                      value);
                                }),
                          ),
                        ],
                      ) : Container(),
                      const Text("  "),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ):Container();
        header.add(modWidget);
      }
      else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderVigorous && logic.trackingPrefList[i].isSelected){
        var vig = (Constant.configurationInfo.
        where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
            (element.isVigorous) ).toList().isNotEmpty)?
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_1
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      bottom: Sizes.height_3
                  ),
                  child: Icon(Icons.more_time)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: Sizes.width_4_5
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
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
                                      child: const Text(
                                          Constant.newActivityVIgMin)),
                                ),
                              ];
                            },
                            child: Text(
                              "${Constant.configurationHeaderVigorous}",
                              style: TextStyle(
                                  color: CColor.black,
                                  fontSize: FontSize.size_10),
                            ),
                          ),

                        ],
                      ),

                      Container(
                        margin:
                        EdgeInsets.only(top: Sizes.height_1_7),
                      ),
                      (Constant.configurationInfo.
                      where((element) => element.title ==
                          logic.selectedDateDailyLogClass.displayLabel &&
                          element.isVigorous ).toList().isNotEmpty) ?
                      Row(
                        children: [
                          Expanded(
                              child: _editableTextVig(logic,true,
                                  onChangeData: (value) {
                                    logic.onChangeEditableVigBottom(
                                        value);
                                  }))
                        ],
                      ) : Container(),
                      const Text("  "),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
        /*Container(
          margin: EdgeInsets.only(
              top: Sizes.height_1
          ),
          // padding: EdgeInsets.only(top: Sizes.height_1_2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                          child: const Text(
                              Constant.newActivityVIgMin)),
                    ),
                  ];
                },
                child: Text(
                  "${Constant.configurationHeaderVigorous}: ",
                  style: TextStyle(
                      color: CColor.black,
                      fontSize: FontSize.size_12),
                ),
              ),


              (Constant.configurationInfo.
              where((element) => element.title ==
                  logic.selectedDateDailyLogClass.displayLabel &&
                  element.isVigorous ).toList().isNotEmpty) ?
              Expanded(
                  child: _editableTextVig(logic,true,
                      onChangeData: (value) {
                        logic.onChangeEditableVigBottom(
                            value);
                      })) : Container(),
              const Text("  "),
            ],
          ),
        )*/:Container();
        header.add(vig);
      }
      else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderTotal && logic.trackingPrefList[i].isSelected){
        var total = (Constant.configurationInfo.
        where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
            (element.isTotal) ).toList().isNotEmpty)?
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_1
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      bottom: Sizes.height_3
                  ),
                  child: Icon(Icons.timelapse)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: Sizes.width_4_5
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
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
                                      child: const Text(
                                          Constant.newActivityTotal)),
                                ),
                              ];
                            },
                            child: Text(
                              "${Constant.configurationHeaderTotal}: ",
                              style: TextStyle(
                                  color: CColor.black,
                                  fontSize: FontSize.size_10),
                            ),
                          ),

                        ],
                      ),

                      Container(
                        margin:
                        EdgeInsets.only(top: Sizes.height_1_7),
                      ),
                      (Constant.configurationInfo.
                      where((element) => element.title ==
                          logic.selectedDateDailyLogClass.displayLabel &&
                          element.isTotal ).toList().isNotEmpty) ?
                      Row(
                        children: [
                          Expanded(
                            child: _editableTextTotal(logic,true,
                                onChangeData: (value) {
                                  logic.onChangeEditableTotalMinBottom(
                                      value);
                                }),
                          )
                        ],
                      ) : Container(),
                      const Text("  "),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
        /*Container(
          margin: EdgeInsets.only(
              top: Sizes.height_1
          ),
          // padding: EdgeInsets.only(top: Sizes.height_1_2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                          child: const Text(
                              Constant.newActivityTotal)),
                    ),
                  ];
                },
                child: Text(
                  "${Constant.configurationHeaderTotal}: ",
                  style: TextStyle(
                      color: CColor.black,
                      fontSize: FontSize.size_12),
                ),
              ),
              (Constant.configurationInfo.
              where((element) => element.title ==
                  logic.selectedDateDailyLogClass.displayLabel &&
                  element.isTotal ).toList().isNotEmpty) ?
              Expanded(
                child: _editableTextTotal(logic,true,
                    onChangeData: (value) {
                      logic.onChangeEditableTotalMinBottom(
                          value);
                    }),
              ):Container(),
            ],
          ),
        )*/:Container();
        header.add(total);
      }
      /*else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderDays && logic.trackingPrefList[i].isSelected){
        var strengthDays = (Constant.configurationInfo.
        where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
            element.isDaysStr ).toList().isNotEmpty) ?
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_0_8
          ),
          padding: EdgeInsets.only(top: Sizes.height_0_5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                          child: const Text(
                              Constant.newActivityStrengthDays)),
                    ),
                  ];
                },
                child: Text(
                  "${Constant.daysStrength}: ",
                  style: TextStyle(
                      color: CColor.black,
                      fontSize: FontSize.size_12),
                ),
              ),
              Container(
                margin:
                EdgeInsets.only(left: Sizes.width_1_5),
              ),
              _checkBoxDaysStrength(
                context, logic, setStateBottom,true,),
            ],
          ),
        ): Container();
        header.add(strengthDays);
      }*/
      else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderCalories && logic.trackingPrefList[i].isSelected){
        var calories = (Constant.configurationInfo.
        where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
            element.isCalories ).toList().isNotEmpty) ?
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_1
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      bottom: Sizes.height_3
                  ),
                  child: const Icon(Icons.energy_savings_leaf_outlined)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: Sizes.width_4_5
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
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
                                      child: const Text(
                                          Constant.newActivityCalories)),
                                ),
                              ];
                            },
                            child: Text(
                              "${Constant.calories}",
                              style: TextStyle(
                                  color: CColor.black,
                                  fontSize: FontSize.size_10),
                            ),
                          ),
                        ],
                      ),

                      Container(
                        margin:
                        EdgeInsets.only(top: Sizes.height_1_7),
                      ),
                      (Constant.configurationInfo.
                      where((element) => element.title ==
                          logic.selectedDateDailyLogClass.displayLabel &&
                          element.isCalories ).toList().isNotEmpty) ?
                      Row(
                        children: [
                          Expanded(
                            child: _editableTextCalories(logic,true,
                                onChangeData: (value) {
                                  logic
                                      .onChangeEditableCaloriesBottom(
                                      value);
                                }),
                          ),
                        ],
                      ) : Container(),
                      const Text("  "),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )/*,
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_1_2
          ),
          padding: EdgeInsets.only(top: Sizes.height_0_2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                          child: const Text(
                              Constant.newActivityCalories)),
                    ),
                  ];
                },
                child: Text(
                  "${Constant.calories}: ",
                  style: TextStyle(
                      color: CColor.black,
                      fontSize: FontSize.size_12),
                ),
              ),


              Container(
                margin:
                EdgeInsets.only(left: Sizes.width_1_5),
              ),
              Expanded(
                child: _editableTextCalories(logic,true,
                    onChangeData: (value) {
                      logic
                          .onChangeEditableCaloriesBottom(
                          value);
                    }),
              ),
            ],
          ),
        ) */: Container();
        header.add(calories);
      }
      else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderSteps && logic.trackingPrefList[i].isSelected){
        var steps = (Constant.configurationInfo.
        where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
            element.isSteps ).toList().isNotEmpty) ?
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_1
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      bottom: Sizes.height_3
                  ),
                  child: const Icon(Icons.run_circle_outlined)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: Sizes.width_4_5
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
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
                                      child: const Text(
                                          Constant.newActivitySteps)),
                                ),
                              ];
                            },
                            child: Text(
                              "${Constant.steps}",
                              style: TextStyle(
                                  color: CColor.black,
                                  fontSize: FontSize.size_10),
                            ),
                          ),
                        ],
                      ),

                      Container(
                        margin:
                        EdgeInsets.only(top: Sizes.height_1_7),
                      ),
                      (Constant.configurationInfo.
                      where((element) => element.title ==
                          logic.selectedDateDailyLogClass.displayLabel &&
                          element.isSteps ).toList().isNotEmpty) ?
                      Row(
                        children: [
                          Expanded(
                            child: _editableTextSteps(logic,true,
                                onChangeData: (value) {
                                  logic
                                      .onChangeEditableStepsBottom(
                                      value);
                                }),
                          ),
                        ],
                      ) : Container(),
                      const Text("  "),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
        /*Container(
          padding: EdgeInsets.only(top: Sizes.height_1_2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                          child: const Text(
                              Constant.newActivitySteps)),
                    ),
                  ];
                },
                child: Text(
                  "${Constant.steps}: ",
                  style: TextStyle(
                      color: CColor.black,
                      fontSize: FontSize.size_12),
                ),
              ),


              Container(
                margin:
                EdgeInsets.only(left: Sizes.width_1_5),
              ),
              Expanded(
                child: _editableTextSteps(logic,true,
                    onChangeData: (value) {
                      logic
                          .onChangeEditableStepsBottom(
                          value);
                    }),
              ),
            ],
          ),
        ) */: Container();
        header.add(steps);
      }
      // else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderRest && logic.trackingPrefList[i].isSelected){
      //   var rest = (Constant.configurationInfo.
      //   where((element) => element.title ==
      //       logic.selectedDateDailyLogClass.displayLabel &&
      //       (element.isRest)  ).toList().isNotEmpty) ?
      //   Container(
      //     padding: EdgeInsets.only(top: Sizes.height_1_2),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Text(
      //           "${Constant.configurationHeaderRest}: ",
      //           style: TextStyle(
      //               color: CColor.black,
      //               fontSize: FontSize.size_12),
      //         ),
      //         Container(
      //           margin:
      //           EdgeInsets.only(left: Sizes.width_1_5),
      //         ),
      //         (Constant.configurationInfo.
      //         where((element) => element.title ==
      //             logic.selectedDateDailyLogClass.displayLabel &&
      //             element.isRest ).toList().isNotEmpty) ?
      //         Expanded(
      //           child:
      //           _editableTextRestHeartRate(
      //               logic,true, onChangeData: (value) {
      //             logic
      //                 .onChangeEditableRestHeartBottom(
      //                 value);
      //           }),
      //         ):Container(),
      //       ],
      //     ),
      //   ): Container();
      //   header.add(rest);
      // }
      else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderPeck && logic.trackingPrefList[i].isSelected){
        var peak = (Constant.configurationInfo.
        where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
            (element.isPeck)  ).toList().isNotEmpty) ?
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_1
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      bottom: Sizes.height_3
                  ),
                  child: const Icon(Icons.monitor_heart_outlined)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: Sizes.width_4_5
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
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
                                      child: const Text(
                                          Constant.newActivityPeakHeartRate)),
                                ),
                              ];
                            },
                            child: Text(
                              "${Constant.configurationHeaderPeck}",
                              style: TextStyle(
                                  color: CColor.black,
                                  fontSize: FontSize.size_10),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin:
                        EdgeInsets.only(top: Sizes.height_1_7),
                      ),
                      (Constant.configurationInfo.
                      where((element) => element.title ==
                          logic.selectedDateDailyLogClass.displayLabel &&
                          element.isPeck ).toList().isNotEmpty) ?
                      Row(
                        children: [
                          Expanded(
                            child:
                            _editableTextPeakHeartRate(
                                logic,true, onChangeData: (value) {
                              logic
                                  .onChangeEditablePeakHeartBottom(
                                  value);
                            }),
                          )
                        ],
                      ) : Container(),
                      const Text("  "),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )

        /*Container(
          padding: EdgeInsets.only(top: Sizes.height_1_2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                          child: const Text(
                              Constant.newActivityPeakHeartRate)),
                    ),
                  ];
                },
                child: Text(
                  "${Constant.configurationHeaderPeck}: ",
                  style: TextStyle(
                      color: CColor.black,
                      fontSize: FontSize.size_12),
                ),
              ),


              (Constant.configurationInfo.
              where((element) => element.title ==
                  logic.selectedDateDailyLogClass.displayLabel &&
                  element.isPeck ).toList().isNotEmpty) ?
              Expanded(
                child:
                _editableTextPeakHeartRate(
                    logic,true, onChangeData: (value) {
                  logic
                      .onChangeEditablePeakHeartBottom(
                      value);
                }),
              ): Container()
            ],
          ),
        )*/: Container();
        header.add(peak);
      }
      else if(logic.trackingPrefList[i].titleName == Constant.configurationExperience && logic.trackingPrefList[i].isSelected){
        var ex = (Constant.configurationInfo.
        where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
            element.isExperience ).toList().isNotEmpty) ?
        Container(
          padding: EdgeInsets.only(top: Sizes.height_1_2,bottom: Sizes.height_1_2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.reviews_outlined),
              Container(
                margin: EdgeInsets.only(
                  left: Sizes.width_4_5
                ),
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
                            child: const Text(
                                Constant.newActivityExperience)),
                      ),
                    ];
                  },
                  child: Text(
                    "${Constant.experience}: ",
                    style: TextStyle(
                        color: CColor.black,
                        fontSize: FontSize.size_10),
                  ),
                ),
              ),


              Container(
                margin:
                EdgeInsets.only(left: Sizes.width_1_5),
              ),
              Container(
                padding: EdgeInsets.only(
                    // top: Sizes.height_1_3,
                    right: Sizes.width_0_3,
                    left: Sizes.width_0_3),
                child: PopupMenuButton<int>(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Utils.getSmileyWidget(
                          Constant.smiley1ImgPath,
                          Constant.smiley1Title),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Utils.getSmileyWidget(
                          Constant.smiley2ImgPath,
                          Constant.smiley2Title),
                    ),
                    PopupMenuItem(
                      value: 3,
                      child: Utils.getSmileyWidget(
                          Constant.smiley3ImgPath,
                          Constant.smiley3Title),
                    ),
                    PopupMenuItem(
                      value: 4,
                      child: Utils.getSmileyWidget(
                          Constant.smiley4ImgPath,
                          Constant.smiley4Title),
                    ),
                    PopupMenuItem(
                      value: 5,
                      child: Utils.getSmileyWidget(
                          Constant.smiley5ImgPath,
                          Constant.smiley5Title),
                    ),
                    PopupMenuItem(
                      value: 6,
                      child: Utils.getSmileyWidget(
                          Constant.smiley6ImgPath,
                          Constant.smiley6Title),
                    ),
                    PopupMenuItem(
                      value: 7,
                      child: Utils.getSmileyWidget(
                          Constant.smiley7ImgPath,
                          Constant.smiley7Title),
                    ),
                  ],
                  offset: Offset(-Sizes.width_9, 0),
                  color: Colors.grey[60],
                  elevation: 2,
                  onSelected: (value) {

                    var expreianceIconValue = 0;
                    if (value == 1) {
                      logic.labelIcon = Constant.smiley1ImgPath;
                      expreianceIconValue = -3;
                    } else if (value == 2) {
                      logic.labelIcon = Constant.smiley2ImgPath;
                      expreianceIconValue = -2;
                    } else if (value == 3) {
                      logic.labelIcon = Constant.smiley3ImgPath;
                      expreianceIconValue = -1;
                    } else if (value == 4) {
                      logic.labelIcon = Constant.smiley4ImgPath;
                      expreianceIconValue = 0;
                    } else if (value == 5) {
                      logic.labelIcon = Constant.smiley5ImgPath;
                      expreianceIconValue = 1;
                    } else if (value == 6) {
                      logic.labelIcon = Constant.smiley6ImgPath;
                      expreianceIconValue = 2;
                    } else if (value == 7) {
                      logic.labelIcon = Constant.smiley7ImgPath;
                      expreianceIconValue = 3;
                    } else {
                      logic.labelIcon = Constant.smiley1ImgPath;
                      expreianceIconValue = -1;
                    }

                    setStateBottom(() {
                      logic.updateSmileyForBottom(expreianceIconValue);
                    });
                    // logic.addDaysDataWeekWise(mainIndex, daysIndex, labelName);
                  },
                  child: Row(
                    children: [
                      Image.asset(
                          Utils.getIconNameFromType(logic
                              .selectedDateDailyLogClass
                              .smileyType),
                          width: Sizes.width_8,
                          height: Sizes.height_2),
                      const Icon(
                        Icons.arrow_drop_down_sharp,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ): Container();
        header.add(ex);
      }

       // if(logic.trackingPrefList[i].titleName == Constant.configurationNotes && logic.trackingPrefList[i].isSelected){

      // }
    }
    var notes =  (Constant.configurationInfo.
    where((element) => element.title ==
        logic.selectedDateDailyLogClass.displayLabel &&
        element.isNotes ).toList().isNotEmpty) ?
    Container(
      margin: EdgeInsets.only(
          top: Sizes.height_1
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      bottom: Sizes.height_3
                  ),
                  child: const Icon(Icons.edit_note_sharp)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: Sizes.width_4_5
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
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
                                      child: const Text(
                                          Constant.newActivityNotes)),
                                ),
                              ];
                            },
                            child:Text(
                              Constant.noteType,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: CColor.black,
                                  fontSize: FontSize.size_10),
                            ),

                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          (Constant.configurationInfo.
          where((element) => element.title ==
              logic.selectedDateDailyLogClass.displayLabel &&
              element.isNotes ).toList().isNotEmpty) ?
          Row(
            children: [
              Expanded(
                child: _editableTextNotesBottom(
                    logic,true, onChangeData: (value) {
/*                  logic
                      .onChangeEditableTextValueNotesBottom(
                      value);*/
                  logic.getDataFromController();
                }),
              ),
            ],
          ) : Container(),
          const Text("  "),

        ],
      ),
    )
        :Container();
    header.add(notes);
    header.add(Container(
      padding: EdgeInsets.only(
          top: Sizes.height_1_8, bottom: Sizes.height_4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              Get.back();
              setStateBottom(() {});
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius:
                  BorderRadius.circular(10)),
              // padding: const EdgeInsets.all(8),
              padding: EdgeInsets.symmetric(
                  horizontal: Sizes.width_3_5,
                  vertical: Sizes.height_1_1
              ),
              child: Text(
                "Cancel",
                style: TextStyle(
                    color: CColor.black,
                    fontSize: FontSize.size_14),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              logic.insertUpdateRecordActivity();
              setStateBottom(() {});
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                  color: CColor.black),
              /*padding: EdgeInsets.only(
                  left: Sizes.width_6,
                  right: Sizes.width_6,
                  top: 7,
                  bottom: 7),*/
              padding: EdgeInsets.symmetric(
                horizontal: Sizes.width_9,
                vertical: Sizes.height_1_1
              ),
              child: Text(
                "Ok",
                style: TextStyle(
                    color: CColor.white,
                    fontSize: FontSize.size_14),
              ),
            ),
          ),
        ],
      ),
    ));
    return header;
  }

  ///Daliy
  bottomTapDetailsDaily(BuildContext context, HomeControllers logic,) {
    Future<void> future = showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: CColor.transparent,
        useSafeArea: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, StateSetter setStateBottom) {
              return Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      decoration: BoxDecoration(
                          color: CColor.white,
                          borderRadius: BorderRadius.circular(9)),
                      margin: EdgeInsets.only(
                          left: Sizes.width_1,
                          right: Sizes.width_1,
                          bottom: Sizes.height_0_5),
                    child:
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: CColor.primaryColor
                          ),
                          width: double.infinity,
                          height: Sizes.height_6,
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: Sizes.width_3
                                ),
                                child: InkWell(
                                    onTap: (){
                                      Get.back();
                                    },
                                    child: Icon(Icons.arrow_back_rounded,color: CColor.white,)),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: Sizes.width_5
                                  ),
                                  child: Text(Constant.homeDailyValues,style:
                                  AppFontStyle.styleW500(CColor.white, FontSize.size_14)),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.back();
                                  Get.toNamed(AppRoutes.configuration, arguments: [false]);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      right: Sizes.width_4
                                  ),
                                  child: Image.asset(Constant.settingConfigurationIcons,
                                    width: Sizes.width_6,
                                    height: Sizes.width_6,color: CColor.white,),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              margin: EdgeInsets.only(
                                left: Sizes.width_4_5,
                                right: Sizes.width_4_5,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            showDatePickerDialog(
                                                logic, context, setStateBottom,false)
                                                .then((value) => (value) {
                                              setStateBottom(() {});
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: Sizes.height_1,
                                              bottom: Sizes.height_1,
                                            ),
                                            padding: EdgeInsets.only(top: Sizes.height_1_2),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                const Icon(Icons.calendar_month),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: Sizes.width_3
                                                  ),
                                                  child: Text(
                                                    DateFormat(
                                                        Constant.commonDateFormatDdMmmYyyy)
                                                        .format(logic.selectedNewDateDaliy),
                                                    style: TextStyle(
                                                        color: CColor.black,
                                                        fontSize: FontSize.size_12,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      /*InkWell(
                                        onTap: (){
                                          Get.back();
                                          Get.toNamed(AppRoutes.configuration,arguments: [false]);

                                        },
                                        child: Image.asset(Constant.settingConfigurationIcons,
                                          width:  Sizes.width_6,
                                          height: Sizes.width_6,),
                                      )*/
                                    ],
                                  ),
                                  Column(
                                    children: dailyValueRecordWidgetList(logic,context,setStateBottom)!,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),


                      ],
                    )
                  );
            },
          );
        });
    future.then((void value) {
      logic.generateDateList();
    });
  }

  List<Widget>? dailyValueRecordWidgetList(HomeControllers logic, BuildContext context,setStateBottom){
    List<Widget> header = [];
    for (int i = 0; i < logic.trackingPrefList.length; i++) {
      if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderModerate && logic.trackingPrefList[i].isSelected){
        var modWidget = (Constant.configurationInfo.
        where((element) =>
        (element.isModerate) ).toList().isNotEmpty)?
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_1
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      bottom: Sizes.height_3
                  ),
                  child: Icon(Icons.more_time)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: Sizes.width_4_5
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
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
                                      child: const Text(
                                          Constant.dailyValuesModMin)),
                                ),
                              ];
                            },
                            child: Text(
                              "${Constant.dailyValueLabelHeaderModerate}",
                              style: TextStyle(
                                  color: CColor.black,
                                  fontSize: FontSize.size_10),
                            ),
                          ),
                        ],
                      ),

                      Container(
                        margin:
                        EdgeInsets.only(top: Sizes.height_1_7),
                      ),
                      (Constant.configurationInfo.
                      where((element) =>
                      element.isModerate ).toList().isNotEmpty) ?
                      Row(
                        children: [
                          Expanded(
                            child: _editableTextMod(logic,false,
                                onChangeData: (value) {
                                  logic.onChangeDayValue1Bottom(
                                      value);
                                }),
                          )
                        ],
                      ) : Container(),
                      const Text("  "),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ) :
        /*Container(
          margin: EdgeInsets.only(
              top: Sizes.height_1
          ),
          // padding: EdgeInsets.only(top: Sizes.height_1_2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                          child: const Text(
                              Constant.dailyValuesModMin)),
                    ),
                  ];
                },
                child:               Text(
                  "${Constant.dailyValueLabelHeaderModerate}: ",
                  style: TextStyle(
                      color: CColor.black,
                      fontSize: FontSize.size_12),
                ),

              ),

              Container(
                margin:
                EdgeInsets.only(left: Sizes.width_1_5),
              ),
              (Constant.configurationInfo.
              where((element) =>
              element.isModerate ).toList().isNotEmpty) ?
              Expanded(
                child: _editableTextMod(logic,false,
                    onChangeData: (value) {
                      logic.onChangeDayValue1Bottom(
                          value);
                    }),
              ) : Container(),
              const Text("  "),
            ],
          ),
        )*/Container();


        header.add(modWidget);
      }
      else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderVigorous && logic.trackingPrefList[i].isSelected){
        var vig =   (Constant.configurationInfo.
        where((element) =>
        (element.isModerate || element.isVigorous || element.isTotal) ).toList().isNotEmpty)?
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_1
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      bottom: Sizes.height_3
                  ),
                  child: Icon(Icons.more_time)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: Sizes.width_4_5
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
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
                                      child: const Text(
                                          Constant.dailyValuesVigMin)),
                                ),
                              ];
                            },
                            child: Text(
                              "${Constant.dailyValueLabelHeaderVigorous}",
                              style: TextStyle(
                                  color: CColor.black,
                                  fontSize: FontSize.size_10),
                            ),
                          ),
                        ],
                      ),

                      Container(
                        margin:
                        EdgeInsets.only(top: Sizes.height_1_7),
                      ),
                      (Constant.configurationInfo.
                      where((element) =>
                      element.isVigorous ).toList().isNotEmpty) ?
                      Row(
                        children: [
                          Expanded(
                              child: _editableTextVig(logic,false,
                                  onChangeData: (value) {
                                    logic.onChangeDayValue2Bottom(
                                        value);
                                  }))
                        ],
                      ) : Container(),
                      const Text("  "),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
        /*Container(
          margin: EdgeInsets.only(
              top: Sizes.height_1
          ),
          // padding: EdgeInsets.only(top: Sizes.height_1_2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                          child: const Text(
                              Constant.dailyValuesVigMin)),
                    ),
                  ];
                },
                child:               Text(
                  "${Constant.dailyValueLabelHeaderVigorous}: ",
                  style: TextStyle(
                      color: CColor.black,
                      fontSize: FontSize.size_12),
                ),


              ),

              Container(
                margin:
                EdgeInsets.only(left: Sizes.width_1_5),
              ),

              (Constant.configurationInfo.
              where((element) =>
              element.isVigorous ).toList().isNotEmpty) ?
              Expanded(
                  child: _editableTextVig(logic,false,
                      onChangeData: (value) {
                        logic.onChangeDayValue2Bottom(
                            value);
                      })) : Container(),
              const Text("  "),

            ],
          ),
        )*/:Container();
        header.add(vig);
      }
      else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderTotal && logic.trackingPrefList[i].isSelected){
        var total =   (Constant.configurationInfo.
        where((element) =>
        (element.isTotal) ).toList().isNotEmpty)?
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_1
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      bottom: Sizes.height_3
                  ),
                  child: Icon(Icons.timelapse)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: Sizes.width_4_5
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
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
                                      child: const Text(
                                          Constant.dailyValuesTotal)),
                                ),
                              ];
                            },
                            child: Text(
                              "${Constant.dailyValueLabelHeaderTotal}",
                              style: TextStyle(
                                  color: CColor.black,
                                  fontSize: FontSize.size_10),
                            ),
                          ),
                        ],
                      ),

                      Container(
                        margin:
                        EdgeInsets.only(top: Sizes.height_1_7),
                      ),
                      (Constant.configurationInfo.
                      where((element) =>
                      element.isTotal ).toList().isNotEmpty) ?
                      Row(
                        children: [
                          Expanded(
                            child: _editableTextTotal(logic,false,
                                onChangeData: (value) {
                                  logic.onChangeDayTotalBottom(
                                      value);
                                }),
                          )
                        ],
                      ) : Container(),
                      const Text("  "),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
        /*Container(
          margin: EdgeInsets.only(
              top: Sizes.height_1
          ),
          // padding: EdgeInsets.only(top: Sizes.height_1_2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                          child: const Text(
                              Constant.dailyValuesTotal)),
                    ),
                  ];
                },
                child:Text(
                  "${Constant.dailyValueLabelHeaderTotal}: ",
                  style: TextStyle(
                      color: CColor.black,
                      fontSize: FontSize.size_12),
                ),
              ),

              Container(
                margin:
                EdgeInsets.only(left: Sizes.width_1_5),
              ),

              (Constant.configurationInfo.
              where((element) =>
              element.isTotal ).toList().isNotEmpty) ?
              Expanded(
                child: _editableTextTotal(logic,false,
                    onChangeData: (value) {
                      logic.onChangeDayTotalBottom(
                          value);
                    }),
              ):Container(),
            ],
          ),
        )*/:Container();
        header.add(total);
      }
      /*else if(logic.trackingPrefList[i].titleName == Constant.configurationNotes && logic.trackingPrefList[i].isSelected){
        var notes =    (Constant.configurationInfo.
        where((element) =>
        element.isNotes ).toList().isNotEmpty) ?
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                        child: const Text(
                            Constant.dailyValuesNotes)),
                  ),
                ];
              },
              child: Container(
                margin: EdgeInsets.only(top: Sizes.height_2),
                child: Text(
                  "${Constant.noteType}: ",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: CColor.black,
                      fontSize: FontSize.size_12),
                ),
              ),

            ),


            Container(
              margin: EdgeInsets.only(
                  left: Sizes.width_1_5),
            ),
            Expanded(
              child: _editableTextNotesBottom(
                  logic,false, onChangeData: (value) {
                logic
                    .onChangeDayNotesBottom(
                    value);
              }),
            ),
          ],
        ) : Container();
        header.add(notes);
      }*/
      else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderDays && logic.trackingPrefList[i].isSelected){
        var strengthDays =(Constant.configurationInfo.
        where((element) =>
        element.isDaysStr ).toList().isNotEmpty) ?
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_1
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      bottom: Sizes.height_3
                  ),
                  child: Icon(Icons.view_day)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: Sizes.width_4_5
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
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
                                      child: const Text(
                                          Constant.dailyValuesStrengthDay)),
                                ),
                              ];
                            },
                            child: Text(
                              "${Constant.dailyValueLabelHeaderDays}",
                              style: TextStyle(
                                  color: CColor.black,
                                  fontSize: FontSize.size_10),
                            ),
                          ),
                        ],
                      ),

                      Container(
                        margin:
                        EdgeInsets.only(top: Sizes.height_1),
                      ),
                      (Constant.configurationInfo.
                      where((element) =>
                      element.isDaysStr ).toList().isNotEmpty) ?
                      Row(
                        children: [
                          _checkBoxDaysStrength(
                            context, logic, setStateBottom,false,),
                        ],
                      ) : Container(),
                      const Text("  "),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
        /*Container(
          margin: EdgeInsets.only(
              top: Sizes.height_0_8
          ),
          padding: EdgeInsets.only(top: Sizes.height_0_5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                          child: const Text(
                              Constant.dailyValuesStrengthDay)),
                    ),
                  ];
                },
                child:              Text(
                  "${Constant.dailyValueLabelHeaderDays}: ",
                  style: TextStyle(
                      color: CColor.black,
                      fontSize: FontSize.size_12),
                ),


              ),

              Container(
                margin:
                EdgeInsets.only(left: Sizes.width_1_5),
              ),
              _checkBoxDaysStrength(
                context, logic, setStateBottom,false,),
            ],
          ),
        )*/: Container();
        header.add(strengthDays);
      }
      else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderCalories && logic.trackingPrefList[i].isSelected){
        var calories = (Constant.configurationInfo.
        where((element) =>
        element.isCalories ).toList().isNotEmpty) ?
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_1
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      bottom: Sizes.height_3
                  ),
                  child: Icon(Icons.energy_savings_leaf_outlined)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: Sizes.width_4_5
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
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
                                      child: const Text(
                                          Constant.dailyValuesCalories)),
                                ),
                              ];
                            },
                            child: Text(
                              "${Constant.dailyValueLabelHeaderCalories}",
                              style: TextStyle(
                                  color: CColor.black,
                                  fontSize: FontSize.size_10),
                            ),
                          ),
                        ],
                      ),

                      Container(
                        margin:
                        EdgeInsets.only(top: Sizes.height_1_7),
                      ),
                      (Constant.configurationInfo.
                      where((element) =>
                      element.isCalories ).toList().isNotEmpty) ?
                      Row(
                        children: [
                          Expanded(
                            child: _editableTextCalories(logic,false,
                                onChangeData: (value) {
                                  logic
                                      .onChangeDayTitle3Bottom(
                                      value);
                                }),
                          ),
                        ],
                      ) : Container(),
                      const Text("  "),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
        /*Container(
          margin: EdgeInsets.only(
              top: Sizes.height_1_2
          ),
          padding: EdgeInsets.only(top: Sizes.height_0_2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                          child: const Text(
                              Constant.dailyValuesCalories)),
                    ),
                  ];
                },
                child:              Text(
                  "${Constant.dailyValueLabelHeaderCalories}: ",
                  style: TextStyle(
                      color: CColor.black,
                      fontSize: FontSize.size_12),
                ),


              ),

              Container(
                margin:
                EdgeInsets.only(left: Sizes.width_1_5),
              ),
              Expanded(
                child: _editableTextCalories(logic,false,
                    onChangeData: (value) {
                      logic
                          .onChangeDayTitle3Bottom(
                          value);
                    }),
              ),
            ],
          ),
        )*/ : Container();
        header.add(calories);
      }
      else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderSteps && logic.trackingPrefList[i].isSelected){
        var steps =  (Constant.configurationInfo.
        where((element) =>
        element.isSteps ).toList().isNotEmpty) ?
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_1
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      bottom: Sizes.height_3
                  ),
                  child: Icon(Icons.run_circle_outlined)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: Sizes.width_4_5
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
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
                                      child: const Text(
                                          Constant.dailyValuesSteps)),
                                ),
                              ];
                            },
                            child: Text(
                              "${Constant.dailyValueLabelHeaderSteps}",
                              style: TextStyle(
                                  color: CColor.black,
                                  fontSize: FontSize.size_10),
                            ),
                          ),
                        ],
                      ),

                      Container(
                        margin:
                        EdgeInsets.only(top: Sizes.height_1_7),
                      ),
                      (Constant.configurationInfo.
                      where((element) =>
                      element.isSteps ).toList().isNotEmpty) ?
                      Row(
                        children: [
                          Expanded(
                            child: _editableTextSteps(logic,false,
                                onChangeData: (value) {
                                  logic
                                      .onChangeDayTitle4Bottom(
                                      value);
                                }),
                          ),
                        ],
                      ) : Container(),
                      const Text("  "),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )

        /*Container(
          padding: EdgeInsets.only(top: Sizes.height_1_2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                          child: const Text(
                              Constant.dailyValuesSteps)),
                    ),
                  ];
                },
                child:              Text(
                  "${Constant.dailyValueLabelHeaderSteps}: ",
                  style: TextStyle(
                      color: CColor.black,
                      fontSize: FontSize.size_12),
                ),


              ),

              Container(
                margin:
                EdgeInsets.only(left: Sizes.width_1_5),
              ),
              Expanded(
                child: _editableTextSteps(logic,false,
                    onChangeData: (value) {
                      logic
                          .onChangeDayTitle4Bottom(
                          value);
                    }),
              ),
            ],
          ),
        )*/ : Container();
        header.add(steps);
      }
      else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderRest && logic.trackingPrefList[i].isSelected){
        var rest = (Constant.configurationInfo.
        where((element) =>
        (element.isRest)  ).toList().isNotEmpty) ?
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_1
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      bottom: Sizes.height_3
                  ),
                  child: Icon(Icons.monitor_heart_outlined)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: Sizes.width_4_5
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
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
                                      child: const Text(
                                          Constant.dailyValuesRestingHeartRate)),
                                ),
                              ];
                            },
                            child: Text(
                              "${Constant.dailyValueLabelHeaderRest}",
                              style: TextStyle(
                                  color: CColor.black,
                                  fontSize: FontSize.size_10),
                            ),
                          ),
                        ],
                      ),

                      Container(
                        margin:
                        EdgeInsets.only(top: Sizes.height_1_7),
                      ),
                      (Constant.configurationInfo.
                      where((element) =>
                      element.isRest ).toList().isNotEmpty) ?
                      Row(
                        children: [
                          Expanded(
                            child:
                            _editableTextRestHeartRate(
                                logic,false, onChangeData: (value) {
                              logic
                                  .onChangeDayValue1Title5Bottom(
                                  value);
                            }),
                          )
                        ],
                      ) : Container(),
                      const Text("  "),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )

        /*Container(
          padding: EdgeInsets.only(top: Sizes.height_1_2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                          child: const Text(
                              Constant.dailyValuesRestingHeartRate)),
                    ),
                  ];
                },
                child:              Text(
                  "${Constant.dailyValueLabelHeaderRest}: ",
                  style: TextStyle(
                      color: CColor.black,
                      fontSize: FontSize.size_12),
                ),


              ),

              Container(
                margin:
                EdgeInsets.only(left: Sizes.width_1_5),
              ),
              (Constant.configurationInfo.
              where((element) =>
              element.isRest ).toList().isNotEmpty) ?
              Expanded(
                child:
                _editableTextRestHeartRate(
                    logic,false, onChangeData: (value) {
                  logic
                      .onChangeDayValue1Title5Bottom(
                      value);
                }),
              ):Container(),
            ],
          ),
        )*/: Container();
        header.add(rest);
      }
      else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderPeck && logic.trackingPrefList[i].isSelected){
        var peak = (Constant.configurationInfo.
        where((element) =>
        (element.isPeck)).toList().isNotEmpty) ?
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_1
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      bottom: Sizes.height_3
                  ),
                  child: Icon(Icons.monitor_heart_rounded)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: Sizes.width_4_5
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
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
                                      child: const Text(
                                          Constant.dailyValuesPeakHeartRate)),
                                ),
                              ];
                            },
                            child: Text(
                              "${Constant.dailyValueLabelHeaderPeck}",
                              style: TextStyle(
                                  color: CColor.black,
                                  fontSize: FontSize.size_10),
                            ),
                          ),
                        ],
                      ),

                      Container(
                        margin:
                        EdgeInsets.only(top: Sizes.height_1_7),
                      ),
                      (Constant.configurationInfo.
                      where((element) =>
                      element.isPeck ).toList().isNotEmpty) ?
                      Row(
                        children: [
                          Expanded(
                            child:
                            _editableTextPeakHeartRate(
                                logic, false,onChangeData: (value) {
                              logic
                                  .onChangeDayValue2Title5Bottom(
                                  value);
                            }),
                          )
                        ],
                      ) : Container(),
                      const Text("  "),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )

        /*Container(
          padding: EdgeInsets.only(top: Sizes.height_1_2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                          child: const Text(
                              Constant.dailyValuesPeakHeartRate)),
                    ),
                  ];
                },
                child:              Text(
                  "${Constant.dailyValueLabelHeaderPeck}: ",
                  style: TextStyle(
                      color: CColor.black,
                      fontSize: FontSize.size_12),
                ),


              ),

              Container(
                margin:
                EdgeInsets.only(left: Sizes.width_1_5),
              ),
              (Constant.configurationInfo.
              where((element) =>
              element.isPeck ).toList().isNotEmpty) ?
              Expanded(
                child:
                _editableTextPeakHeartRate(
                    logic, false,onChangeData: (value) {
                  logic
                      .onChangeDayValue2Title5Bottom(
                      value);
                }),
              ): Container()
            ],
          ),
        )*/: Container();
        header.add(peak);
      }
      /*else if(logic.trackingPrefList[i].titleName == Constant.configurationExperience && logic.trackingPrefList[i].isSelected){
        var ex =
        (Constant.configurationInfo.
        where((element) =>
        element.isExperience ).toList().isNotEmpty) ?
        Container(
          padding: EdgeInsets.only(top: Sizes.height_1_2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                          child: const Text(
                              Constant.dailyValuesModMin)),
                    ),
                  ];
                },
                child:              Text(
                  "${Constant.experience}: ",
                  style: TextStyle(
                      color: CColor.black,
                      fontSize: FontSize.size_12),
                ),


              ),

              Container(
                margin:
                EdgeInsets.only(left: Sizes.width_1_5),
              ),
              Container(
                padding: EdgeInsets.only(
                    top: Sizes.height_1_3,
                    right: Sizes.width_0_3,
                    left: Sizes.width_0_3),
                child: PopupMenuButton<int>(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Utils.getSmileyWidget(
                          Constant.smiley1ImgPath,
                          Constant.smiley1Title),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Utils.getSmileyWidget(
                          Constant.smiley2ImgPath,
                          Constant.smiley2Title),
                    ),
                    PopupMenuItem(
                      value: 3,
                      child: Utils.getSmileyWidget(
                          Constant.smiley3ImgPath,
                          Constant.smiley3Title),
                    ),
                    PopupMenuItem(
                      value: 4,
                      child: Utils.getSmileyWidget(
                          Constant.smiley4ImgPath,
                          Constant.smiley4Title),
                    ),
                    PopupMenuItem(
                      value: 5,
                      child: Utils.getSmileyWidget(
                          Constant.smiley5ImgPath,
                          Constant.smiley5Title),
                    ),
                    PopupMenuItem(
                      value: 6,
                      child: Utils.getSmileyWidget(
                          Constant.smiley6ImgPath,
                          Constant.smiley6Title),
                    ),
                    PopupMenuItem(
                      value: 7,
                      child: Utils.getSmileyWidget(
                          Constant.smiley7ImgPath,
                          Constant.smiley7Title),
                    ),
                  ],
                  offset: Offset(-Sizes.width_9, 0),
                  color: Colors.grey[60],
                  elevation: 2,
                  onSelected: (value) {
                    // var labelIcon = "";

                    if (value == 1) {
                      logic.labelIcon = Constant.smiley1ImgPath;
                    } else if (value == 2) {
                      logic.labelIcon = Constant.smiley2ImgPath;
                    } else if (value == 3) {
                      logic.labelIcon = Constant.smiley3ImgPath;
                    } else if (value == 4) {
                      logic.labelIcon = Constant.smiley4ImgPath;
                    } else if (value == 5) {
                      logic.labelIcon = Constant.smiley5ImgPath;
                    } else if (value == 6) {
                      logic.labelIcon = Constant.smiley6ImgPath;
                    } else if (value == 7) {
                      logic.labelIcon = Constant.smiley7ImgPath;
                    } else {
                      logic.labelIcon =
                          Constant.smiley4ImgPath;
                    }
                    setStateBottom(() {
                      logic.updateSmileyForDayBottom(value);
                    });
                  },
                  child: Row(
                    children: [
                      Image.asset(
                          Utils.getIconNameFromType(logic
                              .selectedDateDailyLogDayClass
                              .smileyType),
                          width: Sizes.width_8,
                          height: Sizes.height_2),
                      const Icon(
                        Icons.arrow_drop_down_sharp,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ): Container();
        header.add(ex);
      }*/
    }
    header.add(Container(
      padding: EdgeInsets.only(
          top: Sizes.height_1_8, bottom: Sizes.height_4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              Get.back();
              setStateBottom(() {});
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius:
                  BorderRadius.circular(10)),
              padding: EdgeInsets.symmetric(
                  horizontal: Sizes.width_3_5,
                  vertical: Sizes.height_1_1
              ),              child: Text(
                "Cancel",
                style: TextStyle(
                    color: CColor.black,
                    fontSize: FontSize.size_14),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              logic.insertUpdateDailyValuesFromSheet();
              setStateBottom(() {});
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                  color: CColor.black),
              padding: EdgeInsets.symmetric(
                  horizontal: Sizes.width_9,
                  vertical: Sizes.height_1_1
              ),
              child: Text(
                "Ok",
                style: TextStyle(
                    color: CColor.white,
                    fontSize: FontSize.size_14),
              ),
            ),
          ),
        ],
      ),
    ));
    return header;
  }

  /*User on The Bottom Sheet*/

  Widget _editableTextMod(HomeControllers logic,bool isActivity,
      {Function? onChangeData}) {
    return SizedBox(
      width: 20,
      height: 20,
      child: TextField(
        /*enabled: (logic.selectedDateDailyLogClass.displayLabel ==
            Constant.itemRunning) ? false : true,*/
/*        enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.title ==
            (isActivity ? logic.selectedDateDailyLogClass.displayLabel : logic.selectedDateDailyLogDayClass.displayLabel) &&
            element.isModerate ).toList().isNotEmpty),*/
        textAlign: TextAlign.start,
        decoration: const InputDecoration(
            hintText: 'Mod'
        ),
        enableInteractiveSelection: false,
        keyboardType: Utils.getInputTypeKeyboard(),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(fontSize: FontSize.size_10),
        maxLines: 1,
        autofocus: false,
        autocorrect: true,
        controller: !isActivity ? logic.selectedDateDailyLogDayClass.modValueController: logic.selectedDateDailyLogClass.modValueController,
        onChanged: (value) {
          if (onChangeData != null) {
            onChangeData.call(value);
          }
        },
      ),
    );
  }

  Widget _editableTextVig(HomeControllers logic,bool isActivity,
      {Function? onChangeData}) {
    return SizedBox(
      width: 20,
      height: 20,
      child: TextField(
        textAlign: TextAlign.start,
        enableInteractiveSelection: false,
        keyboardType: Utils.getInputTypeKeyboard(),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(fontSize: FontSize.size_10),
        maxLines: 1,
        decoration: const InputDecoration(
            hintText: 'Vig'
        ),
        autofocus: false,
        autocorrect: true,
        controller: !isActivity ? logic.selectedDateDailyLogDayClass.vigValueController: logic.selectedDateDailyLogClass.vigValueController,
        onChanged: (value) {
          if (onChangeData != null) {
            onChangeData.call(value);
          }
        },
      ),
    );
  }

  Widget _editableTextTotal(HomeControllers logic,bool isActivity,
      {Function? onChangeData}) {
    return SizedBox(
      width: 20,
      height: 20,
      child: TextField(
        /*enabled: (logic.selectedDateDailyLogClass.displayLabel ==
            Constant.itemRunning) ? false : true,*/
/*        enabled: ( Constant.configurationInfo.where((element) => element.title ==
            (isActivity ? logic.selectedDateDailyLogClass.displayLabel : logic.selectedDateDailyLogDayClass.displayLabel) &&
            element.isTotal ).toList().isNotEmpty ),*/
        textAlign: TextAlign.start,
        enableInteractiveSelection: false,
        keyboardType: Utils.getInputTypeKeyboard(),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(
          fontSize: FontSize.size_10,
        ),
        maxLines: 1,
        decoration: const InputDecoration(
            hintText: 'Total'
        ),
        autofocus: false,
        autocorrect: true,
        controller:  !isActivity ? logic.selectedDateDailyLogDayClass.totalValueController: logic.selectedDateDailyLogClass.totalValueController,
        onChanged: (value) {
          if (onChangeData != null) {
            onChangeData.call(value);
          }
        },
      ),
    );
  }

  _checkBoxDaysStrength(
      BuildContext context, HomeControllers logic, StateSetter setState,bool isActivity,) {
    return Container(
      height: Sizes.height_3,
      child: Checkbox(
        value: (isActivity) ? logic.selectedDateDailyLogClass.isCheckedDayData : logic.selectedDateDailyLogDayClass.isCheckedDayData,
        onChanged: /*(!Constant.isEditMode || Constant.configurationInfo.where((element) => element.title ==
            (isActivity ? logic.selectedDateDailyLogClass.displayLabel : logic.selectedDateDailyLogDayClass.displayLabel) &&
            element.isDaysStr ).toList().isEmpty )
            ? null
            :*/(value) {
          setState(() {
            if(isActivity){
              logic.onChangeCheckBoxValueBottom(value!);
            }else{
              logic.onChangeCheckBoxDayValueBottom(value!);
            }
          });
        },
      ),
    );
  }

  Widget _editableTextCalories(HomeControllers logic,bool isActivity,
      {Function? onChangeData}) {
    return SizedBox(
      width: 20,
      height: 20,
      child: TextField(
        textAlign: TextAlign.start,
        enableInteractiveSelection: false,
        keyboardType: Utils.getInputTypeKeyboard(),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(fontSize: FontSize.size_10),
        maxLines: 1,
        autofocus: false,
        autocorrect: true,
        decoration: const InputDecoration(
            hintText: 'Calories'
        ),
        controller: !isActivity ? logic.selectedDateDailyLogDayClass.caloriesValueController:  logic.selectedDateDailyLogClass.caloriesValueController,
        onChanged: (value) {
          if (onChangeData != null) {
            onChangeData.call(value);
          }
        },
      ),
    );
  }

  Widget _editableTextSteps(HomeControllers logic,bool isActivity,
      {Function? onChangeData}) {
    return SizedBox(
      width: 20,
      height: 20,
      child: TextField(
        textAlign: TextAlign.start,
        enableInteractiveSelection: false,
        keyboardType: Utils.getInputTypeKeyboard(),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(fontSize: FontSize.size_10),
        maxLines: 1,
        autofocus: false,
        autocorrect: true,
        decoration: const InputDecoration(
            hintText: 'Steps'
        ),
        controller: !isActivity ? logic.selectedDateDailyLogDayClass.stepsValueController:  logic.selectedDateDailyLogClass.stepsValueController,
        onChanged: (value) {
          if (onChangeData != null) {
            onChangeData.call(value);
          }
        },
      ),
    );
  }

  Widget _editableTextRestHeartRate(HomeControllers logic,bool isActivity,
      {Function? onChangeData}) {
    return SizedBox(
      width: 20,
      height: 20,
      child: TextField(
        textAlign: TextAlign.start,
        enableInteractiveSelection: false,
        keyboardType: Utils.getInputTypeKeyboard(),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(fontSize: FontSize.size_10),
        maxLines: 1,
        decoration: const InputDecoration(
            hintText: 'Rest'
        ),
        autofocus: false,
        autocorrect: true,
        controller:!isActivity ? logic.selectedDateDailyLogDayClass.restHeartValueController:  logic.selectedDateDailyLogClass.restHeartValueController,
        onChanged: (value) {
          if (onChangeData != null) {
            onChangeData.call(value);
          }
        },
      ),
    );
  }

  Widget _editableTextPeakHeartRate(HomeControllers logic,bool isActivity,
      {Function? onChangeData}) {
    return SizedBox(
      width: 20,
      height: 20,
      child: TextField(
        // enabled: Constant.isEditMode,
/*        enabled: (Constant.configurationInfo.where((element) => element.title ==
            (isActivity ? logic.selectedDateDailyLogClass.displayLabel : logic.selectedDateDailyLogDayClass.displayLabel) &&
            element.isPeck ).toList().isNotEmpty ),*/
        textAlign: TextAlign.start,
        enableInteractiveSelection: false,
        keyboardType: Utils.getInputTypeKeyboard(),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(fontSize: FontSize.size_10),
        maxLines: 1,
        decoration: const InputDecoration(
            hintText: 'Peak'
        ),
        autofocus: false,
        autocorrect: true,
        controller:!isActivity ? logic.selectedDateDailyLogDayClass.peakHeartValueController:  logic.selectedDateDailyLogClass.peakHeartValueController,
        onChanged: (value) {
          if (onChangeData != null) {
            onChangeData.call(value);
          }
        },
      ),
    );
  }

  Widget _editableTextNotesBottom(HomeControllers logic,bool isActivity,
      {Function? onChangeData}) {
    return SizedBox(
      height: Get.height*0.3,
      child:Container(
        // margin: EdgeInsets.only(top: Sizes.height_1,/*bottom:  Sizes.height_2*/),
        decoration: BoxDecoration(
            border: Border.all(
                color: CColor.black,
                width: 1
            ),
            borderRadius: BorderRadius.circular(10)
        ),
        child: /*HtmlEditor(
          controller: !isActivity ? logic.selectedDateDailyLogDayClass.notesController: logic.selectedDateDailyLogClass.notesController,
          htmlEditorOptions: const HtmlEditorOptions(
            hint: 'Your text here...',
            adjustHeightForKeyboard: false,
            autoAdjustHeight: true,
          ),
          htmlToolbarOptions: const HtmlToolbarOptions(
            toolbarPosition: ToolbarPosition.belowEditor,
            toolbarType: ToolbarType.nativeGrid,
            defaultToolbarButtons: [
              StyleButtons(style: true),
              FontButtons(strikethrough: false,clearAll: false,subscript: false,superscript: false),
              // ColorButtons(),
              ListButtons(listStyles: false,ol: true,ul: true),
              ParagraphButtons(
                  lineHeight: false,
                  alignLeft: true,
                  alignRight: true,
                  alignJustify: true,
                  textDirection: false,
                  caseConverter: false),
              // InsertButtons(),
              // OtherButtons(),
            ],
          ),
          // otherOptions: OtherOptions(height: Sizes.height_40),
          otherOptions: OtherOptions(height: Sizes.height_40,decoration: BoxDecoration(
              border: Border.all(color: CColor.transparent)
          )),
          callbacks: Callbacks(
            onChangeContent: (String? changed) {
              Debug.printLog('content changed to $changed');
            },
            onChangeCodeview: (String? changed) {
              Debug.printLog('code changed to $changed');
              if (onChangeData != null) {
                onChangeData.call(changed);
              }
              logic.selectedDateDailyLogDayClass.notesValues = changed ?? "";
              // logic.onChangeHTML(changed ?? "");
            },
          ),
        ),*/
        Column(
          children: [
            QuillToolbar.simple(
                configurations: QuillSimpleToolbarConfigurations(
                  controller: !isActivity ? logic.selectedDateDailyLogDayClass.notesController: logic.selectedDateDailyLogClass.notesController,
                  showFontFamily: false,
                  showFontSize: false,
                  showBoldButton: true,
                  showItalicButton: true,
                  showUnderLineButton: true,
                  showStrikeThrough: false,
                  showInlineCode: false,
                  showClearFormat: false,
                  showListCheck: false,
                  showListNumbers: false,
                  showListBullets: false,
                  // showListCheck: false,
                  showCodeBlock: false,
                  showIndent: false,
                  showLink: false,
                  // showHorizontalRule: false,
                  showAlignmentButtons: true,
                  showLeftAlignment: true,
                  showCenterAlignment: true,
                  showRightAlignment: true,
                  showJustifyAlignment: true,
                  // showDirectionButtons: false,
                  // showCaseConverter: false
                  showBackgroundColorButton: false,
                  showClipboardCopy: false,
                  showClipboardCut: false,
                  showColorButton: false,
                  showUndo: false,
                  showSearchButton: false,
                  showClipboardPaste: false,
                  showQuote: false,
                  showSubscript: false,
                  showRedo: false,
                  showDirection: false,
                  showSuperscript: false,
                  showSmallButton: false,
                  showDividers: false,
                )),
            const Divider(
              height: 1,
            ),
            Expanded(
              child: QuillEditor.basic(
                configurations: QuillEditorConfigurations(
                  controller: !isActivity ? logic.selectedDateDailyLogDayClass.notesController: logic.selectedDateDailyLogClass.notesController,
                ), // true for view only mode
              ),
            ),
          ],
        ),

      ),
    );
  }

 /* Widget _editableTextNotesBottom(HomeControllers logic,bool isActivity,
      {Function? onChangeData}) {
    return SizedBox(
      child:Container(
        margin: EdgeInsets.only(top: Sizes.height_1,*//*bottom:  Sizes.height_2*//*),
        decoration: BoxDecoration(
            border: Border.all(
                color: CColor.black,
                width: 1
            ),
            borderRadius: BorderRadius.circular(10)
        ),
        child: TextField(
          keyboardType: TextInputType.text,
          controller: !isActivity ? logic.selectedDateDailyLogDayClass.notesController: logic.selectedDateDailyLogClass.notesController,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          maxLines: 3,
          style: TextStyle(fontSize: FontSize.size_10),
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
