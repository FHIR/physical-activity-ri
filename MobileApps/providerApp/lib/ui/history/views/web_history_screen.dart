import 'package:banny_table/ui/history/datamodel/activityMinClass.dart';
import 'package:banny_table/ui/history/datamodel/caloriesStepHeartRate.dart';
import 'package:banny_table/ui/history/datamodel/daysStrength.dart';
import 'package:banny_table/ui/history/datamodel/editableActivityMinutesWeb/activityMinutesDayWeb.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../utils/font_style.dart';
import '../controllers/history_controller.dart';
import '../datamodel/editableActivityMinutesWeb/activityMinutesDayDataWeb.dart';
import '../datamodel/editableActivityMinutesWeb/activityMinutesWeekWeb.dart';
import '../datamodel/editableCaloriesStepWeb/editableCalStepDayDataWeb.dart';
import '../datamodel/editableCaloriesStepWeb/editableCalStepDayWeb.dart';
import '../datamodel/editableCaloriesStepWeb/editableCalStepWeekWeb.dart';
import '../datamodel/editableHeartRateWeb/editableHeartRateDayDataWeb.dart';
import '../datamodel/editableHeartRateWeb/editableHeartRateDayWeb.dart';
import '../datamodel/editableHeartRateWeb/editableHeartRateWeekWeb.dart';
import '../others/tableColumnsWeb/columnsActivityMinWeb.dart';
import '../others/tableColumnsWeb/columnsCaloriesWeb.dart';
import '../others/tableColumnsWeb/columnsDaysStrWeb.dart';
import '../others/tableColumnsWeb/columnsExperience.dart';
import '../others/tableColumnsWeb/columnsHeartRate.dart';
import '../others/tableColumnsWeb/columnsStepsWeb.dart';
import '../others/tableColumnsWeb/columnsWhatWhenWeb.dart';

class WebHistoryScreen extends StatelessWidget {
  // HistoryController logic = Get.find<HistoryController>();
  final HistoryController logic;

