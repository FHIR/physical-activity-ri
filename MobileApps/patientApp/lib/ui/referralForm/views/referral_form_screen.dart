import 'package:banny_table/db_helper/box/condition_form_data.dart';
import 'package:banny_table/ui/goalForm/datamodel/notesData.dart';
import 'package:banny_table/ui/referralForm/controllers/referral_form_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../utils/constant.dart';
import '../../../utils/utils.dart';
import '../datamodel/performerData.dart';

class ReferralFormScreen extends StatelessWidget {
  const ReferralFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColor.white,
      appBar: AppBar(
        backgroundColor: CColor.primaryColor,
        title: const Text("Referral form",
          style: TextStyle(
            color: CColor.white,
            // fontSize: 20,
            fontFamily: Constant.fontFamilyPoppins,
          ),),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context,BoxConstraints constraints) {
            return SingleChildScrollView(
              child: GetBuilder<ReferralFormController>(builder: (logic) {
                return Column(
                  children: [
                    _widgetReferralTypeDropDown(context, logic,constraints),
                    // _widgetOccurrence(context, logic,constraints),
                    _widgetDateEditText(context, logic,constraints),
                    if(logic.selectedPriority != null &&
                        logic.selectedPriority != "Null" &&
                        logic.selectedPriority != "null")_widgetPriorityDropDown(context, logic,constraints),
                    if(logic.textReasonCode.text != "")
                    _widgetEnterText(logic,constraints),
                    if(logic.selectedPerformer.performerId != "" && logic.selectedPerformer.performerName != "")
                    _widgetPerformerDropDown(context, logic,constraints),
                    if(logic.createdCondition.where((element) => element.isSelected).toList().isNotEmpty /*|| logic.showCondition.isNotEmpty*/)
                      _widgetConditionSelect(context,logic,constraints),
                    Row(
                      children: [
                        if(logic.selectedStatus != null &&
                            logic.selectedStatus != "Null" &&
                            logic.selectedStatus != "null")_widgetStatusDropDown(context, logic,constraints),

                      ],
                    ),
                    if(logic.notesList.isNotEmpty)_widgetNotesEditText(logic,context,constraints),
                    /*Container(
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
              }),
            );
          }
        ),
      ),
    );
  }

/*
  _widgetCreatedGoalsDropDown(
      BuildContext context, ReferralFormController logic) {
    return GetBuilder<ReferralFormController>(builder: (logic) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: Sizes.width_3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      bottom: Sizes.height_1,
                      top: Sizes.height_3,
                      left: Sizes.width_2),
                  child: Text(
                    "Select Goals",
                    style: AppFontStyle.styleW700(
                      CColor.black,
                      (kIsWeb) ? FontSize.size_3 : FontSize.size_10,
                    ),
                  ),
                ),
                Spacer(),
                (logic.createdGoals.where((element) => element.isSelected).toList().isNotEmpty)? InkWell(
                  onTap: () {
                    showDialogForChooseGoal(logic,context);
                  },
                  child: Container(
                      margin: EdgeInsets.only(
                        right: Sizes.width_2,
                        top: Sizes.height_3,
                        bottom: Sizes.height_1,),
                      child: Icon(Icons.add_rounded,size: (kIsWeb) ? Sizes.width_2:Sizes.width_7,)),
                ): Container()
              ],
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
              child: (logic.createdGoals.where((element) => element.isSelected).toList().isNotEmpty)
                  ? ListView.builder(
                      itemBuilder: (context, index) {
                        return _itemSelectedGoal(
                            logic.createdGoals
                                .where((element) => element.isSelected)
                                .toList()[index],
                            index,
                            logic);
                      },
                      physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: logic.createdGoals.where((element) => element.isSelected).toList().length,
              )
                  : InkWell(
                onTap: () {
                  showDialogForChooseGoal(logic, context);
                },
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                          "Choose your goal",
                          style: AppFontStyle.styleW500(
                            CColor.black,
                            (kIsWeb) ? FontSize.size_2 : FontSize.size_10,
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

  _itemSelectedGoal(GoalTableData goalData, int index, ReferralFormController logic){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${goalData.target} ${goalData.multipleGoals}",
          style: AppFontStyle.styleW700(
            CColor.black,
            (kIsWeb) ? FontSize.size_3 : FontSize.size_10,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: Sizes.height_0_5),
          child: Text(
            "Due date: ${DateFormat(Constant.commonDateFormatDdMmYyyy).format(goalData.dueDate!)}",
            style: AppFontStyle.styleW500(
              CColor.black,
              (kIsWeb)
                  ? FontSize.size_2
                  : FontSize.size_9,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: Sizes.height_0_5),
          child: Text(
            "Status: ${goalData.achievementStatus}",
            style: AppFontStyle.styleW500(
              CColor.black,
              (kIsWeb)
                  ? FontSize.size_2
                  : FontSize.size_9,
            ),
          ),
        ),
        if(logic.createdGoals.where((element) => element.isSelected).toList().length > (index+1))
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
*/

  _widgetStatusDropDown(BuildContext context, ReferralFormController logic,BoxConstraints constraints) {
    return GetBuilder<ReferralFormController>(builder: (logic) {
      return Expanded(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_3),
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
                                    "The current status of the referral.")),
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
              /*Container(
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
                  value: logic.selectedStatus,
                  //elevation: 5,
                  style: const TextStyle(color: Colors.white),
                  iconEnabledColor: Colors.black,
                  items: Utils.statusList
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
                    logic.onChangeStatus(value);
                    // logic.onChangeLifeCycleStatus(value!);
                    Debug.printLog("lifecycle value...$value");
                  },
                ),
              ),*/
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
                      vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.5, constraints)  :Sizes.height_1_5),
                  decoration: BoxDecoration(
                    color: CColor.greyF8,
                    border:(logic.isEdited)?null:Border.all(
                      color: CColor.primaryColor, width: 0.7,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          logic.selectedStatus,
                          style: AppFontStyle.styleW500(
                            CColor.black,
                              (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_10),

                        ),
                      ),
                      // const Icon(Icons.arrow_drop_down_rounded)
                    ],
                  )),
            ],
          ),
        ),
      );
    });
  }

  _widgetIntentDropDown(BuildContext context, ReferralFormController logic) {
    return GetBuilder<ReferralFormController>(builder: (logic) {
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
                "Intent",
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
                value: logic.selectedIntent,
                //elevation: 5,
                style: const TextStyle(color: Colors.white),
                iconEnabledColor: Colors.black,
                items: Utils.intentList
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
                  logic.onChangeIntent(value);
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

    _widgetPriorityDropDown(BuildContext context, ReferralFormController logic,BoxConstraints constraints) {
    return GetBuilder<ReferralFormController>(builder: (logic) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.5, constraints): Sizes.width_3),
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
                                  "The urgency of the referral. Options include 'Routine' for standard referrals and 'Urgent' for those needing immediate attention.")),
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
            /*Container(
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
                value: logic.selectedPriority,
                //elevation: 5,
                style: const TextStyle(color: Colors.white),
                iconEnabledColor: Colors.black,
                items: Utils.priorityList
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
                  logic.onChangePriority(value);
                  Debug.printLog("lifecycle value...$value");
                },
              ),
            ),*/
            Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    horizontal: (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
                    vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.5, constraints)  :Sizes.height_2),
                decoration: BoxDecoration(
                  color: CColor.greyF8,
                  border:(logic.isEdited)?null:Border.all(
                    color: CColor.primaryColor, width: 0.7,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        logic.selectedPriority,
                        style: AppFontStyle.styleW500(
                          CColor.black,
                            (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints):  FontSize.size_10),

                      ),
                    ),
                    // const Icon(Icons.arrow_drop_down_rounded)
                  ],
                )),
          ],
        ),
      );
    });
  }

  _widgetReferralTypeDropDown(BuildContext context, ReferralFormController logic,BoxConstraints constraints) {
    return GetBuilder<ReferralFormController>(builder: (logic) {
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
                  Text(
                    "Referral Type",
                    style: AppFontStyle.styleW700(
                      CColor.black,
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
                                  "The type of referral being made, or a new type if it is not listed.")),
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
                child: InkWell(
                  onTap: () {
                    // showDialogForChooseCode(logic, context);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          logic.selectedCodeType,
                          style: AppFontStyle.styleW500(
                            CColor.black,
                              (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.0, constraints): FontSize.size_10)
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

  _widgetPerformerDropDown(BuildContext context, ReferralFormController logic,BoxConstraints constraints) {
    return GetBuilder<ReferralFormController>(builder: (logic) {
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
                  Text(
                    "Restricted to",
                    style: AppFontStyle.styleW700(
                      CColor.black,
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
                                  "The name of the provider to whom this referral is specifically directed")),
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
            /*Container(
              padding: EdgeInsets.symmetric(
                  horizontal: (kIsWeb) ? Sizes.width_1_5 : Sizes.width_3,
                  vertical: Sizes.height_1_5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: CColor.greyF8,
                border: Border.all(color: CColor.primaryColor, width: 0.7),
              ),
              child: DropdownButtonFormField(
                focusColor: Colors.white,
                decoration: const InputDecoration.collapsed(hintText: ''),
                value: logic.selectedPerformer,
                //elevation: 5,
                style: const TextStyle(color: Colors.white),
                iconEnabledColor: Colors.black,
                isExpanded: true,
                items: Utils.performerList.map<DropdownMenuItem<PerformerData>>((value) {
                  return DropdownMenuItem<PerformerData>(
                    value:value,
                    child: Text(
                      "${value.performerId}->${value.performerName}",
                      overflow: TextOverflow.ellipsis,
                      style: AppFontStyle.styleW500(
                          CColor.black, (kIsWeb) ? FontSize.size_3 : FontSize.size_10),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  logic.onChangePerformer(value);
                  // logic.onChangeLifeCycleStatus(value!);
                  Debug.printLog("value...$value");
                },
              ),
            ),*/
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
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${logic.selectedPerformer.performerName}",
                        style: AppFontStyle.styleW500(
                          CColor.black,
                            (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.0, constraints): FontSize.size_10
                        ),
                      ),
                    ),
                    // const Icon(Icons.arrow_drop_down_rounded)
                  ],
                )),
          ],
        ),
      );
    });
  }

  _widgetOccurrence(BuildContext context, ReferralFormController logic,BoxConstraints constraints) {
    return GetBuilder<ReferralFormController>(builder: (logic) {
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
                  Text(
                    "Complete within Timeframe",
                    style: AppFontStyle.styleW700(
                      CColor.black,
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
                                  "Specify the start and end dates by which the referral actions should be completed.")),
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
              child: Row(
                children: [
                  // Container(
                  //   alignment: Alignment.center,
                  //   child: Text("Period date :",
                  //     style: AppFontStyle.styleW700(
                  //       CColor.black,
                  //         (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_10),
                  //   ),
                  // ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        // showDatePickerDialog(logic, context,Constant.periodDate,true);
                      },
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.0, constraints) :Sizes.width_3),
                            child: Text(
                              logic.periodStartDateStr.text,
                              style: AppFontStyle.styleW400(
                                CColor.black,
                                  (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_10),

                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left:(kIsWeb) ?AppFontStyle.sizesWidthManageWeb(0.5, constraints) : Sizes.width_1),
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
                    // margin: EdgeInsets.only(right: Sizes.width_5,left: Sizes.width_5),
                    margin: EdgeInsets.only(left:(kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_5 ,right:Sizes.width_5),
                    child: Text(
                      "&",
                      style: AppFontStyle.styleW400(
                        CColor.black,
                          (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_10),

                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        // showDatePickerDialog(logic, context,Constant.periodDate,false);
                      },
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(0.5, constraints) :Sizes.width_1),
                            child: Text(
                              logic.periodEndDateStr.text,
                              style: AppFontStyle.styleW400(
                                CColor.black,
                                  (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_10),

                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(0.5, constraints) :Sizes.width_1),
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
          ],
        ),
      );
    });
  }

  _widgetDateEditText(BuildContext context, ReferralFormController logic,BoxConstraints constraints) {
    return Row(
      children: [
        _widgetOnsetDate(logic, context,constraints),
        if(logic.periodEndDateStr.text != "")
          _widgetAbatementDate(logic, context,constraints),
      ],
    );
  }

  Widget _widgetOnsetDate(ReferralFormController logic, BuildContext context,BoxConstraints constraints) {
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
                                "The start and end dates by which the referral actions should be completed.")),
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

  Widget _widgetAbatementDate(ReferralFormController logic, BuildContext context,BoxConstraints constraints) {
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
                                "The start and end dates by which the referral actions should be completed.")),
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


