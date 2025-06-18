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

import '../../../utils/sizer_utils.dart';

class ConditionListScreen extends StatelessWidget {
  const ConditionListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConditionListController>(builder: (logic) {
      return LayoutBuilder(
        builder: (BuildContext context,BoxConstraints constraints) {
          return Scaffold(
            backgroundColor: CColor.white,
            appBar: AppBar(
              backgroundColor: CColor.primaryColor,
              title: const Text("Condition List",
                style: TextStyle(
                  color: CColor.white,
                  // fontSize: 20,
                  fontFamily: Constant.fontFamilyPoppins,
                ),),
            ),
            body: SafeArea(
              child: Utils.pullToRefreshApi(_listViewCondition(logic,constraints),
                  logic.refreshController, logic.onRefresh, logic.onLoading),
            ),
          );
        }
      );
    });
  }

    _listViewCondition(ConditionListController logic,BoxConstraints constraints) {
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
                return _itemCondition(
                    logic.conditionDataList[index], logic, index, context,constraints);
              },
              itemCount: logic.conditionDataList.length,
              padding: EdgeInsets.only(bottom: Sizes.height_10),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
            ),
          );
  }

  _itemCondition(ConditionTableData conditionData, ConditionListController logic,
      int index, BuildContext context,BoxConstraints constraints) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.conditionForm, arguments: [conditionData])!
            .then((value) => {
              // logic.getConditionDataList()
            });
      },
      child: Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CColor.white,
          boxShadow: const [
            BoxShadow(
              color: CColor.txtGray50,
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
            Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.2, constraints) : Sizes.width_4),
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(conditionData.verificationStatus != "")Text(
                    "${conditionData.verificationStatus ?? ""}: ${conditionData.display ?? ""}",
                    style: AppFontStyle.styleW700(
                      CColor.black,
                      (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.1, constraints) : FontSize.size_10,
                    ),
                  ),
                  if(conditionData.onset != null)
                  Container(
                    margin: EdgeInsets.only(top: Sizes.height_0_5),
                    child: Text(
                      "Onset date: ${DateFormat(Constant.commonDateFormatDdMmYyyy).format(conditionData.onset ?? DateTime.now())}",
                      style: AppFontStyle.styleW500(
                        CColor.black,
                            (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_9,
                      ),
                    ),
                  ),
                    /*Container(
                      margin: EdgeInsets.only(top: Sizes.height_0_5),
                      child: Text(
                        "Abatement date: ${DateFormat(Constant.commonDateFormatDdMmYyyy).format(conditionData.abatement ?? DateTime.now())}",
                        style: AppFontStyle.styleW500(
                          CColor.black,
                          (kIsWeb) ? FontSize.size_2 : FontSize.size_9,
                        ),
                      ),
                    ),*/
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  alertDialogMenu(int index, ConditionListController logic) {
    return AlertDialog(
      title: const Text("Confirm DeleteNote"),
      content: const Text("This is note not restore for Deleted."),
      actions: [
        InkWell(
          onTap: () {
            Get.back();
          },
          child: const Text("Cancel"),
        ),
        InkWell(
          onTap: () {
            logic.deteleItemNote(index);
          },
          child: const Text("Delete"),
        )
      ],
    );
  }

  asyncConfirmDialog(
      BuildContext context, int index, ConditionListController logic) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('You want to delete your Condition ?'),
          actions: <Widget>[
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                margin: EdgeInsets.only(bottom: Sizes.height_0_5),
                child: const Text("Cancle"),
              ),
            ),
            InkWell(
              onTap: () {
                logic.deteleItemNote(index);
              },
              child: Container(
                margin: EdgeInsets.only(
                    left: (kIsWeb) ? Sizes.width_1 : Sizes.width_2_5,
                    bottom: Sizes.height_0_5),
                child: const Text("Delete"),
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
          "No conditions are currently recorded",
          style: AppFontStyle.styleW500(
              CColor.black, (kIsWeb) ? FontSize.size_3 : FontSize.size_12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }




}
