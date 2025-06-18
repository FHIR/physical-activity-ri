import 'package:banny_table/ui/patientUserList/controllers/patient_user_list_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/utils.dart';

class WebPatientUserListScreen extends StatelessWidget {
  const WebPatientUserListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(700, 600),
      minTextAdapt: false,
      splitScreenMode: false,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: CColor.white,
          body: SafeArea(
            child: GetBuilder<PatientUserListController>(builder: (logic) {
              return logic.patientList.isNotEmpty ?  Column(
                children: [
                  Expanded(child: _listPatientUser(context, logic)),
                  _widgetButtonDetails(logic)
                ],
              ):Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(color: CColor.primaryColor,)) ;
            }),
          ),
        );
      },
    );
  }



  _listPatientUser(BuildContext context, PatientUserListController logic) {
    return Container(
      color: CColor.white,
      margin: EdgeInsets.only(
          left: 8.w,
          right: 8.w
      ),
      child: ListView.builder(
        /*gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 0.0,
            mainAxisSpacing: 0.0
        ),*/
        itemBuilder: (context, index) {
          return _itemUser(logic,index,context);
        },

        itemCount: logic.patientList.length,
        padding: EdgeInsets.only(bottom: 14.h,top: 6.h),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }

  _itemUser( PatientUserListController logic,int index,BuildContext context) {
    return GestureDetector(
      onTap: () {
        logic.saveDetail(index);
       /* Utils.getAllDbData();
        Preference.shared.setString(Preference.patientId, logic.patientList[index].patientId);
        Preference.shared.setString(Preference.patientFName, logic.patientList[index].fName);
        Preference.shared.setString(Preference.patientLName, logic.patientList[index].lName);
        Preference.shared.setString(Preference.patientDob, logic.patientList[index].dob);
        Preference.shared.setString(Preference.patientGender, logic.patientList[index].gender);
        logic.gotoSkipTab();*/
      },
      child: Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10).r,
          color: CColor.white,
          border: Border.all(
              color: (logic.patientList[index].patientId == Utils.getPatientId())
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
            horizontal: 6.h,
            vertical: 6.h),
        padding: EdgeInsets.symmetric(
          horizontal: 8.h,
          vertical: 7.h,),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10).h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10).r,
                color: CColor.primaryColor30,
              ),
              child: const Icon(Icons.person,color: CColor.primaryColor,),
            ),
            Expanded  (
                child: Container(
                  margin: EdgeInsets.only(left: 14.w),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "First Name:- ",
                          style: AppFontStyle.styleW700(CColor.black,9.sp),
                          children: [
                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: logic.patientList[index].fName,
                              style: AppFontStyle.styleW600(
                                  CColor.gray, 8.sp
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Last Name:- ",
                          style: AppFontStyle.styleW700(CColor.black,9.sp),
                          children: [
                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: logic.patientList[index].lName,
                              style: AppFontStyle.styleW600(
                                  CColor.gray,8.sp
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Dob date:- ",
                          style: AppFontStyle.styleW700(CColor.black,9.sp),
                          children: [
                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: logic.patientList[index].dob,
                              style: AppFontStyle.styleW600(
                                  CColor.gray, 8.sp
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Gender:- ",
                          style: AppFontStyle.styleW700(CColor.black,9.sp),
                          children: [
                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: logic.patientList[index].gender,
                              style: AppFontStyle.styleW600(
                                  CColor.gray, 8.sp
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                )),

          ],
        ),
      ),
    );
  }

  _widgetButtonDetails(PatientUserListController logic){
    return (logic.isNavigation) ? Container(
      margin: EdgeInsets.only(
          top: 3.h,
          left: 7.w,
          right: 7.w
      ),
      padding: EdgeInsets.only(
          top: 4.h, bottom: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                logic.gotoSkipTab();
              },
              child: Container(
                padding: const EdgeInsets.all(3).w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: CColor.primaryColor,
                    borderRadius: BorderRadius.circular(7).r,
                    border: Border.all(
                        color: CColor.white
                    )
                ),
                margin: EdgeInsets.only(
                    right: 3.w
                ),
                child: Text(
                  "Next",
                  style: TextStyle(
                      color: CColor.white,
                      fontSize:8.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    ) : Container();
  }





}
