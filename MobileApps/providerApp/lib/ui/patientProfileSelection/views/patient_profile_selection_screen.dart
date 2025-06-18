import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/patient_profile_selection_controller.dart';

class PatientProfileSelectionScreen extends StatelessWidget {
  const PatientProfileSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          useMaterial3: false
      ),
      child: GetBuilder<PatientProfileSelectionController>(builder: (logic) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: CColor.primaryColor,
            title: const Text(Constant.headerSelectPatient),
          ),
          backgroundColor: CColor.white,
          body: SafeArea(
            child: _widgetFirstPageDetails(context, logic)
          ),
        );
      }),
    );
  }

  _widgetFirstPageDetails(BuildContext context,
      PatientProfileSelectionController logic) {
    return Container(
      margin: EdgeInsets.only(
          top: Sizes.height_1,
          left: Sizes.width_3,
          right: Sizes.width_3
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _widgetSearchIDText(logic)),
              Expanded(child: _widgetSearchNameText(logic),),
            ],
          ),
          _widgetPatientIds(logic),
          _widgetButtonDetails(context)
        ],
      ),
    );
  }

  Widget _widgetSearchIDText(PatientProfileSelectionController logic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // height: Sizes.height_6,
          margin: EdgeInsets.only(
              top: Sizes.height_2, right: Sizes.width_1_5, left: Sizes.width_3),
          decoration: BoxDecoration(
            color: CColor.transparent,

            border: Border.all(
              color: CColor.primaryColor, width: 0.7,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: TextFormField(
            controller: logic.searchIdControllers,
            // keyboardType: TextInputType.text,
            keyboardType: Utils.getInputTypeKeyboard(),
            textAlign: TextAlign.start,
            focusNode: logic.searchIdFocus,
            textInputAction: TextInputAction.done,
            style: AppFontStyle.styleW500(
                CColor.black, (kIsWeb) ? FontSize.size_3 : FontSize.size_10),
            cursorColor: CColor.black,
            decoration: const InputDecoration(
              hintText: "Search Id",
              filled: true,
              border: InputBorder.none,
            ),
            onChanged: (value) {
              logic.getPatientList();
            },
          ),
          /*KeyboardActions(
            autoScroll: false,
            config: Utils.buildKeyboardActionsConfig(logic.searchIdFocus),
            child: TextFormField(
              controller: logic.searchIdControllers,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.start,
              focusNode: logic.searchIdFocus,
              textInputAction: TextInputAction.done,
              style: AppFontStyle.styleW500(CColor.black,(kIsWeb)?FontSize.size_3: FontSize.size_10),
              cursorColor: CColor.black,
              decoration: const InputDecoration(
                hintText: "Search Id",
                filled: true,
                border:InputBorder.none,
              ),
              onChanged: (value){
                logic.getPatientList();
              },
            ),
          ),*/
        ),
      ],
    );
  }

  Widget _widgetSearchNameText(PatientProfileSelectionController logic) {
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
              logic.getPatientList();
            },
          ),
        ),
      ],
    );
  }

  _widgetPatientIds(PatientProfileSelectionController logic) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(
            left: Sizes.width_1_3,
            right: Sizes.width_1_2,
            top: Sizes.height_1_2
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: Sizes.width_0_5, vertical: 7),
          decoration: const BoxDecoration(
              color: CColor.white
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              (logic.patientProfileList.isNotEmpty)?
              ListView.builder(
                itemBuilder: (context, index) {
                  return _itemUser(logic, index, context);
                },
                itemCount: logic.patientProfileList.length,
                padding: const EdgeInsets.all(0),
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
              ): (!logic.isShowProgress) ?
              Container(
            alignment: Alignment.center,
            child: Text(
              "No user found",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: CColor.black,
                  fontSize: 15.sp),
            ),
          ):Container(),
              Container(
                alignment: Alignment.center,
                child: (logic.isShowProgress) ?
                const CircularProgressIndicator(
                  // backgroundColor: CColor.primaryColor,
                  valueColor: AlwaysStoppedAnimation(CColor.primaryColor),
                  // strokeWidth: 10,
                ) : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _itemUser(PatientProfileSelectionController logic, int index, BuildContext context) {
    return GestureDetector(
      onTap: () {
        logic.saveDetail(index);
      },
      child: Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CColor.white,
          border: Border.all(
              color: (logic.patientProfileList[index].patientId ==
                  Utils.getPatientId() ||
                  logic.patientProfileList[index].patientId ==
                      Utils.getProviderId()) /*||
                      logic.patientProfileList[index].patientId ==
                          Utils.getServiceProviderId())*/
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
                      logic.patientProfileList[index].patientId.isNotEmpty ?
                      RichText(
                        text: TextSpan(
                          text: "Id:- ",
                          style: AppFontStyle.styleW700(
                              CColor.black, (kIsWeb) ? 5.sp : 13.sp),
                          children: [

                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: logic.patientProfileList[index].patientId
                                  .toString(),
                              style: AppFontStyle.styleW600(
                                  CColor.gray, (kIsWeb) ? 4.sp : 12.sp
                              ),
                            ),
                          ],
                        ),
                      ) : Container(),
                      logic.patientProfileList[index].fName.isNotEmpty ?
                      RichText(
                        text: TextSpan(
                          text: "First Name:- ",
                          style: AppFontStyle.styleW700(
                              CColor.black, (kIsWeb) ? 5.sp : 13.sp),
                          children: [

                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: logic.patientProfileList[index].fName
                                  .toString(),
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

  _widgetButtonDetails(BuildContext context) {
    return GetBuilder<PatientProfileSelectionController>(builder: (logic) {
      if ((kIsWeb)) {
        return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(
              left:8.h,
              right:8.h,
              // top: 110
            ),
            padding: EdgeInsets.only(
                top: 4.h, bottom: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      logic.moveToScreen();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: CColor.primaryColor,
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                              color: CColor.white
                          )
                      ),
                      child: Text(
                        "Next",
                        style: TextStyle(
                            color: CColor.white,
                            fontSize:Utils.sizesFontManage(context ,3.5)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
      } else {
        return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 8.w,
              right: 8.w,
            ),
            padding: EdgeInsets.only(top: 4.h, bottom: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      logic.moveToScreen();
                    },
                    child: Container(
                      padding:  EdgeInsets.all((kIsWeb)?5:10).w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: CColor.primaryColor,
                          borderRadius: BorderRadius.circular(13).w,
                          border: Border.all(color: CColor.white)),
                      child: Text(
                        "Next",
                        style: TextStyle(color: CColor.white,
                            fontSize: Utils.sizesFontManage(context ,7)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
      }
    });
  }

}
