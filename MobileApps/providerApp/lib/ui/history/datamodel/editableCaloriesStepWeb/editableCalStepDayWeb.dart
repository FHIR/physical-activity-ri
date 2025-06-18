import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../utils/constant.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/trackingPref/dataModel/trackingPref.dart';
import '../../controllers/history_controller.dart';
import '../caloriesStepHeartRate.dart';

Widget editableCalStepDayWeb(int daysIndex, HistoryController homeController,
    CaloriesStepHeartRateDay data, int mainIndex, String titleType,List<TrackingPref> trackingPrefList,BuildContext context,BoxConstraints constraints,
    {Function? onChangeData}) {
  return SizedBox(
    // width: 20,
    // height: 20,
    child: TextField(
      textAlign: TextAlign.right,
      // enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => (titleType == Constant.titleSteps)?element.isSteps:element.isCalories ).toList().isNotEmpty ) ,
      enabled: (Constant.isEditMode && trackingPrefList.where((element) => (titleType == Constant.titleSteps)
          ?(element.titleName == Constant.configurationHeaderSteps && element.isSelected):
      (element.titleName == Constant.configurationHeaderCalories && element.isSelected)).toList().isNotEmpty ) ,
      // cursorHeight: Utils.sizesHeightManage(context, 8.0),
      focusNode: data.daysValueFocus,
      enableInteractiveSelection: false,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: Utils.getInputTypeKeyboard(),
      // keyboardType: TextInputType.number,
      style: TextStyle(fontSize: AppFontStyle.commonFontSizeBodyWeb(constraints)),
      maxLines: 1,
      autofocus: true,
      autocorrect: true,
      controller: data.daysValueTitleController,
      // controller:TextEditingController(),
      onChanged: (value) {
        if (onChangeData != null) {
          onChangeData.call(value);
        }
      },
    ),
  );
}
