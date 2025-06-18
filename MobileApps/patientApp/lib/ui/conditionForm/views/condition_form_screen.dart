import 'package:banny_table/ui/conditionForm/controllers/condition_form_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ConditionFormScreen extends StatelessWidget {
  const ConditionFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColor.white,
      appBar: AppBar(
        backgroundColor: CColor.primaryColor,
        title: const Text("Condition",
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
              child: GetBuilder<ConditionController>(builder: (logic) {
                return Column(
                  children: [
                    _widgetCondition(context, logic,constraints),
                    _widgetEnterText(logic,constraints),
                    _widgetVerificationStatusDropDown(context, logic,constraints),
                    _widgetDateEditText(context, logic,constraints),
                  ],
                );
              }),
            );
          }
        ),
      ),
    );
  }

  _widgetCondition(
      BuildContext context, ConditionController logic,BoxConstraints constraints) {
    return GetBuilder<ConditionController>(builder: (logic) {
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
                    "Condition",
                    style: AppFontStyle.styleW700(
                      CColor.black,
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
                                  "The medical condition recorded. This can include diagnoses like hypertension or diabetes.")),
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
                  borderRadius: BorderRadius.circular((kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.9, constraints) :15),
                  color: CColor.greyF8,
                  border: (logic.isEdited)?null:Border.all(color: CColor.primaryColor, width: 0.7),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        logic.selectedConditionStatus,
                        style: AppFontStyle.styleW500(
                        CColor.black,
                            (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.0, constraints): FontSize.size_10),
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

  _widgetVerificationStatusDropDown(
      BuildContext context, ConditionController logic,BoxConstraints constraints) {
    return GetBuilder<ConditionController>(builder: (logic) {
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
                    "Verification",
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
                                  "The status of the condition verification.")),
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
                  borderRadius: BorderRadius.circular((kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.9, constraints) :15),
                  color: CColor.greyF8,
                  border: (logic.isEdited)?null:Border.all(color: CColor.primaryColor, width: 0.7),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        logic.selectedVerificationStatus,
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
      );
    });
  }

  _widgetDateEditText(BuildContext context, ConditionController logic,BoxConstraints constraints) {
    return Row(
      children: [
        if(logic.onSetDateController.text.isNotEmpty)
        _widgetOnsetDate(logic, context,constraints),
        if(logic.abatementController.text.isNotEmpty)
        _widgetAbatementDate(logic, context,constraints),
      ],
    );
  }

  Widget _widgetOnsetDate(ConditionController logic, BuildContext context,BoxConstraints constraints) {
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
                                "The date when the condition was first diagnosed or noticed.")),
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
              border: (logic.isEdited)?null:Border.all(
                color: CColor.primaryColor,
                width: 0.7,
              ),
              borderRadius: BorderRadius.circular((kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.8, constraints) :15),
              // color: CColor.greyF8,
              // borderRadius: BorderRadius.circular((kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.9, constraints) :15),
            ),
            child: TextFormField(
              enabled: false,
              readOnly: true,
              controller: logic.onSetDateController,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
              style: AppFontStyle.styleW500(
                  CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_10),
              cursorColor: CColor.black,
              decoration: InputDecoration(
                hintText: "Select on set date".tr,
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
                // right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.6, constraints):  Sizes.width_3,
                left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(2.3, constraints)  :Sizes.width_3
            ),
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    text: "Resolved Date",
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
                                "If applicable, the date when the condition was resolved or no longer considered active.")),
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
              border: (logic.isEdited)?null:Border.all(
                  color: CColor.primaryColor,
                  width: 0.7
              ),
              borderRadius: BorderRadius.circular((kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.8, constraints) :15),
              color: CColor.greyF8,
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
              controller: logic.abatementController,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
              style: AppFontStyle.styleW500(CColor.black, (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.0, constraints):FontSize.size_10),
              cursorColor: CColor.black,
              decoration: InputDecoration(
                hintText: "Select your abatement date".tr,
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

  Future<void> showDatePickerDialog(
      ConditionController logic, BuildContext context, bool isOnset) async {
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
                  if (isOnset) {
                    logic.onSelectionOnsetChangedDatePicker(
                        dateRangePickerSelectionChangedArgs);
                  } else {
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
                             "Additional information or specifics about the condition to help understand your health status")),
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
                top: Sizes.height_1, right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) :Sizes.width_3, left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3),
            decoration: BoxDecoration(
              color: CColor.transparent,
              border:(logic.isEdited)?null:Border.all(
                color: CColor.primaryColor, width: 0.7,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: TextFormField(
              maxLines: 3,
              enabled: false,
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


}
