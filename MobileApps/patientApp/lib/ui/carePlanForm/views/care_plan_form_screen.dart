import 'package:banny_table/ui/carePlanForm/controllers/care_plan_form_controller.dart';
import 'package:banny_table/ui/goalForm/datamodel/goalDataModel.dart';
import 'package:banny_table/ui/goalForm/datamodel/notesData.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../../db_helper/box/goal_data.dart';
import '../../../utils/utils.dart';

class CarePlanFormScreen extends StatelessWidget {
  const CarePlanFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColor.white,
      appBar: AppBar(
        backgroundColor: CColor.primaryColor,
        title: const Text("Care Plan",
          style: TextStyle(
            color: CColor.white,
            // fontSize: 20,
            fontFamily: Constant.fontFamilyPoppins,
          ),),
      ),
      body: SafeArea(
        child:LayoutBuilder(
          builder: (BuildContext context,BoxConstraints constraints) {
            return SingleChildScrollView(
              child: GetBuilder<CarePlanController>(builder: (logic) {
                return Column(
                  children: [
                    _widgetEnterText(logic,constraints),
                    _widgetStatusDropDown(context, logic,constraints),
                    _widgetDateEditText(context, logic,constraints),
                    // _widgetPeriod(context, logic),
                    _widgetMultipleGoalsDropDown(context, logic,constraints),
                    _widgetNotesEditText(logic, context,constraints),
                  ],
                );
              }),
            );
          }
        ),
      ),
    );
  }

  Widget _widgetEnterText(CarePlanController logic,BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_3, right:(kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.0, constraints) :Sizes.width_3, left:(kIsWeb) ?AppFontStyle.sizesWidthManageWeb(2.0, constraints) : Sizes.width_4),
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  text: "Plan",
                  style: AppFontStyle.styleW700(CColor.black,(kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
                ),
              ),
              SizedBox(
                width: Sizes.width_1,
              ),
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
                              "A detailed description of the care plan outlining the objectives, strategies, and key elements.")),
                    ),
                  ];
                },
                child: Icon(Icons.info_outline,
                    color: CColor.gray,
                    size: (kIsWeb) ? 6.sp : FontSize.size_12),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(
                top: Sizes.height_1, right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) :Sizes.width_3, left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3),
            decoration: BoxDecoration(
              color: CColor.greyF8,
              border:(logic.isEdited)?null:Border.all(
                color: CColor.primaryColor, width: 0.7,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            /*child: TextFormField(
              maxLines: 3,
              enabled: false,
              controller: logic.textFirstController,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.start,
              focusNode: logic.textFirstFocus,
              textInputAction: TextInputAction.done,
              style: AppFontStyle.styleW500(CColor.black,(kIsWeb)?AppFontStyle.sizesFontManageWeb(1.0, constraints): FontSize.size_10),
              cursorColor: CColor.black,
              decoration: InputDecoration(
                hintText: logic.selectTextFirst,
                filled: true,
                border:InputBorder.none,
              ),
            )*/
          child: HtmlWidget(
            // logic.editedCarePlanData.text.toString(),
            Utils.getHtmlFromDelta(logic.editedCarePlanData.text.toString()),
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
            textStyle:  AppFontStyle.styleW500(CColor.black,(kIsWeb)?AppFontStyle.sizesFontManageWeb(1.0, constraints): FontSize.size_10),
          ),
        ),
      ],
    );
  }

  _widgetStatusDropDown(BuildContext context, CarePlanController logic,BoxConstraints constraints) {
    return GetBuilder<CarePlanController>(builder: (logic) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                  bottom: (kIsWeb) ?AppFontStyle.sizesHeightManageWeb(0.5, constraints) : Sizes.height_0_5,
                  top: (kIsWeb) ?AppFontStyle.sizesHeightManageWeb(1.0, constraints) : Sizes.height_3,
                  left: (kIsWeb)? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_2),
              child: Row(
                children: [
                  RichText(
                    text: TextSpan(
                      text: "Status",
                      style: AppFontStyle.styleW700(CColor.black,
                          (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
                    ),
                  ),
                  SizedBox(
                    width: Sizes.width_1,
                  ),
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
                                  "The current status of the care plan.")),
                        ),
                      ];
                    },
                    child: Icon(Icons.info_outline,
                        color: CColor.gray,
                        size: (kIsWeb) ? 6.sp : FontSize.size_12),
                  ),
                ],
              ),
            ),
            Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
                    vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.3, constraints)  :Sizes.height_2),
                decoration: BoxDecoration(
                  color: CColor.greyF8,
                  border:(logic.isEdited)?null:Border.all(
                    color: CColor.primaryColor, width: 0.7,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Row(
                  children: [
                    Text(
                      logic.selectedStatus.toString(),
                      style: AppFontStyle.styleW500(CColor.black,
                          (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_10),
                    ),
                  ],
                )),
          ],
        ),
      );
    });
  }

  _widgetPeriod(BuildContext context, CarePlanController logic) {
    return GetBuilder<CarePlanController>(builder: (logic) {
      return Container(
        margin: EdgeInsets.only(
            top: Sizes.height_3,
            left: Sizes.width_3,
            right: Sizes.width_3,
            bottom: Sizes.height_2
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: Sizes.width_2),
                  child: Text(
                    "Period",
                    style: AppFontStyle.styleW700(
                      CColor.black,
                      (kIsWeb)?FontSize.size_3:FontSize.size_10,
                    ),
                  ),
                ),
                SizedBox(
                  width: Sizes.width_1,
                ),
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
                                "Specify the start and end dates for the care plan. This defines the duration during which the plan is intended to be followed.")),
                      ),
                    ];
                  },
                  child: Icon(Icons.info_outline,
                      color: CColor.gray,
                      size: (kIsWeb) ? 6.sp : FontSize.size_12),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(
                  top: Sizes.height_1
              ),
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: (kIsWeb) ? Sizes.width_1_5 : Sizes.width_3,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: CColor.greyF8,
                border: Border.all(color: CColor.primaryColor, width: 0.7),
              ),
              child: Container(
                // margin: EdgeInsets.only(top: Sizes.height_1),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        // showDatePickerDialog(logic, context,Constant.periodDate,true);
                      },
                      child: Container(
                        padding: EdgeInsets.all(Sizes.width_3),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                logic.periodStartDateStr.text,
                                style: AppFontStyle.styleW400(
                                  CColor.black,
                                  (kIsWeb) ? FontSize.size_3 : FontSize.size_10,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: Sizes.width_1),
                              child: Icon(
                                Icons.date_range_rounded,
                                size: Sizes.height_3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(Sizes.width_3),
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: Sizes.width_3),
                      child: Text(
                        "&",
                        style: AppFontStyle.styleW400(
                          CColor.black,
                          (kIsWeb) ? FontSize.size_3 : FontSize.size_10,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // showDatePickerDialog(logic, context,Constant.periodDate,false);
                      },
                      child: Container(
                        padding: EdgeInsets.all(Sizes.width_3),

                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: Sizes.width_3),
                              child: Text(
                                logic.periodEndDateStr.text,
                                style: AppFontStyle.styleW400(
                                  CColor.black,
                                  (kIsWeb) ? FontSize.size_3 : FontSize.size_10,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: Sizes.width_1),
                              child: Icon(
                                Icons.date_range_rounded,
                                size: Sizes.height_3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  _widgetDateEditText(BuildContext context, CarePlanController logic,BoxConstraints constraints) {
    return Row(
      children: [
        _widgetOnsetDate(logic, context,constraints),
        if(logic.periodEndDateStr.text != "")
        _widgetAbatementDate(logic, context,constraints),
      ],
    );
  }

  Widget _widgetOnsetDate(CarePlanController logic, BuildContext context,BoxConstraints constraints) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
                top: (kIsWeb)
                    ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                    : Sizes.height_3,
                right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints):  Sizes.width_3,
                left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.9, constraints)  :Sizes.width_4),
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    text: "Start Date",
                    style: AppFontStyle.styleW700(CColor.black,
                        (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
                    children: const <TextSpan>[],
                  ),
                ),
                SizedBox(
                  width: Sizes.width_1,
                ),
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
                                "The start and end dates for the care plan, defining the duration during which the plan is intended to be followed.")),
                      ),
                    ];
                  },
                  child: Icon(Icons.info_outline,
                      color: CColor.gray,
                      size: (kIsWeb) ? 6.sp : FontSize.size_12),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: (kIsWeb)
                    ? AppFontStyle.sizesHeightManageWeb(0.5, constraints)
                    : Sizes.height_0_5,
                right:(kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints):  Sizes.width_3,
                left:(kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_3),
            decoration: BoxDecoration(
              color: CColor.greyF8,
              border:(logic.isEdited)?null:Border.all(
                color: CColor.primaryColor, width: 0.7,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: TextFormField(
              enabled: false,
              readOnly: true,
              controller: logic.periodStartDateStr,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
              style: AppFontStyle.styleW500(
                  CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_10),
              cursorColor: CColor.black,
              decoration: InputDecoration(
                hintText: "YYYY-MM-DD",
                filled: true,
                fillColor: Colors.transparent,
                hintStyle:  AppFontStyle.styleW500(
                    CColor.gray, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_10),
                // contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: Sizes.width_5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _widgetAbatementDate(CarePlanController logic, BuildContext context,BoxConstraints constraints) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
                top: (kIsWeb)
                    ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                    : Sizes.height_3,
                // right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.6, constraints):  Sizes.width_3,
                left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(2.3, constraints)  :Sizes.width_3
            ),
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    text: "End Date",
                    style: AppFontStyle.styleW700(CColor.black,
                        (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
                    children: const <TextSpan>[],
                  ),
                ),
                SizedBox(
                  width: Sizes.width_1,
                ),
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
                                "The start and end dates for the care plan, defining the duration during which the plan is intended to be followed.")),
                      ),
                    ];
                  },
                  child: Icon(Icons.info_outline,
                      color: CColor.gray,
                      size: (kIsWeb) ? 6.sp : FontSize.size_12),
                ),

              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: CColor.greyF8,
              border:(logic.isEdited)?null:Border.all(
                color: CColor.primaryColor, width: 0.7,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin: EdgeInsets.only(
                top: (kIsWeb)
                    ? AppFontStyle.sizesHeightManageWeb(0.5, constraints)
                    : Sizes.height_0_5,
                right:(kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints):  Sizes.width_3,
                left:(kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_3),
            child: TextFormField(
              enabled: false,
              readOnly: true,
              controller: logic.periodEndDateStr,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
              style: AppFontStyle.styleW500(CColor.black, (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.0, constraints):FontSize.size_10),
              cursorColor: CColor.black,
              decoration: InputDecoration(
                hintText: "YYYY-MM-DD",
                filled: true,
                fillColor: Colors.transparent,
                hintStyle: AppFontStyle.styleW500(CColor.gray, (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.0, constraints):FontSize.size_10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showDatePickerDialog(CarePlanController logic,
      BuildContext context, String dateType, bool isStartDate) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                  color: CColor.white),
              child: SfDateRangePicker(
                onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                  if (dateType == Constant.normalDate) {
                  } else if (dateType == Constant.periodDate) {
                    logic.onChangePeriodDate(
                        isStartDate, dateRangePickerSelectionChangedArgs);
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
                  Get.back();
                },
              )),
        );
      },
    );
  }

  _widgetMultipleGoalsDropDown(BuildContext context, CarePlanController logic,BoxConstraints constraints) {
    return GetBuilder<CarePlanController>(builder: (logic) {
      return logic.createdGoals
              .where((element) => element.isSelected)
              .toList()
              .isNotEmpty
          ? Container(
              margin: EdgeInsets.symmetric(horizontal: (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            bottom: (kIsWeb) ?AppFontStyle.sizesHeightManageWeb(0.5, constraints) : Sizes.height_1,
                            top: (kIsWeb) ?AppFontStyle.sizesHeightManageWeb(1.0, constraints) : Sizes.height_3,
                            left: (kIsWeb)? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_2),
                        child: Text(
                          "Select Goals",
                          style: AppFontStyle.styleW700(
                            CColor.black,
                            (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Sizes.width_1,
                      ),
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
                                      "The specific goals associated with this care plan, outlining the targets to be achieved within the plan's time frame.")),
                            ),
                          ];
                        },
                        child: Icon(Icons.info_outline,
                            color: CColor.gray,
                            size: (kIsWeb) ? 6.sp : FontSize.size_12),
                      ),
                      const Spacer(),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
                        vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.3, constraints)  :Sizes.height_1_5),
                      decoration: BoxDecoration(
                        color: CColor.greyF8,
                        border:(logic.isEdited)?null:Border.all(
                          color: CColor.primaryColor, width: 0.7,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    child: (logic.createdGoals
                            .where((element) => element.isSelected)
                            .toList()
                            .isNotEmpty)
                        ? ListView.builder(
                            itemBuilder: (context, index) {
                              return _itemSelectedGoal(
                                  logic.createdGoals
                                      .where((element) => element.isSelected)
                                      .toList()[index],
                                  index,
                                  logic,constraints);
                            },
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: logic.createdGoals
                                .where((element) => element.isSelected)
                                .toList()
                                .length,
                          )
                        : Container()
                  ),
                ],
              ),
            )
          : Container();
    });
  }

  _itemSelectedGoal(
      // GoalTableData goalData, int index, CarePlanController logic,BoxConstraints constraints) {
      GoalSyncDataModel goalData, int index, CarePlanController logic,BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${goalData.target} ${goalData.multipleGoals}",
          style: AppFontStyle.styleW700(
            CColor.black,
            (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_10,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: Sizes.height_0_5),
          child: Text(
            "Due date: ${DateFormat(Constant.commonDateFormatDdMmYyyy).format(goalData.dueDate!)}",
            style: AppFontStyle.styleW500(
              CColor.black,
              (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(0.9, constraints) : FontSize.size_9,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: Sizes.height_0_5),
          child: Text(
            "Status: ${goalData.lifeCycleStatus}",
            style: AppFontStyle.styleW500(
              CColor.black,
              (kIsWeb) ? AppFontStyle.sizesFontManageWeb(0.9, constraints) : FontSize.size_9,
            ),
          ),
        ),
        if (logic.createdGoals
                .where((element) => element.isSelected)
                .toList()
                .length >
            (index + 1))
          Container(
            margin:
                EdgeInsets.only(bottom: Sizes.height_2, top: Sizes.height_1),
            child: const Divider(
              color: CColor.black,
              height: 2,
            ),
          ),
      ],
    );
  }

  Widget _widgetNotesEditText(
    CarePlanController logic,
    BuildContext context,BoxConstraints constraints
  ) {
    return logic.notesList.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: (kIsWeb) ?   AppFontStyle.sizesHeightManageWeb(1.0, constraints):Sizes.height_3,
                    right: (kIsWeb) ?   AppFontStyle.sizesWidthManageWeb(1.0, constraints):Sizes.width_3,
                    left: (kIsWeb) ?   AppFontStyle.sizesWidthManageWeb(2.0, constraints):Sizes.width_4),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            "Notes",
                            style: AppFontStyle.styleW700(CColor.black,
                                (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
                          ),
                          SizedBox(
                            width: Sizes.width_1,
                          ),
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
                                          "Additional comments or details about the care plan, including instructions, observations, or relevant information for following the plan.")),
                                ),
                              ];
                            },
                            child: Icon(Icons.info_outline,
                                color: CColor.gray,
                                size: (kIsWeb) ? 6.sp : FontSize.size_12),
                          ),
                        ],
                      ),
                    ),
                    Container()
                  ],
                ),
              ),
              ListView.builder(
                itemBuilder: (context, index) {
                  return _itemNotes(
                      index, logic.notesList[index], logic, context,constraints);
                },
                shrinkWrap: true,
                reverse: true,
                itemCount: logic.notesList.length,
                physics: const NeverScrollableScrollPhysics(),
              ),
            ],
          )
        : Container();
  }

  showDialogForAddNewCode(
      BuildContext context, CarePlanController logic, bool isEditNote, index) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: CColor.white,
          contentPadding: const EdgeInsets.all(0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          content: Wrap(
            children: [
              Center(
                child: Container(
                  padding:
                      EdgeInsets.all((kIsWeb) ? Sizes.width_2 : Sizes.width_5),
                  width: (kIsWeb) ? Sizes.width_30 : Get.width * 0.8,
                  // height: (kIsWeb) ?Sizes.height_30:,
                  child: Column(
                    children: [
                      Container(
                        color: CColor.transparent,
                        child: TextFormField(
                          controller: logic.notesController,
                          focusNode: logic.notesControllersFocus,
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.text,
                          style: AppFontStyle.styleW500(CColor.black,
                              (kIsWeb) ? FontSize.size_3 : FontSize.size_10),
                          maxLines: 2,
                          cursorColor: CColor.black,
                          decoration: InputDecoration(
                            hintText: "Enter your Note",
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: CColor.primaryColor, width: 0.7),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: CColor.primaryColor, width: 0.7),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: CColor.primaryColor, width: 0.7),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: CColor.primaryColor, width: 0.7),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: Sizes.height_2),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  Get.back();
                                  logic.notesController.clear();
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      CColor.transparent),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side: const BorderSide(
                                          color: CColor.primaryColor,
                                          width: 0.7),
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.all((kIsWeb) ? 10 : 5),
                                  child: Text(
                                    "Cancel",
                                    textAlign: TextAlign.center,
                                    style: AppFontStyle.styleW400(
                                        CColor.black,
                                        (kIsWeb)
                                            ? FontSize.size_3
                                            : FontSize.size_12),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: Sizes.width_2),
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  logic
                                      .addNotesData(logic.notesController.text,
                                          isEditNote, index)
                                      .then((value) => {
                                            logic.notesController.clear(),
                                          });
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      CColor.primaryColor),
                                  elevation: MaterialStateProperty.all(1),
                                  shadowColor:
                                      MaterialStateProperty.all(CColor.gray),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side: const BorderSide(
                                          color: CColor.primaryColor,
                                          width: 0.7),
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.all((kIsWeb) ? 10 : 5),
                                  child: Text(
                                    isEditNote ? "Edit" : "Add",
                                    textAlign: TextAlign.center,
                                    style: AppFontStyle.styleW400(
                                        CColor.white,
                                        (kIsWeb)
                                            ? FontSize.size_3
                                            : FontSize.size_12),
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
              ),
            ],
          ),
        );
      },
    );
  }

  _itemNotes(int index, NotesData notesData, CarePlanController logic,
      BuildContext context,BoxConstraints constraints) {
    return logic.notesList.isNotEmpty
        ? Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.symmetric(
                    horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
                    vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.5, constraints):Sizes.height_0_5),
                padding: EdgeInsets.only(
                    left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
                    right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
                    top: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.5, constraints):Sizes.height_1_8,
                    bottom: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.3, constraints):Sizes.height_0_5),
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.8, constraints): Sizes.width_2),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(notesData.author != null && notesData.author != "" && notesData.author != "null" &&
                              notesData.author != "NULL")Container(
                            margin: EdgeInsets.only(top: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.0, constraints): Sizes.height_0_5),
                            child: Text(
                              "${notesData.author}",
                              style: AppFontStyle.styleW500(
                                CColor.black,
                                (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints) : FontSize.size_9,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: Sizes.height_0_5),
                            child: Text(
                              "Date: ${DateFormat(Constant.commonDateFormatDdMmYyyy).format(notesData.date!)}",
                              style: AppFontStyle.styleW500(
                                CColor.black,
                                (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints) : FontSize.size_9,
                              ),
                            ),
                          ),
                          /*Text(
                            "${notesData.notes}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppFontStyle.styleW700(
                              CColor.black,
                              (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10,
                            ),
                          ),*/
                          HtmlWidget(
                            // notesData.notes.toString(),
                            Utils.getHtmlFromDelta(notesData.notes.toString()),
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
                            textStyle:  AppFontStyle.styleW500(CColor.black,(kIsWeb)?AppFontStyle.sizesFontManageWeb(1.0, constraints): FontSize.size_10),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.5, constraints) : Sizes.width_7,
                ),
                child: const Divider(
                  color: CColor.black,
                  height: 2,
                ),
              ),
            ],
          )
        : Container();
  }

  void showDialogForChooseGoal(CarePlanController logic, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setStateGoal) {
            return AlertDialog(
              backgroundColor: CColor.white,
              contentPadding: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
              content: SingleChildScrollView(
                child: Container(
                  width: Get.width * 0.8,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                      color: CColor.white),
                  child: Column(
                    children: [
                      (logic.createdGoals.isNotEmpty)
                          ? Text(
                              "Choose your goal",
                              style: AppFontStyle.styleW500(
                                CColor.black,
                                (kIsWeb) ? FontSize.size_2 : FontSize.size_10,
                              ),
                            )
                          : Container(),
                      (logic.createdGoals.isNotEmpty)
                          ? Column(
                              children: [
                                ListView.builder(
                                  itemBuilder: (context, index) {
                                    return _itemGoalListed(
                                        logic.createdGoals[index],
                                        logic,
                                        index,
                                        context,
                                        setStateGoal);
                                  },
                                  itemCount: logic.createdGoals.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: Sizes.height_2,
                                    right: Sizes.width_3,
                                    left: Sizes.width_3,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          onPressed: () {
                                            logic.onCancelTap();
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    CColor.transparent),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                side: const BorderSide(
                                                    color: CColor.primaryColor,
                                                    width: 0.7),
                                              ),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(
                                                (kIsWeb) ? 10 : 5),
                                            child: Text(
                                              "Cancel",
                                              textAlign: TextAlign.center,
                                              style: AppFontStyle.styleW400(
                                                  CColor.black,
                                                  (kIsWeb)
                                                      ? FontSize.size_3
                                                      : FontSize.size_12),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: Sizes.width_2),
                                      Expanded(
                                        child: TextButton(
                                          onPressed: () {
                                            logic.onOkTap();
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    CColor.primaryColor),
                                            elevation:
                                                MaterialStateProperty.all(1),
                                            shadowColor:
                                                MaterialStateProperty.all(
                                                    CColor.gray),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                side: const BorderSide(
                                                    color: CColor.primaryColor,
                                                    width: 0.7),
                                              ),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(
                                                (kIsWeb) ? 10 : 5),
                                            child: Text(
                                              "Ok",
                                              textAlign: TextAlign.center,
                                              style: AppFontStyle.styleW400(
                                                  CColor.white,
                                                  (kIsWeb)
                                                      ? FontSize.size_3
                                                      : FontSize.size_12),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          : SizedBox(
                              height: Get.height * 0.5,
                              child: Center(
                                child: Text(
                                  "No goals are currently recorded ",
                                  style: AppFontStyle.styleW700(
                                    CColor.black,
                                    (kIsWeb)
                                        ? FontSize.size_3
                                        : FontSize.size_10,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // _itemGoalListed(GoalTableData goalData, CarePlanController logic, int index,
  _itemGoalListed(GoalSyncDataModel goalData, CarePlanController logic, int index,
      BuildContext context, setStateGoal) {
    return GestureDetector(
      onTap: () {
        logic.onChangeGoalSelect(goalData, index);
        setStateGoal(() {});
      },
      child: Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: (logic.createdGoals[index].isSelected)
                  ? CColor.primaryColor
                  : CColor.transparent),
          color: CColor.white,
          boxShadow: const [
            BoxShadow(
              color: CColor.txtGray50,
              // blurRadius: 1,
              spreadRadius: 0.5,
            )
          ],
        ),
        margin: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
            vertical: Sizes.height_1),
        padding: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
            vertical: Sizes.height_2),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${goalData.target} ${goalData.multipleGoals}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: AppFontStyle.styleW700(
                      CColor.black,
                      (kIsWeb) ? FontSize.size_3 : FontSize.size_10,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: Sizes.height_0_5),
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      "Due date: ${DateFormat(Constant.commonDateFormatDdMmYyyy).format(goalData.dueDate!)}",
                      style: AppFontStyle.styleW500(
                        CColor.black,
                        (kIsWeb) ? FontSize.size_2 : FontSize.size_9,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: Sizes.height_0_5),
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      "Status: ${goalData.achievementStatus}",
                      style: AppFontStyle.styleW500(
                        CColor.black,
                        (kIsWeb) ? FontSize.size_2 : FontSize.size_9,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
