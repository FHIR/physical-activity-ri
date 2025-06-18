
import 'package:banny_table/ui/conditionForm/controllers/condition_form_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../utils/utils.dart';

class ConditionFormScreen extends StatelessWidget {
  const ConditionFormScreen({Key? key}) : super(key: key);

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
          title: const Text("Condition"),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: LayoutBuilder(
              builder: (BuildContext context,BoxConstraints constraints) {
                return GetBuilder<ConditionController>(builder: (logic) {
                  return Column(
                    children: [
                      _widgetConditionTypeDropDown(context,logic,constraints),
                      _widgetEnterText(logic,constraints),
                      if(logic.isEdited)   _widgetVerificationStatusDropDown(context,logic,constraints),
                      _widgetDateEditText(context,logic,constraints),
                      Container(
                        margin: EdgeInsets.only(top: Sizes.height_2,bottom: Sizes.height_5),
                        child: Row(
                          children: [
                            _buttonCancel(context,constraints),
                            _buttonAddUpdate(context,constraints),
                          ],
                        ),
                      ),
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

  Widget _widgetEnterText(ConditionController logic,BoxConstraints constraints) {
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
                  text: "Details",
                  style: AppFontStyle.styleW700(CColor.black,(kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
                  children:[
                    /*TextSpan(
                      text: '*',
                      style: TextStyle(
                          color: CColor.red,
                          fontSize: (kIsWeb)?FontSize.size_3: FontSize.size_10
                      ),
                    ),*/
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
                              "Enter any additional information or specifics about the condition that might be helpful for understanding the patient's health status.")),
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
          // padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(
                top: Sizes.height_1,
                right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) :Sizes.width_3, left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3),
            decoration: BoxDecoration(
              color: CColor.transparent,
              border:Border.all(
                color: CColor.primaryColor, width: 0.7,
              ),
              borderRadius: BorderRadius.circular((kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.9, constraints) :15),
            ),
            child: TextFormField(
              maxLines: 3,
              controller: logic.textDetalisController,
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
            )
          /*HtmlEditor(
            controller: logic.htmlEditorController,
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
          ),*/
        ),
      ],
    );
  }



  _widgetConditionTypeDropDown(BuildContext context, ConditionController logic,BoxConstraints constraints) {
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
              child:Row(
                children: [
                  RichText(
                    text: TextSpan(
                      text: "Condition",
                      style: AppFontStyle.styleW700(CColor.black,(kIsWeb)? AppFontStyle.sizesFontManageWeb(1.3, constraints)  : FontSize.size_10),
                      children:[
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                              color: CColor.red,
                              fontSize: (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10
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
                                  "Select the medical condition you are recording from the drop-down list, or add a new condition by entering the SNOMED CT code and condition name.")),
                        ),
                      ];
                    },
                    child: Icon(Icons.info_outline,
                        color: CColor.gray,
                        size: (kIsWeb) ? 6.sp : FontSize.size_12),
                  ),
                ],
              ),
              // child: Text(
              //   "Condition",
              //   style: AppFontStyle.styleW700(
              //     CColor.black,
              //     (kIsWeb) ? FontSize.size_3 : FontSize.size_10,
              //   ),
              // ),
            ),
            Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
                    vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.8, constraints)  :Sizes.height_1_5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular((kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.9, constraints) :15),
                  color: CColor.greyF8,
                  border: Border.all(color: CColor.primaryColor, width: 0.7),
                ),
                child: InkWell(
                  onTap: () {
                    showDialogForChooseCode(logic, context,constraints);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          logic.selectedCodeTypeConditionHint,
                          style: AppFontStyle.styleW500(
                            CColor.black,
                              (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.0, constraints): FontSize.size_10
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down_rounded)
                    ],
                  ),
                )),
          ],
        ),
      );

  }

  void showDialogForChooseCode(
      ConditionController logic, BuildContext context,BoxConstraints constraints) {
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
                              index, context, Utils.conditionDropDown[index].display,logic,constraints);
                        },
                        itemCount: Utils.conditionDropDown.length,
                        padding: const EdgeInsets.all(0),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                      ),
                      InkWell(
                        onTap: () {
                          showDialogForAddNewCode(context,logic,setStateDialogForChooseCode,constraints);
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            left: Sizes.width_2,
                          ),
                          child: Text(
                            "+ Add New Type",
                            style: AppFontStyle.styleW500(
                              CColor.primaryColor,
                              (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_12,
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

  showDialogForAddNewCode(BuildContext context, ConditionController logic, setStateDialogForChooseCode,BoxConstraints constraints){
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
                  padding: EdgeInsets.all((kIsWeb)? AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_5),
                  width: Get.width * 0.8,
                  child: Column(
                    children: [
                      Container(
                        color: CColor.transparent,
                        child: TextFormField(
                          controller: logic.addContitionCodeController,
                          focusNode: logic.addConditionCodeFocus,
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.text,
                          style: AppFontStyle.styleW500(
                              CColor.black,
                              (kIsWeb)
                                  ? AppFontStyle.sizesFontManageWeb(1.0, constraints)
                                  : FontSize.size_10),
                          // maxLines: 1,
                          cursorColor: CColor.black,
                          decoration: InputDecoration(
                            labelText: "Enter Condition code",
                            labelStyle: const TextStyle(color: Colors.black),
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
                        margin: EdgeInsets.only(
                            top: Sizes.height_1
                        ),
                        color: CColor.transparent,
                        child: TextFormField(
                          controller: logic.addContitionTypeController,
                          focusNode: logic.addConditionTypeFocus,
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.text,
                          style: AppFontStyle.styleW500(
                              CColor.black,
                              (kIsWeb)
                                  ? AppFontStyle.sizesFontManageWeb(1.0, constraints)
                                  : FontSize.size_10),
                          maxLines: 2,
                          cursorColor: CColor.black,
                          decoration: InputDecoration(
                            labelText: "Enter your Condition",
                            labelStyle: const TextStyle(color: Colors.black),
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
                                        CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints) : FontSize.size_12),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: Sizes.width_2),
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  logic.addNewCodeDataIntoList(logic.addContitionTypeController.text,logic.addContitionCodeController.text);
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
                                        (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints) : FontSize.size_12),
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

  _itemCodeData(int index, BuildContext context, String codeList, ConditionController logic,BoxConstraints constraints) {
    return InkWell(
      onTap: () {
        logic.onChangeCode(index);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: Sizes.height_3,left: Sizes.width_2),
        child: Text(
          codeList,
          style: AppFontStyle.styleW500(
            (codeList == logic.selectedCodeTypeConditionHint)
                ? CColor.primaryColor
                : CColor.black,
            (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_12,
          ),
        ),
      ),
    );
  }

  _widgetVerificationStatusDropDown(BuildContext context, ConditionController logic,BoxConstraints constraints) {
    return GetBuilder<ConditionController>(builder: (logic) {
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
                  RichText(
                    text: TextSpan(
                      text: "Verification",
                      style: AppFontStyle.styleW700(CColor.black,(kIsWeb)?AppFontStyle.sizesFontManageWeb(1.3, constraints): FontSize.size_10),
                      children:[
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                              color: CColor.red,
                              fontSize: (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.3, constraints): FontSize.size_10
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
                                  "Choose the status of the condition verification")),
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
                        logic.selectedVerificationStatus,
                        style: AppFontStyle.styleW500(
                          CColor.black,
                          (kIsWeb) ? FontSize.size_3 : FontSize.size_10,
                        ),
                      ),
                    ),
                    // const Icon(Icons.arrow_drop_down_rounded)
                  ],
                )),*/
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
                  vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)  :Sizes.height_1_5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular((kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.9, constraints) :15),
                color: CColor.greyF8,
                border: Border.all(color: CColor.primaryColor, width: 0.7),
              ),
              child: DropdownButtonFormField<dynamic>(
                focusColor: Colors.white,
                decoration: const InputDecoration.collapsed(hintText: ''),
                // value: logic.selectedVerificationStatus,
                hint: Text(logic.selectedVerificationStatusHint,style: AppFontStyle.styleW500(
                    CColor.black,(kIsWeb)?AppFontStyle.sizesFontManageWeb(1.0, constraints): FontSize.size_10),),
                //elevation: 5,
                style: const TextStyle(color: Colors.white),
                iconEnabledColor: Colors.black,
                items: Utils.verificationStatusList
                    .map<DropdownMenuItem>((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(
                      value,
                      style: AppFontStyle.styleW500(
                          CColor.black,(kIsWeb)?AppFontStyle.sizesFontManageWeb(1.0, constraints): FontSize.size_10),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  logic.onChangeVerificationStatus(value!);
                  Debug.printLog("achievementStatusList value...$value");
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  _widgetDateEditText(BuildContext context, ConditionController logic,BoxConstraints constraints) {
    return Row(
      children: [
        _widgetOnsetDate(logic,context,constraints),
        _widgetAbatementDate(logic, context,constraints),
      ],
    );
  }

  Widget _widgetOnsetDate(ConditionController logic,BuildContext context,BoxConstraints constraints) {
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
                    text: "Onset Date",
                    style: AppFontStyle.styleW700(CColor.black,(kIsWeb)?  AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
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
                                "Specify the date when the condition was first diagnosed or noticed.")),
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
              showDatePickerDialog(logic, context,true);
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
                      controller: logic.onSetDateController,
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

  Widget _widgetAbatementDate(ConditionController logic, BuildContext context,BoxConstraints constraints) {
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
                left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.9, constraints)  :Sizes.width_3),
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    text: "Resolved Date",
                    style: AppFontStyle.styleW700(CColor.black,(kIsWeb)? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
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
                                "If applicable, enter the date when the condition was resolved or no longer considered active")),
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
              showDatePickerDialog(logic, context,false);
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
                      controller: logic.abatementController,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.text,
                      style: AppFontStyle.styleW500(CColor.black, (kIsWeb)? AppFontStyle.sizesFontManageWeb(1.0, constraints) :FontSize.size_10),
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
      child: GetBuilder<ConditionController>(builder: (logic) {
        return Container(
          margin:
          EdgeInsets.only(
              top: (kIsWeb)
                  ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                  : Sizes.height_3,
              right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints):  Sizes.width_2,
              left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.0, constraints)  :Sizes.width_2),

          width: double.infinity,
          child: TextButton(
            onPressed: () {
              // logic.insertUpdateData();
              logic.checkValidationForToken();
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
                style: AppFontStyle.styleW400(CColor.white, (kIsWeb)? AppFontStyle.sizesFontManageWeb(1.3, constraints) :FontSize.size_12),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buttonCancel(BuildContext context,BoxConstraints constraints) {
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
              style: AppFontStyle.styleW400(CColor.black,(kIsWeb)?AppFontStyle.sizesFontManageWeb(1.3, constraints): FontSize.size_12),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showDatePickerDialog(ConditionController logic,
      BuildContext context,bool isOnset) async {
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
              padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                  color: CColor.white),
              child: SfDateRangePicker(
                onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                  if(isOnset){
                    logic.onSelectionOnsetChangedDatePicker(
                        dateRangePickerSelectionChangedArgs);
                  }else{
                    logic.onSelectionAbatementChangedDatePicker(
                        dateRangePickerSelectionChangedArgs);
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

}
