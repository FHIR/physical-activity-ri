import 'package:banny_table/utils/font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../utils/constant.dart';
import '../../../../utils/utils.dart';
import '../../controllers/history_controller.dart';
import '../caloriesStepHeartRate.dart';

Widget editableRestDayDataWeb(int index, int daysIndex, int daysDataIndex,HistoryController homeController,
    CaloriesStepHeartRateData dataList,BuildContext context,BoxConstraints constraints,
    {Function? onChangeData}) {
  return SizedBox(
    child: TextField(
      textAlign: TextAlign.right,
      /*enabled: (homeController.trackingChartDataList[index].dayLevelDataList[daysIndex].activityLevelDataList.isNotEmpty)?
      (Constant.isEditMode && Constant.configurationInfo.where((element) => element.title ==
          homeController.trackingChartDataList[index].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].displayLabel &&
          element.isRest ).toList().isNotEmpty ):true ,*/
      enabled: false,
      // cursorHeight: Utils.sizesHeightManage(context, 8.0),
      enableInteractiveSelection: false,
      keyboardType: TextInputType.number,
      focusNode: dataList.daysDataValue1Focus,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      // keyboardType: Utils.getInputTypeKeyboard(),
      style: TextStyle(fontSize: AppFontStyle.commonFontSizeBodyWeb(constraints)
      ),
      // inputFormatters: [
      //   FilteringTextInputFormatter.allow(RegExp(r"\d+([\.]\d+)?")),
      // ],
      maxLines: 1,
      autofocus: true,
      autocorrect: true,
      controller: dataList.daysDataValue1Title5Controller,
      onChanged: (value) {
        if (onChangeData != null) {
          onChangeData.call(value);
        }
      },
    ),
  );
}

Widget editablePeakDayDataWeb(int index,int daysIndex, int daysDataIndex, HistoryController homeController,
    CaloriesStepHeartRateData dataList,BuildContext context,BoxConstraints constraints,
    {Function? onChangeData}) {
  return SizedBox(
    child: TextField(
      textAlign: TextAlign.right,
      enabled: (homeController.trackingChartDataList[index].dayLevelDataList[daysIndex].activityLevelDataList.isNotEmpty)?
      (Constant.isEditMode && Constant.configurationInfo.where((element) => element.title ==
          homeController.trackingChartDataList[index].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].displayLabel &&
          element.isPeck ).toList().isNotEmpty ):true ,
      // inputFormatters: [
      //   FilteringTextInputFormatter.allow(RegExp(r"\d+([\.]\d+)?")),
      // ],
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: Utils.getInputTypeKeyboard(),
      // cursorHeight: Utils.sizesHeightManage(context, 8.0),
      enableInteractiveSelection: false,
      focusNode: dataList.daysDataValue2Focus,
      // keyboardType: TextInputType.number,
      style: TextStyle(fontSize: AppFontStyle.commonFontSizeBodyWeb(constraints)

      ),
      maxLines: 1,
      autofocus: true,
      autocorrect: true,
      controller: dataList.daysDataValue2Title5Controller,
      onChanged: (value) {
        if (onChangeData != null) {
          onChangeData.call(value);
        }
      },
    ),
  );
}
