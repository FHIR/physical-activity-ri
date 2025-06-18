import 'package:banny_table/healthData/getWorkOutDataModel.dart';
import 'package:banny_table/ui/configuration/datamodel/activity_dataModel.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/configuration/controllers/configuration_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';

import '../../../../../utils/utils.dart';
import '../controllers/activity_selection_controller.dart';

class ActivitySelectionScreen extends StatelessWidget {
  ConfigurationMainController? configurationMainController;


  ActivitySelectionScreen({ this.configurationMainController, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    return ScreenUtilInit(
      builder: (context, child) {
        return GetBuilder<ActivitySelectionController>(builder: (logic) {
          return Scaffold(
            backgroundColor: CColor.white,
            floatingActionButton: Container(
              margin: EdgeInsets.only(
                bottom: Sizes.height_6
              ),
              child: FloatingActionButton(
                  child: Icon(Icons.add),
                  backgroundColor: CColor.primaryColor,
                  onPressed: () {
                    logic.onChangeEditable(false);
                    logic.addFirstData();
                    showDialogForAddNewCode(context, logic,false,"","","",-1);
                    // showDialogForAddNewCode(context, logic);
                  }),
            ),
            appBar: AppBar(
              toolbarHeight: 50,
              title: const Text("Activity Selection"),
              leading: IconButton(
                onPressed: () {
                  configurationMainController!.pageConfigurationController
                      .previousPage(duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn);
                  Debug.printLog("------back");
                },
                icon: Icon(Icons.arrow_back),
              ),
              backgroundColor: CColor.primaryColor,
            ),
            body: SafeArea(
              child: LayoutBuilder(
                builder: (BuildContext context ,BoxConstraints constraints) {
                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _widgetMoreDetails(orientation,constraints),
                              // _widgetAddActivity(context,logic),
                              _widgetConfigurationDetalis(context, logic,orientation,constraints,),
                            ],
                          ),
                        ),
                      ),
                      _widgetButtonDetails(logic, context,orientation,constraints,)
                    ],
                  );
                }
              ),

            ),
          );
        });
      },
    );
  }

  _widgetMoreDetails(Orientation orientation ,BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(
          left: (kIsWeb)
              ? AppFontStyle.sizesWidthManageWeb(2.0, constraints)
              : (orientation == Orientation.portrait)?
          25.w : AppFontStyle.sizesWidthManageWeb(2.0, constraints) ,
          right: (kIsWeb)
              ? AppFontStyle.sizesWidthManageWeb(2.0, constraints)
              : (orientation == Orientation.portrait)? 25.w : AppFontStyle.sizesWidthManageWeb(2.0, constraints),
          top:(kIsWeb)
              ? AppFontStyle.sizesHeightManageWeb(1.5, constraints)
              :  (orientation == Orientation.portrait)? 20.h : AppFontStyle.sizesHeightManageWeb(0.5, constraints)),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              top:  (kIsWeb) ? AppFontStyle.sizesFontManageWeb(0.2, constraints) :1.h,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              Constant.trackingPrefDesc,
              textAlign: TextAlign.start,
              style: AppFontStyle.styleW500(
                  CColor.black,
                  (kIsWeb)
                      ? AppFontStyle.sizesFontManageWeb(1.5, constraints)
                      : (orientation == Orientation.portrait)
                          ? 13.sp
                          : AppFontStyle.sizesFontManageWeb(1.5, constraints)),
            ),
          ),
        ],
      ),
    );
  }

  _widgetButtonDetails(ActivitySelectionController logic,
      BuildContext context,Orientation orientation ,BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(
          top: (orientation == Orientation.portrait)
              ? 15.h
              : AppFontStyle.sizesHeightManageWeb(0.3, constraints),
          left: (kIsWeb)
              ? AppFontStyle.sizesWidthManageWeb(1.7, constraints)
              : 8.w,
          right: (kIsWeb)
              ? AppFontStyle.sizesWidthManageWeb(1.7, constraints)
              : 8.w),
      padding: EdgeInsets.only(
          top: (kIsWeb)
              ? AppFontStyle.sizesHeightManageWeb(1.5, constraints)
              : (orientation == Orientation.portrait)
                  ? 4.h
                  : AppFontStyle.sizesHeightManageWeb(1.5, constraints),
          bottom: (kIsWeb)
              ? AppFontStyle.sizesHeightManageWeb(1.5, constraints)
              : (orientation == Orientation.portrait)
                  ? 10.h
                  : AppFontStyle.sizesHeightManageWeb(1.5, constraints)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                /*configurationMainController!.pageConfigurationController
                    .nextPage(duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn);*/
                logic.moveToScreen();
              },
              child: Container(
                padding: EdgeInsets.all((kIsWeb) ? 5 : (orientation == Orientation.portrait)? 10 :5),
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
                      fontSize: (kIsWeb)
                          ? AppFontStyle.sizesFontManageWeb(1.5, constraints)
                          : (orientation == Orientation.portrait)
                              ? 13.sp
                              : AppFontStyle.sizesFontManageWeb(
                                  1.6, constraints)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _widgetConfigurationDetalis(BuildContext context,
      ActivitySelectionController logic,Orientation orientation ,BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(top:(kIsWeb)
          ? AppFontStyle.sizesHeightManageWeb(0.5, constraints)
          : (orientation == Orientation.portrait)? Sizes.height_1 : AppFontStyle.sizesHeightManageWeb(1.0, constraints)),
      child: ListView.builder(
          padding:EdgeInsets.only(
              bottom:(kIsWeb)
              ? AppFontStyle.sizesHeightManageWeb(0.5, constraints)
              : (orientation == Orientation.portrait)? Sizes.height_5 : AppFontStyle.sizesHeightManageWeb(0.5, constraints)


          ),
          itemCount: Constant.configurationInfo.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _widgetItemBox(
                context,
                Constant.configurationInfo[index].title,
                Constant.configurationInfo[index].iconImage,
                index,
                logic, (value) {
              /*Debug.printLog("Tap");
              bottomSheetConfiguration(
                  context,
                  Constant.configurationInfo[index].iconImage,
                  Constant.configurationInfo[index].title,
                  logic,
                  index);*/

              Debug.printLog("Tap....$value");

              if(value == "") {
                bottomSheetConfiguration(
                    context,
                    Constant.configurationInfo[index].iconImage,
                    Constant.configurationInfo[index].title,
                    logic,
                    index,constraints,orientation);
              }else{
                /*logic.selectedIcon = WorkOutData(imageTitle: Constant.configurationInfo[index].title,
                    imagesPath: Constant.configurationInfo[index].iconImage);

                logic.addActivityControllers.text = Constant.configurationInfo[index].title;
                logic.addActivityCodeControllers.text = Constant.configurationInfo[index].activityCode;
*/
                HealthWorkoutActivityType dataType = HealthWorkoutActivityType.OTHER;
                var getTypeFromName = Utils.getWorkoutDataList.where((element) =>
                element.workOutDataName == Constant.configurationInfo[index].title).toList();
                if(getTypeFromName.isNotEmpty){
                  dataType = getTypeFromName[0].datatype;
                }
                logic.selectedIcon = WorkOutData(workOutDataName: Constant.configurationInfo[index].title,
                  workOutDataImages: Constant.configurationInfo[index].iconImage, datatype: dataType,workOutDataCode: Constant.configurationInfo[index].activityCode
                );

                logic.addActivityControllers.text = Constant.configurationInfo[index].title;
                logic.addActivityCodeControllers.text = Constant.configurationInfo[index].activityCode;
                if(Constant.configurationInfo[index].activityCode != ""){
                  logic.onChangeEditable(true);
                }else{
                  logic.onChangeEditable(false);
                }
                showDialogForAddNewCode(context, logic,true,
                    Constant.configurationInfo[index].title,
                    Constant.configurationInfo[index].activityCode,
                    Constant.configurationInfo[index].iconImage,index);
              }
            }, orientation , constraints);
          }),
    );
  }

  _widgetItemBox(BuildContext context, String title, String images, int index,
      ActivitySelectionController logic, Function callback,Orientation orientation ,BoxConstraints constraints) {
    return (Constant.activityByDefaultList.contains(title))?
    Column(
      children: [
        Container(
          margin: EdgeInsets.only(
            // top: Sizes.height_1,
              top: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.3, constraints) : 0,
              bottom: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.3, constraints) : 0,
              left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : (orientation == Orientation.portrait)? 8.w :AppFontStyle.sizesWidthManageWeb(0.4, constraints),
              right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints): (orientation == Orientation.portrait)? 8.w :AppFontStyle.sizesWidthManageWeb(0.4, constraints)),
          decoration: BoxDecoration(
            // color: colors,
            borderRadius: (kIsWeb) ? BorderRadius.circular(2.w) : BorderRadius
                .circular(5)
                .r,
          ),
          padding: EdgeInsets.symmetric(
              horizontal: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.0, constraints): 6.w,
              vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.4, constraints) : 8.h),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(0.5, constraints) : 3.w),
                child: Image.asset(
                  images,
                  width: (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.8, constraints) : (orientation == Orientation.portrait)? 22.w :AppFontStyle.sizesWidthManageWeb(1.8, constraints),
                  height: (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.8, constraints) : (orientation == Orientation.portrait)? 22.w :AppFontStyle.sizesWidthManageWeb(1.8, constraints),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.0, constraints)  : 6.w),
                child: Text(
                  title,
                  style: AppFontStyle.styleW500(CColor.black,
                      (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : (orientation == Orientation.portrait)? 12.sp: AppFontStyle.sizesFontManageWeb(1.3, constraints) ),
                ),
              ),
              Expanded(child: Container()),
              Container(
                margin: EdgeInsets.only(right: (kIsWeb) ? 2.w : 4.w),
                child: itemSelectedBoxEnableMain(
                    Constant.configurationInfo[index].isEnabled,
                    Constant.configurationHeaderEnabled,
                    logic, (value) {
                  Debug.printLog("Switch");
                  logic.onChangeCheckBox(
                      Constant.configurationHeaderEnabled, index);
                }, index),
              ),
              InkWell(
                onTap: () {
                  callback("");
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: Sizes.height_0_1,horizontal: Sizes.width_1_2),
                  child: Icon(
                    Icons.settings,
                    size: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.8, constraints)  : (orientation == Orientation.portrait)? 15.w :AppFontStyle.sizesWidthManageWeb(1.8, constraints),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            // top: Sizes.height_1,
              left: 8.w,
              right: 4.w),
          child: const Divider(
            height: 1,
            // color: CColor.black,
          ),
        ),
      ],
    ):
    Slidable(
      key: UniqueKey(),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {
          var lastIndex = index;
          var lastItem = Constant.configurationInfo[index];
          Debug.printLog("start data...$index");
          showDeleteAlertDialog(context, (value) {
            logic.deleteActivity(index, lastItem.title,
                lastItem.iconImage,
                lastItem.activityCode,isRemovedFromLocal: true);
            Get.back();
          }, Constant.configurationInfo[index].title, (va) {
            Constant.configurationInfo.insert(lastIndex,lastItem);
            Get.back();
            logic.update();
          });
          Constant.configurationInfo.removeAt(index);

        }),

        // All actions are defined in the children parameter.
        children:  [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            onPressed: (context) {
              showDeleteAlertDialog(context, (value) {
                logic.deleteActivity(index, Constant.configurationInfo[index].title,
                    Constant.configurationInfo[index].iconImage,
                    Constant.configurationInfo[index].activityCode,isRemovedFromLocal: false);
                Get.back();
              }, Constant.configurationInfo[index].title, (value) {
                Get.back();
              });
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
   /*   background: Container(color: Colors.red,),
      onDismissed: (direction) {
        logic.deleteActivity(index, Constant.configurationInfo[index].title,
            Constant.configurationInfo[index].iconImage,
            Constant.configurationInfo[index].activityCode);
      },*/
      child: InkWell(
        onTap: () {
          if(!Utils.isThisOutSideTitle(title)){
            callback("");
          }else{
            callback("edit");
          }
        },
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                // top: Sizes.height_1,
                  top: (kIsWeb) ? Sizes.height_1 : 0,
                  bottom: (kIsWeb) ? Sizes.height_1 : 0,
                  left: (kIsWeb) ? 5.w : 8.w,
                  right: (kIsWeb) ? 5.w : 8.w),
              decoration: BoxDecoration(
                // color: colors,
                borderRadius: (kIsWeb) ? BorderRadius.circular(2.w) : BorderRadius
                    .circular(5)
                    .r,
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: (kIsWeb) ? 4.w : 6.w,
                  vertical: (kIsWeb) ? 7.h : 8.h),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: (kIsWeb) ? 2.w : 3.w),
                    child: Image.asset(
                      images,
                      width: (kIsWeb) ? 6.w : 22.w,
                      height: (kIsWeb) ? 6.w : 22.w,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: (kIsWeb) ? 4.w : 6.w),
                    child: Text(
                      title,
                      style: AppFontStyle.styleW500(CColor.black,
                          (kIsWeb) ? 5.sp : 12.sp),
                    ),
                  ),

                  Expanded(child: Container()),
                  Container(
                    margin: EdgeInsets.only(right: (kIsWeb) ? 2.w : 4.w),
                    child: itemSelectedBoxEnableMain(
                        Constant.configurationInfo[index].isEnabled,
                        Constant.configurationHeaderEnabled,
                        logic, (value) {
                      Debug.printLog("Switch");
                      logic.onChangeCheckBox(
                          Constant.configurationHeaderEnabled, index);
                    }, index),
                  ),
                  InkWell(
                    onTap: () {
                      callback("");
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: Sizes.height_0_1,horizontal: Sizes.width_1_2),
                      child: Icon(
                        Icons.settings,
                        size: (kIsWeb) ? 7.w : 15.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                // top: Sizes.height_1,
                  left: 8.w,
                  right: 4.w),
              child: const Divider(
                height: 1,
                // color: CColor.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  showDeleteAlertDialog(BuildContext context,Function okCallBack,String
  activityName,Function cancelCallBack) {

    // set up the button
    Widget okButton = TextButton(
      child: const Text("Delete"),
      onPressed: () {
        okCallBack.call("");
      },
    );

    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        cancelCallBack.call("");
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(activityName),
      content: Text("This $activityName activity will be deleted from your app."),
      actions: [
        okButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  bottomSheetConfiguration(BuildContext context, String images, String title,
      ActivitySelectionController logic, int index,BoxConstraints constraints,Orientation orientation) {
    Future<void> future = showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        constraints:constraints ,
        backgroundColor: CColor.transparent,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return Wrap(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: (orientation == Orientation.portrait)
                            ? 8.h
                            : AppFontStyle.sizesHeightManageWeb(
                                0.5, constraints),
                        bottom: (orientation == Orientation.portrait) ?6.h : AppFontStyle.sizesHeightManageWeb(0.5, constraints)),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: CColor.white,
                        borderRadius: BorderRadius.only(
                            topRight: const Radius.circular(5).r,
                            topLeft: const Radius.circular(5).r)),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    margin:
                                    EdgeInsets.only(top: 2.h),
                                    child: Image.asset(
                                        images,
                                        width: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.9, constraints) : (orientation == Orientation.portrait) ?35.w :AppFontStyle.sizesWidthManageWeb(2.2, constraints),
                                        height: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.9, constraints) : (orientation == Orientation.portrait) ?35.w :AppFontStyle.sizesWidthManageWeb(2.2, constraints)
                                    ),
                                  ),
                                  Container(
                                    margin:
                                    EdgeInsets.only(top: Sizes.height_1),
                                    child: Text(
                                      title,
                                      style: TextStyle(
                                          fontSize: (kIsWeb) ?AppFontStyle.sizesFontManageWeb( 1.6,constraints) : (orientation == Orientation.portrait) ?15.sp :AppFontStyle.sizesWidthManageWeb(1.3, constraints),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 20.w),
                                child: Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  size:
                                  (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.9, constraints) : Sizes.width_7,
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 8.w,
                              right: 8.w,
                              top: 9.h),
                          decoration: BoxDecoration(
                              color: CColor.primaryColor10,
                              borderRadius:
                              BorderRadius
                                  .circular(6)
                                  .r),
                          padding: EdgeInsets.only(
                              top: 6.h,
                              bottom: 6.h,
                              left: 9.w,
                              right: 9.w),
                          child: Column(
                            children: [
                              if(logic.trackingPrefList.where((element) => element.titleName
                                  == Constant.configurationHeaderTotal &&  element.isSelected).toList().isNotEmpty)
                              itemSelectedBox(
                                  Constant.configurationInfo[index].isTotal,
                                  Constant.configurationHeaderTotal,
                                  setState,
                                  logic, (value) {
                                Debug.printLog("Switch");
                                logic.onChangeCheckBox(
                                    Constant.configurationHeaderTotal, index);
                              }, index),

                              if(logic.trackingPrefList.where((element) => element.titleName
                                  == Constant.configurationHeaderModerate &&  element.isSelected).toList().isNotEmpty)
                              itemSelectedBox(
                                  Constant.configurationInfo[index].isModerate,
                                  Constant.configurationHeaderModerate,
                                  setState,
                                  logic, (value) {
                                Debug.printLog("Switch");
                                logic.onChangeCheckBox(
                                    Constant.configurationHeaderModerate,
                                    index);
                              }, index),

                              if(logic.trackingPrefList.where((element) => element.titleName
                                  == Constant.configurationHeaderVigorous &&  element.isSelected).toList().isNotEmpty)
                                itemSelectedBox(
                                  Constant.configurationInfo[index].isVigorous,
                                  Constant.configurationHeaderVigorous,
                                  setState,
                                  logic, (value) {
                                Debug.printLog("Switch");
                                logic.onChangeCheckBox(
                                    Constant.configurationHeaderVigorous,
                                    index);
                              }, index),

                              if(logic.trackingPrefList.where((element) => element.titleName
                                  == Constant.configurationHeaderDays &&  element.isSelected).toList().isNotEmpty)
                              itemSelectedBox(
                                  Constant.configurationInfo[index].isDaysStr,
                                  Constant.configurationHeaderDays,
                                  setState,
                                  logic, (value) {
                                Debug.printLog("Switch");
                                logic.onChangeCheckBox(
                                    Constant.configurationHeaderDays, index);
                              }, index),

                              if(logic.trackingPrefList.where((element) => element.titleName
                                  == Constant.configurationHeaderCalories &&  element.isSelected).toList().isNotEmpty)
                              itemSelectedBox(
                                  Constant.configurationInfo[index].isCalories,
                                  Constant.configurationHeaderCalories,
                                  setState,
                                  logic, (value) {
                                Debug.printLog("Switch");
                                logic.onChangeCheckBox(
                                    Constant.configurationHeaderCalories,
                                    index);
                              }, index),

                              if(logic.trackingPrefList.where((element) => element.titleName
                                  == Constant.configurationHeaderSteps &&  element.isSelected).toList().isNotEmpty)
                              itemSelectedBox(
                                  Constant.configurationInfo[index].isSteps,
                                  Constant.configurationHeaderSteps,
                                  setState,
                                  logic, (value) {
                                Debug.printLog("Switch");
                                logic.onChangeCheckBox(
                                    Constant.configurationHeaderSteps, index);
                              }, index),

                              if(logic.trackingPrefList.where((element) => element.titleName
                                  == Constant.configurationHeaderRest &&  element.isSelected).toList().isNotEmpty)
                              itemSelectedBox(
                                  Constant.configurationInfo[index].isRest,
                                  Constant.configurationHeaderRest,
                                  setState,
                                  logic, (value) {
                                Debug.printLog("Switch");
                                logic.onChangeCheckBox(
                                    Constant.configurationHeaderRest, index);
                              }, index),

                              if(logic.trackingPrefList.where((element) => element.titleName
                                  == Constant.configurationHeaderPeck &&  element.isSelected).toList().isNotEmpty)
                              itemSelectedBox(
                                  Constant.configurationInfo[index].isPeck,
                                  Constant.configurationHeaderPeck,
                                  setState,
                                  logic, (value) {
                                Debug.printLog("Switch");
                                logic.onChangeCheckBox(
                                    Constant.configurationHeaderPeck, index);
                              }, index),

                              if(logic.trackingPrefList.where((element) => element.titleName
                                  == Constant.configurationExperience &&  element.isSelected).toList().isNotEmpty)
                              itemSelectedBox(
                                  Constant.configurationInfo[index]
                                      .isExperience,
                                  Constant.configurationExperience,
                                  setState,
                                  logic, (value) {
                                Debug.printLog("Switch");
                                logic.onChangeCheckBox(
                                    Constant.configurationExperience, index);
                              }, index),

                              if(logic.trackingPrefList.where((element) => element.titleName
                                  == Constant.configurationNotes &&  element.isSelected).toList().isNotEmpty)
                              itemSelectedBox(
                                  Constant.configurationInfo[index].isNotes,
                                  Constant.configurationNotes,
                                  setState,
                                  logic, (value) {
                                Debug.printLog("Switch");
                                logic.onChangeCheckBox(
                                    Constant.configurationNotes, index);
                              }, index),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        });
    future.then((void value) => {});
  }


  itemSelectedBoxEnableMain(bool valueCheck, String title,
      ActivitySelectionController logic, Function callback, index) {
    return InkWell(
      onTap: () {
        // logic.onChangeCheckBox(Constant.configurationHeaderRest,index);
        callback("");
        Debug.printLog("Switch");
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.decelerate,
        width: 50,
        height: 25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: valueCheck ? CColor.primaryColor : const Color(0xFFDCDCDC),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 300),
          alignment: valueCheck ? Alignment.centerRight : Alignment.centerLeft,
          curve: Curves.decelerate,
          child: Padding(
            padding: const EdgeInsets.all(4.5),
            child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(100.0),
              ),
            ),
          ),
        ),
      ),
    );
  }


  /*showDialogForAddNewCode(BuildContext context,
      ActivitySelectionController logic,bool isEdit,String title,String code, String iconImage, int index) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: CColor.white,
          contentPadding: const EdgeInsets.all(0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, setStateDialog) {
              return Wrap(
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(
                          (kIsWeb) ? Sizes.width_2 : Sizes.width_5),
                      width: (kIsWeb) ? Sizes.width_30 : Get.width * 0.8,
                      // height: (kIsWeb) ?Sizes.height_30:,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: Sizes.width_2),
                                alignment: Alignment.center,
                                child: PopupMenuButton<ActivityImagesModel>(
                                  itemBuilder: (context) =>
                                      Utils
                                          .activityImagesList
                                          .map(
                                            (e) =>
                                            PopupMenuItem<
                                                ActivityImagesModel>(
                                                value: e,
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        e.imageTitle.toString(),
                                                        style: AppFontStyle
                                                            .styleW400(
                                                            CColor.black,
                                                            (kIsWeb)
                                                                ? FontSize
                                                                .size_3_5
                                                                : FontSize
                                                                .size_9),
                                                      ),
                                                    ),
                                                    Image.asset(e.imagesPath,
                                                        width: Sizes.width_5,
                                                        height: Sizes.height_2),
                                                  ],
                                                )),
                                      )
                                          .toList(),
                                  offset: Offset(-Sizes.width_9, 0),
                                  color: Colors.grey[60],
                                  elevation: 2,
                                  onSelected: (value) {
                                    logic.onChangeIcon(value);
                                    setStateDialog(() {});
                                  },
                                  child: SizedBox(
                                    height:
                                    Constant.commonHeightForTableBoxMobile,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                            logic.selectedIcon!.imagesPath,
                                            width: Sizes.width_5,
                                            height: Sizes.height_2),
                                        const Icon(
                                          Icons.arrow_drop_down_sharp,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: Sizes.height_7,
                                  color: CColor.transparent,
                                  child: TextFormField(
                                    controller: logic.addActivityControllers,
                                    focusNode: logic.addActivityFocus,
                                    textAlign: TextAlign.start,
                                    keyboardType: TextInputType.text,
                                    style: AppFontStyle.styleW500(
                                        CColor.black,
                                        (kIsWeb)
                                            ? FontSize.size_3
                                            : FontSize.size_10),
                                    maxLines: 2,
                                    cursorColor: CColor.black,
                                    decoration: InputDecoration(
                                      hintText: "Enter Activity",
                                      filled: true,
                                      // contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: Sizes.width_5),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: CColor.primaryColor,
                                            width: 0.7),
                                        borderRadius:
                                        BorderRadius.circular(15.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: CColor.primaryColor,
                                            width: 0.7),
                                        borderRadius:
                                        BorderRadius.circular(15.0),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: CColor.primaryColor,
                                            width: 0.7),
                                        borderRadius:
                                        BorderRadius.circular(15.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: CColor.primaryColor,
                                            width: 0.7),
                                        borderRadius:
                                        BorderRadius.circular(15.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: Sizes.height_2),
                            height: Sizes.height_7,
                            color: CColor.transparent,
                            child: TextFormField(
                              controller: logic.addActivityCodeControllers,
                              focusNode: logic.addActivityCodeFocus,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              style: AppFontStyle.styleW500(
                                  CColor.black,
                                  (kIsWeb)
                                      ? FontSize.size_3
                                      : FontSize.size_10),
                              maxLines: 2,
                              cursorColor: CColor.black,
                              decoration: InputDecoration(
                                hintText: "Enter Activity Code",
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: CColor.primaryColor,
                                      width: 0.7),
                                  borderRadius:
                                  BorderRadius.circular(15.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: CColor.primaryColor,
                                      width: 0.7),
                                  borderRadius:
                                  BorderRadius.circular(15.0),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: CColor.primaryColor,
                                      width: 0.7),
                                  borderRadius:
                                  BorderRadius.circular(15.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: CColor.primaryColor,
                                      width: 0.7),
                                  borderRadius:
                                  BorderRadius.circular(15.0),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: Sizes.height_2),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      Get.back();
                                      logic.addActivityControllers.clear();
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all(
                                          CColor.transparent),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(15.0),
                                          side: const BorderSide(
                                              color: CColor.primaryColor,
                                              width: 0.7),
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(
                                          (kIsWeb) ? 10 : 5),
                                      child: Text(
                                        "Cancel",
                                        textAlign: TextAlign.center,
                                        style: AppFontStyle.styleW400(
                                            CColor.black,
                                            (kIsWeb)
                                                ? FontSize.size_3
                                                : FontSize.size_12),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: Sizes.width_2),
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      *//*logic.addNewActivity(
                                          logic.addActivityControllers.text,
                                          logic.selectedIcon!.imagesPath,
                                        logic.addActivityCodeControllers.text,
                                      );*//*
                                      if(isEdit){
                                        logic.updateActivity(index,logic.addActivityControllers.text,
                                            logic.selectedIcon!.imagesPath,
                                            logic.addActivityCodeControllers.text);
                                      }else{
                                        logic.addNewActivity(
                                            logic.addActivityControllers.text,
                                            logic.selectedIcon!.imagesPath,
                                            logic.addActivityCodeControllers.text);
                                      }
                                      setStateDialog((){});
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all(
                                          CColor.primaryColor),
                                      elevation: MaterialStateProperty.all(1),
                                      shadowColor: MaterialStateProperty.all(
                                          CColor.gray),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(15.0),
                                          side: const BorderSide(
                                              color: CColor.primaryColor,
                                              width: 0.7),
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(
                                          (kIsWeb) ? 10 : 5),
                                      child: Text(
                                        (isEdit)?"Update":"Add",
                                        textAlign: TextAlign.center,
                                        style: AppFontStyle.styleW400(
                                            CColor.white,
                                            (kIsWeb)
                                                ? FontSize.size_3
                                                : FontSize.size_12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }*/

  showDialogForAddNewCode(BuildContext context, ActivitySelectionController logic,bool isEdit,String title,String code,
      String iconImage, int index) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: CColor.white,
          contentPadding: const EdgeInsets.all(0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, setStateDialog) {
              return Wrap(
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(
                          (kIsWeb) ? Sizes.width_2 : Sizes.width_5),
                      width: (kIsWeb) ? Sizes.width_30 : Get.width * 0.8,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: Sizes.width_2),
                                alignment: Alignment.center,
                                child: PopupMenuButton<WorkOutData>(
                                  itemBuilder: (context) =>
                                      Utils
                                          .getWorkoutDataList
                                          .map(
                                            (e) =>
                                            PopupMenuItem<
                                                WorkOutData>(
                                                value: e,
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      e.workOutDataName.toString(),
                                                      style: AppFontStyle
                                                          .styleW400(
                                                          CColor.black,
                                                          (kIsWeb)
                                                              ? FontSize
                                                              .size_3_5
                                                              : FontSize
                                                              .size_9),
                                                    ),
                                                    Image.asset(e.workOutDataImages,
                                                        width: Sizes.width_5,
                                                        height: Sizes.height_2),
                                                  ],
                                                )),
                                      )
                                          .toList(),
                                  offset: Offset(-Sizes.width_9, 0),
                                  color: Colors.grey[60],
                                  elevation: 2,
                                  onSelected: (value) {
                                    logic.onChangeIcon(value);
                                    setStateDialog(() {});
                                  },
                                  child: SizedBox(
                                    height:
                                    Constant.commonHeightForTableBoxMobile,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                            logic.selectedIcon!.workOutDataImages,
                                            width: Sizes.width_5,
                                            height: Sizes.height_2),
                                        const Icon(
                                          Icons.arrow_drop_down_sharp,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  // height: Sizes.height_7,
                                  color: CColor.transparent,
                                  child: TextFormField(
                                    controller: logic.addActivityControllers,
                                    focusNode: logic.addActivityFocus,
                                    textAlign: TextAlign.start,
                                    keyboardType: TextInputType.text,
                                    style: AppFontStyle.styleW500(
                                        CColor.black,
                                        (kIsWeb)
                                            ? FontSize.size_3
                                            : FontSize.size_10),
                                    // maxLines: 2,
                                    onChanged: (value) {
                                      setStateDialog((){
                                        logic.resetActivityCode(setStateDialog);
                                      });
                                    },
                                    cursorColor: CColor.black,
                                    validator: (value) {
                                      setStateDialog((){
                                        logic.validationText(value);
                                      });
                                    },
                                    decoration: InputDecoration(
                                      label: Text("Enter Activity Name"),
                                      error: Visibility(
                                        visible: logic.showError,
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Icon(Icons.error,size: Get.width*0.04,color: CColor.red,),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: Sizes.width_1_5
                                                ),
                                                child: Text(logic.valueValidError,style: TextStyle(
                                                    fontSize: FontSize.size_8,
                                                    color: CColor.red
                                                ),),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // errorText: logic.valueValidError,
                                      // error: Icon(Icons.error),
                                      labelStyle: TextStyle(
                                          color: CColor.black
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: CColor.primaryColor,
                                            width: 0.7),
                                        borderRadius:
                                        BorderRadius.circular(15.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: CColor.primaryColor,
                                            width: 0.7),
                                        borderRadius:
                                        BorderRadius.circular(15.0),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: CColor.primaryColor,
                                            width: 0.7),
                                        borderRadius:
                                        BorderRadius.circular(15.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: CColor.primaryColor,
                                            width: 0.7),
                                        borderRadius:
                                        BorderRadius.circular(15.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: Sizes.width_3),
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
                                            padding:  const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                                color: CColor.white,
                                                border: Border.all(width: 1),
                                                borderRadius: BorderRadius.circular(10)),
                                            child: Text(
                                                Constant.activityLogDesc)),
                                      ),
                                    ];
                                  },
                                  child: Icon(Icons.info_outline,
                                      color: CColor.black, size: Sizes.height_2_5),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(top: Sizes.height_2),
                                  height: Sizes.height_7,
                                  color: CColor.transparent,
                                  child: TextFormField(
                                    controller: logic.addActivityCodeControllers,
                                    focusNode: logic.addActivityCodeFocus,
                                    textAlign: TextAlign.start,
                                    keyboardType: TextInputType.text,
                                    readOnly: logic.isEditable,
                                    enabled:!logic.isEditable,
                                    style: AppFontStyle.styleW500(
                                        CColor.black,
                                        (kIsWeb)
                                            ? FontSize.size_3
                                            : FontSize.size_10),
                                    maxLines: 2,
                                    cursorColor: CColor.black,
                                    decoration: InputDecoration(
                                      hintText: "Enter Activity Code",
                                      filled: true,
                                      fillColor: logic.isEditable ? Colors.grey.shade200 : Colors.white,
                                      border: OutlineInputBorder(
                                        borderSide:  BorderSide(
                                            color:  logic.isEditable ? Colors.grey.shade500 : CColor.primaryColor,
                                            width: 0.7),
                                        borderRadius:
                                        BorderRadius.circular(15.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:  BorderSide(
                                            color:  logic.isEditable ? Colors.grey.shade500 : CColor.primaryColor,
                                            width: 0.7),
                                        borderRadius:
                                        BorderRadius.circular(15.0),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide:  BorderSide(
                                            color:  logic.isEditable ? Colors.grey.shade500 : CColor.primaryColor,
                                            width: 0.7),
                                        borderRadius:
                                        BorderRadius.circular(15.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:  BorderSide(
                                            color:  logic.isEditable ? Colors.grey.shade500 : CColor.primaryColor,
                                            width: 0.7),
                                        borderRadius:
                                        BorderRadius.circular(15.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: Sizes.height_2),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      Get.back();
                                      logic.addActivityControllers.clear();
                                      logic.addActivityCodeControllers.clear();
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all(
                                          CColor.transparent),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(15.0),
                                          side: const BorderSide(
                                              color: CColor.primaryColor,
                                              width: 0.7),
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(
                                          (kIsWeb) ? 10 : 5),
                                      child: Text(
                                        "Cancel",
                                        textAlign: TextAlign.center,
                                        style: AppFontStyle.styleW400(
                                            CColor.black,
                                            (kIsWeb)
                                                ? FontSize.size_3
                                                : FontSize.size_12),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: Sizes.width_2),
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      if(isEdit){
                                        logic.updateActivity(index,logic.addActivityControllers.text,
                                            logic.selectedIcon!.workOutDataImages,
                                            logic.addActivityCodeControllers.text);
                                      }else{
                                        logic.addNewActivity(
                                            logic.addActivityControllers.text,
                                            logic.selectedIcon!.workOutDataImages,
                                            logic.addActivityCodeControllers.text);
                                      }
                                      setStateDialog((){});
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all(
                                          CColor.primaryColor),
                                      elevation: MaterialStateProperty.all(1),
                                      shadowColor: MaterialStateProperty.all(
                                          CColor.gray),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(15.0),
                                          side: const BorderSide(
                                              color: CColor.primaryColor,
                                              width: 0.7),
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(
                                          (kIsWeb) ? 10 : 5),
                                      child: Text(
                                        (isEdit)?"Update":"Add",
                                        textAlign: TextAlign.center,
                                        style: AppFontStyle.styleW400(
                                            CColor.white,
                                            (kIsWeb)
                                                ? FontSize.size_3
                                                : FontSize.size_12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    ).then((value) => {
      logic.valueValidError = "",
      logic.showError = false,
    });
  }


  itemSelectedBox(bool valueCheck, String title, setState,
      ActivitySelectionController logic, Function callback, index) {
    return Container(
      padding: EdgeInsets.only(top: 7.h, bottom: 7.h),
      child: Row(
        children: [
          Expanded(
            child: Text(title),
          ),
          InkWell(
            onTap: () {
              setState(() {
                // logic.onChangeCheckBox(Constant.configurationHeaderRest,index);
                callback("");
              });
              Debug.printLog("Switch");
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.decelerate,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: valueCheck ? CColor.primaryColor : const Color(
                    0xFFDCDCDC),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                alignment:
                valueCheck ? Alignment.centerRight : Alignment.centerLeft,
                curve: Curves.decelerate,
                child: Padding(
                  padding: const EdgeInsets.all(4.5),
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
