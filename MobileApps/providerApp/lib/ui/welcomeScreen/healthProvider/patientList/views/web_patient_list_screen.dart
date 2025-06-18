import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../utils/utils.dart';
import '../controllers/patient_list_controller.dart';

class WebPatientListScreen extends StatelessWidget {
  const WebPatientListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // designSize:  Size(700,600),
      // designSize:  Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
      // minTextAdapt: true,
      // splitScreenMode: true,
      // useInheritedMediaQuery: true,
      // ensureScreenSize: true,
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context,constraints) {
            return Scaffold(
              backgroundColor: CColor.white,
              body: SafeArea(
                child: GetBuilder<PatientListController>(builder: (logic) {
                  return logic.patientList.isNotEmpty ?  Column(
                    children: [
                      _widgetMoreDetails(context),
                      Expanded(child: _listPatientUser(context, logic)),
                      _widgetButtonDetails(logic,context)
                    ],
                  ):Container(
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(color: CColor.primaryColor,)) ;
                }),
              ),
            );
          }
        );
      },
    );
  }



  _widgetMoreDetails(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: 25.w,
          right: 25.w,
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
              style: AppFontStyle.styleW500(CColor.black,Utils.sizesFontManage(context ,3.0)),
            ),
          ),
        ],
      ),
    );
  }

  _listPatientUser(BuildContext context, PatientListController logic) {
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
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }

  _itemUser( PatientListController logic,int index,BuildContext context) {
    return GestureDetector(
      onTap: () {
       /* Utils.getAllDbData();
        Preference.shared.setString(Preference.patientId, logic.patientList[index].patientId);
        Preference.shared.setString(Preference.patientFName, logic.patientList[index].fName);
        Preference.shared.setString(Preference.patientLName, logic.patientList[index].lName);
        Preference.shared.setString(Preference.patientDob, logic.patientList[index].dob);
        Preference.shared.setString(Preference.patientGender, logic.patientList[index].gender);
        logic.gotoSkipTab();*/
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
                          style: AppFontStyle.styleW700(CColor.black,Utils.sizesFontManage(context ,2.8)),
                          children: [
                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: logic.patientList[index].fName,
                              style: AppFontStyle.styleW600(
                                  CColor.gray, Utils.sizesFontManage(context ,2.5)
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Last Name:- ",
                          style: AppFontStyle.styleW700(CColor.black,Utils.sizesFontManage(context ,2.8)),
                          children: [
                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: logic.patientList[index].lName,
                              style: AppFontStyle.styleW600(
                                  CColor.gray,Utils.sizesFontManage(context ,2.5)
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Dob date:- ",
                          style: AppFontStyle.styleW700(CColor.black,Utils.sizesFontManage(context ,2.8)),
                          children: [
                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: logic.patientList[index].dob,
                              style: AppFontStyle.styleW600(
                                  CColor.gray, Utils.sizesFontManage(context ,2.5)
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Gender:- ",
                          style: AppFontStyle.styleW700(CColor.black,Utils.sizesFontManage(context ,2.8)),
                          children: [
                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: logic.patientList[index].gender,
                              style: AppFontStyle.styleW600(
                                  CColor.gray, Utils.sizesFontManage(context ,2.5)
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

  _widgetButtonDetails(PatientListController logic,BuildContext context) {
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
              top: 2.h, bottom: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    logic.gotoSkipTab();
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
  }




}
