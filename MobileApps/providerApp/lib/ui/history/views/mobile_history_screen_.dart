// import 'package:banny_table/ui/history/datamodel/activityMinClass.dart';
// import 'package:banny_table/ui/history/datamodel/caloriesStepHeartRate.dart';
// import 'package:banny_table/ui/history/datamodel/daysStrength.dart';
// import 'package:banny_table/ui/history/datamodel/editableActivityMinutes/activityMinutesDay.dart';
// import 'package:banny_table/ui/history/others/tableColumns/columnsWhatWhen.dart';
// import 'package:banny_table/utils/color.dart';
// import 'package:banny_table/utils/constant.dart';
// import 'package:banny_table/utils/debug.dart';
// import 'package:banny_table/utils/sizer_utils.dart';
// import 'package:banny_table/utils/utils.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:horizontal_data_table/horizontal_data_table.dart';
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// import '../../../utils/font_style.dart';
// import '../controllers/history_controller.dart';
// import '../datamodel/editableActivityMinutes/activityMinutesDayData.dart';
// import '../datamodel/editableActivityMinutes/activityMinutesWeek.dart';
// import '../datamodel/editableCaloriesStep/editableCalStepDay.dart';
// import '../datamodel/editableCaloriesStep/editableCalStepDayData.dart';
// import '../datamodel/editableCaloriesStep/editableCalStepWeek.dart';
// import '../datamodel/editableHeartRate/editableHeartRateDay.dart';
// import '../datamodel/editableHeartRate/editableHeartRateDayData.dart';
// import '../datamodel/editableHeartRate/editableHeartRateWeek.dart';
// import '../others/tableColumns/columnsActivityMin.dart';
// import '../others/tableColumns/columnsCalories.dart';
// import '../others/tableColumns/columnsDaysStr.dart';
// import '../others/tableColumns/columnsExperience.dart';
// import '../others/tableColumns/columnsHeartRate.dart';
// import '../others/tableColumns/columnsSteps.dart';
//
// class MobileHistoryScreen extends StatelessWidget {
//   // HistoryController? historyController = Get.find<HistoryController>();
//
//   MobileHistoryScreen({Key? key}) : super(key: key);
//   // MobileHistoryScreen({Key? key,@required this.historyController}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     var orientation = MediaQuery.of(context).orientation;
//     // historyController!.onChangePortraitLandscape(orientation);
//
//     return Scaffold(
//       resizeToAvoidBottomInset:false,
//       backgroundColor: CColor.white,
//       body: SafeArea(
//         child: GetBuilder<HistoryController>(
//           init: HistoryController(),
//           assignId: true,
//           builder: (logic) {
//             logic.onChangePortraitLandscape(orientation);
//             return (orientation == Orientation.portrait)?
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _widgetToggleFilter(context,logic,orientation),
//                 _widgetSelectedDates(context,logic),
//                 Expanded(child: _getBodyWidget(context,orientation,logic,false))
//               ],
//             ):Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     _widgetToggle(context,logic, isLandscape: true),
//                     Expanded(child: _widgetSelectedDates(context,logic,isLandscape: true),),
//                     _widgetDatePicker(context,logic,isLandscape: true),
//                     _widgetFilter(context,logic,orientation,isLandscape: true)
//                   ],
//                 ),
//                 Expanded(child: _getBodyWidget(context,orientation,logic,true))
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _getBodyWidget(BuildContext context, Orientation orientation, HistoryController logic,bool isScroll) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height,
//       child: HorizontalDataTable(
//         leftHandSideColumnWidth: MediaQuery.of(context).size.width * ((logic.isPortrait)?0.35:0.2),
//         rightHandSideColumnWidth: MediaQuery.of(context).size.width * (Utils.getTableWidth(
//             context,
//             (logic.trackingPrefList.where((element) => element.titleName == Constant.configurationHeaderModerate
//             && element.isSelected).toList().isNotEmpty && Constant.boolActivityMinMod),
//             logic.trackingPrefList.where((element) => element.titleName == Constant.configurationHeaderVigorous
//                 && element.isSelected).toList().isNotEmpty,
//             (logic.trackingPrefList.where((element) => element.titleName == Constant.configurationHeaderCalories
//                 && element.isSelected).toList().isNotEmpty && Constant.boolCalories),
//             (logic.trackingPrefList.where((element) => element.titleName == Constant.configurationHeaderSteps
//                 && element.isSelected).toList().isNotEmpty  && Constant.boolSteps),
//            (( (logic.trackingPrefList.where((element) => element.titleName == Constant.configurationHeaderRest
//                 && element.isSelected).toList().isNotEmpty) ||
//                logic.trackingPrefList.where((element) => element.titleName == Constant.configurationHeaderPeck
//                    && element.isSelected).toList().isNotEmpty) && Constant.boolHeartRate),
//             (logic.trackingPrefList.where((element) => element.titleName == Constant.configurationExperience
//                 && element.isSelected).toList().isNotEmpty && Constant.boolExperience),
//             logic.trackingPrefList.where((element) => element.titleName == Constant.configurationHeaderDays
//                 && element.isSelected).toList().isNotEmpty,logic)+0.02),
//         isFixedHeader: true,
//         headerWidgets: _getHeaderWidget(orientation,logic,context),
//         leftSideItemBuilder: (context, index) {
//           return leftSideWidget(orientation,logic,context);
//         },
//         rightSideItemBuilder: (context, index) {
//           return _rightSideWidget(orientation,logic,context);
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
//   _getHeaderWidget(Orientation orientation, HistoryController logic, BuildContext context){
//     return [
//       cWhatWhenWidgetNormal(orientation),
//
//       if((logic.trackingPrefList.where((element) => (element.titleName == Constant.configurationHeaderModerate
//           && element.isSelected)
//       ).toList().isEmpty) &&
//           (logic.trackingPrefList.where((element) =>
//               (element.titleName == Constant.configurationHeaderVigorous
//                   && element.isSelected)
//           ).toList().isEmpty) &&
//           (logic.trackingPrefList.where((element) =>
//               (element.titleName == Constant.configurationHeaderTotal
//                   && element.isSelected)
//           ).toList().isEmpty)) Container(
//         height: Constant.commonHeightForTableBoxMobileHeader,
//         decoration:  const BoxDecoration(
//             border: Border(
//               right: BorderSide(
//                   color: CColor.transparent
//               ),
//             )
//         ),
//       ) else
//         cActivityMinNormal(orientation,logic,context),
//
//       if(logic.trackingPrefList.where((element) => element.titleName == Constant.configurationHeaderDays
//           && element.isSelected).toList().isNotEmpty )
//       cDaysStrNormal(orientation,logic,context),
//
//       if(logic.trackingPrefList.where((element) => element.titleName == Constant.configurationHeaderCalories
//           && element.isSelected).toList().isNotEmpty  && Constant.boolCalories)
//         cCaloriesNormal(orientation,logic,context),
//
//         if(logic.trackingPrefList.where((element) => element.titleName == Constant.configurationHeaderSteps
//             && element.isSelected).toList().isNotEmpty  && Constant.boolSteps)
//         cStepsNormal(orientation,logic,context),
//
//       if(((logic.trackingPrefList.where((element) => (element.titleName == Constant.configurationHeaderRest
//           && element.isSelected)
//       ).toList().isEmpty) &&
//           (logic.trackingPrefList.where((element) =>
//               (element.titleName == Constant.configurationHeaderPeck
//                   && element.isSelected)
//           ).toList().isEmpty))) Container(
//         height: Constant.commonHeightForTableBoxMobileHeader,
//         decoration:  const BoxDecoration(
//             border: Border(
//               right: BorderSide(
//                   color: CColor.transparent
//               ),
//             )
//         ),
//       ) else
//         (Constant.boolHeartRate)?cHeartRateNormal(orientation,logic,context):
//         Container(
//           height: Constant.commonHeightForTableBoxMobileHeader,
//           decoration:  const BoxDecoration(
//               border: Border(
//                 right: BorderSide(
//                     color: CColor.transparent
//                 ),
//               )
//           ),
//         ) ,
//
//       if(logic.trackingPrefList.where((element) => element.titleName == Constant.configurationExperience
//           && element.isSelected).toList().isNotEmpty && Constant.boolExperience)
//         cExperienceNormal(orientation,logic,context),
//     ];
//   }
//
//   _rightSideWidget(
//       Orientation orientation, HistoryController logic, BuildContext contex) {
//     return  Row(
//       key: logic.tableKey,
//       children: [
//         if((logic.trackingPrefList.where((element) => (element.titleName == Constant.configurationHeaderModerate
//             && element.isSelected)
//         ).toList().isEmpty) &&
//             (logic.trackingPrefList.where((element) =>
//             (element.titleName == Constant.configurationHeaderVigorous
//                 && element.isSelected)
//             ).toList().isEmpty) &&
//             (logic.trackingPrefList.where((element) =>
//             (element.titleName == Constant.configurationHeaderTotal
//                 && element.isSelected)
//             ).toList().isEmpty)) Container() else _widgetActivityMinMod(orientation, logic, contex) ,
//
//         if(logic.trackingPrefList.where((element) => element.titleName == Constant.configurationHeaderDays
//             && element.isSelected).toList().isNotEmpty )_widgetDaysStrengthDataList(orientation, logic, contex),
//
//         if(logic.trackingPrefList.where((element) => element.titleName == Constant.configurationHeaderCalories
//             && element.isSelected).toList().isNotEmpty && Constant.boolCalories) _widgetCaloriesDataList(orientation, logic, contex),
//
//         if(logic.trackingPrefList.where((element) => element.titleName == Constant.configurationHeaderSteps
//             && element.isSelected).toList().isNotEmpty  && Constant.boolSteps) _widgetStepsDataList(orientation, logic, contex),
//
//         if((logic.trackingPrefList.where((element) => (element.titleName == Constant.configurationHeaderRest
//             && element.isSelected)
//         ).toList().isEmpty) &&
//             (logic.trackingPrefList.where((element) =>
//             (element.titleName == Constant.configurationHeaderPeck
//                 && element.isSelected)
//             ).toList().isEmpty)) Container() else (Constant.boolHeartRate)?_widgetHeartRateDataList(orientation, logic, contex):Container(),
//
//         if (logic.trackingPrefList.where((element) =>
//         element.titleName == Constant.configurationExperience &&
//             element.isSelected).toList().isNotEmpty && Constant.boolExperience)_widgetExperienceDataList(orientation, logic, contex),
//       ],
//     );
//   }
//
//   Widget _widgetActivityMinMod(Orientation orientation, HistoryController logic,BuildContext contex){
//     return Container(
//       decoration: const BoxDecoration(
//           border: Border(
//             right: BorderSide(
//                 color: CColor.black,
//             ),
//           )
//       ),
//       child: Row(
//         crossAxisAlignment:
//         CrossAxisAlignment.start,
//         mainAxisAlignment:
//         MainAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: MediaQuery.of(contex).size.width *
//                 Utils.getActivityMinRowColumnWidth(contex,Constant.boolActivityMinMod,
//                     Constant.boolActivityMinVig,logic),
//
//             child: ListView.builder(
//               itemBuilder: (context,
//                   index) {
//                 return _itemActivityMinWeek(
//                     index,
//                     context,
//                     logic
//                         .activityMinDataList[index],
//                     logic);
//               },
//               padding: EdgeInsets.zero,
//               shrinkWrap: true,
//               itemCount:
//               logic.activityMinDataList.length,
//               physics:
//               const NeverScrollableScrollPhysics(),
//               scrollDirection: Axis
//                   .vertical,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _widgetDaysStrengthDataList(Orientation orientation, HistoryController logic,BuildContext contex){
//     return Container(
//       decoration: const BoxDecoration(
//           border: Border(
//             right: BorderSide(
//                 color: CColor.black,
//             ),
//           )
//       ),
//
//       child: Row(
//         crossAxisAlignment:
//         CrossAxisAlignment.start,
//         mainAxisAlignment:
//         MainAxisAlignment.start,
//         children: [
//           Container(
//             width: MediaQuery.of(contex).size.width * Utils.getDaysStrengthRowColumnWidth(contex,logic),
//             alignment: Alignment
//                 .topCenter,
//             child: ListView.builder(
//               itemBuilder: (context,
//                   index) {
//                 return _itemDaysStrengthWeek(
//                     index,
//                     context,
//                     logic
//                         .daysStrengthDataList[
//                     index],
//                     logic,
//                     Constant.titleDaysStr);
//               },
//               padding:
//               const EdgeInsets.all(0),
//               shrinkWrap: true,
//               itemCount: logic
//                   .daysStrengthDataList
//                   .length,
//               physics:
//               const NeverScrollableScrollPhysics(),
//               scrollDirection: Axis
//                   .vertical,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _widgetCaloriesDataList(Orientation orientation, HistoryController logic,BuildContext contex){
//     return Container(
//       decoration: const BoxDecoration(
//           border: Border(
//             right: BorderSide(
//                 color: CColor.black
//             ),
//           )
//       ),
//
//       child: Row(
//         crossAxisAlignment:
//         CrossAxisAlignment.start,
//         mainAxisAlignment:
//         MainAxisAlignment.start,
//         children: [
//           Container(
//             width:MediaQuery.of(contex).size.width * Utils.getCaloriesRowColumnWidth(contex,logic),
//             alignment: Alignment
//                 .topCenter,
//             child: ListView.builder(
//               itemBuilder:
//                   (context, index) {
//                 return _itemCaloriesStepWeek(
//                     index,
//                     context,
//                     logic
//                         .caloriesDataList[
//                     index],
//                     logic,
//                     Constant
//                         .titleCalories);
//               },
//               padding:
//               const EdgeInsets.all(0),
//               shrinkWrap: true,
//               itemCount: logic
//                   .caloriesDataList
//                   .length,
//               physics:
//               const NeverScrollableScrollPhysics(),
//               scrollDirection:
//               Axis.vertical,
//             ),
//           ),
//
// /*        const VerticalDivider(
//             color: CColor.black,
//             width: 1,
//             thickness: 1,
//           )*/
//
//         ],
//       ),
//     );
//   }
//
//   Widget _widgetStepsDataList(Orientation orientation, HistoryController logic,BuildContext contex){
//     return Container(
//       decoration: const BoxDecoration(
//           border: Border(
//             right: BorderSide(
//                 color: CColor.black
//             ),
//           )
//       ),
//
//       child: Row(
//         crossAxisAlignment:
//         CrossAxisAlignment.start,
//         mainAxisAlignment:
//         MainAxisAlignment.start,
//         children: [
//           Container(
//             width: MediaQuery.of(contex).size.width * Utils.getStepsRowColumnWidth(contex,logic),
//             alignment: Alignment
//                 .topCenter,
//             child: ListView.builder(
//               itemBuilder:
//                   (context, index) {
//                 return _itemCaloriesStepWeek(
//                     index,
//                     context,
//                     logic
//                         .stepsDataList[
//                     index],
//                     logic,
//                     Constant
//                         .titleSteps);
//               },
//               padding:
//               const EdgeInsets.all(0),
//               shrinkWrap: true,
//               itemCount: logic
//                   .stepsDataList
//                   .length,
//               physics:
//               const NeverScrollableScrollPhysics(),
//               scrollDirection:
//               Axis.vertical,
//             ),
//           ),
//
// /* const VerticalDivider(
//             color: CColor.black,
//             width: 1,
//             thickness: 1,
//           )*/
//
//         ],
//       ),
//     );
//   }
//
//   Widget _widgetHeartRateDataList(Orientation orientation, HistoryController logic,BuildContext contex){
//     return Container(
//       decoration: const BoxDecoration(
//           border: Border(
//             right: BorderSide(
//                 color: CColor.black
//             ),
//           )
//       ),
//
//       child: Row(
//         crossAxisAlignment:
//         CrossAxisAlignment.start,
//         mainAxisAlignment:
//         MainAxisAlignment.start,
//         children: [
//           Container(
//             width: MediaQuery.of(contex).size.width * Utils.getHeartRateRowColumnWidth(contex,logic),
//             alignment: Alignment
//                 .topCenter,
//             child: ListView.builder(
//               itemBuilder:
//                   (context, index) {
//                 return _itemHeartRateWeek(
//                     index,
//                     context,
//                     logic
//                         .heartRateRestDataList[
//                     index],
//                     logic
//                         .heartRatePeakDataList[
//                     index],
//                     logic,
//                     Constant
//                         .titleHeartRateRest);
//               },
//               padding:
//               const EdgeInsets.all(0),
//               shrinkWrap: true,
//               itemCount: logic
//                   .heartRateRestDataList
//                   .length,
//               physics:
//               const NeverScrollableScrollPhysics(),
//               scrollDirection:
//               Axis.vertical,
//             ),
//           ),
//
// /* const VerticalDivider(
//             color: CColor.black,
//             width: 1,
//             thickness: 1,
//           )*/
//
//         ],
//       ),
//     );
//   }
//
//   Widget _widgetExperienceDataList(Orientation orientation, HistoryController logic,BuildContext contex){
//     return  Container(
//       decoration: const BoxDecoration(
//           border: Border(
//             right: BorderSide(
//                 color: CColor.black
//             ),
//           )
//       ),
//
//       child: Row(
//         crossAxisAlignment:
//         CrossAxisAlignment.start,
//         mainAxisAlignment:
//         MainAxisAlignment.start,
//         children: [
//           Container(
//             width:MediaQuery.of(contex).size.width * Utils.getExperienceRowColumnWidth(contex,logic),
//             alignment: Alignment
//                 .topCenter,
//             child: ListView.builder(
//               itemBuilder:
//                   (context,
//                   mainIndex) {
//                 return _itemExWeek(
//                     mainIndex,
//                     // logic.otherTitleSmileyData,
//                     logic.activityMinDataList,
//                     logic,
//                     orientation);
//               },
//               padding:
//               const EdgeInsets.all(0),
//               shrinkWrap: true,
//               itemCount:
//               logic.activityMinDataList.length,
//               physics:
//               const NeverScrollableScrollPhysics(),
//               scrollDirection:
//               Axis.vertical,
//             ),
//           ),
//
// /* const VerticalDivider(
//             color: CColor.black,
//             width: 1,
//             thickness: 1,
//           )*/
//
//         ],
//       ),
//     );
//   }
//
//   Widget leftSideWidget(Orientation orientation, HistoryController logic, BuildContext context){
//     return SizedBox(
//       width:MediaQuery.of(context).size.width * ((logic.isPortrait)?0.35:0.2),
//       child: Container(
//         decoration: const BoxDecoration(
//             border: Border(
//               right: BorderSide(
//                   color: CColor.black
//               ),
//             ),
//           // color: Colors.red
//         ),
//
//         child: Row(
//           crossAxisAlignment:
//           CrossAxisAlignment.start,
//           mainAxisAlignment:
//           MainAxisAlignment.start,
//           children: [
//             Expanded(
//               child: SizedBox(
//                 // width: Sizes.width_30,
//                 width: (orientation ==
//                     Orientation.portrait)
//                     ? Sizes.width_35
//                     : Sizes.width_50,
//                 child: ListView.builder(
//                   itemBuilder: (context,
//                       index) {
//                     return _itemWhatWhenWeek(
//                         index,
//                         context,
//                         logic,
//                         logic
//                             .activityMinDataList[index],
//                         orientation);
//                   },
//                   shrinkWrap: true,
//                   physics:
//                   const NeverScrollableScrollPhysics(),
//                   itemCount:
//                   logic.activityMinDataList.length,
//                   scrollDirection: Axis
//                       .vertical,
//                 ),
//               ),
//             ),
//             const VerticalDivider(
//               color: CColor.black,
//               width: 1,
//               thickness: 1,
//             )
//           ],
//         ),
//       )
//     );
//   }
//
//   _itemWhatWhenWeek(int mainIndex, BuildContext context, HistoryController logic,
//       LastWeekData data, Orientation orientation) {
//     return Column(
//       children: [
//         InkWell(
//           onTap: () {
//             logic.onExpandWeek(mainIndex);
//           },
//           child: SizedBox(
//             // height: Sizes.height_6,
//             height: Constant.commonHeightForTableBoxMobile,
//             child: Row(
//               children: [
//                 Icon(
//                   (logic.activityMinDataList[mainIndex].isExpanded)
//                       ? Icons.arrow_drop_up_rounded
//                       : Icons.arrow_drop_down_rounded,
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       alignment: Alignment.center,
//                       child: Text(
//                         "${DateFormat(Constant.commonDateFormatMmmDd).format(
//                             data.weekStartDate!)}-${DateFormat(Constant.commonDateFormatMmmDd).format(
//                             data.weekEndDate!)}",
//                         style: TextStyle(
//                             fontWeight: (logic.activityMinDataList[mainIndex].isExpanded)
//                                 ? FontWeight.w700
//                                 : FontWeight.normal),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//         (logic.activityMinDataList[mainIndex].isExpanded)
//             ? ListView.builder(
//           itemBuilder: (context, index) {
//             return _itemWhatWhenDay(index, context, data.weekDaysDataList,
//                 logic, mainIndex,orientation);
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
//     _itemWhatWhenDay(int daysIndex, BuildContext context,
//       List<WeekDays> weekDaysDataList, HistoryController logic, int mainIndex,Orientation orientation) {
//     return (logic.activityMinDataList[mainIndex].weekDaysDataList[daysIndex].isShow)?
//     Column(
//       children: [
//         Container(
//           height: Constant.commonHeightForTableBoxMobile,
//           padding: EdgeInsets.only(
//             right: Sizes.width_1_5,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               InkWell(
//                 onTap: () {
//                   if (logic.activityMinDataList[mainIndex].weekDaysDataList[daysIndex]
//                       .daysDataList.isNotEmpty) {
//                     logic.onExpandDays(mainIndex, daysIndex);
//                   }
//                 },
//                 child: Icon(
//                   (weekDaysDataList[daysIndex].isExpanded)
//                       ? Icons.arrow_drop_up_rounded
//                       : Icons.arrow_drop_down_rounded,
//                   color: (logic.activityMinDataList[mainIndex]
//                       .weekDaysDataList[daysIndex]
//                       .daysDataList.isNotEmpty)
//                       ? Colors.black
//                       : Colors.transparent,
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   if (logic.activityMinDataList[mainIndex].weekDaysDataList[daysIndex]
//                       .daysDataList.isNotEmpty) {
//                     logic.onExpandDays(mainIndex, daysIndex);
//                   }
//                 },
//                 child: Container(
//                   padding: EdgeInsets.only(
//                     // top: Sizes.height_1,
//                       right: Sizes.width_1_5,
//                       left: Sizes.width_1),
//                   alignment: Alignment.center,
//                   child: Text(
//                     "${weekDaysDataList[daysIndex].dayName} "
//                         "${DateFormat(Constant.commonDateFormatMmDd).format(weekDaysDataList[daysIndex].storedDate!)}",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: (weekDaysDataList[daysIndex].isExpanded)
//                             ? FontWeight.w700
//                             : FontWeight.normal),
//                   ),
//                 ),
//               ),
//               if ( logic
//                   .activityMinDataList[mainIndex]
//                   .weekDaysDataList[daysIndex]
//                   .activityLevelData.isNotEmpty && Constant.isEditMode)
//                 PopupMenuButton<String>(
//                   enabled:Constant.isEditMode,
//                   itemBuilder: (context) =>
//                       logic
//                           .activityMinDataList[mainIndex]
//                           .weekDaysDataList[daysIndex]
//                           .activityLevelData.map((e) => PopupMenuItem<String>(
//                                 value: e.toString(),
//                                 child:  Row(
//                                         children: [_widgetNumberImage(e,
//                                             logic
//                                                 .activityMinDataList[mainIndex]
//                                                 .weekDaysDataList[daysIndex]
//                                                 .activityLevelDataIcons[
//                                             logic
//                                                 .activityMinDataList[mainIndex]
//                                                 .weekDaysDataList[daysIndex]
//                                                 .activityLevelData.indexWhere((element) => element == e).toInt()
//                                             ].toString()),
//                                           ],
//                                       )
//                               ),
//                             )
//                             .toList(),
//                         offset: Offset(-Sizes.width_9, 0),
//                   color: Colors.grey[60],
//                   elevation: 2,
//                   onSelected: (value) {
//                     logic.addDaysDataWeekWise(
//                         mainIndex, daysIndex, value);
//                   },
//                   child: Container(
//                       padding: EdgeInsets.only(
//                         // top: Sizes.height_2_1_5,
//                           right: Sizes.width_1_5,
//                           left: Sizes.width_1_5),
//                       child: Text("+", style: TextStyle(
//                           fontSize: FontSize.size_13
//                       ),)),
//                 )
//               else
//                       Container(
//                         padding: EdgeInsets.only(
//                             // top: Sizes.height_2_1_5,
//                             right: Sizes.width_2,
//                             left: Sizes.width_1_5),
//                         child: Text(
//                           "+",
//                           style: TextStyle(fontSize: FontSize.size_1,color: CColor.white),
//                         ),
//                       ),
//                   ],
//           ),
//         ),
//         Utils.dividerCustom(color: CColor.transparent),
//         (weekDaysDataList[daysIndex].daysDataList.isNotEmpty &&
//             weekDaysDataList[daysIndex].isExpanded)
//
//             ? ListView.builder(
//           itemBuilder: (context, daysDataIndex) {
//             return Container(
//               height: Constant.commonHeightForTableBoxMobile,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       if (Constant.isEditMode) {
//                         logic.removeDaysDataIndexWise(
//                             mainIndex, daysIndex, daysDataIndex);
//                       }
//
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(10),
//                       // color: CColor.primaryColor,
//                       child: Icon(
//                         Icons.close,
//                         color: (Constant.isEditMode) ? CColor.red : Colors
//                             .grey,
//                         size: Sizes.width_4,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Container(
//                       margin: EdgeInsets.only(left: Sizes.width_1),
//                       child: Row(
//                         children: [
//                           Image.asset(
//
//                             weekDaysDataList[daysIndex]
//                                 .daysDataList[daysDataIndex]
//                                 .iconPath
//                                 .toString(),
//                             height: Sizes.width_5,
//                             width: Sizes.width_5,
//                           ),
//                           Expanded(
//                             child: Container(
//                               margin: EdgeInsets.only(left: Sizes.width_0_5),
//                               child: Text(
//                                 weekDaysDataList[daysIndex].daysDataList[daysDataIndex].displayLabel.toString(),
//                                 style: AppFontStyle.styleW400(CColor.black, FontSize.size_8),
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
//           padding: EdgeInsets.only(
//               left: MediaQuery
//                   .of(context)
//                   .size
//                   .width * 0.02),
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: weekDaysDataList[daysIndex].daysDataList.length,
//           shrinkWrap: true,
//         )
//             : Container()
//       ],
//     ):Container();
//   }
//
//   Widget _widgetNumberImage(String type,String iconName) {
//     return Row(
//       children: [
//         Image.asset(
//           // Utils.getNumberIconNameFromType(type),
//           iconName,
//           height: Sizes.width_5,
//           width: Sizes.width_5,
//         ),
//         Container(
//           margin: EdgeInsets.only(left: Sizes.width_0_5),
//           child: Text(
//             type,
//             style: AppFontStyle.styleW400(CColor.black, FontSize.size_8),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }
//
//   _itemActivityMinWeek(int mainIndex, BuildContext context, LastWeekData dataList,
//       HistoryController logic) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Container(
//           height: Constant.commonHeightForTableBoxMobile,
//           padding: EdgeInsets.only(
//             right: Sizes.width_1_5,
//             left: Sizes.width_1_5,
//           ),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//
//               (logic.trackingPrefList.where((element) => element.titleName == Constant.configurationHeaderModerate
//               && element.isSelected && Constant.boolActivityMinMod).toList().isNotEmpty )?
//               Expanded(
//                 child: Container(
//                   padding: EdgeInsets.only(
//                       bottom: Sizes.height_1
//                   ),
//                   child: editableMod(onChangeData: (value) {
//                   }, mainIndex, logic,Constant.activityMinutesMod,logic.trackingPrefList),
//                 ),
//               ):Container(),
//
//
//               const Text("  "),
//               (logic.trackingPrefList.where((element) => element.titleName == Constant.configurationHeaderVigorous
//                   && element.isSelected && Constant.boolActivityMinVig).toList().isNotEmpty )?Expanded(
//                 child: Container(
//                   padding: EdgeInsets.only(
//                       bottom: Sizes.height_1
//                   ),
//                   child: editableVig(onChangeData: (value) {
//                   }, mainIndex, logic,Constant.activityMinutesVig,logic.trackingPrefList),
//                 ),
//               ):Container(),
//
//
//               const Text("  "),
//               if(logic.trackingPrefList.where((element) => element.titleName == Constant.configurationHeaderTotal
//                   && element.isSelected).toList().isNotEmpty )Expanded(
//                 child: Container(
//                   padding: EdgeInsets.only(
//                       bottom: Sizes.height_1
//                   ),
//                   child: editableActivityMinutes(onChangeData: (value) {
//                   }, mainIndex, logic,Constant.activityMinutesTotal,logic.trackingPrefList),
//                 ),
//               ),
//
//
//               if (logic.trackingPrefList.where((element) =>
//               element.titleName == Constant.configurationNotes &&
//                   element.isSelected).toList().isNotEmpty)Expanded(
//                 child: InkWell(
//                   onTap: () {
//                     if(Constant.isEditMode && Constant.configurationInfo.where((element) => element.isNotes ).toList().isNotEmpty) {
//                       logic.setNotesOnController(
//                           logic.activityMinDataList[mainIndex].weeklyNotes);
//                       bottomAddNotesView(
//                           context, logic, Constant.typeWeek, mainIndex, -1, -1);
//                     }
//                   },
//                   child: Container(
//                     alignment: Alignment.center,
//                     child: (logic.activityMinDataList[mainIndex].weeklyNotes.isNotEmpty) ?Image.asset(
//                       "assets/icons/ic_comment.png",
//                       height: Sizes.width_4,
//                       width: Sizes.width_4,
//                       // color: Colors.grey,
//                     ) : Image.asset("assets/icons/ic_notecomment.png", height: Sizes.width_4,
//                       width: Sizes.width_4,
//                       color: (Constant.isEditMode &&
//                                       Constant.configurationInfo
//                                           .where((element) => element.isNotes)
//                                           .toList()
//                                           .isNotEmpty) ? CColor.black: CColor.gray,
//                             )),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Container(
//           child: (logic.activityMinDataList[mainIndex].isExpanded)
//               ? ListView.builder(
//             itemBuilder: (context, index) {
//               return _itemActivityMinDay(index, context,
//                   dataList.weekDaysDataList, logic, mainIndex);
//             },
//             shrinkWrap: true,
//             padding: const EdgeInsets.all(0),
//             itemCount: dataList.weekDaysDataList.length,
//             physics: const NeverScrollableScrollPhysics(),
//           )
//               : Container(),
//         ),
//         Utils.dividerCustom(),
//       ],
//     );
//   }
//
//   _itemActivityMinDay(int daysIndex, BuildContext context,
//       List<WeekDays> weekDaysDataList, HistoryController logic, int mainIndex) {
//     return (logic.activityMinDataList[mainIndex].weekDaysDataList[daysIndex].isShow)?
//     Column(
//       children: [
//         Column(
//           children: [
//             Container(
//               child: Utils.dividerCustom(),
//             ),
//             Container(
//               height: Constant.commonHeightForTableBoxMobile,
//               padding: EdgeInsets.only(
//                 right: Sizes.width_1_5,
//                 left: Sizes.width_1_5,
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   (logic.trackingPrefList.where((element) => element.titleName == Constant.configurationHeaderModerate
//                       && element.isSelected && Constant.boolActivityMinMod).toList().isNotEmpty )?Expanded(
//                     child: Container(
//                       padding: EdgeInsets.only(
//                           bottom: Sizes.height_1
//                       ),
//                       child: editableActivityMinModDay(onChangeData: (value) {
//                       }, mainIndex, daysIndex, logic,Constant.activityMinutesMod,logic.trackingPrefList),
//                     ),
//                   ):Container(),
//                   const Text("  "),
//
//                   (logic.trackingPrefList.where((element) => element.titleName == Constant.configurationHeaderVigorous
//                       && element.isSelected && Constant.boolActivityMinVig).toList().isNotEmpty )?Expanded(
//                     child: Container(
//                       padding: EdgeInsets.only(
//                           bottom: Sizes.height_1
//                       ),
//                       child: editableActivityMinVigDay(onChangeData: (value) {
//                       }, mainIndex, daysIndex, logic,Constant.activityMinutesVig,logic.trackingPrefList),
//                     ),
//                   ):Container(),
//                   const Text("  "),
//                   if(logic.trackingPrefList.where((element) => element.titleName == Constant.configurationHeaderTotal
//                       && element.isSelected).toList().isNotEmpty )Expanded(
//                     child: Container(
//                       padding: EdgeInsets.only(
//                           bottom: Sizes.height_1
//                       ),
//                       child: editableActivityMiTotalDays(onChangeData: (value) {
//                       }, mainIndex, daysIndex, logic,Constant.activityMinutesTotal,logic.trackingPrefList),
//                     ),
//                   ),
//
//                   if (logic.trackingPrefList.where((element) =>
//                   element.titleName == Constant.configurationNotes &&
//                       element.isSelected).toList().isNotEmpty)Expanded(
//                     child: InkWell(
//                       onTap: () {
//                         if(Constant.isEditMode && Constant.configurationInfo.where((element) => element.isNotes ).toList().isNotEmpty) {
//                           logic.setNotesOnController(logic.activityMinDataList[mainIndex]
//                               .weekDaysDataList[daysIndex].dailyNotes);
//                           bottomAddNotesView(context,logic,Constant.typeDay,mainIndex,daysIndex,-1);
//                         }
//
//                       },
//                       child: Container(
//                         alignment: Alignment.center,
//                         child:
//                           (logic.activityMinDataList[mainIndex]
//                               .weekDaysDataList[daysIndex].dailyNotes.isNotEmpty)?Image.asset(
//                             "assets/icons/ic_comment.png",
//                             height: Sizes.width_4,
//                             width: Sizes.width_4,
//                             // color: Colors.grey,
//                           ) : Image.asset("assets/icons/ic_notecomment.png",height: Sizes.width_4,
//                               width: Sizes.width_4,
//                             color: (Constant.isEditMode &&
//                                                 Constant.configurationInfo
//                                                     .where((element) =>
//                                                         element.isNotes)
//                                                     .toList()
//                                                     .isNotEmpty)
//                                             ? CColor.black
//                                             : CColor.gray,
//                                       )),
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
//               // height: Sizes.height_7,
//               height: Constant.commonHeightForTableBoxMobile,
//               padding: EdgeInsets.only(
//                 right: Sizes.width_1_5,
//                 left: Sizes.width_1_5,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   if(logic.trackingPrefList.where((element) => element.titleName == Constant.configurationHeaderModerate
//                       && element.isSelected && Constant.boolActivityMinMod).toList().isNotEmpty )Expanded(
//                     child: Container(
//                       padding: EdgeInsets.only(
//                         bottom: Sizes.height_1,
//                       ),
//                       child: editableActivityMinModDayData(
//                           onChangeData: (value) {
//                           }, mainIndex, daysIndex, daysDataIndex, logic),
//                     ),
//                   ),
//                   const Text("  "),
//
//                   if(logic.trackingPrefList.where((element) => element.titleName == Constant.configurationHeaderVigorous
//                       && element.isSelected && Constant.boolActivityMinVig).toList().isNotEmpty )Expanded(
//                     child: Container(
//                       padding: EdgeInsets.only(
//                         bottom: Sizes.height_1,
//                       ),
//                       child: editableActivityMinVigDayData(
//                           onChangeData: (value) {
//                           }, mainIndex, daysIndex, daysDataIndex, logic),
//                     ),
//                   ),
//                   const Text("  "),
//
//                   if(logic.trackingPrefList.where((element) => element.titleName == Constant.configurationHeaderTotal
//                       && element.isSelected).toList().isNotEmpty )Expanded(
//                     child: Container(
//                       padding: EdgeInsets.only(
//                         bottom: Sizes.height_1,
//                       ),
//                       child: editableActivityMinTotalDaysData(
//                           onChangeData: (value) {
//                           }, mainIndex, daysIndex, daysDataIndex, logic),
//                     ),
//                   ),
//
//                   if (logic.trackingPrefList.where((element) =>
//                   element.titleName == Constant.configurationNotes &&
//                       element.isSelected).toList().isNotEmpty)Expanded(
//                     child: InkWell(
//                       onTap: () {
//                         if(Constant.isEditMode && Constant.configurationInfo.where((element) => element.title ==
//                             logic.activityMinDataList[mainIndex].weekDaysDataList[daysIndex].daysDataList[daysDataIndex].displayLabel &&
//                             element.isNotes ).toList().isNotEmpty){
//                           logic.setNotesOnController(logic.activityMinDataList[mainIndex]
//                               .weekDaysDataList[daysIndex].daysDataList[daysDataIndex].dayDataNotes);
//                           bottomAddNotesView(context,logic,Constant.typeDaysData,mainIndex,daysIndex,daysDataIndex);
//                         }
//                       },
//                       child: Container(
//                         alignment: Alignment.center,
//                         child:
//                           (logic.activityMinDataList[mainIndex]
//                               .weekDaysDataList[daysIndex].daysDataList[daysDataIndex].dayDataNotes.isNotEmpty)?Image.asset(
//                             "assets/icons/ic_comment.png",
//                             height: Sizes.width_4,
//                             width: Sizes.width_4,
//                             // color: Colors.grey,
//                           ) : Image.asset("assets/icons/ic_notecomment.png",height: Sizes.width_4,
//                               width: Sizes.width_4,color: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.title ==
//                                 logic.activityMinDataList[mainIndex].weekDaysDataList[daysIndex].daysDataList[daysDataIndex].displayLabel &&
//                                 element.isNotes ).toList().isNotEmpty) ? CColor.black : CColor.gray,)
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//           shrinkWrap: true,
//           padding: const EdgeInsets.all(0),
//           itemCount: weekDaysDataList[daysIndex].daysDataList.length,
//           physics: const NeverScrollableScrollPhysics(),
//         )
//             : Container(
//           padding: EdgeInsets.zero,
//         ),
//       ],
//     ):Container();
//   }
//
//   _itemCaloriesStepWeek(int mainIndex, BuildContext context,
//       CaloriesStepHeartRateWeek dataList, HistoryController logic, String titleType) {
//     return Container(
//       margin: const EdgeInsets.all(0),
//       child: Column(
//         children: [
//           Container(
//             // height: Sizes.height_6,
//               height: Constant.commonHeightForTableBoxMobile,
//               padding: EdgeInsets.only(
//                 right: Sizes.width_1_5,
//                 left: Sizes.width_1_5,
//               ),
//               child: Container(
//                 padding: EdgeInsets.only(
//                   bottom: Sizes.height_1,
//                 ),
//                 // child: _editableTextTitleAndOtherWeek(mainIndex, logic, dataList,
//                 child: editableCalStepWeek(mainIndex, logic, titleType,dataList,logic.trackingPrefList,
//                     onChangeData: (value) {
//                       logic.onChangeCalStepWeeks(
//                           mainIndex, value, dataList.titleName);
//                     }),
//               )
//             // _editableText(),
//           ),
//           (dataList.isExpanded)
//               ? ListView.builder(
//             itemBuilder: (context, daysIndex) {
//               return _itemCalStepDays(daysIndex, context,
//                   dataList.daysList, logic, mainIndex, titleType);
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
//   _itemCalStepDays(int daysIndex,
//       BuildContext context,
//       List<CaloriesStepHeartRateDay> weekDaysDataList,
//       HistoryController logic,
//       int mainIndex,
//       String titleType) {
//     return (logic.activityMinDataList[mainIndex].weekDaysDataList[daysIndex].isShow)?
//     Column(
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Utils.dividerCustom(),
//             Container(
//               // height: Sizes.height_7,
//                 height: Constant.commonHeightForTableBoxMobile,
//                 padding: EdgeInsets.only(
//                   right: Sizes.width_1_5,
//                   left: Sizes.width_1_5,
//
//                 ),
//                 alignment: Alignment.bottomCenter,
//
//                 child: Container(
//                   padding: EdgeInsets.only(
//                     bottom: Sizes.height_1,
//                   ),
//                   child: editableCalStepDay(
//                       daysIndex, logic, weekDaysDataList[daysIndex],
//                       onChangeData: (value) {
//                       }, mainIndex, titleType,logic.trackingPrefList),
//                 )
//             ),
//           ],
//         ),
//         // (weekDaysDataList[daysIndex].daysDataList.isNotEmpty &&
//         (weekDaysDataList[daysIndex].daysDataList.isNotEmpty &&
//             weekDaysDataList[daysIndex].isExpanded)
//             ? ListView.builder(
//           itemBuilder: (context, daysDataIndex) {
//             return Container(
//                 height: Constant.commonHeightForTableBoxMobile,
//                 margin:
//                 EdgeInsets.symmetric(horizontal: Sizes.width_1_5),
//                 padding: EdgeInsets.only(
//                   bottom: Sizes.height_1,
//                 ),
//                 // child: _editableTextTitle2AndOtherDaysData(
//                 child:(titleType == Constant.titleCalories) ? editableCalStepDayData(
//                     daysDataIndex,
//                     logic,
//                     mainIndex,
//                     daysIndex,titleType,
//                     weekDaysDataList[daysIndex]
//                         .daysDataList[daysDataIndex],
//                     onChangeData: (value) {
//                     }) : editableCalStepDayDataSteps(
//                     daysDataIndex,
//                     logic,
//                     mainIndex,
//                     daysIndex,titleType,
//                     weekDaysDataList[daysIndex]
//                         .daysDataList[daysDataIndex],
//                     onChangeData: (value) {
//                     }) ,
//             );
//           },
//           shrinkWrap: true,
//           itemCount: weekDaysDataList[daysIndex].daysDataList.length,
//           physics: const NeverScrollableScrollPhysics(),
//         )
//             : Container(
//           padding: EdgeInsets.zero,
//         ),
//       ],
//     ):Container();
//   }
//
//   _itemHeartRateWeek(int mainIndex,
//       BuildContext context,
//       CaloriesStepHeartRateWeek otherTitle5Data,
//       CaloriesStepHeartRateWeek otherTitle6Data,
//       HistoryController logic,
//       String titleType) {
//     return Container(
//       margin: const EdgeInsets.all(0),
//       child: Column(
//         children: [
//           Container(
//               height: Constant.commonHeightForTableBoxMobile,
//               padding: EdgeInsets.only(
//                 right: Sizes.width_1_5,
//                 left: Sizes.width_1_5,
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   if (logic.trackingPrefList.where((element) =>
//                   element.titleName == Constant.configurationHeaderRest &&
//                       element.isSelected).toList().isNotEmpty) Expanded(
//                     child: Container(
//                       padding: EdgeInsets.only(
//                         bottom: Sizes.height_1,
//                       ),
//                       child: editableRestWeek(
//                           mainIndex, logic, otherTitle5Data,logic.trackingPrefList,
//                           onChangeData: (value) {
//                           }),
//                     ),
//                   ),
//                   SizedBox(
//                     width: Sizes.width_2,
//                   ),
//                   if (logic.trackingPrefList.where((element) =>
//                   element.titleName == Constant.configurationHeaderPeck &&
//                       element.isSelected).toList().isNotEmpty)
//                     Expanded(
//                     child: Container(
//                       padding: EdgeInsets.only(
//                         bottom: Sizes.height_1,
//                       ),
//                       child: editablePeakWeek(
//                           mainIndex, logic, otherTitle6Data,logic.trackingPrefList,
//                           onChangeData: (value) {
//                           }),
//                     ),
//                   ),
//                 ],
//               )),
//           (otherTitle5Data.isExpanded && otherTitle6Data.isExpanded)
//               ? ListView.builder(
//             itemBuilder: (context, daysIndex) {
//               return _itemHeartRateDay(
//                   daysIndex,
//                   context,
//                   otherTitle5Data.daysList,
//                   otherTitle6Data.daysList,
//                   logic,
//                   mainIndex,
//                   titleType);
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
//   _itemHeartRateDay(int daysIndex,
//       BuildContext context,
//       List<CaloriesStepHeartRateDay> weekDaysDataListTitle5,
//       List<CaloriesStepHeartRateDay> weekDaysDataListTitle6,
//       HistoryController logic,
//       int mainIndex,
//       String titleType) {
//     return (logic.activityMinDataList[mainIndex].weekDaysDataList[daysIndex].isShow)?
//     Column(
//       children: [
//         Column(
//           children: [
//             Utils.dividerCustom(),
//             Container(
//                 height: Constant.commonHeightForTableBoxMobile,
//                 alignment: Alignment.bottomCenter,
//                 padding: EdgeInsets.only(
//                   right: Sizes.width_1_5,
//                   left: Sizes.width_1_5,
//                 ),
//                 child: Row(
//                   children: [
//                     if (logic.trackingPrefList.where((element) =>
//                     element.titleName == Constant.configurationHeaderRest &&
//                         element.isSelected).toList().isNotEmpty)Expanded(
//                       child: Container(
//                         padding: EdgeInsets.only(
//                           bottom: Sizes.height_1,
//                         ),
//                         child: editableRestDay(
//                             mainIndex, logic, weekDaysDataListTitle5[daysIndex],logic.trackingPrefList,
//                             onChangeData: (value) {
//                             }),
//                       ),
//                     ),
//                     SizedBox(
//                       width: Sizes.width_2,
//                     ),
//                     if (logic.trackingPrefList.where((element) =>
//                     element.titleName == Constant.configurationHeaderPeck &&
//                         element.isSelected).toList().isNotEmpty)Expanded(
//                       child: Container(
//                         padding: EdgeInsets.only(
//                           bottom: Sizes.height_1,
//                         ),
//                         child: editablePeakDay(
//                             mainIndex, logic, weekDaysDataListTitle6[daysIndex],logic.trackingPrefList,
//                             onChangeData: (value) {
//                             }),
//                       ),
//                     ),
//                   ],
//                 )
//             ),
//           ],
//         ),
//         ((weekDaysDataListTitle5[daysIndex].daysDataList.isNotEmpty &&
//             weekDaysDataListTitle5[daysIndex].isExpanded) ||
//             weekDaysDataListTitle6[daysIndex].daysDataList.isNotEmpty &&
//                 weekDaysDataListTitle6[daysIndex].isExpanded)
//             ? ListView.builder(
//           itemBuilder: (context, daysDataIndex) {
//             return Container(
//                 height: Constant.commonHeightForTableBoxMobile,
//                 margin: EdgeInsets.only(
//                   right: Sizes.width_1_5,
//                   left: Sizes.width_1_5,
//                 ),
//                 padding: EdgeInsets.only(
//                   bottom: Sizes.height_1,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     if (logic.trackingPrefList.where((element) =>
//                     element.titleName == Constant.configurationHeaderRest &&
//                         element.isSelected).toList().isNotEmpty)Expanded(
//                       child: editableRestDayData(
//                           mainIndex,
//                           daysIndex,
//                           daysDataIndex,
//                           logic,
//                           weekDaysDataListTitle5[daysIndex]
//                               .daysDataList[daysDataIndex],
//                           onChangeData: (value) {
//                           }),
//                     ),
//                     SizedBox(
//                       width: Sizes.width_2,
//                     ),
//                     if (logic.trackingPrefList.where((element) =>
//                     element.titleName == Constant.configurationHeaderPeck &&
//                         element.isSelected).toList().isNotEmpty)Expanded(
//                       child: editablePeakDayData(
//                           mainIndex,
//                           daysIndex,
//                           daysDataIndex,
//                           logic,
//                           weekDaysDataListTitle6[daysIndex]
//                               .daysDataList[daysDataIndex],
//                           onChangeData: (value) {
//                           }),
//                     ),
//                   ],
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
//     ):Container();
//   }
//
//   _widgetToggleFilter(BuildContext context,HistoryController logic, Orientation orientation) {
//     return Container(
//       padding: EdgeInsets.only(
//         bottom: Sizes.height_1,
//       ),
//       alignment: Alignment.center,
//       child: Row(
//         children: [
//           _widgetToggle(context,logic),
//           const Spacer(),
//           _widgetDatePicker(context,logic),
//           _widgetFilter(context,logic,orientation)
//         ],
//       ),
//     );
//   }
//
//   _widgetToggle(BuildContext context,HistoryController logic, {bool isLandscape = false}) {
//     return Container(
//       margin: EdgeInsets.only(
//         left: Sizes.width_5,
//         top: (isLandscape)?0:Sizes.height_2,
//       ),
//       child:  Container(
//         alignment: Alignment.center,
//         child: PopupMenuButton<int>(
//           enabled: Constant.isEditMode,
//           itemBuilder: (context) => [
//             PopupMenuItem(
//               value: 1,
//               child: Row(
//                 children: [
//                   Text((logic.isWeekExpanded)?"Week Collapse":"Week Expand"),
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
//                   Text((logic.isDayExpanded)?"Day Collapse":"Day Expand"),
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
//                   Text((logic.isHideRow)?"Show empty row":"Hide empty row"),
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
//             logic.onChangeExpand(value);
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
//   _widgetFilter(BuildContext context,HistoryController logic, Orientation orientation,{bool isLandscape = false}) {
//     return InkWell(
//       onTap: () {
//         showFilterDialog(logic, context,orientation);
//       },
//       child: Container(
//         alignment: Alignment.center,
//         margin: EdgeInsets.only(
//           right: Sizes.width_4,
//           top: (isLandscape)?0:Sizes.height_2,
//         ),
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//             border: Border.all(color: CColor.black, width: 1),
//             borderRadius: BorderRadius.circular(7)),
//         child: const Icon(
//           Icons.filter_list_rounded,
//           color: CColor.black,
//         ),
//       ),
//     );
//   }
//
//   void showFilterDialog(HistoryController logic, BuildContext context, Orientation orientation) {
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
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
//                     (orientation == Orientation.landscape)?
//                     Expanded(
//                       child: Container(
//                         margin: EdgeInsets.only(left: Sizes.width_2_5),
//                         child: ListView.builder(
//                           itemBuilder: (context, index) {
//                             return Row(
//                               children: [
//                                 Text(
//                                   logic.titlesListData[index].titleName
//                                       .toString(),
//                                 ),
//                                 Checkbox(
//                                   value: logic.titlesListData[index].selected,
//                                   onChanged: (value) {
//                                     logic.onChangeTitle(
//                                         !logic.titlesListData[index].selected,
//                                         index);
//                                     setState(() {});
//                                   },
//                                 )
//                               ],
//                             );
//                           },
//                           shrinkWrap: true,
//                           itemCount: logic.titlesListData.length,
//                           physics: const AlwaysScrollableScrollPhysics(),
//                         ),
//                       ),
//                     ):Container(
//                       margin: EdgeInsets.only(left: Sizes.width_2_5),
//                       child: ListView.builder(
//                         itemBuilder: (context, index) {
//                           return Row(
//                             children: [
//                               Text(
//                                 logic.titlesListData[index].titleName
//                                     .toString(),
//                               ),
//                               Checkbox(
//                                 value: logic.titlesListData[index].selected,
//                                 onChanged: (value) {
//                                   logic.onChangeTitle(
//                                       !logic.titlesListData[index].selected,
//                                       index);
//                                   setState(() {});
//                                 },
//                               )
//                             ],
//                           );
//                         },
//                         shrinkWrap: true,
//                         itemCount: logic.titlesListData.length,
//                         physics: const AlwaysScrollableScrollPhysics(),
//                       ),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         TextButton(
//                           onPressed: () {
//                             Get.back();
//                           },
//                           child: Text(
//                             "Cancel",
//                             style: AppFontStyle.styleW600(
//                               CColor.black,
//                               FontSize.size_12,
//                             ),
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             logic.onChangeTitleTapOnOk();
//                           },
//                           child: Text(
//                             "Ok",
//                             style: AppFontStyle.styleW600(
//                               CColor.black,
//                               FontSize.size_12,
//                             ),
//                           ),
//                         ),
//                       ],
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
//   _widgetDatePicker(BuildContext context,HistoryController logic,{bool isLandscape = false}) {
//     return InkWell(
//       onTap: () {
//         showDatePickerDialog(logic, context);
//       },
//       child: Container(
//         alignment: Alignment.center,
//         margin: EdgeInsets.only(
//           right: Sizes.width_2,
//           top: (isLandscape)?0:Sizes.height_2,
//         ),
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//             border: Border.all(color: CColor.black, width: 1),
//             borderRadius: BorderRadius.circular(7)),
//         child: const Icon(
//           Icons.date_range_outlined,
//           color: CColor.black,
//         ),
//       ),
//     );
//   }
//
//   void showDatePickerDialog(HistoryController logic, BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
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
//                     },
//                     selectionMode: DateRangePickerSelectionMode.single,
//                     view: DateRangePickerView.month,
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
//   _widgetSelectedDates(BuildContext context, HistoryController logic,{bool isLandscape = false}) {
//     return (logic.startDate != "" && logic.endDate != "")
//         ? Container(
//       margin: EdgeInsets.symmetric(
//           horizontal: Sizes.width_4, vertical: Sizes.height_1),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           InkWell(
//             onTap: () {
//               logic.getAndSetWeeksData(logic.previousDate,isTap: true);
//             },
//             child: Container(
//               padding: const EdgeInsets.all(10),
//               child: const Icon(
//                 Icons.arrow_back_ios_new_rounded,
//               ),
//             ),
//           ),
//                 (isLandscape)
//                     ? Container(
//                   margin: EdgeInsets.symmetric(horizontal: Sizes.width_5),
//                         alignment: Alignment.center,
//                         child: Text(
//                           "${logic.startDate} - ${logic.endDate}",
//                           style: AppFontStyle.styleW700(
//                               CColor.black, FontSize.size_10),
//                         ),
//                       )
//                     : Expanded(
//                         child: Container(
//                           alignment: Alignment.center,
//                           child: Text(
//                             "${logic.startDate} - ${logic.endDate}",
//                             style: AppFontStyle.styleW700(
//                                 CColor.black, FontSize.size_10),
//                           ),
//                         ),
//                       ),
//                 InkWell(
//             onTap: () {
//               logic.getAndSetWeeksData(logic.nextDate,isNext: true,isTap: true);
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
//   Widget _itemExWeek(
//       int mainIndex, List<LastWeekData> dataList, HistoryController logic,
//       Orientation orientation) {
//     return StatefulBuilder(
//       builder: (context, setState) {
//         return Container(
//           margin: const EdgeInsets.all(0),
//           child: Column(
//             children: [
//               Container(
//                 alignment: Alignment.center,
//                 child: PopupMenuButton<int>(
//                   // enabled: Constant.isEditMode,
//                   enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.isExperience ).toList().isNotEmpty),
//                   itemBuilder: (context) =>
//                   [
//                     PopupMenuItem(
//                       value: 1,
//                       child:
//                       Utils.getSmileyWidget(Constant.smiley1ImgPath,Constant.smiley1Title),
//                     ),
//                     PopupMenuItem(
//                       value: 2,
//                       child:
//                       Utils.getSmileyWidget(Constant.smiley2ImgPath,Constant.smiley2Title),
//                     ),
//                     PopupMenuItem(
//                       value: 3,
//                       child:
//                       Utils.getSmileyWidget(Constant.smiley3ImgPath,Constant.smiley3Title),
//                     ),
//                     PopupMenuItem(
//                       value: 4,
//                       child:
//                       Utils.getSmileyWidget(Constant.smiley4ImgPath,Constant.smiley4Title),
//                     ),
//                     PopupMenuItem(
//                       value: 5,
//                       child:
//                       Utils.getSmileyWidget(Constant.smiley5ImgPath,Constant.smiley5Title),
//                     ),
//                     PopupMenuItem(
//                       value: 6,
//                       child:
//                       Utils.getSmileyWidget(Constant.smiley6ImgPath,Constant.smiley6Title),
//                     ),
//                     PopupMenuItem(
//                       value: 7,
//                       child:
//                       Utils.getSmileyWidget(Constant.smiley7ImgPath,Constant.smiley7Title),
//                     ),
//                   ],
//                   offset: Offset(-Sizes.width_9, 0),
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
//                   child: SizedBox(
//                     height: Constant.commonHeightForTableBoxMobile,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Image.asset(Utils.getIconNameFromType(logic
//                             .activityMinDataList[mainIndex].smileyType),
//                             width: Sizes.width_8, height: Sizes.height_2),
//                         (Constant.isEditMode && Constant.configurationInfo.where((element) => element.isExperience ).toList().isNotEmpty)?const Icon(
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
//                   return _itemExDay(mainIndex, daysIndex,
//                       dataList[mainIndex].weekDaysDataList, orientation, logic);
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
//   Widget _itemExDay(int mainIndex,
//       int dayIndex,
//       List<WeekDays> weekDaysDataList,
//       Orientation orientation,
//       HistoryController logic) {
//     return (logic.activityMinDataList[mainIndex].weekDaysDataList[dayIndex].isShow)?
//     Column(
//       children: [
//         Container(
//           alignment: Alignment.center,
//           child: PopupMenuButton<int>(
//             // enabled: Constant.isEditMode,
//             enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.isExperience ).toList().isNotEmpty),
//             itemBuilder: (context) =>
//             [
//               PopupMenuItem(
//                 value: 1,
//                 child:
//                 Utils.getSmileyWidget(Constant.smiley1ImgPath,Constant.smiley1Title),
//               ),
//               PopupMenuItem(
//                 value: 2,
//                 child:
//                 Utils.getSmileyWidget(Constant.smiley2ImgPath,Constant.smiley2Title),
//               ),
//               PopupMenuItem(
//                 value: 3,
//                 child:
//                 Utils.getSmileyWidget(Constant.smiley3ImgPath,Constant.smiley3Title),
//               ),
//               PopupMenuItem(
//                 value: 4,
//                 child:
//                 Utils.getSmileyWidget(Constant.smiley4ImgPath,Constant.smiley4Title),
//               ),
//               PopupMenuItem(
//                 value: 5,
//                 child:
//                 Utils.getSmileyWidget(Constant.smiley5ImgPath,Constant.smiley5Title),
//               ),
//               PopupMenuItem(
//                 value: 6,
//                 child:
//                 Utils.getSmileyWidget(Constant.smiley6ImgPath,Constant.smiley6Title),
//               ),
//               PopupMenuItem(
//                 value: 7,
//                 child:
//                 Utils.getSmileyWidget(Constant.smiley7ImgPath,Constant.smiley7Title),
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
//             child: SizedBox(
//               // height: Sizes.height_7,
//               height: Constant.commonHeightForTableBoxMobile,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(Utils.getIconNameFromType(logic
//                       .activityMinDataList[mainIndex].weekDaysDataList[dayIndex]
//                       .smileyType),
//                       width: Sizes.width_8, height: Sizes.height_2),
//                   (Constant.isEditMode && Constant.configurationInfo.where((element) => element.isExperience ).toList().isNotEmpty)?const Icon(
//                     Icons.arrow_drop_down_sharp,
//                   ):Container(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         Utils.dividerCustom(color: CColor.transparent),
//         (weekDaysDataList[dayIndex].isExpanded)
//             ? ListView.builder(
//           itemBuilder: (context, daysDataIndex) {
//             return _itemExDayData(
//                 mainIndex,
//                 dayIndex,
//                 daysDataIndex,
//                 weekDaysDataList[dayIndex].daysDataList,
//                 orientation, logic);
//           },
//           shrinkWrap: true,
//           padding: EdgeInsets.zero,
//           itemCount: weekDaysDataList[dayIndex].daysDataList.length,
//           physics: const NeverScrollableScrollPhysics(),
//         )
//             : Container(),
//       ],
//     ):Container();
//   }
//
//   Widget _itemExDayData(int mainIndex, int dayIndex, int dayDataIndex,
//       List<DaysData> daysDataList, Orientation orientation,
//       HistoryController logic) {
//     return Container(
//       alignment: Alignment.center,
//       child: PopupMenuButton<int>(
//         enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.title ==
//             logic.activityMinDataList[mainIndex].weekDaysDataList[dayIndex].daysDataList[dayDataIndex].displayLabel &&
//             element.isExperience ).toList().isNotEmpty),
//         itemBuilder: (context) =>
//         [
//           PopupMenuItem(
//             value: 1,
//             child:
//             Utils.getSmileyWidget(Constant.smiley1ImgPath,Constant.smiley1Title),
//           ),
//           PopupMenuItem(
//             value: 2,
//             child:
//             Utils.getSmileyWidget(Constant.smiley2ImgPath,Constant.smiley2Title),
//           ),
//           PopupMenuItem(
//             value: 3,
//             child:
//             Utils.getSmileyWidget(Constant.smiley3ImgPath,Constant.smiley3Title),
//           ),
//           PopupMenuItem(
//             value: 4,
//             child:
//             Utils.getSmileyWidget(Constant.smiley4ImgPath,Constant.smiley4Title),
//           ),
//           PopupMenuItem(
//             value: 5,
//             child:
//             Utils.getSmileyWidget(Constant.smiley5ImgPath,Constant.smiley5Title),
//           ),
//           PopupMenuItem(
//             value: 6,
//             child:
//             Utils.getSmileyWidget(Constant.smiley6ImgPath,Constant.smiley6Title),
//           ),
//           PopupMenuItem(
//             value: 7,
//             child:
//             Utils.getSmileyWidget(Constant.smiley7ImgPath,Constant.smiley7Title),
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
//         child: SizedBox(
//           // height: Sizes.height_7,
//           height: Constant.commonHeightForTableBoxMobile,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//                  Image.asset(Utils.getIconNameFromType(
//                   logic.activityMinDataList[mainIndex].weekDaysDataList[dayIndex]
//                       .daysDataList[dayDataIndex].smileyType),
//                   width: Sizes.width_8, height: Sizes.height_2),
//                (Constant.isEditMode && Constant.configurationInfo.where((element) => element.title ==
//                    logic.activityMinDataList[mainIndex].weekDaysDataList[dayIndex].daysDataList[dayDataIndex].displayLabel &&
//                    element.isExperience ).toList().isNotEmpty) ? const Icon(
//                   Icons.arrow_drop_down_sharp,
//                  )
//                  : Container()
//                //
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _editableDaysStrWeek(int index, HistoryController logic,
//       OtherTitles2CheckBoxWeek dataList,
//       {Function? onChangeData}) {
//     return  SizedBox(
//         // width: 20,
//         // height: 20,
//         child: TextField(
//           textAlign: TextAlign.right,
//           // enabled: Constant.isEditMode,
//           enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.isDaysStr ).toList().isNotEmpty ) ,
//
//           enableInteractiveSelection: false,
//           focusNode: dataList.weekValueTitle2CheckBoxFocus,
//           textInputAction: TextInputAction.done,
//           inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//           keyboardType: Utils.getInputTypeKeyboard(),
//           // keyboardType: TextInputType.number,
//           // inputFormatters: [
//           //   FilteringTextInputFormatter.allow(RegExp(r"\d+([\.]\d+)?")),
//           // ],
//           style: TextStyle(fontSize: FontSize.size_10),
//           maxLines: 1,
//           autofocus: false,
//           autocorrect: true,
//           controller: dataList.weekValueTitle2CheckBoxController,
//           onChanged: (value) {
//             if (onChangeData != null) {
//               onChangeData.call(value);
//             }
//           },
//         ),
//       );
//   }
//
//   _itemDaysStrengthWeek(int mainIndex, BuildContext context,
//       OtherTitles2CheckBoxWeek dataList, HistoryController logic,
//       String titleType) {
//     return Container(
//       margin: const EdgeInsets.all(0),
//       child: Column(
//         children: [
//           Container(
//               height: Constant.commonHeightForTableBoxMobile,
//               padding: EdgeInsets.only(
//                 right: Sizes.width_1_5,
//                 left: Sizes.width_1_5,
//               ),
//               child: Container(
//                 padding: EdgeInsets.only(
//                   bottom: Sizes.height_1,
//                 ),
//                 child: _editableDaysStrWeek(mainIndex, logic, dataList,
//                     onChangeData: (value) {
//                       logic.onChangeDaysStrWeek(
//                           mainIndex, value, dataList.titleName);
//                     },
//                 ),
//               )
//           ),
//           (dataList.isExpanded)
//               ? ListView.builder(
//             itemBuilder: (context, daysIndex) {
//               return _itemDaysStrengthDays(daysIndex, context,
//                   dataList.daysListCheckBox, logic, mainIndex, titleType);
//             },
//             shrinkWrap: true,
//
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
//   _itemDaysStrengthDays(int daysIndex,
//       BuildContext context,
//       List<OtherTitles2CheckBoxDay> daysListCheckBox,
//       HistoryController logic,
//       int mainIndex,
//       String titleType) {
//     return (logic.activityMinDataList[mainIndex].weekDaysDataList[daysIndex].isShow)?
//     Column(
//       children: [
//         Utils.dividerCustom(),
//         SizedBox(
//           height: Constant.commonHeightForTableBoxMobile,
//           child: Checkbox(
//             value: daysListCheckBox[daysIndex].isCheckedDay,
//             onChanged: (!Constant.isEditMode || Constant.configurationInfo.where((element) => element.isDaysStr )
//                 .toList().isEmpty ) ? null : (value) {
//               logic.onChangeDaysStrengthCheckBoxDay(mainIndex, daysIndex);
//             },
//           ),
//         ),
//         (daysListCheckBox[daysIndex].isExpanded)
//             ? ListView.builder(
//           itemBuilder: (context, daysDataIndex) {
//             return _itemDaysStrengthDaysData(
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
//           itemCount: daysListCheckBox[daysIndex].daysDataListCheckBox.length,
//           physics: const NeverScrollableScrollPhysics(),
//         )
//             : Container(),
//       ],
//     ):Container();
//   }
//
//   _itemDaysStrengthDaysData(int daysIndex,
//       BuildContext context,
//       List<OtherTitles2CheckBoxDaysData> daysDataListCheckBox,
//       HistoryController logic,
//       int mainIndex,
//       int daysDataIndex,
//       String titleType) {
//     return SizedBox(
//       // height: Sizes.height_7,
//       height: Constant.commonHeightForTableBoxMobile,
//       child: Checkbox(
//         value: daysDataListCheckBox[daysDataIndex].isCheckedDaysData,
//         onChanged: (logic.activityMinDataList[mainIndex].weekDaysDataList[daysIndex].daysDataList.isNotEmpty)?
//         (!Constant.isEditMode || Constant.configurationInfo.where((element) => element.title ==
//             logic.activityMinDataList[mainIndex].weekDaysDataList[daysIndex].daysDataList[daysDataIndex].displayLabel &&
//             element.isDaysStr ).toList().isEmpty ) ? (value) {
//
//             } :  null : (value) {
//           logic.onChangeDaysStrengthCheckBoxDaysData(mainIndex, daysIndex, daysDataIndex);
//         },
//       ),
//     );
//   }
//
//   bottomAddNotesView(BuildContext context, HistoryController logic, int type, int mainIndex, int daysIndex, int daysDataIndex) {
//     Future<void> future = showModalBottomSheet<void>(
//         context: context,
//         isScrollControlled: true,
//         backgroundColor: CColor.transparent,
//         builder: (context) {
//           return StatefulBuilder(
//             builder: (context, StateSetter setStateBottom) {
//               return Padding(
//                 padding: EdgeInsets.only(
//                   bottom: MediaQuery.of(context).viewInsets.bottom
//                 ),
//                 child: Container(
//                   decoration: const BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(10),
//                         topRight: Radius.circular(10)
//                     ),
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
//                               CColor.black, FontSize.size_14),
//                         ),
//                       ),
//                       Container(
//                         margin: EdgeInsets.only(left: Sizes.height_2,right: Sizes.height_2,top: Sizes.height_2,bottom:  Sizes.height_2),
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             color: CColor.black,
//                             width: 1
//                           ),
//                           borderRadius: BorderRadius.circular(10)
//                         ),
//                         child: TextField(
//                           keyboardType: TextInputType.text,
//                           controller: logic.notesController,
//                           decoration: const InputDecoration(
//                             border: InputBorder.none,
//                           ),
//                           // autofocus: true,
//                           maxLines: 5,
//                           style: TextStyle(fontSize: FontSize.size_10),
//                         ),
//                       ),
//                       Container(
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
//                                   margin: EdgeInsets.only(left: Sizes.width_5,right: Sizes.width_1),
//                                   alignment: Alignment.center,
//                                   decoration: BoxDecoration(
//                                       border: Border.all(),
//                                       borderRadius: BorderRadius.circular(10)),
//                                   padding: const EdgeInsets.all(8),
//                                   child: Text(
//                                     "Cancel",
//                                     style: TextStyle(
//                                         color: CColor.black,
//                                         fontSize: FontSize.size_14),
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
//                                 },
//                                 child: Container(
//                                   margin: EdgeInsets.only(right: Sizes.width_5,left: Sizes.width_1),
//                                   decoration: BoxDecoration(
//                                       border: Border.all(),
//                                       borderRadius: BorderRadius.circular(10),
//                                       color: CColor.black),
//                                   padding: EdgeInsets.only(
//                                       left: Sizes.width_6,
//                                       right: Sizes.width_6,
//                                       top: 7,
//                                       bottom: 7),
//                                   child: Text(
//                                     "Add",
//                                     style: TextStyle(
//                                         color: CColor.white,
//                                         fontSize: FontSize.size_14),
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
//     });
//   }
// }
//
//
