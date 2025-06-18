import 'package:banny_table/ui/welcomeScreen/healthProvider/healthProvider/controllers/health_provider_controller.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/intro/controllers/health_provider_intro_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../utils/font_style.dart';
import '../../../../../utils/sizer_utils.dart';

class MobileHealthProviderIntroScreen extends StatelessWidget {

  HealthProviderController? healthProviderController;

  MobileHealthProviderIntroScreen({ this.healthProviderController, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var orientation = MediaQuery.of(context).orientation;

    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: CColor.white,
          body: SafeArea(
            child: GetBuilder<HealthProviderIntroController>(builder: (logic) {
              return _widgetHealthProvider(context, logic,orientation);
            }),
          ),
        );
      },
    );
  }

  _widgetHealthProvider(
      BuildContext context, HealthProviderIntroController logic,Orientation orientation) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _widgetImage(orientation),
                _widgetMoreDetails(orientation),
              ],
            ),
          ),
        ),
        _widgetButtonYes(logic,orientation),
      ],
    );
  }

  _widgetMoreDetails(Orientation orientation) {
    return Container(
      margin: EdgeInsets.only(
        left: (orientation == Orientation.portrait)? 25.w:15.w,
        right: (orientation == Orientation.portrait)? 25.w:15.w,
        // top: 20.h
      ),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: (orientation == Orientation.portrait)? 9.h:5.h,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              Constant.healthProviderIntro,
              textAlign: TextAlign.start,
              style: AppFontStyle.styleW500(CColor.black, (orientation == Orientation.portrait)? 15.sp:7.sp),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: (orientation == Orientation.portrait)? 9.h:7.h,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              Constant.healthProviderIntroShort,
              textAlign: TextAlign.start,
              style: AppFontStyle.styleW500(CColor.black, (orientation == Orientation.portrait)?15.sp:7.sp),
            ),
          )
        ],
      ),
    );
  }

  _widgetButtonYes(HealthProviderIntroController logic,Orientation orientation){
    return Container(
      padding: EdgeInsets.only(
        top: 5.h, bottom: 5.h,),
      child: Row(
        children: [
          Expanded(child: Container()),
          InkWell(
            onTap: () {
              healthProviderController!.pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
              // logic.gotoNextScreen();
            },
            child: Container(
              padding:  EdgeInsets.symmetric(
                  vertical: 8.h,
                  horizontal: (orientation == Orientation.portrait)? 20.w:24.w
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: CColor.primaryColor,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                      color: CColor.white
                  )
              ),
              child: Text(
                "Yes",
                style: AppFontStyle.styleW700(
                    CColor.white,
                    (orientation == Orientation.portrait)? 14.sp:8.sp),
                // (kIsWeb) ?FontSize.size_8 : FontSize.size_14),
              ),
            ),
          ),
          // (kIsWeb) ? Expanded(child: Container()) : Container(),
          Expanded(child: Container())
        ],
      ),
    );
  }

  _widgetButtonSkip(HealthProviderIntroController logic,Orientation orientation){
    return Container(
      margin: EdgeInsets.only(
          bottom: (orientation == Orientation.portrait)? 10.h:9.h
      ),
      child: Row(
        children: [
          Expanded(child: Container()),
          InkWell(
            onTap: () {
              // Get.toNamed(page)
              logic.gotoNextScreen();
            },
            child: Text(
              "Skip",
              style: TextStyle(
                  color: CColor.primaryColor,
                  fontSize: (orientation == Orientation.portrait)? 12.sp:8.sp),
              // fontSize:(kIsWeb) ?FontSize.size_6: FontSize.size_10),
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }

  /*_widgetImage(Orientation orientation) {
    return Container(
      margin: EdgeInsets.only(top:(orientation == Orientation.portrait)? 20.h :12.h),
      child: Image.asset("assets/images/provider.jpeg",
      height: (orientation == Orientation.portrait)? 150.h:100.h,
        // width: 150.w,
      ),
    );
  }*/

  _widgetImage(Orientation orientation){
    return Container(
      margin: EdgeInsets.only(top: (orientation == Orientation.portrait)? 30.h :0.h),
      padding: EdgeInsets.only(left: Sizes.width_10,right: Sizes.width_10),
      child: SvgPicture.asset(
        Constant.healthProviderImage,
        width: Sizes.height_50,
        height:(orientation == Orientation.portrait)? 200.h : 80.h,
      ),
    );
  }

}
