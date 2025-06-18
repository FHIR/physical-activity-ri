import 'package:banny_table/ui/referralForm/datamodel/performerData.dart';
import 'package:banny_table/ui/taskReferral/controllers/task_referral_form_controller.dart';
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
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../utils/constant.dart';
import '../../../utils/utils.dart';
import '../../goalForm/datamodel/notesData.dart';

class TaskReferralScreen extends StatelessWidget {
  const TaskReferralScreen({super.key});

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
          title: const Text(Constant.settingReferral),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context,BoxConstraints constraints) {
              return SingleChildScrollView(
                child: GetBuilder<TaskReferralController>(builder: (logic) {
                  return Column(
                    children: [
                      _widgetReferralTypeDropDown(context,logic,constraints),
                      _widgetDateEditText(context,logic,constraints),
                      Row(
                        children: [
                          if(logic.statusFix != Constant.statusDraft) _widgetStatusDropDown(context, logic,constraints),
                          _widgetPriorityDropDown(context, logic,constraints),
                        ],
                      ),
                      if(logic.referralInstructions.text.isNotEmpty)_widgetInsText(logic,constraints),
                      _widgetNotesEditText(logic, context,constraints),
                      if(logic.isEdited && (logic.editedToDoData.forDisplay != null &&  logic.editedToDoData.forDisplay.toLowerCase() != "null" ) ) _widgetPatientName(context, logic,constraints),
                      if(logic.isEdited && (logic.editedToDoData.ownerDisplay != null &&  logic.editedToDoData.ownerDisplay.toLowerCase() != "null") ) _widgetOwnerName(context, logic,constraints),
                      if(logic.isEdited && (logic.editedToDoData.requesterDisplay != null &&  logic.editedToDoData.requesterDisplay.toLowerCase() != "null") ) _widgetRequesterName(context, logic,constraints),
                      Container(
                        margin: EdgeInsets.only(
                            top: Sizes.height_2, bottom: Sizes.height_1),
                        child: Row(
                          children: [
                            _buttonCancel(context,logic,constraints),
                            _buttonAddUpdate(context,constraints,logic),
                          ],
                        ),
                      ),
                      // if(logic.statusFix == Constant.statusDraft) _buttonSaveAsDraft(context,constraints),
                    ],
                  );
                }),
              );
            }
          ),
        ),
      ),
    );
  }


  _widgetReferralTypeDropDown(BuildContext context, TaskReferralController logic,BoxConstraints constraints) {
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
                    if(logic.editedToDoData.isCreated!) {
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
  }

  void showDialogForChooseCode(
      TaskReferralController logic, BuildContext context,BoxConstraints constraints) {
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

  _itemCodeData(int index, BuildContext context, String codeList, TaskReferralController logic,BoxConstraints constraints) {
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


  Widget _buttonCancel(BuildContext context, TaskReferralController logic,BoxConstraints constraints) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(
            top: (kIsWeb)
                ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                : Sizes.height_3,
            right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.8, constraints):  Sizes.width_2,
            left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.1, constraints)  :Sizes.width_2),        width: double.infinity,
        child: TextButton(
          onPressed: () {
            Get.back(result:logic.editedToDoData);
            // Navigator.pop(context);
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
            padding: (logic.statusHint != Constant.statusDraft && logic.isEdited) ?EdgeInsets.all((kIsWeb) ? 10 : 8) :const EdgeInsets.all((kIsWeb) ? 10 : 5),
            child: Text(
              "Cancel",
              textAlign: TextAlign.center,
              style: AppFontStyle.styleW400(CColor.black,(kIsWeb)?AppFontStyle.sizesFontManageWeb(1.3, constraints): FontSize.size_12),

            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonAddUpdate(BuildContext context,BoxConstraints constraints,TaskReferralController logic) {
    return Expanded(
    child: Container(
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
            color: logic.statusHint == Constant.statusDraft ? CColor.primaryColor:CColor.primaryColor,
            width: logic.statusHint == Constant.statusDraft ? 2:(kIsWeb) ? 1:2
        ),
        borderRadius: logic.statusHint == Constant.statusDraft ? BorderRadius.circular(15.0):BorderRadius.circular(15.0),
      ),
      padding: (logic.statusHint != Constant.statusDraft) ? (logic.isEdited) ? EdgeInsets.all((kIsWeb) ? 5 : 2):EdgeInsets.all(0) : EdgeInsets.all(0) ,

      child: TextButton(
            onPressed: () {
              logic.insertUpdateData();
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
              padding: (logic.statusHint != Constant.statusDraft) ? (logic.isEdited) ?EdgeInsets.all((kIsWeb) ? 5 : 2) :EdgeInsets.all((kIsWeb) ? 10 : 5) :EdgeInsets.all((kIsWeb) ? 10 : 5),
              child: Text(
                logic.statusFix == Constant.statusDraft ? "Submit": (logic.isEdited) ? "Save": "Submit",
                // (logic.isEdited) ? "Edit" : "Add",
                textAlign: TextAlign.center,
                style: AppFontStyle.styleW400(CColor.white, (kIsWeb)? AppFontStyle.sizesFontManageWeb(1.3, constraints) :FontSize.size_12),

              ),
            ),
          ),
        ),
    );
  }


  Widget _buttonSaveAsDraft(BuildContext context,BoxConstraints constraints,TaskReferralController logic) {
      return Container(
        margin:           EdgeInsets.only(
            bottom: (kIsWeb)
                ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                : Sizes.height_3,
            right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints):  Sizes.width_2,
            left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.0, constraints)  :Sizes.width_2),

        width: double.infinity,
        child: TextButton(
          onPressed: () {
            // logic.insertCheckUpdate(true);
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
              "Save as draft",
              textAlign: TextAlign.center,
              style: AppFontStyle.styleW400(CColor.white,
                  (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_12),
            ),
          ),
        ),
      );
  }


  _widgetDateEditText(BuildContext context, TaskReferralController logic,BoxConstraints constraints) {
    return Row(
      children: [
        if(logic.periodStartDateStr.text.isNotEmpty)_widgetStartDate(logic,context,constraints),
        if(logic.periodEndDateStr.text.isNotEmpty)_widgetEndDate(logic, context,constraints),
      ],
    );
  }

  Widget _widgetStartDate(TaskReferralController logic,BuildContext context,BoxConstraints constraints) {
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
                left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.0, constraints)  :Sizes.width_4),
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

  Widget _widgetEndDate(TaskReferralController logic, BuildContext context,BoxConstraints constraints) {
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
                left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.0, constraints)  :Sizes.width_4),
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


  Future<void> showDatePickerDialog(
      TaskReferralController logic, BuildContext context,String dateType ,bool isStartDate) async {
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
                  logic.onChangePeriodDate(isStartDate,dateRangePickerSelectionChangedArgs);
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

  _widgetStatusDropDown(BuildContext context, TaskReferralController logic,BoxConstraints constraints) {
      return Expanded(
        child: Container(
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
                    Text(
                      "Status",
                      style: AppFontStyle.styleW700(
                        CColor.black,
                        (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_10,
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
                                    "Select the current status of the task.")),
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
                padding: EdgeInsets.symmetric(
                    horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
                    vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.3, constraints)  :Sizes.height_1_5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: CColor.greyF8,
                  border: Border.all(color: CColor.primaryColor, width: 0.7),
                ),
                child: DropdownButtonFormField<dynamic>(
                  focusColor: Colors.white,
                  decoration: const InputDecoration.collapsed(hintText: ''),
                  /* value: (logic.status.isNotEmpty &&
                          Utils.todoStatusList.contains(logic.status))
                      ? logic.status
                      : Utils.todoStatusList[0],*/
                  //elevation: 5,

                  hint: Text(logic.statusHint,style: AppFontStyle.styleW500(
                      CColor.black,(kIsWeb)?AppFontStyle.sizesFontManageWeb(1.0, constraints): FontSize.size_10),),
                  style: const TextStyle(color: Colors.white),
                  iconEnabledColor: Colors.black,
                  items: Utils.todoStatusList
                      .map<DropdownMenuItem>((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(
                        value,
                        style: AppFontStyle.styleW500(CColor.black,
                            (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_10),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    logic.onChangeStatus(value!);
                    Debug.printLog(" value...$value");
                  },
                ),
              ),
            ],
          ),
        ),
      );
  }


  _widgetPriorityDropDown(BuildContext context, TaskReferralController logic,BoxConstraints constraints) {
      return Expanded(
        child: Container(
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
                    Text(
                      "Priority",
                      style: AppFontStyle.styleW700(
                        CColor.black,
                        (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_10,
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
                                    "Choose the urgency level of the task")),
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
                  // value: (logic.selectedPriority.isNotEmpty &&
                  //         Utils.priorityList.contains(logic.selectedPriority))
                  //     ? logic.selectedPriority
                  //     : Utils.priorityList[0],
                  //elevation: 5,
                  hint: Text(logic.selectedPriorityHint,style: AppFontStyle.styleW500(
                      CColor.black,(kIsWeb)?AppFontStyle.sizesFontManageWeb(1.0, constraints): FontSize.size_10),),
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
                  onChanged: (value) {
                    // logic.onChangeLifeCycleStatus(value!);
                    logic.onChangePriority(value);
                    Debug.printLog("lifecycle value...$value");
                  },
                ),
              ),
              /*Container(
                padding: EdgeInsets.symmetric(horizontal: (kIsWeb)?Sizes.width_1_5:Sizes.width_3,
                    vertical: Sizes.height_1_5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: CColor.greyF8,
                  border: Border.all(color: CColor.primaryColor, width: 0.7),
                ),
                child: Row(
                  children: [
                    Text(
                      logic.selectedPriority,
                      style: AppFontStyle.styleW500(
                          CColor.black,(kIsWeb)?FontSize.size_3: FontSize.size_10),
                    ),
                  ],
                ),
              ),*/
            ],
          ),
        ),
      );
  }

  Widget _widgetInsText(TaskReferralController logic,BoxConstraints constraints) {
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
            controller: logic.referralInstructions,
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

  _widgetPatientName(BuildContext context, TaskReferralController logic,BoxConstraints constraints) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(
          bottom: Sizes.height_1, top: Sizes.height_3, left: Sizes.width_5),
      child: Text(
        "Patient Name: ${logic.editedToDoData.forDisplay}",
        style: AppFontStyle.styleW700(
          CColor.black,
          (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_10,
        ),
      ),
    );
  }

  _widgetOwnerName(BuildContext context, TaskReferralController logic,BoxConstraints constraints) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(
          bottom: Sizes.height_1, top: Sizes.height_1, left: Sizes.width_5),
      child: Text(
        "Owner Name: ${logic.editedToDoData.ownerDisplay}",
        style: AppFontStyle.styleW700(
          CColor.black,
          (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_10,
        ),
      ),
    );
  }

  _widgetRequesterName(BuildContext context, TaskReferralController logic,BoxConstraints constraints) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(
          bottom: Sizes.height_1, top: Sizes.height_1, left: Sizes.width_5),
      child: Text(
        "Requester Name: ${ (logic.editedToDoData.requesterDisplay != null || logic.editedToDoData.requesterDisplay.toLowerCase() != "null".toLowerCase() || logic.editedToDoData.requesterDisplay != "") ?  logic.editedToDoData.requesterDisplay : Utils.getPrimaryServerData()!.providerFName ?? ""}",
        style: AppFontStyle.styleW700(
          CColor.black,
          (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_10,
        ),
      ),
    );
  }



  Widget _widgetNotesEditText(
      TaskReferralController logic,
      BuildContext context,BoxConstraints constraints
      ) {
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
                  ? AppFontStyle.sizesWidthManageWeb(1.0, constraints)
                  : Sizes.width_4),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: Sizes.width_1),
                  child: Row(
                    children: [
                      Text(
                        "Notes",
                        style: AppFontStyle.styleW700(CColor.black,
                            (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
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
                                      "Add any additional comments or details about the task. This can include observations, follow-up actions, or relevant information for tracking the task.")),
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
              ),
              InkWell(
                onTap: () {
                  _showDialogForAddNote(context, logic, false, 0,constraints);
                },
                child: Container(
                    margin: EdgeInsets.only(
                      right: Sizes.width_1,
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      size: (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.5, constraints) : Sizes.width_7,
                    )),
              )
            ],
          ),
        ),
        ListView.builder(
          itemBuilder: (context, index) {
            return _itemNotes(index, logic.notesList[index], logic, context,constraints);
          },
          shrinkWrap: true,
          reverse: true,
          itemCount: logic.notesList.length,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }

  _showDialogForAddNote(BuildContext context, TaskReferralController logic,bool isEditNote,index,BoxConstraints constraints){
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


  _itemNotes(int index, NotesData notesData, TaskReferralController logic,
      BuildContext context,BoxConstraints constraints) {
    return logic.notesList.isNotEmpty
        ? InkWell(
      onTap: () {

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
                Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.8, constraints): Sizes.width_2),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(notesData.author != null && notesData.author != "")
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
                          /* Text(
                              "${notesData.notes}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppFontStyle.styleW700(
                                CColor.black,
                                (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.3, constraints):FontSize.size_10,
                              ),
                            ),*/
                          HtmlWidget(
                            Utils.getHtmlFromDelta( notesData.notes.toString()),
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
                      onTap: (){
                        logic.editNoteDataController("${notesData.notes}",true);
                        _showDialogForAddNote(context, logic, true, index,constraints);
                      },
                      child: Container(
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.only(
                            left: Sizes.width_3, bottom: Sizes.height_1_5),
                        child: Icon(Icons.edit,
                            size:
                            (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints)  : Sizes.width_4),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        logic.deleteNoteListData(notesData.noteId, index);
                      },
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.only(
                            left: Sizes.width_3,
                            bottom: Sizes.height_1_5),
                        child: Icon(Icons.delete_forever,
                            color: CColor.red,
                            size: (kIsWeb)
                                ? AppFontStyle.sizesFontManageWeb(1.3, constraints)
                                : Sizes.width_5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: (kIsWeb) ? Sizes.width_3 : Sizes.width_5,
            ),
            child: const Divider(
              color: CColor.black,
              height: 2,
            ),
          ),
        ],
      ),
    )
        : Container();
  }




}
