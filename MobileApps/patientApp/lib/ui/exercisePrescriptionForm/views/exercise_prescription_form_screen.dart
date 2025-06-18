import 'package:banny_table/ui/goalForm/datamodel/notesData.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../db_helper/box/notes_data.dart';
import '../../../utils/constant.dart';
import '../../../utils/debug.dart';
import '../../../utils/utils.dart';
import '../controllers/exercise_prescription_form_controller.dart';

class ExercisePrescriptionScreen extends StatelessWidget {
  const ExercisePrescriptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColor.white,
      appBar: AppBar(
        backgroundColor: CColor.primaryColor,
        title: const Text("Exercise Prescription form",
          style: TextStyle(
            color: CColor.white,
            // fontSize: 20,
            fontFamily: Constant.fontFamilyPoppins,
          ),),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context,BoxConstraints constraints) {
          return SafeArea(
            child: SingleChildScrollView(
              child: GetBuilder<ExercisePrescriptionController>(builder: (logic) {
                return Column(
                  children: [
                    _widgetInstructions(logic,constraints),
                    // _widgetOccurrence(context, logic),
                    _widgetDateEditText(context, logic,constraints),
                    if(logic.selectedStatusFix != Constant.statusDraft)_widgetStatusDropDown(context, logic,constraints),
                    if(logic.notesList.isNotEmpty)_widgetNotesEditText(logic,context,constraints),
                  ],
                );
              }),
            ),
          );
        }
      ),
    );
  }

  Widget _widgetInstructions(ExercisePrescriptionController logic,BoxConstraints constraints) {
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
                              "Detailed instructions for the exercise prescription, including specific activities, duration, and intensity.")),
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
                top: Sizes.height_1, right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) :Sizes.width_3, left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3),
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
            readOnly: true,
            controller: logic.textReasonCode,
            textAlign: TextAlign.start,
              style: AppFontStyle.styleW500(CColor.black,(kIsWeb)?AppFontStyle.sizesFontManageWeb(1.0, constraints): FontSize.size_10),
            decoration: InputDecoration(
              hintText: logic.textReasonCodeHint,
              filled: true,
              fillColor: Colors.transparent,
              border:InputBorder.none,
            ),
          )
        ),
      ],
    );
  }

  _widgetStatusDropDown(BuildContext context, ExercisePrescriptionController logic,BoxConstraints constraints) {
    return GetBuilder<ExercisePrescriptionController>(builder: (logic) {
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
                      (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) :  FontSize.size_10,
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
                                  "The current status of the exercise prescription")),
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
                color: CColor.greyF8,
                border:(logic.isEdited)?null:Border.all(
                  color: CColor.primaryColor, width: 0.7,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: DropdownButtonFormField<String>(
                focusColor: Colors.white,
                decoration: const InputDecoration.collapsed(hintText: ''),
                value: logic.selectedStatus,
                iconDisabledColor: CColor.transparent,
                dropdownColor:CColor.transparent,
                style: const TextStyle(color: Colors.white),
                iconEnabledColor: Colors.black,
                items: Utils.statusList
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: AppFontStyle.styleW500(CColor.black,
                          (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(1.0, constraints) :  FontSize.size_10),
                    ),
                  );
                }).toList(),
                onChanged: null,
              ),
            ),
          ],
        ),
      );
    });
  }

  _widgetOccurrence(BuildContext context, ExercisePrescriptionController logic) {
    return GetBuilder<ExercisePrescriptionController>(builder: (logic) {
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
                    "Complete within Timeframe",
                    style: AppFontStyle.styleW700(
                      CColor.black,
                      (kIsWeb) ? FontSize.size_3 : FontSize.size_10,
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
                                  "Specify the start and end dates for completing the exercise prescription.")),
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
                  vertical: Sizes.height_1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: CColor.greyF8,
                border: Border.all(color: CColor.primaryColor, width: 0.7),
              ),
              child: Container(
                margin: EdgeInsets.only(top: Sizes.height_0_5,bottom: Sizes.height_0_5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
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
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: Sizes.width_5,right: Sizes.width_5),
                      child: Text(
                        "&",
                        style: AppFontStyle.styleW400(
                          CColor.black,
                          (kIsWeb) ? FontSize.size_3 : FontSize.size_10,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(left: Sizes.width_3),
                          child: Text(
                            logic.periodEndDateStr.text,
                            overflow: TextOverflow.ellipsis,
                            style: AppFontStyle.styleW400(
                              CColor.black,
                              (kIsWeb) ? FontSize.size_3 : FontSize.size_10,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.date_range_rounded,
                            size: Sizes.height_3,
                          ),
                        ),
                      ],
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

  _widgetDateEditText(BuildContext context, ExercisePrescriptionController logic,BoxConstraints constraints) {
    return Row(
      children: [
        _widgetOnsetDate(logic, context,constraints),
        if(logic.periodEndDateStr.text != "")
          _widgetAbatementDate(logic, context,constraints),
      ],
    );
  }

  Widget _widgetOnsetDate(ExercisePrescriptionController logic, BuildContext context,BoxConstraints constraints) {
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
                                "The start and end dates for completing the exercise prescription")),
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

  Widget _widgetAbatementDate(ExercisePrescriptionController logic, BuildContext context,BoxConstraints constraints) {
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
                                "The start and end dates for completing the exercise prescription")),
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


  Widget _widgetNotesEditText(ExercisePrescriptionController logic,BuildContext context,BoxConstraints constraints) {
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
          reverse: true,
          itemCount:logic.notesList.length,
          physics: const NeverScrollableScrollPhysics(),
        ),

      ],
    );
  }

  _itemNotes(int index, NoteTableData notesData,ExercisePrescriptionController logic,BuildContext context,BoxConstraints constraints){
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
                          if(notesData.author != null && notesData.author != ""&& notesData.author !="null")
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

}
