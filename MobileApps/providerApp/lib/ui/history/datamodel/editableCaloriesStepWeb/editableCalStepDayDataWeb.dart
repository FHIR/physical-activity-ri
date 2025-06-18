import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../utils/constant.dart';
import '../../controllers/history_controller.dart';
import '../caloriesStepHeartRate.dart';

Widget editableCalStepDayDataWeb(
    int daysDataIndex,
    HistoryController homeController,
    int mainIndex,
    int daysIndex,
    String titleType,
    CaloriesStepHeartRateData daysDataList,BuildContext context,BoxConstraints constraints,
    {Function? onChangeData}) {
  return SizedBox(
    child: TextField(
      textAlign: TextAlign.right,
      enabled:  ( homeController
          .trackingChartDataList[mainIndex]
          .dayLevelDataList[daysIndex]
          .activityLevelDataList.isNotEmpty)?
      (Constant.isEditMode &&
          Constant.configurationInfo
              .where((element) => element.title ==
              homeController
                  .trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .displayLabel && element.isCalories
          )
              .toList()
              .isNotEmpty):true,
      // cursorHeight: Utils.sizesHeightManage(context, 8.0),
      enableInteractiveSelection: false,
      keyboardType: TextInputType.number,
      focusNode: daysDataList.daysDataValueFocus,
      style: TextStyle(fontSize: AppFontStyle.commonFontSizeBodyWeb(constraints)),
      maxLines: 1,
      autofocus: true,
      autocorrect: true,
      controller: daysDataList.daysDataValueTitleController,
      onChanged: (value) {
        if (onChangeData != null) {
          onChangeData.call(value);
        }
      },
    ),
  );
}


Widget editableCalStepDayDataWebStep(
    int daysDataIndex,
    HistoryController homeController,
    int mainIndex,
    int daysIndex,
    String titleType,
    CaloriesStepHeartRateData daysDataList,BuildContext context,BoxConstraints constraints,
    {Function? onChangeData}) {
  return SizedBox(
    child: TextField(
      textAlign: TextAlign.right,
      enabled: (homeController
          .trackingChartDataList[mainIndex]
          .dayLevelDataList[daysIndex]
          .activityLevelDataList.isNotEmpty)?
      (Constant.isEditMode &&
          Constant.configurationInfo
              .where((element) => element.title ==
              homeController
                  .trackingChartDataList[mainIndex]
                  .dayLevelDataList[daysIndex]
                  .activityLevelDataList[daysDataIndex]
                  .displayLabel && element.isSteps
          )
              .toList()
              .isNotEmpty):true,
      // cursorHeight: Utils.sizesHeightManage(context, 8.0),
      enableInteractiveSelection: false,
      focusNode: daysDataList.daysDataValueFocus,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: AppFontStyle.commonFontSizeBodyWeb(constraints)),
      maxLines: 1,
      autofocus: true,
      autocorrect: true,
      controller: daysDataList.daysDataValueTitleController,
      onChanged: (value) {
        if (onChangeData != null) {
          onChangeData.call(value);
        }
      },
    ),
  );
}