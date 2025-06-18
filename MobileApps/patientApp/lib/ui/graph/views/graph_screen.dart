import 'package:banny_table/ui/bottomNavigation/controllers/bottom_navigation_controller.dart';
import 'package:banny_table/ui/graph/controllers/graph_controller.dart';
import 'package:banny_table/ui/graph/datamodel/graphDatamodel.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../utils/font_style.dart';
import '../../../utils/sizer_utils.dart';
import '../../../utils/utils.dart';

class GraphScreen extends StatelessWidget {
  BottomNavigationController? bottomNavigationController;

  GraphScreen({Key? key, @required this.bottomNavigationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColor.white,
      body: GetBuilder<GraphController>(
          init: GraphController(),
          assignId: true,
          builder: (logic) {
            return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return SafeArea(
                child: Column(
                  children: [
                    (kIsWeb)
                        ? Container(
                            margin: EdgeInsets.only(top: Sizes.height_2),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // _widgetActivityDropDown(context,logic),
                                // _widgetMeasureDropDown(context,logic),
                                // _widgetTimeDropDown(context,logic),
                                Expanded(
                                    child:
                                        _widgetMeasureDropDown(context, logic,constraints)),
                                Expanded(
                                    child: _widgetTimeDropDown(context, logic,constraints)),
                                // _widgetTimeFrameDropDown(context,logic),
                              ],
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.only(top: Sizes.height_1_5),
                            child: Row(
                              children: [
                                // Expanded(child: _widgetActivityDropDown(context,logic)),
                                Expanded(
                                    child:
                                        _widgetMeasureDropDown(context, logic,constraints)),
                                Expanded(
                                    child: _widgetTimeDropDown(context, logic,constraints)),
                              ],
                            ),
                          ),
                    if (Constant.listOfMeaSure.isNotEmpty)
                      getGraphDetalis(logic, constraints),
                    (Constant.listOfMeaSure.isNotEmpty)
                        ? Expanded(
                            child: Container(
                              height:
                                  (kIsWeb) ? Sizes.height_60 : Sizes.height_50,
                              margin: EdgeInsets.only(top: Sizes.height_1),
                              child: SfCartesianChart(
                                enableAxisAnimation: false,
                                // Enable axis clip to allow scrolling
                                primaryXAxis: CategoryAxis(
                                  labelStyle: TextStyle(
                                      fontSize: (kIsWeb)
                                          ? FontSize.size_4
                                          : FontSize.size_8),
                                ),
                                primaryYAxis: NumericAxis(
                                  labelStyle: TextStyle(
                                      fontSize: (kIsWeb)
                                          ? FontSize.size_4
                                          : FontSize.size_8),
                                ),
                                // Y-axis for vertical scrolling
                                tooltipBehavior: TooltipBehavior(
                                  enable: true,
                                  builder: (data, point, series, pointIndex,
                                      seriesIndex) {
                                    return Container(
                                      margin: EdgeInsets.all(10),
                                      child: Wrap(
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                Utils.getSeriesMeasureType(
                                                    /*(Constant.listOfMeaSure[Constant.selectedRadioValue].titleName ==
                                                        Constant.heartRate && Constant.selectedTime == Constant.timeDay)
                                                        ? logic.chartHeartPeak
                                                        : */logic.chartDataList,
                                                    pointIndex,
                                                    seriesIndex,
                                                    series,
                                                    data,
                                                    point,
                                                    Constant
                                                        .listOfMeaSure[Constant
                                                            .selectedRadioValue]
                                                        .titleName),
                                                style: const TextStyle(
                                                  color: CColor.white,
                                                ),
                                              ),
                                              Container(
                                                width: 50,
                                                child: const Divider(
                                                    color: CColor.white),
                                              ),
                                              Container(
                                                child: Text(
                                                  Utils.getSeriesDate(
                                                      /*(Constant.listOfMeaSure[Constant.selectedRadioValue].titleName ==
                                                          Constant.heartRate && Constant.selectedTime == Constant.timeDay)
                                                          ? logic.chartHeartPeak :*/logic.chartDataList,
                                                      pointIndex,
                                                      seriesIndex,
                                                      series,
                                                      data,
                                                      point,
                                                      Constant
                                                          .listOfMeaSure[Constant
                                                              .selectedRadioValue]
                                                          .titleName),
                                                  style: const TextStyle(
                                                    color: CColor.white,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  Utils.getSeriesValue(
                                                      /*(Constant.listOfMeaSure[Constant.selectedRadioValue].titleName ==
                                                          Constant.heartRate && Constant.selectedTime == Constant.timeDay)
                                                          ? logic.chartHeartPeak : */logic.chartDataList,
                                                      pointIndex,
                                                      seriesIndex,
                                                      series,
                                                      data,
                                                      point,
                                                      Constant
                                                          .listOfMeaSure[Constant
                                                              .selectedRadioValue]
                                                          .titleName),
                                                  style: const TextStyle(
                                                    color: CColor.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                zoomPanBehavior: ZoomPanBehavior(
                                  enablePinching: true,
                                  enableDoubleTapZooming: true,
                                  enableMouseWheelZooming: true,
                                ),
                                // title: ChartTitle(text: 'Line and Step Line Chart'),
                                series: <CartesianSeries>[
                                  if (logic.lineChart1)
                                    LineSeries<ChartData, String>(
                                        color: CColor.primaryColor,
                                        dataSource: logic.chartDataList,
                                        xValueMapper: (ChartData data, _) =>
                                            data.x,
                                        yValueMapper: (ChartData data, _) =>
                                            data.y1,
                                        enableTooltip: true,
                                        markerSettings: MarkerSettings(
                                            isVisible: (logic.chartDataList
                                                    .where((element) =>
                                                        element.y1 != 0)
                                                    .toList()
                                                    .isNotEmpty)
                                                ? true
                                                : false,
                                            color: CColor.primaryColor,
                                            width: (logic.chartDataList
                                                    .where((element) =>
                                                        element.y1 != 0.0)
                                                    .toList()
                                                    .isNotEmpty)
                                                ? 5
                                                : 0,
                                            height: (logic.chartDataList
                                                    .where((element) =>
                                                        element.y1 != 0.0)
                                                    .toList()
                                                    .isNotEmpty)
                                                ? 5
                                                : 0)),
                                  if (logic.lineChart2)
                                    LineSeries<ChartData, String>(
                                        color: CColor.qrColorGreen,
                                        dataSource: /*(Constant.listOfMeaSure[Constant.selectedRadioValue].titleName ==
                                                Constant.heartRate && Constant.selectedTime == Constant.timeDay)
                                            ? logic.chartHeartRate
                                            :*/ logic.chartDataList,
                                        xValueMapper: (ChartData data, _) =>
                                            data.x,
                                        yValueMapper: (ChartData data, _) =>
                                            data.y2,
                                        enableTooltip: true,
                                        markerSettings: MarkerSettings(
                                            isVisible: (/*((Constant.listOfMeaSure[Constant.selectedRadioValue].titleName ==
                                                Constant.heartRate && Constant.selectedTime == Constant.timeDay)
                                                ? logic.chartHeartRate
                                                :*/ logic.chartDataList.where((element) => element.y2 != 0)
                                                        .toList()
                                                        .isNotEmpty)
                                                ? true
                                                : false,
                                            color: CColor.qrColorGreen,
                                            width: ( (/*(Constant.listOfMeaSure[Constant.selectedRadioValue].titleName ==
                                                Constant.heartRate && Constant.selectedTime == Constant.timeDay)
                                                ? logic.chartHeartRate
                                                :*/ logic.chartDataList).where((element) => element.y2 != 0.0).toList().isNotEmpty) ? 5 : 0,
                                            height: (/*((Constant.listOfMeaSure[Constant.selectedRadioValue].titleName ==
                                                Constant.heartRate && Constant.selectedTime == Constant.timeDay)
                                                ? logic.chartHeartRate
                                                :*/ logic.chartDataList.where((element) => element.y2 != 0.0).toList().isNotEmpty) ? 5 : 0)),
                                  if (logic.lineChart3)
                                    LineSeries<ChartData, String>(
                                      color: CColor.txtBlue,
                                      dataSource: /*(Constant.listOfMeaSure[Constant.selectedRadioValue].titleName ==
                                          Constant.heartRate && Constant.selectedTime == Constant.timeDay)
                                          ? logic.chartHeartPeak
                                          :*/logic.chartDataList,
                                      xValueMapper: (ChartData data, _) =>
                                          data.x,
                                      yValueMapper: (ChartData data, _) =>
                                          data.y3,
                                      enableTooltip: true,
                                      markerSettings: MarkerSettings(
                                          isVisible: ((logic.chartDataList)
                                                  .where((element) =>
                                                      element.y3 != 0)
                                                  .toList()
                                                  .isNotEmpty)
                                              ? true
                                              : false,
                                          color: CColor.txtBlue,
                                          width: ((logic.chartDataList)
                                                  .where((element) =>
                                                      element.y3 != 0.0)
                                                  .toList()
                                                  .isNotEmpty)
                                              ? 5
                                              : 0,
                                          height: ((logic.chartDataList)
                                                  .where((element) =>
                                                      element.y3 != 0.0)
                                                  .toList()
                                                  .isNotEmpty)
                                              ? 5
                                              : 0),
                                    ),
                                  /*StepLineSeries<ChartData, String>(
                              color: CColor.black,
                              dataSource: logic.chartGoalDataList,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y1,
                              // markerSettings: MarkerSettings(isVisible: true),
                          ),*/
                                ],
                              ),
                            ),
                          )
                        : Expanded(
                            child: _emptyWidget(Constant.graphDataNotFind)),
                  ],
                ),
              );
            });
          }),
    );
  }

  _emptyWidget(String values) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: Sizes.width_5),
        child: Text(
          values.toString(),
          style: AppFontStyle.styleW500(
              CColor.black, (kIsWeb) ? FontSize.size_3 : FontSize.size_12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /* @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColor.white,
      body: SafeArea(
        child: Column(
          children: [
            _widgetActivityDropDown(context),
            _widgetMeasureDropDown(context),
            _widgetTimeDropDown(context),
            _widgetTimeFrameDropDown(context),
          ],
        ),
      ),
    );
  }*/

  _widgetActivityDropDown(BuildContext context, GraphController logic) {
    return Container(
      width: (kIsWeb) ? Sizes.width_16_5 : null,
      margin: EdgeInsets.symmetric(
          horizontal: (kIsWeb) ? Sizes.width_0_5 : Sizes.width_3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
                bottom: Sizes.height_1,
                top: Sizes.height_3,
                left: Sizes.width_2),
            child: Text(
              "Activity",
              style: AppFontStyle.styleW700(
                CColor.black,
                (kIsWeb) ? FontSize.size_3 : FontSize.size_10,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: (kIsWeb) ? Sizes.width_1_5 : Sizes.width_3,
                vertical: Sizes.height_1_5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: CColor.greyF8,
              border: Border.all(color: CColor.primaryColor, width: 0.7),
            ),
            child: DropdownButtonFormField<dynamic>(
              focusColor: Colors.white,
              decoration: const InputDecoration.collapsed(hintText: ''),
              value: logic.selectedActivity,
              //elevation: 5,
              style: const TextStyle(color: Colors.white),
              iconEnabledColor: Colors.black,
              items: Constant.configurationInfoGraphManage
                  .map<DropdownMenuItem>((value) {
                return DropdownMenuItem<String>(
                  value: value.title,
                  child: Text(
                    value.title,
                    style: AppFontStyle.styleW500(CColor.black,
                        (kIsWeb) ? FontSize.size_3 : FontSize.size_10),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                logic.onChangeActivityTimeAndFrameGraphData(
                    value ?? "", Constant.graphActivityType);
                // logic.onChangeLifeCycleStatus(value!);
                // Debug.printLog("lifecycle value...$value");
              },
            ),
          ),
        ],
      ),
    );
  }

  _widgetMeasureDropDown(BuildContext context, GraphController logic,BoxConstraints constraints) {
    return Container(
      width: (kIsWeb) ? double.infinity : null,
      // height: (kIsWeb) ? Sizes.height_8 : null,
      margin: EdgeInsets.symmetric(
          horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.7, constraints) : Sizes.width_3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              _widgetMeasureDialog(context, logic,constraints);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
                  vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.8, constraints) : Sizes.height_1_5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular((kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.9, constraints) :15),
                color: CColor.greyF8,
                border: Border.all(color: CColor.primaryColor, width: 0.7),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      // logic.selectedMeaSure,
                      Constant.listOfMeaSure.isNotEmpty
                          ? Constant.listOfMeaSure[Constant.selectedRadioValue]
                              .titleName
                          : "No Data",
                      overflow: TextOverflow.ellipsis,
                      style: AppFontStyle.styleW500(
                        CColor.black,
                        (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints) : FontSize.size_10,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down_rounded,
                    color: CColor.black,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _widgetTimeDropDown(BuildContext context, GraphController logic,BoxConstraints constraints) {
    return Container(
      width: (kIsWeb) ? double.infinity : null,
      // height: (kIsWeb) ? Sizes.height_8 : null,
      margin: EdgeInsets.symmetric(
          horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.7, constraints) : Sizes.width_3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.symmetric(
                  horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
                  vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.2, constraints) : Sizes.height_1_5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular((kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.9, constraints) :15),
                color: CColor.greyF8,
                border: Border.all(color: CColor.primaryColor, width: 0.7),
              ),
              child: (Constant.listOfMeaSure.isNotEmpty)
                  ? (Constant.listOfMeaSure[Constant.selectedRadioValue]
                              .titleName ==
                          Constant.experience)
                      ? Row(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: Sizes.height_0_1_5),
                              child: Text(
                                Constant.selectedTime,
                                style: AppFontStyle.styleW500(
                                    CColor.black,
                                  (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints) : FontSize.size_10,)

                              ),
                            ),
                          ],
                        )
                      : _widgetDropDownDatWeek(context, logic,constraints)
                  : _widgetDropDownDatWeek(context, logic,constraints)),
        ],
      ),
    );
  }

  _widgetDropDownDatWeek(BuildContext context, GraphController logic,BoxConstraints constraints) {
    return DropdownButtonFormField<String>(
      focusColor: Colors.white,
      decoration: const InputDecoration.collapsed(hintText: ''),
      value: Constant.selectedTime,
      style:  TextStyle(color: Colors.white),
      iconEnabledColor: Colors.black,
      items: Utils.timeList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: AppFontStyle.styleW500(
                CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints) : FontSize.size_10,),
          ),
        );
      }).toList(),
      onChanged: (value) {
        logic.onChangeActivityTimeAndFrameGraphData(
            value ?? "", Constant.graphTimeType);
        // logic.onChangeLifeCycleStatus(value!);
        // Debug.printLog("lifecycle value...$value");
      },
    );
  }

  _widgetTimeFrameDropDown(BuildContext context, GraphController logic) {
    return Container(
      width: (kIsWeb) ? Sizes.width_16_5 : null,
      margin: EdgeInsets.symmetric(
          horizontal: (kIsWeb) ? Sizes.width_0_5 : Sizes.width_3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
                bottom: Sizes.height_1,
                top: Sizes.height_3,
                left: Sizes.width_2),
            child: Text(
              "Time frame",
              style: AppFontStyle.styleW700(
                CColor.black,
                (kIsWeb) ? FontSize.size_3 : FontSize.size_10,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: (kIsWeb) ? Sizes.width_1_5 : Sizes.width_3,
                vertical: Sizes.height_1_5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: CColor.greyF8,
              border: Border.all(color: CColor.primaryColor, width: 0.7),
            ),
            child: DropdownButtonFormField<String>(
              focusColor: Colors.white,
              decoration: const InputDecoration.collapsed(hintText: ''),
              value: Constant.selectedTimeFrame,
              style: const TextStyle(color: Colors.white),
              iconEnabledColor: Colors.black,
              items: Utils.timeFrameList
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: AppFontStyle.styleW500(CColor.black,
                        (kIsWeb) ? FontSize.size_3 : FontSize.size_10),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                // logic.onChangeLifeCycleStatus(value!);
                // Debug.printLog("lifecycle value...$value");
                logic.onChangeActivityTimeAndFrameGraphData(
                    value ?? "", Constant.graphTimeFrameType);
              },
            ),
          ),
        ],
      ),
    );
  }

  _widgetMeasureDialog(BuildContext context, GraphController logic,BoxConstraints constraints) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateGraph) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
              content: SingleChildScrollView(
                child: Container(
                  // margin: const EdgeInsets.all(40),
                  width: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(10.0, constraints) : Get.width * 0.15,
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
                      (Constant.listOfMeaSure.isNotEmpty)
                          ? Container(
                        margin: EdgeInsets.only(left: (kIsWeb)
                            ? AppFontStyle.sizesWidthManageWeb(1.0, constraints)
                            : Sizes.width_2_5),
                              child: ListView.builder(
                                itemBuilder: (context, mainIndex) {
                                  return _itemMeasureData(
                                      logic,
                                      context,
                                      Constant.listOfMeaSure[mainIndex],
                                      mainIndex,
                                      setStateGraph,constraints);
                                },
                                shrinkWrap: true,
                                itemCount: Constant.listOfMeaSure.length,
                                physics: const NeverScrollableScrollPhysics(),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(bottom: Sizes.height_1_5),
                              child: Text("No Data"),
                            ),
                    ],
                  ),
                ),
              ),
              actions: [
                if (Constant.listOfMeaSure.isNotEmpty)
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
                            (kIsWeb) ? FontSize.size_3_5 : FontSize.size_12,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (Constant.listOfMeaSure.isNotEmpty) {
                            // logic.getGraphDataAndSetTimeFrame(Constant.listOfMeaSure[Constant.selectedRadioValue].titleName);
                            if (Constant
                                    .listOfMeaSure[Constant.selectedRadioValue]
                                    .titleName ==
                                Constant.experience) {
                              logic
                                  .experienceManage(Constant.graphAMeaSureType);
                            } else {
                              logic.onChangeActivityTimeAndFrameGraphData(
                                  "", Constant.graphAMeaSureType);
                            }
                          } else {
                            Debug.printLog("No Data Found");
                          }
                          // logic.onChangeTitleTapOnOk();
                          Get.back();
                        },
                        child: Text(
                          "Ok",
                          style: AppFontStyle.styleW600(
                            CColor.black,
                            (kIsWeb) ? FontSize.size_3_5 : FontSize.size_12,
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

  _itemMeasureData(GraphController logic, BuildContext context,
      ListOfMeaSure listOfMeaSure, int mainIndex, StateSetter setStateGraph,BoxConstraints constraints) {
    return Column(
      children: [
        Row(
          children: [
            /* Checkbox(
              value: logic.listOfMeaSure[mainIndex].isSelected,
              onChanged: (logic.listOfMeaSure
                  .where((element) => element.isSelected && logic.listOfMeaSure[mainIndex] != element)
                  .toList()
                  .isNotEmpty)
                  ? null
                  :(value) {
                logic.onChangeMeaSureData(mainIndex,-1);
                setStateGraph((){});
              },
            ),*/
            Radio(
              value: mainIndex,
              groupValue: Constant.selectedRadioValue,
              activeColor: CColor.primaryColor,
              onChanged: (value) {
                logic.onChangeRadioValue(mainIndex, true);
                setStateGraph(() {});
              },
            ),
            Text(
              listOfMeaSure.titleName.toString(),
              style: AppFontStyle.styleW700(CColor.black,
                  (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.1, constraints) : FontSize.size_12),
            ),
          ],
        ),
        if (Constant.listOfMeaSure[mainIndex].subList.isNotEmpty)
          Container(
            margin:
                EdgeInsets.only(
                    left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.8, constraints) : Sizes.width_5),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Checkbox(
                      value: Constant
                          .listOfMeaSure[mainIndex].subList[index].isSelected,
                      onChanged: (Constant.selectedRadioValue != mainIndex)
                          ? null
                          : (value) {
                              logic.onChangeMeaSureData(mainIndex, index);
                              setStateGraph(() {});
                            },
                    ),
                    Text(
                      listOfMeaSure.subList[index].subTitleName.toString(),
                      style: AppFontStyle.styleW500(CColor.black,
                          (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.1, constraints) : FontSize.size_10),
                    ),
                  ],
                );
              },
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: listOfMeaSure.subList.length,
            ),
          )
        else
          Container()
      ],
    );
  }

  getGraphDetalis(GraphController logic, BoxConstraints constraints) {
    return Container(
      alignment: Alignment.centerRight,
      margin: EdgeInsets.only(
          left: (kIsWeb) ? Get.width * 0.11 : Sizes.width_15,
          top: Sizes.height_1),
      child: (Constant.listOfMeaSure[Constant.selectedRadioValue].titleName ==
              Constant.activityMinutes)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          // Expanded(child: Container()),
                          Container(
                            width: (kIsWeb)
                                ? AppFontStyle.sizesWidthManageWeb(
                                    1.1, constraints)
                                : Sizes.width_3,
                            height: (kIsWeb)
                                ? AppFontStyle.sizesWidthManageWeb(
                                    1.1, constraints)
                                : Sizes.width_3,
                            color: CColor.txtBlue,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: Sizes.width_2),
                            child: Text(
                              "Mod",
                              style: TextStyle(
                                  fontSize: (kIsWeb)
                                      ? AppFontStyle.sizesFontManageWeb(
                                          1.1, constraints)
                                      : FontSize.size_13),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          // Expanded(child: Container()),
                          Container(
                            width: (kIsWeb)
                                ? AppFontStyle.sizesWidthManageWeb(
                                    1.1, constraints)
                                : Sizes.width_3,
                            height: (kIsWeb)
                                ? AppFontStyle.sizesWidthManageWeb(
                                    1.1, constraints)
                                : Sizes.width_3,
                            color: CColor.toastBackground,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: Sizes.width_2),
                            child: Text(
                              "Vig",
                              style: TextStyle(
                                  fontSize: (kIsWeb)
                                      ? AppFontStyle.sizesFontManageWeb(
                                          1.1, constraints)
                                      : FontSize.size_13),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          // Expanded(child: Container()),
                          Container(
                            width: (kIsWeb)
                                ? AppFontStyle.sizesWidthManageWeb(
                                    1.1, constraints)
                                : Sizes.width_3,
                            height: (kIsWeb)
                                ? AppFontStyle.sizesWidthManageWeb(
                                    1.1, constraints)
                                : Sizes.width_3,
                            color: CColor.primaryColor,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: Sizes.width_2),
                            child: Text(
                              "Total",
                              style: TextStyle(
                                  fontSize: (kIsWeb)
                                      ? AppFontStyle.sizesFontManageWeb(
                                          1.1, constraints)
                                      : FontSize.size_13),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )
          : (Constant.listOfMeaSure[Constant.selectedRadioValue].titleName ==
                  Constant.heartRate)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              // Expanded(child: Container()),
                              Container(
                                width: (kIsWeb)
                                    ? AppFontStyle.sizesWidthManageWeb(
                                        1.1, constraints)
                                    : Sizes.width_3,
                                height: (kIsWeb)
                                    ? AppFontStyle.sizesWidthManageWeb(
                                        1.1, constraints)
                                    : Sizes.width_3,
                                color: CColor.toastBackground,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: Sizes.width_2),
                                child: Text(
                                  "Rest",
                                  style: TextStyle(
                                      fontSize: (kIsWeb)
                                          ? AppFontStyle.sizesFontManageWeb(
                                              1.1, constraints)
                                          : FontSize.size_13),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              // Expanded(child: Container()),
                              Container(
                                width: (kIsWeb)
                                    ? AppFontStyle.sizesWidthManageWeb(
                                        1.1, constraints)
                                    : Sizes.width_3,
                                height: (kIsWeb)
                                    ? AppFontStyle.sizesWidthManageWeb(
                                        1.1, constraints)
                                    : Sizes.width_3,
                                color: CColor.txtBlue,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: Sizes.width_2),
                                child: Text(
                                  "Peak",
                                  style: TextStyle(
                                      fontSize: (kIsWeb)
                                          ? AppFontStyle.sizesFontManageWeb(
                                              1.1, constraints)
                                          : FontSize.size_13),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Container(),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y1, this.y2, this.y3);

  final String x;
  final double y1;
   double? y2;
   double? y3;
}
