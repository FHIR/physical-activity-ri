import 'package:banny_table/healthData/getWorkOutDataModel.dart';
import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/ui/configuration/controllers/configuration_controllers.dart';
import 'package:banny_table/ui/configuration/datamodel/activity_dataModel.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:sizer/sizer.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/sizer_utils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class MobileConfigurationScreen extends StatelessWidget {
  const MobileConfigurationScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConfigurationController>(builder: (logic) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: CColor.primaryColor,
            onPressed: () {
              showDialogForAddNewCode(context, logic,false,"","","",-1);
            },
            child: const Icon(Icons.add)),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    (logic.isSkipTab) ? _widgetBackButton() : Container(),
                    _widgetActivityGeneralAbove(),
                    _widgetActivityManage(context, logic),
                    _widgetAddActivity(context, logic),
                    Container(
                      child: _widgetConfigurationDetalis(
                          context, logic),
                    ),
                    _widgetButtonDetails(logic),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  _widgetActivityManage(BuildContext context, ConfigurationController logic) {
    return (logic.trackingPrefList.isNotEmpty)?
    Container(
        margin: EdgeInsets.only(
          left: (kIsWeb) ? 15.w : Sizes.width_3,
          right: (kIsWeb) ? 15.w : Sizes.width_3,
          top: (kIsWeb) ? 30.h : 0,
        ),
        child: ReorderableListView(
          onReorder: logic.onReorder,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: buildListItems(logic),
        )):Container();
  }


  List<Widget> buildListItems(ConfigurationController logic) {
    return logic.trackingPrefList
        .map((item) => Container(
      key: ValueKey(item),
      // margin: EdgeInsets.only(left: 9.w, right: 10.w, top: 3.h, bottom: 3.h),
      margin: EdgeInsets.only(left: Sizes.width_3, right: Sizes.width_3, top: Sizes.height_0_5, bottom: Sizes.height_0_5),
      child: Row(
        children: [
          const Icon(Icons.menu),
          Container(
            margin: EdgeInsets.only(left: Sizes.width_3),
            child: Text(
              item.titleName,
              style: AppFontStyle.styleW400(
                CColor.black,
                (kIsWeb) ? 6.sp : FontSize.size_10,
              ),
            ),
          ),
          /*Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 5.w),
            child: PopupMenuButton(
              elevation: 0,
              constraints: BoxConstraints(
                  minWidth: Get.width * 0.1, maxWidth: Get.width * 0.6),
              color: Colors.transparent,
              padding: const EdgeInsets.all(0),
              position: PopupMenuPosition.under,
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: CColor.white,
                            border: Border.all(width: 1.w),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                            "This activity in ${item.titleName} details and Above manually On and Off Activity")),
                  ),
                ];
              },
              child: Icon(Icons.info_outline,
                  color: CColor.gray, size: (kIsWeb) ? 6.sp : FontSize.size_10),
            ),
          ),*/
          const Spacer(),
          Checkbox(
            value: item.isSelected,
            activeColor: CColor.primaryColor,
            onChanged: (value) {
              logic.onChangeActivityManageData(
                  item.titleName,item: item);
            },
          ),
        ],
      ),
    ))
        .toList();
  }


  _widgetBackButton() {
    return Container(
      margin: EdgeInsets.only(top: 2.h),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
              margin: EdgeInsets.only(left: Sizes.width_3),
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                left: Sizes.width_3,
                right: Sizes.width_5,
              ),
              child: Image.asset(
                Constant.leftArrowIcons,
                height: Sizes.width_5,
                width: Sizes.width_5,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                  right: (kIsWeb) ? Sizes.width_1 : Sizes.width_5),
              child: Text(
                Constant.headerConfigurationScreen,
                maxLines: 2,
                style: AppFontStyle.styleW600(CColor.black, FontSize.size_12),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.toNamed(AppRoutes.goalViewScreen);
            },
            child: Container(
              margin: EdgeInsets.only(right: 12.w),
              child: Text(
                "Skip",
                style: AppFontStyle.styleW600(CColor.primaryColor, FontSize.size_12),
              ),
            ),
          )
        ],
      ),
    );
  }

  _widgetActivityGeneralAbove() {
    return Container(
      decoration: const BoxDecoration(
        color: CColor.primaryColor30,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: Sizes.height_1, bottom: Sizes.height_1, left: Sizes.width_5),
        child: Text("General",
            style: AppFontStyle.styleW700(Colors.black, FontSize.size_12)),
      ),
    );
  }

  _widgetAddActivity(BuildContext context, ConfigurationController logic) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: CColor.primaryColor30,
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  // padding: EdgeInsets.only(top: 6.h, bottom: 6.h, left: 17.w),
                  padding: EdgeInsets.only(top: Sizes.height_1, bottom: Sizes.height_1, left: Sizes.width_5),
                  child: Text("Activity",
                      style: AppFontStyle.styleW700(Colors.black, FontSize.size_12)),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  _widgetConfigurationDetalis(BuildContext context,
      ConfigurationController logic) {
    return Container(
      margin: EdgeInsets.only(top: Sizes.height_1,bottom: Sizes.height_8_3),
      child: ListView.builder(
          padding: EdgeInsets.zero,
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
                 Debug.printLog("Tap....$value");

                  if(value == "") {
                    bottomSheetConfiguration(
                        context,
                        Constant.configurationInfo[index].iconImage,
                        Constant.configurationInfo[index].title,
                        logic,
                        index);
                  }else{
                    /*logic.selectedIcon = ActivityImagesModel(imageTitle: Constant.configurationInfo[index].title,
                        imagesPath: Constant.configurationInfo[index].iconImage);*/
                    HealthWorkoutActivityType dataType = HealthWorkoutActivityType.OTHER;
                    var getTypeFromName = Utils.getWorkoutDataList.where((element) =>
                    element.workOutDataName == Constant.configurationInfo[index].title).toList();
                    if(getTypeFromName.isNotEmpty){
                      dataType = getTypeFromName[0].datatype;
                    }
                    logic.selectedIcon = WorkOutData(workOutDataName: Constant.configurationInfo[index].title,
                        workOutDataImages: Constant.configurationInfo[index].iconImage, datatype: dataType,
                    );

                    logic.addActivityControllers.text = Constant.configurationInfo[index].title;
                    logic.addActivityCodeControllers.text = Constant.configurationInfo[index].activityCode;

                    showDialogForAddNewCode(context, logic,true,
                        Constant.configurationInfo[index].title,
                        Constant.configurationInfo[index].activityCode,
                        Constant.configurationInfo[index].iconImage,index);
                  }
            });
          }),
    );
  }

  _widgetItemBox(BuildContext context, String title, String images, int index,
      ConfigurationController logic, Function callback) {
    if ((Constant.activityByDefaultList.contains(title))) {
      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: Sizes.width_1, right: Sizes.width_3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius
                  .circular(5),
            ),
            padding: EdgeInsets.symmetric(horizontal: Sizes.width_3, vertical: Sizes.height_1),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left:  Sizes.width_3),
                  child: Image.asset(
                    images,
                    width:  Sizes.width_5,
                    height:  Sizes.width_5,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left:  Sizes.width_3),
                  child: Text(
                    title,
                    style: AppFontStyle.styleW400(CColor.black, FontSize.size_10),
                  ),
                ),

                Expanded(child: Container()),
                Container(
                  margin: EdgeInsets.only(right:  Sizes.width_3),
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
                  child: Icon(
                    Icons.settings,
                    size:  Sizes.width_4,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 8.w, right: 4.w),
            child: const Divider(
              height: 1,
              // color: CColor.black,
            ),
          ),
        ],
      );
    } else {
      return Slidable(
        key: UniqueKey(),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(onDismissed: () {
            var lastIndex = index;
            var lastItem = Constant.configurationInfo[index];
            Debug.printLog("start data...$index");
            showDeleteAlertDialog(context, (value) {
         /*     logic.deleteActivity(index, Constant.configurationInfo[index].title,
                  Constant.configurationInfo[index].iconImage,
                  Constant.configurationInfo[index].activityCode,isRemovedFromLocal: true);*/
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
     /* background: Container(color: Colors.red),
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
          //
        },
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: Sizes.width_1, right: Sizes.width_3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius
                    .circular(5),
              ),
              padding: EdgeInsets.symmetric(horizontal: Sizes.width_3, vertical: Sizes.height_1),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left:  Sizes.width_3),
                    child: Image.asset(
                      images,
                      width:  Sizes.width_5,
                      height:  Sizes.width_5,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left:  Sizes.width_3),
                    child: Text(
                      title,
                      style: AppFontStyle.styleW400(CColor.black, FontSize.size_10),
                    ),
                  ),

                  Expanded(child: Container()),
                  Container(
                    margin: EdgeInsets.only(right:  Sizes.width_3),
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
                    child: Icon(
                      Icons.settings,
                      size:  Sizes.width_4,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 8.w, right: 4.w),
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
      ConfigurationController logic, int index) {
    Future<void> future = showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: CColor.transparent,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return Wrap(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: Sizes.height_2, bottom: Sizes.height_2),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: CColor.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5),
                            topLeft: Radius.circular(5))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: Sizes.height_1),
                                    child: Image.asset(images,
                                        width: Sizes.width_9, height: Sizes.width_9),
                                  ),
                                  Container(
                                    margin:
                                    EdgeInsets.only(top: Sizes.height_1),
                                    child: Text(
                                      title,
                                      style: TextStyle(
                                          fontSize: FontSize.size_11,
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
                                margin: EdgeInsets.only(right: Sizes.width_6),
                                child: Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  size:
                                  (kIsWeb) ? Sizes.width_2 : Sizes.width_7,
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin:
                          EdgeInsets.only(left: Sizes.width_3, right: Sizes.width_3, top: Sizes.height_0_5),
                          decoration: BoxDecoration(
                              color: CColor.primaryColor10,
                              borderRadius: BorderRadius
                                  .circular(6)),
                          padding: EdgeInsets.only(
                              top: Sizes.height_2, bottom: Sizes.height_2, left: Sizes.width_3, right: Sizes.width_3),
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
                                  Constant.configurationInfo[index].isExperience,
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

  itemSelectedBox(bool valueCheck, String title, setState,
      ConfigurationController logic, Function callback, index) {
    return Container(
      padding: EdgeInsets.only(top: Sizes.height_1, bottom: Sizes.height_1),
      child: Row(
        children: [
          Expanded(
            child: Text(title),
          ),
          InkWell(
            onTap: () {
              setState(() {
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
                color:
                valueCheck ? CColor.primaryColor : const Color(0xFFDCDCDC),
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

  itemSelectedBoxEnableMain(bool valueCheck, String title,
      ConfigurationController logic, Function callback, index) {
    return InkWell(
      onTap: () {
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

  showDialogForAddNewCode(BuildContext context, ConfigurationController logic,bool isEdit,String title,String code,
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
    );
  }

  _widgetButtonDetails(ConfigurationController logic) {
    return (logic.isSkipTab)
        ? Container(
      margin: EdgeInsets.only(top: 15.h, left: 8.w, right: 8.w),
      padding: EdgeInsets.only(top: 4.h, bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                logic.saveOpeningDetails();
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: CColor.primaryColor,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: CColor.white)),
                // margin: EdgeInsets.only(right: Sizes.width_2),
                child: Text(
                  "Next",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: CColor.white, fontSize: 15.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    )
        : Container();
  }
}
