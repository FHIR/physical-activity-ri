import 'package:banny_table/db_helper/box/care_plan_form_data.dart';
import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/ui/carePlanList/controllers/care_plan_list_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/debug.dart';
import '../../../utils/sizer_utils.dart';

class CarePlanListScreen extends StatelessWidget {
  const CarePlanListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CarePlanListController>(builder: (logic) {
      return LayoutBuilder(
        builder: (BuildContext context,BoxConstraints constraints) {
          return Scaffold(
            backgroundColor: CColor.white,
            appBar: AppBar(
              backgroundColor: CColor.primaryColor,
              title: const Text("CarePlan List",
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

  _listViewCondition(CarePlanListController logic,BoxConstraints constraints) {
    return (logic.careDataList.isEmpty)
        ? _emptyWidget()
        : Container(
            color: CColor.white,
            margin: EdgeInsets.only(
                top: Sizes.height_2_1,
                left: Sizes.width_1,
                right: Sizes.width_1),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return _itemCarePlan(
                    logic.careDataList[index], logic, index, context,constraints);
              },
              itemCount: logic.careDataList.length,
              padding: EdgeInsets.only(bottom: Sizes.height_10),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
            ),
          );
  }

  _itemCarePlan(CarePlanTableData carePlan, CarePlanListController logic, int index,
      BuildContext context,BoxConstraints constraints) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.carePlanForm, arguments: [carePlan,logic.goalDataList])!
            .then((value) => {
              // logic.getCarePlanDataListLocal()
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
            Expanded(
                child: Container(
              // margin: EdgeInsets.only(right: Sizes.width_4),
              alignment: Alignment.centerLeft,
              child: Row(
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
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.2, constraints) : Sizes.width_4),
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
                                      ? Utils.htmlToPlainText(carePlan.text ?? "")
                                      : "",
                                  style:  TextStyle(
                                    fontWeight: FontWeight.bold,fontSize:(kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.1, constraints) : FontSize.size_10,

                                  ),
                                ),*/

                              ],
                            ),
                            maxLines: 3,
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
                        ],
                      ),
                    ),
                  ),
                 /* Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: Sizes.width_3),
                        alignment: Alignment.center,
                        child: Image.asset(
                            height: (kIsWeb) ? Sizes.width_2 : Sizes.width_4_5,
                            width: (kIsWeb) ? Sizes.width_2 : Sizes.width_4_5,
                            Constant.icHomeCarePlan),
                      )
                    ],
                  ),*/
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  alertDialogMenu(int index, CarePlanListController logic) {
    return AlertDialog(
      title: const Text("Confirm DeleteNote"),
      content: const Text("This is note not restore for Deleted."),
      actions: [
        InkWell(
          onTap: () {
            Get.back();
          },
          child: const Text("Cancle"),
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
      BuildContext context, int index, CarePlanListController logic) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('You want to delete your goal ?'),
          actions: <Widget>[
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                margin: EdgeInsets.only(bottom: Sizes.height_0_5),
                child: const Text("Cancel"),
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
          "No Care Plans are currently recorded ",
          style: AppFontStyle.styleW500(
              CColor.black, (kIsWeb) ? FontSize.size_3 : FontSize.size_12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
