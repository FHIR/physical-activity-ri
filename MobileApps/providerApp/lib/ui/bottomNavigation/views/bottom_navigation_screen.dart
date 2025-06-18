import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/ui/bottomNavigation/controllers/bottom_navigation_controller.dart';
import 'package:banny_table/ui/graph/views/graph_screen.dart';
import 'package:banny_table/ui/history/views/history_screen.dart';
import 'package:banny_table/ui/home/home/views/home_screen_expanded.dart';
import 'package:banny_table/ui/mixed/views/mixed_screen.dart';
import 'package:banny_table/ui/setting/views/setting_screen.dart';
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


class BottomNavigationScreen extends StatelessWidget {
  BottomNavigationScreen({Key? key}) : super(key: key);
  BottomNavigationController bottomNavigationController =
  Get.find<BottomNavigationController>();

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    return ScreenUtilInit(
      // designSize: const Size(700, 600),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
              useMaterial3: false
          ),
          child: LayoutBuilder(
            builder: (BuildContext context,BoxConstraints constraints) {
              return GetBuilder<BottomNavigationController>(builder: (logic) {
                return Scaffold(
                    backgroundColor: CColor.white,
                    appBar: AppBar(
                      leading:(logic.bottomSelectedIndex == 0 && Utils.isSelectMonth())?
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => {},
                      ):null,
                      backgroundColor: CColor.primaryColor,
                      title: Container(
                        margin: EdgeInsets.only(left: Sizes.width_2),
                        child: Text(
                          logic.getHeaderNameFromIndex(),
                        ),
                      ),
                      actions:
                      [
                        // if(Utils.getAPIEndPoint() != "")
                          GestureDetector(
                          onTap: () {
                            // Get.toNamed(AppRoutes.patientProfileScreen);
                            showDialogForChooseUser(logic, context,orientation,constraints);
                            Debug.printLog("Goto patientProfileScreen .........");
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: (kIsWeb) ? 1 : 5,
                                bottom: (kIsWeb) ? 1 : 5,
                                right: 1).w,
                            padding: const EdgeInsets.only(left: 10, right: 10).w,
                            child: Icon(
                              Icons.person_pin,
                              size: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(2.5, constraints) : (orientation == Orientation.portrait)?29.sp : AppFontStyle.sizesFontManageWeb(3.0, constraints),
                          ),
                        )
                          ),
                        /*Constant.listOfMeaSure.isNotEmpty*/ /*&&*/ logic.bottomSelectedIndex == 1 && Utils.timeFrame.isNotEmpty
                            ? PopupMenuButton<String>(
                          itemBuilder: (context) {
                            return Utils.timeFrame.map((String timeFrame) {
                              return PopupMenuItem(
                                value: timeFrame,
                                // row has two child icon and text
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(timeFrame,style: TextStyle(
                                        color: (timeFrame == Constant.selectedTimeFrame)?CColor.primaryColor:CColor.black
                                    ),)
                                  ],
                                ),
                              );
                            }).toList();
                          },
                          padding: EdgeInsets.zero,
                          tooltip: "Time",
                          offset: const Offset(5, 6),
                          color: Colors.white,
                          elevation: 5,
                          onSelected: (values) {
                            logic.selectedTimeFrameGraph(values);
                          },
                        ): Container(),
                      ],
                    ),
                    /*bottomNavigationBar:
              bottomNavigationController.buildBottomNavBarItems(),*/
                    body: Column(
                      children: [
                        Expanded(
                          child: PageView(
                            allowImplicitScrolling: false,
                            onPageChanged: (value){
                              Debug.printLog("onPageChanged......${value.toString()}");
                            },
                            controller: bottomNavigationController.pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            children: <Widget>[
                              HomeScreen(
                                  bottomNavigationController: bottomNavigationController),
                              // GraphScreen(bottomNavigationController: bottomNavigationController,callback: logic.callback),
                              const GraphScreen(),
                              HistoryScreen(),
                              // const MixedScreen(),
                              SettingScreen(),
                            ],
                          ),
                        ),
                        _widgetBottomBar(orientation)
                      ],
                    )
                );
              });
            }
          ),
        );
      },
    );
  }

  _widgetMenuItem(String values){
    return PopupMenuItem(
      value: values,
      // row has two child icon and text
      child: Row(
        children: [
          SizedBox(
            // sized box with width 10
            width: 10,
          ),
          Text(values,style: TextStyle(
              color: (values == Constant.selectedTimeFrame)?CColor.primaryColor:CColor.black
          ),)
        ],
      ),
    );
  }


  void showDialogForChooseUser(BottomNavigationController logic,
      BuildContext context,Orientation orientation,BoxConstraints constraints) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setStateDialogForChooseCode) {
            return AlertDialog(
              backgroundColor: CColor.white,
              contentPadding: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
              content: SingleChildScrollView(
                child: Container(
                  width: Get.width * 0.8,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                      color: CColor.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 5.h),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: (){
                                Get.back();
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 5.w),
                                child: const Icon(Icons.close, color: CColor.red,),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(
                                  right: Sizes.width_6
                                ),
                                alignment: Alignment.center,
                                child: Text("Patient Profile",
                                  style: AppFontStyle.styleW700(
                                      CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.5, constraints) : (orientation == Orientation.portrait) ? 16.sp : 9.sp),),
                              ),
                            )
                          ],
                        ),
                      ),
                      if(Utils.getPatientId() != "")
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 7.h,),
                          width: double.infinity,
                          child:
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all((kIsWeb)?5.w:(orientation == Orientation.portrait) ? 10.w:5.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius
                                      .circular(10)
                                      .r,
                                  color: CColor.primaryColor30,
                                ),
                                child: const Icon(Icons.person, color: CColor.primaryColor,),
                              ),
                              Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 14.w),
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        /*(Utils.getPatientId() != "") ?
                                        RichText(
                                          text: TextSpan(
                                            // text: "Patient ID:- ",
                                            // style: AppFontStyle.styleW700(CColor.black, (kIsWeb)?6.sp: (orientation == Orientation.portrait) ? 13.sp: 8.sp),
                                            children: [

                                              ///This Is use For Goal Type is mandatory
                                              TextSpan(
                                                text: Utils.getPatientId()
                                                    .toString(),
                                                style: AppFontStyle.styleW600(
                                                    CColor.gray, (kIsWeb)?5.sp:(orientation == Orientation.portrait) ? 12.sp:7.5.sp
                                                ),
                                              ),
                                            ],
                                          ),
                                        ) : Container(),*/
                                        (Utils.getPatientFName() != "") ?
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "${Utils.getPatientFName()} ${Utils.getPatientLName()}",
                                                style: AppFontStyle.styleW700(
                                                    CColor.black, (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.3, constraints) :(orientation == Orientation.portrait) ? 12.sp:7.5.sp
                                                ),
                                              ),
                                            ],
                                          ),
                                        ) : Container(),
                                        /*(Utils.getPatientLName() != "") ?
                                        RichText(
                                          text: TextSpan(
                                            text: "Last Name:- ",
                                            style: AppFontStyle.styleW700(CColor.black, (kIsWeb)?6.sp:(orientation == Orientation.portrait) ? 13.sp: 8.sp),
                                            children: [

                                              ///This Is use For Goal Type is mandatory
                                              TextSpan(
                                                text: Utils.getPatientLName()
                                                    .toString(),
                                                style: AppFontStyle.styleW600(
                                                    CColor.gray, (kIsWeb)?5.sp:(orientation == Orientation.portrait) ? 12.sp:7.5.sp
                                                ),
                                              ),
                                            ],
                                          ),
                                        ) : Container(),*/
                                        (Utils.getPatientDob() != "") ?
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: Utils.checkDate( Utils.getPatientDob().toString()),
                                                style: AppFontStyle.styleW700(
                                                    CColor.gray, (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.3, constraints):(orientation == Orientation.portrait) ? 12.sp:7.5.sp
                                                ),
                                              ),
                                            ],
                                          ),
                                        ) : Container(),
                                        (Utils.getPatientGender() != "") ?
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: Utils.getPatientGender()
                                                    .toString(),
                                                style: AppFontStyle.styleW600(
                                                    CColor.gray, (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.3, constraints):(orientation == Orientation.portrait) ? 12.sp:7.5.sp
                                                ),
                                              ),
                                            ],
                                          ),
                                        ) : Container(),
                                      ],
                                    ),
                                  )),
                            ],
                          )
                      ),
                      if(Utils.getProviderId() != "" )
                        Container(
                          alignment: Alignment.center,
                          child: Text("Provider Profile",
                            style: AppFontStyle.styleW700(
                                CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.5, constraints) : (orientation == Orientation.portrait) ? 16.sp : 9.sp),),
                        ),
                      if(Utils.getProviderId() != "" )

                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 7.h,),
                          width: double.infinity,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all((kIsWeb)?AppFontStyle.sizesFontManageWeb(1.3, constraints):(orientation == Orientation.portrait) ? 10.w:5.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius
                                      .circular(10)
                                      .r,
                                  color: CColor.primaryColor30,
                                ),
                                child: const Icon(Icons.person, color: CColor.primaryColor,),
                              ),
                              Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 14.w),
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        if (Utils.getProviderDOB() == "" &&
                                            Utils.getProviderGender() == "" &&
                                            Utils.getProviderName() == "")
                                          RichText(
                                            text: TextSpan(
                                              // text: "Provider Id:- ",
                                              // style: AppFontStyle.styleW700(CColor.black, (kIsWeb)?6.sp:(orientation == Orientation.portrait) ? 13.sp: 8.sp),
                                              children: [
                                                TextSpan(
                                                  text: "${Utils.getProviderId()}",
                                                  // text: Utils.getProviderId()
                                                  //     .toString(),
                                                  style: AppFontStyle.styleW600(
                                                      CColor.black, (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.3, constraints):(orientation == Orientation.portrait) ? 12.sp:7.5.sp
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                        RichText(
                                          text: TextSpan(
                                            // text: "Provider Id:- ",
                                            // style: AppFontStyle.styleW700(CColor.black, (kIsWeb)?6.sp:(orientation == Orientation.portrait) ? 13.sp: 8.sp),
                                            children: [
                                              if(Utils.getProviderName() != "")
                                              TextSpan(
                                                text: "${Utils.getProviderName()} ${Utils.getProviderLastName()}",
                                                // text: Utils.getProviderId()
                                                //     .toString(),
                                                style: AppFontStyle.styleW600(
                                                    CColor.black, (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.3, constraints):(orientation == Orientation.portrait) ? 12.sp:7.5.sp
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if(Utils.getProviderDOB() != "" )RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                            text: Utils.checkDate( Utils.getProviderDOB().toString()),
                                                style: AppFontStyle.styleW700(
                                                    CColor.gray, (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.3, constraints):(orientation == Orientation.portrait) ? 12.sp:7.5.sp
                                                ),
                                              ),
                                            ],
                                          ),
                                        ) ,
                                        if(Utils.getProviderGender() != "" )RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                            text:  Utils.getProviderGender().toString(),
                                                style: AppFontStyle.styleW700(
                                                    CColor.gray, (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.3, constraints):(orientation == Orientation.portrait) ? 12.sp:7.5.sp
                                                ),
                                              ),
                                            ],
                                          ),
                                        ) ,


                                      ],
                                    ),
                                  )),


                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

