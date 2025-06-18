import 'package:banny_table/ui/welcomeScreen/healthProvider/qrScanner/datamodel/serverModelJson.dart';
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

import '../controllers/provider_id_selection_controller.dart';

class ProfileSelectionScreen extends StatelessWidget {
  const ProfileSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    return Theme(
      data: ThemeData(
          useMaterial3: false
      ),
      child: GetBuilder<ProfileSelectionController>(builder: (logic) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: CColor.primaryColor,
            toolbarHeight: 50,
            title: Text(/*Utils.getProfilePageHeader(logic.fromScreenType)*/Constant.headerSelectProvider),
          ),
          backgroundColor: CColor.white,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                    child:SingleChildScrollView(
                      child: _widgetFirstPageDetails(context, logic,orientation),
                    )
                ),
                _widgetButtonDetails(logic,orientation),
              ],
            ),
          ),
        );
      }),
    );
  }

  _widgetFirstPageDetails(BuildContext context, ProfileSelectionController logic,Orientation orientation) {
    return Container(
      margin: EdgeInsets.only(
          top: (orientation == Orientation.portrait) ?  Sizes.height_1 :Sizes.height_0_5,
          left: Sizes.width_3,
          right: Sizes.width_3
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _widgetManagerDropDown(context, logic,orientation),
          Row(
            children: [
              Expanded(child: _widgetSearchIDText(logic,orientation)),
              Expanded(child: _widgetSearchNameText(logic,orientation),),
            ],
          ),
          _widgetPatientIds(logic,orientation),
        ],
      ),
    );
  }


  _widgetManagerDropDown(BuildContext context, ProfileSelectionController logic,Orientation orientation) {
    return GetBuilder<ProfileSelectionController>(builder: (logic) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: Sizes.width_3),
        child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: (kIsWeb) ? Sizes.width_1_5 : Sizes.width_3,
                vertical: (orientation == Orientation.portrait) ? Sizes.height_1_5 :Sizes.height_1_2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: CColor.greyF8,
              border: Border.all(color: CColor.primaryColor, width: 0.7),
            ),
            child: DropdownButtonFormField(
              focusColor: Colors.white,
              isExpanded: true,
              decoration: const InputDecoration.collapsed(hintText: ''),
              // value: logic.selectedMultipleGoalStatus,
              value: logic.selectedUrlModel,
              //elevation: 5,
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
                              (kIsWeb) ? FontSize.size_3 : (orientation == Orientation.portrait) ?  FontSize.size_10 :FontSize.size_9),
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

  Widget _widgetSearchIDText(ProfileSelectionController logic,Orientation orientation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // height: Sizes.height_6,
          margin: EdgeInsets.only(
              top: (orientation == Orientation.portrait) ? Sizes.height_2 :Sizes.height_1_2, right: Sizes.width_1_5, left: Sizes.width_3),
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
                CColor.black, (kIsWeb) ? FontSize.size_3 :(orientation == Orientation.portrait) ?  FontSize.size_10 :FontSize.size_9),
            cursorColor: CColor.black,
            decoration: const InputDecoration(
              hintText: "Search Id",
              filled: true,
              border: InputBorder.none,
            ),
            onChanged: (value) {
              logic.getProviderList();
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

  Widget _widgetSearchNameText(ProfileSelectionController logic,Orientation orientation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top:(orientation == Orientation.portrait) ? Sizes.height_2 :Sizes.height_1_2, right: Sizes.width_3, left: Sizes.width_1_5),
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
                CColor.black, (kIsWeb) ? FontSize.size_3 : (orientation == Orientation.portrait) ?  FontSize.size_10 :FontSize.size_9),
            cursorColor: CColor.black,
            decoration: const InputDecoration(
              hintText: "Search Name",
              filled: true,
              border: InputBorder.none,
            ),
            onChanged: (value) {
              logic.getProviderList();
            },
          ),
        ),
      ],
    );
  }

  _widgetPatientIds(ProfileSelectionController logic,Orientation orientation) {
    return Container(
      margin: EdgeInsets.only(
          left: Sizes.width_1_3,
          right: Sizes.width_1_2,
          top: (orientation == Orientation.portrait) ?   Sizes.height_1_2 :Sizes.height_1
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
                return _itemUser(logic, index, context,orientation);
              },
              itemCount: logic.patientProfileList.length,
              padding: const EdgeInsets.all(0),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
            ),
            Container(
              margin: EdgeInsets.only(
                top: (orientation == Orientation.portrait) ? Sizes.height_25 :Sizes.height_5
              ),
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
    );
  }

  _itemUser(ProfileSelectionController logic, int index, BuildContext context,Orientation orientation) {
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
                              CColor.black, (kIsWeb) ? 5.sp : (orientation == Orientation.portrait) ?   13.sp :7.2.sp),
                          children: [
                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: logic.patientProfileList[index].patientId
                                  .toString(),
                              style: AppFontStyle.styleW600(
                                  CColor.gray, (kIsWeb) ? 4.sp : (orientation == Orientation.portrait) ?   12.sp:6.7.sp
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
                              CColor.black, (kIsWeb) ? 5.sp : (orientation == Orientation.portrait) ?   13.sp :7.2.sp),
                          children: [

                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: logic.patientProfileList[index].fName
                                  .toString(),
                              style: AppFontStyle.styleW600(
                                  CColor.gray, (kIsWeb) ? 4.sp : (orientation == Orientation.portrait) ?   12.sp:6.7.sp
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

  _widgetButtonDetails(ProfileSelectionController logic,Orientation orientation) {
    return Container(
      margin: EdgeInsets.only(
        left: (kIsWeb) ? 3.w : 4.w,
        right: (kIsWeb) ? 3.w : 4.w,
        // top: 110
      ),
      // padding: EdgeInsets.only(
      //     top: (kIsWeb) ? 2.h : 1.h, bottom: (kIsWeb) ? 2.h : 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                logic.moveToScreen();
              },
              child: Container(
                padding: const EdgeInsets.all((kIsWeb) ? 2 : 10),
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
                      fontSize: (kIsWeb) ? 5.5.sp : (orientation == Orientation.portrait) ? 15.sp:7.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
