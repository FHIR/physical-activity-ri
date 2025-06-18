import 'package:banny_table/db_helper/box/goal_data.dart';
import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/ui/goalForm/datamodel/goalDataModel.dart';
import 'package:banny_table/ui/goalList/controllers/goal_list_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/debug.dart';
import '../../../utils/sizer_utils.dart';

class GoalListScreen extends StatelessWidget {
  const GoalListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    return GetBuilder<GoalListController>(builder: (logic) {
      return LayoutBuilder(
        builder: (BuildContext context,BoxConstraints constraints) {
          return Scaffold(
            backgroundColor: CColor.white,
            appBar: AppBar(
              backgroundColor: CColor.primaryColor,
              title: const Text("Goal List",
                style: TextStyle(
                  color: CColor.white,
                  // fontSize: 20,
                  fontFamily: Constant.fontFamilyPoppins,
                ),),
              actions: [
                _widgetFilter(context,logic,orientation),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: CColor.primaryColor,
              onPressed: () {
                Get.toNamed(AppRoutes.goalForm, arguments: [null,true,Constant.dataGoalList])!
                    .then((value) => {
                      logic.getGoalDataList()
                    });
              },
              child: const Icon(Icons.add),
            ),
            body: Utils.pullToRefreshApi(_listViewGoal(logic,constraints), logic.refreshController,
                logic.onRefresh, logic.onLoading)
          );
        }
      );
    });
  }




  /*_widgetFilterDropDown(BuildContext context,GoalListController logic) {
    return Container(
      width: Sizes.width_30,
      // height: Sizes.height_0_5,
      margin: EdgeInsets.symmetric(horizontal: Sizes.width_2),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? Sizes.width_1_5 : Sizes.width_3,
            ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: CColor.greyF8,
          border: Border.all(color: CColor.black, width: 0.7),
        ),
        child: DropdownButtonFormField<String>(
          focusColor: Colors.white,
          isExpanded: true,
          decoration: const InputDecoration.collapsed(hintText: ''),
          // value: logic.filterGoalFilter,
          style: const TextStyle(color: Colors.white),
          iconEnabledColor: Colors.black,
          items: Utils.filterGoalList
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: AppFontStyle.styleW500(CColor.black,
                    (kIsWeb) ? FontSize.size_3 : FontSize.size_10),
              ),
            );
          }).toList(),
          onChanged: (value) {
            // logic.onSelectSyncingTime(value);
            Debug.printLog("lifecycle value...$value");
          },
        ),
      ),
    );
  }*/