/*  _itemUser(BottomNavigationController logic, int index, BuildContext context) {
    return GestureDetector(
      onTap: () {
        logic.saveDetail(index);
      },
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(
          horizontal: 8.w,
          vertical: 7.h,),
        width: double.infinity,
        child:
         Row(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.start,
           children: [
             Container(
               padding: EdgeInsets.all((kIsWeb)?5.w:10.w),
               decoration: BoxDecoration(
                 borderRadius: BorderRadius
                     .circular(10)
                     .r,
                 color: CColor.primaryColor30,
               ),
               child: const Icon(Icons.person, color: CColor.primaryColor,),
             ),
             Expanded(
                 child: Container(
                   margin: EdgeInsets.only(left: 14.w),
                   alignment: Alignment.centerLeft,
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Constant.patientList[index].patientId.isNotEmpty ?
                       RichText(
                         text: TextSpan(
                           text: "Patient ID:- ",
                           style: AppFontStyle.styleW700(CColor.black, (kIsWeb)?6.sp:13.sp),
                           children: [

                             ///This Is use For Goal Type is mandatory
                             TextSpan(
                               text: Constant.patientList[index].patientId
                                   .toString(),
                               style: AppFontStyle.styleW600(
                                   CColor.gray, (kIsWeb)?5.sp:12.sp
                               ),
                             ),
                           ],
                         ),
                       ) : Container(),
                       Constant.patientList[index].fName.isNotEmpty ?
                       RichText(
                         text: TextSpan(
                           text: "First Name:- ",
                           style: AppFontStyle.styleW700(CColor.black, (kIsWeb)?6.sp:13.sp),
                           children: [

                             ///This Is use For Goal Type is mandatory
                             TextSpan(
                               text: Constant.patientList[index].fName
                                   .toString(),
                               style: AppFontStyle.styleW600(
                                   CColor.gray, (kIsWeb)?5.sp:12.sp
                               ),
                             ),
                           ],
                         ),
                       ) : Container(),
                       Constant.patientList[index].lName.isNotEmpty ?
                       RichText(
                         text: TextSpan(
                           text: "Last Name:- ",
                           style: AppFontStyle.styleW700(CColor.black, (kIsWeb)?6.sp:13.sp),
                           children: [

                             ///This Is use For Goal Type is mandatory
                             TextSpan(
                               text: Constant.patientList[index].lName
                                   .toString(),
                               style: AppFontStyle.styleW600(
                                   CColor.gray, (kIsWeb)?5.sp:12.sp
                               ),
                             ),
                           ],
                         ),
                       ) : Container(),
                       Constant.patientList[index].dob.isNotEmpty ?
                       RichText(
                         text: TextSpan(
                           text: "Dob:- ",
                           style: AppFontStyle.styleW700(CColor.black, (kIsWeb)?6.sp:13.sp),
                           children: [

                             ///This Is use For Goal Type is mandatory
                             TextSpan(
                               text: Constant.patientList[index].dob.toString(),
                               style: AppFontStyle.styleW600(
                                   CColor.gray, (kIsWeb)?5.sp:12.sp
                               ),
                             ),
                           ],
                         ),
                       ) : Container(),
                       Constant.patientList[index].gender.isNotEmpty ?
                       RichText(
                         text: TextSpan(
                           text: "Gender:- ",
                           style: AppFontStyle.styleW700(CColor.black, (kIsWeb)?6.sp:13.sp),
                           children: [

                             ///This Is use For Goal Type is mandatory
                             TextSpan(
                               text: Constant.patientList[index].gender
                                   .toString(),
                               style: AppFontStyle.styleW600(
                                   CColor.gray, (kIsWeb)?5.sp:12.sp
                               ),
                             ),
                           ],
                         ),
                       ) : Container(),

                     ],
                   ),
                 )),

           ],
         )
      ),
    );
  }*/


  _widgetBottomBar(Orientation orientation) {
    return GetBuilder<BottomNavigationController>(builder: (logic) {
      return Container(
        padding: EdgeInsets.symmetric(vertical:(orientation == Orientation.portrait) ?  Sizes.height_2_5 :Sizes.height_1_5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(Sizes.width_3),
            topLeft: Radius.circular(Sizes.width_3),
          ),
          color: CColor.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 1,
              spreadRadius: 1,
            )
          ],
        ),
        child: Row(
          children: [
            _itemBar(
                Icon(
                  Icons.home,
                  color: (logic.bottomSelectedIndex == 0)
                      ? CColor.primaryColor
                      : CColor.black,
                ), (val) {
              logic.onPageChanged(0);
            }),
            _itemBar(
                Icon(
                  Icons.bar_chart,
                  color: (logic.bottomSelectedIndex == 1)
                      ? CColor.primaryColor
                      : CColor.black,
                ), (val) {
              logic.onPageChanged(1);
            }),
            _itemBar(
                Image.asset(
                  Constant.homeIcHistory,
                  height: Sizes.height_3,
                  width: Sizes.height_3,
                  color: (logic.bottomSelectedIndex == 2)
                      ? CColor.primaryColor
                      : CColor.black,
                ),
                /*Icon(
                  Icons.history_outlined,
                  color: (logic.bottomSelectedIndex == 2)
                      ? CColor.primaryColor
                      : CColor.black,
                ), */(val) {
              logic.onPageChanged(2);
            }),
            _itemBar(
                Icon(
                  Icons.settings,
                  color: (logic.bottomSelectedIndex == 3)
                      ? CColor.primaryColor
                      : CColor.black,
                ), (val) {
              logic.onPageChanged(3);
            }),
          ],
        ),
      );
    });
  }

  _itemBar( icons, Function callBack,) {
    return Expanded(
      child: InkWell(
        onTap: () {
          callBack.call("");
        },
        child: Container(
          child: icons,
        ),
      ),
    );
  }
}
