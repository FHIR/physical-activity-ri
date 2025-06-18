
import 'package:banny_table/ui/history/controllers/history_controller.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/trackingPref/dataModel/trackingPref.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../utils/constant.dart';
import '../caloriesStepHeartRate.dart';

Widget editableRestDayDayWeb(int index, HistoryController homeController,
    CaloriesStepHeartRateDay dataList,List<TrackingPref> trackingPrefList,BuildContext context,BoxConstraints constraints, {Function? onChangeData}) {
  return SizedBox(

    child: TextField(
      textAlign: TextAlign.right,
      enabled: (Constant.isEditMode && trackingPrefList.where((element) => (element.titleName == Constant.configurationHeaderRest && element.isSelected)).toList().isNotEmpty ) ,
      // cursorHeight: Utils.sizesHeightManage(context, 8.0),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: Utils.getInputTypeKeyboard(),
      enableInteractiveSelection: false,
      // keyboardType: TextInputType.number,
      focusNode: dataList.daysValue1Focus,
      style: TextStyle(fontSize: AppFontStyle.commonFontSizeBodyWeb(constraints)),      // inputFormatters: [
      //   FilteringTextInputFormatter.allow(RegExp(r"\d+([\.]\d+)?")),
      // ],
      maxLines: 1,
      autofocus: true,
      autocorrect: true,
      controller: dataList.daysValue1Title5Controller,
      onChanged: (value) {
        if (onChangeData != null) {
          onChangeData.call(value);

        }
      },
    ),
  );
}

Widget editablePeakDayDayWeb(int index, HistoryController homeController,
    CaloriesStepHeartRateDay dataList, List<TrackingPref> trackingPrefList,BuildContext context,BoxConstraints constraints,{Function? onChangeData}) {
  return SizedBox(
    child: TextField(
      textAlign: TextAlign.right,
      enabled: (Constant.isEditMode && trackingPrefList.where((element) => (element.titleName == Constant.configurationHeaderPeck && element.isSelected)).toList().isNotEmpty ) ,
      // cursorHeight: Utils.sizesHeightManage(context, 8.0),
      enableInteractiveSelection: false,
      // keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: Utils.getInputTypeKeyboard(),
      focusNode: dataList.daysValue2Focus,
      style: TextStyle(fontSize: AppFontStyle.commonFontSizeBodyWeb(constraints)),      // inputFormatters: [
      //   FilteringTextInputFormatter.allow(RegExp(r"\d+([\.]\d+)?")),
      // ],
      maxLines: 1,
      autofocus: true,
      autocorrect: true,
      controller: dataList.daysValue2Title5Controller,
      onChanged: (value) {
        if (onChangeData != null) {
          onChangeData.call(value);

        }
      },
    ),
  );
}
