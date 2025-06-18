import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../utils/constant.dart';
import '../../../welcomeScreen/activityConfiguration/trackingPref/datamodel/trackingPref.dart';
import '../../controllers/history_controller.dart';
import '../caloriesStepHeartRate.dart';

Widget editableCalStepWeekWeb(int index, HistoryController homeController,String titleType,
    CaloriesStepHeartRateWeek dataList,  List<TrackingPref> trackingPrefList,BuildContext context,BoxConstraints constraints
,{Function? onChangeData}) {
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
      enableInteractiveSelection: false,
      // keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: Utils.getInputTypeKeyboard(),
      style: TextStyle(fontSize: AppFontStyle.commonFontSizeBodyWeb(constraints)
      ),
      maxLines: 1,
      autofocus: true,
      autocorrect: true,
      controller: dataList.weekValueTitleController,
      onChanged: (value) {
        if (onChangeData != null) {
          onChangeData.call(value);
        }
      },
    ),
  );
}
