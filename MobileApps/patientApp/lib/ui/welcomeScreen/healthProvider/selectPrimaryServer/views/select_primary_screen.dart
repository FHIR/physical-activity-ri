import 'package:banny_table/ui/welcomeScreen/healthProvider/healthProvider/controllers/health_provider_controller.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/selectPrimaryServer/controllers/select_primary_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class SelectPrimaryScreen extends StatelessWidget {
  HealthProviderController? healthProviderController;

  SelectPrimaryScreen({this.healthProviderController, Key? key})
      : super(key: key);

  // SelectPrimaryController selectPrimaryController = Get.find<SelectPrimaryController>();

  @override
  Widget build(BuildContext context) {
    // selectPrimaryController.healthProviderController = healthProviderController;
    return LayoutBuilder(
      builder: (BuildContext context,BoxConstraints constraints) {
        return GetBuilder<SelectPrimaryController>(builder: (logic) {
          return Scaffold(
            backgroundColor: CColor.white,
            appBar: AppBar(
              backgroundColor: CColor.primaryColor,
              title: Text(Constant.selectPrimaryServerAppBar,textAlign: TextAlign
              .start),
              leading: IconButton(
                onPressed: () {
                  if (logic.isFromSetting) {
                    Get.back();
                  } else {
                    healthProviderController!.pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  }
                  Debug.printLog("------back");
                },
                icon: const Icon(Icons.arrow_back),
              ),
              actions: [
                Container(
                  margin: EdgeInsets.only(
                    right: (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.5, constraints): Sizes.width_4
                  ),
                  child: PopupMenuButton(
                    elevation: 0,
                    constraints: BoxConstraints(
                        minWidth: Get.width * 0.1, maxWidth: Get.width * 0.8),
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(0),
                    position: PopupMenuPosition.under,
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  color: CColor.white,
                                  border: Border.all(width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                  Constant.selectPrimaryI)),
                        ),
                      ];
                    },
                    child: Icon(Icons.info_outline,
                        color: CColor.white, size: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.5,constraints) : Sizes.height_2_5),
                  ),
                ),

              ],
            ),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(child: _widgetQrManageDetails(context, logic,constraints)),
                  _widgetButtonDetails(logic,constraints),

                ],
              ),

          );
        });
      }
    );
  }

  _widgetQrManageDetails(BuildContext context, SelectPrimaryController logic,BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(
          left:(kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : 5.w,
          right:(kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) :5.w
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _widgetServerIds(logic,constraints),
          // _widgetQrDetails(logic),
          // Expanded(child: Container()),
        ],
      ),
    );
  }


  _widgetServerIds(SelectPrimaryController logic,BoxConstraints constraints) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(
            left:(kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.9, constraints) : Sizes.width_1_3,
            right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.9, constraints) :Sizes.width_1_2,
            top: (kIsWeb) ?  AppFontStyle.sizesHeightManageWeb(0.1, constraints):Sizes.height_1_2
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: ( kIsWeb) ?AppFontStyle.sizesWidthManageWeb(0.3, constraints): Sizes.width_0_5, vertical: 7),
          decoration: const BoxDecoration(
              color: CColor.white
          ),
          child: Utils.getServerList.where((element) => element.isSelected).toList().isNotEmpty ? ListView.builder(
            itemBuilder: (context, index) {
              return _itemUser(logic, index, context,constraints);
            },
            // itemCount: Utils.getServerList.where((element) => element.isSelected).toList().length,
            itemCount: Utils.getServerList.length,
            padding: const EdgeInsets.all(0),
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
          ) : Container(
            alignment: Alignment.center,
            child: Text(
              "Please Select any Connection", style: AppFontStyle.styleW600(
                CColor.black, (kIsWeb) ? 4.5.sp : 14.sp
            ),),
          ),
        ),
      ),
    );
  }

  _itemUser(SelectPrimaryController logic, int index, BuildContext context,BoxConstraints constraints) {
    return (Utils.getServerList[index].isSelected)?
    GestureDetector(
      onTap: () {
        logic.selectPrimaryUrl(index);
      },
      child: Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
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
          horizontal: Sizes.height_1_2,
          vertical: Sizes.height_1,),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                logic.selectPrimaryUrl(index);
              },
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: CColor.primaryColor,
                    width: 2.0,
                  ),
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: logic.selectedUrlDataList[index].isPrimary ? CColor
                          .primaryColor : CColor.transparent,
                    ),
                  ),
                ),
              ),
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
                      logic.selectedUrlDataList[index].displayName.isNotEmpty ?
                      RichText(
                        text: TextSpan(
                          text: "${logic.selectedUrlDataList[index].title} :- ",
                          style: AppFontStyle.styleW700(
                              CColor.black, (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.6, constraints) : 13.sp),
                          children: [
                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: logic.selectedUrlDataList[index].url
                                  .toString(),
                              style: AppFontStyle.styleW600(
                                  CColor.black, (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.5, constraints) : 12.sp
                              ),
                            ),
                          ],
                        ),
                      ) :
                      Container(),
                    ],
                  ),
                )),

          ],
        ),
      ),
    ):Container();
  }


  _widgetButtonDetails(SelectPrimaryController logic,BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(
        left: (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.7, constraints) :8.w,
        right: (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.7, constraints): 8.w,
        // top: 110
      ),
      padding: EdgeInsets.only(
          top: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.5, constraints) :4.h, bottom:(kIsWeb) ?AppFontStyle.sizesHeightManageWeb(1.5, constraints) : 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                if(logic.isFromSetting){
                  logic.nextPage();
                }else{
                  logic.nextPage(healthProviderController: healthProviderController);
                }
              },
              child: Container(
                padding: const EdgeInsets.all((kIsWeb) ? 5 :10),
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
                      fontSize: (kIsWeb) ?AppFontStyle.sizesFontManageWeb(1.5,constraints) :15.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
