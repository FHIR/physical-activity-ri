import 'package:banny_table/ui/history/controllers/history_controller.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../../utils/debug.dart';
import '../../../welcomeScreen/activityConfiguration/trackingPref/datamodel/trackingPref.dart';

Widget editableActivityMinModDayWeb(int mainIndex, int daysIndex,
    HistoryController homeController,String cType,List<TrackingPref> trackingPrefList,BuildContext context,BoxConstraints constraints,
    {Function? onChangeData}) {
  // Debug.printLog(",,,,,,,,isEditMode.......${(Constant.isEditMode )}");
  // Debug.printLog(",,,,,,,,cType.......${( cType == Constant.configurationHeaderModerate)}");
  // Debug.printLog(",,,,,,,,titleName.......${( trackingPrefList.where((element) =>  (element.titleName == Constant.configurationHeaderModerate )).toList().isNotEmpty )}");
  // Debug.printLog(",,,,,,,,isEnable.......${(Constant.isEditMode && trackingPrefList.where((element) =>  element.isSelected).toList().isNotEmpty )}");
  return SizedBox(
    child: TextField(
      textAlign: TextAlign.right,
      // enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.isModerate ).toList().isNotEmpty ) ,
      enabled: (Constant.isEditMode && trackingPrefList.where((element) => (cType == Constant.configurationHeaderModerate)
          && (element.titleName == Constant.configurationHeaderModerate && element.isSelected)).toList().isNotEmpty ),
      // cursorHeight: Utils.sizesHeightManage(context, 8.0),
      enableInteractiveSelection: false,
      focusNode: homeController.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].modMinValueFocus,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize:AppFontStyle.commonFontSizeBodyWeb(constraints)),
      maxLines: 1,
      autofocus: true,
      autocorrect: true,
      controller: homeController.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
          .modMinController,
      onChanged: (value) {
        if (onChangeData != null) {
          onChangeData.call(value);
        }
      },
    ),
  );
}

Widget editableActivityMinVigDayWeb(int mainIndex, int daysIndex,
    HistoryController homeController,String cType,List<TrackingPref> trackingPrefList,BuildContext context,BoxConstraints constraints,
    {Function? onChangeData}) {
  return SizedBox(
    child: TextField(
      textAlign: TextAlign.right,
      // enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.isVigorous ).toList().isNotEmpty ) ,
      enabled: (Constant.isEditMode && trackingPrefList.where((element) => (cType == Constant.configurationHeaderVigorous)
          && (element.titleName == Constant.configurationHeaderVigorous && element.isSelected)).toList().isNotEmpty ) ,
      // cursorHeight: Utils.sizesHeightManage(context, 8.0),
      focusNode: homeController.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].vigMinValueFocus,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: AppFontStyle.commonFontSizeBodyWeb(constraints)),
      maxLines: 1,
      autofocus: true,
      autocorrect: true,
      controller: homeController.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
          .vigMinController,
      onChanged: (value) {
        if (onChangeData != null) {
          onChangeData.call(value);
        }
      },
    ),
  );
}

Widget editableActivityMiTotalDayWeb(int mainIndex, int daysIndex,
    HistoryController homeController,String cType,List<TrackingPref> trackingPrefList,BuildContext context,BoxConstraints constraints,
    {Function? onChangeData}) {
  return SizedBox(
    child: TextField(
      textAlign: TextAlign.right,
      // enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.isTotal ).toList().isNotEmpty ) ,
      enabled: (Constant.isEditMode && trackingPrefList.where((element) => (cType == Constant.configurationHeaderTotal)
          && (element.titleName == Constant.configurationHeaderTotal && element.isSelected)).toList().isNotEmpty ) ,
      // cursorHeight: Utils.sizesHeightManage(context, 8.0),
      enableInteractiveSelection: false,
      focusNode: homeController.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].totalMinValueFocus,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: AppFontStyle.commonFontSizeBodyWeb(constraints)),
      maxLines: 1,
      autofocus: true,
      autocorrect: true,
      controller: homeController.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
          .totalMinController,
      onChanged: (value) {
        if (onChangeData != null) {
          onChangeData.call(value);
        }
      },
    ),
  );
}


