import 'package:banny_table/ui/goalForm/datamodel/notesData.dart';
import 'package:banny_table/ui/referralForm/datamodel/performerData.dart';
import 'package:banny_table/ui/toDoForm/controllers/to_do_form_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
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

import '../../../utils/utils.dart';

class ToDoFormScreen extends StatelessWidget {
  const ToDoFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColor.white,
      appBar: AppBar(
        backgroundColor: CColor.primaryColor,
        title: const Text("ToDo"),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: GetBuilder<ToDoController>(builder: (logic) {
                return Column(
                  children: [
                    ///General
                    if(logic.isGeneralInfo() && !logic.isManualTask())_widgetStatusGeneralInfoResponseText(logic),

                    ///review-material
                    (logic.isReviewContact() && logic.reviewMaterialControllerURL.text != "")?
                    _widgetReviewMaterialURlText(logic): Container(),
                    (logic.isReviewContact() && logic.reviewMaterialControllerTitle.text != "")?
                    _widgetReviewMaterialTitleText(logic): Container(),

                    ///Both in make -Contact select
                    (logic.isChosenContact() && logic.selectedPerformer.performerId != "" &&  logic.selectedPerformer.performerName != "")?
                    _widgetReferralAssignedToDropDown(context,logic): Container(),

                    _widgetCodeDropDown(context,logic),
                    (logic.isGeneralInfo() && logic.generalInformationDetalisCode.text != "")?
                    _widgetGeneralInformationText(logic): Container(),




                    (logic.isChosenContact() && logic.makeContactDetalisCode.text != "")?
                    _widgetEnterMakeDetalis(logic): Container(),
                    if(logic.isChosenContact() && !logic.isManualTask())_widgetStatusChosenContact(logic),
                    _widgetStatusDropDown(context,logic),
                    if(!logic.isManualTask()) _widgetStatusReasonText(logic),
                    if(logic.selectedPriority != "" &&
                        logic.selectedPriority != "Null" &&
                        logic.selectedPriority != "null" && !logic.isManualTask())_widgetPriorityDropDown(context,logic),
                    _widgetNotesEditText(logic,context,constraints),






                    Container(
                      margin: EdgeInsets.only(
                          top: Sizes.height_2,
                          bottom: (logic.status ==
                                      Constant.toDoStatusCompleted ||
                                  logic.status == Constant.toDoStatusCancelled)
                              ? Sizes.height_5
                              : Sizes.height_2),
                      child: Row(
                        children: [
                          _buttonCancel(context),
                          _buttonAddUpdate(context),
                        ],
                      ),
                    ),
                    if(logic.status != Constant.toDoStatusCompleted && logic.status != Constant.toDoStatusCancelled)
                    _widgetButtonStatus(logic),
                  ],
                );
              }),
            );
          },

        ),
      ),
    );
  }

  _widgetCodeDropDown(BuildContext context, ToDoController logic) {
    return GetBuilder<ToDoController>(builder: (logic) {
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
                "Requested action",
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
                          logic.selectedDisplay,
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


/*  void showDialogForChooseCode(
      ToDoController logic, BuildContext context) {
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
                              index, context, Utils.codeTodoList[index].display,logic);
                        },
                        itemCount: Utils.codeTodoList.length,
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
                            "+ Add New Code",
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

  showDialogForAddNewCode(BuildContext context, ToDoController logic, setStateDialogForChooseCode){
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
                          controller: logic.addNewCodeController,
                          focusNode: logic.addNewCodeFocus,
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
                                  logic.addNewCodeDataIntoList(logic.addNewCodeController.text);
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
  }*/


  _itemCodeData(int index, BuildContext context, String codeDisplay, ToDoController logic) {
    return InkWell(
      onTap: () {
        logic.onChangeCode(index);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: Sizes.height_3,left: Sizes.width_2),
        child: Text(
          codeDisplay,
          style: AppFontStyle.styleW500(
            (Utils.codeTodoList[index].display == logic.selectedDisplay)
                ? CColor.primaryColor
                : CColor.black,
            (kIsWeb) ? FontSize.size_3 : FontSize.size_12,
          ),
        ),
      ),
    );
  }


  _widgetStatusDropDown(BuildContext context, ToDoController logic) {
    return GetBuilder<ToDoController>(builder: (logic) {
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
              child: Row(
                children: [
                  Text(
                    "Status",
                    style: AppFontStyle.styleW700(
                      CColor.black,
                      (kIsWeb)?FontSize.size_3:FontSize.size_10,
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
                                  "The current status of the task")),
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
              padding: EdgeInsets.symmetric(horizontal: (kIsWeb)?Sizes.width_1_5:Sizes.width_3,
                  vertical: Sizes.height_1_5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: CColor.greyF8,
                // border: Border.all(color: CColor.primaryColor, width: 0.7),
              ),
              child: DropdownButtonFormField<dynamic>(
                focusColor: Colors.white,
                decoration: const InputDecoration.collapsed(hintText: ''),
                value: logic.status,
                  style: const TextStyle(color: Colors.white),
                  iconEnabledColor: Colors.transparent,
                  iconDisabledColor: CColor.transparent,
                items: Utils.todoStatusList
                    .map<DropdownMenuItem>((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(
                      value,
                      style: AppFontStyle.styleW500(
                          CColor.black,(kIsWeb)?FontSize.size_3: FontSize.size_10),
                    ),
                  );
                }).toList(),
                onChanged: null
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _widgetStatusReasonText(ToDoController logic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_3, right: Sizes.width_3, left: Sizes.width_4),
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  text: "Status Reason",
                  style: AppFontStyle.styleW700(CColor.black,(kIsWeb)?FontSize.size_3: FontSize.size_10),
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
                              "The reason for the current status of the task, explaining why a task is delayed, completed, or cancelled.")),
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
              top: Sizes.height_1, right: Sizes.width_3, left: Sizes.width_3),
          decoration: BoxDecoration(
            color: CColor.transparent,

            border:Border.all(
              color: CColor.primaryColor, width: 0.7,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child:  TextFormField(
              controller: logic.statusReason,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.start,
              focusNode: logic.statusReasonFocus,
              textInputAction: TextInputAction.done,
              style: AppFontStyle.styleW500(CColor.black,(kIsWeb)?FontSize.size_3: FontSize.size_10),
              cursorColor: CColor.black,
              decoration: const InputDecoration(
                filled: true,
                border:InputBorder.none,
              ),
            ),
        ),
      ],
    );
  }

  Widget _widgetStatusGeneralInfoResponseText(ToDoController logic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_3, right: Sizes.width_3, left: Sizes.width_4),
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  text: "General Information Response",
                  style: AppFontStyle.styleW700(CColor.black,(kIsWeb)?FontSize.size_3: FontSize.size_10),
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
                              "The response or information you provided related to the task.")),
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
              top: Sizes.height_1, right: Sizes.width_3, left: Sizes.width_3),
          decoration: BoxDecoration(
            color: CColor.transparent,
            border:Border.all(
              color: CColor.primaryColor, width: 0.7,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child:  TextFormField(
            controller: logic.generalInfoResponseReason,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.start,
            focusNode: logic.generalInfoResponseReasonFocus,
            textInputAction: TextInputAction.done,
            style: AppFontStyle.styleW500(CColor.black,(kIsWeb)?FontSize.size_3: FontSize.size_10),
            cursorColor: CColor.black,
            decoration: const InputDecoration(
              filled: true,
              border:InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _widgetStatusChosenContact(ToDoController logic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_3, right: Sizes.width_3, left: Sizes.width_4),
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  text: "Chosen Contact",
                  style: AppFontStyle.styleW700(CColor.black,(kIsWeb)?FontSize.size_3: FontSize.size_10),
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
                              "The name of the chosen provider.")),
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
              top: Sizes.height_1, right: Sizes.width_3, left: Sizes.width_3),
          decoration: BoxDecoration(
            color: CColor.transparent,
            border:Border.all(
              color: CColor.primaryColor, width: 0.7,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child:  TextFormField(
            controller: logic.chosenContactController,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.start,
            focusNode: logic.chosenContactFocus,
            textInputAction: TextInputAction.done,
            style: AppFontStyle.styleW500(CColor.black,(kIsWeb)?FontSize.size_3: FontSize.size_10),
            cursorColor: CColor.black,
            decoration: const InputDecoration(
              filled: true,
              border:InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  _widgetPriorityDropDown(BuildContext context, ToDoController logic) {
    return GetBuilder<ToDoController>(builder: (logic) {
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
              child: Row(
                children: [
                  Text(
                    "Priority",
                    style: AppFontStyle.styleW700(
                      CColor.black,
                      (kIsWeb) ? FontSize.size_3 : FontSize.size_10,
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
                                  "The urgency level of the task.")),
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
                  horizontal: (kIsWeb) ? Sizes.width_1_5 : Sizes.width_3,
                  vertical: Sizes.height_1_5),
              decoration: BoxDecoration(
                color: CColor.greyF8,
                border:(logic.isEdited)?null:Border.all(
                  color: CColor.primaryColor, width: 0.7,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: DropdownButtonFormField<String>(
                focusColor: Colors.white,
                decoration: const InputDecoration.collapsed(hintText: ''),
                value: logic.selectedPriority,
                //elevation: 5,
                style: const TextStyle(color: Colors.white),
                iconEnabledColor: Colors.transparent,
                iconDisabledColor: CColor.transparent,
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
                /*onChanged: (value) {
                  logic.onChangePriority(value);
                  Debug.printLog("lifecycle value...$value");
                },*/
                onChanged: null,
              ),
            ),
          ],
        ),
      );
    });
  }


  Widget _buttonAddUpdate(BuildContext context) {
    return Expanded(
      child: GetBuilder<ToDoController>(builder: (logic) {
        return Container(
          margin:
          EdgeInsets.only(
              top: Sizes.height_3, left: Sizes.width_2, right: Sizes.width_2),
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              logic.updatePatientTask();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(CColor.primaryColor),
              elevation: MaterialStateProperty.all(1),
              shadowColor: MaterialStateProperty.all(CColor.gray),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: const BorderSide(
                      color: CColor.primaryColor, width: 0.7),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all((kIsWeb)?10:5),
              child: Text(
                (logic.isEdited)?"Save":"Add",
                textAlign: TextAlign.center,
                style: AppFontStyle.styleW400(CColor.white, (kIsWeb)?FontSize.size_3:FontSize.size_12),
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
        margin:
        EdgeInsets.only(
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
            padding: const EdgeInsets.all((kIsWeb)?10:5),
            child: Text(
              "Cancel",
              textAlign: TextAlign.center,
              style: AppFontStyle.styleW400(CColor.black,(kIsWeb)?FontSize.size_3: FontSize.size_12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _widgetNotesEditText(ToDoController logic,BuildContext context, BoxConstraints constraints,) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_3, right: Sizes.width_3, left: Sizes.width_4),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      "Notes",
                      style: AppFontStyle.styleW700(CColor.black, (kIsWeb)?FontSize.size_3:FontSize.size_10),
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
                                    "Additional comments or details about the task, including observations, follow-up actions, or relevant information for tracking the task.")),
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
              InkWell(
                onTap: () {
                  _showDialogForAddNote(context,logic,false,0);
                },
                child: Container(
                    margin: EdgeInsets.only(
                      right: Sizes.width_2,),
                    child: Icon(Icons.add_rounded,size: (kIsWeb) ? Sizes.width_2:Sizes.width_7,)),
              )
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

/*  _showDialogForAddNote(BuildContext context, ToDoController logic,bool isEditNote,index){
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
  }*/

  _showDialogForAddNote(
      BuildContext context, ToDoController logic, bool isEditNote, index) {
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
                                  height: (kIsWeb) ? Get.height*0.05 : Get.height*0.2,
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
                                  logic.getDataFromController();
                                  if(logic.notesValue.isNotEmpty){
                                    logic.addNotesData(logic.notesValue,isEditNote,index).then((value) => {
                                      logic.notesController.clear(),
                                      logic.notesValue = "",
                                    });
                                  }else{
                                    Utils.showToast(context, "Please enter notes");
                                  }


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


  _itemNotes(int index, NotesData notesData,ToDoController logic,BuildContext context, BoxConstraints constraints){
    return logic.notesList.isNotEmpty ?
    InkWell(
      onTap: (){
        // logic.editNoteDataController("${notesData.notes}");
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
                horizontal: (kIsWeb) ? Sizes.width_3 : Sizes.width_3,
                vertical: Sizes.height_0_5),
            padding: EdgeInsets.only(
                left: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
                right: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
                top: Sizes.height_1_8,
                bottom: Sizes.height_0_5
            ),
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded  (
                    child: Container(
                      margin: EdgeInsets.only(left: Sizes.width_2),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: Sizes.height_0_5),
                            child: Text(
                              "${notesData.author}",
                              style: AppFontStyle.styleW500(
                                CColor.black,
                                (kIsWeb)?FontSize.size_2:FontSize.size_9,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: Sizes.height_0_5),
                            child: Text(
                              "Date: ${DateFormat(Constant.commonDateFormatDdMmYyyy).format(notesData.date!)}",
                              style: AppFontStyle.styleW500(
                                CColor.black,
                                (kIsWeb)?FontSize.size_2:FontSize.size_9,
                              ),
                            ),
                          ),
                          /*Text(
                            "${notesData.notes}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppFontStyle.styleW700(
                              CColor.black,
                              (kIsWeb)?FontSize.size_3:FontSize.size_10,
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
                if((logic.notesList[index].isCreatedNote ?? false) && Utils.getPrimaryServerData() != null)
                Column(
                  children: [
                    InkWell(
                      onTapUp: (details) {
                        logic.editNoteDataController("${notesData.notes}",true);
                        _showDialogForAddNote(context,logic,true,index);
                      },
                      child: Container(
                        alignment: Alignment.topCenter,
                        padding:
                        EdgeInsets.only(left: Sizes.width_3, bottom: Sizes.height_1_5),
                        child: Icon(Icons.edit, size: (kIsWeb)?Sizes.width_1_2:Sizes.width_4),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        logic.deleteNoteListData(notesData.noteId,index);
                      },
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        padding:
                        EdgeInsets.only(left: Sizes.width_3, bottom: Sizes.height_1_5),
                        child: Icon(Icons.delete_forever,color: CColor.red, size: (kIsWeb)?Sizes.width_1_2:Sizes.width_5),
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


  _widgetReferralAssignedToDropDown(BuildContext context, ToDoController logic) {
    return GetBuilder<ToDoController>(builder: (logic) {
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
              child: Row(
                children: [
                  Text(
                    "Contact Provider",
                    style: AppFontStyle.styleW700(
                      CColor.black,
                      (kIsWeb) ? FontSize.size_3 : FontSize.size_10,
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
                                  "The name of the provider who should be contacted for this task")),
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
                    horizontal: (kIsWeb) ? Sizes.width_1_5 : Sizes.width_3,
                    vertical: Sizes.height_1_5),
                decoration: BoxDecoration(
                  color: CColor.greyF8,
                  border:(logic.isEdited)?null:Border.all(
                    color: CColor.primaryColor, width: 0.7,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: InkWell(
                  onTap: () {
                    Debug.printLog("Update Only For Provider");
                    // showRestrictedToSelectionDialog(context,logic);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child:Text(
                          logic.selectedPerformer.performerName != "" ?
                          logic.selectedPerformer.performerName : Constant.pleaseSelect
                          ,style: AppFontStyle.styleW500(
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


  showRestrictedToSelectionDialog(BuildContext context,ToDoController logic){
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
                          Expanded(child: _widgetSearchNameText(logic,setStateFromMain)),
                        ],
                      ),
                    ),
                    (Utils.performerList.isEmpty /*!isShowProgress*/)?
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
    );
  }

  Widget _widgetSearchNameText(ToDoController logic,setStateFromMain) {
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
              logic.getAssignedData(value,setStateFromMain);
            },
          ),
        ),
      ],
    );
  }


  _widgetPatientIds(ToDoController logic) {
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
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            ListView.builder(
              itemBuilder: (context, index) {
                return _itemPatientUser(index, context,Utils.performerList[index],logic);
              },
              itemCount: Utils.performerList.length,
              padding: const EdgeInsets.all(0),
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
            ),
            // Container(
            //   alignment: Alignment.center,
            //   child: (isShowProgress) ?
            //   const CircularProgressIndicator(
            //     valueColor: AlwaysStoppedAnimation(CColor.primaryColor),
            //   ) : Container(),
            // ),
          ],
        ),
      ),
    );
  }

  _itemPatientUser(int index, BuildContext context, PerformerData performerData,ToDoController logic) {
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

  Widget _widgetEnterMakeDetalis(ToDoController logic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_3, right: Sizes.width_3, left: Sizes.width_4),
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  text: "Description",
                  style: AppFontStyle.styleW700(CColor.black,(kIsWeb)?FontSize.size_3: FontSize.size_10),
                  children:[
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                          color: CColor.red,
                          fontSize: (kIsWeb)?FontSize.size_3: FontSize.size_10
                      ),
                    ),
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
                              "A detailed description of the task, including all necessary information needed to complete the task.")),
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
              top: Sizes.height_1, right: Sizes.width_3, left: Sizes.width_3),
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
            controller: logic.makeContactDetalisCode,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.start,
            focusNode: logic.makeContactDetalisCodeFocus,
            textInputAction: TextInputAction.done,
            style: AppFontStyle.styleW500(CColor.black,(kIsWeb)?FontSize.size_3: FontSize.size_10),
            cursorColor: CColor.black,
            decoration: InputDecoration(
              hintText: logic.makeContactDetalisCodeHint,
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

  Widget _widgetReviewMaterialURlText(ToDoController logic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_3, right: Sizes.width_3, left: Sizes.width_4),
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  text: "Url",
                  style: AppFontStyle.styleW700(CColor.black,(kIsWeb)?FontSize.size_3: FontSize.size_10),
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
                              "The web address (URL) for any online materials or resources needed for the task.")),
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
              top: Sizes.height_1, right: Sizes.width_3, left: Sizes.width_3),
          decoration: BoxDecoration(
            color: CColor.greyF8,
            border:(logic.isEdited)?null:Border.all(
              color: CColor.primaryColor, width: 0.7,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: InkWell(
            onTap: (){
              Utils.launchURL(logic.reviewMaterialControllerURL.text);
            },
            child: TextFormField(
              // maxLines: 3,
              enabled: false,
              controller: logic.reviewMaterialControllerURL,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.start,
              focusNode: logic.reviewMaterialFocusURL,
              textInputAction: TextInputAction.done,
              style: TextStyle(
                color: Colors.blue,
                fontSize: (kIsWeb) ? FontSize.size_3 : FontSize.size_10,
                fontFamily: Constant.fontFamilyPoppins,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
                decorationThickness: 2
                /// Medium
              ),
              cursorColor: CColor.black,
              decoration: InputDecoration(
                hintText: logic.reviewMaterialHintURL,
                filled: true,
                fillColor: Colors.transparent,
                border:InputBorder.none,
              ),
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

  Widget _widgetReviewMaterialTitleText(ToDoController logic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_3, right: Sizes.width_3, left: Sizes.width_4),
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  text: "Title",
                  style: AppFontStyle.styleW700(CColor.black,(kIsWeb)?FontSize.size_3: FontSize.size_10),
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
                              "The title for the task.")),
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
              top: Sizes.height_1, right: Sizes.width_3, left: Sizes.width_3),
          decoration: BoxDecoration(
            color: CColor.greyF8,
            border:(logic.isEdited)?null:Border.all(
              color: CColor.primaryColor, width: 0.7,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: TextFormField(
            // maxLines: 3,
            enabled: false,
            controller: logic.reviewMaterialControllerTitle,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.start,
            focusNode: logic.reviewMaterialFocusTitle,
            textInputAction: TextInputAction.done,
            style: AppFontStyle.styleW500(CColor.black,(kIsWeb)?FontSize.size_3: FontSize.size_10),
            cursorColor: CColor.black,
            decoration: InputDecoration(
              hintText: logic.reviewMaterialHintTitle,
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

  Widget _widgetGeneralInformationText(ToDoController logic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_3, right: Sizes.width_3, left: Sizes.width_4),
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  text: "Description",
                  style: AppFontStyle.styleW700(CColor.black,(kIsWeb)?FontSize.size_3: FontSize.size_10),
                  children:[
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                          color: CColor.red,
                          fontSize: (kIsWeb)?FontSize.size_3: FontSize.size_10
                      ),
                    ),
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
                              "A detailed description of the task, including all necessary information needed to complete the task.")),
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
              top: Sizes.height_1, right: Sizes.width_3, left: Sizes.width_3),
          decoration: BoxDecoration(
            color: CColor.greyF8,
            border:(logic.isEdited)?null:Border.all(
              color: CColor.primaryColor, width: 0.7,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: TextFormField(
            maxLines: 3,
            enabled: false,
            controller: logic.generalInformationDetalisCode,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.start,
            focusNode: logic.generalInformationDetalisCodeFocus,
            textInputAction: TextInputAction.done,
            style: AppFontStyle.styleW500(CColor.black,(kIsWeb)?FontSize.size_3: FontSize.size_10),
            cursorColor: CColor.black,
            decoration: InputDecoration(
              hintText: logic.generalInformationDetalisCodeHint,
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


  _widgetButtonStatus(ToDoController logic){
    return Container(
      margin:
      EdgeInsets.only(
          left: Sizes.width_2, right: Sizes.width_2,bottom: Sizes.height_3),
      child: Row(
        children: [
          if(logic.status != Constant.toDoStatusCompleted &&  logic.status != Constant.toDoStatusCancelled && logic.status != Constant.toDoStatusInProgress)
          Expanded(
            child: GestureDetector(
              onTap: (){
                logic.manageToDOStatus(Constant.isProgress);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: Get.height*0.013,
                    horizontal: Get.width*0.02
                ),
                margin: EdgeInsets.only(
                  right: Get.width*0.01
                ),
                decoration: BoxDecoration(
                    color: CColor.primaryColor30,
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    color: CColor.primaryColor
                  )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text("In-Progress",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: AppFontStyle.styleW400(CColor.black, (kIsWeb)?FontSize.size_3:FontSize.size_10),
                      ),
                    ),
                    Image.asset(Constant.icInProgress,width: Get.height*0.03,height: Get.height*0.02,),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: (){
                logic.manageToDOStatus(Constant.isCompleted);
              },
              child: Container(
                margin: EdgeInsets.only(
                    right: Get.width*0.01,
                    left: (logic.status != Constant.toDoStatusInProgress)? Get.width*0.01 :0.0,
                ),
                padding: EdgeInsets.symmetric(
                    vertical: Get.height*0.013,
                  horizontal: Get.width*0.02
                ),
                decoration: BoxDecoration(
                  color: CColor.primaryColor30,
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    color: CColor.primaryColor
                  )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(Constant.toDoStatusCompleted,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: AppFontStyle.styleW400(CColor.black, (kIsWeb)?FontSize.size_3:FontSize.size_10),
                      ),
                    ),
                    Image.asset(Constant.icCompleted,width: Get.height*0.03,height: Get.height*0.02,),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: (){
                logic.manageToDOStatus(Constant.isCancel);
              },
              child: Container(
                margin: EdgeInsets.only(
                  left:  Get.width*0.01,
                ),
                padding: EdgeInsets.symmetric(
                    vertical: Get.height*0.013,
                    horizontal: Get.width*0.02
                ),
                decoration: BoxDecoration(
                    color: CColor.primaryColor30,
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    color: CColor.primaryColor
                  )
                ),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        child: Text("Cancelled",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: AppFontStyle.styleW400(CColor.black, (kIsWeb)?FontSize.size_3:FontSize.size_10),
                        ),
                      ),
                    ),
                    Image.asset(Constant.icCancel,width: Get.height*0.03,height: Get.height*0.02,),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


}
