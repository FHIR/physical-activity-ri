import 'package:banny_table/ui/welcomeScreen/healthProvider/healthProvider/controllers/health_provider_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../utils/constant.dart';
import '../../../../../utils/font_style.dart';
import '../controllers/organization_provider_controller.dart';

class OrganizationProviderScreen extends StatelessWidget {
  HealthProviderController? healthProviderController;
  OrganizationProviderScreen({this.healthProviderController, Key? key } ) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    return GetBuilder<OrganizationProviderController>(builder: (logic) {
      return Theme(
        data: ThemeData(
            useMaterial3: false
        ),

        child: ScreenUtilInit(
          builder: (context, child) {
            return   Scaffold(
              appBar: AppBar(
                backgroundColor: CColor.white,
                shadowColor: CColor.transparent,
                // iconTheme: IconThemeData( color: Colors. black,),
                leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      healthProviderController?.previousPage();
                    }),
              ),
              backgroundColor: CColor.white,
              body:LayoutBuilder(
                builder: (BuildContext context,BoxConstraints constraints) {
                  return  _widgetHealthProvider(context,logic,orientation,constraints);
                }
              )
            );
          },
        ),
      );
    });
  }

  _widgetHealthProvider(
      BuildContext context, OrganizationProviderController logic,Orientation orientation,BoxConstraints constraints) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _widgetImage(orientation,constraints),
                _widgetMoreDetails(orientation,constraints),
              ],
            ),
          ),
        ),
        _widgetButtonYes(logic,orientation,constraints),
        _widgetButtonNo(logic,orientation,constraints),
      ],
    );
  }

  _widgetImage(Orientation orientation,BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(top:(kIsWeb) ? AppFontStyle.sizesHeightManageWeb(2.0, constraints):(orientation == Orientation.portrait)? 50.h :12.h),
      child: Image.asset("assets/images/ic_organization.png",
        height: (kIsWeb) ? AppFontStyle.sizesFontManageWeb(12.0, constraints) :(orientation == Orientation.portrait)? 150.h:100.h,
      ),
    );
  }

  _widgetMoreDetails(Orientation orientation,BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(
        top: (kIsWeb)
            ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
            : (orientation == Orientation.portrait)
                ? 25.h
                : 15.h,
        left: (kIsWeb)
            ? AppFontStyle.sizesWidthManageWeb(1.5, constraints)
            : (orientation == Orientation.portrait)
                ? 25.w
                : 15.w,
        right: (kIsWeb)
            ? AppFontStyle.sizesWidthManageWeb(1.5, constraints)
            : (orientation == Orientation.portrait)
                ? 25.w
                : 15.w,
      ),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0,constraints): (orientation == Orientation.portrait)? 9.h:5.h,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              Constant.healthProviderOrganization,
              textAlign: TextAlign.start,
              style: AppFontStyle.styleW500(CColor.black,(kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2,constraints): (orientation == Orientation.portrait)? 15.sp:7.sp),
            ),
          ),
        ],
      ),
    );
  }

  _widgetButtonYes(OrganizationProviderController logic,Orientation orientation,BoxConstraints constraints){
    return Container(
      padding: EdgeInsets.only(
        top: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.0, constraints): 5.h,
        bottom: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.0, constraints): 5.h,
      ),
      child: Row(
        children: [
          Expanded(child: Container()),
          InkWell(
            onTap: () {
              healthProviderController?.nextPage(true);
            },
            child: Container(
              padding:  EdgeInsets.symmetric(
                  vertical:(kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.0, constraints) : 8.h,
                  horizontal: (kIsWeb)
                      ? AppFontStyle.sizesWidthManageWeb(5.0, constraints)
                      : (orientation == Orientation.portrait)
                          ? 20.w
                          : 24.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: CColor.primaryColor,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                      color: CColor.white
                  )
              ),
              child: Text(
                Constant.useMyOwn,
                style: AppFontStyle.styleW700(
                    CColor.white,(kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.5,constraints):
                    (orientation == Orientation.portrait)? 14.sp:8.sp),
                // (kIsWeb) ?FontSize.size_8 : FontSize.size_14),
              ),
            ),
          ),
          Expanded(child: Container())
        ],
      ),
    );
  }

  _widgetButtonNo(OrganizationProviderController logic,Orientation orientation,BoxConstraints constraints){
    return Container(
      margin: EdgeInsets.only(
          bottom: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.0, constraints):(orientation == Orientation.portrait)? 10.h:9.h
      ),
      child: Row(
        children: [
          Expanded(child: Container()),
          InkWell(
            onTap: () {
              healthProviderController?.nextPage(false);
            },
            child: Text(
              Constant.useOther,
              style: TextStyle(
                  color: CColor.primaryColor,
                  fontSize:(kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.5,constraints) :  (orientation == Orientation.portrait)? 12.sp:8.sp),
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }

}
