import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/ui/mixed/controllers/mixed_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

import '../../../utils/debug.dart';

class MixedScreen extends StatelessWidget {
  const MixedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MixedController>(builder: (logic) {
      return LayoutBuilder(
        builder: (BuildContext context,BoxConstraints constraints) {
          return Scaffold(
            backgroundColor: CColor.white,
            floatingActionButtonLocation: ExpandableFab.location,
            floatingActionButton: ExpandableFab(
              key: logic.keyFabButton,
              duration: const Duration(milliseconds: 300),
              distance: 60.0,
              type: ExpandableFabType.up,
              pos: ExpandableFabPos.right,
              childrenOffset: const Offset(0, 20),
              fanAngle: 40,
              openButtonBuilder: RotateFloatingActionButtonBuilder(
                child: const Icon(Icons.add),
                fabSize: ExpandableFabSize.regular,
                foregroundColor: CColor.white,
                backgroundColor: CColor.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                angle: 3.14 * 2,
              ),
              closeButtonBuilder: FloatingActionButtonBuilder(
                size: 60,
                builder: (BuildContext context, void Function()? onPressed,
                    Animation<double> progress) {
                  return Container(
                    decoration: BoxDecoration(
                      color: CColor.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 1),
                          blurRadius: 5,
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: onPressed,
                      icon: const Icon(
                        Icons.close,
                        size: 30,
                      ),
                    ),
                  );
                },
              ),
              overlayStyle: ExpandableFabOverlayStyle(
                // color: Colors.black.withOpacity(0.5),
                blur: 0,
              ),
              onOpen: () {
                Debug.printLog('onOpen');
              },
              afterOpen: () {
                Debug.printLog('afterOpen');
              },
              onClose: () {
                Debug.printLog('onClose');
              },
              afterClose: () {
                Debug.printLog('afterClose');
              },
              children: [
                _widgetContainerBox("Goal", (value) {
                  Debug.printLog("Goal");
                  final state = logic.keyFabButton.currentState;
                  if (state != null) {
                    debugPrint('isOpen:${state.isOpen}');
                    state.toggle();
                  }
                  Get.toNamed(AppRoutes.goalForm, arguments: [null,true,Constant.dataMixScreen])!.then((value) =>
                      logic.callApiForHive());
                },constraints),
              ],
            ),
            body: GetBuilder<MixedController>(builder: (logic) {
                  return SafeArea(
                      child: Utils.pullToRefreshApi(
                          _widgetMixed(logic,context,constraints), logic.refreshController, logic.onRefresh,
                          logic.onLoading)
                  );
                }),
          );
        }
      );
    });
  }

  _widgetContainerBox(String title,
      Function callBack,BoxConstraints constraints) {
    return GestureDetector(
      onTap: (){
        callBack.call("");
      },
      child: Container(
        width: Sizes.width_33,
        decoration: BoxDecoration(
            color: CColor.primaryColor,
            borderRadius: BorderRadius.circular(10)
          // shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
        alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.all(5),
          child: Text(title,
              textAlign: TextAlign.center,
              style: AppFontStyle.styleW500(
                  CColor.white, (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : FontSize.size_11)),
        ),
      ),
    );

  }

  _widgetMixed(MixedController logic,BuildContext context,BoxConstraints constraints) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _widgetCondition(logic,context,constraints),
          _widgetGoalView(logic,context,constraints),
          _widgetCarePlan(logic,context,constraints),
          _widgetRxData(logic,context,constraints),
          _widgetReferral(logic,context,constraints),
        ],
      ),
    );
  }

  _widgetGoalView(MixedController logic,BuildContext context,BoxConstraints constraints) {
    return InkWell(
      onTap: () {
        if (logic.goalDataList.isNotEmpty /*&& !logic.isGoalLoading*/) {
          Get.toNamed(AppRoutes.goalList,
              arguments: [logic.serverUrlDataList, logic.goalDataList])!.then((value) => {
            logic.callApiForHive(),
          });
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
            vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.05, constraints):Sizes.height_0_0_5),
        padding: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.8, constraints) : Sizes.width_3,
            vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.0, constraints): Sizes.height_2),
        child: Row(
          children: [
            Container(
              padding:  EdgeInsets.all((kIsWeb) ? AppFontStyle.sizesFontManageWeb(0.7, constraints) : 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CColor.primaryColor30,
              ),
              child: Image.asset(
                "assets/icons/ic_goal.png",
                height:  (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.3, constraints) : Sizes.height_2,
                width:  (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.3, constraints) : Sizes.height_2,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        /*(logic.isGoalLoading) ? Constant.goal :
                        (logic.goalDataList.isEmpty)
                            ? "${Constant.goal} (None)"
                            : Constant.goal,*/
                        overflow: TextOverflow.ellipsis,
                        (logic.isGoalLoading) ? Constant.goal:
                        (logic.goalDataList.isEmpty)
                                ? "${Constant.goal} (None)"
                                : "${Constant.goal} (Active: ${logic.goalDataList.where((element) => element.lifeCycleStatus == Constant.lifeCycleActive).toList().length})",
                        style: AppFontStyle.styleW600(CColor.black,
                            (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.4,constraints) : FontSize.size_12),
                      ),
                    ),
                    (logic.isGoalLoading)
                        ?
                    Lottie.asset(
                        Constant.progressLoader, height: Sizes.height_4,delegates: LottieDelegates(
                      values: [
                        ValueDelegate.color(
                          const ['**', 'Ellipse 1', '**'],
                          value: CColor.primaryColor,
                        ),
                      ],
                    ),)
                        : Container(),
                  ],
                ),
              ),
            ),
            if(logic.goalDataList.isNotEmpty &&
                !logic.isGoalLoading) const Icon(Icons.navigate_next_rounded)
          ],
        ),
      ),
    );
  }


  _widgetReferral(MixedController logic,BuildContext context,BoxConstraints constraints) {
    return InkWell(
      onTap: () {
        if (logic.referralListData.isNotEmpty ) {
          Get.toNamed(AppRoutes.referralList,
              arguments: [logic.serverUrlDataList, logic.referralListData,logic.conditionDataList]);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
            vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.05, constraints):Sizes.height_0_0_5),
        padding: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.8, constraints) : Sizes.width_3,
            vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.0, constraints): Sizes.height_2),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CColor.primaryColor30,
              ),
              child: Image.asset(
                Constant.settingReferralIcons,
                height:  (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.3, constraints) : Sizes.height_2,
                width:  (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.3, constraints) : Sizes.height_2,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        /*(logic.isReferralLoading) ? Constant.settingReferral :
                        (logic.referralListData.isEmpty) ? "${Constant
                            .settingReferral} (None)" : Constant.settingReferral,*/
                        overflow: TextOverflow.ellipsis,
                        (logic.isReferralLoading)
                            ? Constant.settingReferral
                            : (logic.referralListData.isEmpty)
                                ? "${Constant.settingReferral} (None)"
                                : "${Constant.settingReferral} (Active: ${logic.referralListData.where((element) => element.status == Constant.statusActive).toList().length})",
                        style: AppFontStyle.styleW600(CColor.black,
                            (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.4,constraints) : FontSize.size_12),
                      ),
                    ),
                    (logic.isReferralLoading)
                        ?
                    Lottie.asset(
                        Constant.progressLoader, height: Sizes.height_4,delegates: LottieDelegates(
                    values: [
                    ValueDelegate.color(
                    const ['**', 'Ellipse 1', '**'],
                    value: CColor.primaryColor,
                    ),
                  ],
                ),)
                        : Container(),
                  ],
                ),
              ),
            ),
            if(logic.referralListData.isNotEmpty &&
                !logic.isReferralLoading) const Icon(
                Icons.navigate_next_rounded)
          ],
        ),
      ),
    );
  }

  _widgetCondition(MixedController logic,BuildContext context,BoxConstraints constraints) {
    return InkWell(
      onTap: () {
        if (logic.conditionDataList.isNotEmpty /*&& !logic.isConditionLoading*/) {
          Get.toNamed(AppRoutes.conditionList,
              arguments: [logic.serverUrlDataList, logic.conditionDataList]);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
            vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.05, constraints):Sizes.height_0_0_5),
        padding: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.8, constraints) : Sizes.width_3,
            vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.0, constraints): Sizes.height_2),
        child: Row(
          children: [
            Container(
              padding:  EdgeInsets.all((kIsWeb) ? AppFontStyle.sizesFontManageWeb(0.7, constraints) : 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CColor.primaryColor30,
              ),
              child: Image.asset(
                Constant.settingConditionIcons,
                height:  (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.3, constraints) : Sizes.height_2,
                width:  (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.3, constraints) : Sizes.height_2,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        /*(logic.isConditionLoading) ? Constant.settingCondition :
                        (logic.conditionDataList.isEmpty) ? "${Constant
                            .settingCondition} (None)" : Constant
                            .settingCondition,*/
                        overflow: TextOverflow.ellipsis,
                        (logic.isConditionLoading) ? Constant.settingCondition:
                        (logic.conditionDataList.isEmpty)
                                ? "${Constant.settingCondition} (None)"
                                : "${Constant.settingCondition} (Active: ${logic.conditionDataList.where((element) => element.verificationStatus == Constant.verificationStatusConfirmed).toList().length})",
                        style: AppFontStyle.styleW600(CColor.black,
                            (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.4,constraints) : FontSize.size_12),
                      ),
                    ),
                    (logic.isConditionLoading)
                        ?
                    Lottie.asset(
                        Constant.progressLoader, height: Sizes.height_4,delegates: LottieDelegates(
                      values: [
                        ValueDelegate.color(
                          const ['**', 'Ellipse 1', '**'],
                          value: CColor.primaryColor,
                        ),
                      ],
                    ),)
                        : Container(),
                  ],
                ),
              ),
            ),
            if(logic.conditionDataList.isNotEmpty &&
                !logic.isConditionLoading) const Icon(
                Icons.navigate_next_rounded)
          ],
        ),
      ),
    );
  }

  _widgetCarePlan(MixedController logic,BuildContext context,BoxConstraints constraints) {
    return InkWell(
      onTap: () {
        if (logic.careDataList.isNotEmpty /*&& !logic.isCarePlanLoading*/) {
          Get.toNamed(AppRoutes.carePlanList,
              arguments: [logic.serverUrlDataList, logic.careDataList,logic.goalDataList]);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
            vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.05, constraints):Sizes.height_0_0_5),
        padding: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.8, constraints) : Sizes.width_3,
            vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.0, constraints): Sizes.height_2),
        child: Row(
          children: [
            Container(
              padding:  EdgeInsets.all((kIsWeb) ? AppFontStyle.sizesFontManageWeb(0.7, constraints) : 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CColor.primaryColor30,
              ),
              child: Image.asset(
                Constant.settingCarePlanIcons,
                height:  (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.3, constraints) : Sizes.height_2,
                width:  (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.3, constraints) : Sizes.height_2,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        /*(logic.isCarePlanLoading) ? Constant.settingCarePlan :
                        (logic.careDataList.isEmpty) ? "${Constant
                            .settingCarePlan} (None)" : Constant.settingCarePlan,*/
                        overflow: TextOverflow.ellipsis,
                        (logic.isCarePlanLoading) ? Constant.settingCarePlan:
                        (logic.careDataList.isEmpty)
                                ? "${Constant.settingCarePlan} (None)"
                                : "${Constant.settingCarePlan} (Active: ${logic.careDataList.where((element) => element.status == Constant.statusActive).toList().length})",
                        style: AppFontStyle.styleW600(CColor.black,
                            (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.4,constraints) : FontSize.size_12),
                      ),
                    ),
                    (logic.isCarePlanLoading)
                        ?
                    Lottie.asset(
                        Constant.progressLoader, height: Sizes.height_4,delegates: LottieDelegates(
                      values: [
                        ValueDelegate.color(
                          const ['**', 'Ellipse 1', '**'],
                          value: CColor.primaryColor,
                        ),
                      ],
                    ),)
                        : Container(),
                  ],
                ),
              ),
            ),
            if(logic.careDataList.isNotEmpty &&
                !logic.isCarePlanLoading) const Icon(
                Icons.navigate_next_rounded)

          ],
        ),
      ),
    );
  }

  _widgetRxData(MixedController logic,BuildContext context,BoxConstraints constraints) {
    return InkWell(
      onTap: () {
        if (logic.rxDataList.isNotEmpty) {
          Get.toNamed(AppRoutes.exerciseDataList,arguments: [logic.rxDataList]);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
            vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.05, constraints):Sizes.height_0_0_5),
        padding: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.8, constraints) : Sizes.width_3,
            vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.0, constraints): Sizes.height_2),
        child: Row(
          children: [
            Container(
              padding:  EdgeInsets.all((kIsWeb) ? AppFontStyle.sizesFontManageWeb(0.7, constraints) : 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CColor.primaryColor30,
              ),
              child: Image.asset(
                Constant.settingCarePlanIcons,
                height:  (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.3, constraints) : Sizes.height_2,
                width:  (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.3, constraints) : Sizes.height_2,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        /*(logic.isRxLoading) ? Constant.settingRx :
                        (logic.rxDataList.isEmpty) ? "${Constant
                            .settingRx} (None)" : Constant.settingRx,*/
                        overflow: TextOverflow.ellipsis,
                        (logic.isRxLoading)
                            ? Constant
                            .settingRx
                            : (logic.rxDataList
                            .isEmpty)
                            ? "${Constant.settingRx} (None)"
                            : "${Constant.settingRx} (Active: ${logic.rxDataList.where((element) => element.status == Constant.statusActive).toList().length})",
                        style: AppFontStyle.styleW600(CColor.black,
                            (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.4,constraints) : FontSize.size_12),
                      ),
                    ),
                    (logic.isRxLoading)
                        ?
                    Lottie.asset(
                      Constant.progressLoader, height: Sizes.height_4,delegates: LottieDelegates(
                      values: [
                        ValueDelegate.color(
                          const ['**', 'Ellipse 1', '**'],
                          value: CColor.primaryColor,
                        ),
                      ],
                    ),)
                        : Container(),
                  ],
                ),
              ),
            ),
            if(logic.rxDataList.isNotEmpty &&
                !logic.isRxLoading) const Icon(
                Icons.navigate_next_rounded)

          ],
        ),
      ),
    );
  }
}
