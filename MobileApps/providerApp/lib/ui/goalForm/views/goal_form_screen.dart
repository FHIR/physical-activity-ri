
import 'package:banny_table/ui/goalForm/controllers/goal_form_controller.dart';
import 'package:banny_table/ui/goalForm/datamodel/goalTypeData.dart';
import 'package:banny_table/ui/goalForm/datamodel/notesData.dart';
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
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../utils/utils.dart';

class GoalFormScreen extends StatelessWidget {
  const GoalFormScreen({Key? key}) : super(key: key);

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
          title: const Text("Goal"),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context ,BoxConstraints constraints) {
              return SingleChildScrollView(
                child: GetBuilder<GoalFormController>(builder: (logic) {
                  return Column(
                    children: [
                      _widgetMultipleGoalsDropDown(context,logic,constraints),
                      _widgetGoalAndDueDateEditText(context,logic,constraints),
                      // _widgetDescEditText(logic),
                      if(logic.isEdited && logic.selectedStatusFix.toLowerCase() != Constant.lifeCycleProposed.toLowerCase() )
                      _widgetLifecycleStatusDropDown(context,logic,constraints),
                      if(logic.isEdited && logic.selectedStatusFix.toLowerCase() != Constant.lifeCycleProposed.toLowerCase())
                      _widgetAchievementStatusDropDown(context,logic,constraints),
                      _widgetNotesEditText(logic,context,constraints),
                      Container(
                        margin: EdgeInsets.only(top: Sizes.height_2,bottom: Sizes.height_1),
                        child: Row(
                          children: [
                            _buttonCancel(context,constraints,logic),
                            _buttonAddUpdate(context,constraints),
                          ],
                        ),
                      ),
                      if(logic.selectedStatusFix.toLowerCase() == Constant.lifeCycleProposed.toLowerCase()) _buttonSaveAsDraft(context,constraints),
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

  _widgetMultipleGoalsDropDown(BuildContext context, GoalFormController logic,BoxConstraints constraints) {
    return GetBuilder<GoalFormController>(builder: (logic) {
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
                        text: "Goal Type ",
                        style: AppFontStyle.styleW700(CColor.black,(kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),

                        children: [
                          ///This Is use For Goal Type is mandatory
                          TextSpan(
                            text: ' *',
                            style: TextStyle(
                                color: CColor.red,
                                fontSize:(kIsWeb) ?  AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10
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
                                  "Select the type of physical activity goal being set")),
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
                borderRadius: BorderRadius.circular((kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.9, constraints) :15),
                color: CColor.greyF8,
                border: Border.all(
                    color: CColor.primaryColor,
                    width: 0.7
                ),
              ),
              child: DropdownButtonFormField(
                focusColor: Colors.white,

                isExpanded: true,
                decoration: const InputDecoration.collapsed(hintText: ''),
                // value: logic.selectedMultipleGoalStatus,
                // value: logic.selectedGoalMeasure,
                //elevation: 5,
                padding: EdgeInsets.zero,
                hint: Text(logic.selectedGoalMeasureHint,style: AppFontStyle.styleW500(
                    CColor.black,(kIsWeb)?AppFontStyle.sizesFontManageWeb(1.0, constraints): FontSize.size_10),),
                style: const TextStyle(color: Colors.white),
                iconEnabledColor: Colors.black,
                items: Utils.multipleGoalsList
                    .map<DropdownMenuItem<GoalMeasure>>(( value) {
                  return DropdownMenuItem<GoalMeasure>(
                    value:value,
                    child: Text(
                      value.goalValue,
                      overflow: TextOverflow.ellipsis,
                      style: AppFontStyle.styleW500(
                          CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_10),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  logic.onChangeMultipleGoalStatus(value);
                  Debug.printLog("lifecycle value...$value");
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  _widgetLifecycleStatusDropDown(BuildContext context, GoalFormController logic,BoxConstraints constraints) {
    return GetBuilder<GoalFormController>(builder: (logic) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_3),
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
                                  "Choose the current status of the goal. Options include 'Active' for ongoing goals, 'Completed' for achieved goals, and 'Cancelled' for goals that are no longer pursued.")),
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
                  vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.5, constraints)  :Sizes.height_1_5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular((kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.8, constraints) :15),
                color: CColor.greyF8,
                border: Border.all(
                    color: CColor.primaryColor,
                    width: 0.7
                ),
              ),
              child: DropdownButtonFormField<String>(
                focusColor: Colors.white,
                decoration: const InputDecoration.collapsed(hintText: ''),
                // value: logic.selectedLifeCycleStatus,
                //elevation: 5,
                hint: Text(logic.selectedLifeCycleStatusHint,style: AppFontStyle.styleW500(
                    CColor.black,(kIsWeb)?AppFontStyle.sizesFontManageWeb(1.0, constraints): FontSize.size_10),),
                style: const TextStyle(color: Colors.white),
                iconEnabledColor: Colors.black,
                items: Utils.lifeCycleStatusList
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: AppFontStyle.styleW500(
                          CColor.black, (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.0, constraints):FontSize.size_10),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  logic.onChangeLifeCycleStatus(value!);
                  Debug.printLog("lifecycle value...$value");
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  _widgetAchievementStatusDropDown(BuildContext context, GoalFormController logic,BoxConstraints constraints) {
    return GetBuilder<GoalFormController>(builder: (logic) {
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
                      text: "Achievement",
                      style: AppFontStyle.styleW700(CColor.black,(kIsWeb)?AppFontStyle.sizesFontManageWeb(1.3, constraints): FontSize.size_10),
                      children: [
                        ///This Is use For Goal Type is mandatory
                        // TextSpan(
                        //   text: ' *',
                        //   style: TextStyle(
                        //       color: CColor.red,
                        //       fontSize: (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.3, constraints): FontSize.size_10
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
                                  "Select the current progress status of the goal. Options include 'Improving,' No-change,' or 'Worsening' based on performance and progress.")),
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
                  vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.5, constraints)  :Sizes.height_1_5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular((kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.8, constraints) :15),
                color: CColor.greyF8,
                border: Border.all(color: CColor.primaryColor, width: 0.7),
              ),
              child: DropdownButtonFormField<String>(
                focusColor: Colors.white,
                decoration: const InputDecoration.collapsed(hintText: ''),
                // value: logic.selectedAchievementStatus,
                //elevation: 5,
                hint: Text(logic.selectedAchievementStatusHint,style: AppFontStyle.styleW500(
                    CColor.black,(kIsWeb)?AppFontStyle.sizesFontManageWeb(1.0, constraints): FontSize.size_10),),
                style: const TextStyle(color: Colors.white),
                iconEnabledColor: Colors.black,
                items: Utils.achievementStatusList
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: AppFontStyle.styleW500(
                          CColor.black,(kIsWeb)?AppFontStyle.sizesFontManageWeb(1.0, constraints): FontSize.size_10),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  logic.onChangeAchievementStatus(value!);
                  Debug.printLog("achievementStatusList value...$value");
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _widgetNotesEditText(GoalFormController logic,BuildContext context,BoxConstraints constraints) {
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
                                    "Add any additional comments or details about the physical activity goal. This can include motivations, obstacles, or specific observations related to progress")),
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
                  showDialogForAddNewCode(context,logic,false,0,constraints);
                  // logic.addNotesData();
                },
                child: Container(
                    margin: EdgeInsets.only(
                      right: Sizes.width_2,),
                    child: Icon(Icons.add_rounded,size: (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.5, constraints):Sizes.width_7,)),
              )
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

  showDialogForAddNewCode(BuildContext context, GoalFormController logic,bool isEditNote,index,BoxConstraints constraints){
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



  _itemNotes(int index, NotesData notesData,GoalFormController logic,BuildContext context,BoxConstraints constraints){
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
              /*boxShadow: const [
                BoxShadow(
                  color: CColor.primaryColor,
                  // blurRadius: 1,
                  spreadRadius: 0.5,
                )
              ],*/
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
                /*Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: CColor.primaryColor30,
                  ),
                  child: Image.asset(
                    "assets/icons/ic_fitness.png",
                    height: Sizes.height_2,
                    width: Sizes.height_2,
                  ),
                ),*/
                Expanded (
                    child: Container(
                      margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.8, constraints): Sizes.width_2),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(notesData.author != "" && notesData.author != "null" && notesData.author != null)
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
                if(logic.notesList[index].isCreatedNote ?? false)Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        await logic.editNoteDataController("${notesData.notes}",true);
                        showDialogForAddNewCode(context,logic,true,index,constraints);
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
            child: Divider(
              color: CColor.black,
              height: 2,
            ),
          ),
        ],
      ),
    ) : Container();

    /*TextFormField(
        controller: notesData.controller,
        textAlign: TextAlign.start,
        keyboardType: TextInputType.text,
        style: AppFontStyle.styleW500(CColor.black, (kIsWeb)?FontSize.size_3:FontSize.size_10),
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
      ),*/
  }

  Widget _widgetDescEditText(GoalFormController logic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_3, right: Sizes.width_3, left: Sizes.width_4),
          child:/* Text(
            "Description",
            style: AppFontStyle.styleW700(CColor.black,(kIsWeb)?FontSize.size_3: FontSize.size_10),
          ),*/
          RichText(
            text: TextSpan(
              text: "Description ",
              style: AppFontStyle.styleW700(CColor.black,(kIsWeb)?FontSize.size_3: FontSize.size_10),
              children: [
                ///This Is use For Goal Type is mandatory
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
        ),
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_1, right: Sizes.width_3, left: Sizes.width_3),
          color: CColor.transparent,
          child: TextFormField(
            maxLines: 3,
            controller: logic.descController,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.text,
            style: AppFontStyle.styleW500(CColor.black, (kIsWeb)?FontSize.size_3:FontSize.size_10),
            cursorColor: CColor.black,
            decoration: InputDecoration(
              hintText: "Enter your description".tr,
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
        ),
      ],
    );
  }

  _widgetGoalAndDueDateEditText(BuildContext context, GoalFormController logic,BoxConstraints constraints) {
    return Row(
      children: [
        _widgetEnterGoal(logic,constraints),
        _widgetDueDate(logic, context,constraints),
      ],
    );
  }

  Widget _widgetEnterGoal(GoalFormController logic,BoxConstraints constraints) {
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
                    text: "Target",
                    style: AppFontStyle.styleW700(CColor.black, (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                            color: CColor.red,
                            fontSize:  (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10
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
                                "Specify the target value for the goal")),
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
                top: (kIsWeb)
                    ? AppFontStyle.sizesHeightManageWeb(0.5, constraints)
                    : Sizes.height_1,
                right:(kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints):  Sizes.width_3,
                left:(kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_3),
            decoration: BoxDecoration(
              color: CColor.transparent,

              border:Border.all(
                color: CColor.primaryColor, width: 0.7,
              ),
              borderRadius: BorderRadius.circular((kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.9, constraints) :15),
            ),
            child:  TextFormField(
                controller: logic.targetController,
                keyboardType: Utils.getInputTypeKeyboard(),
              textAlign: TextAlign.start,
                focusNode: logic.targetFocus,
                textInputAction: TextInputAction.done,
                style: AppFontStyle.styleW500(CColor.black,(kIsWeb)?AppFontStyle.sizesFontManageWeb(1.0, constraints): FontSize.size_10),
                cursorColor: CColor.black,
                decoration: InputDecoration(
                  hintText: logic.selectedMultipleGoalStatus,
                  filled: true,
                  border:InputBorder.none,
                ),
              ),

            /*KeyboardActions(
              autoScroll: false,
              config: Utils.buildKeyboardActionsConfig(logic.targetFocus),
              child: TextFormField(

                controller: logic.targetController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.start,
                focusNode: logic.targetFocus,
                textInputAction: TextInputAction.done,
                style: AppFontStyle.styleW500(CColor.black,(kIsWeb)?FontSize.size_3: FontSize.size_10),
                cursorColor: CColor.black,
                decoration: InputDecoration(
                  hintText: logic.selectedMultipleGoalStatus,

                  filled: true,
                  border:InputBorder.none,
                ),
              ),
            ),*/
          ),
        ],
      ),
    );
  }

  Widget _widgetDueDate(GoalFormController logic, BuildContext context,BoxConstraints constraints) {
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
                    text: "Due date",
                    style: AppFontStyle.styleW700(CColor.black,(kIsWeb)?AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
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
                                "Enter the date by which the physical activity goal is intended to be achieved.")),
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
              showDatePickerDialog(logic, context);
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
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
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      enabled: false,
                      readOnly: true,
                      controller: logic.dueDateController,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.text,
                      style: AppFontStyle.styleW500(CColor.black, (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.0, constraints):FontSize.size_10),
                      cursorColor: CColor.black,
                      decoration:  InputDecoration(
                        hintText: "YYYY-MM-DD",
                        hintStyle: AppFontStyle.styleW500(CColor.gray, (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.0, constraints):FontSize.size_10),
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
      child: GetBuilder<GoalFormController>(builder: (logic) {
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
            borderRadius:  BorderRadius.circular(15.0),
          ),
          padding: (logic.selectedLifeCycleStatusHint != Constant.lifeCycleProposed) ? (logic.isEdited) ? EdgeInsets.all((kIsWeb) ? 5 : 2):EdgeInsets.all(0) : EdgeInsets.all(0) ,
          child: TextButton(
            onPressed: () {
              logic.insertForSign();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(CColor.primaryColor),
              elevation: MaterialStateProperty.all(1),
              shadowColor: MaterialStateProperty.all(CColor.gray),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(
                      color: CColor.primaryColor, width: 0.7),
                ),
              ),
            ),
            child: Padding(
              padding: (logic.selectedLifeCycleStatusHint != Constant.lifeCycleProposed) ? (logic.isEdited) ?EdgeInsets.all((kIsWeb) ? 5 : 2) :EdgeInsets.all((kIsWeb) ? 10 : 5) :EdgeInsets.all((kIsWeb) ? 10 : 5),
              child: Text(
                // "Activate",
                (logic.selectedStatusFix.toLowerCase() == Constant.lifeCycleProposed.toLowerCase())? "Activate": (logic.isEdited)?"Save":"Activate",
                textAlign: TextAlign.center,
                style: AppFontStyle.styleW400(CColor.white, (kIsWeb)? AppFontStyle.sizesFontManageWeb(1.3, constraints) :FontSize.size_12),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buttonCancel(BuildContext context,BoxConstraints constraints,GoalFormController logic) {
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
            padding: (logic.selectedLifeCycleStatusHint != Constant.lifeCycleProposed && logic.isEdited) ?EdgeInsets.all((kIsWeb) ? 10 : 8) :const EdgeInsets.all((kIsWeb) ? 10 : 5),
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

  Future<void> showDatePickerDialog(GoalFormController logic,
      BuildContext context) async {
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
                  logic.onSelectionChangedDatePicker(
                      dateRangePickerSelectionChangedArgs);
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

  Widget _buttonSaveAsDraft(BuildContext context,BoxConstraints constraints) {
    return GetBuilder<GoalFormController>(builder: (logic) {
      return Container(
        margin:           EdgeInsets.only(
            bottom: (kIsWeb)
                ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                : Sizes.height_3,
            right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints):  Sizes.width_2,
            left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.0, constraints)  :Sizes.width_2),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
              color: (logic.selectedLifeCycleStatusHint != Constant.statusDraft && !logic.isEdited) ? CColor.transparent:CColor.primaryColor,
              width: (logic.selectedLifeCycleStatusHint != Constant.statusDraft && !logic.isEdited) ? 0:(kIsWeb) ? 1:2
          ),
          borderRadius: (logic.selectedLifeCycleStatusHint != Constant.statusDraft && !logic.isEdited) ? BorderRadius.circular(0.0):BorderRadius.circular(15.0),
        ),
        padding: (logic.selectedLifeCycleStatusHint != Constant.statusDraft && !logic.isEdited) ? EdgeInsets.all(0) : EdgeInsets.all((kIsWeb) ? 5 : 5),
        child: TextButton(
          onPressed: () {
              logic.insertSaveAsDraft();
              // logic.insertUpdateData();
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
            padding: logic.selectedLifeCycleStatusHint == Constant.statusDraft ?EdgeInsets.all((kIsWeb) ? 5 : 5) : EdgeInsets.all((kIsWeb) ? 10 : 3),
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


}
