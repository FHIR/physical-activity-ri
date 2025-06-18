import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/ui/ExercisePrescription/dataModel/exercisePrescriptionDataModel.dart';
import 'package:banny_table/ui/carePlanForm/datamodel/carePlanSyncDataModel.dart';
import 'package:banny_table/ui/conditionForm/datamodel/conditionSyncDataModel.dart';
import 'package:banny_table/ui/goalForm/datamodel/goalDataModel.dart';
import 'package:banny_table/ui/patientIndependentMode/datamodel/ToDoListDatamodel.dart';
import 'package:banny_table/ui/referralForm/datamodel/referralDataModel.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import '../../../bottomNavigation/controllers/bottom_navigation_controller.dart';
import '../controllers/home_controllers.dart';
import 'package:lottie/lottie.dart';



class HomeScreen extends StatelessWidget {
  BottomNavigationController? bottomNavigationController;

  HomeScreen({super.key, @required this.bottomNavigationController});

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    return Theme(
      data: ThemeData(
          useMaterial3: false
      ),
      child: LayoutBuilder(
        builder: (BuildContext context,BoxConstraints constraints) {
          return GetBuilder<HomeControllers>(
              init: HomeControllers(),
              builder: (logic) {
            return Scaffold(
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
                  child:  Icon(Icons.add),
                  fabSize: ExpandableFabSize.regular,
                  foregroundColor: CColor.white,
                  backgroundColor: CColor.primaryColor,
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
                            offset: Offset(0, 1),
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
                children: (orientation == Orientation.portrait || kIsWeb) ? [
                  _widgetContainerBox("Patient Task ",constraints,(value){
                    Debug.printLog("Patient Task");
                    final state = logic.keyFabButton.currentState;
                    if (state != null) {
                      debugPrint('isOpen:${state.isOpen}');
                      state.toggle();
                    }
                    Get.toNamed(AppRoutes.toDoFormScreen, arguments: [null, Constant.todoFromSetting])!.then((value) {
                      // logic.callPatientTaskAPI();
                      logic.updateMethod();
                    });
                  }),
                  _widgetContainerBox("Referral",constraints,(value){
                    Debug.printLog("Referral");
                    final state = logic.keyFabButton.currentState;
                    if (state != null) {
                      debugPrint('isOpen:${state.isOpen}');
                      state.toggle();
                    }
                    Get.toNamed(AppRoutes.referralForm, arguments: [null,logic.conditionDataListLocal])!.then((value) {
                      // logic.callReferralAPI();
                      logic.updateMethod();

                    });
                  }),
                  _widgetContainerBox("Exercise Rx",constraints,(value){
                    Debug.printLog("Exercise");
                    final state = logic.keyFabButton.currentState;
                    if (state != null) {
                      debugPrint('isOpen:${state.isOpen}');
                      state.toggle();
                    }
                    Get.toNamed(AppRoutes.exercisePrescriptionFrom, arguments: [null])!.then((value) {
                      // logic.callExercisePrescriptionAPI();
                      logic.updateMethod();

                    });
                  }),
                  _widgetContainerBox("Activity plan",constraints,(value){
                    Debug.printLog("Physical activity plan");
                    final state = logic.keyFabButton.currentState;
                    if (state != null) {
                      debugPrint('isOpen:${state.isOpen}');
                      state.toggle();
                    }
                    Get.toNamed(AppRoutes.carePlanForm, arguments: [null,logic.goalDataListLocal])!.then((value) {
                      // logic.callCarePlanAPI();
                      logic.updateMethod();

                    });
                  }),
                  _widgetContainerBox("Goal",constraints,(value){
                    Debug.printLog("Goal");
                    final state = logic.keyFabButton.currentState;
                    if (state != null) {
                      debugPrint('isOpen:${state.isOpen}');
                      state.toggle();
                    }
                    Get.toNamed(AppRoutes.goalForm, arguments: [null,true])!.then((value) {
                      // logic.callGoalAPI();
                      logic.updateMethod();

                    });
                  }),
                  _widgetContainerBox("Condition",constraints,(value){
                    Debug.printLog("Condition");
                    final state = logic.keyFabButton.currentState;
                    if (state != null) {
                      debugPrint('isOpen:${state.isOpen}');
                      state.toggle();
                    }
                    Get.toNamed(AppRoutes.conditionForm, arguments: [null])!.then((value) {
                      // logic.callConditionAPI();
                      logic.updateMethod();
                    });
                  }),
                ]:
                [
                  Row(
                    children: [

                      Column(
                        children: [
                          _widgetContainerBox("Patient Task ",constraints,(value){
                            Debug.printLog("Patient Task");
                            final state = logic.keyFabButton.currentState;
                            if (state != null) {
                              debugPrint('isOpen:${state.isOpen}');
                              state.toggle();
                            }
                            Get.toNamed(AppRoutes.toDoFormScreen, arguments: [null, Constant.todoFromSetting])!.then((value) {
                              // logic.callPatientTaskAPI();
                              logic.updateMethod();
                            });
                          }),
                          Container(
                            margin: EdgeInsets.only(
                                top: Sizes.height_1
                            ),
                            child: _widgetContainerBox("Referral",constraints,(value){
                              Debug.printLog("Referral");
                              final state = logic.keyFabButton.currentState;
                              if (state != null) {
                                debugPrint('isOpen:${state.isOpen}');
                                state.toggle();
                              }
                              Get.toNamed(AppRoutes.referralForm, arguments: [null,logic.conditionDataListLocal])!.then((value) {
                                // logic.callReferralAPI();
                                logic.updateMethod();

                              });
                            }),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: Sizes.height_1
                            ),
                            child: _widgetContainerBox("Goal",constraints,(value){
                              Debug.printLog("Goal");
                              final state = logic.keyFabButton.currentState;
                              if (state != null) {
                                debugPrint('isOpen:${state.isOpen}');
                                state.toggle();
                              }
                              Get.toNamed(AppRoutes.goalForm, arguments: [null,true])!.then((value) {
                                // logic.callGoalAPI();
                                logic.updateMethod();

                              });
                            }),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: Sizes.width_3,right: Sizes.width_5
                        ),
                        child: Column(
                          children: [
                            _widgetContainerBox("Exercise Rx",constraints,(value){
                              Debug.printLog("Exercise");
                              final state = logic.keyFabButton.currentState;
                              if (state != null) {
                                debugPrint('isOpen:${state.isOpen}');
                                state.toggle();
                              }
                              Get.toNamed(AppRoutes.exercisePrescriptionFrom, arguments: [null])!.then((value) {
                                // logic.callExercisePrescriptionAPI();
                                logic.updateMethod();

                              });
                            }),
                            Container(
                              margin: EdgeInsets.only(
                                  top: Sizes.height_1
                              ),
                              child: _widgetContainerBox("Physical activity plan",constraints,(value){
                                Debug.printLog("Physical activity plan");
                                final state = logic.keyFabButton.currentState;
                                if (state != null) {
                                  debugPrint('isOpen:${state.isOpen}');
                                  state.toggle();
                                }
                                Get.toNamed(AppRoutes.carePlanForm, arguments: [null,logic.goalDataListLocal])!.then((value) {
                                  // logic.callCarePlanAPI();
                                  logic.updateMethod();

                                });
                              }),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: Sizes.height_1
                              ),
                              child: _widgetContainerBox("Condition",constraints,(value){
                                Debug.printLog("Condition");
                                final state = logic.keyFabButton.currentState;
                                if (state != null) {
                                  debugPrint('isOpen:${state.isOpen}');
                                  state.toggle();
                                }
                                Get.toNamed(AppRoutes.conditionForm, arguments: [null])!.then((value) {
                                  // logic.callConditionAPI();
                                  logic.updateMethod();

                                });
                              }),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                ],
              ),
              body: SafeArea(
                  child:Container(
                        margin: EdgeInsets.only(
                          left: (kIsWeb ) ?AppFontStyle.sizesWidthManageWeb(1.2, constraints) :Sizes.width_4,
                          right: (kIsWeb ) ?AppFontStyle.sizesWidthManageWeb(1.2, constraints) :Sizes.width_4,
                        ),
                        child: Utils.pullToRefreshApi(_widgetHomeScreen(logic,context,constraints), logic.refreshController, logic.onRefresh, logic.onLoading),
                      ),

              ),
            );
          });
        }
      ),
    );
  }

  _widgetHomeScreen(HomeControllers logic, BuildContext context,BoxConstraints constraints){
    return SingleChildScrollView(
      child: Column(
        children: [
          _widgetMainConditions(logic,context,constraints),
          _widgetMainGoals(logic,context,constraints),
          _widgetMainCarePlans(logic,context,constraints),
          _widgetMainRx(logic,context,constraints),
          _widgetMainReferrals(logic,context,constraints),
          _widgetMainPatientTasks(logic,context,constraints),
        ],
      ),
    );
  }

  _widgetMainConditions(HomeControllers logic, BuildContext context,BoxConstraints constraints){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.2, constraints): Sizes.height_2_1),
      decoration: BoxDecoration(
        border: Border.all(color: CColor.txtGray50, width: 1),
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(7),
            topRight: Radius.circular(7)),
      ),
      child: InkWell(
        enableFeedback: logic.conditionDataListLocal.isEmpty ? true: false,
        onTap: (){
          if(logic.conditionDataListLocal.isEmpty){
            Get.toNamed(AppRoutes.conditionForm, arguments: [null])!.then((value) {
              // logic.getConditionDataList(false);
            });
          }
        },
        child: IgnorePointer(
          ignoring: (logic.conditionDataListLocal.isEmpty
              && !logic.isConditionProgress || logic.isConditionLoading) ? true: false,
          child: ExpansionTile(
            // maintainState: false,
            trailing: Icon(Icons.keyboard_arrow_down_sharp,size: (logic.conditionDataList.isEmpty
                && !logic.isConditionProgress || logic.isConditionLoading) ? 0.0 : (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(2.0, constraints): Sizes.height_2_5,),
            onExpansionChanged: (value){
              Debug.printLog("value expanded......$value");
              if(!value){
                logic.fliterUnselectApply(Constant.homeConditions);
                logic.conditionViewExpanded(false);
              }else{
                logic.conditionViewExpanded(true);
              }
              // logic.getConditionDataList(value);
            },
            title: Row(
              children: [
                Expanded(
                  child: Container(
                    margin:
                    EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    (logic.isConditionLoading) ? Constant.homeConditions:
                                    (logic.conditionDataListLocal.isEmpty) ? "${Constant.homeConditions} (None)" :"${Constant.homeConditions} (Active: ${logic.conditionDataListLocal.where((element) => element.verificationStatus == Constant.verificationStatusConfirmed).toList().length})",
                                    style: AppFontStyle.styleW700(
                                        CColor.primaryColor,
                                        (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.4,constraints):FontSize.size_13),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  (logic.isConditionLoading) ?
                                  Lottie.asset(Constant.progressLoader,height: Sizes.height_5_4) : Container(),
                                ],
                              ),
                            ),
                            (logic.isConditionProgress) ?
                            InkWell(
                              onTap: () {
                                showFilterDialog(logic, context,Constant.homeConditions,constraints);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  Icons.filter_list_rounded,
                                  color: CColor.primaryColor,
                                  size:(kIsWeb) ?AppFontStyle.sizesFontManageWeb(1.4,constraints): Sizes.width_5,
                                ),
                              ),
                            ) : Container()
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Icon(Icons.navigate_next_rounded)
              ],
            ),
            children: <Widget>[
              _listViewCondition(logic,constraints),
            ],
          ),
        ),
      ),
    );
  }

  _widgetMainCarePlans(HomeControllers logic, BuildContext context,BoxConstraints constraints){
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(

        border: Border(
            bottom:
            BorderSide(color: CColor.txtGray50, width: 1),
            left:
            BorderSide(color: CColor.txtGray50, width: 1),
            right: BorderSide(
                color: CColor.txtGray50, width: 1)
        ),
      ),
      child: InkWell(
        enableFeedback: logic.careDataListLocal.isEmpty ? true: false,
        onTap: (){
          if(logic.careDataListLocal.isEmpty){
            Get.toNamed(AppRoutes.carePlanForm, arguments: [null,logic.goalDataListLocal])!.then((value) {
              // logic.getCarePlanDataListLocal(false);

            });
          }
        },
        child: IgnorePointer(
          ignoring: (logic.careDataListLocal.isEmpty
              && !logic.isCarePlanProgress || logic.isCarePlanLoading) ? true: false,
          child: ExpansionTile(
            trailing: Icon(Icons.keyboard_arrow_down_sharp,size: (logic.careDataList.isEmpty
                && !logic.isCarePlanProgress || logic.isCarePlanLoading) ? 0.0 :(kIsWeb) ? AppFontStyle.sizesWidthManageWeb(2.0, constraints): Sizes.height_2_5,),
            onExpansionChanged: (value){
              Debug.printLog("value expanded......$value");
              if(!value){
                logic.fliterUnselectApply(Constant.homeCarePlans);
                logic.carePlansViewExpanded(false);
              }else{
                logic.carePlansViewExpanded(true);
              }
              // logic.getCarePlanDataListLocal(value);
            },
            title: Row(
              children: [
                Expanded(
                  child: Container(
                    margin:
                    EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_2),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  (kIsWeb) ?
                                  Row(
                                    children: [
                                      Text(
                                        (logic.isCarePlanLoading) ? Constant.homeCarePlans:
                                        (logic.careDataListLocal.isEmpty) ? "${Constant.homeCarePlans} (None)" :"${Constant.homeCarePlans} (Active: ${logic.careDataListLocal.where((element) => element.status == Constant.statusActive).toList().length})",
                                        style: AppFontStyle.styleW700(
                                            CColor.primaryColor,
                                            (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.4,constraints):FontSize.size_13),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
/*                                      (logic.isCarePlanLoading) ?
                                      Lottie.asset(Constant.progressLoader,*//*width: Sizes.width_0*//*height: Sizes.height_5_4) : Container(),*/
                                    ],
                                  ) :
                                  Container(
                                    padding: EdgeInsets.only(
                                        bottom: Sizes.height_0_4,
                                        top: Sizes.height_0_4),
                                    child: RichText(
                                      // textAlign: TextAlign.right,
                                      text: TextSpan(
                                        text: Constant
                                            .homeCarePlans,
                                        style: AppFontStyle.styleW700(
                                            CColor.primaryColor,
                                            (kIsWeb)
                                                ? AppFontStyle
                                                .sizesFontManageWeb(
                                                1.4, constraints)
                                                : FontSize.size_13),
                                        children: [
                                          TextSpan(
                                            text: (logic
                                                .isCarePlanLoading)
                                                ? ""
                                                : (logic.careDataListLocal
                                                .isEmpty)
                                                ? "\n(None)"
                                                : "\n(Active: ${logic.careDataListLocal.where((element) => element.status == Constant.statusActive).toList().length})",
                                            style: TextStyle(
                                                color:
                                                CColor.primaryColor,
                                                fontSize: (kIsWeb)
                                                    ? AppFontStyle
                                                    .sizesFontManageWeb(
                                                    1.35,
                                                    constraints)
                                                    : FontSize.size_12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  (logic.isCarePlanLoading) ?
                                  Lottie.asset(Constant.progressLoader,/*width: Sizes.width_0*/height: Sizes.height_5_4) : Container(),
                                ],
                              ),

                            ),
                            (logic.isCarePlanProgress) ?
                            InkWell(
                              onTap: () {
                                showFilterDialog(logic, context,Constant.homeCarePlans,constraints);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  Icons.filter_list_rounded,
                                  color: CColor.primaryColor,
                                  size:(kIsWeb) ?AppFontStyle.sizesFontManageWeb(1.4,constraints): Sizes.width_5,
                                ),
                              ),
                            ) : Container()
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Icon(Icons.navigate_next_rounded)
              ],
            ),
            children: <Widget>[
              _listViewCarePlan(logic,constraints),
            ],
          ),
        ),
      ),
    );
  }

  _widgetMainRx(HomeControllers logic, BuildContext context,BoxConstraints constraints){
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
            bottom:
            BorderSide(color: CColor.txtGray50, width: 1),
            left:
            BorderSide(color: CColor.txtGray50, width: 1),
            right: BorderSide(
                color: CColor.txtGray50, width: 1)),
      ),
      child: InkWell(
        enableFeedback: logic.exerciseListDataLocal.isEmpty ? true: false,
        onTap: (){
          if(logic.exerciseListDataLocal.isEmpty){
            Get.toNamed(AppRoutes.exercisePrescriptionFrom, arguments: [null])!.then((value) {
              // logic.getExerciseFormData(false);
            });
          }
        },
        child: IgnorePointer(
          ignoring: (logic.exerciseListDataLocal.isEmpty
              && !logic.isExerciseProgress || logic.isExerciseLoading) ? true: false,
          child: ExpansionTile(
            trailing: Icon(Icons.keyboard_arrow_down_sharp,size: (logic.exerciseListData.isEmpty
                && !logic.isExerciseProgress || logic.isExerciseLoading) ? 0.0 : (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(2.0, constraints):Sizes.height_2_5,),
            onExpansionChanged: (value){
              Debug.printLog("value expanded......$value");
              if(!value){
                logic.fliterUnselectApply(Constant.homeExercisePrescription);
                logic.rxViewExpanded(false);
              }else{
                logic.rxViewExpanded(true);
              }
              // logic.getExerciseFormData(value);
            },
            title: Container(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin:
                      EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_2),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    (kIsWeb)? Row(
                                      children: [
                                        Text(
                                          (logic.isExerciseLoading)
                                              ? Constant
                                                  .homeExercisePrescription
                                              : (logic.exerciseListDataLocal
                                                      .isEmpty)
                                                  ? "${Constant.homeExercisePrescription} (None)"
                                                  : "${Constant.homeExercisePrescription} (Active: ${logic.exerciseListData.where((element) => element.status == Constant.statusActive).toList().length})",
                                          style: AppFontStyle.styleW700(
                                              CColor.primaryColor,
                                              (kIsWeb)
                                                  ? AppFontStyle
                                                      .sizesFontManageWeb(
                                                          1.4,
                                                          constraints)
                                                  : FontSize.size_13),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    )
                                        : Container(
                                            padding: EdgeInsets.only(
                                                bottom: Sizes.height_0_4,
                                                top: Sizes.height_0_4),
                                            child: RichText(
                                              // textAlign: TextAlign.right,
                                              text: TextSpan(
                                                text: Constant
                                                    .homeExercisePrescription,
                                                style: AppFontStyle.styleW700(
                                                    CColor.primaryColor,
                                                    (kIsWeb)
                                                        ? AppFontStyle
                                                            .sizesFontManageWeb(
                                                                1.4, constraints)
                                                        : FontSize.size_13),
                                                children: [
                                                  TextSpan(
                                                    text: (logic
                                                            .isExerciseLoading)
                                                        ? ""
                                                        : (logic.exerciseListDataLocal
                                                                .isEmpty)
                                                            ? "\n(None)"
                                                            : "\n(Active: ${logic.exerciseListData.where((element) => element.status == Constant.statusActive).toList().length})",
                                                    style: TextStyle(
                                                        color:
                                                            CColor.primaryColor,
                                                        fontSize: (kIsWeb)
                                                            ? AppFontStyle
                                                                .sizesFontManageWeb(
                                                                    1.35,
                                                                    constraints)
                                                            : FontSize.size_12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                    /*Expanded(
                                      child: Text(
                                        (logic.isExerciseLoading)
                                            ? Constant.homeExercisePrescription
                                            : (logic.exerciseListDataLocal
                                                    .isEmpty)
                                                ? "${Constant.homeExercisePrescription} (None)"
                                                : "${Constant.homeExercisePrescription} (Active: ${logic.exerciseListData.where((element) => element.status == Constant.statusActive).toList().length})",
                                        textAlign: TextAlign.start,
                                        style: AppFontStyle.styleW700(
                                            CColor.primaryColor,
                                            (kIsWeb)?Utils.sizesFontManage(context,3.0):FontSize.size_12),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),*/
                                    (logic.isExerciseLoading) ?
                                    Lottie.asset(Constant.progressLoader,/*width: Sizes.width_0*/height: Sizes.height_5_4) : Container(),
                                    // if(logic.isExerciseLoading) Expanded(child: Container())
                                  ],
                                ),
                              ),
                              (logic.isExerciseProgress) ?
                              InkWell(
                                onTap: () {
                                  showFilterDialog(logic, context,Constant.homeExercisePrescription,constraints);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.filter_list_rounded,
                                    color: CColor.primaryColor,
                                    size:(kIsWeb) ?AppFontStyle.sizesFontManageWeb(1.4,constraints): Sizes.width_5,
                                  ),
                                ),
                              ) : Container()
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            children: <Widget>[
              _listExerciseForm(logic, context,constraints),
            ],
          ),
        ),
      ),
    );
  }

  _widgetMainGoals(HomeControllers logic, BuildContext context,BoxConstraints constraints){
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
            bottom:
            BorderSide(color: CColor.txtGray50, width: 1),
            left:
            BorderSide(color: CColor.txtGray50, width: 1),
            right: BorderSide(
                color: CColor.txtGray50, width: 1)),
      ),
      child: InkWell(
        enableFeedback: logic.goalDataListLocal.isEmpty ? true: false,
        onTap: (){
          if(logic.goalDataListLocal.isEmpty){
            Get.toNamed(AppRoutes.goalForm, arguments: [null,true])!.then((value) {
              // logic.getGoalDataList(false);
            });
          }
        },
        child: IgnorePointer(
          ignoring: (logic.goalDataListLocal.isEmpty && !logic.isGoalProgress || logic.isGoalLoading) ? true: false,
          child: ExpansionTile(
            trailing: Icon(Icons.keyboard_arrow_down_sharp,size: (logic.goalDataList.isEmpty
                && !logic.isGoalProgress || logic.isGoalLoading) ? 0.0 :(kIsWeb) ? AppFontStyle.sizesWidthManageWeb(2.0, constraints): Sizes.height_2_5,),
            onExpansionChanged: (value){
              Debug.printLog("value expanded......$value");
              if(!value){
                logic.fliterUnselectApply(Constant.homeGoals);
                logic.goalViewExpanded(false);
              }else{
                logic.goalViewExpanded(true);
              }
              // logic.getGoalDataList(value);
            },
            title: Row(
              children: [
                Expanded(
                  child: Container(
                    margin:
                    EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_2),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    (logic.isGoalLoading) ? Constant.homeGoals:
                                    (logic.goalDataListLocal.isEmpty) ? "${Constant.homeGoals} (None)" :"${Constant.homeGoals} (Active: ${logic.goalDataListLocal.where((element) => element.lifeCycleStatus == Constant.lifeCycleActive).toList().length})",
                                    style: AppFontStyle.styleW700(
                                        CColor.primaryColor,
                                        (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.4,constraints):FontSize.size_13),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  (logic.isGoalLoading) ?
                                  Lottie.asset(Constant.progressLoader,/*width: Sizes.width_0*/height: Sizes.height_5_4) : Container(),
                                ],
                              ),
                            ),
                            (logic.isGoalProgress) ?
                            InkWell(
                              onTap: () {
                                showFilterDialog(logic, context,Constant.homeGoals,constraints);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  Icons.filter_list_rounded,
                                  color: CColor.primaryColor,
                                  size:(kIsWeb) ?AppFontStyle.sizesFontManageWeb(1.4,constraints): Sizes.width_5,
                                ),
                              ),
                            ) : Container()
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Icon(Icons.navigate_next_rounded)
              ],
            ),
            children: <Widget>[
              _listViewGoal(logic,constraints),

            ],
          ),
        ),
      ),
    );
  }

  _widgetMainReferrals(HomeControllers logic, BuildContext context,BoxConstraints constraints){
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
            bottom:
            BorderSide(color: CColor.txtGray50, width: 1),
            left:
            BorderSide(color: CColor.txtGray50, width: 1),
            right: BorderSide(
                color: CColor.txtGray50, width: 1)),

      ),
      child: InkWell(
        enableFeedback: logic.referralListDataLocal.isEmpty ? true: false,
        onTap: (){
          if(logic.referralListDataLocal.isEmpty){
            Get.toNamed(AppRoutes.referralForm, arguments: [null,logic.conditionDataListLocal])!.then((value) {
              // logic.getReferralFormData(false);
            });
          }
        },
        child: IgnorePointer(
          ignoring: (logic.referralListDataLocal.isEmpty && !logic.isReferralProgress  || logic.isReferralLoading) ? true: false,
          child: ExpansionTile(
            trailing: Icon(Icons.keyboard_arrow_down_sharp,size: (logic.referralListData.isEmpty
                && !logic.isReferralProgress || logic.isReferralLoading) ? 0.0 : (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(2.0, constraints):Sizes.height_2_5,),
            onExpansionChanged: (value){
              Debug.printLog("value expanded......$value");
              if(!value){
                logic.fliterUnselectApply(Constant.homeReferral);
                logic.referralViewExpanded(false);
              }else{
                logic.referralViewExpanded(true);
              }
              // logic.getReferralFormData(value);
            },
            title: Container(
              margin:
              EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_2),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              (logic.isReferralLoading) ? Constant.homeReferral:
                              // (logic.referralListDataLocal.isEmpty) ? "${Constant.homeReferral} (None)" :Constant.homeReferral,
                              (logic.referralListDataLocal.isEmpty) ? "${Constant.homeReferral} (None)" :"${ Constant.homeReferral} (Active: ${logic.referralListDataLocal.where((element) => element.status == Constant.statusActive).toList().length})",

                              style: AppFontStyle.styleW700(
                                  CColor.primaryColor,
                                  (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.4,constraints):FontSize.size_13),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            (logic.isReferralLoading) ?
                            Lottie.asset(Constant.progressLoader,/*width: Sizes.width_0*/height: Sizes.height_5_4) : Container(),
                          ],
                        ),
                      ),
                      (logic.isReferralProgress) ?
                      InkWell(
                        onTap: () {
                          showFilterDialog(logic, context,Constant.homeReferral,constraints);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.filter_list_rounded,
                            color: CColor.primaryColor,
                            size:(kIsWeb) ?AppFontStyle.sizesFontManageWeb(1.4,constraints): Sizes.width_5,
                          ),
                        ),
                      ) : Container()
                    ],
                  ),
                ],
              ),
            ),
            children: <Widget>[
              _listAssignedReferralForm(logic, context,constraints),
            ],
          ),
        ),
      ),
    );
  }

  _widgetMainPatientTasks(HomeControllers logic, BuildContext context,BoxConstraints constraints){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
          bottom: Sizes.height_10
      ),
      decoration: const BoxDecoration(
        border: Border(
            bottom:
            BorderSide(color: CColor.txtGray50, width: 1),
            left:
            BorderSide(color: CColor.txtGray50, width: 1),
            right: BorderSide(
                color: CColor.txtGray50, width: 1)),
      ),
      child: InkWell(
        enableFeedback: logic.patientTaskDataListLocal.isEmpty ? true: false,
        onTap: (){
          if(logic.patientTaskDataListLocal.isEmpty){
            Get.toNamed(AppRoutes.toDoFormScreen, arguments: [null, Constant.todoFromSetting])!.then((value) {
              // logic.callPatientTaskAPI();
            });
          }
        },
        child: IgnorePointer(
          ignoring: (logic.patientTaskDataListLocal.isEmpty && !logic.isPatientTaskProgress || logic.isPatientTaskLoading) ? true: false,
          child: ExpansionTile(
            trailing: Icon(Icons.keyboard_arrow_down_sharp,size: (logic.patientTaskDataList.isEmpty && !logic.isPatientTaskProgress || logic.isPatientTaskLoading) ? 0.0 : (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(2.0, constraints): Sizes.height_2_5,),
            onExpansionChanged: (value){
              Debug.printLog("value expanded......$value");
              if(!value){
                logic.fliterUnselectApply(Constant.homePatientTask);
                logic.patientTaskViewExpanded(false);
              }else{
                logic.patientTaskViewExpanded(true);
              }
              // logic.getPatientTaskAPI(value);
            },
            title: Row(
              children: [
                Expanded(
                  child: Container(
                    margin:
                    EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_2),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    (logic.isPatientTaskLoading) ? Constant.homePatientTask:
                                    (logic.patientTaskDataListLocal.isEmpty) ? "${Constant.homePatientTask} (None)" :"${Constant.homePatientTask} (Active: ${logic.patientTaskDataListLocal.where((element) => element.status == Constant.toDoStatusReady || element.status == Constant.toDoStatusInProgress).toList().length})",
                                    textAlign: TextAlign.start,
                                    style: AppFontStyle.styleW700(
                                        CColor.primaryColor,
                                        (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.4,constraints):FontSize.size_13),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  (logic.isPatientTaskLoading) ?
                                  Lottie.asset(Constant.progressLoader,/*width: Sizes.width_0*/height: Sizes.height_5_4) : Container(),
                                ],
                              ),
                            ),
                            (logic.isPatientTaskProgress) ?
                            InkWell(
                              onTap: () {
                                showFilterDialog(logic, context,Constant.homePatientTask,constraints);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  Icons.filter_list_rounded,
                                  color: CColor.primaryColor,
                                  size:(kIsWeb) ?AppFontStyle.sizesFontManageWeb(1.4,constraints): Sizes.width_5,
                                ),
                              ),
                            ) : Container()
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Icon(Icons.navigate_next_rounded)
              ],
            ),
            children: <Widget>[
              _listViewPatientTask(logic,constraints),
            ],
          ),
        ),
      ),
    );
  }

  _widgetContainerBox(String title,BoxConstraints constraints,
      Function callBack,) {
    return GestureDetector(
      onTap: (){
        callBack.call("");
      },
      child: Container(
        width: (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(20.0, constraints) :Sizes.width_33,
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
              overflow: TextOverflow.ellipsis,
              style: AppFontStyle.styleW500(
              CColor.white, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints) : FontSize.size_11)),
        ),
      ),
    );

  }

  void showFilterDialog(HomeControllers logic, BuildContext context,String fromType,BoxConstraints constraints) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              // backgroundColor: Colors.transparent,
              // insetPadding: const EdgeInsets.all(10),
              contentPadding: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
              content: Container(
                // margin: const EdgeInsets.all(40),
                width: Get.width * 0.15,
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                    color: CColor.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: Sizes.width_2_5),
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Text(
                                logic.shortingNameTODO(
                                logic.getFilterListStatusWise(fromType)[index].status
                                    .toString()),
                              ),
                              Checkbox(
                                value: logic.getFilterListStatusWise(fromType)[index].isSelected,
                                onChanged: (value) {
                                  logic.onChangeFilterDara(
                                      !logic.getFilterListStatusWise(fromType)[index].isSelected,
                                      index,fromType);
                                  setState(() {});
                                },
                              )
                            ],
                          );
                        },
                        shrinkWrap: true,
                        itemCount: logic.getFilterListStatusWise(fromType).length,
                        physics: const AlwaysScrollableScrollPhysics(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            "Cancel",
                            style: AppFontStyle.styleW600(
                              CColor.black,
                              (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.5, constraints): FontSize.size_12,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            logic.onChangeFilterDataTapOnOk(fromType);
                          },
                          child: Text(
                            "Ok",
                            style: AppFontStyle.styleW600(
                              CColor.black,
                              (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.5, constraints): FontSize.size_12,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  _emptyWidget(String title) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: Sizes.width_5,vertical: Sizes.height_3),
        child: Text(
          // "You can add your referral from the below + button",
          title,
          style: AppFontStyle.styleW500(
              CColor.black, (kIsWeb) ? FontSize.size_3 : FontSize.size_12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }



  ///Referral Assigned
  /// This is use For The Referral
  _listAssignedReferralForm(HomeControllers logic, BuildContext context,BoxConstraints constraints) {
    return (logic.referralListData.isEmpty)
        ? _emptyWidget("There is no referral for the selected status")
        : Container(
      color: CColor.white,
      margin: EdgeInsets.only(
          left:(kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.6, constraints): Sizes.width_1,
          right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.6, constraints):Sizes.width_1),

      child: ListView.builder(
        itemBuilder: (context, index) {
          return _itemAssignedReferralForm(
              logic.referralListData[index],
              logic,
              context,
              index,constraints);
        },
        // itemCount: (logic.referralListData.length > int.parse(Constant.historyCount.text.toString())) ? int.parse(Constant.historyCount.text.toString()) : logic.referralListData.length,
        itemCount: logic.referralListData.length,
        padding: EdgeInsets.only(bottom:(kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.9, constraints):Sizes.height_1),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }

  _itemAssignedReferralForm(ReferralSyncDataModel referralListData,
      HomeControllers logic, BuildContext context, int index,BoxConstraints constraints) {
    return GestureDetector(
      onTap: () async {
        var value = await Get.toNamed(AppRoutes.referralAssignedFormScreen, arguments: [referralListData,logic.conditionDataListLocal]);
        if (value != null) {
          logic.updateLocalReferralsList(value);
        } else {
          // logic.callReferralAPI();
          logic.isReferralProgress = true;
          logic.fliterUnselectApply(Constant.homeReferral);
        }
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
            horizontal: (kIsWeb)
                ? AppFontStyle.sizesWidthManageWeb(1.1, constraints)
                : Sizes.width_3,
            vertical: (kIsWeb)
                ? AppFontStyle.sizesHeightManageWeb(0.5, constraints)
                : Sizes.height_0_5),
        padding: EdgeInsets.symmetric(
            horizontal: (kIsWeb)
                ? AppFontStyle.sizesWidthManageWeb(1.0, constraints)
                : Sizes.width_3,
            vertical: (kIsWeb)
                ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                : Sizes.height_1),
        width: double.infinity,
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: Sizes.height_1),
                  padding: EdgeInsets.only(top: Sizes.height_1,
                      bottom: Sizes.height_1),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: CColor.primaryColor30,
                        ),
                        child: Image.asset(
                          Constant.icHomeReferrals,
                          height: (kIsWeb)
                              ? AppFontStyle.sizesWidthManageWeb(
                              1.3, constraints)
                              : Sizes.height_2,
                          width: (kIsWeb)
                              ? AppFontStyle.sizesWidthManageWeb(
                              1.3, constraints)
                              : Sizes.height_2,
                        ),
                      ),
                      (referralListData.priority == Constant.priorityUrgent)
                          ? Container(
                          margin: EdgeInsets.only(left: Sizes.width_2,top: Sizes.height_1),
                          child: Image.asset(
                            Constant.icInformation,
                            color: CColor.red,
                            width: Sizes.height_2,
                            height: Sizes.height_2,
                          ))
                          : Container(),
                      Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                left: (kIsWeb)
                                    ? AppFontStyle.sizesWidthManageWeb(
                                    1.2, constraints)
                                    : (referralListData.priority == Constant.priorityUrgent) ?Sizes.width_2 :Sizes.width_4,
                                right: (kIsWeb)
                                    ? AppFontStyle.sizesWidthManageWeb(
                                    1.2, constraints)
                                    : Sizes.width_4),
                             alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "${referralListData.status}: ",
                                        style:  TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:(kIsWeb)
                                          ? AppFontStyle.sizesFontManageWeb(
                                              1.1, constraints)
                                          : FontSize.size_10,
                                        ),
                                      ),
                                      TextSpan(
                                        text: (referralListData.referralTypeDisplay != null)
                                            ? '${referralListData.referralTypeDisplay} '
                                            : "",
                                        style:  TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:(kIsWeb)
                                          ? AppFontStyle.sizesFontManageWeb(
                                              1.1, constraints)
                                          : FontSize.size_10,
                                        ),
                                      ),
                                      if(referralListData.performerName != null && referralListData.performerName != "")
                                      TextSpan(
                                        text: "assigned to ${referralListData.performerName} ",
                                        style:  TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:(kIsWeb)
                                          ? AppFontStyle.sizesFontManageWeb(
                                              1.1, constraints)
                                          : FontSize.size_10,
                                        ),
                                      ),
                                      TextSpan(
                                        text: (referralListData.priority == Constant.priorityUrgent)?"(${referralListData.priority})":"",
                                        style:  TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:(kIsWeb)
                                          ? AppFontStyle.sizesFontManageWeb(
                                              1.1, constraints)
                                          : FontSize.size_10,
                                        ),
                                      ),
                                    ],
                                  ),
                                  maxLines: 3,
                                ),
                                RichText(
                                  text: TextSpan(
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: (referralListData.startDate != null)
                                            ? '${DateFormat(Constant.commonDateFormatDdMmYyyy).format(referralListData.startDate!)}'
                                            : "",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: (kIsWeb)
                                              ? AppFontStyle.sizesFontManageWeb(
                                              1.0, constraints)
                                              : FontSize.size_9,
                                        ),
                                      ),
                                      TextSpan(
                                        text: (referralListData.endDate != null)
                                            ? ' to ${DateFormat(Constant.commonDateFormatDdMmYyyy).format(referralListData.endDate!)}'
                                            : "",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:(kIsWeb)
                                              ? AppFontStyle.sizesFontManageWeb(
                                              1.0, constraints)
                                              : FontSize.size_9,
                                        ),
                                      ),
                                    ],
                                  ),
                                  maxLines: 3,
                                ),
                              ],
                            ),
                          )),
                      Column(
                        children: [
                          referralListData.isCreated! ?
                          Container(
                            margin: EdgeInsets.only(
                                top: Sizes.height_0_4
                            ),
                            child: Image.asset(
                              Constant.icCreated,
                          height: (kIsWeb)
                              ? AppFontStyle.sizesWidthManageWeb(
                              1.3, constraints)
                              : Sizes.height_3,
                          width: (kIsWeb)
                              ? AppFontStyle.sizesWidthManageWeb(
                              1.5, constraints)
                              : Sizes.height_3,
                              // color: CColor.qrColorGreen,
                            ),
                          ) :
                          Container(
                            margin: EdgeInsets.only(
                                top: Sizes.height_0_4
                            ),
                            child: Image.asset(
                              Constant.icAssign,
                          height: (kIsWeb)
                              ? AppFontStyle.sizesWidthManageWeb(
                              1.3, constraints)
                              : Sizes.height_3,
                          width: (kIsWeb)
                              ? AppFontStyle.sizesWidthManageWeb(
                              1.5, constraints)
                              : Sizes.height_3,
                              // color: CColor.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }



  _listExerciseForm(HomeControllers logic, BuildContext context,BoxConstraints constraints) {
    return (logic.exerciseListData.isEmpty)
        ? _emptyWidget(
        "There is no exercise prescription for the selected status")
        : Container(
      color: CColor.white,
      margin: EdgeInsets.only(
          left:(kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.6, constraints): Sizes.width_1,
          right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.6, constraints):Sizes.width_1),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return _itemExerciseForm(
              logic.exerciseListData[index], logic, context, index,constraints);
        },
        // itemCount: (logic.exerciseListData.length > int.parse(Constant.historyCount.text.toString())) ? int.parse(Constant.historyCount.text.toString()) : logic.exerciseListData.length,
        itemCount: logic.exerciseListData.length,
        padding: EdgeInsets.only(bottom:(kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.9, constraints):Sizes.height_1),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }

  _itemExerciseForm(ExercisePrescriptionSyncDataModel exerciseListData, HomeControllers logic,
      BuildContext context, int index,BoxConstraints constraints) {
    return GestureDetector(
      onTap: () async {
/*        Get.toNamed(AppRoutes.exercisePrescriptionFrom,
            arguments: [exerciseListData])!
            .then((value) => {
              // logic.getReferralFormData(false),
          logic.isExerciseProgress = true,logic.fliterUnselectApply(Constant.homeExercisePrescription)});*/


        var value = await Get.toNamed(AppRoutes.exercisePrescriptionFrom,
            arguments: [exerciseListData]);
        if (value != null) {
          logic.updateLocalRXList(value);
        } else {
          // logic.getExerciseDataListApi();
          logic.isExerciseProgress = true;
          logic.fliterUnselectApply(Constant.homeExercisePrescription);
        }
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
            horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.1, constraints) : Sizes.width_3,
            vertical: (kIsWeb) ?AppFontStyle.sizesHeightManageWeb(0.5, constraints) :Sizes.height_1),
        padding: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
            vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.0, constraints) : Sizes.height_2),
        width: double.infinity,
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: Sizes.height_1),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding:  EdgeInsets.all((kIsWeb) ? AppFontStyle.sizesFontManageWeb(0.7, constraints) : 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: CColor.primaryColor30,
                        ),
                        child: Image.asset(
                          Constant.icHomeExercisePrescriptions,
                          height:  (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.3, constraints) : Sizes.height_2,
                          width:  (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.3, constraints) : Sizes.height_2,
                        ),
                      ),
                      Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.2, constraints) : Sizes.width_4),
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "${exerciseListData.status}: ",
                                        style:  TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:(kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.1, constraints) : FontSize.size_10,
                                        ),
                                      ),
                                      TextSpan(
                                        text: (exerciseListData.referralScope != null)
                                            ? '${exerciseListData.referralScope} '
                                            : "",
                                        style:  TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:(kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.1, constraints) : FontSize.size_10,
                                        ),
                                      ),
                                      TextSpan(
                                        text: (exerciseListData.priority == Constant.priorityUrgent)?"(${exerciseListData.priority})":"",
                                        style:  TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:(kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.1, constraints) : FontSize.size_10,
                                        ),
                                      ),
                                    ],
                                  ),
                                  maxLines: 3,
                                ),
                                RichText(
                                  text: TextSpan(
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: (exerciseListData.startDate != null)
                                            ? '${ DateFormat(Constant.commonDateFormatDdMmYyyy).format(exerciseListData.startDate!)}' : (exerciseListData.endDate != null) ? 'to ${ DateFormat(Constant.commonDateFormatDdMmYyyy).format(exerciseListData.endDate!)}'
                                            : "",
                                        style:  TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:(kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_9,
                                        ),
                                      ),
                                      TextSpan(
                                        text: (exerciseListData.endDate != null) ? ' to ${ DateFormat(Constant.commonDateFormatDdMmYyyy).format(exerciseListData.endDate!)}'
                                            : "",
                                        style:  TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:(kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_9,
                                        ),
                                      ),
                                    ],
                                  ),
                                  maxLines: 3,
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///ToDoList
  /// Assigned Tasks


  /// Created Tasks
  _listViewPatientTask(HomeControllers logic,BoxConstraints constraints) {
    return (logic.patientTaskDataList.isEmpty)
        ? _emptyWidget("There is no Patient tasks for the selected status")
        : Container(
      color: CColor.white,
      margin: EdgeInsets.only(
          left:(kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.6, constraints): Sizes.width_1,
          right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.6, constraints):Sizes.width_1),

      child: ListView.builder(
        itemBuilder: (context, index) {
          return _itemPatientTaskList(
              logic.patientTaskDataList[index], logic, index, context,constraints);
        },
        itemCount: logic.patientTaskDataList.length ,
        // itemCount: (logic.patientTaskDataList.length > int.parse(Constant.historyCount.text.toString())) ? int.parse(Constant.historyCount.text.toString()) :logic.patientTaskDataList.length,
        padding: EdgeInsets.only(bottom:(kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.9, constraints):Sizes.height_1),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }

  _itemPatientTaskList(ToDoDataListModel conditionData, HomeControllers logic,
      int index, BuildContext context,BoxConstraints constraints) {
    return GestureDetector(
      onTap: () async {
        var value = await Get.toNamed(AppRoutes.toDoFormScreen,
            arguments: [conditionData, Constant.todoFromCreated,false]);
        if (value != null) {
         logic.updateLocalToDoList(value);
        } else {
          // logic.getPatientTaskAPI(true);
          logic.isPatientTaskProgress = true;
          logic.fliterUnselectApply(Constant.homePatientTask);
        }
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
            horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.1, constraints) : Sizes.width_3,
            vertical: (kIsWeb) ?AppFontStyle.sizesHeightManageWeb(0.5, constraints) :Sizes.height_1),
        padding: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
            vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.0, constraints) : Sizes.height_2),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding:  EdgeInsets.all((kIsWeb) ? AppFontStyle.sizesFontManageWeb(0.7, constraints) : 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CColor.primaryColor30,
              ),
              child: Image.asset(
                Constant.icHomePatientTask,
                height:  (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.3, constraints) : Sizes.height_2,
                width:  (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.3, constraints) : Sizes.height_2,
              ),
            ),
            (conditionData.priority == Constant.priorityUrgent)
                ? Container(
                margin: EdgeInsets.only(left: Sizes.width_2,top: Sizes.height_1),
                child: Image.asset(
                  Constant.icInformation,
                  color: CColor.red,
                  width: Sizes.height_2,
                  height: Sizes.height_2,
                ))
                : Container(),
            Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.2, constraints)
                    : (conditionData.priority == Constant.priorityUrgent)
                        ? Sizes.width_2
                        : Sizes.width_4,
              ),
              alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*Text(
                        "${conditionData.status} ",
                        style: AppFontStyle.styleW700(
                          CColor.black,
                          (kIsWeb) ? FontSize.size_3 : FontSize.size_10,
                        ),
                      ),
                      (conditionData.statusReason != null)
                          ? Container(
                        margin: EdgeInsets.only(top: Sizes.height_0_5),
                        child: Text(
                          "Status Reason : ${conditionData.statusReason}",
                          style: AppFontStyle.styleW500(
                            CColor.black,
                            (kIsWeb) ? FontSize.size_2 : FontSize.size_9,
                          ),
                        ),
                      )
                          : Container(),
                      (conditionData.priority != null)
                          ? Container(
                        margin: EdgeInsets.only(top: Sizes.height_0_5),
                        child: Text(
                          "Priority : ${conditionData.priority}",
                          style: AppFontStyle.styleW500(
                            CColor.black,
                            (kIsWeb) ? FontSize.size_2 : FontSize.size_9,
                          ),
                        ),
                      )
                          : Container(),
                      (conditionData.display != null)
                          ? Container(
                        margin: EdgeInsets.only(top: Sizes.height_0_5),
                        child: Text(
                          "code : ${conditionData.display}",
                          style: AppFontStyle.styleW500(
                            CColor.black,
                            (kIsWeb) ? FontSize.size_2 : FontSize.size_9,
                          ),
                        ),
                      )
                          : Container(),*/
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: <TextSpan>[
                            TextSpan(
                              text: "${conditionData.status}: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:(kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.1, constraints) : FontSize.size_10,

                              ),
                            ),
                            TextSpan(
                              text: (conditionData.display != null)
                                  ? '${conditionData.display} '
                                  : "",
                              style:  TextStyle(
                                fontWeight: FontWeight.bold,
                                    fontSize:(kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.1, constraints) : FontSize.size_10,
                              ),
                            ),
                            TextSpan(
                              text: (conditionData.priority == Constant.priorityUrgent)?"(${conditionData.priority})":"",
                              style:  TextStyle(
                                fontWeight: FontWeight.bold,
                                    fontSize:(kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.1, constraints) : FontSize.size_10,
                              ),
                            ),
                          ],
                        ),
                        maxLines: 3,
                      ),
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: <TextSpan>[
                             TextSpan(
                              text: "Created: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                    fontSize:(kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_9,
                              ),
                            ),
                            TextSpan(
                              text: (conditionData.createdDate != null)
                                  ? '${ DateFormat(Constant.commonDateFormatDdMmYyyy).format(conditionData.createdDate!)} '
                                  : "",
                              style:  TextStyle(
                                fontWeight: FontWeight.w500,
                                    fontSize:(kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_9,
                              ),
                            ),
                          ],
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }


  ///Goal
  _listViewGoal(HomeControllers logic,BoxConstraints constraints) {
    return (logic.goalDataList.isEmpty)
        ? _emptyWidget("There is no goal for the selected status")
        : Container(
      color: CColor.white,
      margin: EdgeInsets.only(
          left:(kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.6, constraints): Sizes.width_1,
          right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.6, constraints):Sizes.width_1),

      child: ListView.builder(
        itemBuilder: (context, index) {
          return _itemGoal(
              logic.goalDataList[index], logic, index, context,constraints);
        },
        itemCount: logic.goalDataList.length,
        // itemCount: (logic.goalDataList.length > int.parse(Constant.historyCount.text.toString())) ? int.parse(Constant.historyCount.text.toString()) : logic.goalDataList.length,
        padding: EdgeInsets.only(bottom:(kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.9, constraints):Sizes.height_1),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }

  _itemGoal(GoalSyncDataModel goalData, HomeControllers logic, int index,
      BuildContext context,BoxConstraints constraints) {
    return GestureDetector(
      onTap: () async {
        /*Get.toNamed(AppRoutes.goalForm, arguments: [goalData, true])!
            .then((value) => {
              // logic.getGoalDataList(false),
          logic.isGoalProgress = true,logic.fliterUnselectApply(Constant.homeGoals)});*/


        var value = await Get.toNamed(AppRoutes.goalForm,
            arguments: [goalData,true]);
        if (value != null) {
          logic.updateLocalGoalList(value);
        } else {
          // logic.getGoalDataListApi();
          logic.isGoalProgress = true;
          logic.fliterUnselectApply(Constant.homeGoals);
        }
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
            horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.1, constraints) : Sizes.width_3,
            vertical: (kIsWeb) ?AppFontStyle.sizesHeightManageWeb(0.5, constraints) :Sizes.height_1),
        padding: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
            vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.0, constraints) : Sizes.height_2),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding:  EdgeInsets.all((kIsWeb) ? AppFontStyle.sizesFontManageWeb(0.7, constraints) : 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CColor.primaryColor30,
              ),
              child: Image.asset(
                Constant.icHomeGoals,
                height:  (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.3, constraints) : Sizes.height_2,
                width:  (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.3, constraints) : Sizes.height_2,
              ),
            ),
            Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.2, constraints) : Sizes.width_4),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${goalData.lifeCycleStatus}: ${goalData.target} ${goalData.multipleGoals}",
                        style: AppFontStyle.styleW700(
                          CColor.black,
                          (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.1, constraints) : FontSize.size_10,
                        ),
                      ),
                      if (goalData.dueDate != null)
                        Container(
                          margin: EdgeInsets.only(top: Sizes.height_0_5),
                          child: Text(
                            "Target date: ${DateFormat(
                                Constant.commonDateFormatDdMmYyyy).format(
                                goalData.dueDate!)}",
                            style: AppFontStyle.styleW500(
                              CColor.black,
                              (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_9,
                            ),
                          ),
                        ),
                      /*Container(
                    margin: EdgeInsets.only(top: Sizes.height_0_5),
                    child: Text(
                      "Start date: ${DateFormat(Constant.commonDateFormatDdMmYyyy).format(goalData.createdDate!)}",
                      style: AppFontStyle.styleW500(
                        CColor.black,
                        (kIsWeb)?FontSize.size_2:FontSize.size_9,
                      ),
                    ),
                  ),*/
                      /*Container(
                    margin: EdgeInsets.only(top: Sizes.height_0_5),
                    child: Text(
                      "Lifecycle Status: ${goalData.lifeCycleStatus}",
                      style: AppFontStyle.styleW500(
                        CColor.black,
                        FontSize.size_9,
                      ),
                    ),
                  ),*/
                      Row(
                        children: [
                          /* Container(
                        margin: EdgeInsets.only(top: Sizes.height_0_5),
                        child: Text(
                          "Status:",
                          style: AppFontStyle.styleW500(
                            CColor.black,
                            (kIsWeb)?FontSize.size_2:FontSize.size_9,
                          ),
                        ),
                      ),*/
                          /*(goalData.lifeCycleStatus != Constant.lifeCycleActive && goalData.lifeCycleStatus !=
                          Constant.lifeCycleCancelled && goalData.lifeCycleStatus !=
                          Constant.lifeCycleCompleted && goalData.lifeCycleStatus !=
                          Constant.lifeCycleOnHold)?
                      Container(
                        margin: EdgeInsets.only(top: Sizes.height_0_5),
                        child: Text(
                          "${goalData.lifeCycleStatus}",
                          style: AppFontStyle.styleW500(
                            CColor.black,
                            (kIsWeb)?FontSize.size_2:FontSize.size_9,
                          ),
                        ),
                      ) : Container(),*/

                          /// Use On the Icon For Status
                          (goalData.lifeCycleStatus ==
                              Constant.lifeCycleActive ||
                              goalData.lifeCycleStatus ==
                                  Constant.lifeCycleCancelled ||
                              goalData.lifeCycleStatus ==
                                  Constant.lifeCycleCompleted ||
                              goalData.lifeCycleStatus ==
                                  Constant.lifeCycleOnHold)
                              ?
                          /*Container(
                        margin: EdgeInsets.only(
                          left: Sizes.width_0_3,top: Sizes.height_0_5
                        ),
                        child: Image.asset(
                          (goalData.lifeCycleStatus ==
                                  Constant.lifeCycleAccepted)
                              ? Constant.lifeCycleAcceptedIcon
                              : (goalData.lifeCycleStatus ==
                                      Constant.lifeCycleCancelIcon)
                                  ? Constant.lifeCycleCancelIcon
                                  : (goalData.lifeCycleStatus ==
                                          Constant.lifeCycleCompleted)
                                      ? Constant.lifeCycleCompletedIcon
                                      : Constant.lifeCycleHoldIcon,
                          width: (kIsWeb) ? Sizes.width_1 :Sizes.width_5,
                          height: (kIsWeb) ? Sizes.width_1 :Sizes.width_5,
                        ),
                      )*/

                          ///This Is use For The Change a Icons
                          Container(
                            margin: EdgeInsets.only(top: Sizes.height_0_5),
                            child: Image.asset(
                              (goalData.lifeCycleStatus ==
                                  Constant.lifeCycleActive)
                                  ? Constant.lifeCycleStatusAccepted
                                  : (goalData.lifeCycleStatus ==
                                  Constant.lifeCycleCancelled)
                                  ? Constant.lifeCycleStatusCancelled
                                  : (goalData.lifeCycleStatus ==
                                  Constant.lifeCycleCompleted)
                                  ? Constant.lifeCycleStatusCompleted
                                  : Constant.lifeCycleStatusOnHold,
                              width: (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.1, constraints) :Sizes.width_4,
                              height: (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.1, constraints) :Sizes.width_4,
                            ),
                          )
                              : Container(),
                        ],
                      ),
                    ],
                  ),
                )),
            /*Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  padding:
                  EdgeInsets.only(left: Sizes.width_3, bottom: Sizes.height_3),
                  child: Icon(Icons.edit, size: (kIsWeb)?Sizes.width_1_2:Sizes.width_4),
                ),
                InkWell(
                  onTap: (){
                    Debug.printLog("Detele");
                  },
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    padding:
                    EdgeInsets.only(left: Sizes.width_3, bottom: Sizes.height_2),
                    child: Icon(Icons.delete_forever,color: CColor.red, size: (kIsWeb)?Sizes.width_1_2:Sizes.width_5),
                  ),
                ),
              ],
            ),*/
          ],
        ),
      ),
    );
  }


  _listViewCondition(HomeControllers logic,BoxConstraints constraints) {
    return (logic.conditionDataList.isEmpty)
        ? _emptyWidget("There is no conditions for the selected status")
        : Container(
      color: CColor.white,
      margin: EdgeInsets.only(
          left:(kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.6, constraints): Sizes.width_1,
          right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.6, constraints):Sizes.width_1),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return _itemCondition(logic.conditionDataList[index],logic,index,context,constraints);
        },
        // itemCount: (logic.conditionDataList.length > int.parse(Constant.historyCount.text.toString())) ? int.parse(Constant.historyCount.text.toString()) :logic.conditionDataList.length,
        itemCount: logic.conditionDataList.length,
        padding: EdgeInsets.only(bottom:(kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.9, constraints):Sizes.height_1),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }

  _itemCondition(ConditionSyncDataModel conditionData, HomeControllers logic,int index,BuildContext context,BoxConstraints constraints) {
    return GestureDetector(
      onTap: () async {
        /*Get.toNamed(AppRoutes.conditionForm, arguments: [conditionData])!
            .then((value) => {
              // logic.getConditionDataList(false),
          logic.isConditionProgress = true,
          logic.fliterUnselectApply(Constant.homeConditions)});*/


        var value = await Get.toNamed(AppRoutes.conditionForm,
            arguments: [conditionData]);
        if (value != null) {
          logic.updateLocalConditionList(value);
        } else {
          // logic.getConditionDataListApi();
          logic.isConditionProgress = true;
          logic.fliterUnselectApply(Constant.homeConditions);
        }

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
            horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.1, constraints) : Sizes.width_3,
            vertical: (kIsWeb) ?AppFontStyle.sizesHeightManageWeb(0.5, constraints) :Sizes.height_1),
        padding: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
            vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.0, constraints) : Sizes.height_2),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding:  EdgeInsets.all((kIsWeb) ? AppFontStyle.sizesFontManageWeb(0.7, constraints) : 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CColor.primaryColor30,
              ),
              child: Image.asset(
                Constant.icHomeConditions,
                height:  (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.3, constraints) : Sizes.height_2,
                width:  (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.3, constraints) : Sizes.height_2,
              ),
            ),

            Expanded  (
                child: Container(
                  margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.2, constraints) : Sizes.width_4),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*Text(
                        "${conditionData.verificationStatus} ",
                        style: AppFontStyle.styleW700(
                          CColor.black,
                          (kIsWeb)?FontSize.size_3:FontSize.size_10,
                        ),
                      ),
                      if(conditionData.onset != null)
                        Container(
                          margin: EdgeInsets.only(top: Sizes.height_0_5),
                          child: Text(
                            "Onset date: ${DateFormat(Constant.commonDateFormatDdMmYyyy).format(conditionData.onset!)}",
                            style: AppFontStyle.styleW500(
                              CColor.black,
                              (kIsWeb)?FontSize.size_2:FontSize.size_9,
                            ),
                          ),
                        ),
                      if(conditionData.abatement != null)Container(
                        margin: EdgeInsets.only(top: Sizes.height_0_5),
                        child: Text(
                          "Abatement date: ${DateFormat(Constant.commonDateFormatDdMmYyyy).format(conditionData.abatement!)}",
                          style: AppFontStyle.styleW500(
                            CColor.black,
                            (kIsWeb)?FontSize.size_2:FontSize.size_9,
                          ),
                        ),
                      ),*/
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: <TextSpan>[
                            TextSpan(
                              text: "${conditionData.verificationStatus}: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:(kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.1, constraints) : FontSize.size_10,
                              ),
                            ),
                            TextSpan(
                              text: (conditionData.display != null)
                                  ? '${conditionData.display} '
                                  : "",
                              style:  TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:(kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.1, constraints) : FontSize.size_10,
                              ),
                            ),
                          ],
                        ),
                        maxLines: 3,
                      ),
                      if(conditionData.onset != null)
                        Container(
                          margin: EdgeInsets.only(top: Sizes.height_0_5),
                          child: Text(
                            "Onset date: ${DateFormat(Constant.commonDateFormatDdMmYyyy).format(conditionData.onset!)}",
                            style: AppFontStyle.styleW500(
                              CColor.black,
                              (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_9,
                            ),
                          ),
                        ),
                      if(conditionData.abatement != null) Container(
                        margin: EdgeInsets.only(top: Sizes.height_0_5),
                        child: Text(
                          "Abatement date: ${DateFormat(Constant.commonDateFormatDdMmYyyy).format(conditionData.abatement!)}",
                          style: AppFontStyle.styleW500(
                            CColor.black,
                            (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_9,
                          ),
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

  ///carePlan

  _listViewCarePlan(HomeControllers logic,BoxConstraints constraints) {
    return (logic.careDataList.isEmpty)
        ? _emptyWidget("There is no care plan for the selected status")
        : Container(
      color: CColor.white,
      margin: EdgeInsets.only(
          left:(kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.6, constraints): Sizes.width_1,
          right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.6, constraints):Sizes.width_1),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return _itemCarePlan(logic.careDataList[index],logic,index,context,constraints);
        },
        // itemCount: (logic.careDataList.length > int.parse(Constant.historyCount.text.toString())) ? int.parse(Constant.historyCount.text.toString()) : logic.careDataList.length,
        itemCount: logic.careDataList.length,
        padding: EdgeInsets.only(bottom:(kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.9, constraints):Sizes.height_1),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }

  _itemCarePlan(CarePlanSyncDataModel carePlan, HomeControllers logic,int index,BuildContext context,BoxConstraints constraints) {
    return GestureDetector(
      onTap: () async {
        /*Get.toNamed(AppRoutes.carePlanForm, arguments: [carePlan,logic.goalDataListLocal])!
            .then((value) => {
              // logic.getCarePlanDataListLocal(false),
          logic.isCarePlanProgress = true,logic.fliterUnselectApply(Constant.homeCarePlans)});*/

        var value = await Get.toNamed(AppRoutes.carePlanForm,
            arguments: [carePlan,logic.goalDataListLocal]);
        if (value != null) {
          logic.updateLocalCarePlanList(value);
        } else {
          // logic.getCarePlanDataListApi();
          logic.isCarePlanProgress = true;
          logic.fliterUnselectApply(Constant.homeCarePlans);
        }
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
            horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.1, constraints) : Sizes.width_3,
            vertical: (kIsWeb) ?AppFontStyle.sizesHeightManageWeb(0.5, constraints) :Sizes.height_1),
        padding: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
            vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.0, constraints) : Sizes.height_2),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding:  EdgeInsets.all((kIsWeb) ? AppFontStyle.sizesFontManageWeb(0.7, constraints) : 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CColor.primaryColor30,
              ),
              child: Image.asset(
                Constant.icHomeCarePlan,
                height:  (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.3, constraints) : Sizes.height_2,
                width:  (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.3, constraints) : Sizes.height_2,
              ),
            ),
            Expanded  (
                child: Container(
                  margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.2, constraints) : Sizes.width_4),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: <TextSpan>[
                            TextSpan(
                              text: "${carePlan.status}: ",
                              style:  TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:(kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.1, constraints) : FontSize.size_10,
                              ),
                            ),
                            /*TextSpan(
                              text: (carePlan.text != null)
                                  ? '${Utils.htmlToPlainText(carePlan.text.toString())} '
                                  : "",
                              style:  TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:(kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.1, constraints) : FontSize.size_10,
                              ),
                            ),*/
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      HtmlWidget(
                        // logic.editedCarePlanData.text.toString(),
                        Utils.getHtmlFromDelta(carePlan.text ?? ""),
                        customStylesBuilder: (element) {
                          if (element.classes.contains('foo')) {
                            return {'color': 'red'};
                          }
                          return null;
                        },
                        onTapUrl: (url) async {
                          Debug.printLog('Link tapped: $url');
                          await Utils.launchURL(url);
                          return true;
                        },
                        renderMode: RenderMode.column,
                        textStyle:  AppFontStyle.styleW500(CColor.black,(kIsWeb)?AppFontStyle.sizesFontManageWeb(1.0, constraints): FontSize.size_10),
                      ),
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: <TextSpan>[
                            TextSpan(
                              text: (carePlan.startDate != null)
                                  ? '${DateFormat(Constant.commonDateFormatDdMmYyyy).format(carePlan.startDate!)}'
                                  : "",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: (kIsWeb)
                                    ? AppFontStyle.sizesFontManageWeb(
                                    1.0, constraints)
                                    : FontSize.size_9,
                              ),
                            ),
                            TextSpan(
                              text: (carePlan.endDate != null)
                                  ? ' to ${DateFormat(Constant.commonDateFormatDdMmYyyy).format(carePlan.endDate!)}'
                                  : "",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: (kIsWeb)
                                    ? AppFontStyle.sizesFontManageWeb(
                                    1.0, constraints)
                                    : FontSize.size_9,
                              ),
                            ),
                          ],
                        ),
                        maxLines: 3,
                      ),

                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

}