  const WebHistoryScreen(this.logic, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: LayoutBuilder(
        builder: (BuildContext context,BoxConstraints constraints) {
          return Scaffold(
            backgroundColor: CColor.white,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _widgetToggleFilterWeb(context, logic,constraints),
                _widgetSelectedDatesWeb(context, logic,constraints),
                Expanded(
                    child: _getBodyWidget(context, logic,constraints))
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _getBodyWidget(BuildContext context, HistoryController logic,BoxConstraints constraints) {
    return SizedBox(
      height: constraints.maxHeight,
      child: HorizontalDataTable(
        onRefresh: () {
          Debug.printLog("onRefresh.....");
        },
        leftHandSideColumnWidth:
        AppFontStyle.sizesWidthManageWeb(15.0,constraints),
        rightHandSideColumnWidth:(Utils.getTableWidthWeb(
            context,constraints,
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
        headerWidgets: _getHeaderWidgetWeb(logic, context,constraints),
        leftSideItemBuilder: (context, index) {
          return leftSideWidgetWeb(logic, context,constraints);
        },
        rightSideItemBuilder: (context, index) {
          return _rightSideWidgetWeb(logic, context,constraints);
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

  List<Widget>? _getHeaderWidgetWeb(HistoryController logic,
      BuildContext context,BoxConstraints constraints) {
    List<Widget> header = [];
    header.add(cWhatWhenWebNormal(constraints));

    for (int i = 0; i < logic.trackingPrefList.length; i++) {
      if (logic.trackingPrefList[i].titleName ==
          Constant.configurationHeaderModerate &&
          logic.trackingPrefList[i].isSelected) {
        header.add(cActivityMinWebNormal(
            logic, context, Constant.configurationHeaderModerate,constraints));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationHeaderVigorous &&
          logic.trackingPrefList[i].isSelected) {
        header.add(cActivityMinWebNormal(
            logic, context, Constant.configurationHeaderVigorous,constraints));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationHeaderTotal &&
          logic.trackingPrefList[i].isSelected) {
        header.add(cActivityMinWebNormal(
            logic, context, Constant.configurationHeaderTotal,constraints));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationNotes && logic.trackingPrefList[i].isSelected) {
        header.add(
            cActivityMinWebNormal(logic, context, Constant.configurationNotes,constraints));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationHeaderDays &&
          logic.trackingPrefList[i].isSelected) {
        header.add(cDaysStrWebNormal(logic, context,constraints));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationHeaderCalories &&
          logic.trackingPrefList[i].isSelected) {
        header.add(cCaloriesWebNormal(logic, context,constraints));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationHeaderSteps &&
          logic.trackingPrefList[i].isSelected) {
        header.add(cStepsWebNormal(logic, context,constraints));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationHeaderRest &&
          logic.trackingPrefList[i].isSelected) {
        header.add(cHeartRateWebNormal(
            logic, context, Constant.configurationHeaderRest,constraints));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationHeaderPeck &&
          logic.trackingPrefList[i].isSelected) {
        header.add(cHeartRateWebNormal(
            logic, context, Constant.configurationHeaderPeck,constraints));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationExperience &&
          logic.trackingPrefList[i].isSelected) {
        header.add(cExperienceWebNormal(logic, context,constraints));
      }
    }
    return header;
    /*return [
      cWhatWhenWebNormal(),
      cActivityMinWebNormal(logic, context),
      cDaysStrWebNormal(logic, context),

      if (Constant.boolCalories)
        cCaloriesWebNormal(logic, context),

      if (Constant.boolSteps)
        cStepsWebNormal(logic, context),

      if (Constant.boolPeakHeartRate)
        cHeartRateWebNormal(logic, context),

      if (Constant.boolExperience)
        cExperienceWebNormal(logic, context),
    ];*/
  }

  _rightSideWidgetWeb(HistoryController logic, BuildContext contex,BoxConstraints constraints) {
    return Row(
        key: logic.tableKey,
        children: rightSideWidgetWeb(logic, contex,constraints)!
    );
  }

  List<Widget>? rightSideWidgetWeb(HistoryController logic,
      BuildContext context,BoxConstraints constraints) {
    List<Widget> header = [];
    for (int i = 0; i < logic.trackingPrefList.length; i++) {
      if (logic.trackingPrefList[i].titleName ==
          Constant.configurationHeaderModerate &&
          logic.trackingPrefList[i].isSelected) {
        header.add(_widgetActivityMinModWeb(
            logic, context, Constant.configurationHeaderModerate,constraints));
      }
      else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationHeaderVigorous &&
          logic.trackingPrefList[i].isSelected) {
        header.add(_widgetActivityMinModWeb(
            logic, context, Constant.configurationHeaderVigorous,constraints));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationHeaderTotal &&
          logic.trackingPrefList[i].isSelected) {
        header.add(_widgetActivityMinModWeb(
            logic, context, Constant.configurationHeaderTotal,constraints));
      } else
      if (logic.trackingPrefList[i].titleName == Constant.configurationNotes &&
          logic.trackingPrefList[i].isSelected) {
        header.add(_widgetActivityMinModWeb(
            logic, context, Constant.configurationNotes,constraints));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationHeaderDays &&
          logic.trackingPrefList[i].isSelected) {
        header.add(_widgetDaysStrengthDataListWeb(logic, context,constraints));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationHeaderCalories &&
          logic.trackingPrefList[i].isSelected) {
        header.add(_widgetCaloriesDataListWeb(logic, context,constraints));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationHeaderSteps &&
          logic.trackingPrefList[i].isSelected) {
        header.add(_widgetStepsDataListWeb(logic, context,constraints));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationHeaderRest &&
          logic.trackingPrefList[i].isSelected) {
        header.add(_widgetHeartRateDataListWeb(
            logic, context, Constant.configurationHeaderRest,constraints));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationHeaderPeck &&
          logic.trackingPrefList[i].isSelected) {
        header.add(_widgetHeartRateDataListWeb(
            logic, context, Constant.configurationHeaderPeck,constraints,));
      } else if (logic.trackingPrefList[i].titleName ==
          Constant.configurationExperience &&
          logic.trackingPrefList[i].isSelected) {
        header.add(_widgetExperienceDataListWeb(logic, context,constraints));
      }
    }
    Debug.printLog("header.................${header.length}");
    return header;
    /*return Row(
      children: [
        // _widgetActivityMinModWeb(logic, context),
        // _widgetDaysStrengthDataListWeb(logic, context),
        // if (Constant.boolCalories) _widgetCaloriesDataListWeb(logic, context),
        // if (Constant.boolSteps) _widgetStepsDataListWeb(logic, context),
        // if (Constant.boolPeakHeartRate) _widgetHeartRateDataListWeb(logic, context),
        // if (Constant.boolExperience)
        //   _widgetExperienceDataListWeb(logic, context),
      ],
    );*/
  }

  Widget _widgetActivityMinModWeb(HistoryController logic,
      BuildContext context, String columnType,BoxConstraints constraints) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: CColor.black,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width:
            ((columnType == Constant.configurationHeaderModerate) ? Utils
                .getModRowColumnWidthWeb(context, logic,constraints, isFromHeader: false) :
            (columnType == Constant.configurationHeaderVigorous) ? Utils
                .getModRowColumnWidthWeb(context, logic,constraints, isFromHeader: false) :
            (columnType == Constant.configurationHeaderTotal)
                ? Utils.getTotalRowColumnWidthWeb(
                context, logic,constraints, isFromHeader: false)
                :
            Utils.getNotesRowColumnWidthWeb(
                context, logic,constraints, isFromHeader: false)),

            // alignment: Alignment.topCenter,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return _itemActivityMinWeekWeb(
                    index,
                    context,
                    logic
                        .trackingChartDataList[index],
                    logic, columnType,constraints);
              },
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              itemCount: logic.trackingChartDataList.length,
              physics:
              const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
            ),
          ),
          const VerticalDivider(
            color: CColor.black,
            width: 1,
            thickness: 1,
          )

        ],
      ),
    );
  }

  Widget _widgetDaysStrengthDataListWeb(HistoryController logic,
      BuildContext context,BoxConstraints constraints) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(),
          )),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: Utils.getDaysStrengthRowColumnWidthWeb(
                context, logic, constraints,isFromHeader: false),
            alignment: Alignment.topCenter,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return _itemDaysStrengthWeekWeb(
                    index,
                    context,
                    logic
                        .daysStrengthDataList[
                    index],
                    logic,
                    Constant.titleDaysStr,constraints);
              },
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              itemCount: logic
                  .daysStrengthDataList.length,
              physics:
              const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
            ),
          ),
          const VerticalDivider(
            color: CColor.black,
            width: 1,
            thickness: 1,
          )

        ],
      ),
    );
  }

  Widget _widgetCaloriesDataListWeb(HistoryController logic,
      BuildContext context,BoxConstraints constraints) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(),
          )),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        mainAxisAlignment:
        MainAxisAlignment.start,
        children: [
          Container(
            width: Utils.getCaloriesRowColumnWidthWeb(
                context, logic, constraints, isFromHeader: false),
            alignment: Alignment.topCenter,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return _itemCaloriesStepWeekWeb(
                    index,
                    context,
                    logic
                        .caloriesDataList[index],
                    logic,
                    Constant.titleCalories,constraints,);
              },
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              itemCount: logic
                  .caloriesDataList.length,
              physics:
              const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
            ),
          ),
          const VerticalDivider(
            color: CColor.black,
            width: 1,
            thickness: 1,
          )

        ],
      ),
    );
  }

  Widget _widgetStepsDataListWeb(HistoryController logic,
      BuildContext context,BoxConstraints constraints) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(),
          )),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        mainAxisAlignment:
        MainAxisAlignment.start,
        children: [
          Container(
            width:  Utils.getStepsRowColumnWidthWeb(context, logic,constraints, isFromHeader: false),
            alignment: Alignment.topCenter,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return _itemCaloriesStepWeekWeb(
                    index,
                    context,
                    logic
                        .stepsDataList[index],
                    logic,
                    Constant.titleSteps,constraints,);
              },
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              itemCount: logic
                  .stepsDataList.length,
              physics:
              const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
            ),
          ),
          const VerticalDivider(
            color: CColor.black,
            width: 1,
            thickness: 1,
          )

        ],
      ),
    );
  }

  Widget _widgetHeartRateDataListWeb(HistoryController logic,
      BuildContext context, String columnName,BoxConstraints constraints) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(),
          )),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        mainAxisAlignment:
        MainAxisAlignment.start,
        children: [
          Container(
            width:
            ((columnName == Constant.configurationHeaderRest)
                ? Utils.getRestHeartRateRowColumnWidthWeb(
                context, logic,constraints, isFromHeader: false)
                : Utils.getPeakHeartRateRowColumnWidthWeb(
                context, logic,constraints, isFromHeader: false)),
            alignment: Alignment.topCenter,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return _itemHeartRateWeekWeb(
                    index,
                    context,
                    logic
                        .heartRateRestDataList[index],
                    logic
                        .heartRatePeakDataList[
                    index],
                    logic,
                    Constant.titleHeartRateRest,
                    columnName,constraints);
              },
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              itemCount: logic
                  .heartRateRestDataList.length,
              physics:
              const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
            ),
          ),
          const VerticalDivider(
            color: CColor.black,
            width: 1,
            thickness: 1,
          )

        ],
      ),
    );
  }

  Widget _widgetExperienceDataListWeb(HistoryController logic,
      BuildContext context,BoxConstraints constraints) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(),
          )),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Container(
            width: Utils.getExperienceRowColumnWidthWeb(
                context, logic,constraints,  isFromHeader: false),
            alignment: Alignment.topCenter,
            child: ListView.builder(
              itemBuilder: (context, mainIndex) {
                return _itemExWeekWeb(
                    mainIndex,
                    logic.experienceDataList,
                    logic,context,constraints);
              },
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              itemCount:  logic.experienceDataList.length,
              physics:
              const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
            ),
          ),
          const VerticalDivider(
            color: CColor.black,
            width: 1,
            thickness: 1,
          )

        ],
      ),
    );
  }

  Widget leftSideWidgetWeb(HistoryController logic, BuildContext context,BoxConstraints constraints) {
    return Container(
      width: AppFontStyle.sizesWidthManageWeb(15.0,constraints),
      decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(),
          )),
      margin: EdgeInsets.only(
          left: AppFontStyle.sizesWidthManageWeb(1.0,constraints)
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return _itemWhatWhenWeekWeb(
                    index,
                    context,
                    logic,
                    logic
                        .trackingChartDataList[
                    index],constraints);
              },
              shrinkWrap: true,
              physics:
              const NeverScrollableScrollPhysics(),
              itemCount: logic
                  .trackingChartDataList.length,
              scrollDirection: Axis.vertical,
            ),
          ),
          Utils.verticalDividerCustom(),
        ],
      ),
    );
  }

  void showDatePickerDialog(HistoryController logic,
      BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateTemp) {
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
                  width: Get.width * 0.7,
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
                      setStateTemp(() {});
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
                      logic.updateData(logic.selectedNewDate);
                      // setState(() {});
                    },
                  )),
            );
          },
        );
      },
    );
  }

  _widgetToggleFilterWeb(BuildContext context, HistoryController logic,BoxConstraints constraints) {
    return Container(
      padding: EdgeInsets.only(
        bottom: AppFontStyle.sizesHeightManageWeb(1.1,constraints),
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          _widgetToggleWeb(context, logic,constraints),
          const Spacer(),
          _widgetRefresh(context,logic),

          _widgetDatePickerWeb(context, logic,constraints),
          _widgetFilterWeb(context, logic,constraints)
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


  _widgetToggleWeb(BuildContext context, HistoryController logic,BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(
        left: AppFontStyle.sizesWidthManageWeb(2.0, constraints),
        top: AppFontStyle.sizesHeightManageWeb(1.5, constraints),
      ),
      child: Container(
        alignment: Alignment.center,
        child: PopupMenuButton<int>(
          // enabled: Constant.isEditMode,
          itemBuilder: (context) =>
          [
            PopupMenuItem(
              value: 1,
              child: Row(
                children: [
                  Text((logic.isWeekExpanded)
                      ? "Week Collapse"
                      : "Week Expand"),
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
                  Text((logic.isDayExpanded)
                      ? "Day Collapse"
                      : "Day Expand"),
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
                  Text((logic.isHideRow)
                      ? "Show empty row"
                      : "Hide empty row"),
                  if (logic.isHideRow)
                    Container(
                        margin: EdgeInsets.only(left: Sizes.width_2),
                        child: const Icon(Icons.check))
                ],
              ),
            ),
          ],
          offset: Offset(-Sizes.width_9, 50),
          color: Colors.grey[60],
          elevation: 2,
          onSelected: (value) {
            // setState(() {
            logic.onChangeExpand(value);
            // });
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
      ),
    );
  }

  _widgetFilterWeb(BuildContext context, HistoryController logic,BoxConstraints constraints) {
    return Tooltip(
      message: "Fliter",
      child: InkWell(
        hoverColor: CColor.transparent,
        onTap: () {
          showFilterDialogWeb(logic, context,constraints);
        },
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
              top: AppFontStyle.sizesHeightManageWeb(1.5, constraints),
              right: AppFontStyle.sizesWidthManageWeb(2.0, constraints)
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
      ),
    );
  }

  _widgetDatePickerWeb(BuildContext context, HistoryController logic,BoxConstraints constraints) {
    return Tooltip(
      message: "DatePiker",
      child: InkWell(
        // splashColor: CColor.transparent,
        // highlightColor: CColor.transparent,
        hoverColor: CColor.transparent,
        onTap: () {
          showDatePickerDialog(logic, context);
        },
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
              top: AppFontStyle.sizesHeightManageWeb(1.5, constraints),
              right: AppFontStyle.sizesWidthManageWeb(0.8, constraints)
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
      ),
    );
  }

  showDatePickerDialogWeb(HistoryController logic,
      BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(10),
              contentPadding: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
              content: Container(
                  margin: const EdgeInsets.all(40),
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
                      logic.updateData(logic.selectedNewDate);
                    },
                  )),
            );
          },
        );
      },
    );
  }

  _widgetSelectedDatesWeb(BuildContext context, HistoryController logic,BoxConstraints constraints) {
    return (logic.startDate != "" &&
        logic.endDate != "")
        ? Container(
      margin: EdgeInsets.symmetric(
          horizontal: AppFontStyle.sizesWidthManageWeb(1.1,constraints), vertical: AppFontStyle.sizesHeightManageWeb(1.0,constraints)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Constant.isCalledAPI = false;
              // setState(() {
              logic.getAndSetWeeksData(
                  logic.previousDate, isTap: true);
              // });
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
                "${logic.startDate} - ${logic
                    .endDate}",
                style:
                // AppFontStyle.styleW700(CColor.black, FontSize.size_5),
                AppFontStyle.styleW700(CColor.black, AppFontStyle.sizesFontManageHeadingWeb(1.5,constraints)),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Constant.isCalledAPI = false;
              // setState(() {
              logic.getAndSetWeeksData(
                  logic.nextDate,
                  isNext: true, isTap: true);
              // });
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

  void showFilterDialogWeb(HistoryController logic,
      BuildContext context,BoxConstraints constraints) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateTemp) {
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
                    Container(
                      margin: EdgeInsets.only(left: Sizes.width_2_5),
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Expanded(
                                child: Text(
                                  logic.trackingPrefList[index].titleName
                                      .toString(),
                                  style: AppFontStyle.styleW700(
                                      CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints): FontSize.size_2),
                                ),
                              ),
                              Checkbox(
                                value: logic
                                    .trackingPrefList[index].isSelected,
                                onChanged: (value) {
                                  logic.onChangeTitle(
                                      !logic
                                          .trackingPrefList[index].isSelected,
                                      index);
                                  setStateTemp(() {});
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
                    Container(
                      margin: EdgeInsets.only(
                          left: Sizes.width_2, top: Sizes.height_0_7),
                      child: Row(
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
                                AppFontStyle.sizesFontManageWeb(1.4,constraints),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              logic.onChangeTitleTapOnOk();
                              // setState(() {});
                            },
                            child: Text(
                              "Ok",
                              style: AppFontStyle.styleW600(
                                CColor.black,
                                AppFontStyle.sizesFontManageWeb(1.4,constraints),
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
      },
    );
  }

  Widget _itemExWeekWeb(
      // int mainIndex, List<WeekLevelData> dataList, HistoryController logics
      int mainIndex, List<CaloriesStepHeartRateWeek> dataList, HistoryController logic,BuildContext context,BoxConstraints constraints

      ) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          margin: const EdgeInsets.all(0),
          child: Column(
            children: [
              /*Container(
                // height: Sizes.height_9,
                height: Constant.commonHeightForTableBoxWeb,
                alignment: Alignment.center,
                child: PopupMenuButton<int>(
                  enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.isExperience ).toList().isNotEmpty),
                  itemBuilder: (context) =>
                  [
                    PopupMenuItem(
                      value: 1,
                      child: Utils.getSmileyWidget(
                          Constant.smiley1ImgPath, Constant.smiley1Title,
                          isWeb: true),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Utils.getSmileyWidget(
                          Constant.smiley2ImgPath, Constant.smiley2Title,
                          isWeb: true),
                    ),
                    PopupMenuItem(
                      value: 3,
                      child: Utils.getSmileyWidget(
                          Constant.smiley3ImgPath, Constant.smiley3Title,
                          isWeb: true),
                    ),
                    PopupMenuItem(
                      value: 4,
                      child: Utils.getSmileyWidget(
                          Constant.smiley4ImgPath, Constant.smiley4Title,
                          isWeb: true),
                    ),
                    PopupMenuItem(
                      value: 5,
                      child: Utils.getSmileyWidget(
                          Constant.smiley5ImgPath, Constant.smiley5Title,
                          isWeb: true),
                    ),
                    PopupMenuItem(
                      value: 6,
                      child: Utils.getSmileyWidget(
                          Constant.smiley6ImgPath, Constant.smiley6Title,
                          isWeb: true),
                    ),
                    PopupMenuItem(
                      value: 7,
                      child: Utils.getSmileyWidget(
                          Constant.smiley7ImgPath, Constant.smiley7Title,
                          isWeb: true),
                    ),
                  ],
                  offset: const Offset(0, 0),
                  color: Colors.grey[60],
                  elevation: 2,
                  onSelected: (value) {
                    var labelIcon = "";
                    var expreianceIconValue = 0.0;
                    if (value == 1) {
                      labelIcon = Constant.smiley1ImgPath;
                      expreianceIconValue  = -3;
                    } else if (value == 2) {
                      labelIcon = Constant.smiley2ImgPath;
                      expreianceIconValue  = -2;
                    } else if (value == 3) {
                      labelIcon = Constant.smiley3ImgPath;
                      expreianceIconValue  = -1;
                    } else if (value == 4) {
                      labelIcon = Constant.smiley4ImgPath;
                      expreianceIconValue  = 0;
                    } else if (value == 5) {
                      labelIcon = Constant.smiley5ImgPath;
                      expreianceIconValue  = 1;
                    } else if (value == 6) {
                      labelIcon = Constant.smiley6ImgPath;
                      expreianceIconValue  = 2;
                    } else if (value == 7) {
                      labelIcon = Constant.smiley7ImgPath;
                      expreianceIconValue  = 3;
                    } else {
                      labelIcon = Constant.smiley1ImgPath;
                      expreianceIconValue  = -1;
                    }
                    logic.updateSmileyWeekLevel(labelIcon, value, mainIndex,expreianceIconValue);
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      right: Sizes.width_1_5,
                      left: Sizes.width_1_5,
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                            Utils.getIconNameFromType(logics
                                .activityMinDataList[mainIndex].smileyType),
                            width: Sizes.width_1_5,
                            height: Sizes.width_1_5),
const Icon(
                          Icons.arrow_drop_down_sharp,
                        ),

                        (Constant.isEditMode && Constant.configurationInfo.where((element) => element.isExperience ).toList().isNotEmpty)?const Icon(
                          Icons.arrow_drop_down_sharp,
                        ):Container(),
                      ],
                    ),
                  ),
                ),
              ),*/
              Container(
                height: AppFontStyle.commonHeightForTrackingChartBodyWeb(constraints),
              ),
              (dataList[mainIndex].isExpanded)
                  ? ListView.builder(
                itemBuilder: (context, daysIndex) {
                  return _itemExDayWeb(
                      mainIndex,
                      daysIndex,
                      dataList[mainIndex].daysList,
                      logic,context,constraints);
                },
                shrinkWrap: true,
                padding: EdgeInsets.zero,
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

  Widget _itemExDayWeb(int mainIndex, int dayIndex,
      List<CaloriesStepHeartRateDay> weekDaysDataList, HistoryController logic,BuildContext context,BoxConstraints constraints) {
    return (logic.trackingChartDataList[mainIndex]
        .dayLevelDataList[dayIndex].isShow)
        ? Column(
      children: [
        Utils.dividerCustom(),
        Container(
          // height: Sizes.height_10,
          height: AppFontStyle.commonHeightForTrackingChartBodyWeb(constraints),
          alignment: Alignment.center,
          child: PopupMenuButton<int>(
            enabled:  (Constant.isEditMode && Constant.configurationInfo.where((element) => element.isExperience ).toList().isNotEmpty),
            itemBuilder: (context) =>
            [
              PopupMenuItem(
                value: 1,
                child: Utils.getSmileyWidget(
                    Constant.smiley1ImgPath, Constant.smiley1Title,
                    isWeb: true),
              ),
              PopupMenuItem(
                value: 2,
                child: Utils.getSmileyWidget(
                    Constant.smiley2ImgPath, Constant.smiley2Title,
                    isWeb: true),
              ),
              PopupMenuItem(
                value: 3,
                child: Utils.getSmileyWidget(
                    Constant.smiley3ImgPath, Constant.smiley3Title,
                    isWeb: true),
              ),
              PopupMenuItem(
                value: 4,
                child: Utils.getSmileyWidget(
                    Constant.smiley4ImgPath, Constant.smiley4Title,
                    isWeb: true),
              ),
              PopupMenuItem(
                value: 5,
                child: Utils.getSmileyWidget(
                    Constant.smiley5ImgPath, Constant.smiley5Title,
                    isWeb: true),
              ),
              PopupMenuItem(
                value: 6,
                child: Utils.getSmileyWidget(
                    Constant.smiley6ImgPath, Constant.smiley6Title,
                    isWeb: true),
              ),
              PopupMenuItem(
                value: 7,
                child: Utils.getSmileyWidget(
                    Constant.smiley7ImgPath, Constant.smiley7Title,
                    isWeb: true),
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
                  labelIcon, expreianceIconValue, mainIndex, dayIndex, expreianceIconValue);
            },
            child: Container(
              padding: EdgeInsets.only(
                // right: Utils.sizesWidthManage(context, 0.6),
                // left: Utils.sizesWidthManage(context, 5.3)
                //,
                  left: AppFontStyle.sizesWidthManageTrackingChartWeb(5.0, constraints)
              ),
              child: Row(
                children: [
                  Image.asset(
                      Utils.getIconNameFromType(logic
                          .experienceDataList[mainIndex].daysList[dayIndex]
                          .smileyType),
                            height:
                                AppFontStyle.sizesWidthManageTrackingChartWeb(
                                    1.8, constraints),
                            width:
                                AppFontStyle.sizesWidthManageTrackingChartWeb(
                                    1.8, constraints)),
                        (Constant.isEditMode && Constant.configurationInfo.where((element) => element.isExperience ).toList().isNotEmpty)? const Icon(
                    Icons.arrow_drop_down_sharp,
                  ) : Container(),
                ],
              ),
            ),
          ),
        ),
        (weekDaysDataList[dayIndex].isExpanded)
            ? ListView.builder(
          itemBuilder: (context, daysDataIndex) {
            return _itemExDayDataWeb(
                mainIndex,
                dayIndex,
                daysDataIndex,
                weekDaysDataList[dayIndex].daysDataList,
                logic,context,constraints);
          },
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: weekDaysDataList[dayIndex].daysDataList.length,
          physics: const NeverScrollableScrollPhysics(),
        )
            : Container()
      ],
    )
        : Container(color: Colors.cyanAccent,);
  }

  Widget _itemExDayDataWeb(int mainIndex, int dayIndex, int dayDataIndex,
      List<CaloriesStepHeartRateData> daysDataList, HistoryController logic,BuildContext context,BoxConstraints constraints) {
    return Container(
      // height: Sizes.height_10,
      height: AppFontStyle.commonHeightForTrackingChartBodyWeb(constraints),
      alignment: Alignment.center,
      child: PopupMenuButton<int>(
        // enabled: Constant.isEditMode,
        enabled: (Constant.isEditMode &&
            Constant.configurationInfo
                .where((element) =>
            element.title ==
                daysDataList[dayDataIndex].activityName &&
                element.isExperience)
                .toList()
                .isNotEmpty),
        itemBuilder: (context) =>
        [
          PopupMenuItem(
            value: 1,
            child: Utils.getSmileyWidget(
                Constant.smiley1ImgPath, Constant.smiley1Title,
                isWeb: true),
          ),
          PopupMenuItem(
            value: 2,
            child: Utils.getSmileyWidget(
                Constant.smiley2ImgPath, Constant.smiley2Title,
                isWeb: true),
          ),
          PopupMenuItem(
            value: 3,
            child: Utils.getSmileyWidget(
                Constant.smiley3ImgPath, Constant.smiley3Title,
                isWeb: true),
          ),
          PopupMenuItem(
            value: 4,
            child: Utils.getSmileyWidget(
                Constant.smiley4ImgPath, Constant.smiley4Title,
                isWeb: true),
          ),
          PopupMenuItem(
            value: 5,
            child: Utils.getSmileyWidget(
                Constant.smiley5ImgPath, Constant.smiley5Title,
                isWeb: true),
          ),
          PopupMenuItem(
            value: 6,
            child: Utils.getSmileyWidget(
                Constant.smiley6ImgPath, Constant.smiley6Title,
                isWeb: true),
          ),
          PopupMenuItem(
            value: 7,
            child: Utils.getSmileyWidget(
                Constant.smiley7ImgPath, Constant.smiley7Title,
                isWeb: true),
          ),
        ],
        offset: Offset(-Sizes.width_9, 0),
        color: Colors.grey[60],
        elevation: 2,
        onSelected: (value) {
          var labelIcon = "";

          var expreianceIconValue = 0.0;
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
              labelIcon, value, mainIndex, dayIndex, dayDataIndex,
              expreianceIconValue);
          // logic.updateTitle6POP();
        },
        child: Container(
          // padding: EdgeInsets.only(
          // top: Sizes.height_4_1_5,
          // right: Sizes.width_1_5,
          // left: Sizes.width_1_5,
          // bottom: Sizes.height_2_5
          // ),
          padding: EdgeInsets.only(
            // right: Utils.sizesWidthManage(context, 0.6),
            // left: Utils.sizesWidthManage(context, 0.1),
              left: AppFontStyle.sizesWidthManageTrackingChartWeb(5.0, constraints)
          ),
          child: Row(
            children: [
              Image.asset(
                  Utils.getIconNameFromType(
                      logic.experienceDataList[mainIndex].daysList[dayIndex]
                          .daysDataList[dayDataIndex].smileyType),
                height: AppFontStyle.sizesWidthManageTrackingChartWeb(1.8, constraints),
                width: AppFontStyle.sizesWidthManageTrackingChartWeb(1.8, constraints)),
              (Constant.isEditMode && Constant.configurationInfo.where((element) => element.title ==
                  // logic.activityMinDataList[mainIndex].weekDaysDataList[dayIndex].daysDataList[dayDataIndex].displayLabel &&
                  logic.experienceDataList[mainIndex].daysList[dayIndex].daysDataList[dayDataIndex].activityName &&
                  element.isExperience ).toList().isNotEmpty) ?const Icon(
                Icons.arrow_drop_down_sharp,
              )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  _itemWhatWhenWeekWeb(int mainIndex, BuildContext context,
      HistoryController logic, WeekLevelData data,BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tooltip(
          message: "Weekly Data",
          child: InkWell(
            onTap: () {
              logic.onExpandWeek(mainIndex);
              // setState(() {});
            },
            child: Container(
              alignment: Alignment.centerLeft,
              // height: Sizes.height_9,
              height: AppFontStyle.commonHeightForTrackingChartBodyWeb(constraints),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
                              Constant.commonDateFormatMmmDd).format(data
                              .weekEndDate!)}",
                          style: TextStyle(
                              fontWeight: (logic
                                  .trackingChartDataList[mainIndex]
                                  .isExpanded)
                                  ? FontWeight.w700
                                  : FontWeight.normal,
                              fontSize: AppFontStyle.sizesFontManageTrackingChartBodyWeb(1.3,constraints)
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        (logic.trackingChartDataList[mainIndex].isExpanded)
            ? ListView.builder(
          // padding: EdgeInsets.only(
          //     left: MediaQuery.of(context).size.width * 0.01),
          itemBuilder: (context, index) {
            return _itemWhatWhenDayWeb(index, context,
                data.dayLevelDataList, logic, mainIndex,constraints);
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

  _itemWhatWhenDayWeb(int daysIndex,
      BuildContext context,
      List<DayLevelData> weekDaysDataList,
      HistoryController logic,
      int mainIndex,BoxConstraints constraints) {
    return (logic.trackingChartDataList[mainIndex]
        .dayLevelDataList[daysIndex].isShow)
        ? Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: AppFontStyle.sizesWidthManageTrackingChartWeb( 1.7,constraints)),
          // color: CColor.qrColorGreen,
          height: AppFontStyle.commonHeightForTrackingChartBodyWeb(constraints),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  // setState(() {
                  if (logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
                      .activityLevelDataList.isNotEmpty) {
                    logic.onExpandDays(mainIndex, daysIndex);
                  }
                  // });
                },
                child: Icon(
                  (weekDaysDataList[daysIndex].isExpanded)
                      ? Icons.arrow_drop_up_rounded
                      : Icons.arrow_drop_down_rounded,
                  color: (logic
                      .trackingChartDataList[mainIndex]
                      .dayLevelDataList[daysIndex]
                      .activityLevelDataList
                      .isNotEmpty)
                      ? Colors.black
                      : Colors.transparent,
                ),
              ),
              InkWell(
                onHover: (hover) {},
                onTap: () {
                  // logic.onExpandDays(mainIndex, daysIndex);
                  // setState(() {
                  // if (logic.trackingChartDataList[mainIndex]
                  //     .dayLevelDataList[daysIndex]
                  //     .activityLevelDataList.isNotEmpty) {
                  logic.onExpandDays(mainIndex, daysIndex);
                  // }
                  // });
                },
                child: Container(
                  height: Sizes.height_10,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${weekDaysDataList[daysIndex].dayName}\n"
                        "${DateFormat(Constant.commonDateFormatMmDd).format(
                        weekDaysDataList[daysIndex].storedDate!)}",
                    textAlign: TextAlign.center,
                    style: TextStyle( fontSize: AppFontStyle.commonFontSizeBodyWeb(constraints)),
                  ),
                ),
              ),
            ],
          ),
        ),
        Utils.dividerCustom(color: CColor.transparent),
        (weekDaysDataList[daysIndex].activityLevelDataList.isNotEmpty &&
            weekDaysDataList[daysIndex].isExpanded)
            ? ListView.builder(
          itemBuilder: (context, daysDataIndex) {
            return Container(
              // margin:
              //     EdgeInsets.symmetric(horizontal: Sizes.width_1_5),
              padding: EdgeInsets.only(
                right:  AppFontStyle.sizesWidthManageWeb(0.7,constraints),
                left:  AppFontStyle.sizesWidthManageWeb(2.2,constraints),
              ),
              // height: Sizes.height_10,
              height: AppFontStyle.commonHeightForTrackingChartBodyWeb(constraints),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Image.asset(
                          /*Utils.getNumberIconNameFromType(
                                          weekDaysDataList[daysIndex]
                                              .daysDataList[daysDataIndex]
                                              .displayLabel
                                              .toString())*/
                          weekDaysDataList[daysIndex]
                              .activityLevelDataList[daysDataIndex]
                              .iconPath
                              .toString(),
                          height: AppFontStyle.sizesWidthManageWeb(1.9,constraints),
                          width: AppFontStyle.sizesWidthManageWeb(1.9,constraints),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                left: AppFontStyle.sizesWidthManageWeb(0.3,constraints)),
                            // child: Text(type,style: AppFontStyle.styleW400(CColor.black, FontSize.size_8),),
                            child: Text(
                              weekDaysDataList[daysIndex]
                                  .activityLevelDataList[daysDataIndex]
                                  .displayLabel
                                  .toString(),
                              style: AppFontStyle.styleW400(
                                  CColor.black, AppFontStyle.commonFontSizeBodyWeb(constraints)),
                              overflow: TextOverflow.ellipsis,
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

                            logic.onChangeActivityTimeLast(startDate,endDate);

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
                                  if(totalMin != null){
                                    addedMin = totalMin;
                                  }
                                  var endDateTIme = weekDaysDataList[daysIndex]
                                      .activityLevelDataList[daysDataIndex]
                                      .activityStartDate.add(Duration(minutes: addedMin));
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
                                },constraints);
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: AppFontStyle.sizesWidthManageWeb( 0.8,constraints)),
                            child: Icon(
                              Icons.watch_later_outlined,
                              size: AppFontStyle.commonFontSizeBodyWeb(constraints)+3.0,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          // padding: EdgeInsets.only(
          //     left: MediaQuery.of(context).size.width * 0.04),
          physics: const NeverScrollableScrollPhysics(),
          itemCount:
          weekDaysDataList[daysIndex].activityLevelDataList.length,
          shrinkWrap: true,
        )
            : Container()
      ],
    )
        : Container();
  }

//   _itemWhatWhenDayWeb(int daysIndex,
//       BuildContext context,
//       List<WeekDays> weekDaysDataList,
//       HistoryController logic,
//       int mainIndex) {
//     return (logic.activityMinDataList[mainIndex]
//         .weekDaysDataList[daysIndex].isShow)
//         ? Column(
//       children: [
//         Container(
//           padding: EdgeInsets.only(left: Sizes.width_2),
//           // color: CColor.qrColorGreen,
//           height: Constant.commonHeightForTableBoxWeb,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               InkWell(
//                 onTap: () {
//                   // setState(() {
//                   if (logic
//                       .activityMinDataList[mainIndex]
//                       .weekDaysDataList[daysIndex]
//                       .daysDataList
//                       .isNotEmpty) {
//                     logic.onExpandDays(mainIndex, daysIndex);
//                   }
//                   // });
//                 },
//                 child: Icon(
//                   (weekDaysDataList[daysIndex].isExpanded)
//                       ? Icons.arrow_drop_up_rounded
//                       : Icons.arrow_drop_down_rounded,
//                   color: (logic
//                       .activityMinDataList[mainIndex]
//                       .weekDaysDataList[daysIndex]
//                       .daysDataList
//                       .isNotEmpty)
//                       ? Colors.black
//                       : Colors.transparent,
//                 ),
//               ),
//               InkWell(
//                 onHover: (hover) {},
//                 onTap: () {
//                   // logic.onExpandDays(mainIndex, daysIndex);
//                   // setState(() {
//                   if (logic.activityMinDataList[mainIndex]
//                       .weekDaysDataList[daysIndex]
//                       .daysDataList.isNotEmpty) {
//                     logic.onExpandDays(mainIndex, daysIndex);
//                   }
//                   // });
//                 },
//                 child: Container(
//                   height: Sizes.height_10,
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     "${weekDaysDataList[daysIndex].dayName}\n"
//                         "${DateFormat(Constant.commonDateFormatMmDd).format(
//                         weekDaysDataList[daysIndex].storedDate!)}",
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(fontSize: 12),
//                   ),
//                 ),
//               ),
//               if ( logic
//                   .activityMinDataList[mainIndex]
//                   .weekDaysDataList[daysIndex]
//                   .activityLevelData.isNotEmpty && Constant.isEditMode)
//                 PopupMenuButton<String>(
//                   enabled: Constant.isEditMode,
// itemBuilder: (context) => [
//                           if (!logic.activityMinDataList[mainIndex]
//                               .weekDaysDataList[daysIndex].isBicycling && Constant.configurationInfo.where((element) =>
//                           element.title == Constant.itemBicycling &&
//
//                               element.isEnabled ).toList().isEmpty  )
//                             PopupMenuItem(
//                               value: 1,
//                               child: Row(
//                                 children: [
//                                   _widgetNumberImage(Constant.itemBicycling)
//                                 ],
//                               ),
//                             ),
//                           if (!logic.activityMinDataList[mainIndex]
//                               .weekDaysDataList[daysIndex].isJogging && Constant.configurationInfo.where((element) =>
//                           element.title == Constant.itemJogging &&
//
//                               element.isEnabled ).toList().isEmpty )
//                             PopupMenuItem(
//                               value: 2,
//                               child: Row(
//                                 children: [
//                                   _widgetNumberImage(Constant.itemJogging)
//                                 ],
//                               ),
//                             ),
//                           if (!logic.activityMinDataList[mainIndex]
//                               .weekDaysDataList[daysIndex].isRunning && Constant.configurationInfo.where((element) =>
//                           element.title == Constant.itemRunning &&
//
//                               element.isEnabled ).toList().isEmpty )
//                             PopupMenuItem(
//                               value: 3,
//                               child: Row(
//                                 children: [
//                                   _widgetNumberImage(Constant.itemRunning)
//                                 ],
//                               ),
//                             ),
//                           if (!logic.activityMinDataList[mainIndex]
//                               .weekDaysDataList[daysIndex].isSwimming && Constant.configurationInfo.where((element) =>
//                           element.title == Constant.itemSwimming &&
//
//                               element.isEnabled ).toList().isEmpty )
//                             PopupMenuItem(
//                               value: 4,
//                               child: Row(
//                                 children: [
//                                   _widgetNumberImage(Constant.itemSwimming)
//                                 ],
//                               ),
//                             ),
//                           if (!logic.activityMinDataList[mainIndex]
//                               .weekDaysDataList[daysIndex].isWalking && Constant.configurationInfo.where((element) =>
//                           element.title == Constant.itemWalking &&
//
//                               element.isEnabled ).toList().isEmpty )
//                             PopupMenuItem(
//                               value: 5,
//                               child: Row(
//                                 children: [
//                                   _widgetNumberImage(Constant.itemWalking)
//                                 ],
//                               ),
//                             ),
//                           if (!logic.activityMinDataList[mainIndex]
//                               .weekDaysDataList[daysIndex].isWeights && Constant.configurationInfo.where((element) =>
//                           element.title == Constant.itemWeights &&
//
//                               element.isEnabled ).toList().isEmpty )
//                             PopupMenuItem(
//                               value: 6,
//                               child: Row(
//                                 children: [
//                                   _widgetNumberImage(Constant.itemWeights)
//                                 ],
//                               ),
//                             ),
//                           if (!logic.activityMinDataList[mainIndex]
//                               .weekDaysDataList[daysIndex].isMixed && Constant.configurationInfo.where((element) =>
//                           element.title == Constant.itemMixed &&
//
//                               element.isEnabled ).toList().isEmpty )
//                             PopupMenuItem(
//                               value: 7,
//                               child: Row(
//                                 children: [
//                                   _widgetNumberImage(Constant.itemMixed)
//                                 ],
//                               ),
//                             ),
//                         ],
//
//                   itemBuilder: (context) =>
//                       logic
//                           .activityMinDataList[mainIndex]
//                           .weekDaysDataList[daysIndex]
//                           .activityLevelData.map((e) =>
//                           PopupMenuItem<String>(
//                               value: e.toString(),
//                               child: Row(
//                                 children: [_widgetNumberImage(e,
//                                     logic
//                                         .activityMinDataList[mainIndex]
//                                         .weekDaysDataList[daysIndex]
//                                         .activityLevelDataIcons[
//                                     logic
//                                         .activityMinDataList[mainIndex]
//                                         .weekDaysDataList[daysIndex]
//                                         .activityLevelData.indexWhere((
//                                         element) => element == e).toInt()
//                                     ].toString()),
//                                 ],
//                               )
//                           ),
//                       )
//                           .toList(),
//                   offset: Offset(-Sizes.width_9, 0),
//                   color: Colors.grey[60],
//                   elevation: 2,
//                   onSelected: (value) {
//                     // var labelName = "";
//
//  if (value == 1) {
//                             labelName = Constant.itemBicycling;
//                           } else if (value == 2) {
//                             labelName = Constant.itemJogging;
//                           } else if (value == 3) {
//                             labelName = Constant.itemRunning;
//                           } else if (value == 4) {
//                             labelName = Constant.itemSwimming;
//                           } else if (value == 5) {
//                             labelName = Constant.itemWalking;
//                           } else if (value == 6) {
//                             labelName = Constant.itemWeights;
//                           } else if (value == 7) {
//                             labelName = Constant.itemMixed;
//                           } else {
//                             labelName = Constant.itemBicycling;
//                           }
//
//
//
//                     // setState(() {
//                     logic.addDaysDataWeekWise(mainIndex, daysIndex, value,
//                       // reCall: () {setState(() {});}
//                     );
//                     // });
//                   },
//                   child: Container(
//                       margin: EdgeInsets.only(left: Sizes.width_1),
//                       child: const Text("+")),
//                 )
//               else
//                 Container(),
//             ],
//           ),
//         ),
//         Utils.dividerCustom(color: CColor.transparent),
//         (weekDaysDataList[daysIndex].daysDataList.isNotEmpty &&
//             weekDaysDataList[daysIndex].isExpanded)
//             ? ListView.builder(
//           itemBuilder: (context, daysDataIndex) {
//             return Container(
//               // margin:
//               //     EdgeInsets.symmetric(horizontal: Sizes.width_1_5),
//               padding: EdgeInsets.only(
//                 right: Sizes.width_1_5,
//                 left: Sizes.width_3,
//               ),
//               // height: Sizes.height_10,
//               height: Constant.commonHeightForTableBoxWeb,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       if (Constant.isEditMode) {
//                         logic.removeDaysDataIndexWise(
//                             mainIndex, daysIndex, daysDataIndex);
//                       }
//                       // setState(() {});
//                     },
//                     child: Icon(
//                       Icons.close,
//                       color: (Constant.isEditMode)
//                           ? CColor.red
//                           : Colors.grey,
//                       size: Sizes.width_1,
//                     ),
//                   ),
//                   Expanded(
//                     child: Container(
//                       // margin: EdgeInsets.only(left: Sizes.width_1),
//                       child: Row(
//                         children: [
//                           Image.asset(
// Utils.getNumberIconNameFromType(
//                                             weekDaysDataList[daysIndex]
//                                                 .daysDataList[daysDataIndex]
//                                                 .displayLabel
//                                                 .toString())
//
//                             weekDaysDataList[daysIndex]
//                                 .daysDataList[daysDataIndex]
//                                 .iconPath
//                                 .toString(),
//                             height: Sizes.width_0_8,
//                             width: Sizes.width_0_8,
//                           ),
//                           Expanded(
//                             child: Container(
//                               margin: EdgeInsets.only(
//                                   left: Sizes.width_0_5),
//                               // child: Text(type,style: AppFontStyle.styleW400(CColor.black, FontSize.size_8),),
//                               child: Text(
//                                 weekDaysDataList[daysIndex]
//                                     .daysDataList[daysDataIndex]
//                                     .displayLabel
//                                     .toString(),
//                                 style: AppFontStyle.styleW400(
//                                     CColor.black, FontSize.size_2),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//           // padding: EdgeInsets.only(
//           //     left: MediaQuery.of(context).size.width * 0.04),
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount:
//           weekDaysDataList[daysIndex].daysDataList.length,
//           shrinkWrap: true,
//         )
//             : Container()
//       ],
//     )
//         : Container();
//   }

  Widget _widgetNumberImage(String type, String iconName, BuildContext context,
      BoxConstraints constraints) {
    return Row(
      children: [
        Image.asset(
          // Utils.getNumberIconNameFromType(type),
          iconName,
          height:
              AppFontStyle.sizesWidthManageTrackingChartWeb(1.8, constraints),
          width:
              AppFontStyle.sizesWidthManageTrackingChartWeb(1.8, constraints),
        ),
        Container(
          margin: EdgeInsets.only(left: Sizes.width_0_5),
          // child: Text(type,style: AppFontStyle.styleW400(CColor.black, FontSize.size_8),),
          child: Text(
            type,
            style: AppFontStyle.styleW400(
                CColor.black, AppFontStyle.commonFontSizeBodyWeb(constraints)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  _itemActivityMinWeekWeb(int mainIndex, BuildContext context,
      WeekLevelData dataList, HistoryController logic, String columnType,BoxConstraints constraints) {
    return Container(
      margin: const EdgeInsets.all(0),
      child: Column(
        children: [
          Container(
            // height: Sizes.height_9,
            // height: Constant.commonHeightForTableBoxWeb,
            height: AppFontStyle.commonHeightForTrackingChartBodyWeb(constraints),
            child: Row(
              children: [
                (logic.trackingPrefList.where((element) =>
                element.titleName == Constant.configurationHeaderModerate
                    && element.isSelected)
                    .toList()
                    .isNotEmpty &&
                    columnType == Constant.configurationHeaderModerate)
                    ? Expanded(
                  child: Container(
                    padding: EdgeInsets.only(bottom: Sizes.height_1),
                    // child: _editableTextValue1Web(onChangeData: (value) {
                    child: editableActivityMinModWeekWeb(
                        onChangeData: (value) {
                          Debug.printLog(
                              "Title 1 _editableTextValue1....$value");
                          /*logic.onChangeActivityMinMod(
                            mainIndex, value);*/
                          // setState(() {});
                        },
                        mainIndex,
                        logic,
                        columnType,
                        logic.trackingPrefList,
                        context,constraints,
                    ),
                  ),
                )
                    : Container(),

                const Text("  "),
                (logic.trackingPrefList.where((element) =>
                element.titleName == Constant.configurationHeaderVigorous
                    && element.isSelected)
                    .toList()
                    .isNotEmpty
                    && columnType == Constant.configurationHeaderVigorous)
                    ? Expanded(
                  child: Container(
                    padding: EdgeInsets.only(bottom: Sizes.height_1),
                    // child: _editableTextValue2Web(onChangeData: (value) {
                    child: editableActivityMinVigWeekWeb(
                        onChangeData: (value) {
                          Debug.printLog(
                              "Title 1 _editableTextValue2....$value");
                          /*logic.onChangeActivityMinVig(
                              mainIndex, value);*/
                          // setState(() {});
                        }, mainIndex, logic,
                        columnType,
                        logic.trackingPrefList,context,constraints,),
                  ),
                )
                    : Container(),

                const Text("  "),
                if(logic.trackingPrefList.where((element) =>
                element.titleName == Constant.configurationHeaderTotal
                    && element.isSelected)
                    .toList()
                    .isNotEmpty
                    && columnType == Constant.configurationHeaderTotal)
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(bottom: Sizes.height_1),
                      // child: _editableTextTotalWeb(onChangeData: (value) {
                      child:
                      editableActivityMiTotalWeekWeb(onChangeData: (value) {
                        Debug.printLog("Title 1 _editableTextTotal....$value");
                        // logic.onChangeActivityMinTotal(mainIndex, value);
                        // setState(() {});
                      }, mainIndex, logic,
                          columnType,
                          logic.trackingPrefList,context,constraints,),
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
                        // if (Constant.isEditMode && Constant.configurationInfo
                        //     .where((element) => element.isNotes)
                        //     .toList()
                        //     .isNotEmpty) {
                          logic.setNotesOnController(logic
                              .trackingChartDataList[mainIndex].weeklyNotes);
                          bottomAddNotesView(context, logic,
                              Constant.typeWeek, mainIndex, -1, -1);
                        // }
                      },
                      child: Container(
                          alignment: Alignment.center,
                          child:
                          (logic.trackingChartDataList[mainIndex]
                              .weeklyNotes.isNotEmpty)

                              ? Image.asset(
                            "assets/icons/ic_comment.png",
                            height: AppFontStyle.sizesWidthManageTrackingChartWeb(1.8, constraints),
                            width: AppFontStyle.sizesWidthManageTrackingChartWeb(1.8, constraints),
                            // color: Colors.grey,
                          ) : Image.asset("assets/icons/ic_notecomment.png",
                            height: AppFontStyle.sizesWidthManageTrackingChartWeb(1.8, constraints),
                            width: AppFontStyle.sizesWidthManageTrackingChartWeb(1.8, constraints),
                            color: (Constant.isEditMode &&
                                Constant.configurationInfo
                                    .where((element) => element.isNotes)
                                    .toList()
                                    .isNotEmpty) ? CColor.black : CColor.gray,)
                      ),
                    ),
                  ),
              ],
            ),
          ),
          (logic.trackingChartDataList[mainIndex].isExpanded)
              ? ListView.builder(
            itemBuilder: (context, index) {
              return _itemActivityMinDayWeb(index, context,
                  dataList.dayLevelDataList, logic, mainIndex, columnType,constraints);
            },
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: dataList.dayLevelDataList.length,
            physics: const NeverScrollableScrollPhysics(),
          )
              : Container(),
          Utils.dividerCustom(),
        ],
      ),
    );
  }

  _itemActivityMinDayWeb(int daysIndex,
      BuildContext context,
      List<DayLevelData> weekDaysDataList,
      HistoryController logic,
      int mainIndex, String columnType,BoxConstraints constraints) {
    return (logic.trackingChartDataList[mainIndex]
        .dayLevelDataList[daysIndex].isShow)
        ? Column(
      children: [
        Column(
          children: [
            Utils.dividerCustom(),
            Container(
              height: AppFontStyle.commonHeightForTrackingChartBodyWeb(constraints),
              child: Row(
                children: [
                  (logic.trackingPrefList.where((element) =>
                  element.titleName == Constant.configurationHeaderModerate
                      && element.isSelected)
                      .toList()
                      .isNotEmpty &&
                      columnType == Constant.configurationHeaderModerate)
                      ? Expanded(
                    child: Container(
                      padding:
                      EdgeInsets.only(bottom: Sizes.height_1),
                      // child: _editableTextValue1DaysWeb(onChangeData: (value) {
                      child: editableActivityMinModDayWeb(
                          onChangeData: (value) {
                            Debug.printLog(
                                "Title 1 _editableTextValue1Days....$value");
                            // logic.onChangeActivityMinModDay(
                            //     mainIndex, daysIndex, value);
                            // setState(() {});
                          }, mainIndex, daysIndex, logic, columnType,
                          logic.trackingPrefList,context,constraints,),
                    ),
                  )
                      : Container(),

                  const Text("  "),
                  (logic.trackingPrefList.where((element) =>
                  element.titleName == Constant.configurationHeaderVigorous
                      && element.isSelected)
                      .toList()
                      .isNotEmpty
                      && columnType == Constant.configurationHeaderVigorous)
                      ? Expanded(
                    child: Container(
                      padding:
                      EdgeInsets.only(bottom: Sizes.height_1),
                      // child: _editableTextValue2DaysWeb(onChangeData: (value) {
                      child: editableActivityMinVigDayWeb(
                          onChangeData: (value) {
                            Debug.printLog(
                                "Title 1 _editableTextValue2Days....$value");
                            // logic.onChangeActivityMinVigDay(
                            //     mainIndex, daysIndex, value);
                            // setState(() {});
                          }, mainIndex, daysIndex, logic, columnType,
                          logic.trackingPrefList,context,constraints,),
                    ),
                  )
                      : Container(),
                  const Text("  "),

                  if(logic.trackingPrefList.where((element) =>
                  element.titleName == Constant.configurationHeaderTotal
                      && element.isSelected)
                      .toList()
                      .isNotEmpty
                      && columnType == Constant.configurationHeaderTotal)
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(bottom: Sizes.height_1),
                        // child: _editableTextTotalDaysWeb(onChangeData: (value) {
                        child: editableActivityMiTotalDayWeb(
                            onChangeData: (value) {
                              Debug.printLog(
                                  "Title 1 _editableTextTotalDays....$value");
                              // logic.onChangeActivityMiTotalDays(
                              //     mainIndex, daysIndex, value);
                              // setState(() {});
                            }, mainIndex, daysIndex, logic, columnType,
                            logic.trackingPrefList,context,constraints,),
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
                          /*if (Constant.isEditMode &&
                              Constant.configurationInfo
                                  .where((element) => element.isNotes)
                                  .toList()
                                  .isNotEmpty) {*/
                            logic.setNotesOnController(logic
                                .trackingChartDataList[mainIndex]
                                .dayLevelDataList[daysIndex]
                                .dailyNotes);
                            bottomAddNotesView(context, logic,
                                Constant.typeDay, mainIndex, daysIndex, -1);
                          // }
                        },
                        child: Container(
                            alignment: Alignment.center,
                            child:
                            (logic.trackingChartDataList[mainIndex]
                                .dayLevelDataList[daysIndex].dailyNotes
                                .isNotEmpty)
                                ? Image.asset(
                              "assets/icons/ic_comment.png",
                              height: AppFontStyle.sizesWidthManageTrackingChartWeb(1.8, constraints),
                              width: AppFontStyle.sizesWidthManageTrackingChartWeb(1.8, constraints),
                              // color: Colors.grey,
                            )
                                : Image.asset(
                              "assets/icons/ic_notecomment.png",
                              height: AppFontStyle.sizesWidthManageTrackingChartWeb(1.8, constraints),
                              width: AppFontStyle.sizesWidthManageTrackingChartWeb(1.8, constraints),
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
              // height: Sizes.height_10,
              // height: Constant.commonHeightForTableBoxWeb,
              height: AppFontStyle.commonHeightForTrackingChartBodyWeb(constraints),

              // margin:
              // EdgeInsets.symmetric(horizontal: Sizes.width_1_5),
/*              padding: EdgeInsets.only(
                right: Utils.sizesWidthManage(context, 0.6),
                left: Utils.sizesWidthManage(context, 0.1),
              ),*/
              child: Row(
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
                            bottom: Sizes.height_1),
                        // child: _editableTextValue1DaysDataWeb(
                        child: editableActivityMinModDayDataWeb(
                            onChangeData: (value) {
                              Debug.printLog(
                                  "Title 1 _editableTextValue1DaysData....$value");
                              /*logic.onChangeActivityMinModDayData(
                                mainIndex,
                                daysIndex,
                                daysDataIndex,
                                value);*/

                              // setState(() {});
                            }, mainIndex, daysIndex, daysDataIndex,
                            logic,context,constraints,),
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
                            bottom: Sizes.height_1),
                        // child: _editableTextValue2DaysDataWeb(
                        child: editableActivityMinVigDayDataWeb(
                            onChangeData: (value) {
                              Debug.printLog(
                                  "Title 1 _editableTextValue2DaysData....$value");
                              /*logic.onChangeActivityMinVigDayData(
                                mainIndex,
                                daysIndex,
                                daysDataIndex,
                                value);*/

                              // setState(() {});
                            }, mainIndex, daysIndex, daysDataIndex,
                            logic,context,constraints,),
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
                        padding:
                        EdgeInsets.only(bottom: Sizes.height_1),
                        // child: _editableTextTotalDaysDataWeb(
                        child: editableActivityMinTotalDaysDataWeb(
                            onChangeData: (value) {
                              Debug.printLog(
                                  "Title 1 _editableTextTotalDaysData....$value");
                              // logic
                              //     .onChangeActivityMinTotalDaysData(
                              //         mainIndex,
                              //         daysIndex,
                              //         daysDataIndex,
                              //         value);
                              // setState(() {});
                            }, mainIndex, daysIndex, daysDataIndex,
                            logic,context,constraints,),
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
                          // if (Constant.isEditMode &&
                          //     Constant.configurationInfo
                          //         .where((element) =>
                          //     element.title ==
                          //         logic
                          //             .trackingChartDataList[
                          //         mainIndex]
                          //             .dayLevelDataList[
                          //         daysIndex]
                          //             .activityLevelDataList[
                          //         daysDataIndex]
                          //             .displayLabel &&
                          //         element.isNotes)
                          //         .toList()
                          //         .isNotEmpty) {
                            logic.setNotesOnController(logic
                                .trackingChartDataList[mainIndex]
                                .dayLevelDataList[daysIndex]
                                .activityLevelDataList[daysDataIndex]
                                .dayDataNotes);
                            bottomAddNotesView(
                                context,
                                logic,
                                Constant.typeDay,
                                mainIndex,
                                daysIndex,
                                daysDataIndex);
                          // }
                        },
                        child: Container(
                            alignment: Alignment.center,
                            child:
                            (logic.trackingChartDataList[mainIndex]
                                .dayLevelDataList[daysIndex]
                                .activityLevelDataList[daysDataIndex]
                                .dayDataNotes
                                .isNotEmpty)
                                ? Image.asset(
                              "assets/icons/ic_comment.png",
                              height: AppFontStyle.sizesWidthManageTrackingChartWeb(1.8, constraints),
                              width: AppFontStyle.sizesWidthManageTrackingChartWeb(1.8, constraints),
                              // color: Colors.grey,
                            )
                                : Image.asset(
                              "assets/icons/ic_notecomment.png",
                              height: AppFontStyle.sizesWidthManageTrackingChartWeb(1.8, constraints),
                              width: AppFontStyle.sizesWidthManageTrackingChartWeb(1.8, constraints),
                              color: (Constant.isEditMode &&
                                  Constant.configurationInfo.where((element) =>
                                  element.title ==
                                      logic.trackingChartDataList[mainIndex]
                                          .dayLevelDataList[daysIndex]
                                          .activityLevelDataList[daysDataIndex]
                                          .displayLabel &&
                                      element.isNotes)
                                      .toList()
                                      .isNotEmpty) ? CColor.black : CColor.gray,
                            )

                        ),
                      ),
                    ),
                ],
              ),
            );
          },
          shrinkWrap: true,
          itemCount:
          weekDaysDataList[daysIndex].activityLevelDataList.length,
          physics: const NeverScrollableScrollPhysics(),
        )
            : Container(
          padding: EdgeInsets.zero,
        ),
      ],
    )
        : Container();
  }

  _itemCaloriesStepWeekWeb(int mainIndex,
      BuildContext context,
      CaloriesStepHeartRateWeek dataList,
      HistoryController logic,
      String titleType,BoxConstraints constraints) {
    return Container(
      margin: const EdgeInsets.all(0),
      child: Column(
        children: [
          Container(
            // height: Sizes.height_9,
              height: AppFontStyle.commonHeightForTrackingChartBodyWeb(constraints),

              // height: Constant.commonHeightForTableBoxWeb,

              /*padding: EdgeInsets.only(
                // top: Sizes.height_2_1_5_8,
                  right: Sizes.width_1_5,
                  left: Sizes.width_1_5,*/
              // child: _editableTextTitleAndOtherWeekWeb(
              child: editableCalStepWeekWeb(
                  mainIndex, logic, titleType, dataList, logic.trackingPrefList,context,constraints,
                  onChangeData: (value) {
                    /*logic.onChangeCalStepWeeks(
                        mainIndex, value, dataList.titleName);*/
                    // setState(() {});
                  })
            // _editableText(),
          ),
          // return (logic.dataList[mainIndex].isExpanded)
          (dataList.isExpanded)
              ? ListView.builder(
            itemBuilder: (context, daysIndex) {
              return _itemCalStepDaysWeb(
                  daysIndex,
                  context,
                  dataList.daysList,
                  logic,
                  mainIndex,
                  titleType,constraints);
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

  _itemDaysStrengthWeekWeb(int mainIndex,
      BuildContext context,
      OtherTitles2CheckBoxWeek dataList,
      HistoryController logic,
      String titleType,BoxConstraints constraints) {
    return Container(
      margin: const EdgeInsets.all(0),
      child: Column(
        children: [
          Container(
              height: AppFontStyle.commonHeightForTrackingChartBodyWeb(constraints),

            // height: Sizes.height_9,
            //   height: Constant.commonHeightForTableBoxWeb,
              child: Container(
                padding: EdgeInsets.only(bottom: Sizes.height_1),
                child: _editableTextTitle2CheckBoxWeekWeb(
                    mainIndex, logic, dataList,context,constraints,onChangeData: (value) {
                  // logic.onChangeDaysStrWeek(
                  //     mainIndex, value, dataList.titleName);
                }),
              )),
          (dataList.isExpanded)
              ? ListView.builder(
            itemBuilder: (context, daysIndex) {
              return _itemDaysStrengthDaysWeek(
                  daysIndex,
                  context,
                  dataList.daysListCheckBox,
                  logic,
                  mainIndex,
                  titleType,constraints);
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

  _itemDaysStrengthDaysWeek(int daysIndex,
      BuildContext context,
      List<OtherTitles2CheckBoxDay> daysListCheckBox,
      HistoryController logic,
      int mainIndex,
      String titleType,BoxConstraints constraints) {
    return (logic.trackingChartDataList[mainIndex]
        .dayLevelDataList[daysIndex].isShow)
        ? Column(
      children: [
        Utils.dividerCustom(),
        Container(
          height: AppFontStyle.commonHeightForTrackingChartBodyWeb(constraints),

/*          padding: EdgeInsets.only(
            right: Utils.sizesWidthManage(context, 0.6),
            left: Utils.sizesWidthManage(context, 0.1),
          ),
          // height: Sizes.height_10,
          height: Constant.commonHeightForTableBoxWeb,*/
          child: Checkbox(
            value: daysListCheckBox[daysIndex].isCheckedDay,
            /*onChanged: (!Constant.isEditMode || Constant.configurationInfo.where((element) => element.isDaysStr )
                    .toList().isEmpty )
                ? null
                : (value) {
              logic.onChangeDaysStrengthCheckBoxDay(
                  mainIndex, daysIndex);
            },
*/
            // onChanged: (!Constant.isEditMode || Constant.configurationInfo
            //     .where((element) => element.isDaysStr)
            //     .toList()
            //     .isEmpty) ? null : (value) {
            //   logic.onChangeDaysStrengthCheckBoxDay(mainIndex, daysIndex);
            // },
            onChanged:null
          ),
        ),
        (daysListCheckBox[daysIndex].isExpanded)
            ? ListView.builder(
          itemBuilder: (context, daysDataIndex) {
            return _itemDaysStrengthDaysDataWeb(
                daysIndex,
                context,
                daysListCheckBox[daysIndex].daysDataListCheckBox,
                logic,
                mainIndex,
                daysDataIndex,
                titleType,constraints);
          },
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: daysListCheckBox[daysIndex]
              .daysDataListCheckBox
              .length,
          physics: const NeverScrollableScrollPhysics(),
        )
            : Container(),
      ],
    )
        : Container();
  }

  _itemDaysStrengthDaysDataWeb(int daysIndex,
      BuildContext context,
      List<OtherTitles2CheckBoxDaysData> daysDataListCheckBox,
      HistoryController logic,
      int mainIndex,
      int daysDataIndex,
      String titleType,BoxConstraints constraints) {
    try {
      return SizedBox(
        height: AppFontStyle.commonHeightForTrackingChartBodyWeb(constraints),
        /*child: Checkbox(
          value: daysDataListCheckBox[daysDataIndex].isCheckedDaysData,
          // onChanged: (logic.trackingChartDataList[mainIndex]
          //     .dayLevelDataList[daysIndex].activityLevelDataList.isNotEmpty) ?
          // (!Constant.isEditMode || Constant.configurationInfo.where((element) =>
          // element.title ==
          //     logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
          //         .activityLevelDataList[daysDataIndex].displayLabel &&
          //     element.isDaysStr)
          //     .toList()
          //     .isNotEmpty) ? (value) {
          //   logic.onChangeDaysStrengthCheckBoxDaysData(
          //       mainIndex, daysIndex, daysDataIndex);
          // } : null : (value) {}
          onChanged: null,
        ),*/
      );
    } catch (e) {
      return SizedBox(
        height: AppFontStyle.commonHeightForTrackingChartBodyWeb(constraints),
        /*child: Checkbox(
          value: daysDataListCheckBox[daysDataIndex].isCheckedDaysData,
          *//*onChanged: (value) {
            logic.onChangeDaysStrengthCheckBoxDaysData(
                mainIndex, daysIndex, daysDataIndex);
          },*//*
          onChanged: null,
        ),*/
      );
    }
    /*return Container(
      padding: EdgeInsets.only(
        right: Sizes.width_1_5,
        left: Sizes.width_1_5,
      ),
      // height: Sizes.height_10,
      height: Constant.commonHeightForTableBoxWeb,
      child: Checkbox(
        value: daysDataListCheckBox[daysDataIndex].isCheckedDaysData,
        onChanged: (!Constant.isEditMode ||
            Constant.configurationInfo.where((element) =>
            element.title ==
                logic.activityMinDataList[mainIndex]
                    .weekDaysDataList[daysIndex].daysDataList[daysDataIndex]
                    .displayLabel &&
                element.isDaysStr)
                .toList()
                .isEmpty)
            ? null
            : (value) {
          logic.onChangeDaysStrengthCheckBoxDaysData(
              mainIndex, daysIndex, daysDataIndex);
          // setState(() {});
        },
      ),
    );*/
  }

  Widget _editableTextTitle2CheckBoxWeekWeb(int index,
      HistoryController logic, OtherTitles2CheckBoxWeek dataList,BuildContext context,BoxConstraints constraints,
      {Function? onChangeData}) {
    return SizedBox(
      child: TextField(
        textAlign: TextAlign.right,
        enabled: (Constant.isEditMode && Constant.configurationInfo
            .where((element) => element.isDaysStr)
            .toList()
            .isNotEmpty),
        // cursorHeight: Utils.sizesHeightManage(context, 8.0),
        enableInteractiveSelection: false,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: AppFontStyle.commonFontSizeBodyWeb(constraints)),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r"\d+([\.]\d+)?")),
        ],
        maxLines: 1,
        autofocus: false,
        autocorrect: true,
        controller: dataList.weekValueTitle2CheckBoxController,
        onChanged: (value) {
          if (onChangeData != null) {
            onChangeData.call(value);
          }
        },
      ),
    );
  }

  _itemCalStepDaysWeb(int daysIndex,
      BuildContext context,
      List<CaloriesStepHeartRateDay> weekDaysDataList,
      HistoryController logic,
      int mainIndex,
      String titleType,BoxConstraints constraints) {
    return (logic.trackingChartDataList[mainIndex]
        .dayLevelDataList[daysIndex].isShow)
        ? Column(
      children: [
        Column(
          children: [
            Utils.dividerCustom(),
            Container(
                height: AppFontStyle.commonHeightForTrackingChartBodyWeb(constraints),

/*                padding: EdgeInsets.only(
                    right: Utils.sizesWidthManage(context, 0.6),
                    left: Utils.sizesWidthManage(context, 0.1),
                    bottom: Sizes.height_1
                ),
                // padding: EdgeInsets.only(
                // right: Sizes.width_1_5,
                // left: Sizes.width_1_5,
                // height: Sizes.height_10,
                height: Constant.commonHeightForTableBoxWeb,*/
                // child: _editableTextTitle2AndOtherDaysWeb(
                child: editableCalStepDayWeb(daysIndex, logic,
                    weekDaysDataList[daysIndex], onChangeData: (value) {
                      /*logic.onChangeCalStepDay(
                            mainIndex,
                            daysIndex,
                            value,
                            weekDaysDataList[daysIndex].titleName,
                            titleType);*/

                    }, mainIndex, titleType, logic.trackingPrefList,context,constraints)
              // _editableText(),
            ),
          ],
        ),
        // (weekDaysDataList[daysIndex].daysDataList.isNotEmpty &&
        (weekDaysDataList[daysIndex].daysDataList.isNotEmpty &&
            weekDaysDataList[daysIndex].isExpanded)
            ? ListView.builder(
          itemBuilder: (context, daysDataIndex) {
            return Container(
              // height: Sizes.height_10,
                height: AppFontStyle.commonHeightForTrackingChartBodyWeb(constraints),
                // margin: EdgeInsets.symmetric(
                //     horizontal: Sizes.width_1_5),
                child: Container(
                  padding: EdgeInsets.only(bottom: Sizes.height_1),
                  // child: _editableTextTitle2AndOtherDaysDataWeb(
                  child: (titleType == Constant.titleCalories)
                      ? editableCalStepDayDataWeb(
                      daysDataIndex,
                      logic,
                      mainIndex,
                      daysIndex,
                      titleType,
                      weekDaysDataList[daysIndex]
                          .daysDataList[daysDataIndex],context,constraints,
                      onChangeData: (value) {
                        /*logic.onChangeCountOtherDaysData(
                                    mainIndex,
                                    daysIndex,
                                    daysDataIndex,
                                    value,
                                    titleType);*/
                      })
                      : editableCalStepDayDataWebStep(
                      daysDataIndex,
                      logic,
                      mainIndex,
                      daysIndex,
                      titleType,
                      weekDaysDataList[daysIndex]
                          .daysDataList[daysDataIndex],context,constraints,
                      onChangeData: (value) {
                        /*logic.onChangeCountOtherDaysData(
                                        mainIndex,
                                        daysIndex,
                                        daysDataIndex,
                                        value,
                                        titleType);*/
                      }),
                )
              // _editableText(),
            );
          },
          shrinkWrap: true,
          itemCount:
          weekDaysDataList[daysIndex].daysDataList.length,
          physics: const NeverScrollableScrollPhysics(),
        )
            : Container(
          padding: EdgeInsets.zero,
        ),
      ],
    )
        : Container();
  }

  _itemHeartRateWeekWeb(int mainIndex,
      BuildContext context,
      CaloriesStepHeartRateWeek otherTitle5Data,
      CaloriesStepHeartRateWeek otherTitle6Data,
      HistoryController logic,
      String titleType, String columnName,BoxConstraints constraints) {
    return Container(
      margin: const EdgeInsets.all(0),
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.only(
                  bottom: Sizes.height_1
              ),
              height: AppFontStyle.commonHeightForTrackingChartBodyWeb(constraints),
              child: Row(
                children: [
                  if (logic.trackingPrefList.where((element) =>
                  element.titleName == Constant.configurationHeaderRest &&
                      element.isSelected)
                      .toList()
                      .isNotEmpty
                      && columnName == Constant.configurationHeaderRest)
                    Expanded(
                      // child: _editableTextTitle5Value1WeekWeb(
                      child: editableRestWeekWeb(
                          mainIndex, logic, otherTitle5Data,
                          logic.trackingPrefList,context,constraints,
                          onChangeData: (value) {
                            /*logic.onChangeCalStepWeeks(
                          //  mainIndex, value, otherTitle5Data.titleName);
                          mainIndex,
                          value,
                          Constant.titleHeartRateRest);*/

                            // setState(() {});
                          }),
                    ),
                  // const Spacer(),
                  // SizedBox(
                  //   width: Utils.sizesWidthManage(context, 2.5),
                  // ),
                  if (logic.trackingPrefList.where((element) =>
                  element.titleName == Constant.configurationHeaderPeck &&
                      element.isSelected)
                      .toList()
                      .isNotEmpty
                      && columnName == Constant.configurationHeaderPeck)
                    Expanded(
                      // child: _editableTextTitle5Value2WeekWeb(
                      child: editablePeakWeekWeb(
                          mainIndex, logic, otherTitle6Data,
                          logic.trackingPrefList,context,constraints,
                          onChangeData: (value) {
                            /*logic.onChangeCalStepWeeks(
                          mainIndex, value, Constant.titleHeartRatePeak);
*/
                          }),
                    ),
                ],
              )
            // _editableText(),
          ),
          (otherTitle5Data.isExpanded)
              ? ListView.builder(
            itemBuilder: (context, daysIndex) {
              return _itemHeartRateDayDay(
                  daysIndex,
                  context,
                  otherTitle5Data.daysList,
                  otherTitle6Data.daysList,
                  logic,
                  mainIndex,
                  titleType,
                  columnName,constraints);
            },
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: otherTitle5Data.daysList.length,
            physics: const NeverScrollableScrollPhysics(),
          )
              : Container(),
          Utils.dividerCustom(),
        ],
      ),
    );
  }

  _itemHeartRateDayDay(int daysIndex,
      BuildContext context,
      List<CaloriesStepHeartRateDay> weekDaysDataListTitle5,
      List<CaloriesStepHeartRateDay> weekDaysDataListTitle6,
      HistoryController logic,
      int mainIndex,
      String titleType, String columnName,BoxConstraints constraints) {
    return (logic.trackingChartDataList[mainIndex]
        .dayLevelDataList[daysIndex].isShow)
        ? Column(
      children: [
        Column(
          children: [
            Utils.dividerCustom(),
            Container(
                height: AppFontStyle.commonHeightForTrackingChartBodyWeb(constraints),
                padding: EdgeInsets.only(
                    bottom: Sizes.height_1
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
                        // child: _editableTextTitle5Value1DayWeb(
                        child: editableRestDayDayWeb(
                            mainIndex,
                            logic,
                            weekDaysDataListTitle5[daysIndex],
                            logic.trackingPrefList,context,constraints,
                            onChangeData: (value) {
                              /*logic.onChangeCalStepDay(
                                  mainIndex,
                                  daysIndex,
                                  value,
                                  weekDaysDataListTitle5[daysIndex].titleName,
                                  Constant.titleHeartRateRest);*/

                              // titleType);
                            }),
                      ),
                    // SizedBox(
                    //   width: Sizes.width_2,
                    // ),
                    if (logic.trackingPrefList.where((element) =>
                    element.titleName == Constant.configurationHeaderPeck &&
                        element.isSelected)
                        .toList()
                        .isNotEmpty &&
                        columnName == Constant.configurationHeaderPeck)
                      Expanded(
                        // child: _editableTextTitle5Value2DayWeb(
                        child: editablePeakDayDayWeb(
                            mainIndex,
                            logic,
                            weekDaysDataListTitle6[daysIndex],
                            logic.trackingPrefList,context,constraints,
                            onChangeData: (value) {
                              /*logic.onChangeCalStepDay(
                                  mainIndex,
                                  daysIndex,
                                  value,
                                  weekDaysDataListTitle6[daysIndex].titleName,
                                  Constant.titleHeartRatePeak);*/

                              // titleType);
                            }),
                      ),
                  ],
                )
              // _editableText(),
            ),
          ],
        ),
        (weekDaysDataListTitle5[daysIndex].daysDataList.isNotEmpty &&
            weekDaysDataListTitle5[daysIndex].isExpanded)
            ? ListView.builder(
          itemBuilder: (context, daysDataIndex) {
            return Container(
              // height: Sizes.height_10,
                height: AppFontStyle.commonHeightForTrackingChartBodyWeb(constraints),
                padding: EdgeInsets.only(
                    bottom: Sizes.height_1
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
                        // child: _editableTextTitle5Value1DayDataWeb(
                        child: editableRestDayDataWeb(
                            mainIndex,
                            daysIndex,
                            daysDataIndex,
                            logic,
                            weekDaysDataListTitle5[daysIndex]
                                .daysDataList[daysDataIndex],context,constraints,
                            onChangeData: (value) {
                              /*logic.onChangeCountOtherDaysData(
                                        mainIndex,
                                        daysIndex,
                                        daysDataIndex,
                                        value,
                                        Constant.titleHeartRateRest);*/
                              // titleType);
                            }),
                      ),
                    // SizedBox(
                    //   width: Sizes.width_2,
                    // ),
                    if (logic.trackingPrefList.where((element) =>
                    element.titleName == Constant.configurationHeaderPeck &&
                        element.isSelected)
                        .toList()
                        .isNotEmpty &&
                        columnName == Constant.configurationHeaderPeck)
                      Expanded(
                        // child: _editableTextTitle5Value2DayDataWeb(
                        child: editablePeakDayDataWeb(
                            mainIndex,
                            daysIndex,
                            daysDataIndex,
                            logic,
                            weekDaysDataListTitle6[daysIndex]
                                .daysDataList[daysDataIndex],context,constraints,
                            onChangeData: (value) {
                              /*logic.onChangeCountOtherDaysData(
                                mainIndex,
                                daysIndex,
                                daysDataIndex,
                                value,
                                Constant.titleHeartRatePeak);*/
                              // setState(() {});
                              // titleType);
                            }),
                      ),
                  ],
                )
              // _editableText(),
            );
          },
          shrinkWrap: true,
          itemCount:
          weekDaysDataListTitle5[daysIndex].daysDataList.length,
          physics: const NeverScrollableScrollPhysics(),
        )
            : Container(
          padding: EdgeInsets.zero,
        ),
      ],
    )
        : Container();
  }

  bottomAddNotesView(BuildContext context, HistoryController logic, int type,
      int mainIndex, int daysIndex, int daysDataIndex) {
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
                content: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.3,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
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
                              CColor.black, FontSize.size_3),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(
                            left: Sizes.height_2,
                            right: Sizes.height_2,
                            top: Sizes.height_2,
                            bottom: Sizes.height_2),
                        decoration: BoxDecoration(
                            border: Border.all(color: CColor.black, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        /*child: TextField(
                          cursorHeight: Constant.cursorHeightForWeb,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              fontSize: Constant.webTextFiledTextSize),
                          maxLines: 5,
                          controller: logic.notesController,
                        ),*/
                        child: HtmlWidget(
                          logic.notesController.text.toString(),
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
                          textStyle:  TextStyle(fontSize: Constant.webTextFiledTextSize),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: Sizes.height_2,
                            right: Sizes.height_2,
                            top: Sizes.height_2,
                            bottom: Sizes.height_2),
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
                                  margin: EdgeInsets.only(right: Sizes.width_1),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.only(
                                    // left: Sizes.width_6,
                                    // right: Sizes.width_6,
                                      top: Sizes.height_1,
                                      bottom: Sizes.height_1),
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                        color: CColor.black,
                                        fontSize: FontSize.size_3_5),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            /*Expanded(
                              child: InkWell(
                                onTap: () {
                                  logic.insertUpdateWeekNotesData(
                                      mainIndex,
                                      daysIndex,
                                      daysDataIndex,
                                      logic.notesController.text,
                                      type);
                                  Get.back();
                                  setStateBottom(() {});
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: Sizes.width_1),
                                  decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(10),
                                      color: CColor.black),
                                  padding: EdgeInsets.only(
                                    // left: Sizes.width_6,
                                    // right: Sizes.width_6,
                                      top: Sizes.height_1,
                                      bottom: Sizes.height_1),
                                  child: Text(
                                    "Add",
                                    style: TextStyle(
                                        color: CColor.white,
                                        fontSize: FontSize.size_3_5),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),*/
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
      // setState(() {});
    });
  }


  Future<void> selectFromAndToDate(BuildContext context, DateTime startDate,
      DateTime endDate,
      String activityName, List<DayLevelData> weekDaysDataList,
      int mainIndex, int daysIndex, int daysDataIndex, HistoryController logic,
      Function callBackStartDate, Function callBackEndDate,BoxConstraints constraints) async {
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
                              top: AppFontStyle.sizesHeightManageWeb(1.2,constraints), left: AppFontStyle.sizesWidthManageWeb(1.3,constraints)),
                          child: Text(
                            activityName,
                            style: TextStyle(
                              fontSize: AppFontStyle.commonFontSizeBodyWeb(constraints) * 1.2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical:AppFontStyle.sizesHeightManageWeb(1.2,constraints),
                              horizontal:  AppFontStyle.sizesWidthManageWeb(1.3,constraints)),
                          child: Row(
                            children: [
                              const Text('Starts'),
                              // const Spacer(),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    selectDateTime(
                                        context, false, startDate, endDate, constraints,(
                                        dateTime) {
                                      setState(() {
                                        startDate = dateTime;
                                        callBackStartDate.call(startDate);
                                      });
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: AppFontStyle.sizesHeightManageWeb(1.2,constraints)),
                                    decoration: BoxDecoration(
                                        color: CColor.greyF8,
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      // DateFormat(Constant.commonDateFormatFullDate).format(startDate),
                                      DateFormat.yMMMd().add_jm().format(
                                          startDate),
                                      // style: TextStyle(fontSize: FontSize.size_12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        /* Container(
                          margin: EdgeInsets.only(bottom: Sizes.height_2,
                              left: Sizes.width_4,
                              right: Sizes.width_4),
                          child: Row(
                            children: [
                              const Text('Ends  '),
                              // const Spacer(),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    selectDateTime(
                                        context, true, startDate, endDate, (
                                        dateTime) {
                                      setState(() {
                                        endDate = dateTime;
                                        callBackEndDate.call(endDate);
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
                                          endDate),
                                      // style: TextStyle(fontSize: FontSize.size_12),
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
                              bottom:  AppFontStyle.sizesHeightManageWeb(1.5,constraints), right: AppFontStyle.sizesWidthManageWeb(1.5,constraints)),
                          child: Row(
                            children: [
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  logic.resetLastDate(
                                      weekDaysDataList, daysIndex,
                                      daysDataIndex, startDate
                                      , endDate);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: AppFontStyle.sizesWidthManageWeb(2.0,constraints)),
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              /*GestureDetector(
                                onTap: () async {
                                  // var activityEndaDate = weekDaysDataList[daysIndex]
                                  //     .activityLevelDataList[daysDataIndex]
                                  //     .activityEndDate;

                                  var activityStartDate = weekDaysDataList[daysIndex]
                                      .activityLevelDataList[daysDataIndex]
                                      .activityStartDate;

                                  var activityEndaDate = activityStartDate.add(Duration(minutes: weekDaysDataList[daysIndex]
                                      .activityLevelDataList[daysDataIndex].totalMinValue ?? 1));

                                  Debug.printLog("Total min from start date.....${weekDaysDataList[daysIndex]
                                      .activityLevelDataList[daysDataIndex].totalMinValue ?? 1}  $activityEndaDate  $activityStartDate");

                                  // var activityEndaDateLast = weekDaysDataList[daysIndex]
                                  //     .activityLevelDataList[daysDataIndex]
                                  //     .activityEndDateLast;
                                  //
                                  // var activityStartDateLast = weekDaysDataList[daysIndex]
                                  //     .activityLevelDataList[daysDataIndex]
                                  //     .activityStartDateLast;

                                  var getTotalMinFromTwoDates = Utils.getTotalMinFromTwoDates(
                                      activityStartDate,activityEndaDate);
                                  if(int.parse(getTotalMinFromTwoDates) >= 0 ) {
                                    var listOfLastData = weekDaysDataList[daysIndex]
                                        .activityLevelDataList;

                                    *//*var dataIsInWithoutAnotherData = listOfLastData.where((element) =>
                                        Utils.isBetween(element.activityStartDate, element.activityEndDate,
                                            activityStartDate, activityEndaDate)
                                    ).toList().isEmpty;*//*

                                    var dataIsInWithoutAnotherData = Utils.checkDateOverlap(listOfLastData,
                                        activityStartDate,activityEndaDate,
                                        currentActivityData: weekDaysDataList[daysIndex]
                                            .activityLevelDataList[daysDataIndex]);

                                    if(dataIsInWithoutAnotherData){
                                      Utils.showToast(Get.context!, "You have to select unique date");
                                    }else {
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
                                          weekDaysDataList, mainIndex,
                                          daysIndex,
                                          daysDataIndex, true,
                                          activityStartDate,
                                          activityEndaDate);
                                    }
                                  }else{
                                    Utils.showToast(context, "Invalid dates");
                                  }
                                },
                                child: const Text(
                                  "Select",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),*/
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

  Future<void> selectDateTime(BuildContext context, bool isEndDate,
      DateTime fromDate, DateTime toDate,BoxConstraints constraints,
      Function callBack) async {
    var tempDate = DateTime.now();
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, setStateDialog) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Wrap(
                    children: [
                      Container(
                        // margin: EdgeInsets.only(
                        //   left: Sizes.width_10,right: Sizes.width_10
                        // ),
                        // alignment: Alignment.bottomCenter,
                        color: CColor.white,
                        // width: Utils.sizesWidthManage(context, 50.0),
                        child: Column(
                          children: [
                            Container(
                              height: Sizes.height_30,
                              padding: EdgeInsets.zero,
                              // width: Sizes.width_30,
                              width: double.infinity,
                              margin: EdgeInsets.zero,
                              child: CupertinoTheme(
                                data: CupertinoThemeData(
                                  textTheme: CupertinoTextThemeData(
                                    dateTimePickerTextStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: AppFontStyle.commonFontSizeBodyWeb(constraints),
                                    ),
                                  ),
                                ),
                                child: CupertinoDatePicker(
                                  mode: CupertinoDatePickerMode.time,
                                  initialDateTime: (isEndDate) ? toDate : fromDate,
                                  backgroundColor: CColor.white,
                                  onDateTimeChanged: (DateTime dateTime) {
                                    setStateDialog((){
                                      tempDate = dateTime;
                                      logic.update();
                                      Debug.printLog("date......$tempDate");
                                    });
                                  },
                                ),
                              ),
                            ),
                            Container(
                              // alignment: Alignment.bottomRight,
                              color: CColor.white,
                              margin: EdgeInsets.only(
                                  bottom: Sizes.height_2, right: Sizes.width_4),
                              child: Row(
                                children: [
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: Sizes
                                          .height_2),
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          color: CColor.black,
                                          // fontSize: FontSize.size_12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setStateDialog((){
                                        callBack.call(tempDate);
                                        Get.back();
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: Sizes.width_2,
                                          right: Sizes.width_3,
                                          bottom: Sizes.height_2),
                                      child: Text(
                                        "Select",
                                        style: TextStyle(
                                          color: CColor.black,
                                          // fontSize: FontSize.size_12,
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
            });
      },
    );
  }

/*  Future<void> selectDateWithActivityChoose(BuildContext context,
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
                              top: Sizes.height_2, left: Sizes.width_2),
                          child: Text(
                            activityName,
                            style: TextStyle(
                              fontSize: FontSize.size_6,
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
                                      // style: TextStyle(fontSize: FontSize.size_6),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        *//*Container(
                          margin: EdgeInsets.only(bottom: Sizes.height_1,
                              left: Sizes.width_4,
                              right: Sizes.width_4),
                          child: Row(
                            children: [
                              const Text('Ends  '),
                              // const Spacer(),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    selectDateTimeWithActivityChoose(
                                        context, true, activityStartDate,
                                        activityEndDate, (dateTime) {
                                      setState(() {
                                        activityEndDate = dateTime;
                                        callBackEndDate.call(activityEndDate);
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
                                          activityEndDate),
                                      // style: TextStyle(fontSize: FontSize.size_6),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),*//*
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

                                  *//* var getTotalMinFromTwoDates = Utils.getTotalMinFromTwoDates(
                                      activityStartDate,activityEndaDate);

                                  await logic.updateTotalMinAtActivityLevel(
                                      DateFormat(Constant.commonDateFormatDdMmYyyy)
                                          .format(weekDaysDataList[daysIndex]
                                          .activityLevelDataList[daysDataIndex].storedDate!)
                                      ,activityName,activityStartDate,activityEndaDate,
                                      getTotalMinFromTwoDates,mainIndex,daysIndex,daysDataIndex);

                                  logic.update();

                                  logic.updateDeleteActivityWhenChangeTime(weekDaysDataList,mainIndex,daysIndex,daysDataIndex );*//*
                                  activityEndDate = activityStartDate.add(const Duration(minutes: 1));

                                  var getTotalMinFromTwoDates =
                                  Utils.getTotalMinFromTwoDates(
                                      activityStartDate, activityEndDate);


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
                                  }else{
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
  }*/

  Future<void> selectDateTimeWithActivityChoose(BuildContext context,
      bool isEndDate, DateTime fromDate, DateTime toDate,
      Function callBack,BoxConstraints constraints) async {
    var tempDate = DateTime.now();
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: StatefulBuilder(
            builder: (BuildContext context, setStateDialog) {
              return Center(
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
                            width: Sizes.width_30,
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
                                initialDateTime: (isEndDate)
                                    ? toDate
                                    : fromDate,
                                backgroundColor: CColor.white,
                                onDateTimeChanged: (DateTime dateTime) {
                                  setStateDialog(() {
                                    tempDate = dateTime;
                                    Debug.printLog("date......$tempDate");
                                    logic.update();
                                  });

                                },
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            color: CColor.white,
                            margin: EdgeInsets.only(
                                bottom:  AppFontStyle.sizesHeightManageWeb(1.5,constraints), right: AppFontStyle.sizesWidthManageWeb(1.5,constraints)),
                            child: Row(
                              children: [
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: AppFontStyle.sizesWidthManageWeb(2.0,constraints)),
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                        color: CColor.black,
                                        // fontSize: FontSize.size_12,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setStateDialog(() {
                                      callBack.call(tempDate);
                                      Get.back();
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: Sizes.width_2,
                                        right: Sizes.width_3,
                                        bottom: Sizes.height_2),
                                    child: Text(
                                      "Select",
                                      style: TextStyle(
                                        color: CColor.black,
                                        // fontSize: FontSize.size_12,
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
              );
            },
          ),
        );
      },
    );
  }

}
