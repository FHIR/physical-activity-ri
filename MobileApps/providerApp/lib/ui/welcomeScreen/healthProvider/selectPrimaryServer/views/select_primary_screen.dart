import 'package:banny_table/ui/welcomeScreen/healthProvider/healthProvider/controllers/health_provider_controller.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/selectPrimaryServer/controllers/select_primary_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/sizer_utils.dart';
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
    var orientation = MediaQuery.of(context).orientation;
    // selectPrimaryController.healthProviderController = healthProviderController;
    return Theme(
      data: ThemeData(
          useMaterial3: false
      ),
      child: GetBuilder<SelectPrimaryController>(builder: (logic) {
        return Scaffold(
          backgroundColor: CColor.white,
          appBar: AppBar(
            backgroundColor: CColor.primaryColor,
            toolbarHeight: 50,
            title:  Text(Constant.selectPrimaryServerAppBar),
            leading: IconButton(
              onPressed: () {
                if (logic.isFromSetting) {
                  Get.back();
                } else {
                  // Get.back();
                  healthProviderController!.pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn);
                }
                Debug.printLog("------back");
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(child: _widgetQrManageDetails(context, logic,orientation )),
                _widgetButtonDetails(logic,orientation ),

              ],
            ),

        );
      }),
    );
  }

  _widgetQrManageDetails(BuildContext context, SelectPrimaryController logic,Orientation orientation) {
    return Container(
      margin: EdgeInsets.only(
          left:(kIsWeb) ? Sizes.width_2 : 5.w,
          right:(kIsWeb) ? Sizes.width_2 :5.w
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _widgetServerIds(logic,orientation ),
          // _widgetQrDetails(logic),
          // Expanded(child: Container()),
        ],
      ),
    );
  }


  _widgetServerIds(SelectPrimaryController logic,Orientation orientation) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(
            left:(kIsWeb) ? Sizes.width_1 : Sizes.width_1_3,
            right: (kIsWeb) ? Sizes.width_1 :Sizes.width_1_2,
            top: Sizes.height_1_2
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: Sizes.width_0_5, vertical: 7),
          decoration: const BoxDecoration(
              color: CColor.white
          ),
          child: Utils.getServerList.where((element) => element.isSelected).toList().isNotEmpty ? ListView.builder(
            itemBuilder: (context, index) {
              return _itemUser(logic, index, context,orientation );
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

  _itemUser(SelectPrimaryController logic, int index, BuildContext context, Orientation orientation ) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                logic.selectPrimaryUrl(index);
              },
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // color: logic.selectedUrlData[index].displayName.isNotEmpty ? Colors.blue : Colors.transparent,
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
                      color: logic.selectedUrlDataList[index].isPrimary! ? CColor
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
                      logic.selectedUrlDataList[index].displayName!.isNotEmpty ?
                      RichText(
                        text: TextSpan(
                          text: "${logic.selectedUrlDataList[index].title} :- ",
                          style: AppFontStyle.styleW700(
                              CColor.black, (kIsWeb) ? 5.sp :(orientation == Orientation.portrait) ? 13.sp :11.sp),
                          children: [

                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: logic.selectedUrlDataList[index].url
                                  .toString(),
                              style: AppFontStyle.styleW600(
                                  CColor.black, (kIsWeb) ? 4.sp : (orientation == Orientation.portrait) ? 12.sp :10.sp
                              ),
                            ),
                          ],
                        ),
                      ) :
                      Container(),
                      /*logic.selectedUrlDataList[index].isSecure! ? Container(
                        margin: EdgeInsets.only(
                          top: Sizes.height_1
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: (){
                                if(logic.selectedUrlDataList[index].authToken == ""){
                                  logic.callServiceProvider(logic.selectedUrlDataList[index],index);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: CColor.qrColorGreen,
                                  borderRadius: BorderRadius.circular(9),

                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    // horizontal: 15
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        right: Sizes.width_1,
                                        left: Sizes.width_1
                                      ),
                                      child:logic.selectedUrlDataList[index].authToken == "" ? const Icon(Icons.close,color: CColor.red,):const Icon(Icons.done,color: CColor.white,),
                                    ),
                                    Container(
                                        padding: EdgeInsets.only(
                                          // vertical: 5,
                                          left: Sizes.width_1,
                                          right: Sizes.width_3
                                        ),
                                        child: Text("Authorize",style: AppFontStyle.styleW500(CColor.white, (kIsWeb) ? FontSize.size_4 :FontSize.size_10),)),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(child: Container())
                          ],
                        )
                      ) :
                          Container()*/
                    ],
                  ),
                )),

          ],
        ),
      ),
    ):Container();
  }


  _widgetButtonDetails(SelectPrimaryController logic,Orientation orientation) {
    return Container(
      margin: EdgeInsets.only(
        left: (kIsWeb) ?3.w :8.w,
        right: (kIsWeb) ?3.w: 8.w,
        // top: 110
      ),
      padding: EdgeInsets.only(
          top: (kIsWeb) ? 2.h :4.h, bottom:(kIsWeb) ? 2.h : 1.h),
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
                padding: const EdgeInsets.all((kIsWeb) ? 2 :10),
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
                      fontSize: (kIsWeb) ?5.5.sp : (orientation == Orientation.portrait) ? 15.sp:13.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
