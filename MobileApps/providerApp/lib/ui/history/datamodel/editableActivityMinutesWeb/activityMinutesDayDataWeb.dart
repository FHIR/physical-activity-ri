import 'package:banny_table/ui/history/controllers/history_controller.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/material.dart';

Widget editableActivityMinModDayDataWeb(int mainIndex, int daysIndex,
    int daysDataIndex, HistoryController homeController,BuildContext context,BoxConstraints constraints,
    {Function? onChangeData}) {
  return SizedBox(
    child: TextField(
      textAlign: TextAlign.right,
      enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.title ==
          homeController.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].displayLabel &&
          element.isModerate ).toList().isNotEmpty ) ,
      // cursorHeight: Utils.sizesHeightManage(context, 8.0),
      enableInteractiveSelection: false,
      focusNode: homeController.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].modMinValueFocus,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: AppFontStyle.commonFontSizeBodyWeb(constraints)),
      maxLines: 1,
      autofocus: true,
      autocorrect: true,
      controller: homeController
          .trackingChartDataList[mainIndex]
          .dayLevelDataList[daysIndex]
          .activityLevelDataList[daysDataIndex]
          .modMinController,
      onChanged: (value) {
        if (onChangeData != null) {
          onChangeData.call(value);
        }
      },
    ),
  );
}

Widget editableActivityMinVigDayDataWeb(int mainIndex, int daysIndex,
    int daysDataIndex, HistoryController homeController,BuildContext context,BoxConstraints constraints,
    {Function? onChangeData}) {
  return SizedBox(
    child: TextField(
      textAlign: TextAlign.right,
      enabled:(Constant.isEditMode && Constant.configurationInfo.where((element) => element.title ==
          homeController.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].displayLabel &&
          element.isVigorous ).toList().isNotEmpty ) ,
      // cursorHeight: Utils.sizesHeightManage(context, 8.0),
      enableInteractiveSelection: false,
      keyboardType: TextInputType.number,
      focusNode: homeController.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].vigMinValueFocus,
      style: TextStyle(fontSize: AppFontStyle.commonFontSizeBodyWeb(constraints)),
      maxLines: 1,
      autofocus: true,
      autocorrect: true,
      controller: homeController
          .trackingChartDataList[mainIndex]
          .dayLevelDataList[daysIndex]
          .activityLevelDataList[daysDataIndex]
          .vigMinController,
      onChanged: (value) {
        if (onChangeData != null) {
          onChangeData.call(value);
        }
      },
    ),
  );
}

Widget editableActivityMinTotalDaysDataWeb(int mainIndex, int daysIndex,
    int daysDataIndex, HistoryController homeController,BuildContext context,BoxConstraints constraints,
    {Function? onChangeData}) {
  return SizedBox(
    child: TextField(
      textAlign: TextAlign.right,
      enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.title ==
          homeController.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].displayLabel &&
          element.isTotal ).toList().isNotEmpty ) ,
      // cursorHeight: Utils.sizesHeightManage(context, 8.0),
      enableInteractiveSelection: false,
      focusNode: homeController.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].totalMinValueFocus,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: AppFontStyle.commonFontSizeBodyWeb(constraints)),
      maxLines: 1,
      autofocus: true,
      autocorrect: true,
      controller: homeController
          .trackingChartDataList[mainIndex]
          .dayLevelDataList[daysIndex]
          .activityLevelDataList[daysDataIndex]
          .totalMinController,
      onChanged: (value) {
        if (onChangeData != null) {
          onChangeData.call(value);
        }
      },
    ),
  );
}
