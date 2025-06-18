import 'package:banny_table/db_helper/box/condition_form_data.dart';
import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/ui/conditionList/controllers/condition_list_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/debug.dart';
import '../../../utils/sizer_utils.dart';

class ConditionListScreen extends StatelessWidget {
  const ConditionListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    return GetBuilder<ConditionListController>(builder: (logic) {
      return Theme(
        data: ThemeData(
            useMaterial3: false
        ),
        child: Scaffold(
          backgroundColor: CColor.white,
          appBar: AppBar(
            backgroundColor: CColor.primaryColor,
            title: const Text("Condition List"),

          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: CColor.primaryColor,
            onPressed: () {
              Get.toNamed(AppRoutes.conditionForm, arguments: [null])!
                  .then((value) => {logic.getConditionDataList()});
            },
            child: const Icon(Icons.add),
          ),
          body: SafeArea(
            child: Utils.pullToRefreshApi(_listViewCondition(logic), logic.refreshController, logic.onRefresh, logic.onLoading),

          ),
        ),
      );
    });
  }


  _listViewCondition(ConditionListController logic) {
    return (logic.conditionDataList.isEmpty)
        ? _emptyWidget()
        : Container(
            color: CColor.white,
            margin: EdgeInsets.only(
                top: Sizes.height_2_1,
                left: Sizes.width_1,
                right: Sizes.width_1),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return _itemGoal(logic.conditionDataList[index],logic,index,context);
              },
              itemCount: logic.conditionDataList.length,
              padding: EdgeInsets.only(bottom: Sizes.height_10),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
            ),
          );
  }

  _itemGoal(ConditionTableData conditionData, ConditionListController logic,int index,BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.conditionForm, arguments: [conditionData])!
            .then((value) => {logic.getConditionDataList()});
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
            horizontal: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
            vertical: Sizes.height_1),
        padding: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
            vertical: Sizes.height_2),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded  (
                child: Container(
              margin: EdgeInsets.only(left: Sizes.width_4),
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
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
                  ),
                ],
              ),
            )),
            Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  padding:
                      EdgeInsets.only(left: Sizes.width_3, bottom: Sizes.height_4),
                  child: Icon(Icons.edit, size: (kIsWeb)?Sizes.width_1_2:Sizes.width_4),
                ),
                InkWell(
                  onTap: (){
                    asyncConfirmDialog(context,index,logic);
                    Debug.printLog("Detele");
                  },
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    padding:
                        EdgeInsets.only(left: Sizes.width_3, bottom: Sizes.height_3),
                    child: Icon(Icons.delete_forever,color: CColor.red, size: (kIsWeb)?Sizes.width_1_2:Sizes.width_5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  alertDialogMenu(int index,ConditionListController logic){
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

  asyncConfirmDialog(BuildContext context,int index,ConditionListController logic) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
              'You want to delete your Condition ?'),
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
          "Click + button to define a Condition",
          style: AppFontStyle.styleW500(CColor.black, (kIsWeb)?FontSize.size_3:FontSize.size_12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
