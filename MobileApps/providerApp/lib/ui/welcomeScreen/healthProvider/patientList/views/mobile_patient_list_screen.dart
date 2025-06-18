import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../utils/utils.dart';
import '../controllers/patient_list_controller.dart';


class MobilePatientListScreen extends StatelessWidget {
   MobilePatientListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // patientUserListController.context = context;

    return ScreenUtilInit(
      /*minTextAdapt: true,
      splitScreenMode: true,*/
      builder: (context, child) {
        return Scaffold(
          backgroundColor: CColor.white,
          body: SafeArea(
            child: GetBuilder<PatientListController>(builder: (logic) {
              return (!logic.isShowProgress) ?  Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if(logic.patientList.isNotEmpty)_widgetMoreDetails(),
                          (logic.patientList.isNotEmpty)
                              ? Expanded(
                                  child: _listPatientUser(context, logic),
                                )
                              : Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "No patient found",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: CColor.black,
                                          fontSize: 15.sp),
                                    ),
                                  ),
                                ),
                          _widgetButtonDetails(logic)
                        ],
                ),
              ):Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(color: CColor.primaryColor,)) ;
            }),
          ),
        );
      },
    );
  }


   _widgetMoreDetails() {
     return Container(
       margin: EdgeInsets.only(
         left: 25.h,
         right: 25.h,
         top: 20.h
       ),
       alignment: Alignment.center,
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         mainAxisAlignment: MainAxisAlignment.start,
         children: [
           Container(
             margin: EdgeInsets.only(
               top: 1.h,
             ),
             alignment: Alignment.centerLeft,
             child: Text(
               Constant.healthProviderPatient,
               textAlign: TextAlign.start,
               style: AppFontStyle.styleW500(CColor.black, 13.sp),
             ),
           ),
         ],
       ),
     );
   }


   _listPatientUser(BuildContext context, PatientListController logic) {
    return Container(
      color: CColor.white,
      // alignment: Alignment.center,
      margin: EdgeInsets.only(
          top: 5.h,
          left: 10.w,
          right: 10.w,
      ),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return  _itemUser(logic,index,context);
        },
        itemCount: logic.patientList.length,
        padding: EdgeInsets.only(bottom: 14.h,top: 3.h),
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
      )
    );
  }

  _itemUser(PatientListController logic,int index,BuildContext context) {
    return  GestureDetector(
      onTap: () {
       /* Preference.shared.setString(Preference.patientId, logic.patientList[index].patientId);
        Preference.shared.setString(Preference.patientFName, logic.patientList[index].fName);
        Preference.shared.setString(Preference.patientLName, logic.patientList[index].lName);
        Preference.shared.setString(Preference.patientDob, logic.patientList[index].dob);
        Preference.shared.setString(Preference.patientGender, logic.patientList[index].gender);
        Utils.getAllDbData();*/
        logic.saveDetail(index);
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
            horizontal: 6.w,
            vertical: 6.h),
        padding: EdgeInsets.symmetric(
            horizontal: 8.w,
            vertical: 7.h,),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10).w,
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
                      logic.patientList[index].fName.isNotEmpty ?
                      RichText(
                        text: TextSpan(
                          text: "First Name:- ",
                          style: AppFontStyle.styleW700(CColor.black,13.sp),
                          children: [
                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: logic.patientList[index].fName.toString(),
                              style: AppFontStyle.styleW600(
                                   CColor.gray, 12.sp
                              ),
                            ),
                          ],
                        ),
                      ) : Container(),
                      logic.patientList[index].lName.isNotEmpty ?
                      RichText(
                        text: TextSpan(
                          text: "Last Name:- ",
                          style: AppFontStyle.styleW700(CColor.black,13.sp),
                          children: [
                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: logic.patientList[index].lName.toString(),
                              style: AppFontStyle.styleW600(
                                   CColor.gray, 12.sp
                              ),
                            ),
                          ],
                        ),
                      ): Container(),
                      logic.patientList[index].dob.isNotEmpty ?
                      RichText(
                        text: TextSpan(
                          text: "Dob date:- ",
                          style: AppFontStyle.styleW700(CColor.black,13.sp),
                          children: [
                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: logic.patientList[index].dob.toString(),
                              style: AppFontStyle.styleW600(
                                   CColor.gray, 12.sp
                              ),
                            ),
                          ],
                        ),
                      ): Container(),
                      logic.patientList[index].gender.isNotEmpty ?
                      RichText(
                        text: TextSpan(
                          text: "Gender:- ",
                          style: AppFontStyle.styleW700(CColor.black,13.sp),
                          children: [
                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: logic.patientList[index].gender.toString(),
                              style: AppFontStyle.styleW600(
                                   CColor.gray, 12.sp
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
    ) ;
  }

  _widgetButtonDetails(PatientListController logic) {
     return Container(
       margin: EdgeInsets.only(
           top: 15.h, left: 8.h, right: 8.h),
       padding:
       EdgeInsets.only(top: 4.h, bottom: 10.h),
       child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceAround,
         children: [
           Expanded(
             child: InkWell(
               onTap: () {
                 logic.gotoSkipTab();
               },
               child: Container(
                 padding: const EdgeInsets.all(10),
                 alignment: Alignment.center,
                 decoration: BoxDecoration(
                     color: CColor.primaryColor,
                     borderRadius: BorderRadius.circular(7),
                     border: Border.all(color: CColor.white)),
                 // margin: EdgeInsets.only(right: Sizes.width_2),
                 child: Text(
                   "Next",
                   textAlign: TextAlign.center,
                   style: TextStyle(
                       color: CColor.white,
                       fontSize: 15.sp),
                 ),
               ),
             ),
           ),
         ],
       ),
     );
   }



}
