import 'dart:io';

import 'package:banny_table/ui/history/datamodel/activityMinClass.dart';
import 'package:banny_table/ui/history/datamodel/caloriesStepHeartRate.dart';
import 'package:banny_table/ui/history/datamodel/daysStrength.dart';
import 'package:banny_table/ui/history/datamodel/editableActivityMinutes/activityMinutesDay.dart';
import 'package:banny_table/ui/history/others/tableColumns/columnsWhatWhen.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../healthData/getSetHealthData.dart';
import '../../../routes/filterDialog.dart';
import '../../../utils/font_style.dart';
import '../controllers/history_controller.dart';
import '../datamodel/editableActivityMinutes/activityMinutesDayData.dart';
import '../datamodel/editableActivityMinutes/activityMinutesWeek.dart';
import '../datamodel/editableCaloriesStep/editableCalStepDay.dart';
import '../datamodel/editableCaloriesStep/editableCalStepDayData.dart';
import '../datamodel/editableCaloriesStep/editableCalStepWeek.dart';
import '../datamodel/editableHeartRate/editableHeartRateDay.dart';
import '../datamodel/editableHeartRate/editableHeartRateDayData.dart';
import '../datamodel/editableHeartRate/editableHeartRateWeek.dart';
import '../others/tableColumns/columnsActivityMin.dart';
import '../others/tableColumns/columnsCalories.dart';
import '../others/tableColumns/columnsDaysStr.dart';
import '../others/tableColumns/columnsExperience.dart';
import '../others/tableColumns/columnsHeartRate.dart';
import '../others/tableColumns/columnsSteps.dart';

class MobileHistoryScreen extends StatelessWidget {
  // HistoryController? historyController = Get.find<HistoryController>();

  MobileHistoryScreen({Key? key}) : super(key: key);

  // MobileHistoryScreen({Key? key,@required this.historyController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery
        .of(context)
        .orientation;
    // historyController!.onChangePortraitLandscape(orientation);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CColor.white,
      body: SafeArea(
        child: GetBuilder<HistoryController>(
          init: HistoryController(),
          assignId: true,
          builder: (logic) {
            logic.onChangePortraitLandscape(orientation);
            // return Utils.pullToRefreshApi(_widgetHistory(context,orientation,logic),logic.refreshController,logic.onRefresh,logic.onLoading);
            return _widgetHistory(context, orientation, logic);
          },
        ),
      ),
    );
  }

  _widgetHistory(BuildContext context, Orientation orientation,
      HistoryController logic) {
    return (orientation == Orientation.portrait) ?
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _widgetToggleFilter(context, logic, orientation),
        _widgetSelectedDates(context, logic),
        Expanded(child: _getBodyWidget(context, orientation, logic, false))
      ],
    ) :
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _widgetToggle(context, logic, isLandscape: true),
            Expanded(
              child: _widgetSelectedDates(context, logic, isLandscape: true),),
            _widgetDatePicker(context, logic, orientation, isLandscape: true),
            _widgetFilter(context, logic, orientation, isLandscape: true)
          ],
        ),
        Expanded(child: _getBodyWidget(context, orientation, logic, true))
      ],
    );
  }

  Widget _getBodyWidget(BuildContext context, Orientation orientation,
      HistoryController logic, bool isScroll) {
    return SizedBox(
      height: MediaQuery
          .of(context)
          .size
          .height,
      child: HorizontalDataTable(
        leftHandSideColumnWidth: MediaQuery
            .of(context)
            .size
            .width * ((logic.isPortrait) ? 0.35 : 0.2),
        rightHandSideColumnWidth: MediaQuery
            .of(context)
            .size
            .width * (Utils.getTableWidth(
            context,
            (logic.trackingPrefList.where((element) =>
            element.titleName == Constant.configurationHeaderModerate
                && element.isSelected)
                .toList()
                .isNotEmpty),
            (logic.trackingPrefList.where((element) =>
            element.titleName == Constant.configurationHeaderVigorous
                && element.isSelected)
                .toList()
                .isNotEmpty),
            (logic.trackingPrefList.where((element) =>
            element.titleName == Constant.configurationHeaderTotal
                && element.isSelected)
                .toList()
                .isNotEmpty),
            (logic.trackingPrefList.where((element) =>
            element.titleName == Constant.configurationNotes
                && element.isSelected)
                .toList()
                .isNotEmpty),
            (logic.trackingPrefList.where((element) =>
            element.titleName == Constant.configurationHeaderDays
                && element.isSelected)
                .toList()
                .isNotEmpty),
            (logic.trackingPrefList.where((element) =>
            element.titleName == Constant.configurationHeaderCalories
                && element.isSelected)
                .toList()
                .isNotEmpty),
            (logic.trackingPrefList.where((element) =>
            element.titleName == Constant.configurationHeaderSteps
                && element.isSelected)
                .toList()
                .isNotEmpty),
            (logic.trackingPrefList.where((element) =>
            element.titleName == Constant.configurationHeaderRest
                && element.isSelected)
                .toList()
                .isNotEmpty),
            (logic.trackingPrefList.where((element) =>
            element.titleName == Constant.configurationHeaderPeck
                && element.isSelected)
                .toList()
                .isNotEmpty),
            (logic.trackingPrefList.where((element) =>
            element.titleName == Constant.configurationExperience
                && element.isSelected)
                .toList()
                .isNotEmpty),
            logic)),
        isFixedHeader: true,
        headerWidgets: headerWidget(orientation, logic, context),
        leftSideItemBuilder: (context, index) {
          return leftSideWidget(orientation, logic, context);
        },
        rightSideItemBuilder: (context, index) {
          return _rightSideWidget(orientation, logic, context);
        },
        itemCount: 1,
        rowSeparatorWidget: const Divider(
          color: Colors.black54,
          height: 1.0,
          thickness: 0.0,
        ),
      ),
    );
  }

  List<Widget>? headerWidget(Orientation orientation, HistoryController logic,
      BuildContext context) {
    List<Widget> header = [];
    header.add(cWhatWhenWidgetNormal(orientation, context, logic));

    for (int i = 0; i < logic.trackingPrefList.length; i++) {
      if (logic.trackingPrefList[i].titleName ==
          Constant.configurationHeaderModerate &&
          logic.trackingPrefList[i].isSelected) {
        header.add(cActivityMinNormal(
            orientation, logic, context, Constant.configurationHeaderModerate));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationHeaderVigorous &&
          logic.trackingPrefList[i].isSelected) {
        header.add(cActivityMinNormal(
            orientation, logic, context, Constant.configurationHeaderVigorous));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationHeaderTotal &&
          logic.trackingPrefList[i].isSelected) {
        header.add(cActivityMinNormal(
            orientation, logic, context, Constant.configurationHeaderTotal));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationNotes && logic.trackingPrefList[i].isSelected) {
        header.add(cActivityMinNormal(
            orientation, logic, context, Constant.configurationNotes));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationHeaderDays &&
          logic.trackingPrefList[i].isSelected) {
        header.add(cDaysStrNormal(orientation, logic, context));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationHeaderCalories &&
          logic.trackingPrefList[i].isSelected) {
        header.add(cCaloriesNormal(orientation, logic, context));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationHeaderSteps &&
          logic.trackingPrefList[i].isSelected) {
        header.add(cStepsNormal(orientation, logic, context));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationHeaderRest &&
          logic.trackingPrefList[i].isSelected) {
        header.add(cHeartRateNormal(
            orientation, logic, context, Constant.configurationHeaderRest));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationHeaderPeck &&
          logic.trackingPrefList[i].isSelected) {
        header.add(cHeartRateNormal(
            orientation, logic, context, Constant.configurationHeaderPeck));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationExperience &&
          logic.trackingPrefList[i].isSelected) {
        header.add(cExperienceNormal(orientation, logic, context));
      }
    }
    return header;
  }

  List<Widget>? rightSideWidget(Orientation orientation,
      HistoryController logic, BuildContext contex) {
    List<Widget> header = [];
    for (int i = 0; i < logic.trackingPrefList.length; i++) {
      if (logic.trackingPrefList[i].titleName ==
          Constant.configurationHeaderModerate &&
          logic.trackingPrefList[i].isSelected) {
        header.add(_widgetActivityMinMod(
            orientation, logic, contex, Constant.configurationHeaderModerate));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationHeaderVigorous &&
          logic.trackingPrefList[i].isSelected) {
        header.add(_widgetActivityMinMod(
            orientation, logic, contex, Constant.configurationHeaderVigorous));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationHeaderTotal &&
          logic.trackingPrefList[i].isSelected) {
        header.add(_widgetActivityMinMod(
            orientation, logic, contex, Constant.configurationHeaderTotal));
      } else
      if (logic.trackingPrefList[i].titleName == Constant.configurationNotes &&
          logic.trackingPrefList[i].isSelected) {
        header.add(_widgetActivityMinMod(
            orientation, logic, contex, Constant.configurationNotes));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationHeaderDays &&
          logic.trackingPrefList[i].isSelected) {
        header.add(_widgetDaysStrengthDataList(orientation, logic, contex));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationHeaderCalories &&
          logic.trackingPrefList[i].isSelected) {
        header.add(_widgetCaloriesDataList(orientation, logic, contex));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationHeaderSteps &&
          logic.trackingPrefList[i].isSelected) {
        header.add(_widgetStepsDataList(orientation, logic, contex));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationHeaderRest &&
          logic.trackingPrefList[i].isSelected) {
        header.add(_widgetHeartRateRestDataList(
            orientation, logic, contex, Constant.configurationHeaderRest));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationHeaderPeck &&
          logic.trackingPrefList[i].isSelected) {
        header.add(_widgetHeartRatePeakDataList(
            orientation, logic, contex, Constant.configurationHeaderPeck));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationExperience &&
          logic.trackingPrefList[i].isSelected) {
        header.add(_widgetExperienceDataList(orientation, logic, contex));
      }
    }
    return header;
  }

  _rightSideWidget(Orientation orientation, HistoryController logic,
      BuildContext contex) {
    return Row(
        key: logic.tableKey,
        children: rightSideWidget(orientation, logic, contex)!
    );
  }

  Widget _widgetActivityMinMod(Orientation orientation, HistoryController logic,
      BuildContext contex,
      String columnType) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(
              color: CColor.black,
            ),
          )
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        mainAxisAlignment:
        MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery
                .of(contex)
                .size
                .width *
                ((columnType == Constant.configurationHeaderModerate) ? Utils
                    .getModRowColumnWidth(contex, logic, isFromHeader: false) :
                (columnType == Constant.configurationHeaderVigorous) ? Utils
                    .getModRowColumnWidth(contex, logic, isFromHeader: false) :
                (columnType == Constant.configurationHeaderTotal)
                    ? Utils.getTotalRowColumnWidth(
                    contex, logic, isFromHeader: false)
                    :
                Utils.getNotesRowColumnWidth(
                    contex, logic, isFromHeader: false)),
            child: ListView.builder(
              itemBuilder: (context,
                  index) {
                return _itemActivityMinWeek(
                    index,
                    context,
                    logic
                        .trackingChartDataList[index],
                    logic, columnType);
              },
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount:
              logic.trackingChartDataList.length,
              physics:
              const NeverScrollableScrollPhysics(),
              scrollDirection: Axis
                  .vertical,
            ),
          ),
        ],
      ),
    );
  }

  Widget _widgetDaysStrengthDataList(Orientation orientation,
      HistoryController logic, BuildContext contex) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(
              color: CColor.black,
            ),
          )
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        mainAxisAlignment:
        MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery
                .of(contex)
                .size
                .width * Utils.getDaysStrengthRowColumnWidth(
                contex, logic, isFromHeader: false),
            alignment: Alignment
                .topCenter,
            child: ListView.builder(
              itemBuilder: (context,
                  index) {
                return _itemDaysStrengthWeek(
                    index,
                    context,
                    logic
                        .daysStrengthDataList[
                    index],
                    logic,
                    Constant.titleDaysStr);
              },
              padding:
              const EdgeInsets.all(0),
              shrinkWrap: true,
              itemCount: logic
                  .daysStrengthDataList
                  .length,
              physics:
              const NeverScrollableScrollPhysics(),
              scrollDirection: Axis
                  .vertical,
            ),
          ),
        ],
      ),
    );
  }

  Widget _widgetCaloriesDataList(Orientation orientation,
      HistoryController logic, BuildContext contex) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(
                color: CColor.black
            ),
          )
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        mainAxisAlignment:
        MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery
                .of(contex)
                .size
                .width * Utils.getCaloriesRowColumnWidth(
                contex, logic, isFromHeader: false),
            alignment: Alignment
                .topCenter,
            child: ListView.builder(
              itemBuilder:
                  (context, index) {
                return _itemCaloriesStepWeek(
                    index,
                    context,
                    logic
                        .caloriesDataList[
                    index],
                    logic,
                    Constant
                        .titleCalories);
              },
              padding:
              const EdgeInsets.all(0),
              shrinkWrap: true,
              itemCount: logic
                  .caloriesDataList
                  .length,
              physics:
              const NeverScrollableScrollPhysics(),
              scrollDirection:
              Axis.vertical,
            ),
          ),

