import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../../utils/debug.dart';
import '../../../../utils/font_style.dart';
import '../../../../utils/utils.dart';
import '../controllers/home_controllers.dart';

class WebHomeScreen extends StatefulWidget {
  const WebHomeScreen({super.key});

  @override
  State<WebHomeScreen> createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen> {
  @override
  Widget build(BuildContext context) {
    // double screenWidth = context.width;
    return Scaffold(
      backgroundColor: CColor.white,
      body: SafeArea(
        child: Center(
          child: LayoutBuilder(
            builder: (BuildContext context,BoxConstraints constraints) {
              return GetBuilder<HomeControllers>(
                assignId: true,
                builder: (logic) {
                  return Utils.pullToRefreshApi(_widgetHome(context,logic,constraints)
                      , logic.refreshController, logic.onRefresh, logic.onLoading);
                  // return _widgetHome(context,logic);
                },
              );
            }
          ),
        ),
      ),
    );
  }

  _widgetHome(BuildContext context,HomeControllers logic,BoxConstraints constraints){
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: AppFontStyle.sizesWidthManageWeb(1.1, constraints)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
/*
                      Container(
                        margin: EdgeInsets.only(top: Sizes.height_3),
                        child: Text(
                          "Choose your option to add more logs.",
                          style: AppFontStyle.styleW500(
                              CColor.black, Utils.sizesFontManage(context,2.4)),
                        ),
                      ),
*/
            (constraints.maxWidth < 650) ?
            Column(
              children: [
                _widgetNewActivity(context,logic,constraints),
                _widgetDaliyActivity(context,logic,constraints),
                _widgetMonthlySummary(context,logic,constraints),
                _widgetTrackingChart(context,logic,constraints),
                _widgetToDOList(context,logic,constraints),
              ],
            ):
            Column(
              children: [
                Row(
                  children: [
                    Expanded(child:_widgetNewActivity(context,logic,constraints), ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                            left: Sizes.width_1
                        ),
                        child:_widgetDaliyActivity(context,logic,constraints),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                            left: Sizes.width_1
                        ),
                        child:_widgetMonthlySummary(context,logic,constraints),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        child:_widgetTrackingChart(context,logic,constraints),
                      ),
                    ),
                    Expanded(child:
                    Container(
                      margin: EdgeInsets.only(
                          left: Sizes.width_1
                      ),
                          child: _widgetToDOList(context,logic,constraints),
                        ) ),
                    // Expanded(child:  _widgetDaliyActivity(context,logic),),
                    Expanded(child: Container()),
                  ],
                ),
              ],
            )

          ],
        ),
      ),
    );
  }

  _widgetNewActivity(BuildContext context,HomeControllers logic,BoxConstraints constraints){
    return Container(
      margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.2, constraints) : Sizes.width_1),
      child: _widgetContainerBox(Constant.homeRecord,
          Constant.homeRecordActivity, (value) {
           /* logic.onChangeMonth(false);
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
            bottomNewActivityRecordData(context, logic,constraints);*/

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
            bottomNewActivityRecordData(context, logic,constraints);

          },constraints),
    );
  }

  _widgetMonthlySummary(BuildContext context,HomeControllers logic,BoxConstraints constraints){
    return Container(
      margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.2, constraints) : Sizes.width_1),
      child: _widgetContainerBox(Constant.homeMonthly,
          Constant.homeMonthlySummary, (value) {
            Get.toNamed(AppRoutes.homeMonthly);
          },constraints),
    );
  }

  _widgetTrackingChart(BuildContext context,HomeControllers logic,BoxConstraints constraints){
    return Container(
      margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.2, constraints) : Sizes.width_1),
      child: _widgetContainerBox(Constant.homeTracking,
          Constant.homeTrackingChart, (value) {
            FocusScope.of(context).requestFocus(FocusNode());

            // logic.onChangeMonth(true);
            logic.gotoTrackingChartPage();
          },constraints),
    );
  }

  _widgetToDOList(BuildContext context,HomeControllers logic,BoxConstraints constraints){
    return Container(
      margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.2, constraints) : Sizes.width_1),
      child: _widgetContainerBoxToDo(
          Constant.homeToDoList, Constant.homeToDO,
              (value) {
            // logic.onChangeMonth(true);
            if(logic.toDoDataList.isNotEmpty) {
              Get.toNamed(AppRoutes.toDoListScreen)!.then((value) => {
                logic.getToDoDataListApi(),
              });
            }
          },logic,constraints),
    );
  }

  _widgetDaliyActivity(BuildContext context,HomeControllers logic,BoxConstraints constraints){
    return Container(
      margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.2, constraints) : Sizes.width_1),
      child:  _widgetContainerBox(Constant.homeDailyValues,
        Constant.homeDailyValuesIconsPath, (value) {
          /*   logic.selectedNewDateDaliy = DateTime.now();
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
                              showDialogDetailsViewDayLevel(context, logic);*/
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
          bottomTapDetailsDaily(context, logic,constraints);
        },constraints),
    );
  }

  _widgetContainerBox(String title,String icons,Function callBack,BoxConstraints constraints) {
    return InkWell(
      hoverColor: CColor.transparent,
      onTap: () {
        callBack.call("");
      },
      child: Container(
        margin: EdgeInsets.only(top: Sizes.height_2_1),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
              color: CColor.txtGray50,
              width: 1
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        padding:  EdgeInsets.symmetric(horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.5, constraints):  Sizes.width_4,
            vertical: ( kIsWeb) ?AppFontStyle.sizesHeightManageWeb(1.3, constraints):  Sizes.height_2 ),
        child: Row(
          children: [
            Image.asset(icons,width: AppFontStyle.sizesWidthManageWeb(1.5, constraints),height: AppFontStyle.sizesWidthManageWeb(1.5, constraints),color: CColor.primaryColor,),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.2, constraints) :  Sizes.width_1_2
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                      AppFontStyle.styleW700(CColor.primaryColor, AppFontStyle.sizesFontManageWeb(1.3,constraints)),
                    ),
                  ],
                ),
              ),
            ),
            const Icon(Icons.navigate_next_rounded)
          ],
        ),
      ),
    );
  }

  _widgetContainerBoxToDo(String title, String icons, Function callBack, HomeControllers logic,BoxConstraints constraints) {
    return InkWell(
      hoverColor: CColor.transparent,
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
        padding:  EdgeInsets.symmetric(horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.5, constraints):  Sizes.width_4,
            vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.3, constraints):  Sizes.height_2 ),
        child: Row(
          children: [
            Image.asset(icons,width: AppFontStyle.sizesWidthManageWeb(1.5, constraints),height: AppFontStyle.sizesWidthManageWeb(1.5, constraints),color: CColor.primaryColor,),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                    left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.2, constraints) :  Sizes.width_1_2
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        // "Goal ${(logic.goalDataList.isEmpty && !logic.isGoalLoading)?"(None)":""}",
                        (logic.isTodoLoading) ? title :
                        (logic.toDoDataList.isEmpty) ? "$title (None)" : title,

                        style: AppFontStyle.styleW700(CColor.primaryColor, AppFontStyle.sizesFontManageWeb(1.3,constraints)),


                      ),
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
        return StatefulBuilder(
          builder: (context, setStateAlert) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
              content: Container(
                  width: Get.width * 0.9,
                  height: Get.height * 0.5,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                      color: CColor.white),
                  child: SfDateRangePicker(
                    /*onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                      logic.onSelectionChangedDatePicker(
                          dateRangePickerSelectionChangedArgs);
                      setStateAlert(() {});
                    },*/
                    onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                      if(isActivity) {
                        logic.onSelectionChangedDatePicker(
                            dateRangePickerSelectionChangedArgs);
                        setStateAlert(() {});
                      }else{
                        logic.onDayChangedDatePicker(
                            dateRangePickerSelectionChangedArgs);
                        setStateAlert(() {});
                      }
                    },
                    selectionMode: DateRangePickerSelectionMode.single,
                    view: DateRangePickerView.month,
                    showActionButtons: true,
                    showNavigationArrow: Utils.manageCalenderInNavigation(),
                    cancelText: "Cancel",
                    confirmText: "Ok",
                    onCancel: () {
                      Get.back();
                    },
                    onSubmit: (p0) {
                      setStateBottom(() {
                        logic.changeExDropDown(
                            Constant.itemBicycling, logic.selectedNewDate);
                      });
                      Get.back();
                    },
                  )),
            );
          },
        );
      },
    ).then((value) =>
        (value) {
      setStateBottom(() {});
    });
  }

  Widget _widgetNumberImage(String type,String icon,BoxConstraints constraints) {
    return Row(
      children: [
        Image.asset(
          // Utils.getNumberIconNameFromType(type),
          icon,
          height: AppFontStyle.sizesWidthManageWeb(1.2, constraints),
          width: AppFontStyle.sizesWidthManageWeb(1.2, constraints),
        ),
        Container(
          margin: EdgeInsets.only(left: Sizes.width_0_5),
          child: Text(type,style: TextStyle(
              fontSize: AppFontStyle.sizesFontManageWeb(1.3, constraints)
          ),),
        ),
      ],
    );
  }

  /*showDialogDetailsView(BuildContext context, HomeControllers logic) {
    Future<void> future = showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, StateSetter setStateBottom) {
              return AlertDialog(
                insetPadding: const EdgeInsets.all(10),
                contentPadding: const EdgeInsets.all(0),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                content: Wrap(
                  children: [
                    (Constant.configurationInfo.
                    where((element) => element.title ==
                        logic.selectedDateDailyLogClass.displayLabel &&
                        (element.isEnabled) ).toList().isNotEmpty) ?
                    Container(
                      padding: EdgeInsets.all(Sizes.width_2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        showDatePickerDialog(
                                            logic, context, setStateBottom,true);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(top: Sizes.height_1),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Date: ",
                                              style: TextStyle(
                                                  color: CColor.black,
                                                  fontSize: FontSize.size_3_5),
                                            ),
                                            Text(
                                              DateFormat(
                                                  Constant.commonDateFormatDdMmYyyy)
                                                  .format(logic.selectedNewDate),
                                              style: TextStyle(
                                                  color: CColor.black,
                                                  fontSize: FontSize.size_3_5),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                            top: Sizes.height_1_3,
                                            // right: Sizes.width_0_3,
                                            // left: Sizes.width_0_3,
                                          ),
                                          child: PopupMenuButton<String>(
                                            itemBuilder: (context) => logic
                                                .activityLevelData
                                                .map(
                                                  (e) => PopupMenuItem<String>(
                                                  value: e.toString(),
                                                  child: Row(
                                                    children: [
                                                      _widgetNumberImage(e)
                                                    ],
                                                  )),
                                            )
                                                .toList(),
                                            offset: Offset(-Sizes.width_9, 0),
                                            color: Colors.grey[60],
                                            elevation: 2,
                                            onSelected: (value) {
                                              setStateBottom(() {
                                                logic.changeExDropDown(
                                                    value, logic.selectedNewDate);
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                _widgetNumberImage(logic
                                                    .selectedDateDailyLogClass
                                                    .displayLabel ??
                                                    Constant.itemBicycling),
                                                const Icon(
                                                  Icons.arrow_drop_down_sharp,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  Get.back();
                                  Get.toNamed(AppRoutes.configuration,arguments: [false]);

                                },
                                child: Image.asset(Constant.settingConfigurationIcons,
                                  width:  Sizes.width_2,
                                  height: Sizes.width_2,),
                              )
                            ],
                          ),

                          (Constant.configurationInfo.
                          where((element) => element.title ==
                              logic.selectedDateDailyLogClass.displayLabel &&
                              (element.isModerate || element.isVigorous || element.isTotal) ).toList().isNotEmpty)?
                            Container(
                              padding: EdgeInsets.only(top: Sizes.height_1_1),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${Constant.activityMinutes}: ",
                                    style: TextStyle(
                                        color: CColor.black,
                                        fontSize: FontSize.size_3_5),
                                  ),
                                  Container(
                                    margin:
                                    EdgeInsets.only(left: Sizes.width_1),
                                  ),
                                  (Constant.configurationInfo.
                                  where((element) => element.title ==
                                      logic.selectedDateDailyLogClass.displayLabel &&
                                      element.isModerate ).toList().isNotEmpty) ?
                                  Expanded(
                                    child: _editableTextModWeb(logic,true,
                                        onChangeData: (value) {
                                          logic
                                              .onChangeEditableModBottom(
                                              value);
                                        }),
                                  ):Container(),
                                  const Text("  "),
                                  (Constant.configurationInfo.
                                  where((element) => element.title ==
                                      logic.selectedDateDailyLogClass.displayLabel &&
                                      element.isVigorous ).toList().isNotEmpty) ?
                                  Expanded(
                                      child: _editableTextVigWeb(logic,true,
                                          onChangeData: (value) {
                                            logic
                                                .onChangeEditableVigBottom(
                                                value);
                                          })):Container(),
                                  const Text("  "),
                                  (Constant.configurationInfo.
                                  where((element) => element.title ==
                                      logic.selectedDateDailyLogClass.displayLabel &&
                                      element.isTotal ).toList().isNotEmpty) ?
                                  Expanded(
                                    child: _editableTextTotalWeb(logic,true,
                                        onChangeData: (value) {
                                          logic.onChangeEditableTotalMinBottom(
                                              value);
                                        }),
                                  ):Container(),
                                ],
                              ),
                            ):Container(),

                          (Constant.configurationInfo.
                          where((element) => element.title ==
                              logic.selectedDateDailyLogClass.displayLabel &&
                              element.isDaysStr ).toList().isNotEmpty) ?
                            Container(
                              margin: EdgeInsets.only(
                                  top: Sizes.height_1
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "${Constant.daysStrength}: ",
                                    style: TextStyle(
                                        color: CColor.black,
                                        fontSize: FontSize.size_3_5),
                                  ),
                                  Container(
                                    margin:
                                    EdgeInsets.only(left: Sizes.width_1_5),
                                  ),
                                  _checkBoxDaysStrengthWeb(
                                      context,
                                      logic,
                                      setStateBottom,true,
                                  ),
                                ],
                              ),
                            ) :Container(),

                          (Constant.configurationInfo.
                          where((element) => element.title ==
                              logic.selectedDateDailyLogClass.displayLabel &&
                              element.isCalories ).toList().isNotEmpty) ?
                            Container(
                              margin: EdgeInsets.only(
                                  top: Sizes.height_0_5
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${Constant.calories}: ",
                                    style: TextStyle(
                                        color: CColor.black,
                                        fontSize: FontSize.size_3_5),
                                  ),
                                  Container(
                                    margin:
                                    EdgeInsets.only(left: Sizes.width_1),
                                  ),
                                  Expanded(
                                    child: _editableTextCaloriesWeb(logic,true,
                                        onChangeData: (value) {
                                          logic
                                              .onChangeEditableCaloriesBottom(
                                              value);
                                          setState(() {});
                                        }),
                                  ),
                                ],
                              ),
                            ) :Container(),

                          (Constant.configurationInfo.
                          where((element) => element.title ==
                              logic.selectedDateDailyLogClass.displayLabel &&
                              element.isSteps ).toList().isNotEmpty) ?
                            Container(
                              // padding: EdgeInsets.only(top: Sizes.height_1_2),
                              margin: EdgeInsets.only(
                                  top: Sizes.height_0_5
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${Constant.steps}: ",
                                    style: TextStyle(
                                        color: CColor.black,
                                        fontSize: FontSize.size_3_5),
                                  ),
                                  Container(
                                    margin:
                                    EdgeInsets.only(left: Sizes.width_1),
                                  ),
                                  Expanded(
                                    child: _editableTextStepsWeb(logic,true,
                                        onChangeData: (value) {
                                          logic
                                              .onChangeEditableStepsBottom(
                                              value);
                                          setState(() {});
                                        }),
                                  ),
                                ],
                              ),
                            ):Container(),

                          (Constant.configurationInfo.
                          where((element) => element.title ==
                              logic.selectedDateDailyLogClass.displayLabel &&
                              (element.isRest || element.isPeck)  ).toList().isNotEmpty) ?
                            Container(
                              margin: EdgeInsets.only(
                                  top: Sizes.height_0_5
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${Constant.heartRate}: ",
                                    style: TextStyle(
                                        color: CColor.black,
                                        fontSize: FontSize.size_3_5),
                                  ),
                                  Container(
                                    margin:
                                    EdgeInsets.only(left: Sizes.width_1),
                                  ),
                                  (Constant.configurationInfo.
                                  where((element) => element.title ==
                                      logic.selectedDateDailyLogClass.displayLabel &&
                                      element.isRest ).toList().isNotEmpty) ?
                                  Expanded(
                                    child: _editableTextRestHeartRateWeb(
                                        logic,true, onChangeData: (value) {
                                      logic
                                          .onChangeEditableRestHeartBottom(
                                          value);
                                      setState(() {});
                                    }),
                                  ):Container(),
                                  const Text("  "),
                                  (Constant.configurationInfo.
                                  where((element) => element.title ==
                                      logic.selectedDateDailyLogClass.displayLabel &&
                                      element.isPeck ).toList().isNotEmpty) ?
                                  Expanded(
                                    child: _editableTextPeakHeartRateWeb(
                                        logic, true,onChangeData: (value) {
                                      logic
                                          .onChangeEditablePeakHeartBottom(
                                          value);
                                      setState(() {});
                                    }),
                                  ):Container(),
                                ],
                              ),
                            ) :Container(),

                            Container(
                              padding: EdgeInsets.only(top: Sizes.height_1),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "${Constant.experience}: ",
                                    style: TextStyle(
                                        color: CColor.black,
                                        fontSize: FontSize.size_3_5),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: Sizes.height_0_5,
                                        right: Sizes.width_0_3,
                                        left: Sizes.width_0_3),
                                    child: PopupMenuButton<int>(
                                      itemBuilder: (context) =>
                                      [
                                        PopupMenuItem(
                                          value: 1,
                                          child:
                                          Utils.getSmileyWidget(
                                              Constant.smiley1ImgPath,
                                              Constant.smiley1Title,
                                              isWeb: true),
                                        ),
                                        PopupMenuItem(
                                          value: 2,
                                          child:
                                          Utils.getSmileyWidget(
                                              Constant.smiley2ImgPath,
                                              Constant.smiley2Title,
                                              isWeb: true),
                                        ),
                                        PopupMenuItem(
                                          value: 3,
                                          child:
                                          Utils.getSmileyWidget(
                                              Constant.smiley3ImgPath,
                                              Constant.smiley3Title,
                                              isWeb: true),
                                        ),
                                        PopupMenuItem(
                                          value: 4,
                                          child:
                                          Utils.getSmileyWidget(
                                              Constant.smiley4ImgPath,
                                              Constant.smiley4Title,
                                              isWeb: true),
                                        ),
                                        PopupMenuItem(
                                          value: 5,
                                          child:
                                          Utils.getSmileyWidget(
                                              Constant.smiley5ImgPath,
                                              Constant.smiley5Title,
                                              isWeb: true),
                                        ),
                                        PopupMenuItem(
                                          value: 6,
                                          child:
                                          Utils.getSmileyWidget(
                                              Constant.smiley6ImgPath,
                                              Constant.smiley6Title,
                                              isWeb: true),
                                        ),
                                        PopupMenuItem(
                                          value: 7,
                                          child:
                                          Utils.getSmileyWidget(
                                              Constant.smiley7ImgPath,
                                              Constant.smiley7Title,
                                              isWeb: true),
                                        ),
                                      ],
                                      offset: Offset(-Sizes.width_9, 0),
                                      color: Colors.grey[60],
                                      elevation: 2,
                                      onSelected: (value) {
                                        if (value == 1) {
                                          logic.labelIcon =
                                              Constant.smiley1ImgPath;
                                        } else if (value == 2) {
                                          logic.labelIcon =
                                              Constant.smiley2ImgPath;
                                        } else if (value == 3) {
                                          logic.labelIcon =
                                              Constant.smiley3ImgPath;
                                        } else if (value == 4) {
                                          logic.labelIcon =
                                              Constant.smiley4ImgPath;
                                        } else if (value == 5) {
                                          logic.labelIcon =
                                              Constant.smiley5ImgPath;
                                        } else if (value == 6) {
                                          logic.labelIcon =
                                              Constant.smiley6ImgPath;
                                        } else if (value == 7) {
                                          logic.labelIcon =
                                              Constant.smiley7ImgPath;
                                        } else {
                                          logic.labelIcon =
                                              Constant.smiley1ImgPath;
                                        }
                                        setStateBottom(() {
                                          logic.updateSmileyForBottom(value);
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Image.asset(Utils.getIconNameFromType(
                                              logic.selectedDateDailyLogClass
                                                  .smileyType),
                                              width: Sizes.width_1_9),
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
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: Sizes.height_2),
                                  child: Text(
                                    "${Constant.noteType}: ",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: CColor.black,
                                        fontSize: FontSize.size_3_5),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: Sizes.width_1_5),
                                ),
                                Expanded(
                                  child: _editableTextNotesBottom(
                                      logic,true, onChangeData: (value) {
                                    logic
                                        .onChangeEditableTextValueNotesBottom(
                                        value);
                                  }),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.only(
                                top: Sizes.height_2_1,
                                bottom: Sizes.height_0_5),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius:
                                        BorderRadius.circular(10)),
                                    padding: EdgeInsets.only(
                                        right: Sizes.width_0_5,
                                        left: Sizes.width_0_5,
                                        top: Sizes.height_0_5,
                                        bottom: Sizes.height_0_5
                                    ),
                                    // padding: const EdgeInsets.all(4),
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                          color: CColor.black,
                                          fontSize: FontSize.size_3_5),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    logic.insertUpdateRecordActivity();
                                    setState(() {});
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        color: CColor.black),
                                    padding: EdgeInsets.only(
                                        left: Sizes.width_1,
                                        right: Sizes.width_1,
                                        top: Sizes.height_0_5,
                                        bottom: Sizes.height_0_5),
                                    child: Text(
                                      "Ok",
                                      style: TextStyle(
                                          color: CColor.white,
                                          fontSize: FontSize.size_3_5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ): Container(
                      margin: EdgeInsets.only(
                          left: Sizes.width_12,
                          right: Sizes.width_12,
                          top: Sizes.height_4,
                          bottom: Sizes.height_4),
                      alignment: Alignment.center,
                      child: Text(
                        "Please  Enable For Activity Configuration",
                        style: AppFontStyle.styleW700(
                            CColor.black, FontSize.size_4),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
    future.then((void value) {
      setState(() {
        logic.generateDateList();
      });
    });
  }*/

