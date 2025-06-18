import 'package:banny_table/ui/patientUserList/controllers/patient_user_list_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/utils.dart';

class MobilePatientUserListScreen extends StatelessWidget {
   MobilePatientUserListScreen({Key? key}) : super(key: key);
  // PatientUserListController  patientUserListController = Get.find<PatientUserListController>();

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
            child: GetBuilder<PatientUserListController>(builder: (logic) {
              return Constant.patientList.isNotEmpty ?  Column(
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
      // alignment: Alignment.center,
      margin: EdgeInsets.only(
          left: 10.w,
          right: 10.w
      ),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return  _itemUser(logic,index,context);
        },
        // itemCount: Constant.patientList.length,
        itemCount: Constant.patientList.length,
        padding: EdgeInsets.only(bottom: 14.h,top: 3.h),
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
      )
    );
  }

  _itemUser(PatientUserListController logic,int index,BuildContext context) {
    return  GestureDetector(
      onTap: () {
        logic.saveDetail(index);
        /*Preference.shared.setString(Preference.patientId, Constant.patientList[index].patientId);
        Preference.shared.setString(Preference.patientFName, Constant.patientList[index].fName);
        Preference.shared.setString(Preference.patientLName, Constant.patientList[index].lName);
        Preference.shared.setString(Preference.patientDob, Constant.patientList[index].dob);
        Preference.shared.setString(Preference.patientGender, Constant.patientList[index].gender);
        Utils.getAllDbData();
        Preference.shared.setString(Preference.patientId, Constant.patientList[index].patientId).then((value) => {
        // logic.gotoSkipTab(),
        });*/
      },
      child: Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10).r,
          color: CColor.white,
          border: Border.all(
              color: (Constant.patientList[index].patientId == Utils.getPatientId())
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
                      Constant.patientList[index].fName.isNotEmpty ?
                      RichText(
                        text: TextSpan(
                          text: "First Name:- ",
                          style: AppFontStyle.styleW700(CColor.black,13.sp),
                          children: [
                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: Constant.patientList[index].fName.toString(),
                              style: AppFontStyle.styleW600(
                                   CColor.gray, 12.sp
                              ),
                            ),
                          ],
                        ),
                      ) : Container(),
                      Constant.patientList[index].lName.isNotEmpty ?
                      RichText(
                        text: TextSpan(
                          text: "Last Name:- ",
                          style: AppFontStyle.styleW700(CColor.black,13.sp),
                          children: [
                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: Constant.patientList[index].lName.toString(),
                              style: AppFontStyle.styleW600(
                                   CColor.gray, 12.sp
                              ),
                            ),
                          ],
                        ),
                      ): Container(),
                      Constant.patientList[index].dob.isNotEmpty ?
                      RichText(
                        text: TextSpan(
                          text: "Dob date:- ",
                          style: AppFontStyle.styleW700(CColor.black,13.sp),
                          children: [
                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: Constant.patientList[index].dob.toString(),
                              style: AppFontStyle.styleW600(
                                   CColor.gray, 12.sp
                              ),
                            ),
                          ],
                        ),
                      ): Container(),
                      Constant.patientList[index].gender.isNotEmpty ?
                      RichText(
                        text: TextSpan(
                          text: "Gender:- ",
                          style: AppFontStyle.styleW700(CColor.black,13.sp),
                          children: [
                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: Constant.patientList[index].gender.toString(),
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

  _widgetButtonDetails(PatientUserListController logic) {
     return (logic.isNavigation)
         ? Container(
       margin: EdgeInsets.only(
           top: 15.h, left: 8.w, right: 8.w),
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
     )
         : Container();
   }



}
