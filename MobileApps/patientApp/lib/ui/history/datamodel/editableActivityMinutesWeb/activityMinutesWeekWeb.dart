import 'package:banny_table/ui/history/controllers/history_controller.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/material.dart';
import '../../../../utils/color.dart';
import '../../../welcomeScreen/activityConfiguration/trackingPref/datamodel/trackingPref.dart';

Widget editableActivityMinModWeekWeb(int index, HistoryController homeController, String cType,List<TrackingPref> trackingPrefList,BuildContext context,BoxConstraints constraints,
    {Function? onChangeData}) {
  return SizedBox(
    child: TextField(
      textAlign: TextAlign.right,
      // enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.isModerate ).toList().isNotEmpty ) ,
      enabled: (Constant.isEditMode && trackingPrefList.where((element) => (cType == Constant.configurationHeaderModerate)
          && (element.titleName == Constant.configurationHeaderModerate && element.isSelected)).toList().isNotEmpty ) ,
      // cursorHeight: Utils.sizesHeightManage(context, 8.0),
      enableInteractiveSelection: false,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: AppFontStyle.commonFontSizeBodyWeb(constraints)),
      maxLines: 1,
      focusNode: homeController.trackingChartDataList[index].modMinValueFocus,
      autofocus: true,
      autocorrect: true,
      controller: homeController.trackingChartDataList[index].modMinController,
      onChanged: (value) {
        if (onChangeData != null) {
          onChangeData.call(value);
        }
      },
    ),
  );
}

Widget editableActivityMinVigWeekWeb(int index, HistoryController homeController, String cType,List<TrackingPref> trackingPrefList,BuildContext context,BoxConstraints constraints,
    {Function? onChangeData}) {
  return SizedBox(
    child: TextField(
      textAlign: TextAlign.right,
      // enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.isVigorous ).toList().isNotEmpty ) ,
      enabled: (Constant.isEditMode && trackingPrefList.where((element) => (cType == Constant.configurationHeaderVigorous)
          && (element.titleName == Constant.configurationHeaderVigorous && element.isSelected)).toList().isNotEmpty ) ,
      // cursorHeight: Utils.sizesHeightManage(context, 8.0),
      enableInteractiveSelection: false,
      focusNode: homeController.trackingChartDataList[index].vigMinValueFocus,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: AppFontStyle.commonFontSizeBodyWeb(constraints)),
      maxLines: 1,
      autofocus: true,
      autocorrect: true,
      controller: homeController.trackingChartDataList[index].vigMinController,
      onChanged: (value) {
        if (onChangeData != null) {
          onChangeData.call(value);
        }
      },
    ),
  );
}

Widget editableActivityMiTotalWeekWeb(int index, HistoryController homeController, String cType,List<TrackingPref> trackingPrefList,BuildContext context,BoxConstraints constraints,
    {Function? onChangeData}) {
  return SizedBox(
    child: TextField(
      textAlign: TextAlign.right,
      // enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.isTotal ).toList().isNotEmpty ) ,
      enabled: (Constant.isEditMode && trackingPrefList.where((element) => (cType == Constant.configurationHeaderTotal)
          && (element.titleName == Constant.configurationHeaderTotal && element.isSelected)).toList().isNotEmpty ) ,
      // cursorHeight: Utils.sizesHeightManage(context, 8.0),
      enableInteractiveSelection: false,
      focusNode: homeController.trackingChartDataList[index].totalMinValueFocus,
      keyboardType: TextInputType.number,
      /*style: TextStyle(fontSize: AppFontStyle.commonFontSizeBodyWeb(constraints),
          color: (Constant.limitOfValue <=
              ((homeController.trackingChartDataList[index].totalMinController.text == "")
                  ? 0
                  : double.parse(homeController.trackingChartDataList[index].totalMinController.text)))
              ? CColor.toastBackground
              : CColor.red),*/
      style: TextStyle(fontSize: AppFontStyle.commonFontSizeBodyWeb(constraints)),
      maxLines: 1,
      autofocus: true,
      autocorrect: true,
      controller: homeController.trackingChartDataList[index].totalMinController,
      onChanged: (value) {
        if (onChangeData != null) {
          onChangeData.call(value);
        }
      },
    ),
  );
}