/*        const VerticalDivider(
            color: CColor.black,
            width: 1,
            thickness: 1,
          )*/

        ],
      ),
    );
  }

  Widget _widgetStepsDataList(Orientation orientation, HistoryController logic,
      BuildContext contex) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(
                color: CColor.black
            ),
          )
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        mainAxisAlignment:
        MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery
                .of(contex)
                .size
                .width * Utils.getStepsRowColumnWidth(
                contex, logic, isFromHeader: false),
            alignment: Alignment
                .topCenter,
            child: ListView.builder(
              itemBuilder:
                  (context, index) {
                return _itemCaloriesStepWeek(
                    index,
                    context,
                    logic
                        .stepsDataList[
                    index],
                    logic,
                    Constant
                        .titleSteps);
              },
              padding:
              const EdgeInsets.all(0),
              shrinkWrap: true,
              itemCount: logic
                  .stepsDataList
                  .length,
              physics:
              const NeverScrollableScrollPhysics(),
              scrollDirection:
              Axis.vertical,
            ),
          ),
        ],
      ),
    );
  }

  Widget _widgetHeartRatePeakDataList(Orientation orientation,
      HistoryController logic, BuildContext contex,
      String columnName) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(
                color: CColor.black
            ),
          )
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        mainAxisAlignment:
        MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery
                .of(contex)
                .size
                .width * Utils.getPeakHeartRateRowColumnWidth(
                contex, logic, isFromHeader: false),
            alignment: Alignment
                .topCenter,
            child: ListView.builder(
              itemBuilder:
                  (context, index) {
                return _itemHeartRatePeakWeek(
                    index,
                    context,
                    logic
                        .heartRatePeakDataList[
                    index],
                    logic,
                    Constant
                        .titleHeartRateRest, columnName);
              },
              padding:
              const EdgeInsets.all(0),
              shrinkWrap: true,
              itemCount: logic
                  .heartRatePeakDataList
                  .length,
              physics:
              const NeverScrollableScrollPhysics(),
              scrollDirection:
              Axis.vertical,
            ),
          ),
        ],
      ),
    );
  }

  _itemHeartRatePeakWeek(int mainIndex,
      BuildContext context,
      CaloriesStepHeartRateWeek heartRatePeak,
      HistoryController logic,
      String titleType, String columnName) {
    return Container(
      margin: const EdgeInsets.all(0),
      child: Column(
        children: [
          Container(
              height: Constant.commonHeightForTableBoxMobile,
              padding: EdgeInsets.only(
                right: Sizes.width_1_5,
                left: Sizes.width_1_5,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (logic.trackingPrefList.where((element) =>
                  element.titleName == Constant.configurationHeaderPeck &&
                      element.isSelected)
                      .toList()
                      .isNotEmpty
                      && columnName == Constant.configurationHeaderPeck)
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(
                          bottom: Sizes.height_1,
                        ),
                        child: editablePeakWeek(
                            mainIndex, logic, heartRatePeak,
                            logic.trackingPrefList, context,
                            onChangeData: (value) {}),
                      ),
                    ),
                ],
              )),
          (heartRatePeak.isExpanded)
              ? ListView.builder(
            itemBuilder: (context, daysIndex) {
              return _itemHeartRatePeakDay(
                  daysIndex,
                  context,
                  heartRatePeak.daysList,
                  logic,
                  mainIndex,
                  titleType,
                  columnName);
            },
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: heartRatePeak.daysList.length,
            physics: const NeverScrollableScrollPhysics(),
          )
              : Container(),
          Utils.dividerCustom(),
        ],
      ),
    );
  }

  _itemHeartRatePeakDay(int daysIndex,
      BuildContext context,
      List<CaloriesStepHeartRateDay> heartRatePeak,
      HistoryController logic,
      int mainIndex,
      String titleType, String columnName) {
    return (logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
        .isShow) ?
    Column(
      children: [
        Column(
          children: [
            Utils.dividerCustom(),
            Container(
                height: Constant.commonHeightForTableBoxMobile,
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(
                  right: Sizes.width_1_5,
                  left: Sizes.width_1_5,
                ),
                child: Row(
                  children: [
                    if (logic.trackingPrefList.where((element) =>
                    element.titleName == Constant.configurationHeaderPeck &&
                        element.isSelected)
                        .toList()
                        .isNotEmpty &&
                        columnName == Constant.configurationHeaderPeck)
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                            bottom: Sizes.height_1,
                          ),
                          child: editablePeakDay(
                              mainIndex, logic, heartRatePeak[daysIndex],
                              logic.trackingPrefList, context,
                              onChangeData: (value) {}),
                        ),
                      ),
                  ],
                )
            ),
          ],
        ),
        (heartRatePeak[daysIndex].daysDataList.isNotEmpty &&
            heartRatePeak[daysIndex].isExpanded)
            ? ListView.builder(
          itemBuilder: (context, daysDataIndex) {
            return Container(
                height: Constant.commonHeightForTableBoxMobile,
                margin: EdgeInsets.only(
                  right: Sizes.width_1_5,
                  left: Sizes.width_1_5,
                ),
                padding: EdgeInsets.only(
                  bottom: Sizes.height_1,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (logic.trackingPrefList.where((element) =>
                    element.titleName == Constant.configurationHeaderPeck &&
                        element.isSelected)
                        .toList()
                        .isNotEmpty &&
                        columnName == Constant.configurationHeaderPeck)
                      Expanded(
                        child: editablePeakDayData(
                            mainIndex,
                            daysIndex,
                            daysDataIndex,
                            logic,
                            heartRatePeak[daysIndex]
                                .daysDataList[daysDataIndex], context,
                            onChangeData: (value) {}),
                      ),
                  ],
                )
              // _editableText(),
            );
          },
          shrinkWrap: true,
          itemCount:
          heartRatePeak[daysIndex].daysDataList.length,
          physics: const NeverScrollableScrollPhysics(),
        )
            : Container(
          padding: EdgeInsets.zero,
        ),
      ],
    ) : Container();
  }

  Widget _widgetHeartRateRestDataList(Orientation orientation,
      HistoryController logic, BuildContext contex,
      String columnName) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(
                color: CColor.black
            ),
          )
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        mainAxisAlignment:
        MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery
                .of(contex)
                .size
                .width * Utils.getRestHeartRateRowColumnWidth(
                contex, logic, isFromHeader: false),
            alignment: Alignment
                .topCenter,
            child: ListView.builder(
              itemBuilder:
                  (context, index) {
                return _itemHeartRateRestWeek(
                    index,
                    context,
                    logic
                        .heartRateRestDataList[
                    index],
                    logic,
                    Constant
                        .titleHeartRateRest, columnName);
              },
              padding:
              const EdgeInsets.all(0),
              shrinkWrap: true,
              itemCount: logic
                  .heartRateRestDataList
                  .length,
              physics:
              const NeverScrollableScrollPhysics(),
              scrollDirection:
              Axis.vertical,
            ),
          ),
        ],
      ),
    );
  }

  _itemHeartRateRestWeek(int mainIndex,
      BuildContext context,
      CaloriesStepHeartRateWeek heartRateRest,
      HistoryController logic,
      String titleType, String columnName) {
    return Container(
      margin: const EdgeInsets.all(0),
      child: Column(
        children: [
          Container(
              height: Constant.commonHeightForTableBoxMobile,
              padding: EdgeInsets.only(
                right: Sizes.width_1_5,
                left: Sizes.width_1_5,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                  if (logic.trackingPrefList.where((element) =>
                  element.titleName == Constant.configurationHeaderRest &&
                      element.isSelected)
                      .toList()
                      .isNotEmpty
                      && columnName == Constant.configurationHeaderRest)
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(
                          bottom: Sizes.height_1,
                        ),
                        child: editableRestWeek(
                            mainIndex, logic, heartRateRest,
                            logic.trackingPrefList, context,
                            onChangeData: (value) {}),
                      ),
                    ),

                  SizedBox(
                    width: Sizes.width_2,
                  ),
                ],
              )),
          (heartRateRest.isExpanded)
              ? ListView.builder(
            itemBuilder: (context, daysIndex) {
              return _itemHeartRateRestDay(
                  daysIndex,
                  context,
                  heartRateRest.daysList,
                  logic,
                  mainIndex,
                  titleType,
                  columnName);
            },
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: heartRateRest.daysList.length,
            physics: const NeverScrollableScrollPhysics(),
          )
              : Container(),
          Utils.dividerCustom(),
        ],
      ),
    );
  }

  _itemHeartRateRestDay(int daysIndex,
      BuildContext context,
      List<CaloriesStepHeartRateDay> heartRateRestDataList,
      HistoryController logic,
      int mainIndex,
      String titleType, String columnName) {
    return (logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
        .isShow) ? Column(
      children: [
        Column(
          children: [
            Utils.dividerCustom(),
            Container(
                height: Constant.commonHeightForTableBoxMobile,
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(
                  right: Sizes.width_1_5,
                  left: Sizes.width_1_5,
                ),
                child: Row(
                  children: [
                    if (logic.trackingPrefList.where((element) =>
                    element.titleName == Constant.configurationHeaderRest &&
                        element.isSelected)
                        .toList()
                        .isNotEmpty &&
                        columnName == Constant.configurationHeaderRest)
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                            bottom: Sizes.height_1,
                          ),
                          child: editableRestDay(
                              mainIndex, logic,
                              heartRateRestDataList[daysIndex],
                              logic.trackingPrefList, context,
                              onChangeData: (value) {}),
                        ),
                      ),

                    SizedBox(
                      width: Sizes.width_2,
                    ),
                  ],
                )
            ),
          ],
        ),
        ((heartRateRestDataList[daysIndex].daysDataList.isNotEmpty &&
            heartRateRestDataList[daysIndex].isExpanded))
            ? ListView.builder(
          itemBuilder: (context, daysDataIndex) {
            return Container(
                height: Constant.commonHeightForTableBoxMobile,
                margin: EdgeInsets.only(
                  right: Sizes.width_1_5,
                  left: Sizes.width_1_5,
                ),
                padding: EdgeInsets.only(
                  bottom: Sizes.height_1,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (logic.trackingPrefList.where((element) =>
                    element.titleName == Constant.configurationHeaderRest &&
                        element.isSelected)
                        .toList()
                        .isNotEmpty &&
                        columnName == Constant.configurationHeaderRest)
                      Expanded(
                        child: editableRestDayData(
                            mainIndex,
                            daysIndex,
                            daysDataIndex,
                            logic,
                            heartRateRestDataList[daysIndex]
                                .daysDataList[daysDataIndex], context,
                            onChangeData: (value) {}),
                      ),

                    SizedBox(
                      width: Sizes.width_2,
                    ),
                  ],
                )
              // _editableText(),
            );
          },
          shrinkWrap: true,
          itemCount:
          heartRateRestDataList[daysIndex].daysDataList.length,
          physics: const NeverScrollableScrollPhysics(),
        )
            : Container(
          padding: EdgeInsets.zero,
        ),
      ],
    ) : Container();
  }

  Widget _widgetExperienceDataList(Orientation orientation,
      HistoryController logic, BuildContext contex) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(
                color: CColor.black
            ),
          )
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        mainAxisAlignment:
        MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery
                .of(contex)
                .size
                .width * Utils.getExperienceRowColumnWidth(
                contex, logic, isFromHeader: false),
            alignment: Alignment
                .topCenter,
            child: ListView.builder(
              itemBuilder:
                  (context,
                  mainIndex) {
                return _itemExWeek(
                    mainIndex,
                    // logic.activityMinDataList,
                    logic.experienceDataList,
                    logic,
                    orientation);
              },
              padding:
              const EdgeInsets.all(0),
              shrinkWrap: true,
              itemCount:
              // logic.activityMinDataList.length,
              logic.experienceDataList.length,
              physics:
              const NeverScrollableScrollPhysics(),
              scrollDirection:
              Axis.vertical,
            ),
          ),
        ],
      ),
    );
  }

  Widget leftSideWidget(Orientation orientation, HistoryController logic,
      BuildContext context) {
    return SizedBox(
        width: MediaQuery
            .of(context)
            .size
            .width * ((logic.isPortrait) ? 0.35 : 0.2),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(
                  color: CColor.black
              ),
            ),
            // color: Colors.red
          ),

          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            mainAxisAlignment:
            MainAxisAlignment.start,
            children: [
              Expanded(
                child: SizedBox(
                  // width: Sizes.width_30,
                  width: (orientation ==
                      Orientation.portrait)
                      ? Sizes.width_35
                      : Sizes.width_50,
                  child: ListView.builder(
                    itemBuilder: (context,
                        index) {
                      return _itemWhatWhenWeek(
                          index,
                          context,
                          logic,
                          logic
                              .trackingChartDataList[index],
                          orientation);
                    },
                    shrinkWrap: true,
                    physics:
                    const NeverScrollableScrollPhysics(),
                    itemCount:
                    logic.trackingChartDataList.length,
                    scrollDirection: Axis
                        .vertical,
                  ),
                ),
              ),
              const VerticalDivider(
                color: CColor.black,
                width: 1,
                thickness: 1,
              )
            ],
          ),
        )
    );
  }

  _itemWhatWhenWeek(int mainIndex, BuildContext context,
      HistoryController logic,
      WeekLevelData data, Orientation orientation) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            logic.onExpandWeek(mainIndex);
          },
          child: SizedBox(
            // height: Sizes.height_6,
            height: Constant.commonHeightForTableBoxMobile,
            child: Row(
              children: [
                Icon(
                  (logic.trackingChartDataList[mainIndex].isExpanded)
                      ? Icons.arrow_drop_up_rounded
                      : Icons.arrow_drop_down_rounded,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "${DateFormat(Constant.commonDateFormatMmmDd).format(
                            data.weekStartDate!)}-${DateFormat(
                            Constant.commonDateFormatMmmDd).format(
                            data.weekEndDate!)}",
                        style: TextStyle(
                            fontWeight: (logic.trackingChartDataList[mainIndex]
                                .isExpanded)
                                ? FontWeight.w700
                                : FontWeight.normal),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        (logic.trackingChartDataList[mainIndex].isExpanded)
            ? ListView.builder(
          itemBuilder: (context, index) {
            return _itemWhatWhenDay(index, context, data.dayLevelDataList,
                logic, mainIndex, orientation);
          },
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.dayLevelDataList.length,
          shrinkWrap: true,
        )
            : Container(),
        Utils.dividerCustom(),
      ],
    );
  }

  _itemWhatWhenDay(int daysIndex, BuildContext context,
      List<DayLevelData> weekDaysDataList, HistoryController logic,
      int mainIndex, Orientation orientation) {
    return (logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
        .isShow) ?
    Column(
      children: [
        Container(
          height: Constant.commonHeightForTableBoxMobile,
          padding: EdgeInsets.only(
            right: Sizes.width_1_5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  if (logic.trackingChartDataList[mainIndex]
                      .dayLevelDataList[daysIndex]
                      .activityLevelDataList.isNotEmpty) {
                    logic.onExpandDays(mainIndex, daysIndex);
                  }
                },
                child: Icon(
                  (weekDaysDataList[daysIndex].isExpanded)
                      ? Icons.arrow_drop_up_rounded
                      : Icons.arrow_drop_down_rounded,
                  color: (logic.trackingChartDataList[mainIndex]
                      .dayLevelDataList[daysIndex]
                      .activityLevelDataList.isNotEmpty)
                      ? Colors.black
                      : Colors.transparent,
                ),
              ),
              InkWell(
                onTap: () {
                  // if (logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
                  //     .activityLevelDataList.isNotEmpty) {
                  logic.onExpandDays(mainIndex, daysIndex);
                  // }
                },
                child: Container(
                  padding: EdgeInsets.only(
                    // top: Sizes.height_1,
                      right: Sizes.width_1_5,
                      left: Sizes.width_1),
                  alignment: Alignment.center,
                  child: Text(
                    "${weekDaysDataList[daysIndex].dayName} "
                        "${DateFormat(Constant.commonDateFormatMmDd).format(
                        weekDaysDataList[daysIndex].storedDate!)}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: (weekDaysDataList[daysIndex].isExpanded)
                            ? FontWeight.w700
                            : FontWeight.normal),
                  ),
                ),
              ),
              // if ( logic
              //     .trackingChartDataList[mainIndex]
              //     .dayLevelDataList[daysIndex]
              //     .activityLevelData.isNotEmpty && Constant.isEditMode)


              PopupMenuButton<String>(
                enabled: (Constant.isEditMode),
                itemBuilder: (context) =>

                    logic
                        .trackingChartDataList[mainIndex]
                        .dayLevelDataList[daysIndex]
                        .activityLevelData.map((e) =>
                        PopupMenuItem<String>(
                            value: e.toString(),
                            child: Row(
                              children: [_widgetNumberImage(e,
                                  logic
                                      .trackingChartDataList[mainIndex]
                                      .dayLevelDataList[daysIndex]
                                      .activityLevelDataIcons[
                                  logic
                                      .trackingChartDataList[mainIndex]
                                      .dayLevelDataList[daysIndex]
                                      .activityLevelData.indexWhere((
                                      element) => element == e).toInt()
                                  ].toString()),
                              ],
                            )
                        ),
                    )
                        .toList(),
                offset: Offset(-Sizes.width_9, 0),
                color: Colors.grey[60],
                elevation: 2,
                onSelected: (value) {
                  // logic.addDaysDataWeekWise(
                  //     mainIndex, daysIndex, value);
                  var selectedDayDate = logic
                      .trackingChartDataList[mainIndex]
                      .dayLevelDataList[daysIndex]
                      .storedDate ??
                      DateTime.now();
                  var nowDate = DateTime.now();
                  var date = DateTime(
                      selectedDayDate.year,
                      selectedDayDate.month,
                      selectedDayDate.day,
                      nowDate.hour,
                      nowDate.minute);
                  logic.onChangeActivityDateLocal(
                      startDate: date, endDate: date, reset: false);
                  selectDateWithActivityChoose(
                      context,
                      value,
                      logic.trackingChartDataList[mainIndex]
                          .dayLevelDataList,
                      mainIndex,
                      daysIndex,
                      logic, (activityStartDate) {
                    logic.onChangeActivityDateLocal(
                        startDate: activityStartDate, reset: false);
                  }, (activityEndDate) {
                    logic.onChangeActivityDateLocal(
                        endDate: activityEndDate, reset: false);
                  },
                      logic.localStartDate ?? DateTime.now(),
                      logic.localEndDate ?? DateTime.now());
                },
                child: Container(
                    padding: EdgeInsets.only(
                      // top: Sizes.height_2_1_5,
                        right: Sizes.width_1_5,
                        left: Sizes.width_1_5),
                    child: Text("+", style: TextStyle(
                        fontSize: FontSize.size_13
                    ),)),
              )
              /*   else
                      Container(
                        padding: EdgeInsets.only(
                            // top: Sizes.height_2_1_5,
                            right: Sizes.width_2,
                            left: Sizes.width_1_5),
                        child: Text(
                          "+",
                          style: TextStyle(fontSize: FontSize.size_1,color: CColor.white),
                        ),
                      ),*/
            ],
          ),
        ),
        Utils.dividerCustom(color: CColor.transparent),
        (weekDaysDataList[daysIndex].activityLevelDataList.isNotEmpty &&
            weekDaysDataList[daysIndex].isExpanded)
            ? ListView.builder(
          itemBuilder: (context, daysDataIndex) {
            return SizedBox(
              height: Constant.commonHeightForTableBoxMobile,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  /*InkWell(
                    onTap: () {
                      if (Constant.isEditMode &&
                          !weekDaysDataList[daysIndex]
                              .activityLevelDataList[daysDataIndex]
                              .isFromAppleHealth) {
                        logic.removeDaysDataIndexWise(
                            mainIndex, daysIndex, daysDataIndex);
                      }

                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      // color: CColor.primaryColor,
                      child: Icon(
                        Icons.close,
                        color: (Constant.isEditMode &&
                            !weekDaysDataList[daysIndex]
                                .activityLevelDataList[daysDataIndex]
                                .isFromAppleHealth) ? CColor.red : Colors
                            .transparent,
                        size: Sizes.width_4,
                      ),
                    ),
                  ),*/
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: Sizes.width_3),
                      child: Row(
                        children: [
                          Image.asset(

                            weekDaysDataList[daysIndex]
                                .activityLevelDataList[daysDataIndex]
                                .iconPath
                                .toString(),
                            height: Sizes.width_5,
                            width: Sizes.width_5,
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: Sizes.width_0_5),
                              child: Text(
                                weekDaysDataList[daysIndex]
                                    .activityLevelDataList[daysDataIndex]
                                    .displayLabel.toString(),
                                style: AppFontStyle.styleW400(
                                    CColor.black, FontSize.size_8),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      var startDate = weekDaysDataList[daysIndex]
                          .activityLevelDataList[daysDataIndex]
                          .activityStartDate;
                      var endDate = weekDaysDataList[daysIndex]
                          .activityLevelDataList[daysDataIndex]
                          .activityEndDate;
                      var displayName = weekDaysDataList[daysIndex]
                          .activityLevelDataList[daysDataIndex]
                          .displayLabel
                          .toString();

                      logic.onChangeActivityTimeLast(startDate, endDate);

                      selectFromAndToDate(
                          context,
                          startDate,
                          endDate,
                          displayName,
                          weekDaysDataList,
                          mainIndex,
                          daysIndex,
                          daysDataIndex,
                          logic,
                              (activityStartDate) async {
                            weekDaysDataList[daysIndex]
                                .activityLevelDataList[daysDataIndex]
                                .activityStartDate =
                                activityStartDate;

                            var totalMin = weekDaysDataList[daysIndex]
                                .activityLevelDataList[daysDataIndex]
                                .totalMinValue;
                            var addedMin = 1;
                            if (totalMin != null) {
                              addedMin = totalMin;
                            }
                            var endDateTIme = weekDaysDataList[daysIndex]
                                .activityLevelDataList[daysDataIndex]
                                .activityStartDate.add(
                                Duration(minutes: addedMin));
                            weekDaysDataList[daysIndex]
                                .activityLevelDataList[daysDataIndex]
                                .activityEndDate = endDateTIme;
                            logic.update();
                            Debug.printLog(
                                "activityStartDate...$activityStartDate");
                          },
                              (activityEndDate) async {
                            weekDaysDataList[daysIndex]
                                .activityLevelDataList[daysDataIndex]
                                .activityEndDate = activityEndDate;
                            logic.update();
                            Debug.printLog(
                                "activityEndDate...$activityEndDate");
                          });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: Sizes.width_1),
                      child: Icon(
                        Icons.watch_later_outlined,
                        size: Sizes.width_5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          padding: EdgeInsets.only(
              left: MediaQuery
                  .of(context)
                  .size
                  .width * 0.01),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: weekDaysDataList[daysIndex].activityLevelDataList.length,
          shrinkWrap: true,
        )
            : Container()
      ],
    ) : Container();
  }

  Future<void> selectDateWithActivityChoose(BuildContext context,
      String activityName, List<DayLevelData> weekDaysDataList,
      int mainIndex, int daysIndex, HistoryController logic,
      Function callBackStartDate, Function callBackEndDate,
      DateTime activityStartDate, DateTime activityEndDate) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: Wrap(
                children: [
                  AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              top: Sizes.height_2, left: Sizes.width_4),
                          child: Text(
                            activityName,
                            style: TextStyle(
                              fontSize: FontSize.size_14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: Sizes.height_2,
                              horizontal: Sizes.width_4),
                          child: Row(
                            children: [
                              const Text('Starts'),
                              // const Spacer(),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    selectDateTimeWithActivityChoose(
                                        context,
                                        false,
                                        activityStartDate,
                                        activityEndDate, (dateTime) {
                                      setState(() {
                                        activityStartDate = dateTime;
                                        callBackStartDate
                                            .call(activityStartDate);
                                      });
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: Sizes.width_2),
                                    decoration: BoxDecoration(
                                        color: CColor.greyF8,
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      DateFormat.yMMMd().add_jm().format(
                                          activityStartDate),
                                      style: TextStyle(
                                          fontSize: FontSize.size_12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        /*Container(
                          margin: EdgeInsets.only(bottom: Sizes.height_2,left: Sizes.width_4,right: Sizes.width_4),
                          child: Row(
                            children: [
                              const Text('Ends  '),
                              // const Spacer(),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    selectDateTimeWithActivityChoose(context, true,activityStartDate, activityEndDate,(dateTime){
                                      setState((){
                                        activityEndDate = dateTime;
                                        callBackEndDate.call(activityEndDate);
                                      });
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: Sizes.width_2),
                                    decoration: BoxDecoration(
                                        color: CColor.greyF8,
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      DateFormat.yMMMd().add_jm().format(activityEndDate),
                                      style: TextStyle(fontSize: FontSize.size_12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),*/
                        Container(
                          margin: EdgeInsets.only(
                              bottom: Sizes.height_2, right: Sizes.width_4),
                          child: Row(
                            children: [
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: Sizes.width_3),
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {

                                  /* var getTotalMinFromTwoDates = Utils.getTotalMinFromTwoDates(
                                      activityStartDate,activityEndaDate);

                                  await logic.updateTotalMinAtActivityLevel(
                                      DateFormat(Constant.commonDateFormatDdMmYyyy)
                                          .format(weekDaysDataList[daysIndex]
                                          .activityLevelDataList[daysDataIndex].storedDate!)
                                      ,activityName,activityStartDate,activityEndaDate,
                                      getTotalMinFromTwoDates,mainIndex,daysIndex,daysDataIndex);

                                  logic.update();

                                  logic.updateDeleteActivityWhenChangeTime(weekDaysDataList,mainIndex,daysIndex,daysDataIndex );*/
                                  // if(activityStartDate.minute == activityEndDate.minute){
                                  activityEndDate = activityStartDate.add(
                                      const Duration(minutes: 1));
                                  // }
                                  var getTotalMinFromTwoDates =
                                  Utils.getTotalMinFromTwoDates(
                                      activityStartDate, activityEndDate);

                                  // int index =  logic.trackingChartDataList[mainIndex]
                                  //     .dayLevelDataList[daysIndex]
                                  //     .activityLevelData.indexWhere((element) => element == activityName).toInt();
                                  // logic.trackingChartDataList[mainIndex]
                                  //     .dayLevelDataList[daysIndex]
                                  //     .activityLevelDataList[index].activityEndDate =  logic.trackingChartDataList[mainIndex].
                                  // dayLevelDataList[daysIndex].activityLevelDataList[index].activityStartDate.add(Duration(minutes: 1));

                                  /*if(getTotalMinFromTwoDates == "1") {

                                    if ( logic.trackingChartDataList[mainIndex].
                                    dayLevelDataList[daysIndex]
                                        .activityLevelDataList[index].modMinValue != 0 && logic.trackingChartDataList[mainIndex].
                                    dayLevelDataList[daysIndex]
                                        .activityLevelDataList[index].modMinValue != "0.0" && logic.trackingChartDataList[mainIndex].
                                    dayLevelDataList[daysIndex]
                                        .activityLevelDataList[index].modMinValue != null ||
                                        logic.trackingChartDataList[mainIndex].
                                        dayLevelDataList[daysIndex]
                                            .activityLevelDataList[index].vigMinValue != 0 && logic.trackingChartDataList[mainIndex].
                                        dayLevelDataList[daysIndex]
                                            .activityLevelDataList[index].vigMinValue != "0.0" && logic.trackingChartDataList[mainIndex].
                                        dayLevelDataList[daysIndex]
                                            .activityLevelDataList[index].vigMinValue != null) {
                                      int  totalMin = logic.trackingChartDataList[mainIndex].
                                      dayLevelDataList[daysIndex]
                                          .activityLevelDataList[index].modMinValue!  + logic.trackingChartDataList[mainIndex].
                                      dayLevelDataList[daysIndex]
                                          .activityLevelDataList[index].vigMinValue!;
                                      int intValue = totalMin.toInt();
                                      getTotalMinFromTwoDates = "${intValue.toString()}";
                                      logic.trackingChartDataList[mainIndex].

                                      Debug.printLog("getTotalMinFromTwoDates...........${getTotalMinFromTwoDates.toString()}");
                                    }
                                  }*/
                                  if (int.parse(getTotalMinFromTwoDates) >= 0) {
                                    await logic
                                        .addDaysDataSelectedActivityDateWise(
                                        mainIndex,
                                        daysIndex,
                                        activityName,
                                        activityStartDate,
                                        activityEndDate);
                                    await logic.onChangeActivityDateLocal(
                                        reset: true);
                                  } else {
                                    Utils.showToast(context, "Invalid dates");
                                  }
                                },
                                child: const Text(
                                  "Select",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
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
            );
          },
        );
      },
    );
  }

  Future<void> selectDateTimeWithActivityChoose(BuildContext context,
      bool isEndDate, DateTime fromDate, DateTime toDate,
      Function callBack) async {
    var tempDate = DateTime.now();
    tempDate = (isEndDate) ? toDate : fromDate;
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
                            initialDateTime: (isEndDate) ? toDate : fromDate,
                            backgroundColor: CColor.white,
                            onDateTimeChanged: (DateTime dateTime) async {
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
                                margin: EdgeInsets.only(left: Sizes.width_5,
                                    right: Sizes.width_10,
                                    bottom: Sizes.height_2),
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

  Future<void> selectFromAndToDate(BuildContext context, DateTime startDate,
      DateTime endDate,
      String activityName, List<DayLevelData> weekDaysDataList,
      int mainIndex, int daysIndex, int daysDataIndex, HistoryController logic,
      Function callBackStartDate, Function callBackEndDate) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: Wrap(
                children: [
                  AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    // title: Text(activityName),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              top: Sizes.height_2, left: Sizes.width_4),
                          child: Text(
                            activityName,
                            style: TextStyle(
                              fontSize: FontSize.size_14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: Sizes.height_2,
                              horizontal: Sizes.width_4),
                          child: Row(
                            children: [
                              const Text('Starts'),
                              // const Spacer(),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (!weekDaysDataList[daysIndex]
                                        .activityLevelDataList[daysDataIndex]
                                        .isFromAppleHealth) {
                                      selectDateTime(
                                          context, false, startDate, endDate, (
                                          dateTime) {
                                        setState(() {
                                          startDate = dateTime;
                                          callBackStartDate.call(startDate);
                                        });
                                      });
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: Sizes.width_2),
                                    decoration: BoxDecoration(
                                        color: CColor.greyF8,
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      // DateFormat(Constant.commonDateFormatFullDate).format(startDate),
                                      DateFormat.yMMMd().add_jm().format(
                                          startDate),
                                      style: TextStyle(
                                          fontSize: FontSize.size_12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        /*Container(
                          margin: EdgeInsets.only(bottom: Sizes.height_2,left: Sizes.width_4,right: Sizes.width_4),
                          child: Row(
                            children: [
                              const Text('Ends  '),
                              // const Spacer(),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    selectDateTime(context, true,startDate, endDate,(dateTime){
                                      setState((){
                                        endDate = dateTime;
                                        callBackEndDate.call(endDate);
                                      });
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: Sizes.width_2),
                                    decoration: BoxDecoration(
                                        color: CColor.greyF8,
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      DateFormat.yMMMd().add_jm().format(endDate),
                                      style: TextStyle(fontSize: FontSize.size_12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),*/
                        Container(
                          margin: EdgeInsets.only(
                              bottom: Sizes.height_2, right: Sizes.width_4),
                          child: Row(
                            children: [
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  if (!weekDaysDataList[daysIndex]
                                      .activityLevelDataList[daysDataIndex]
                                      .isFromAppleHealth) {
                                    logic.resetLastDate(
                                        weekDaysDataList, daysIndex,
                                        daysDataIndex, startDate
                                        , endDate);
                                  } else {
                                    Get.back();
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: Sizes.width_3),
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              if(!weekDaysDataList[daysIndex]
                                  .activityLevelDataList[daysDataIndex]
                                  .isFromAppleHealth)GestureDetector(
                                onTap: () async {
                                  /* var activityEndaDate = weekDaysDataList[daysIndex]
                                      .activityLevelDataList[daysDataIndex]
                                      .activityEndDate;*/

                                  var activityStartDate = weekDaysDataList[daysIndex]
                                      .activityLevelDataList[daysDataIndex]
                                      .activityStartDate;

                                  var activityEndaDate = activityStartDate.add(
                                      Duration(
                                          minutes: weekDaysDataList[daysIndex]
                                              .activityLevelDataList[daysDataIndex]
                                              .totalMinValue ?? 1));

                                  Debug.printLog(
                                      "Total min from start date.....${weekDaysDataList[daysIndex]
                                          .activityLevelDataList[daysDataIndex]
                                          .totalMinValue ??
                                          1}  $activityEndaDate  $activityStartDate");

                                  // var activityEndaDateLast = weekDaysDataList[daysIndex]
                                  //     .activityLevelDataList[daysDataIndex]
                                  //     .activityEndDateLast;
                                  //
                                  // var activityStartDateLast = weekDaysDataList[daysIndex]
                                  //     .activityLevelDataList[daysDataIndex]
                                  //     .activityStartDateLast;

                                  var getTotalMinFromTwoDates = Utils
                                      .getTotalMinFromTwoDates(
                                      activityStartDate, activityEndaDate);
                                  if (int.parse(getTotalMinFromTwoDates) >= 0) {
                                    var listOfLastData = weekDaysDataList[daysIndex]
                                        .activityLevelDataList;

                                    /*var dataIsInWithoutAnotherData = listOfLastData.where((element) =>
                                        Utils.isBetween(element.activityStartDate, element.activityEndDate,
                                            activityStartDate, activityEndaDate)
                                    ).toList().isEmpty;*/

                                    var dataIsInWithoutAnotherData = Utils
                                        .checkDateOverlap(listOfLastData,
                                        activityStartDate, activityEndaDate,
                                        currentActivityData: weekDaysDataList[daysIndex]
                                            .activityLevelDataList[daysDataIndex]);

                                    if (dataIsInWithoutAnotherData) {
                                      Utils.showToast(Get.context!,
                                          "You have to select unique date");
                                    } else {
                                      Get.back();
                                      await logic.updateTotalMinAtActivityLevel(
                                          DateFormat(
                                              Constant.commonDateFormatDdMmYyyy)
                                              .format(
                                              weekDaysDataList[daysIndex]
                                                  .activityLevelDataList[daysDataIndex]
                                                  .storedDate!)
                                          ,
                                          activityName,
                                          activityStartDate,
                                          activityEndaDate,
                                          getTotalMinFromTwoDates,
                                          mainIndex,
                                          daysIndex,
                                          daysDataIndex,
                                          true);
                                      logic.update();
                                      logic.updateDeleteActivityWhenChangeTime(
                                          weekDaysDataList,
                                          mainIndex,
                                          daysIndex,
                                          daysDataIndex,
                                          true,
                                          activityStartDate,
                                          activityEndaDate);
                                    }
                                  } else {
                                    Utils.showToast(context, "Invalid dates");
                                  }
                                },
                                child: const Text(
                                  "Select",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
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
            );
          },
        );
      },
    );
  }

  Widget _widgetNumberImage(String type, String iconName) {
    return Row(
      children: [
        Image.asset(
          // Utils.getNumberIconNameFromType(type),
          iconName,
          height: Sizes.width_5,
          width: Sizes.width_5,
        ),
        Container(
          margin: EdgeInsets.only(left: Sizes.width_0_5),
          child: Text(
            type,
            style: AppFontStyle.styleW400(CColor.black, FontSize.size_8),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Future<void> selectDateTime(BuildContext context, bool isEndDate,
      DateTime fromDate, DateTime toDate,
      Function callBack) async {
    var tempDate = DateTime.now();
    tempDate = (isEndDate) ? toDate : fromDate;
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
                            initialDateTime: (isEndDate) ? toDate : fromDate,
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
                                margin: EdgeInsets.only(left: Sizes.width_5,
                                    right: Sizes.width_10,
                                    bottom: Sizes.height_2),
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

  _itemActivityMinWeek(int mainIndex, BuildContext context,
      WeekLevelData dataList,
      HistoryController logic, String columnType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          height: Constant.commonHeightForTableBoxMobile,
          padding: EdgeInsets.only(
            right: Sizes.width_1_5,
            left: Sizes.width_1_5,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              (logic.trackingPrefList.where((element) =>
              element.titleName == Constant.configurationHeaderModerate
                  && element.isSelected)
                  .toList()
                  .isNotEmpty &&
                  columnType == Constant.configurationHeaderModerate) ?
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                      bottom: Sizes.height_1
                  ),
                  child: editableMod(onChangeData: (value) {}, mainIndex, logic,
                      Constant.activityMinutesMod, logic.trackingPrefList),
                ),
              ) : Container(),


              const Text("  "),
              (logic.trackingPrefList.where((element) =>
              element.titleName == Constant.configurationHeaderVigorous
                  && element.isSelected)
                  .toList()
                  .isNotEmpty
                  && columnType == Constant.configurationHeaderVigorous) ?
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                      bottom: Sizes.height_1
                  ),
                  child: editableVig(onChangeData: (value) {}, mainIndex, logic,
                      Constant.activityMinutesVig, logic.trackingPrefList),
                ),
              ) : Container(),


              const Text("  "),
              if(logic.trackingPrefList.where((element) =>
              element.titleName == Constant.configurationHeaderTotal
                  && element.isSelected)
                  .toList()
                  .isNotEmpty
                  && columnType == Constant.configurationHeaderTotal)
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                        bottom: Sizes.height_1
                    ),
                    child: editableActivityMinutes(
                        onChangeData: (value) {}, mainIndex, logic,
                        Constant.activityMinutesTotal, logic.trackingPrefList),
                  ),
                ),


              if (logic.trackingPrefList.where((element) =>
              element.titleName == Constant.configurationNotes &&
                  element.isSelected)
                  .toList()
                  .isNotEmpty
                  && columnType == Constant.configurationNotes)
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (Constant.isEditMode && Constant.configurationInfo
                          .where((element) => element.isNotes)
                          .toList()
                          .isNotEmpty) {
                        logic.setNotesOnController(
                            logic.trackingChartDataList[mainIndex].weeklyNotes);
                        bottomAddNotesView(
                            context, logic, Constant.typeWeek, mainIndex, -1,
                            -1);
                      }
                    },
                    child: Container(
                        alignment: Alignment.center,
                        child: (logic.trackingChartDataList[mainIndex]
                            .weeklyNotes.isNotEmpty) ? Image.asset(
                          "assets/icons/ic_comment.png",
                          height: Sizes.width_4,
                          width: Sizes.width_4,
                          // color: Colors.grey,
                        ) : Image.asset("assets/icons/ic_notecomment.png",
                          height: Sizes.width_4,
                          width: Sizes.width_4,
                          color: (Constant.isEditMode &&
                              Constant.configurationInfo
                                  .where((element) => element.isNotes)
                                  .toList()
                                  .isNotEmpty) ? CColor.black : CColor.gray,
                        )),
                  ),
                ),
            ],
          ),
        ),
        Container(
          child: (logic.trackingChartDataList[mainIndex].isExpanded)
              ? ListView.builder(
            itemBuilder: (context, index) {
              return _itemActivityMinDay(index, context,
                  dataList.dayLevelDataList, logic, mainIndex, columnType);
            },
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
            itemCount: dataList.dayLevelDataList.length,
            physics: const NeverScrollableScrollPhysics(),
          )
              : Container(),
        ),
        Utils.dividerCustom(),
      ],
    );
  }

  _itemActivityMinDay(int daysIndex, BuildContext context,
      List<DayLevelData> weekDaysDataList, HistoryController logic,
      int mainIndex, String columnType) {
    return (logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
        .isShow) ?
    Column(
      children: [
        Column(
          children: [
            Container(
              child: Utils.dividerCustom(),
            ),
            Container(
              height: Constant.commonHeightForTableBoxMobile,
              padding: EdgeInsets.only(
                right: Sizes.width_1_5,
                left: Sizes.width_1_5,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  (logic.trackingPrefList.where((element) =>
                  element.titleName == Constant.configurationHeaderModerate
                      && element.isSelected)
                      .toList()
                      .isNotEmpty &&
                      columnType == Constant.configurationHeaderModerate) ?
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                          bottom: Sizes.height_1
                      ),
                      child: editableActivityMinModDay(
                          onChangeData: (value) {}, mainIndex, daysIndex, logic,
                          Constant.activityMinutesMod, logic.trackingPrefList,
                          context),
                    ),
                  ) : Container(),
                  const Text("  "),

                  (logic.trackingPrefList.where((element) =>
                  element.titleName == Constant.configurationHeaderVigorous
                      && element.isSelected)
                      .toList()
                      .isNotEmpty
                      && columnType == Constant.configurationHeaderVigorous) ?
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                          bottom: Sizes.height_1
                      ),
                      child: editableActivityMinVigDay(
                          onChangeData: (value) {}, mainIndex, daysIndex, logic,
                          Constant.activityMinutesVig, logic.trackingPrefList,
                          context),
                    ),
                  ) : Container(),
                  const Text("  "),

                  if(logic.trackingPrefList.where((element) =>
                  element.titleName == Constant.configurationHeaderTotal
                      && element.isSelected)
                      .toList()
                      .isNotEmpty
                      && columnType == Constant.configurationHeaderTotal)
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(
                            bottom: Sizes.height_1
                        ),
                        child: editableActivityMiTotalDays(
                            onChangeData: (value) {}, mainIndex, daysIndex,
                            logic, Constant.activityMinutesTotal,
                            logic.trackingPrefList, context),
                      ),
                    ),

                  if (logic.trackingPrefList.where((element) =>
                  element.titleName == Constant.configurationNotes &&
                      element.isSelected)
                      .toList()
                      .isNotEmpty
                      && columnType == Constant.configurationNotes)
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (Constant.isEditMode && Constant.configurationInfo
                              .where((element) => element.isNotes)
                              .toList()
                              .isNotEmpty) {
                            logic.setNotesOnController(logic
                                .trackingChartDataList[mainIndex]
                                .dayLevelDataList[daysIndex].dailyNotes);
                            bottomAddNotesView(context, logic, Constant.typeDay,
                                mainIndex, daysIndex, -1);
                          }
                        },
                        child: Container(
                            alignment: Alignment.center,
                            child:
                            (logic.trackingChartDataList[mainIndex]
                                .dayLevelDataList[daysIndex].dailyNotes
                                .isNotEmpty) ? Image.asset(
                              "assets/icons/ic_comment.png",
                              height: Sizes.width_4,
                              width: Sizes.width_4,
                              // color: Colors.grey,
                            ) : Image.asset(
                              "assets/icons/ic_notecomment.png", height: Sizes
                                .width_4,
                              width: Sizes.width_4,
                              color: (Constant.isEditMode &&
                                  Constant.configurationInfo
                                      .where((element) =>
                                  element.isNotes)
                                      .toList()
                                      .isNotEmpty)
                                  ? CColor.black
                                  : CColor.gray,
                            )),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        (weekDaysDataList[daysIndex].activityLevelDataList.isNotEmpty &&
            weekDaysDataList[daysIndex].isExpanded)
            ? ListView.builder(
          itemBuilder: (context, daysDataIndex) {
            return Container(
              // height: Sizes.height_7,
              height: Constant.commonHeightForTableBoxMobile,
              padding: EdgeInsets.only(
                right: Sizes.width_1_5,
                left: Sizes.width_1_5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if(logic.trackingPrefList.where((element) =>
                  element.titleName == Constant.configurationHeaderModerate
                      && element.isSelected)
                      .toList()
                      .isNotEmpty
                      && columnType == Constant.configurationHeaderModerate)
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(
                          bottom: Sizes.height_1,
                        ),
                        child: editableActivityMinModDayData(
                            onChangeData: (value) {}, mainIndex, daysIndex,
                            daysDataIndex, logic, context),
                      ),
                    ),
                  const Text("  "),

                  if(logic.trackingPrefList.where((element) =>
                  element.titleName == Constant.configurationHeaderVigorous
                      && element.isSelected)
                      .toList()
                      .isNotEmpty
                      && columnType == Constant.configurationHeaderVigorous)
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(
                          bottom: Sizes.height_1,
                        ),
                        child: editableActivityMinVigDayData(
                            onChangeData: (value) {}, mainIndex, daysIndex,
                            daysDataIndex, logic, context),
                      ),
                    ),
                  const Text("  "),

                  if(logic.trackingPrefList.where((element) =>
                  element.titleName == Constant.configurationHeaderTotal
                      && element.isSelected)
                      .toList()
                      .isNotEmpty
                      && columnType == Constant.configurationHeaderTotal)
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(
                          bottom: Sizes.height_1,
                        ),
                        child: editableActivityMinTotalDaysData(
                            onChangeData: (value) {}, mainIndex, daysIndex,
                            daysDataIndex, logic, context),
                      ),
                    ),

                  if (logic.trackingPrefList.where((element) =>
                  element.titleName == Constant.configurationNotes &&
                      element.isSelected)
                      .toList()
                      .isNotEmpty
                      && columnType == Constant.configurationNotes)
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (Constant.isEditMode &&
                              Constant.configurationInfo.where((element) =>
                              element.title ==
                                  logic.trackingChartDataList[mainIndex]
                                      .dayLevelDataList[daysIndex]
                                      .activityLevelDataList[daysDataIndex]
                                      .displayLabel &&
                                  element.isNotes)
                                  .toList()
                                  .isNotEmpty) {
                            logic.setNotesOnController(
                                logic.trackingChartDataList[mainIndex]
                                    .dayLevelDataList[daysIndex]
                                    .activityLevelDataList[daysDataIndex]
                                    .dayDataNotes);
                            bottomAddNotesView(
                                context, logic, Constant.typeDaysData,
                                mainIndex, daysIndex, daysDataIndex);
                          }
                        },
                        child: Container(
                            alignment: Alignment.center,
                            child:
                            (logic.trackingChartDataList[mainIndex]
                                .dayLevelDataList[daysIndex]
                                .activityLevelDataList[daysDataIndex]
                                .dayDataNotes.isNotEmpty) ? Image.asset(
                              "assets/icons/ic_comment.png",
                              height: Sizes.width_4,
                              width: Sizes.width_4,
                              // color: Colors.grey,
                            ) : Image.asset("assets/icons/ic_notecomment.png",
                              height: Sizes.width_4,
                              width: Sizes.width_4,
                              color: (Constant.isEditMode &&
                                  Constant.configurationInfo.where((element) =>
                                  element.title ==
                                      logic.trackingChartDataList[mainIndex]
                                          .dayLevelDataList[daysIndex]
                                          .activityLevelDataList[daysDataIndex]
                                          .displayLabel &&
                                      element.isNotes)
                                      .toList()
                                      .isNotEmpty) ? CColor.black : CColor
                                  .gray,)
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
          shrinkWrap: true,
          padding: const EdgeInsets.all(0),
          itemCount: weekDaysDataList[daysIndex].activityLevelDataList.length,
          physics: const NeverScrollableScrollPhysics(),
        )
            : Container(
          padding: EdgeInsets.zero,
        ),
      ],
    ) : Container();
  }

  _itemCaloriesStepWeek(int mainIndex, BuildContext context,
      CaloriesStepHeartRateWeek dataList, HistoryController logic,
      String titleType) {
    return Container(
      margin: const EdgeInsets.all(0),
      child: Column(
        children: [
          Container(
            // height: Sizes.height_6,
              height: Constant.commonHeightForTableBoxMobile,
              padding: EdgeInsets.only(
                right: Sizes.width_1_5,
                left: Sizes.width_1_5,
              ),
              child: Container(
                padding: EdgeInsets.only(
                  bottom: Sizes.height_1,
                ),
                // child: _editableTextTitleAndOtherWeek(mainIndex, logic, dataList,
                child: editableCalStepWeek(
                  mainIndex, logic, titleType, dataList, logic.trackingPrefList,
                  context,
                  onChangeData: (value) {
                    logic.onChangeCalStepWeeks(
                        mainIndex, value, dataList.titleName);
                  },
                ),
              )
            // _editableText(),
          ),
          (dataList.isExpanded)
              ? ListView.builder(
            itemBuilder: (context, daysIndex) {
              return _itemCalStepDays(daysIndex, context,
                  dataList.daysList, logic, mainIndex, titleType);
            },
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: dataList.daysList.length,
            physics: const NeverScrollableScrollPhysics(),
          )
              : Container(),
          Utils.dividerCustom(),
        ],
      ),
    );
  }

  _itemCalStepDays(int daysIndex,
      BuildContext context,
      List<CaloriesStepHeartRateDay> weekDaysDataList,
      HistoryController logic,
      int mainIndex,
      String titleType) {
    return (logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
        .isShow) ?
    Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Utils.dividerCustom(),
            Container(
              // height: Sizes.height_7,
                height: Constant.commonHeightForTableBoxMobile,
                padding: EdgeInsets.only(
                  right: Sizes.width_1_5,
                  left: Sizes.width_1_5,

                ),
                alignment: Alignment.bottomCenter,

                child: Container(
                  padding: EdgeInsets.only(
                    bottom: Sizes.height_1,
                  ),
                  child: editableCalStepDay(
                      daysIndex,
                      logic,
                      weekDaysDataList[daysIndex],
                      onChangeData: (value) {},
                      mainIndex,
                      titleType,
                      logic.trackingPrefList,
                      context),
                )
            ),
          ],
        ),
        // (weekDaysDataList[daysIndex].daysDataList.isNotEmpty &&
        (weekDaysDataList[daysIndex].daysDataList.isNotEmpty &&
            weekDaysDataList[daysIndex].isExpanded)
            ? ListView.builder(
          itemBuilder: (context, daysDataIndex) {
            return Container(
              height: Constant.commonHeightForTableBoxMobile,
              margin:
              EdgeInsets.symmetric(horizontal: Sizes.width_1_5),
              padding: EdgeInsets.only(
                bottom: Sizes.height_1,
              ),
              // child: _editableTextTitle2AndOtherDaysData(
              child: (titleType == Constant.titleCalories)
                  ? editableActivityCalories(
                  daysDataIndex,
                  logic,
                  mainIndex,
                  daysIndex,
                  titleType,
                  weekDaysDataList[daysIndex]
                      .daysDataList[daysDataIndex],
                  context,
                  onChangeData: (value) {}
              )
                  : editableActivitySteps(
                  daysDataIndex,
                  logic,
                  mainIndex,
                  daysIndex,
                  titleType,
                  weekDaysDataList[daysIndex]
                      .daysDataList[daysDataIndex],
                  context,
                  onChangeData: (value) {}
              ),
            );
          },
          shrinkWrap: true,
          itemCount: weekDaysDataList[daysIndex].daysDataList.length,
          physics: const NeverScrollableScrollPhysics(),
        )
            : Container(
          padding: EdgeInsets.zero,
        ),
      ],
    ) : Container();
  }

  _widgetToggleFilter(BuildContext context, HistoryController logic,
      Orientation orientation) {
    return Container(
      padding: EdgeInsets.only(
        bottom: Sizes.height_1,
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          // InkWell(
          //   onTap: (){
          //     openPopupBox(logic,context);
          //   },
          //   child: Container(
          //     alignment: Alignment.center,
          //     padding: const EdgeInsets.all(8),
          //     decoration: BoxDecoration(
          //         border: Border.all(color: CColor.black, width: 1),
          //         borderRadius: BorderRadius.circular(7)),
          //     child: const Icon(
          //       Icons.arrow_drop_down_rounded,
          //       color: CColor.black,
          //     ),
          //   ),
          // ),
          _widgetToggle(context, logic),
          const Spacer(),
          if(Utils.getServerListPreference().isNotEmpty)_widgetRefresh(context, logic),
          _widgetDatePicker(context, logic, orientation),
          _widgetFilter(context, logic, orientation)
        ],
      ),
    );
  }

  _widgetRefresh(BuildContext context, HistoryController logic) {
    return InkWell(
      onTap: () {
        logic.onRefresh();
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          right: Sizes.width_2,
          top: Sizes.height_2,
        ),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          // border: Border.all(color: CColor.black, width: 1),
            borderRadius: BorderRadius.circular(7)),
        child: const Icon(
          Icons.refresh,
          color: CColor.black,
        ),
      ),
    );
  }

  _widgetToggle(BuildContext context,HistoryController logic, {bool isLandscape = false}) {
    return Container(
      margin: EdgeInsets.only(
        left: Sizes.width_5,
        top: (isLandscape)?0:Sizes.height_2,
      ),
      child:  StatefulBuilder(
        builder: (BuildContext context,StateSetter stateSetter) {
          stateSetter((){});
          return Container(
            alignment: Alignment.center,
            child: PopupMenuButton<int>(
              enabled: Constant.isEditMode,
              key: logic.popupMenuKey,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: [
                      Text((logic.isWeekExpanded)?"Week Collapse":"Week Expand"),
                      if (logic.isWeekExpanded)
                        Container(
                            margin: EdgeInsets.only(left: Sizes.width_2),
                            child: const Icon(Icons.check))
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: [
                      Text((logic.isDayExpanded)?"Day Collapse":"Day Expand"),
                      if (logic.isDayExpanded)
                        Container(
                            margin: EdgeInsets.only(left: Sizes.width_2),
                            child: const Icon(Icons.check))
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 3,
                  child: Row(
                    children: [
                      // const Text("Hide empty row"),
                      Text((logic.isHideRow)?"Show empty row":"Hide empty row"),
                      if (logic.isHideRow)
                        Container(
                            margin: EdgeInsets.only(left: Sizes.width_2),
                            child: const Icon(Icons.check))
                    ],
                  ),
                ),
              ],
              position: PopupMenuPosition.under,
              // offset: Offset(-5, 25),
              color: Colors.grey[60],
              elevation: 2,
              onSelected: (value) {
                logic.onChangeExpand(value);
              },
              onOpened: (){
                logic.menuManege(true);
                stateSetter((){});
              },
              onCanceled: (){
                logic.menuManege(false);
                stateSetter((){});
              },

              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(color: CColor.black, width: 1),
                    borderRadius: BorderRadius.circular(7)),
                child: const Icon(
                  Icons.arrow_drop_down_rounded,
                  color: CColor.black,
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  _widgetFilter(BuildContext context, HistoryController logic,
      Orientation orientation, {bool isLandscape = false}) {
    return InkWell(
      onTap: () {
        // logic.updateOrientation(context);
        showFilterDialog(logic, context, orientation);
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          right: Sizes.width_4,
          top: (isLandscape) ? 0 : Sizes.height_2,
        ),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(color: CColor.black, width: 1),
            borderRadius: BorderRadius.circular(7)),
        child: const Icon(
          Icons.filter_list_rounded,
          color: CColor.black,
        ),
      ),
    );
  }

/*  void _showFilterDialog(HistoryController logic, BuildContext context, Orientation orientation) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return OrientationBuilder(
          builder: (context, orientation) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 16),
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Text("Item $index"),
                                  Checkbox(
                                    value: false,
                                    onChanged: (value) {
                                      // Handle checkbox change
                                    },
                                  ),
                                ],
                              );
                            },
                            shrinkWrap: true,
                            itemCount: 10,
                            physics: const NeverScrollableScrollPhysics(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle OK action
                      },
                      child: Text(
                        "Ok",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                )

              ],
            );
          },
        );
      },
    );
  }

  void showFilterDialogDup(HistoryController logic, BuildContext context, Orientation orientation) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              // backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(0),
              contentPadding: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
              content: Container(
                // margin: const EdgeInsets.all(40),
                width: Get.width * 0.15,
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                    color: CColor.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    (orientation == Orientation.landscape)?
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: Sizes.width_2_5),
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Text(
                                  logic.trackingPrefList[index].titleName
                                      .toString(),
                                ),
                                Checkbox(
                                  value: logic.trackingPrefList[index].isSelected,
                                  onChanged: (value) {
                                    logic.onChangeTitle(
                                        !logic.trackingPrefList[index].isSelected,
                                        index);
                                    setState(() {});
                                  },
                                )
                              ],
                            );
                          },
                          shrinkWrap: true,
                          itemCount: logic.trackingPrefList.length,
                          physics: const AlwaysScrollableScrollPhysics(),
                        ),
                      ),
                    ):
                    Container(
                      margin: EdgeInsets.only(left: Sizes.width_2_5),
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Text(
                                logic.trackingPrefList[index].titleName
                                    .toString(),
                              ),
                              Checkbox(
                                value: logic.trackingPrefList[index].isSelected,
                                onChanged: (value) {
                                  logic.onChangeTitle(
                                      !logic.trackingPrefList[index].isSelected,
                                      index);
                                  setState(() {});
                                },
                              )
                            ],
                          );
                        },
                        shrinkWrap: true,
                        itemCount: logic.trackingPrefList.length,
                        physics: const AlwaysScrollableScrollPhysics(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            "Cancel",
                            style: AppFontStyle.styleW600(
                              CColor.black,
                              FontSize.size_12,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            logic.onChangeTitleTapOnOk();
                          },
                          child: Text(
                            "Ok",
                            style: AppFontStyle.styleW600(
                              CColor.black,
                              FontSize.size_12,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }*/

  void showFilterDialog(HistoryController logic, BuildContext context,
      Orientation orientation) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            setState(() {});
            return AlertDialog(
              // backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(0),
              contentPadding: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
              content: Scrollbar(
                thumbVisibility: true,
                trackVisibility: true,
                radius: Radius.circular(15.0),
                thickness: 7.0,
                child: SingleChildScrollView(
                  child: Wrap(
                    children: [
                      Container(
                        // margin: const EdgeInsets.all(40),
                        width: (orientation == Orientation.landscape) ? Get
                            .width * 0.34 : Get.width * 0.7,
                        padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              15,
                            ),
                            color: CColor.white),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: Sizes.width_2_5),
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          logic.trackingPrefList[index]
                                              .titleName
                                              .toString(),
                                        ),
                                      ),
                                      Checkbox(
                                        value: logic.trackingPrefList[index]
                                            .isSelected,
                                        onChanged: (value) {
                                          logic.onChangeTitle(
                                              !logic.trackingPrefList[index]
                                                  .isSelected,
                                              index);
                                          setState(() {});
                                        },
                                      )
                                    ],
                                  );
                                },
                                shrinkWrap: true,
                                itemCount: logic.trackingPrefList.length,
                                physics: const NeverScrollableScrollPhysics(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        "Cancel",
                        style: AppFontStyle.styleW600(
                          CColor.black,
                          FontSize.size_12,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        logic.onChangeTitleTapOnOk();
                      },
                      child: Text(
                        "Ok",
                        style: AppFontStyle.styleW600(
                          CColor.black,
                          FontSize.size_12,
                        ),
                      ),
                    ),
                  ],
                )

              ],
            );
          },
        );
      },
    );
  }

  _widgetDatePicker(BuildContext context, HistoryController logic,
      Orientation orientation, {bool isLandscape = false}) {
    return InkWell(
      onTap: () {
        showDatePickerDialog(logic, context, orientation);
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          right: Sizes.width_2,
          top: (isLandscape) ? 0 : Sizes.height_2,
        ),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(color: CColor.black, width: 1),
            borderRadius: BorderRadius.circular(7)),
        child: const Icon(
          Icons.date_range_outlined,
          color: CColor.black,
        ),
      ),
    );
  }

  void showDatePickerDialog(HistoryController logic, BuildContext context,
      Orientation orientation) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              // backgroundColor: Colors.transparent,
              // insetPadding: const EdgeInsets.all(10),
              contentPadding: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
              content: (orientation == Orientation.landscape) ? Container(
                // margin: const EdgeInsets.all(40),
                  height: Get.width * 0.95,
                  width: Get.height * 0.8,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                      color: CColor.white),
                  child: SfDateRangePicker(

                    onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                      logic.onSelectionChangedDatePicker(
                          dateRangePickerSelectionChangedArgs);
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
                      logic.updateData(logic.selectedNewDate);
                    },
                  )) : Container(
                // margin: const EdgeInsets.all(40),
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
                    onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                      logic.onSelectionChangedDatePicker(
                          dateRangePickerSelectionChangedArgs);
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
                      logic.updateData(logic.selectedNewDate);
                    },
                  )),
            );
          },
        );
      },
    );
  }

  _widgetSelectedDates(BuildContext context, HistoryController logic,
      {bool isLandscape = false}) {
    return (logic.startDate != "" && logic.endDate != "")
        ? Container(
      margin: EdgeInsets.symmetric(
          horizontal: Sizes.width_4, vertical: Sizes.height_1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Constant.isCalledAPI = false;
              logic.getAndSetWeeksData(logic.previousDate, isTap: true);
              // logic.getAndSetWeeksData(logic.previousDate,isFromAPICall: true);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
              ),
            ),
          ),
          (isLandscape)
              ? Container(
            margin: EdgeInsets.symmetric(horizontal: Sizes.width_5),
            alignment: Alignment.center,
            child: Text(
              "${logic.startDate} - ${logic.endDate}",
              style: AppFontStyle.styleW700(
                  CColor.black, FontSize.size_10),
            ),
          )
              : Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "${logic.startDate} - ${logic.endDate}",
                style: AppFontStyle.styleW700(
                    CColor.black, FontSize.size_10),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Constant.isCalledAPI = false;
              logic.getAndSetWeeksData(
                  logic.nextDate, isNext: true, isTap: true);
              // logic.getAndSetWeeksData(logic.nextDate,isFromAPICall: true);
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
    )
        : Container();
  }

  Widget _itemExWeek(
      // int mainIndex, List<LastWeekData> dataList, HistoryController logic,
      int mainIndex, List<CaloriesStepHeartRateWeek> dataList,
      HistoryController logic,
      Orientation orientation) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          margin: const EdgeInsets.all(0),
          child: Column(
            children: [
              Container(height: Constant.commonHeightForTableBoxMobile,),
              (dataList[mainIndex].isExpanded)
                  ? ListView.builder(
                itemBuilder: (context, daysIndex) {
                  return _itemExDay(mainIndex, daysIndex,
                      // dataList[mainIndex].weekDaysDataList, orientation, logic);
                      dataList[mainIndex].daysList, orientation, logic);
                },
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                // itemCount: dataList[mainIndex].weekDaysDataList.length,
                itemCount: dataList[mainIndex].daysList.length,
                physics: const NeverScrollableScrollPhysics(),
              )
                  : Container(),
              Utils.dividerCustom(),
            ],
          ),
        );
      },
    );
  }

  Widget _itemExDay(int mainIndex,
      int dayIndex,
      // List<WeekDays> weekDaysDataList,
      List<CaloriesStepHeartRateDay> weekDaysDataList,
      Orientation orientation,
      HistoryController logic) {
    // return (logic.activityMinDataList[mainIndex].weekDaysDataList[dayIndex].isShow)?
    return (logic.trackingChartDataList[mainIndex].dayLevelDataList[dayIndex]
        .isShow) ?
    Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: PopupMenuButton<int>(
            enabled: (Constant.isEditMode && Constant.configurationInfo
                .where((element) => element.isExperience)
                .toList()
                .isNotEmpty),
            itemBuilder: (context) =>
            [
              PopupMenuItem(
                value: 1,
                child:
                Utils.getSmileyWidget(
                    Constant.smiley1ImgPath, Constant.smiley1Title),
              ),
              PopupMenuItem(
                value: 2,
                child:
                Utils.getSmileyWidget(
                    Constant.smiley2ImgPath, Constant.smiley2Title),
              ),
              PopupMenuItem(
                value: 3,
                child:
                Utils.getSmileyWidget(
                    Constant.smiley3ImgPath, Constant.smiley3Title),
              ),
              PopupMenuItem(
                value: 4,
                child:
                Utils.getSmileyWidget(
                    Constant.smiley4ImgPath, Constant.smiley4Title),
              ),
              PopupMenuItem(
                value: 5,
                child:
                Utils.getSmileyWidget(
                    Constant.smiley5ImgPath, Constant.smiley5Title),
              ),
              PopupMenuItem(
                value: 6,
                child:
                Utils.getSmileyWidget(
                    Constant.smiley6ImgPath, Constant.smiley6Title),
              ),
              PopupMenuItem(
                value: 7,
                child:
                Utils.getSmileyWidget(
                    Constant.smiley7ImgPath, Constant.smiley7Title),
              ),
            ],
            offset: Offset(-Sizes.width_9, 0),
            color: Colors.grey[60],
            elevation: 2,
            onSelected: (value) {
              var labelIcon = "";


              var expreianceIconValue = 0;
              if (value == 1) {
                labelIcon = Constant.smiley1ImgPath;
                expreianceIconValue = -3;
              } else if (value == 2) {
                labelIcon = Constant.smiley2ImgPath;
                expreianceIconValue = -2;
              } else if (value == 3) {
                labelIcon = Constant.smiley3ImgPath;
                expreianceIconValue = -1;
              } else if (value == 4) {
                labelIcon = Constant.smiley4ImgPath;
                expreianceIconValue = 0;
              } else if (value == 5) {
                labelIcon = Constant.smiley5ImgPath;
                expreianceIconValue = 1;
              } else if (value == 6) {
                labelIcon = Constant.smiley6ImgPath;
                expreianceIconValue = 2;
              } else if (value == 7) {
                labelIcon = Constant.smiley7ImgPath;
                expreianceIconValue = 3;
              } else {
                labelIcon = Constant.smiley1ImgPath;
                expreianceIconValue = -1;
              }
              logic.updateSmileyDayLevel(
                  labelIcon, expreianceIconValue, mainIndex, dayIndex,
                  expreianceIconValue);
            },
            child: SizedBox(
              // height: Sizes.height_7,
              height: Constant.commonHeightForTableBoxMobile,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /*     Image.asset(Utils.getIconNameFromType(logic
                      .activityMinDataList[mainIndex].weekDaysDataList[dayIndex]
                      .smileyType),*/
                  Image.asset(Utils.getIconNameFromType(logic
                      .experienceDataList[mainIndex].daysList[dayIndex]
                      .smileyType),
                      width: Sizes.width_8, height: Sizes.height_2),
                  (Constant.isEditMode && Constant.configurationInfo
                      .where((element) => element.isExperience)
                      .toList()
                      .isNotEmpty) ? const Icon(
                    Icons.arrow_drop_down_sharp,
                  ) : Container(),
                ],
              ),
            ),
          ),
        ),
        Utils.dividerCustom(color: CColor.transparent),
        (weekDaysDataList[dayIndex].isExpanded)
            ? ListView.builder(
          itemBuilder: (context, daysDataIndex) {
            return _itemExDayData(
                mainIndex,
                dayIndex,
                daysDataIndex,
                weekDaysDataList[dayIndex].daysDataList,
                orientation, logic);
          },
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: weekDaysDataList[dayIndex].daysDataList.length,
          physics: const NeverScrollableScrollPhysics(),
        )
            : Container(),
      ],
    ) : Container();
  }

  Widget _itemExDayData(int mainIndex, int dayIndex, int dayDataIndex,
      // List<DaysData> daysDataList, Orientation orientation,
      List<CaloriesStepHeartRateData> daysDataList, Orientation orientation,
      HistoryController logic) {
    return Container(
      alignment: Alignment.center,
      child: PopupMenuButton<int>(
        /*enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.title ==
            logic.activityMinDataList[mainIndex].weekDaysDataList[dayIndex].daysDataList[dayDataIndex].displayLabel &&
            element.isExperience ).toList().isNotEmpty),*/
        /*enabled: (Constant.isEditMode &&
            Constant.configurationInfo
                .where((element) =>
            element.title ==
                daysDataList[dayDataIndex].activityName &&
                element.isExperience)
                .toList()
                .isNotEmpty),*/
        itemBuilder: (context) =>
        [
          PopupMenuItem(
            value: 1,
            child:
            Utils.getSmileyWidget(
                Constant.smiley1ImgPath, Constant.smiley1Title),
          ),
          PopupMenuItem(
            value: 2,
            child:
            Utils.getSmileyWidget(
                Constant.smiley2ImgPath, Constant.smiley2Title),
          ),
          PopupMenuItem(
            value: 3,
            child:
            Utils.getSmileyWidget(
                Constant.smiley3ImgPath, Constant.smiley3Title),
          ),
          PopupMenuItem(
            value: 4,
            child:
            Utils.getSmileyWidget(
                Constant.smiley4ImgPath, Constant.smiley4Title),
          ),
          PopupMenuItem(
            value: 5,
            child:
            Utils.getSmileyWidget(
                Constant.smiley5ImgPath, Constant.smiley5Title),
          ),
          PopupMenuItem(
            value: 6,
            child:
            Utils.getSmileyWidget(
                Constant.smiley6ImgPath, Constant.smiley6Title),
          ),
          PopupMenuItem(
            value: 7,
            child:
            Utils.getSmileyWidget(
                Constant.smiley7ImgPath, Constant.smiley7Title),
          ),
        ],
        offset: Offset(-Sizes.width_9, 0),
        color: Colors.grey[60],
        elevation: 2,
        onSelected: (value) {
          var labelIcon = "";

          var expreianceIconValue = 0;
          if (value == 1) {
            labelIcon = Constant.smiley1ImgPath;
            expreianceIconValue = -3;
          } else if (value == 2) {
            labelIcon = Constant.smiley2ImgPath;
            expreianceIconValue = -2;
          } else if (value == 3) {
            labelIcon = Constant.smiley3ImgPath;
            expreianceIconValue = -1;
          } else if (value == 4) {
            labelIcon = Constant.smiley4ImgPath;
            expreianceIconValue = 0;
          } else if (value == 5) {
            labelIcon = Constant.smiley5ImgPath;
            expreianceIconValue = 1;
          } else if (value == 6) {
            labelIcon = Constant.smiley6ImgPath;
            expreianceIconValue = 2;
          } else if (value == 7) {
            labelIcon = Constant.smiley7ImgPath;
            expreianceIconValue = 3;
          } else {
            labelIcon = Constant.smiley1ImgPath;
            expreianceIconValue = -1;
          }
          logic.updateSmileyDaysDataLevel(
              labelIcon, expreianceIconValue, mainIndex, dayIndex, dayDataIndex);
          // logic.updateTitle6POP();
        },
        child: SizedBox(
          // height: Sizes.height_7,
          height: Constant.commonHeightForTableBoxMobile,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*Image.asset(Utils.getIconNameFromType(
                  logic.activityMinDataList[mainIndex].weekDaysDataList[dayIndex]
                      .daysDataList[dayDataIndex].smileyType),*/
              Image.asset(Utils.getIconNameFromType(
                  logic.experienceDataList[mainIndex].daysList[dayIndex]
                      .daysDataList[dayDataIndex].smileyType),
                  width: Sizes.width_8, height: Sizes.height_2),
              /*Icon(
                Icons.arrow_drop_down_sharp,
              )*/
              (Constant.isEditMode)
                  ? const Icon(
                Icons.arrow_drop_down_sharp,
              )
                  : Container()
              //
            ],
          ),
        ),
      ),
    );
  }

  Widget _editableDaysStrWeek(int index, HistoryController logic,
      OtherTitles2CheckBoxWeek dataList, BuildContext context,
      {Function? onChangeData}) {
    return SizedBox(
      // width: 20,
      // height: 20,
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  textAlign: TextAlign.right,
                  // enabled: Constant.isEditMode,
                  enabled: (Constant.isEditMode && Constant.configurationInfo
                      .where((element) => element.isDaysStr)
                      .toList()
                      .isNotEmpty),
                  enableInteractiveSelection: false,
                  focusNode: dataList.weekValueTitle2CheckBoxFocus,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: Utils.getInputTypeKeyboard(),
                  // keyboardType: TextInputType.number,
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.allow(RegExp(r"\d+([\.]\d+)?")),
                  // ],
                  style: TextStyle(fontSize: FontSize.size_10),
                  maxLines: 1,
                  autofocus: false,
                  autocorrect: true,
                  controller: dataList.weekValueTitle2CheckBoxController,
                  onChanged: (value) {
                    if (onChangeData != null) {
                      onChangeData.call(value);
                    }
                  },
                  onEditingComplete: () {
                    dataList.weekValueTitle2CheckBoxFocus.unfocus();
                  },

                  onSubmitted: (values) {
                    dataList.weekValueTitle2CheckBoxFocus.unfocus();
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    FocusScope.of(context).requestFocus(
                        dataList.weekValueTitle2CheckBoxFocus);
                  },
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _itemDaysStrengthWeek(int mainIndex, BuildContext context,
      OtherTitles2CheckBoxWeek dataList, HistoryController logic,
      String titleType) {
    return Container(
      margin: const EdgeInsets.all(0),
      child: Column(
        children: [
          Container(
              height: Constant.commonHeightForTableBoxMobile,
              padding: EdgeInsets.only(
                right: Sizes.width_1_5,
                left: Sizes.width_1_5,
              ),
              child: Container(
                padding: EdgeInsets.only(
                  bottom: Sizes.height_1,
                ),
                child: _editableDaysStrWeek(mainIndex, logic, dataList, context,
                  onChangeData: (value) {
                    logic.onChangeDaysStrWeek(
                        mainIndex, value, dataList.titleName);
                  },
                ),
              )
          ),
          (dataList.isExpanded)
              ? ListView.builder(
            itemBuilder: (context, daysIndex) {
              return _itemDaysStrengthDays(daysIndex, context,
                  dataList.daysListCheckBox, logic, mainIndex, titleType);
            },
            shrinkWrap: true,

            padding: EdgeInsets.zero,
            itemCount: dataList.daysListCheckBox.length,
            physics: const NeverScrollableScrollPhysics(),
          )
              : Container(),
          Utils.dividerCustom(),
        ],
      ),
    );
  }

  _itemDaysStrengthDays(int daysIndex,
      BuildContext context,
      List<OtherTitles2CheckBoxDay> daysListCheckBox,
      HistoryController logic,
      int mainIndex,
      String titleType) {
    return (logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
        .isShow) ?
    Column(
      children: [
        Utils.dividerCustom(),
        SizedBox(
          height: Constant.commonHeightForTableBoxMobile,
          child: Checkbox(
            value: daysListCheckBox[daysIndex].isCheckedDay,
            onChanged: (!Constant.isEditMode || Constant.configurationInfo
                .where((element) => element.isDaysStr)
                .toList()
                .isEmpty) ? null : (value) {
              logic.onChangeDaysStrengthCheckBoxDay(mainIndex, daysIndex);
            },
          ),
        ),
        (daysListCheckBox[daysIndex].isExpanded)
            ? ListView.builder(
          itemBuilder: (context, daysDataIndex) {
            return _itemDaysStrengthDaysData(
                daysIndex,
                context,
                daysListCheckBox[daysIndex].daysDataListCheckBox,
                logic,
                mainIndex,
                daysDataIndex,
                titleType);
          },
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: daysListCheckBox[daysIndex].daysDataListCheckBox.length,
          physics: const NeverScrollableScrollPhysics(),
        )
            : Container(),
      ],
    ) : Container();
  }

  _itemDaysStrengthDaysData(int daysIndex,
      BuildContext context,
      List<OtherTitles2CheckBoxDaysData> daysDataListCheckBox,
      HistoryController logic,
      int mainIndex,
      int daysDataIndex,
      String titleType) {
    try {
      return SizedBox(
        height: Constant.commonHeightForTableBoxMobile,
        /*child: Checkbox(
          value: daysDataListCheckBox[daysDataIndex].isCheckedDaysData,
          onChanged: (logic.trackingChartDataList[mainIndex]
              .dayLevelDataList[daysIndex].activityLevelDataList.isNotEmpty) ?
          (!Constant.isEditMode || Constant.configurationInfo.where((element) =>
          element.title ==
              logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex].displayLabel &&
              element.isDaysStr)
              .toList()
              .isNotEmpty
              && !logic.trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex].isFromAppleHealth) ? (
              value) {
            logic.onChangeDaysStrengthCheckBoxDaysData(
                mainIndex, daysIndex, daysDataIndex);
          } : null : (value) {},
        ),*/
      );
    } catch (e) {
      return SizedBox(
        height: Constant.commonHeightForTableBoxMobile,
        /*child: Checkbox(
          value: daysDataListCheckBox[daysDataIndex].isCheckedDaysData,
          onChanged: (value) {
            logic.onChangeDaysStrengthCheckBoxDaysData(
                mainIndex, daysIndex, daysDataIndex);
          },
        ),*/
      );
    }
  }

  bottomAddNotesView(BuildContext context, HistoryController logic, int type,
      int mainIndex, int daysIndex, int daysDataIndex) {
    Future<void> future = showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: CColor.transparent,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, StateSetter setStateBottom) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery
                        .of(context)
                        .viewInsets
                        .bottom
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)
                    ),
                    color: CColor.white,
                  ),
                  child: Wrap(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: Sizes.height_2),
                        child: Text(
                          "Add your notes",
                          style: AppFontStyle.styleW700(
                              CColor.black, FontSize.size_14),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: Sizes.height_2,
                            right: Sizes.height_2,
                            top: Sizes.height_2,
                            bottom: Sizes.height_2),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: CColor.black,
                                width: 1
                            ),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: /*HtmlEditor(
                          controller: logic.notesController,
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
                          otherOptions: OtherOptions(height: Sizes.height_30,decoration: BoxDecoration(
                              border: Border.all(color: CColor.transparent)
                          )),                          callbacks: Callbacks(
                          onChangeContent: (String? changed) {
                            Debug.printLog('content changed to $changed');
                          },
                          onChangeCodeview: (String? changed) {
                            Debug.printLog('code changed to $changed');
                            logic.editNoteDataController(changed ?? "",);
                          },
                        ),
                        )*/
                        Container(
                          height: Get.height*0.3,
                          child: Column(
                                                children: [
                                                QuillToolbar.simple(
                                                configurations: QuillSimpleToolbarConfigurations(
                          controller: logic.notesController,
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
                                                controller: logic.notesController,
                                              ), // true for view only mode
                                            ),
                                          ),
                                          ],
                                        ),
                        ),

              ),
                      Container(
                        padding: EdgeInsets.only(
                            top: Sizes.height_1, bottom: Sizes.height_4),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Get.back();
                                  setStateBottom(() {});
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: Sizes.width_5,
                                      right: Sizes.width_1),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                        color: CColor.black,
                                        fontSize: FontSize.size_14),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  logic.insertUpdateWeekNotesData(
                                      mainIndex,
                                      daysIndex,
                                      daysDataIndex,
                                      logic.getDataFromController(),
                                      type);
                                  Get.back();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: Sizes.width_5,
                                      left: Sizes.width_1),
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
                                    "Add",
                                    style: TextStyle(
                                        color: CColor.white,
                                        fontSize: FontSize.size_14),
                                    textAlign: TextAlign.center,
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
              );
            },
          );
        });
    future.then((void value) {
      logic.notesValueLocal = "";
      logic.notesController.clear();
    });
  }
}


