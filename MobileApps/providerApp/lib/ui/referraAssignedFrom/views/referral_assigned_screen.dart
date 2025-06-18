import 'package:banny_table/db_helper/box/condition_form_data.dart';
import 'package:banny_table/ui/conditionForm/datamodel/conditionSyncDataModel.dart';
import 'package:banny_table/ui/goalForm/datamodel/notesData.dart';
import 'package:banny_table/ui/referraAssignedFrom/controllers/referral_assigned_controller.dart';
import 'package:banny_table/ui/referralForm/controllers/referral_form_controller.dart';
import 'package:banny_table/ui/referralForm/datamodel/performerData.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../utils/constant.dart';
import '../../../utils/utils.dart';

class ReferralAssignedFormScreen extends StatelessWidget {
  const ReferralAssignedFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          useMaterial3: false
      ),
      child: Scaffold(
        backgroundColor: CColor.white,
        appBar: AppBar(
          backgroundColor: CColor.primaryColor,
          title: const Text("Referral form"),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: LayoutBuilder(
              builder: (BuildContext context,BoxConstraints constraints) {
                return GetBuilder<ReferralAssignedFormController>(builder: (logic) {
                  return Column(
                    children: [
                      _widgetReferralTypeDropDown(context, logic,constraints),
                      // _widgetOccurrence(context, logic),
                      _widgetDateEditText(context, logic,constraints),
                      _widgetPriorityDropDown(context, logic,constraints),
                      _widgetEnterText(logic,constraints),
                      // _widgetEnterInstructions(logic),
                      _widgetReferralAssignedToDropDown(context,logic,constraints),
                      if(logic.createdCondition.isNotEmpty /*|| logic.showCondition.isNotEmpty*/)
                        _widgetConditionSelect(context,logic,constraints),
                      if(logic.selectedStatusFix != Constant.statusDraft) _widgetStatusDropDown(context, logic,constraints),
                      _widgetNotesEditText(logic,context,constraints),

                      Container(
                        margin: EdgeInsets.only(
                            top: Sizes.height_2, bottom: Sizes.height_1),
                        child: Row(
                          children: [
                            _buttonCancel(context,constraints,logic),
                            _buttonAddUpdate(context,constraints),
                          ],
                        ),
                      ),
                      if(logic.selectedStatusFix == Constant.statusDraft) _buttonSaveAsDraft(context,constraints),

      /*                _widgetReferralTypeDropDown(context, logic),
                      _widgetPerformerDropDown(context, logic),
                      _widgetOccurrence(context, logic),
                      _widgetStatusDropDown(context, logic),
                      _widgetPriorityDropDown(context, logic),
                      *//*if(logic.notesList.isNotEmpty)*//*
                      _widgetNotesEditText(logic,context),
                      Container(
                        margin: EdgeInsets.only(
                            top: Sizes.height_2, bottom: Sizes.height_5),
                        child: Row(
                          children: [
                            _buttonCancel(context),
                            _buttonAddUpdate(context),
                          ],
                        ),
                      ),*/
                    ],
                  );
                });
              }
            ),
          ),
        ),
      ),
    );
  }

  _widgetStatusDropDown(BuildContext context, ReferralAssignedFormController logic,BoxConstraints constraints) {
    return GetBuilder<ReferralAssignedFormController>(builder: (logic) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                  bottom: (kIsWeb) ?AppFontStyle.sizesHeightManageWeb(0.5, constraints) : Sizes.height_1,
                  top: (kIsWeb) ?AppFontStyle.sizesHeightManageWeb(1.0, constraints) : Sizes.height_3,
                  left: (kIsWeb)? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_2),
              child: Row(
                children: [
                  Text(
                    "Status",
                    style: AppFontStyle.styleW700(
                      CColor.black,
                        (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10
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
                                  "Select the current status of the referral.")),
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
              padding: EdgeInsets.symmetric(
                  horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
                  vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.3, constraints)  :Sizes.height_1_5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: CColor.greyF8,
                border: Border.all(color: CColor.primaryColor, width: 0.7),
              ),
              child: DropdownButtonFormField<String>(
                focusColor: Colors.white,
                decoration: const InputDecoration.collapsed(hintText: ''),
                // value: logic.selectedStatus,
                hint: Text(logic.selectedStatusHint,style: AppFontStyle.styleW500(
                    CColor.black,(kIsWeb)? AppFontStyle.sizesFontManageWeb(1.0, constraints): FontSize.size_10),),
                style: const TextStyle(color: Colors.white),
                iconEnabledColor: Colors.black,
                items: Utils.statusList
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: AppFontStyle.styleW500(CColor.black,
                          (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_10),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  logic.onChangeStatus(value);
                  // logic.onChangeLifeCycleStatus(value!);
                  Debug.printLog("lifecycle value...$value");
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  _widgetPriorityDropDown(BuildContext context, ReferralAssignedFormController logic,BoxConstraints constraints) {
    return GetBuilder<ReferralAssignedFormController>(builder: (logic) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                  bottom: (kIsWeb) ?AppFontStyle.sizesHeightManageWeb(0.5, constraints) : Sizes.height_1,
                  top: (kIsWeb) ?AppFontStyle.sizesHeightManageWeb(1.0, constraints) : Sizes.height_3,
                  left: (kIsWeb)? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_2),
              child: Row(
                children: [
                  Text(
                    "Priority",
                    style: AppFontStyle.styleW700(
                      CColor.black,
                        (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10
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
                                  "Choose the urgency of the referral. Options include 'Routine' for standard referrals and 'Urgent' for those needing immediate attention")),
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
              padding: EdgeInsets.symmetric(
                  horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
                  vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.3, constraints)  :Sizes.height_1_5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: CColor.greyF8,
                border: Border.all(color: CColor.primaryColor, width: 0.7),
              ),
              child: DropdownButtonFormField<String>(
                focusColor: Colors.white,
                decoration: const InputDecoration.collapsed(hintText: ''),
                // value: logic.selectedPriority,
                //elevation: 5,
                hint: Text(logic.selectedPriorityHint,style: AppFontStyle.styleW500(
                    CColor.black,(kIsWeb)?AppFontStyle.sizesFontManageWeb(1.0, constraints): FontSize.size_10),),
                // iconSize: 0.0,
                style: const TextStyle(color: Colors.white),
                iconEnabledColor: Colors.black,
                items: Utils.priorityList
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: AppFontStyle.styleW500(CColor.black,
                          (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_10),
                    ),
                  );
                }).toList(),
                onChanged: (logic.referralEditedData.isCreated!) ? (value) {
                  logic.onChangePriority(value);
                } : null,
              ),
            ),
            /*Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    horizontal: (kIsWeb) ? Sizes.width_1_5 : Sizes.width_3,
                    vertical: Sizes.height_1_5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: CColor.greyF8,
                  border: Border.all(color: CColor.primaryColor, width: 0.7),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        logic.selectedPriority,
                        style: AppFontStyle.styleW500(
                          CColor.black,
                          (kIsWeb) ? FontSize.size_3 : FontSize.size_10,
                        ),
                      ),
                    ),
                    // const Icon(Icons.arrow_drop_down_rounded)
                  ],
                )),*/
          ],
        ),
      );
    });
  }

  _widgetReferralTypeDropDown(BuildContext context, ReferralAssignedFormController logic,BoxConstraints constraints) {
    return GetBuilder<ReferralAssignedFormController>(builder: (logic) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                  bottom: (kIsWeb) ?AppFontStyle.sizesHeightManageWeb(0.5, constraints) : Sizes.height_1,
                  top: (kIsWeb) ?AppFontStyle.sizesHeightManageWeb(1.0, constraints) : Sizes.height_3,
                  left: (kIsWeb)? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_2),
              child: Row(
                children: [
                  Text(
                    "Referral Type",
                    style: AppFontStyle.styleW700(
                      CColor.black,
                      (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10,
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
                                  "Select the type of referral being made from the list")),
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
                    vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.3, constraints)  :Sizes.height_1_5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular((kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.9, constraints) :15),
                  color: CColor.greyF8,
                  border: Border.all(color: CColor.primaryColor, width: 0.7),
                ),
                child: InkWell(
                  onTap: () {
                    if(logic.referralEditedData.isCreated!) {
                      showDialogForChooseCode(logic, context,constraints);
                    }
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          logic.selectedCodeType,
                          style: AppFontStyle.styleW500(
                            CColor.black,
                            (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_10,
                          ),
                        ),
                      ),
                      // const Icon(Icons.arrow_drop_down_rounded)
                    ],
                  ),
                )),
          ],
        ),
      );
    });
  }

  _widgetPerformerDropDown(BuildContext context, ReferralAssignedFormController logic) {
    return GetBuilder<ReferralAssignedFormController>(builder: (logic) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: Sizes.width_3),
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
                "Assigned To",
                style: AppFontStyle.styleW700(
                  CColor.black,
                  (kIsWeb) ? FontSize.size_3 : FontSize.size_10,
                ),
              ),
            ),
            Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    horizontal: (kIsWeb) ? Sizes.width_1_5 : Sizes.width_3,
                    vertical: Sizes.height_1_5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: CColor.greyF8,
                  border: Border.all(color: CColor.primaryColor, width: 0.7),
                ),
                child: InkWell(
                  onTap: () {
                    showDialogForSearchAssigned(logic, context);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${logic.selectedPerformer.performerId}->${logic.selectedPerformer.performerName}",
                          style: AppFontStyle.styleW500(
                            CColor.black,
                            (kIsWeb) ? FontSize.size_3 : FontSize.size_10,
                          ),
                        ),
                      ),
                      // const Icon(Icons.arrow_drop_down_rounded)
                    ],
                  ),
                )),
          ],
        ),
      );
    });
  }

  _widgetOccurrence(BuildContext context, ReferralAssignedFormController logic) {
    return GetBuilder<ReferralAssignedFormController>(builder: (logic) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: Sizes.width_3),
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
                "Complete within Timeframe",
                style: AppFontStyle.styleW700(
                  CColor.black,
                  (kIsWeb) ? FontSize.size_3 : FontSize.size_10,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: (kIsWeb) ? Sizes.width_1_5 : Sizes.width_3,
                  vertical: Sizes.height_1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: CColor.greyF8,
                border: Border.all(color: CColor.primaryColor, width: 0.7),
              ),
              child: Container(
                margin: EdgeInsets.only(top: Sizes.height_0_5,bottom: Sizes.height_0_5),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if(logic.referralEditedData.isCreated!) {
                            showDatePickerDialog(
                                logic, context, Constant.periodDate, true);
                          }
                        },
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: Sizes.width_3),
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
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(right: Sizes.width_5,left: Sizes.width_5),
                      child: Text(
                        "&",
                        style: AppFontStyle.styleW400(
                          CColor.black,
                          (kIsWeb) ? FontSize.size_3 : FontSize.size_10,
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (logic.referralEditedData.isCreated!) {
                            showDatePickerDialog(
                                logic, context, Constant.periodDate, false);
                          }
                        },
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: Sizes.width_1),
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

  _widgetDateEditText(BuildContext context, ReferralAssignedFormController logic,BoxConstraints constraints) {
    return Row(
      children: [
        _widgetStartDate(logic,context,constraints),
        _widgetEndDate(logic, context,constraints),
      ],
    );
  }

  Widget _widgetStartDate(ReferralAssignedFormController logic,BuildContext context,BoxConstraints constraints) {
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
                    style: AppFontStyle.styleW700(CColor.black,(kIsWeb)?AppFontStyle.sizesFontManageWeb(1.3, constraints): FontSize.size_10),
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
                                "If specified, service should not be delivered before this date")),
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

          GestureDetector(
            onTap: () {
              showDatePickerDialog(logic, context,Constant.periodDate,true);
            },
            child: Container(
              height: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(3.0, constraints) : Sizes.height_6,
              decoration: BoxDecoration(
                border: Border.all(
                    color: CColor.primaryColor,
                    width: 0.7
                ),
                borderRadius: BorderRadius.circular((kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.9, constraints) :15),
                color: CColor.transparent,
              ),
              margin: EdgeInsets.only(
                  top: (kIsWeb)
                      ? AppFontStyle.sizesHeightManageWeb(0.5, constraints)
                      : Sizes.height_1,
                  right:(kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints):  Sizes.width_3,
                  left:(kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_3),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      enabled: false,
                      readOnly: true,
                      controller: logic.periodStartDateStr,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.text,
                      style: AppFontStyle.styleW500(CColor.black, (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.0, constraints) :FontSize.size_10),
                      cursorColor: CColor.black,
                      decoration: const InputDecoration(
                        hintText: "YYYY-MM-DD",
                        filled: true,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: Sizes.width_3),
                    child: const Icon(Icons.calendar_month_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _widgetEndDate(ReferralAssignedFormController logic, BuildContext context,BoxConstraints constraints) {
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
                    text: "End Date",
                    style: AppFontStyle.styleW700(CColor.black,(kIsWeb)?  AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
                    children: const <TextSpan>[
                    ],
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
                                "If specified, service should be completed before this date.")),
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

          GestureDetector(
            onTap: () {
              showDatePickerDialog(logic, context,Constant.periodDate,false);
            },
            child: Container(
              height: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(3.0, constraints) : Sizes.height_6,
              decoration: BoxDecoration(
                border: Border.all(
                    color: CColor.primaryColor,
                    width: 0.7
                ),
                borderRadius: BorderRadius.circular((kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.9, constraints) :15),
                color: CColor.transparent,
              ),
              margin: EdgeInsets.only(
                  top: (kIsWeb)
                      ? AppFontStyle.sizesHeightManageWeb(0.5, constraints)
                      : Sizes.height_1,
                  right:(kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints):  Sizes.width_3,
                  left:(kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_3),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      enabled: false,
                      readOnly: true,
                      controller: logic.periodEndDateStr,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.text,
                      style: AppFontStyle.styleW500(CColor.black, (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.0, constraints) :FontSize.size_10),
                      cursorColor: CColor.black,
                      decoration: const InputDecoration(
                        hintText: "YYYY-MM-DD",
                        filled: true,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: Sizes.width_3),
                    child: const Icon(Icons.calendar_month_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonAddUpdate(BuildContext context,BoxConstraints constraints) {
    return Expanded(
      child: GetBuilder<ReferralAssignedFormController>(builder: (logic) {
        return Container(
          margin:
          EdgeInsets.only(
              top: (kIsWeb)
                  ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                  : Sizes.height_3,
              right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints):  Sizes.width_2,
              left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.0, constraints)  :Sizes.width_2),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: CColor.primaryColor,
              width: (kIsWeb) ? 1:2
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          padding: logic.selectedStatusFix == Constant.statusDraft ? EdgeInsets.all(0) : EdgeInsets.all((kIsWeb) ? 5 : 5),
          child: TextButton(
            onPressed: () {
              // if(logic.isValidation()) {
                logic.insertForSign();
                // logic.insertUpdateData();
                // logic.insertUpdateData();
              // }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(CColor.primaryColor),
              elevation: MaterialStateProperty.all(1),
              shadowColor: MaterialStateProperty.all(CColor.gray),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side:
                      const BorderSide(color: CColor.primaryColor, width: 0.7),
                ),
              ),
            ),

            child: Padding(
              padding: logic.selectedStatusFix == Constant.statusDraft ?EdgeInsets.all((kIsWeb) ? 10 : 5) : EdgeInsets.all((kIsWeb) ? 5 : 2),
              child: Text(
                logic.selectedStatusFix == Constant.statusDraft ? "Sign" : logic.isEdited ? "Save" :"Sign",
                textAlign: TextAlign.center,
                style: AppFontStyle.styleW400(CColor.white,
                    (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_12),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buttonCancel(BuildContext context,BoxConstraints constraints,ReferralAssignedFormController logic) {
    return Expanded(
      child: Container(
        margin:
        EdgeInsets.only(
            top: (kIsWeb)
                ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                : Sizes.height_3,
            right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.8, constraints):  Sizes.width_2,
            left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.1, constraints)  :Sizes.width_2),
        width: double.infinity,
        child: TextButton(
          onPressed: () {
            Get.back();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(CColor.transparent),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: const BorderSide(color: CColor.primaryColor, width: 0.7),
              ),
            ),
          ),
          child: Padding(
            padding: logic.selectedStatusFix != Constant.statusDraft  ?EdgeInsets.all((kIsWeb) ? 10 : 8) :const EdgeInsets.all((kIsWeb) ? 10 : 5),
            child: Text(
              "Cancel",
              textAlign: TextAlign.center,
              style: AppFontStyle.styleW400(
                  CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_12),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showDatePickerDialog(
      ReferralAssignedFormController logic, BuildContext context,String dateType ,bool isStartDate) async {
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
                  if(dateType == Constant.normalDate){
                    logic.onChangeNormalDate(dateRangePickerSelectionChangedArgs);
                  }else if(dateType == Constant.periodDate){
                    logic.onChangePeriodDate(isStartDate,dateRangePickerSelectionChangedArgs);
                  }
                },
                minDate: isStartDate ? null : DateTime.parse(logic.periodStartDateStr.text),
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

  void showDialogForChooseCode(
      ReferralAssignedFormController logic, BuildContext context,BoxConstraints constraints) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context,setStateDialogForChooseCode) {
            return  AlertDialog(
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                      color: CColor.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ListView.builder(
                        itemBuilder: (context, index) {
                          return _itemCodeData(
                              index, context, Utils.codeList[index].display,logic,constraints);
                        },
                        itemCount: Utils.codeList.length,
                        padding: const EdgeInsets.all(0),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     showDialogForAddNewCode(context,logic,setStateDialogForChooseCode,constraints);
                      //   },
                      //   child: Container(
                      //     margin: EdgeInsets.only(
                      //       left: Sizes.width_2,
                      //     ),
                      //     child: Text(
                      //       "+ Add New Type",
                      //       style: AppFontStyle.styleW500(
                      //         CColor.primaryColor,
                      //         (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_12,
                      //       ),
                      //     ),
                      //   ),
                      // )
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

  showDialogForAddNewCode(BuildContext context, ReferralAssignedFormController logic, setStateDialogForChooseCode,BoxConstraints constraints){
    showDialog(context: context,
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
                  padding: EdgeInsets.all(Sizes.width_5),
                  width: Get.width * 0.8,
                  child: Column(
                    children: [
                      Container(
                        color: CColor.transparent,
                        child: TextFormField(
                          controller: logic.addReferralTypeController,
                          focusNode: logic.addReferralTypeFocus,
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.text,
                          style: AppFontStyle.styleW500(
                              CColor.black,
                              (kIsWeb)
                                  ? FontSize.size_3
                                  : FontSize.size_10),
                          maxLines: 2,
                          cursorColor: CColor.black,
                          decoration: InputDecoration(
                            hintText: "Enter your code".tr,
                            filled: true,
                            // contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: Sizes.width_5),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: CColor.primaryColor,
                                  width: 0.7),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: CColor.primaryColor,
                                  width: 0.7),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: CColor.primaryColor,
                                  width: 0.7),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: CColor.primaryColor,
                                  width: 0.7),
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
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(CColor.transparent),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular((kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.8, constraints) :15),
                                      side: const BorderSide(color: CColor.primaryColor, width: 0.7),
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all((kIsWeb) ? 10 : 5),
                                  child: Text(
                                    "Cancel",
                                    textAlign: TextAlign.center,
                                    style: AppFontStyle.styleW400(
                                        CColor.black, (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_12),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: Sizes.width_2),
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  logic.addNewCodeDataIntoList(logic.addReferralTypeController.text);
                                  setStateDialogForChooseCode((){});
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(CColor.primaryColor),
                                  elevation: MaterialStateProperty.all(1),
                                  shadowColor: MaterialStateProperty.all(CColor.gray),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular((kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.8, constraints) :15),
                                      side:
                                      const BorderSide(color: CColor.primaryColor, width: 0.7),
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all((kIsWeb) ? 10 : 5),
                                  child: Text(
                                    "Add",
                                    textAlign: TextAlign.center,
                                    style: AppFontStyle.styleW400(CColor.white,
                                        (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_12),
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
      },);
  }

  _itemCodeData(int index, BuildContext context, String codeList, ReferralAssignedFormController logic,BoxConstraints constraints) {
    return InkWell(
      onTap: () {
        logic.onChangeCode(index);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: Sizes.height_3,left: Sizes.width_2),
        child: Text(
          codeList,
          style: AppFontStyle.styleW500(
            (Utils.codeList[index].display == logic.selectedCodeType)
                ? CColor.primaryColor
                : CColor.black,
            (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_12,
          ),
        ),
      ),
    );
  }

  Widget _widgetNotesEditText(ReferralAssignedFormController logic,BuildContext context,BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: (kIsWeb)
                  ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                  : Sizes.height_3,
              right: (kIsWeb)
                  ? AppFontStyle.sizesWidthManageWeb(2.0, constraints)
                  : Sizes.width_2,
              left: (kIsWeb)
                  ? AppFontStyle.sizesWidthManageWeb(2.0, constraints)
                  : Sizes.width_4),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      "Notes",
                      style: AppFontStyle.styleW700(CColor.black, (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.3, constraints):FontSize.size_10),
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
                                    Constant.notesReferralDesc)),
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
              (!logic.referralEditedData.readonly )? InkWell(
                onTap: () {
                  _showDialogForAddNote(context,logic,false,0,constraints);
                  // logic.addNotesData();
                },
                child: Container(
                    margin: EdgeInsets.only(
                      right: Sizes.width_2,),
                    child: Icon(Icons.add_rounded,size: (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.5, constraints):Sizes.width_7,)),
              ): Container()
            ],
          ),
        ),
        ListView.builder(itemBuilder: (context, index) {
          return _itemNotes(index,logic.notesList[index],logic,context,constraints);
        },
          shrinkWrap: true,
          reverse: true,
          itemCount:logic.notesList.length,
          physics: const NeverScrollableScrollPhysics(),
        ),

      ],
    );
  }

  _showDialogForAddNote(BuildContext context, ReferralAssignedFormController logic,bool isEditNote,index,BoxConstraints constraints){
    showDialog(context: context,
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
                  padding: EdgeInsets.all((kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) :Sizes.width_5),
                  width: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(30.0, constraints) :Get.width * 0.8,
                  // height: (kIsWeb) ?Sizes.height_30:,
                  child: Column(
                    children: [
                      Container(
                        /* child: TextFormField(
                          controller: logic.notesController,
                          focusNode: logic.notesControllersFocus,
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.text,
                          style: AppFontStyle.styleW500(
                              CColor.black,
                              (kIsWeb)
                                  ? AppFontStyle.sizesFontManageWeb(1.3, constraints)
                                  : FontSize.size_10),
                          maxLines: 2,
                          cursorColor: CColor.black,
                          decoration: InputDecoration(
                            hintText: "Enter your Note",
                            filled: true,
                            // contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: Sizes.width_5),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: CColor.primaryColor,
                                  width: 0.7),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: CColor.primaryColor,
                                  width: 0.7),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: CColor.primaryColor,
                                  width: 0.7),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: CColor.primaryColor,
                                  width: 0.7),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),*/
                        decoration: BoxDecoration(
                          color: CColor.transparent,
                          border:Border.all(
                            color: CColor.primaryColor, width: 0.7,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Container(
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
                                Container(
                                  height: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(10.0, constraints) : Get.height*0.2,
                                  padding: EdgeInsets.all(AppFontStyle.sizesHeightManageWeb(0.5, constraints)),
                                  child: QuillEditor.basic(
                                    configurations: QuillEditorConfigurations(
                                      controller: logic.notesController,
                                    ), // true for view only mode
                                  ),
                                ),
                              ],
                            )
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
                                  backgroundColor: MaterialStateProperty.all(CColor.transparent),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side: const BorderSide(color: CColor.primaryColor, width: 0.7),
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all((kIsWeb) ? 10 : 5),
                                  child: Text(
                                    "Cancel",
                                    textAlign: TextAlign.center,
                                    style: AppFontStyle.styleW400(
                                        CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_12),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: Sizes.width_2),
                            Expanded(
                              child: TextButton(
                                onPressed: () {

                                  if(logic.notesController.document.toDelta().toList().isNotEmpty){
                                    logic.addNotesData(logic.notesValue,isEditNote,index).then((value) => {
                                      logic.notesController.clear(),
                                      logic.notesValue = "",
                                    });
                                  }else{
                                    Utils.showToast(context, "Please enter notes");
                                  }

                                  // logic.addNewCodeDataIntoList(logic.addNewCodeController.text);
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(CColor.primaryColor),
                                  elevation: MaterialStateProperty.all(1),
                                  shadowColor: MaterialStateProperty.all(CColor.gray),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side:
                                      const BorderSide(color: CColor.primaryColor, width: 0.7),
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all((kIsWeb) ? 10 : 5),
                                  child: Text(
                                    isEditNote ? "Edit" :"Add",
                                    textAlign: TextAlign.center,
                                    style: AppFontStyle.styleW400(CColor.white,
                                        (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_12),
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
      },);
  }

  _itemNotes(int index, NotesData notesData,ReferralAssignedFormController logic,BuildContext context,BoxConstraints constraints){
    return logic.notesList.isNotEmpty ?
    InkWell(
      onTap: (){

      },
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              // color: CColor.greyF8,
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
                Expanded  (
                    child: Container(
                      margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.5, constraints): Sizes.width_2),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(notesData.author != null && notesData.author != "null" && notesData.author != "" )
                          Container(
                            margin: EdgeInsets.only(top: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.0, constraints): Sizes.height_0_5),
                            child: Text(
                              "${notesData.author}",
                              style: AppFontStyle.styleW500(
                                CColor.black,
                                (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints) :FontSize.size_9,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: Sizes.height_0_5),
                            child: Text(
                              "Date: ${DateFormat(Constant.commonDateFormatDdMmYyyy).format(notesData.date!)}",
                              style: AppFontStyle.styleW500(
                                CColor.black,
                                (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints) :FontSize.size_9,
                              ),
                            ),
                          ),
                          /*Text(
                            "${notesData.notes}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppFontStyle.styleW700(
                              CColor.black,
                              (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.3, constraints):FontSize.size_10,
                            ),
                          ),*/
                          HtmlWidget(
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
                (notesData.authorReference != "Practitioner/${Utils.getProviderId()}")?Container():Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        await logic.editNoteDataController("${notesData.notes}",true);
                        // showDialogForAddNewCode(context,logic,true);
                        _showDialogForAddNote(context,logic,true,index,constraints);
                      },
                      child: Container(
                        alignment: Alignment.topCenter,
                        padding:
                        EdgeInsets.only(left: Sizes.width_3, bottom: Sizes.height_1_5),
                        child: Icon(Icons.edit, size: (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.3, constraints):Sizes.width_4),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        logic.deleteNoteListData(notesData.noteId,index);
                        Debug.printLog("Detele");
                      },
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        padding:
                        EdgeInsets.only(left: Sizes.width_3, bottom: Sizes.height_1_5),
                        child: Icon(Icons.delete_forever,color: CColor.red, size: (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.3, constraints):Sizes.width_5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: (kIsWeb) ? Sizes.width_3 : Sizes.width_7,
            ),
            child: const Divider(
              color: CColor.black,
              height: 2,
            ),
          ),
        ],
      ),
    ) : Container();
  }

  void showDialogForSearchAssigned(
      ReferralAssignedFormController logic, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setStateDialog) {
            return  AlertDialog(
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                      color: CColor.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: Sizes.height_0_8, right: Sizes.width_3, left: Sizes.width_1_5,bottom: Sizes.height_1),
                        decoration: BoxDecoration(
                          color: CColor.transparent,
                          border: Border.all(
                            color: CColor.primaryColor, width: 0.7,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: TextFormField(
                          controller: logic.searchNameControllers,
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.start,
                          focusNode: logic.searchNameFocus,
                          textInputAction: TextInputAction.done,
                          style: AppFontStyle.styleW500(
                              CColor.black, (kIsWeb) ? FontSize.size_3 : FontSize.size_10),
                          cursorColor: CColor.black,
                          decoration: const InputDecoration(
                            hintText: "Search Name",
                            filled: true,
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setStateDialog((){
                              logic.getAssignedData(value,setStateDialog);
                            });
                          },
                        ),
                      ),
                      // _widgetSearchNameText(logic ,setStateDialog),
                      Container(
                        height: Sizes.height_40,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return _itemSearchAssignedData(
                                // index, context, Utils.performerList[index],logic);
                                index, context, logic.restrictedDataList[index],logic);
                          },
                          // itemCount: Utils.performerList.length,
                          itemCount: logic.restrictedDataList.length,
                          padding: const EdgeInsets.all(0),
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                        ),
                      ),
                      /*InkWell(
                        onTap: () {
                          showDialogForAddNewCode(context,logic,setStateDialogForChooseCode);
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            left: Sizes.width_2,
                          ),
                          child: Text(
                            "+ Add New Type",
                            style: AppFontStyle.styleW500(
                              CColor.primaryColor,
                              (kIsWeb) ? FontSize.size_3 : FontSize.size_12,
                            ),
                          ),
                        ),
                      )*/
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

  _itemSearchAssignedData(int index, BuildContext context, PerformerData performerData, ReferralAssignedFormController logic) {
    return InkWell(
      onTap: () {
        logic.onChangeAssignedTo(index);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: Sizes.height_3,left: Sizes.width_2),
        child: Text(
          "${performerData.performerId}->${performerData.performerName}",
          style: AppFontStyle.styleW500(
            (Utils.performerList[index].performerId == logic.selectedPerformer.performerId)
                ? CColor.primaryColor
                : CColor.black,
            (kIsWeb) ? FontSize.size_3 : FontSize.size_12,
          ),
        ),
      ),
    );
  }

  Widget _buttonSaveAsDraft(BuildContext context,BoxConstraints constraints) {
    return GetBuilder<ReferralAssignedFormController>(builder: (logic) {
      return Container(
        margin:           EdgeInsets.only(
            bottom: (kIsWeb)
                ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                : Sizes.height_3,
            right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints):  Sizes.width_2,
            left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.0, constraints)  :Sizes.width_2),
        decoration: BoxDecoration(
          border: Border.all(
              color: (logic.selectedStatusFix != Constant.statusDraft && !logic.isEdited) ? CColor.transparent:CColor.primaryColor,
              width: (logic.selectedStatusFix != Constant.statusDraft && !logic.isEdited) ? 0:(kIsWeb) ? 1:2
          ),
          borderRadius: (logic.selectedStatusFix != Constant.statusDraft && !logic.isEdited) ? BorderRadius.circular(0.0):BorderRadius.circular(15.0),
        ),
        padding: (logic.selectedStatusFix != Constant.statusDraft && !logic.isEdited) ? EdgeInsets.all(0) : EdgeInsets.all((kIsWeb) ? 5 : 5),
        width: double.infinity,
        child: TextButton(
          onPressed: () {
            // if(logic.isValidation()) {
              logic.insertSaveAsDraft();
              // logic.insertUpdateData();
            // }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(CColor.primaryColor),
            elevation: MaterialStateProperty.all(1),
            shadowColor: MaterialStateProperty.all(CColor.gray),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side:
                const BorderSide(color: CColor.primaryColor, width: 0.7),
              ),
            ),
          ),
          child: Padding(
            padding: logic.selectedStatusFix == Constant.statusDraft ?EdgeInsets.all((kIsWeb) ? 5 : 5) : EdgeInsets.all((kIsWeb) ? 10 : 3),
            child: Text(
              "Save as draft",
              textAlign: TextAlign.center,
              style: AppFontStyle.styleW400(CColor.white,
                  (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_12),
            ),
          ),
        ),
      );
    });
  }

  Widget _widgetEnterInstructions(ReferralAssignedFormController logic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_3, right: Sizes.width_3, left: Sizes.width_4),
          child: RichText(
            text: TextSpan(
              text: "Instructions",
              style: AppFontStyle.styleW700(CColor.black,(kIsWeb)?FontSize.size_3: FontSize.size_10),
              children:[
                /*TextSpan(
                  text: ' *',
                  style: TextStyle(
                      color: CColor.red,
                      fontSize: (kIsWeb)?FontSize.size_3: FontSize.size_10
                  ),
                ),*/
              ],
            ),
          ),
        ),
        Container(
          // height: Sizes.height_6,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(
              top: Sizes.height_1, right: Sizes.width_3, left: Sizes.width_3),
          decoration: BoxDecoration(
            color: CColor.transparent,
            border:Border.all(
              color: CColor.primaryColor, width: 0.7,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: HtmlEditor(
            controller: logic.htmlEditorController,
            htmlEditorOptions: const HtmlEditorOptions(
              hint: 'Your Instructions here...',
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
            otherOptions: OtherOptions(height: Sizes.height_40),
            callbacks: Callbacks(
              onChangeContent: (String? changed) {
                Debug.printLog('content changed to $changed');
              },
              onChangeCodeview: (String? changed) {
                Debug.printLog('code changed to $changed');
                logic.onChangeHTML(changed ?? "");
              },
            ),
          ),
          /*Column(
            children: [
              QuillHtmlEditor(
                // text: "<h1>Hello</h1>This is a quill html editor example 😊",
                hintText: 'Your text here...',
                controller: logic.htmlEditorController,
                isEnabled: true,
                minHeight: Sizes.height_20,
                // textStyle: _editorTextStyle,
                hintTextStyle: AppFontStyle.styleW600(CColor.gray, FontSize.size_12),
                hintTextAlign: TextAlign.start,
                padding: const EdgeInsets.only(left: 10, top: 5),
                hintTextPadding: EdgeInsets.zero,
                // backgroundColor: _backgroundColor,
                onFocusChanged: (hasFocus) => debugPrint('has focus $hasFocus'),
                onTextChanged: (text) => debugPrint('widget text change $text'),
                onEditorCreated: () => debugPrint('Editor has been loaded'),
                onEditorResized: (height) =>
                    debugPrint('Editor resized $height'),
                onSelectionChanged: (sel) =>
                    debugPrint('${sel.index},${sel.length}'),
              ),
              Container(
                child: ToolBar(
                  toolBarColor: Colors.grey.shade100,
                  activeIconColor: Colors.green,
                  padding: const EdgeInsets.all(8),
                  iconSize: 20,
                  controller: logic.htmlEditorController,
                  toolBarConfig: const [
                    ToolBarStyle.bold,
                    ToolBarStyle.italic,
                    ToolBarStyle.align,
                    ToolBarStyle.color,
                    ToolBarStyle.size,
                    ToolBarStyle.headerOne,
                    ToolBarStyle.headerTwo,
                    ToolBarStyle.listBullet,
                    ToolBarStyle.listOrdered,
                  ],
                ),
              )
            ],
          ),*/

        ),
      ],
    );
  }

  Widget _widgetEnterText(ReferralAssignedFormController logic,BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: (kIsWeb)
                  ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                  : Sizes.height_3,
              right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints):  Sizes.width_3,
              left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(2.0, constraints)  :Sizes.width_5),
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  text: "Instructions",
                  style: AppFontStyle.styleW700(CColor.black,(kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
                  children:const [
                    // TextSpan(
                    //   text: ' *',
                    //   style: TextStyle(
                    //       color: CColor.red,
                    //       fontSize: (kIsWeb)?FontSize.size_3: FontSize.size_10
                    //   ),
                    // ),
                  ],
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
                              "Provide detailed instructions for the referral. This can include specific actions, reasons for the referral, and any other relevant guidelines")),
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
          // height: Sizes.height_6,
          margin: EdgeInsets.only(
              top: Sizes.height_1,
              right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) :Sizes.width_3,
              left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3),
          decoration: BoxDecoration(
            color: CColor.transparent,
            border:Border.all(
              color: CColor.primaryColor, width: 0.7,
            ),
            borderRadius: BorderRadius.circular((kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.9, constraints) :15),
          ),
          child: TextFormField(
            maxLines: 3,
            controller: logic.textReasonCode,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.start,
            focusNode: logic.textReasonCodeFocus,
            textInputAction: TextInputAction.done,
            style: AppFontStyle.styleW500(CColor.black,(kIsWeb)?AppFontStyle.sizesFontManageWeb(1.0, constraints): FontSize.size_10),
            cursorColor: CColor.black,
            decoration: InputDecoration(
              hintText: logic.textReasonCodeHint,
              filled: true,
              border:InputBorder.none,
            ),
          )

          /*KeyboardActions(
            autoScroll: false,
            config: Utils.buildKeyboardActionsConfig(logic.textFirstFocus),
            child: TextFormField(

              controller: logic.textFirstController,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.start,
              focusNode: logic.textFirstFocus,
              textInputAction: TextInputAction.done,
              style: AppFontStyle.styleW500(CColor.black,(kIsWeb)?FontSize.size_3: FontSize.size_10),
              cursorColor: CColor.black,
              decoration: InputDecoration(
                hintText: logic.selectTextFirst,
                filled: true,
                border:InputBorder.none,
              ),
            )*/,

        ),
      ],
    );
  }


  _widgetReferralAssignedToDropDown(BuildContext context, ReferralAssignedFormController logic,BoxConstraints constraints) {
    return GetBuilder<ReferralAssignedFormController>(builder: (logic) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                  bottom: (kIsWeb) ?AppFontStyle.sizesHeightManageWeb(0.5, constraints) : Sizes.height_1,
                  top: (kIsWeb) ?AppFontStyle.sizesHeightManageWeb(1.0, constraints) : Sizes.height_3,
                  left: (kIsWeb)? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_2),
              child: Row(
                children: [
                  Text(
                    "Restricted to",
                    style: AppFontStyle.styleW700(
                      CColor.black,
                        (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10
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
                                  "Use this if the referral is ‘locked’ to a particular recipient and can’t be re-directed in the event of non-availability/refusal")),
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
                    vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.3, constraints)  :Sizes.height_1_5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: CColor.greyF8,
                  border: Border.all(color: CColor.primaryColor, width: 0.7),
                ),
                child: InkWell(
                  onTap: () {
                    showRestrictedToSelectionDialog(context,logic,constraints);
                    // showDialogForSearchAssigned(logic, context);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child:Text(
                          logic.selectedPerformer.performerName != "" ?
                          logic.selectedPerformer.performerName : Constant.pleaseSelect
                          ,style: AppFontStyle.styleW500(
                          CColor.black,
                          (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_10,
                        ),
                        ),
                      ),
                      // const Icon(Icons.arrow_drop_down_rounded)
                    ],
                  ),
                )),
          ],
        ),
      );
    });
  }

  showRestrictedToSelectionDialog(BuildContext context,ReferralAssignedFormController logic,BoxConstraints constraints){
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: Colors.white,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: StatefulBuilder(
              builder: (context, setStateFromMain) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Row(
                        children: [
                          Expanded(child: _widgetSearchNameText(logic,setStateFromMain,constraints)),
                        ],
                      ),
                    ),
                    // (Utils.performerList.isEmpty /*!isShowProgress*/)?
                    (logic.restrictedDataList.isEmpty /*!isShowProgress*/)?
                    Container(
                      margin: EdgeInsets.symmetric(vertical: Sizes.height_2),
                      alignment: Alignment.center,
                      child: Text(
                        "Not found",
                        style: AppFontStyle.styleW700(
                          CColor.black,
                          Utils.sizesFontManage(context, 3.0),),
                      ),
                    )
                        : _widgetPatientIds(logic)
                    ,
                  ],
                );
              },
            ),
          ),
        );
      },
    ).then((value) => {
      logic.searchNameControllers.clear(),
        logic.update(),
    });
  }

  Widget _widgetSearchNameText(ReferralAssignedFormController logic,setStateFromMain ,BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_2, right: Sizes.width_3, left: Sizes.width_1_5),
          decoration: BoxDecoration(
            color: CColor.transparent,

            border: Border.all(
              color: CColor.primaryColor, width: 0.7,
            ),
            borderRadius: BorderRadius.circular((kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.9, constraints) :15),
          ),
          child: TextFormField(
            controller: logic.searchNameControllers,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.start,
            focusNode: logic.searchNameFocus,
            textInputAction: TextInputAction.done,
            style: AppFontStyle.styleW500(
                CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_10),
            cursorColor: CColor.black,
            decoration: const InputDecoration(
              hintText: "Search Name",
              filled: true,
              border: InputBorder.none,
            ),
            onChanged: (value) {
              logic.getAssignedData(value,setStateFromMain);
            },
          ),
        ),
      ],
    );
  }


  _widgetPatientIds(ReferralAssignedFormController logic) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(
            left: Sizes.width_1_3,
            right: Sizes.width_1_2,
            top: Sizes.height_1_2
        ),
        padding: EdgeInsets.symmetric(
            horizontal: Sizes.width_0_5, vertical: 7),
        decoration: const BoxDecoration(
            color: CColor.white
        ),
        child: ListView.builder(
          itemBuilder: (context, index) {
            // return _itemPatientUser(index, context,Utils.performerList[index],logic);
            return _itemPatientUser(index, context,logic.restrictedDataList[index],logic);
          },
          // itemCount: Utils.performerList.length,
          itemCount: logic.restrictedDataList.length,
          padding: const EdgeInsets.all(0),
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
        ),
      ),
    );
  }

  _itemPatientUser(int index, BuildContext context, PerformerData performerData,ReferralAssignedFormController logic) {
    return GestureDetector(
      onTap: () {
        logic.onChangeAssignedTo(index);

      },
      child: Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CColor.white,
          border: Border.all(
              color: (performerData ==
                  performerData.performerName)
                  ? CColor.primaryColor
                  : CColor.transparent),
          boxShadow: const [
            BoxShadow(
              color: CColor.txtGray50,
              // blurRadius: 1,
              spreadRadius: 0.5,
            )
          ],
        ),
        margin: EdgeInsets.symmetric(
            horizontal: Sizes.width_0_5,
            vertical: Sizes.height_1),
        padding: EdgeInsets.symmetric(
          horizontal: Sizes.height_1_2,
          vertical: Sizes.height_1,),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CColor.primaryColor30,
              ),
              child: const Icon(Icons.person, color: CColor.primaryColor,),
            ),
            Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: (kIsWeb) ? Sizes.width_1_5 : Sizes.width_3),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      performerData.performerName.isNotEmpty ?
                      RichText(
                        text: TextSpan(
                          // text: "Name:- ",
                          style: AppFontStyle.styleW700(
                              CColor.black, (kIsWeb) ? 5.sp : 13.sp),
                          children: [

                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: performerData.performerName
                                  .toString(),
                              style: AppFontStyle.styleW700(
                                  CColor.black, (kIsWeb) ? 4.sp : 12.sp
                              ),
                            ),
                          ],
                        ),
                      ) : Container(),
                      (performerData.dob.isNotEmpty && performerData.dob != "null") ?
                      RichText(
                        text: TextSpan(
                          // text: "DOB:- ",
                          style: AppFontStyle.styleW700(
                              CColor.black, (kIsWeb) ? 5.sp : 13.sp),
                          children: [
                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: Utils.checkDate(performerData.dob.toString()),
                              // text: DateFormat(Constant.commonDateFormatMmmDdYyyy).format(DateTime.parse(logic.patientProfileList[index].dob.toString())) ?? "",
                              style: AppFontStyle.styleW600(
                                  CColor.gray, (kIsWeb) ? 4.sp : 12.sp
                              ),
                            ),
                          ],
                        ),
                      ) : Container(),
                      (performerData.gender.isNotEmpty && performerData.gender != "null") ?
                      RichText(
                        text: TextSpan(
                          // text: "DOB:- ",
                          style: AppFontStyle.styleW700(
                              CColor.black, (kIsWeb) ? 5.sp : 13.sp),
                          children: [
                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: performerData.gender.toString(),
                              // text: DateFormat(Constant.commonDateFormatMmmDdYyyy).format(DateTime.parse(logic.patientProfileList[index].dob.toString())) ?? "",
                              style: AppFontStyle.styleW600(
                                  CColor.gray, (kIsWeb) ? 4.sp : 12.sp
                              ),
                            ),
                          ],
                        ),
                      ) : Container(),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  _widgetConditionSelect(
      BuildContext context, ReferralAssignedFormController logic,BoxConstraints constraints) {
    return GetBuilder<ReferralAssignedFormController>(builder: (logic) {
      return Container(
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
                  child: Row(
                    children: [
                      Text(
                        "Condition",
                        style: AppFontStyle.styleW700(
                          CColor.black,
                          (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10,
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
                                      "The indication justifying the referral")),
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
                const Spacer(),
                (logic.createdCondition.where((element) => element.isSelected).toList().isNotEmpty)? InkWell(
                  onTap: () {
                    showDialogForChooseGoal(logic,context,constraints);
                  },
                  child: Container(
                      margin: EdgeInsets.only(
                        right: Sizes.width_2,
                        top: Sizes.height_3,
                        bottom: Sizes.height_1,),
                      child: Icon(Icons.add_rounded,size: (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.5, constraints):Sizes.width_7,)),
                ): Container()
              ],
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
                  vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.3, constraints)  :Sizes.height_1_5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular((kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.9, constraints) :15),
                color: CColor.greyF8,
                border: Border.all(color: CColor.primaryColor, width: 0.7),
              ),
              child: (logic.createdCondition.where((element) => element.isSelected).toList().isNotEmpty)
                  ? ListView.builder(
                itemBuilder: (context, index) {
                  return _itemSelectedGoal(
                      logic.createdCondition
                          .where((element) => element.isSelected)
                          .toList()[index],
                      index,
                      logic,constraints);
                },
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: logic.createdCondition.where((element) => element.isSelected).toList().length,
              )
                  : InkWell(
                onTap: () {
                  showDialogForChooseGoal(logic, context,constraints);
                },
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                          "Choose relevant condition(s)",
                          style: AppFontStyle.styleW500(
                            CColor.black,
                            (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints)  : FontSize.size_10,
                          ),
                        )),
                    const Icon(Icons.arrow_drop_down_rounded)
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }


  _itemSelectedGoal(ConditionSyncDataModel goalData, int index, ReferralAssignedFormController logic,BoxConstraints constraints){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${goalData.verificationStatus} ${goalData.display}",
          style: AppFontStyle.styleW700(
            CColor.black,
            (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints)  : FontSize.size_10,
          ),
        ),
        if(goalData.onset != null)
        Container(
          margin: EdgeInsets.only(top: Sizes.height_0_5),
          child: Text(
            "Onset date: ${DateFormat(Constant.commonDateFormatDdMmYyyy).format(goalData.onset!)}",
            style: AppFontStyle.styleW500(
              CColor.black,
              (kIsWeb)
                  ? AppFontStyle.sizesFontManageWeb(0.9, constraints)
                  : FontSize.size_9,
            ),
          ),
        ),
       /* if(goalData.text != null && goalData.text != "null" && goalData.text != "Null" &&  goalData.text != "")Container(
          margin: EdgeInsets.only(top: Sizes.height_0_5),
          child: Text(
            "Status: ${goalData.text}",
            style: AppFontStyle.styleW500(
              CColor.black,
              (kIsWeb)
                  ? FontSize.size_2
                  : FontSize.size_9,
            ),
          ),
        ),*/
        if(logic.createdCondition.where((element) => element.isSelected).toList().length > (index+1))
          Container(
            margin: EdgeInsets.only(bottom: Sizes.height_2,top: Sizes.height_1),
            child: const Divider(
              color: CColor.black,
              height: 2,
            ),
          ),
      ],
    );
  }


  void showDialogForChooseGoal(
      ReferralAssignedFormController logic, BuildContext context,BoxConstraints constraints) {
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                      color: CColor.white),
                  child: Column(
                    children: [
                      (logic.createdCondition.isNotEmpty)
                          ? Text(
                        "Choose your Condition",
                        style: AppFontStyle.styleW500(
                          CColor.black,
                          (kIsWeb) ? FontSize.size_2 : FontSize.size_10,
                        ),
                      )
                          : Container(),
                      // _widgetSearchCondition(logic,setStateGoal),
                      (logic.createdCondition.isNotEmpty)
                          ? Column(
                        children: [
                          ListView.builder(
                            itemBuilder: (context, index) {
                              return _itemConditionListed(
                                  logic.createdCondition[index],
                                  logic,
                                  index,
                                  context,
                                  setStateGoal,constraints);
                            },
                            itemCount: logic.createdCondition.length,
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
                                      backgroundColor: MaterialStateProperty.all(CColor.transparent),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                          side: const BorderSide(color: CColor.primaryColor, width: 0.7),
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all((kIsWeb) ? 10 : 5),
                                      child: Text(
                                        "Cancel",
                                        textAlign: TextAlign.center,
                                        style: AppFontStyle.styleW400(
                                            CColor.black, (kIsWeb) ? FontSize.size_3 : FontSize.size_12),
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
                                      backgroundColor: MaterialStateProperty.all(CColor.primaryColor),
                                      elevation: MaterialStateProperty.all(1),
                                      shadowColor: MaterialStateProperty.all(CColor.gray),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                          side:
                                          const BorderSide(color: CColor.primaryColor, width: 0.7),
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all((kIsWeb) ? 10 : 5),
                                      child: Text(
                                        "Ok",
                                        textAlign: TextAlign.center,
                                        style: AppFontStyle.styleW400(CColor.white,
                                            (kIsWeb) ? FontSize.size_3 : FontSize.size_12),
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
                            "You don't have any goals",
                            style: AppFontStyle.styleW700(
                              CColor.black,
                              (kIsWeb) ? FontSize.size_3 : FontSize.size_10,
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


  _itemConditionListed(ConditionSyncDataModel goalData, ReferralAssignedFormController logic,
      int index, BuildContext context, setStateGoal,BoxConstraints constraints) {
    return GestureDetector(
      onTap: () {
        logic.onChangeConditionSelect(goalData, index);
        setStateGoal((){});
      },
      child: Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            // color: (goalData == logic.selectedCreatedGoals)
              color: (logic.createdCondition[index].isSelected)
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
                    "${goalData.verificationStatus} ${goalData.display}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: AppFontStyle.styleW700(
                      CColor.black,
                      (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints)  : FontSize.size_10,
                    ),
                  ),
                  if(goalData.onset != null)
                    Container(
                    margin: EdgeInsets.only(top: Sizes.height_0_5),
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      "Onset date: ${DateFormat(Constant.commonDateFormatDdMmYyyy).format(goalData.onset!)}",
                      style: AppFontStyle.styleW500(
                        CColor.black,
                        (kIsWeb) ? AppFontStyle.sizesFontManageWeb(0.9, constraints) : FontSize.size_9,
                      ),
                    ),
                  ),
                  /*Container(
                    margin: EdgeInsets.only(top: Sizes.height_0_5),
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      "Status: ${goalData.abatement}",
                      style: AppFontStyle.styleW500(
                        CColor.black,
                        (kIsWeb) ? FontSize.size_2 : FontSize.size_9,
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _widgetSearchCondition(ReferralAssignedFormController logic,setStateFromMain) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_2, right: Sizes.width_3, left: Sizes.width_1_5),
          decoration: BoxDecoration(
            color: CColor.transparent,

            border: Border.all(
              color: CColor.primaryColor, width: 0.7,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: TextFormField(
            controller: logic.searchConditionControllers,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.start,
            focusNode: logic.searchConditionFocus,
            textInputAction: TextInputAction.done,
            style: AppFontStyle.styleW500(
                CColor.black, (kIsWeb) ? FontSize.size_3 : FontSize.size_10),
            cursorColor: CColor.black,
            decoration: const InputDecoration(
              hintText: "Search Name",
              filled: true,
              border: InputBorder.none,
            ),
            onChanged: (value) {
              logic.getConditionData(value,setStateFromMain);
            },
          ),
        ),
      ],
    );
  }

}