/*  _itemNotes(int index, NotesData notesData) {
    return Container(
      // height: Sizes.height_6,
      margin: EdgeInsets.only(
          top: Sizes.height_1, right: Sizes.width_3, left: Sizes.width_3),
      color: CColor.transparent,
      child: TextFormField(
        controller: notesData.controller,
        textAlign: TextAlign.start,
        keyboardType: TextInputType.text,
        style: AppFontStyle.styleW500(
            CColor.black, (kIsWeb) ? FontSize.size_3 : FontSize.size_10),
        maxLines: 2,
        cursorColor: CColor.black,
        decoration: InputDecoration(
          hintText: "Enter your notes".tr,
          filled: true,
          // contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: Sizes.width_5),
          border: OutlineInputBorder(
            borderSide:
                const BorderSide(color: CColor.primaryColor, width: 0.7),
            borderRadius: BorderRadius.circular(15.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: CColor.primaryColor, width: 0.7),
            borderRadius: BorderRadius.circular(15.0),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: CColor.primaryColor, width: 0.7),
            borderRadius: BorderRadius.circular(15.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: CColor.primaryColor, width: 0.7),
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
    );
  }*/

  Widget _buttonAddUpdate(BuildContext context) {
    return Expanded(
      child: GetBuilder<ReferralFormController>(builder: (logic) {
        return Container(
          margin: EdgeInsets.only(
              top: Sizes.height_3, left: Sizes.width_2, right: Sizes.width_2),
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              if(logic.isValidation()) {
                logic.insertUpdateData();
              }
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
                (logic.isEdited) ? "Edit" : "Assign",
                textAlign: TextAlign.center,
                style: AppFontStyle.styleW400(CColor.white,
                    (kIsWeb) ? FontSize.size_3 : FontSize.size_12),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buttonCancel(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(
            top: Sizes.height_3, left: Sizes.width_2, right: Sizes.width_2),
        width: double.infinity,
        child: TextButton(
          onPressed: () {
            Get.back();
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
    );
  }

  Future<void> showDatePickerDialog(
      ReferralFormController logic, BuildContext context,String dateType ,bool isStartDate) async {
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

  /*void showDialogForChooseGoal(
      ReferralFormController logic, BuildContext context) {
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
                            "No goals are currently recorded ",
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

  _itemGoalListed(GoalTableData goalData, ReferralFormController logic,
      int index, BuildContext context, setStateGoal) {
    return GestureDetector(
      onTap: () {
        logic.onChangeGoalSelect(goalData, index);
        setStateGoal((){});
      },
      child: Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              // color: (goalData == logic.selectedCreatedGoals)
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
  }*/

  void showDialogForChooseCode(
      ReferralFormController logic, BuildContext context) {
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
                              index, context, Utils.codeList[index].display,logic);
                        },
                        itemCount: Utils.codeList.length,
                        padding: const EdgeInsets.all(0),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                      ),
                      InkWell(
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
                      )
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

  showDialogForAddNewCode(BuildContext context, ReferralFormController logic, setStateDialogForChooseCode){
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
                                  logic.addNewCodeDataIntoList(logic.addReferralTypeController.text);
                                  setStateDialogForChooseCode((){});
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
                                    "Add",
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
                  ),
                ),
              ),
            ],
          ),
        );
      },);
  }

  _itemCodeData(int index, BuildContext context, String codeList, ReferralFormController logic) {
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
            (kIsWeb) ? FontSize.size_3 : FontSize.size_12,
          ),
        ),
      ),
    );
  }


  Widget _widgetNotesEditText(ReferralFormController logic,BuildContext context,BoxConstraints constraints) {
    return Column(
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
                      style: AppFontStyle.styleW700(CColor.black,                       (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints): FontSize.size_10),

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
                                    "Additional comments or details about the exercise referral.")),
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
              /*(!logic.referralEditedData.readonly )? InkWell(
                onTap: () {
                  _showDialogForAddNote(context,logic,false,0);
                  // logic.addNotesData();
                },
                child: Container(
                    margin: EdgeInsets.only(
                      right: Sizes.width_2,),
                    child: Icon(Icons.add_rounded,size: (kIsWeb) ? Sizes.width_2:Sizes.width_7,)),
              ): Container()*/
            ],
          ),
        ),
        ListView.builder(itemBuilder: (context, index) {
          return _itemNotes(index,logic.notesList[index],logic,context,constraints);
        },
          shrinkWrap: true,
          itemCount:logic.notesList.length,
          reverse: true,
          physics: const NeverScrollableScrollPhysics(),
        ),

      ],
    );
  }

  _showDialogForAddNote(BuildContext context, ReferralFormController logic,bool isEditNote,index){
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
                  padding: EdgeInsets.all((kIsWeb) ? Sizes.width_2 :Sizes.width_5),
                  width: (kIsWeb) ? Sizes.width_30 :Get.width * 0.8,
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
                          style: AppFontStyle.styleW500(
                              CColor.black,
                              (kIsWeb)
                                  ? FontSize.size_3
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
                                        CColor.black, (kIsWeb) ? FontSize.size_3 : FontSize.size_12),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: Sizes.width_2),
                            Expanded(
                              child: TextButton(
                                onPressed: () {

                                  logic.addNotesData(logic.notesController.text,isEditNote,index).then((value) => {
                                    logic.notesController.clear(),
                                  });
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
                                        (kIsWeb) ? FontSize.size_3 : FontSize.size_12),
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

  _itemNotes(int index, NotesData notesData,ReferralFormController logic,BuildContext context,BoxConstraints constraints){
    return logic.notesList.isNotEmpty ?
    InkWell(
      onTap: (){
        // logic.editNoteDataController("${notesData.notes}");
        // showDialogForAddNewCode(context,logic,true);
        // _showDialogForAddNote(context,logic,true,index);
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
                      margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.8, constraints): Sizes.width_2),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
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
                /*Column(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      padding:
                      EdgeInsets.only(left: Sizes.width_3, bottom: Sizes.height_1_5),
                      child: Icon(Icons.edit, size: (kIsWeb)?Sizes.width_1_2:Sizes.width_4),
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
                        child: Icon(Icons.delete_forever,color: CColor.red, size: (kIsWeb)?Sizes.width_1_2:Sizes.width_5),
                      ),
                    ),
                  ],
                ),*/
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
      ),
    ) : Container();
  }


  Widget _widgetEnterText(ReferralFormController logic,BoxConstraints constraints) {
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
                  text: "Instructions",
                  style: AppFontStyle.styleW700(CColor.black,(kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints): FontSize.size_10),
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
                              "Detailed instructions for the referral, including specific actions, reasons for the referral, and any other relevant guidelines")),
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
              top: Sizes.height_1, right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) :Sizes.width_3, left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3),
          decoration: BoxDecoration(
            color: CColor.greyF8,
            border:(logic.isEdited)?null:Border.all(
              color: CColor.primaryColor, width: 0.7,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: TextFormField(
            enabled: false,
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
              fillColor: Colors.transparent,
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


  _widgetConditionSelect(
      BuildContext context, ReferralFormController logic,BoxConstraints constraints) {
    return GetBuilder<ReferralFormController>(builder: (logic) {
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
                                      "The condition related to this referral")),
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
                // (logic.createdCondition.where((element) => element.isSelected).toList().isNotEmpty)? InkWell(
                //   onTap: () {
                //     // showDialogForChooseGoal(logic,context);
                //   },
                //   child: Container(
                //       margin: EdgeInsets.only(
                //         right: Sizes.width_2,
                //         top: Sizes.height_3,
                //         bottom: Sizes.height_1,),
                //       child: Icon(Icons.add_rounded,size: (kIsWeb) ? Sizes.width_2:Sizes.width_7,)),
                // ): Container()
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
                  : Container()/*InkWell(
                onTap: () {
                  // showDialogForChooseGoal(logic, context);
                },
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                          "Choose your Condition",
                          style: AppFontStyle.styleW500(
                            CColor.black,
                            (kIsWeb) ? FontSize.size_2 : FontSize.size_10,
                          ),
                        )),
                    // const Icon(Icons.arrow_drop_down_rounded)
                  ],
                ),
              ),*/
            ),
          ],
        ),
      );
    });
  }


  _itemSelectedGoal(ConditionTableData goalData, int index, ReferralFormController logic,BoxConstraints constraints){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${goalData.verificationStatus} ${goalData.display}",
          style: AppFontStyle.styleW700(
            CColor.black,
            (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_10,
          ),
        ),
        if(goalData.onset != null)
        Container(
          margin: EdgeInsets.only(top: Sizes.height_0_5),
          child: Text(
            "Onset date: ${DateFormat(Constant.commonDateFormatDdMmYyyy).format(goalData.onset!)}",
            style: AppFontStyle.styleW500(
              CColor.black,
              (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(0.9, constraints) : FontSize.size_9,

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


}
