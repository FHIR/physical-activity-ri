import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/ui/home/home/controllers/home_controllers.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../utils/debug.dart';
import '../../../utils/utils.dart';
import '../controllers/mixed_controller.dart';

class MixedScreen extends StatelessWidget {
  const MixedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          useMaterial3: false
      ),
      child: Scaffold(
        backgroundColor: CColor.white,
        body: SafeArea(
            child: SingleChildScrollView(
              child: GetBuilder<MixedController>(builder: (logic) {
                return Column(
                  children: [
                    _widgetGoalView(),
                    // _widgetReferral(),
                    _widgetCondition(),
                    _widgetCarePlan(),
                    _widgetToDoList(),
                    _widgetRecordActivity(logic,context),
                    _widgetMonthlySummary(),
                    _widgetTrackingChart(logic),
                  ],
                );
              }),
            )
        ),
      ),
    );
  }

  _widgetGoalView() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.goalList);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
            vertical: Sizes.height_0_0_5),
        padding: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
            vertical: Sizes.height_1_8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CColor.primaryColor30,
              ),
              child: Image.asset(
                "assets/icons/ic_goal.png",
                height: Sizes.height_2,
                width: Sizes.height_2,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: Sizes.width_3),
                child: Text(
                  "Goal",
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


  _widgetReferral() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.referralList);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
            vertical: Sizes.height_0_0_5),
        padding: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
            vertical: Sizes.height_2),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CColor.primaryColor30,
              ),
              child: Image.asset(
                Constant.settingReferralIcons,
                height: Sizes.height_2,
                width: Sizes.height_2,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: Sizes.width_3),
                child: Text(
                  Constant.settingReferral,
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

  _widgetCondition() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.conditionList);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
            vertical: Sizes.height_0_0_5),
        padding: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
            vertical: Sizes.height_2),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CColor.primaryColor30,
              ),
              child: Image.asset(
                Constant.settingConditionIcons,
                height: Sizes.height_2,
                width: Sizes.height_2,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: Sizes.width_3),
                child: Text(
                  Constant.settingCondition,
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

  _widgetCarePlan() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.carePlanList);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
            vertical: Sizes.height_0_0_5),
        padding: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
            vertical: Sizes.height_2),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CColor.primaryColor30,
              ),
              child: Image.asset(
                Constant.settingCarePlanIcons,
                height: Sizes.height_2,
                width: Sizes.height_2,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: Sizes.width_3),
                child: Text(
                  Constant.settingCarePlan,
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

  _widgetToDoList() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.toDoFormScreen,arguments: [null,Constant.todoFromSetting]);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
            vertical: Sizes.height_0_0_5),
        padding: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
            vertical: Sizes.height_2),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CColor.primaryColor30,
              ),
              child: Image.asset(
                Constant.icToToList,
                height: Sizes.height_2,
                width: Sizes.height_2,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: Sizes.width_3),
                child: Text(
                  Constant.settingToDoList,
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

  _widgetRecordActivity(MixedController logic, BuildContext context) {
    return GestureDetector(
      onTap: () {
        logic.getPreferenceActivityData();
        var selectedDateFirstDate = logic.dailyLogDataList.where((element) =>
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

        logic.changeTitleDropDown(
            "",
            logic.selectedNewDate,
            isGetData: true);
        bottomTapDetailsView(context, logic);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
            vertical: Sizes.height_0_0_5),
        padding: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
            vertical: Sizes.height_2),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CColor.primaryColor30,
              ),
              child: Image.asset(
                Constant.homeRecordActivity,
                height: Sizes.height_2,
                width: Sizes.height_2,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: Sizes.width_3),
                child: Text(
                  Constant.homeRecord,
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

  _widgetMonthlySummary() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.homeMonthly);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
            vertical: Sizes.height_0_0_5),
        padding: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
            vertical: Sizes.height_2),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CColor.primaryColor30,
              ),
              child: Image.asset(
                Constant.homeMonthlySummary,
                height: Sizes.height_2,
                width: Sizes.height_2,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: Sizes.width_3),
                child: Text(
                  Constant.homeMonthly,
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

  _widgetTrackingChart(MixedController logic) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.history);
        // logic.gotoTrackingChartPage();
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
            vertical: Sizes.height_0_0_5),
        padding: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
            vertical: Sizes.height_2),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CColor.primaryColor30,
              ),
              child: Image.asset(
                Constant.homeTrackingChart,
                height: Sizes.height_2,
                width: Sizes.height_2,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: Sizes.width_3),
                child: Text(
                  Constant.homeTracking,
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

  bottomTapDetailsView(BuildContext context, MixedController logic,) {
    Future<void> future = showModalBottomSheet<void>(
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
                          left: Sizes.width_12,
                          right: Sizes.width_12,
                        ),
                        child: Column(
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
                                              logic, context, setStateBottom)
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
                                                    fontSize: FontSize.size_14,fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                DateFormat(
                                                    Constant.commonDateFormatDdMmYyyy)
                                                    .format(logic.selectedNewDate),
                                                style: TextStyle(
                                                    color: CColor.black,
                                                    fontSize: FontSize.size_14,fontWeight: FontWeight.bold),
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
                                                  logic.changeTitleDropDown(
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
                                    width:  Sizes.width_6,
                                    height: Sizes.width_6,),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                (Constant.configurationInfo.
                                where((element) => element.title ==
                                    logic.selectedDateDailyLogClass.displayLabel &&
                                    (element.isModerate || element.isVigorous || element.isTotal) ).toList().isNotEmpty)?
                                Container(
                                  margin: EdgeInsets.only(
                                      top: Sizes.height_1_8
                                  ),
                                  padding: EdgeInsets.only(top: Sizes.height_1_2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${Constant.activityMinutes}: ",
                                        style: TextStyle(
                                            color: CColor.black,
                                            fontSize: FontSize.size_12),
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
                                        child: _editableTextValue1Bottom(logic,
                                            onChangeData: (value) {
                                              logic.onChangeEditableTextValue1Bottom(
                                                  value);
                                            }),
                                      ) : Container(),
                                      const Text("  "),

                                      (Constant.configurationInfo.
                                      where((element) => element.title ==
                                          logic.selectedDateDailyLogClass.displayLabel &&
                                          element.isVigorous ).toList().isNotEmpty) ?
                                      Expanded(
                                          child: _editableTextValue2Bottom(logic,
                                              onChangeData: (value) {
                                                logic.onChangeEditableTextValue2Bottom(
                                                    value);
                                              })) : Container(),
                                      const Text("  "),

                                      (Constant.configurationInfo.
                                      where((element) => element.title ==
                                          logic.selectedDateDailyLogClass.displayLabel &&
                                          element.isTotal ).toList().isNotEmpty) ?
                                      Expanded(
                                        child: _editableTextTotalBottom(logic,
                                            onChangeData: (value) {
                                              logic.onChangeEditableTextTotalBottom(
                                                  value);
                                            }),
                                      ):Container(),
                                    ],
                                  ),
                                ):Container(),
                                /*else
                                Container(),*/
                                /*if (Constant.daysStrengthShowWithItem.contains(
                                  logic.selectedDateDailyLogClass.displayLabel))*/
                                (Constant.configurationInfo.
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
                                      Text(
                                        "${Constant.daysStrength}: ",
                                        style: TextStyle(
                                            color: CColor.black,
                                            fontSize: FontSize.size_12),
                                      ),
                                      Container(
                                        margin:
                                        EdgeInsets.only(left: Sizes.width_1_5),
                                      ),
                                      _itemTitle2CheckBoxDaysEditTextBottom(
                                          context, logic, setStateBottom),
                                    ],
                                  ),
                                ): Container(),
                                /*else
                                Container(),*/
                                /*if (Constant.caloriesShowWithItem.contains(
                                  logic.selectedDateDailyLogClass.displayLabel))*/
                                (Constant.configurationInfo.
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
                                      Text(
                                        "${Constant.calories}: ",
                                        style: TextStyle(
                                            color: CColor.black,
                                            fontSize: FontSize.size_12),
                                      ),
                                      Container(
                                        margin:
                                        EdgeInsets.only(left: Sizes.width_1_5),
                                      ),
                                      Expanded(
                                        child: _editableTextValueTitle3Bottom(logic,
                                            onChangeData: (value) {
                                              logic
                                                  .onChangeEditableTextValueTitle3Bottom(
                                                  value);
                                            }),
                                      ),
                                    ],
                                  ),
                                ) : Container(),
                                /*else
                                Container()*/
                                /*if (Constant.stepsShowWithItem.contains(
                                  logic.selectedDateDailyLogClass.displayLabel))*/
                                (Constant.configurationInfo.
                                where((element) => element.title ==
                                    logic.selectedDateDailyLogClass.displayLabel &&
                                    element.isSteps ).toList().isNotEmpty) ?
                                Container(
                                  padding: EdgeInsets.only(top: Sizes.height_1_2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${Constant.steps}: ",
                                        style: TextStyle(
                                            color: CColor.black,
                                            fontSize: FontSize.size_12),
                                      ),
                                      Container(
                                        margin:
                                        EdgeInsets.only(left: Sizes.width_1_5),
                                      ),
                                      Expanded(
                                        child: _editableTextValueTitle4Bottom(logic,
                                            onChangeData: (value) {
                                              logic
                                                  .onChangeEditableTextValueTitle4Bottom(
                                                  value);
                                            }),
                                      ),
                                    ],
                                  ),
                                ) : Container(),
                                /*else
                                Container()*/
                                /*if (Constant.heartPeckShowWithItem.contains(
                                  logic.selectedDateDailyLogClass.displayLabel))*/
                                (Constant.configurationInfo.
                                where((element) => element.title ==
                                    logic.selectedDateDailyLogClass.displayLabel &&
                                    (element.isRest || element.isPeck)  ).toList().isNotEmpty) ?
                                Container(
                                  padding: EdgeInsets.only(top: Sizes.height_1_2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${Constant.heartRate}: ",
                                        style: TextStyle(
                                            color: CColor.black,
                                            fontSize: FontSize.size_12),
                                      ),
                                      Container(
                                        margin:
                                        EdgeInsets.only(left: Sizes.width_1_5),
                                      ),
                                      (Constant.configurationInfo.
                                      where((element) => element.title ==
                                          logic.selectedDateDailyLogClass.displayLabel &&
                                          element.isRest ).toList().isNotEmpty) ?
                                      Expanded(
                                        child:
                                        _editableTextValueTitle5InValue1Bottom(
                                            logic, onChangeData: (value) {
                                          logic
                                              .onChangeEditableTextValue1Title5Bottom(
                                              value);
                                        }),
                                      ):Container(),
                                      const Text("  "),
                                      (Constant.configurationInfo.
                                      where((element) => element.title ==
                                          logic.selectedDateDailyLogClass.displayLabel &&
                                          element.isPeck ).toList().isNotEmpty) ?
                                      Expanded(
                                        child:
                                        _editableTextValueTitle5InValue2Bottom(
                                            logic, onChangeData: (value) {
                                          logic
                                              .onChangeEditableTextValue2Title5Bottom(
                                              value);
                                        }),
                                      ): Container()
                                    ],
                                  ),
                                ): Container()
                                /*else
                                Container()*/,
                                /*if (Constant.experienceShowWithItem.contains(
                                  logic.selectedDateDailyLogClass.displayLabel))*/
                                Container(
                                  padding: EdgeInsets.only(top: Sizes.height_1_2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${Constant.experience}: ",
                                        style: TextStyle(
                                            color: CColor.black,
                                            fontSize: FontSize.size_12),
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
                                              logic.updateSmileyForBottom(value);
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
                                )
                                /*else
                                Container()*/,
                                Container(
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
                                                fontSize: FontSize.size_14),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          logic.updateSingleDataFromSheet();
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
                                                fontSize: FontSize.size_14),
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
                      )/* :
                    Container(
                            margin: EdgeInsets.only(
                                left: Sizes.width_12,
                                right: Sizes.width_12,
                                top: Sizes.height_4,
                                bottom: Sizes.height_4),
                            alignment: Alignment.center,
                            child: Text(
                              "Please  Enable For Activity Configuration",
                              style: AppFontStyle.styleW700(
                                  CColor.black, FontSize.size_13),
                            ),
                          ),*/
                  ),
                ],
              );
            },
          );
        });
    future.then((void value) {
      logic.generateDateList();
    });
  }

  Future<void> showDatePickerDialog(MixedController logic, BuildContext context,
      StateSetter setStateBottom) async {
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
                  logic.onSelectionChangedDatePicker(
                      dateRangePickerSelectionChangedArgs);
                  setStateBottom(() {});
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
                    logic.changeTitleDropDown(
                        Constant.itemBicycling, logic.selectedNewDate);
                  });
                  Get.back();
                  // logic.updateData(logic.selectedNewDate);
                },
              )),
        );
      },
    ).then((value) => (value) {
      Debug.printLog("Close....");
      setStateBottom(() {});
    });
  }


  Widget _widgetNumberImage(String type) {
    return Row(
      children: [
        Image.asset(
          Utils.getNumberIconNameFromType(type),
          height: Sizes.width_5,
          width: Sizes.width_5,
        ),
        Container(
          margin: EdgeInsets.only(left: Sizes.width_2),
          child: Text(type,style: TextStyle(
              fontSize: FontSize.size_13
          ),),
        ),
      ],
    );
  }

  /*User on The Bottom Sheet*/

  Widget _editableTextValue1Bottom(MixedController logic,
      {Function? onChangeData}) {
    return SizedBox(
      width: 20,
      height: 20,
      child: TextField(
        /*enabled: (logic.selectedDateDailyLogClass.displayLabel ==
            Constant.itemRunning) ? false : true,*/
        enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
            element.isModerate ).toList().isNotEmpty),
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
            hintText: 'Mod'
        ),
        enableInteractiveSelection: false,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: FontSize.size_10),
        maxLines: 1,
        autofocus: false,
        autocorrect: true,
        controller: logic.selectedDateDailyLogClass.title1Value1Controller,
        onChanged: (value) {
          if (onChangeData != null) {
            onChangeData.call(value);
          }
        },
      ),
    );
  }

  Widget _editableTextValue2Bottom(MixedController logic,
      {Function? onChangeData}) {
    return SizedBox(
      width: 20,
      height: 20,
      child: TextField(
        /*enabled: (logic.selectedDateDailyLogClass.displayLabel ==
            Constant.itemRunning) ? false : true,*/
        enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
            element.isVigorous ).toList().isNotEmpty ),
        textAlign: TextAlign.center,
        enableInteractiveSelection: false,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: FontSize.size_10),
        maxLines: 1,
        decoration: const InputDecoration(
            hintText: 'Vig'
        ),
        autofocus: false,
        autocorrect: true,
        controller: logic.selectedDateDailyLogClass.title1Value2Controller,
        onChanged: (value) {
          if (onChangeData != null) {
            onChangeData.call(value);
          }
        },
      ),
    );
  }

  Widget _editableTextTotalBottom(MixedController logic,
      {Function? onChangeData}) {
    return SizedBox(
      width: 20,
      height: 20,
      child: TextField(
        /*enabled: (logic.selectedDateDailyLogClass.displayLabel ==
            Constant.itemRunning) ? false : true,*/
        enabled: ( Constant.configurationInfo.where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
            element.isTotal ).toList().isNotEmpty ),
        textAlign: TextAlign.center,
        enableInteractiveSelection: false,
        keyboardType: TextInputType.number,
        style: TextStyle(
          fontSize: FontSize.size_10,
        ),
        maxLines: 1,
        decoration: const InputDecoration(
            hintText: 'Total'
        ),
        autofocus: false,
        autocorrect: true,
        controller: logic.selectedDateDailyLogClass.title1TotalValueController,
        onChanged: (value) {
          if (onChangeData != null) {
            onChangeData.call(value);
          }
        },
      ),
    );
  }

  _itemTitle2CheckBoxDaysEditTextBottom(
      BuildContext context, MixedController logic, StateSetter setState) {
    return Container(

      height: Sizes.height_1,
      child: Checkbox(
        value: logic.bottomIsCheckedDayData,
        onChanged: (!Constant.isEditMode || Constant.configurationInfo.where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
            element.isDaysStr ).toList().isEmpty )
            ? null
            :(value) {
          setState(() {
            logic.onChangeCheckBoxValueBottom(value!);
          });
        },
      ),
    );
  }

  Widget _editableTextValueTitle3Bottom(MixedController logic,
      {Function? onChangeData}) {
    return SizedBox(
      width: 20,
      height: 20,
      child: TextField(
        /* enabled: (logic.selectedDateDailyLogClass.displayLabel ==
            Constant.itemRunning) ? false : true,*/
        enabled: (Constant.configurationInfo.where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
            element.isCalories ).toList().isNotEmpty ),
        textAlign: TextAlign.center,
        enableInteractiveSelection: false,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: FontSize.size_10),
        maxLines: 1,
        autofocus: false,
        autocorrect: true,
        controller: logic.selectedDateDailyLogClass.title3TotalValueController,
        onChanged: (value) {
          if (onChangeData != null) {
            onChangeData.call(value);
          }
        },
      ),
    );
  }

  Widget _editableTextValueTitle4Bottom(MixedController logic,
      {Function? onChangeData}) {
    return SizedBox(
      width: 20,
      height: 20,
      child: TextField(
        /* enabled: (logic.selectedDateDailyLogClass.displayLabel ==
           Constant.itemRunning) ? false : true,*/

        enabled: (Constant.configurationInfo.where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
            element.isSteps ).toList().isNotEmpty ),
        textAlign: TextAlign.center,
        enableInteractiveSelection: false,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: FontSize.size_10),
        maxLines: 1,
        autofocus: false,
        autocorrect: true,
        controller: logic.selectedDateDailyLogClass.title4TotalValueController,
        onChanged: (value) {
          if (onChangeData != null) {
            onChangeData.call(value);
          }
        },
      ),
    );
  }

  Widget _editableTextValueTitle5InValue1Bottom(MixedController logic,
      {Function? onChangeData}) {
    return SizedBox(
      width: 20,
      height: 20,
      child: TextField(
        // enabled: Constant.isEditMode,
        enabled: (Constant.configurationInfo.where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
            element.isRest ).toList().isNotEmpty ),
        textAlign: TextAlign.center,
        enableInteractiveSelection: false,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: FontSize.size_10),
        maxLines: 1,
        decoration: const InputDecoration(
            hintText: 'Rest'
        ),
        autofocus: false,
        autocorrect: true,
        controller: logic.selectedDateDailyLogClass.title5Value1Controller,
        onChanged: (value) {
          if (onChangeData != null) {
            onChangeData.call(value);
          }
        },
      ),
    );
  }

  Widget _editableTextValueTitle5InValue2Bottom(MixedController logic,
      {Function? onChangeData}) {
    return SizedBox(
      width: 20,
      height: 20,
      child: TextField(
        // enabled: Constant.isEditMode,
        enabled: (Constant.configurationInfo.where((element) => element.title ==
            logic.selectedDateDailyLogClass.displayLabel &&
            element.isPeck ).toList().isNotEmpty ),
        textAlign: TextAlign.center,
        enableInteractiveSelection: false,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: FontSize.size_10),
        maxLines: 1,
        decoration: const InputDecoration(
            hintText: 'Peak'
        ),
        autofocus: false,
        autocorrect: true,
        controller: logic.selectedDateDailyLogClass.title5Value2Controller,
        onChanged: (value) {
          if (onChangeData != null) {
            onChangeData.call(value);
          }
        },
      ),
    );
  }
}
