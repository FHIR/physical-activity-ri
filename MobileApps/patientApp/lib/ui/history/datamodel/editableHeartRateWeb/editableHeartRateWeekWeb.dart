import 'package:banny_table/ui/welcomeScreen/activityConfiguration/trackingPref/datamodel/trackingPref.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../utils/constant.dart';
import '../../controllers/history_controller.dart';
import '../caloriesStepHeartRate.dart';

Widget editableRestWeekWeb(int index, HistoryController homeController,
    CaloriesStepHeartRateWeek dataList, List<TrackingPref> trackingPrefList,BuildContext context,BoxConstraints constraints,{Function? onChangeData}) {
  return Container(
    // width: 20,
    // height: 20,
    child: TextField(
      textAlign: TextAlign.right,
      enabled: (Constant.isEditMode && trackingPrefList.where((element) => (element.titleName == Constant.configurationHeaderRest && element.isSelected)).toList().isNotEmpty )  ,
      // cursorHeight: Utils.sizesHeightManage(context, 8.0),
      enableInteractiveSelection: false,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: Utils.getInputTypeKeyboard(),
      // keyboardType: TextInputType.number,
      focusNode: dataList.weekValue1Focus,
      style: TextStyle(fontSize: AppFontStyle.commonFontSizeBodyWeb(constraints)
      ),
      // inputFormatters: [
      //   FilteringTextInputFormatter.allow(RegExp(r"\d+([\.]\d+)?")),
      // ],
      maxLines: 1,
      autofocus: true,
      autocorrect: true,
      controller: dataList.weekValue1Title5Title5Controller,
      onChanged: (value) {
        if (onChangeData != null) {
          onChangeData.call(value);

        }
      },
    ),
  );
}

Widget editablePeakWeekWeb(int index, HistoryController homeController,
    CaloriesStepHeartRateWeek dataList,List<TrackingPref> trackingPrefList,BuildContext context,BoxConstraints constraints,{Function? onChangeData}) {
  return SizedBox(
    // width: 20,
    // height: 20,
    child: TextField(
      textAlign: TextAlign.right,
      enabled: (Constant.isEditMode && trackingPrefList.where((element) => (element.titleName == Constant.configurationHeaderPeck && element.isSelected)).toList().isNotEmpty ) ,
      // cursorHeight: Utils.sizesHeightManage(context, 8.0),
      enableInteractiveSelection: false,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: Utils.getInputTypeKeyboard(),
      // keyboardType: TextInputType.number,
      focusNode: dataList.weekValue2Focus,
      style: TextStyle(fontSize: AppFontStyle.commonFontSizeBodyWeb(constraints)),
      // inputFormatters: [
      //   FilteringTextInputFormatter.allow(RegExp(r"\d+([\.]\d+)?")),
      // ],
      maxLines: 1,
      autofocus: true,
      autocorrect: true,
      controller: dataList.weekValue2Title5Controller,
      onChanged: (value) {
        if (onChangeData != null) {
          onChangeData.call(value);

        }
      },
    ),
  );
}