  _widgetFilter(BuildContext context,GoalListController logic, Orientation orientation,{bool isLandscape = false}) {
    return InkWell(
      onTap: () {
        showFilterDialog(logic, context,orientation);
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          right: Sizes.width_4,
          top: (isLandscape)?0:Sizes.height_0_8,
          bottom: Sizes.height_0_8
        ),
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          // color: CColor.greyF8,
          //   border: Border.all(color: CColor.black, width: 1),
          //   borderRadius: BorderRadius.circular(7)
        ),
        child: const Icon(
          Icons.filter_list_rounded,
          color: CColor.white,
        ),
      ),
    );
  }


  void showFilterDialog(GoalListController logic, BuildContext context, Orientation orientation) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
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
                          return InkWell(
                            onTap: (){
                              logic.selectFilter(Utils.filterGoalList[index]);
                              Get.back();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  Utils.filterGoalList[index].toString(),
                                ),
                                Radio(
                                  activeColor: CColor.primaryColor,
                                  value: Utils.filterGoalList[index],
                                  groupValue: logic.filterGoalFilter,
                                  onChanged: (value) {
                                    setState(() {
                                      logic.selectFilter(value);
                                      Get.back();
                                      // Utils.filterGoalList[index].isSelect = value;
                                    });
                                  },
                                ),
                                /*Checkbox(
                                  value: Utils.filterGoalList[index].isSelect,
                                  onChanged: (value) {
                                    *//*logic.onChangeTitle(
                                        !logic.titlesListData[index].selected,
                                        index);*//*
                                    setState(() {});
                                  },
                                )*/
                              ],
                            ),
                          );
                        },
                        shrinkWrap: true,
                        itemCount: Utils.filterGoalList.length,
                        physics: const AlwaysScrollableScrollPhysics(),
                      ),
                    ),
                    /*Row(
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
                              FontSize.size_12,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // logic.onChangeTitleTapOnOk();
                          },
                          child: Text(
                            "Ok",
                            style: AppFontStyle.styleW600(
                              CColor.black,
                              FontSize.size_12,
                            ),
                          ),
                        ),
                      ],
                    )*/
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }




  _listViewGoal(GoalListController logic,BoxConstraints constraints) {
    return (logic.filterGoalDataList.isEmpty)
        ? _emptyWidget()
        : Container(
            color: CColor.white,
            margin: EdgeInsets.only(
                top: Sizes.height_2_1,
                left: Sizes.width_1,
                right: Sizes.width_1),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return _itemGoal(logic.filterGoalDataList[index],logic,index,context,constraints);
              },
              itemCount: logic.filterGoalDataList.length,
              padding: EdgeInsets.only(bottom: Sizes.height_10),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
            ),
          );
  }

  // _itemGoal(GoalTableData goalData, GoalListController logic,int index,BuildContext context,BoxConstraints constraints) {
  _itemGoal( goalData, GoalListController logic,int index,BuildContext context,BoxConstraints constraints) {
    return GestureDetector(
      onTap: () async {
        /*Get.toNamed(AppRoutes.goalForm, arguments: [goalData,true])!
            .then((value) => {logic.getGoalDataListApi(isFirstTimeLoad: false)});*/

        var value = await Get.toNamed(AppRoutes.goalForm,
            arguments: [goalData,true,""]);
        if (value != null) {
          logic.updateLocalGoalList(value);
        } else {
          // logic.getGoalDataListApi(isFirstTimeLoad: false);
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
            Expanded  (
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
                  if(goalData.dueDate != null)Container(
                    margin: EdgeInsets.only(top: Sizes.height_0_5),
                    child: Text(
                      "Target date: ${DateFormat(Constant.commonDateFormatDdMmYyyy).format(goalData.dueDate!)}",
                      style: AppFontStyle.styleW500(
                        CColor.black,
                        (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_9,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      /// Use On the Icon For Status
                      (goalData.lifeCycleStatus == Constant.lifeCycleActive || goalData.lifeCycleStatus ==
                          Constant.lifeCycleCancelled || goalData.lifeCycleStatus ==
                          Constant.lifeCycleCompleted || goalData.lifeCycleStatus ==
                          Constant.lifeCycleOnHold)?
                      ///This Is use For The Change a Icons
                      Container(
                        margin: EdgeInsets.only(
                            top:(kIsWeb) ? AppFontStyle.sizesFontManageWeb(0.5, constraints) : Sizes.height_0_5
                        ),
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
            if(goalData.isEditable)
            Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  padding:
                      EdgeInsets.only(left: Sizes.width_3, bottom: Sizes.height_3),
                  child: Icon(Icons.edit, size: (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.3, constraints):Sizes.width_4),
                ),
                InkWell(
                  onTap: (){
                    asyncConfirmDialog(context,index,logic);
                    Debug.printLog("Detele");
                  },
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    padding:
                        EdgeInsets.only(left: Sizes.width_3, bottom: Sizes.height_2),
                    child: Icon(Icons.delete_forever,color: CColor.red, size: (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.3, constraints):Sizes.width_5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  alertDialogMenu(int index,GoalListController logic){
    return  AlertDialog(
      title: const Text("Confirm DeleteNote"),
      content: const Text("This is note not restore for Deleted."),
      actions: [
        InkWell(
          onTap: (){
            Get.back();
          },
          child: Container(
            child: Text("Cancle"),
          ),
        ),
        InkWell(
          onTap: (){
            logic.deteleItemNote(index);

          },
          child: Container(
            child: Text("Delete"),
          ),
        )
      ],
    );
  }

  asyncConfirmDialog(BuildContext context,int index,GoalListController logic) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
              'You want to delete your goal ?'),
          actions: <Widget>[
            InkWell(
              onTap: (){
                Get.back();
              },
              child: Container(
                margin: EdgeInsets.only(
                    bottom: Sizes.height_0_5
                ),
                child: Text("Cancle"),
              ),
            ),
            InkWell(
              onTap: (){
                logic.deteleItemNote(index);

              },
              child: Container(
                margin: EdgeInsets.only(
                  left: (kIsWeb) ? Sizes.width_1:Sizes.width_2_5,
                  bottom: Sizes.height_0_5
                ),
                child: Text("Delete"),
              ),
            )
          ],
        );
      },
    );
  }

  _emptyWidget() {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: Sizes.width_5),
        child: Text(
          "No goals are currently recorded",
          style: AppFontStyle.styleW500(CColor.black, (kIsWeb)?FontSize.size_3:FontSize.size_12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
