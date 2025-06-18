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

import '../controllers/log_table_controller.dart';

class LogTableScreen extends StatelessWidget {
  const LogTableScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LogTableController>(builder: (logic) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: CColor.primaryColor,
          title: Text(Constant.logTableAppBar,
            style: TextStyle(
              color: CColor.white,
              // fontSize: 20,
              fontFamily: Constant.fontFamilyPoppins,
            ),),
        ),
        backgroundColor: CColor.white,
        body: LayoutBuilder(
          builder: (BuildContext context,BoxConstraints constraints) {
            return SafeArea(
              child: _widgetType(logic,constraints),
            );
          }
        ),
      );
    });
  }

  _widgetType(LogTableController logic,BoxConstraints constraints) {
    return Container(
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
        child: (logic.logTable.isNotEmpty)?
        ListView.builder(
          // reverse: true,

          itemBuilder: (context, index) {
            return _itemUser(logic, index, context,constraints);
          },
          itemCount: logic.logTable.length,
          padding: const EdgeInsets.all(0),
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
        ):
        Container(
          alignment: Alignment.center,
          child: Text(
            "No log data found",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: CColor.black,
                fontSize: (kIsWeb) ? 7.sp :15.sp),
          ),
        ),
      ),
    );
  }

  _itemUser(LogTableController logic, int index, BuildContext context,BoxConstraints constraints) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(10),
        color: CColor.white,
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
        // horizontal: Sizes.height_1_2,
        vertical: Sizes.height_1,),
      width: double.infinity,
      child: Container(
        margin: EdgeInsets.only(
            left: (kIsWeb) ? Sizes.width_1_5 : Sizes.width_3),
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (logic.logTable[index].type!.isNotEmpty) ?
            RichText(
              text: TextSpan(
                text: "Type:- ",
                style: AppFontStyle.styleW700(
                    CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints) : 13.sp),
                children: [
                  ///This Is use For Goal Type is mandatory
                  TextSpan(
                    text: logic.logTable[index].type
                        .toString(),
                    style: AppFontStyle.styleW600(
                        CColor.gray, (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(1.0, constraints) : 12.sp
                    ),
                  ),
                ],
              ),
            ) : Container(),
            logic.logTable[index].resourceType!.isNotEmpty ?
            RichText(
              text: TextSpan(
                text: "ResourceType:- ",
                style: AppFontStyle.styleW700(
                    CColor.black, (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(1.2, constraints) : 13.sp),
                children: [
                  TextSpan(
                    text: logic.logTable[index].resourceType
                        .toString(),
                    style: AppFontStyle.styleW600(
                        CColor.gray, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : 12.sp
                    ),
                  ),
                ],
              ),
            ) : Container(),
            logic.logTable[index].resourceType!.isNotEmpty ?
            RichText(
              text: TextSpan(
                text: "Response:- ",
                style: AppFontStyle.styleW700(
                    CColor.black, (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(1.2, constraints) : 13.sp),
                children: [
                  TextSpan(
                    text: logic.logTable[index].response
                        .toString(),
                    style: AppFontStyle.styleW600(
                        CColor.gray, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : 12.sp
                    ),
                  ),
                ],
              ),
            ) : Container(),
            /*Container(
              margin: EdgeInsets.only(
                top: Get.height*0.03
              ),
              child: Divider(
                height: 1,
                color: CColor.black,
              ),
            )*/
          ],
        ),
      ),
    );
  }
}