/*  showDialogDetailsViewDayLevel(BuildContext context, HomeControllers logic) {
    Future<void> future = showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, StateSetter setStateBottom) {
              return AlertDialog(
                insetPadding: const EdgeInsets.all(10),
                contentPadding: const EdgeInsets.all(0),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                content: Wrap(
                  children: [
                    Container(
                      padding: EdgeInsets.all(Sizes.width_2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        showDatePickerDialog(
                                            logic, context, setStateBottom,false)
                                            .then((value) => (value) {
                                          setStateBottom(() {});
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(top: Sizes.height_1),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Date: ",
                                              style: TextStyle(
                                                  color: CColor.black,
                                                  fontSize: FontSize.size_3_5,fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              DateFormat(
                                                  Constant.commonDateFormatDdMmYyyy)
                                                  .format(logic.selectedNewDateDaliy),
                                              style: TextStyle(
                                                  color: CColor.black,
                                                  fontSize: FontSize.size_3_5,fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  Get.back();
                                  Get.toNamed(AppRoutes.configuration,arguments: [false]);

                                },
                                child: Image.asset(Constant.settingConfigurationIcons,
                                  width:  Sizes.width_2,
                                  height: Sizes.width_2,),
                              )
                            ],
                          ),

                          Column(
                            children: [
                              (Constant.configurationInfo.
                              where((element) =>
                              (element.isModerate || element.isVigorous || element.isTotal) ).toList().isNotEmpty)?
                              Container(
                                margin: EdgeInsets.only(
                                    top: Sizes.height_1_8
                                ),
                                padding: EdgeInsets.only(top: Sizes.height_1_1),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${Constant.activityMinutes}: ",
                                      style: TextStyle(
                                          color: CColor.black,
                                          fontSize: FontSize.size_3_5),
                                    ),
                                    Container(
                                      margin:
                                      EdgeInsets.only(left: Sizes.width_1),
                                    ),
                                    (Constant.configurationInfo.
                                    where((element) =>
                                    element.isModerate ).toList().isNotEmpty) ?
                                    Expanded(
                                      child: _editableTextModWeb(logic,false,
                                          onChangeData: (value) {
                                            logic.onChangeDayValue1Bottom(
                                                value);
                                          }),
                                    ) : Container(),
                                    const Text("  "),

                                    (Constant.configurationInfo.
                                    where((element) =>
                                    element.isVigorous ).toList().isNotEmpty) ?
                                    Expanded(
                                        child: _editableTextVigWeb(logic,false,
                                            onChangeData: (value) {
                                              logic.onChangeDayValue2Bottom(
                                                  value);
                                            })) : Container(),
                                    const Text("  "),

                                    (Constant.configurationInfo.
                                    where((element) =>
                                    element.isTotal ).toList().isNotEmpty) ?
                                    Expanded(
                                      child: _editableTextTotalWeb(logic,false,
                                          onChangeData: (value) {
                                            logic.onChangeDayTotalBottom(
                                                value);
                                          }),
                                    ):Container(),
                                  ],
                                ),
                              ):Container(),
                              (Constant.configurationInfo.
                              where((element) =>
                              element.isDaysStr ).toList().isNotEmpty) ?
                              Container(
                                margin: EdgeInsets.only(
                                    top: Sizes.height_1
                                ),
                                // padding: EdgeInsets.only(top: Sizes.height_3_5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${Constant.daysStrength}: ",
                                      style: TextStyle(
                                          color: CColor.black,
                                          fontSize: FontSize.size_3_5),
                                    ),
                                    Container(
                                      margin:
                                      EdgeInsets.only(left: Sizes.width_1_5),
                                    ),
                                    _checkBoxDaysStrengthWeb(
                                      context, logic, setStateBottom,false,),
                                  ],
                                ),
                              ): Container(),
                              (Constant.configurationInfo.
                              where((element) =>
                              element.isCalories ).toList().isNotEmpty) ?
                              Container(
                                margin: EdgeInsets.only(
                                    top: Sizes.height_0_5
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${Constant.calories}: ",
                                      style: TextStyle(
                                          color: CColor.black,
                                          fontSize: FontSize.size_3_5),
                                    ),
                                    Container(
                                      margin:
                                      EdgeInsets.only(left: Sizes.width_1),
                                    ),
                                    Expanded(
                                      child: _editableTextCaloriesWeb(logic,false,
                                          onChangeData: (value) {
                                            logic
                                                .onChangeDayTitle3Bottom(
                                                value);
                                          }),
                                    ),
                                  ],
                                ),
                              ) : Container(),
                              (Constant.configurationInfo.
                              where((element) =>
                              element.isSteps ).toList().isNotEmpty) ?
                              Container(
                                padding: EdgeInsets.only(top: Sizes.height_0_5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${Constant.steps}: ",
                                      style: TextStyle(
                                          color: CColor.black,
                                          fontSize: FontSize.size_3_5),
                                    ),
                                    Container(
                                      margin:
                                      EdgeInsets.only(left: Sizes.width_1),
                                    ),
                                    Expanded(
                                      child: _editableTextStepsWeb(logic,false,
                                          onChangeData: (value) {
                                            logic
                                                .onChangeDayTitle4Bottom(
                                                value);
                                          }),
                                    ),
                                  ],
                                ),
                              ) : Container(),
                              (Constant.configurationInfo.
                              where((element) =>
                              (element.isRest || element.isPeck)  ).toList().isNotEmpty) ?
                              Container(
                                padding: EdgeInsets.only(top: Sizes.height_0_5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${Constant.heartRate}: ",
                                      style: TextStyle(
                                          color: CColor.black,
                                          fontSize: FontSize.size_3_5),
                                    ),
                                    Container(
                                      margin:
                                      EdgeInsets.only(left: Sizes.width_1),
                                    ),
                                    (Constant.configurationInfo.
                                    where((element) =>
                                    element.isRest ).toList().isNotEmpty) ?
                                    Expanded(
                                      child:
                                      _editableTextRestHeartRateWeb(
                                          logic,false, onChangeData: (value) {
                                        logic
                                            .onChangeDayValue1Title5Bottom(
                                            value);
                                      }),
                                    ):Container(),
                                    const Text("  "),
                                    (Constant.configurationInfo.
                                    where((element) =>
                                    element.isPeck ).toList().isNotEmpty) ?
                                    Expanded(
                                      child:
                                      _editableTextPeakHeartRateWeb(
                                          logic, false,onChangeData: (value) {
                                        logic
                                            .onChangeDayValue2Title5Bottom(
                                            value);
                                      }),
                                    ): Container()
                                  ],
                                ),
                              ): Container(),
                              (Constant.configurationInfo.
                              where((element) =>
                              element.isExperience ).toList().isNotEmpty) ?
                              Container(
                                padding: EdgeInsets.only(top: Sizes.height_1),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${Constant.experience}: ",
                                      style: TextStyle(
                                          color: CColor.black,
                                          fontSize: FontSize.size_3_5),
                                    ),
                                    Container(
                                      margin:
                                      EdgeInsets.only(left: Sizes.width_1_5),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          top: Sizes.height_0_5,
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
                                                width: Sizes.width_1_9),
                                            const Icon(
                                              Icons.arrow_drop_down_sharp,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ): Container(),
                              (Constant.configurationInfo.
                              where((element) => *//*element.title ==
                                  logic.selectedDateDailyLogDayClass.displayLabel &&*//*
                              element.isNotes ).toList().isNotEmpty) ?
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: Sizes.height_2),
                                      child: Text(
                                        "${Constant.noteType}: ",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: CColor.black,
                                            fontSize: FontSize.size_3_5),
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
                                ),
                              ) : Container(),

                              *//*else
                                Container()*//*
                              Container(
                                padding: EdgeInsets.only(
                                    top: Sizes.height_2_1,
                                    bottom: Sizes.height_0_5),
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
                                        padding: EdgeInsets.only(
                                            right: Sizes.width_0_5,
                                            left: Sizes.width_0_5,
                                            top: Sizes.height_0_5,
                                            bottom: Sizes.height_0_5
                                        ),
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                              color: CColor.black,
                                              fontSize: FontSize.size_3_5),
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
                                        padding: EdgeInsets.only(
                                            left: Sizes.width_1,
                                            right: Sizes.width_1,
                                            top: Sizes.height_0_5,
                                            bottom: Sizes.height_0_5),
                                        child: Text(
                                          "Ok",
                                          style: TextStyle(
                                              color: CColor.white,
                                              fontSize: FontSize.size_3_5),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
    future.then((void value) {
      setState(() {
        logic.generateDateList();
      });
    });
  }*/

  /*User on The Bottom Sheet*/
  Widget _editableTextModWeb(HomeControllers logic,bool isActivity,BoxConstraints constraints,
      {Function? onChangeData}) {
    return SizedBox(
      child: TextField(
        // cursorHeight: Constant.cursorHeightForWeb,
        enabled: (Constant.isEditMode),
        enableInteractiveSelection: false,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: AppFontStyle.sizesFontManageWeb(1.3, constraints)),
        maxLines: 1,
        autofocus: true,
        decoration: const InputDecoration(
            hintText: 'Mod'
        ),
        autocorrect: true,
        textAlign: TextAlign.start,
        controller: !isActivity ? logic.selectedDateDailyLogDayClass.modValueController: logic.selectedDateDailyLogClass.modValueController,
        onChanged: (value) {
          if (onChangeData != null) {
            onChangeData.call(value);
          }
        },
      ),
    );
  }

  Widget _editableTextVigWeb(HomeControllers logic,bool isActivity,BoxConstraints constraints,
      {Function? onChangeData}) {
    return SizedBox(
      child: TextField(
       /* enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
            element.isVigorous ).toList().isNotEmpty ),*/
        // cursorHeight: Constant.cursorHeightForWeb,
        textAlign: TextAlign.start,
        enableInteractiveSelection: false,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: AppFontStyle.sizesFontManageWeb(1.3, constraints)),
        maxLines: 1,
        autofocus: false,
        autocorrect: true,
        decoration: const InputDecoration(
            hintText: 'Vig'
        ),
        controller: !isActivity ? logic.selectedDateDailyLogDayClass.vigValueController: logic.selectedDateDailyLogClass.vigValueController,
        onChanged: (value) {
          if (onChangeData != null) {
            onChangeData.call(value);
          }
        },
      ),
    );
  }

    Widget _editableTextTotalWeb(HomeControllers logic,bool isActivity,BoxConstraints constraints,
      {Function? onChangeData}) {
    return SizedBox(
      child: TextField(
        // cursorHeight: Constant.cursorHeightForWeb,
        textAlign: TextAlign.start,
       /* enabled: ( Constant.configurationInfo.where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
            element.isTotal ).toList().isNotEmpty ),*/
        enableInteractiveSelection: false,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: AppFontStyle.sizesFontManageWeb(1.3, constraints)),
        maxLines: 1,
        autofocus: false,
        autocorrect: true,
        decoration: const InputDecoration(
            hintText: 'Total'
        ),
        controller:  !isActivity ? logic.selectedDateDailyLogDayClass.totalValueController: logic.selectedDateDailyLogClass.totalValueController,
        onChanged: (value) {
          if (onChangeData != null) {
            onChangeData.call(value);
          }
        },
      ),
    );
  }

  _checkBoxDaysStrengthWeb(BuildContext context,
      HomeControllers logic, StateSetter updateSet,bool isActivity) {
    return Container(
      margin: EdgeInsets.only(
          top: Sizes.height_1
      ),
      child: Checkbox(
        value: (isActivity) ? logic.selectedDateDailyLogClass.isCheckedDayData : logic.selectedDateDailyLogDayClass.isCheckedDayData,
        onChanged:/*(!Constant.isEditMode || Constant.configurationInfo.where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
            element.isDaysStr ).toList().isEmpty )
            ? null
            : */(value) {
          updateSet(() {
            // logic.onChangeCheckBoxValueBottom(value!);
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

  Widget _editableTextCaloriesWeb(HomeControllers logic,bool isActivity,BoxConstraints constraints,
      {Function? onChangeData}) {
    return SizedBox(
      child: TextField(
        // cursorHeight: Constant.cursorHeightForWeb,
        /*enabled: (Constant.configurationInfo.where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
            element.isCalories ).toList().isNotEmpty ),*/
        textAlign: TextAlign.start,
        enableInteractiveSelection: false,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: AppFontStyle.sizesFontManageWeb(1.3, constraints)),
        maxLines: 1,
        autofocus: false,
        autocorrect: true,
        controller: !isActivity ? logic.selectedDateDailyLogDayClass.caloriesValueController:  logic.selectedDateDailyLogClass.caloriesValueController,
        onChanged: (value) {
          if (onChangeData != null) {
            onChangeData.call(value);
          }
        },
      ),
    );
  }

  Widget _editableTextStepsWeb(HomeControllers logic,bool isActivity,BoxConstraints constraints,
      {Function? onChangeData}) {
    return SizedBox(
      child: TextField(
        // cursorHeight: Constant.cursorHeightForWeb,
        /*enabled: (Constant.configurationInfo.where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
            element.isSteps ).toList().isNotEmpty ),*/
        textAlign: TextAlign.start,
        enableInteractiveSelection: false,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: AppFontStyle.sizesFontManageWeb(1.3, constraints)),
        maxLines: 1,
        autofocus: false,
        autocorrect: true,
        controller: !isActivity ? logic.selectedDateDailyLogDayClass.stepsValueController:  logic.selectedDateDailyLogClass.stepsValueController,
        onChanged: (value) {
          if (onChangeData != null) {
            onChangeData.call(value);
          }
        },
      ),
    );
  }

  Widget _editableTextRestHeartRateWeb(HomeControllers logic,bool isActivity,BoxConstraints constraints,
      {Function? onChangeData}) {
    return SizedBox(
      child: TextField(
        // cursorHeight: Constant.cursorHeightForWeb,
        textAlign: TextAlign.start,
        enableInteractiveSelection: false,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: AppFontStyle.sizesFontManageWeb(1.3, constraints)),
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

  Widget _editableTextPeakHeartRateWeb(HomeControllers logic,bool isActivity,BoxConstraints constraints,
      {Function? onChangeData}) {
    return SizedBox(
      child: TextField(
        // cursorHeight: Constant.cursorHeightForWeb,
        /*enabled: (Constant.configurationInfo.where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
            element.isPeck ).toList().isNotEmpty ),*/
        textAlign: TextAlign.start,
        enableInteractiveSelection: false,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: AppFontStyle.sizesFontManageWeb(1.3, constraints)),
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

  Widget _editableTextNotesBottom(HomeControllers logic,bool isActivity,BoxConstraints constraints,
      {Function? onChangeData}) {
    return SizedBox(
      // width: Sizes.width_7,
      // height: Get.height*0.3,
      height: AppFontStyle.sizesHeightManageWeb(17.0, constraints),
      child:Container(
        margin: EdgeInsets.only(top: AppFontStyle.sizesHeightManageWeb(1.0, constraints),bottom:  AppFontStyle.sizesHeightManageWeb(1.0, constraints)),
        decoration: BoxDecoration(
            border: Border.all(
                color: CColor.black,
                width: 1
            ),
            borderRadius: BorderRadius.circular(10)
        ),
        child:         Column(
          children: [
            QuillToolbar.simple(
                configurations: QuillSimpleToolbarConfigurations(
                  controller: !isActivity ? logic.selectedDateDailyLogDayClass.notesController: logic.selectedDateDailyLogClass.notesController,
                  // showStyleButton: true, // Show style buttons
                  showFontFamily: false, // Show font family button
                  showFontSize: false, // Show font size button
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

        /*TextField(
          // cursorHeight: Constant.cursorHeightForWeb,
          keyboardType: TextInputType.text,
          controller: !isActivity ? logic.selectedDateDailyLogDayClass.notesController: logic.selectedDateDailyLogClass.notesController,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          maxLines: 3,
          style: TextStyle(fontSize: AppFontStyle.sizesFontManageWeb(1.3, constraints)),
          onChanged: (value) {
            if (onChangeData != null) {
              onChangeData.call(value);
            }
          },
        ),*/
      ),
    );
  }

  bottomNewActivityRecordData(BuildContext context, HomeControllers logic,BoxConstraints constraints) {
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
                      left: AppFontStyle.sizesWidthManageWeb(0.5, constraints),
                      right: AppFontStyle.sizesWidthManageWeb(0.5, constraints),
                      bottom: AppFontStyle.sizesFontManageWeb(0.5, constraints)),
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
                                AppFontStyle.styleW500(CColor.white, AppFontStyle.sizesFontManageWeb(1.8, constraints))),
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
                                  width: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(2.0, constraints): Sizes.width_6,
                                  height:(kIsWeb) ? AppFontStyle.sizesWidthManageWeb(2.0, constraints): Sizes.width_6,color: CColor.white,),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.only(
                              left: AppFontStyle.sizesWidthManageWeb(3.5, constraints),
                              right: AppFontStyle.sizesWidthManageWeb(3.5, constraints),
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
                                                  left: AppFontStyle.sizesWidthManageWeb(2.7, constraints)
                                              ),
                                              child: Text(
                                                DateFormat(
                                                    Constant.commonDateFormatDdMmmYyyy)
                                                    .format(logic.selectedNewDate),
                                                style: TextStyle(
                                                    color: CColor.black,
                                                    fontSize: AppFontStyle.sizesFontManageWeb(1.3, constraints),
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
                                                                .toInt()],constraints)
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
                                                              .displayLabel).toInt()],constraints),
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
                                      top: AppFontStyle.sizesHeightManageWeb(1.5, constraints),
                                      bottom:AppFontStyle.sizesHeightManageWeb(1.0, constraints)
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
                                      GestureDetector(
                                        onTap: () {
                                          selectDateTimeActivity(
                                              context, false,
                                              logic.selectedDateDailyLogClass.activityStartDate,
                                              logic.selectedDateDailyLogClass.activityEndDate ?? DateTime.now(),
                                                  (dateTime) {
                                                setStateBottom(() {
                                                  logic.selectedDateDailyLogClass.activityStartDate = dateTime;
                                                });
                                              },constraints);

                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(left: AppFontStyle.sizesWidthManageWeb(2.7, constraints)),
                                          // padding: const EdgeInsets.all(5),
                                          child: Text( DateFormat(
                                              Constant.commonDateFormatHhMmA)
                                              .format(logic.selectedDateDailyLogClass.activityStartDate),
                                            // DateFormat.yMMMd().add_jm().format(logic.selectedDateDailyLogClass.activityStartDate),
                                            style: TextStyle(fontSize:AppFontStyle.sizesFontManageWeb(1.3, constraints)),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Column(
                                  children: activityRecordWidgetList(logic, context, setStateBottom,constraints)!,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              /*],
              );*/
            },
          );
        });

    /*Future<void> future = showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: CColor.transparent,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, StateSetter setStateBottom) {
              return Wrap(
                children: [
                  Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      decoration: BoxDecoration(
                          color: CColor.white,
                          borderRadius: BorderRadius.circular(9)),
                      margin: EdgeInsets.only(
                          left: Sizes.width_1,
                          right: Sizes.width_1,
                          bottom: Sizes.height_0_5),
                      child: Container(
                        margin: EdgeInsets.only(
                          left: Sizes.width_4,
                          right: Sizes.width_4,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          showDatePickerDialog(
                                              logic, context, setStateBottom,true)
                                              .then((value) => (value) {
                                            setStateBottom(() {});
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(top: Sizes.height_1_2),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Date: ",
                                                style: TextStyle(
                                                    color: CColor.black,
                                                    fontSize: FontSize.size_3,fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                DateFormat(
                                                    Constant.commonDateFormatDdMmYyyy)
                                                    .format(logic.selectedNewDate),
                                                style: TextStyle(
                                                    color: CColor.black,
                                                    fontSize: FontSize.size_3,fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: Sizes.height_1_3,
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
                                                            logic.activityLevelIconData[logic.activityLevelData.indexWhere((element) => element == e).toInt()])
                                                      ],
                                                    )),
                                              )
                                                  .toList(),
                                              offset: Offset(-Sizes.width_9, (MediaQuery.of(context).viewInsets.bottom !=   0.0) ? Sizes.height_27 : 0.0),
                                              color: Colors.grey[60],
                                              elevation: 2,
                                              onOpened: (){
                                                FocusScope.of(Get.context!).requestFocus(new FocusNode());
                                                Debug.printLog("Open Activity");
                                                Debug.printLog("${MediaQuery.of(context).devicePixelRatio.toString()},,,,,,,,,,,,,${MediaQuery.of(context).viewInsets.bottom.toString()}");
                                              },
                                              onSelected: (value) {
                                                setStateBottom(() {
                                                  logic.changeExDropDown(
                                                      value, logic.selectedNewDate,iconPath: logic.activityLevelIconData[logic.activityLevelData.indexWhere((element) => element == value).toInt()]);
                                                });
                                              },
                                              child: Row(
                                                children: [
                                                  _widgetNumberImage(
                                                      logic.selectedDateDailyLogClass
                                                          .displayLabel ??
                                                          Constant
                                                              .itemBicycling,
                                                      logic.activityLevelIconData[logic.activityLevelData.indexWhere((element) => element == logic.selectedDateDailyLogClass
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
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: (){
                                    Get.back();
                                    Get.toNamed(AppRoutes.configuration,arguments: [false]);
                                  },
                                  child: Image.asset(Constant.settingConfigurationIcons,
                                    width:  Sizes.width_1_5,
                                    height: Sizes.width_1_5,),
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: Sizes.height_2),
                              child: Row(
                                children: [
                                  Text(
                                    "Start Date: ",
                                    style: TextStyle(
                                        color: CColor.black,
                                        fontSize: FontSize.size_3),
                                  ),
                                  // const Spacer(),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        selectDateTimeActivity(context, false,logic.selectedDateDailyLogClass.activityStartDate,
                                            logic.selectedDateDailyLogClass.activityEndDate ?? DateTime.now(),(dateTime){
                                              setStateBottom((){
                                                logic.selectedDateDailyLogClass.activityStartDate = dateTime;
                                              });
                                            },constraints);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(left: Sizes.width_2),
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                          DateFormat.yMMMd().add_jm().format(logic.selectedDateDailyLogClass.activityStartDate),
                                          style: TextStyle(fontSize: FontSize.size_3),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Column(
                              children: activityRecordWidgetList(logic,context,setStateBottom,constraints)!,
                            ),
                          ],
                        ),
                      )
                  ),
                ],
              );
            },
          );
        });*/
    future.then((void value) {
      logic.generateDateList();
      logic.resetData();
    });
  }

  Future<void> selectDateTimeActivity(BuildContext context,bool isEndDate,DateTime fromDate,DateTime toDate,
      Function callBack,BoxConstraints constraints) async {
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
                                fontSize: FontSize.size_3,
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
                                margin: EdgeInsets.only(bottom: Sizes.height_1),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: CColor.black,
                                    fontSize: FontSize.size_3,
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
                                margin: EdgeInsets.only(left: Sizes.width_2_5,right: Sizes.width_5,bottom: Sizes.height_1),
                                child: Text(
                                  "Select",
                                  style: TextStyle(
                                    color: CColor.black,
                                    fontSize: FontSize.size_3,
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

  List<Widget>? activityRecordWidgetList(HomeControllers logic, BuildContext context,setStateBottom,BoxConstraints constraints){
    List<Widget> header = [];
    for (int i = 0; i < logic.trackingPrefList.length; i++) {
      if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderModerate && logic.trackingPrefList[i].isSelected){
        var modWidget = (Constant.configurationInfo.
        where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
            (element.isModerate) ).toList().isNotEmpty)?
        Container(
          margin: EdgeInsets.only(
              top:  AppFontStyle.sizesHeightManageWeb(0.3, constraints),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      bottom: AppFontStyle.sizesHeightManageWeb(1.8, constraints)
                  ),
                  child: Icon(Icons.more_time)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: AppFontStyle.sizesWidthManageWeb(2.7, constraints)
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
                                  fontSize: AppFontStyle.sizesFontManageWeb(1.3, constraints)),
                            ),
                          ),
                        ],
                      ),
                      (Constant.configurationInfo.
                      where((element) => element.title ==
                          logic.selectedDateDailyLogClass.displayLabel &&
                          element.isModerate ).toList().isNotEmpty) ?
                      Row(
                        children: [
                          Expanded(
                            child: _editableTextModWeb(logic,true,constraints,
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
              top:  AppFontStyle.sizesHeightManageWeb(0.3, constraints),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      bottom: AppFontStyle.sizesHeightManageWeb(1.8, constraints)
                  ),
                  child: Icon(Icons.more_time)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: AppFontStyle.sizesWidthManageWeb(2.7, constraints)
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
                                  fontSize: AppFontStyle.sizesFontManageWeb(1.3, constraints)),
                            ),
                          ),

                        ],
                      ),

                      (Constant.configurationInfo.
                      where((element) => element.title ==
                          logic.selectedDateDailyLogClass.displayLabel &&
                          element.isVigorous ).toList().isNotEmpty) ?
                      Row(
                        children: [
                          Expanded(
                              child: _editableTextVigWeb(logic,true,constraints,
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
        :Container();
        header.add(vig);
      }
      else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderTotal && logic.trackingPrefList[i].isSelected){
        var total = (Constant.configurationInfo.
        where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
            (element.isTotal) ).toList().isNotEmpty)?
        Container(
          margin: EdgeInsets.only(
              top:  AppFontStyle.sizesHeightManageWeb(0.3, constraints),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      bottom: AppFontStyle.sizesHeightManageWeb(1.8, constraints)
                  ),
                  child: Icon(Icons.timelapse)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: AppFontStyle.sizesWidthManageWeb(2.7, constraints)
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
                                  fontSize: AppFontStyle.sizesFontManageWeb(1.3, constraints)),
                            ),
                          ),

                        ],
                      ),

                      (Constant.configurationInfo.
                      where((element) => element.title ==
                          logic.selectedDateDailyLogClass.displayLabel &&
                          element.isTotal ).toList().isNotEmpty) ?
                      Row(
                        children: [
                          Expanded(
                            child: _editableTextTotalWeb(logic,true,constraints,
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
        :Container();
        header.add(total);
      }
      else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderCalories && logic.trackingPrefList[i].isSelected){
        var calories = (Constant.configurationInfo.
        where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
            element.isCalories ).toList().isNotEmpty) ?
        Container(
          margin: EdgeInsets.only(
              top:  AppFontStyle.sizesHeightManageWeb(0.3, constraints),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      bottom: AppFontStyle.sizesHeightManageWeb(1.8, constraints)
                  ),
                  child: const Icon(Icons.energy_savings_leaf_outlined)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: AppFontStyle.sizesWidthManageWeb(2.7, constraints)
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
                                  fontSize: AppFontStyle.sizesFontManageWeb(1.3, constraints)),
                            ),
                          ),
                        ],
                      ),

                      (Constant.configurationInfo.
                      where((element) => element.title ==
                          logic.selectedDateDailyLogClass.displayLabel &&
                          element.isCalories ).toList().isNotEmpty) ?
                      Row(
                        children: [
                          Expanded(
                            child: _editableTextCaloriesWeb(logic,true,constraints,
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
        ) : Container();
        header.add(calories);
      }
      else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderSteps && logic.trackingPrefList[i].isSelected){
        var steps = (Constant.configurationInfo.
        where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
            element.isSteps ).toList().isNotEmpty) ?
        Container(
          margin: EdgeInsets.only(
              top:  AppFontStyle.sizesHeightManageWeb(0.3, constraints),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      bottom: AppFontStyle.sizesHeightManageWeb(1.8, constraints)
                  ),
                  child: const Icon(Icons.run_circle_outlined)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: AppFontStyle.sizesWidthManageWeb(2.7, constraints)
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
                                  fontSize: AppFontStyle.sizesFontManageWeb(1.3, constraints)),
                            ),
                          ),
                        ],
                      ),

                      (Constant.configurationInfo.
                      where((element) => element.title ==
                          logic.selectedDateDailyLogClass.displayLabel &&
                          element.isSteps ).toList().isNotEmpty) ?
                      Row(
                        children: [
                          Expanded(
                            child: _editableTextStepsWeb(logic,true,constraints,
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
        : Container();
        header.add(steps);
      }
      else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderPeck && logic.trackingPrefList[i].isSelected){
        var peak = (Constant.configurationInfo.
        where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
            (element.isPeck)  ).toList().isNotEmpty) ?
        Container(
          margin: EdgeInsets.only(
              top:  AppFontStyle.sizesHeightManageWeb(0.3, constraints),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      bottom: AppFontStyle.sizesHeightManageWeb(1.8, constraints)
                  ),
                  child: const Icon(Icons.monitor_heart_outlined)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: AppFontStyle.sizesWidthManageWeb(2.7, constraints)
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
                                  fontSize: AppFontStyle.sizesFontManageWeb(1.3, constraints)),
                            ),
                          ),
                        ],
                      ),
                      (Constant.configurationInfo.
                      where((element) => element.title ==
                          logic.selectedDateDailyLogClass.displayLabel &&
                          element.isPeck ).toList().isNotEmpty) ?
                      Row(
                        children: [
                          Expanded(
                            child:
                            _editableTextPeakHeartRateWeb(
                                logic,true,constraints, onChangeData: (value) {
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
        ) : Container();
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
                    left: AppFontStyle.sizesWidthManageWeb(2.7, constraints)
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
                        fontSize: AppFontStyle.sizesFontManageWeb(1.3, constraints)),
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
                    left: Sizes.width_0_3,),
                child: PopupMenuButton<int>(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Utils.getSmileyWidget(
                          Constant.smiley1ImgPath,
                          Constant.smiley1Title,constraints:constraints,isWeb: true),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Utils.getSmileyWidget(
                          Constant.smiley2ImgPath,
                          Constant.smiley2Title,constraints:constraints,isWeb: true),
                    ),
                    PopupMenuItem(
                      value: 3,
                      child: Utils.getSmileyWidget(
                          Constant.smiley3ImgPath,
                          Constant.smiley3Title,constraints:constraints,isWeb: true),
                    ),
                    PopupMenuItem(
                      value: 4,
                      child: Utils.getSmileyWidget(
                          Constant.smiley4ImgPath,
                          Constant.smiley4Title,constraints:constraints,isWeb: true),
                    ),
                    PopupMenuItem(
                      value: 5,
                      child: Utils.getSmileyWidget(
                          Constant.smiley5ImgPath,
                          Constant.smiley5Title,constraints:constraints,isWeb: true),
                    ),
                    PopupMenuItem(
                      value: 6,
                      child: Utils.getSmileyWidget(
                          Constant.smiley6ImgPath,
                          Constant.smiley6Title,constraints:constraints,isWeb: true),
                    ),
                    PopupMenuItem(
                      value: 7,
                      child: Utils.getSmileyWidget(
                          Constant.smiley7ImgPath,
                          Constant.smiley7Title,constraints:constraints,isWeb: true),
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
                          width: AppFontStyle.sizesWidthManageWeb(1.3, constraints),
                          height: AppFontStyle.sizesWidthManageWeb(1.3, constraints)),
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
    }
    var notes =  (Constant.configurationInfo.
    where((element) => element.title ==
        logic.selectedDateDailyLogClass.displayLabel &&
        element.isNotes ).toList().isNotEmpty) ?
    Container(
      margin: EdgeInsets.only(
        top:  AppFontStyle.sizesHeightManageWeb(0.3, constraints),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      // bottom: AppFontStyle.sizesHeightManageWeb(1.8, constraints)
                  ),
                  child: const Icon(Icons.edit_note_sharp)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: AppFontStyle.sizesWidthManageWeb(2.7, constraints)
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
                                  fontSize: AppFontStyle.sizesFontManageWeb(1.3, constraints)),
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
                    logic,true, constraints,onChangeData: (value) {
/*                  logic
                      .onChangeEditableTextValueNotesBottom(
                      value);*/
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
          top: AppFontStyle.sizesHeightManageWeb(0.5, constraints), bottom: AppFontStyle.sizesHeightManageWeb(2.5, constraints)),
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
                  horizontal: AppFontStyle.sizesWidthManageWeb(2.5, constraints),
                  vertical: AppFontStyle.sizesHeightManageWeb(1.0, constraints)
              ),
              child: Text(
                "Cancel",
                style: TextStyle(
                    color: CColor.black,
                    fontSize: AppFontStyle.sizesFontManageWeb(1.5, constraints)),
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
                  horizontal: AppFontStyle.sizesWidthManageWeb(4.5, constraints),
                  vertical: AppFontStyle.sizesHeightManageWeb(1.0, constraints)
              ),
              child: Text(
                "Ok",
                style: TextStyle(
                    color: CColor.white,
                    fontSize: AppFontStyle.sizesFontManageWeb(1.5, constraints)),
              ),
            ),
          ),
        ],
      ),
    ));
    return header;

    /*List<Widget> header = [];
    for (int i = 0; i < logic.trackingPrefList.length; i++) {
      if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderModerate && logic.trackingPrefList[i].isSelected){
        var modWidget = (Constant.configurationInfo.
        where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
            (element.isModerate) ).toList().isNotEmpty)?
        Container(
          margin: EdgeInsets.only(
              top:  AppFontStyle.sizesHeightManageWeb(0.3, constraints),
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
                              border: Border.all(width: 5),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Text(
                              Constant.newActivityModMin)),
                    ),
                  ];
                },
                child: Text(
                  "${Constant.configurationHeaderModerate}: ",
                  style: TextStyle(
                      color: CColor.black,
                      fontSize: FontSize.size_3),
                ),
              ),
              Container(
                margin:
                EdgeInsets.only(left: Sizes.width_1_5),
              ),
              (Constant.configurationInfo.
              where((element) => element.title ==
                  logic.selectedDateDailyLogClass.displayLabel &&
                  element.isModerate ).toList().isNotEmpty) ?
              Expanded(
                child: _editableTextModWeb(logic,true,
                    onChangeData: (value) {
                      logic.onChangeEditableModBottom(
                          value);
                    }),
              ) : Container(),
              const Text("  "),
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
              top:  AppFontStyle.sizesHeightManageWeb(0.3, constraints),
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
                              border: Border.all(width: 5),
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
                      fontSize: FontSize.size_3),
                ),
              ),
              (Constant.configurationInfo.
              where((element) => element.title ==
                  logic.selectedDateDailyLogClass.displayLabel &&
                  element.isVigorous ).toList().isNotEmpty) ?
              Expanded(
                  child: _editableTextVigWeb(logic,true,
                      onChangeData: (value) {
                        logic.onChangeEditableVigBottom(
                            value);
                      })) : Container(),
              const Text("  "),
            ],
          ),
        ):Container();
        header.add(vig);
      }
      else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderTotal && logic.trackingPrefList[i].isSelected){
        var total = (Constant.configurationInfo.
        where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
            (element.isTotal) ).toList().isNotEmpty)?
        Container(
          margin: EdgeInsets.only(
              top:  AppFontStyle.sizesHeightManageWeb(0.3, constraints),
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
                              border: Border.all(width: 5),
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
                      fontSize: FontSize.size_3),
                ),
              ),
              (Constant.configurationInfo.
              where((element) => element.title ==
                  logic.selectedDateDailyLogClass.displayLabel &&
                  element.isTotal ).toList().isNotEmpty) ?
              Expanded(
                child: _editableTextTotalWeb(logic,true,
                    onChangeData: (value) {
                      logic.onChangeEditableTotalMinBottom(
                          value);
                    }),
              ):Container(),
            ],
          ),
        ):Container();
        header.add(total);
      }
      */
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
                              border: Border.all(width: 5),
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
                      fontSize: FontSize.size_3),
                ),
              ),
              Container(
                margin:
                EdgeInsets.only(left: Sizes.width_1_5),
              ),
              _checkBoxDaysStrengthWeb(
                context, logic, setStateBottom,true,),
            ],
          ),
        ): Container();
        header.add(strengthDays);
      }*/
    /*
      else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderCalories && logic.trackingPrefList[i].isSelected){
        var calories = (Constant.configurationInfo.
        where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
            element.isCalories ).toList().isNotEmpty) ?
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
                              border: Border.all(width: 5),
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
                      fontSize: FontSize.size_3),
                ),
              ),
              Container(
                margin:
                EdgeInsets.only(left: Sizes.width_1_5),
              ),
              Expanded(
                child: _editableTextCaloriesWeb(logic,true,
                    onChangeData: (value) {
                      logic
                          .onChangeEditableCaloriesBottom(
                          value);
                    }),
              ),
            ],
          ),
        ) : Container();
        header.add(calories);
      }
      else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderSteps && logic.trackingPrefList[i].isSelected){
        var steps = (Constant.configurationInfo.
        where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
            element.isSteps ).toList().isNotEmpty) ?
        Container(
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
                              border: Border.all(width: 5),
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
                      fontSize: FontSize.size_3),
                ),
              ),
              Container(
                margin:
                EdgeInsets.only(left: Sizes.width_1_5),
              ),
              Expanded(
                child: _editableTextStepsWeb(logic,true,
                    onChangeData: (value) {
                      logic
                          .onChangeEditableStepsBottom(
                          value);
                    }),
              ),
            ],
          ),
        ) : Container();
        header.add(steps);
      }
      else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderPeck && logic.trackingPrefList[i].isSelected){
        var peak = (Constant.configurationInfo.
        where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
            (element.isPeck)  ).toList().isNotEmpty) ?
        Container(
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
                              border: Border.all(width: 5),
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
                      fontSize: FontSize.size_3),
                ),
              ),
              (Constant.configurationInfo.
              where((element) => element.title ==
                  logic.selectedDateDailyLogClass.displayLabel &&
                  element.isPeck ).toList().isNotEmpty) ?
              Expanded(
                child:
                _editableTextPeakHeartRateWeb(
                    logic,true, onChangeData: (value) {
                  logic
                      .onChangeEditablePeakHeartBottom(
                      value);
                }),
              ): Container()
            ],
          ),
        ): Container();
        header.add(peak);
      }
      else if(logic.trackingPrefList[i].titleName == Constant.configurationExperience && logic.trackingPrefList[i].isSelected){
        var ex = (Constant.configurationInfo.
        where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
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
                              border: Border.all(width: 5),
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
                      fontSize: FontSize.size_3),
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
                          Constant.smiley1Title,isWeb: true),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Utils.getSmileyWidget(
                          Constant.smiley2ImgPath,
                          Constant.smiley2Title,isWeb: true),
                    ),
                    PopupMenuItem(
                      value: 3,
                      child: Utils.getSmileyWidget(
                          Constant.smiley3ImgPath,
                          Constant.smiley3Title,isWeb: true),
                    ),
                    PopupMenuItem(
                      value: 4,
                      child: Utils.getSmileyWidget(
                          Constant.smiley4ImgPath,
                          Constant.smiley4Title,isWeb: true),
                    ),
                    PopupMenuItem(
                      value: 5,
                      child: Utils.getSmileyWidget(
                          Constant.smiley5ImgPath,
                          Constant.smiley5Title,isWeb: true),
                    ),
                    PopupMenuItem(
                      value: 6,
                      child: Utils.getSmileyWidget(
                          Constant.smiley6ImgPath,
                          Constant.smiley6Title,isWeb: true),
                    ),
                    PopupMenuItem(
                      value: 7,
                      child: Utils.getSmileyWidget(
                          Constant.smiley7ImgPath,
                          Constant.smiley7Title,isWeb: true),
                    ),
                  ],
                  offset: Offset(-Sizes.width_9, 0),
                  color: Colors.grey[60],
                  elevation: 2,
                  onSelected: (value) {
                    // var labelIcon = "";


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
                          width: AppFontStyle.sizesFontManageWeb(1.1,constraints),
                          height: AppFontStyle.sizesFontManageWeb(1.1,constraints)),
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
      else if(logic.trackingPrefList[i].titleName == Constant.configurationNotes && logic.trackingPrefList[i].isSelected){
        var notes =  (Constant.configurationInfo.
        where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
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
                            border: Border.all(width: 5),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                            Constant.newActivityNotes)),
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
                      fontSize: FontSize.size_3),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: Sizes.width_1_5),
            ),
            Expanded(
              child: _editableTextNotesBottom(
                  logic,true, onChangeData: (value) {
                logic
                    .onChangeEditableTextValueNotesBottom(
                    value);
              }),
            ),
          ],
        ):Container();
        header.add(notes);
      }
    }
    header.add(Container(
      padding: EdgeInsets.only(
          top: Sizes.height_1_8, bottom: Sizes.height_10),
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
              padding: const EdgeInsets.all(8),
              child: Text(
                "Cancel",
                style: TextStyle(
                    color: CColor.black,
                    fontSize: FontSize.size_3),
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
              padding: EdgeInsets.only(
                  left: Sizes.width_6,
                  right: Sizes.width_6,
                  top: 7,
                  bottom: 7),
              child: Text(
                "Ok",
                style: TextStyle(
                    color: CColor.white,
                    fontSize: FontSize.size_3),
              ),
            ),
          ),
        ],
      ),
    ));
    return header;*/
  }

  /// Daily values
  bottomTapDetailsDaily(BuildContext context, HomeControllers logic,BoxConstraints constraints) {
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
                      left: AppFontStyle.sizesWidthManageWeb(0.5, constraints),
                      right: AppFontStyle.sizesWidthManageWeb(0.5, constraints),
                      bottom: AppFontStyle.sizesFontManageWeb(0.5, constraints)),
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
                                AppFontStyle.styleW500(CColor.white,  AppFontStyle.sizesFontManageWeb(1.8, constraints))),
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
                                  width: AppFontStyle.sizesWidthManageWeb(2.0, constraints),
                                  height: AppFontStyle.sizesWidthManageWeb(2.0, constraints),color: CColor.white,),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.only(
                              left: AppFontStyle.sizesWidthManageWeb(3.5, constraints),
                              right: AppFontStyle.sizesWidthManageWeb(3.5, constraints),
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
                                                    left: AppFontStyle.sizesWidthManageWeb(2.7, constraints)
                                                ),
                                                child: Text(
                                                  DateFormat(
                                                      Constant.commonDateFormatDdMmmYyyy)
                                                      .format(logic.selectedNewDateDaliy),
                                                  style: TextStyle(
                                                      color: CColor.black,
                                                      fontSize: AppFontStyle.sizesFontManageWeb(1.3, constraints),
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
                                  children: dailyValueRecordWidgetList(logic,context,setStateBottom,constraints)!,
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

 /*   Future<void> future = showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: CColor.transparent,
        // barrierColor: CColor.transparent,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, StateSetter setStateBottom) {
              return Wrap(
                children: [
                  Container(
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
                      Container(
                        margin: EdgeInsets.only(
                          left: Sizes.width_4,
                          right: Sizes.width_4,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          showDatePickerDialog(
                                              logic, context, setStateBottom,false)
                                              .then((value) => (value) {
                                            setStateBottom(() {});
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(top: Sizes.height_1_2),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Date: ",
                                                style: TextStyle(
                                                    color: CColor.black,
                                                    fontSize: FontSize.size_3,fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                DateFormat(
                                                    Constant.commonDateFormatDdMmYyyy)
                                                    .format(logic.selectedNewDateDaliy),
                                                style: TextStyle(
                                                    color: CColor.black,
                                                    fontSize: FontSize.size_3,fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: (){
                                    Get.back();
                                    Get.toNamed(AppRoutes.configuration,arguments: [false]);

                                  },
                                  child: Image.asset(Constant.settingConfigurationIcons,
                                    width:  Sizes.width_1,
                                    height: Sizes.width_1,),
                                )
                              ],
                            ),
                            Column(
                              children: dailyValueRecordWidgetList(logic,context,setStateBottom,constraints)!,
                            ),
                          ],
                        ),
                      )
                  ),
                ],
              );
            },
          );
        });*/
    future.then((void value) {
      logic.generateDateList();
    });
  }

  List<Widget>? dailyValueRecordWidgetList(HomeControllers logic, BuildContext context,setStateBottom,BoxConstraints constraints){
    List<Widget> header = [];
    for (int i = 0; i < logic.trackingPrefList.length; i++) {
      if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderModerate && logic.trackingPrefList[i].isSelected){
        var modWidget = (Constant.configurationInfo.
        where((element) =>
        (element.isModerate) ).toList().isNotEmpty)?
        Container(
          margin: EdgeInsets.only(
              top: AppFontStyle.sizesHeightManageWeb(0.3, constraints),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      bottom: AppFontStyle.sizesHeightManageWeb(1.8, constraints)
                  ),
                  child: Icon(Icons.more_time)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: AppFontStyle.sizesWidthManageWeb(2.7, constraints)
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
                                  fontSize: AppFontStyle.sizesFontManageWeb(1.3, constraints)),
                            ),
                          ),
                        ],
                      ),
                      (Constant.configurationInfo.
                      where((element) =>
                      element.isModerate ).toList().isNotEmpty) ?
                      Row(
                        children: [
                          Expanded(
                            child: _editableTextModWeb(logic,false,constraints,
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
        Container();


        header.add(modWidget);
      }
      else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderVigorous && logic.trackingPrefList[i].isSelected){
        var vig =   (Constant.configurationInfo.
        where((element) =>
        (element.isModerate || element.isVigorous || element.isTotal) ).toList().isNotEmpty)?
        Container(
          margin: EdgeInsets.only(
              top: AppFontStyle.sizesHeightManageWeb(0.3, constraints),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      bottom: AppFontStyle.sizesHeightManageWeb(1.8, constraints)
                  ),
                  child: Icon(Icons.more_time)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: AppFontStyle.sizesWidthManageWeb(2.7, constraints)
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
                                  fontSize: AppFontStyle.sizesFontManageWeb(1.3, constraints)),
                            ),
                          ),
                        ],
                      ),
                      (Constant.configurationInfo.
                      where((element) =>
                      element.isVigorous ).toList().isNotEmpty) ?
                      Row(
                        children: [
                          Expanded(
                              child: _editableTextVigWeb(logic,false,constraints,
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
        ):Container();
        header.add(vig);
      }
      else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderTotal && logic.trackingPrefList[i].isSelected){
        var total =   (Constant.configurationInfo.
        where((element) =>
        (element.isTotal) ).toList().isNotEmpty)?
        Container(
          margin: EdgeInsets.only(
              top: AppFontStyle.sizesHeightManageWeb(0.3, constraints),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      bottom: AppFontStyle.sizesHeightManageWeb(1.8, constraints)
                  ),
                  child: Icon(Icons.timelapse)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: AppFontStyle.sizesWidthManageWeb(2.7, constraints)
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
                                  fontSize: AppFontStyle.sizesFontManageWeb(1.3, constraints)),
                            ),
                          ),
                        ],
                      ),
                      (Constant.configurationInfo.
                      where((element) =>
                      element.isTotal ).toList().isNotEmpty) ?
                      Row(
                        children: [
                          Expanded(
                            child: _editableTextTotalWeb(logic,false,constraints,
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
        ):Container();
        header.add(total);
      } else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderDays && logic.trackingPrefList[i].isSelected){
        var strengthDays =(Constant.configurationInfo.
        where((element) =>
        element.isDaysStr ).toList().isNotEmpty) ?
        Container(
          margin: EdgeInsets.only(
              top: AppFontStyle.sizesHeightManageWeb(0.3, constraints),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      bottom: AppFontStyle.sizesHeightManageWeb(1.8, constraints)
                  ),
                  child: Icon(Icons.view_day)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: AppFontStyle.sizesWidthManageWeb(2.7, constraints)
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
                                  fontSize: AppFontStyle.sizesFontManageWeb(1.3, constraints)),
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
                          _checkBoxDaysStrengthWeb(
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
        ) : Container();
        header.add(strengthDays);
      }
      else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderCalories && logic.trackingPrefList[i].isSelected){
        var calories = (Constant.configurationInfo.
        where((element) =>
        element.isCalories ).toList().isNotEmpty) ?
        Container(
          margin: EdgeInsets.only(
              top: AppFontStyle.sizesHeightManageWeb(0.3, constraints),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      bottom: AppFontStyle.sizesHeightManageWeb(1.8, constraints)
                  ),
                  child: Icon(Icons.energy_savings_leaf_outlined)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: AppFontStyle.sizesWidthManageWeb(2.7, constraints)
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
                                  fontSize: AppFontStyle.sizesFontManageWeb(1.3, constraints)),
                            ),
                          ),
                        ],
                      ),
                      (Constant.configurationInfo.
                      where((element) =>
                      element.isCalories ).toList().isNotEmpty) ?
                      Row(
                        children: [
                          Expanded(
                            child: _editableTextCaloriesWeb(logic,false,constraints,
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
        ) : Container();
        header.add(calories);
      }
      else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderSteps && logic.trackingPrefList[i].isSelected){
        var steps =  (Constant.configurationInfo.
        where((element) =>
        element.isSteps ).toList().isNotEmpty) ?
        Container(
          margin: EdgeInsets.only(
              top: AppFontStyle.sizesHeightManageWeb(0.3, constraints),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      bottom: AppFontStyle.sizesHeightManageWeb(1.8, constraints)
                  ),
                  child: Icon(Icons.run_circle_outlined)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: AppFontStyle.sizesWidthManageWeb(2.7, constraints)
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
                                  fontSize: AppFontStyle.sizesFontManageWeb(1.3, constraints)),
                            ),
                          ),
                        ],
                      ),
                      (Constant.configurationInfo.
                      where((element) =>
                      element.isSteps ).toList().isNotEmpty) ?
                      Row(
                        children: [
                          Expanded(
                            child: _editableTextStepsWeb(logic,false,constraints,
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
        ) : Container();
        header.add(steps);
      }
      else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderRest && logic.trackingPrefList[i].isSelected){
        var rest = (Constant.configurationInfo.
        where((element) =>
        (element.isRest)  ).toList().isNotEmpty) ?
        Container(
          margin: EdgeInsets.only(
              top: AppFontStyle.sizesHeightManageWeb(0.3, constraints),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      bottom: AppFontStyle.sizesHeightManageWeb(1.8, constraints)
                  ),
                  child: Icon(Icons.monitor_heart_outlined)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: AppFontStyle.sizesWidthManageWeb(2.7, constraints)
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
                                  fontSize: AppFontStyle.sizesFontManageWeb(1.3, constraints)),
                            ),
                          ),
                        ],
                      ),
                      (Constant.configurationInfo.
                      where((element) =>
                      element.isRest ).toList().isNotEmpty) ?
                      Row(
                        children: [
                          Expanded(
                            child:
                            _editableTextRestHeartRateWeb(
                                logic,false, constraints,onChangeData: (value) {
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
        ) : Container();
        header.add(rest);
      }
      else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderPeck && logic.trackingPrefList[i].isSelected){
        var peak = (Constant.configurationInfo.
        where((element) =>
        (element.isPeck)).toList().isNotEmpty) ?
        Container(
          margin: EdgeInsets.only(
              top: AppFontStyle.sizesHeightManageWeb(0.3, constraints),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      bottom: AppFontStyle.sizesHeightManageWeb(1.8, constraints)
                  ),
                  child: Icon(Icons.monitor_heart_rounded)),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: AppFontStyle.sizesWidthManageWeb(2.7, constraints)
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
                                  fontSize: AppFontStyle.sizesFontManageWeb(1.3, constraints)),
                            ),
                          ),
                        ],
                      ),
                      (Constant.configurationInfo.
                      where((element) =>
                      element.isPeck ).toList().isNotEmpty) ?
                      Row(
                        children: [
                          Expanded(
                            child:
                            _editableTextPeakHeartRateWeb(
                                logic, false,constraints,onChangeData: (value) {
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
          top: AppFontStyle.sizesHeightManageWeb(0.5, constraints), bottom: AppFontStyle.sizesHeightManageWeb(2.5, constraints)),
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
                  horizontal: AppFontStyle.sizesWidthManageWeb(2.5, constraints),
                  vertical: AppFontStyle.sizesHeightManageWeb(1.0, constraints)
              ),
              child: Text(
              "Cancel",
              style: TextStyle(
                  color: CColor.black,
                  fontSize: AppFontStyle.sizesFontManageWeb(1.5, constraints)),
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
                  horizontal: AppFontStyle.sizesWidthManageWeb(4.5, constraints),
                  vertical: AppFontStyle.sizesHeightManageWeb(1.0, constraints)
              ),
              child: Text(
                "Ok",
                style: TextStyle(
                    color: CColor.white,
                    fontSize: AppFontStyle.sizesFontManageWeb(1.5, constraints)),
              ),
            ),
          ),
        ],
      ),
    ));
    return header;

    /*for (int i = 0; i < logic.trackingPrefList.length; i++) {
      if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderModerate && logic.trackingPrefList[i].isSelected){
        var modWidget = (Constant.configurationInfo.
        where((element) =>
        (element.isModerate) ).toList().isNotEmpty)?
        Container(
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
                              border: Border.all(width: 5),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Text(
                              Constant.dailyValuesModMin)),
                    ),
                  ];
                },
                child: Text(
                  "${Constant.configurationHeaderModerate}: ",
                  style: TextStyle(
                      color: CColor.black,
                      fontSize: FontSize.size_3),
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
                child: _editableTextModWeb(logic,false,constraints,
                    onChangeData: (value) {
                      logic.onChangeDayValue1Bottom(
                          value);
                    }),
              ) : Container(),
              const Text("  "),
            ],
          ),
        ):Container();


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
                              border: Border.all(width: 5),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Text(
                              Constant.dailyValuesVigMin)),
                    ),
                  ];
                },
                child: Text(
                  "${Constant.configurationHeaderVigorous}: ",
                  style: TextStyle(
                      color: CColor.black,
                      fontSize: FontSize.size_3),
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
                  child: _editableTextVigWeb(logic,false,constraints,
                      onChangeData: (value) {
                        logic.onChangeDayValue2Bottom(
                            value);
                      })) : Container(),
              const Text("  "),

            ],
          ),
        ):Container();
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
                              border: Border.all(width: 5),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Text(
                              Constant.dailyValuesTotal)),
                    ),
                  ];
                },
                child: Text(
                  "${Constant.configurationHeaderTotal}: ",
                  style: TextStyle(
                      color: CColor.black,
                      fontSize: FontSize.size_3),
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
                child: _editableTextTotalWeb(logic,false,constraints,
                    onChangeData: (value) {
                      logic.onChangeDayTotalBottom(
                          value);
                    }),
              ):Container(),
            ],
          ),
        ):Container();
        header.add(total);
      }
      */
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
                            border: Border.all(width: 5),
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
                      fontSize: FontSize.size_3),
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
    /*
      else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderDays && logic.trackingPrefList[i].isSelected){
        var strengthDays =(Constant.configurationInfo.
        where((element) =>
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
                              border: Border.all(width: 5),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Text(
                              Constant.dailyValuesStrengthDay)),
                    ),
                  ];
                },
                child: Text(
                  "${Constant.daysStrength}: ",
                  style: TextStyle(
                      color: CColor.black,
                      fontSize: FontSize.size_3),
                ),
              ),
              Container(
                margin:
                EdgeInsets.only(left: Sizes.width_1_5),
              ),
              _checkBoxDaysStrengthWeb(
                context, logic, setStateBottom,false,),
            ],
          ),
        ): Container();
        header.add(strengthDays);
      }
      else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderCalories && logic.trackingPrefList[i].isSelected){
        var calories = (Constant.configurationInfo.
        where((element) =>
        element.isCalories ).toList().isNotEmpty) ?
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
                              border: Border.all(width: 5),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Text(
                              Constant.dailyValuesCalories)),
                    ),
                  ];
                },
                child: Text(
                  "${Constant.calories}: ",
                  style: TextStyle(
                      color: CColor.black,
                      fontSize: FontSize.size_3),
                ),
              ),
              Container(
                margin:
                EdgeInsets.only(left: Sizes.width_1_5),
              ),
              Expanded(
                child: _editableTextCaloriesWeb(logic,false,constraints,
                    onChangeData: (value) {
                      logic
                          .onChangeDayTitle3Bottom(
                          value);
                    }),
              ),
            ],
          ),
        ) : Container();
        header.add(calories);
      }
      else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderSteps && logic.trackingPrefList[i].isSelected){
        var steps =  (Constant.configurationInfo.
        where((element) =>
        element.isSteps ).toList().isNotEmpty) ?
        Container(
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
                              border: Border.all(width: 5),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Text(
                              Constant.dailyValuesSteps)),
                    ),
                  ];
                },
                child: Text(
                  "${Constant.steps}: ",
                  style: TextStyle(
                      color: CColor.black,
                      fontSize: FontSize.size_3),
                ),
              ),
              Container(
                margin:
                EdgeInsets.only(left: Sizes.width_1_5),
              ),
              Expanded(
                child: _editableTextStepsWeb(logic,false,constraints,
                    onChangeData: (value) {
                      logic
                          .onChangeDayTitle4Bottom(
                          value);
                    }),
              ),
            ],
          ),
        ) : Container();
        header.add(steps);
      }
      else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderRest && logic.trackingPrefList[i].isSelected){
        var rest = (Constant.configurationInfo.
        where((element) =>
        (element.isRest)  ).toList().isNotEmpty) ?
        Container(
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
                              border: Border.all(width: 5),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Text(
                              Constant.dailyValuesRestingHeartRate)),
                    ),
                  ];
                },
                child: Text(
                  "${Constant.configurationHeaderRest}: ",
                  style: TextStyle(
                      color: CColor.black,
                      fontSize: FontSize.size_3),
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
                _editableTextRestHeartRateWeb(
                    logic,false, constraints, onChangeData: (value) {
                  logic
                      .onChangeDayValue1Title5Bottom(
                      value);
                }),
              ):Container(),
            ],
          ),
        ): Container();
        header.add(rest);
      }
      else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderPeck && logic.trackingPrefList[i].isSelected){
        var peak = (Constant.configurationInfo.
        where((element) =>
        (element.isPeck)).toList().isNotEmpty) ?
        Container(
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
                              border: Border.all(width: 5),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Text(
                              Constant.dailyValuesPeakHeartRate)),
                    ),
                  ];
                },
                child: Text(
                  "${Constant.configurationHeaderPeck}: ",
                  style: TextStyle(
                      color: CColor.black,
                      fontSize: FontSize.size_3),
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
                _editableTextPeakHeartRateWeb(
                    logic, false,constraints,onChangeData: (value) {
                  logic
                      .onChangeDayValue2Title5Bottom(
                      value);
                }),
              ): Container()
            ],
          ),
        ): Container();
        header.add(peak);
      }
      */
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
                              border: Border.all(width: 5),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Text(
                              Constant.dailyValuesModMin)),
                    ),
                  ];
                },
                child: Text(
                  "${Constant.experience}: ",
                  style: TextStyle(
                      color: CColor.black,
                      fontSize: FontSize.size_3),
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
                          Constant.smiley1Title,isWeb: true),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Utils.getSmileyWidget(
                          Constant.smiley2ImgPath,
                          Constant.smiley2Title,isWeb: true),
                    ),
                    PopupMenuItem(
                      value: 3,
                      child: Utils.getSmileyWidget(
                          Constant.smiley3ImgPath,
                          Constant.smiley3Title,isWeb: true),
                    ),
                    PopupMenuItem(
                      value: 4,
                      child: Utils.getSmileyWidget(
                          Constant.smiley4ImgPath,
                          Constant.smiley4Title,isWeb: true),
                    ),
                    PopupMenuItem(
                      value: 5,
                      child: Utils.getSmileyWidget(
                          Constant.smiley5ImgPath,
                          Constant.smiley5Title,isWeb: true),
                    ),
                    PopupMenuItem(
                      value: 6,
                      child: Utils.getSmileyWidget(
                          Constant.smiley6ImgPath,
                          Constant.smiley6Title,isWeb: true),
                    ),
                    PopupMenuItem(
                      value: 7,
                      child: Utils.getSmileyWidget(
                          Constant.smiley7ImgPath,
                          Constant.smiley7Title,isWeb: true),
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
                          width: Sizes.width_1,
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
      }*//*
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
              padding: const EdgeInsets.all(8),
              child: Text(
                "Cancel",
                style: TextStyle(
                    color: CColor.black,
                    fontSize: FontSize.size_3),
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
              padding: EdgeInsets.only(
                  left: Sizes.width_6,
                  right: Sizes.width_6,
                  top: 7,
                  bottom: 7),
              child: Text(
                "Ok",
                style: TextStyle(
                    color: CColor.white,
                    fontSize: FontSize.size_3),
              ),
            ),
          ),
        ],
      ),
    ));
    return header;*/
  }

}
