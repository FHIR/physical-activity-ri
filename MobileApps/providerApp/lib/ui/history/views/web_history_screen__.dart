// import 'package:banny_table/ui/history/datamodel/activityMinClass.dart';
// import 'package:banny_table/ui/history/datamodel/caloriesStepHeartRate.dart';
// import 'package:banny_table/ui/history/datamodel/daysStrength.dart';
// import 'package:banny_table/ui/history/datamodel/editableActivityMinutesWeb/activityMinutesDayWeb.dart';
// import 'package:banny_table/utils/color.dart';
// import 'package:banny_table/utils/constant.dart';
// import 'package:banny_table/utils/debug.dart';
// import 'package:banny_table/utils/sizer_utils.dart';
// import 'package:banny_table/utils/utils.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:horizontal_data_table/horizontal_data_table.dart';
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
//
// import '../../../utils/font_style.dart';
// import '../../welcomeScreen/activityConfiguration/trackingPref/datamodel/trackingPref.dart';
// import '../controllers/history_controller.dart';
// import '../datamodel/editableActivityMinutesWeb/activityMinutesDayDataWeb.dart';
// import '../datamodel/editableActivityMinutesWeb/activityMinutesWeekWeb.dart';
// import '../datamodel/editableCaloriesStepWeb/editableCalStepDayDataWeb.dart';
// import '../datamodel/editableCaloriesStepWeb/editableCalStepDayWeb.dart';
// import '../datamodel/editableCaloriesStepWeb/editableCalStepWeekWeb.dart';
// import '../datamodel/editableHeartRateWeb/editableHeartRateDayDataWeb.dart';
// import '../datamodel/editableHeartRateWeb/editableHeartRateDayWeb.dart';
// import '../datamodel/editableHeartRateWeb/editableHeartRateWeekWeb.dart';
// import '../others/tableColumns/columnsActivityMin.dart';
// import '../others/tableColumns/columnsHeartRate.dart';
// import '../others/tableColumnsWeb/columnsCaloriesWeb.dart';
// import '../others/tableColumnsWeb/columnsDaysStrWeb.dart';
// import '../others/tableColumnsWeb/columnsExperience.dart';
// import '../others/tableColumnsWeb/columnsStepsWeb.dart';
// import '../others/tableColumnsWeb/columnsWhatWhenWeb.dart';
//
// class WebHistoryScreen extends StatelessWidget {
//   // HistoryController logic = Get.find<HistoryController>();
//   final HistoryController logic;
//
//   const WebHistoryScreen(this.logic, {
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       child: Scaffold(
//         backgroundColor: CColor.white,
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _widgetToggleFilterWeb(context, logic),
//             _widgetSelectedDatesWeb(context, logic),
//             Expanded(
//                 child: _getBodyWidget(context, logic))
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _getBodyWidget(BuildContext context, HistoryController logic) {
//     return SizedBox(
//       height: MediaQuery
//           .of(context)
//           .size
//           .height,
//       child: HorizontalDataTable(
//         leftHandSideColumnWidth: MediaQuery
//             .of(context)
//             .size
//             .width * 0.1,
//         /*rightHandSideColumnWidth: MediaQuery
//             .of(context)
//             .size
//             .width * (Utils.getTableWidth(
//             context,
//             Constant.boolActivityMinMod,
//             Constant.boolActivityMinVig,
//             Constant.boolCalories,
//             Constant.boolSteps,
//             Constant.boolRestHeartRate,
//             Constant.boolPeakHeartRate,
//             Constant.boolExperience,
//             logic) + 0.02),*/
//         rightHandSideColumnWidth: MediaQuery
//             .of(context)
//             .size
//             .width * (Utils.getTableWidth(
//             context,
//             Constant.boolActivityMinMod,
//             Constant.boolActivityMinVig,
//             Constant.boolCalories,
//             Constant.boolSteps,
//             Constant.boolHeartRate,
//             Constant.boolExperience,
//             logic) + 0.02),
//         isFixedHeader: true,
//         headerWidgets: _getHeaderWidgetWeb(logic, context),
//         leftSideItemBuilder: (context, index) {
//           return leftSideWidgetWeb(logic, context);
//         },
//         rightSideItemBuilder: (context, index) {
//           return _rightSideWidgetWeb(logic, context);
//         },
//         itemCount: 1,
//         rowSeparatorWidget: const Divider(
//           color: Colors.black54,
//           height: 1.0,
//           thickness: 0.0,
//         ),
//       ),
//     );
//   }
//
//
//   _getHeaderWidgetWeb(HistoryController logic, BuildContext context){
//     return headerWidget(logic,context);
//   }
//
//   List<Widget>? headerWidget(HistoryController logic, BuildContext context){
//     List<Widget> header = [];
//     header.add(cWhatWhenWebNormal());
//     for (int i = 0; i < logic.trackingPrefList.length; i++) {
//       if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderModerate){
//         header.add(cActivityModNormal( logic, context));
//       }
//       else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderVigorous){
//         header.add(cActivityVigNormal(logic,context));
//       }
//       else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderTotal){
//         header.add(cActivityTotalNormal(logic,context));
//       }
//       else if(logic.trackingPrefList[i].titleName == Constant.configurationNotes){
//         header.add(cActivityNotesNormal(logic,context));
//       }
//       else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderDays){
//         header.add(cDaysStrWebNormal(logic,context));
//       }
//       else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderCalories){
//         header.add(cCaloriesWebNormal(logic,context));
//       }
//       else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderSteps){
//         header.add(cStepsWebNormal(logic,context));
//       }
//       else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderRest){
//         header.add(cRestHeartRateNormal(logic,context,Constant.heartRateRest));
//       }
//       else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderPeck){
//         header.add(cRestHeartRateNormal(logic,context,Constant.heartRatePeak));
//       }
//       else if(logic.trackingPrefList[i].titleName == Constant.configurationExperience){
//         header.add(cExperienceWebNormal(logic,context));
//       }
//     }
//     return header;
//   }
//
//   // _getHeaderWidgetWeb(HistoryController logic, BuildContext context) {
//   //   return [
//   //     cWhatWhenWebNormal(),
//   //     cActivityMinWebNormal(logic, context),
//   //     cDaysStrWebNormal(logic, context),
//   //
//   //     if (Constant.boolCalories)
//   //       cCaloriesWebNormal(logic, context),
//   //
//   //     if (Constant.boolSteps)
//   //       cStepsWebNormal(logic, context),
//   //
//   //     if (Constant.boolPeakHeartRate)
//   //       cHeartRateWebNormal(logic, context),
//   //
//   //     if (Constant.boolExperience)
//   //       cExperienceWebNormal(logic, context),
//   //   ];
//   // }
//
//   /*_rightSideWidgetWeb(HistoryController logic, BuildContext context) {
//     return Row(
//       children: [
//         _widgetActivityMinModWeb(logic, context),
//         _widgetDaysStrengthDataListWeb(logic, context),
//         if (Constant.boolCalories) _widgetCaloriesDataListWeb(logic, context),
//         if (Constant.boolSteps) _widgetStepsDataListWeb(logic, context),
//         if (Constant.boolPeakHeartRate) _widgetHeartRateDataListWeb(logic, context),
//         if (Constant.boolExperience)
//           _widgetExperienceDataListWeb(logic, context),
//       ],
//     );
//   }*/
//
//   _rightSideWidgetWeb(HistoryController logic, BuildContext contex) {
//     return  Row(
//       key: logic.tableKey,
//       children: rightSideWidget(logic, contex)!,
//     );
//   }
//
//   List<Widget>? rightSideWidget(HistoryController logic, BuildContext context){
//     List<Widget> header = [];
//     for (int i = 0; i < logic.trackingPrefList.length; i++) {
//       if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderModerate){
//         header.add(_widgetActivityMinModWeb(logic, context,Constant.activityMinutesMod));
//       }
//       else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderVigorous){
//         header.add(_widgetActivityMinModWeb(logic, context,Constant.activityMinutesVig));
//       }
//       else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderTotal){
//         header.add(_widgetActivityMinModWeb(logic, context,Constant.activityMinutesTotal));
//       }
//       else if(logic.trackingPrefList[i].titleName == Constant.configurationNotes){
//         header.add(_widgetActivityMinModWeb(logic, context,Constant.noteType));
//       }
//       else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderDays){
//         header.add(_widgetDaysStrengthDataListWeb(logic, context));
//       }
//       else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderCalories){
//         header.add(_widgetCaloriesDataListWeb(logic, context));
//       }
//       else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderSteps){
//         header.add(_widgetStepsDataListWeb(logic, context));
//       }
//       else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderRest){
//         header.add(_widgetHeartRateDataListWeb(logic, context,Constant.heartRateRest));
//       }
//       else if(logic.trackingPrefList[i].titleName == Constant.configurationHeaderPeck){
//         header.add(_widgetHeartRateDataListWeb(logic, context,Constant.heartRatePeak));
//       }
//       else if(logic.trackingPrefList[i].titleName == Constant.configurationExperience){
//         header.add(_widgetExperienceDataListWeb(logic, context));
//       }
//     }
//     return header;
//   }
//
//   Widget _widgetActivityMinModWeb(HistoryController logic,
//       BuildContext context,String cType) {
//     return Container(
//       decoration: const BoxDecoration(
//           border: Border(
//             right: BorderSide(
//               color: CColor.black,
//             ),
//           )
//       ),
//       child: Row(
//         crossAxisAlignment:
//         CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: MediaQuery.of(context).size.width *
//                 ((cType == Constant.activityMinutesMod)?Utils.getModRowColumnWidth(context,logic):
//                 (cType == Constant.activityMinutesVig)?Utils.getVigRowColumnWidth(context,logic):
//                 (cType == Constant.activityMinutesTotal)?Utils.getTotalRowColumnWidth(context,logic):
//                 Utils.getNotesRowColumnWidth(context,logic)),
//
//             // alignment: Alignment.topCenter,
//             child: ListView.builder(
//               itemBuilder: (context, index) {
//                 return _itemActivityMinWeekWeb(
//                     index,
//                     context,
//                     logic
//                         .activityMinDataList[index],
//                     logic,cType);
//               },
//               padding: const EdgeInsets.all(0),
//               shrinkWrap: true,
//               itemCount: logic
//                   .activityMinDataList.length,
//               physics:
//               const NeverScrollableScrollPhysics(),
//               scrollDirection: Axis.vertical,
//             ),
//           ),
//           /*const VerticalDivider(
//             color: CColor.black,
//             width: 1,
//             thickness: 1,
//           )*/
//         ],
//       ),
//     );
//   }
//
//   Widget _widgetDaysStrengthDataListWeb(HistoryController logic,
//       BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//           border: Border(
//             right: BorderSide(),
//           )),
//       child: Row(
//         crossAxisAlignment:
//         CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Container(
//             width: MediaQuery
//                 .of(context)
//                 .size
//                 .width * Utils.getDaysStrengthRowColumnWidth(context, logic),
//             alignment: Alignment.topCenter,
//             child: ListView.builder(
//               itemBuilder: (context, index) {
//                 return _itemDaysStrengthWeekWeb(
//                     index,
//                     context,
//                     logic
//                         .daysStrengthDataList[
//                     index],
//                     logic,
//                     Constant.titleDaysStr);
//               },
//               padding: const EdgeInsets.all(0),
//               shrinkWrap: true,
//               itemCount: logic
//                   .daysStrengthDataList.length,
//               physics:
//               const NeverScrollableScrollPhysics(),
//               scrollDirection: Axis.vertical,
//             ),
//           ),
//           /* const VerticalDivider(
//             color: CColor.black,
//             width: 1,
//             thickness: 1,
//           )*/
//         ],
//       ),
//     );
//   }
//
//   Widget _widgetCaloriesDataListWeb(HistoryController logic,
//       BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//           border: Border(
//             right: BorderSide(),
//           )),
//       child: Row(
//         crossAxisAlignment:
//         CrossAxisAlignment.start,
//         mainAxisAlignment:
//         MainAxisAlignment.start,
//         children: [
//           Container(
//             width: MediaQuery
//                 .of(context)
//                 .size
//                 .width * Utils.getCaloriesRowColumnWidth(context, logic),
//             alignment: Alignment.topCenter,
//             child: ListView.builder(
//               itemBuilder: (context, index) {
//                 return _itemCaloriesStepWeekWeb(
//                     index,
//                     context,
//                     logic
//                         .caloriesDataList[index],
//                     logic,
//                     Constant.titleCalories);
//               },
//               padding: const EdgeInsets.all(0),
//               shrinkWrap: true,
//               itemCount: logic
//                   .caloriesDataList.length,
//               physics:
//               const NeverScrollableScrollPhysics(),
//               scrollDirection: Axis.vertical,
//             ),
//           ),
//           /*const VerticalDivider(
//             color: CColor.black,
//             width: 1,
//             thickness: 1,
//           )*/
//         ],
//       ),
//     );
//   }
//
//   Widget _widgetStepsDataListWeb(HistoryController logic,
//       BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//           border: Border(
//             right: BorderSide(),
//           )),
//       child: Row(
//         crossAxisAlignment:
//         CrossAxisAlignment.start,
//         mainAxisAlignment:
//         MainAxisAlignment.start,
//         children: [
//           Container(
//             width: MediaQuery
//                 .of(context)
//                 .size
//                 .width * Utils.getStepsRowColumnWidth(context, logic),
//             alignment: Alignment.topCenter,
//             child: ListView.builder(
//               itemBuilder: (context, index) {
//                 return _itemCaloriesStepWeekWeb(
//                     index,
//                     context,
//                     logic
//                         .stepsDataList[index],
//                     logic,
//                     Constant.titleSteps);
//               },
//               padding: const EdgeInsets.all(0),
//               shrinkWrap: true,
//               itemCount: logic
//                   .stepsDataList.length,
//               physics:
//               const NeverScrollableScrollPhysics(),
//               scrollDirection: Axis.vertical,
//             ),
//           ),
//           /* const VerticalDivider(
//             color: CColor.black,
//             width: 1,
//             thickness: 1,
//           )*/
//         ],
//       ),
//     );
//   }
//
//   Widget _widgetHeartRateDataListWeb(HistoryController logic,
//       BuildContext context,String cType) {
//     return Container(
//       decoration: const BoxDecoration(
//           border: Border(
//             right: BorderSide(),
//           )),
//       child: Row(
//         crossAxisAlignment:
//         CrossAxisAlignment.start,
//         mainAxisAlignment:
//         MainAxisAlignment.start,
//         children: [
//           Container(
//             width: MediaQuery
//                 .of(context)
//                 .size
//                 .width * Utils.gePeaktHeartRateRowColumnWidth(context, logic),
//             alignment: Alignment.topCenter,
//             child: ListView.builder(
//               itemBuilder: (context, index) {
//                 return _itemHeartRateWeekWeb(
//                     index,
//                     context,
//                     logic
//                         .heartRateRestDataList[index],
//                     logic
//                         .heartRatePeakDataList[
//                     index],
//                     logic,
//                     Constant.titleHeartRateRest,cType);
//               },
//               padding: const EdgeInsets.all(0),
//               shrinkWrap: true,
//               itemCount: logic
//                   .heartRateRestDataList.length,
//               physics:
//               const NeverScrollableScrollPhysics(),
//               scrollDirection: Axis.vertical,
//             ),
//           ),
//           /*const VerticalDivider(
//             color: CColor.black,
//             width: 1,
//             thickness: 1,
//           )*/
//         ],
//       ),
//     );
//   }
//
//   Widget _widgetExperienceDataListWeb(HistoryController logic,
//       BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//           border: Border(
//             right: BorderSide(),
//           )),
//       child: Row(
//         crossAxisAlignment:
//         CrossAxisAlignment.start,
//         mainAxisAlignment:
//         MainAxisAlignment.start,
//         children: [
//           Container(
//             width: MediaQuery
//                 .of(context)
//                 .size
//                 .width * Utils.getExperienceRowColumnWidth(context, logic,isFromHeader: false),
//             alignment: Alignment.topCenter,
//             child: ListView.builder(
//               itemBuilder: (context, mainIndex) {
//                 return _itemExWeekWeb(
//                     mainIndex,
//                     logic
//                         .activityMinDataList,
//                     logic);
//               },
//               padding: const EdgeInsets.all(0),
//               shrinkWrap: true,
//               itemCount: logic
//                   .activityMinDataList.length,
//               physics:
//               const NeverScrollableScrollPhysics(),
//               scrollDirection: Axis.vertical,
//             ),
//           ),
//           /*const VerticalDivider(
//             color: CColor.black,
//             width: 1,
//             thickness: 1,
//           )*/
//         ],
//       ),
//     );
//   }
//
//   Widget leftSideWidgetWeb(HistoryController logic, BuildContext context) {
//     return Container(
//       width: MediaQuery
//           .of(context)
//           .size
//           .width * 0.1,
//       decoration: const BoxDecoration(
//           border: Border(
//             right: BorderSide(),
//           )),
//       child: Row(
//         crossAxisAlignment:
//         CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemBuilder: (context, index) {
//                 return _itemWhatWhenWeekWeb(
//                     index,
//                     context,
//                     logic,
//                     logic
//                         .activityMinDataList[
//                     index]);
//               },
//               shrinkWrap: true,
//               physics:
//               const NeverScrollableScrollPhysics(),
//               itemCount: logic
//                   .activityMinDataList.length,
//               scrollDirection: Axis.vertical,
//             ),
//           ),
//           Utils.verticalDividerCustom(),
//         ],
//       ),
//     );
//   }
//
//   void showDatePickerDialog(HistoryController logic,
//       BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setStateTemp) {
//             return AlertDialog(
//               // backgroundColor: Colors.transparent,
//               // insetPadding: const EdgeInsets.all(10),
//               contentPadding: const EdgeInsets.all(0),
//               shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(15.0),
//                 ),
//               ),
//               content: Container(
//                 // margin: const EdgeInsets.all(40),
//                   width: Get.width * 0.9,
//                   height: Get.height * 0.5,
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(
//                         15,
//                       ),
//                       color: CColor.white),
//                   child: SfDateRangePicker(
//                     onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
//                       logic.onSelectionChangedDatePicker(
//                           dateRangePickerSelectionChangedArgs);
//                       setStateTemp(() {});
//                     },
//                     selectionMode: DateRangePickerSelectionMode.single,
//                     view: DateRangePickerView.month,
//                     // showTodayButton: true,
//                     // allowViewNavigation: true,
//                     showActionButtons: true,
//                     cancelText: "Cancel",
//                     confirmText: "Ok",
//                     onCancel: () {
//                       Get.back();
//                     },
//                     onSubmit: (p0) {
//                       logic.updateData(logic.selectedNewDate);
//                       // setState(() {});
//                     },
//                   )),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   _widgetToggleFilterWeb(BuildContext context, HistoryController logic) {
//     return Container(
//       padding: EdgeInsets.only(
//         bottom: Sizes.height_1,
//       ),
//       alignment: Alignment.center,
//       child: Row(
//         children: [
//           _widgetToggleWeb(context, logic),
//           const Spacer(),
//           _widgetDatePickerWeb(context, logic),
//           _widgetFilterWeb(context, logic)
//         ],
//       ),
//     );
//   }
//
//   _widgetToggleWeb(BuildContext context, HistoryController logic) {
//     return Container(
//       margin: EdgeInsets.only(
//         left: Sizes.width_5,
//         top: Sizes.height_2,
//       ),
//       child: Container(
//         alignment: Alignment.center,
//         child: PopupMenuButton<int>(
//           enabled: Constant.isEditMode,
//           itemBuilder: (context) =>
//           [
//             PopupMenuItem(
//               value: 1,
//               child: Row(
//                 children: [
//                   Text((logic.isWeekExpanded)
//                       ? "Week Collapse"
//                       : "Week Expand"),
//                   if (logic.isWeekExpanded)
//                     Container(
//                         margin: EdgeInsets.only(left: Sizes.width_2),
//                         child: const Icon(Icons.check))
//                 ],
//               ),
//             ),
//             PopupMenuItem(
//               value: 2,
//               child: Row(
//                 children: [
//                   Text((logic.isDayExpanded)
//                       ? "Day Collapse"
//                       : "Day Expand"),
//                   if (logic.isDayExpanded)
//                     Container(
//                         margin: EdgeInsets.only(left: Sizes.width_2),
//                         child: const Icon(Icons.check))
//                 ],
//               ),
//             ),
//             PopupMenuItem(
//               value: 3,
//               child: Row(
//                 children: [
//                   // const Text("Hide empty row"),
//                   Text((logic.isHideRow)
//                       ? "Show empty row"
//                       : "Hide empty row"),
//                   if (logic.isHideRow)
//                     Container(
//                         margin: EdgeInsets.only(left: Sizes.width_2),
//                         child: const Icon(Icons.check))
//                 ],
//               ),
//             ),
//           ],
//           offset: Offset(-Sizes.width_9, 50),
//           color: Colors.grey[60],
//           elevation: 2,
//           onSelected: (value) {
//             // setState(() {
//             logic.onChangeExpand(value);
//             // });
//           },
//           child: Container(
//             alignment: Alignment.center,
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//                 border: Border.all(color: CColor.black, width: 1),
//                 borderRadius: BorderRadius.circular(7)),
//             child: const Icon(
//               Icons.arrow_drop_down_rounded,
//               color: CColor.black,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   _widgetFilterWeb(BuildContext context, HistoryController logic) {
//     return Tooltip(
//       message: "Fliter",
//       child: InkWell(
//         hoverColor: CColor.transparent,
//         onTap: () {
//           showFilterDialogWeb(logic, context);
//         },
//         child: Container(
//           alignment: Alignment.center,
//           margin: EdgeInsets.only(
//             right: Sizes.width_4,
//             top: Sizes.height_2,
//           ),
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//               border: Border.all(color: CColor.black, width: 1),
//               borderRadius: BorderRadius.circular(7)),
//           child: const Icon(
//             Icons.filter_list_rounded,
//             color: CColor.black,
//           ),
//         ),
//       ),
//     );
//   }
//
//   _widgetDatePickerWeb(BuildContext context, HistoryController logic) {
//     return Tooltip(
//       message: "DatePiker",
//       child: InkWell(
//         // splashColor: CColor.transparent,
//         // highlightColor: CColor.transparent,
//         hoverColor: CColor.transparent,
//         onTap: () {
//           showDatePickerDialog(logic, context);
//         },
//         child: Container(
//           alignment: Alignment.center,
//           margin: EdgeInsets.only(
//             right: Sizes.width_0_5,
//             top: Sizes.height_2,
//           ),
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//               border: Border.all(color: CColor.black, width: 1),
//               borderRadius: BorderRadius.circular(7)),
//           child: const Icon(
//             Icons.date_range_outlined,
//             color: CColor.black,
//           ),
//         ),
//       ),
//     );
//   }
//
//   showDatePickerDialogWeb(HistoryController logic,
//       BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               backgroundColor: Colors.transparent,
//               insetPadding: const EdgeInsets.all(10),
//               contentPadding: const EdgeInsets.all(0),
//               shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(15.0),
//                 ),
//               ),
//               content: Container(
//                   margin: const EdgeInsets.all(40),
//                   width: Get.width * 0.9,
//                   height: Get.height * 0.5,
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(
//                         15,
//                       ),
//                       color: CColor.white),
//                   child: SfDateRangePicker(
//                     onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
//                       logic.onSelectionChangedDatePicker(
//                           dateRangePickerSelectionChangedArgs);
//                     },
//                     selectionMode: DateRangePickerSelectionMode.single,
//                     view: DateRangePickerView.month,
//                     // showTodayButton: true,
//                     // allowViewNavigation: true,
//                     showActionButtons: true,
//                     cancelText: "Cancel",
//                     confirmText: "Ok",
//                     onCancel: () {
//                       Get.back();
//                     },
//                     onSubmit: (p0) {
//                       logic.updateData(logic.selectedNewDate);
//                     },
//                   )),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   _widgetSelectedDatesWeb(BuildContext context, HistoryController logic) {
//     return (logic.startDate != "" &&
//         logic.endDate != "")
//         ? Container(
//       margin: EdgeInsets.symmetric(
//           horizontal: Sizes.width_4, vertical: Sizes.height_1),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           InkWell(
//             onTap: () {
//               // setState(() {
//               logic.getAndSetWeeksData(
//                   logic.previousDate,isTap: true);
//               // });
//             },
//             child: Container(
//               padding: const EdgeInsets.all(10),
//               child: const Icon(
//                 Icons.arrow_back_ios_new_rounded,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Container(
//               alignment: Alignment.center,
//               child: Text(
//                 "${logic.startDate} - ${logic
//                     .endDate}",
//                 style:
//                 // AppFontStyle.styleW700(CColor.black, FontSize.size_5),
//                 AppFontStyle.styleW700(CColor.black, 10.sp),
//               ),
//             ),
//           ),
//           InkWell(
//             onTap: () {
//               // setState(() {
//               logic.getAndSetWeeksData(
//                   logic.nextDate,
//                   isNext: true,isTap: true);
//               // });
//             },
//             child: Container(
//               padding: const EdgeInsets.all(10),
//               // color: CColor.backgroundColor,
//               child: const Icon(
//                 Icons.arrow_forward_ios_rounded,
//               ),
//             ),
//           ),
//         ],
//       ),
//     )
//         : Container();
//   }
//
//   void showFilterDialogWeb(HistoryController logic,
//       BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setStateTemp) {
//             return AlertDialog(
//               // backgroundColor: Colors.transparent,
//               // insetPadding: const EdgeInsets.all(10),
//               contentPadding: const EdgeInsets.all(0),
//               shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(15.0),
//                 ),
//               ),
//               content: Container(
//                 // margin: const EdgeInsets.all(40),
//                 width: Get.width * 0.15,
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(
//                       15,
//                     ),
//                     color: CColor.white),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(left: Sizes.width_2_5),
//                       child: ListView.builder(
//                         itemBuilder: (context, index) {
//                           return Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   logic.titlesListData[index].titleName
//                                       .toString(),
//                                   style: AppFontStyle.styleW700(
//                                       CColor.black, FontSize.size_2),
//                                 ),
//                               ),
//                               Checkbox(
//                                 value: logic
//                                     .titlesListData[index].selected,
//                                 onChanged: (value) {
//                                   logic.onChangeTitle(
//                                       !logic
//                                           .titlesListData[index].selected,
//                                       index);
//                                   setStateTemp(() {});
//                                 },
//                               )
//                             ],
//                           );
//                         },
//                         shrinkWrap: true,
//                         itemCount: logic.titlesListData.length,
//                         physics: const NeverScrollableScrollPhysics(),
//                       ),
//                     ),
//                     Container(
//                       margin: EdgeInsets.only(
//                           left: Sizes.width_2, top: Sizes.height_0_7),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           TextButton(
//                             onPressed: () {
//                               Get.back();
//                             },
//                             child: Text(
//                               "Cancel",
//                               style: AppFontStyle.styleW600(
//                                 CColor.black,
//                                 FontSize.size_2,
//                               ),
//                             ),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               logic.onChangeTitleTapOnOk();
//                               // setState(() {});
//                             },
//                             child: Text(
//                               "Ok",
//                               style: AppFontStyle.styleW600(
//                                 CColor.black,
//                                 FontSize.size_2,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Widget _itemExWeekWeb(int mainIndex, List<LastWeekData> dataList,
//       HistoryController logics) {
//     return StatefulBuilder(
//       builder: (context, setState) {
//         return Container(
//           margin: const EdgeInsets.all(0),
//           child: Column(
//             children: [
//               Container(
//                 // height: Sizes.height_9,
//                 height: Constant.commonHeightForTableBoxWeb,
//                 alignment: Alignment.center,
//                 child: PopupMenuButton<int>(
//                   // enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.isExperience ).toList().isNotEmpty),
//                   enabled: (Constant.isEditMode &&
//                       logic.trackingPrefList.where((element) => element.isSelected
//                           && element.titleName == Constant.configurationExperience).
//                       toList().isNotEmpty),
//                   itemBuilder: (context) =>
//                   [
//                     PopupMenuItem(
//                       value: 1,
//                       child: Utils.getSmileyWidget(
//                           Constant.smiley1ImgPath, Constant.smiley1Title,
//                           isWeb: true),
//                     ),
//                     PopupMenuItem(
//                       value: 2,
//                       child: Utils.getSmileyWidget(
//                           Constant.smiley2ImgPath, Constant.smiley2Title,
//                           isWeb: true),
//                     ),
//                     PopupMenuItem(
//                       value: 3,
//                       child: Utils.getSmileyWidget(
//                           Constant.smiley3ImgPath, Constant.smiley3Title,
//                           isWeb: true),
//                     ),
//                     PopupMenuItem(
//                       value: 4,
//                       child: Utils.getSmileyWidget(
//                           Constant.smiley4ImgPath, Constant.smiley4Title,
//                           isWeb: true),
//                     ),
//                     PopupMenuItem(
//                       value: 5,
//                       child: Utils.getSmileyWidget(
//                           Constant.smiley5ImgPath, Constant.smiley5Title,
//                           isWeb: true),
//                     ),
//                     PopupMenuItem(
//                       value: 6,
//                       child: Utils.getSmileyWidget(
//                           Constant.smiley6ImgPath, Constant.smiley6Title,
//                           isWeb: true),
//                     ),
//                     PopupMenuItem(
//                       value: 7,
//                       child: Utils.getSmileyWidget(
//                           Constant.smiley7ImgPath, Constant.smiley7Title,
//                           isWeb: true),
//                     ),
//                   ],
//                   offset: const Offset(0, 0),
//                   color: Colors.grey[60],
//                   elevation: 2,
//                   onSelected: (value) {
//                     var labelIcon = "";
//                     var expreianceIconValue = 0.0;
//                     if (value == 1) {
//                       labelIcon = Constant.smiley1ImgPath;
//                       expreianceIconValue  = -3;
//                     } else if (value == 2) {
//                       labelIcon = Constant.smiley2ImgPath;
//                       expreianceIconValue  = -2;
//                     } else if (value == 3) {
//                       labelIcon = Constant.smiley3ImgPath;
//                       expreianceIconValue  = -1;
//                     } else if (value == 4) {
//                       labelIcon = Constant.smiley4ImgPath;
//                       expreianceIconValue  = 0;
//                     } else if (value == 5) {
//                       labelIcon = Constant.smiley5ImgPath;
//                       expreianceIconValue  = 1;
//                     } else if (value == 6) {
//                       labelIcon = Constant.smiley6ImgPath;
//                       expreianceIconValue  = 2;
//                     } else if (value == 7) {
//                       labelIcon = Constant.smiley7ImgPath;
//                       expreianceIconValue  = 3;
//                     } else {
//                       labelIcon = Constant.smiley1ImgPath;
//                       expreianceIconValue  = -1;
//                     }
//                     logic.updateSmileyWeekLevel(labelIcon, value, mainIndex,expreianceIconValue);
//                   },
//                   child: Container(
//                     padding: EdgeInsets.only(
//                       right: Sizes.width_1_5,
//                       left: Sizes.width_1_5,
//                     ),
//                     child: Row(
//                       children: [
//                         Image.asset(
//                             Utils.getIconNameFromType(logics
//                                 .activityMinDataList[mainIndex].smileyType),
//                             width: Sizes.width_1_5,
//                             height: Sizes.width_1_5),
//                         /*const Icon(
//                           Icons.arrow_drop_down_sharp,
//                         ),*/
//                         (Constant.isEditMode && logic.trackingPrefList.where((element) => element.isSelected
//                             && element.titleName == Constant.configurationExperience).
//                         toList().isNotEmpty)?const Icon(
//                           Icons.arrow_drop_down_sharp,
//                         ):Container(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               (dataList[mainIndex].isExpanded)
//                   ? ListView.builder(
//                 itemBuilder: (context, daysIndex) {
//                   return _itemExDayWeb(
//                       mainIndex,
//                       daysIndex,
//                       dataList[mainIndex].weekDaysDataList,
//                       logics);
//                 },
//                 shrinkWrap: true,
//                 padding: EdgeInsets.zero,
//                 itemCount: dataList[mainIndex].weekDaysDataList.length,
//                 physics: const NeverScrollableScrollPhysics(),
//               )
//                   : Container(),
//               Utils.dividerCustom(),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _itemExDayWeb(int mainIndex, int dayIndex,
//       List<WeekDays> weekDaysDataList, HistoryController logic) {
//     return (logic.activityMinDataList[mainIndex]
//         .weekDaysDataList[dayIndex].isShow)
//         ? Column(
//       children: [
//         Utils.dividerCustom(),
//         Container(
//           // height: Sizes.height_10,
//           height: Constant.commonHeightForTableBoxWeb,
//           alignment: Alignment.center,
//           child: PopupMenuButton<int>(
//             // enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.isExperience ).toList().isNotEmpty),
//             enabled: (Constant.isEditMode &&
//                 logic.trackingPrefList.where((element) => element.isSelected
//                     && element.titleName == Constant.configurationExperience).
//                 toList().isNotEmpty),
//             itemBuilder: (context) =>
//             [
//               PopupMenuItem(
//                 value: 1,
//                 child: Utils.getSmileyWidget(
//                     Constant.smiley1ImgPath, Constant.smiley1Title,
//                     isWeb: true),
//               ),
//               PopupMenuItem(
//                 value: 2,
//                 child: Utils.getSmileyWidget(
//                     Constant.smiley2ImgPath, Constant.smiley2Title,
//                     isWeb: true),
//               ),
//               PopupMenuItem(
//                 value: 3,
//                 child: Utils.getSmileyWidget(
//                     Constant.smiley3ImgPath, Constant.smiley3Title,
//                     isWeb: true),
//               ),
//               PopupMenuItem(
//                 value: 4,
//                 child: Utils.getSmileyWidget(
//                     Constant.smiley4ImgPath, Constant.smiley4Title,
//                     isWeb: true),
//               ),
//               PopupMenuItem(
//                 value: 5,
//                 child: Utils.getSmileyWidget(
//                     Constant.smiley5ImgPath, Constant.smiley5Title,
//                     isWeb: true),
//               ),
//               PopupMenuItem(
//                 value: 6,
//                 child: Utils.getSmileyWidget(
//                     Constant.smiley6ImgPath, Constant.smiley6Title,
//                     isWeb: true),
//               ),
//               PopupMenuItem(
//                 value: 7,
//                 child: Utils.getSmileyWidget(
//                     Constant.smiley7ImgPath, Constant.smiley7Title,
//                     isWeb: true),
//               ),
//             ],
//             offset: Offset(-Sizes.width_9, 0),
//             color: Colors.grey[60],
//             elevation: 2,
//             onSelected: (value) {
//               var labelIcon = "";
//
//
//               var expreianceIconValue = 0.0;
//               if (value == 1) {
//                 labelIcon = Constant.smiley1ImgPath;
//                 expreianceIconValue  = -3;
//               } else if (value == 2) {
//                 labelIcon = Constant.smiley2ImgPath;
//                 expreianceIconValue  = -2;
//               } else if (value == 3) {
//                 labelIcon = Constant.smiley3ImgPath;
//                 expreianceIconValue  = -1;
//               } else if (value == 4) {
//                 labelIcon = Constant.smiley4ImgPath;
//                 expreianceIconValue  = 0;
//               } else if (value == 5) {
//                 labelIcon = Constant.smiley5ImgPath;
//                 expreianceIconValue  = 1;
//               } else if (value == 6) {
//                 labelIcon = Constant.smiley6ImgPath;
//                 expreianceIconValue  = 2;
//               } else if (value == 7) {
//                 labelIcon = Constant.smiley7ImgPath;
//                 expreianceIconValue  = 3;
//               } else {
//                 labelIcon = Constant.smiley1ImgPath;
//                 expreianceIconValue  = -1;
//               }
//               logic.updateSmileyDayLevel(
//                   labelIcon, value, mainIndex, dayIndex,expreianceIconValue);
//             },
//             child: Container(
//               padding: EdgeInsets.only(
//                 // top: Sizes.height_3_98,
//                 right: Sizes.width_1_5,
//                 left: Sizes.width_1_5,
//                 // bottom: Sizes.height_2_1_5
//               ),
//               child: Row(
//                 children: [
//                   Image.asset(
//                       Utils.getIconNameFromType(logic
//                           .activityMinDataList[mainIndex]
//                           .weekDaysDataList[dayIndex]
//                           .smileyType),
//                       width: Sizes.width_1_5,
//                       height: Sizes.width_1_5),
//                   (Constant.isEditMode &&
//                       logic.trackingPrefList.where((element) => element.isSelected
//                           && element.titleName == Constant.configurationExperience).
//                       toList().isNotEmpty)?const Icon(
//                     Icons.arrow_drop_down_sharp,
//                   ):Container(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         (weekDaysDataList[dayIndex].isExpanded)
//             ? ListView.builder(
//           itemBuilder: (context, daysDataIndex) {
//             return _itemExDayDataWeb(
//                 mainIndex,
//                 dayIndex,
//                 daysDataIndex,
//                 weekDaysDataList[dayIndex].daysDataList,
//                 logic);
//           },
//           shrinkWrap: true,
//           padding: EdgeInsets.zero,
//           itemCount: weekDaysDataList[dayIndex].daysDataList.length,
//           physics: const NeverScrollableScrollPhysics(),
//         )
//             : Container()
//       ],
//     )
//         : Container();
//   }
//
//   Widget _itemExDayDataWeb(int mainIndex, int dayIndex, int dayDataIndex,
//       List<DaysData> daysDataList, HistoryController logic) {
//     return Container(
//       // height: Sizes.height_10,
//       height: Constant.commonHeightForTableBoxWeb,
//       alignment: Alignment.center,
//       child: PopupMenuButton<int>(
//         // enabled: Constant.isEditMode,
//         enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.title ==
//             logic.activityMinDataList[mainIndex].weekDaysDataList[dayIndex].daysDataList[dayDataIndex].displayLabel &&
//             element.isExperience ).toList().isNotEmpty),
//         itemBuilder: (context) =>
//         [
//           PopupMenuItem(
//             value: 1,
//             child: Utils.getSmileyWidget(
//                 Constant.smiley1ImgPath, Constant.smiley1Title,
//                 isWeb: true),
//           ),
//           PopupMenuItem(
//             value: 2,
//             child: Utils.getSmileyWidget(
//                 Constant.smiley2ImgPath, Constant.smiley2Title,
//                 isWeb: true),
//           ),
//           PopupMenuItem(
//             value: 3,
//             child: Utils.getSmileyWidget(
//                 Constant.smiley3ImgPath, Constant.smiley3Title,
//                 isWeb: true),
//           ),
//           PopupMenuItem(
//             value: 4,
//             child: Utils.getSmileyWidget(
//                 Constant.smiley4ImgPath, Constant.smiley4Title,
//                 isWeb: true),
//           ),
//           PopupMenuItem(
//             value: 5,
//             child: Utils.getSmileyWidget(
//                 Constant.smiley5ImgPath, Constant.smiley5Title,
//                 isWeb: true),
//           ),
//           PopupMenuItem(
//             value: 6,
//             child: Utils.getSmileyWidget(
//                 Constant.smiley6ImgPath, Constant.smiley6Title,
//                 isWeb: true),
//           ),
//           PopupMenuItem(
//             value: 7,
//             child: Utils.getSmileyWidget(
//                 Constant.smiley7ImgPath, Constant.smiley7Title,
//                 isWeb: true),
//           ),
//         ],
//         offset: Offset(-Sizes.width_9, 0),
//         color: Colors.grey[60],
//         elevation: 2,
//         onSelected: (value) {
//           var labelIcon = "";
//
//           var expreianceIconValue = 0.0;
//           if (value == 1) {
//             labelIcon = Constant.smiley1ImgPath;
//             expreianceIconValue  = -3;
//           } else if (value == 2) {
//             labelIcon = Constant.smiley2ImgPath;
//             expreianceIconValue  = -2;
//           } else if (value == 3) {
//             labelIcon = Constant.smiley3ImgPath;
//             expreianceIconValue  = -1;
//           } else if (value == 4) {
//             labelIcon = Constant.smiley4ImgPath;
//             expreianceIconValue  = 0;
//           } else if (value == 5) {
//             labelIcon = Constant.smiley5ImgPath;
//             expreianceIconValue  = 1;
//           } else if (value == 6) {
//             labelIcon = Constant.smiley6ImgPath;
//             expreianceIconValue  = 2;
//           } else if (value == 7) {
//             labelIcon = Constant.smiley7ImgPath;
//             expreianceIconValue  = 3;
//           } else {
//             labelIcon = Constant.smiley1ImgPath;
//             expreianceIconValue  = -1;
//           }
//           logic.updateSmileyDaysDataLevel(
//               labelIcon, value, mainIndex, dayIndex, dayDataIndex,expreianceIconValue);
//           // logic.updateTitle6POP();
//         },
//         child: Container(
//           padding: EdgeInsets.only(
//             // top: Sizes.height_4_1_5,
//             right: Sizes.width_1_5,
//             left: Sizes.width_1_5,
//             // bottom: Sizes.height_2_5
//           ),
//           child: Row(
//             children: [
//               Image.asset(
//                   Utils.getIconNameFromType(logic
//                       .activityMinDataList[mainIndex]
//                       .weekDaysDataList[dayIndex]
//                       .daysDataList[dayDataIndex]
//                       .smileyType),
//                   width: Sizes.width_1_5,
//                   height: Sizes.width_1_5),
//               (Constant.isEditMode && Constant.configurationInfo.where((element) => element.title ==
//                   logic.activityMinDataList[mainIndex].weekDaysDataList[dayIndex].daysDataList[dayDataIndex].displayLabel &&
//                   element.isExperience ).toList().isNotEmpty) ? const Icon(
//                 Icons.arrow_drop_down_sharp,
//               )
//                   : Container()
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   _itemWhatWhenWeekWeb(int mainIndex, BuildContext context,
//       HistoryController logic, LastWeekData data) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Tooltip(
//           message: "Weekly Data",
//           child: InkWell(
//             onTap: () {
//               logic.onExpandWeek(mainIndex);
//               // setState(() {});
//             },
//             child: Container(
//               alignment: Alignment.center,
//               // height: Sizes.height_9,
//               height: Constant.commonHeightForTableBoxWeb,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     (logic.activityMinDataList[mainIndex].isExpanded)
//                         ? Icons.arrow_drop_up_rounded
//                         : Icons.arrow_drop_down_rounded,
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         alignment: Alignment.center,
//                         child: Text(
//                           "${DateFormat(Constant.commonDateFormatMmmDd).format(
//                               data.weekStartDate!)}-${DateFormat(
//                               Constant.commonDateFormatMmmDd).format(data
//                               .weekEndDate!)}",
//                           style: TextStyle(
//                               fontWeight: (logic
//                                   .activityMinDataList[mainIndex]
//                                   .isExpanded)
//                                   ? FontWeight.w700
//                                   : FontWeight.normal),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         (logic.activityMinDataList[mainIndex].isExpanded)
//             ? ListView.builder(
//           // padding: EdgeInsets.only(
//           //     left: MediaQuery.of(context).size.width * 0.01),
//           itemBuilder: (context, index) {
//             return _itemWhatWhenDayWeb(index, context,
//                 data.weekDaysDataList, logic, mainIndex);
//           },
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: data.weekDaysDataList.length,
//           shrinkWrap: true,
//         )
//             : Container(),
//         Utils.dividerCustom(),
//       ],
//     );
//   }
//
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
//                   /*itemBuilder: (context) => [
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
//                         ],*/
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
//                     /* if (value == 1) {
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
//                           }*/
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
//                             /*Utils.getNumberIconNameFromType(
//                                             weekDaysDataList[daysIndex]
//                                                 .daysDataList[daysDataIndex]
//                                                 .displayLabel
//                                                 .toString())*/
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
//
//   Widget _widgetNumberImage(String type, String iconName) {
//     return Row(
//       children: [
//         Image.asset(
//           // Utils.getNumberIconNameFromType(type),
//           iconName,
//           height: Sizes.width_0_8,
//           width: Sizes.width_0_8,
//         ),
//         Container(
//           margin: EdgeInsets.only(left: Sizes.width_0_5),
//           // child: Text(type,style: AppFontStyle.styleW400(CColor.black, FontSize.size_8),),
//           child: Text(
//             type,
//             style: AppFontStyle.styleW400(CColor.black, FontSize.size_2),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }
//
//   _itemActivityMinWeekWeb(int mainIndex, BuildContext context,
//       LastWeekData dataList, HistoryController logic,String cType) {
//     return Container(
//       margin: const EdgeInsets.all(0),
//       child: Column(
//         children: [
//           Container(
//             // height: Sizes.height_9,
//             height: Constant.commonHeightForTableBoxWeb,
//             padding: EdgeInsets.only(
//               right: Sizes.width_1_5,
//               left: Sizes.width_1_5,
//             ),
//             child: Row(
//               children: [
//                 (Constant.boolActivityMinMod  && cType == Constant.activityMinutesMod)
//                     ? Expanded(
//                   child: Container(
//                     padding: EdgeInsets.only(bottom: Sizes.height_1),
//                     // child: _editableTextValue1Web(onChangeData: (value) {
//                     child: editableActivityMinModWeekWeb(
//                       onChangeData: (value) {
//                         Debug.printLog(
//                             "Title 1 _editableTextValue1....$value");
//                         logic.onChangeActivityMinMod(
//                             mainIndex, value);
//                         // setState(() {});
//                       },
//                       mainIndex,
//                       logic,
//                         cType,
//                       logic.trackingPrefList
//                     ),
//                   ),
//                 )
//                     : Container(),
//                 const Text("  "),
//                 (Constant.boolActivityMinVig && cType == Constant.activityMinutesVig)
//                     ? Expanded(
//                   child: Container(
//                     padding: EdgeInsets.only(bottom: Sizes.height_1),
//                     // child: _editableTextValue2Web(onChangeData: (value) {
//                     child: editableActivityMinVigWeekWeb(
//                         onChangeData: (value) {
//                           Debug.printLog(
//                               "Title 1 _editableTextValue2....$value");
//                           logic.onChangeActivityMinVig(
//                               mainIndex, value);
//                           // setState(() {});
//                         }, mainIndex, logic,
//                         cType,
//                         logic.trackingPrefList),
//                   ),
//                 )
//                     : Container(),
//                 const Text("  "),
//                 if(Constant.boolActivityMinTotal && cType == Constant.activityMinutesTotal) Expanded(
//                   child: Container(
//                     padding: EdgeInsets.only(bottom: Sizes.height_1),
//                     // child: _editableTextTotalWeb(onChangeData: (value) {
//                     child:
//                     editableActivityMiTotalWeekWeb(onChangeData: (value) {
//                       Debug.printLog("Title 1 _editableTextTotal....$value");
//                       // logic.onChangeActivityMinTotal(mainIndex, value);
//                       // setState(() {});
//                     }, mainIndex, logic,
//                         cType,
//                         logic.trackingPrefList),
//                   ),
//                 ),
//                 if(Constant.boolNotes && cType == Constant.noteType)Expanded  (
//                   child: InkWell(
//                     onTap: () {
//                       if(Constant.isEditMode && logic.trackingPrefList.where((element) => element.isSelected
//                           && element.titleName == Constant.configurationNotes).
//                       toList().isNotEmpty) {
//                         logic.setNotesOnController(logic
//                             .activityMinDataList[mainIndex].weeklyNotes);
//                         bottomAddNotesView(context, logic,
//                             Constant.typeWeek, mainIndex, -1, -1);
//                       }
//                     },
//                     child: Container(
//                         alignment: Alignment.center,
//                         child:
//                         (logic.activityMinDataList[mainIndex]
//                             .weeklyNotes.isNotEmpty)
//
//                             ? Image.asset(
//                           "assets/icons/ic_comment.png",
//                           height: Sizes.width_1,
//                           width: Sizes.width_1,
//                           // color: Colors.grey,
//                         ) : Image.asset("assets/icons/ic_notecomment.png",
//                           height: Sizes.width_1,
//                           width: Sizes.width_1,
//                           color:  (Constant.isEditMode &&
//                               logic.trackingPrefList
//                                   .where((element) => element.isSelected
//                                   && element.titleName == Constant.configurationNotes)
//                                   .toList()
//                                   .isNotEmpty)  ? CColor.black: CColor.gray,)
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           (logic.activityMinDataList[mainIndex].isExpanded)
//               ? ListView.builder(
//             itemBuilder: (context, index) {
//               return _itemActivityMinDayWeb(index, context,
//                   dataList.weekDaysDataList, logic, mainIndex,cType);
//             },
//             shrinkWrap: true,
//             padding: EdgeInsets.zero,
//             itemCount: dataList.weekDaysDataList.length,
//             physics: const NeverScrollableScrollPhysics(),
//           )
//               : Container(),
//           Utils.dividerCustom(),
//         ],
//       ),
//     );
//   }
//
//   _itemActivityMinDayWeb(int daysIndex,
//       BuildContext context,
//       List<WeekDays> weekDaysDataList,
//       HistoryController logic,
//       int mainIndex, String cType) {
//     return (logic.activityMinDataList[mainIndex]
//         .weekDaysDataList[daysIndex].isShow)
//         ? Column(
//       children: [
//         Column(
//           children: [
//             Utils.dividerCustom(),
//             Container(
//               height: Constant.commonHeightForTableBoxWeb,
//               padding: EdgeInsets.only(
//                   right: Sizes.width_1_5,
//                   left: Sizes.width_1_5),
//               child: Row(
//                 children: [
//                   (Constant.boolActivityMinMod && cType == Constant.activityMinutesMod)
//                       ? Expanded(
//                     child: Container(
//                       padding:
//                       EdgeInsets.only(bottom: Sizes.height_1),
//                       child: editableActivityMinModDayWeb(
//                           onChangeData: (value) {
//                           }, mainIndex, daysIndex, logic,cType,logic.trackingPrefList),
//                     ),
//                   )
//                       : Container(),
//                   const Text("  "),
//                   (Constant.boolActivityMinVig && cType == Constant.activityMinutesVig)
//                       ? Expanded(
//                     child: Container(
//                       padding:
//                       EdgeInsets.only(bottom: Sizes.height_1),
//                       child: editableActivityMinVigDayWeb(
//                           onChangeData: (value) {
//                           }, mainIndex, daysIndex, logic,cType,logic.trackingPrefList),
//                     ),
//                   )
//                       : Container(),
//                   const Text("  "),
//                   if (Constant.boolActivityMinTotal && cType == Constant.activityMinutesTotal)Expanded(
//                     child: Container(
//                       padding: EdgeInsets.only(bottom: Sizes.height_1),
//                       child: editableActivityMiTotalDayWeb(
//                           onChangeData: (value) {
//                           }, mainIndex, daysIndex, logic,cType,logic.trackingPrefList),
//                     ),
//                   ),
//                   if (Constant.boolNotes && cType == Constant.noteType)Expanded(
//                     child: InkWell(
//                       onTap: () {
//                         if(Constant.isEditMode &&
//                             logic.trackingPrefList.where((element) => element.isSelected
//                                 && element.titleName == Constant.configurationNotes).
//                             toList().isNotEmpty) {
//                                 logic.setNotesOnController(logic
//                                     .activityMinDataList[mainIndex]
//                                     .weekDaysDataList[daysIndex]
//                                     .dailyNotes);
//                                 bottomAddNotesView(context, logic,
//                                     Constant.typeDay, mainIndex, daysIndex, -1);
//                               }
//                             },
//                       child: Container(
//                           alignment: Alignment.center,
//                           child:
//                           (logic.activityMinDataList[mainIndex]
//                               .weekDaysDataList[daysIndex].dailyNotes
//                               .isNotEmpty)
//                               ? Image.asset(
//                             "assets/icons/ic_comment.png",
//                             height: Sizes.width_1,
//                             width: Sizes.width_1,
//                           )
//                               : Image.asset(
//                             "assets/icons/ic_notecomment.png",
//                             height: Sizes.width_1,
//                             width: Sizes.width_1,
//                             color:(Constant.isEditMode &&
//                                 logic.trackingPrefList.where((element) => element.isSelected
//                                     && element.titleName == Constant.configurationNotes).
//                                 toList().isNotEmpty)
//                                 ? CColor.black
//                                 : CColor.gray,
//                           )),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         (weekDaysDataList[daysIndex].daysDataList.isNotEmpty &&
//             weekDaysDataList[daysIndex].isExpanded)
//             ? ListView.builder(
//           itemBuilder: (context, daysDataIndex) {
//             return Container(
//               height: Constant.commonHeightForTableBoxWeb,
//               margin:
//               EdgeInsets.symmetric(horizontal: Sizes.width_1_5),
//               child: Row(
//                 children: [
//                   (Constant.boolActivityMinMod  && cType == Constant.activityMinutesMod)
//                       ? Expanded(
//                     child: Container(
//                       padding: EdgeInsets.only(
//                           bottom: Sizes.height_1),
//                       child: editableActivityMinModDayDataWeb(
//                           onChangeData: (value) {
//                           }, mainIndex, daysIndex, daysDataIndex,
//                           logic),
//                     ),
//                   )
//                       : Container(),
//                   const Text("  "),
//                   (Constant.boolActivityMinMod && cType == Constant.activityMinutesVig)
//                       ? Expanded(
//                     child: Container(
//                       padding: EdgeInsets.only(
//                           bottom: Sizes.height_1),
//                       child: editableActivityMinVigDayDataWeb(
//                           onChangeData: (value) {
//                           }, mainIndex, daysIndex, daysDataIndex,
//                           logic),
//                     ),
//                   )
//                       : Container(),
//                   const Text("  "),
//                   if (Constant.boolActivityMinTotal && cType == Constant.activityMinutesTotal)Expanded(
//                     child: Container(
//                       padding:
//                       EdgeInsets.only(bottom: Sizes.height_1),
//                       child: editableActivityMinTotalDaysDataWeb(
//                           onChangeData: (value) {
//                           }, mainIndex, daysIndex, daysDataIndex,
//                           logic),
//                     ),
//                   ),
//                   if (Constant.boolNotes && cType == Constant.noteType)Expanded(
//                     child: InkWell(
//                       onTap: () {
//                         if(Constant.isEditMode && Constant.configurationInfo.where((element) => element.title ==
//                             logic.activityMinDataList[mainIndex].weekDaysDataList[daysIndex].daysDataList[daysDataIndex].displayLabel &&
//                             element.isNotes ).toList().isNotEmpty){
//                                       logic.setNotesOnController(logic
//                                           .activityMinDataList[mainIndex]
//                                           .weekDaysDataList[daysIndex]
//                                           .daysDataList[daysDataIndex]
//                                           .dayDataNotes);
//                                       bottomAddNotesView(
//                                           context,
//                                           logic,
//                                           Constant.typeDay,
//                                           mainIndex,
//                                           daysIndex,
//                                           daysDataIndex);
//                                     }
//                                   },
//                       child: Container(
//                           alignment: Alignment.center,
//                           child:
//                           (logic.activityMinDataList[mainIndex]
//                               .weekDaysDataList[daysIndex]
//                               .daysDataList[daysDataIndex].dayDataNotes
//                               .isNotEmpty)
//                               ? Image.asset(
//                             "assets/icons/ic_comment.png",
//                             height: Sizes.width_1,
//                             width: Sizes.width_1,
//                           )
//                               : Image.asset(
//                             "assets/icons/ic_notecomment.png",
//                             height: Sizes.width_1,
//                             width: Sizes.width_1,
//                             color: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.title ==
//                                 logic.activityMinDataList[mainIndex].weekDaysDataList[daysIndex].daysDataList[daysDataIndex].displayLabel &&
//                                 element.isNotes ).toList().isNotEmpty) ? CColor.black : CColor.gray,
//                           )
//
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//           shrinkWrap: true,
//           itemCount:
//           weekDaysDataList[daysIndex].daysDataList.length,
//           physics: const NeverScrollableScrollPhysics(),
//         )
//             : Container(
//           padding: EdgeInsets.zero,
//         ),
//       ],
//     )
//         : Container();
//   }
//
//   _itemCaloriesStepWeekWeb(int mainIndex,
//       BuildContext context,
//       CaloriesStepHeartRateWeek dataList,
//       HistoryController logic,
//       String titleType) {
//     return Container(
//       margin: const EdgeInsets.all(0),
//       child: Column(
//         children: [
//           Container(
//             // height: Sizes.height_9,
//               height: Constant.commonHeightForTableBoxWeb,
//               padding: EdgeInsets.only(
//                 // top: Sizes.height_2_1_5_8,
//                   right: Sizes.width_1_5,
//                   left: Sizes.width_1_5,
//                   bottom: Sizes.height_1),
//               // child: _editableTextTitleAndOtherWeekWeb(
//               child: editableCalStepWeekWeb(mainIndex, logic, titleType,dataList,logic.trackingPrefList,
//                   onChangeData: (value) {
//                     logic.onChangeCalStepWeeks(
//                         mainIndex, value, dataList.titleName);
//                     // setState(() {});
//                   })
//             // _editableText(),
//           ),
//           // return (logic.dataList[mainIndex].isExpanded)
//           (dataList.isExpanded)
//               ? ListView.builder(
//             itemBuilder: (context, daysIndex) {
//               return _itemCalStepDaysWeb(
//                   daysIndex,
//                   context,
//                   dataList.daysList,
//                   logic,
//                   mainIndex,
//                   titleType);
//             },
//             shrinkWrap: true,
//             padding: EdgeInsets.zero,
//             itemCount: dataList.daysList.length,
//             physics: const NeverScrollableScrollPhysics(),
//           )
//               : Container(),
//           Utils.dividerCustom(),
//         ],
//       ),
//     );
//   }
//
//   _itemDaysStrengthWeekWeb(int mainIndex,
//       BuildContext context,
//       OtherTitles2CheckBoxWeek dataList,
//       HistoryController logic,
//       String titleType) {
//     return Container(
//       margin: const EdgeInsets.all(0),
//       child: Column(
//         children: [
//           Container(
//             // height: Sizes.height_9,
//               height: Constant.commonHeightForTableBoxWeb,
//               padding: EdgeInsets.only(
//                 right: Sizes.width_1_5,
//                 left: Sizes.width_1_5,
//               ),
//               child: Container(
//                 padding: EdgeInsets.only(bottom: Sizes.height_1),
//                 child: _editableTextTitle2CheckBoxWeekWeb(
//                     mainIndex, logic, dataList,logic.trackingPrefList, onChangeData: (value) {
//                   logic.onChangeDaysStrWeek(
//                       mainIndex, value, dataList.titleName);
//                 }),
//               )),
//           (dataList.isExpanded)
//               ? ListView.builder(
//             itemBuilder: (context, daysIndex) {
//               return _itemDaysStrengthDaysWeek(
//                   daysIndex,
//                   context,
//                   dataList.daysListCheckBox,
//                   logic,
//                   mainIndex,
//                   titleType);
//             },
//             shrinkWrap: true,
//             padding: EdgeInsets.zero,
//             itemCount: dataList.daysListCheckBox.length,
//             physics: const NeverScrollableScrollPhysics(),
//           )
//               : Container(),
//           Utils.dividerCustom(),
//         ],
//       ),
//     );
//   }
//
//   _itemDaysStrengthDaysWeek(int daysIndex,
//       BuildContext context,
//       List<OtherTitles2CheckBoxDay> daysListCheckBox,
//       HistoryController logic,
//       int mainIndex,
//       String titleType) {
//     return (logic.activityMinDataList[mainIndex]
//         .weekDaysDataList[daysIndex].isShow)
//         ? Column(
//       children: [
//         Utils.dividerCustom(),
//         Container(
//           padding: EdgeInsets.only(
//             right: Sizes.width_1_5,
//             left: Sizes.width_1_5,
//           ),
//           // height: Sizes.height_10,
//           height: Constant.commonHeightForTableBoxWeb,
//           child: Checkbox(
//             value: daysListCheckBox[daysIndex].isCheckedDay,
//             /*onChanged: (!Constant.isEditMode)
//                 ? null
//                 : (value) {
//               logic.onChangeDaysStrengthCheckBoxDay(
//                   mainIndex, daysIndex);
//             },*/
//             onChanged: (!Constant.isEditMode || logic.trackingPrefList.where((element) => element.isSelected
//                 && element.titleName == Constant.configurationHeaderDays)
//                 .toList().isEmpty ) ? null : (value) {
//               logic.onChangeDaysStrengthCheckBoxDay(mainIndex, daysIndex);
//             },
//           ),
//         ),
//         (daysListCheckBox[daysIndex].isExpanded)
//             ? ListView.builder(
//           itemBuilder: (context, daysDataIndex) {
//             return _itemDaysStrengthDaysDataWeb(
//                 daysIndex,
//                 context,
//                 daysListCheckBox[daysIndex].daysDataListCheckBox,
//                 logic,
//                 mainIndex,
//                 daysDataIndex,
//                 titleType);
//           },
//           shrinkWrap: true,
//           padding: EdgeInsets.zero,
//           itemCount: daysListCheckBox[daysIndex]
//               .daysDataListCheckBox
//               .length,
//           physics: const NeverScrollableScrollPhysics(),
//         )
//             : Container(),
//       ],
//     )
//         : Container();
//   }
//
//   _itemDaysStrengthDaysDataWeb(int daysIndex,
//       BuildContext context,
//       List<OtherTitles2CheckBoxDaysData> daysDataListCheckBox,
//       HistoryController logic,
//       int mainIndex,
//       int daysDataIndex,
//       String titleType) {
//     return Container(
//       padding: EdgeInsets.only(
//         right: Sizes.width_1_5,
//         left: Sizes.width_1_5,
//       ),
//       // height: Sizes.height_10,
//       height: Constant.commonHeightForTableBoxWeb,
//       child: Checkbox(
//         value: daysDataListCheckBox[daysDataIndex].isCheckedDaysData,
//         onChanged: (!Constant.isEditMode ||
//             Constant.configurationInfo.where((element) =>
//             element.title ==
//                 logic.activityMinDataList[mainIndex]
//                     .weekDaysDataList[daysIndex].daysDataList[daysDataIndex]
//                     .displayLabel &&
//                 element.isDaysStr)
//                 .toList()
//                 .isEmpty)
//             ? null
//             : (value) {
//           logic.onChangeDaysStrengthCheckBoxDaysData(
//               mainIndex, daysIndex, daysDataIndex);
//           // setState(() {});
//         },
//       ),
//     );
//   }
//
//   Widget _editableTextTitle2CheckBoxWeekWeb(int index,
//       HistoryController logic, OtherTitles2CheckBoxWeek dataList,List<TrackingPref> trackingPrefList,
//       {Function? onChangeData}) {
//     return SizedBox(
//       child: TextField(
//         textAlign: TextAlign.right,
//         // enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.isDaysStr ).toList().isNotEmpty ) ,
//         enabled: (Constant.isEditMode && trackingPrefList.where((element) => (element.titleName == Constant.configurationHeaderDays && element.isSelected)).toList().isNotEmpty ) ,
//         cursorHeight: Constant.cursorHeightForWeb,
//         enableInteractiveSelection: false,
//         keyboardType: TextInputType.number,
//         style: TextStyle(fontSize: Constant.webTextFiledTextSize),
//         inputFormatters: [
//           FilteringTextInputFormatter.allow(RegExp(r"\d+([\.]\d+)?")),
//         ],
//         maxLines: 1,
//         autofocus: false,
//         autocorrect: true,
//         controller: dataList.weekValueTitle2CheckBoxController,
//         onChanged: (value) {
//           if (onChangeData != null) {
//             onChangeData.call(value);
//           }
//         },
//       ),
//     );
//   }
//
//   _itemCalStepDaysWeb(int daysIndex,
//       BuildContext context,
//       List<CaloriesStepHeartRateDay> weekDaysDataList,
//       HistoryController logic,
//       int mainIndex,
//       String titleType) {
//     return (logic.activityMinDataList[mainIndex]
//         .weekDaysDataList[daysIndex].isShow)
//         ? Column(
//       children: [
//         Column(
//           children: [
//             Utils.dividerCustom(),
//             Container(
//                 padding: EdgeInsets.only(
//                     right: Sizes.width_1_5,
//                     left: Sizes.width_1_5,
//                     bottom: Sizes.height_1),
//                 // height: Sizes.height_10,
//                 height: Constant.commonHeightForTableBoxWeb,
//                 // child: _editableTextTitle2AndOtherDaysWeb(
//                 child: editableCalStepDayWeb(daysIndex, logic,
//                     weekDaysDataList[daysIndex], onChangeData: (value) {
//                       /*logic.onChangeCalStepDay(
//                             mainIndex,
//                             daysIndex,
//                             value,
//                             weekDaysDataList[daysIndex].titleName,
//                             titleType);*/
//                     }, mainIndex, titleType,logic.trackingPrefList)
//               // _editableText(),
//             ),
//           ],
//         ),
//         // (weekDaysDataList[daysIndex].daysDataList.isNotEmpty &&
//         (weekDaysDataList[daysIndex].daysDataList.isNotEmpty &&
//             weekDaysDataList[daysIndex].isExpanded)
//             ? ListView.builder(
//           itemBuilder: (context, daysDataIndex) {
//             return Container(
//               // height: Sizes.height_10,
//                 height: Constant.commonHeightForTableBoxWeb,
//                 margin: EdgeInsets.symmetric(
//                     horizontal: Sizes.width_1_5),
//                 child: Container(
//                   padding: EdgeInsets.only(bottom: Sizes.height_1),
//                   // child: _editableTextTitle2AndOtherDaysDataWeb(
//                   child: (titleType == Constant.titleCalories)
//                       ? editableCalStepDayDataWeb(
//                       daysDataIndex,
//                       logic,
//                       mainIndex,
//                       daysIndex,
//                       titleType,
//                       weekDaysDataList[daysIndex]
//                           .daysDataList[daysDataIndex],
//                       onChangeData: (value) {
//                         logic.onChangeCountOtherDaysData(
//                                     mainIndex,
//                                     daysIndex,
//                                     daysDataIndex,
//                                     value,
//                                     titleType);
//                       })
//                       : editableCalStepDayDataWebStep(
//                       daysDataIndex,
//                       logic,
//                       mainIndex,
//                       daysIndex,
//                       titleType,
//                       weekDaysDataList[daysIndex]
//                           .daysDataList[daysDataIndex],
//                       onChangeData: (value) {
//                          logic.onChangeCountOtherDaysData(
//                                         mainIndex,
//                                         daysIndex,
//                                         daysDataIndex,
//                                         value,
//                                         titleType);
//                       }),
//                 )
//               // _editableText(),
//             );
//           },
//           shrinkWrap: true,
//           itemCount:
//           weekDaysDataList[daysIndex].daysDataList.length,
//           physics: const NeverScrollableScrollPhysics(),
//         )
//             : Container(
//           padding: EdgeInsets.zero,
//         ),
//       ],
//     )
//         : Container();
//   }
//
//   _itemHeartRateWeekWeb(int mainIndex,
//       BuildContext context,
//       CaloriesStepHeartRateWeek otherTitle5Data,
//       CaloriesStepHeartRateWeek otherTitle6Data,
//       HistoryController logic,
//       String titleType, String cType) {
//     return Container(
//       margin: const EdgeInsets.all(0),
//       child: Column(
//         children: [
//           Container(
//               padding: EdgeInsets.only(
//                   right: Sizes.width_1_5,
//                   left: Sizes.width_1_5,
//                   bottom: Sizes.height_1),
//               // height: Sizes.height_9,
//               height: Constant.commonHeightForTableBoxWeb,
//               child: Row(
//                 children: [
//                   if(cType == Constant.heartRateRest)Expanded(
//                     child: editableRestWeekWeb(
//                         mainIndex, logic, otherTitle5Data,
//                         onChangeData: (value) {
//                         }),
//                   ),
//                   // const Spacer(),
//                   SizedBox(
//                     width: Sizes.width_2,
//                   ),
//                   if(cType == Constant.heartRatePeak)Expanded(
//                     child: editablePeakWeekWeb(
//                         mainIndex, logic, otherTitle6Data,
//                         onChangeData: (value) {
//                         }),
//                   ),
//                 ],
//               )
//           ),
//           (otherTitle5Data.isExpanded)
//               ? ListView.builder(
//             itemBuilder: (context, daysIndex) {
//               return _itemHeartRateDayDay(
//                   daysIndex,
//                   context,
//                   otherTitle5Data.daysList,
//                   otherTitle6Data.daysList,
//                   logic,
//                   mainIndex,
//                   titleType,cType);
//             },
//             shrinkWrap: true,
//             padding: EdgeInsets.zero,
//             itemCount: otherTitle5Data.daysList.length,
//             physics: const NeverScrollableScrollPhysics(),
//           )
//               : Container(),
//           Utils.dividerCustom(),
//         ],
//       ),
//     );
//   }
//
//   _itemHeartRateDayDay(int daysIndex,
//       BuildContext context,
//       List<CaloriesStepHeartRateDay> weekDaysDataListTitle5,
//       List<CaloriesStepHeartRateDay> weekDaysDataListTitle6,
//       HistoryController logic,
//       int mainIndex,
//       String titleType, String cType) {
//     return (logic.activityMinDataList[mainIndex]
//         .weekDaysDataList[daysIndex].isShow)
//         ? Column(
//       children: [
//         Column(
//           children: [
//             Utils.dividerCustom(),
//             Container(
//                 height: Constant.commonHeightForTableBoxWeb,
//                 padding: EdgeInsets.only(
//                     right: Sizes.width_1_5,
//                     left: Sizes.width_1_5,
//                     bottom: Sizes.height_1),
//                 child: Row(
//                   children: [
//                     if(cType == Constant.heartRateRest)Expanded(
//                       child: editableRestDayDayWeb(
//                           mainIndex,
//                           logic,
//                           weekDaysDataListTitle5[daysIndex],
//                           onChangeData: (value) {
//                           }),
//                     ),
//                     SizedBox(
//                       width: Sizes.width_2,
//                     ),
//                     if(cType == Constant.heartRatePeak)Expanded(
//                       child: editablePeakDayDayWeb(
//                           mainIndex,
//                           logic,
//                           weekDaysDataListTitle6[daysIndex],
//                           onChangeData: (value) {
//                           }),
//                     ),
//                   ],
//                 )
//               // _editableText(),
//             ),
//           ],
//         ),
//         (weekDaysDataListTitle5[daysIndex].daysDataList.isNotEmpty &&
//             weekDaysDataListTitle5[daysIndex].isExpanded)
//             ? ListView.builder(
//           itemBuilder: (context, daysDataIndex) {
//             return Container(
//               // height: Sizes.height_10,
//                 height: Constant.commonHeightForTableBoxWeb,
//                 margin: EdgeInsets.symmetric(
//                     horizontal: Sizes.width_1_5),
//                 child: Container(
//                   padding: EdgeInsets.only(bottom: Sizes.height_1),
//                   child: Row(
//                     children: [
//                       if(cType == Constant.heartRateRest)Expanded(
//                         child: editableRestDayDataWeb(
//                             mainIndex,
//                             daysIndex,
//                             daysDataIndex,
//                             logic,
//                             weekDaysDataListTitle5[daysIndex]
//                                 .daysDataList[daysDataIndex],
//                             onChangeData: (value) {
//                               logic.onChangeCountOtherDaysData(
//                                           mainIndex,
//                                           daysIndex,
//                                           daysDataIndex,
//                                           value,
//                                           Constant.titleHeartRateRest);
//                             }),
//                       ),
//                       SizedBox(
//                         width: Sizes.width_2,
//                       ),
//                       if(cType == Constant.heartRatePeak)Expanded(
//                         child: editablePeakDayDataWeb(
//                             mainIndex,
//                             daysIndex,
//                             daysDataIndex,
//                             logic,
//                             weekDaysDataListTitle6[daysIndex]
//                                 .daysDataList[daysDataIndex],
//                             onChangeData: (value) {
//                               logic.onChangeCountOtherDaysData(
//                                   mainIndex,
//                                   daysIndex,
//                                   daysDataIndex,
//                                   value,
//                                   Constant.titleHeartRatePeak);
//                             }),
//                       ),
//                     ],
//                   ),
//                 )
//               // _editableText(),
//             );
//           },
//           shrinkWrap: true,
//           itemCount:
//           weekDaysDataListTitle5[daysIndex].daysDataList.length,
//           physics: const NeverScrollableScrollPhysics(),
//         )
//             : Container(
//           padding: EdgeInsets.zero,
//         ),
//       ],
//     )
//         : Container();
//   }
//
//   bottomAddNotesView(BuildContext context, HistoryController logic, int type,
//       int mainIndex, int daysIndex, int daysDataIndex) {
//     Future<void> future = showDialog<void>(
//         context: context,
//         barrierDismissible: true,
//         builder: (context) {
//           return StatefulBuilder(
//             builder: (context, StateSetter setStateBottom) {
//               return AlertDialog(
//                 insetPadding: const EdgeInsets.all(10),
//                 contentPadding: const EdgeInsets.all(0),
//                 shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(15.0),
//                   ),
//                 ),
//                 content: Container(
//                   width: MediaQuery
//                       .of(context)
//                       .size
//                       .width * 0.3,
//                   decoration: const BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(10),
//                         topRight: Radius.circular(10)),
//                     color: CColor.white,
//                   ),
//                   child: Wrap(
//                     children: [
//                       Container(
//                         alignment: Alignment.center,
//                         margin: EdgeInsets.only(top: Sizes.height_2),
//                         child: Text(
//                           "Add your notes",
//                           style: AppFontStyle.styleW700(
//                               CColor.black, FontSize.size_3),
//                         ),
//                       ),
//                       Container(
//                         margin: EdgeInsets.only(
//                             left: Sizes.height_2,
//                             right: Sizes.height_2,
//                             top: Sizes.height_2,
//                             bottom: Sizes.height_2),
//                         decoration: BoxDecoration(
//                             border: Border.all(color: CColor.black, width: 1),
//                             borderRadius: BorderRadius.circular(10)),
//                         child: TextField(
//                           cursorHeight: Constant.cursorHeightForWeb,
//                           keyboardType: TextInputType.text,
//                           style: TextStyle(
//                               fontSize: Constant.webTextFiledTextSize),
//                           maxLines: 5,
//                           controller: logic.notesController,
//                         ),
//                       ),
//                       Container(
//                         margin: EdgeInsets.only(
//                             left: Sizes.height_2,
//                             right: Sizes.height_2,
//                             top: Sizes.height_2,
//                             bottom: Sizes.height_2),
//                         padding: EdgeInsets.only(
//                             top: Sizes.height_1, bottom: Sizes.height_4),
//                         child: Row(
//                           // mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             Expanded(
//                               child: InkWell(
//                                 onTap: () {
//                                   Get.back();
//                                   setStateBottom(() {});
//                                 },
//                                 child: Container(
//                                   margin: EdgeInsets.only(right: Sizes.width_1),
//                                   alignment: Alignment.center,
//                                   decoration: BoxDecoration(
//                                       border: Border.all(),
//                                       borderRadius: BorderRadius.circular(10)),
//                                   padding: EdgeInsets.only(
//                                     // left: Sizes.width_6,
//                                     // right: Sizes.width_6,
//                                       top: Sizes.height_1,
//                                       bottom: Sizes.height_1),
//                                   child: Text(
//                                     "Cancel",
//                                     style: TextStyle(
//                                         color: CColor.black,
//                                         fontSize: FontSize.size_3_5),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: InkWell(
//                                 onTap: () {
//                                   logic.insertUpdateWeekNotesData(
//                                       mainIndex,
//                                       daysIndex,
//                                       daysDataIndex,
//                                       logic.notesController.text,
//                                       type);
//                                   Get.back();
//                                   setStateBottom(() {});
//                                 },
//                                 child: Container(
//                                   margin: EdgeInsets.only(left: Sizes.width_1),
//                                   decoration: BoxDecoration(
//                                       border: Border.all(),
//                                       borderRadius: BorderRadius.circular(10),
//                                       color: CColor.black),
//                                   padding: EdgeInsets.only(
//                                     // left: Sizes.width_6,
//                                     // right: Sizes.width_6,
//                                       top: Sizes.height_1,
//                                       bottom: Sizes.height_1),
//                                   child: Text(
//                                     "Add",
//                                     style: TextStyle(
//                                         color: CColor.white,
//                                         fontSize: FontSize.size_3_5),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         });
//     future.then((void value) {
//       // setState(() {});
//     });
//   }
// }
