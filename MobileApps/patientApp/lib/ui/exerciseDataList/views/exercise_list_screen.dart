import 'package:banny_table/db_helper/box/referral_data.dart';
import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/ui/mixed/datamodel/exerciseData.dart';
import 'package:banny_table/ui/referralList/controllers/referral_list_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/constant.dart';
import '../controllers/exercise_list_controller.dart';

class ExerciseListScreen extends StatelessWidget {
  const ExerciseListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExerciseListController>(builder: (logic) {
      return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Scaffold(
          backgroundColor: CColor.white,
          appBar: AppBar(
            backgroundColor: CColor.primaryColor,
            title: const Text("Exercise prescription List",
              style: TextStyle(
                color: CColor.white,
                // fontSize: 20,
                fontFamily: Constant.fontFamilyPoppins,
              ),),
          ),
          body: SafeArea(
            child: Utils.pullToRefreshApi(
                _listExerciseForm(logic, context, constraints),
                logic.refreshController,
                logic.onRefresh,
                logic.onLoading),
          ),
        );
      });
    });
  }

  _listExerciseForm(ExerciseListController logic, BuildContext context,BoxConstraints constraints) {
    return (logic.rxDataList.isEmpty)
        ? _emptyWidget(
        "No Exercise prescription existing.")
        : Container(
      color: CColor.white,
      margin: EdgeInsets.only(
          left: (kIsWeb)
              ? AppFontStyle.sizesWidthManageWeb(0.6, constraints)
              : Sizes.width_1,
          right: (kIsWeb)
              ? AppFontStyle.sizesWidthManageWeb(0.6, constraints)
              : Sizes.width_1),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return _itemExerciseForm(
              logic.rxDataList[index], logic, context, index,
              constraints);
        },
        itemCount: logic.rxDataList.length,
        padding: EdgeInsets.only(
            bottom: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(
                0.9, constraints) : Sizes.height_1),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }

  _itemExerciseForm(ExerciseData referralListData, ExerciseListController logic,
      BuildContext context, int index, BoxConstraints constraints) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.exerciseForm, arguments: [referralListData]);
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all((kIsWeb)
                            ? AppFontStyle.sizesFontManageWeb(0.7, constraints)
                            : 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: CColor.primaryColor30,
                        ),
                        child: Image.asset(
                          Constant.icHomeExercisePrescriptions,
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
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.only(
                            left: (kIsWeb)
                                ? AppFontStyle.sizesWidthManageWeb(
                                    1.2, constraints)
                                : Sizes.width_4,
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
                                    text: "${referralListData.status} ",
                                    style: TextStyle(
                                      color: CColor.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: (kIsWeb)
                                          ? AppFontStyle.sizesFontManageWeb(
                                              1.1, constraints)
                                          : FontSize.size_11,
                                    ),
                                  ),
                                  TextSpan(
                                    text: (referralListData.referralScope !=
                                            null)
                                        ? '${referralListData.referralScope} '
                                        : "",
                                    style:  TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: (kIsWeb)
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  _emptyWidget(String title) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: Sizes.width_5),
        child: Text(
          title,
          style: AppFontStyle.styleW500(
              CColor.black, (kIsWeb) ? FontSize.size_3 : FontSize.size_12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
