import 'package:banny_table/ui/welcomeScreen/healthProvider/healthProvider/controllers/health_provider_controller.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/qrScanner/datamodel/serverModel.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/selectPrimaryServer/datamodel/serverModelJson.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../controllers/patient_list_controller.dart';


class PatientListScreen extends StatelessWidget {
  HealthProviderController? healthProviderController;

  PatientListScreen({ this.healthProviderController, Key? key})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GetBuilder<PatientListController>(builder: (logic) {
      return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: CColor.primaryColor,
            title: const Text("Select Patient Profile"),
            leading: IconButton(
              onPressed: () {
                if (logic.isNavigation || logic.isFromSetting) {
                  Get.back();
                } else {
                  // if(Preference.shared.getServerList(Preference.serverUrlList)!.toList().where((element) => element.isSelected).toList().length > 1) {
                  if(Preference.shared.getServerList(Preference.serverUrlAllListed)!.toList().where((element) => element.isSelected).toList().length > 1) {
                    healthProviderController!.pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  }else{
                    healthProviderController!.pageController.jumpToPage(1);
                  }
                }
                Debug.printLog("------back");
              },
              icon: Icon(Icons.arrow_back),
            ),
          ),
          backgroundColor: CColor.white,
          body: LayoutBuilder(
            builder: (BuildContext context,BoxConstraints constraints) {
              return SafeArea(
                child:  _widgetFirstPageDetails(context, logic,constraints),
              );
            }
          ),
        ),
      );
    });
  }


  _widgetFirstPageDetails(BuildContext context, PatientListController logic,BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(
          top: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.0, constraints): Sizes.height_1,
          left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) :Sizes.width_3,
          right:(kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _widgetManagerDropDown(context, logic,constraints),
          Row(
            children: [
              Expanded(child: _widgetSearchIDText(logic,constraints)),
              Expanded(child: _widgetSearchNameText(logic,constraints),),
            ],
          ),
          _widgetPatientIds(logic,constraints),
          _widgetButtonDetails(logic,constraints),
        ],
      ),
    );
  }


  _widgetManagerDropDown(BuildContext context, PatientListController logic,BoxConstraints constraints) {
    return GetBuilder<PatientListController>(builder: (logic) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) :Sizes.width_3),
        child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
                vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.0, constraints) : Sizes.height_1_5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular((kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) :15),
            color: CColor.greyF8,
            border: Border.all(color: CColor.primaryColor, width: 0.7),
          ),
          child: DropdownButtonFormField(
            focusColor: Colors.white,
            isExpanded: true,
            decoration: const InputDecoration.collapsed(hintText: ''),
            value: logic.selectedUrlModel,
            padding: EdgeInsets.zero,
            style: const TextStyle(color: Colors.white),
            iconEnabledColor: Colors.black,
            items: logic.serverModelDataList.where((element) => element.isSelected && !element.isSecure).toList()
                .map<DropdownMenuItem<ServerModelJson>>((value) {
              return DropdownMenuItem<ServerModelJson>(
                value: value,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        value.url,
                        overflow: TextOverflow.ellipsis,
                        style: AppFontStyle.styleW500(
                            CColor.black,
                            (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0,constraints) : FontSize.size_10),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              logic.onChangeUrl(value);
              Debug.printLog(" value...$value");
            },
          )
        ),
      );
    });
  }

  Widget _widgetSearchIDText(PatientListController logic,BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // height: Sizes.height_6,
          margin: EdgeInsets.only(
              top: Sizes.height_2,
              right: (kIsWeb)
                  ? AppFontStyle.sizesFontManageWeb(1.0, constraints)
                  : Sizes.width_1_5,
              left: (kIsWeb)
                  ? AppFontStyle.sizesFontManageWeb(1.0, constraints)
                  : Sizes.width_3),
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
                CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_10),
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

  Widget _widgetSearchNameText(PatientListController logic,BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_2,
              right: (kIsWeb)
                  ? AppFontStyle.sizesFontManageWeb(1.0, constraints)
                  : Sizes.width_1_5,
              left: (kIsWeb)
                  ? AppFontStyle.sizesFontManageWeb(1.0, constraints)
                  : Sizes.width_3),
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
                CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_10),
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

  _widgetPatientIds(PatientListController logic,BoxConstraints constraints) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(
            left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.8, constraints) :Sizes.width_1_3,
            right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.8, constraints) :Sizes.width_1_2,
            top: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.8, constraints) :Sizes.height_1_2
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
              ListView.builder(
                itemBuilder: (context, index) {
                  return _itemUser(logic, index, context,constraints);
                },
                itemCount: logic.patientProfileList.length,
                padding: const EdgeInsets.all(0),
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
              ),
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

  _itemUser(PatientListController logic, int index, BuildContext context,BoxConstraints constraints) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        logic.saveDetail(index);
      },
      child: Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CColor.white,
          border: Border.all(
              color: (logic.selectedUrlModel!.patientId ==
                  logic.patientProfileList[index].patientId)
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
            horizontal:(kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.1, constraints) : Sizes.width_0_5,
            vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.4, constraints) :Sizes.height_1),
        padding: EdgeInsets.symmetric(
          horizontal:(kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.height_1_2,
          vertical:(kIsWeb) ?AppFontStyle.sizesHeightManageWeb(1.0, constraints): Sizes.height_1,),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all( (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints): 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CColor.primaryColor30,
              ),
              child: const Icon(Icons.person, color: CColor.primaryColor,),
            ),
            Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*logic.patientProfileList[index].patientId.isNotEmpty ?
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
                      ) : Container(),*/
                      logic.patientProfileList[index].fName.isNotEmpty ?
                      RichText(
                        text: TextSpan(
                          // text: "Name:- ",
                          // style: AppFontStyle.styleW700(
                          //     CColor.black, (kIsWeb) ? 5.sp : 13.sp),
                          children: [

                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: logic.patientProfileList[index].fName
                                  .toString(),
                              style: AppFontStyle.styleW600(
                                  CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints) : 12.sp
                              ),
                            ),
                          ],
                        ),
                      ) : Container(),
                      (logic.patientProfileList[index].dob.isNotEmpty && logic.patientProfileList[index].dob != "null") ?
                      RichText(
                        text: TextSpan(
                          // text: "DOB:- ",
                          // style: AppFontStyle.styleW700(
                          //     CColor.black, (kIsWeb) ? 5.sp : 13.sp),
                          children: [
                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: Utils.checkDate(logic.patientProfileList[index].dob.toString()),
                              // text: DateFormat(Constant.commonDateFormatMmmDdYyyy).format(DateTime.parse(logic.patientProfileList[index].dob.toString())) ?? "",
                              style: AppFontStyle.styleW600(
                                  CColor.gray, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.1, constraints) : 10.sp
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

  _widgetButtonDetails(PatientListController logic,BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(
        left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.7, constraints) : 4.w,
        right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.7, constraints) : 4.w,
        // top: 110
      ),
      // padding: EdgeInsets.only(
      //     top: (kIsWeb) ? 2.h : 1.h, bottom: (kIsWeb) ? 2.h : 1.h),
      padding: EdgeInsets.only(
          top: AppFontStyle.sizesHeightManageWeb(1.5, constraints),
          bottom: AppFontStyle.sizesHeightManageWeb(1.5, constraints)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                logic.moveToScreen();
              },
              child: Container(
                padding: const EdgeInsets.all((kIsWeb) ? 5 : 10),
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
                      fontSize: (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.5,constraints) : 15.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


}
