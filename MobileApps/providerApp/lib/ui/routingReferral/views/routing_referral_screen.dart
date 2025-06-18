import 'package:banny_table/ui/goalForm/datamodel/notesData.dart';
import 'package:banny_table/ui/routingReferral/controllers/routing_referral_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../utils/constant.dart';
import '../../../utils/utils.dart';

class RoutingReferralScreen extends StatelessWidget {
  const RoutingReferralScreen({Key? key}) : super(key: key);

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
          title: const Text("Routing Referral"),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: GetBuilder<RoutingReferralController>(builder: (logic) {
              return Column(
                children: [
                  (logic.arg[1] != null) ?
                  Column(
                    children: [
                      _widgetStatusDropDown(context, logic),
                      _widgetEnterStatusReason(logic),
                    ],
                  ) : Container(),
                  /*_widgetEnterBusinessStatus(logic),*/
                  _widgetPriorityDropDown(context, logic),
                  // _widgetOwnerDropDown(context, logic),
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
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  _widgetStatusDropDown(BuildContext context, RoutingReferralController logic) {
    return GetBuilder<RoutingReferralController>(builder: (logic) {
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
                  left: (kIsWeb) ?Sizes.width_0_3: Sizes.width_2),
              child: Text(
                "Status",
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
                // value: Utils.routingReferralStatus[0],
                value: logic.selectedStatusReason,
                //elevation: 5,
                style: const TextStyle(color: Colors.white),
                iconEnabledColor: Colors.black,
                items: Utils.routingReferralStatus
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
                  logic.getSelectedStatus(value);
                  Debug.printLog("lifecycle value...$value");
                },
              ),
            ),
          ],
        ),
      );
    });
  }


  Widget _widgetEnterStatusReason(RoutingReferralController logic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_3, right: Sizes.width_3, left:(kIsWeb) ?Sizes.width_3: Sizes.width_4),
          child: Text(
            "status reason",
            style: AppFontStyle.styleW700(CColor.black,(kIsWeb)?FontSize.size_3: FontSize.size_10),
          ),
        ),
        Container(
          height: Sizes.height_6,
          margin: EdgeInsets.only(
              top: Sizes.height_1, right: Sizes.width_3, left: Sizes.width_3),
          decoration: BoxDecoration(
            color: CColor.transparent,

            border:Border.all(
              color: CColor.primaryColor, width: 0.7,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: TextFormField(
              controller: logic.statusReasonControllers,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.start,
              focusNode: logic.statusReasonFocus,
              textInputAction: TextInputAction.done,
              style: AppFontStyle.styleW500(CColor.black,(kIsWeb)?FontSize.size_3: FontSize.size_10),
              cursorColor: CColor.black,
              decoration: InputDecoration(
                hintText: logic.selectedStatusReason,
                filled: true,
                // contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: Sizes.width_5),
                // border:InputBorder.none,
                border: OutlineInputBorder(
                  borderSide:
                  const BorderSide(color: CColor.transparent, width: 0.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                  const BorderSide(color: CColor.transparent, width: 0.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide:
                  const BorderSide(color: CColor.transparent, width: 0.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                  const BorderSide(color: CColor.transparent, width: 0.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
          /* KeyboardActions(
            autoScroll: false,
            config: Utils.buildKeyboardActionsConfig(logic.statusReasonFocus),
            child: TextFormField(
              controller: logic.statusReasonControllers,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.start,
              focusNode: logic.statusReasonFocus,
              textInputAction: TextInputAction.done,
              style: AppFontStyle.styleW500(CColor.black,(kIsWeb)?FontSize.size_3: FontSize.size_10),
              cursorColor: CColor.black,
              decoration: InputDecoration(
                hintText: logic.selectedStatusReason,
                filled: true,
                // contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: Sizes.width_5),
                // border:InputBorder.none,
                border: OutlineInputBorder(
                  borderSide:
                  const BorderSide(color: CColor.transparent, width: 0.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                  const BorderSide(color: CColor.transparent, width: 0.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide:
                  const BorderSide(color: CColor.transparent, width: 0.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                  const BorderSide(color: CColor.transparent, width: 0.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
          ),*/
        ),
      ],
    );
  }

/*  Widget _widgetEnterBusinessStatus(RoutingReferralController logic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_3, right: Sizes.width_3, left: (kIsWeb) ?Sizes.width_3: Sizes.width_4),
          child: Text(
            "Business Status",
            style: AppFontStyle.styleW700(CColor.black,(kIsWeb)?FontSize.size_3: FontSize.size_10),
          ),
        ),
        Container(
          height: Sizes.height_6,
          margin: EdgeInsets.only(
              top: Sizes.height_1, right: Sizes.width_3, left: Sizes.width_3),
          decoration: BoxDecoration(
            color: CColor.transparent,

            border:Border.all(
              color: CColor.primaryColor, width: 0.7,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: KeyboardActions(
            autoScroll: false,
            config: Utils.buildKeyboardActionsConfig(logic.businessStatusFocus),
            child: TextFormField(
              controller: logic.businessStatusControllers,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.start,
              focusNode: logic.businessStatusFocus,
              textInputAction: TextInputAction.done,
              style: AppFontStyle.styleW500(CColor.black,(kIsWeb)?FontSize.size_3: FontSize.size_10),
              cursorColor: CColor.black,
              decoration: InputDecoration(
                hintText: "",
                filled: true,
                // contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: Sizes.width_5),
                // border:InputBorder.none,
                border: OutlineInputBorder(
                  borderSide:
                  const BorderSide(color: CColor.transparent, width: 0.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                  const BorderSide(color: CColor.transparent, width: 0.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide:
                  const BorderSide(color: CColor.transparent, width: 0.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                  const BorderSide(color: CColor.transparent, width: 0.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }*/

  _widgetPriorityDropDown(BuildContext context, RoutingReferralController logic) {
    return GetBuilder<RoutingReferralController>(builder: (logic) {
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
                  left:(kIsWeb) ?Sizes.width_0_3: Sizes.width_2),
              child: Text(
                "Priority",
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
                  logic.onChangePriority(value!);
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


  /*_widgetOwnerDropDown(BuildContext context, RoutingReferralController logic) {
    return GetBuilder<RoutingReferralController>(builder: (logic) {
      return logic.selectedOwner.isNotEmpty ? Container(
        margin: EdgeInsets.symmetric(horizontal: Sizes.width_3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                  bottom: Sizes.height_1,
                  top: Sizes.height_3,
                  left:(kIsWeb) ?Sizes.width_0_3: Sizes.width_2),
              child: Text(
                "Owner",
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
                value: logic.selectedOwner,
                //elevation: 5,
                isExpanded: true,
                style: const TextStyle(color: Colors.white),
                iconEnabledColor: Colors.black,
                onChanged: (value) {
                  // logic.onChangeLifeCycleStatus(value!);
                  logic.getSelectedOwner(value);
                  Debug.printLog(" value...$value");
                },
                items: Utils.performerList.map<DropdownMenuItem<String>>(( value) {
                  return DropdownMenuItem(
                    value: value,

                    child: Text(
                      value,
                      style: AppFontStyle.styleW500(CColor.black,
                          (kIsWeb) ? FontSize.size_3 : FontSize.size_10),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ) : Container();
    });
  }*/

/*  Widget _widgetNotesEditText(RoutingReferralController logic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_3, right: Sizes.width_3, left: (kIsWeb) ?Sizes.width_3:Sizes.width_4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Notes",
                  style: AppFontStyle.styleW700(CColor.black,
                      (kIsWeb) ? FontSize.size_3 : FontSize.size_10),
                ),
              ),
              InkWell(
                onTap: () {
                  logic.addNotesData();
                },
                child: Container(
                    margin: EdgeInsets.only(
                      right: Sizes.width_2,
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      size: (kIsWeb) ? Sizes.width_2 : Sizes.width_7,
                    )),
              ),
            ],
          ),
        ),
        ListView.builder(
          itemBuilder: (context, index) {
            return _itemNotes(index, logic.notesList[index]);
          },
          shrinkWrap: true,
          itemCount: logic.notesList.length,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }

  _itemNotes(int index, NotesData notesData) {
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


  Widget _widgetNotesEditText(RoutingReferralController logic,BuildContext context,) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_3, right: Sizes.width_3, left: Sizes.width_4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Notes",
                  style: AppFontStyle.styleW700(CColor.black, (kIsWeb)?FontSize.size_3:FontSize.size_10),
                ),
              ),
              (!logic.editedRoutingReferralData!.readonly )? InkWell(
                onTap: () {
                  _showDialogForAddNote(context,logic,false,0);
                  // logic.addNotesData();
                },
                child: Container(
                    margin: EdgeInsets.only(
                      right: Sizes.width_2,),
                    child: Icon(Icons.add_rounded,size: (kIsWeb) ? Sizes.width_2:Sizes.width_7,)),
              ): Container()
            ],
          ),
        ),
        ListView.builder(itemBuilder: (context, index) {
          return _itemNotes(index,logic.notesList[index],logic,context);
        },
          shrinkWrap: true,
          itemCount:logic.notesList.length,
          physics: const NeverScrollableScrollPhysics(),
        ),

      ],
    );
  }

  _showDialogForAddNote(BuildContext context, RoutingReferralController logic,bool isEditNote,index){
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

  _itemNotes(int index, NotesData notesData,RoutingReferralController logic,BuildContext context){
    return logic.notesList.isNotEmpty ?
    InkWell(
      onTap: (){
        logic.editNoteDataController("${notesData.notes}");
        _showDialogForAddNote(context,logic,true,index);
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
                          Text(
                            "${notesData.notes}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppFontStyle.styleW700(
                              CColor.black,
                              (kIsWeb)?FontSize.size_3:FontSize.size_10,
                            ),
                          ),

                        ],
                      ),
                    )),
                Column(
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
  }


  Widget _buttonAddUpdate(BuildContext context) {
    return Expanded(
      child: GetBuilder<RoutingReferralController>(builder: (logic) {
        return Container(
          margin: EdgeInsets.only(
              top: Sizes.height_3, left: Sizes.width_2, right: Sizes.width_2),
          width: double.infinity,
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
                  borderRadius: BorderRadius.circular(15.0),
                  side:
                  const BorderSide(color: CColor.primaryColor, width: 0.7),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all((kIsWeb) ? 10 : 5),
              child: Text(
                (logic.isEdited) ? "Edit" : "Add",
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


}
